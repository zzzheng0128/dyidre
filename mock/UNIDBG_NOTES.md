# UNIDBG_NOTES.md — 给 unidbg 的改进意见

> 基于对 `libmetasec_ml.so`（抖音 metasec 安全库）的全量逆向实测
> （`metasec_350101/init_array/`：116 个 init_array ctor 模拟报告）以及本项目
> `libmock.so` 的攻防对抗实验（`analyze_mock.py`）写成。
> 每条意见都标注了**实测依据**——即真实防护代码已经在这条缝隙上
> 部署了检测，或攻击方已经在这条缝隙上完成了穿透。

unidbg 的本质是「Unicorn CPU 模拟 + Java 侧手写 syscall/JNI/Linker 语义」。
它对付普通 SDK 足够好，但 metasec 这类一线加固库的所有反模拟探针，
恰好全部打在 unidbg 与真机行为的差异面上。下面按优先级列出改进方向。

---

## P0-1. 严格 ISA 模式：未实现的系统指令必须抛异常，不得静默 NOP

**实测依据**：真 .so init_array ctor[0]（`0x59294`）的第一道探针就是
`msr nzcv, xN` 写入已知值后立即 `mrs xN, nzcv` 回读比对，随后 `clrex`、
`brk #3`。这组指令的语义组合是模拟器试金石：

- `msr nzcv` 在部分模拟器/旧版 KVM 里是 NOP 或写不进，回读值不符即判模拟器；
- `clrex` 清本地 exclusive monitor，影响后续 `ldxr/stxr` 配对；
- `brk #3` 应产生 SIGTRAP 走信号分发——防护代码注册了自己的 SIGTRAP
  handler，handler 被调到 = 正常；模拟器若无声跳过 brk，handler 永远
  不触发，行为差异立刻暴露。

**现状**：unidbg/Unicorn 对多数系统寄存器指令、cache/屏障指令静默 NOP，
`brk` 无声继续。防护代码的探测结果变成"不可观测地通过"，分析者不知道
自己在哪层已经被标记。

**建议**：

1. 增加 `setStrictISA(true)` 模式：所有未忠实实现的系统指令
   （`msr/mrs` 非常用寄存器、`dc/ic`、`dsb/isb`、`clrex`、`brk`、
   `xpaclri` 等 PAC 指令）默认抛 `UnimplementedInsnException`，
   带上 PC 与指令编码，让"防护探测点命中"成为**可观测事件**；
2. 对每个被吞掉的指令记一条 `emu_event` 日志（pc、编码、处置方式：
   NOP/近似/忠实），分析结束可导出报告——这直接回答"我在哪层被拦"；
3. `brk #imm` 应走完整的信号分发路径（把 SIGTRAP 投递给目标注册的
   sigaction），而不是 continue。这是成本最低、收益最大的一条。

## P0-2. mprotect 必须真实改页权限，并在违权访问时抛异常

**实测依据**：本项目 mock 的运行时代码解密（复刻真 .so ctor[93]
`0x129430` 的完整形态）依赖这样的时序：明文只存在于
`mprotect(RW) → XOR 写回 → 调用 → mprotect(RW) → XOR 重加密` 的窗口内。
真机上 RX 页被写会 SIGSEGV——**页的权限状态本身就是完整性信号**。

**现状**：Unicorn 底层内存通常整体 RWX，`mprotect` 在 unidbg 里只是
记账。后果有两个，都很严重：

- 防护方视角失效：CRC/自校验代码可以靠"往自己 .text 写一字节看是否
  SIGSEGV"来判定环境，权限不实时这个探针就哑了；
- 分析方视角失真：解密循环往"按理是 RX"的页写明文时毫无动静，
  分析者得不到任何提示——而真机上这个写必须先有 mprotect，**mprotect
  调用序列本身就是解密封装边界的信号**，权限模型失真会把这类信号
  全部磨平。

**建议**：

1. `mprotect` 真实映射到 Unicorn 的 `mem_protect`，权限不符的读写抛
   `UcError` 并投递 SIGSEGV 给目标 sigaction；
2. 提供 `onProtectChange` 回调/事件：每次 mprotect 记录
   `(addr, len, old→new, caller_pc)`。本项目攻击侧实验证明：只需监视
   226 号调用 + 窗口内内存写，就能在 seal 瞬间把明文精确抠出来——
   防御方用这个事件流做完整性哨兵，分析方用它做 dump 触发器，双方
   都需要它成为一等公民。

## P0-3. 内存写 watchpoint API（带调用点归属）

**实测依据**：本项目 `analyze_mock.py` 穿透"用后重加密"的唯一有效手段
是 `UC_HOOK_MEM_WRITE` 记录 mprotect 窗口内的写集合。真 .so 的
ctor[93] 同款机制（2 对齐错位密文槽 + 明文写回跳入）也只能这样抓。

**现状**：Unicorn 原生支持 mem hook，但 unidbg Java 层没有暴露成
方便的 API，用户要自己掉回 Unicorn 层写，且写事件缺少"当前在谁的
栈帧里"的上下文。

**建议**：提供 `emulator.watchMemoryWrite(addr, len, listener)`，事件里
携带 `(pc, lr, 当前模块, 写入长度, 新值)`，并内置"窗口聚合"模式
（两次 mprotect 之间自动聚合写范围）。这一个 API 同时服务：
代码解密明文抓取、CRC 校验目标区定位、字符串原地解密观测。

## P1-1. svc 语义与真内核一致：返回值、errno、副作用三件套

**实测依据**：真 .so 反模拟探针用 `svc #0` 直发 syscall（绕过 libc，
防 plt hook）。mock 复刻了同款（getpid=172、mprotect=226）。
分析器端要接管 INTR、按 x8 分发、**按内存指令编码判断 PC 是否要 +4**
才能跑下去。

**现状**：unidbg 的 svc 已走 Java handler（比裸 Unicorn 强），但：
- 很多 syscall 返回乐观值（0/固定值），errno 语义缺失；
- 副作用缺失：`getpid` 每次返回同一个值、`gettimeofday/clock_gettime`
  不推进或步进失真——而真 .so 有时钟锚点检测（init_array 期取锚、
  运行期比对漂移）；
- PC 推进语义藏在 handler 约定里，文档化不足。

**建议**：

1. syscall 返回走 `(ret, errno)` 完整语义，失败路径可被配置
   （模拟器上"该失败的没失败"和"该成功的没成功"都是检测面）；
2. 时钟类 syscall 支持真实推进模式（宿主机单调时钟映射），并允许
   设置初始墙钟——对抗/复现时间锚检测都需要；
3. 把"svc 命中 → 分发的 handler → 返回值"打进 emu_event 日志，
   未实现 syscall 号默认告警而非静默返 0。

## P1-2. /proc 虚拟文件系统要"自洽"，而不只是"有内容"

**实测依据**：真 .so init_array 加载期预解密了三类特征库——root 检测
（`su`/`magisk` 等路径与包名）、注入框架检测（frida/xposed 特征串）、
云手机检测（`ro.kernel.qemu`、厂商指纹）。这些检测大量读
`/proc/self/status`（TracerPid）、`/proc/self/maps`、`/proc/net/tcp`，
并**交叉验证**：maps 里的模块集要和 `dl_iterate_phdr` 看到的一致，
status 的 TracerPid 要和 `ptrace(PTRACE_TRACEME)` 自检结果一致。

**现状**：unidbg 的 /proc 是静态模板，各接口之间互不相干——maps 里
没有 unidbg 自己映射的模块布局，TracerPid 恒 0 但 ptrace 调用又能
"成功"，互相矛盾的回答本身就是模拟器指纹。

**建议**：虚拟 /proc 由运行时真实状态**生成**而非模板填充：
maps 从 unidbg 的模块表渲染、status 的 TracerPid 与 ptrace 子系统
联动、fd 目录与文件打开记录一致。检测代码读到的每个答案都能从
另一个接口复算出来，才谈得上自洽。

## P1-3. I-cache/D-cache 一致性建模（自修改代码的关键面）

**实测依据**：真 .so 和 mock 的解密封装都是 `写回明文 → dc cvau →
ic ivau → dsb ish → isb → 跳入`。真机上漏掉 cache 同步会执行到旧
指令（真 .so 甚至利用"不同步时的行为差异"作为检测面）。

**现状**：Unicorn 无 cache 模型，写完即生效，`dc/ic/dsb/isb` 全是 NOP。
这意味着：(a) 防护代码无法依赖 cache 副作用检测环境；(b) 分析者
观察不到"这段代码依赖 cache 同步"这一事实本身。

**建议**：strict 模式下提供可选的"延迟生效"I-cache 模拟：被写的页在
收到 `ic ivau` 之前执行旧内容。实现重（需要指令缓存层），但至少应
把 `dc cvau/ic ivau` 的命中地址范围记入事件日志——`ic ivau` 作用的
地址范围 = 刚被自修改的代码范围，这是零成本的解密边界信号。

## P2-1. 2 对齐（非 4 对齐）跳转与相位错乱代码的诊断支持

**实测依据**：真 .so ctor[93] 的密文槽 VA≡2 (mod 4)，从槽起点反汇编
相位错乱（objdump 只能解出垃圾）。mock 完整复刻。分析者最容易卡在：
"这段代码为什么在反汇编器里是糊的"。

**建议**：unidbg 的 trace/反汇编视图在遇到 PC 2 对齐、或连续
UDF/未知指令时，自动提示"可能存在错位代码加密，试试 +2 相位反汇编"，
并可一键按 2 偏移重新反汇编当前区域。纯诊断改进，但能把新手从
数小时的困惑里救出来。

## P2-2. init_array 全量执行与逐 ctor 报告

**实测依据**：真 .so 有 **116 个 init_array ctor**，前 5 项是防护本体
（反模拟、环境检测、密钥初始化、代码解密调度），其余是业务初始化。
防护代码故意混在大量正常 ctor 里，且执行顺序敏感（ctor[93] 的解密
依赖 ctor[0] 的探针结果决定走哪条解密路径——平坦化分发）。

**现状**：unidbg 跑 init_array 是可行的，但某个 ctor 中止时缺少
"第几个、地址、已完成的副作用"的报告。

**建议**：`callInitArray` 输出逐 ctor 报告：索引、地址、执行状态、
触发的 svc/异常/事件摘要。116 个 ctor 里定位 5 个防护项，目前全靠
人肉；有了报告就是一次排序的事。

---

## 总结：优先级矩阵

| 优先级 | 改进 | 防护方利用现状 | 分析方痛点 | 实现成本 |
|---|---|---|---|---|
| P0-1 | 严格 ISA 模式 + brk 走信号 | ctor[0] 探针已部署 | 被拦了不知道 | 低 |
| P0-2 | mprotect 真实权限 | RX 写 SIGSEGV 探针可用 | 解密边界信号被磨平 | 中 |
| P0-3 | 内存写 watchpoint API | — | 抓明文窗口全靠手搓 | 低 |
| P1-1 | svc 语义三件套 | svc 直发探针已部署 | 返回值乐观、时钟失真 | 中 |
| P1-2 | /proc 自洽 | 交叉验证检测已部署 | 模板互相矛盾 = 指纹 | 中 |
| P1-3 | cache 一致性事件 | cache 副作用检测可用 | 同步范围信号丢失 | 高（可只做日志） |
| P2-1 | 2 对齐跳转诊断 | 相位错乱密文已部署 | 反汇编全糊 | 低 |
| P2-2 | init_array 逐 ctor 报告 | 防护混入 116 ctor | 定位全靠人肉 | 低 |

一句话：**metasec 级别的防护已经不依赖"模拟器跑不动"，而是依赖
"模拟器的行为差异可探测"。unidbg 的进化方向不是更强的模拟，而是
更忠实的语义 + 把防护探测点变成可观测事件**——让攻防双方都从
"猜"变成"看日志"。

---

## 附：本项目对真 .so 反模拟机制的实测清单（意见的事实基础）

| 机制 | 真 .so 位置 | 形态 | mock 复刻 |
|---|---|---|---|
| svc 直发系统调用 | init_array ctor[0] `0x59294` | svc #0 + 平坦化分发 | `emu_check()` 探针 B（getpid/172） |
| NZCV 写读回校验 | 同上函数体内 | `msr nzcv` 写已知值回读比对 | `emu_check()` 探针 A（逐指令复刻） |
| clrex / brk #3 陷阱 | 同上 | brk 依赖 SIGTRAP 分发 | 同（`brk #3`） |
| 运行时代码解密 | init_array ctor[93] `0x129430` | 2 对齐错位密文槽 + 明文写回跳入 | payload 密文槽 `0x1622` + unlock/seal |
| 用后重加密 | 同上（调用期窗口） | 明文仅存于一次调用内 | `seal_payload()` 对称 XOR |
| root/注入/云手机特征库 | ctor[68]/[69]/[86] | init_array 期预解密特征串 | （未复刻，属环境检测层） |
| CRC 自校验 | JNI_OnLoad 路径 | 种子 0x20190512 → 0x77DF8B85 | 构建期回填 CRC32 |
| 字符串加密 | 全 .so 散布 | 周期-8 XOR ×5 密钥 + IMM/RODATA 双形态 | 真实密钥流提取复刻 |

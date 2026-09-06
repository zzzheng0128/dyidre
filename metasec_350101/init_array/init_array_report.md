# libmetasec_ml.so `.init_array` 深度分析报告

分析对象：`/Users/freeman/project/douyin/study/libmetasec_ml.so`（2,864,144 字节，ARM64）
方法：ELF 静态解析 + objdump 反汇编 + Unicorn 全量模拟全部 116 个构造函数
（`init_array_emu.py`，逐项记录解密字符串 / svc / brk / 代码段写 / 动态代码执行）。
置信度标注：高 = 模拟实测或直接指令证据；中 = 静态结构证据；低 = 推断。

## 0. 结构总览

```
DT_INIT        : 无
DT_INIT_ARRAY  : 0x260190, 116 项（RW 段页首）
DT_FINI_ARRAY  : 0x260530, 2 项
```

116 项分两类（高置信度）：

| 区间 | 条目 | 性质 |
|---|---|---|
| [0..4] | `0x59294`、`0x14cebc`、`0x152b58`、`0x1702b8`、`0x171ddc` | **防护层初始化**（加固器/安全模块自身） |
| [5..115] | `0x33c20 .. 0x423fc`（间隔约 0x13c） | 111 个业务模块自注册：各自解密 4~100 条字符串（模块名/配置/检测库），写入内部注册表 |

加载期最早执行的 5 项是防护本体——下面逐项深挖。

## 1. ctor[0] `0x59294` — 反模拟 + 反调试 + 反静态分析三合一起手式

全程 O-MVLL 混淆（MBA 表达式 + 控制流平坦化）。实测仅调用 `clock_gettime`
（计时锚点，高置信度）；静态可见以下防护构件（全部有直接指令证据）：

### 1.1 svc #0 裸系统调用探测（高）

```
59374: ldp x3, x2, [sp, #0x10]     ; 从栈恢复全部 syscall 参数
59378: ldp x0, x1, [sp]
5937c: ldp x29, x30, [sp, #0x30]
59380: svc #0                      ; 绕过 libc 直接进内核
59384: 477001de  <unknown>         ; svc 之后紧跟密文字节
```

参数由 MBA 链计算（`and/orn/orr/add/eor` + movk 常量：
`x9 = ((x26 & 0x10400000400) | 0x1010104) + ((x17 | x26) & x1) ^ 0xff5f9ebb...`），
静态无法直接读出调用号；svc 返回后立即落入无法反汇编的字节——
与后文 ctor[93] 的"代码静态密文化"呼应。

### 1.2 NZCV 忠实性检查 + brk 陷阱（高）

```
59394: mrs  x1, NZCV      ; 保存标志
59398: mov  x0, xzr
5939c: cmp  x0, xzr       ; Z=1
593a0: msr  NZCV, x0      ; 写 0 清标志（Z→0）
593a4: b.ne 0x593b0       ; 忠实实现：Z=0，跳过陷阱
593a8: clrex              ; ← 弱模拟器（忽略 msr NZCV）会走到这里
593ac: brk  #0x3          ; SIGTRAP 陷阱：崩溃/暴露
593b0: msr  NZCV, x1      ; 恢复标志，正常继续
```

逻辑：cmp 先置 Z=1，再用 `msr NZCV` 清零；若运行环境不实现 NZCV 写入
（弱模拟器/部分插桩框架），`b.ne` 不跳转，直接踩 `brk #3`。
Unicorn 实现了 NZCV，能通过此检查——这也是它对 O-MVLL 系防护有效的原因之一。

### 1.3 计算式跳转 + 自取地址反汇编错位（高）

```
59350: bl  0x5935c        ; stub：从栈上取回自己的返回地址（泄露 PC）
59354: add x1, x0, #0x34
59358: br  x1             ; 跳入 stub 体内 +0x34 的中间位置
```

`bl` 的目的地不是函数而是"取址 stub"；线性反汇编无法分辨边界，
IDA/objdump 的函数识别被故意破坏。`x26 = adrp+add` 取**自身函数地址**
参与 MBA 运算——密钥/偏移与代码的绝对位置绑定，代码被搬移即算错。

### 1.4 控制流平坦化状态机（高）

`0x59440` 起一条长达十余分支的 `cmp w8, <movk 构造的 32 位状态值>; b.eq`
链，是 O-MVLL 控制流平坦化的 dispatcher：真实逻辑被打散成状态块，
静态阅读无法恢复原始控制流。

## 2. ctor[1] `0x14cebc` — 内部能力注册表（CF1..CF16 / G0..G2）初始化

模拟实测（高置信度）：

- 在栈上构造 **16 个 (名称, 函数指针, 标志) 三元组**（名称指针指向
  `.rodata` 加密区 `0x202f54+`，函数指针 `0x14cb20+`），随后整体注册；
- 用 `memcmp` 逐一比对 `CF0`..`CF16`、`G0`/`G1`/`G2` 键名做**注册表自检测试**；
- 注册过程 `pthread_mutex_lock/unlock` 保护，多次 `syscall(178)`（gettid）；
- 同函数内还对 `memcpy`/`memset`/`__sync_fetch_and_add_*`/`floor`/`round`
  等符号名做 memcmp 匹配——即按名字初始化一张**运行时符号分发表**。

功能定位（中置信度）：这是 metasec 内部"能力/算法槽位表"的装载器，
后续模块按 CF 编号取用实现——把"哪个函数干什么"从符号层面彻底抹掉。

## 3. ctor[2]/[3] `0x152b58` / `0x1702b8` — 完整性标记校验

模拟实测（高置信度）：各自执行 `memcmp("linking", "linking", 7)`。
对自解密出的标记串与内嵌常量做一致性比较——链接/装载完整性哨兵，
值被篡改即失配。

## 4. ctor[4] `0x171ddc` — 注册表交叉自检

模拟实测（高置信度）：大量 `memcmp(CFx, CFy)` 交叉比对 +
mutex 保护，是对 ctor[1] 所建注册表的二次一致性验证。
（模拟中途因伪环境缺数据而停，但自检行为已充分观测。）

## 5. ctor[93] `0x129430` — 运行时代码解密的实体证据

这是最硬的一层防护，静态+动态双重证据（高置信度）：

1. **函数体内嵌密文块**：`0x129518`、0x129550` 等处为 `<unknown>`
   字节（`d61fffeb`、`ff77f6f1`），夹在正常指令之间；
2. **计算式跳转进入**：`bl 取址 stub; add x1, x0, #0x38; br x1`，
   落点是 stub 之后的代码中段；
3. **跳入 2 对齐地址**：模拟中 PC 停在 `0x129ec2`（2 对齐），
   而文件里该处的字节是 `ret`（`c0035fd6`）——**文件态与运行态不一致**，
   说明执行前需要一次运行时解密/重写；我们的模拟器直接执行了密文，
   死循环在里面。这正是"分析脚本必须 hook 内存写才能跟进"的那层；
4. 进入前用 MBA 链计算 `x19 = 全局基址 + 混淆偏移`，
   即密文块的位置/密钥由混淆表达式现场算出。

## 6. 密集区 [5..115] — 111 个模块自注册（含三大检测数据库）

每个 ctor 结构雷同：先解密 `'bd' / 'v04.09.05' / '1.0'`（模块名+版本头，
另有 `'rp_fail_record'` 等配置键），再解密并注册本模块的资源。
其中三个"注册中心"直接暴露了这个 SDK 的检测覆盖面（全部高置信度，
模拟实时解密所得）：

### ctor[68] `0x39778` — ROOT 检测库（46 条）

su 各变体路径（`/system/xbin/su`、`/system/bin/.su`、`/sbin/su`…）、
Magisk 全家桶（`/data/adb/magisk`、`/sbin/.magisk`、`/dev/magisk/img`、
`magiskpolicy`、`libzygisk.so`）、KernelSU/APatch（`/data/adb/ksu`、
`/data/adb/apd`、`/data/adb/kpatch`）、各类一键 root 包名
（kingroot、kinguser、rootcloak2、shua me、mtk user2root…）。

### ctor[69] `0x3a6dc` — 注入框架检测库（35 条）

LSPosed/EdXposed/Riru/Taichi 全家族模块路径
（`/sbin/.magisk/modules/riru_lsposed`、`zygisk_lsposed`、`taichi-zygisk`…）、
Xposed 安装器与运行时文件（`/system/framework/XposedBridge.jar`、
`libxposed_art.so(.no_orig)`、`/system/xposed.prop`、
`de.robv.android.xposed.installer`、`org.meowcat.edxposed.manager`）。

### ctor[86] `0x3c724` — 云手机/虚拟机检测库（100 条）

- X8 沙箱：`ro.x8.version/uuid`、`/x8/config/root.pkg.blacklist`、
  `/proc/self/root//data/data/com.x8zs.sandbox/2ndos/rootfs`
- 虚拟大师 vphone：`ro.vphone.rompath/socketpath/pkname`
- 两仪 twoyi：`/proc/self/root//data/data/io.twoyi/rootfs`
- 分身 dual space：`com.clone.android.dual.space/vm`
- Titan 内核云机：`ro.kernel.titan`、`/vendor/lib64/libtitan-ril.so`、
  `/init.titan.rc`
- Rockchip 方案云机：`ro.rksdk.version`、`sys.rkadb.root` 等
- 构建指纹交叉校验：`ro.*.build.date.utc` ×6 个分区

### 其余值得注意的模块注册

- ctor[18] `0x34d20`：SensorQueue API 表（传感器事件采集，行为指纹用）
- ctor[19] `0x34e68`：cJSON API 表 + **`ms_open/ms_read/ms_write/ms_syscall`**
  ——metasec 自有的 syscall 封装层（`ms_syscall(IIIIII)` 六参数形态）
- ctor[5] `0x33c20`：首个模块注册（`v04.09.05`，初始化全套
  mutex/rwlock/TLS key）

## 7. 防护手段总结（按攻击者视角的对抗目标）

| 手段 | 位置 | 对抗什么 | 置信度 |
|---|---|---|---|
| svc #0 裸 syscall + 参数 MBA 混淆 | ctor[0] `0x59380` 等 | 模拟器无内核（svc 中止模拟）；静态读不出调用号 | 高 |
| NZCV 忠实性检查 + `brk #3` 陷阱 | ctor[0] `0x59394` | 弱模拟器/插桩框架（不实现 msr NZCV 即踩 SIGTRAP） | 高 |
| `clrex` 伴随陷阱 | ctor[0] `0x593a8` | 干扰独占加载/存储序列的模拟 | 中 |
| 计算式跳转（bl 取址 stub + br 中段） | ctor[0]/[93] 等 | 线性/递归反汇编、函数边界识别 | 高 |
| 控制流平坦化状态机 | ctor[0] `0x59440+` | 人工静态阅读、反编译器 | 高 |
| 自取地址参与密钥运算 | ctor[0] `x26=&self` | 代码搬移/dump 后重放 | 高 |
| 代码静态密文化 + 2 对齐跳入 | ctor[93]（`0x129518`/`0x129550` 密文块、`0x129ec2` 2 对齐落点） | 纯静态反汇编；不带解密的模拟 | 高 |
| 完整性标记 memcmp 校验 | ctor[2]/[3]（`'linking'`）、ctor[4] | 重打包/篡改 | 高 |
| 能力注册表（CF1..CF16/G0..G2）+ 自检 | ctor[1]/[4] | 符号级理解（彻底去语义化） | 高 |
| 检测数据库加载期预解密 | ctor[68]/[69]/[86] | 运行时才开始检测，静态看不到明文名单 | 高 |
| 计时锚点 clock_gettime | ctor[0]/[106] | 单步/模拟的时间侧信道（配合后续比对） | 中 |

## 8. 对 mock 项目的映射

| 真 .so init_array 行为 | mock 对应层 | 状态 |
|---|---|---|
| svc #0 探测 + NZCV 校验 + brk | `emu_check()` 双探针 | ✅ 已有（brk 陷阱未做） |
| 代码静态密文化 + 运行时解密跳入 | `payload()` + `unlock_payload()` | ✅ 已有（未做 2 对齐错位跳入） |
| 完整性 memcmp/CRC 校验 | CRC 自校验 | ✅ 已有（形态不同） |
| 检测库加载期解密注册 | 字符串加密 + IMM/RODATA 双形态 | ✅ 机制相同 |
| 能力注册表去语义化 | JNI 动态注册 | 部分对应 |
| 控制流平坦化/MBA dispatcher | opaque predicate 点缀 | ❌ 密度差距 |
| 2 对齐跳入 + 用后重加密 | — | ❌ 路线图第 2 项 |

## 产物

- `init_array_emu.py` — 本次分析用的全量 ctor 模拟器（增量落盘、svc 去重、
  memcmp/syscall 参数抓取）
- `init_array_trace.json` — 116 个 ctor 的完整行为轨迹
- `run_full.log` — 终端全量日志

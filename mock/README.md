# libmock.so — libmetasec_ml.so 防护机制的教学级重现（加固版 v10）

对抖音安全组件 `libmetasec_ml.so`（ARM64, stripped, O-MVLL 混淆）七大核心机制的
**同方案重现**，并附带可完整破解它的 Python 分析脚本。用于逆向工程练习：
先理解攻击者视角的分析方法，再理解防护方的设计取舍。

## 正常做法 vs 加固做法

先建立基线：一个**不做任何防护**的 Android native SDK 通常长什么样，
以及它暴露了什么；再看 mock 复刻的加固方案各自堵住了哪条攻击路径。

### 对比 1 — 字符串

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 写法 | `const char* cls = "com/mock/Mock";` | 构建期用周期-8 XOR 密钥流加密，源码/二进制里只有密文 |
| 二进制形态 | 明文躺在 `.rodata`，`strings` 命令直接可见 | 密文驻留 `.rodata`（长串）或**立即数展开写栈**（短串，不经 `.rodata`） |
| 暴露面 | 类名、方法名、签名、业务端点、检测路径全部泄露；可被 YARA/特征扫描直接命中 | 静态扫描只看到无意义字节；`strings` 输出为空 |
| 破解代价 | 零 | 必须动态模拟执行到解密点（Unicorn hook 进/出口），或先静态提炼密钥流 |

要点：正常做法的字符串是**免费情报**——攻击者不运行代码就能画出 SDK 的
完整功能地图。加密后，每条字符串都要付出一次动态分析成本；
2,685 个调用点（真 .so 的规模）意味着静态特征匹配彻底失效。

### 对比 2 — JNI 注册

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 写法 | 静态注册：导出 `Java_com_mock_Mock_a` 函数符号；或 Java 层 `static { … }` 直接声明 | `JNI_OnLoad` 里运行时构造 `JNINativeMethod` 表，调 `RegisterNatives` |
| 二进制形态 | 方法名编码在**导出符号名**里，`readelf -s` / IDA 导出窗口直接列出全部 native 方法 | 仅导出 `JNI_OnLoad` 一个符号；方法名/签名是运行时解密出来的栈上数据 |
| 暴露面 | 攻击者拿到"类名.方法名 → 函数地址"的完整映射，hook 点直接可定位 | fnPtr 只是 `adrp+add` 算出的裸地址，无符号、无名字；必须先模拟执行 `JNI_OnLoad` 才能拿到注册表 |
| 破解代价 | 零 | 需要构造假 JavaVM/JNIEnv vtable，模拟执行并在 `RegisterNatives` 槽位截获参数 |

要点：静态注册把"攻击者最想要的东西"（方法表）白送在符号表里。
动态注册把它变成一段必须执行才能观察到的瞬时内存状态。

### 对比 3 — 完整性自校验

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 写法 | 无 | `JNI_OnLoad` 入口对自身 `.text` 求 CRC32，与构建期回填的期望值比较（比较本身走 MBA XOR，无直白 cmp 校验点） |
| 二进制形态 | — | 期望值是**构建后期 patch** 进 `.rodata` 的（mock 当前构建为 `0xb89c5429`），源码里只有占位魔数 `0xDEADBEEF` |
| 防护目标 | 无 | 任何代码段 patch——inline hook 的跳板覆写、调试器软件断点（`brk` 改写）、反编译后重打包——都会改变 CRC，库直接拒绝工作 |
| 破解代价 | — | patch 的同时必须同步修 CRC 期望值或绕过分支；且期望值位置本身需要被找到 |

要点：前两层是"防看"，这一层是"防改"。它把攻击成本从"改一个字节"
抬高到"理解整个校验回路"。

### 对比 4 — 反模拟

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 写法 | 无 | `svc #0` 真实系统调用探测 + NZCV 忠实性检查（带 `brk #3` 反调试陷阱） |
| 防护目标 | 无 | Unicorn/QEMU 用户态等"无内核、指令语义不忠实"的分析环境；裸奔的插桩框架 |
| 生效方式 | — | Unicorn 执行 `svc` 时没有内核接管，直接抛未处理异常**中止模拟**；不实现 `msr NZCV` 的弱模拟器会踩进 `clrex + brk #3`（SIGTRAP）——防护在指令级生效，不依赖返回值判断 |
| 破解代价 | — | 攻击方必须给模拟器加 `UC_HOOK_INTR`，逐条识别并接管对抗指令（伪造 syscall 返回、手动推进 PC） |

要点：前三层防护都可以被"放进模拟器里跑一遍"统一穿透；本层专门抬升
**动态模拟**本身的门槛，逼攻击者先维护一套 syscall/异常接管框架。

### 对比 5 — 代码本身

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 二进制形态 | 函数机器码在文件中即明文，`objdump`/IDA 直接反汇编 | 关键函数机器码构建期加密，且**密文槽位放在 VA≡2 (mod 4) 的错位地址**（真 .so 同款），原函数位置填 `udf #0` 陷阱；运行时才解密写回原址跳入 |
| 静态分析 | 反编译即得全部逻辑 | 静态反汇编密文槽只能看到相位错乱的垃圾指令；`n_b` 只剩一个跳转，函数原位是 `udf` 死码 |
| 动态分析 | 断点/ hook 直接下在函数上 | 必须先跟过 `mprotect + 错位密文读取 + 明文写回 + I-cache 刷新` 这段自修改代码流程 |
| 破解代价 | 零 | 模拟器要能执行自修改代码（接管 mprotect syscall、容忍 cache 维护指令），或先静态还原加密参数再手工脱壳 |

要点：这是对"代码"本身的保护——即使攻击者穿透了前四层拿到注册表，
native 方法的实现体在文件里依然不存在。

### 对比 6 — 控制流与算术形态

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 控制流 | 函数基本块按书写顺序 fall-through，IDA 的 CFG 图直接可读 | O-MVLL 平坦化：基本块由状态变量驱动（真 .so ctor[0] 实测形态）；mock 中 `n_b` 的 unlock→payload→seal 三段时序打散成**穿线式状态机**——每个块尾部 `ldrsw` 读偏移表 + `add` + `br x8` 计算下一块地址，无 switch 无跳表，另有诱饵块 + 永假死分支 |
| 算术形态 | `a ^ b` 就是一条 `eor`，解密循环靠"找 XOR"即可定位 | MBA 混合布尔算术：`a^b ≡ a+b-2*(a&b)`（编译为 add/and/sub/mul 网）、`a+b ≡ 2*(a\|b)-(a^b)`（编译为 orr/eor/mul/sub 网），叠加 opaque 项 `(c*(c+1))&1` 阻断编译器折叠 |
| 暴露面 | 控制流图 = 程序逻辑图；异或循环是解密点的路标 | CFG 里块序与真实执行序无关，状态推进没有立即数常数链；"找 eor 定位解密"的静态启发式对 unlock/seal 失效 |
| 破解代价 | 零 | 需要符号执行/污染分析证明 opaque 项恒零才能化简 MBA；平坦化是 `br x8` 数据驱动分发——IDA 无法自动恢复 CFG，必须先求解偏移表与状态机转移语义 |

要点：前五层保护的是**数据与代码的内容**，本层保护的是**逻辑的可读性**
——攻击者就算拿到明文代码，读到的也是一张必须先做图重建的状态机。
另外这层有个诚实的工程教训：教科书 MBA 恒等式 `(a|b)-(a&b)` 会被
clang -O2 折叠回 `eor`（白混淆），mock 选用的两条恒等式是**实测存活**
的——这正是真 .so 用 O-MVLL 在编译器后端注入、而不是手写源码的原因。

### 对比 7 — 反调试（运行期环境）

| | 正常做法 | mock / 真 .so 的做法 |
|---|---|---|
| 写法 | 无 | 加载期 `ptrace(PTRACE_TRACEME)` 占坑自检 + TracerPid 双轨轮询（每次 native 调用同步查 + 裸 `clone` 后台 watcher 线程 50ms 周期查，命中即 `exit_group` 自毁） |
| 防护目标 | 无 | gdb/lldb attach、frida-server、基于 ptrace 的注入框架 |
| 生效方式 | — | TRACEME 成功后内核拒绝后续 attach（EPERM）——先发占坑；已被调试时 TRACEME 直接失败、TracerPid 非 0，两路互证 |
| 检测点隐蔽性 | — | `/proc/self/status` 路径与 `TracerPid:` 字段名同样加密存放，`strings` 看不到检测点 |
| 破解代价 | — | 模拟器端须伪造 4 个 syscall（ptrace/openat/read/close）且**两个接口的回答必须自洽**（TracerPid 与 TRACEME 结果要能对上）；真机端须 patch 内核态语义或绕开检测点 |

要点：前六层防的是"分析代码"，本层防的是"运行期被盯梢"。
它把对抗面从二进制推向**环境自洽性**——攻击者伪造任何一个
/proc 接口，都必须保证所有其它接口给出一致的答案（这正是
UNIDBG_NOTES.md P1-2 指出的大多数模拟器的软肋）。

### 综合对比

| 攻击手段 | 对正常做法 | 对加固做法 |
|---|---|---|
| `strings` / `readelf` / YARA | 全量泄露 | 一无所获 |
| IDA 静态浏览 | 方法表、字符串、代码逻辑一目了然 | 只剩 `JNI_OnLoad` 一个入口，密文、vtable 间接调用、加密函数体 |
| inline hook / 软件断点 | 直接可用 | CRC 失配，库自毁（真 .so 走 `0x125D34`） |
| Unicorn 直接模拟 | 不需要 | svc #0 中止模拟 |
| Unicorn + INTR 接管 | 不需要 | **仍可全部穿透**——见下 |
| 反编译读逻辑 | 直接读 | 平坦化 CFG 需先做状态机重建；MBA 网需先做恒等式化简 |
| gdb/frida attach | 直接可用 | TRACEME 占坑拒绝 attach；TracerPid 轮询捕获已存在的 tracer |

诚实的边界：即便叠满六层，攻击方仍可通过 INTR hook 接管 syscall、
让自修改代码在模拟器里自然完成解密来完成穿透（`analyze_mock.py`
已演示）。防护的本质不是"不可破解"，而是持续抬高攻击者的工程成本：
每一层都逼着对手的武器库多一件装备。

## 重现的七大机制

### 1. 字符串加密（真实方案，非近似）

分析真 .so 时，对其 5 个解密函数（`0x12B904 / 0x12BFA8 / 0x12C648 / 0x12C9A4 / 0x12CF90`）
做了黑盒选择明文提炼（`../metasec_350101/extract_algo.py`），穿透 MBA 混淆得到真实算法：

```
每个变体均为周期 8 的 XOR 密钥流：  out[i] = in[i] ^ K[i % 8]

v1 (0x12B904): K = a5 10 71 c7 50 90 e1 b1
v2 (0x12BFA8): K = a5 12 81 d7 60 10 71 b2
v3 (0x12C648): K = b5 20 91 e7 40 a0 e3 b6
v4 (0x12C9A4): K = a7 50 78 c9 60 97 ef f1
v5 (0x12CF90): K = 35 1f 7f f7 90 9f e1 b1
```

该结论经真 .so 中 2,354 对密文/明文交叉验证，100% 吻合。

mock 端完全照搬这一方案：

- 5 个解密函数变体 `dec_v1..dec_v5`，使用**同一组真实密钥流**；
- 同样的调用约定：`dec(buf, len)` 原地解密、写 NUL、返回 `buf`；
- 同样的**双形态装载**（由 `gen_ciphers.py` 按字符串长度自动选择）：
  - **RODATA 形态**：密文驻留 `.rodata`，调用点先拷贝到可写栈缓冲再解密
    （对应真 .so 的 `new[] + ldr q0/d0` 整块搬运模式）；
  - **IMM 立即数展开**：短字符串（方法名等）的密文由编译器展开成
    `mov wN, #imm; strh/strb` 序列直接写栈，`.rodata` 里**不留任何痕迹**
    （对应真 .so 里大量 `mov/strh` 立即数写栈的调用点）；
- 每个变体带一个 O-MVLL 风格 opaque predicate（`(i*(i+1)) & 1` 恒为 0），
  模拟原版的 MBA 保护外观。

### 2. JNI_OnLoad 动态注册

复刻真 .so 函数 `0x12F5D0`（在 `0x12F92C` 经 JNIEnv vtable slot 215 调 RegisterNatives，
注册 `com/bytedance/mobsec/metasec/ml/MS.a`）的结构：

```
JNI_OnLoad(vm, _):
    !emu_check()                               → return -1   # 反模拟
    crc32_self(text_base, 0x180) != CRC_EXPECT → return -1   # 自校验
    GetEnv(vm, &env, JNI_VERSION_1_6)          # JavaVM vtable slot 6
    clazz = FindClass(env, dec_v4(class_name)) # JNIEnv vtable slot 6
    methods[0] = { dec_v1("a"), dec_v2(sig), &n_a }
    methods[1] = { dec_v3("b"), dec_v5(sig), &n_b }   # fnPtr 走 adrp+add
    RegisterNatives(env, clazz, methods, 2)    # JNIEnv vtable slot 215

n_b(env, _):                                  # 按需解密、用完重加密
    unlock_payload(text_base)                  # mprotect + 解密写回 + 刷 cache
    r = payload(env)                           # 明文只存在于这次调用内
    seal_payload(text_base)                    # 立即恢复密文
    return r
```

注册内容（与真 .so 同款签名；地址为当前构建）：

| 类 | 方法 | 签名 | native fnPtr |
|---|---|---|---|
| `com/mock/Mock` | `a` | `(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;` | `0x12b4` |
| `com/mock/Mock` | `b` | `()Ljava/lang/String;` | `0x1390` |

### 3. CRC 自校验（构建期回填）

- `JNI_OnLoad` 入口对自身 `.text` 前 `0x180` 字节求标准 CRC32
  （多项式 `0xEDB88320`，位运算实现，无查表避免额外数据段）；
- 期望值 `CRC_EXPECT` 在源码中是占位魔数 `0xDEADBEEF`；
- `so_linker.py` 在重定位和 payload 密文化完成后计算真实 CRC 并改写
  `.rodata` 中的占位值（当前构建为 `0xe2f26c4c`，文件偏移 `0x1550`）——
  模拟商用加固"构建后期 patch 校验和"的做法，源码里永远看不到正确期望值；
- 失配即返回 `-1` 拒绝注册（真 .so 此处 `bl 0x125D34` 走自毁函数）。

**防护演示**（已验证）：把 `libmock.so` 拷到 `/tmp` 并改动 `.text` 中任意一个字节后，
`analyze_mock.py` 的输出变为 `JNI_OnLoad returned 0xffffffff`、
`registration: null`——svc 探测被接管也没用，库在 CRC 处自毁，
注册表和字符串全部拿不到。演示输出存于 `mock_analysis_patched.json`。

### 4. 反模拟检查（svc #0 + NZCV + brk 陷阱）

对应真 .so init_array ctor[0]（`0x59294`）里实测的原版对抗块
（分析见 `../metasec_350101/init_array/init_array_report.md`），`emu_check()` 内两个互补探针：

- **探针 A — NZCV 忠实性检查 + brk 反调试陷阱**（逐指令复刻真 .so `0x59394`）：
  `mrs` 保存 NZCV → `cmp xzr,xzr` 置 Z=1 → `msr NZCV` 清零（Z→0）→
  `b.ne` 正常跳过。不实现 `msr NZCV` 的弱模拟器/插桩框架 Z 保持 1，
  落入 `clrex + brk #3`（SIGTRAP——裸运行崩溃、被调试时暴露）；
  真机与 Unicorn（忠实实现 NZCV）正常跳过。
- **探针 B — svc #0 系统调用探测**（真 .so `0x59380` 同款）：以 `__NR_getpid`(172)
  发起真实系统调用。真机内核返回 pid > 0；Unicorn 没有内核，
  `svc` 直接触发未处理异常**中止整个模拟**，根本执行不到返回值比较。

**攻防演示**（已验证）：未升级的 `analyze_mock.py` 在 svc 处抛出
`UC_ERR_EXCEPTION`，`JNI_OnLoad` 崩溃、0 条字符串还原——防护生效。
攻击方标准跟进是给模拟器加 `UC_HOOK_INTR`：按 x8 的 syscall 号伪造返回值
（假 pid 4242），并按内存中的指令编码判断是否需要把 PC 推进过 svc。

### 5. 运行时代码解密（错位密文槽 + 按需解密 + 用后重加密）

对应真 .so init_array ctor[93]（`0x129430`）实测的完整形态：

- **构建期**：`so_linker.py` 在重定位完成后把 `payload()`（n_b 的真正实现，
  0x68 字节）的机器码加密后搬到 RX 段尾部一个 **VA≡2 (mod 4) 的密文槽位**
  （当前构建 `0x1622`）——从槽位起点反汇编时指令相位与 4 对齐网格错开
  2 字节，`objdump` 只能解出相位错乱的 `<unknown>`/SIMD 垃圾指令；
  **payload 原位填 0**（`udf #0`——未解密时被调用立即 SIGILL）；
- **运行时（按需解密、用完重加密）**：`n_b` 每次被调用时——
  `unlock_payload()`：`svc` 调 `mprotect`(226) 改 RWX → 从 2 对齐槽位读密文、
  XOR 解密、**明文写回 payload 的 4 对齐原地址** → `dc cvau`/`ic ivau`
  刷 cache → `dsb ish` + `isb`；调用 `payload()`；返回前 `seal_payload()`
  **立即恢复密文**（XOR 对称，原地再 XOR 一遍即与槽位逐字节一致）。
  明文只存在于一次调用之内，攻击者的 dump 窗口被压缩到调用瞬间；
- **ASLR 处理**：回填的是文件相对 VA，运行时以"页对齐的自身地址 +
  文件偏移"换算真实地址，与真 .so 的做法一致；
- **四个元数据（明文 VA/长度/密钥/密文槽 VA）由构建期回填进 `.rodata`
  占位常量**，源码里只有 `0xDEAD0001/2/A7/4` 魔数。

**攻防演示**（已验证）：分析器不接管 `mprotect` syscall 时，模拟在
`unlock_payload` 里中止；接管后（返回 0，Unicorn 内存本就 RWX），
模拟日志里能清楚看到 n_b 内部的**两次** mprotect（调用前解密、
返回前重加密），`mock_sdk_v1.0` 照常还原。若绕过 `n_b` 直接模拟
`payload` 地址，跳入的是 `udf` 死码，立即崩溃。

**但"用后重加密"并没有消灭明文窗口**（已验证，`payload_plaintext.bin`）：
seal 要重加密就必须先 `mprotect` 把页改成 RW，而 `unlock→seal` 之间
对页内的写集合恰好就是 payload 本体。分析器用 `UC_HOOK_MEM_WRITE`
记录该窗口内被写地址范围 `[0x1464, 0x1464+0x68)`，在 seal 的 `svc`
触发瞬间（明文尚在内存）精确 dump——拿到完整 104 字节明文，
capstone 反汇编证实是合法 ARM64：栈帧开关、字符串拷贝循环、
`bl 0x131c`（解密函数）、`ldr x20, [x8, #0x538]`（JNIEnv vtable
slot 167 = NewStringUTF）一应俱全。**结论：代码加密对抗的是静态
分析与"非调用期 dump"，对"盯着内存写的动态分析"只是把成本从
一次页 dump 提高到一次写监视 + 时序捕捉。**

### 6. 控制流平坦化 + MBA 混淆（O-MVLL 形态复刻）

对应真 .so ctor[0]（`0x59294`）实测的 dispatcher 分发形态与全库散布的
MBA 混淆块（and/eor/madd 混合网）。本实现分两部分：

**MBA 原语**（`mba_xor` / `mba_add`）：把解密 XOR、状态推进、CRC 比较
全部改写成混合布尔算术恒等式。关键工程教训（实测得出）：

- 教科书恒等式 `(a|b)-(a&b) ≡ a^b` 会被 clang -O2 的 InstCombine
  **折叠回一条 `eor`**——从源码写 MBA 的第一版全部白混淆；
- 存活配方是换恒等式 + 叠加非线性 opaque 项：
  `a^b ≡ a+b-2*(a&b) + (c*(c+1)&1)`，其中 c 来自 volatile 恒零变量
  （任意整数乘其后继必为偶数，恒 0，但 volatile 阻断编译器证明）；
- 编译产物实测：unlock 解密循环为
  `ldrb; ldr; mvn; mul; add; and; sub lsl#1; and; add; strb` 的 11 条
  指令网——没有 `eor`，"找 XOR 循环定位解密点"的静态启发式失效。

**平坦化**（`n_b`，数据驱动穿线分发）：unlock→payload→seal 三段时序
打散成 6 态状态机（3 真实 + 2 诱饵 + 1 出口），**没有 switch、没有
跳表**——每个基本块尾部独立计算下一块地址：

- 块地址表 `DISP[]` 存**标签差值**（`&&Lx - &&L_BASE`，GNU C 计算
  goto 扩展）：汇编期解出 int32 偏移，全程零动态重定位，PIC/ASLR
  天然安全（这是源码层做计算式间接跳转且不依赖链接器支持 ABS64
  数据重定位的唯一写法）；
- 每个块尾部实测形态：`ldrsw x8, [x22, w25, uxtw #2]`（读偏移表）
  → `add x8, x23, x8`（基址+偏移）→ **`br x8`**——与真 .so 0x59440
  的"算术算地址 + br xN"同形态；
- 状态推进全部走 `mba_add`：二进制里没有 `mov w8, #1` 式的立即数
  状态链，每个转移都是 `ldr(volatile); eor; mvn; mul; lsl; orr; add` 网；
- 永假死分支 `(OP&1)!=0 → st=ST_DONE` 编译为 `tst+csel`，把状态
  伪装成"直通出口"，反编译器必须证明 OP≡0 才能剪掉这条出边；
- 两个诱饵块仅被偏移表引用而永远不会进入，但地址被取使编译器
  无法删除——CFG 上多出两个假基本块和两条假转移边。

**攻防定位**（与其它层的分工）：这两层对动态模拟**天然透明**——
`analyze_mock.py` 未做任何适配即照常全绿，因为模拟器逐条执行指令，
不关心控制流写成什么图、算术写成什么网。它们抬的是**静态阅读**
成本：IDA 里 `br x8` 的目标是数据依赖的，CFG 恢复必须先求解
偏移表 + 状态机的完整转移语义，比 switch 跳表高一个量级。
真 .so 的设计逻辑正是分层拦截：静态分析者先被 MBA/平坦化挡住，
动态分析者再被 svc/CRC/代码加密挡住。

**有意简化**：真 .so 的基本块物理乱序由 O-MVLL 在编译器后端完成；
源码层无法控制后端块排布——这一差距如实保留。

### 7. 反调试（ptrace 占坑自检 + TracerPid 轮询）

对应真 .so 的反调试层。两个互补探针：

- **探针 C — ptrace(PTRACE_TRACEME) 占坑**（`ptrace_selfcheck`，
  仅 JNI_OnLoad 加载期调一次）：未被调试时调用成功，进程从此被
  打上 PT_PTRACED 标记，后续调试器 attach 即被内核 EPERM 拒绝——
  先发制人；已被调试时 TRACEME 直接返回 EPERM 暴露现状。
  **必须只调一次**（成功后第二次 TRACEME 会 EPERM 误伤自己），
  所以运行期只能用无副作用的探针 D；
- **探针 D — TracerPid 轮询**（`tracerpid_poll`，双轨：同步轮询点在
  JNI_OnLoad、n_a、n_b 每个入口 + 后台 watcher 线程 50ms 周期轮询）：
  openat(56)/read(63)/close(57) 全走裸 svc，解密 `/proc/self/status`
  路径（RODATA 形态）与 `TracerPid:` 字段名（IMM 形态）。
  判定与真内核语义对齐：`TracerPid == 0 || TracerPid == getppid()`
  为干净（TRACEME 占坑后父进程即 tracer，朴素"非 0 即判定"会永久
  误伤自己——这是实现反调试最容易踩的真实陷阱）。fail-open：
  /proc 不可用时不误伤受限环境。
- **watcher 线程**（`spawn_watcher`）：mmap(222) 匿名页作栈 +
  裸 clone(220, VM|FS|FILES|SIGHAND|THREAD)——与 pthread_create 的
  内核路径同款；子线程 50ms 一轮 poll，命中即 `exit_group(9)`
  整组自毁。watcher 零参数传递（自含轮询+自毁），规避 clone
  子栈参数布置的 ABI 脆弱点。
- **结构性反模拟红利**：Unicorn/unidbg 这类顺序模拟器无法忠实执行
  clone 的并发语义，攻击方只能伪造 clone 返回非 0——watcher 线程
  在模拟器里**整体不可见、永不执行**，检测面与模拟观测面被错开
  （分析日志里只留下一行 "watcher 线程在模拟器里不运行"）。
- **与模拟器的对抗转移**：本层在 Unicorn 下必然被穿透（攻击方
  伪造 6 个 syscall 即可），但它把成本转移到**自洽性**——TracerPid
  的答案必须与 ptrace/getppid 子系统行为一致（UNIDBG_NOTES.md
  P1-2）。`analyze_mock.py` 的伪造实现里两者联动（干净模式
  TracerPid=fake ppid=1234；`MOCK_TRACER=1` 同时翻转 TRACEME 与
  TracerPid 的回答）。
- **与模拟器的对抗转移**：本层在 Unicorn 下必然被穿透（攻击方
  伪造 4 个 syscall 即可），但它把成本转移到**自洽性**——TracerPid
  的答案必须与 ptrace 子系统行为一致（UNIDBG_NOTES.md P1-2）。
  `analyze_mock.py` 的伪造实现里两者是联动的（`MOCK_TRACER` 环境
  变量同时翻转两个接口的回答）。

**攻防演示**（已验证，双模式对照）：

```bash
python3 analyze_mock.py          # 干净环境：TRACEME ok + TracerPid=0
                                 #   → 注册成功，payload 照常被抓
MOCK_TRACER=1 python3 analyze_mock.py   # 模拟已被调试：TRACEME → EPERM
                                 #   → JNI_OnLoad 返回 -1，零泄露
```

## 文件清单

| 文件 | 说明 |
|---|---|
| `mock.c` | libmock.so 全部源码（无 libc，`-nostdlib -ffreestanding`，全注释） |
| `gen_ciphers.py` | 用真实密钥流把明文加密成 `cipher_data.h`；按长度选 IMM/RODATA 形态（含自检测试） |
| `cipher_data.h` | 生成的密文 + 密钥常量 + IMM 装载宏（构建产物，勿手改） |
| `so_linker.py` | 迷你 ELF 链接器：`.o` → `.so`，应用重定位、payload 密文化、回填 CRC |
| `build.sh` | 一键构建 |
| `libmock.so` | 构建产物：ARM64 ELF shared object，12,496 字节，仅导出 `JNI_OnLoad` |
| `analyze_mock.py` | 配套分析脚本（见下） |
| `mock_analysis.json` | 分析输出（`mock_analysis_patched.json` 为 CRC 自毁演示输出） |
| `payload_plaintext.bin` | 攻防演示产物：seal 窗口内抓到的 payload 明文（104B，合法 ARM64） |
| `UNIDBG_NOTES.md` | 基于本项目实测给 unidbg 的改进意见 |

## 构建

```sh
./build.sh
```

要求：macOS 自带 Xcode Command Line Tools（Apple clang）+ managed Python。
原理：Apple clang 是纯 LLVM，可直接交叉编译 aarch64-linux ELF 目标文件；
`so_linker.py` 完成链接（应用 `ADRP_PREL_PG_HI21` / `ADD_ABS_LO12_NC` /
各宽度 `LDST*_ABS_LO12_NC` 重定位，生成 `.dynsym/.dynstr/.hash/.dynamic`
和两个 PT_LOAD），因此**不需要 Android NDK**。

## 分析脚本

```sh
python3 analyze_mock.py [libmock.so]
```

使用与分析真 .so 完全相同的两种方法：

**方法 1 — 字符串还原**
1. 启发式定位解密函数族：被 `bl` 调用、函数体含 `eor` 且从 x0 指向的缓冲 `ldrb`；
2. Unicorn 模拟宿主函数（JNI_OnLoad 及注册的 native 方法），hook 解密函数
   进/出口：进入时从 `(x0, w1)` 读密文，返回后按 NUL 读明文；
3. 自动处理编译器特化克隆（常量 len 传播后不再读 w1 的变体）；
4. IMM 形态对方法 1 天然透明：hook 读的是**栈缓冲内容**，
   不关心密文是拷贝来的还是立即数写上的。

**方法 2 — JNI 注册表还原**
1. 构造假 JavaVM/JNIEnv：vtable 槽全部指向 NOP hook 窗口；
2. 模拟执行 `JNI_OnLoad`，在 Python 侧分发 `GetEnv / FindClass /
   RegisterNatives / NewStringUTF`，参数完全可观测；
3. 递归模拟每个注册的 fnPtr，收集 native 方法内部的解密字符串；
4. 同时静态标注 RegisterNatives 调用点（`ldr xN,[xN,#0x6B8]; blr xN`，
   当前位于 `0x119c`）。

**对抗层穿透（攻击方跟进记录）**：
- 反模拟：`UC_HOOK_INTR` 接管 svc #0，伪造 getpid 返回并推进 PC；
- 反调试：同一 INTR hook 再接管 ptrace/openat/read/close——伪造
  TRACEME 成功 + 假 `/proc/self/status`（TracerPid=0），且两个接口的
  回答必须自洽（`MOCK_TRACER=1` 可跑对照演示：模拟已被调试时
  JNI_OnLoad 返回 -1、零泄露）；
- 代码解密：同一 INTR hook 接管 mprotect（返回 0），自修改解密循环
  在模拟器内存中自然完成——无需额外处理；
- 明文抓取：`UC_HOOK_MEM_WRITE` 记录 mprotect 窗口内的写地址范围
  （unlock→seal 之间的写集合 = payload 本体），在 seal 的 svc 触发
  瞬间精确 dump `payload_plaintext.bin`（104B，capstone 验证为合法
  ARM64）——用后重加密只压缩窗口，没有消灭窗口；
- CRC：模拟器加载未被篡改的 .text，校验自然通过（CRC 对抗的是
  patch 场景，可用 `/tmp/libmock_patched.so` 演示）；
- 平坦化 + MBA：动态模拟**天然免疫**——模拟器逐条执行指令，
  状态机怎么跳、算术写成什么形态都不影响语义结果。这两层抬的是
  **静态阅读**成本（IDA 里的 CFG 与表达式形态），对"跑起来看"的
  攻击路径透明。这正是真 .so 把它们与其它层叠加的原因：
  静态分析者先被 MBA/平坦化挡住，动态分析者再被 svc/CRC/代码加密
  挡住，两套武器库缺一不可。

输出 `mock_analysis.json` + 终端日志。当前结果：

- 9/9 明文字符串全部还原（类名、两个方法名、两个签名、两条 native 返回串、
  反调试检测串 `/proc/self/status` 与 `TracerPid:`）；
- 注册表完整：`com/mock/Mock` 注册 2 个方法，name/sig/fnPtr 全部正确；
- `JNI_OnLoad` 返回 `0x10006`（JNI_VERSION_1_6）。

**已知局限**：启发式会把 `crc32_self`（同样满足"被 bl 调用 + 循环读字节"特征）
误报为解密函数，产生一条 `pt: null` 的噪声记录。真 .so 分析中需要人工剔除
同类误报，脚本保留这一行为以反映真实分析体验。

## 与真 .so 的差异（有意简化）

| 维度 | libmetasec_ml.so | libmock.so |
|---|---|---|
| 解密算法 | 周期 8 XOR ×5 密钥 | **相同**（真实提取） |
| 密文装载 | RODATA 拷贝 + 立即数展开混合 | **相同**（双形态） |
| CRC 自校验 | 有（种子 0x20190512 → 硬编码 0x77DF8B85） | **有**（构建期回填 CRC32） |
| 反模拟检查 | 有（NZCV 保存/恢复验证、svc #0 探测，散布全库） | **有**（同款双探针，集中一处） |
| 运行时代码解密 | 有（2 对齐错位密文 + 明文写回跳入，用完重新加密） | **有**（完整对齐：错位密文槽 + 按需解密 + 用后重加密） |
| 函数体混淆 | MBA + 计算式间接跳转（`br xN` 数据驱动分发）+ 控制流平坦化 | **有**（MBA 双恒等式实测存活 + n_b 穿线式状态机：`ldrsw` 偏移表 + `br x8`，诱饵块/死分支齐全） |
| 反调试 | 有（brk 陷阱 / ptrace 自检 / TracerPid 轮询） | **有**（`clrex + brk #3` 复刻 0x59394 + ptrace TRACEME 占坑 + TracerPid 轮询点散布每次 native 调用） |
| 字符串规模 | 2,685 个调用点 | 7 个调用点 |
| libc 依赖 | malloc/pthread 等 221 个导入 | 无 |

差异集中在"密度与分布"层：真 .so 把反模拟块、CRC 校验、加密代码区撒满
全库每个关键函数，mock 为教学可读性集中在一处。七大核心机制已全部对齐。

## 进一步加固的路线图

已完成：~~密文立即数展开~~、~~CRC 自校验~~、~~反模拟检查（svc/NZCV/brk）~~、
~~运行时代码解密（错位密文槽 + 按需解密 + 用后重加密）~~、
~~解密/状态推进 MBA 化 + 控制流平坦化（计算 goto 偏移表 + `br x8`
数据驱动分发，0x59440 形态）~~、~~反调试（ptrace TRACEME 占坑 +
TracerPid 轮询 + clone 后台 watcher 线程自毁）~~。继续叠加的方向：

1. **对抗块散布化**：把 svc/NZCV 探针、CRC 校验、密文代码区复制到每个
   解密函数与 native 方法里，逼攻击者逐点排雷（真 .so 的密度形态）；
2. 基本块物理乱序（编译器后端级，O-MVLL 本体——源码层无法表达，
   需接 LLVM pass 或二进制重写）。

`analyze_mock.py` 的框架（Unicorn + hook 窗口 + vtable 分发 + INTR 接管）
已为此预留扩展空间。

# libmetasec_ml.so 整体结构分析报告

- 目标: `/Users/freeman/project/douyin/study/libmetasec_ml.so`（ELF 64-bit ARM64, stripped, 2.7MB, BuildID 025e5170…）
- 方法: rev-struct 技能流程；环境无 IDA MCP / 无导出反编译，采用 llvm-objdump 全量反汇编（`full_disasm.txt`，436,292 行）+ 按 vaddr 直读 ELF 数据段
- 日期: 2026-09-06；仅静态分析，未修改 IDA

---

## 1. 二进制概况

| 项 | 值 |
|---|---|
| 唯一导出符号 | `JNI_OnLoad` (0x139BB0) |
| .text | 0x33C20 起，约 1.7MB（0x1A9C38 字节） |
| .rodata / .data.rel.ro / .data / .bss | 0x1DD860 / 0x260540 / 0x27D000 / 0x2BBD70 |
| JNI 标准函数导入 | **无**（无 FindClass/RegisterNatives；交互全部自实现或经 dlsym） |
| 显著导入 | `mprotect`、`dl_iterate_phdr`、`getauxval`、`prctl`、`ptrace` 缺席但有 `kill`/`fork`/`waitpid`、`popen`/`system`、socket 族、`ASensorManager_*`、`ALooper_*`、`__system_property_*`、pthread 全族 |

**定性**：抖音 metasec 安全 SDK 的 ML/脚本保护库。自带一套 C++ 运行时风格的对象系统（vtable + 虚析构）、自定义红黑树 map、引用字符串类，以及一个字节码 VM 解释器。

## 2. 加固/混淆特征

1. **JNI_OnLoad (0x139BB0) 控制流混淆**：`bl` 取返回地址后 `add x1, x0, #0x34; br x1` 间接跳转；内嵌 `svc #0` 直接系统调用（绕过 PLT hook）；`mrs/msr NZCV` + `clrex` + `brk` 反调试序列。
2. **字符串加密**：大量调用点模式为 `operator new(len)` → 逐字节写入立即数 → `bl 0x12C9A4 / 0x12B904 / 0x12C648 / 0x12CF90 / 0x12BFA8`（各解密桩，签名 `(dst_buf, len)`，调用频次 448–582）。
3. **VM 解释器**：0x14B000–0x14D000 区域含跳转表派发（`ldr x8,[x26,w8,uxtw#3]; br x8`，case 0x35/0x57…），为字节码 VM 主循环。

## 3. 基础设施函数

| 地址 | 语义 | 证据 |
|---|---|---|
| 0x1C2EDC | `operator new(size)`：malloc + new_handler 循环 + bad_alloc | malloc 失败回调 `blr x0` 后重试 |
| 0x1C2F44 | `operator delete` | erase 路径释放 pair |
| 0x1C2F40 | `operator new[]`（小对象/字节缓冲） | 字符串解密桩使用 |
| 0x10B5F0 | MSString 构造（from C 串）: vtable=0x262AF0, cap=len+1, malloc | strlen+malloc+memcpy |
| 0x10B68C | MSString 拷贝构造 | 各 map 调用点 new(0x18) 后调用 |
| 0x10B764 / 0x10B7A8 | MSString 析构 / 析构+delete | vtable[0]/vtable[1] |
| 0x10B488 | MSString 构造（from ptr+len, w2=len） | `ldr x1,[x8,#0x10]; ldr w2,[x8,#0xc]` |
| 0x12DD04 / 0x12DE7C | RAII 互斥 guard 构造/析构 | 析构查锁表 0x2C3438[(guard>>4)&0xFF] 后 `pthread_mutex_unlock` |
| 0x2C3438 | 分片互斥锁表（256 项指针，锁体在每项 +8） | guard 析构索引 |

## 4. 恢复的核心结构体

### 4.1 TREE_MAP（顶层 map 对象）—— 置信度：高

```c
typedef void (*elem_delete_t)(void *elem);        // 调 [elem]->vtable[1] 多态销毁
typedef int  (*key_cmp_t)(const void *a, const void *b);

struct TREE_MAP {                 // sizeof = 0x28（0x120010: operator new(0x28)）
    /* 0x00 */ void        *vtable;      // → 0x26F150（另一实例 0x26F178）
    /* 0x08 */ elem_delete_t key_delete;    // 覆盖写/erase 时销毁 key
    /* 0x10 */ elem_delete_t value_delete;  // 覆盖写/erase 时销毁旧 value
    /* 0x18 */ key_cmp_t     cmp;           // 构造时转发给 TREE_IMPL.cmp
    /* 0x20 */ struct TREE_IMPL *impl;      // 堆分配红黑树实现
};
```

vtable @0x26F150 = `{ 0x11FD10, 0x11FE24, 0x11FF04(遍历收集), 0, 0, 0x120084(析构) }`；
第二实例 @0x26F178 = `{ 0x120084, 0x120110(析构+delete), 0, 0, 0x1202F0, 0x12037C }`。

关键证据地址：
- +0x08：`0x11FCC4`（assign 分支，x0=key）、erase `0x11FEAC`（x0=[pair+0]）；ctor `0x11FC20`
- +0x10：`0x11FCD4`（x0=[pair+8]=旧 value）、erase `0x11FEB8`；ctor `0x11FC20`
- +0x18：ctor `0x11FC24` 写入、`0x11FC2C` 转发 impl；本库实例 = 0x57A5C（取 `a+8`/`b+8` 后尾跳串比较 0x10A5FC）
- +0x20：`0x11FC50` `add x22,x0,#0x20`；thunk `0x10E914` `ldr x0,[x0]` 二次解引用；find `0x11FE50`、erase `0x11FE84`、dtor `0x1200C4`
- +0x00：ctor `0x11FC10` 写 0x26F150；内容经数据段直读确认为函数指针表

### 4.2 TREE_IMPL（红黑树实现）—— 置信度：高

```c
struct TREE_IMPL {                // sizeof = 0x28（0x10E7C0: operator new(0x28)）
    /* 0x00 */ TREE_NODE *header;   // 哨兵头节点; root = header->parent
    /* 0x08 */ size_t    node_count;// size() thunk 0x11FE48→0x10ECA4: ldr x0,[impl+8]
    /* 0x10 */ key_cmp_t cmp;       // = TREE_MAP.cmp
    /* 0x18 */ proj_fn_t proj;      // 默认 0x10E42C（identity: `ldr x0,[x1]; ret`）
    /* 0x20 */ void     *proj_ctx;  // = NULL
};
```
证据：ctor `0x10E7AC`+`0x10EB7C`（header 自旋初始化 left/right=自身、`str x19,[x20,#0x10]` 存 cmp、`stp` 存 {proj,ctx}）；查找循环 `0x10F344` / 插入循环 `0x10ED00`（cmp<0 走 +0x10 否则 +0x18）。

### 4.3 TREE_NODE / TREE_PAIR —— 置信度：高

```c
struct TREE_PAIR { void *key; void *value; };   // 0x10 字节（0x11FBDC: new(0x10)）

struct TREE_NODE {                // sizeof = 0x28（0x10EBC0: new(0x28) 零初始化）
    /* 0x00 */ uint32 color;      // w32 写入（ctor `str wzr,[x0]`）
    /* 0x08 */ TREE_NODE *parent; // root = [header+8]
    /* 0x10 */ TREE_NODE *left;
    /* 0x18 */ TREE_NODE *right;
    /* 0x20 */ TREE_PAIR *pair;   // 插入时挂接（0x10EE9C: str x22,[x0,#0x20]）
};
```
经典 libstdc++ `_Rb_tree` 节点布局（孩子偏移 0x10/0x18 决定下降方向，见 `csel x8, x26(0x10), x24(0x18), lt` @0x10ED38）。

### 4.4 MSString（map 的 key 类型）—— 置信度：高

```c
struct MSString {                 // sizeof = 0x18
    /* 0x00 */ void  *vtable;     // = 0x262AF0 = { 0x10B764 dtor, 0x10B7A8 dtor+delete, 0x262B48, … }
    /* 0x08 */ int32  capacity;   // len+1（stp w8,w0,[x19,#8] @0x10B628）
    /* 0x0C */ int32  length;
    /* 0x10 */ char  *data;       // malloc(cap)，析构 free 并清零
};
```
证据：ctor `0x10B5F0`、dtor `0x10B774`（`ldr x0,[x0,#0x10]; free`）。41 个调用点均以 `new(0x18)`+`0x10B68C` 拷贝构造 key，佐证 key 恒为 MSString。

### 4.5 树迭代器（trait 对象）—— 置信度：中高

```c
struct TREE_ITER {                // 16 字节 fat 对象，栈上构造
    /* 0x00 */ void *vtable;      // = 0x27DF80
    /* 0x08 */ TREE_NODE *node;   // 当前节点 / header(end)
};
// vtable[+0x08] = deref → TREE_PAIR*（0x11FCBC / 0x11FE9C 处 ldr x8,[x8,#8]; blr）
// vtable[+0x18] = advance（0x11FF8C）
// vtable[+0x58] = equals/end-compare（0x11FC80: ldr x8,[x23,#0x58]）
// 0x27DF80 数据 = { 0x10F480, 0x10F4A0, 0x10F4AC, 0x10F4BC, 0, 0x10F4E0, …, +0x58: 0x10F504 }
```

### 4.6 多态 value 对象 —— 置信度：中

value 为带 vtable 的多态对象，统一经 `0x579F4` 系列辅助销毁（`if(p){ [p]->vtable[1](p); }`）。观测到的 value 形态：`new(4)` int32 盒（`0x1193B8`）、`new(8)` int64/double 盒（`0x1196F8`、`str d8,[x0]` @0x120E3C）、`new(0x18)` MSString。疑似 VM 的 tagged-value 体系，需进一步分析 0x4788C/0x44B6C（16 字节 {a,b} 值对拷贝，疑似 Value={type,payload}）。

## 5. 全局对象与注册表

| 地址 | 内容 | 说明 |
|---|---|---|
| 0x26F150 / 0x26F178 | TREE_MAP vtable ×2 种实例 | .data.rel.ro |
| 0x262AF0 | MSString vtable | .data.rel.ro |
| 0x27DF00 | 全局注册表（静态初始化为 0，+0x18=0x10E6FC） | `0x10D65C` 经 `0x10C570` 取条目并写 `entry+0x18=0x40/0x20`（特性标志位） |
| 0x27DF80 | 树迭代器 vtable | 见 4.5 |
| 0x2C3438 | 256 项分片互斥锁表 | RAII guard 析构解锁 |

## 6. TREE_MAP 使用面（41 个 insert_or_assign 调用点）

统一模式 `find(0x11FE50) → miss → new key/value → 0x11FC30`。map 在父对象中的位置：

- 内嵌：父+0x08（0x1193D0）、父+0x18（0x68FFC wrapper、0x150600）、父+0x30（0x119888）、父+0x58（0x119710）
- 指针字段：[p+0x10]（0xFA468）、[p+0x18]（0x11A628）、[p+0xC0]（0x11A79C）、[p]（0x11A938、0x150E1C）、[p+0x90]（0x151A84 区域）
- 加锁保护：`0x126030` 调用点前对 `[x0+0x28]+8` 做 pthread_mutex_lock

逐点上下文见 `callers_ctx.asm`（1,107 行）。

## 7. 操作函数族（TREE_MAP 方法表）

| 地址 | 功能 |
|---|---|
| 0x11FC08 | ctor（vtable=0x26F150 实例） |
| 0x12005C | ctor（vtable=0x26F178 实例） |
| 0x11FC30 | insert_or_assign |
| 0x11FE50 | find（thunk → impl 0x10E834） |
| 0x11FE48 | size（thunk → [impl+8]） |
| 0x11FE58/0x11FE60 | begin/end 迭代器（thunk） |
| 0x11FE68 | erase（销毁 key/value → free pair → 摘节点） |
| 0x11FF04 | 遍历收集（迭代至 end，经 vtable[+0x58] 判停） |
| 0x120084 / 0x120110 | dtor / dtor+delete |

## 8. 局限

- stripped 无符号、无反编译器；函数命名为语义推断。
- +0x00 vtable 各槽位的具体语义（除析构外）未逐槽验证 —— 中置信度。
- VM 字节码格式、字符串解密算法、JNI 注册的实际 native 方法表未展开。
- 多态 value 的完整类型体系（4.6）仅采样确认。

## 附：工作区产物

| 文件 | 内容 |
|---|---|
| `full_disasm.txt` | 全量反汇编（436K 行） |
| `func_11fc30.asm` | 目标函数体 |
| `callees.asm` / `callees2.asm` | 一/二层 callee |
| `callers_ctx.asm` | 41 个调用点上下文 |

---

# 附录 A：加密字符串批量还原（2026-09-06 追加）

## 方法

解密函数族（5 个变体，各带独立密钥流）：`0x12B904 / 0x12BFA8 / 0x12C648 / 0x12C9A4 / 0x12CF90`，共 2,685 个调用点。函数体被 MBA 混淆 + 计算式间接跳转保护，手工还原算法成本高，改用 **Unicorn 2.1.4 模拟执行**：

1. 映射两个 PT_LOAD 段 + .bss，手工应用 7,903 条 R_AARCH64_RELATIVE 重定位；
2. GLOB_DAT/JUMP_SLOT 导入槽（228 个）填入 hook 窗口，按 dynsym 名称在 Python 侧实现 libc/pthread 语义（malloc 堆、TLS key、memcpy 等）；
3. `svc #0` 钩子返回 0（绕过反调试 syscall）；`mrs TPIDR_EL0` 指向伪造 TLS（栈金丝雀一致）；
4. 调用点密文两种模式均覆盖：立即数逐字节写入 new[] 缓冲（含 `ldr d/q` 从 .rodata 拷贝）、`add x0,xR,#off` 直接指向 .rodata 密文；
5. 单持久实例顺序解密 2,685 条。

## 结果

- 提取密文 2,358 条（其余 327 条为 bss 运行时填充等不可静态提取模式）；
- 成功模拟解密 2,325 条；可打印明文 2,325 条中 2,218 条 len≥2，去重后 **1,308 条独立字符串**；
- 各解密函数可打印率 99.7%–100%（交叉验证样本："data"、"op"、"bd"、"v04.09.05"、"rp_fail_record"）。

## 内容性质

- **反 Root/反 Hook 指纹库**：`/data/adb/magisk|ksu|lspd|kpatch|apd|edxp`、`/data/adb/modules/riru_lsposed|taichi`、`.edxposed.manager`、`/cache/magisk.log`、`/debug_ramdisk`、`/data/magisk.apk` 等；
- **群控/自动化检测**：`/data/local/tmp/minicap(.so)`、`org.autojs.autojs`、`simplehat.clicker`、`/data/mock/`（虚拟定位）；
- **历史 ROOT 利用包**：`com.baidu.easyroot`、`com.mtk.user2root`、`com.rd.user2root`、`hh.root` 等；
- **业务端点**：`/aweme/v1/poi/recommend`、`/dc/rnd(_tob)`、`/common_config/v1/info(_tob)`；
- **JNI 反射签名**：`()Landroid/app/ActivityThread;`、`(Ljava/lang/ClassLoader;)I` 等完整方法签名集。

完整清单见 `strings_decrypted.txt`（站点地址 + 解密函数 + 明文），原始数据 `decrypted_strings.json`。

## 工具链（可复用）

| 文件 | 用途 |
|---|---|
| `emu.py` | 单条解密 CLI：`python3 emu.py <func> <hex> <len>` |
| `batch_decrypt.py` | 批量提取 + 批量模拟解密 |

---

# 附录 B：JNI 注册表还原（2026-09-06 追加）

## 结论（高置信度）

`libmetasec_ml.so` 的全部 JNI 动态注册只有 **1 个类、1 个方法**：

| 项 | 值 |
|---|---|
| Java 类 | `com/bytedance/mobsec/metasec/ml/MS` |
| 方法名 | `a` |
| 签名 | `(IIJLjava/lang/String;Ljava/lang/Object;)Ljava/lang/Object;` |
| native 函数 | **0x12FB84**（thunk：丢弃 jclass、参数左移后进入反调试 stub，真实逻辑自 0x12FC08→0x12FCE0 起） |
| RegisterNatives 调用点 | 0x12F92C（函数 0x12F5D0 内，由 JNI_OnLoad+0xEAC @ 0x13AA80 调用） |
| 注册条数 | 1（0x12F924 `mov w3,#1`） |

即 Java 侧入口为 `com.bytedance.mobsec.metasec.ml.MS.a(int, int, long, String, Object)`。

## 证据链

1. **唯一性**：全 .so 仅一处 `ldr xN,[xN,#0x6B8]`（JNIEnv vtable slot 215 = RegisterNatives）后接 `blr`；dynsym 无任何 `Java_*` 导出（仅 JNI_OnLoad，sym#226）。
2. **类名**：JNI_OnLoad 0x13A344 处 `adrp x9,0x27e000; ldp x20,x22,[x9,#0xA08]` 读静态槽，再加 0x13A698–0x13A704 常量链算出的 delta `0xFFFFFFFFFF408E20`；手工求值 x22 = 0xDF9D2D + delta = **0x202B4D**，该处静态明文即 `com/bytedance/mobsec/metasec/ml/MS`（无重定位、无需模拟）。
3. **方法名**：注册函数内 `bl 0x12FABC`——2 字节密文 `0x10C4` 经解密函数 0x12B904 模拟还原为 `"a"`。
4. **签名**：`bl 0x12FB08`——60 字节密文（.rodata 0x2026A0 起 48B + 0x202700 起 8B + 立即数 0xD7BA66C6）经 0x12BFA8 模拟还原为完整签名。
5. **fnPtr**：0x12F90C `adrp x8,0x12F000; add x8,x8,#0xB84` → 静态可得 0x12FB84，存入 JNINativeMethod.fnPtr。

## 过程备注

- 完整模拟 JNI_OnLoad 的路径上：修复重定位应用缺陷（GLOB_DAT @0x27CD68 指向 JNI_OnLoad 自身、109 条 ABS64 此前未处理）后，GetEnv(0x10006) 已成功打通；继续执行在 0x13B496 处被**运行时代码解密 stub**（svc/NZCV 反模拟 + 明文写回后跳入 2 对齐地址）阻断，静态字节与运行时指令流在此处不同。
- 因此改用「静态定位 + 局部模拟」混合方案完成注册表还原；`jni_onload_emu.py` 保留为可复用的 JNI 模拟骨架（假 JavaVM/JNIEnv vtable 全部可观测）。
- 保护方案特征：O-MVLL 风格——字符串加密（5 密钥流变体）、代码段运行时解密、CRC 自校验（0x20190512→0x77DF8B85）、反模拟 NZCV 检查、`__stack_chk_fail` 全覆盖。

产物：`jni_onload_trace.json`（注册表 + 证据地址）。

---

# 附录 C：字符串解密算法黑盒提取（2026-09-07 追加）

## 结论（高置信度）

5 个解密桩全部是**单字节 XOR、周期 8 的固定密钥流**，与输入长度无关、逐条之间无状态。即：

```c
void decrypt(uint8_t *buf, size_t len) {   // 5 个函数各自只有 key[8] 不同
    for (size_t i = 0; i < len; i++) buf[i] ^= key[i & 7];
}
```

| 解密函数 | key[8]（hex） | 调用点数 | 离线复算验证 |
|---|---|---|---|
| 0x12B904 | `a5 10 71 c7 50 90 e1 b1` | 494 | 494/494 ✓ |
| 0x12BFA8 | `a5 12 81 d7 60 10 71 b2` | 483 | 483/484（1 条见下注） |
| 0x12C648 | `b5 20 91 e7 40 a0 e3 b6` | 490 | 490/492（2 条见下注） |
| 0x12C9A4 | `a7 50 78 c9 60 97 ef f1` | 387 | 387/387 ✓ |
| 0x12CF90 | `35 1f 7f f7 90 9f e1 b1` | 500 | 500/501（1 条见下注） |

验证方法：对上表密钥做纯 Python XOR 复算 `decrypted_strings.json` 全部 2,358 条记录，**2,354 条与模拟器输出逐字节一致**。4 条「不一致」均为原模拟记录尾部多读出了脏字节（如 `'ap'` vs `'ap\x??'`），XOR 复算结果反而更干净，不影响算法结论。

**实践意义**：今后遇到这 5 个桩的密文不再需要 Unicorn，直接按上表 XOR 即可；密钥流与长度无关也意味着可从任意偏移起解。

## 提取方法（黑盒，无需还原 MBA）

`extract_algo.py` 不向反汇编要算法，而是向真实函数「提问」：

1. 输入 `0x00*N` → 输出即密钥流 K（XOR 型函数的性质 `f(0)=K`）；
2. 输入 `0x01*N`、`0x02*N` → 验证 XOR 线性（`f(x)^f(0) == x` 处处成立）；
3. len=32 与 len=64 前缀对比 → 确认 K 不依赖长度；
4. 对 K 做模式识别：5 个函数全部命中 period=8 周期。

5 个函数均通过全部检验（XOR-type: True、len-independent: True），无任何非线性分支。

## 产物

| 文件 | 内容 |
|---|---|
| `extract_algo.py` | 黑盒算法提取脚本（复用 `emu.py` 的 Unicorn 加载骨架） |
| `extract_algo_output.txt` | 5 个函数的完整提取输出（密钥流 + 模式判定） |

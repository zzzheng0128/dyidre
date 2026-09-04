# 350.101 `.init_array` / 完整性与环境风险链 IDA 标注

目标数据库：

- `/Users/freeman/project/douyin/dyidre/materials/350101/libmetasec_ml.so.i64`
- 原始样本 SHA-256：`2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76`
- 所有地址均为模块 RVA，当前 imagebase 为 `0`。
- 本轮只修改 IDA 数据库中的名字、类型与注释，没有修改原始 SO 字节。

## 本轮落库内容

- 可重复脚本定义 35 个函数名：覆盖早期初始化、映像完整性、signal-loop、自修改代码缓存探针、JNI引用槽生命周期、setting 值写入、native/JNI/ART hook、TracerPid、线程名、root 路径和 maps 快照等链路。
- 11 个全局/数据对象名，并在 12 个关键定义处记录生命周期、结果流或 VMP 角色。
- 6 个 Local Types：2 个枚举与 4 个结构体/结构视图。
- 30 个函数原型，以及函数/关键地址处的中英文证据边界注释。

可重复执行脚本：

- `/Users/freeman/project/douyin/dyidre/skills/ida_apply_integrity_guard_350101.py`
- 脚本先核对 `0x59294`、`0xD7D84`、`0xD875C`、`0xD86D0` 四个代码锚点；版本不匹配时拒绝写入。
- 只替换 IDA 默认名、脚本自己的名字，以及已知错误旧名 `ptrace_disable[_350]`；其他分析者命名会保留。

`0xD875C` 是本次可重复脚本新增的寄存器级尾跳转名称；修改脚本本身不表示任何现有 IDB 已自动保存，需在匹配样本的 IDA 中重新执行脚本后才会写入数据库。

## 关键结构

### `METASEC_INTEGRITY_GUARD_350` (`0x88`)

| 偏移 | 字段 | 证据含义 |
|---:|---|---|
| `+0x08/+0x0C` | `expected_machine_id` / `observed_machine_id` | ELF machine 期望值与运行时观测值 |
| `+0x10/+0x18` | `image_base` / `image_end` | 被检查的映像区间 |
| `+0x20/+0x28` | `expected_image_xor` / `image_check_length` | VMP 完整性检查输入 |
| `+0x30` | `signal_loop_failed` | signal-loop 检查失败状态 |
| `+0x38` | `linker_callback_state` | 实际保存运行时 callback 地址；参与格式化上报和 linker 区间归属分类 |
| `+0x40` | `first_check_time` | 作为有符号 64 位值写入 JSON；非 VMP 静态写入源尚未确认 |
| `+0x48/+0x4C` | `link_verify_code` / `link_verify_aux` | 前者写入 report item6；后者等于 1 时追加风险条目 9 |
| `+0x50` | `integrity_risk_bits` | 完整性执行/风险发布位 |
| `+0x58/+0x60` | 两个 mutex | signal 与 integrity 检查同步 |
| `+0x68..+0x7C` | setting/package guard 状态 | 初始化值按32位拆分写入四个setting key；VMP写入语义待trace |
| `+0x80` | `jni_ref_slot` | 指向 `METASEC_JNI_GLOBAL_REF_SLOT_350`，用于持有带锁的JNI global ref |

### `METASEC_JNI_GLOBAL_REF_SLOT_350` (`0x20`)

该对象并非 guard 专属，token 等其他上下文也复用同一构造器，因此不宜命名为 package-check object：

| 偏移 | 字段 | 已确认行为 |
|---:|---|---|
| `+0x00` | `vtable` | 析构与 deleting-destructor 虚表 |
| `+0x08` | `state` | 构造时清零；精确状态语义待调用点/trace |
| `+0x10` | `global_ref` | 构造时为 NULL；析构时用当前线程 `JNIEnv->DeleteGlobalRef` 释放 |
| `+0x18` | `mutex` | 构造时分配并初始化，析构时通过虚函数释放 |

### `METASEC_HOOK_RISK_CONTEXT_350` (`0x2C0`)

本版本通过调用点反复确认：

- `+0xD8`：native API 扫描 mutex
- `+0xE0`：JNI table 扫描 mutex
- `+0xE8`：Java/ART method 扫描 mutex
- `+0x2BC`：4 字节 hook mask

因此不能继续套用旧版 `COOKIE_RISK_DATA4`。旧结构尺寸不足，且会把三个 mutex 错显示为签名引用字段。

### `METASEC_REPORT_ITEM6_GUARD_VIEW_350` (`0x128`)

这是局部 overlay，不声称完整恢复对象：只命名当前链路中被稳定读写的 `has_su`、`err_module`、`jni_is_debug`、`tracer_pid_value` 与 link-verify 数组字段；其余字节明确保留为 unknown。

## 重要更正

- `0x15AFFC` 已更名为 `deleteCompositeVectorState_350`。函数只调用内部析构，再 `free(object)`；没有 ptrace syscall，也没有关闭调试的行为。旧名 `ptrace_disable` 属于误标。
- “检测到风险”不等于“当场退出”。当前链路多数把结果写入 risk object、report/tree、mask 或 guard 位，随后由签名/策略流程消费。只有具体调用点证明控制流终止时，才能标成 kill/abort。
- `runMetaIntegrityXorVM_350` 与 `runMetaPackageCheckVM_350` 只按已证明的包装层职责命名；内部 VMP opcode 语义仍需静态 handler 与动态 trace 双证据逐项恢复。

## package-check VMP 的新增边界证据

`runMetaPackageCheckVM_350` 在 `0xD7EBC` 明确构造两项 native 参数块：`[0]=guard`、`[1]=0xD875C`；`0xD7EE8` 随后调用：

```text
exeVMInner(
    program = 0x1EA850,
    args    = { guard, 0xD875C },
    auxA    = 0x262800,
    auxB    = 0x262890,
    scratch = native stack area
)
```

`0xD875C` 的原始 12 字节为 `MOV X2, X0; MOV X0, X1; BR X2`。因此它只证明：进入该 bridge 时的 target 来自 `X0`，目标接收原 `X1` 作为自己的 `X0`，并以尾跳转转移。它不写内存、不改 `LR`；更不能据此推断该目标的业务语义、完整参数个数或返回类型。为避免把这项局部寄存器证据扩大成 callback ABI，`0x1EA850` 没有加入 native wrapper ABI 清单。

本轮给三个数据对象落了证据边界名称：

| RVA | 名称 | 已证明内容 |
|---:|---|---|
| `0x1EA850` | `g_packageCheckVmProgram_350` | package/environment VM 程序起点 |
| `0x262800` | `g_packageCheckVmAuxTableA_350` | 作为 `exeVMInner` 的第三个 native 参数传入 |
| `0x262890` | `g_packageCheckVmAuxTableB_350` | 作为 `exeVMInner` 的第四个 native 参数传入 |

ELF program header 证明首个 `PT_LOAD` 为 `file_off=0, vaddr=0`，覆盖到 `0x25EA20`，因此 `0x1EA850` 在本样本中可直接映射到同值文件偏移。真机日志已经观测到相邻的下一 VM 入口 `0x1EC4D0`；在候选区间 `[0x1EA850,0x1EC4D0)` 中：

- 共 `0x1C80` 字节、1824 个 32 位 word；末尾 `0x1EC4CC` 为全零 word。
- 1807 个 word 已落入当前 runtime 有实现的 opcode/二级 selector，17 个尚未实现。
- 未实现集合为 top-level `0x00/0x06/0x09/0x3D`，以及 `op=0x11` 的 selector `0x0D/0x20/0x21`。
- `0x00` 只出现在末尾零 word；这与程序尾部哨兵相符，但尚不能仅凭静态扫描定义其 handler 语义。

这组结果强烈支持该候选区间主要是 VM 指令流，但仍只是**语法覆盖率**，不是执行可达性证明。尤其 `auxA/auxB` 的表项外观不能直接当作 native 函数指针；其解码方式必须从对应 handler 或该入口的动态 trace 得出。

离线复核现在可以直接运行：

```bash
PYTHONDONTWRITEBYTECODE=1 python3 \
  dyidre/versions/350101/vm_generic_350101/native_vmp_runtime.py \
  --validate-package-check-static-candidate-350 \
  dyidre/materials/350101/libmetasec_ml.so
```

该校验先固定整份 SO 的 size/SHA-256，再固定 callsite、span 边界、code SHA-256、1824 个 word 的 selector-gated 覆盖率、17 个未实现项分布和末尾零 word；它不会执行 `exeVMInner`，不会构造 `pParam`，也不会模拟 bridge 或推导 guard 字段写入。

当前真正缺的不是“再扫一遍所有 word”，而是用 `vm_code_off=0x1EA850` 收一条执行 trace，记录每次 VM load/store 的有效地址。只有当有效地址落入本次 native `guard` 对象 `[guard, guard+0x88)`，才能把 `+0x40/+0x68..+0x7C/+0x80` 的写入者和具体 opcode 闭合。

## `.init_array` 链的阅读方式

```text
.init_array / early constructor
    -> initEarlyRuntimeGuard_350
       -> 路径/环境字符串表初始化
       -> initializeIntegrityMonitor_350
          -> guard 字段初始化与 ELF machine 检查
          -> 映像边界、期望 XOR/长度装载
          -> signal-loop 与延迟完整性任务

业务/报告阶段
    -> collectHookAndDebugRisks_350
       -> native API 地址归属扫描
       -> JNIEnv 函数表扫描
       -> ART method / Java debug 扫描
       -> TracerPid、线程名、root 路径、maps 等风险项
       -> 写入 report/tree/mask，影响后续风险材料与策略分支
```

## 证据等级

- **已确认**：调用关系、字段读写偏移、互斥锁位置、映像范围与 XOR/长度输入、风险结果被写入聚合结构。
- **高可信语义名**：名称直接描述当前版本可见的数据流，不声称算法实现已经完整恢复。
- **待动态确认**：各检测位最终怎样改变每一种签名结果、服务端策略或退出路径；VMP 内部每个 opcode 的精确语义。

后续继续分析时，应以该结构体布局为 350.101 基线，将真机 trace 的 `tid/LR/参数/返回值/内存副作用` 映射回这些聚合入口，不要用旧版字段名直接迁移。

## 会影响后续结果的全局状态

| RVA | 名称 | 后续影响 |
|---:|---|---|
| `0x2BBDF8` | `gGlobalLinkerInfoRef` | 进程级 REF，内部持有 guard；检查器和报告器共同读取 |
| `0x2BBE80` | `g_early_runtime_time_350` | 先存 start，JNI_OnLoad 后改成 elapsed，进入启动耗时材料 |
| `0x27DC98` | `g_sig64_guard_state_350` | `-1/1/3/1213` 状态机；`0xDD878` 将其写入 JSON 报告 |
| `0x27DDF0` | `g_meta_check_len_350` | 写到 guard `+0x28`，作为完整性 VMP 长度输入 |
| `0x27DDF4` | `g_meta_expected_xor_350` | 写到 guard `+0x20`，作为完整性 VMP 期望值 |
| `0x2C0FB8` | `g_cachedElfMachinePathPrimary_350` | 首选 ELF header 探测路径缓存，本身不是检测结果 |
| `0x2C0FC0` | `g_cachedElfMachinePathFallback_350` | 首选失败时使用的备用路径缓存 |
| `0x2C0E58` | `g_signalProbeContextActive_350` | 控制 signal handler 上下文恢复，不是计数器 |
| `0x27EDF8` | `g_httpSignSamplingCounter_350` | HTTP 签名调用抽样计数；每次构建签名头递增，以 `%10` 选择耗时及设备信息采样窗口 |

计数器方面，`runRelocatedSignalLoopProbe_350` 的返回值会与常量 `10` 比较，但没有持久化全局计数器。计数实际位于复制探针的 `X4/X5` 寄存器中，最终返回 `X4`。

此外还存在一个与 signal-loop 无关的持久化计数器 `g_httpSignSamplingCounter_350`：

- `counter % 10` 命中位图 `0x291`，即余数 `0/4/7/9` 时，记录本次签名开始时间；结束后将 `elapsed_ms` 以 64 位值写入设置键 `fd8d1a41d3c56026d47f1f8ba146eb99`。
- 命中位图 `0x14B`，即余数 `0/1/3/6/8` 时，调用一次设备信息刷新/采样逻辑。
- 每次 `buildSignedHttpHeadersInner_350` 都做普通的 `counter + 1` 全局写；当前静态代码未见锁或原子指令，因此它是近似调度计数，而不是严格的跨线程序号。

## 内存值与 offset 如何进入计算

这里要区分“字段 offset”与“混淆算术”。下列 offset 已有明确的数据流证据：

| 来源 | 运算/用途 | 后果 |
|---|---|---|
| `guard+0x0C` | 选择是否清除候选 linker 地址的 bit0；Android 29+ 再以 `process_vm_readv` 读取 4 字节 | 改变报告中的 linker/架构材料 |
| `guard+0x10/+0x18` | 作为 `candidate_lr` 的开区间上下界；实际 LR 从 `returnLR_frame+8` 读取 | 越界进入 `exeCheckFailed1`；该模板覆盖多个敏感入口 |
| `guard+0x20/+0x28` | VMP 完整性程序的期望 XOR 与映像长度输入 | 改变完整性校验结果 |
| `guard+0x30` | 与 1 比较 | 命中时追加风险条目 12 |
| `guard+0x38` | 与 page size、linker 区间比较并编码为 0/1/2；同时格式化到报告 | callback 地址异常会改变 JSON 分类值 |
| `guard+0x40` | `SCVTF` 转 double | 直接写入 JSON；当前只确认消费者，写入者仍待 VMP trace |
| `guard+0x48` | 作为整数传给 report item6 属性写入器 | 直接进入 link-verify 报告字段 |
| `guard+0x4C` | 与 1 比较 | 命中时追加风险条目 9 |
| `guard+0x68/+0x70/+0x78/+0x7C` | 分别按32位值写入 `45ca7e...`、`f866b1...`、`cede08...`、`30c8cb...` 设置项 | 初始化时均为0；setting树保存值副本，并非对guard字段的实时引用 |

`setUpdateSettingItemValue_int` 会在树中已有 key 时原位覆盖 4 字节值；key 不存在时复制 key，并另外分配 4 字节 value。64 位版本 `setUpdateSettingItemValue_i64_350` 也是同样模式，只是 value 为 8 字节。因此上面几个字段在初始化阶段写入的是**快照**。后续若 guard 字段被 VMP 修改，必须再次调用 setter 才会反映到 setting 树。当前已静态证明 `guard+0x50` 在完整性 VM 返回后会重新发布；`+0x68..+0x7C` 的 350.101 后续发布点仍需动态内存写 trace 确认。

签名主流程还会留下两项按值保存的派生状态：

- `0x14A468` 对当前中间输出 tree 的序列化 `MEM_BLOCK` 计算 CRC32，`0x14A490` 将结果写入设置键 `167774bf518c11948aa0784351ccf5a9`。这是请求内容/中间树的派生快照，不是固定常量。
- `0x14A508` 在 F8 managed builder 返回后，把常量 `100` 写入设置键 `2e8ab1223d07836ad4fc65fc581b4808`。可以确认写入时序和值，但目前不能仅凭静态位置断言它是成功码、版本号还是阶段标记。

旧版 `/Users/freeman/project/douyin/z/ws/mm64.cpp` 对这四个 hash 有 `field2/field3/CRC32` 一类标签，但它只能作为跨版本候选线索。本轮没有仅凭旧版标签给 350.101 的 `+0x68..+0x7C` 强行定业务名。

### 自修改 signal-loop 探针

`0xB58C0..0xB5B2F` 共 `0x270` 字节被复制到匿名 RWX 页。首次执行前，`flushCodeCacheRange_350` 根据 `CTR_EL0` 的 D/I cache line 大小执行 `DC CVAU -> DSB -> IC IVAU -> ISB`。

探针内部随后故意在循环中不做 cache maintenance：

1. `X4`、`X5` 是两个寄存器计数值。
2. `captureProbeLrInX7_350` 把调用点 LR 留在 `X7`。
3. `[X7-8]` 读取 `ADD X5, X5, #1` 的机器码；第二次 `X7-8` 得到 `ADD X4, X4, #1` 的指令槽。
4. 把前者的 4 字节指令字写到后者，形成运行中代码覆盖。
5. 循环内不刷新 I-cache；最终恢复原指令并返回 `X4`。

因此 `-8` 不是随意常量，而是利用 AArch64 固定 4 字节指令和 `BL` 返回地址做的自定位。真实 CPU 的取指/缓存可见性与某些模拟器的“写完立即生效”模型不同：上层以返回值是否为 `10` 把差异写入 `guard+0x30`。这是“内存副作用 + offset + 指令缓存行为”共同参与检测的实例。

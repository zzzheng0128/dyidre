# 350.101 native VMP：从入口样本继续恢复的分析记录

## 目的与边界

这份记录保存一种可迁移的分析过程：先用 `exeVMInner` 入口事件确认“哪个
wrapper 调用了哪个 VM program”，再逐层收集 fetch、dispatch、handler 和状态
副作用证据。350.101 的地址与结论只是当前版本基线；升级版本时复用步骤，不
直接复用 offset 或 opcode 标签。

当前原始证据是 `dyidre/versions/350101/vmp_handler_log`。它只证明入口调用关系，不
证明 VM program 长度、可达控制流、opcode 语义或完整覆盖。

## 第一层：入口地址归一化

已知当前版本 `exeVMInner_350 = libmetasec_ml.so + 0x4cc10`。每条 stackplz
事件在入口处读取：

- `PC`：实际命中的 `exeVMInner` 地址；
- `X0`：入口 ABI 中的 `vmCode` 指针；
- `LR`：调用该 VM program 的 native wrapper 返回地址；
- `X1`：`pParamList`；
- `X2/X3`：VM 数据区；
- `X4`：`VmParam64`。

ASLR 下不能直接比较绝对地址。逐条事件按以下公式归一化：

```text
module_base = PC - 0x4cc10
vmCode_off  = X0 - module_base
caller_off  = LR - module_base
```

必须逐条计算并检查所有 `module_base` 是否一致，不能从日志中随便挑一个
看起来像基址的地址。入口处的 `X5` 还不是可靠的 VM PC；只有进入已经确认的
取指位置后，才能按该位置的寄存器约定解释它。

解析器只接受 `event=uprobe`，并在 `arg_name` 存在时要求它等于指定入口
offset；同时交叉检查 JSON 顶层的 `PC/LR` 与寄存器快照，避免把混合 probe
日志或截断事件算进当前入口样本。

机械提取命令：

```bash
python3 dyidre/scripts/analyze_vmp_entry_uprobes.py \
  dyidre/versions/350101/vmp_handler_log/vmp_entry_350101.log \
  --entry-offset 0x4cc10 \
  --print-format markdown
```

当前日志共有 145 条可用入口事件，全部给出同一模块基址
`0x6c070d0000`。归一化后的调用簇为：

| vmCode offset | caller LR offset | 次数 | 当前能下的结论 |
|---:|---:|---:|---|
| `0x1f7860` | `0x124e34` | 55 | 目标 material wrapper 到目标 VM program 的入口链成立 |
| `0x1ec670` | `0xd95cc` | 54 | 独立 VM program/caller 簇，语义另证 |
| `0x1ecaf0` | `0xd964c` | 27 | 独立 VM program/caller 簇，语义另证 |
| `0x1f6670` | `0x11999c` | 8 | 独立 VM program/caller 簇，语义另证 |
| `0x201800` | `0x12acf8` | 1 | 单样本候选，只能记录，不能命名语义 |

日志第一条原始事件本身是 `vmCode=0x1ec670`、`caller=0xd95cc`。先前单独
粘贴的目标样本则是 `PC=base+0x4cc10`、`X0=base+0x1f7860`、
`LR=base+0x124e34`；两者都正确，只属于不同调用簇。

### 完整入口寄存器的可选闭合检查

对于当前 exact-SO 样本，可在上述纯解析命令后加
`--validate-known-wrapper-abi-350`。该开关仍只读取归档日志，但会要求
`stack_str` 同时给出 `PC/LR/SP/X0..X4`，并在顶层 `SP` 存在时与寄存器
快照交叉核对。随后以 `PC-0x4cc10` 推出基址，要求同一条记录同时满足：

```bash
python3 dyidre/scripts/analyze_vmp_entry_uprobes.py \
  dyidre/vmp/vmp_entry_350101.log \
  --entry-offset 0x4cc10 \
  --validate-known-wrapper-abi-350 \
  --print-format markdown
```

```text
LR == base + callerLR
X0 == base + vmCode
X2/X3 == base + vmData1/vmData2
X1 == SP + parameter-window offset
X4 == SP + VmParam64 offset
```

当前归档日志的结果为 136 条 closed ABI、9 条仍未闭合、0 条寄存器关系
错误：`small_1ec670=54`、`small_1ecaf0=27`、`material_1f7860=55`；剩余
`0x1f6670/0x11999c=8` 与 `0x201800/0x12acf8=1` 只计入 entry-only，绝不因为
它们未进入 manifest 而报作损坏记录。这个检查不读取 pParam 内存、不解释
`X9/X10`、不调用 bridge，也不证明任何 VMP 输出或 opcode 语义。

### 已闭合 wrapper ABI 的程序化边界

`native_vmp_runtime.py` 中的不可变
`KNOWN_NATIVE_VMP_WRAPPERS_350` 只登记同时拥有入口事件和 wrapper 静态
栈布局证据的三项：`0xd9574/0x1ec670/0xd95cc`、
`0xd95f4/0x1ecaf0/0xd964c`、
`0x124dd4/0x1f7860/0x124e34`。`resolve_native_vmp_wrapper_abi_350()` 对
`entry/vmCode/callerLR` fail-closed；
`validate_native_vmp_wrapper_abi_350()` 再逐项核对两个 data 指针、参数窗口、
`VmParam64` 窗口、`funBridge` 和结果形态。两者都不解释 VMP，不生成
material，也不把旧 `z/ws` 的 `VM_XMEDUSA` 聚合结构作为 350.101 输入。

该 manifest 还被 `metasec_so_identity.md` 中的 exact identity 约束：
`size=0x2bb410`、SHA-256
`2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76`。
`validate_native_vmp_image_350()` 只在本地 byte sequence 上验证该身份；
`validate_native_vmp_wrapper_image_350()` 才同时接受 canonical image 和
canonical wrapper。二者都不加载或执行 SO。

两条 small wrapper 的静态 wrapper-body/`exeVMInner` 证据也以只读 metadata
保留：`VmParam64` 的三 qword 为 `funBridge@+0`、`pParam-anchor@+8`、
`outer-LR@+0x10`，anchor 分别是 `SP+0x4a0` 与 `SP+0x3c0`；`0xd9980` 仅记录为
`mov x2,x0; mov x0,x1; br x2` 的尾跳转 ABI。它不是 generic callback，且
entry-context offsets 不能被误用为独立、零初始化的 pParam 输入结构。
`material_1f7860` 对这些新增 metadata 仍明确为 unknown。

本地 trace 只补充“是否走过 bridge”的观测，不提升为通用 VMP 语义：
`runs/350101/gumtrace/latest/gumtrace_4cc10.log` 的 `1ec670` 路径实际进入
`0xd9980` 七次，最后向 `pParam+0` 写入 `0x71a975a0`；而 archived
`full_once` 中 `1ec670` 与 `1ecaf0` 都有最终 `pParam+0` 写入（分别为
`0x71ac15a0` 与 `0`），却没有 `0xd9980` 命中。两个来源的结果不同，因此
manifest 绝不把本地值、bridge 次数或 callback target 回填为默认实现。

`0x1f6670/0x11999c` 与 `0x201800/0x12acf8` 当前仍只有 entry 证据，故刻意
不进入 manifest。缺少 pParam 前后镜像、`funBridge` 调用及外部内存 delta 前，
也不能把两条 small wrapper 的静态 opcode 覆盖误写成 ABI/副作用已执行。

### 已落地的窄范围 CF82 回放桥

`(vmCode=0x1ec670, caller=0xd95cc)` 现在只在一个已闭合的 managed
wrapper ABI 上使用：`CF82 @ 0x16fe08` 不读取 managed 参数，调用
`0xd9574`，并将其 `W0` 写入 managed slot2。`0xd9574` 固定传入
`exeVMInner(vmCode=0x1ec670, out=SP+8, data=0x262980/0x2629c0, param=SP+0x10)`，
随后从该输出窗口读回 `W0`。

归档 trace 的该路径读取 SO 可变 `.bss + 0x2c1040` 并产生一个 32 位结果；该
存储不是常量、也不是 VMP 语义的通用替身。因此
`managed_vm_runtime_350101` 只提供 `native_globals_u32[82] -> slot2` 的显式
回放输入，缺失即失败：不嵌入捕获值，也不把静态 `0x1ec670` 的全 word 覆盖误称为
任意运行状态下的通用执行器。

## 第二层：由 VM program 分组，而不是混在一起追

入口聚类以后，每个 `(vmCode_off, caller_off)` 单独建采集批次。至少保存：

```text
版本 / SO 哈希 / 加载基址 / 入口 offset / vmCode offset / caller offset
PID / TID / comm / 触发场景 / 原始日志路径 / 采集工具与配置
```

同一 `vmCode_off` 如果出现多个 caller，说明它可能被多个业务 wrapper 复用；
同一 caller 如果选择多个 `vmCode_off`，说明 wrapper 内可能有模式选择。只有
重复触发仍稳定的一对一关系，才能作为后续静态定位锚点。

## 第三层：从入口走到 fetch 和 dispatch

入口只告诉我们“进了哪个程序”。要恢复 ISA，下一批证据应分开采：

1. 在已静态确认的取指点记录当前 VM PC、读取的 32-bit word 和下一 VM PC。
2. 在 dispatch 前记录原始 word、解码后的 selector/opcode 和 native handler
   目标。
3. 以 `(vmCode_off, vm_pc_off, word, handler_off)` 为主键去重；循环次数只作为
   热度，不重复计为新 opcode 证据。
4. 控制流指令额外保存 taken/fall-through 两类后继；只看到一种路径时，不能
   推断完整条件。

在 350.101 已知布局中，`0x4cd94` 是可用于解释当前 VM PC 的 fetch 证据点，
`0x4cdf4` 附近包含间接 `br x8` dispatch。后者是函数内部指令点，不是函数
入口：用函数级 `Interceptor.attach` 给这类地址安装 trampoline 会破坏寄存器
或控制流，已有崩溃样本落在 `libmetasec_ml.so+0x56284`。指令级观测应使用
uprobe、硬件断点、单步或不会改写该基本块的 trace 机制。

## 第四层：恢复一个 opcode 的证据闭环

一个 opcode/selector 只有满足以下闭环，才从“候选”提升为“已恢复”：

1. **静态 handler 边界**：确认 dispatch 目标、入口和所有真实退出；避免把
   相邻扁平化分支合进来。
2. **字段解码**：从 handler 中逐项反推 word 的 bit slice、符号扩展和立即数
   组合，不能套用邻近 opcode 的 `imm16` 布局。
3. **动态副作用**：至少记录执行前后 VM 寄存器、相关内存和下一 VM PC；load、
   store、算术和分支分别验证其核心副作用。
4. **多样本复核**：使用至少两个不同 operand/地址/分支结果；单一 word 只能
   证明该实例，不能证明通用 decoder。
5. **runtime 单测**：把真实 word 和初始状态输入 `native_vmp_runtime.py`，比较
   寄存器、内存和下一 PC；失败时保留 `UnsupportedOpcode`，不做宽松猜测。
6. **回归 trace**：用独立 trace 回放，确认不是对首批样本过拟合。

建议为每项保留以下状态：

```text
unseen -> observed -> handler-mapped -> fields-decoded
       -> side-effects-verified -> runtime-tested -> regression-verified
```

“latest trace 没有未实现 opcode”只代表该 trace 的动态覆盖闭合；“某个静态
program span 的所有 word 都可解码”只代表该 span 的语法覆盖。两者都不等于
350.101 所有 VM program、所有 selector 或所有运行路径已经恢复。

## 第五层：后续推进顺序

后续分析按收益排序：

1. 先为五个入口簇分别取得 fetch/dispatch 样本，避免只围绕 `0x1f7860`。
2. 对现有 handler 表做静态枚举，列出“表中存在但动态未见”的目标。
3. 优先处理同时具备静态 handler、真实 word、执行前后状态的候选。
4. 每恢复一个 handler，同步更新 decoder、严格 runtime、单测和
   `opcode_recovery_350101.md` 证据账本。
5. 最后才将证据充分的名字与注释写入 IDA；未闭环项继续使用中性名称。

这样推进的核心不是追求快速给 opcode 起名，而是把入口、字节码、handler、
副作用和回归测试连成一条可重复验证的证据链。

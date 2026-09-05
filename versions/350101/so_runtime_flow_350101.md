# 350.101 `libmetasec_ml.so` 全流程、地址与数据流台账

这份文档是 350.101 的总入口。它不替代各专项报告，而是把 `.init_array`、JNI、HTTP
签名、managed VM、native VMP、完整性/环境风险和最终输出串成一条可迭代的数据流。

## 1. 适用样本与记号

| 项目 | 值 |
|---|---|
| 样本 | `libmetasec_ml.so` 350.101 |
| SHA-256 | `2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76` |
| Build ID | `025e51707b4c64f0b578e2dd7f12aa58ca94241a` |
| 地址口径 | 本文地址均为 `module RVA`，IDA imagebase 为 `0` |
| 真机换算 | `runtime_address = module_base + RVA` |

证据状态统一使用：

- **S**：静态调用、反编译、字段访问或 ELF 数据已确认。
- **D**：真机/unidbg trace 已观测。
- **V**：有独立 C oracle 或 deterministic replay，输出 byte-exact。
- **P**：推断或局部语义，只能作为下一步候选，不能直接迁移成最终命名。

## 2. SO 的整体分块

```text
ELF loader
  |
  +-- .init_array @ 0x260190
  |     +-- early runtime / integrity guard
  |     +-- 4 个 managed module 解码、绑定 CF/G、导出 F 程序
  |
  +-- JNI_OnLoad @ 0x139BB0
  |     +-- 保存 JavaVM
  |     +-- 找 MS 类继承层级、RegisterNatives
  |     +-- 缓存 Java class/method
  |     +-- 启动完整性与风险监控
  |
  +-- Java native a(...)
        +-- HTTP wrapper @ 0x14DBF4
              +-- 参数解析 / TreeMap
              +-- inner @ 0x149CA8
                    +-- native stage1/2
                    +-- managed F5/F7/F8/F13
                    +-- native VMP protected material helpers
                    +-- TreeMap -> CRLF header string

后台并行链：ELF/signal/code-integrity/hook/debug/root/maps 检查
             -> guard/risk/settings/report
             -> （是否被后续 header、签名或策略消费：未闭合）
```

设计上分成三层：普通 native C++ 负责对象、JNI、调度和容器；managed VM 负责可更新的
签名业务程序；native VMP 保护少数底层 material/helper。这样既能复用 native 容器和
系统能力，又能把高价值算法拆成两种不同的解释执行形式。

## 3. 生命周期阶段总表

| 阶段 | 主入口/关键 RVA | 主要入参 | 主要出参/副作用 | 最终用途 | 证据 |
|---|---|---|---|---|---|
| ELF 早期初始化 | `.init_array` `0x260190`, size `0x3A0` | loader 调用约定、模块映像 | 初始化全局状态；构建 4 个 managed module | 请求到来前准备 VM 与安全状态 | S |
| managed module 构建 | `0x14CEBC`, `0x152B58`, `0x1702B8`, `0x171DDC` | encoded blob、key、CF/G binding | module 指针和 F 程序句柄写入全局区 | 后续直接按 `Fxx` 调用 | S/D |
| JNI 装载 | `0x139BB0 -> 0x13A2C4 -> 0x13A320` | `JavaVM *`, reserved | 保存 VM、注册 native、缓存 class/method | 建立 Java 到 native 的入口 | S |
| HTTP 外层 | `0x14DBF4 buildSignedHttpHeadersCallback_350` | URL、CRLF headers、请求对象/类型 | 构造引用对象和输入树；成功时返回 CRLF header string | Java/native API 可消费的接口形态 | S/D |
| HTTP 内层 | `0x149CA8 buildSignedHttpHeadersInner_350` | ctx、JSON、URL、stub、type、input tree、X8 out | 生成 7 个 `X-*`，写输出 `TREE_MAP`；返回状态码 | 一次完整请求签名 | S/D/V |
| managed VM | `0x154454 -> 0x154468 -> 0x1555A4` | `ManagedProgram *`、call pack/frame slots | F 程序经 CF helper 生成 header material | Argus/Ladon/Medusa/Helios 主体 | S/D/V（按算法） |
| native VMP | `0x4CC10 exeVMInner_350` | vmCode、pParam、data1、data2、VmParam | 仅三条 closed wrapper 分别证实 u32 或 out-ref；package-check/entry-only 输出未知 | material builder 与完整性等 helper 的 VM 边界 | S/D（仅已覆盖入口） |
| 输出封装 | `0x14D424 -> 0x149C20` | 输出 `TREE_MAP` | 序列化为 CRLF header 字符串 | 返回调用方 | S/D |
| 后台风险链 | `0xD86D0` 等 | 映像、signal、JNI/ART、进程环境 | guard/risk bits/settings/report 聚合物 | 到 header、签名或策略的消费未闭合；不等同于全部立即退出 | S，部分 D |

## 4. `.init_array` 与 managed VM 启动

`.init_array` 位于 `VA 0x260190 / file offset 0x25F190 / size 0x3A0`。签名相关的前
四个 module constructor 如下；请求阶段只取已经缓存的程序句柄，不再解码 blob。

| init | build call | encoded blob / size | decode key | 绑定输入 | build 输出 |
|---:|---:|---|---:|---|---|
| `0x14CEBC` | `0x14D0D4` | `0x27EFF0 / 0x58F` | `0x270D30` | CF0..15，G0 | module `0x2C4D40`；F0/F1 `0x2C4D48/50` |
| `0x152B58` | `0x1534E4` | `0x27F9B0 / 0x1FA2C` | `0x270EB0` | CF0..19，G0..64 | module `0x2C5258`；F0..F85 |
| `0x1702B8` | `0x170F54` | `0x29FF20 / 0x1A322` | `0x271920` | CF0..101，G0..10 | sign module `0x2C58C8`；F0..F54 |
| `0x171DDC` | `0x172048` | `0x2BA250 / 0x1857` | `0x271940` | CF0..16，G0..2 | child module `0x2C5AC8`；F0..F7 |

核心 builder ABI：

```c
ManagedModule350 *managedModuleBuild_350(       // 0x154328
    uint8_t *encoded_blob,                      // X0
    uint32_t encoded_size,                      // W1
    void *scratch,                              // X2
    uint32_t flags,                             // W3，当前为 0
    ManagedBinding350 *cf_table,                // X4
    uint32_t cf_count,                          // W5
    ManagedBinding350 *g_table,                 // X6
    uint32_t g_count,                           // W7
    uint8_t *decode_key                         // stack[0]
);
```

| RVA | 输入 | 输出 | 作用 | 证据 |
|---:|---|---|---|---|
| `0x154328` | 上表 9 项 | `ManagedModule350 *` | builder 薄封装，X8 接收内部输出 | S |
| `0x158F48` | blob/key/CF/G | X8 写 module | 以 `decode_key[2]` XOR 解码、解析容器、绑定 CF/G | S |
| `0x154364` | X0 module，X1 `"Fxx"` | `ManagedProgram350 *` | 从 module 导出表查程序 | S |
| `0x154454` | program + 调用参数 | invoke 返回状态/slot2 | 通用调用入口 | S/D |
| `0x154468` | program/frame | 按 kind 进入 bytecode/native/mixed | 区分 kind 1/2/3 | S |
| `0x1545A8` | frame pool/context | frame，`buf` 大小 `0x8380` | 获取并清理 VM frame | S |
| `0x154648` | frame | 释放/归还 | frame 生命周期结束 | S |
| `0x1547C0` | frame, slot index | slot value | 读 slot | S |
| `0x1547D4` | frame, slot index, value | frame 副作用 | 写 slot | S |
| `0x1555A4` | program bytecode + frame | slot2/状态 | 解释 0x18-byte record；opcode base `0x81` | S/D |

frame 的稳定口径：slots 位于 `buf+0x8100`，共 `0x50` 项；slot2 通常承载返回值，
slot4 起是调用参数，slot29 是 value-stack 指针。不同 module 的同号 F/CF 不能混用：
sign F7 与 child F7 不是同一个程序。

## 5. JNI 装载与 Java 入口

| RVA/全局 | 输入 | 输出/副作用 | 作用 | 证据 |
|---:|---|---|---|---|
| `0x139BB0` | `JavaVM *vm`, reserved | JNI version/失败码 | `JNI_OnLoad` 外层入口 | S |
| `0x13A2C4` | 同上 | 转入 inner | 间接包装层 | S |
| `0x13A320` | `JavaVM *` | 注册 native、缓存对象 | `JNI_OnLoadInner_350` | S |
| `0x2C3538` | 写入 JavaVM | 进程级 `JavaVM *` | 以后按线程取得 `JNIEnv *` | S |
| `0x12F5D0` | `JNIEnv *`、MS 类名 | `RegisterNatives` 结果 | 沿 MS 的 superclass 层级注册 native `a(...)` | S |
| `0x2C3518` | class global ref | 缓存引用 | 调用 Java helper | S |
| `0x2C3520` | `jmethodID` | 缓存 `b(...)` | native 到 Java 的派发入口 | S |
| `0xD9044` / `0xD90C0` | `JNIEnv *`、缓存类 | 一次性 latch `0x2C1070` | 探测静态 `a()V`，并处理 JNI exception | S |

类锚点为 `com/bytedance/mobsec/metasec/ml/MS`。目前能确认的是注册层级、签名和缓存
生命周期；Java 层每个整数命令值对应哪项业务，应继续由调用 trace 定义。

## 6. HTTP 签名入口 ABI

### 6.1 外层 `0x14DBF4`

`buildSignedHttpHeadersCallback_350` 接受外部 URL/headers/请求上下文，把 CRLF headers
解析为 `TREE_MAP` 和引用对象，再调用 inner。其“出参”是可直接返回给调用方的 CRLF
header string；inner 自身则以 `TREE_MAP` 为输出。

### 6.2 内层 `0x149CA8`

当前逻辑原型为：

```c
int64_t buildSignedHttpHeadersInner_350(
    MetaSecCtx350 *ctx,             // X0
    REF_JSON_LIST *json_list_ref,   // X1
    REF_MEM_BLOCK *url_ref,         // X2
    REF_MEM_BLOCK *x_ss_stub_ref,   // X3
    int request_type,               // W4，当前基线 0x171
    REF_TREE_MAP *input_tree_ref,   // X5
    REF_TREE_MAP *out               // hidden X8
);
```

真机入口中 X1/X2/X3/X5 是同一栈参数包的 0x10-byte 滑动窗口，不应误建成四个无关
业务对象。成功时返回 `0` 并经 X8 写出 tree；已确认失败码：

| 返回值 | 条件 |
|---:|---|
| `-1` | JSON/list 缺失 |
| `-5` | URL 空或无效 |
| `-6` | `x-ss-stub` 缺失 |
| `-7` | URL 被规则拒绝 |
| `-8` | URL/query 派生失败 |
| `-4` | 最终输出 map 为空 |
| `0` | 成功，X8 获得输出 `TREE_MAP` |

## 7. 一次签名请求的精确阶段

| 顺序 | 调用/写出 RVA | 入参 | 出参 | 最终 header / 用途 | 证据 |
|---:|---|---|---|---|---|
| 1 | `0x14A128` | input tree | mode，基线 0 | 读取 `x-metasec-mode` | S/D |
| 2 | `0x149F78`, `0x14A164` | URL | query/path `MEM_BLOCK` | 为后续 hash/sign 生成规范材料 | S/D |
| 3 | `0x14A1AC -> 0x16D204` | seed/handle、stub、query、short code、mode | key/value pair | `X-Gorgon`；值长 `0x34` | S/D/V（核心 transform） |
| 4 | `0x14A1FC -> 0x16D454` | 时间/阶段参数 | key/value pair | `X-Khronos`；十进制秒，长 `0x0A` | S/D/V |
| 5 | `0x14A38C -> 0x1715F8 -> F5` | full managed call pack | key/value | `X-Argus`，常见长 `0x104` | S/D/V（当前基线） |
| 6 | `0x14A3EC -> 0x171648 -> F7` | short pack | key/value | `X-Ladon`，长 `0x30` | S/D/V |
| 7 | `0x14A468/0x14A490` | 当前中间 tree | CRC32 -> setting | 请求内容/阶段状态快照 | S |
| 8 | `0x14A4E0 -> 0x171698 -> F8` | full pack，`final_flag=1` | key/value | `X-Medusa`，当前约 `0x3B0..0x3B8` | S/D/V（final pack） |
| 9 | `0x14A588 -> 0x1716F4 -> F13` | short pack | key/value | `X-Helios`，长 `0x30` | S/D/V |
| 10 | direct put `0x14A65C` | optional/env pack | key/value | `X-Soter`；default pack 长 `0x78` | S/D/V（default） |
| 11 | `0x14A704 -> 0x120E5C` | elapsed/sampling state | metric/settings | `ML_DoHttpReqSignIT` 耗时消费 | S |
| 12 | `0x14A730 -> 0x14D424 -> 0x149C20` | output tree | CRLF string | 返回完整签名头 | S/D |

注意：表中的“V”只覆盖相应文档声明的边界。例如 Medusa 已验证 final pack/base64，
不代表所有动态环境输入在任意设备上都已闭环。

## 8. 两种 managed 调用参数包

full pack（F5/F8 等）当前字段：

| offset | 字段/输入 | 下游用途 |
|---:|---|---|
| `+0x00` | `seed_or_handle` | 随机/句柄材料 |
| `+0x08` | `JSON_LIST *` | 环境/请求对象 |
| `+0x10` | `x_ss_stub` | 请求体摘要 |
| `+0x18` | URL/query | URL 材料 |
| `+0x20` | aux ref/mem | 辅助数据 |
| `+0x28` | token/env | 设备与运行时材料 |
| `+0x30/+0x38` | bd-client-key item/value | 配置/密钥输入 |
| `+0x40` | request type | 签名模式 |
| `+0x48/+0x50` | `char **out_key/out_value` | managed 返回 key/value |
| `+0x58` | mode | 分支/格式模式 |
| `+0x5C` | final flag | F8 final 阶段标志 |

short pack（F7/F13 等）当前字段：`+0 seed`、`+8 derived block`、`+0x10 JSON`、
`+0x18 stack mem`、`+0x20 out_key`、`+0x28 out_value`。

## 9. 各 `X-*` 的算法边界

| Header | 主要入口 | 输入 | 输出 | 已确认作用/算法 | 未闭环边界 |
|---|---:|---|---|---|---|
| X-Gorgon | `0x16D204` | query、stub、time、mode、seed | 0x34 字符 | native stage1 核心 transform | allocator pointer low16 依赖的泛化来源 |
| X-Khronos | `0x16D454` | 当前秒 | 10 字符 | 十进制时间戳 | 无关键算法缺口 |
| X-Argus | F5 / `0x1715F8` | protobuf 字段、query/stub、time/random、配置 | 0x104 字符类 | protobuf -> SM3 -> CF41 SIMON128/256 -> mask/reverse -> CF43 AES-CBC -> CF44 base64 | optional protobuf/env 在更多样本上的覆盖 |
| X-Ladon | F7 / `0x171648` | time/value/aid + key | 48 字符 | `%u-%s-%s` -> CF48/F17 ARX -> prefix4 -> base64 | 已有当前向量 oracle |
| X-Medusa | F8 / `0x171698` | full pack、JSON/env、source-work | 约 0x3B0..0x3B8 | F18..F54 families、F12 bit-pack、CF07 final pack、CF44 base64 | 任意真机环境值的完整泛化 |
| X-Helios | F13 / `0x1716F4` | short pack | 48 字符 | 与 Ladon 同形的 short transform | 更多请求向量 |
| X-Soter | put `0x14A65C` | optional/env | default 0x78 字符 | 当前 empty/default pack 已验证 | 非空环境分支 |

protobuf 识别不是靠名字猜测：CF31/CF90 走 `0x11615C` 做 descriptor-backed wire size，
CF33/CF91 走 `0x1165B8` 写 wire buffer；再由 tag/wire type、字段长度和运行向量还原
`XArgusStruct`。JSON 同理，通过 CF79 的 key/value 写入形态和最终对象消费点定义。

## 10. native VMP `exeVMInner_350`

### 10.1 通用 ABI

```text
0x4CC10 exeVMInner_350
  X0 = vmCode / program pointer
  X1 = pParam/result window
  X2 = vmData1
  X3 = vmData2
  X4 = VmParam64 { funBridge, stack_end, save_LR }
```

VM 指令是 32-bit word，当前顶层分派可见 `op = word & 0x3F`，handler 以 `BR X8`
跳转。线性反汇编看到的异常控制流不能直接当 native basic block；语义必须同时结合
handler 字段解码和执行 trace。

### 10.2 已闭合的 wrapper/entry 对

| wrapper / caller LR | vmCode | data1 / data2 | pParam 输入 | 输出 | 当前定义 |
|---|---:|---|---|---|---|
| `0xD9574 / 0xD95CC` | `0x1EC670` | `0x262980 / 0x2629C0` | `SP+8` result window | wrapper 读 `[SP+8]` 为 u32 | 短 helper VMP |
| `0xD95F4 / 0xD964C` | `0x1ECAF0` | `0x262A00 / 0x262A20` | `SP+8` result window | wrapper 读 `[SP+8]` 为 u32 | 短 helper VMP |
| `0x124DD4 / 0x124E34` | `0x1F7860` | `0x26F2E0 / 0x26F300` | X8 out-ref + 3 个 incoming qword | out-ref 指向 material/list | mssdk material 构造 |

`0x1F7860` 的结果由 `0x12564C selectValueFromNativeVmpMaterial_350` 遍历 list、按 key
匹配并复制 value。它不是直接返回 X-Argus 或 X-Medusa 的“一键 signer”。

另有完整性入口 `0xD7E94 runMetaPackageCheckVM_350`：vmCode `0x1EA850`，aux
`0x262800/0x262890`。当前只能定义 wrapper、参数块和静态候选指令区；没有 guard
有效地址写 trace 前，不能给它内部字段写入强行命名。

当前 native runtime 的“完整”含义是：已收集 trace 中的指令能够严格解码/执行；不是
整个 SO 所有 vmCode、所有不可达 handler 都已恢复。升级时必须重新验证 entry/vmCode/LR
三元组，不能把旧版 `z/ws/vm64.cpp` 的标签直接迁入。

## 11. 完整性、反调试和环境风险链

| RVA | 输入 | 输出/状态 | 作用 | 失败后的影响 | 证据 |
|---:|---|---|---|---|---|
| `0xD86D0` | guard/runtime | 初始化 monitor | 完整性监控总入口 | 安排各子检查 | S |
| `0xD7F10` | ELF path/cache | observed machine id | 读 ELF `e_machine` | 写 guard/report 风险材料 | S |
| `0xD84FC` | signal64、handler、代码页 | `signal_loop_failed` | signal + 自修改 I-cache 行为探针 | 写 guard+0x30，后续报告消费 | S |
| `0xD8218` | 当前 ELF program headers | image base/end、len、expected XOR | 定位 PT_LOAD 并安排延时任务 | 成为 VMP 完整性输入 | S |
| `0xD7D84` | guard/image/package | `integrity_risk_bits`、settings | 执行并发布完整性检查 | 闭合到 guard/settings/risk 聚合物；下游消费未闭合 | S |
| `0xD7E18` | image range、expected XOR/len | integrity result | 映像 XOR VMP wrapper | VMP 字段效果与下游消费未闭合 | S；VM 内部待 D |
| `0xD7E94` | guard、bridge、aux tables | guard/VMP 边界 | package/environment VMP wrapper | 字段级副作用与下游消费未闭合 | S |
| `0xAFBA0` | 敏感入口首指令 | suspicious bool | 检查入口指令是否被 patch/hook | 命中路径可进 `0x125D34` | S |
| `0x125D34` | check failure context | 控制流终止/破坏 | 高敏感失败处理 | 可能 crash/状态破坏 | S |

报告阶段还会扫描 native API 地址归属、JNI 函数表、ART/Java method、TracerPid、可疑
线程名、root 路径和 `/proc/*/maps`。必须区分两类结果：

1. 高敏感入口检查可直接走失败控制流；
2. 多数环境检查只是写入 guard、risk mask、setting 或 report；是否随后被 header、签名或策略读取仍未闭合。

不能把所有“检测到异常”统一命名为 `kill/abort`。
report/post 与 HTTP header 输出虽复用部分通用 tree/settings API，却是独立聚合链；该复用
不能单独作为 header consumer 或对象 alias 的证据。

## 12. 会影响后续流程的全局变量

| RVA | 名称 | 写入来源 | 读取/输出 | 最终作用 |
|---:|---|---|---|---|
| `0x2BBDF8` | `gGlobalLinkerInfoRef` | early init | 检查器/报告器 | 持有全局 linker/guard 引用 |
| `0x2BBE80` | `g_early_runtime_time_350` | early init、JNI_OnLoad | 启动耗时材料 | 先是 start，后变 elapsed |
| `0x27DC98` | `g_sig64_guard_state_350` | signal probe | JSON/report | `-1/1/3/1213` 状态机 |
| `0x27DDF0` | `g_meta_check_len_350` | image bounds init | guard+0x28、integrity VM | 当前检查长度 `0x25EA20` |
| `0x27DDF4` | `g_meta_expected_xor_350` | init 常量 | guard+0x20、integrity VM | 当前期望 XOR `0x99D93502` |
| `0x2C0FB8` | `g_cachedElfMachinePathPrimary_350` | path probe | ELF machine probe | 首选 ELF 路径缓存，不是风险值 |
| `0x2C0FC0` | `g_cachedElfMachinePathFallback_350` | path probe | fallback probe | 备用路径缓存 |
| `0x2C0E58` | `g_signalProbeContextActive_350` | signal setup | handler | 控制上下文恢复，不是计数器 |
| `0x27EDF8` | `g_httpSignSamplingCounter_350` | 每次 inner 调用 `+1` | `%10` 采样分支 | 调度耗时记录和设备信息刷新；非原子近似计数 |
| `0x2C3518` | cached class global ref | JNI_OnLoad | Java helper dispatch | JNI 对象生命周期 |
| `0x2C3520` | cached `b(...)` method ID | JNI_OnLoad | Java call | native -> Java 回调 |
| `0x2C3538` | `JavaVM *` | JNI_OnLoad | 多线程 JNI | 获取当前线程 `JNIEnv *` |

请求流程还会把中间 tree 的 CRC32 写入 setting
`167774bf518c11948aa0784351ccf5a9`，并在 F8 后写常量 `100` 到
`2e8ab1223d07836ad4fc65fc581b4808`。已确认写入时序和值，但后者的业务名称仍保留。

## 13. 输出、状态与失败传播

```text
输入 URL/headers/JSON/env
  -> REF_MEM_BLOCK / REF_JSON_LIST / TREE_MAP
  -> native + managed VM + native VMP material
  -> out TREE_MAP
       X-Gorgon, X-Khronos, X-Argus, X-Ladon,
       X-Medusa, X-Helios, X-Soter
  -> CRLF header string

请求/后台附带副作用（并列，不构成 header 输入边）
  -> CRC/settings/timing
  -> guard/risk/report 聚合物
```

因此“出参”有三类，后续 trace 时要分开记录：

- **直接返回**：状态码、wrapper 返回的 header string 或小 VM u32；
- **隐藏/引用输出**：X8 out tree、managed `out_key/out_value`、VMP out-ref；
- **持久副作用**：ctx/global/guard/settings/report/counter 的写入。

只盯 X0 返回值会漏掉大部分真实结果。

## 14. 后续版本迭代模板

升级到新 SO 时复制本文件为 `so_runtime_flow_<version>.md`，按以下顺序替换：

1. 固定 size/SHA-256/Build ID，所有地址改用新样本 RVA。
2. 对齐 `.init_array`、四类 module init、blob/key/CF/G/F 全局区。
3. 对齐 `JNI_OnLoad -> RegisterNatives -> Java dispatch`。
4. 对齐 wrapper/inner，并重新采 X0..X5、X8、返回值和输出 tree。
5. 按 header 写出点反向确认每个 native/F 程序，不能只凭 F 编号迁移。
6. 对 native VMP 重新收集 `entry + vmCode + LR + X0..X4 + 内存读写`。
7. 对 guard/global 记录 writer、reader、宽度、值域和最终 consumer。
8. C oracle 只在 byte-exact 后标 V；静态同型只能标 S/P。
9. 更新 IDA 名称/结构后，记录所用脚本和数据库保存状态。
10. 运行 `python3 scripts/generate_version_file_catalog.py <version>` 更新目录清单。

推荐每个新发现都补一行：

| RVA | caller/LR | raw 入参 | 逻辑入参 | 直接返回 | 引用/内存输出 | 最终 consumer | 证据 |
|---:|---:|---|---|---|---|---|---|
| `TBD` | `TBD` | `X0..X8/SP` | `TBD` | `TBD` | `TBD` | `TBD` | `S/D/V/P` |

## 15. 专项证据入口

- HTTP 可读伪 C：`build_signed_http_headers_350_recovered.c`
- header 生成/算法：`x_headers_generation_350101.md`、`x_headers_algorithms_350101.md`
- managed VM 启动：`managed_vm_boot_350101.md`
- managed F/CF：`managed_vm_program_lift_350101.md`、`managed_cf_semantics_350101.md`
- native VMP：`exeVMInner_x_headers_350101.md`、`vm_generic_350101/opcode_recovery_350101.md`
- 完整性与全局状态：`integrity_guard_ida_350101.md`
- 环境输入：`environment_inputs_350101.md`
- 结构体：`metasec_structs_350_all.h`
- IDA 落库记录：`ida_rename_update_350101_20260831.md`
- 验收：`algorithm_validation_350101.md`

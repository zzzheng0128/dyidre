# 350101 metasec 结构体恢复笔记

目标入口：

- wrapper: `libmetasec_ml.so+0x14dbf4` = `buildSignedHttpHeadersCallback_350`
- inner: `libmetasec_ml.so+0x149ca8` = `buildSignedHttpHeadersInner_350`

这份目录里的内容不是最终结构体，而是“证据驱动”的恢复结果。每个字段必须同时看三类证据：

1. 入口 dump：这个寄存器/指针进函数时长什么样。
2. 运行读写 trace：哪个 PC 读/写了哪个 offset，宽度是多少。
3. 静态汇编/IDA：这个 PC 真实在做什么，比如复制、引用计数、锁、虚调用。

## 签名证据总览（从这里读）

`so_runtime_flow_350101.md` 是本版本唯一的全链路总入口：它把初始化、JNI/HTTP 边界、
managed VM、native VMP、环境/完整性状态、输出封装和证据等级放在同一条生命周期中。它是
架构与证据地图，不是可独立调用的签名规范。

研究过程与日志溯源另见[还原过程与日志证据索引](recovery_process_and_evidence_350101.md)
及[逐文件日志清单](recovery_log_inventory_350101.json)：按阶段记录来源、产物、验证边界、
原件存在性和已废弃结论；它们补充总流程台账，不替代架构主入口。

建议按下面顺序阅读：

1. [样本身份](metasec_so_identity.md) 与 [分析轨迹](analysis_trajectory_350101.md)：先固定
   样本和版本口径。
2. [总流程台账](so_runtime_flow_350101.md) 与 [输出生成边界](x_headers_generation_350101.md)：
   看输入、阶段、输出容器和失败传播。
3. [managed VM 启动](managed_vm_boot_350101.md)、[恢复边界](managed_vm_recovery_350101.md)、
   [程序流程](managed_vm_program_lift_350101.md)、[CF 语义](managed_cf_semantics_350101.md) 与
   [G 绑定台账](g_binding_ledger_350101.md)：区分 module-local 的 CF/F/G 表及其已证实边界。
4. [环境输入](environment_inputs_350101.md)、[完整性/风险链](integrity_guard_ida_350101.md) 与
   [验证记录](algorithm_validation_350101.md)：区分材料来源、状态副作用和固定基线验证。
5. [CF63/CF64 child 边界](cf63_cf64_child_module_boundary_350101.md)、
   [CF75 child 边界](cf75_child_module_boundary_350101.md) 及
   [native VMP 台账](vm_generic_350101/README.md)：将未闭合或刻意保持 opaque 的路径与主链分开。

阅读时以 `S/D/V/P` 证据等级为准：固定输入/环境下的 `V` 只证明对应基线的一致性，不能
外推为跨设备、跨环境或跨版本的通用结论。总览不收录请求原文、密钥、包字节、地址或运行时
采集步骤；这些原始材料只应留在受控证据中。

## 分析 37xx 时怎么复用这里

这个目录不是单纯的 350101 存档，而是后续版本升级的“基准答案 + 证据模板”。
分析 37xx 时按下面顺序用：

1. 先看 `FILE_CATALOG.md`，知道每类文件怎么来、怎么复跑、后面有什么用。
2. 把 `analysis_trajectory_350101.md` 复制成 `analysis_trajectory_<new_version>.md`，逐项替换 37xx 的 hash、入口、trace、unidbg 结果。
3. 用 `metasec_so_identity.md` 和 `dyidre/materials/350101/materials_manifest.md` 的格式，给 37xx 建自己的 SO/APK/i64 身份记录，避免 APK 名一样但 SO 不同。
4. 用 `build_signed_http_headers_350_recovered.c`、`x_headers_generation_350101.md` 对照 37xx 的 HTTP 签名链路，先找 wrapper/inner/TreeMap 写出点。
5. 用 `managed_vm_decode*/`、`managed_cf_*` 对照 37xx 的 managed VM：先确认 F5/F7/F8/F13 和 CF index 有没有漂移，再看 opcode unknown 是否为 0。
6. 用 `exeVMInner_x_headers_350101.md` 和 `vm_lift_1f7860/` 对照 native VMP：先看 `exeVMInner` 地址、`vmCode` 分布、LR 分布是否同型。
7. 用 `environment_inputs_350101.md`、`unidbg_env_fill_350101.md` 把真机环境同步到 37xx unidbg profile；不要把 fixed baseline 的时间/随机/pid 当算法常量。
8. 用 `*_recovered_350101.c` 和 `run_recovered_c_oracles_350101.sh` 当 oracle 模板；37xx 每恢复一段，就新建对应 `<name>_<version>.c`，用真机/unidbg 中间向量跑到 `failures=0`。
9. 最后再用 `ida_rename_update_350101_20260831.md` 和 `metasec_structs_350_all.h` 迁移 IDA 命名、结构体、中文注释；迁移时只搬“证据对得上”的字段，没验证的继续保留 `field_xxx`。

一句话：37xx 不要重新摸黑。先用 350101 的文件类型搭骨架，再用 37xx 的真机证据逐项替换；路径一致看值，值一致再落 IDA/C oracle。

## 文件

- `FILE_CATALOG.md`：本目录文件来源/生成脚本/后续用途清单；由 `dyidre/scripts/generate_version_file_catalog.py 350101` 生成，提交前如果新增/移动文件可以重跑。
- `so_runtime_flow_350101.md`：350.101 整个 SO 的总流程台账；按 RVA 统一记录 `.init_array`、JNI、HTTP、managed VM、native VMP、完整性链的入参、出参、状态副作用、最终用途与证据等级。后续版本优先复制这份表再逐项替换地址和证据。
- `interface_ledger_350101.json`：机器可读的接口台账；固定记录 `RVA / caller / 入参 / 出参 / 副作用 / 最终用途 / 证据 / 参考文档`，适合新版本复制后逐条对齐。
- `guard_branch_influence_plan_350101.md`：boot/guard 异常参数的单变量实验矩阵，记录 guard/risk/settings/report 写集及后续分支影响；仅用于离线或只读验证。
- `token_report_field_map_350101.md`：从 `dycompare` 的 `get_token`/`report` 分析文本提取的字段、来源、类型、用途及与 350.101 guard/HTTP/F8 的对应关系；真实值已脱敏。
- `dycompare_schema_boundary_350101.md`：历史文本、`klog.proto` 注释与 350.101 之间的 schema/provenance 边界审计；明确哪些标签、类型和跨版本对应仍不能提升为 ABI 结论。
- `token_report_implementation_xrefs_350101.md`：历史兼容参考，**不作为 350/351 升级依据**；升级时以 IDA 数据库和下方 locator 为准。
- `ida_token_report_field_locator.py`：直接在当前 IDA 数据库中按字段字符串 xref、函数名和已有 Local Types 找 token/report 候选；默认只读输出，适合后续版本升级复用。
- `analysis_trajectory_350101.md`：350101 实际走通的分析轨迹；记录 SO 身份、入口、真机采证、unidbg 复现、VM/CF、结构体、IDA 落库之间的证据链。后续升级版本时优先复制它作为新版本轨迹。
- `summary.json`：机器可读证据。
- `x0_evidence.md`：按 offset 聚合后的证据表。
- `x0_struct.h`：自动生成的稀疏结构骨架。
- `x0_tail_timeline.md`：`x0+0x3c0..0x500` 的时间线还原。
- `x0_promote_plan.md`：把字段按“可升级 / 需继续追 / 只是 scratch buffer”分类后的下一步计划。
- `real_vs_unidbg_entry_shape.md`：真机和 unidbg 入口 dump 的结构形态对比，指针值已归一化。
- `metasec_ctx350_draft.h`：人工合并动态/静态证据后的草稿结构，适合导入 IDA。
- `metasec_structs_350_all.h`：350.101 当前已识别/继承的结构快照，包含 `MEM_BLOCK/TREE_MAP/JSON_LIST/COOKIE_RISK*` 等核心结构。
- `metasec_so_identity.md`：当前 350 SO 的身份报告，包含 size、sha256、build-id、字符串锚点。
- `build_signed_http_headers_350_recovered.c`：把 `0x14DBF4 -> 0x149CA8` 的请求到签名成功链路还原成可读伪 C，包含 X-Gorgon/X-Khronos/X-Argus/X-Ladon/X-Medusa/X-Helios/X-Soter 的生成顺序。
- `managed_cf_recovered_350.c`：把 managed VM 里的高价值 CF helper 还原成可读伪 C，重点覆盖 slot 模型、CF61/SM3、CF48/CF49 短头包、CF44/CF98 出口。
- `cf61_sm3_recovered_350101.md` / `cf61_sm3_recovered_350101.c`：CF61 的 SM3 识别过程和 standalone oracle；F15 IV + 5/5 raw vector 已验证，当前 `failures=0`。
- `cf48_short_transform_lift_350101.md` / `cf48_f17_recovered_350101.c`：CF48/CF49/CF44 短头链路的 lift 和 standalone oracle；覆盖 `key32 -> ARX schedule -> managed F17 34-round block transform -> prefix4||out32 -> base64`，F7/X-Ladon 与 F13/X-Helios 两组 runtime 向量当前 `failures=0`。
- `managed_vm_program_lift_350101.md`：把已 decode 的 managed bytecode 程序提升成业务流程说明；区分直接产出 header 的 `F5/F7/F8/F13` 和嵌套 transform 的 `F12/F18/F19/F20/F21/F22/F23/F30/F31/F32/F39/F40/F47/F48/...`。
- `managed_sign_cf_table_350101.md`：从 `0x1702B8 initManagedSignModuleLarge_350` 静态抽出的 `CF0..CF101` 注册表；用于快速生成 unidbg focused probe 的 callsites。
- `g_binding_ledger_350101.md`：四个 managed module 的 `G` import-binding 台账；区分 `G/CF/F` 三张表，现已闭合 80/80 registration/import ABI 与 80/80 G data-symbol reference，并记录 second F1、child F0 对各自三个 8-byte package slot 的窄读证据；不把未证实的 BSS/静态地址误命名为业务字段。
- `g_linkage_and_relocation_static_audit_350101.md`：以 module-local `G` 命名空间、builder link、import、symbol、pool slot、relocation 与 F body 为链的静态交叉审计；明确区分已闭合的链接/引用关系与仍未知的运行时语义。
- `x_argus_pack_350101.md`：F5/X-Argus 的 byte-exact pack 报告；证明 `CF44(src_len=0xc2)` 输入做 base64 后逐字节等于最终 `X-Argus`。
- `f5_x_argus_pack_lift_350101.md`：F5/X-Argus 尾部拼包 lift；自动验证 `0x20+4->0x24 -> 0x44 -> 0xa8 -> 0xb1 -> 0xb3 -> 0xc2` 的 CF30 concat 链，最终 `base64(0xc2 pack) == X-Argus`。
- `f5_argus_cf41_cf42_cf43_static_350101.md`：F5/X-Argus 尾部 `CF41/CF42/CF43` 静态剥离记录；`CF41` 已验证为 SIMON128/256 + PKCS#7，`CF42` 已精确到 little-endian u16 MEM_BLOCK，`CF43` 当前 F5 样本 mode type=1 且验证为 AES-128-CBC + PKCS#7。
- `cf41_simon128_256_recovered_350101.md` / `cf41_simon128_256_recovered_350101.c`：CF41 的 SIMON128/256 standalone oracle；覆盖 `key32 -> 72 round keys -> F16 block transform -> 0x92/0xa0` runtime 向量，当前 `failures=0`。
- `cf41_plain92_proto_350101.md` / `cf41_xargusstruct_decode_350101.md`：CF41 输入明文 `0x92` 的 `XArgusStruct` protobuf field map；记录稳定字段 `aid/device_id/version/sdk/pskVersion/callType`、动态 `random/khronos` 字段，以及当前缺失的 optional 字段。
- `f5_x_argus_pack_lift_cf43mode_ret_350101.md`：带 CF43 低层返回点的 F5/X-Argus 尾包 lift；证明 `0x11CBB4` 原地处理 `0xb3+pad -> 0xc0`，`0x11C8D8 saved_x2_after == final outC0`，最终 `0xc2 = prefix2 || outC0`。
- `cf43_aes128_cbc_recovered_350101.md`：CF43 type1 分支的恢复说明；静态跳表、runtime 参数、OpenSSL 校验和 C oracle 结论都放在这里。
- `cf43_aes128_cbc_recovered_350101.c`：CF43 当前 F5 type1 分支的 standalone oracle；用日志里的 `bodyB3/key16/iv16/outC0` 验证标准 AES-128-CBC + PKCS#7，当前 `failures=0`。
- `x_medusa_pack_350101.md`：F8/X-Medusa 的 raw-CF07 字节级 pack 还原，证明最终 CF44 输入可由 CF07 片段重建，并区分 work area 预组装与变换后的最终拷贝。
- `f8_x_medusa_mutation_watch_350101.md`：继续追 work area 预组装后的原地变换；确认 mini 由 F8 主程序 `ST8` 写回，large subpack 前 `0xf8` 字节由嵌套 F12 `ST64` 变换；并把 F12 source stream 的上游修正为 source-work outer family，而不是 CF97 单独生成。
- `f8_cf79_json_env_fields_350101.md`：F8/X-Medusa phase 内 `CF79 jsonAddNumber` 的 8 个环境数字字段；确认 `cmr/cmr2/un_h/vpn/kd/fkd/pd/do` 进入 JSON/env object，不以明文数值直接落在 final `0x2c8` pack。
- `f8_medusa_mini_xor_recovered_350101.c`：F8 mini-work 20 字节原地变换 oracle；五个 4-byte lane XOR 同一个动态 little-endian key32，两组 runtime 向量当前 `failures=0`。
- `f19_f32_source_work_timeline_350101.md`：`source-work` 的 F19/F31/F32-family 写入时间线；本轮观测到 `F19 -> F31/F32 -> F35/F36/F37/F38`。
- `f20_f40_source_work_timeline_350101.md`：`source-work` 的 F20/F39/F40-family 写入时间线；本轮观测到 `F20 -> F39/F40 -> F43/F44/F45/F46`。
- `source_work_family_compare_350101.md`：source-work VM family 的一一对齐表；四族 `F18/F22/F23`、`F19/F31/F32`、`F20/F39/F40`、`F21/F47/F48` 都已实跑并收齐向量。
- `f18_f21_source_work_outer_compare_350101.md`：补齐 outer producer 的四套模板图谱，尤其是 `20-record adapter + 67-record block loop` 这一层。
- `source_work_round_family_graph_350101.md`：补齐 adapter、key schedule、scheduler、round primitive、GF multiply 的完整 family graph；后续版本升级优先看这个。
- `source_work_key_schedule_family_350101.md`：单独抽出 `F24/F33/F41/F49` 的初始 XOR 常量、`op 0x0d` 字节抽取语义和静态表窗口。
- `source_work_f23_family_exact_350101.md`：把当前 `F23` 的真实 slot ABI、F24 的 48-byte key expansion、F25 scheduler，以及 F29/F38/F46/F54 的 GF 矩阵和四套 scratch swizzle 提升为 byte-exact 说明。
- `f20_f21_source_work_transform_350101.md`：专门梳理 F12 source stream 上游；确认 `CALL_CF_INDEX 0x8b -> F30`，并把 adapter、block loop、scheduler、round primitive 放进同构 family。
- `source_work_vectors_350101.md`：从 unidbg `[source-work]` probe 汇总出的四族 runtime 向量；覆盖 F22/F23、F31/F32、F39/F40、F47/F48，检查 adapter 输出与 block-loop 输入、loop 尾块链值全部 OK。
- `source_work_vector_selfcheck_350101.c`：四族 byte-exact 回归测试；嵌入 4 张 256-byte table 和 runtime vectors，验证 `f20_f21_medusa_source_transform_recovered.c` 输出，当前 `failures=0`。
- `f20_f21_medusa_source_transform_recovered.c`：source-work 的 C lift；现已补齐参数化 key expansion、F23/F32/F40/F48 block loop、scheduler、GF multiply、四套 MixColumns scratch swizzle，并修正 `s6=byte length` 与 `key_area+0xb0` 每块链式写回。
- `c_recovery_suite_350101.md`：350.101 C 代码还原总装说明；明确已 byte-exact 的算法边界、公共 API、以及后续版本升级时如何复跑。
- `metasec_350101_recovered_c.h`：已验证 C 还原模块的公共接口声明。
- `metasec_350101_recovered_c_suite.c` / `run_recovered_c_oracles_350101.sh`：统一编译/链接/自测入口；当前全量 oracle 与 linked suite 都是 `failures=0`。
- `x_headers_algorithms_350101.md` / `x_headers_algorithms_350101.c`：按 `X-*` header 口径整理算法还原；当前 `X-Gorgon` 核心 transform、`X-Khronos`、`X-Ladon/X-Helios`、`X-Argus` protobuf 明文 + CF41/SIMON + CF43/AES tail、`X-Medusa` final-pack/base64、`X-Soter` empty/default pack 均有 C oracle。
- `fixed_s1_s2_signer_350101.md` / `metasec_350101_fixed_signer.c`：固定随机/时间/环境后，只输入 `s1/s2` 生成完整 `X-Argus/X-Gorgon/X-Helios/X-Khronos/X-Ladon/X-Medusa/X-Soter`，当前与 deterministic unidbg baseline 逐字节一致，`fixed s1/s2 signer failures=0`。
- `environment_inputs_350101.md`：把 `s1/s2` 之外参与计算的时间、随机、pid/tid、urandom、AT_RANDOM、F8 JSON/env、Argus key/prefix/mask 等材料单独列出，避免后续升级时把 fixed baseline 环境值误认为算法常量。
- `unidbg_env_fill_350101.md`：记录 350.101 Unidbg 环境补齐过程；包括 `MS.b(0x10003/0x1000022)`、`.msdata/.msf3_<sha1>`、`runtimeObj+0x50/+0x51`、`0xD952C` gate，以及 `-Dmetasec.alignTrueDeviceHttpRuntime=true` 单请求对齐命令。
- `algorithm_validation_350101.md`：算法验收记录；重新跑 C oracle、fixed signer、unidbg 真 SO deterministic replay，并逐项比对 7 个 header 的长度、sha1 和完整值。
- `managed_vm_decode_f19/managed_vm_decode_summary.md`：F19 outer producer 的完整 decode，704 records / unknown 0；与 F20 outer opcode/mnemonic 全同型。
- `managed_vm_decode_sourcework_350101/managed_vm_decode_summary.md`：把分散在多次 unidbg dump 的 F18..F54 source-work 程序合并成一个 decode 总表；四套 outer/adapter/block-loop/scheduler family 都是 complete，全部 unknown 0。
- `managed_vm_decode_adapters_350101/managed_vm_decode_summary.md`：F22/F23/F31/F39/F47/F48 adapter/block-loop body decode；全部 unknown 0。
- `managed_vm_decode_roundfamilies_350101/managed_vm_decode_summary.md`：F24/F25/F26/F27/F28/F29/F33/F41/F49/F50/F51/F52/F53/F54 round-family body decode；全部 unknown 0。
- `managed_vm_decode_f3_f14_350101/managed_vm_decode_summary.md`：补齐此前未分类的 F3/F4/F6/F9/F10/F11/F14；七个 descriptor 均为 `kind=1` managed bytecode，解码均为 unknown 0。
- `managed_vm_runtime_350101/`：0x18-record managed VM 的严格可执行 runtime；新增的 F3..F14 覆盖报告均为 `supported_records == records`。`0x5c` 间接 PC 必须由调用方提供 token-to-record 映射；`0x5e` 也显式区分主模块 CF table 与 child-module program table，后者没有 bridge 时严格抛错而非误调 CF。
- `cf63_second_module_f22_recovered_350101.md` / `cf63_cf64_child_module_boundary_350101.md` / `cf64_child_native_abi_350101.md` / `cf64_alias_probe_350101.md` / `cf75_child_module_boundary_350101.md`：三个 child-module 证据边界。CF63/F22 已有精确纯函数实现；CF64/F1 的 child-frame/raw-memory 与 outer-object alias 边界仍未闭合，CF75/F6 则有已证实的 hidden-slot4 target 写入与两条 target-directed path；两者均刻意维持 opaque。CF64 的 84 个可达 F body（28,076 records）已机械解码完毕，`0x0d..0x16` child-native ABI 也已静态闭合；已有一条严格 CF64-origin 的 `0x0e` pre/post trace（4-byte forward copy、`s2=dst`）。新 `cf64_alias_probe_350101.md` 为 F1 直调 F2/F19/F13 的 kind-1 pre/post 采集器；一次 local baseline 只验证了 CF64→F1 scope，未命中三个目标，故仍未闭合跨 F2/F19/F13 的对象别名。其余 helper 的动态覆盖和 outer pointee 写入仍待 trace，不因此升级为实现。CF75 的 F6 本体为 78 records；其 F0 可达的七个 nested body（F0/F1/F2/F3/F4/F5/F7）已静态解码完毕（合计 1,210 records），但 CF15、source alias、20-byte 尾部和目标对象生命周期仍未闭合，不能因此升级为实现。
- `source_work_static_tables_350101.md`：F36/F44 的静态 256-byte permutation table 定位；从二级表基址 `module.base+0x29f890` 派生出 `+0x484/+0x585` 两个窗口。
- `f12_medusa_subpack_recovered_350101.c`：把嵌套 F12 的 sub-work bit-pack 核心还原成 C oracle；当前大长度路径为 `dst_limit=0x2af,count=31,phase=0,dst+=8,src++`，31 条 `ST64` old/new 向量当前 `failures=0`。
- `f12_bitpack_oracle_350101.md`：由 `f8-watch` 的 31 次 `ST64` old/new 自动反推出 F12 source stream 的验证表；后续升级版本可用 skill 脚本 `metasec_f12_bitpack_oracle.py` 复跑。
- `vm_lift_1f7860/native_vmp_1f7860_recovered.c`：把 `0x124DD4 -> exeVMInner_350(vmCode=0x1F7860)` 还原成 mssdk material 构造伪 C。
- `vm_generic_350101/`：native `exeVMInner_350` 的可复用、严格模式运行时；与 trace decoder 共用指令解码。当前 `0x1F7860` 的 1,132 条真实 32-bit 取指均有证据支持；未知顶层 opcode 或未知 `0x11` selector 仍严格失败。wrapper-ABI manifest 只接受三个同时闭合静态栈布局和 entry 证据的 `entry/vmCode/LR` 对，并由 exact SO size/SHA-256 与完整 `PC/LR/SP/X0..X4` 离线验证进一步收窄；不会把旧 `z/ws` 的 `VM_XMEDUSA` ABI 混入 350.101，也不会模拟 bridge 或 pParam 副作用。
- `vm_generic_350101/opcode_recovery_350101.md`：generic native VMP runtime 的 handler 级证据表；包括 `0x11` 八个已验证 selector、完整的当前 trace 覆盖边界，以及 `0x16` 是普通 ST32、`0x1a` 不使用 common imm16 的校正。

## 可复用 skill

已经沉淀成个人 Codex skill：

```text
/Users/freeman/.codex/skills/metasec-so-recognizer
```

后续升级版本时可以直接说：

```text
用 metasec-so-recognizer 看这个新 libmetasec_ml.so，把 350 的结构和入口对齐过去
```

它会优先走：

1. SO 身份识别：hash / build-id / 字符串锚点。
2. 入口对齐：从 334 旧注释 `getHttpHeadVerify`、350 当前 `buildSignedHttpHeaders*` 和 registry path 找候选。
3. 真机 vs unidbg 入参 dump 对比。
4. read/write trace 聚合并逐步提升结构字段。
5. IDA Local Types / 函数原型 / 注释落库。

## 当前“去 VM 化”的具体含义

这里不是简单把花指令 nop 掉。350.101 这条链有两层 VM/解释器：

1. `0x4CC10 exeVMInner_350` 是 native VMP。wrapper 选择一个 `vmCode`
   入口，例如 `0x1F7860`，解释执行后构造 mssdk material。这个方向的产物是
   `vm_lift_1f7860/native_vmp_1f7860_recovered.c`。
2. `0x1555A4 managedBytecodeRun_350` 是 managed bytecode VM。它跑
   `F5/F7/F8/F13` 程序，再通过 `CFxx` native callback 做 format、copy、
   digest、base64、JSON 写入。这个方向的产物是
   `managed_cf_recovered_350.c` 和 `x_argus_medusa_material_350101.md`。

所以当前做法是“语义 lift / 代码重现”：先把 VM 指令和 CF 原语翻译成人能读的
等价逻辑，再逐步把未知 flattened micro-block 补成具体算法。已经确认的地方直接
命名；CF61 已从 `digest32` 提升为 `SM3`，CF41 已提升为
`SIMON128/256`，CF43 当前 type1 已提升为 `AES-128-CBC`。还没证实的地方
继续保留 `shortHeaderTransform32` 这种形状名。

## 当前已经比较稳的结论

### `x0` 是主 context

`0x149ca8` 入口里：

```text
x0 = MetaSecCtx350 *
x1/x2/x3/x5 = 参数树窗口
x4 = type，当前 trace 为 0x171
x8 = 临时 sign_tree/scratch 栈对象
```

真机上 `x1/x2/x3/x5` 是同一块栈数组的滑动窗口：

```text
x5 = base
x3 = x5 + 0x10
x2 = x5 + 0x20
x1 = x5 + 0x30
```

所以它们不是四个独立结构体，而是同一个 `MetaSecHttpInnerArgPack350` 的四个 0x10 ref 窗口被不同参数位置传进去。

### `x0+0x8` 是 registry / object table

证据：

- `0x14a004`: `ldr x8, [x28, #0x8]`
- `0x14a0c0`: `ldr x0, [x28, #0x8]`
- 后面调用 `sub_1261b0(registry, 2)`

`sub_1261b0` 会在 registry 里按 type 查对象，找到 type 后返回 payload。

进一步看 `0x1261b0/getCookieBodyFun`：

```c
v8 = iterator.value();
if (**(int32_t **)v8 == type) {
    return *(void **)(v8 + 8);
}
```

所以 registry 的节点 payload 至少可以先写成：

```c
typedef struct MetaSecRegistryEntry350 {
    int32_t *type_ptr;
    void    *payload;
} MetaSecRegistryEntry350;
```

也就是说：`registry` 管的是 “type -> object” 的对象表。当前 http trace 里 `type=2` 返回的 `payload` 正好落在 `x0+0x1e0`，因此 `ctx+0x1e0` 才能被确认为一个嵌入对象起点。

### `x0+0x1e0` 是嵌入对象起点

证据：

- `sub_1261b0([x0+0x8], 2)` 返回值在 trace 里等于 `x0+0x1e0`。
- `0x14a0ec` 读 `[x27]`，trace 显示它读的是 `x0+0x1e0`。

所以这里不是普通 qword，而是一个嵌入对象：

IDA 里现在已经提升成：

```c
COOKIE_RISK2 op2; /* x0+0x1e0 */
```

`MetaSecOp2Object350` 只保留在旧笔记里当临时名字。

它内部目前比较稳：

```text
op2+0x00 = ops/vtable
op2+0x60 = shared_ref.obj       -> 顶层 x0+0x240
op2+0x68 = shared_ref.refcnt    -> 顶层 x0+0x248
op2+0x78 = rwlock_holder        -> 顶层 x0+0x258
op2+0x80 = busy/reentry flag    -> 顶层 x0+0x260
```

### `x0+0x240/+0x248` 是引用计数对象对

证据：

- `0x47930`: 读 `[x0]`
- `0x47c78`: 写 `[x19]`
- `0x47c84`: 写 `[x19,#8]`
- `0x4ac04`: 清 `[x19,#8]`

静态逻辑很像：

```c
typedef struct MetaSecSharedRef350 {
    void *obj;
    int32_t *refcnt;
} MetaSecSharedRef350;
```

`0x47c1c` 会：

1. 释放旧 ref。
2. 写入新 obj。
3. `malloc(4)` 作为 refcnt。
4. `*refcnt = 1`。

### `x0+0x258/+0x260` 是锁和 busy 标记

证据在 `0x74000` 附近：

```asm
74020: strb w8, [x19,#0x80]     ; busy = 1
74028: ldr  x8, [x19,#0x78]     ; rwlock holder
7403c: bl   pthread_rwlock_rdlock
7419c: strb wzr,[x19,#0x80]     ; busy = 0
7480c: ldrb w9, [x20,#0x80]     ; check busy
```

因为这里的 `x19/x20` 对应的是 `x0+0x1e0`，所以换算到顶层就是：

```text
x0+0x258 = op2.rwlock_holder
x0+0x260 = op2.busy
```

### `x0+0x3c0..0x500` 是复用 buffer

看 `x0_tail_timeline.md`。

当前 trace 至少分两轮：

1. phase 1：先清零，再写 TLV/env 明文，再由 `0x138560` 拷贝/覆盖出 0xa0 字节结果。
2. phase 2：重新写 `"X-Soter\r\nAAAA..."` 一类文本结果。

因此这里不要拆成一堆 `field_3c0/field_3c1`，应该视为 scratch/output buffer：

```c
uint8_t env_tlv_scratch_3c0[0xa0];
uint8_t transform_out_460[0xa0];
```

## 后续怎么继续补

### 0. 先判断 unidbg 和真机是不是同构

先跑：

```bash
python3 /Users/freeman/project/douyin/dyidre/skills/metasec_entrydump_compare.py \
  --left /Users/freeman/project/douyin/dyidre/runs/350101/entrydump/20260830_201913_wrapper/rf_gumtrace_entrydump_350101.wrapper_entrydump.txt \
  --right /Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_structtrace_x0_1000_20260830_203159.log \
  --left-name real \
  --right-name unidbg \
  --reg x0 --reg x5 --reg x8 \
  --out /Users/freeman/project/douyin/dyidre/versions/350101/real_vs_unidbg_entry_shape.md
```

当前结果：

- `x0` 外层布局基本同构：`q0/q3` shape 对得上，说明主 context 大框架没跑偏。
- `x0.q1/q2/q4/q6/q7` 只有 partial：说明 registry/node 内容里有真机环境差异。
- `x5/x8` partial 很多：说明 header/env 参数节点和 unidbg 输入还没完全贴近真机。

所以后续先不要怀疑 `0x149ca8` 地址或 ABI，优先补 unidbg 的入参/header/env/MS.b。

### 1. 在 IDA 导入草稿结构和注释

打开 350 的 i64 后运行：

```python
exec(open("/Users/freeman/project/douyin/dyidre/skills/ida_apply_metasec_struct_evidence.py").read())
```

它会：

- 导入/更新 `MetaSecCtx350`、`MetaSecOp2Object350`、`MetaSecSharedRef350` 等 Local Types。
- 给 `buildSignedHttpHeadersInner_350` 套原型，让 `a1` 变成 `MetaSecCtx350 *ctx`。
- 给 `registry_find_type_350`、`setObjectAddRef_5`、`shared_ref_release_350`、`op2_fill_locked_350` 套原型。
- 把 `summary.json` 里的字段访问证据打到对应 PC 的 repeatable comment。

当前 IDA 里已经应用过一轮，应该能看到：

```c
__int64 __fastcall buildSignedHttpHeadersInner_350(
        MetaSecCtx350 *ctx,
        REF_JSON_LIST *json_list,
        REF_MEM_BLOCK *url,
        REF_MEM_BLOCK *x_ss_stub,
        int type,
        REF_TREE_MAP *tree_map)
```

并且 helper 里应该能看到：

```c
dst->obj
dst->refcnt
op2->busy
op2->rwlock_holder
registry->risk_items
registry->fun_mutex
```

### 2. 优先看这些函数

```text
0x149ca8  buildSignedHttpHeadersInner_350，HTTP 签名头构建内层入口
0x1261b0  registry 按 type 查对象
0x47908   shared_ref assign/copy
0x47c1c   shared_ref reset/assign
0x4abd4   shared_ref release
0x74000   op2 读锁 + busy guard
0x7480c   op2 busy 检查路径
0x117eb8  varint/TLV length 编码
0x116a04  TLV/value 写入相关
0x138520  byte copy/output，核心写点是 0x138560
```

### 3. 每次只升级一种字段

建议顺序：

1. 先固定 `MetaSecSharedRef350`。
2. 再固定 `MetaSecOp2Object350`。
3. 再看 `registry` 的节点格式。
4. 最后再拆 `MetaSecNode350` 的字符串/kv 节点。

不要一口气把全部 `ptr_018/ptr_020/...` 都命名死。它们现在只是内容上像节点，缺少读写 PC 证据。

可以用 promotion 脚本生成下一轮列表：

```bash
python3 /Users/freeman/project/douyin/dyidre/skills/metasec_struct_promote.py \
  --summary /Users/freeman/project/douyin/dyidre/versions/350101/summary.json \
  --reg x0 \
  --out /Users/freeman/project/douyin/dyidre/versions/350101/x0_promote_plan.md
```

它会把当前 offset 分成：

- `ref_pair/stable_field`：可以写进草稿结构。
- `embedded_candidate`：下一轮要对指针目标继续 dump/watch。
- `scratch_buffer`：只看时间线，不拆单字段。

### 4. unidbg 补环境时优先看差异字段

当前 unidbg 还有一些 `MS.b` 返回 `null/空串`：

```text
0x10008
0x2000001
0x2000002
0x1000019
0x100001e
0x1000026
0x1000022
...
```

这些会影响 `x0+0x3c0` TLV/env buffer 内容，从而影响 VM/签名路径。后续如果真机和 unidbg trace 分叉，就优先补这些 op 的返回。

当前已经确认的 350.101 `MS.b`/runtime 语义：

```text
0x10003
  返回 Java 层可见的 .msdata 根目录：
  /data/user/0/com.ss.android.ugc.aweme/files/.msdata

0x1000022
  不是直接返回配置值，而是 repo/key KV 读取。
  repo = d8b674543fc0b023b69f6a3f5a0f287d458ea204
  file = .msf3_<sha1(key)>
  path = <rootfs>/data/user/0/com.ss.android.ugc.aweme/files/.msdata/mssdk/ml/<file>
  返回值 = 文件原始 bytes 的 hex 字符串。

0x14F94C runtime config init
  查询 d_signv5_ctrl / signv5_ctrl / signv5_ctrl.fixedvalue，
  最终落到 runtimeObj+0x51 / runtimeObj+0x50。

0x1503AC / 0x149F60
  读取 runtimeObj+0x50 || runtimeObj+0x51。
  真机 HTTP 请求中返回 1，0x14A250 bit0=1，因此跳过 F5/F7，仅走 F8/F13。

0xD9044 / 0xD952C runtime gate
  真机 HTTP window 中返回 0，因此会继续触发 smallB / vmCode 0x1ECAF0。
```

短跑真机分支对齐命令：

```bash
cd /Users/freeman/project/douyin/unidbg/unidbg-android
java -cp "target/test-classes:../unidbg-api/target/classes:target/classes:$(cat target/test.cp)" \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.countOneRequest=true \
  -Dmetasec.probeHttpBranches=true \
  -Dmetasec.alignTrueDeviceHttpRuntime=true \
  com.ss.android.ugc.aweme.Sign6_350101
```

`-Dmetasec.alignTrueDeviceHttpRuntime=true` 是 350.101 当前的分支归一化快捷开关：

```text
runtimeObj+0x50 signv5_ctrl   = 1
runtimeObj+0x51 d_signv5_ctrl = 0
0xD952C runtime gate byte     = 0
```

验证日志：

```text
unidbg/unidbg-android/target/sign6_350101_alignruntime_20260831_125333.log
unidbg/unidbg-android/target/sign6_350101_rootfs_pixel6_20260831_133047.log
```

这次结果：

```text
branch_helper_ret_149f60: x0=1
branch_f5f7_gate_14a250: bit0=1 -> skip F5/F7
runtimeGate_d952c: ret_byte=0/global=0

exeVMInner.vmCode:
  0x1EC670 x2
  0x1ECAF0 x1
  0x1F7860 x1
```

旧的 `alignruntime` 日志里曾多出 `0x201800 x1`。同步 Pixel6 350.101
真机 `.msdata/mssdk/ml` 到 rootfs 后已经消失，所以后续还原 X-header
算法时，以 `0x1EC670/0x1ECAF0/0x1F7860` 作为当前核心 VM 链。

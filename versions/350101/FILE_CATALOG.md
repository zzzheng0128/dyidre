# 350101 文件来源、生成脚本和后续用途

这个文件是版本目录的交接清单。它回答三个问题：

- 这个文件怎么来的；
- 是哪个脚本或流程生成的；
- 后面升级版本时它有什么用。

它的主要目的不是归档，而是给下一个版本复用。比如分析 37xx 时，
先拿本目录当 350101 基准：同类文件照着生成，同类结论逐项对齐，
能复用的 C oracle/结构/offset 定位方法直接迁移，不能复用的地方留下差异证据。

更新命令：

```bash
python3 scripts/generate_version_file_catalog.py 350101
```

如果你是在包含 `dyidre/` 的上级工作区执行，则把命令前面加 `dyidre/`。

版本目录：

```text
versions/350101
```

## 升级新版本时怎么用

| 350101 文件类型 | 分析 37xx 时怎么用 |
|---|---|
| `metasec_so_identity.md` / `materials_manifest.md` | 先确认 37xx 的 APK/SO/i64 身份，不要靠文件名猜版本。 |
| `analysis_trajectory_350101.md` / `README.md` | 复制成新版本轨迹，逐项替换 offset、hash、日志和结论。 |
| `probes/<version>/` 对应脚本产物 | 先复制 350101 probe，改 offset 表，再抓一条真机基准请求。 |
| `real_vs_unidbg_entry_shape.md` / `environment_inputs_350101.md` | 对齐入口 ABI 和真机环境；37xx 跑不通时先查这里对应字段。 |
| `managed_vm_decode*/` / `managed_cf_*` | 对比 F 程序、CF 表、slot/handler 是否漂移；优先看 unknown opcode 和 CF index。 |
| `x_argus*` / `x_medusa*` / `source_work*` | 按 header 分段验证，确认 37xx 是沿用算法、换常量，还是换 VM 程序。 |
| `*_recovered_*.c` / `metasec_*fixed_signer.c` | 作为 byte-exact oracle；37xx 每还原一段就补向量跑回归。 |
| `ida_rename_update_*.md` / `metasec_structs_*_all.h` | 迁移 IDA 命名、结构和中文注释，但必须用 37xx 证据重新确认。 |

## 分类统计

| 分类 | 数量 |
|---|---:|
| managed VM decode 统计 | 141 |
| managed VM decoded asm | 124 |
| managed VM linear C | 124 |
| 分析报告 | 25 |
| 机器可读证据 | 23 |
| 请求向量 | 23 |
| managed VM decode 目录 | 17 |
| source-work 报告 | 11 |
| 二进制向量 | 11 |
| 路径 diff 报告 | 10 |
| C oracle | 8 |
| CF 恢复报告 | 6 |
| X-Argus 报告 | 6 |
| X-Medusa 报告 | 4 |
| 运行日志 | 4 |
| native VMP 证据 | 3 |
| 后处理脚本 | 3 |
| 目录 | 3 |
| 请求对比证据 | 3 |
| 路径序列 | 3 |
| CF 表 | 2 |
| eDBG/stackplz | 2 |
| managed VM | 2 |
| runner 脚本 | 2 |
| 固定请求 signer | 2 |
| 结构体 | 2 |
| 结构证据 | 2 |
| 请求对比目录 | 2 |
| C oracle runner | 1 |
| C oracle suite | 1 |
| C oracle 接口 | 1 |
| C 代码 | 1 |
| CF C lift | 1 |
| CF 语义 | 1 |
| HTTP 总流程 | 1 |
| IDA 落库 | 1 |
| SO 身份 | 1 |
| X-header C oracle | 1 |
| X-header 算法 | 1 |
| X-header 链路 | 1 |
| managed VM lift | 1 |
| native VMP | 1 |
| native VMP C lift | 1 |
| native VMP lift 目录 | 1 |
| unidbg 环境 | 1 |
| 交接清单 | 1 |
| 入口 ABI | 1 |
| 入口文档 | 1 |
| 分析轨迹 | 1 |
| 指令路径 diff 目录 | 1 |
| 控制流混淆 | 1 |
| 环境输入 | 1 |
| 真机请求向量 | 1 |
| 确定性复现 | 1 |
| 确定性验收 | 1 |
| 算法验收 | 1 |
| 结构提升 | 1 |
| 结构时间线 | 1 |
| 结构草稿 | 1 |
| 请求基准 | 1 |

## 文件清单

| path | size | 分类 | 怎么来 | 生成脚本/流程 | 后续用途 |
|---|---:|---|---|---|---|
| `FILE_CATALOG.md` | 106.3K | 交接清单 | 目录扫描生成 | scripts/generate_version_file_catalog.py | 说明本目录文件来源、生成脚本和后续用途；提交前可重跑更新。 |
| `README.md` | 25.3K | 入口文档 | 人工整理 | 手工维护 | 接手 350101 先读，快速知道当前结论和核心文件。 |
| `algorithm_validation_350101.md` | 6.1K | 算法验收 | C oracle + unidbg deterministic replay | run_recovered_c_oracles_350101.sh + unidbg baseline | 提交前确认算法是否仍然 byte-exact。 |
| `analysis_trajectory_350101.md` | 10.0K | 分析轨迹 | 350101 实际分析过程沉淀 | 人工维护 | 后续升级版本复制成 analysis_trajectory_<version>.md，逐项替换证据。 |
| `build_signed_http_headers_350_recovered.c` | 15.3K | HTTP 总流程 | IDA 反编译 + trace 证据人工 lift | 人工维护 | 从请求到 X-header 写出的主流程伪 C。 |
| `c_recovery_suite_350101.md` | 5.8K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `c_recovery_suite_350101_det_after_fix.log` | 5.2K | 运行日志 | oracle/unidbg/脚本运行输出 | 对应 runner 或验证脚本 | 复查当时结果；可用新 run 替换 latest。 |
| `c_recovery_suite_350101_run.log` | 5.6K | 运行日志 | oracle/unidbg/脚本运行输出 | 对应 runner 或验证脚本 | 复查当时结果；可用新 run 替换 latest。 |
| `c_recovery_suite_350101_validation_latest.log` | 5.6K | 运行日志 | oracle/unidbg/脚本运行输出 | 对应 runner 或验证脚本 | 复查当时结果；可用新 run 替换 latest。 |
| `cf03_rc4_residue_transpose_350101.md` | 2.9K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf16_rand_recovered_350101.md` | 1.1K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf22_cf23_cf24_sdk_identity_350101.md` | 3.1K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf40_cf96_ref_assign_recovered_350101.md` | 1.0K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf41_plain92_proto_350101.md` | 3.3K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf41_simon128_256_recovered_350101.c` | 7.5K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `cf41_simon128_256_recovered_350101.md` | 4.6K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf41_xargusstruct_decode_350101.md` | 1.5K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf43_aes128_cbc_recovered_350101.c` | 11.2K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `cf43_aes128_cbc_recovered_350101.md` | 2.2K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf48_f17_recovered_350101.c` | 10.6K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `cf48_short_transform_lift_350101.md` | 8.6K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf57_strtoull_recovered_350101.md` | 624 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf59_crc8_recovered_350101.md` | 500 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf61_sm3_recovered_350101.c` | 10.2K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `cf61_sm3_recovered_350101.md` | 3.2K | CF 恢复报告 | CF trace + IDA + oracle | 人工整理 | 说明 CF helper 的算法身份和验证向量。 |
| `cf62_cf68_cf70_recovered_350101.md` | 908 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf63_cf64_child_module_boundary_350101.md` | 5.9K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf63_second_module_f22_recovered_350101.md` | 1.7K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf65_context_flag_recovered_350101.md` | 553 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf66_cf89_time_recovered_350101.md` | 745 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf75_child_module_boundary_350101.md` | 8.5K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf80_cf81_globals_recovered_350101.md` | 610 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf93_ref_release_recovered_350101.md` | 424 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `cf_string_decode_and_proto_serializer_350101.md` | 13.7K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `deterministic_350101_x_medusa_raw.bin` | 709 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `deterministic_replay_350101.md` | 7.1K | 确定性复现 | 固定时间/随机/env 的 unidbg replay | run_sign6_350101_deterministic.sh | 验证同一输入每次输出一致。 |
| `deterministic_verify_350101.latest.md` | 3.2K | 确定性验收 | 最近一次 deterministic verify 结果 | verify_unidbg_deterministic_350101.py | 快速查看当前 baseline 是否对齐。 |
| `edbg_assist_plan_350101.md` | 11.0K | eDBG/stackplz | 硬断点/watch 辅助方案 | 人工整理 | RF 太吵时用 eDBG/stackplz 精确追字段写入。 |
| `environment_inputs_350101.md` | 9.4K | 环境输入 | true-env/jnitrace/unidbg stub 汇总 | 人工整理 | 区分算法常量和真机环境值，避免把 fixed env 当算法。 |
| `exeVMInner_x_headers_350101.md` | 21.1K | native VMP | GumTrace + IDA wrapper 分析 | gum-exevm/native-vmp probe + 人工整理 | 说明 0x4CC10 在 X-header 里的角色和 vmCode 分布。 |
| `f12_bitpack_oracle_350101.md` | 3.0K | X-Medusa 报告 | F8/F12/source-work/watch/oracle | true-env/f8-watch/metasec_f12_bitpack_oracle.py + 人工整理 | 恢复 X-Medusa final pack 和 source-work。 |
| `f12_medusa_subpack_recovered_350101.c` | 6.7K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `f18_f21_source_work_outer_compare_350101.md` | 6.3K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `f19_f32_source_work_timeline_350101.md` | 8.0K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `f20_f21_medusa_source_transform_recovered.c` | 25.0K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `f20_f21_source_work_timeline_350101.md` | 8.0K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `f20_f21_source_work_transform_350101.md` | 8.9K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `f20_f40_source_work_timeline_350101.md` | 8.0K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `f5_argus_cf41_cf42_cf43_static_350101.md` | 9.4K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `f5_x_argus_pack_350101_cf43mode_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_pack_350101_cf43mode_ret_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_pack_350101_tail_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_pack_lift_350101.md` | 11.2K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `f5_x_argus_pack_lift_350101_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_pack_lift_cf43mode_350101.md` | 10.7K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `f5_x_argus_pack_lift_cf43mode_350101_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_pack_lift_cf43mode_ret_350101.md` | 11.4K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `f5_x_argus_pack_lift_cf43mode_ret_350101_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_tail_final_c2_cf43mode_350101.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f5_x_argus_tail_final_c2_cf43mode_ret_350101.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `f8_cf79_json_env_fields_350101.md` | 3.2K | X-Medusa 报告 | F8/F12/source-work/watch/oracle | true-env/f8-watch/metasec_f12_bitpack_oracle.py + 人工整理 | 恢复 X-Medusa final pack 和 source-work。 |
| `f8_medusa_mini_xor_recovered_350101.c` | 2.9K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `f8_x_medusa_mutation_watch_350101.md` | 13.2K | X-Medusa 报告 | F8/F12/source-work/watch/oracle | true-env/f8-watch/metasec_f12_bitpack_oracle.py + 人工整理 | 恢复 X-Medusa final pack 和 source-work。 |
| `fixed_s1_s2_signer_350101.md` | 5.1K | 固定请求 signer | C fixed signer 验证说明 | 人工整理 | 说明只输入 s1/s2 + fixed env 生成完整 header 的验收口径。 |
| `flat_dispatch_350101.md` | 6.7K | 控制流混淆 | IDA/GumTrace 分析 | 人工整理 | 识别 flattened dispatcher，避免误判成算法主线。 |
| `ida_rename_update_350101_20260831.md` | 13.8K | IDA 落库 | IDA rename/prototype/comment 记录 | skills/ida_apply_metasec_struct_evidence.py + ida-pro-mcp | 说明哪些名字/中文注释已经写回 IDA。 |
| `instr_diff_350101/` | - | 指令路径 diff 目录 | 真机 GumTrace/instrseq 与 unidbg instrseq 对比 | skills/metasec_instrseq_diff.py | 判断 raw PC 差异是否影响算法主线。 |
| `instr_diff_350101/managed_blr_cf_target_diff_350101_req01_v2.md` | 8.9K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/managed_blr_target_diff_350101_req01.md` | 3.3K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true350101_req01_managed_blr_seq.tsv` | 27.6K | 路径序列 | 真机/unidbg 指令或 BLR/CF 序列 | GumTrace/unidbg trace 后处理 | 给 diff 报告提供原始序列。 |
| `instr_diff_350101/true350101_req01_managed_blr_seq_with_index.tsv` | 38.1K | 路径序列 | 真机/unidbg 指令或 BLR/CF 序列 | GumTrace/unidbg trace 后处理 | 给 diff 报告提供原始序列。 |
| `instr_diff_350101/true350101_req01_vs_unidbg_true_req01_full_fuzzy.md` | 217.4K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true350101_req01_vs_unidbg_true_req01_fuzzy.md` | 181.1K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true350101_vs_unidbg_req01_fuzzy.md` | 59.7K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true_gumtrace_hwm_url.txt` | 836 | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true_vs_unidbg_149cbc_firstdiff.md` | 4.1K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true_vs_unidbg_149cbc_fuzzy.md` | 32.7K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/true_vs_unidbg_fixedtime_149cbc_firstdiff.md` | 11.4K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `instr_diff_350101/unidbg350101_req01_managed_blr_seq.tsv` | 97.0K | 路径序列 | 真机/unidbg 指令或 BLR/CF 序列 | GumTrace/unidbg trace 后处理 | 给 diff 报告提供原始序列。 |
| `instr_diff_350101/xmedusa_value_diff_fixedpid_350101_req01.md` | 5.2K | 路径 diff 报告 | 真机 vs unidbg 指令/语义路径对比 | skills/metasec_instrseq_diff.py + 人工整理 | 确认差异是否只是 helper 级别。 |
| `integrity_guard_ida_350101.md` | 14.2K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `managed_cf_recovered_350.c` | 26.7K | CF C lift | 高价值 CF helper 伪 C | 人工维护 | 把 VM callback 原语变成可读 C。 |
| `managed_cf_semantics_350101.md` | 32.9K | CF 语义 | CF trace + IDA 分析 | 人工整理 | 说明 CFxx helper 各自做什么。 |
| `managed_cf_table_sign_350101.md` | 4.5K | CF 表 | sign module CF 注册表抽取 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_cf_table_probe.py | 新版本快速对齐 CF index/name/callsite。 |
| `managed_cf_trace_summary.json` | 9.8K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_sign_cf_table_350101.md` | 4.4K | CF 表 | sign module CF 注册表抽取 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_cf_table_probe.py | unidbg focused probe 的 callsite 来源。 |
| `managed_vm_boot_350101.md` | 14.4K | managed VM | .init_array/module build 静态分析 + unidbg dump | 人工整理 | 解释 managed module/F 程序怎么启动。 |
| `managed_vm_decode/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode/F13_350101_F13_0x5d2000_0xe70.decoded.asm` | 13.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode/F13_350101_F13_0x5d2000_0xe70.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode/F13_350101_F13_0x5d2000_0xe70.linear.c` | 19.9K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode/F15_350101_F15_0x606200_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode/F15_350101_F15_0x606200_0x2a0.decoded.stats.md` | 428 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode/F15_350101_F15_0x606200_0x2a0.linear.c` | 4.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode/F5_350101_F5_0x67b000_0x4728.decoded.asm` | 69.4K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode/F5_350101_F5_0x67b000_0x4728.decoded.stats.md` | 2.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode/F5_350101_F5_0x67b000_0x4728.linear.c` | 99.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode/F7_350101_F7_0x5d1000_0xea0.decoded.asm` | 13.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode/F7_350101_F7_0x5d1000_0xea0.decoded.stats.md` | 1.3K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode/F7_350101_F7_0x5d1000_0xea0.linear.c` | 20.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode/F8_350101_F8_0x882000_0x21870.decoded.asm` | 438.6K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode/F8_350101_F8_0x882000_0x21870.decoded.stats.md` | 2.8K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode/F8_350101_F8_0x882000_0x21870.linear.c` | 728.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode/managed_vm_decode_summary.md` | 2.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_adapters_350101/F22_350101_F22_0x5e1400_0x1e0.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F22_350101_F22_0x5e1400_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F22_350101_F22_0x5e1400_0x1e0.linear.c` | 3.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/F23_350101_F23_0x62e100_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F23_350101_F23_0x62e100_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F23_350101_F23_0x62e100_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/F31_350101_F31_0x5e1800_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F31_350101_F31_0x5e1800_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F31_350101_F31_0x5e1800_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/F39_350101_F39_0x5e1a00_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F39_350101_F39_0x5e1a00_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F39_350101_F39_0x5e1a00_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/F47_350101_F47_0x5e1c00_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F47_350101_F47_0x5e1c00_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F47_350101_F47_0x5e1c00_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/F48_350101_F48_0x62f600_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_adapters_350101/F48_350101_F48_0x62f600_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_adapters_350101/F48_350101_F48_0x62f600_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_adapters_350101/managed_vm_decode_summary.md` | 3.9K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_f1_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_cf64_f1_350101/F1_350101_F1_0x742000_0xdbd8.decoded.asm` | 178.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_f1_350101/F1_350101_F1_0x742000_0xdbd8.decoded.stats.md` | 2.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_f1_350101/F1_350101_F1_0x742000_0xdbd8.linear.c` | 295.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_f1_350101/managed_vm_decode_summary.md` | 662 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_cf64_reachable_350101/F10_350101_F10_0x75e000_0x3168.decoded.asm` | 40.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F10_350101_F10_0x75e000_0x3168.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F10_350101_F10_0x75e000_0x3168.linear.c` | 66.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F11_350101_F11_0x609400_0x498.decoded.asm` | 4.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F11_350101_F11_0x609400_0x498.decoded.stats.md` | 703 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F11_350101_F11_0x609400_0x498.linear.c` | 6.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F12_350101_F12_0x787000_0x4a28.decoded.asm` | 58.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F12_350101_F12_0x787000_0x4a28.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F12_350101_F12_0x787000_0x4a28.linear.c` | 91.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F13_350101_F13_0x6da000_0x2e68.decoded.asm` | 48.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F13_350101_F13_0x6da000_0x2e68.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F13_350101_F13_0x6da000_0x2e68.linear.c` | 72.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F14_350101_F14_0x609900_0x498.decoded.asm` | 4.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F14_350101_F14_0x609900_0x498.decoded.stats.md` | 703 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F14_350101_F14_0x609900_0x498.linear.c` | 6.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F15_350101_F15_0x78c000_0x4ae8.decoded.asm` | 59.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F15_350101_F15_0x78c000_0x4ae8.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F15_350101_F15_0x78c000_0x4ae8.linear.c` | 92.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F16_350101_F16_0x6dd000_0x2d48.decoded.asm` | 47.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F16_350101_F16_0x6dd000_0x2d48.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F16_350101_F16_0x6dd000_0x2d48.linear.c` | 70.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F17_350101_F17_0x609e00_0x498.decoded.asm` | 4.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F17_350101_F17_0x609e00_0x498.decoded.stats.md` | 703 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F17_350101_F17_0x609e00_0x498.linear.c` | 6.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F18_350101_F18_0x791000_0x4a70.decoded.asm` | 59.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F18_350101_F18_0x791000_0x4a70.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F18_350101_F18_0x791000_0x4a70.linear.c` | 91.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F19_350101_F19_0x757000_0x3168.decoded.asm` | 40.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F19_350101_F19_0x757000_0x3168.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F19_350101_F19_0x757000_0x3168.linear.c` | 66.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F1_350101_F1_0x742000_0xdbd8.decoded.asm` | 178.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F1_350101_F1_0x742000_0xdbd8.decoded.stats.md` | 2.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F1_350101_F1_0x742000_0xdbd8.linear.c` | 295.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F20_350101_F20_0x60a800_0x438.decoded.asm` | 3.6K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F20_350101_F20_0x60a800_0x438.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F20_350101_F20_0x60a800_0x438.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F21_350101_F21_0x60a300_0x438.decoded.asm` | 3.6K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F21_350101_F21_0x60a300_0x438.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F21_350101_F21_0x60a300_0x438.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F2_350101_F2_0x6fb000_0x4b60.decoded.asm` | 59.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F2_350101_F2_0x6fb000_0x4b60.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F2_350101_F2_0x6fb000_0x4b60.linear.c` | 92.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F3_350101_F3_0x750000_0xd8.decoded.asm` | 963 | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F3_350101_F3_0x750000_0xd8.decoded.stats.md` | 348 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F3_350101_F3_0x750000_0xd8.linear.c` | 1.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F4_350101_F4_0x6d7000_0x2e68.decoded.asm` | 48.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F4_350101_F4_0x6d7000_0x2e68.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F4_350101_F4_0x6d7000_0x2e68.linear.c` | 72.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F5_350101_F5_0x608a00_0x498.decoded.asm` | 4.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F5_350101_F5_0x608a00_0x498.decoded.stats.md` | 702 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F5_350101_F5_0x608a00_0x498.linear.c` | 6.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F6_350101_F6_0x77a000_0x4aa0.decoded.asm` | 59.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F6_350101_F6_0x77a000_0x4aa0.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F6_350101_F6_0x77a000_0x4aa0.linear.c` | 91.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F7_350101_F7_0x75a800_0x3168.decoded.asm` | 40.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F7_350101_F7_0x75a800_0x3168.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F7_350101_F7_0x75a800_0x3168.linear.c` | 66.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F8_350101_F8_0x608f00_0x498.decoded.asm` | 4.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F8_350101_F8_0x608f00_0x498.decoded.stats.md` | 702 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F8_350101_F8_0x608f00_0x498.linear.c` | 6.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/F9_350101_F9_0x782000_0x4a70.decoded.asm` | 59.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_cf64_reachable_350101/F9_350101_F9_0x782000_0x4a70.decoded.stats.md` | 2.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_cf64_reachable_350101/F9_350101_F9_0x782000_0x4a70.linear.c` | 91.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_cf64_reachable_350101/coverage_F1_program_table_350101.json` | 610 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_decode_cf64_reachable_350101/managed_vm_decode_summary.md` | 8.1K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_child_f0_350101/F0_350101_F0_0x648000_0xa38.decoded.asm` | 11.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_350101/F0_350101_F0_0x648000_0xa38.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_350101/F0_350101_F0_0x648000_0xa38.linear.c` | 15.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_350101/managed_vm_decode_summary.md` | 642 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_child_f0_reachable_350101/F0_350101_F0_0x648000_0xa38.decoded.asm` | 11.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F0_350101_F0_0x648000_0xa38.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F0_350101_F0_0x648000_0xa38.linear.c` | 15.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F1_350101_F1_0x602600_0x168.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F1_350101_F1_0x602600_0x168.decoded.stats.md` | 380 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F1_350101_F1_0x602600_0x168.linear.c` | 2.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F2_350101_F2_0x62da00_0x6d8.decoded.asm` | 6.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F2_350101_F2_0x62da00_0x6d8.decoded.stats.md` | 1.3K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F2_350101_F2_0x62da00_0x6d8.linear.c` | 9.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F3_350101_F3_0x622200_0x870.decoded.asm` | 7.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F3_350101_F3_0x622200_0x870.decoded.stats.md` | 1.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F3_350101_F3_0x622200_0x870.linear.c` | 12.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F4_350101_F4_0x8b8f00_0x438.decoded.asm` | 3.6K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F4_350101_F4_0x8b8f00_0x438.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F4_350101_F4_0x8b8f00_0x438.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F5_350101_F5_0x8b8a00_0x438.decoded.asm` | 3.6K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F5_350101_F5_0x8b8a00_0x438.decoded.stats.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F5_350101_F5_0x8b8a00_0x438.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/F7_350101_F7_0x70d000_0x4e18.decoded.asm` | 81.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_child_f0_reachable_350101/F7_350101_F7_0x70d000_0x4e18.decoded.stats.md` | 990 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_child_f0_reachable_350101/F7_350101_F7_0x70d000_0x4e18.linear.c` | 116.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_child_f0_reachable_350101/managed_vm_decode_summary.md` | 2.4K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f0_f2_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f0_f2_350101/F0_350101_F0_0x30dc00_0x2d0.decoded.asm` | 3.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f0_f2_350101/F0_350101_F0_0x30dc00_0x2d0.decoded.stats.md` | 597 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f0_f2_350101/F0_350101_F0_0x30dc00_0x2d0.linear.c` | 4.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f0_f2_350101/F1_350101_F1_0x30df00_0x2d0.decoded.asm` | 3.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f0_f2_350101/F1_350101_F1_0x30df00_0x2d0.decoded.stats.md` | 597 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f0_f2_350101/F1_350101_F1_0x30df00_0x2d0.linear.c` | 4.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f0_f2_350101/F2_350101_F2_0xfffffffffffe9500_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f0_f2_350101/F2_350101_F2_0xfffffffffffe9500_0x270.decoded.stats.md` | 977 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f0_f2_350101/F2_350101_F2_0xfffffffffffe9500_0x270.linear.c` | 3.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f0_f2_350101/managed_f0_f2_analysis_350101.md` | 4.6K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `managed_vm_decode_f0_f2_350101/managed_f0_f2_recovered_350101.c` | 4.7K | C oracle | VM/CF/算法人工还原 | 人工维护 | byte-exact 验证具体算法片段。 |
| `managed_vm_decode_f0_f2_350101/managed_vm_decode_summary.md` | 1.2K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f12/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f12/F12_350101_F12_0x5d0000_0xf48.decoded.asm` | 13.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f12/F12_350101_F12_0x5d0000_0xf48.decoded.stats.md` | 1.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f12/F12_350101_F12_0x5d0000_0xf48.linear.c` | 20.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f12/managed_vm_decode_summary.md` | 760 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f16_f17_f18/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f16_f17_f18/F16_350101_F16_0x5e1600_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f16_f17_f18/F16_350101_F16_0x5e1600_0x1f8.decoded.stats.md` | 719 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f16_f17_f18/F16_350101_F16_0x5e1600_0x1f8.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f16_f17_f18/F17_350101_F17_0x8721c0_0x198.decoded.asm` | 1.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f16_f17_f18/F17_350101_F17_0x8721c0_0x198.decoded.stats.md` | 667 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f16_f17_f18/F17_350101_F17_0x8721c0_0x198.linear.c` | 2.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f16_f17_f18/F18_350101_F18_0x72c000_0x4680.decoded.asm` | 57.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f16_f17_f18/F18_350101_F18_0x72c000_0x4680.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f16_f17_f18/F18_350101_F18_0x72c000_0x4680.linear.c` | 95.9K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f16_f17_f18/managed_vm_decode_summary.md` | 1.3K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f19/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f19/F19_350101_F19_0x8af000_0x4200.decoded.asm` | 54.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f19/F19_350101_F19_0x8af000_0x4200.decoded.stats.md` | 1.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f19/F19_350101_F19_0x8af000_0x4200.linear.c` | 89.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f19/managed_vm_decode_summary.md` | 2.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f20_f40_f43_46/F20_350101_F20_0x879000_0x4200.decoded.asm` | 54.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F20_350101_F20_0x879000_0x4200.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F20_350101_F20_0x879000_0x4200.linear.c` | 89.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/F40_350101_F40_0x62ef00_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F40_350101_F40_0x62ef00_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F40_350101_F40_0x62ef00_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/F43_350101_F43_0x606b00_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F43_350101_F43_0x606b00_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F43_350101_F43_0x606b00_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/F44_350101_F44_0x5d9680_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F44_350101_F44_0x5d9680_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F44_350101_F44_0x5d9680_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/F45_350101_F45_0x5e2200_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F45_350101_F45_0x5e2200_0x1f8.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F45_350101_F45_0x5e2200_0x1f8.linear.c` | 3.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/F46_350101_F46_0x87e000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f20_f40_f43_46/F46_350101_F46_0x87e000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f20_f40_f43_46/F46_350101_F46_0x87e000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f20_f40_f43_46/managed_vm_decode_summary.md` | 3.9K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f21/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f21/F21_350101_F21_0x8aa000_0x4680.decoded.asm` | 57.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f21/F21_350101_F21_0x8aa000_0x4680.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f21/F21_350101_F21_0x8aa000_0x4680.linear.c` | 95.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f21/managed_vm_decode_summary.md` | 2.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f30_f42/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f30_f42/F30_350101_F30_0x5e2000_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f30_f42/F30_350101_F30_0x5e2000_0x1f8.decoded.stats.md` | 1.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f30_f42/F30_350101_F30_0x5e2000_0x1f8.linear.c` | 2.9K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f30_f42/F42_350101_F42_0x60cb00_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f30_f42/F42_350101_F42_0x60cb00_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f30_f42/F42_350101_F42_0x60cb00_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f30_f42/managed_vm_decode_summary.md` | 903 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f32_family/F32_350101_F32_0x62e800_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F32_350101_F32_0x62e800_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F32_350101_F32_0x62e800_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/F34_350101_F34_0x60c600_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F34_350101_F34_0x60c600_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F34_350101_F34_0x60c600_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/F35_350101_F35_0x606800_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F35_350101_F35_0x606800_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F35_350101_F35_0x606800_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/F36_350101_F36_0x5d9180_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F36_350101_F36_0x5d9180_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F36_350101_F36_0x5d9180_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/F37_350101_F37_0x5d9400_0x258.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F37_350101_F37_0x5d9400_0x258.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F37_350101_F37_0x5d9400_0x258.linear.c` | 3.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/F38_350101_F38_0x7bf000_0xe70.decoded.asm` | 12.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f32_family/F38_350101_F38_0x7bf000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f32_family/F38_350101_F38_0x7bf000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f32_family/managed_vm_decode_summary.md` | 3.9K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_f3_f14_350101/F10_350101_F10_0x32ac00_0x990.decoded.asm` | 7.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F10_350101_F10_0x32ac00_0x990.decoded.stats.md` | 1.3K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F10_350101_F10_0x32ac00_0x990.linear.c` | 12.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F11_350101_F11_0x3b8000_0x5c40.decoded.asm` | 97.4K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F11_350101_F11_0x3b8000_0x5c40.decoded.stats.md` | 899 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F11_350101_F11_0x3b8000_0x5c40.linear.c` | 145.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F14_350101_F14_0x46c800_0x3078.decoded.asm` | 43.0K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F14_350101_F14_0x46c800_0x3078.decoded.stats.md` | 1.8K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F14_350101_F14_0x46c800_0x3078.linear.c` | 64.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F3_350101_F3_0xfffffffffffe9780_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F3_350101_F3_0xfffffffffffe9780_0x270.decoded.stats.md` | 977 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F3_350101_F3_0xfffffffffffe9780_0x270.linear.c` | 3.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F4_350101_F4_0xfffffffffffd8a80_0x198.decoded.asm` | 1.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F4_350101_F4_0xfffffffffffd8a80_0x198.decoded.stats.md` | 425 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F4_350101_F4_0xfffffffffffd8a80_0x198.linear.c` | 2.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F6_350101_F6_0xfffffffffffe9a00_0x258.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F6_350101_F6_0xfffffffffffe9a00_0x258.decoded.stats.md` | 538 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F6_350101_F6_0xfffffffffffe9a00_0x258.linear.c` | 3.4K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/F9_350101_F9_0x5c0000_0x3f678.decoded.asm` | 830.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_f3_f14_350101/F9_350101_F9_0x5c0000_0x3f678.decoded.stats.md` | 2.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_f3_f14_350101/F9_350101_F9_0x5c0000_0x3f678.linear.c` | 1.3M | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_f3_f14_350101/README.md` | 1013 | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `managed_vm_decode_f3_f14_350101/managed_vm_decode_summary.md` | 2.3K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_roundfamilies_350101/F24_350101_F24_0x62fd00_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F24_350101_F24_0x62fd00_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F24_350101_F24_0x62fd00_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F25_350101_F25_0x608500_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F25_350101_F25_0x608500_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F25_350101_F25_0x608500_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F26_350101_F26_0x606500_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F26_350101_F26_0x606500_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F26_350101_F26_0x606500_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F27_350101_F27_0x5d8c80_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F27_350101_F27_0x5d8c80_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F27_350101_F27_0x5d8c80_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F28_350101_F28_0x5d8f00_0x228.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F28_350101_F28_0x5d8f00_0x228.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F28_350101_F28_0x5d8f00_0x228.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F29_350101_F29_0x731000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F29_350101_F29_0x731000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F29_350101_F29_0x731000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F33_350101_F33_0x630400_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F33_350101_F33_0x630400_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F33_350101_F33_0x630400_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F41_350101_F41_0x630b00_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F41_350101_F41_0x630b00_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F41_350101_F41_0x630b00_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F49_350101_F49_0x631200_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F49_350101_F49_0x631200_0x648.decoded.stats.md` | 968 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F49_350101_F49_0x631200_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F50_350101_F50_0x8b8000_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F50_350101_F50_0x8b8000_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F50_350101_F50_0x8b8000_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F51_350101_F51_0x606e00_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F51_350101_F51_0x606e00_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F51_350101_F51_0x606e00_0x2a0.linear.c` | 4.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F52_350101_F52_0x5d9900_0x240.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F52_350101_F52_0x5d9900_0x240.decoded.stats.md` | 583 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F52_350101_F52_0x5d9900_0x240.linear.c` | 3.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F53_350101_F53_0x5d9b80_0x228.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F53_350101_F53_0x5d9b80_0x228.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F53_350101_F53_0x5d9b80_0x228.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/F54_350101_F54_0x87f000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_roundfamilies_350101/F54_350101_F54_0x87f000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_roundfamilies_350101/F54_350101_F54_0x87f000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_roundfamilies_350101/managed_vm_decode_summary.md` | 6.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/` | - | managed VM decode 目录 | managed program dump 解码结果 | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_managed_vm_decoder.py | 升级时对照 F 程序 opcode/linear.c/unknown 统计。 |
| `managed_vm_decode_sourcework_350101/F16_350101_F16_0x5e1600_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F16_350101_F16_0x5e1600_0x1f8.decoded.stats.md` | 719 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F16_350101_F16_0x5e1600_0x1f8.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F17_350101_F17_0x8721c0_0x198.decoded.asm` | 1.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F17_350101_F17_0x8721c0_0x198.decoded.stats.md` | 667 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F17_350101_F17_0x8721c0_0x198.linear.c` | 2.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F18_350101_F18_0x72c000_0x4680.decoded.asm` | 57.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F18_350101_F18_0x72c000_0x4680.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F18_350101_F18_0x72c000_0x4680.linear.c` | 95.9K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F19_350101_F19_0x8af000_0x4200.decoded.asm` | 54.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F19_350101_F19_0x8af000_0x4200.decoded.stats.md` | 1.5K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F19_350101_F19_0x8af000_0x4200.linear.c` | 89.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F20_350101_F20_0x879000_0x4200.decoded.asm` | 54.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F20_350101_F20_0x879000_0x4200.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F20_350101_F20_0x879000_0x4200.linear.c` | 89.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F21_350101_F21_0x8aa000_0x4680.decoded.asm` | 57.5K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F21_350101_F21_0x8aa000_0x4680.decoded.stats.md` | 1.6K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F21_350101_F21_0x8aa000_0x4680.linear.c` | 95.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F22_350101_F22_0x5e1400_0x1e0.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F22_350101_F22_0x5e1400_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F22_350101_F22_0x5e1400_0x1e0.linear.c` | 3.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F23_350101_F23_0x62e100_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F23_350101_F23_0x62e100_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F23_350101_F23_0x62e100_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F24_350101_F24_0x62fd00_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F24_350101_F24_0x62fd00_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F24_350101_F24_0x62fd00_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F25_350101_F25_0x608500_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F25_350101_F25_0x608500_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F25_350101_F25_0x608500_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F26_350101_F26_0x606500_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F26_350101_F26_0x606500_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F26_350101_F26_0x606500_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F27_350101_F27_0x5d8c80_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F27_350101_F27_0x5d8c80_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F27_350101_F27_0x5d8c80_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F28_350101_F28_0x5d8f00_0x228.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F28_350101_F28_0x5d8f00_0x228.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F28_350101_F28_0x5d8f00_0x228.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F29_350101_F29_0x731000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F29_350101_F29_0x731000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F29_350101_F29_0x731000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F30_350101_F30_0x5e2000_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F30_350101_F30_0x5e2000_0x1f8.decoded.stats.md` | 1.0K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F30_350101_F30_0x5e2000_0x1f8.linear.c` | 2.9K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F31_350101_F31_0x5e1800_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F31_350101_F31_0x5e1800_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F31_350101_F31_0x5e1800_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F32_350101_F32_0x62e800_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F32_350101_F32_0x62e800_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F32_350101_F32_0x62e800_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F33_350101_F33_0x630400_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F33_350101_F33_0x630400_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F33_350101_F33_0x630400_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F34_350101_F34_0x60c600_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F34_350101_F34_0x60c600_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F34_350101_F34_0x60c600_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F35_350101_F35_0x606800_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F35_350101_F35_0x606800_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F35_350101_F35_0x606800_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F36_350101_F36_0x5d9180_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F36_350101_F36_0x5d9180_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F36_350101_F36_0x5d9180_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F37_350101_F37_0x5d9400_0x258.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F37_350101_F37_0x5d9400_0x258.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F37_350101_F37_0x5d9400_0x258.linear.c` | 3.7K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F38_350101_F38_0x7bf000_0xe70.decoded.asm` | 12.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F38_350101_F38_0x7bf000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F38_350101_F38_0x7bf000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F39_350101_F39_0x5e1a00_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F39_350101_F39_0x5e1a00_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F39_350101_F39_0x5e1a00_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F40_350101_F40_0x62ef00_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F40_350101_F40_0x62ef00_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F40_350101_F40_0x62ef00_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F41_350101_F41_0x630b00_0x678.decoded.asm` | 5.3K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F41_350101_F41_0x630b00_0x678.decoded.stats.md` | 1022 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F41_350101_F41_0x630b00_0x678.linear.c` | 8.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F42_350101_F42_0x60cb00_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F42_350101_F42_0x60cb00_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F42_350101_F42_0x60cb00_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F43_350101_F43_0x606b00_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F43_350101_F43_0x606b00_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F43_350101_F43_0x606b00_0x2a0.linear.c` | 4.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F44_350101_F44_0x5d9680_0x270.decoded.asm` | 2.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F44_350101_F44_0x5d9680_0x270.decoded.stats.md` | 637 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F44_350101_F44_0x5d9680_0x270.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F45_350101_F45_0x5e2200_0x1f8.decoded.asm` | 1.9K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F45_350101_F45_0x5e2200_0x1f8.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F45_350101_F45_0x5e2200_0x1f8.linear.c` | 3.2K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F46_350101_F46_0x87e000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F46_350101_F46_0x87e000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F46_350101_F46_0x87e000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F47_350101_F47_0x5e1c00_0x1e0.decoded.asm` | 1.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F47_350101_F47_0x5e1c00_0x1e0.decoded.stats.md` | 486 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F47_350101_F47_0x5e1c00_0x1e0.linear.c` | 2.8K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F48_350101_F48_0x62f600_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F48_350101_F48_0x62f600_0x648.decoded.stats.md` | 947 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F48_350101_F48_0x62f600_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F49_350101_F49_0x631200_0x648.decoded.asm` | 5.2K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F49_350101_F49_0x631200_0x648.decoded.stats.md` | 968 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F49_350101_F49_0x631200_0x648.linear.c` | 8.1K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F50_350101_F50_0x8b8000_0x408.decoded.asm` | 3.7K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F50_350101_F50_0x8b8000_0x408.decoded.stats.md` | 732 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F50_350101_F50_0x8b8000_0x408.linear.c` | 5.6K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F51_350101_F51_0x606e00_0x2a0.decoded.asm` | 2.8K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F51_350101_F51_0x606e00_0x2a0.decoded.stats.md` | 654 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F51_350101_F51_0x606e00_0x2a0.linear.c` | 4.0K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F52_350101_F52_0x5d9900_0x240.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F52_350101_F52_0x5d9900_0x240.decoded.stats.md` | 583 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F52_350101_F52_0x5d9900_0x240.linear.c` | 3.3K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F53_350101_F53_0x5d9b80_0x228.decoded.asm` | 2.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F53_350101_F53_0x5d9b80_0x228.decoded.stats.md` | 320 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F53_350101_F53_0x5d9b80_0x228.linear.c` | 3.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/F54_350101_F54_0x87f000_0xe70.decoded.asm` | 12.1K | managed VM decoded asm | managed bytecode dump 解码 | metasec_managed_vm_decoder.py | 看原始 VM 指令序列。 |
| `managed_vm_decode_sourcework_350101/F54_350101_F54_0x87f000_0xe70.decoded.stats.md` | 933 | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_decode_sourcework_350101/F54_350101_F54_0x87f000_0xe70.linear.c` | 18.5K | managed VM linear C | decoded asm 线性提升 | metasec_managed_vm_decoder.py | 作为人工 lift/C oracle 的中间层。 |
| `managed_vm_decode_sourcework_350101/managed_vm_decode_summary.md` | 13.1K | managed VM decode 统计 | decoder 统计 | metasec_managed_vm_decoder.py | 确认 unknown opcode 是否为 0，升级时先看这个。 |
| `managed_vm_program_lift_350101.md` | 22.0K | managed VM lift | decoded asm/linear.c 二次提升 | 人工整理 | 把 F 程序提升成业务流程，升级时对照差异。 |
| `managed_vm_recovery_350101.md` | 10.9K | managed VM | managed bytecode decode + trace | metasec_managed_vm_decoder.py + 人工整理 | 记录 opcode、slot 模型、F5/F7/F8/F13 路线。 |
| `managed_vm_runtime_350101/` | - | 目录 | 人工/脚本生成 | 见目录内 README 或上级报告 | 承载同类证据或中间产物。 |
| `managed_vm_runtime_350101/README.md` | 16.4K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `managed_vm_runtime_350101/cf_bindings_350101.json` | 10.7K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F10.json` | 144 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F10_0x32ac00_0x990.json` | 144 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F11.json` | 145 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F11_0x3b8000_0x5c40.json` | 145 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F14.json` | 145 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F14_0x46c800_0x3078.json` | 145 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F3.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F3_0xfffffffffffe9780_0x270.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F4.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F4_0xfffffffffffd8a80_0x198.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F6.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F6_0xfffffffffffe9a00_0x258.json` | 151 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F9.json` | 149 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/coverage_350101_F9_0x5c0000_0x3f678.json` | 149 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `managed_vm_runtime_350101/managed_vm_runtime.py` | 186.2K | 后处理脚本 | 人工整理 | python | 解析日志或验证 deterministic baseline。 |
| `metasec_350101_fixed_signer.c` | 24.4K | 固定请求 signer | C fixed signer 实现 | 人工维护 | 最终算法还原的可执行雏形。 |
| `metasec_350101_recovered_c.h` | 12.9K | C oracle 接口 | 手工整理公共接口 | 人工维护 | 多个 recovered C 文件共享的头文件。 |
| `metasec_350101_recovered_c_suite.c` | 7.3K | C oracle suite | 统一测试入口 | 人工维护 | 把各 CF/header oracle 串起来做回归。 |
| `metasec_ctx350_draft.h` | 5.0K | 结构体 | 动态证据 + IDA 静态访问人工合并 | 人工维护 | 导入 IDA/对照新版本 ctx 布局。 |
| `metasec_so_identity.md` | 709 | SO 身份 | 原始 SO hash/build-id/string anchors | ~/.codex/skills/metasec-so-recognizer/scripts/metasec_so_probe.py | 确认分析结论对应哪份 SO；升级版本第一步对照它。 |
| `metasec_structs_350_all.h` | 56.2K | 结构体 | 334 旧结构 + 350101 动态证据修正 | 人工维护 | 当前结构总快照，IDA Local Types 和 unidbg 注释参考。 |
| `multi_request_compare_350101/` | - | 请求对比目录 | 真机 counter + unidbg one/multi request 对比 | counter-one/counter-multi probe + unidbg baseline | 判断单请求/多请求路径是否稳定。 |
| `multi_request_compare_350101/README.md` | 5.9K | 请求对比证据 | 真机请求与 unidbg 请求对比 | counter probe + unidbg baseline | 定位路径/值差异是否随请求变化。 |
| `multi_request_compare_350101/true_device_metamulti_8req_20260831_121946.json` | 161.7K | 请求对比证据 | 真机请求与 unidbg 请求对比 | counter probe + unidbg baseline | 定位路径/值差异是否随请求变化。 |
| `multi_request_compare_350101/true_req_01_s1.txt` | 195 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_01_s2.txt` | 902 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_02_s1.txt` | 1.9K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_02_s2.txt` | 1.7K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_03_s1.txt` | 927 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_03_s2.txt` | 1.1K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_04_s1.txt` | 160 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_04_s2.txt` | 1.2K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_05_s1.txt` | 834 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_05_s2.txt` | 1.0K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_06_s1.txt` | 903 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_06_s2.txt` | 1.2K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_07_s1.txt` | 869 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_07_s2.txt` | 1.1K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_08_s1.txt` | 881 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `multi_request_compare_350101/true_req_08_s2.txt` | 1.1K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `one_request_compare_350101/` | - | 请求对比目录 | 真机 counter + unidbg one/multi request 对比 | counter-one/counter-multi probe + unidbg baseline | 判断单请求/多请求路径是否稳定。 |
| `one_request_compare_350101/README.md` | 2.8K | 请求对比证据 | 真机请求与 unidbg 请求对比 | counter probe + unidbg baseline | 定位路径/值差异是否随请求变化。 |
| `one_request_compare_350101/true_s1.txt` | 160 | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `one_request_compare_350101/true_s2.txt` | 1.2K | 请求向量 | 真机单请求/多请求样本里的 s1/s2 | counter-one/counter-multi probe + 人工固化 | 升级版本时复跑同类请求，判断算法是否只对一条样本偶然成立。 |
| `real_vs_unidbg_entry_shape.md` | 5.3K | 入口 ABI | 真机 entrydump + unidbg entrydump | skills/metasec_entrydump_compare.py | 确认 X0-X5/X8 参数形态一致，避免 unidbg 输入偏掉。 |
| `recovery_process_350101.md` | 20.7K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `req01_app_log_s1s2_unidbg_sync_350101.md` | 3.5K | 请求基准 | 真机 request01 s1/s2 同步到 unidbg | 人工整理 + unidbg baseline | 说明固定请求怎么来的，后续算法验证都用这一组。 |
| `run_recovered_c_oracles_350101.sh` | 3.9K | C oracle runner | 统一编译/运行脚本 | 人工维护 | 提交前跑它确认 C 还原没坏。 |
| `run_sign6_350101_deterministic.sh` | 1.0K | runner 脚本 | 人工整理 | shell | 一键复跑对应验证或 unidbg 场景。 |
| `run_sign6_350101_trueenv_214509.sh` | 2.0K | runner 脚本 | 人工整理 | shell | 一键复跑对应验证或 unidbg 场景。 |
| `source_work_f23_family_exact_350101.md` | 5.2K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `source_work_family_compare_350101.md` | 6.8K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `source_work_key_schedule_family_350101.md` | 3.5K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `source_work_round_family_graph_350101.md` | 8.6K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `source_work_static_tables_350101.md` | 3.8K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `source_work_vector_selfcheck_350101.c` | 12.5K | C 代码 | 人工整理 | 人工维护 | 算法 lift 或说明性伪 C。 |
| `source_work_vectors_350101.md` | 6.0K | source-work 报告 | managed VM source-work family trace/lift | metasec_workarea_timeline.py + decoder + 人工整理 | 恢复 F18/F19/F20/F21 family 和嵌套变换。 |
| `stackplz_rf_rpc_bridge_350101.md` | 4.2K | eDBG/stackplz | RF RPC + stackplz bridge 实测记录 | stackplz-bridge probe | 后续按 module+offset 下硬断点的模板。 |
| `summary.json` | 99.1K | 结构证据 | entrydump/read-write trace 聚合 | skills/metasec_struct_infer.py | 机器可读结构证据，供结构提升、IDA 注释和后续脚本复用。 |
| `true_device_branch_probe_350101_latest.json` | 980 | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `true_device_one_request_count_350101_latest.json` | 4.2K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `true_env_sync_350101_214509.md` | 7.5K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `true_request_vectors/` | - | 真机请求向量 | 从真机 app log/request dump 固化的 s1/s2 | 人工整理 + unidbg sync 脚本 | 固定算法输入，避免每次换请求造成假差异。 |
| `true_request_vectors/req01_app_log_true_meta.json` | 352 | 请求向量 | 真机 request01 s1/s2 和同步结果 | 人工整理 + unidbg aligned run | 固定后续算法验证输入。 |
| `true_request_vectors/req01_app_log_true_s1.txt` | 160 | 请求向量 | 真机 request01 s1/s2 和同步结果 | 人工整理 + unidbg aligned run | 固定后续算法验证输入。 |
| `true_request_vectors/req01_app_log_true_s2.txt` | 1.2K | 请求向量 | 真机 request01 s1/s2 和同步结果 | 人工整理 + unidbg aligned run | 固定后续算法验证输入。 |
| `true_request_vectors/req01_app_log_unidbg_aligned_summary.json` | 4.6K | 请求向量 | 真机 request01 s1/s2 和同步结果 | 人工整理 + unidbg aligned run | 固定后续算法验证输入。 |
| `true_request_vectors/run_req01_app_log_aligned_unidbg_350101.sh` | 1.6K | 请求向量 | 真机 request01 s1/s2 和同步结果 | 人工整理 + unidbg aligned run | 固定后续算法验证输入。 |
| `unidbg_env_fill_350101.md` | 6.6K | unidbg 环境 | JNI/MS.b/.msdata/rootfs 补齐过程 | 人工整理 + unidbg 日志 | 新版本 unidbg 跑不通时先看这里补环境。 |
| `verify_unidbg_deterministic_350101.py` | 4.7K | 后处理脚本 | 人工整理 | python | 解析日志或验证 deterministic baseline。 |
| `vm_generic_350101/` | - | 目录 | 人工/脚本生成 | 见目录内 README 或上级报告 | 承载同类证据或中间产物。 |
| `vm_generic_350101/README.md` | 10.9K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `vm_generic_350101/coverage_1f7860.json` | 27.2K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `vm_generic_350101/coverage_static_1ec670.json` | 5.8K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `vm_generic_350101/coverage_static_1ecaf0.json` | 5.8K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `vm_generic_350101/native_vmp_runtime.py` | 90.9K | 后处理脚本 | 人工整理 | python | 解析日志或验证 deterministic baseline。 |
| `vm_generic_350101/opcode_recovery_350101.md` | 11.7K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `vm_generic_350101/vmp_entry_analysis_process_350101.md` | 10.6K | 分析报告 | 人工整理或脚本输出后人工修订 | 见报告正文命令/证据段 | 作为升级版本对照和交接说明。 |
| `vm_generic_350101/vmp_entry_summary_350101.json` | 2.3K | 机器可读证据 | probe/unidbg/后处理脚本输出 | 对应 probe 或 scripts 后处理 | 给后续脚本、对比和报告复用。 |
| `vm_lift_1f7860/` | - | native VMP lift 目录 | GumTrace 切片 + native VMP 人工 lift | gum-exevm/native-vmp probe + 人工整理 | 追 vmCode=0x1f7860 的输入输出和 C lift。 |
| `vm_lift_1f7860/gumtrace_1f7860.vmtrace.asm` | 671.8K | native VMP 证据 | GumTrace raw/slice/asm | gum-exevm/native-vmp probe | 支撑 native VMP lift。 |
| `vm_lift_1f7860/gumtrace_1f7860_3pages.vmtrace.asm` | 1.4M | native VMP 证据 | GumTrace raw/slice/asm | gum-exevm/native-vmp probe | 支撑 native VMP lift。 |
| `vm_lift_1f7860/gumtrace_1f7860_slice.log` | 34.7M | native VMP 证据 | GumTrace raw/slice/asm | gum-exevm/native-vmp probe | 支撑 native VMP lift。 |
| `vm_lift_1f7860/native_vmp_1f7860_recovered.c` | 8.2K | native VMP C lift | vmCode=0x1f7860 人工恢复 | GumTrace 切片 + IDA 分析 | 复现 native material builder。 |
| `vmp_handler_log/` | - | 目录 | 人工/脚本生成 | 见目录内 README 或上级报告 | 承载同类证据或中间产物。 |
| `vmp_handler_log/vmp_entry_350101.log` | 109.6K | 运行日志 | oracle/unidbg/脚本运行输出 | 对应 runner 或验证脚本 | 复查当时结果；可用新 run 替换 latest。 |
| `x0_evidence.md` | 31.8K | 结构证据 | X0/ctx 读写证据聚合 | skills/metasec_struct_infer.py | 按 offset 看 ctx 字段证据，升级时对照字段是否漂移。 |
| `x0_promote_plan.md` | 5.5K | 结构提升 | summary.json 二次整理 | skills/metasec_struct_promote.py | 说明哪些字段可提升、哪些字段继续观察。 |
| `x0_struct.h` | 1.9K | 结构草稿 | X0/ctx offset 自动骨架 | skills/metasec_struct_infer.py | 早期稀疏结构草稿；不直接当最终结构。 |
| `x0_tail_timeline.md` | 3.3K | 结构时间线 | ctx 尾部 scratch/output 写入时间线 | skills/metasec_struct_infer.py | 追 ctx+0x3c0..0x500 一类输出/scratch 区。 |
| `x_argus_medusa_material_350101.md` | 19.0K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `x_argus_pack_350101.md` | 2.3K | X-Argus 报告 | F5/CF pack/watch/oracle | metasec_argus_*_report.py + 人工整理 | 恢复 X-Argus pack、加密、base64 链路。 |
| `x_argus_pack_350101_cf44_input.bin` | 194 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |
| `x_headers_algorithms_350101.c` | 39.9K | X-header C oracle | 算法还原代码 | 人工维护 | 固定输入下生成/验证各 X-* header 的 C 实现。 |
| `x_headers_algorithms_350101.md` | 7.4K | X-header 算法 | 各 CF/VM/C oracle 汇总 | 人工整理 | 按 header 口径看算法还原进度。 |
| `x_headers_generation_350101.md` | 21.0K | X-header 链路 | TreeMap put/xheader probe + IDA 路径 | 人工整理 | 看每个 X-* header 在哪里生成、哪里写出。 |
| `x_medusa_pack_350101.md` | 4.5K | X-Medusa 报告 | F8/F12/source-work/watch/oracle | true-env/f8-watch/metasec_f12_bitpack_oracle.py + 人工整理 | 恢复 X-Medusa final pack 和 source-work。 |
| `x_medusa_pack_350101_cf44_input.bin` | 712 | 二进制向量 | 从 trace/log 提取的 raw pack、CF 输入或 header bytes | metasec_*_report.py / true-env / 人工提取 | C oracle 的 byte-exact 测试向量。 |

## 维护规则

- 新增文件时，先让本脚本生成默认分类。
- 如果出现 `未分类`，说明这个文件的来源/用途还没沉淀，提交前要补分类规则或在版本 README 里解释。
- 脚本生成的清单不是替代分析报告；重点报告仍然要在正文里记录证据、命令和结论。
- 大型真机 raw log 不放在版本目录，放 `runs/<version>/` 或 `_archive/`。


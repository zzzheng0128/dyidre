# 350101 文件来源和作用

这份目录解决一个问题：以后看到文件名，不需要猜“它是怎么来的、有没有用”。

## 主目录

```text
versions/350101/
```

这是当前 350101 的主工作目录。

更完整、可复跑的版本内文件清单已经沉淀到：

```text
versions/350101/FILE_CATALOG.md
```

更新命令：

```bash
python3 scripts/generate_version_file_catalog.py 350101
```

## 核心报告

| 文件 | 来源 | 作用 |
|---|---|---|
| `README.md` | 人工整理 | 350101 主索引，先读它 |
| `summary.json` | 结构 trace 聚合脚本生成 | 机器可读结构证据 |
| `metasec_so_identity.md` | SO probe | 记录 SO 身份、hash、build-id、锚点 |
| `real_vs_unidbg_entry_shape.md` | 真机 entrydump + unidbg entrydump | 对比入口 ABI 和指针形态 |
| `req01_app_log_s1s2_unidbg_sync_350101.md` | 真机请求 + unidbg baseline | 说明 request01 如何同步 |
| `environment_inputs_350101.md` | true-env + unidbg dump | 记录 s1/s2 外参与计算的环境字段 |
| `unidbg_env_fill_350101.md` | jnitrace/true-env/unidbg stub | 记录 `MS.b`、`.msdata`、runtime gate 怎么补 |
| `algorithm_validation_350101.md` | C oracle + unidbg deterministic replay | 当前算法验收结果 |

## HTTP / X-header 链路

| 文件 | 作用 |
|---|---|
| `build_signed_http_headers_350_recovered.c` | 从请求到 header 写出的伪 C 总流程 |
| `x_headers_generation_350101.md` | `X-Argus/X-Gorgon/X-Khronos/X-Ladon/X-Medusa/X-Helios/X-Soter` 生成顺序 |
| `x_headers_algorithms_350101.md` / `.c` | 按 header 口径整理算法还原 |
| `fixed_s1_s2_signer_350101.md` / `metasec_350101_fixed_signer.c` | 固定环境后，只输入 s1/s2 生成完整 headers |
| `c_recovery_suite_350101.md` | C 还原 suite 总说明 |
| `metasec_350101_recovered_c.h` | C oracle 公共接口 |
| `metasec_350101_recovered_c_suite.c` | C oracle 总测试 |
| `run_recovered_c_oracles_350101.sh` | 一键跑 C oracle |

## Managed VM / CF

| 文件 | 作用 |
|---|---|
| `managed_vm_boot_350101.md` | managed VM 从 `.init_array` 初始化的过程 |
| `managed_vm_recovery_350101.md` | managed VM 结构、opcode、slot 模型 |
| `managed_vm_program_lift_350101.md` | F5/F7/F8/F13 和 source-work family 的业务 lift |
| `managed_cf_semantics_350101.md` | CF helper 语义恢复 |
| `managed_cf_recovered_350.c` | 已恢复 CF helper 的伪 C |
| `managed_cf_table_sign_350101.md` / `managed_sign_cf_table_350101.md` | sign module 的 CF 注册表 |
| `managed_vm_decode*/` | 各 F 程序 decode 输出，`.decoded.asm` 和 `.linear.c` 是 VM bytecode 反编译中间产物 |

## Native VMP / exeVMInner

| 文件 | 作用 |
|---|---|
| `exeVMInner_x_headers_350101.md` | `exeVMInner_4cc10` 在 X-header 链路中的作用 |
| `flat_dispatch_350101.md` | native flattened dispatcher 识别记录 |
| `vm_lift_1f7860/native_vmp_1f7860_recovered.c` | `vmCode=0x1f7860` 的 native VMP lift |
| `vm_lift_1f7860/gumtrace_1f7860*.log/asm` | VMP lift 的原始/切片证据 |

## X-Argus 重点

| 文件 | 作用 |
|---|---|
| `x_argus_pack_350101.md` | F5/X-Argus pack 和最终 base64 对齐 |
| `f5_x_argus_pack_lift_*.md` | F5 尾部拼包过程 |
| `cf41_simon128_256_recovered_350101.md` / `.c` | CF41 = SIMON128/256 oracle |
| `cf43_aes128_cbc_recovered_350101.md` / `.c` | CF43 type1 = AES-128-CBC oracle |
| `cf41_plain92_proto_350101.md` / `cf41_xargusstruct_decode_350101.md` | XArgusStruct protobuf 字段 |

## X-Medusa 重点

| 文件 | 作用 |
|---|---|
| `x_medusa_pack_350101.md` | F8/X-Medusa final pack |
| `f8_x_medusa_mutation_watch_350101.md` | F8 work area 变换 watch 记录 |
| `f8_cf79_json_env_fields_350101.md` | F8 里进入 JSON/env 的字段 |
| `f8_medusa_mini_xor_recovered_350101.c` | mini 20-byte XOR oracle |
| `f12_bitpack_oracle_350101.md` | F12 bitpack 反推来源 |
| `f12_medusa_subpack_recovered_350101.c` | F12 subpack oracle |
| `source_work_*`、`f18/f19/f20/f21*` | X-Medusa source-work family 恢复 |

## 真机采集脚本和批次

Frida/RF JS、stackplz、eDBG 的复用说明统一看：

```text
docs/reusable-probes-stackplz-edbg.md
```

| 路径 | 来源 | 作用 |
|---|---|---|
| `probes/350101/metasec_probe_350101.js` | rustFrida JS | 统一 probe 入口，通过 mode 选择 true-env/jnitrace/counter/gumtrace/stackplz bridge |
| `probes/350101/run_metasec_probe_350101.sh` | host shell | 推送统一 JS runtime、spawn App、按 mode 拉回日志到 `runs/350101/<kind>/<timestamp>/` |
| `scripts/extract_true_env_xmedusa.py` | 本地后处理 | 从 raw log 重建 `summary.json`、F8 入参文件、X-Medusa b64/raw |
| `scripts/index_true_env_runs.py` | 本地索引 | 统计 `runs/<version>/true_env_xmedusa/` 下的批次状态 |
| `runs/350101/true_env_xmedusa/latest` | 真机采集 | 当前 true-env 成功基准，指向 `20260831_214509` |
| `runs/350101/true_env_xmedusa/RUNS.md` | `scripts/index_true_env_runs.py` | true-env 批次清单；半成品已删除，只保留当前基准 |
| `mode=jnitrace` | rustFrida JS | JNI 调用采集脚本 |
| `mode=gum-exevm/gum-http` | rustFrida/GumTrace JS | PC trace / VM trace 脚本 |
| `runs/350101/entrydump/` | 真机采集批次 | 入口 ABI 证据 |
| `runs/350101/jnitrace/` | 真机采集批次 | jnitrace/NewString/崩溃定位证据 |
| `runs/350101/edbg_stackplz/` | 辅助采样 | 硬断点、栈、tombstone 等辅助证据 |

## unidbg 对应关系

`dyidre` 的真机证据最终要落到 unidbg 可复跑基准：

| dyidre | unidbg |
|---|---|
| 真机 request01 `s1/s2` | `unidbg-android/src/test/resources/metasec/350101/req01_app_log_s1.txt` / `s2.txt` |
| true-env 约束 | `unidbg-android/src/test/resources/metasec/350101/baseline.properties` |
| 350101 offsets | `Sign6MetaSecBase.MetaSecProfile.v350101()` |
| 验证脚本 | `unidbg/scripts/metasec-350101-req01-baseline.sh` |

## 归档目录

| 路径 | 内容 | 为什么不放顶层 |
|---|---|---|
| `_archive/large_raw_traces/` | 1GB 级 full GumTrace raw log | 只在深度复盘时需要 |
| `_archive/device_boot_images/` | 设备启动/APatch 镜像 | 和签名算法无直接关系 |
| `tools/runtime_payloads/` | `rustfrida`、`*.kpm`、`embed*.so` | 设备运行工具，后续版本直接复用 |
| `_archive/deleted_reproducible_20260831/` | pycache、时间戳、`.last_*` | 可再生垃圾，先归档未硬删 |

确认磁盘要瘦身时，优先删除：

```text
_archive/large_raw_traces/
_archive/device_boot_images/
```

核心报告和 C oracle 不建议删。

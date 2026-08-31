# 350101 true_env_xmedusa 批次索引

这个文件由 `dyidre/scripts/index_true_env_runs.py` 生成。
它只做索引，不替代原始证据；真实日志、bin、b64、tar 仍以各 run 目录为准。

- 当前版本：`350101`
- 采集类型：`true_env_xmedusa`
- latest：`20260831_214509`

## 批次状态

| run_id | 状态 | 文件数 | 大小 | http | F8 | X-Medusa | 说明 |
|---|---|---:|---:|---:|---:|---:|---|
| `20260831_214509` | `baseline-ready` | 25 | 785.0KB | 2 | 2 | 2 | 完整 true-env / F8 / emit / app-files 快照；可作为 unidbg 环境同步基准。 |
| `smoke_true_env_20260901` | `usable-history` | 25 | 241.6KB | 2 | 2 | 2 | 有 summary 和 X-Medusa 事件，但采集字段少于当前基准；适合回看演进。 |

## 文件来源约定

| 文件 | 谁生成 | 作用 |
|---|---|---|
| `rustfrida_console.log` | `run_metasec_probe_<version>.sh true-env ...` 的 host tee | RF spawn/attach 输出，判断注入是否卡住或崩溃。 |
| `true_env_xmedusa_<version>.log` | `metasec_probe_<version>.js mode=true-env` 写到 App 私有目录后由 host 拉回 | 原始真机事件流，是所有后处理的源头。 |
| `true_env_xmedusa_summary.json` | `dyidre/scripts/extract_true_env_xmedusa.py` 从原始 log 归一化 | 机器可读摘要，喂给 unidbg baseline 和差异分析。 |
| `metasec_app_files_snapshot.tar` | true-env 后处理 | App 私有文件快照，用于同步 `.msdata`、`.msf3_*` 等环境状态。 |
| `rootfs_app_files_manifest.json` | true-env 后处理 | 记录哪些 App 文件进入 unidbg rootfs。 |
| `f8_*` / `xmedusa_*` | `dyidre/scripts/extract_true_env_xmedusa.py` | F8 入参、token、stub、lastF8、emit bytes/b64，专门追 `X-Medusa` 值级差异。 |

## 判断规则

- `baseline-ready`：能作为后续版本对齐的真机基准。
- `usable-history`：有价值，但字段不全，只做历史对照。
- `partial`：只有原始日志，不能直接用于 unidbg。
- `failed-bootstrap`：注入/启动失败证据，保留用于排查 RF 稳定性。


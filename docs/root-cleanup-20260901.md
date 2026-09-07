# dyidre 根目录整理记录 2026-09-01

目标：根目录只保留工程入口，不再堆具体脚本、日志、截图和试跑目录。

## 整理后的根目录

```text
dyidre/
  README.md
  docs/
  probes/
  runs/
  scripts/
  skills/
  versions/
  metasec_350101_01/
  materials/
  _archive/
```

其中：

- `probes/`：可复用采集脚本；
- `runs/`：真机采集证据；
- `scripts/`：本地后处理/索引脚本；
- `versions/`：每个版本的分析入口；
- `metasec_350101_01/`：当前 350101 主分析目录；原根目录 `struct_infer_350101_x0_v2/` 已迁入这里；
- `materials/`：每个版本的 APK/SO/i64 本体和 manifest；
- `_archive/`：不作为日常入口的大文件或旧 payload。

## 移动规则

| 原来 | 现在 | 说明 |
|---|---|---|
| 顶层 `*.js`、`run_*.sh` | `probes/350101/` | 350101 offset/ABI 相关采集脚本 |
| `auto_skip_popups.py` | `probes/common/` | 跨版本 UI 辅助脚本 |
| `gumtrace_1165b8.log` | `runs/350101/gumtrace/20260829_1165b8/` | 真机 trace 证据 |
| `gumtrace_4cc10.log`、`.vmtrace.asm` | `runs/350101/gumtrace/20260829_4cc10/` | `exeVMInner @ 0x4CC10` 证据 |
| `formal_20260830_175233/` | `runs/350101/jnitrace/20260830_175233_formal/` | 正式 jnitrace 采集 |
| `newstring_20260830_180047/` | `runs/350101/jnitrace/20260830_180047_newstring/` | NewString 专项采集 |
| `entrydump_only_*` / `wrapper_entrydump_*` / `gumtrace_entrydump_*` | `runs/350101/entrydump/` | HTTP/sign 入口 ABI 证据 |
| `current_aweme_maps*` / `artmethod_maps_check*` | `runs/350101/maps_artmethod/20260829_artmethod_check/` | maps/ArtMethod 检测证据 |
| `stackplz_*` / `edbg_test_*` | `runs/350101/edbg_stackplz/` | 硬断点/栈采样辅助证据 |
| no-RF 对照 logcat | `runs/350101/control/20260830_1725_norf_noperms/` | 注入问题排查对照 |

## 删除规则

按“半成品就删掉”的口径，本轮直接删除了：

- `runs/350101/true_env_xmedusa/20260831_213610`
- `runs/350101/true_env_xmedusa/20260831_213829`
- `runs/350101/true_env_xmedusa/20260831_213859`
- `runs/350101/true_env_xmedusa/20260831_214052`
- `runs/350101/true_env_xmedusa/20260831_214146`
- `runs/350101/true_env_xmedusa/20260831_214401`
- 顶层早期 RF 半成品/崩溃日志：`165302_crashed`、`170154`、`171947`、`spawn_early`、`console2`、`ms` 等；
- 临时 `test.js`；
- 早期结构试验目录：`struct_infer_350101_x0/`、`struct_infer_350101_x8*/`、`struct_infer_350101_args_v2/`。

当前 true-env 只保留：

```text
runs/350101/true_env_xmedusa/latest -> 20260831_214509
```

## 后续新增版本怎么放

新版本不要往根目录放文件，直接建：

```text
probes/<version>/
runs/<version>/
versions/<version>/
```

脚本运行产物必须进入 `runs/<version>/<run_kind>/<timestamp>/`。

# 350101 true_env_xmedusa

这里整理的是 `X-Medusa` 值级对齐时抓的真机环境批次。

## 生成链路

```text
dyidre/probes/350101/run_metasec_probe_350101.sh true-env 90 <run_id>
  ├─ 基于 dyidre/probes/350101/metasec_probe_350101.js 生成 runtime_true-env.js
  ├─ push runtime_true-env.js 到 /data/local/tmp/
  ├─ rustfrida --spawn com.ss.android.ugc.aweme -l runtime_true-env.js
  ├─ host tee 保存 rustfrida_console.log
  └─ 从 App 私有目录拉回 true_env_xmedusa_350101.log

true_env 后处理
  ├─ dyidre/scripts/extract_true_env_xmedusa.py 从 raw log 抽取 summary/json
  ├─ 抽取 F8 pack/url/stub/token/aux
  ├─ 抽取 X-Medusa lastF8/emit b64 + decoded raw
  └─ App 私有文件快照由环境同步步骤打包，给 unidbg rootfs 使用
```

当前可复用索引：

```bash
cd /Users/freeman/project/douyin
python3 dyidre/scripts/index_true_env_runs.py \
  --root dyidre/runs/350101/true_env_xmedusa \
  --out-md dyidre/runs/350101/true_env_xmedusa/RUNS.md \
  --out-json dyidre/runs/350101/true_env_xmedusa/runs_manifest.json
```

如果要从 raw log 重新抽取值级文件：

```bash
python3 dyidre/scripts/extract_true_env_xmedusa.py \
  dyidre/runs/350101/true_env_xmedusa/20260831_214509 \
  --dry-run
```

确认没问题后再加 `--force` 覆盖重建。默认不覆盖已有文件。

## 批次选择

| 批次 | 状态 | 说明 |
|---|---|---|
| `20260831_214509` | 当前基准 | 字段最全，包含 summary、F8 pack、stub/token、lastF8/emit、App files snapshot、rootfs manifest。 |

旧的 `213610/213829/213859/214052/214146/214401` 属于失败或半字段试跑，已按“半成品删除”的口径清掉。

## 文件说明

| 文件 | 来源 | 作用 |
|---|---|---|
| `rustfrida_console.log` | host 脚本 tee | 看 RF 是否注入成功、是否卡住/崩溃。 |
| `true_env_xmedusa_350101.log` | JS 在真机进程内写出 | 原始事件流，后续所有抽取都从这里来。 |
| `true_env_xmedusa_summary.json` | `scripts/extract_true_env_xmedusa.py` | 结构化摘要，记录 module、pid/tid、time、HTTP/F8/emit 事件。 |
| `metasec_app_files_snapshot.tar` | true-env 后处理 | App 私有文件快照，给 unidbg 补 `.msdata` / `.msf3_*`。 |
| `rootfs_app_files_manifest.json` | true-env 后处理 | 记录同步到 unidbg rootfs 的文件清单。 |
| `f8_pack_raw70_event_*.bin` | `scripts/extract_true_env_xmedusa.py` | F8 pack 前 0x70 字节，定位 X-Medusa 输入结构。 |
| `f8_url_or_path_event_*.txt` | `scripts/extract_true_env_xmedusa.py` | F8 里看到的 URL/path 字符串窗口。 |
| `f8_x_ss_stub_event_*.bin` | `scripts/extract_true_env_xmedusa.py` | F8 输入里的 `x-ss-stub` bytes。 |
| `f8_token_block_event_*.txt/bin` | `scripts/extract_true_env_xmedusa.py` | F8 token/material 字段。 |
| `f8_aux_ref_mem_event_*.bin` | `scripts/extract_true_env_xmedusa.py` | F8 辅助 REF/MEM_BLOCK 指针内容。 |
| `xmedusa_lastF8_event_*.b64/raw.bin` | `scripts/extract_true_env_xmedusa.py` | F8 返回值，还没写入 header 前。 |
| `xmedusa_emit_event_*.b64/raw.bin` | `scripts/extract_true_env_xmedusa.py` | `0x14A53C` emit 阶段最终写出的 X-Medusa。 |

## 和 unidbg 的关系

`20260831_214509` 里的值被同步到：

```text
unidbg/unidbg-android/src/test/resources/metasec/350101/baseline.properties
unidbg/scripts/metasec-350101-req01-baseline.sh
dyidre/metasec_350101_01/true_env_sync_350101_214509.md
```

如果新版本出现 `X-Medusa` 不一致，先照这个目录复制一套 `runs/<new_version>/true_env_xmedusa/<run_id>/`，再比较 F8 pack、lastF8、emit 三层。

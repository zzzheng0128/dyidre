# 350101 eDBG / stackplz runs

这里放硬件断点、watch/rwatch、栈采样辅助证据。

| 批次 | 说明 |
|---|---|
| `20260831_edbg_test` | eDBG 早期测试和 tombstone 证据。 |
| `20260831_stackplz` | stackplz clock/offset 测试。 |
| `20260831_stackplz_rf_rpc` | stackplz RPC + rustFrida bridge 测试。 |

脚本在：

```text
dyidre/probes/350101/run_stackplz_*.sh
dyidre/probes/350101/metasec_probe_350101.js mode=stackplz-bridge
```

复用手册：

```text
dyidre/docs/reusable-probes-stackplz-edbg.md
```

## 归档要求

每次新跑一个硬断点/watch 批次，都放到：

```text
dyidre/runs/350101/edbg_stackplz/<run_id>/
```

目录里至少保留：

| 文件 | 作用 |
|---|---|
| `README.md` | 设备、包版本、SO hash、目标 offset、命令、触发动作、结论 |
| `*.console` | 工具启动输出 |
| `*.log` | 命中记录、regs、stack |
| `*.json` 或 `*.txt` | 如果有 RF/eDBG dump，放原始结果 |

如果这批只是失败/半成品，确认不再复盘后直接删，不要留在根目录刷存在感。

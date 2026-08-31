# dyidre archive

这个目录放“不作为日常入口，但暂时不硬删”的内容。

| 目录 | 内容 | 备注 |
|---|---|---|
| `large_raw_traces/` | 1GB 级 GumTrace full raw log | 日常不用；需要重新做 raw PC diff 时再打开 |
| `device_boot_images/` | Pixel6 boot/APatch 镜像 | 和 MetaSec 算法还原弱相关 |
| `runtime_payloads/` | `rustfrida`、`*.kpm`、`embed*.so` | 设备运行 payload；脚本默认仍使用 `/data/local/tmp/...` |
| `deleted_reproducible_20260831/` | pycache、时间戳、`.last_*` | 可再生瞬态文件，先归档而不是硬删 |

如果只想释放磁盘，优先删 `large_raw_traces/`，大约 2.1G。

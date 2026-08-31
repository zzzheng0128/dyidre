# dyidre 清理记录 2026-08-31

## 做了什么

1. 目录重命名：

   ```text
   pixel6_boot -> dyidre
   ```

2. 文档/脚本里的维护性路径引用：

   ```text
   pixel6_boot -> dyidre
   ```

3. 新增统一入口：

   ```text
   dyidre/README.md
   dyidre/docs/toolchain.md
   dyidre/docs/upgrade-runbook.md
   dyidre/docs/350101-file-catalog.md
   dyidre/versions/350101/
   ```

4. 归档大文件：

   ```text
   dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log
   dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log
   ```

5. 归档设备镜像：

   ```text
   dyidre/_archive/device_boot_images/boot-oriole-bp1a.250305.019.img
   dyidre/_archive/device_boot_images/apatch_patched_11224_0.13.3_rtqe.img
   ```

6. 归档运行 payload：

   ```text
   dyidre/_archive/runtime_payloads/rustfrida
   dyidre/_archive/runtime_payloads/embed1.so
   dyidre/_archive/runtime_payloads/embed2.so
   dyidre/_archive/runtime_payloads/embed3.so
   dyidre/_archive/runtime_payloads/hide-so.kpm
   dyidre/_archive/runtime_payloads/wxshadow.kpm
   ```

7. 归档可再生瞬态文件：

   ```text
   dyidre/_archive/deleted_reproducible_20260831/
   ```

   包括 `__pycache__`、`.last_*`、`current_*_ts.txt`。

8. 版本化真机采集批次：

   ```text
   dyidre/runs/350101/true_env_xmedusa/
   ```

   原来散在顶层的 `true_env_xmedusa_350101_<timestamp>/` 已移动到这里，
   并新增：

   ```text
   dyidre/runs/README.md
   dyidre/runs/350101/README.md
   dyidre/runs/350101/true_env_xmedusa/README.md
   dyidre/runs/350101/true_env_xmedusa/RUNS.md
   dyidre/runs/350101/true_env_xmedusa/runs_manifest.json
   ```

   当前 `latest` 指向 `20260831_214509`，这是 350101 的 true-env 基准批次。

## 为什么没有直接删大日志

两个 full GumTrace raw log 加起来约 2.1G，日常分析确实不应该摆在顶层。

但它们是原始证据，不是纯构建产物：后续如果要复盘 raw PC 差异、重新生成 `.seq`、或解释某个 “当时为什么这么命名”，还可能用到。

所以本轮先归档不硬删。确认后可以删除：

```text
dyidre/_archive/large_raw_traces/
```

## 后续清理建议

- 每个新版本只保留一个成功 true-env 批次；
- 失败批次如果没有成为基准，直接删除，避免后续误用；
- `unidbg/unidbg-android/target/` 只保留最新 baseline log，其他跑完即可删；
- 不要删除 `versions/350101/` 里的 `.md/.c/.h/.json`，这些是算法还原证据链。

2026-09-01 又做了一次根目录整理，详见：

```text
dyidre/docs/root-cleanup-20260901.md
```

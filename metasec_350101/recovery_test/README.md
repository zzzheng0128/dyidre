# recovery_test/ — 崩溃恢复端到端演练现场（2026-09-07）

目的：证明「IDB 损坏后，用原始 SO + 恢复脚本能完整救回全部分析成果」。

## 演练流程（可复跑）

```bash
# 1. 全新建库 + 跑恢复脚本（无头模式，约 1-2 分钟）
"/Applications/IDA Professional 9.3.app/Contents/MacOS/idat" \
  -A -Lida_batch.log -Srecovery_test_drive.py libmetasec_ml.so

# 2. 二次开库独立验证（重新打开保存的 i64 回读，不依赖第一轮的内存状态）
"/Applications/IDA Professional 9.3.app/Contents/MacOS/idat" \
  -A -Lida_verify.log -Srecovery_test_verify.py libmetasec_ml_so_recovered.i64
```

## 结果（verify_result.json）

| 类别 | 恢复/总数 |
|---|---|
| 函数/标签命名 | **136 / 136** |
| 函数注释 | **1,210 / 1,210** |
| 解密站点注释 | **2,325 / 2,325** |
| 明文缓存槽命名 | **2,345 / 2,345** |

零 miss。即 `skills/ida_apply_dyidre_enrich_9_3.py` 在全新库上实现完美恢复。

## 文件说明

| 文件 | 说明 |
|---|---|
| `libmetasec_ml.so` | 隔离的样本副本（SHA-256 与原样本一致，恢复脚本会校验） |
| `recovery_test_drive.py` | 驱动：等自动分析完 → SHA-256 校验 → restore → 另存 i64 |
| `recovery_test_verify.py` | 验证：重开 i64，按快照逐条回读比对，写 `verify_result.json` |
| `libmetasec_ml_so_recovered.i64` | 恢复演练产出的数据库（32MB，可直接打开查看效果） |
| `restore_stats.json` | 第一轮恢复统计（rename 2,481 / 注释 3,535 / 0 失败） |
| `verify_result.json` | 第二轮验证结果（上表） |
| `ida_batch.log` / `ida_verify.log` | 两轮无头运行日志 |
| `libmetasec_ml.so.id0/.id1/.id2/.nam/.til` | 第一轮未正常退出残留的临时库文件，可删 |

## 已知边角

- 驱动里 `ida_kernwin.exit(0)` 在 IDA 9.3 不存在（应为 `idc.qexit(0)`），
  导致第一轮结尾报 AttributeError——但保存已先于退出完成，不影响演练结论；
- IDA 内嵌 Python 的 `open()` 默认 ASCII 编码，读写含中文的 JSON 必须显式
  `encoding="utf-8"`（verify 脚本第一轮的失败原因，已修）。

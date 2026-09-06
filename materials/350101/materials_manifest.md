# 350101 analysis materials manifest

这个文件记录当前分析结论对应的原始材料。提交前如果换了 APK/SO、更新了 IDA 注释/结构体/重命名，都要重新生成它。

更新命令：

```bash
scripts/update_materials_manifest.sh --apk materials/350101/source.apk 350101 \
  materials/350101/libmetasec_ml.so \
  materials/350101/libmetasec_ml.so.i64
```

检查是否过期：

```bash
scripts/update_materials_manifest.sh --check --apk materials/350101/source.apk 350101 \
  materials/350101/libmetasec_ml.so \
  materials/350101/libmetasec_ml.so.i64
```

## 材料状态

| role | path | size | mtime | sha256 |
|---|---|---:|---|---|
| raw SO | `materials/350101/libmetasec_ml.so` | 2864144 | 2025-10-16 13:45:07 +0800 | `2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76` |
| IDA i64 | `materials/350101/libmetasec_ml.so.i64` | 50667317 | 2026-09-06 22:02:07 +0800 | `20806d8d52e1c3f5308f48dab0181f6893f7d0bb226903a91440d41a82fff4c5` |
| APK | `materials/350101/source.apk` | 313325639 | 2025-10-16 13:45:07 +0800 | `dda27904ade84d335591af62e09c6100c25bc66f3613a462e3a0874f33313a10` |

## SO 信息

| key | value |
|---|---|
| file | `ELF 64-bit LSB shared object, ARM aarch64, version 1 (SYSV), dynamically linked, BuildID[sha1]=025e51707b4c64f0b578e2dd7f12aa58ca94241a, stripped` |
| build-id | `025e51707b4c64f0b578e2dd7f12aa58ca94241a` |

## APK 信息

| key | value |
|---|---|
| file | `Zip archive data, at least v2.0 to extract, compression method=deflate` |
| embedded libmetasec_ml.so paths | `lib/arm64-v8a/libmetasec_ml.so` |
| first embedded libmetasec_ml.so sha256 | `2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76` |
| embedded SO matches raw SO | `yes` |

## 提交前约束

- 改过 IDA 函数名、结构体、原型、中文注释后，必须保存 `.i64` 并重新跑本脚本。
- 换过 APK 或 `libmetasec_ml.so` 后，必须重新跑本脚本，并同步更新 `metasec_so_identity.md`。
- 默认把 `.apk/.so/.i64` 本体放在 `materials/350101/` 并纳入提交历史；这样 APK 来源、SO、IDA 数据库每次改动都有 git 记录。
- 如果后续改用 Git LFS，也要确保 LFS pointer 和本 manifest 的 hash 对应同一份二进制。
- 不要让 `versions/350101/` 的结论对应一个旧 APK/SO/`.i64`，这是后续版本升级最容易埋雷的地方。

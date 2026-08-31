# 提交前检查清单

这份清单用于提交 `dyidre` / `unidbg` 里 MetaSec 相关改动前做最后校验。

## 0. 安装自动 pre-commit hook

推荐安装 hook，这样每次 `git commit` 时会自动同步 `.apk/.so/.i64` 本体、manifest 和版本目录 `FILE_CATALOG.md`，不需要手动跑同步脚本。

```bash
cd /path/to/dyidre
git init
scripts/install_pre_commit_hook.sh
```

安装后 git 会使用：

```text
githooks/pre-commit
```

hook 会读取：

```text
materials/materials_sources.tsv
```

目前 350101 已配置：

```text
350101  douyin_35_0_0/libmetasec_ml.so  douyin_35_0_0/libmetasec_ml.so.i64  douyin_35_0_0/dy351_vivo.apk
```

临时跳过自动同步：

```bash
DYIDRE_SKIP_MATERIALS_SYNC=1 git commit -m "..."
```

注意：如果你在包含 `dyidre/` 的上级 monorepo 执行，也可以运行 `dyidre/scripts/install_pre_commit_hook.sh`；hook 会自动识别 `dyidre/` 子目录布局。

如果 `versions/<version>/` 存在，hook 还会自动执行：

```bash
python3 scripts/generate_version_file_catalog.py <version>
```

并把 `versions/<version>/FILE_CATALOG.md` 加进本次提交。这样 37xx 新增分析报告、向量、C oracle 后，文件用途清单会跟着更新。

## 1. 手动同步 `.apk/.so/.i64` 本体

如果还没安装 hook，或者想手动同步，执行：

```bash
cd /path/to/dyidre
scripts/sync_metasec_materials.sh 350101 \
  douyin_35_0_0/libmetasec_ml.so \
  douyin_35_0_0/libmetasec_ml.so.i64 \
  douyin_35_0_0/dy351_vivo.apk
```

只检查有没有过期：

```bash
scripts/update_materials_manifest.sh --check \
  --apk materials/350101/source.apk \
  350101 \
  materials/350101/libmetasec_ml.so \
  materials/350101/libmetasec_ml.so.i64
```

新版本把 `350101` 和路径换成对应版本。上面三个源路径如果在 `dyidre` 仓库根目录找不到，脚本会自动尝试到上级工作区查找，所以可以继续写 `douyin_35_0_0/...` 这种路径。

## 2. 如果改过 IDA，确认 `.i64` 已保存

以下操作都算改过 IDA：

- 函数重命名；
- 结构体/Local Types 更新；
- 函数原型更新；
- 关键地址中文注释；
- 全局变量名更新，例如 `g_managedProg_sign_F*_350`。

做完后必须：

1. 保存 IDA 数据库；
2. 更新 `versions/<version>/ida_rename_update_*.md`；
3. 重新跑 `scripts/sync_metasec_materials.sh`；
4. 确认 `.i64` 本体也在本次提交里。

## 3. 如果换过 SO，重新跑身份识别

```bash
python3 ~/.codex/skills/metasec-so-recognizer/scripts/metasec_so_probe.py \
  /absolute/path/to/libmetasec_ml.so \
  --out versions/<version>/metasec_so_identity.md
```

然后再同步本体和 manifest：

```bash
scripts/sync_metasec_materials.sh <version> <so_path> <ida_i64_path> <apk_path>
```

## 4. 跑 unidbg 基准

350101：

```bash
cd ../unidbg
scripts/metasec-350101-req01-baseline.sh
```

看这些是否仍然稳定：

- `s1/s2` 固定请求能正常跑；
- `X-Argus / X-Gorgon / X-Khronos / X-Ladon / X-Medusa / X-Helios / X-Soter` 对齐 baseline；
- `exeVMInner.vmCode/LR` 分布没有异常变化；
- deterministic validation 没失败。

## 5. 确认文档没有断链

至少检查：

```bash
rg -n "TODO|MISS|FIXME" README.md docs versions/350101
```

有 TODO 可以保留，但必须是明确的待办，不要留下“这是什么文件”这种无上下文半成品。

## 6. 提交前最小必带文件

每次 MetaSec 相关提交至少应该包含这些类别里的改动：

```text
materials/<version>/source.apk
materials/<version>/libmetasec_ml.so
materials/<version>/libmetasec_ml.so.i64
materials/<version>/materials_manifest.md
versions/<version>/README.md 或分析报告
versions/<version>/FILE_CATALOG.md          # 版本文件来源/生成脚本/后续用途清单
versions/<version>/ida_rename_update_*.md     # 如果改过 IDA
versions/<version>/metasec_so_identity.md     # 如果换过 SO
unidbg/unidbg-android/src/test/resources/metasec/<version>/  # 如果换过请求/环境
unidbg/scripts/metasec-<version>-*.sh                # 如果改过回归方式
```

`.apk/.so/.i64` 默认要进 git 提交历史；如果后面切 Git LFS，也必须确认 LFS pointer 和 manifest 一起提交。

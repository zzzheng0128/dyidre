# 分析材料目录

这里记录每个版本分析时使用的原始材料，重点是：

- `libmetasec_ml.so`：原始 SO；
- `libmetasec_ml.so.i64`：IDA 数据库，也就是平时口头说的 id64/i64；
- `source.apk`：这份 SO 对应的安装包；
- `materials_manifest.md`：提交前必须更新的材料 hash/大小/build-id 记录。

## 为什么要管这些

MetaSec 分析很依赖版本一致性。只提交脚本和文档，但 `.apk`、`.so` 或 `.i64` 没同步，会出现两个麻烦：

- 后面不知道当前结构体/函数名到底对应哪个 APK/SO；
- IDA 已经改了注释，但 manifest 还是旧 hash，升级新版本时会误判。

所以每次提交前都要更新对应版本的 manifest。

## 更新命令

推荐安装 pre-commit hook，让每次 `git commit` 自动同步：

```bash
cd /Users/freeman/project/douyin/dyidre
git init
scripts/install_pre_commit_hook.sh
```

hook 读取这个表：

```text
materials/materials_sources.tsv
```

新版本只要加一行：

```text
<version>	<so_path>	<ida_i64_path>	<apk_path>
```

如果要手动同步，以 350101 为例：

```bash
cd /Users/freeman/project/douyin/dyidre
scripts/sync_metasec_materials.sh 350101 \
  douyin_35_0_0/libmetasec_ml.so \
  douyin_35_0_0/libmetasec_ml.so.i64 \
  douyin_35_0_0/dy351_vivo.apk
```

检查有没有忘更新：

```bash
scripts/update_materials_manifest.sh --check \
  --apk materials/350101/source.apk \
  350101 \
  materials/350101/libmetasec_ml.so \
  materials/350101/libmetasec_ml.so.i64
```

## 二进制要进提交历史

默认规则：`.apk/.so/.i64` 本体放到：

```text
materials/<version>/
```

并纳入提交历史。APK 是来源，SO 是分析对象，`.i64` 是 IDA 的分析数据库，函数名、结构体、原型、中文注释都在里面；只交文档不交二进制材料，后面接手的人会对不上。

当前已加：

```text
.gitattributes
```

里面把 `.apk/.so/.i64/.idb` 接到 Git LFS。原因很简单：APK 超过 GitHub 普通文件 100MB 限制；用 LFS 后，git 历史里记录 pointer，真正大文件走 LFS 对象。

提交时仍然要一起提交：

```text
materials/<version>/materials_manifest.md
versions/<version>/ida_rename_update_*.md
```

这样每次 `.i64` 的变化都有提交记录，也能通过 manifest 校验具体 hash。

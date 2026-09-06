# recovery_test2/ — 统一恢复脚本的全量端到端演练（2026-09-07）

与 `recovery_test/`（仅 B 侧 enrich）的区别：本轮跑的是**统一恢复脚本**
`skills/ida_rehydrate_metasec_9_3.py`，四个 pass 全部覆盖。

## 复跑

```bash
# 全新建库 + 四段恢复（无头，约 2 分钟）
"/Applications/IDA Professional 9.3.app/Contents/MacOS/idat" \
  -A -Lida_full2.log \
  -S/Users/freeman/project/douyin/dyidre/skills/ida_rehydrate_metasec_9_3.py \
  libmetasec_ml.so

# 二次开库独立验证
"/Applications/IDA Professional 9.3.app/Contents/MacOS/idat" \
  -A -Lida_vfull3.log -Sverify_full.py libmetasec_ml.so.i64
```

## 验证结果（verify_full_result.json，全部通过）

| pass | 成果 | 验证 |
|---|---|---|
| 1 结构体证据 | 33 个 MetaSec 家族 Local Types（TREE_MAP/MetaSecSharedRef350/…）+ 389 条字段证据注释 + 72/78 原型 | ✅ |
| 2 managed CF | 102/102 wrapper 注释、95 命名（`managedCf00_fillMemBlock_350`、`cf61_sm3Digest_…` 抽查命中） | ✅ |
| 3 proto/json | 10 命名 + 1 已有（`pb_message_unpack_by_descriptor` 等 3/3 抽查命中） | ✅ |
| 4 B 侧 enrich | 136 命名 / 1,210 函数注释 / 2,325 站点注释 / 2,345 槽命名 | ✅ 零 miss |

## 本轮踩到的两个坑（已修，留在统一脚本注释里）

1. **runpy.run_path 返回的命名空间 dict 与函数的 `__globals__` 不是同一对象**——
   对返回 dict 打补丁不影响脚本内函数的全局查找（第一轮日志暴露：pass1 读了
   原始路径而非内嵌数据）。修复：改 `_load_module()` 用受控 dict 直接 `exec`。
2. **`ida_typeinf.get_named_type(..., "MetaSecCtx350", NTF_TYPE)` 对这批类型恒
   False**（主 IDB 对照组同样 False）——验证 Local Types 必须用
   `get_ordinal_count` + `get_numbered_type_name` 序号枚举。

## 文件

| 文件 | 说明 |
|---|---|
| `libmetasec_ml.so` | 隔离样本副本（SHA-256 校验过） |
| `libmetasec_ml.so.i64` | 统一恢复产出的完整数据库（32MB） |
| `verify_full.py` / `verify_full_result.json` | 二次开库验证脚本与结果 |
| `ida_full*.log` / `ida_vfull*.log` | 各轮运行日志（full2/vfull3 为最终轮） |
| `proto_json_name_restore/` | pass3 自动留存的原名称记录 |

# IDA 回填报告（B 侧收获 → IDB）

日期：2026-09-07
目标 IDB：`libmetasec_ml.so`（imagebase=0，地址即 RVA）
方式：`ida_mcp.py` → `py_exec_file` 在 IDA 进程内执行 `ida_enrich_apply.py`

## 1. 应用结果

| 类别 | 计划 | 成功 | 跳过 | 失败 |
|---|---:|---:|---:|---:|
| 函数重命名 | 136 | **132** | 4（已有语义名，保护性跳过） | 0 |
| 函数注释（种子证据） | 1,210 | **1,210** | 0 | 0 |
| 站点注释（解密明文） | 2,325 | **2,325** | 0（无覆盖冲突） | 0 |

数据源：`campaign_round3_ledger.json`（404 定性）、`seed_index.json`（1,210 函数）、
`decrypted_strings.json`（2,685 站，去重/无效后 2,325）、`r6_handlers.json`（操作码 handler）。

## 2. 命名规范

- **41 个 curated 手工名**：字符串解密族 `ms_strdec_f1..f6`、数据结构
  `ms_sharedref_create/copy/release`、`ms_msstring_ctor`、`ms_vmframe_slot_read/write`、
  JNI 链 `ms_jni_a_thunk / ms_jni_integrity_prefix / ms_jni_a_flat_dispatcher`、
  签名链 `ms_sign_reqctx_registry_t4 / ms_sign_orchestrator / ms_sign_runtime_cfg_init`、
  检测矩阵坐实件（`ms_detroot_su_path_table`、`ms_detcloudvm_prop_maintable`、
  `ms_antidbg_tracerpid_parser` 等）、MS.a 操作码 handler（`ms_op_2000002_sign` 等）。
- **95 个域名**：`ms_<域短名>_<地址hex>`，仅 高/中 置信度参与重命名
  （低置信度与 sdk_version/plumbing_noise 域只进注释）。
- 函数注释格式：`[域|置信度] decrypted seeds: 种子1 | 种子2 | …`
- 站点注释格式：`ms_str: "<明文>"`

## 3. 安全约束（已在 apply 脚本强制）

1. 重命名只覆盖 IDA 默认名 `sub_<addr>`；350101 遗产名（`*_350` 等）一律不动
   ——本次 4 个跳过即此保护生效；
2. `set_name` 用 `SN_CHECK`，冲突自动加后缀；
3. 站点已有注释时追加而非覆盖；
4. 未保存 IDB：所有改动在 IDA 内存中，确认无误后在 IDA 里 Ctrl+W 落盘；
   不满意直接不保存关闭即可全部回滚。

## 4. 抽样验证（py_eval 回读）

```text
0x39778  ms_detroot_su_path_table      [root_magisk|高(已反编译坐实)] seeds: /system/xbin/su | …
0x3C724  ms_detcloudvm_prop_maintable  [cloud_phone_vm|高] seeds: bd | v04.09.05 | ro.x8.version | …
0x480E4  ms_op_2000002_sign            （MS.a 签名操作 handler）
0xAFE94  ms_antidbg_tracerpid_parser   [anti_debug_proc|高] seeds: pid | tracer_pid | ppid | …
0x12B904 ms_strdec_f1_period8          （周期-8 密钥流解密族 1）
0x33C54  站点注释: ms_str: "bd"
```

## 5. 产物

| 文件 | 用途 |
|---|---|
| `build_enrich_plan.py` | 计划生成器（数据源 → plan JSON），可复跑 |
| `ida_enrich_plan.json` | 回填计划（136 命名 / 1,210 函数注释 / 2,325 站点注释） |
| `ida_enrich_apply.py` | IDA 内执行的应用器（含保护规则） |
| `ida_enrich_result.json` | 应用统计与失败清单（本次失败为 0） |

## 5.5 缓存槽语义化重命名（第二轮，用户确认截图后执行）

截图中的 `qword_2C2710…` 一页确认是解密明文的全局一次性缓存槽。
`ida_slot_rename.py` 按"站点后第一条 STR 到槽页"规则回链配对：

| 指标 | 数值 |
|---|---:|
| 站点成功配对槽位 | 2,354 / 2,358（4 站未配对，已记录） |
| 唯一槽数 | 2,347 |
| 槽重命名成功 | **2,345**（首批 2,240 + 补刀 105） |
| 已有语义名跳过 | 2 |
| 一槽多明文冲突（保留先者，已记录） | 7 |

- 命名格式：`g_str_<明文slug>`，重复明文槽（如 `v04.09.05` 出现于上百个槽）
  用 `g_str_<slug>_<hexaddr>` 保证唯一（首轮 `_2.._99` 数字后缀在超 100 个重复时
  耗尽，`ida_slot_fix.py` 改为地址后缀补齐 105 个）；
- 每个槽同时写入注释 `ms_str: "<明文>"`；
- 抽样回读：`qword_2BBE98 → g_str_bd`、`qword_2C2710 →
  g_str_ro_bootimage_build_date_utc`、`qword_2C2720 → g_str_1player_2ndos_rootfs`；
- 产物：`ida_slot_rename.py` / `ida_slot_fix.py` / `ida_slot_check.py` /
  `ida_slot_rename_result.json`。

## 7. 崩溃容灾：成果已固化为**一份**统一恢复脚本（两轮端到端演练全过）

**唯一维护入口：`skills/ida_rehydrate_metasec_9_3.py`**
（取代 `ida_rehydrate_350101_9_3.py` / `ida_rehydrate_full_9_3.py` /
`ida_apply_dyidre_enrich_9_3.py` 三份旧入口，旧文件仅留档）

| 组成 | 内容 |
|---|---|
| 内嵌数据（4 块 zlib+base64） | B 侧 enrich 快照 421KB + 350101 summary.json 101KB + 草稿结构头 5KB + CF manifest 11KB |
| 内嵌逻辑 | B 侧 enrich 应用器（含全部保护规则） |
| 外部逻辑引用 | 350101 三个 pass 的脚本本体（skills/ 下，稳定代码；数据已被内嵌覆盖，断网/删 versions 目录也能恢复） |
| 校验 | SHA-256 精确匹配样本 + imagebase=0，不符即拒绝 |

**新增成果同步流程**：更新 `dyidre_enrich_snapshot.json`（或 350101 数据文件）→
重跑 `metasec_350101/build_rehydrate_unified.py` → 统一脚本更新。
勿手改生成文件里的 base64 块。

两轮隔离演练：

| 演练 | 范围 | 结果 |
|---|---|---|
| `recovery_test/` | 仅 B 侧 enrich | 136/136、1210/1210、2325/2325、2345/2345 零 miss |
| `recovery_test2/` | **全量四批**（结构体/CF/proto-json/enrich） | 33 个 MetaSec 家族 Local Types + 389 条字段证据注释 + 72/78 原型；CF 102/102 注释、95 命名；proto/json 10+1；enrich 四项 100% —— **全部通过** |

演练踩坑（已修并写进脚本注释）：
1. `runpy.run_path` 返回的 dict 与函数 `__globals__` 不是同一对象，补丁不生效
   → 改 `_load_module()` 受控 exec 加载；
2. `ida_typeinf.get_named_type(NTF_TYPE)` 对 MetaSec 家族类型恒 False（主 IDB 同）
   → 验证 Local Types 必须用序号枚举（`get_ordinal_count` + `get_numbered_type_name`）；
3. `loc_597D4/loc_12FCE0` 不是函数头，首轮命名保护未覆盖 → 已补语义名入快照。

## 6. 后续可加

1. 585 个 unclassified 函数：用 350101 的 managed VM handler 表反查归属后再命名；
2. ~~全局明文缓存槽改名~~（已完成，见 5.5）；剩余 4 个未配对站点可人工核；
3. 0x20000xx 其余 12 个操作码的业务语义坐实后，把 `ms_op_*_business` 换成正式名；
4. 7 条"一槽多明文"冲突值得人工看一眼——多为相邻站点共用检测表槽
   （如 `prb_content_processing` 槽吃掉 `prb_safetyNet/prb_dynIssuance/prb_neo_execution`），
   可能意味着这几个站点实际写的是同一张探针配置表的不同槽，配对窗口需按站点间距收紧。

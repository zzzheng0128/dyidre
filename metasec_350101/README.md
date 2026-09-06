# metasec_350101 — libmetasec_ml.so 逆向分析工作区（总目录）

> 📋 接手请先读 [`HANDOFF.md`](HANDOFF.md)（交接文档：结论速查、遗留清单、工具链、血泪教训）。

目标二进制：抖音 metasec 安全 SDK 的 ML 保护库 `libmetasec_ml.so`
（ELF64 ARM64，stripped，2,864,144 字节，SHA-256 `2416637a…`，唯一导出 `JNI_OnLoad`）。
原始样本在 `/Users/freeman/project/douyin/study/libmetasec_ml.so`，本目录的
`libmetasec_ml.so` 是同哈希副本，所有脚本默认在本目录下运行、读写相对路径。

> 地址口径：全部地址为 module RVA（IDA imagebase=0）。

---

## 0. 战役全景（六轮 + 回填 + 容灾）

| 轮次 | 目标 | 报告 | 状态 |
|---|---|---|---|
| R0 | `0x11FC30`（TREE_MAP insert_or_assign）的 X0 结构体恢复 | `libmetasec_ml_struct_report.md` | ✅ 六结构体手工恢复 |
| R1 | IDA MCP 接入；9,357 函数枢纽分类 | `ida_campaign_round1_report.md` | ✅ 发现第 6 解密族 |
| R2 | 明文种子反查：黑盒批解密 2,685 站 | `ida_campaign_round2_report.md` | ✅ 1,210 函数带明文证据 |
| R3 | 全量 16 域自动分类 | `ida_campaign_round3_report.md` | ✅ 404/1,210 定性 |
| R4 | sign v5 签名链定性 | `ida_campaign_round4_report.md` | ✅ 两条路径闭合 |
| R5/R6 | Java→native 调度实测；17 操作码定案 | `ida_campaign_round5_report.md` | ✅ 0x2000002/05/0E=签名 |
| 回填 | B 侧收获灌入 IDB（命名/注释/槽名） | `ida_enrich_report.md` | ✅ 5,880 项，0 失败 |
| 容灾 | 成果固化成可恢复脚本 + 隔离演练 | `ida_enrich_report.md` §7 | ✅ 二次开库 100% 命中 |

**总入口文档**：`libmetasec_ml_master_report.md`（战役地图 + 二进制画像 + 全部结论索引）。
**跨项目对照**：`crosswalk_350101_vs_dyidre.md`（与 `versions/350101` 存档的逐主题对照、
冲突清单、37xx 复用流程）。

---

## 1. 工具链脚本（模拟器族，按演进顺序）

骨架共用约定：ELF PT_LOAD 映射 → 手工应用 R_AARCH64_RELATIVE/ABS64 重定位 →
GLOB_DAT/JUMP_SLOT 导入槽填 HOOKWIN 窗口 → 伪造 TLS（+0x28 栈金丝雀）/栈/堆 →
`svc #0` 统一返回 0 → LR 指向栈顶哨兵作为返回终点。

| 脚本 | 用途 | 用法 | 状态 |
|---|---|---|---|
| `emu_poc.py` | 概念验证：单函数模拟跑通（解密桩 `0x12C9A4`） | `python3 emu_poc.py`（内置示例） | 考古留档 |
| `emu.py` | 单条解密 CLI：指定解密桩+密文输出明文 | `python3 emu.py 12c9a4 956278 3` → `"22"` | 可用 |
| `batch_decrypt.py` | 批量：pass1 从反汇编提 2,685 个站点密文，pass2 单持久 Unicorn 实例顺序解密 | `python3 batch_decrypt.py` → `decrypted_strings.json` | 可用 |
| `extract_algo.py` | 黑盒算法提取：探针输入推断 5 个解密桩均为「XOR+周期 8 密钥流」 | `python3 extract_algo.py` → `extract_algo_output.txt` | 可用（key 已提出，离线可复算） |
| `jni_onload_emu.py` | JNI_OnLoad 全量模拟：伪造 JavaVM/JNIEnv vtable，观测 JNI 活动 | `python3 jni_onload_emu.py` → `jni_onload_trace.json` | ⚠️ 会在 `0x13B496` 运行时代码解密 stub 阻断（已知边界，见 R0 报告附录 B） |
| `emu_jni.py` | **主力**：MS.a native 主体受控模拟器；ctor 初始化 + context 快照 + emu_stop 重定向 + 软陷阱 | 产出 `emu_jni_blr_all.json` 等 | ✅ 成熟可用 |
| `emu_jni_dbg.py` / `emu_jni_dbg2.py` | emu_jni 开发期的两个调试迭代 | — | ❌ **已废弃**，勿复用（文件头有横幅） |

免模拟器复算字符串：5 个解密族均为 XOR+周期 8 密钥流，key 见
`libmetasec_ml_struct_report.md` 附录 C，直接 `bytes(c^k[i%8] …)` 即可。

## 2. IDA 侧脚本（MCP 客户端与战役脚本）

| 脚本 | 用途 | 备注 |
|---|---|---|
| `ida_mcp.py` | IDA Pro MCP（SSE, 127.0.0.1:13337）极简 JSON-RPC 客户端 | ⚠️ 必须用裸 socket：requests/urllib3 与该服务器分块解码不兼容；用法见文件头 |
| `campaign_round3_classify.py` | 16 域自动分类器：种子词汇打分 → 逐函数台账 | 输入 `seed_index.json`，输出 `campaign_round3_ledger.json`，可复跑 |

## 3. 回填与容灾脚本（2026-09-07 新增）

| 脚本 | 用途 | 运行位置 |
|---|---|---|
| `build_enrich_plan.py` | 由台账/种子/明文/操作码生成回填计划 `ida_enrich_plan.json` | 本机 Python |
| `ida_enrich_apply.py` | 应用计划：136 重命名 + 1,210 函数注释 + 2,325 站点注释 | IDA 内（py_exec_file） |
| `ida_slot_rename.py` | 站点→缓存槽回链配对，`g_str_<slug>` 语义命名 2,240 槽 | IDA 内 |
| `ida_slot_fix.py` | 补刀：重复明文槽改 `g_str_<slug>_<hex>`，补齐 105 个 | IDA 内 |
| `ida_slot_check.py` | 复查/诊断槽命名残留 | IDA 内 |
| `ida_dyidre_snapshot.py` | 从在线 IDB 导出最终状态快照 `dyidre_enrich_snapshot.json` | IDA 内 |
| `build_rehydrate_dyidre.py` | 由快照生成自包含恢复脚本 `skills/ida_apply_dyidre_enrich_9_3.py` | 本机 Python |
| `build_rehydrate_unified.py` | **主生成器**：快照 + 350101 三份数据 → 统一恢复脚本 | 本机 Python |

恢复体系（详见 `ida_enrich_report.md` §7 与 `HANDOFF.md` §5.1）：
**唯一入口 `skills/ida_rehydrate_metasec_9_3.py`**——五批成果（350101 结构体 /
managed CF / proto-json / **integrity guard 反调试链** + 本侧 enrich）数据全内嵌、
SHA-256 校验、一把恢复。pass4 前的 preamble 会补 9 个前置类型声明
（FUN_MUTEX / REF_COOKIE_RISK_ITEMS / jobject / REF_JSON_LIST 等，详见
HANDOFF §6 教训 9-10）。
旧入口 `ida_rehydrate_350101_9_3.py` / `ida_rehydrate_full_9_3.py` /
`ida_apply_dyidre_enrich_9_3.py` 已被取代，**已删除**（2026-09-07，见 HANDOFF §5.1）。
**新增成果同步流程**：更新快照/数据文件 → 重跑 `build_rehydrate_unified.py`
→ 统一脚本更新（勿手改 base64 块）。
**IDB 崩溃恢复**：原始 SO 重开库 → 跑一次统一脚本即全部回来
（演练现场：`recovery_test/`（仅 B 侧）与 `recovery_test2/`（全量五批，三轮全过；
末轮 enrich 136/136 零 miss、guard 3/3、proto 3/3、MetaSec 家族类型 37 个））。

## 4. 数据产物（JSON）

| 文件 | 内容 | 上游脚本 |
|---|---|---|
| `decrypted_strings.json` | 2,685 站：site/dec/len/ct(密文hex)/pt(明文) | batch_decrypt.py |
| `strings_decrypted.txt` | 人类可读明文清单 | 同上 |
| `seed_index.json` | 1,210 函数的种子索引（index: 函数→seeds[]；missed_sites=64） | R2 |
| `campaign_round3_ledger.json` | 1,210 函数分类台账（domain/confidence/score/evidence） | campaign_round3_classify.py |
| `jni_onload_trace.json` | JNI 注册表证据（唯一注册 `MS.a(IIJ String Object)` → `0x12FB84`） | jni_onload_emu.py |
| `r3_*.json` / `r4_*.json` / `r5_*.json` / `r6_*.json` | 各轮反编译/调用链/模拟原始数据 | 各轮战役 |
| `emu_jni_blr_all.json` | MS.a 主体 BLR 间接调用解析结果 | emu_jni.py |
| `ida_enrich_plan.json` / `ida_enrich_result.json` | 回填计划 / 应用统计 | §3 |
| `ida_slot_rename_result.json` | 槽配对统计 + 7 条冲突 + 4 未配对站点 | ida_slot_rename.py |
| `dyidre_enrich_snapshot.json` | **容灾快照**（恢复脚本的数据源） | ida_dyidre_snapshot.py |

## 5. 反汇编中间产物（取证留档）

`full_disasm.txt`（43.6 万行全量反汇编，多脚本输入）、`func_11fc30.asm`、
`callees.asm` / `callees2.asm`（一/二层 callee）、`callers_ctx.asm`（41 个调用点上下文）、
`callsites.txt`、`dec_12b904.asm`（MBA 混淆形态留档）、`r5_jni_bl_targets.txt`、
`r3_*.log` / `r4_*.log` / `batch_err.log` / `err.log`。

## 5.5 init_array/（.init_array 深挖现场，2026-09-07 凌晨并入本目录）

116 个 ctor 的全量模拟分析：`init_array_emu.py`（模拟器，逐项记录解密字符串/
svc/brk/代码段写）、`init_array_report.md`（报告：ctor[0] 反模拟三件套、ctor[1] CF
注册表、ctor[2]/[3] 完整性哨兵、**ctor[93] 运行时代码解密硬证据**、ctor[68/69/86]
三大检测库完整名单、对 mock 项目的映射表）、`init_array_trace.json`（116 ctor
行为轨迹原始证据）、`run_full.log`。两个符号链接：full_disasm.txt、
libmetasec_ml.so（→ study/ 原件）。

## 6. recovery_test/（崩溃恢复演练现场）

隔离目录：SO 副本 + 无头 IDA 全新建库 + 恢复脚本 + 二次开库验证。
结果：136/136、1210/1210、2325/2325、2345/2345 **100% 命中**（`verify_result.json`）。
详见该目录 `README.md`。

## 7. 环境依赖

- 本机脚本：Python 3 + `unicorn`（2.1.4 验证过）；在本目录下运行；
- IDA 侧：IDA Pro 9.3（`/Applications/IDA Professional 9.3.app`）+ ida-pro-mcp 插件
  （SSE 13337），无头模式用 `idat -A -S<script>`；
- 恢复脚本与 350101 恢复器并列放在 `dyidre/skills/`。

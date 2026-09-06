# metasec_350101 交接文档

> 接手人 5 分钟版：这是对抖音 metasec 安全 SDK 的 `libmetasec_ml.so`（350.101）
> 做了**六轮逆向战役 + IDA 成果回填 + 崩溃容灾体系**的工作区。
> 结论总览读 `libmetasec_ml_master_report.md`；
> 目录细节读 `README.md`；与旧项目（versions/350101）的关系读
> `crosswalk_350101_vs_dyidre.md`；IDB 崩了跑
> `skills/ida_rehydrate_metasec_9_3.py` 一键恢复。
> 所有地址 = module RVA（IDA imagebase=0）。

---

## 1. 样本与身份

| 项 | 值 |
|---|---|
| 文件 | `libmetasec_ml.so`（ELF64 ARM64，stripped，2,864,144 字节） |
| SHA-256 | `2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76` |
| Build ID | `025e51707b4c64f0b578e2dd7f12aa58ca94241a` |
| 来源 | 抖音 35.0.0 包（内部版本串 v04.09.05），原件 `/Users/freeman/project/douyin/study/libmetasec_ml.so` |
| 加固 | 字符串加密（6 解密族）+ 控制流平坦化 + 双层 VM（native VMP + managed 字节码 VM） |
| 规模 | 9,357 函数，唯一导出 `JNI_OnLoad`，无标准 JNI 导入（JNIEnv 交互全自实现） |

⚠️ **本目录与 `versions/350101/` 是同一份二进制**：地址可直接互引。350101 是前一轮
深度还原存档（X-* 头算法 byte-exact、双层 VM 严格 runtime、真机/unidbg 证据体系）；
本目录是新一轮广度战役（全量函数台账、检测矩阵、字符串体系、调度实测）+ IDA 回填。
IDB 里的 `*_350` / `managedFrame*_350` 命名是 350101 项目灌入的遗产。

## 2. 核心结论速查（全部已回填进 IDB）

**数据结构**（R0 手工恢复，高置信）：TREE_MAP（全局中心容器，检测项/配置/签名头都是它）、
TREE_IMPL（红黑树）、shared_ref 引用计数协议（`0x4788C/0x44B6C/0x42CE4`，扇入最高 1,598）、
MSString（vtable `0x262AF0`）、hash 表（`0x172AF4`）、VM frame（槽在 `buf+0x8100`）。

**字符串加密**：5 个周期-8 密钥流 XOR 族（`0x12B904/0x12BFA8/0x12C648/0x12C9A4/0x12CF90`，
key 已提取，离线免模拟器可复算，见结构报告附录 C）+ 1 个变长族（`0x15AC98`，密钥未提取，
236 站未收割）。黑盒批解密 2,685 站，2,261 条回锚函数边界。

**加载期防线**：`.init_array` 116 个 ctor；ctor[3]=签名模块 init（`0x1702B8`），
ctor[68/69/86]=root 路径/注入框架/云手机特征预解密库（`0x3C724` 是 119 项明文主表）。

**检测矩阵**（10 域，代表件全部高置信）：root `0x39778`（41 条 su 路径）、
Magisk `0xC5D00`、frida/xposed `0xC710C`、LSPosed/Riru `0x3A6DC`、云手机 `0x3C724`+
`0x7F1A0`、品牌 `0xC2A60`、反调试 `0xAFE94`（TracerPid 解析）、硬件 `0x16B080`、
设备指纹 `0x77EC4`（MediaDrm/UUID）、端口扫描 `0x98780`。

**签名链（sign v5）**：数据面=TREE_MAP；控制面=点分键配置树（`sub_12D910` 查询）。
两条路径：托管模块路径 `0x8EFD8 → 0x14F8C8` 编排器（实测走通）；
HTTP 头路径 `0x14DBF4 wrapper → 0x149CA8 inner`（350101 已 byte-exact 还原 7 个 X-* 头）。

**JNI 调度（emu 实测）**：`MS.a(IIJ String Object)` 唯一注册方法 → `0x12FB84` thunk →
`0x12FCE0` 完整性前缀（表哈希种子 `0x20190512`，失败仅上报 `0x125D34` 不中断）→
`0x597D4` 巨型平坦化调度器（BST 二分 17 个操作码 `0x2000001–0x2000011`）→
**`0x2000002/05/0E` = 签名操作**（0x2000003/04 签名辅助，0x2000007/08 注册表查询）。

## 3. 当前状态

- **IDB 已回填**（2026-09-07，全部在内存中，需人工 Ctrl+W 落盘）：
  132 函数重命名 + 1,210 函数注释 + 2,325 解密站点注释 + 2,345 明文缓存槽语义名
  （`g_str_*`）。保护规则：只覆盖默认名，不动 350101 遗产名。
- **容灾体系已验证**：`skills/ida_rehydrate_metasec_9_3.py` 一份脚本恢复【五批】成果
  （350101 结构体 / managed CF / proto-json / **integrity guard 反调试链** / dyidre enrich），
  隔离环境三轮演练全过（`recovery_test/`、`recovery_test2/`），末轮验证：
  enrich 136/136 零 miss、guard 全局 3/3、proto 3/3、MetaSec 家族类型 37 个。
- **350101 对照完成**：`crosswalk_350101_vs_dyidre.md` 含逐主题互证表 + 6 条待对齐冲突 +
  37xx 六步复用流程。

## 4. 继续分析：遗留清单（按优先级）

| # | 事项 | 抓手 |
|---|---|---|
| 1 | managed VM 主循环地址口径：`0x14B000-0x14D000`（R0 定性）vs `0x1555A4`（350101 解释器）是否同物 | IDA 反编译核对；opcode 表还原直接复用 350101 的 `managed_vm_runtime_350101/` |
| 2 | shared_ref 协议族合并：我方 `0x4788C/0x44B6C/0x42CE4` vs 350101 `0x47908/0x47C1C/0x4ABD4` 六个地址反编译去重 | crosswalk §6-2 |
| 3 | `0x20000xx` 操作码双向语义：MS.a（Java→native）与 MS.b（native→Java）是否同一命名空间，重点 `0x2000002` | 一次联合 trace |
| 4 | 第 6 解密族（`0x15AC98`）密钥流提取 + 236 站收割 | 参考 350101 CF 字符串解码记录 |
| 5 | 585 个 unclassified 函数定性（多为 VM handler/纯算术） | 用 350101 handler 表反查归属 |
| 6 | 7 条"一槽多明文"冲突人工核对（如 prb_* 探针配置槽误配） | `ida_slot_rename_result.json` conflicts |
| 7 | 4 个未配对解密站点 | 同上 unpaired |
| 8 | 其余 12 个 `ms_op_*_business` 操作码坐实后改正式名 | emu_jni.py 复跑 |
| 9 | op2（MS.a 第二 int 参数）语义未探索 | — |

## 5. 工具链速查

| 要做什么 | 用什么 |
|---|---|
| 跟 IDA 对话 | `ida_mcp.py`（SSE 裸 socket 直连 13337；**别用 requests/urllib3**） |
| 解一条密文 | `emu.py <func_hex> <cipher_hex> <len>`，或查附录 C 的 key 直接 XOR |
| 批量解密 | `batch_decrypt.py` → `decrypted_strings.json` |
| 模拟 MS.a 调度 | `emu_jni.py`（先跑 116 个 ctor → context 快照 → 逐操作码重跑） |
| 函数分类 | `campaign_round3_classify.py`（台账 → 16 域） |
| 回填新成果到 IDA | 更新快照 `ida_dyidre_snapshot.py` → `build_rehydrate_unified.py` → 统一恢复脚本 |
| 恢复 IDB | `skills/ida_rehydrate_metasec_9_3.py`（GUI 跑或无头 `idat -A -S`） |
| 分析 37xx 新版本 | crosswalk §7 六步流程 + 350101 的 `metasec-so-recognizer` skill |

### 5.1 skills/ 下脚本谁有用（2026-09-07 盘点）

| 脚本 | 状态 | 说明 |
|---|---|---|
| `ida_rehydrate_metasec_9_3.py` | **唯一恢复入口** | 生成物，含五批全部成果；新增成果改数据后重跑 builder 同步 |
| `ida_apply_metasec_struct_evidence.py` | pass 库，勿单跑 | 被统一脚本 pass1 以受控 exec 调用，数据路径会被内嵌快照覆盖 |
| `ida_apply_managed_cf_350101.py` | pass 库，勿单跑 | 同上，pass2 |
| `ida_apply_proto_json_names_350101.py` | pass 库，可单跑 | 自包含；单独跑只补 10 个 proto/json 名字 |
| `ida_apply_integrity_guard_350101.py` | pass 库，勿单跑 | pass4；依赖 preamble 补 9 个前置类型（统一脚本已处理） |
| `ida_token_report_field_locator.py` | 独立分析工具 | token/report 字段定位，与恢复无关 |
| `metasec_*.py`（5 个） | 独立分析工具 | entrydump 对比 / 指令序列 diff / 结构体推断 / 晋升 / VM trace 解码 |
| ~~`ida_rehydrate_350101_9_3.py`~~ | **已删除**（2026-09-07） | 旧 350101 单独入口，已被统一脚本取代 |
| ~~`ida_rehydrate_full_9_3.py`~~ | **已删除**（2026-09-07） | 旧四批入口，已被统一脚本取代 |
| ~~`ida_apply_dyidre_enrich_9_3.py`~~ | **已删除**（2026-09-07） | 旧 enrich 单独入口，已内嵌进统一脚本 pass5 |

## 6. 血泪教训（别再踩）

1. **fetch-invalid 钩子里直接改 PC 不可靠**——必须 `emu_stop` + 外层恢复循环重定向
   （emu_jni.py 注释里有详解；踩坑现场留在已废弃的 `emu_jni_dbg*.py`）。
2. **runpy.run_path 返回的 dict 不是函数的 `__globals__`**——打补丁不生效，
   要用受控 dict `exec`（见 `ida_rehydrate_metasec_9_3.py` 的 `_load_module`）。
3. **`ida_typeinf.get_named_type` 对 MetaSec 家族类型恒 False**——验证 Local Types
   用 `get_ordinal_count` + `get_numbered_type_name` 序号枚举。
4. **IDA 内嵌 Python 的 `open()` 默认 ASCII**——读写中文 JSON 必须 `encoding="utf-8"`。
5. **IDA 9.3 无 `ida_kernwin.exit`**——无头脚本退出用 `idc.qexit(0)`。
6. `loc_XXXX` 标签不是函数头，命名保护规则要覆盖 loc_ 前缀（调度器 `0x597D4`
   和完整性前缀 `0x12FCE0` 就是这种）。
7. 重复明文槽（如 `v04.09.05` 上百个）命名后缀会耗尽，用 `g_str_<slug>_<hex>` 地址后缀。
8. 检测 ≠ 退出：多数环境检查只写 guard/risk/report 聚合物，下游消费未闭合，
   别把所有检测命名成 kill/abort（350101 的教训，crosswalk §3.7）。
9. **`ida_typeinf.parse_decls` 出错不抛异常，返回错误条数**——try/except 拦不到，
   必须显式检查返回值；IDA 9.3 签名是 4 参 `parse_decls(til, input, None, PT_SIL)`。
10. guard 脚本的 TYPE_DECLS/PROTOTYPES 依赖一批前置类型（FUN_MUTEX、
    REF_COOKIE_RISK_ITEMS、jobject、COOKIE_UPDATE_SETTINGS 等），它们只在
    `metasec_structs_350_all.h` 完整定义而草稿头没有——统一脚本 pass4 前有
    preamble 逐条补声明（按值字段必须给完整定义，指针参数前置声明即够）。

## 7. 文件地图（重点）

```
metasec_350101/
├── libmetasec_ml_master_report.md   ← 结论总入口（六轮战役地图）
├── crosswalk_350101_vs_dyidre.md    ← 与 350101 存档对照 + 37xx 复用流程
├── ida_enrich_report.md             ← 回填与容灾报告（含演练结果）
├── README.md                        ← 目录级详细索引
├── HANDOFF.md                       ← 本文档
├── libmetasec_ml_struct_report.md   ← R0 结构体报告（含解密 key 附录 C）
├── ida_campaign_round{1..5}_report.md
├── ida_mcp.py / emu*.py / batch_decrypt.py / extract_algo.py / jni_onload_emu.py
├── campaign_round3_classify.py      ← 可复跑分类器
├── build_enrich_plan.py / ida_enrich_apply.py / ida_slot_*.py
├── ida_dyidre_snapshot.py / build_rehydrate_unified.py   ← 容灾生成链
├── *.json                           ← 台账/种子/明文/操作码等数据（README §4 逐个有注）
├── recovery_test/  recovery_test2/  ← 恢复演练现场（各自有 README）
├── init_array/                      ← .init_array 116 ctor 深挖现场（独有：ctor[0] 反模拟、ctor[93] 代码密文化）
└── libmetasec_ml.so / full_disasm.txt ← 样本副本 + 43.6 万行反汇编

skills/
└── ida_rehydrate_metasec_9_3.py     ← 统一恢复脚本（唯一维护入口）
```

---
*交接于 2026-09-07。维护规则：新增成果 → 更新快照 → 重跑 builder → 统一恢复脚本更新；
文档与代码注释同步维护。*

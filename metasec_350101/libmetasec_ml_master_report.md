# libmetasec_ml.so 全景分析总报告（2026-09-07）

目标：`/Users/freeman/project/douyin/study/libmetasec_ml.so`
（ELF64 ARM64，stripped，2.7MB，md5 d71025b0… / sha256 前16 2416637a）
性质：抖音 metasec 安全 SDK 的 ML/脚本保护库。
战役跨度：六轮（结构体 → 枢纽分类 → 种子索引 → 全量台账 → 签名链 → 操作码定案），
全程 report-only，未修改 IDB。

---

## 0. 战役地图

| 轮次 | 目标 | 核心成果 |
|---|---|---|
| R0 | 0x11FC30 的 X0 参数结构体 | TREE_MAP 六结构体手工恢复（纯 objdump 反汇编 43.6 万行） |
| R1 | IDA MCP 接入 + 枢纽分类 | 9,357 函数实测；Top-9 扇入枢纽全分类；发现第 6 解密族 |
| R2 | 明文种子反查 | 黑盒解密 2,685 站点 → seed_index：1,210 函数带明文证据 |
| R3 | 全量分类 | 16 域分类器：404/1,210 函数定性；0x3C724 VM 主表等 15 函数坐实 |
| R4 | sign v5 链 | 编排器 14F8C8 全环节定性；TREE_MAP = 签名头数据结构闭环 |
| R5/R6 | Java→native 闭合 | 17 操作码实测；**0x2000002/05/0E = 签名操作** |

工具链：自写 `ida_mcp.py`（SSE 直连 13337）+ `batch_decrypt.py`
（Unicorn 批解密）+ `emu_jni.py`（JNI 主体受控模拟器）。

---

## 1. 二进制画像

- 唯一导出符号 `JNI_OnLoad`（0x139BB0，是壳：计算跳转 + svc 内联 +
  NZCV/clrex/brk 反调试序列）；
- .text 约 1.7MB；**无 JNI 标准导入**（FindClass/RegisterNatives 全无），
  JNIEnv 交互全部自实现；
- 显著导入：mprotect、dl_iterate_phdr、popen/system、socket 族、
  ASensorManager/ALooper、__system_property_*、pthread 全族；
- 函数 9,357（8,478 未命名）；Hex-Rays 反编译可用率 97.5%；
- 加固三件套：**字符串加密（6 解密族）+ 控制流平坦化 + 字节码 VM**
  （0x14B000-0x14D000 跳转表派发主循环）。

## 2. 核心数据结构（全部高置信，证据地址见各轮报告）

| 结构 | 关键字段 | 用途 |
|---|---|---|
| TREE_MAP（0x28） | vtable / key_delete / value_delete / cmp / impl | **全局中心容器：检测项、配置、签名头全是它** |
| TREE_IMPL（0x28） | header / node_count / cmp / proj / proj_ctx | 红黑树实现 |
| shared_ref | {+0 ptr, +8 ctrl}，ctrl[0]=count | 引用计数对象协议（create 0x4788C / copy 0x44B6C / release 0x42CE4，扇入最高 1,598） |
| MSString | vtable 0x262AF0，cap/len/malloc | 字符串类（ctor 0x10B5F0，1,091 xrefs） |
| hash 表（0x172AF4） | popcount 判 2 幂快路径，节点 {+8 hash, +0x10 key} | 次要索引容器 |
| VM frame | buf+0x8100+slot*8（0x1547C0） | VM 解释器帧槽 |
| 点分键树查询 | sub_12D910（`a.b.c` 逐层，读锁保护） | 配置树访问器 |

## 3. 字符串加密体系

- **6 个解密族**：5 个周期-8 密钥流族（0x12B904/0x12BFA8/0x12C648/
  0x12C9A4/0x12CF90，各 448-582 调用点）+ 1 个变长 NUL 密钥流族
  （0x15AC98，236 站点，密钥未提取）；
- 调用模式：`new[](len) → 内联密文立即数 → 解密 → qword 全局一次性缓存槽`；
- **两层明文库**：业务层槽页 `qword_2Bxxxx` / 表构建器槽页 `qword_2Cxxxx`；
- 黑盒批解密（mini 解释器重建密文 + Unicorn 模拟）：**2,685 站点，
  2,261 条回锚函数边界**，仅 64 站未命中（平坦化内嵌块）。

## 4. 加载期防线（.init_array 116 个 ctor）

| ctor | 函数 | 作用 |
|---|---|---|
| [3] | initManagedSignModuleLarge_350 (0x1702B8) | **签名模块第 4 个就初始化** |
| [68] | — | root 路径预解密库 |
| [69] | — | 注入框架特征预解密库 |
| [86] | **sub_3C724** | **119 项云手机/VM 属性明文主表**（24 组×5 解密族并存） |

## 5. 环境检测矩阵（R3 台账：404 函数已定性）

| 检测面 | 代表函数 | 证据强度 |
|---|---|---|
| root/Magisk | 0x39778（41 条 su 路径）、0xC5D00（magisk_feature） | 高（反编译坐实） |
| 注入框架 | 0xC710C（frida/xposed）、0x3A6DC（LSPosed/Riru 32 条路径） | 高 |
| 云手机/VM | 0x3C724（119 项主表）、0x7F1A0（62 项厂商属性） | 高 |
| 品牌/ROM | 0xC2A60（57 条 ro.product.*） | 高 |
| 反调试 | 0xAFE94（TracerPid JSON 进程树匹配器） | 高 |
| 硬件特性 | 0x16B080（FEATURE_BLUETOOTH_LE/GPS/NFC） | 高 |
| 设备指纹 | 0x77EC4（MediaDrm/UUID，2,552 行） | 高 |
| 风险应用 | mssdk_riskapp_db 族（19 函数） | 低-中 |
| 探针配置 | 0x121A0C（prb_dcToken/prb_safetyNet 访问器） | 高 |
| 端口扫描 | 0x98780（port_scan.* 规则表） | 高 |

## 6. 签名体系（sign v5）

**数据面 = TREE_MAP**：签名 = 遍历头字段树 → CRLF 序列化 → 摘要装配 →
回写树。R0 的 0x11FC30（insert_or_assign）直接适用于签名主流程。

**控制面 = 点分键配置树**（ctx+120）：`signv5_ctrl` / `signpath_count.*` /
`d_xmopt_ctrl` / `enable_sign_verify` / `enable_ror_*`。

**两条路径**：
- 托管模块路径（实测走通）：`8EFD8（registry type-4，0xF0 请求上下文）
  → 14F8C8 编排器（锁+控制参数+配置读写）`；
- HTTP 头路径（命名完整）：`buildSignedHttpHeadersCallback_350（平坦化
  包装）→ 两个 dispatcher → buildSignedHttpHeadersInner_350
  （treeMapPut×9 → signStage1/2 → managedSignBuildA/B/Final → base64）`，
  由网络收发阶段驱动。

**加载期**：ctor[3] 初始化签名模块；`g_managedProg_sign_F0..F19` 状态槽群。

## 7. JNI 入口与调度（R5/R6 模拟实测）

```
Java com.bytedance.mobsec.metasec.ml.MS.a(IIJ String Object)   ← 唯一注册方法
→ 0x12FB84 thunk（移参 + 反调试桩链）
→ 0x12FCE0 完整性校验前缀（表哈希种子 0x20190512 / 期望 0x77DF8B85，
   不匹配仅上报 sub_125D34，report-and-continue）
→ 0x597D4 扁平化巨型调度器（约 28KB，75 状态已映射，
   BST 二分 17 个操作码 0x2000001–0x2000011）
→ vtable[op] @0x60D34 → 0x48xxx 操作适配器
→ 业务族（签名/注册查询/轻量读取…）
```

**操作码定案（emu_jni.py 实测，单轮 35 万条指令覆盖）**：

| 操作码 | 判定 |
|---|---|
| **0x2000002 / 05 / 0E** | **签名操作**（完整覆盖 8EFD8→14F8C8→14F94C） |
| 0x2000003 / 04 | 签名相关辅助（擦边共享函数） |
| 0x2000007 / 08 | 注册表查询类 |
| 其余 12 个 | 其他业务/轻量查询 |

## 8. 模拟器方法论（emu_jni.py 关键要点）

1. 先跑全部 .init_array ctor 再进目标（全局明文库/注册表依赖）；
2. `context_save/restore` 快照复用，逐操作码重跑；
3. **fetch-invalid 钩子里改 PC 不可靠**——必须 `emu_stop` + 外层
   恢复循环（修复后单轮 4 千→35 万指令）；
4. abort/金丝雀软陷阱化；未映射读写补零页；零页取指 = 空调用返回 0；
5. JNIEnv 假 vtable 窗口（取指捕获槽号），GetStringUTFChars 给真实字符串。

## 9. 产物索引

| 产物 | 内容 |
|---|---|
| `libmetasec_ml_struct_report.md` | R0 结构体报告 |
| `ida_campaign_round1/2/3/4/5_report.md` | 六轮战役报告 |
| `seed_index.json` / `decrypted_strings.json` | 种子索引 / 2,685 条解密明文 |
| `campaign_round3_ledger.json` + `campaign_round3_classify.py` | 全量分类台账 + 可复跑分类器 |
| `ida_mcp.py` / `emu.py` / `batch_decrypt.py` / `emu_jni.py` | 工具链 |
| `r3_*` / `r4_*` / `r5_*` / `r6_*` .json | 各轮反编译/模拟原始数据 |
| `mock/`（mock.c + README + UNIDBG_NOTES） | 同手法复刻的最小实现 + unidbg 改进建议 |

## 10. 遗留清单

1. 第 6 解密族（0x15AC98）密钥流提取 + 236 站点收割；
2. VM 主循环（0x14B000-0x14D000）opcode 表还原；
3. HTTP 头签名路径的运行时触发验证（需真实网络响应语义）；
4. 585 个 unclassified 函数（多为 VM handler/纯算术）；
5. op2（MS.a 第二 int 参数）语义未探索；
6. 0x14FCC8 的 15 字节配置串（站点 0x14FD24）单点模拟收割。

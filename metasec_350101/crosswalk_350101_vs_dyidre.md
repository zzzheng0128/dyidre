# 350101 存档 × dyidre 六轮战役 对照文档（crosswalk）

日期：2026-09-07
两边对象：
- **A 侧**：`versions/350101/` —— 前一轮"深度还原 + 真机/unidbg 证据"存档（总入口 `so_runtime_flow_350101.md`）
- **B 侧**：`metasec_350101/` —— 本次六轮 IDA MCP 战役（总入口 `libmetasec_ml_master_report.md`）

---

## 1. 样本身份：同一份二进制（已互证）

| 项目 | A 侧（350101） | B 侧（本战役） | 结论 |
|---|---|---|---|
| SHA-256 | `2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76` | 前 16 位 `2416637a…`（IDB 校验值） | ✅ 一致 |
| 文件大小 | 2,864,144 字节 | 2,864,144 字节 | ✅ 一致 |
| Build ID | `025e51707b4c64f0b578e2dd7f12aa58ca94241a` | IDB 记录同值 | ✅ 一致 |
| 地址口径 | module RVA，IDA imagebase=0 | 同 | ✅ 同口径，地址可直接互引 |
| 包/版本 | douyin 35.0.0，内部串 v04.09.05 | 同一样本 | ✅ |

**推论**：两边所有 RVA 级结论可以在同一张表上对齐，不需要地址换算。

## 2. 两边的定位差异（为什么成果形状不同）

| | A 侧 350101 | B 侧本战役 |
|---|---|---|
| 主战场 | 签名链深度还原（X-* 头逐字节闭环） | 全 SO 广度普查（9,357 函数 / 1,210 种子 / 404 定性） |
| 证据主力 | 真机 trace + unidbg deterministic replay + C oracle（S/D/V/P 四级） | IDA MCP 反编译 + Unicorn 批解密 + emu_jni.py 受控模拟（高/中/低置信度） |
| 最深成果 | 7 个 X-* 头算法 byte-exact（`failures=0` 的 C oracle 群） | 检测矩阵 + 字符串解密体系 + JNI 调度操作码实测 |
| 自我定位 | "37xx 的基准答案 + 证据模板" | 同一份 SO 的加载期/检测面/调度面全景 |

一句话：**A 侧在签名业务链上远比 B 侧深；B 侧在加载期防线、检测矩阵、字符串体系、全量函数台账上远比 A 侧广。两边几乎不重叠，是互补关系。**

## 3. 逐主题对照

### 3.1 .init_array / 加载期

| 主题 | A 侧 | B 侧 | 关系 |
|---|---|---|---|
| .init_array 位置 | `0x260190`，size `0x3A0` | 116 个 ctor，逐个索引编号 | ✅ 同区域；B 侧多了 ctor 级全量索引 |
| managed module 构建 | 4 个 init：`0x14CEBC / 0x152B58 / 0x1702B8 / 0x171DDC`，含 blob 地址、decode key、CF/G 表、输出 module 全局槽全表 | ctor[3] = `initManagedSignModuleLarge_350`（`0x1702B8`），并找到 `g_managedProg_sign_F0..F19` 状态槽群 | ✅ 互证：A 的"sign module"行 = B 的 ctor[3] |
| 检测预解密库 | （散见于 integrity 文档） | ctor[68] root 路径库、ctor[69] 注入框架库、ctor[86]=`sub_3C724` 119 项云手机/VM 属性主表 | 🆕 B 侧独有，A 侧未做 ctor 级编目 |
| 早期完整性 | `0xD86D0` 监控总入口、signal 探针 `0xD84FC`、映像 XOR `0xD7E18`（期望 `0x99D93502` / len `0x25EA20`） | JNI 入口前缀 `0x12FCE0` 表哈希校验（种子 `0x20190512` / 期望 `0x77DF8B85`，不匹配走 `sub_125D34` 上报后继续） | ✅ 互补：A 是映像级 XOR 链，B 是入口表哈希链；**`0x125D34` 两边独立找到同一个高敏感失败处理器** |

### 3.2 JNI 与 Java 边界

| 主题 | A 侧 | B 侧 | 关系 |
|---|---|---|---|
| JNI_OnLoad | `0x139BB0 → 0x13A2C4 → 0x13A320`（inner），注册走 `0x12F5D0` 沿 MS superclass 层级 RegisterNatives | `0x139BB0` 定性为壳（计算跳转 + svc 内联 + NZCV/clrex/brk 反调试序列）；无标准 JNI 导入，JNIEnv 交互全自实现 | ✅ 一致互补：A 给了调用链，B 给了壳特征 |
| Java 锚点 | `com/bytedance/mobsec/metasec/ml/MS`；缓存 class `0x2C3518`、`b(...)` jmethodID `0x2C3520`、JavaVM `0x2C3538` | MS.a(IIJ String Object) 唯一注册方法 → `0x12FB84` thunk → `0x12FCE0` → `0x597D4` 巨型调度器 | ✅ 拼接成完整双向图：A=装载与 native→Java 回调缓存，B=Java→native 调度实测 |
| 操作码 `0x20000xx` | 作为 **MS.b（native→Java）** 的命令值记录：`0x2000001/0x2000002` 等 unidbg 返回 null，影响 `x0+0x3c0` TLV/env buffer | 作为 **MS.a（Java→native）** 的分发操作码实测：`0x597D4` BST 二分 17 个 op（`0x2000001–0x2000011`），**`0x2000002/05/0E` = 签名操作** | ⚠️ 同一整数命名空间、两个方向。A 从 unidbg 环境缺口侧看，B 从 native 静态分发表看。**`0x2000002` 两边都指向签名路径，互相加强**；精确的双向映射需一次联合 trace 定案 |
| native→Java 探测 | `0xD9044/0xD90C0` 一次性 latch 探测静态 `a()V` | （未覆盖） | A 独有 |

### 3.3 双层 VM

| 主题 | A 侧 | B 侧 | 关系 |
|---|---|---|---|
| managed 字节码 VM | 解释器 `0x1555A4 managedBytecodeRun_350`（0x18-byte record，opcode base `0x81`）；builder `0x154328`、invoke `0x154454`、frame `buf+0x8100` 共 `0x50` 槽；F5/F7/F8/F13 产 X-Argus/Ladon/Medusa/Helios；CF0..CF101 注册表全表 | VM frame 槽读 `0x1547C0` / 写 `0x1547D4` 已识别；`0x14B000–0x14D000` 跳转表派发主循环（R0 时期定性） | ✅ frame 模型一致（B 的 `0x1547C0/0x1547D4` = A 的 slot 读写）。⚠️ **待对齐**：B 的"主循环 0x14B000–0x14D000"与 A 的解释器 `0x1555A4` 是否同物，B 侧遗留清单第 2 条（opcode 表还原）应直接复用 A 的 `managed_vm_runtime_350101/` 严格 runtime |
| native VMP | `0x4CC10 exeVMInner_350`，ABI（X0=vmCode…X4=VmParam64）完整；已闭合 3 个 wrapper/entry 对（vmCode `0x1EC670/0x1ECAF0/0x1F7860`）+ 完整性入口 `0xD7E94`（vmCode `0x1EA850`）；`vm_generic_350101/` 严格可执行 runtime，1,132 条取指有证据 | R0 时期只识别到"存在字节码 VM"，未展开 VMP | A 远深。B 侧后续 VMP 工作应直接站在 `vm_generic_350101/` 上 |
| 程序/算法还原 | CF41=SIMON128/256、CF43=AES-128-CBC、CF61=SM3、CF48/F17=ARX 短头变换、F12 bit-pack、source-work 四族（F18..F54）全部 unknown 0、byte-exact C oracle 群 | 未触及算法层 | A 独有，B 侧直接继承 |

### 3.4 签名链（sign v5）

| 主题 | A 侧 | B 侧 | 关系 |
|---|---|---|---|
| HTTP wrapper/inner | `0x14DBF4 buildSignedHttpHeadersCallback_350` / `0x149CA8 buildSignedHttpHeadersInner_350`，原型、失败码表（-1/-4/-5/-6/-7/-8/0）、X1/X2/X3/X5 = 同一栈参数包 0x10 滑动窗口 | R4 独立找到同址 wrapper/inner 及命名；另走通托管模块路径 `0x8EFD8（registry type-4，0xF0 请求上下文）→ 0x14F8C8 编排器` | ✅ 地址逐位互证（这也是 B 侧 IDB `_350` 命名的来源）；B 的 `0x8EFD8→0x14F8C8` 路径与 A 的 HTTP 头路径是**两条并列链路**，可互相注释 |
| X-* 阶段表 | 12 步精确阶段表（`0x14A128` 读 mode → Gorgon `0x16D204` 长 0x34 → Khronos `0x16D454` 长 0x0A → F5/Argus 0x104 → F7/Ladon 0x30 → CRC32 setting → F8/Medusa 0x3B0.. → F13/Helios 0x30 → Soter 0x78 → 耗时 → CRLF 输出 `0x14D424→0x149C20`） | R4 定性到 `treeMapPut×9 → signStage1/2 → managedSignBuildA/B/Final → base64` | A 是 B 的超集；B 的"signStage1/2"对应 A 的 Gorgon/Khronos native 段 |
| 配置控制 | `signv5_ctrl` / `d_signv5_ctrl` → `runtimeObj+0x50/+0x51`；真机 bit0=1 时跳过 F5/F7 仅走 F8/F13；`0xD952C` runtime gate | 点分键配置树（ctx+120）：`signv5_ctrl` / `signpath_count.*` / `d_xmopt_ctrl` / `enable_sign_verify` / `enable_ror_*`，查询器 `sub_12D910` | ✅ 同一套配置的两侧：A=运行时值与分支效果，B=树结构与访问器 |
| 采样/副作用 | `g_httpSignSamplingCounter_350`（`0x27EDF8`）%10 采样；CRC32 写 setting `167774bf…`；F8 后写 100 到 `2e8ab122…` | （未覆盖） | A 独有 |

### 3.5 数据结构 / x0 证据

| 主题 | A 侧 | B 侧 | 关系 |
|---|---|---|---|
| 主 ctx（`0x149CA8` 的 x0） | `MetaSecCtx350`：`+0x8` registry（type→payload 对象表，查询 `0x1261B0`）、`+0x1E0` 嵌入 `COOKIE_RISK2`（ops/shared_ref/rwlock/busy）、`+0x240/+0x248` shared_ref 对、`+0x258/+0x260` 锁+busy、`+0x3C0..0x500` 复用 scratch buffer | （本战役未以该函数为结构目标） | A 独有 |
| TREE_MAP | `metasec_structs_350_all.h` 收录 MEM_BLOCK/TREE_MAP/JSON_LIST/COOKIE_RISK* | **R0 起点**：`0x11FC30` = TREE_MAP insert_or_assign，手工恢复 6 结构体（TREE_MAP/TREE_IMPL/shared_ref/MSString/hash 表/VM frame） | ✅ 同结构族。注意两边 x0 不是同一函数：A 的 x0=inner ctx，B 的 R0 x0=TREE_MAP this |
| shared_ref 协议 | assign/copy `0x47908`、reset `0x47C1C`、release `0x4ABD4` | create `0x4788C` / copy `0x44B6C` / release `0x42CE4`（扇入 1,598，全 SO 最高） | ⚠️ **函数地址不完全重合**：两边各自抓到了 shared_ref 协议族的不同成员。需一次合并去重，合成完整 API 表 |

### 3.6 字符串加密

| A 侧 | B 侧 | 关系 |
|---|---|---|
| `cf_string_decode_and_proto_serializer_350101.md`（CF 层字符串解码 + protobuf 序列化，descriptor-backed `0x11615C/0x1165B8`） | **6 个解密族全图**：5 个周期-8 密钥流族（`0x12B904/0x12BFA8/0x12C648/0x12C9A4/0x12CF90`，各 448–582 调用点）+ 1 个变长 NUL 族（`0x15AC98`，236 站，密钥未提取）；两层明文槽页 `qword_2Bxxxx/qword_2Cxxxx`；黑盒批解密 2,685 站 | ✅ 互补两层：B=native 加载期/业务层字符串体系全图；A=managed CF 层的字符串/编码原语。B 侧遗留的第 6 族密钥提取可参考 A 的 decode 记录 |

### 3.7 环境检测 / 反调试

| A 侧 | B 侧 | 关系 |
|---|---|---|
| 完整性链 8 函数台账（`0xD86D0/0xD7F10/0xD84FC/0xD8218/0xD7D84/0xD7E18/0xD7E94/0xAFBA0`）+ 全局状态表（sig64 状态机 `0x27DC98` 等 11 项）；强调"检测≠立即退出"，多写 guard/risk/settings/report 聚合物，下游消费未闭合 | **10 领域检测矩阵**：root `0x39778`（41 条 su 路径）/ Magisk `0xC5D00` / 注入框架 `0xC710C` + LSPosed/Riru `0x3A6DC` / 云手机 `0x3C724`（119 项）+ `0x7F1A0`（62 项厂商属性）/ 品牌 `0xC2A60`（57 条 ro.product.*）/ 反调试 `0xAFE94`（TracerPid JSON 进程树匹配）/ 硬件 `0x16B080` / 设备指纹 `0x77EC4`（MediaDrm/UUID，2,552 行）/ 风险应用 19 函数 / 端口扫描 `0x98780` | ✅ 互补两面：A=检测结果的**聚合与消费侧**（guard/risk/report），B=检测项的**采集与特征侧**。A 提到报告阶段扫描 TracerPid/root 路径/maps——B 侧矩阵正是这些扫描的采集端实现 |
| 失败处理 | `0x125D34` 高敏感失败处理（可能 crash/状态破坏） | `0x12FCE0` 校验失败上报 `sub_125D34`，report-and-continue | ✅ 同址互证 |

### 3.8 unidbg / 模拟器方法论

| A 侧 | B 侧 | 关系 |
|---|---|---|
| 真机 rootfs 同步、`-Dmetasec.alignTrueDeviceHttpRuntime=true` 分支归一化、`MS.b` 缺口清单、deterministic replay 验收 | `emu_jni.py`：先跑全部 ctor 再进目标、context 快照逐 opcode 重跑、fetch-invalid 必须 emu_stop+外层恢复、abort/金丝雀软陷阱、零页取指=空调用 | ✅ 互补：A=环境对齐工程（让 unidbg 像真机），B=执行控制工程（让模拟器跑穿平坦化调度器）。两边经验应合并进同一份 unidbg 改进清单（B 侧已有 `mock/UNIDBG_NOTES.md`） |

## 4. 证据等级体系对照

| A 侧 S/D/V/P | B 侧 高/中/低 | 对齐 |
|---|---|---|
| S 静态确认 | 高（反编译坐实） | ≈ |
| D 真机/unidbg trace 观测 | 高（模拟实测） | ≈，但 A 的 D 含真机，强度更高 |
| V 独立 C oracle byte-exact | （B 侧无此级） | A 独有，是 B 侧算法层奋斗的目标形态 |
| P 推断/候选 | 中/低 | ≈ |

迁移规则建议：B 侧结论进入 A 侧体系时，"高（仅反编译）"→ S；"高（emu 实测）"→ D；任何结论不得直接标 V。

## 5. 各自独有成果清单

**A 侧独有（B 直接继承即可）：**
1. 7 个 X-* 头的 byte-exact C oracle 群 + fixed s1/s2 signer（`metasec_350101_fixed_signer.c`）；
2. managed VM 严格 runtime（`managed_vm_runtime_350101/`）+ 全部 F/CF decode（unknown 0）；
3. native VMP 严格 runtime（`vm_generic_350101/`）+ 3 个闭合 wrapper/entry 对；
4. 真机/unidbg 环境对齐工程（rootfs、分支归一化开关、deterministic replay）；
5. `MetaSecCtx350` 主 ctx 结构（registry/COOKIE_RISK2/shared_ref/scratch）。

**B 侧独有（A 可回填）：**
1. seed_index 全量台账：1,210 函数带明文证据、404 函数 16 域定性（`campaign_round3_ledger.json` + 可复跑分类器）；
2. 字符串解密体系全图（6 族 + 2,685 站明文库 `decrypted_strings.json`）；
3. .init_array 116 ctor 编目 + ctor[68/69/86] 检测预解密库；
4. 10 领域检测矩阵（采集端全图）；
5. MS.a 17 操作码实测分发表（emu_jni.py）；
6. `emu_jni.py` 受控模拟器与 `ida_mcp.py` 工具链；
7. `mock/` 同手法最小复刻 + unidbg 改进建议。

## 6. 冲突 / 待对齐清单（下一步干活按此顺序）

| # | 事项 | 现状 | 建议动作 |
|---|---|---|---|
| 1 | managed VM 主循环地址 | B：`0x14B000–0x14D000` 跳转表；A：解释器 `0x1555A4` | 用 IDA 核对 `0x1555A4` 的反编译是否引用该区间的跳转表；若是同物，统一采用 A 的口径 |
| 2 | shared_ref API 地址不重合 | A：`0x47908/0x47C1C/0x4ABD4`；B：`0x4788C/0x44B6C/0x42CE4` | 六个地址放一张表，逐个反编译定语义，合并成完整协议族 |
| 3 | `0x20000xx` 操作码双向语义 | A：MS.b（native→Java）命令值；B：MS.a（Java→native）分发 op | 一次联合 trace：同一整数在 MS.a 进、MS.b 出是否同义；重点先定 `0x2000002` |
| 4 | x0+0x3C0 TLV/env buffer | A：MS.b 缺口会影响其内容 | B 的 emu_jni.py 可单点模拟收割该 buffer 的写入方 |
| 5 | 第 6 解密族（`0x15AC98`）密钥流 | B 遗留 236 站 | 参考 A 的 CF 字符串解码记录，尝试密钥提取 |
| 6 | B 侧 585 个 unclassified 函数 | 多为 VM handler/纯算术 | 用 A 的 `managed_vm_runtime` handler 表反查归属 |

## 7. 对 37xx 的合并复用流程

A 侧 README 已给出 9 步复用模板；叠加 B 侧成果后，建议 37xx 流程改为：

1. **身份固定**：`metasec_so_identity.md` 格式（A）；
2. **广度先行**：跑 B 的批解密 + seed_index + 分类器，一天内拿到新样本的检测矩阵/字符串体系/函数台账骨架；
3. **入口对齐**：用 A 的 wrapper/inner/module-init 地址模式 + B 的 ctor 编目法交叉定位；
4. **深度逐项替换**：X-* 链、VM、CF 按 A 的模板用 37xx 真机证据替换；
5. **调度实测**：B 的 emu_jni.py 直接复跑操作码分发表，验证 `0x20000xx` 是否漂移；
6. **验收**：A 的 C oracle + deterministic replay 标准（`failures=0`）不变。

---

*本文档为对照索引，不替代两边各自的专项报告；引用结论时请回到 A/B 各自的原始文件核对证据等级。*

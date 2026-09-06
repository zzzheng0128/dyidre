# IDA MCP 全模块战役 · Round 2 报告（2026-09-07）— 明文种子反查

方法：把附录 A 的 2,685 条解密明文按调用点回锚到 IDA 函数边界
（py_eval 进程内 `ida_funcs.get_func(site)`），生成种子索引
`seed_index.json`，再对高价值宿主函数批量反编译（`analyze_batch`）。

## 种子索引统计

| 指标 | 值 |
|---|---|
| 带明文种子的函数 | **1,210 / 9,357（12.9%）** |
| 成功回锚的种子 | 2,261 条 |
| 未命中函数边界的调用点 | 64（2.4%，多为平坦化内嵌块） |

意义：之前"<1% 详细覆盖"的瓶颈被种子索引结构性打开——1,210 个函数
每个都自带若干条明文证据，且明文自带语义（类名/路径/属性键），
批量反编译 + 种子对照即可逐函数定性。

## Top 宿主函数分类（本轮详细反编译 10 个）

| 函数 | 行数 | 种子样本 | 分类 | 置信度 |
|---|---|---|---|---|
| 0x7F1A0 | 1,072 | persist.radio.bksim.iccid / vivo_iccid / opmuuid | 云手机/模拟器指纹采集（属性→TREE_MAP） | 高 |
| 0xC2A60 | 1,004 | ro.product.brand / google / huawei / honor | 品牌指纹检测表构建 | 高 |
| 0x39778 | 588 | /system/xbin/su / daemonsu / shuamesu | root 检测路径表构建 | 高 |
| 0x77EC4 | 2,552（138 子调用） | java/util/UUID / android/media/MediaDrm | 设备 ID 采集（MediaDrm/UUID 走 JNI） | 高 |
| 0xC5D00 | 254 | magisk_feature | Magisk 特征检测 | 高 |
| 0xC710C | 259 | frida / hook / xposed / magisk | 注入框架检测 | 高 |
| 0xAFE94 | 198 | pid / tracer_pid | **TracerPid 状态解析（真 .so 反调试 native 层定位）** | 高 |
| 0x12E2A4 | 264 | sdk_aid / device_id / host_aid / channel | 设备标识上报字段组装 | 高 |
| 0xC0190 | 330 | java/lang/reflect/Executable / artMethod | ART 反射辅助（artMethod 偏移操作） | 中高 |
| 0x16B080 | 246 | FEATURE_BLUETOOTH_LE / GPS / NFC | 硬件特性探测表 | 高 |

定性：该库的业务面 = **环境检测矩阵**（root/注入/云手机/品牌/硬件特性）
+ **设备指纹采集上报**（device_id/MediaDrm/UUID）+ VM 保护的签名逻辑。
检测项以"明文种子→TREE_MAP 条目"形态组织，与 ctor[68/69/86] 的
init_array 预解密库互为印证。

## 覆盖核算（累计）

- 详细分类：~60 函数（枢纽 9 + 关键 2 + 种子宿主 10 + 前序手工 ~40）
- 种子可及面：1,210 函数（12.9%）——下轮批量反编译的直接弹药
- 未触碰：VM 主循环内部、无种子函数 ~8,100 个（含纯算术/VM handler）

## 下一轮队列

1. 种子宿主批量反编译流水线：1,210 函数 × analyze_batch 分片
   （每片 20 函数，MCP 大输出转存 URL 自动回收），产出全量
   函数分类台账（预计可分类 60-70%，其余归 VM handler/算术辅助）
2. TracerPid 链完整还原：0xAFE94 的调用者 + 与 init_array ctor
   的触发关系
3. 检测矩阵 → TREE_MAP 键值 schema：汇总全部检测项键名
4. 第 6 解密族（0x15AC98，变长 NUL 密钥流）密钥提取 + 236 站点收割

## 产物

- `seed_index.json`：函数 → 明文种子全量索引（1,210 函数 / 2,261 种子）
- `campaign_round2_seedhosts.json`：10 个宿主函数完整反编译（803KB）

---

# 附录 B · 识别方法（证据链）

上表每个函数的"分类"不是凭函数名猜的（全部 8,478 个函数无名），
而是按下面的**四步证据链**定性的。任何一步不成立，置信度就降档。

## B.1 通用四步识别法

### 第 1 步：明文种子回锚（黑盒解密 → 函数边界）

字符串全是运行时解密的（静态 strings 看不到明文）。先用批处理
黑盒模拟解密（`batch_decrypt.py`，2,685 站点）拿到
`(解密调用点 site → 明文 pt)` 对照表，再用 IDA 进程内
`ida_funcs.get_func(site)` 把每个调用点回锚到宿主函数边界，
得到 `seed_index.json`：**1,210 个函数各自携带若干条明文证据**。

关键点：明文自带语义——路径（`/system/xbin/su`）、属性键
（`persist.radio.bksim.iccid`）、JNI 类签名
（`android/media/MediaDrm`、`(Ljava/util/UUID;)V`）、JSON 键名
（`tracer_pid`）。一个函数体内密集出现同一语义域的明文，
分类方向就确定了。

### 第 2 步：结构形态佐证（解密 → 一次性缓存 → 消费）

对种子宿主做完整反编译，检查统一的代码模式：

```
if ( !qword_2Bxxxx )              // 全局一次性缓存槽
  qword_2Bxxxx = sub_12C9A4();    // 解密取明文（见"口径说明"）
... 消费明文（属性读取 / 路径比对 / JSON 组装 / JNI 调用）
```

实测：0x7F1A0 内 **62 个互异的 `qword_2Bxxxx` 缓存槽**，
与它的 **62 条种子一一对应**——说明该函数就是一个
"检测项表构建器"，每个槽位 = 一个检测项明文。0x39778 有
92 个槽 / 41 条 su 路径种子，0xC2A60 有 61 个槽 / 57 条品牌种子，
形态完全一致。槽位数与种子数的对应关系是"表构建器"定性的
结构证据（种子 < 槽位是因为部分槽存派生对象而非明文本身）。

### 第 3 步：消费辅助函数核实（反编译到底层）

种子说明"构建了什么表"，但"拿表干什么"要看消费端调用的
辅助函数。本轮逐一反编译核实：

| 辅助函数 | 反编译结论 | 证据 |
|---|---|---|
| `sub_B1AD4` | `__system_property_find` + `__system_property_read` 封装 | 反编译体直接可见两个 libc 调用（refs 确认） |
| `sub_123B14` | JSON 值设置器（内部分配节点、调 `json_delete_chain`，IDB 已有名） | 反编译体 + 既有符号名 |
| `sub_123AF4` | 布尔检查：`sub_10D5A8(*(a1+8)) != 0` | 反编译体可见；**`sub_10D5A8` 深层语义未深挖** |
| `sub_7180C` | atomic guard 单例初始化（`byte_2BC690`） | 反编译体可见 |

例：0x7F1A0 调 `sub_B1AD4` **12 次**——"读 persist.* 系统属性"
从种子推测升级为代码级坐实；0xAFE94 调 `sub_123B14` 组装
`{pid, tracer_pid, ppid, name, orphan, match, process_tree}` 的
JSON 进程树——"TracerPid 状态解析器"定性坐实。

### 第 4 步：init_array 预解密库交叉互证

`init_array/`（本目录下）报告独立发现：ctor[68] 预解密 root 路径、
ctor[69] 预解密注入框架特征、ctor[86] 预解密云手机指纹。
本轮在业务层函数里找到**同一语义域**的明文种子
（0x39778↔ctor[68]、0xC710C↔ctor[69]、0x7F1A0↔ctor[86]），
两条独立证据链（启动期预解密库 / 业务期检测表）互指同一套
检测矩阵，分类结论收敛。

## B.2 逐函数证据明细

| 函数 | 种子数 | 种子样本（原文） | 结构佐证 | 消费端核实 | 结论置信依据 |
|---|---|---|---|---|---|
| 0x7F1A0 | 62 | `persist.radio.bksim.iccid` `vivo_iccid` `persist.sys.oppo.opmuuid` `debug.dps.perf.uuid` | 62 个缓存槽，与种子一一对应 | `sub_B1AD4`×12（属性读取坐实）、`sub_123AF4`×31 | 种子语义域（厂商私有属性=云手机指纹）+ 属性读取代码级坐实 → **高** |
| 0xC2A60 | 57 | `ro.product.brand` `google` `huawei` `honor` `redmi` `miui` `coloros` | 61 个缓存槽 | `sub_B1AD4`×1 | 品牌/ROM 词汇表 + 属性读取 → **高** |
| 0x39778 | 41 | `/system/xbin/su` `/system/bin/shuamesu` `/system/xbin/daemonsu` `bstk/su` `longeneroot.apk` | 92 个缓存槽 | — | su 路径词汇表无歧义 + ctor[68] 互证 → **高** |
| 0x77EC4 | 59 | `java/util/UUID` `android/media/MediaDrm` `PROPERTY_DEVICE_UNIQUE_ID` `getPropertyByteArray` `pm path com.tencent.mm` | 71 个缓存槽、2,552 行 / 138 子调用 | — | JNI 类签名即 MediaDrm 唯一设备 ID 采集的标准调用序列 → **高** |
| 0xC5D00 | 13 | `magisk_feature` `inject_app_process` `/proc/self/attr/prev` `u:r:zygote:s0` `libnativebridge.so` | 13 个缓存槽 | — | Magisk/Zygisk 内部特征词（inject_app_process 是 Magisk 专有名词）→ **高** |
| 0xC710C | 8 | `frida` `hook` `posed` `magisk` `maps_risklist` `maps_safelist` `anon:` | — | — | maps 风险/安全名单 + 注入框架关键词 → **高** |
| 0xAFE94 | 9 | `pid` `tracer_pid` `ppid` `name` `orphan` `match` `process_tree` | 9 个缓存槽 | `sub_123B14` JSON 组装坐实 | /proc/self/status TracerPid 字段名 + JSON 进程树匹配器 → **高**（反调试 native 层定位） |
| 0x12E2A4 | 11 | `sdk_aid` `device_id` `host_aid` `channel` `configURLs` `reportURLs` | — | `sub_123AF4`×8 | 上报字段名词汇表 → **高**（字段组装），具体网络路径未追 |
| 0xC0190 | 11 | `java/lang/reflect/Executable` `artMethod` `J` `Bill/Francies/Louis/Zeoy` `()V` | 14 个缓存槽 | — | artMethod 偏移操作属 ART 内部结构，功能定性靠词汇推断 → **中高** |
| 0x16B080 | 8 | `FEATURE_BLUETOOTH_LE` `FEATURE_LOCATION_GPS` `FEATURE_NFC` `FEATURE_TELEPHONY` | — | — | PackageManager 硬件特性常量表 → **高** |

## B.3 口径说明与未决项（诚实声明）

1. **伪代码里的解密调用显示为无参 `sub_12C9A4();`** —— 参数走
   寄存器约定，未被反编译器还原成显式实参。明文不是从伪代码
   直接读到的，而是来自第 1 步的黑盒模拟解密对照表。
2. **`sub_123AF4` / `sub_10D5A8` 深层语义未深挖**：已知它是
   对结构体 `+8` 偏移的布尔判定，但判定对象未定性。凡结论依赖
   该函数语义的（如 0x7F1A0 的 31 处检查的具体含义），相应论断
   按**中置信**对待。
3. **64 个调用点（2.4%）未命中函数边界**，多为控制流平坦化的
   内嵌块，未纳入种子索引。
4. 0xC0190 的 `Bill/Francies/Louis/Zeoy` 是加固占位类名
   （常见于字节系加固），据此推断"ART 反射辅助"而非业务功能，
   故标**中高**而非高。

# IDA MCP 全模块战役 · Round 3 报告（2026-09-07）— 全量函数分类台账

方法：Round 2 产出的 `seed_index.json`（1,210 函数 / 2,261 条明文种子）
经 `campaign_round3_classify.py` 全量自动分类（16 个语义域关键词表，
强词权重 2 / 弱词权重 1），再抽 15 个高价值函数用 IDA MCP 反编译做
结构佐证（本报告全部结论 = 种子语义 + 代码结构双重证据，
单种子函数一律标低置信）。

## 全景分布（1,210 函数）

| 领域 | 函数数 | 高 | 中 | 低 |
|---|---|---|---|---|
| sdk_version（SDK 版本/内部标识） | 148 | 99 | 37 | 12 |
| brand_rom（品牌/ROM 指纹） | 62 | 4 | 25 | 33 |
| jni_reflect（JNI/反射/ART 辅助） | 58 | 2 | 10 | 46 |
| device_id（设备标识采集） | 24 | 3 | 7 | 14 |
| inject_framework（注入框架检测） | 20 | 5 | 14 | 1 |
| app_risk（风险应用检测） | 19 | 0 | 0 | 19 |
| sys_prop（系统属性读取） | 19 | 0 | 5 | 14 |
| hardware_feature（硬件特性探测） | 16 | 1 | 6 | 9 |
| cloud_phone_vm（云手机/虚拟空间） | 9 | 1 | 8 | 0 |
| network_report（上报/网络通道） | 9 | 1 | 5 | 3 |
| root_magisk（root/Magisk 检测） | 7 | 1 | 1 | 5 |
| anti_debug_proc（反调试/进程状态） | 7 | 1 | 3 | 3 |
| crypto（加密/编码） | 6 | 0 | 4 | 2 |
| plumbing_noise（格式串/签名碎片） | 221 | — | — | — |
| unclassified（信息不足） | 585 | — | — | — |

已定性（非 noise/unclassified）：**404 函数（33.4%）**，其中高置信 108 +
已坐实 10。未定的 806 个中 996-种子直方图显示 996 个函数只有 1 条种子，
且多为 `v04.09.05`/`bd`/格式串/JNI 签名碎片——属 SDK 管道代码，
与 Round 1 "8,478 个无名函数多为 VM handler/算术辅助" 的结论一致。

## 本轮重大新发现（15 个函数反编译坐实）

### 1. 0x3C724 — 全库最大的明文初始化器（119 种子，52KB 伪代码）

**这是云手机/VM 属性明文的主表构建器**，规模超过此前所有宿主：

- 体内 **24 组 × 5 个解密族**（sub_12B904 / sub_12BFA8 / sub_12C648 /
  sub_12C9A4 / sub_12CF90 各调 24 次），120 次 `sub_1C2F40(len)` 分配；
- 每个字符串 = `alloc(len) → 写入内联密文常量（如
  *(_QWORD *)v4 = 0x825F2950F9B522D3LL）→ 解密 → 缓存 qword_2C26xx`；
- 明文清单是**云手机厂商属性全表**：`ro.x8.*`（x8 沙箱）、`ro.vphone.*`
  （微宿）、`vmprop.*`、`ro.vmos.*`（VMOS）、`ro.rksdk.*`（红手指）、
  `ro.kernel.titan`（泰坦云手机）等 119 条。

意义：它把"云手机检测"从 Round 2 的 62 种子函数（0x7F1A0）升级为
**独立的 119 项主表**，且证明 5 个解密族在同一函数内并存使用。

### 2. 0x121A0C — prb_* 探针配置访问器

switch(a1) 索引 → 解密一条 `prb_*` 配置串 → 缓存 `qword_2C30xx`。
配置项：`prb_dcToken`、`prb_safetyNet`、`prb_dynIssuance`、
`prb_content_processing`、`neo_execution` 等——**安全探针的
运行时配置表**（SafetyNet 对抗、动态签发开关）。

### 3. 0x98780 — 端口扫描检测配置

`port_scan.enable / .extr_proc / .last_port / .mand / .proh`——
检测本机端口扫描行为的规则表（Frida/注入工具常开端口）。

### 4. 0x3A6DC — LSPosed/Riru/EdXposed 检测表（32 种子，新定位）

`/data/adb/modules/riru_lsposed`、`.edxposed.manager`、
`/data/data/org.lsposed.manager` 等 32 条——比 Round 2 的 0xC5D00
（Magisk 13 条）更完整的**注入框架落地路径表**。

### 5. 签名算法控制参数浮出

- 0x14F94C：`d_signv5_ctrl` / `signv5_ctrl` / `signv5_ctrl.fixedvalue`
- 0x14FAF4：`signpath_count.interval` / `signpath_count.maxcount`

——**签名生成逻辑（sign v5）的运行时控制参数**，是该库最核心的
业务值的入口线索。

### 6. 上报端点路径族

0x96A58 `/ri/report`、0x96AB8 `/ri/report_tob`、0x96B24
`/ri/report_ext`、0x119008 `itor/collect`、0x1503C4 `/ri/report`——
风险情报（ri = risk intelligence）上报通道。

### 7. 其余坐实项

| 函数 | 种子 | 结构佐证 | 定性 |
|---|---|---|---|
| 0xB39C4 | eth0/iip/gip/ghw | 6 槽 5 解密族 | 网卡接口信息采集 |
| 0xAD6AC | /proc/self/cgroup、bg_non_ | 3 槽 | 进程调度组（前台/后台）检测 |
| 0xD9B50 | am get-config、mcc/mnc | 3 槽 | SIM 运营商信息采集 |
| 0xD209C | bluetooth_name、getContentResolver | 7 槽 5 族 | 蓝牙名称设备指纹 |
| 0xF1724 | firstInstallTime | 3 槽 | 安装时间指纹 |
| 0xC0844 | Bill/Francies/Louis/Zeoy | 10 槽 5 族 | 第二处加固占位类簇（同 0xC0190） |
| 0x7E024/0x7E2CC/0x7E57C | libc.so / libandroid_runtime.so / libandroid_servers.so | 各 2 槽，调 metasec350_shared_ref_* | native 系统库名表项（钩挂/完整性检查候选） |
| 0x97338 | tes_interval/rep_interval | 3 槽，调 sub_123B14(JSON) | 上报周期配置组装 |
| 0x9EFEC | opps/cpps/rpps | 3 槽，调 sub_123B14+sub_123AF4 | 性能计数配置组装 |

### 8. 84 个同模版本函数

种子模式 `('1.0','bd','v04.09.05','v04.09.05')` 在 **84 个函数**
中逐字重复——SDK 版本明文的按 key 分发 stub，不是 84 个独立逻辑。

## 结构规律（本轮 15 函数交叉验证）

全部 15 个函数共享同一签名：

```
sub_1C2F40(len) 分配 → 写入内联密文常量 → 5 解密族之一 →
qword_2Bxxxx / qword_2Cxxxx 全局一次性缓存槽
```

- 业务层函数（Round 2 的 10 个）用 `qword_2Bxxxx` 页；
- 表构建器/访问器（本轮 0x3C724/0x121A0C 等）用 `qword_2Cxxxx` 页；
- **两个全局槽页 = 两层明文库**：2C 页是初始化期主表，2B 页是
  业务期检测项。与 init_array ctor[68/69/86] 的预解密库三层呼应。

## 口径与局限

1. **单种子函数一律低置信**：1 条明文不足以定域，161 个低置信
   条目需反编译升级；
2. **种子存在截断碎片**（`er;`/`ager;`/`OCATION` 等）——黑盒解密
   按站点截取导致的部分明文，已在分类器中按 JNI 签名/噪音规则过滤；
3. **领域重叠**：0x7F1A0 的种子同时命中 brand_rom（oppo/vivo）与
   cloud_phone_vm（iccid/opmuuid），Round 2 已坐实为"厂商私有 ID
   属性采集"，自动标签取 brand_rom 仅因弱词命中数多，以人工坐实为准；
4. analyze_batch 响应有总预算：8 函数/批时全部截断至 1,022 字符，
   4 函数/批或单函数 decompile 可得全文（本轮批次 3 因此重跑）；
5. 585 个 unclassified 多数只有噪音种子，**不代表无价值**——
   VM handler 和纯算术逻辑本就不含字符串。

## 下一轮队列

1. 0x3C724 的调用者追踪（xref 0x260440 是数据引用，疑似函数指针表
   项）→ 确定 VM 主表的触发时机；
2. sign v5 链：0x14F94C/0x14FAF4 的调用者 → 签名生成主流程定位；
3. 161 个低置信（单种子）函数的批量反编译升级；
4. 第 6 解密族（0x15AC98）密钥提取（沿用 Round 2 队列）。

## 产物

- `campaign_round3_classify.py`：16 域关键词自动分类器（可复跑）
- `campaign_round3_ledger.json`：1,210 函数全量分类台账
  （domain/secondary/score/confidence/evidence 五元组）
- `r3_batch1/2/3_full.json`：15 个高价值函数完整反编译（共 ~95KB）

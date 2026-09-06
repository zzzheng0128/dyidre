# IDA MCP 全模块战役 · Round 4 报告（2026-09-07）— sign v5 链完整还原

起点：Round 3 发现的签名控制参数函数 0x14F94C（`d_signv5_ctrl` /
`signv5_ctrl` / `signv5_ctrl.fixedvalue`）与 0x14FAF4
（`signpath_count.interval` / `signpath_count.maxcount`）。
方法：xrefs_to 逐级上溯 + 全程反编译验证 + .init_array 表扫描。
**本轮零猜测：每一环都有反编译或表项证据。**

## 完整链路图

```
[加载期]  .init_array（共 116 个 ctor）
   ctor[3]  = initManagedSignModuleLarge_350 (0x1702B8)   ← 签名模块第 4 个就初始化
   ctor[4]  = sub_171DDC（签名模块伴生初始化）
   ctor[86] = sub_3C724（119 项云手机/VM 属性明文主表，Round 3 发现）
              → 与 init_array 报告 ctor[86]=云手机预解密库 完全互证

[Java 入口]（来自前序 jni_onload_trace.json）
   com.bytedance.mobsec.metasec.ml.MS.a(IIJ String Object)
     → fnPtr 0x12FB84（thunk：丢 jclass、移参、进反调试桩链）
     → 0x12FC08 → 0x12FCE0（真实逻辑）

[分发层]
   sub_8EFD8 —— 注册表类型处理器（唯一引用 = 数据表项 0x261CF8，
                即经 metasec350_registry 注册为 type handler）；
                构造 0xF0 字节请求上下文（sub_1C2EDC(0xF0) +
                sub_65CC0 四参数填充），尾调签名编排器
   sub_8D6D8 —— pthread_mutex_lock 保护 + registry_find_type(4)
                查找类型处理器，尾调签名编排器
   sub_8E9CC —— 22 参数适配 trampoline（C++ 变参模板桩），
                包装后调 sub_8D6D8

[签名编排器]  sub_14F8C8（本轮链路的枢纽）
   sub_1509EC()          取全局状态
   sub_66994(a1+120,a2)  上下文写入（+120 偏移）
   sub_14F94C()          signv5_ctrl 控制参数（d_signv5_ctrl/fixedvalue）
   sub_14FAF4(a1)        signpath_count 计数参数（interval/maxcount）
   sub_14FCC8(a1)        ↓ 未深挖
   sub_14FD90(a1)        ↓ 未深挖
   sub_44A98/sub_150A00  收尾输出

[HTTP 签名层]（IDB 前序已命名，本轮验证连接）
   buildSignedHttpHeadersCallback_350 (0x14DBF4)
     —— 控制流平坦化包装器（状态机常量 -1225583056/-1480375958/
        -277515925/1031488438），按 sub_63CC8 判定分发到：
     ├─ metasec350_http_dispatcher_14ebb4 (0x14EBB4)
     │     → treeMapToCrlfString2_350 / parseCrlfPairsToTree2_350
     └─ metasec350_http_dispatcher_alt_14e888 (0x14E888)
           → treeMapToCrlfString_350 / parseCrlfPairsToTree_350
   buildSignedHttpHeadersInner_350 (0x149CA8，26KB 伪代码) ← 调用者
   sub_14A880 / sub_14B80C（两个请求类型入口）
     —— treeMapPut_350 × 9（构建头字段树）
        queryInputTreeByRuntimeHeaderKey1/2_350（读输入树）
        signStage1_makeStubPieces_350 → signStage2_makeKeyPieces_350
        managedSignBuildA/B/Final_350（三段装配）
        managedSignPostEmitF13_350 / base64PackC0ToStackMemBlock48_350
        g_httpSignSamplingCounter_350（采样计数）
```

## 全局状态表（前序命名，本轮确认在用）

- `g_managedModule_sign_350` (0x2C58C8) + `g_managedProg_sign_F0..F19`
  (0x2C58D0 起连续 20+ 槽) —— 签名模块的程序化状态机存储；
- `g_httpSignSamplingCounter_350` (0x27EDF8) —— HTTP 签名采样计数器；
- `g_signalProbeContextActive_350` (0x2C0E58) —— 探针上下文激活标志。

## 与最初 TREE_MAP 任务的闭环

Round 0 的起点 0x11FC30 = `insert_or_assign`（TREE_MAP 插入）。
本轮确认签名主流程 **buildSignedHttpHeadersInner_350 调
treeMapPut_350 系列 9 次**，两个 HTTP dispatcher 分别调
`treeMapToCrlfString(2)_350` 与 `parseCrlfPairsToTree(2)_350`
且都经过 sub_11FE48（0x11FE50 find 的紧邻入口）。

结论：**TREE_MAP 就是签名头的数据结构**——输入头/输出头都以
TREE_MAP 组织，签名 = 遍历树 → CRLF 序列化 → 摘要装配 →
回写树。最初的结构体分析（TREE_MAP 最小定义）直接适用于
签名主流程的输入输出格式。

## 两条签名路径的关系（Round 4 补完后已闭环）

最初留的四个未深挖环节，本轮全部反编译定性：

| 环节 | 机器码/伪代码证据 | 定性 |
|---|---|---|
| sub_1509EC | `pthread_mutex_lock(*(a1+152)+8)` | ctx 对象内嵌互斥锁（+152）加锁 |
| sub_14FCC8 | 解密 15 字节配置串 → `sub_12D910(*(obj+120), str)` 写入/查询 → 置 `ctx+82` 标志 | 配置项写入 ctx+120 树（该站点 15 字节密文走 sub_150A60 辅助写入，批解密未重建，`ok:false`，明文待单点模拟） |
| sub_14FD90 | 解密得 **`d_xmopt_ctrl`**（13 字节，批解密已收割）→ `sub_1504D8(ctx, key, 0)` → 布尔存 `ctx+83` | 从 ctx+120 树读 xmopt 控制开关 |
| sub_150A00 | 机器码 `ldr x8,[x21,#40]; ldur x9,[x29,#-8]; cmp x8,x9; ret` | **栈金丝雀校验辅助**（TLS canary vs 栈帧 canary），11 处函数尾调用点；不是运行时代码解密桩，疑点排除 |

辅助函数定性：

- **sub_12D910 = 点分键树查询**：读锁保护，按 `.` 分割键逐层走子节点
  （`sub_10BE58(key, 46, pos)` 找分隔符）——即 `treeMapGet("a.b.c")`；
- **sub_1504D8 = 树配置读取封装**：`treeMapGet(*(ctx+120), key)` → bool。

**汇合结论（闭环）**：两条路径操作的是**同一个 ctx 对象的
同一棵点分键 TREE_MAP（+120）**——

- 托管模块路径（sub_14F8C8）：加锁（+152）→ 读 signv5_ctrl /
  signpath_count / d_xmopt_ctrl 控制参数 → 置 ctx+82/+83 标志位；
- HTTP 头签名路径（Inner_350）：`queryInputTreeByRuntimeHeaderKey1/2`
  读输入树 → treeMapPut ×9 写输出头树；
- 两侧共享 ctx 的 +120 树与 +82/+83 标志（sub_8D6D8 与 sub_14F8C8
  都对 a1+120 做 `sub_66994` 写入可互证）。

即：**signv5_ctrl 等控制参数决定签名行为开关，头字段树承载
签名输入输出**——控制面与数据面在 ctx 对象上汇合。

## 产物

- `r4_callers_full.json`：sub_8D6D8 / sub_8EFD8 完整伪代码
- `r4_signflow_full.json`：签名主流程 4 个命名函数完整伪代码
- `r4_dispatchers_full.json`：两个 HTTP dispatcher 完整伪代码
- `r5_links_full.json`：四环节（14FCC8/14FD90/1509EC/150A00）
  + 树查询（12D910/1504D8）完整伪代码
- init_array 扫描：ctor[3]=签名模块初始化、ctor[86]=VM 主表（互证）

## 遗留（降级为低优先级）

1. 0x14FCC8 的 15 字节配置串明文（站点 0x14FD24，密文经
   sub_150A60 辅助写入，需单点 Unicorn 模拟重建）；
2. sub_14A880 / sub_14B80C（Inner 的两个请求类型入口）向上
   到 JNI 0x12FCE0 的分发层尚未逐级走通。

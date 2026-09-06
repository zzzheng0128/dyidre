# IDA MCP 全模块战役 · Round 5 报告（2026-09-07）— Java→native 全链闭合

目标：走通 Round 4 遗留的最后一段——Inner 两个入口（sub_14A880 /
sub_14B80C）向上到 JNI 落点 0x12FCE0。
方法：xrefs 逐级上溯 + 三张调度表转储 + JNI 扁平化主体全量 BL/BLR 扫描。

## 结论：全链仅剩一跳运行时分发

```
[Java]  com.bytedance.mobsec.metasec.ml.MS.a(IIJ String Object)
   │  RegisterNatives @ 0x12F92C（jni_onload_trace.json 前序坐实）
   ▼
0x12FB84  thunk（丢 jclass、移参、进反调试桩链）
   │  B loc_12FCE0（尾跳，IDA 未识别函数边界）
   ▼
0x12FCE0  JNI 主体（扁平化调度器，IDA 无函数边界）
   ├─ 扫 0x8000 字节：160 个去重 BL 目标 + **133 个 BLR 间接调用点**
   ├─ 本地处理器表 off_27E770（hash 键 0x134B658/0x134B650 +
   │   0xFFFF… 哨兵配对，处理器 sub_133720 / sub_133920 均带
   │   pthread_mutex 锁保护）
   ├─ TLS 上下文 off_27CBF8（经 sub_60858 = pthread_once +
   │   getspecific/setspecific 的线程局部存储助手访问）
   └─ 直接静态边：BL sub_44B6C（shared_ref 对象协议助手，
      与签名链 sub_8E9CC/0x8EFD8/dispatchers 同一对象族）
   ▼  【唯一缺口：133 个 BLR 的运行时目标解析】
[注册表层]
   sub_44BF4 ──调用──▶ sub_14D4EC ──读──▶ L2 调度表 0x270C50（5 项）
   │                                       ├─ sub_149398（构建器，写入 0x14A880）
   │                                       ├─ sub_149404
   │                                       ├─ sub_1260E4 / sub_126064
   │                                       │   （被 0x2618xx-0x261Dxx + 0x26F4xx
   │                                       │    共 12+ 张 vtable/注册描述表引用）
   │                                       └─ sub_14C978
   ▼
90 项处理器表 0x27EA20（全为 0x14Bxxx 签名族函数指针，
   被 sub_149430 / sub_14B67C / sub_14BC64 索引消费；
   其中 sub_149430 由 buildSignedHttpHeadersInner_350 内部调用
   —— Inner 自身也经此表做二级分发）
   ▼
sub_14A880 / sub_14B80C（Inner 的两个请求类型入口）
   ▼
buildSignedHttpHeadersInner_350 (0x149CA8) ← 签名内核
```

## 关键佐证明细

| 证据 | 值 |
|---|---|
| sub_14A880 引用 | sub_149398 / sub_14C964 体内的**数据引用**（表构建） |
| sub_14B80C 引用 | 90 项处理器表 0x27EA20 的第 13 项（0x27EB88） |
| 0x12FCE0 性质 | `get_func_attr` = BADADDR，IDA 未识别函数边界； |
| | 0x12FC08 = `B loc_12FCE0` 尾跳（JNI thunk 链最后一跳） |
| JNI 主体规模 | 0x8000 字节窗口内 375 个 BL/BLR 调用点 |
| BLR 占比 | 133/375 ≈ **35% 间接调用**——扁平化 + 表分发的典型特征 |
| 模块注册表 | off_260540（.init_array 结束紧邻处）→ sub_42C1C/sub_42E04， |
| | 被 0x34xxx 区（sdk_version 种子簇）的 sub_34034/sub_34314 消费 |

## 与全局架构的对齐

1. **注册表架构三层**：模块注册表（0x260540，加载期）→
   L2 调度表（0x270C50，5 项构建器）→ 90 项处理器表
   （0x27EA20，运行期）。与 Round 4 的 registry_find_type(4)
   是同一套 type-handler 机制；
2. **JNI 主体 = 总调度器**：MS.a 的 5 个参数（含 int 操作码 w0/w2）
   经扁平化状态机 + 133 个 BLR 表分发到各业务族，
   签名族（0x14Bxxx）只是其中一支；
3. **与 mock 项目互证**：mock.c 的 .init_array 预解密 +
   RegisterNatives 单入口 + 平坦化分发，与真库结构一一对应。

## 诚实声明

- **唯一未闭合的边**：JNI 主体 133 个 BLR 中哪一个解析进
  签名族注册表，静态 xref 不可见（数据驱动分发）。
  闭合手段：用前序 emu.py / jni_onload_emu.py 骨架对
  0x12FCE0 主体做受控模拟，在 BLR 站点记录解析目标；
- off_27E770 的键 0x134B658/0x134B650 是运行时堆值
  （静态内容无意义），键值→操作的映射需模拟或动态获取；
- 本 round 不改 IDB（report-only 约定保持）。

---

# Round 5 补记 · 模拟闭合（emu_jni.py）

用 Unicorn 受控模拟（先跑 116 个 .init_array ctor 再进调度器，
context_save/restore 快照复用），把"最后一跳"从推断变成实测：

## 1. JNI 主体 0x12FCE0 的真实身份：完整性校验前缀

- 对函数指针表做**运行时哈希**（种子 0x20190512，逐 dword
  `EOR` 混合），期望值 **0x77DF8B85**；
- 不匹配 → 调 sub_125D34（上报/置标志）**然后照常继续**——
  report-and-continue 设计，不拦截；
- 尾跳 `B loc_597D4`，把原 6 参数转交真正的调度器。

## 2. 真正的调度器 0x597D4（IDA 未识别，约 28KB）

- 扁平化状态机：**已映射 75 个状态**（比较链 MOV/MOVK + CSEL）；
- **操作码 = MS.a 第一个 int 参数，取值 0x2000001–0x2000011
  共 17 个操作**（BST 二分分发：`CMP op, #0x20000XX` + LT 分支）；
- 初测 op1=0/1/7 全部走同一条 13 状态路径返回 0——因为
  真实操作码是 0x20000XX，小数值根本进不了业务分支。

## 3. 最后一跳实测：vtable 分发 @ 0x60D34

```
0x60CB4  LDR X8, [X20]        ; 调度器对象 -> vtable
0x60CB8  LDR X19, [X8, X19]   ; vtable[操作码槽位]
0x60D30  MOV X0, X20
0x60D34  BLR X19              ; ← 最后一跳
```

模拟实测各操作码的解析目标（多轮运行取并集）：

| 操作码 | 解析到的处理器 |
|---|---|
| 0x2000002 | sub_480E4 |
| 0x2000003 | sub_489E4 |
| 0x2000004 | sub_484E4 |
| 0x2000005 | sub_48380 |
| 0x2000008 | 0x127Dxx 系列 → sub_129B9C ×13（registry 邻域 0x1261B0 旁） |

另有公共边 `BLR @0x4AC14 → sub_10B7A8`（shared_ref 释放族虚调用）。

## 4. JNIEnv 活动实测（每操作码一轮）

槽位 167/168（GetStringUTFLength/UTFChars）、171（NewObjectArray）、
23/26/31/33/35、200、228——证明 jstring URL 参数被真实读取、
字符串语义进入状态机。

## 5. 诚实声明（补记前）

- 模拟中 110-113/116 个 ctor 成功，3-6 个失败（缺映射内存，
  已记录地址）；ctor[3]（initManagedSignModuleLarge_350）在
  部分轮次失败，签名模块全局态可能不完整；
- BLR 采用"记录目标+跳过调用"策略（返回 FAKEOBJ 支持链式下钻），
  路径覆盖优先于执行保真；op1=0x2000001/6/7 的轮次在更深处的
  共享对象内部触碰未映射内存中止（正常，属假对象语义边界）；
- **哪个操作码 = 签名**仍需下一轮：反编译 0x48xxx 处理器群
  （每个 ~2KB 的适配器）追到签名注册表调用即可定案。

---

# Round 6 补记 · 签名操作码定案（模拟实测）

## 修复的关键模拟缺陷

1. **fetch-invalid 钩子里直接改 PC 不可靠**（Unicorn 在非法取指钩子里
   改 PC 后继续，会偶发 UC_ERR_MAP 且钩子无异常）——改为
   `emu_stop + resume_pc + 外层恢复循环` 后，单轮执行量从 ~4K 暴涨到
   **35 万条指令**，深层链路全部走通；
2. `__stack_chk_fail/abort` 从致命改为软陷阱（记录+返回 0）——
   假对象环境下的金丝雀失配是语义副作用，不该中断；
3. 未映射读/写按需补零页；取指到零页按"空调用返回 0"处理。

## 17 个操作码 × 全量模拟覆盖结果

| 操作码 | 分发路径 | 覆盖签名链 | 判定 |
|---|---|---|---|
| **0x2000002** | 0x60D34 → sub_480E4 | **orch_14F8C8 + sub_8EFD8 + signv5_14F94C 全覆盖（35 万指令）** | **签名操作** |
| **0x2000005** | 0x60D34 → sub_48380 | 同上（34.7 万指令） | **签名操作** |
| **0x200000E** | 0x60D34 → sub_488E8 | 同上（34 万指令） | **签名操作** |
| 0x2000003/04 | → sub_489E4 / sub_484E4 | sign_149 区擦边 36 PC（共享辅助） | 相关辅助 |
| 0x2000008 | 27-47 BLR 站，registry_126 201 PC | 注册表重度活动，未到签名 | 注册/查询类 |
| 0x2000007 | registry_126 42 PC | 仅注册表 | 查询类 |
| 0x2000009/10 | 擦边 / 0x4AECC→0x123C00 | 否 | 其他业务 |
| 0x2000001/6/A/C/F/11 | 各自浅路径 | 否 | 其他业务 |
| 0x200000B/D | 0 个 BLR，立即返回 | 否 | 轻量查询 |

## 最终定案

**MS.a(op1 ∈ {0x2000002, 0x2000005, 0x200000E}) = 三个需签名的请求类型**，
实测完整执行链：

```
Java MS.a(0x2000002, op2, long, url, body)
  → 0x12FB84 thunk → 0x12FCE0 完整性校验前缀（哈希 0x77DF8B85，上报不拦截）
  → 0x597D4 扁平化调度器（BST 二分 17 操作码）
  → vtable[op] @0x60D34 → sub_480E4/48380/488E8（操作适配器）
  → sub_8EFD8（registry type-4 处理器，0xF0 字节请求上下文）
  → sub_14F8C8（签名编排器：加锁 → signv5_ctrl@0x14F94C →
     signpath_count@0x14FAF4 → 14FCC8/14FD90 配置读写）
```

**Java→native→签名编排器全链闭环，每一环都有模拟执行覆盖或
静态 xref 证据。** HTTP 头签名路径（Inner_350）在本组参数下未触发，
与 Round 4 "两条路径"结论一致——它应在网络收发阶段由响应驱动。

## 遗留（低优先级）

- op2（第二 int 参数）语义未探索（全程用 0）；
- 模拟产出的是覆盖证据，未提取真实签名输出字节（假 JNIEnv/
  假对象下输出无真实性）；
- 0x2000008 触及 3M 指令上限，其完整语义待定。

## 产物（累计新增）

- `emu_jni.py`：成熟版 JNI 受控模拟器（ctor 初始化 + 快照复用 +
  emu_stop 重定向 + 区域覆盖 + 状态机跟踪 + 软陷阱）
- `emu_jni_blr_all.json`：累计 98 个 BLR 站点 → 运行时目标
- `r6_handlers.json`：8 个操作码处理器的反编译调用清单

## 产物

- `r5_links_full.json`：四环节 + 树查询函数完整伪代码（Round 4 补完）
- `r5_jni_12fce0.json`：（0x12FCE0 反编译失败，以扫描替代）
- `r5_jni_bl_targets.txt`：JNI 主体 160 个去重 BL 目标全量
- 本报告（含三张调度表的地址/内容/消费者清单）

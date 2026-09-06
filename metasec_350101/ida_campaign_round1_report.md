# IDA MCP 全模块战役 · Round 0-1 报告（2026-09-07）

目标：libmetasec_ml.so（md5 d71025b0…，sha256 前 16 位 2416637a，与 IDB 校验一致）
连接方式：SSE 直连 localhost:13337（`ida_mcp.py`，运行时未登记该 server，自实现客户端）
模式：report-only（未改名/未打补丁/未改 IDB）

## 规模修正（IDB 实测 vs 此前静态估算）

| 维度 | 此前 objdump 静态估算 | IDA 实测 | 结论 |
|---|---|---|---|
| 函数数 | ≈5,238（唯一 bl 目标） | **9,357**（8,478 未命名） | 静态漏掉 44%——`br xN` 数据驱动转移与尾调用藏边得到实锤 |
| 字符串 | 2,685 解密调用点 | 2,823 条（IDB） | 吻合 |
| 反编译可用率 | 不可用（无反编译器） | **117/120 抽样成功（97.5%）**；3 个失败全是 extern 段 thunk | Hex-Rays 对该库基本通吃 |

## Round 1：Top 扇入枢纽分类（9 个未知枢纽全部分类成功）

| 地址 | xrefs | 分类 | 证据形态 |
|---|---|---|---|
| 0x42CE4 | 1,598 | shared_ref_release（作用域释放：RAII guard + 引用计数释放） | guard 构造/析构对 + release 调用 |
| 0x4788C | 653 | shared_ref_create（{ptr,ctrl} 控制块 new 4B、计数置 1） | 伪代码直读 |
| 0x44B6C | 565 | shared_ref_copy（`++*ctrl`） | 伪代码直读 |
| 0x47A4C | 456 | shared_ref_copy 变体（不同锁池） | 同构 |
| 0x47AD4 | 466 | release 族（guard + sub_4AD44） | 同构 |
| 0x172AF4 | 513 | **hash 表 find**（popcount 判 2 幂 → `(n-1)&hash` 快路径 vs `hash%n`；链走比较存hash@+8、key@+0x10） | vcnt_s8/vaddlv_u8 + 桶链遍历 |
| 0x15AC98 | 236 | **第 6 个字符串解密族**：`dst[i]=src[i]^keystream[i]`，NUL 结尾变长密钥流（区别于已知的周期-8 五族） | 伪代码直读 |
| 0x46780 | 250 | libc++ SSO string 析构（tag&1 → free(ptr@+16)） | 伪代码直读 |
| 0x1547C0 | 262 | VM frame slot 读取（frame->buf+0x8100+slot*8，slot2 常作返回值槽） | IDB 已有注释 + 形态吻合 |

交叉验证：sub_10B5F0（1,091 xrefs）/ sub_10B764（815）正是此前手工确认的 MSString 构造/析构——两路线索互相印证。

## 关键函数验证

- **0x11FC30**（本战役起点）伪代码确认 TREE_MAP put/replace 语义：`map+0x00`=tree_head_ptr、`free_key`/`free_value` 为字段内函数指针，比较器经 trait 对象 `+88` 槽调用——此前手工恢复的 6 结构体全部成立，且 IDB 中已存在 334 版本导入的 TREE_MAP 类型体系（注释提示 item_value 应为 TREE_KV*，需修正评估）。
- **JNI_OnLoad（0x139BB0）是壳**：真实逻辑在 `sub_139BF8(vm,reserved)+52; BR X1` 的计算跳转之后，反编译器无法跟随——注册表还原仍以模拟执行为准（与此前 jni_onload_emu.py 路线一致）。

## 覆盖核算（诚实口径）

- 详细分类函数：本轮 +9 枢纽 + 2 关键函数 ≈ 累计 ~50/9,357（**0.5%**）
- 反编译可及面：97.5% 函数可直接产伪代码——瓶颈已从"读不动"变为"看得慢"
- 未触碰面：VM 字节码解释器主循环（0x14B000-0x14D000）内部、8,478 个未命名函数中的业务层、.data.rel.ro 的 vtable/注册表数据面

## 下一轮队列（按 skill 优先级评分）

1. 明文种子反查：2,685 条明文 × 调用点 → containing function 批量反编译（预计单轮可把覆盖率推到 20%+）
2. shared_ref 体系收敛：create/copy/release 三族 ctrl_block 结构体定型（+0 ptr、+8 ctrl、ctrl[0]=count）
3. 第 6 解密族（0x15AC98）密钥流提取 + 其 236 个调用点收割
4. hash 表族（0x172AF4 上下游）结构体恢复：bucket 数组、节点 {+8 hash, +0x10 key}
5. VM frame 结构（0x1547C0 出发，buf+0x8100 slot 区）与 VM 主循环 opcode 表

## 产物

- `ida_mcp.py`：SSE 直连客户端（list-tools / call / call-batch）
- `campaign_round1_hubs.json`：9 枢纽完整分析（含 CFG、常量、xref 计数）
- `campaign_round1_keyfuncs.txt`：0x11FC30 / JNI_OnLoad / 0x182DB4 / 0x15AC98 完整分析

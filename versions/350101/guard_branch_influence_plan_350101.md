# 350.101 boot/guard 异常分支影响分析计划

本文件用于自有样本的离线或只读实验，目标是回答“某个异常输入最终改变了哪一条分支、哪个状态和哪个输出”。不修改 SO 字节，不伪造检测结果，也不用于隐藏采集行为。

## 1. 统一记录格式

每个实验建立一个独立 run 目录，记录：

```text
检测点 RVA | caller/LR | 输入来源 | 正常值 | 变异值
输出寄存器/返回码 | guard 写集 | risk/settings/report 写集
后续读取者 | 分支目标 | 最终影响 | 证据文件
```

地址均用 RVA；真机地址只作为 `module_base + RVA` 的运行时实例保存。

## 2. 优先实验矩阵

| 类别 | 观测点 | 单变量异常 | 需要比较的结果 |
|---|---:|---|---|
| ELF 身份 | `0xD7F10` | `e_machine`、路径命中/缺失 | `guard+0x08/+0x0C`、report 字段 |
| 映像边界 | `0xD8218` | PT_LOAD 范围、长度 | `guard+0x10/+0x18/+0x28`、完整性 VM 输入 |
| 映像校验 | `0xD7E18` / `0xD7E94` | XOR 或长度不匹配 | `guard+0x50`、settings、是否进入失败处理 |
| signal/cache | `0xD84FC` | 返回值不为 `10`、handler 状态异常 | `guard+0x30`、报告风险条目 12 |
| linker 回调 | `guard+0x38` 消费点 | 地址越界、page 对齐变化 | JSON 分类值、link-verify 字段 |
| link verify | `guard+0x48/+0x4C` | code/aux 为 0、1、其他值 | report item6、风险条目 9 |
| hook/debug | `0xAFBA0` 等 | 入口指令异常、TracerPid 非零 | hook mask、report/tree、终止路径 |
| 线程/环境 | 风险扫描入口 | 可疑线程名、root 路径、maps 项 | risk object/report；下游 consumer 待证 |

每次只改变一项；时间、随机、pid/tid、请求 URL、stub 和 JSON 固定，避免把环境漂移误认为 guard 分支差异。

## 3. 结果分类

对每个异常样本，将影响归为四类之一：

1. **仅报告**：当前只观察到 report/tree 写入，尚未建立签名输入边。
2. **状态传播**：写 guard/risk/settings；后续 reader 必须单独证明，不能预设为 F5/F8 或策略逻辑。
3. **延迟分支**：当前调用成功，但在下一次请求或后台任务中改变路径。
4. **终止路径**：明确跳到失败处理、异常返回或进程终止点；必须有动态控制流证据。

不要仅凭函数名或“检测到异常”字样把路径命名为 `kill/abort`。

## 4. 当前已知基线

- `guard+0x20/+0x28`：完整性 VMP 的期望 XOR 和映像长度。
- `guard+0x30`：signal-loop 失败状态。
- `guard+0x38`：linker callback 地址归属分类。
- `guard+0x40`：当前已确认被转换后写入 JSON，但写入者仍待 VMP trace。
- `guard+0x48/+0x4C`：link-verify code/aux，分别进入 report 和风险条目。
- `guard+0x50`：完整性风险位；ordinary-native 路径置已执行标记，并在两个 VMP wrapper 返回后按值重新发布；VMP 对其他位的作用仍未闭合。
- `guard+0x68..+0x7C`：四个 32 位 setting 快照，VMP 后续写入语义仍未闭合。
- `g_httpSignSamplingCounter_350 @ 0x27EDF8`：每次 inner 调用递增，按 `%10` 影响耗时和设备采样窗口；当前静态上不是原子计数器。

## 5. 证据晋级规则

- **S**：IDA/静态调用和字段访问明确。
- **D**：真机或 unidbg 观察到具体输入、返回和内存写入。
- **V**：离线重放或 oracle 对输出逐字节验证。
- **P**：只有形状或相邻版本线索，不能改成确定业务名。

只有同时拥有静态 writer、动态值变化，以及被证明进入 direct HTTP header-output 链的后续
reader，才把某个 guard 字段提升为“影响某 header/策略分支”的结论；仅看到通用
settings/tree reader 不足以完成晋级。

## 6. 推荐产物

```text
runs/350101/guard_branch/<run_id>/
  inputs.json        # 单变量变异及固定环境
  trace.jsonl        # PC/LR/返回值/内存写
  diff.md            # 正常 vs 异常
  branch_map.json    # writer -> reader -> consumer
```

最终结论回填到 `interface_ledger_350101.json` 的 `outputs/purpose/evidence`，并在
`integrity_guard_ida_350101.md` 中补充已闭合的 writer/reader 关系。

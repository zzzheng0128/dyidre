# `dycompare` schema 边界审计（350.101）

## 范围

本文将历史 `dycompare` 文本注释与 350.101 证据台账分离核对。它只做
schema/provenance 审计：不定义 350.101 native ABI、不重建 token/report 请求，
也不声称历史样本值会被新版本接受。

来源只按路径和行号引用；本文不复制历史样本中的 token、标识符、地址、路径、哈希
或设备值。

证据等级：**S** = 本地静态文本/schema 直接可见；**D** = 350.101 本地 trace
已经观测；**P** = 有界的跨版本推断，不能升级为 ABI 或算法事实。

## 1. 历史文件实际能证明什么

| 结论 | 依据 | 状态 |
|---|---|---|
| `get_token` 有 tag-1 外层 metadata，及后续的应用/会话类字段。 | `dycompare/dy_get_token分析.txt:1-143`；`dycompare/klog.proto:3-16` | S，仅限该历史注释集合 |
| metadata 是设备、系统、文件系统的宽泛快照。 | `dycompare/dy_get_token分析.txt:1-130`；`dycompare/klog.proto:18-146` | S，仅限字段类别 |
| `report` 是硬件、环境、风险、网络、传感器、配置等 group 的独立集合。 | `dycompare/dy_report.txt:1-753` | S，仅限该历史注释集合 |
| 历史文本能证明具体 protobuf serializer、descriptor 或 350.101 对象布局。 | 这三个文件均无 raw wire body、生成 descriptor 或同版本 writer。 | 未建立 |

因此可复用的是**字段来源类别**，不是 wire 级或版本级兼容性。

## 2. `klog.proto` 只能视为局部注释，不能视为 descriptor

本地 schema 注释与 text-form 样本在多个位置不一致；这些差异正是防止把方便的
字段名误提升为硬约束的边界。

| tag / 范围 | 历史文本形态 | `klog.proto` 声明 | 可保留结论 |
|---|---|---|---|
| 顶层 17 | text 样本中有额外占位字段。 | `KLog` 未声明 tag-17。 | 该 schema 对该样本不完整。 |
| metadata 7 | 渲染成 nested/packed 风格对象。 | 声明为 `string`。 | wire type 和嵌套关系仍需 raw protobuf 证据。 |
| metadata 8 | 注释描述 doubled density-like 数值。 | 注释描述另一种变换。 | 只能保留“显示密度数值类别”；编码是 P。 |
| metadata 23 | text 注释为 serial-like 字段。 | 声明/注释为 `wifiName`。 | 字段名冲突，应保留中性的 tag 记号。 |
| metadata 38/39 | text 注释区分 MAC-like 与 SSID-like 数据。 | 字段名相近，但行内注释并不一致。 | 类别可暂作参考；精确 wire 归属尚未验证。 |

本文刻意不改 `klog.proto`：那会暗示已恢复 descriptor，而现有材料尚不足以支持。

## 3. 可以成立的 350.101 跨版本关联

只有两类受限的类别级关联：

1. 历史环境/配置 JSON 中的部分名称与已观测的 `main-sign.F8` 环境 JSON key 集
   重叠。350.101 的 `CF79` 只证明向环境 JSON 对象写入；并未证明继承的字段顺序、
   值编码或 final pack offset。见 `f8_cf79_json_env_fields_350101.md:27-85` 和
   `token_report_field_map_350101.md:143-151`。350.101 写集为 **D**，跨版本语义延续
   为 **P**。
2. 历史配置名与文档中的 350.101 runtime sign-control 类别重叠；它们可以作为
   搜索/provenance 标签，但不能证明具体 writer、reader 或 branch effect。见
   `environment_inputs_350101.md:25-29`，状态为 **P**。

现有 350.101 字段台账仍是唯一的权威边界：

```text
历史字段类别
  -> JSON/TREE/risk/report 域
  -> 只有已 trace 的 350.101 writer + reader + consumer 才能命名 F/CF 边
```

## 4. 明确不能建立的关联

- `KLog` tag 不是 `MetaSecCtx350` 的 C offset、managed-frame slot 或 native VMP
  参数位置。
- `KLog` 不能证明 `CF31/CF33/CF90/CF91` 序列化该 schema；这些 helper 有独立的
  350.101 计长/写入边界，绑定 descriptor 前仍需要同版本 wire 证据。
- 历史 VM 名称和对象大小不得迁移到 `main-sign.F*`、`child-152B58.F*` 或
  `child-2BA250.F*`。
- 历史 cache 文件命名只证明环境/cache 域存在；不能由此识别 350.101 `.msf3_*` 的
  key、payload 或 consumer。

## 5. 对当前 F/CF 台账的影响

该材料不能缩小两个 active opaque child-module 缺口：

| 命名空间 | 当前已证实边界 | 闭合前仍需 |
|---|---|---|
| `child-152B58.F1` / 外层 `CF64` | bytecode/table coverage 完整；local baseline 已进入 F1。 | 子调用之间的 object alias、pointee write、ownership。 |
| `child-2BA250.F6` / 外层 `CF75` | child-F6 ABI 与 7 个可达 nested body decode 已知。 | `CF15`、result-tail/source alias、两条 ownership/lifetime 路径。 |

见 `cf63_cf64_child_module_boundary_350101.md:191-220` 与
`cf75_child_module_boundary_350101.md:171-204`。这两个模块彼此独立，F 编号不能
与 `main-sign.F8` 及其 source-work families 混写。

## 6. 未来允许升级结论的证据标准

只有同一个 350.101 样本同时具备以下链条，才可提升历史字段：

```text
field/tag + raw wire type
-> named writer
-> named reader
-> named 350.101 consumer
-> observed bounded effect
```

在此之前，将它作为 provenance 且标为 **P**；派生报告继续排除 raw identifier 和
其他敏感样本值。

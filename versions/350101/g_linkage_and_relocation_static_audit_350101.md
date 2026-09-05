# 350.101 G 链接与静态引用审计

## 范围

本文把现有 `G` 证据整理为一条可复查的静态链：module-local 名称、constructor
binding、blob import、linking symbol、data-slot、`reloc.CODE` 引用与 decoded F
body。它不描述运行时签名算法，也不把静态引用升级为实际执行、原始 global 读写方向或
host target 的对象语义。

样本身份、builder ABI 与逐项原始证据以
[g_binding_ledger_350101.md](g_binding_ledger_350101.md) 为准；本文只是交叉审计入口。

## 证据链与命名空间

```text
module-local G name
  -> constructor binding record
  -> module builder import link
  -> parsed env.Gx import
  -> linking symbol / package data slot
  -> reloc.CODE data-symbol reference
  -> decoded F body
```

图中的箭头表示可复查的命名或链接关联，不表示两端共用同一块存储。

每个 module 都有独立的 `G0...` 命名空间。相同编号不能跨 module 合并；两个 binding
target 地址相同，也只能证明它们复用了同一注册 target，不能推出对象布局、生命周期或
业务含义。

## 分层 alias 图

```text
constructor target T[module,G]
        │  binder 的 8-byte 值复制
        ▼
module import slot I[module,G]

package data slot D[module,G]  ←── static relocation ──  decoded F body
```

`T`、`I`、`D` 是三层不同的证据对象：每个 `(module,G)` 的 `I` 与 `D` 都必须保持
独立，当前没有 `I == D`、`T -> *T` 或 package slot 向 host 对象传播的证据。

在已枚举的 80 个 constructor binding 中，只有三组 `T` 可按**地址身份**合并：second
`G0` 与 child `G0`、second `G1` 与 child `G1`、second `G2` 与 main `G7` 及 child
`G2`。因此当前可写为 76 个 `T` identity 节点；其余登记 target 在这些表中未见重合。
这不合并同名 G：例如 HTTP/main 的 `G0` 没有同一 `T` 的静态证据。

## 当前静态覆盖

| module | G binding / import ABI | F 到 G 的静态引用 | 已收窄的访问形态 | 仍保持未知 |
|---|---|---|---|---|
| HTTP | 1/1 已闭合 | `F0/F1 → G0` | 仅显式 data-symbol reference | 读写方向、target 语义 |
| second | 65/65 已闭合 | 65/65 已闭合 | F1 对三个 package pool slot 的窄范围读取 | 其他 F 的操作方向与所有 target 语义 |
| main sign | 11/11 已闭合 | 11/11 已闭合 | 静态表/ELF cell 的地址身份与少量 native reader | managed 使用方向、cell 内值与被指向对象语义 |
| child | 3/3 已闭合 | `F0 → G0/G1/G2` | F0 对三个 package slot 的窄范围读取 | 原始 global 方向、target 语义 |

因此，注册/import ABI 是 **80/80**；四个 package 的显式 data-symbol 引用也是
**80/80**。这两个数字分别回答“能否链接”和“哪些 F body 有静态引用”，不回答
“运行时读了什么、写了什么或为何影响某个输出”。

## 已闭合的静态含义

1. `G` 不是 `CF` callback 表、`F` 导出表，也不是解释器的通用 call table。
2. builder 把不透明 target 按 pointer-width 值写入 module 接管的 import-slot 存储；这
   是链接动作，不是对 target 指向对象的解引用。
3. 四个 package 中解析到的 G data symbol 都可可靠归属到至少一个 code body；它只能
   标记为“显式静态引用”。
4. second F1 与 child F0 各有三个 package slot 的窄范围读取证据；该事实不等价于
   host target 的类型、字段宽度或原始 global get/set 方向。

## relocation record parser 的边界

native custom-section parser 可确认 `reloc*` payload 使用变长整数的 record 序列；当前
观察到的 `0x1b/0x1c` record 属于无 addend 形态。它只校验并消费记录、推进 cursor，
没有保存 record 字段、建立 symbol 映射或执行 code/data patch store。因此：

- package 交叉解析得到的 G symbol 与 F body 归属可作为静态引用证据；
- 不能把 parser 中的字段位置提升为已证实的 patch-site、目标段、写宽或端序；
- builder 的 import-slot 写入是另一条 host-import link，不是 `reloc.CODE` patch。
- 在当前已见的 parser→build→bind 调用链中，未找到独立的 relocation materializer；
  这只是当前静态材料的未发现结论，不等于全局不存在另一条尚未定位的 loader。

## 明确保留的边界

- 所有 G 的原始 global 读写方向、host target 的类型/所有权/字段含义均未知。
- native direct reader 与 managed G 静态引用不能仅凭 target 地址相同而建立因果关系。
- 静态引用不能证明该 F 会在某次请求、某个分支或某种环境下执行。

## 不依赖环境的后续静态工作

1. 在可获得的静态材料中定位实际 materialization/loader；只有它才能进一步回答
   relocation 的 patch-site、写入宽度和端序。
2. 对后续版本沿用同一分层 alias 图，重新枚举 `T` identity，而不由同名 G、相同 target
   或 package slot 引用推断 `I`/`D`/对象 alias。
3. 保持 package slot 读取、原始 global 方向和 host target 语义三层分离，避免由
   `reloc.CODE` 或相同 target 地址建立未证实的因果关系。

只有上述静态层完成后，才适合单独评估还需要哪些运行期证据；在此之前不应为未知 G
提供默认零值、普通指针模型或 CF callback 替代实现。

## 关联资料

- [G binding 台账](g_binding_ledger_350101.md)
- [managed VM 启动与模块构建](managed_vm_boot_350101.md)
- [CF64 child 边界](cf63_cf64_child_module_boundary_350101.md)
- [CF75 child 边界](cf75_child_module_boundary_350101.md)
- [总流程与证据等级](so_runtime_flow_350101.md)

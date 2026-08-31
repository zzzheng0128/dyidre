# 350.101 source-work outer family map

这份记录补上一个容易漏掉的层级：`F19/F20/F21` 这种 outer producer
并不是直接只调用 `F32/F40` block loop。`CALL_CF_INDEX` 绑定表显示，
outer 里面先会调用一个 20-record 小程序，再调用一个 67-record block loop。

目前结论：四套 family 都已经在多轮 source-work sweep 里跑到；单次固定请求会
随机/状态化选择其中一套，所以不能只看某一轮 trace。

## 总览

| outer template | outer records | first family call | second family call | 当前状态 |
|---|---:|---|---|---|
| `F18` / `0x1a0000126f0` | 752 | `idx 0x7d -> F22` / 20 records | `idx 0x7e -> F23` / 67 records | 已观测 source-work producer |
| `F19` / `0x1a00001497f` | 704 | `idx 0x7f -> F31` / 20 records | `idx 0x80 -> F32` / 67 records | 已观测 source-work producer |
| `F20` / `0x1a0000132b5` | 704 | `idx 0x81 -> F39` / 20 records | `idx 0x82 -> F40` / 67 records | 已观测 source-work producer |
| `F21` / `0x1a000013dba` | 752 | `idx 0x83 -> F47` / 20 records | `idx 0x84 -> F48` / 67 records | 已观测 source-work producer |

这里的 20-record 小程序先暂名为 `sourceWorkBlockAdapter_*`，67-record
小程序暂名为 `sourceWorkBlockLoop_*`。不要把 20-record adapter 误删：
它是 outer producer 的真实 `CALL_CF_INDEX` 目标之一。

## 绑定表证据

`op5e CALL_CF_INDEX` 的 native handler 形状仍然是：

```text
op5e handler: 0x1570DC
callee:       0x15AB1C
semantic:     program = (*(record.q1))[imm32]
```

当前 unidbg dump 中：

```text
q1  = 0x125fd3c0
*q1 = 0x12608000
```

从 `0x12608000` 绑定表读出的关键 index：

| index | program descriptor | F 名 | records | role |
|---:|---:|---|---:|---|
| `0x7d` | `0x127beb40` | `F22` | 20 | F18-family adapter |
| `0x7e` | `0x127beb80` | `F23` | 67 | F18-family block loop |
| `0x7f` | `0x127bebc0` | `F31` | 20 | F19-family adapter |
| `0x80` | `0x127bec00` | `F32` | 67 | F19-family block loop |
| `0x81` | `0x127bec40` | `F39` | 20 | F20-family adapter |
| `0x82` | `0x127bec80` | `F40` | 67 | F20-family block loop |
| `0x83` | `0x127becc0` | `F47` | 20 | F21-family adapter |
| `0x84` | `0x127bed00` | `F48` | 67 | F21-family block loop |
| `0x85` | `0x127bed40` | `F24` | 69 | F18-family key schedule / first-block pre-transform |
| `0x86` | `0x127bed80` | `F25` | 43 | F18-family scheduler |
| `0x87..0x8a` | `0x127bedc0..0x127bee80` | `F26..F29` | 28/26/23/154 | F18-family round primitives |
| `0x8b` | `0x127beec0` | `F30` | 21 | shared GF(2^8) multiply |
| `0x8c` | `0x127bef00` | `F33` | 69 | F19-family key schedule / first-block pre-transform |
| `0x8d` | `0x127bef40` | `F34` | 43 | F19/F32-family scheduler |
| `0x8e..0x91` | `0x127bef80..0x128b7080` | `F35..F38` | 28/26/25/154 | F19/F32-family round primitives |
| `0x92` | `0x128b7080` | `F41` | 69 | F20-family key schedule / first-block pre-transform |
| `0x93` | `0x128b70c0` | `F42` | 43 | F20/F40-family scheduler |
| `0x94..0x97` | `0x128b7100..0x128b71c0` | `F43..F46` | 28/26/21/154 | F20/F40-family round primitives |
| `0x98` | `0x128b7200` | `F49` | 67 | F21-family key schedule / first-block pre-transform |
| `0x99` | `0x128b7240` | `F50` | 43 | F21/F48-family scheduler |
| `0x9a..0x9d` | `0x128b7280..0x128b7340` | `F51..F54` | 28/24/23/154 | F21/F48-family round primitives |

注意：descriptor dump 每个文件读了 0x80 字节，所以前 `0x40` 是当前
descriptor，后 `0x40` 常常是内存中相邻的下一个 descriptor。这只能证明
descriptor table 的相邻布局，不能说成“前一个 descriptor 指针指向后一个”。

## outer 的调用骨架

四个 outer 的 `CALL_CF_INDEX` 序列是同一个骨架，只替换两处 family-specific
index：

```text
F18: 0x23, 0x7d, 0x65, 0x36, 0x48, 0x7e, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
F19: 0x23, 0x7f, 0x65, 0x36, 0x48, 0x80, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
F20: 0x23, 0x81, 0x65, 0x36, 0x48, 0x82, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
F21: 0x23, 0x83, 0x65, 0x36, 0x48, 0x84, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
```

可读理解：

```text
outer source-work producer
  -> common setup/helper
  -> family adapter       // 20 records: F22/F31/F39/F47
  -> common data movement
  -> family block loop    // 67 records: F23/F32/F40/F48
  -> common tail writeback
```

## F21 为什么比 F20 大

`F20` 是 704 records，`F21` 是 752 records。它不是完全不同算法，而是同模板的
“宽 call-frame / 宽窗口”版本：

- 两者核心 `CALL_CF_INDEX` 骨架一致；
- F21 的 family pair 是 `0x83/0x84`，对应 `F47/F48`；
- F21 多出来的 48 records 主要分布在 prologue、tail 和每个 call-frame
  附近，表现为参数窗口/临时 slot 更宽；
- F21 分支骨架仍然是少量前向跳转 + 一个回跳循环，和 F20 的 outer loop
  形态一致。

因此升级版本时，不能只用 record count 判断“704 才是 source-work outer”。
应该同时看：

1. 12 个 `CALL_CF_INDEX` 的骨架；
2. family pair 是否落到 `20 records + 67 records`；
3. 是否对 31-byte source 做 `0x01` padding，再写回 32-byte work area；
4. 后续是否进入 F12 的 31 次 `ST64` bit-pack burst。

## adapter / round family 已补全

完整子图见：

```text
dyidre/versions/350101/source_work_round_family_graph_350101.md
```

新增 body decode 证明：

- `F22/F31/F39/F47` 是 20-record adapter，同形，只替换 family call index；
- `F23/F32/F40/F48` 是 67-record block loop，同形，只替换 scheduler index；
- `F25/F34/F42/F50` 是 43-record scheduler，同形；
- `F29/F38/F46/F54` 是 154-record MixColumns-like，同形，内部 16 次调用
  `F30`；
- `F30` 是 shared 21-record GF(2^8) multiply；
- `op 0x0d` 已恢复成 `BYTE_FROM_U32_SHIFT`，round-family decode 已经全
  `unknown=0`。

## 当前下一步

AES-like 内层已经继续语义化：

- `F24/F33/F41/F49` 已恢复为 family XOR + 48-byte key expansion；
- `F23` 已确认 `s6=byte length`，不是 end pointer；
- `F29/F38/F46/F54` 的共同 GF 矩阵和四套 scratch swizzle 已落成 C；
- `F18/F22/F23` family-A 已拆出 `F24 -> F25 -> F26/F27/F28/F29 -> F30`。

详见 `source_work_f23_family_exact_350101.md`。后续已经补完：

- 四族 runtime vectors：`source_work_vectors_350101.md`
- 四族 byte-exact C 回归：`source_work_vector_selfcheck_350101.c`
- 当前 selfcheck 结果：`failures=0`

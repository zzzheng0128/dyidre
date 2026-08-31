# x0 struct promotion plan

- entry address: `0x7327278780`
- max observed access end: `0x500`

## 怎么用这份报告

1. `stable_field/ref_pair` 可以优先写进结构体草稿。
2. `embedded_candidate` 不要直接命名最终字段，先对它指向的对象再跑一轮 entry dump / read-write trace。
3. `scratch_buffer` 只按时间线理解，不按单个 offset 命名。
4. 如果同一 offset 的 writer/reader PC 能在 IDA 里解释为锁、引用计数、copy、varint，再升级成强字段。

## PC 热点

- `libmetasec_ml.so+0x138560`: touches `160` observed offsets
- `libc.so+0x1c7a8`: touches `64` observed offsets
- `libmetasec_ml.so+0x117f30`: touches `40` observed offsets
- `libmetasec_ml.so+0x117ec8`: touches `11` observed offsets
- `libmetasec_ml.so+0x117edc`: touches `7` observed offsets
- `libmetasec_ml.so+0x116b18`: touches `6` observed offsets
- `libc.so+0x1c1c0`: touches `6` observed offsets
- `libc.so+0x1c1a4`: touches `6` observed offsets
- `libmetasec_ml.so+0x117ef4`: touches `5` observed offsets
- `libc.so+0x1c1cc`: touches `5` observed offsets
- `libc.so+0x1c294`: touches `4` observed offsets
- `libmetasec_ml.so+0x117f04`: touches `4` observed offsets
- `libc.so+0x1c29c`: touches `4` observed offsets
- `libc.so+0x1c2a4`: touches `4` observed offsets
- `libc.so+0x1c2ac`: touches `4` observed offsets
- `libc.so+0x1c18c`: touches `4` observed offsets
- `libc.so+0x1c2bc`: touches `4` observed offsets
- `libc.so+0x1c2c0`: touches `4` observed offsets
- `libc.so+0x1c2c4`: touches `4` observed offsets
- `libc.so+0x1c2c8`: touches `4` observed offsets

## 字段候选

### ref_pair

| off | current name | access | pcs | reason / content |
|---:|---|---|---|---|
| `+0x240` | `field_240` | `RW 8 #2` | libmetasec_ml.so+0x47930 (1)<br>libmetasec_ml.so+0x47c78 (1) | adjacent {obj, refcnt} pair; confirm through shared_ref helpers<br>`0x0000000000000000, 0x0` |
| `+0x248` | `field_248` | `W 8 #2` | libmetasec_ml.so+0x4ac04 (1)<br>libmetasec_ml.so+0x47c84 (1) | second half of shared_ref pair at ctx+0x240/+0x248; written by 0x47c84 and cleared by 0x4ac04<br>`0x0, 0x125d7b30` |

### stable_field

| off | current name | access | pcs | reason / content |
|---:|---|---|---|---|
| `+0x008` | `ptr_008` | `R 8 #2` | libmetasec_ml.so+0x14a004 (1)<br>libmetasec_ml.so+0x14a0c0 (1) | runtime read/write evidence exists; safe to name if static use matches<br>`P...p....h..p....h..p....h..p....H4Gs....p4Gs.........U.........` |
| `+0x258` | `field_258` | `R 8 #1` | libmetasec_ml.so+0x74028 (1) | static+runtime overlay: op2+0x78 rwlock_holder read at 0x74028; top-level ctx offset is 0x258<br>`0x0000000012629a40` |
| `+0x260` | `flag_260` | `RW 1 #3` | libmetasec_ml.so+0x7480c (1)<br>libmetasec_ml.so+0x74020 (1)<br>libmetasec_ml.so+0x7419c (1) | runtime read/write evidence exists; safe to name if static use matches<br>`0x00, 0x1, 0x0` |

### embedded_candidate

| off | current name | access | pcs | reason / content |
|---:|---|---|---|---|
| `+0x000` | `ops_or_vtable` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`.c..p....d..p....0..p...d0..p...x...p.......p...p...p.......p...` |
| `+0x010` | `msdata_node` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`.................q...............msf3_...........q..............` |
| `+0x018` | `ptr_018` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`x...p.....5.s....\t+Gt....Q4Gs.....+Gt...@.5.s...p.+Gt...`.5.s...` |
| `+0x020` | `ptr_020` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`....k.................[..........................A....Y.........` |
| `+0x028` | `ptr_028` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`x...p...........................................................` |
| `+0x030` | `ptr_030` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`X...p...P.(.t....2/Gs.....(Gt...p.(Gt..................C........` |
| `+0x038` | `ptr_038` | `  #0` |  | entry content points to nested object/string; needs read/write watch on target object<br>`....... .S....>.................p.+Gt.....+Gt....A..............` |
| `+0x1e0` | `field_1e0` | `R 8 #1` | libmetasec_ml.so+0x14a0ec (1) | static+runtime overlay: registry_find_type(type=2) returns ctx+0x1e0; 0x14a0ec reads op2.ops here<br>`0x00000000122618b0` |

### scratch_buffer

| range | proposed field | writes | top pcs | reason |
|---:|---|---:|---|---|
| `+0x3c0..+0x460` | `env_tlv_scratch_3c0[0xa0]` | `197` | libc.so+0x1c7a8 (64)<br>libmetasec_ml.so+0x117f30 (40)<br>libmetasec_ml.so+0x117ec8 (11)<br>libmetasec_ml.so+0x117edc (7)<br>libmetasec_ml.so+0x116b18 (6) | TLV/env/text scratch; see x0_tail_timeline.md |
| `+0x460..+0x500` | `transform_out_460[0xa0]` | `181` | libmetasec_ml.so+0x138560 (160)<br>libc.so+0x1c294 (2)<br>libc.so+0x1c29c (2)<br>libc.so+0x1c2a4 (2)<br>libc.so+0x1c2ac (2) | transform/output bytes; byte-copy hot loop at libmetasec_ml.so+0x138560 |

## 下一轮 trace 建议

- 对 `ctx->registry` 指向对象做 watch：目标是固定 `fun_mutex` 和 `risk_items/tree head` 的真实 offset。
- 对 `MetaSecRegistryEntry350.payload` 返回的对象逐 type 记录：比如 type=2 已确认是 `ctx+0x1e0`。
- 对 `ctx+0x10/0x18/0x20/...` 指向的 `MetaSecNode350` 单独跑 nested dump，确认 node 里 length/string/ref 的布局。
- 对 `ctx+0x3c0..0x500` 继续看 timeline，不要作为固定字段拆碎。

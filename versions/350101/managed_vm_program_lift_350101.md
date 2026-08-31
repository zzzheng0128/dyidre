# 350.101 managed VM program lift notes

Scope:

- managed interpreter: `0x1555A4 managedBytecodeRun_350`
- HTTP/sign programs: `F5`, `F7`, `F8`, `F13`, `F15`
- nested transform programs currently relevant to `F8/X-Medusa`:
  `F12`, `F18`, `F19`, `F20`, `F21`, `F22`, `F23`, `F30`, `F31`,
  `F32`, `F34`, `F35`, `F36`, `F37`, `F38`, `F39`, `F40`, `F42`,
  `F43`, `F44`, `F45`, `F46`, `F47`, `F48`
- decoded output: `dyidre/versions/350101/managed_vm_decode/`

这份不是重新解释 VM 原理，而是把已经解出的 bytecode 往“业务伪代码”
再抬一层：哪些 record 只是保存寄存器/临时栈，哪些 record 真的在准备
`X-*` header。

## 总体判断

`F5/F7/F8/F13/F15` 已经可以完整 decode，当前样本 unknown opcode 为 0。
后续真正要还原的是两类东西：

1. managed bytecode 自己的参数搬运、常量拼装、分支；
2. `op5e CALL_CF_INDEX` 调进 native binding 后的业务 helper。

因此现在的恢复边界是：

```text
managed VM bytecode: 已经能线性 lift
CF/native helper:    部分已命名，flattened crypto/transform 还要继续拆
```

## 程序和 header 对应

| Program | Wrapper | Header/output | Body size | 当前恢复状态 |
|---|---:|---|---:|---|
| `F5` | `0x1715F8` | `X-Argus` | `0x4728` / 759 records | 大包主流程和尾部 `0xc2` pack 已字节级闭环 |
| `F7` | `0x171648` | `X-Ladon` | `0x0ea0` / 156 records | 短包流程已结构化 |
| `F8` | `0x171698` | `X-Medusa` | `0x21870` / 5722 records | 大包主流程已定位，包含大量环境/JSON copy |
| `F13` | `0x1716F4` | `X-Helios` side path | `0x0e70` / 154 records | 和 F7 同族，差异字段已定位 |
| `F15` | `0x171794` | digest state init | `0x02a0` / 28 records | 被 `CF61` 调用，用于 32-byte digest 初始化 |

嵌套 transform 程序不直接 emit header，它们是 `F8/X-Medusa` 中间 work area
的生产/变换层：

| Program | Runtime body/id | Body size | 当前恢复状态 |
|---|---:|---:|---|
| `F12` | `0x800001245f` | `0x0f48` / 163 records | source stream -> sub-work qword bit-pack；31 次 `ST64` 已能反推出 source byte |
| `F18` | `0x1a0000126f0` | `0x4680` / 752 records | observed source-work outer branch；CALL_CF_INDEX `0x7d/0x7e -> F22/F23` |
| `F19` | `0x1a00001497f` | `0x4200` / 704 records | observed source-work outer producer；CALL_CF_INDEX `0x7f/0x80 -> F31/F32` |
| `F20` | `0x1a0000132b5` | `0x4200` / 704 records | observed source-work outer producer；CALL_CF_INDEX `0x81/0x82 -> F39/F40` |
| `F21` | `0x1a000013dba` | `0x4680` / 752 records | observed source-work outer branch；CALL_CF_INDEX `0x83/0x84 -> F47/F48` |
| `F22` | `0x2000016019` | `0x01e0` / 20 records | F18-family block adapter；calls `0x85 -> F24` and `0x36` |
| `F23` | `0x500001606d` | `0x0648` / 67 records | F18-family 16-byte block loop；calls `0x86 -> F25` |
| `F24` | `0x165a6` | `0x0678` / 69 records | F18-family key schedule / first-block pre-transform |
| `F25` | `0x30000166be` | `0x0408` / 43 records | F18-family block-round scheduler |
| `F26` | `0x1676d` | `0x02a0` / 28 records | F18-family round-key XOR |
| `F27` | `0x167e0` | `0x0270` / 26 records | F18-family S-box lookup + column byte rotation |
| `F28` | `0x1684b` | `0x0228` / 23 records | F18-family fixed permutation |
| `F29` | `0x70000168ab` | `0x0e70` / 154 records | F18-family MixColumns-like；内部调用 `F30` |
| `F30` | `0x16b16` | `0x01f8` / 21 records | GF(2^8) multiply；`xtime` reduction polynomial `0x1b` |
| `F31` | `0x200001617c` | `0x01e0` / 20 records | F19-family block adapter；calls `0x8c -> F33` and `0x36` |
| `F32` | `0x50000161d0` | `0x0648` / 67 records | 16-byte block loop；F32-family |
| `F33` | `0x16b6e` | `0x0678` / 69 records | F19-family key schedule / first-block pre-transform |
| `F34` | `0x3000016c86` | `0x0408` / 43 records | block-round scheduler；F32-family |
| `F35` | `0x16d35` | `0x02a0` / 28 records | round-key XOR；F32-family |
| `F36` | `0x16da8` | `0x0270` / 26 records | S-box lookup + column byte rotation；F32-family |
| `F37` | `0x16e13` | `0x0258` / 25 records | fixed 16-byte permutation；F32-family，12 writes |
| `F38` | `0x7000016e7b` | `0x0e70` / 154 records | MixColumns-like 16-byte transform；内部多次 `CALL_CF_INDEX 0x8b -> F30` |
| `F39` | `0x20000162df` | `0x01e0` / 20 records | F20-family block adapter；calls `0x92 -> F41` and `0x36` |
| `F40` | `0x5000016333` | `0x0648` / 67 records | 16-byte block loop；pre/post XOR key area，中间 `CALL_CF_INDEX 0x93 -> F42` |
| `F41` | `0x170e7` | `0x0678` / 69 records | F20-family key schedule / first-block pre-transform |
| `F42` | `0x30000171ff` | `0x0408` / 43 records | block-round scheduler：`F43 -> F44 -> F45 -> F46 -> F43 -> F44 -> F45 -> F43` |
| `F43` | `0x172ae` | `0x02a0` / 28 records | 16-byte round-key XOR，4-byte 小端/反序应用 |
| `F44` | `0x17321` | `0x0270` / 26 records | S-box lookup + column byte rotation |
| `F45` | `0x1738c` | `0x01f8` / 21 records | 固定 16-byte permutation，10 writes |
| `F46` | `0x70000173e4` | `0x0e70` / 154 records | MixColumns-like 16-byte transform；内部多次 `CALL_CF_INDEX 0x8b -> F30` |
| `F47` | `0x2000016442` | `0x01e0` / 20 records | F21-family block adapter；calls `0x98 -> F49` and `0x36` |
| `F48` | `0x5000016496` | `0x0648` / 67 records | F21-family 16-byte block loop；calls `0x99 -> F50` |
| `F49` | `0x17650` | `0x0648` / 67 records | F21-family key schedule / first-block pre-transform，短变体 |
| `F50` | `0x3000017760` | `0x0408` / 43 records | F21-family block-round scheduler |
| `F51` | `0x1780f` | `0x02a0` / 28 records | F21-family round-key XOR |
| `F52` | `0x17882` | `0x0240` / 24 records | F21-family S-box lookup + column byte rotation，短变体 |
| `F53` | `0x178e5` | `0x0228` / 23 records | F21-family fixed permutation |
| `F54` | `0x7000017945` | `0x0e70` / 154 records | F21-family MixColumns-like；内部调用 `F30` |

## F7 / F13 短包程序

这两个最适合先落成“可读伪代码”，因为没有复杂分支，body 很短。

入口参数都是 `MetaSecManagedShortCallArg350 *arg`，wrapper 把它放到 slot4：

```c
typedef struct MetaSecManagedShortCallArg350 {
    int64_t seed_or_handle;       // +0x00
    MEM_BLOCK *derived_block;     // +0x08, 当前样本内容形态类似 "1128"
    JSON_LIST *json_list;         // +0x10
    MEM_BLOCK *stack_memblock;    // +0x18, 当前样本内容形态类似 "1588093228"
    char **out_key;               // +0x20
    char **out_value;             // +0x28
} MetaSecManagedShortCallArg350;
```

### 共同骨架

下面是去掉保存/恢复 slot 后的结构化流程：

```c
void managedShortHeader_F7_or_F13(MetaSecManagedShortCallArg350 *arg) {
    ShortScratch sc = {0};

    sc.out_key = arg->out_key;
    sc.out_value = arg->out_value;

    MEM_BLOCK *derived = arg->derived_block;
    JSON_LIST *json = arg->json_list;
    MEM_BLOCK *env_text = arg->stack_memblock;
    uint64_t seed = arg->seed_or_handle;

    /*
     * record 0x2b / CF100:
     *   "%u-%s-%s" -> text MEM_BLOCK
     * 当前样本能看到类似：
     *   "1788108717-1588093228-1128"
     */
    MEM_BLOCK text = CF100_format("%u-%s-%s", seed, env_text, derived);

    /*
     * record 0x32, 0x4b / CF38:
     *   从 VM 本地 scratch 中拷贝两个 4-byte 片段成 MEM_BLOCK。
     * 这些片段后续一个作为 transform scratch，一个作为 pack prefix。
     */
    MEM_BLOCK transform_or_scratch = CF38_init_by_src(&sc.transform32_seed, 4);
    MEM_BLOCK prefix_or_pack = CF38_init_by_src(&sc.prefix4_seed, 4);

    /*
     * record 0x52 / CF48:
     *   shortHeaderTransform32_flattened(text, transform_or_scratch, key32)
     * 返回/改写出 32-byte 二进制结果。
     */
    CF48_short_transform32(&text, &transform_or_scratch, derived_or_key32);

    /*
     * record 0x55 / CF49:
     *   prefix4 + transform32 -> 0x24 bytes
     */
    MEM_BLOCK pack36 = CF49_concat_prefix_transform(&prefix_or_pack, &transform_or_scratch);

    /*
     * record 0x59 / CF44:
     *   base64(0x24 bytes) -> 48-char header value
     */
    MEM_BLOCK b64 = CF44_base64(&pack36);

    /*
     * record 0x7b/0x82 for F7, 0x79/0x80 for F13:
     *   CF98("%s") writes key and value through out_key/out_value.
     * 真正 header 名字由 runtime CF98 post-return 坐实：
     *   F7  -> "X-Ladon"
     *   F13 -> "X-Helios"
     */
    CF98_format_alloc(arg->out_key, decoded_key_material);
    CF98_format_alloc(arg->out_value, b64.body.mem);
}
```

### F7 与 F13 的真正差异

`F7/F13` 前半段 record `0x00..0x5f` 基本同构。差异从 `0x60`
开始，主要是“从哪里取 4-byte prefix/key material”和“用哪一段常量池”。

| 区间 | F7 / X-Ladon | F13 / X-Helios |
|---:|---|---|
| `0x60` | 读 `json_list + 0xf8` 的 1 byte，写 `scratch+0x26` | 读 pool `+0x79` 的 3-byte 片段，写 `scratch+0x24/+0x26` |
| `0x61..0x6f` | 构造一个 64-bit 常量：`0xb18f_ff35_a63d_3dfd` 形态；同时读 pool `+0x58` 的 3-byte 片段 | 读 pool `+0x6d` 的 9-byte 片段，同时读 `json_list +0x15c/+0x15e` |
| `0x70..0x72` | `scratch+0x28` 写入构造出的 64-bit 常量，`scratch+0x20/+0x22` 写 pool 片段 | `scratch+0x28/+0x30` 写 pool 9-byte 片段 |
| `CF98 出口` | record `0x7b` 写 key，record `0x82` 写 value | record `0x79` 写 key，record `0x80` 写 value |

当前 observed 值：

```text
F7/X-Ladon:
  CF100 text       = "1788108717-1588093228-1128"
  CF48 key/input6  = "b5b49dcffaa587dccaa36fec8005a08c"
  CF48 output32    = 7a bd 4b db 12 ba 2b 22 82 a8 ef fd 65 ea 43 27 ...
  CF49 pack36      = 7c c8 a0 10 || output32
  CF98 key/value   = "X-Ladon" / 48-char base64

F13/X-Helios:
  CF100 text       = "1788108717-1588093228-1128"
  CF48 key/input6  = "c4aebafaa687f565cdec6d5eb75c95de"
  CF48 output32    = 74 f5 5f 3e 23 d3 c8 57 0d 15 df e5 d4 a2 fd c0 ...
  CF49 pack36      = 30 e4 7f 2c || output32
  CF98 key/value   = "X-Helios" / 48-char base64
```

### F7/F13 结构体补充

这部分可以在 IDA 里作为函数局部 scratch 看待，不建议把它当稳定 ABI。

```c
typedef struct MetaSecShortHeaderScratch350 {
    uint8_t  unknown_00[0x10];
    char   **out_key;              // +0x10, copied from arg+0x20
    char   **out_value;            // +0x18, copied from arg+0x28
    uint8_t  key_material_a[0x04];  // +0x20
    uint8_t  key_material_b[0x04];  // +0x24
    uint8_t  b64_or_key_tmp[0x10];  // +0x28
    uint8_t  tmp_ref_38[0x18];      // +0x38
    MEM_BLOCK transform32;          // +0x50, CF48 output side
    MEM_BLOCK prefix_or_pack36;     // +0x68, CF49 output side, then CF44 input
    MEM_BLOCK tmp80;                // +0x80
    MEM_BLOCK formatted_text;       // +0x98, CF100 output
    uint8_t  tmp_b0[0x1c];          // +0xb0
    uint32_t len_or_seed_cc;        // +0xcc
} MetaSecShortHeaderScratch350;
```

## F5 / X-Argus

F5 使用 `MetaSecManagedCallArg350` full pack。它比 F7 大很多，但现在可以
先按 CF 出口切成几段。最新 focused CF tail run 已经把最终 `0xc2`
binary pack 的拼接链验证出来：

```text
pack24 = 0x20 digest/material + 0x04 dyn
pack44 = pack24 + 0x20 digest/material
sm3_44 = SM3(pack44)
tailA8 = 0x08 constant/count + 0xa0 transformed block
bodyB1 = (0x01 prefix + 0x08 prefix) + tailA8
bodyB3 = bodyB1 + 0x02 suffix
argusC2 = 0x02 prefix + 0xc0 transformed body
X-Argus = base64(argusC2)
```

机械验证报告：

```text
dyidre/versions/350101/f5_x_argus_pack_lift_350101.md
```

关键 CF 断点：

| record | helper | 作用 |
|---:|---|---|
| `0x003e` | `CF10` | 拷贝第一段 URL/query/stub 相关材料 |
| `0x0047` | `CF10` | 拷贝第二段材料 |
| `0x0064` | `CF10` | 拷贝 pack 中间块 |
| `0x00a2` | `CF10` | 拷贝 registry/env/token 派生块 |
| `0x0197` | `CF38` | snapshot digest/pack fragment |
| `0x01a9` | `CF38` | snapshot fragment |
| `0x01bc` | `CF38` | snapshot fragment |
| `0x0207` | `CF10` | 拷贝 0x44-class 中间材料 |
| `0x024f` | `CF38` | snapshot 末端 fragment |
| `0x0254` | `CF38` | snapshot 末端 fragment |
| `0x0259` | `CF30` | `1 + 8 -> 0x09` prefix |
| `0x025f` | `CF30` | `0x09 + 0xa8 -> 0xb1` body |
| `0x0263` | `CF42` | 低 16 位小端打包：`low16(0x6f80) -> 80 6f` |
| `0x0268` | `CF30` | `0xb1 + 2 -> 0xb3` |
| `0x027d` | `CF43` | `0xb3` body + 16-byte material/iv 进入 AES mode/PKCS#7 transform；当前 type1 为 AES-128-CBC，对齐到 `0xc0` |
| `0x0287` | `CF42` | 低 16 位小端打包：`low16(0x6f80e11b) -> 1b e1` |
| `0x028c` | `CF30` | `2 + 0xc0 -> 0xc2`，即最终 Argus binary |
| `0x0290` | `CF44` | base64，输入长度约 `0xc2` |
| `0x02b6` | `CF98` | 写回 header key：`X-Argus` |
| `0x02bd` | `CF98` | 写回 header value：约 `0x104` 字符 |

恢复策略：F5 的 bytecode 算术部分主要在拼 fixed-width binary pack。
不要先陷进每条 `OR64/ADD64_IMM16`；先沿 `CF10/CF38/CF30/CF42/CF43/CF44/CF98`
的 MEM_BLOCK 生命周期，把每个中间块命名出来。

## F8 / X-Medusa

F8 是最大的 managed 程序，当前 clean bytecode mark 显示它主路径里确实有
多次 `CF07 memcpy`，这不是旧 phase-level 误归因。

| record | helper | 作用 |
|---:|---|---|
| `0x0360` | `CF38` | 初始化第一段 4/16-byte 材料 |
| `0x0481` | `CF38` | 初始化第二段材料 |
| `0x05a2` | `CF38` | 初始化第三段材料 |
| `0x0a5b` | `CF10` | 拷贝 full pack 派生材料 |
| `0x0c57` | `CF07` | mini work area +0x00，拷贝 0x04 dyn4 |
| `0x0c94` | `CF07` | mini work area +0x04，拷贝 0x10 dyn16 |
| `0x0d31` | `CF07` | large subpack work area +0x000，拷贝 0x01 flag |
| `0x0d6d` | `CF07` | large subpack work area +0x001，拷贝 0x08 time/seed-like bytes |
| `0x0daa` | `CF07` | large subpack work area +0x009，拷贝 0x2a4 blob |
| `0x0de8` | `CF07` | large subpack work area +0x2ad，拷贝 0x02 trailer |
| `0x0f99` | `CF38` | 初始化后半段材料 |
| `0x1018..0x1160` | `CF07 x6` | 拼最终 Medusa binary pack：mutated mini + const/flag/marker + mutated large subpack |
| `0x119a` | `CF44` | base64，输入长度约 `0x2c4/0x2c8` |
| `0x12c9` | `CF98` | 写回 header key：`X-Medusa` |
| `0x133e` | `CF98` | 写回 header value：约 `0x3b0/0x3b8` 字符 |

最新 raw-CF07 证明见
`dyidre/versions/350101/x_medusa_pack_350101.md`：
`base64(CF44 input)` 与最终 `X-Medusa` 完全一致。注意 early work area
和 final copy bytes 不同，说明中间有原地变换，不能把 `0x0c57..0x0de8`
的预组装字节直接当最终 X-Medusa 输入。

最新 write-watch 证明见
`dyidre/versions/350101/f8_x_medusa_mutation_watch_350101.md`：

| work area | writer | interp0 | record/status | 作用 |
|---|---:|---:|---:|---|
| mini `0x14` bytes | `0x157EE4 ST8` | `0x310000010d7` | `0xcbc/0xcc2/0xcc7/0xccd` | F8 主程序四个 byte writer 跑 5 轮 |
| sub prefix `0xf8` bytes | `0x157EB0 ST64` | `0x800001245f` | `0x82` | 嵌套 F12 bit-pack/bit-permute 循环，31 个 qword |

F12 program descriptor 锚点：

```text
global 0x2C5930
body/id 0x800001245f
code 0x125D0000..0x125D0F48
records 163 / known 163 / unknown 0
```

F12 当前可恢复成一个“source byte stream -> sub-work qword bit patch”的
小程序。参数形状是：

```text
s4 = dst_base/sub-work
s5 = dst_limit，当前 0x2af
s6 = source byte stream
s7 = count，当前 31
```

当前大长度路径中 `phase=0`，每轮 `src++`、`dst += 8`，把 1 个 source
byte 的 8 个 bit 分别写进当前 qword 的固定位置。第一笔 watch 的
`old sub[0] = 0x35` 不是 source，按 bytecode 反推 source byte 是 `0xb1`。
31 次 `ST64` 可唯一反推出 source stream：

```text
b1 58 6e 0f f7 2c f9 36 18 b1 c3 4c 92 b5 e1 24
c5 ea 12 ca 3d 0e f6 1c bb e6 e7 ff 9e fc df
```

伪 C 见：

```text
dyidre/versions/350101/f12_medusa_subpack_recovered_350101.c
```

### F12 source stream 的生产链：四套实跑 source-work family

继续给 `CF97 slot4/source-work` 加写监控后，已经能看到 F12 的 source
stream 不是 `CF97` 单独生成。多轮 source-work sweep 已经跑到四套 family；
固定请求单轮只会选择其中一套：

```text
F18/F22/F23-family:
  F18 outer producer   interp0=0x1a0000126f0
  F22 block adapter    interp0=0x2000016019
  F23 block loop       interp0=0x500001606d
  F24 key schedule     interp0=0x165a6
  F25 scheduler        interp0=0x30000166be
  F26/F27/F28/F29      round primitive family
  // 已在 source-work sweep 中实跑到，runtime vector 已收齐

F19/F31/F32-family:
  F19 outer producer   interp0=0x1a00001497f
  F31 block adapter    interp0=0x200001617c
  F32 block loop       interp0=0x50000161d0
  F33 key schedule     interp0=0x16b6e
  F34 scheduler        interp0=0x3000016c86
  F35/F36/F37/F38      round primitive family

F20/F39/F40-family:
  F20 outer producer   interp0=0x1a0000132b5
  F39 block adapter    interp0=0x20000162df
  F40 block loop       interp0=0x5000016333
  F41 key schedule     interp0=0x170e7
  F42 scheduler        interp0=0x30000171ff
  F43/F44/F45/F46      round primitive family

F21/F47/F48-family:
  F21 outer producer   interp0=0x1a000013dba
  F47 block adapter    interp0=0x2000016442
  F48 block loop       interp0=0x5000016496
  F49 key schedule     interp0=0x17650
  F50 scheduler        interp0=0x3000017760
  F51/F52/F53/F54      round primitive family
  // 已在 source-work sweep 中实跑到，runtime vector 已收齐
```

关键 write timeline 见：

```text
dyidre/versions/350101/f19_f32_source_work_timeline_350101.md
dyidre/versions/350101/f20_f40_source_work_timeline_350101.md
dyidre/versions/350101/source_work_family_compare_350101.md
dyidre/versions/350101/f18_f21_source_work_outer_compare_350101.md
dyidre/versions/350101/source_work_round_family_graph_350101.md
```

早期 F20/F40 run 的 `source-work` 边界：

```text
pre-transform 31 bytes:
38 64 29 d4 8c c8 ad cd d1 44 d8 23 be 29 32 5e
b2 e5 0c c6 63 65 7d 5a 4c 85 fe eb fd ac a2

post-transform 32 bytes:
e6 40 ad 61 51 42 bb 3d 39 f4 fd 74 64 85 cc 03
14 54 d5 57 a8 0f 56 59 fe 8e 14 d3 68 55 0e 3b
```

已落成的 C 版半还原骨架：

```text
dyidre/versions/350101/f20_f21_medusa_source_transform_recovered.c
```

其中已经确定：

```text
op5e = program = (*(record.q1))[imm32], then managedProgramInvokeCore_350
op23 = SEXT8_SLOT, S[c]=(int64_t)(int8_t)(uint8_t)S[b]

index 0x7d/0x7e -> F22/F23
index 0x7f/0x80 -> F31/F32
index 0x81/0x82 -> F39/F40
index 0x83/0x84 -> F47/F48
index 0x8b       -> F30
index 0x85/0x86 -> F24/F25
index 0x87..0x8a -> F26/F27/F28/F29
index 0x8c/0x8d -> F33/F34
index 0x8e..0x91 -> F35/F36/F37/F38
index 0x92/0x93 -> F41/F42
index 0x94..0x97 -> F43/F44/F45/F46
index 0x98/0x99 -> F49/F50
index 0x9a..0x9d -> F51/F52/F53/F54

F30 = GF(2^8) multiply, xtime reduction polynomial 0x1b
F25/F34/F42/F50 = block-round scheduler family
F26/F35/F43/F51 = round-key XOR family
F27/F36/F44/F52 = S-box lookup + column rotate family
F28/F37/F45/F53 = fixed byte permutation family
F22/F31/F39/F47 = 20-record block adapter family
F24/F33/F41/F49 = key schedule / first-block pre-transform family
F23/F32/F40/F48 = 16-byte block loop with pre/post XOR and scheduler helper
F29/F38/F46/F54 = fixed GF matrix using F30; exact per-family scratch swizzles
```

其中 `F23` 已确认 `s4=key_area,s5=data,s6=byte_length`；family-A 的
`F24/F25/F26/F27/F28/F29/F30` 已落成结构化 C。四个 mix 程序的 scratch
顺序分别是 `2031 / 1320 / 3210 / 2310`（数字表示原 4-byte group 下标）。
详见 `source_work_f23_family_exact_350101.md`。

F8 的两个 bytecode 写回点当前已经推进到可验证形态：

1. mini：`0xcbc/0xcc2/0xcc7/0xccd` 是 F8 主程序的 `ST8` loop，
   20 字节 mini-work 被分成五个 4-byte lane，全部 XOR
   `key32=(uint32_t)*(state+0x60)`。两组 runtime 向量已由
   `f8_medusa_mini_xor_recovered_350101.c` 验证，当前 `failures=0`。
2. sub：source-work 四族已完成 32-byte 已知向量闭环；F12 消费前 31 字节，
   在大长度路径下 `phase=0,dst+=8,src++`，31 条 `ST64` old/new 已由
   `f12_medusa_subpack_recovered_350101.c` 验证，当前 `failures=0`。

`F8` 还包含环境/检测状态进入 JSON/binary pack 的逻辑。参数级 trace 里
看到的 `CF79` 字段为：

```text
cmr, cmr2, un_h, vpn, kd, fkd, pd, do
```

注意这里 `CF79` 在精确 bytecode mark 中没有标出来，是因为当前 runtime mark
只覆盖了 descriptor-meta 能直接匹配的主 body 调用点；参数级 phase trace
仍然说明 F8 这段业务会进入 JSON number writer。后续拆 F8 时，要同时拿
`*.linear.c` 和 `sign6_350101_cf79_doublebits_20260831_0045.log` 对照。

## 剩余还原面

已经闭环：

1. `CF61`：标准 SM3，`cf61_sm3_recovered_350101.c` 当前 `failures=0`。
2. `CF48/CF49/CF44`：X-Ladon/X-Helios 短头链，`cf48_f17_recovered_350101.c`
   当前 `failures=0`。
3. source-work 四族：`source_work_vector_selfcheck_350101.c` 当前
   `failures=0`。
4. F12 large-sub bitpack：`f12_medusa_subpack_recovered_350101.c` 当前
   `failures=0`。
5. F8 mini-work XOR：`f8_medusa_mini_xor_recovered_350101.c` 当前
   `failures=0`。
6. F5/X-Argus pack：`x_argus_pack_350101.md` 和
   `f5_x_argus_pack_lift_350101.md` 已闭环；`CF30` ladder 全部验证为
   `slot4 == slot5 || slot6`，最终 `CF44 input len=0xc2 -> base64 len=0x104
   -> final X-Argus`，校验为 true。
7. F5/X-Argus tail crypto：`CF41` 已验证为 SIMON128/256 + PKCS#7
   （`cf41_simon128_256_recovered_350101.c` 当前 `failures=0`），`CF43`
   当前 mode type1 已验证为 AES-128-CBC + PKCS#7
   （`cf43_aes128_cbc_recovered_350101.c` 当前 `failures=0`）。

剩余主要是字段命名，不是 VM opcode 缺失：

1. `F8/X-Medusa`：最终 `0x2c8` binary pack 的外层布局、mini XOR、
   F12 sub-prefix bit-pack、source-work 四族都已闭环；`CF79` 已确认
   `cmr/cmr2/un_h/vpn/kd/fkd/pd/do` 是 JSON/env number 输入，不是 final
   pack 明文字段。继续深挖时应追 JSON serialization/source-work 输入，而不是
   在 final `0x2c8` 里按 u32/u64/double 直接搜偏移。
2. `F5/X-Argus`：byte-exact 出口、尾部拼包和两层 tail crypto 都已闭环；
   `CF41=SIMON128/256`，`CF42=LE u16 MEM_BLOCK`，`CF43=type1 AES-128-CBC`。
   `CF41` 明文 `0x92` 已对齐到 `XArgusStruct` protobuf wire data。
   继续深挖时重点是 optional/env 字段何时出现，以及 `bodyB3/finalC2`
   这类加密前后容器的命名，而不是 VM opcode、header 边界或 block 算法本身。

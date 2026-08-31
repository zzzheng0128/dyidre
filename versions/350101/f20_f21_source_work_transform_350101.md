# 350.101 source-work transform families

这份报告回答一个具体问题：`F12` 用来 bit-patch `sub-work` 的 31-byte
source stream 是哪里来的。

## 结论

它不是 `CF97` 单独生成的。`CF97 @ 0x170110` 只是一个能观察到结果的
boundary/commit/release-style helper。真正的 source-work producer 在更前面，
而且目前已经通过多轮 source-work sweep 观察到四套同构 family：

```text
F18/F22/F23-family:
  F18 outer producer
    -> F22 block adapter
    -> F23 block loop

F19/F31/F32-family:
  F19 outer producer
    -> F31 block adapter
    -> F32 block loop
       -> F34 scheduler
          -> F35/F36/F37/F38 primitives
             -> F30 GF(2^8) multiply

F20/F39/F40-family:
  F20 outer producer
    -> F39 block adapter
    -> F40 block loop
       -> F42 scheduler
          -> F43/F44/F45/F46 primitives
           -> F30 GF(2^8) multiply

F21/F47/F48-family:
  F21 outer producer
    -> F47 block adapter
    -> F48 block loop
       -> F50 scheduler
          -> F51/F52/F53/F54 primitives
           -> F30 GF(2^8) multiply
```

旧报告里把 “当前 run 实际走 F20” 写得太绝对；多轮 source-work sweep 已显示
同一个固定请求可以走到四套 family：

也就是说，这里要按 family 形状识别，不要只记一个 `F20/F40/F42` 编号。
更详细的一一对照见：

```text
dyidre/versions/350101/source_work_family_compare_350101.md
dyidre/versions/350101/f18_f21_source_work_outer_compare_350101.md
```

## 关键映射

`CALL_CF_INDEX` 不是直接 CFxx 函数号。对这批 managed program：

```text
op5e handler: 0x1570DC
callee:       0x15AB1C
semantic:     program = (*(record.q1))[imm32]
```

当前 runtime 的已确认绑定：

```text
q1  = 0x125fd3c0
*q1 = 0x12608000

index 0x7d -> 0x127beb40 -> F22, code 0x125e1400..0x125e15e0
index 0x7e -> 0x127beb80 -> F23, code 0x1262e100..0x1262e748
index 0x7f -> 0x127bebc0 -> F31, code 0x125e1800..0x125e19e0
index 0x80 -> 0x127bec00 -> F32, code 0x1262e800..0x1262ee48
index 0x81 -> 0x127bec40 -> F39, code 0x125e1a00..0x125e1be0
index 0x82 -> 0x127bec80 -> F40, code 0x1262ef00..0x1262f548
index 0x83 -> 0x127becc0 -> F47, code 0x125e1c00..0x125e1de0
index 0x84 -> 0x127bed00 -> F48, code 0x1262f600..0x1262fc48
index 0x8b -> 0x127beec0 -> F30, code 0x125e2000..0x125e21f8
index 0x93 -> 0x128b70c0 -> F42, code 0x1260cb00..0x1260cf08
```

所以：

```text
F18 CALL_CF_INDEX 0x7d/0x7e == F22/F23 adapter + block loop
F19 CALL_CF_INDEX 0x7f/0x80 == F31/F32 adapter + block loop
F20 CALL_CF_INDEX 0x81/0x82 == F39/F40 adapter + block loop
F21 CALL_CF_INDEX 0x83/0x84 == F47/F48 adapter + block loop
F32 CALL_CF_INDEX 0x8d == F34-like scheduler
F40 CALL_CF_INDEX 0x93 == F42-like scheduler
F38/F46 CALL_CF_INDEX 0x8b == F30
```

注意：当前 `0x15AB1C` 动态 probe 只稳定抓到了 `idx=0x8b`，没有稳定抓到
`0x8d..0x91/0x93..0x97` scheduler-family 调用。因此 scheduler 绑定现在以
decoded asm + write timeline 为主，`idx=0x8b -> F30` 则有动态 call-cf
日志坐实。

## Program roles

| program | body/id | code | records | role |
|---|---:|---:|---:|---|
| `F18` | `0x1a0000126f0` | `0x72c000..0x730680` | 752 | observed source-work outer branch, F22/F23-family |
| `F19` | `0x1a00001497f` | `0x8af000..0x8b3200` | 704 | observed source-work outer producer, F31/F32-family |
| `F20` | `0x1a0000132b5` | `0x879000..0x87d200` | 704 | observed source-work outer producer, F39/F40-family |
| `F21` | `0x1a000013dba` | `0x8aa000..0x8ae680` | 752 | observed source-work outer branch, F47/F48-family |
| `F22` | `0x2000016019` | `0x5e1400..0x5e15e0` | 20 | F18-family block adapter |
| `F23` | `0x500001606d` | `0x62e100..0x62e748` | 67 | F18-family block loop |
| `F24` | `0x165a6` | `0x62fd00..0x630378` | 69 | F18-family key schedule / first-block pre-transform |
| `F25` | `0x30000166be` | `0x608500..0x608908` | 43 | F18-family round scheduler |
| `F26` | `0x1676d` | `0x606500..0x6067a0` | 28 | F18-family round-key XOR |
| `F27` | `0x167e0` | `0x5d8c80..0x5d8ef0` | 26 | F18-family S-box lookup + column rotation |
| `F28` | `0x1684b` | `0x5d8f00..0x5d9128` | 23 | F18-family fixed byte permutation |
| `F29` | `0x70000168ab` | `0x731000..0x731e70` | 154 | F18-family MixColumns-like transform |
| `F30` | `0x16b16` | `0x5e2000..0x5e21f8` | 21 | GF(2^8) multiply |
| `F31` | `0x200001617c` | `0x5e1800..0x5e19e0` | 20 | F19-family block adapter |
| `F32` | `0x50000161d0` | `0x62e800..0x62ee48` | 67 | 16-byte block loop, F32-family |
| `F33` | `0x16b6e` | `0x630400..0x630a78` | 69 | F19-family key schedule / first-block pre-transform |
| `F34` | `0x3000016c86` | `0x60c600..0x60ca08` | 43 | round scheduler, F32-family |
| `F35` | `0x16d35` | `0x606800..0x606aa0` | 28 | round-key XOR, F32-family |
| `F36` | `0x16da8` | `0x5d9180..0x5d93f0` | 26 | S-box lookup + column rotation, F32-family |
| `F37` | `0x16e13` | `0x5d9400..0x5d9658` | 25 | fixed byte permutation, F32-family |
| `F38` | `0x7000016e7b` | `0x7bf000..0x7bfe70` | 154 | MixColumns-like transform, F32-family |
| `F39` | `0x20000162df` | `0x5e1a00..0x5e1be0` | 20 | F20-family block adapter |
| `F40` | `0x5000016333` | `0x62ef00..0x62f548` | 67 | 16-byte block loop |
| `F41` | `0x170e7` | `0x630b00..0x631178` | 69 | F20-family key schedule / first-block pre-transform |
| `F42` | `0x30000171ff` | `0x60cb00..0x60cf08` | 43 | round scheduler |
| `F43` | `0x172ae` | `0x606b00..0x606da0` | 28 | round-key XOR |
| `F44` | `0x17321` | `0x5d9680..0x5d98f0` | 26 | S-box lookup + column rotation |
| `F45` | `0x1738c` | `0x5e2200..0x5e23f8` | 21 | fixed byte permutation |
| `F46` | `0x70000173e4` | `0x87e000..0x87ee70` | 154 | MixColumns-like transform |
| `F47` | `0x2000016442` | `0x5e1c00..0x5e1de0` | 20 | F21-family block adapter |
| `F48` | `0x5000016496` | `0x62f600..0x62fc48` | 67 | F21-family block loop |
| `F49` | `0x17650` | `0x631200..0x631848` | 67 | F21-family key schedule / first-block pre-transform，短变体 |
| `F50` | `0x3000017760` | `0x8b8000..0x8b8408` | 43 | F21-family round scheduler |
| `F51` | `0x1780f` | `0x606e00..0x6070a0` | 28 | F21-family round-key XOR |
| `F52` | `0x17882` | `0x5d9900..0x5d9b40` | 24 | F21-family S-box lookup + column rotation，短变体 |
| `F53` | `0x178e5` | `0x5d9b80..0x5d9da8` | 23 | F21-family fixed byte permutation |
| `F54` | `0x7000017945` | `0x87f000..0x87fe70` | 154 | F21-family MixColumns-like transform |

## Observed boundary

`CF07` first copies the pre-transform 31 bytes into source-work, then F20 pads
to 0x20 and nested transforms mutate it.

```text
pre-transform 31:
38 64 29 d4 8c c8 ad cd d1 44 d8 23 be 29 32 5e
b2 e5 0c c6 63 65 7d 5a 4c 85 fe eb fd ac a2

post-transform 32:
e6 40 ad 61 51 42 bb 3d 39 f4 fd 74 64 85 cc 03
14 54 d5 57 a8 0f 56 59 fe 8e 14 d3 68 55 0e 3b
```

The first 31 bytes of the post-transform buffer are the source stream consumed
by nested `F12`.

## F30

`F30` had one previously unknown instruction:

```text
op23 = SEXT8_SLOT
S[c] = (int64_t)(int8_t)(uint8_t)S[b]
```

With that fixed, `F30` is cleanly:

```c
uint8_t gf256_mul(uint8_t multiplier, uint8_t value) {
    uint8_t acc = 0;
    while (multiplier) {
        if (multiplier & 1) acc ^= value;
        value = (value & 0x80) ? (value << 1) ^ 0x1b : (value << 1);
        multiplier >>= 1;
    }
    return acc;
}
```

## F42/F46

`F42` schedules:

```text
F43(round=0)
F44
F45
F46
F43(round=1)
F44
F45
F43(round=2)
```

`F46` first reverses each 4-byte word into stack scratch, then applies a
MixColumns-like matrix using `F30`:

```text
row0 = 2 3 1 1
row1 = 1 2 3 1
row2 = 1 1 2 3
row3 = 3 1 1 2
```

This is AES-like in shape. Do not rename it to standard AES until the S-box and
key schedule source are both proven.

## F36/F44 static tables

F36/F44 的 S-box/table 已能从文件定位。访问链是：

```text
q1=0x125fd408
*q1=0x12614f80
*(0x12614f80 + 0x308) = module.base + 0x29f890

F36 table = module.base + 0x29f890 + 0x484 = VA 0x29fd14
F44 table = module.base + 0x29f890 + 0x585 = VA 0x29fe15
```

两个 0x100-byte 窗口都是 256-byte permutation。详细 hash/first64 见：

```text
dyidre/versions/350101/source_work_static_tables_350101.md
```

## Artifacts

```text
timelines:
dyidre/versions/350101/f19_f32_source_work_timeline_350101.md
dyidre/versions/350101/f20_f40_source_work_timeline_350101.md

C skeleton:
dyidre/versions/350101/f20_f21_medusa_source_transform_recovered.c

decode:
dyidre/versions/350101/managed_vm_decode_f19/
dyidre/versions/350101/managed_vm_decode_f32_family/
dyidre/versions/350101/managed_vm_decode_f20_f40_f43_46/
dyidre/versions/350101/managed_vm_decode_f30_f42/

static tables:
dyidre/versions/350101/source_work_static_tables_350101.md

binding proof:
unidbg/unidbg-android/target/sign6_350101_binding_idx_20260831_044207.log
```

## Next

1. source-work 四族端到端向量已收齐：
   `source_work_vectors_350101.md`。
2. C lift 已通过四族 byte-exact selfcheck：
   `source_work_vector_selfcheck_350101.c`，当前 `failures=0`。
3. 下一步转向 `CF61 -> 0x16D86C` digest compression 和 F8 binary pack 字段命名。

# 350.101 source-work key schedule / first-block pre-transform family

这份记录只看 `F24/F33/F41/F49`。它们是 source-work outer 的 adapter
第一跳，作用是准备 family-specific key/work area，然后 block loop 才开始处理
两个 16-byte block。

## 入口关系

| outer | adapter | first call | key/pre-transform program |
|---|---|---|---|
| `F18` | `F22` | `CALL_CF_INDEX 0x85` | `F24` |
| `F19` | `F31` | `CALL_CF_INDEX 0x8c` | `F33` |
| `F20` | `F39` | `CALL_CF_INDEX 0x92` | `F41` |
| `F21` | `F47` | `CALL_CF_INDEX 0x98` | `F49` |

## family constants

| program | records | initial xor bytes | const32 used by `op 0x0d` | table source |
|---|---:|---|---:|---|
| `F24` | 69 | `72 de b5 bb` | `0xbbb5de72` | `*(pool+0x308)+0x33a` |
| `F33` | 69 | `5b 8d 63 d4` | `0xd4638d5b` | `*(pool+0x308)+0x484` |
| `F41` | 69 | `3b f7 a5 92` | `0x92a5f73b` | `*(pool+0x308)+0x585` |
| `F49` | 67 | `c9 a1 f8 89` | `0x89f8a1c9` | `pool+0x171` |

`F24/F33/F41` 是 69-record 同形程序；`F49` 是 67-record 短变体。
主要差异不是大结构，而是：

- 初始 4-byte xor 常量不同；
- `F24/F33/F41` 共用二级表基址，但窗口分别为 `+0x33a/+0x484/+0x585`；
- `F49` 不走二级指针，直接取 runtime pool 的 `+0x171` 窗口；
- `F49` 少了 `LD_POOL_PTR + LD64` 的开头两条同形准备，改在中段直接取表。

## `op 0x0d`

本轮把 managed bytecode decoder 里的 `op 0x0d` 补成：

```c
dst = (uint8_t)((uint32_t)const32 >> (shift & 31));
```

在这些程序里，形态固定是：

```text
s8 = s4 & 0x18
s9 = sbox[...]
s8 = BYTE_FROM_U32_SHIFT(s7, s8)
s8 ^= s9
```

也就是按 `0/8/16/24` 从 32-bit family 常量里抽一个 byte，再和 S-box
结果混合。这个和 native VMP 的同号 opcode 不是一回事。

## byte-exact C 形状

四个程序现在已统一为一个参数化实现：

```c
void expand_round_keys_family(uint8_t work[48],
                              const uint8_t src[16],
                              const uint8_t sbox[256],
                              uint32_t family_const)
{
    uint8_t k[4] = {
        family_const, family_const >> 8,
        family_const >> 16, family_const >> 24
    };

    for (int i = 0; i != 16; i++)
        work[i] = src[i] ^ k[i & 3];

    for (int word = 4; word != 12; word++) {
        uint8_t t[4] = {
            work[(word - 1) * 4 + 0], work[(word - 1) * 4 + 1],
            work[(word - 1) * 4 + 2], work[(word - 1) * 4 + 3]
        };

        if ((word & 3) == 0) {
            uint8_t old0 = t[0];
            t[0] = sbox[t[1]] ^ k[word >> 2];
            t[1] = sbox[t[2]];
            t[2] = sbox[t[3]];
            t[3] = sbox[old0];
        }

        for (int byte = 0; byte != 4; byte++)
            work[word * 4 + byte] =
                work[(word - 4) * 4 + byte] ^ t[byte];
    }
}
```

`word=4/8` 时分别抽 `family_const >> 8/16`，这正好对应 bytecode 中
`s4=8` 起步、每个 word 加 2、再由 `s4 & 0x18` 选择 byte 的控制流。

实际实现见：

```text
dyidre/versions/350101/f20_f21_medusa_source_transform_recovered.c
```

## 解码产物

```text
dyidre/versions/350101/managed_vm_decode_roundfamilies_350101/F24_350101_F24_0x62fd00_0x678.decoded.asm
dyidre/versions/350101/managed_vm_decode_roundfamilies_350101/F33_350101_F33_0x630400_0x678.decoded.asm
dyidre/versions/350101/managed_vm_decode_roundfamilies_350101/F41_350101_F41_0x630b00_0x678.decoded.asm
dyidre/versions/350101/managed_vm_decode_roundfamilies_350101/F49_350101_F49_0x631200_0x648.decoded.asm
```

四个程序当前都是 `unknown=0`。

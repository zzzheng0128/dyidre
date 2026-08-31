# 350.101 source-work static table windows

这份记录 F24/F27、F33/F36、F41/F44 的 S-box/table 来源。结论：表不是本轮运行时堆里临时生成的；
它来自 `libmetasec_ml.so` 文件内的静态数据窗口。

## 访问链

这些 key-expansion / substitution 程序都是这个形状：

```text
LD_POOL_PTR
LD64
ADD64_IMM16
LD8U table[index]
```

具体到当前 350.101：

```text
F24/F27:
  q1 = 0x125fd408
  *q1 = 0x12614f80
  *(0x12614f80 + 0x308) = 0x1229f890
  table = 0x1229f890 + 0x33a = module.base + 0x29fbca

F36:
  q1 = 0x125fd408
  *q1 = 0x12614f80
  *(0x12614f80 + 0x308) = 0x1229f890
  table = 0x1229f890 + 0x484 = module.base + 0x29fd14

F44:
  q1 = 0x125fd408
  *q1 = 0x12614f80
  *(0x12614f80 + 0x308) = 0x1229f890
  table = 0x1229f890 + 0x585 = module.base + 0x29fe15

F49/F52:
  q1 = 0x125fd408
  *q1 = 0x12614f80
  table = 0x12614f80 + 0x171 = 0x126150f1
```

`module.base` 在 unidbg run 中是 `0x12000000`，所以文件 VA 可以直接对齐到
`0x29f890` 这片数据。

## ELF 文件定位

SO：

```text
douyin_35_0_0/libmetasec_ml.so
```

| name | VA | file offset | sha256(first 0x100) | unique | perm256 | first64 |
|---|---:|---:|---|---:|---|---|
| table base | `0x29f890` | `0x29e890` | `fc7234b4702056e72d52693d15d7656000f82af72203e2076a18536a2f8b77f9` | 63 | no | `5b 24 09 a0 76 6d 70 00 cc b4 92 5b 2f 63 61 63 68 65 2f 36 37 32 36 30 2f 4d 65 74 61 53 65 63 53 44 4b 5f 4d 4c 2f 6d 6f 64 75 6c 65 2f 68 74 74 70 5f 72 65 71 75 65 73 74 5f 73 69 67 6e 2f` |
| F24/F27 table | `0x29fbca` | `0x29ebca` | `889cf0adbe6cae808b34a33ac85c9ecc73dd48a15af31df01b23f09a9feaaada` | 256 | yes | `53 29 0f e9 e5 1f 31 6f 90 f7 4a 7e 03 4d 36 77 84 ab 49 23 7c d0 13 5c dc 63 2c 32 2f d3 be 0e 26 24 a4 17 ec d9 15 1a 7f f6 4f 60 73 0a 87 f9 44 5e c6 ad a2 f8 65 d2 2b 69 6c 41 88 f2 4c 0d` |
| F33/F36 table | `0x29fd14` | `0x29ed14` | `5c3c71fa194c289c2ec0c77b5bc8f5fa38f2b2a11f4e8a27b34e1e4f625f9a89` | 256 | yes | `38 92 25 63 e3 64 06 d3 7a 24 10 0b 79 02 a0 28 04 4e 21 84 53 c2 a3 99 19 9c 9d 13 dc 40 c5 5b a6 7e 50 22 73 85 0e bd c1 a2 e2 18 8b 8f 2d 9e 3c b9 09 b8 c4 6a 2a 9f 4a 6d d9 30 07 ea fa 65` |
| F41/F44 table | `0x29fe15` | `0x29ee15` | `0d2fc76c086837c8b40e55ed18e82f811c378ed4917a24098bdf37555080836d` | 256 | yes | `d7 59 fb 72 27 89 b0 88 07 cc 0f da 29 3f 7e 5e 18 19 bb 03 53 51 70 20 b3 1d 3d 00 37 49 52 be a2 c4 21 e8 62 04 0a 9e c8 92 a0 5b 26 6b 7a 0d 0c c3 16 f4 83 b8 1a f3 97 15 65 7f fe 32 ad 8d` |

Runtime-only F21/F47/F48 table:

| name | runtime VA | source | fnv1a(first 0x100) | unique | perm256 | first64 |
|---|---:|---|---|---:|---|---|
| F49/F52 table | `0x126150f1` | `*(0x125fd408)+0x171` | `6d368061` | 256 | yes | `d0 9a 51 5b a5 8c bb ab 3e 37 b0 9f d4 f6 d9 24 4d f8 05 12 e8 4c d7 95 6b e3 01 cf 64 f1 42 9d 58 57 7c c2 41 f3 a2 c6 55 14 4f 81 aa f9 5a 4e 10 8d a8 94 b3 89 70 56 1a e9 00 26 19 fb ba c9` |

## 含义

- 前三个 family 不共用同一个 256-byte S-box 窗口；它们从同一个二级表基址
  `0x1229f890` 派生，偏移分别是 `+0x33a/+0x484/+0x585`。
- F21/F47/F48 使用 `runtime_pool+0x171`，同样是 256-byte permutation，但不在
  `module.base+0x29f890` 这个静态二级表窗口里。
- 三个窗口本身都是 0..255 的 permutation；同 family 的 key expansion 与
  substitution primitive 共用窗口：`F24/F27`、`F33/F36`、`F41/F44`。
- 这解释了为什么三套 decoded asm 形状相近但不能合并成无参数函数：表窗口、
  family constant 和列写回顺序都不同。

## 升级识别

新版本里优先找这个模式：

```text
26-record S-box primitive
  LD_POOL_PTR q1/imm
  LD64 secondary pointer
  ADD64_IMM16 table offset around a few hundred bytes
  four LD8U table lookups per column
  four ST8 writes per column
```

如果表仍是 256-byte permutation，就把 VA/file offset/hash 记录下来，再接
source-work byte-exact 复现。

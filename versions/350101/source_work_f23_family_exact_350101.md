# 350.101 F18..F21 source-work 四族 byte-exact lift

这份记录最初把 `F23` 从机械 `linear.c` 提升成可读的 family-A 实现；现在同一工作
已经扩展到 `F32/F40/F48`，四组 adapter、key expansion、block loop、scheduler 和
round primitive 都已串成可编译的 C 调用链。

对应实现：

```text
dyidre/versions/350101/f20_f21_medusa_source_transform_recovered.c
```

## F23 真实 ABI

入口 slot：

```text
s4 = key_area
s5 = data buffer
s6 = byte length（不是 end 指针）
```

核心逻辑：

```c
for (size_t off = 0; off < length; off += 16) {
    block = data + off;
    block[0..15] ^= key_area[0xb0..0xbf];
    F25(block, key_area);
    block[0..15] ^= key_area[0x10..0x1f];
}

if (length != 0)
    key_area[0xb0..0xbf] = last_block[0..15];
```

旧骨架把 `s6` 写成 `end` 指针是不对的；机械 lift 的比较是
`offset < s6`，而且 offset 每次加 `0x10`。

## F22 / F24：准备 0x30 字节 round-key 区

`F22` 先调用 `F24(s4=key_area,s5=source_key)`，再通过 CF index `0x36`
把 16-byte IV 拷贝到 `key_area+0xb0`。

`F24`：

1. 前 16 字节：`source_key ^ {72 de b5 bb}`，4-byte 常量循环使用；
2. 把 4 个初始 word 扩成 12 个 word，共 `0x30` 字节；
3. `word=4/8` 时执行 `RotWord + table substitution`；
4. round constant 分别是 `0xde/0xb5`，来自 `0xbbb5de72 >> 8/16`；
5. substitution table 是二级静态表 `*(pool+0x308)+0x33a`。

同一个精确模板也适用于：

| program | family const | table |
|---|---:|---|
| F24 | `0xbbb5de72` | `*(pool+0x308)+0x33a` |
| F33 | `0xd4638d5b` | `*(pool+0x308)+0x484` |
| F41 | `0x92a5f73b` | `*(pool+0x308)+0x585` |
| F49 | `0x89f8a1c9` | `pool+0x171` |

其中 F41 已用本轮 unidbg 实跑数据验证。入口 source key：

```text
f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4
```

使用 SO 内 `module.base+0x29fe15`（二级基址 `+0x585`）后，C lift 得到的
48-byte key area 与 F42 入口 dump 完全一致：

```text
ca ae 96 e4 4d 99 0c 1f 0f 04 be 97 41 6a fe 76
5e 4a 47 25 13 d3 4b 3a 1c d7 f5 ad 5d bd 0b db
27 90 08 4a 34 43 43 70 28 94 b6 dd 75 29 bd 06
```

## F25 scheduler

F25 的 43 records 可直接结构化为：

```text
F26(round=0)
F27
F28
F29
F26(round=1)
F27
F28
F26(round=2)
```

这是一套两轮 AES-like SPN：第一轮含 MixColumns-like，最后一轮省略该步骤。
这里仍叫 AES-like，因为 substitution table、初始字节布局和 round-key 字节排列
都是 MetaSec 自定义的。

另外三组 scheduler 已按完全相同的控制流恢复：

```text
F34: F35(0) -> F36 -> F37 -> F38 -> F35(1) -> F36 -> F37 -> F35(2)
F42: F43(0) -> F44 -> F45 -> F46 -> F43(1) -> F44 -> F45 -> F43(2)
F50: F51(0) -> F52 -> F53 -> F54 -> F51(1) -> F52 -> F53 -> F51(2)
```

`F32/F40/F48` 与 F23 的 ABI 和 block loop 完全同形：`s4=key_area`、
`s5=data`、`s6=byte length`。`F31/F39/F47` 也与 F22 同形：先扩展 48-byte
round key，再把 `s6` 指向的 16-byte IV 复制到 `key_area+0xb0`。

## F26 / F27 / F28

`F26` 每 4 字节的 round-key 映射：

```text
block[1] ^= key[0]
block[3] ^= key[1]
block[0] ^= key[2]
block[2] ^= key[3]
```

`F27` 对 4 条 lane 做 table substitution 后写回：

```text
new[i+0x0] = S[old[i+0x8]]
new[i+0x4] = S[old[i+0x0]]
new[i+0x8] = S[old[i+0xc]]
new[i+0xc] = S[old[i+0x4]]
```

`F28` 是固定置换；写入的目标 offset 为：

```text
1,9,5,13,2,14,10,6,15,11,3
```

未写 offset `0/4/7/8/12` 保持原值。

## F29 / F30

`F30` 是 GF(2^8) 乘法：

```text
s4 = multiplier
s5 = value
s2 = product
reduction polynomial low byte = 0x1b
```

`F29/F38/F46/F54` 后 124 records 是同一套矩阵，差异集中在前 30 records
把每个 4-byte group 放入 scratch 的顺序：

| program | scratch `t[0..3]` 来源 |
|---|---|
| F29 | `b2,b0,b3,b1` |
| F38 | `b1,b3,b2,b0` |
| F46 | `b3,b2,b1,b0` |
| F54 | `b2,b3,b1,b0` |

随后对 stride-4 的 `a=t[col]、b=t[col+4]、c=t[col+8]、d=t[col+12]`
应用：

```text
o0 = 2a ^ 3b ^ 1c ^ 1d
o1 = 1a ^ 2b ^ 3c ^ 1d
o2 = 1a ^ 1b ^ 2c ^ 3d
o3 = 3a ^ 1b ^ 1c ^ 2d
```

因此这四个 154-record 程序现在不再只是 `mixcolumns-like` 占位；其矩阵和
family-specific scratch swizzle 都已经落入 C。

## 当前边界

静态 lifting 已经 byte-exact 覆盖四族内部链；动态上已经收齐四条路径的
`source_key + IV + 输入32字节 + 输出32字节` runtime vectors：

```text
dyidre/versions/350101/source_work_vectors_350101.md
```

其中最关键的修正是 block loop 的链值更新：`key_area+0xb0` 不是等整个
loop 结束才写，而是每处理完一个 16-byte block 就立刻写回，下一块使用上一块
输出作为链值。这个行为已经通过四族回归测试验证：

```bash
clang -std=c11 -Wall -Wextra -Werror \
  dyidre/versions/350101/source_work_vector_selfcheck_350101.c \
  -o /tmp/metasec_sourcework_selfcheck_350101
/tmp/metasec_sourcework_selfcheck_350101
# failures=0
```

因此 `F22/F23`、`F31/F32`、`F39/F40`、`F47/F48` 的 adapter + block loop
已经可以视为当前 350.101 的字节级还原完成。仍保留 `AES-like SPN` 命名，是因为
substitution table、round-key 字节排列、MixColumns scratch swizzle 都是
MetaSec 自定义，并不是标准 AES。

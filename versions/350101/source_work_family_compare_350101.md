# 350.101 X-Medusa source-work VM family compare

这份记录专门回答一个坑：`F12` 消费的 31-byte source stream，上游并不只有
`F20 -> F40 -> F42 -> F43/F44/F45/F46` 一条路。多轮 unidbg source-work
sweep 证明这里有四套实跑 managed program family，run-to-run 会切换。

另外，绑定表又补出了一层之前漏掉的小 adapter：outer producer 的两处
family-specific `CALL_CF_INDEX` 其实是 `20-record adapter + 67-record block
loop`。所以准确叫法应该是 `F18/F22/F23-family`、`F19/F31/F32-family`、
`F20/F39/F40-family`、`F21/F47/F48-family`，而不是只写 `F19/F32`、
`F20/F40`。

所以后续升级版本时，不要只按 `F20/F40/F42` 这些编号找；要按“程序形状 +
write timeline + CALL_CF_INDEX 绑定”去识别。

## 证据输入

| run | log | timeline | 结果 |
|---|---|---|---|
| F19/F31/F32-family | `unidbg/unidbg-android/target/sign6_350101_sourcework_callcf_20260831_045638.log` | `f19_f32_source_work_timeline_350101.md` | 走 `F19 -> F31/F32 -> F35/F36/F37/F38` |
| F20/F39/F40-family | `unidbg/unidbg-android/target/sign6_350101_callcf_f32family_20260831_045900.log` | `f20_f40_source_work_timeline_350101.md` | 走 `F20 -> F39/F40 -> F43/F44/F45/F46` |

对应 bytecode decode：

```text
dyidre/versions/350101/managed_vm_decode_f19/
dyidre/versions/350101/managed_vm_decode_f32_family/
dyidre/versions/350101/managed_vm_decode_f20_f40_f43_46/
dyidre/versions/350101/managed_vm_decode_f30_f42/
```

## 两套已实跑 family 对齐

| 角色 | F19/F31/F32-family | F20/F39/F40-family | 识别特征 |
|---|---:|---:|---|
| outer source-work producer | `F19` / `0x1a00001497f` | `F20` / `0x1a0000132b5` | 704 records；负责 31-byte input + `0x01` padding，尾部写 MEM_BLOCK metadata |
| block adapter | `F31` / `0x200001617c` | `F39` / `0x20000162df` | 20 records；outer 第一处 family-specific call；与 `F22/F47` 同形 |
| 16-byte block loop | `F32` / `0x50000161d0` | `F40` / `0x5000016333` | 67 records；pre-xor `key_area+0xb0`，调用 scheduler，再 post-xor `key_area+0x10` |
| round scheduler | `F34` / `0x3000016c86` | `F42` / `0x30000171ff` | 43 records；调用 4 个 round primitive，最后一轮少 MixColumns |
| round-key XOR | `F35` / `0x16d35` | `F43` / `0x172ae` | 28 records；每 4-byte chunk 做 key xor，但两个 family 的 byte swizzle 不完全相同 |
| S-box/column rotate | `F36` / `0x16da8` | `F44` / `0x17321` | 26 records；`LD_POOL_PTR -> LD64 -> sbox + offset`，再 4 列替换/旋转 |
| fixed permutation | `F37` / `0x16e13` | `F45` / `0x1738c` | F37 是 25 records/12 writes；F45 是 21 records/10 writes |
| MixColumns-like | `F38` / `0x7000016e7b` | `F46` / `0x70000173e4` | 154 records；内部多次 `CALL_CF_INDEX 0x8b -> F30` |
| GF multiply | `F30` / `0x16b16` | `F30` / `0x16b16` | 共用；GF(2^8) multiply，reduction polynomial `0x1b` |

外层 `F19/F20` 的 opcode/mnemonic 序列是 704/704 全一致，说明 `F19`
不是一个零散分支，而是和 `F20` 同模板的 outer producer。

两者的 `CALL_CF_INDEX` 序列也只有两处 family-specific index 不同：

```text
F19: 0x23, 0x7f, 0x65, 0x36, 0x48, 0x80, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
F20: 0x23, 0x81, 0x65, 0x36, 0x48, 0x82, 0x47, 0x24, 0x66, 0x48, 0x48, 0x07
```

## timeline 形状

两套 family 的 timeline 几乎同构：

```text
outer: pad byte at +0x1f
loop:  first 16-byte block
xor
sbox/rotate
permute
mixcolumns
xor
sbox/rotate
permute
xor
loop:  both 16-byte blocks
xor/sbox/permute/mixcolumns/xor/sbox/permute/xor on block1
loop:  final block update
outer: write metadata
native/MEM_BLOCK metadata writes
```

差异主要是 family-specific primitive：

```text
F19/F31/F32-family:
  permutation writes = 12
  observed final prefix =
    95 2f b8 ba 91 da 31 4f e6 d0 bc 7f 00 22 a8 55
    4d 2c 8a 09 34 5e 80 8e 5a a4 13 0a da 0d 33 bb

F20/F39/F40-family:
  permutation writes = 10
  observed final prefix =
    0c 45 03 81 b2 4d ef 27 e7 a2 42 94 94 84 70 2f
    88 ff 7c d4 f8 1b c6 e1 8e 72 cf 6c f6 df 2b 81
```

注意：这两个 final prefix 是两次不同运行的观测值，不应该互相比较成“算法输出
不同”。它们证明的是：相同业务点可以选择不同 managed program family。

## CALL_CF_INDEX 绑定要点

bytecode decode 能看到 scheduler 调用：

```text
F19 CALL_CF_INDEX 0x7f -> F31 block adapter
F19 CALL_CF_INDEX 0x80 -> F32 block loop
F32 CALL_CF_INDEX 0x8d -> F34-like scheduler
F34 CALL_CF_INDEX 0x8e/0x8f/0x90/0x91 -> F35/F36/F37/F38-like primitives

F20 CALL_CF_INDEX 0x81 -> F39 block adapter
F20 CALL_CF_INDEX 0x82 -> F40 block loop
F40 CALL_CF_INDEX 0x93 -> F42-like scheduler
F42 CALL_CF_INDEX 0x94/0x95/0x96/0x97 -> F43/F44/F45/F46-like primitives

F38/F46 CALL_CF_INDEX 0x8b -> F30 GF multiply
```

另外两套也已经在 source-work sweep 里跑到：

```text
F18 CALL_CF_INDEX 0x7d -> F22 block adapter
F18 CALL_CF_INDEX 0x7e -> F23 block loop
F21 CALL_CF_INDEX 0x83 -> F47 block adapter
F21 CALL_CF_INDEX 0x84 -> F48 block loop
```

完整 outer / adapter / round family 图谱见：

```text
dyidre/versions/350101/f18_f21_source_work_outer_compare_350101.md
dyidre/versions/350101/source_work_round_family_graph_350101.md
```

但当前 `0x15AB1C` call-cf probe 运行时只稳定抓到了 `idx=0x8b` 的 F30
调用，没有抓到 scheduler 那一层的 `0x8d..0x91/0x93..0x97`。因此这一层
不要只靠 `0x15AB1C` 动态 hook 下结论；要同时用：

1. decoded asm 里的 `CALL_CF_INDEX`；
2. `f21-source-work` write timeline 的 `interp0` 切换；
3. program dump 的 body/id、code range、record count。

我倾向把这理解成：某些 nested managed 调用不是从我们当前 hook 的 helper
入口经过，或者被 wrapper/inline 路径绕开了；而 F30 乘法路径会稳定落到
`0x15AB1C`。

## 升级版本识别流程

新版本对齐时按这个顺序，不要先猜名字：

1. 先 dump sign module 的 `F*` program descriptor，找 record count：
   - 20 records 的 block adapter；
   - 67 records 的 block loop；
   - 43 records 的 scheduler；
   - 28/26/21~25/154 records 的四个 primitive；
   - 21 records 的 GF multiply。
2. decode 这批 program，检查 opcode/mnemonic 形状：
   - block loop 是否有两段 16-byte XOR 和一个 `CALL_CF_INDEX`；
   - scheduler 是否是 `xor -> sbox -> perm -> mix -> xor -> sbox -> perm -> xor`；
   - MixColumns-like 是否多次调用同一个 GF multiply index。
3. 跑 `watchF21SourceWorkAreas=true`，按 `interp0` timeline 确认实际 run
   走哪一套 family。
4. 最后再回填 IDA 名字：
   - `managedSourceWorkOuter_*`
   - `managedSourceWorkBlockLoop_*`
   - `managedSourceWorkRoundScheduler_*`
   - `managedSourceWorkRoundXor_*`
   - `managedSourceWorkSboxRotate_*`
   - `managedSourceWorkPermute_*`
   - `managedSourceWorkMixColumnsLike_*`
   - `managedGf256Mul_*`

命名时保留 family/version 后缀，别把某一版的 `F40` 写死成业务唯一真名。

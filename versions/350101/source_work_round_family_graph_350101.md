# 350.101 source-work round family graph

这份记录把 `F12/X-Medusa` 上游 source-work 的 managed VM 家族补成完整图。

上一版只确认了 `F19/F31/F32`、`F20/F39/F40` 两条实跑路经；本轮把
adapter、block loop、scheduler、round primitive 也单独 dump/decode 了。
现在可以按“形状”而不是按某个 F 编号去升级新版本。

## 结论图

```text
F18 outer, 752 records
  -> F22 adapter, 20 records
       -> F24 key schedule / first-block pre-transform, 69 records
       -> CF index 0x36
  -> F23 16-byte block loop, 67 records
       -> F25 round scheduler, 43 records
            -> F26 round-key xor, 28 records
            -> F27 sbox/rotate, 26 records
            -> F28 fixed permutation, 23 records
            -> F29 mixcolumns-like, 154 records
                 -> F30 GF(2^8) multiply, 21 records

F19 outer, 704 records
  -> F31 adapter, 20 records
       -> F33 key schedule / first-block pre-transform, 69 records
       -> CF index 0x36
  -> F32 16-byte block loop, 67 records
       -> F34 round scheduler, 43 records
            -> F35 round-key xor, 28 records
            -> F36 sbox/rotate, 26 records
            -> F37 fixed permutation, 25 records
            -> F38 mixcolumns-like, 154 records
                 -> F30 GF(2^8) multiply, 21 records

F20 outer, 704 records
  -> F39 adapter, 20 records
       -> F41 key schedule / first-block pre-transform, 69 records
       -> CF index 0x36
  -> F40 16-byte block loop, 67 records
       -> F42 round scheduler, 43 records
            -> F43 round-key xor, 28 records
            -> F44 sbox/rotate, 26 records
            -> F45 fixed permutation, 21 records
            -> F46 mixcolumns-like, 154 records
                 -> F30 GF(2^8) multiply, 21 records

F21 outer, 752 records
  -> F47 adapter, 20 records
       -> F49 key schedule / first-block pre-transform, 67 records
       -> CF index 0x36
  -> F48 16-byte block loop, 67 records
       -> F50 round scheduler, 43 records
            -> F51 round-key xor, 28 records
            -> F52 sbox/rotate, 24 records
            -> F53 fixed permutation, 23 records
            -> F54 mixcolumns-like, 154 records
                 -> F30 GF(2^8) multiply, 21 records
```

四套 family 都已经在 350.101 source-work sweep 中实跑到，并收齐
adapter/block-loop runtime vectors。固定请求每次可能选择不同 family，所以
不要把某一次只看到的 Fxx 当成唯一分支。

## 绑定表 index

`CALL_CF_INDEX` 由 managed record 的 `q1` 绑定表解析：

```text
q1  = 0x125fd3c0
*q1 = 0x12608000
```

关键 index：

| index | F 程序 | records | 角色 |
|---:|---|---:|---|
| `0x7d` | `F22` | 20 | F18 adapter |
| `0x7e` | `F23` | 67 | F18 block loop |
| `0x7f` | `F31` | 20 | F19 adapter |
| `0x80` | `F32` | 67 | F19 block loop |
| `0x81` | `F39` | 20 | F20 adapter |
| `0x82` | `F40` | 67 | F20 block loop |
| `0x83` | `F47` | 20 | F21 adapter |
| `0x84` | `F48` | 67 | F21 block loop |
| `0x85` | `F24` | 69 | F18 key schedule / first-block pre-transform |
| `0x86` | `F25` | 43 | F18 scheduler |
| `0x87..0x8a` | `F26..F29` | 28/26/23/154 | F18 round primitives |
| `0x8b` | `F30` | 21 | shared GF multiply |
| `0x8c` | `F33` | 69 | F19 key schedule / first-block pre-transform |
| `0x8d` | `F34` | 43 | F19 scheduler |
| `0x8e..0x91` | `F35..F38` | 28/26/25/154 | F19 round primitives |
| `0x92` | `F41` | 69 | F20 key schedule / first-block pre-transform |
| `0x93` | `F42` | 43 | F20 scheduler |
| `0x94..0x97` | `F43..F46` | 28/26/21/154 | F20 round primitives |
| `0x98` | `F49` | 67 | F21 key schedule / first-block pre-transform |
| `0x99` | `F50` | 43 | F21 scheduler |
| `0x9a..0x9d` | `F51..F54` | 28/24/23/154 | F21 round primitives |

## 程序形状

### 20-record adapter：F22/F31/F39/F47

四个 adapter 的 opcode/mnemonic 序列完全一致，只替换两个 call index：

| adapter | calls |
|---|---|
| `F22` | `0x85 -> F24`, `0x36` |
| `F31` | `0x8c -> F33`, `0x36` |
| `F39` | `0x92 -> F41`, `0x36` |
| `F47` | `0x98 -> F49`, `0x36` |

作用：把 outer 准备好的输入窗口/工作区传给 family-specific 预处理程序，再调用
公共 helper `0x36` 做收尾/搬运。

### key schedule / first-block pre-transform：F24/F33/F41/F49

`F24/F33/F41` 是 69 records 同形；`F49` 是 67 records 的短变体。

共同特征：

- 先对 16 字节做 family-specific 常量 XOR；
- 再从静态表 `LD_POOL_PTR + 0x308` 或 `+0x171` 取 S-box/permutation table；
- 每 4-byte word 做 `S-box lookup -> byte extraction from 32-bit const -> XOR`
  的 key-schedule-like 变换；
- `op 0x0d` 已恢复为 `BYTE_FROM_U32_SHIFT`：

```c
dst = (uint8_t)((uint32_t)const32 >> (shift & 31));
```

在这组程序里，它用于从 `s7` 的 32-bit family 常量里按 `s4 & 0x18`
抽取一个 byte，再和 S-box 输出混合。

### 67-record block loop：F23/F32/F40/F48

四个 block loop 的 opcode/mnemonic 序列完全一致，只替换 scheduler index：

| block loop | scheduler |
|---|---|
| `F23` | `0x86 -> F25` |
| `F32` | `0x8d -> F34` |
| `F40` | `0x93 -> F42` |
| `F48` | `0x99 -> F50` |

行为：

```text
for each 16-byte block:
  block ^= key_area + 0xb0
  call family scheduler
  block ^= key_area + 0x10
  copy current output block back into key_area + 0xb0
```

这解释了为什么 trace 里 `F12` source-work 前面会先出现两个 16-byte 区块的
反复 XOR / S-box / permutation 写入。

### 43-record scheduler：F25/F34/F42/F50

四个 scheduler 的 opcode/mnemonic 序列完全一致，只替换 primitive index。

| scheduler | calls |
|---|---|
| `F25` | `F26(0), F27, F28, F29, F26(1), F27, F28, F26(2)` |
| `F34` | `F35(0), F36, F37, F38, F35(1), F36, F37, F35(2)` |
| `F42` | `F43(0), F44, F45, F46, F43(1), F44, F45, F43(2)` |
| `F50` | `F51(0), F52, F53, F54, F51(1), F52, F53, F51(2)` |

抽象形态：

```text
round-key xor (round 0)
sbox/rotate + fixed permutation + mixcolumns-like
round-key xor (round 1)
sbox/rotate + fixed permutation
round-key xor (round 2)
```

最后两次 xor 表示最后阶段没有再进入 MixColumns-like，这是 AES-like 结构里很常见
的形状，但这里先只叫 `AES-like`，不要直接命名成标准 AES。

### round primitives

| 角色 | family A | family B | family C | family D | 形状 |
|---|---|---|---|---|---|
| round-key xor | `F26` | `F35` | `F43` | `F51` | 28 records，同形 |
| sbox/rotate | `F27` | `F36` | `F44` | `F52` | 26/26/26/24 records；F52 是短变体 |
| fixed permutation | `F28` | `F37` | `F45` | `F53` | 23/25/21/23 records；write 个数不同 |
| mixcolumns-like | `F29` | `F38` | `F46` | `F54` | 154 records，同形，内部 16 次调用 `F30` |
| GF multiply | `F30` | `F30` | `F30` | `F30` | 21 records，共用，reduction polynomial `0x1b` |

`F29/F38/F46/F54` 的矩阵已经恢复为 GF(2^8) 上的固定
`{2,3,1,1}` 循环矩阵；四者的差异只在输入每 4 字节进入 scratch 的顺序：

```text
F29: b2,b0,b3,b1
F38: b1,b3,b2,b0
F46: b3,b2,b1,b0
F54: b2,b3,b1,b0
```

`F23` 也已确认 `s6` 是 byte length 而不是 end pointer。family-A 的
`F22/F24/F23/F25/F26/F27/F28/F29/F30` byte-exact lift 见：

```text
dyidre/versions/350101/source_work_f23_family_exact_350101.md
```

## 新增 dump / decode 产物

adapter/body dump：

```text
unidbg/unidbg-android/target/managed_program_adapters_350101_20260831_053000
dyidre/versions/350101/managed_vm_decode_adapters_350101
```

round-family dump：

```text
unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127
dyidre/versions/350101/managed_vm_decode_roundfamilies_350101
```

F50/F51/F52/F53/F54 绑定表补证：

```text
unidbg/unidbg-android/target/managed_program_f50_table_350101_20260831_053202
```

两批 decode 当前都是 `unknown=0`。`op 0x0d` 的补丁已经回写到
`metasec-so-recognizer` skill 的 managed VM decoder。

`F24/F33/F41/F49` 的 family-specific 常量和 key-schedule-like 形状单独见：

```text
dyidre/versions/350101/source_work_key_schedule_family_350101.md
```

## 升级版本识别规则

新版本不要先找具体 `F40` 或 `F42`，先找这一组形状：

1. outer：704 或 752 records，`CALL_CF_INDEX` 骨架里有
   `adapter + block loop` 两个 family-specific index；
2. adapter：20 records，两个 call，其中第一个指向 67/69-record 预处理；
3. block loop：67 records，一次 scheduler call，前后各一段 16-byte XOR；
4. scheduler：43 records，6 次 call；
5. primitives：28 / 24~26 / 21~25 / 154 records；
6. shared GF multiply：21 records，含 `0x1b` reduction。

这套规则比 F 编号更耐升级，因为 F 编号和注册顺序可能换，但 VM program 形状和
调用拓扑不太容易同时全换。

# 350.101 `X-*` header 算法还原状态

这份文档按最终 header 口径重新整理，而不是只列 CF/F 原语。

## 已落成 C 的部分

代码入口：

```text
dyidre/versions/350101/x_headers_algorithms_350101.c
dyidre/versions/350101/metasec_350101_recovered_c.h
```

### `X-Gorgon`

当前 350.101 样本的核心算法已经字节级复现：

```text
url_digest4 || x_ss_stub[0..4] || zero4 || gorgon_word_le || seed_be
  -> 0x16CEA0 raw transform
  -> bytesToHexString(raw26)
  -> X-Gorgon
```

其中本次向量：

```text
url_digest4       = ec 8a 33 e2   # MD5(query)[:4]
x_ss_stub[0..4]   = fd f6 0e 82
zero4             = 00 00 00 00
gorgon_word_le    = 00 05 09 04   # dword 0x04090500
seed_be           = 6a 94 53 60   # seed=0x6a945360
short_code        = 0x0008
raw_body_low16    = 0xc6e0        # raw MEM_BLOCK body 地址低 16 位
```

`0x16CEA0` 的关键细节：

- `0x16D1DC` 写固定头：`raw[0]=0x84`，局部 key 固定字节包含
  `4a/16/47/6c`。
- `raw[1]=0x04`，`raw[4..5]=short_code`。
- `raw[2..3]` 混入 raw 临时 buffer 的地址低 16 位。
- KSA/PRGA 是 RC4-like，但不是标准 RC4 swap：汇编实际是
  `S[i]=S[j]; S[j]=S[j]`。
- 收尾对 20 字节材料做 nibble-swap、xor-next、bit-reverse、`len ^ ~byte`。

C API：

```c
metasec_build_x_gorgon_material20_350101(...)
metasec_build_x_gorgon_raw_350101(...)
metasec_build_x_gorgon_value_350101(...)
```

验证输出：

```text
8404e0c60800b1144e023be9a08ef1ebebe5a6df25f723bef357
```

说明：当前 C API 从 `url_digest4` 层进入；本次日志证明
`url_digest4 == MD5(query)[:4]`。后续可以把 MD5 wrapper 接进来，但核心
Gorgon transform 已经闭环。

### `X-Khronos`

`0x16D454 signStage2_makeKeyPieces_350` 里最终写入 header 的值就是
seed 的十进制字符串：

```text
snprintf("%u", seed)
```

本次向量：

```text
seed = 0x6a945360 = 1788105568
X-Khronos = "1788105568"
```

C API：

```c
metasec_build_x_khronos_value_350101(...)
```

### `X-Ladon`

当前 350.101 样本可以完整复现：

```text
CF100("%u-%s-%s")
  -> formatted_text = "1788108717-1588093228-1128"
  -> CF48/F17(text, key32) = transform32
  -> CF49(prefix4 || transform32) = 0x24 pack
  -> CF44(base64(pack36)) = X-Ladon
```

C API：

```c
metasec_build_x_ladon_value_350101(...)
```

验证输出：

```text
fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+
```

### `X-Helios`

和 `X-Ladon` 同族，差异是 `key32/prefix4`：

```text
CF100("%u-%s-%s")
  -> CF48/F17
  -> CF49
  -> CF44
```

C API：

```c
metasec_build_x_helios_value_350101(...)
```

验证输出：

```text
MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5
```

### `X-Argus`

当前拆成三层，已经分别有 C oracle：

第一层是 `XArgusStruct` protobuf 明文构造：

```text
MetaSecXArgusStruct350
  -> protobuf wire
  -> 0x92 plaintext
```

本次 350.101 向量里的稳定字段包括：

```text
k1  sdk_date         = 0x40401252
k2  type             = 2
k3  random_value     = 0x6497ae3a
k4  aid              = "1128"
k5  device_id        = "397365608203400"
k6  version_string   = "1588093228"
k7  app_version_name = "35.1.0"
k8  sdk_version_name = "v04.09.05-ml-android"
k9  sdk_version_code = 0x08120a00
k10 proto_header     = 08 00 00 00 00 00 00 00
k12/k17 khronos      = 0xd529772e
k13 x-ss-stub SM3    = cf 03 47 6f 3b 96
k14 url SM3          = 1f 08 57 8a 51 5b
k15 algorithm_seq    = {2, 0x1530be, 0x1530be}
k20 pskVersion       = "none"
k21 callType         = 0x2e2
```

第二层是 CF41：

```text
0x92 XArgusStruct protobuf
  -> CF41 SIMON128/256 + PKCS#7
  -> 0xa0 encrypted work block
```

第三层是 F5 work-area 改写 + 最终 header tail：

```text
tailA8 = 08 00 00 00 00 00 00 00 || CF41out
mutatedA8[i] = tailA8[len - 1 - i] ^ mask4[i & 3]
bodyB3 = prefix9 || mutatedA8 || suffix2
  -> CF43 AES-128-CBC + PKCS#7
  -> CF42 low16 prefix
  -> CF44 base64
  -> X-Argus
```

这里要特别小心：当前 F5 不是把 `08||CF41out` 直接拼进 AES body。
日志里能看到：

```text
CF41 out    = a6 34 01 c3 28 e9 ... len=0xa0
08||CF41out = 08 00 00 00 00 00 00 00 a6 34 ...
AES bodyB3  = 35 79 fb e6 79 01 cf 07 18 07 e6 3b ...
```

现在这段已经 lift 出来：F5 records `0x021f..0x022c` 是反向读源 buffer，
按 4 字节 mask 循环 xor 后写入目标 buffer。

当前 mask 来源：

```text
F5 records 0x020c..0x0215:
  CF69(..., 2) -> 0xfffc4ffa
  REV16
  ROR #16
  store little-endian mask bytes = ff fc 4f fa
```

从 CF41 明文到最终 header 的完整路径：

```text
tailA8 = le64 || CF41_SIMON128_256_PKCS7(XArgusStruct, key32)
  -> mutatedA8 = reverse_xor(tailA8, mask4)
  -> bodyB3 = prefix9 || mutatedA8 || suffix2
  -> CF43
  -> prefix2 || outC0
  -> base64
```

C API：

```c
metasec_build_x_argus_plain_350101(...)
metasec_cf41_simon128_256_pkcs7_encrypt_350101(...)
metasec_x_argus_mask_from_seed_350101(...)
metasec_x_argus_reverse_xor_tail_350101(...)
metasec_build_x_argus_value_from_plain_350101(...)
metasec_build_x_argus_tail_value_350101(...)
```

当前验证项：

```text
X-Argus protobuf plain match=true len=0x92
X-Argus CF41 SIMON match=true len=0xa0
X-Argus reverse-xor mask match=true len=0x4
X-Argus mutated tailA8 match=true len=0xa8
X-Argus full-from-plain match=true len=0x104
X-Argus tail match=true len=0x104
```

因此，当前 350.101 样本的 `X-Argus` 从 protobuf 明文到最终 header 已经
byte-exact C 复现。还需要运行时提供的是动态字段值，例如 random、khronos、
SM3 摘要、key/material/mask seed；这些属于环境/材料采集，不是算法缺口。

### `X-Medusa`

当前已经还原到 final pack 层：

```text
mini20 || const2 || zero1 || one1 || marker1 || subpack
  -> CF44 base64
  -> X-Medusa
```

C API：

```c
metasec_build_x_medusa_pack_350101(...)
metasec_build_x_medusa_value_from_pack_350101(...)
```

已还原的前置变换：

- mini20：`f8_medusa_mini_xor_recovered_350101.c`
- subpack 前缀 bit-pack：`f12_medusa_subpack_recovered_350101.c`
- F12 source-work 上游四族：`f20_f21_medusa_source_transform_recovered.c`

当前验证：

```text
base64(x_medusa_pack_350101_cf44_input.bin) == X-Medusa
```

### `X-Soter`

当前 350.101 unidbg 样本能复现“空/default Soter 包”：

```text
00 01 00 02 || zero86
  -> CF44 base64
  -> X-Soter
```

C API：

```c
metasec_build_x_soter_value_from_pack_350101(...)
metasec_build_x_soter_empty_value_350101(...)
```

验证输出：

```text
AAEAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

说明：`0x14A65C direct treeMapPut -> X-Soter` 已定位，F13 后半段会在 VM
栈上构造 Soter pack 字段。当前 unidbg 环境字段为空，所以包体除
`00 01 00 02` 外全零；真机若出现非零字段，需要继续追 F13 的环境字段来源。

## 当前结论

如果按“能用 C 复现当前样本 header 值”衡量：

| Header | 当前状态 |
|---|---|
| `X-Gorgon` | 核心 transform + 当前向量完整 C 复现；URL 摘要入口当前从 `MD5(query)[:4]` 层传入 |
| `X-Khronos` | 完整 C 复现，`seed` 十进制 |
| `X-Ladon` | 完整 C 复现 |
| `X-Helios` | 完整 C 复现 |
| `X-Argus` | protobuf 明文 -> CF41 SIMON -> reverse-xor work-area -> CF43 AES/base64 完整 C 复现 |
| `X-Medusa` | final pack/base64 C 复现；mini/F12/source-work 已 C 化；环境收集层未完整 C 化 |
| `X-Soter` | 当前 empty/default pack 完整 C 复现；非零环境字段仍待追 |

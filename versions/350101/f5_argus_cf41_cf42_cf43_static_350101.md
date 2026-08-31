# 350.101 F5/X-Argus tail: CF41 / CF42 / CF43 static peel

This note records the static layer behind the byte-exact F5 tail report:

```text
dyidre/versions/350101/f5_x_argus_pack_lift_350101.md
```

Scope: `libmetasec_ml.so` 350.101, build-id
`025e51707b4c64f0b578e2dd7f12aa58ca94241a`.

## Runtime position

In the focused F5 run:

```text
hit23 CF42: low16(0x6f80)     -> 80 6f
hit24 CF30: 0xb1 + 0x02       -> 0xb3
hit25 CF43: body 0xb3 + key/material/side/mode
hit26 CF42: low16(0x6f80e11b) -> 1b e1
hit27 CF30: 0x02 + 0xc0       -> 0xc2
hit28 CF44: base64(0xc2)      -> X-Argus
```

The final output check is already closed:

```text
base64(final 0xc2 CF44 input) == final X-Argus: true
```

## CF42: exact little-endian u16 MEM_BLOCK helper

Wrapper:

```text
0x16F48C cf42_makeU16MemBlockLE_slot4_out_slot5_low16_350
```

ABI:

```text
slot4 -> hidden X8 output MEM_BLOCK*
slot5 -> W0 value
```

Inner helper:

```text
0x16CC84 makeU16MemBlockLE_16CC84_350
```

Key instructions:

```text
strh w0, [sp,#4]
mov  x0, x8
mov  w2, #2
bl   0x10B488
```

So the recovered semantics are:

```c
void CF42(MEM_BLOCK *out, uint64_t value)
{
    uint16_t le = (uint16_t)value;
    initMemBlockBySrc(out, &le, 2);
}
```

Current F5 examples:

```text
0x6f80     -> 80 6f
0x6f80e11b -> 1b e1
```

【中文】CF42 不是加密/变换，它就是把 slot5 的低 16 位打成 2 字节小端
MEM_BLOCK。以后看到 `80 6f` / `1b e1`，不要再当成神秘尾部算法。

## CF41: SIMON128/256 tail transform

Wrapper:

```text
0x16F43C cf41_argusTailSimon128256_slot4_input_slot5_out_slot6_key_350
```

Observed wrapper ABI:

```text
slot4 -> input MEM_BLOCK
slot5 -> output MEM_BLOCK
slot6 -> key/material MEM_BLOCK
```

Current focused runs show `slot4` is the protobuf `XArgusStruct`, not the
earlier `pack24` bytes:

```text
slot4 input len 0x92 -> cf41_plain92_proto_350101.md
slot5 output storage is reused from an earlier MEM_BLOCK and becomes len 0xa0
slot6 key/material len 0x20
```

Static lower chain:

```text
0x16F43C -> 0x16CB88 -> 0x16E538 -> 0x16E678 / managed F16 wrapper 0x1717F4
```

`0x16CB88`:

- clones `slot6` into a local MEM_BLOCK;
- if cloned length is less than or equal to `0x1f`, appends zero/fill bytes
  so the key/material becomes 32 bytes;
- calls `0x16E538(input.body, input.len, &tmp_out, &tmp_len, key32)`;
- rebuilds `slot5` output MEM_BLOCK from the temporary output.

`0x16E538`:

- allocates a `0x240` work/schedule MEM_BLOCK;
- copies the 32-byte key/material into the schedule;
- copies the input bytes into a temporary input block;
- calls `0x16E678`, the SIMON128/256 key schedule expander using constant
  `0x3dc94c3a046d678b`;
- pads the input with PKCS#7 to a 16-byte boundary;
- loops over 16-byte blocks and calls `0x1717F4`, the managed `F16`
  block-transform wrapper.

`0x1717F4` loads `g_managedProg_sign_F16_350`. Decoded F16 implements the
SIMON round:

```c
R2 = L ^ ((ROL64(R, 1) & ROL64(R, 8)) ^ ROL64(R, 2)) ^ round_key[i];
L  = R;
R  = R2;
```

`0x16E678` emits `72` little-endian u64 round keys (`72 * 8 = 0x240`).
Together this is SIMON128/256: 128-bit block, 256-bit key, 72 rounds.

Recovered shape:

```c
void CF41(MEM_BLOCK *input, MEM_BLOCK *out, MEM_BLOCK *key_material)
{
    MEM_BLOCK key32 = cloneAndPadTo32(key_material);
    uint64_t round_key[72] = simon128_256_expand_16E678(key32);
    padded = pkcs7_pad_16(input);
    out = simon128_256_encrypt_blocks_F16(round_key, padded);
}
```

Runtime vector from `sign6_350101_cf43mode_ret_20260831_072406.log`:

```text
input len 0x92 -> padded/out len 0xa0
key len 0x20
out fnv1a 29b26846
standalone oracle: cf41_simon128_256_recovered_350101.c failures=0
```

【中文】CF41 已经不是黑盒 prepare 了：它是 Argus tail 的
SIMON128/256 层。证据链是 `0x16E678` 的 72 轮 key schedule、F16 的
SIMON round 公式，以及 runtime 向量 byte-exact 对上。

## CF43: AES mode + PKCS#7 tail transform

Wrapper:

```text
0x16F4C4 cf43_argusTailAesModePkcs7Transform_slot4_out_slot5_body_slot6_key16_350
```

Wrapper ABI:

```text
slot4 -> hidden X8 output
slot5 -> X0 body MEM_BLOCK       (current F5 len 0xb3)
slot6 -> X1 key/material block   (inner requires cloned len == 0x10)
slot7 -> X2 side material
slot8 -> X3 mode descriptor
```

Inner helper:

```text
0x11BF94 cf43_argusTailAesModePkcs7Transform_inner_350
```

Important blocks inside `0x11BF94`:

- clones slot6 and checks cloned length is exactly `0x10`;
- initializes mode/cipher context through `0x11CAE0`;
- computes `aligned = ((len + 0x10) / 0x10) << 4`;
- computes a PKCS#7-style padding byte;
- fills bytes from original length to aligned length with that pad byte;
- calls `0x11CBB4(modeDesc, ctx, padded_in, out, aligned_len)`;
- wraps the transformed aligned bytes as a MEM_BLOCK.

Current F5 shape:

```text
bodyB3 len 0xb3 -> padded len 0xc0 -> transformed outC0
argusC2 = CF42(low16 0x6f80e11b) || outC0
```

Focused mode-return proof:

```text
hit22: slot4 0x12849c70 is bodyB1, src_len=0xb1
hit25: CF43 receives bodyB3 at slot5=0x12849c98
hit25: CF43 slot8/modeDesc first word is 1
0x11CBB4: x2 == x3 == padded buffer, x4 == 0xc0
0x11C8D8: saved_x2_after is the post-process 0xc0 output
hit27: CF30 consumes slot6 0x12849c70, now src_len=0xc0, body=outC0
hit28: CF44 receives prefix2 || outC0, len=0xc2
```

So the same work-slot object at `0x12849c70` is reused/overwritten between
`bodyB1` and final `outC0`. The focused return-point log now proves the
ownership chain:

```text
0x11CBB4 in-place mode_process(padded, padded, 0xc0)
  -> 0x11C8D8 saved_x2_after FNV a79949b1
  -> next CF30 slot6 outC0 FNV a79949b1
  -> final CF44 input = prefix2(81 34) || outC0, FNV cc413c64
```

The padding at `0x11CBB4` entry is also visible: bytes `0xb3..0xbf` are thirteen
`0x0d` bytes, exactly PKCS#7 for `0xb3 -> 0xc0`.

AES/mode lower helpers:

| Address | Current name | Evidence |
|---:|---|---|
| `0x10569C` | `aesSetEncryptKey_350` | AES key length branches `0x10/0x18/0x20`, round-key context |
| `0x105AF0` | `aesEncryptBlock_350` | AES T-table/S-box style encrypt block |
| `0x105E54` | `aesDecryptBlock_350` | AES decrypt sibling |
| `0x11CAE0` | `cf43_modeInitDispatcher_350` | dispatches raw/AES-CBC/AES-CTR/feedback mode init |
| `0x11CBB4` | `cf43_modeProcessDispatcher_350` | dispatches raw block loop / AES-CBC / AES-CTR / feedback process |
| `0x11C8D8` | `cf43_afterModeProcessWrapOutput_350` | return point after mode process; post buffer equals final CF30 slot6 |
| `0x106230` | `aesCbcInit_350` | mode type 1 init branch in current F5 sample |
| `0x1062A8` | `aesCbcEncrypt_350` | mode type 1 branch; OpenSSL AES-128-CBC matches |
| `0x1064D0` | `aesCtrProcess_350` | mode type 2 branch, stream/XOR shape |

Static dispatcher bytes:

```text
init table    @ 0x1F76F0: 00 0a 12 1a
process table @ 0x1F76F4: 00 09 12 18

type 0 -> init 0x10569C, process loop 0x105AF0
type 1 -> init 0x106230, process 0x1062A8   // current F5 sample, AES-128-CBC
type 2 -> init 0x106458, process 0x1064D0
type 3 -> init 0x10667C, process 0x1066F4
```

External oracle check:

```text
OpenSSL AES-128-CBC(key=slot6, iv=slot7, nopad(padded bodyB3)) == outC0: true
cf43_aes128_cbc_recovered_350101.c failures=0
```

Recovered shape:

```c
MEM_BLOCK CF43(MEM_BLOCK *body_b3,
               MEM_BLOCK *key16,
               MEM_BLOCK *side,
               void *mode_desc)
{
    uint8_t padded[round16(body_b3->len + 0x10)];
    pkcs7_pad(padded, body_b3);

    ModeCtx ctx;
    mode_init(mode_desc, &ctx, key16, side);
    // 当前 F5 样本 modeDesc[0].type == 1，
    // 即 0x106230 AES-CBC init + 0x1062A8 AES-CBC encrypt。
    mode_process(mode_desc, &ctx, padded, padded, sizeof(padded));
    return memblock(padded, sizeof(padded));
}
```

【中文】CF43 已经能确定是 Argus 尾部 `0xb3 -> 0xc0` 的块加密/模式层。
当前样本 `slot8/modeDesc[0].type == 1`，静态跳表对应
`0x106230 AES-CBC init + 0x1062A8 AES-CBC encrypt`。低层 `0x11CBB4` 是原地处理：
`x2 == x3`，返回后 `0x11C8D8 saved_x2_after` 等于下一次 CF30 的
`slot6/outC0`，最后 `CF44` 输入就是 `81 34 || outC0`。用 OpenSSL 和
standalone C oracle 都已经验证为标准 AES-128-CBC。

## Current completion boundary

Closed:

- F5 tail MEM_BLOCK concat ladder is byte-exact.
- Final `0xc2` pack base64 equals X-Argus.
- CF42 is exact pure C.
- CF43 is statically peeled to AES mode + PKCS#7 padding shape.
- CF43 current F5 mode type is resolved as type 1 and verified as AES-128-CBC.
- CF43 output ownership is resolved through the `0x11C8D8` return-point dump.

Open:

- Continue tracing the upstream builders for optional `XArgusStruct` fields
  currently absent in this request (`k11_platform`, `k16_ms_token`, `k18`,
  `k19`).

Next focused unidbg probe:

```text
-Dmetasec.dumpManagedCfArgs=true
-Dmetasec.dumpManagedCfPost=true
-Dmetasec.managedCfCallsites=0x16f43c,0x16f48c,0x16f4c4,0x16f14c,0x16f544
-Dmetasec.dumpCf43Mode=true
-Dmetasec.cf43ModeMaxEvents=32
-Dmetasec.cf43ModeMaxBytes=0x100
```

【中文】这个探针会同时抓 CF43 wrapper 的 slot4/5/6/7/8、低层
`0x11CAE0/0x11CBB4` 的 `X0..X5/X8`，以及 `0x11C8D8` 返回后的输出。
350.101 已经确认：mode type=1，标准 AES-128-CBC；`0xb3` 按 `0x0d`
补到 `0xc0`，`0x11CBB4` 原地处理，返回缓冲就是后续 `outC0`。

Upgrade rule:

For a newer SO, first align the CF wrapper addresses by table registration,
then verify these three anchors:

```text
CF42 has strh + initMemBlockBySrc(...,2)
CF43 has 16-byte material check + PKCS#7 pad to 16-byte boundary
CF43 lower mode path still reaches AES 0x10569C/0x105AF0 family or its relocated equivalent
```

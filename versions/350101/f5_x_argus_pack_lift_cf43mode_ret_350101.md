# 350.101 F5 / X-Argus tail pack lift

- Source log: `unidbg/unidbg-android/target/sign6_350101_cf43mode_ret_20260831_072406.log`
- Scope: F5 managed program tail after the 0x44 digest/material pack.
- Meaning: this is the byte-exact ladder that builds the `0xc2` binary pack consumed by `CF44`, then returned as `X-Argus` by `CF98`.
- Final CF44 input length: `0xc2`
- Final CF44 input FNV1a: `cc413c64`
- Base64 length: `0x104`
- `base64(final_pack) == final X-Argus`: `True`
- Raw final pack: `dyidre/versions/350101/f5_x_argus_tail_final_c2_cf43mode_ret_350101.bin`
- CF41 SIMON128/256 oracle check: `true` (input `0x92` -> padded/out `0xa0`, key `0x20`, fnv `29b26846`)

## Verified concat ladder

| hit | record hint | helper | check | slot4 output | slot5 left | slot6 right |
|---:|---|---|---|---|---|---|
| 1 | F5 tail step 1 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x20+0x4=0x24`) | `0x24` `7fadf486 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... 91 f7 aa 8a a2 f5 81 34 76 70` | `0x20` `c27cd52d ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5` | `0x4` `4976203e ok` `81 34 76 70` |
| 2 | F5 tail step 2 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x24+0x20=0x44`) | `0x44` `0fe2acd6 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5` | `0x24` `7fadf486 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... 91 f7 aa 8a a2 f5 81 34 76 70` | `0x20` `c27cd52d ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5` |
| 4 | F5 tail step 4 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x8+0xa0=0xa8`) | `0xa8` `bd1c263e ok` `08 00 00 00 00 00 00 00 a6 34 ... 92 3e cf cd cb 18 d3 74 1a f8` | `0x8` `86ec6a6d ok` `08 00 00 00 00 00 00 00` | `0xa0` `29b26846 ok` `a6 34 01 c3 28 e9 e7 82 09 51 ... 92 3e cf cd cb 18 d3 74 1a f8` |
| 5 | F5 tail step 5 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x1+0x8=0x9`) | `0x9` `5848c022 ok` `35 79 fb e6 79 01 cf 07 18` | `0x1` `300ca0d0 ok` `35` | `0x8` `c47fb1cb ok` `79 fb e6 79 01 cf 07 18` |
| 6 | F5 tail step 6 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x9+0xa8=0xb1`) | `0xb1` `bb36bec3 ok` `35 79 fb e6 79 01 cf 07 18 07 ... 7b 5c ff fc 4f fa ff fc 4f f2` | `0x9` `5848c022 ok` `35 79 fb e6 79 01 cf 07 18` | `0xa8` `0ae4e0c8 ok` `07 e6 3b 29 e7 37 82 35 c1 6e ... 7b 5c ff fc 4f fa ff fc 4f f2` |
| 8 | F5 tail step 8 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0xb1+0x2=0xb3`) | `0xb3` `ebbffc4d ok` `35 79 fb e6 79 01 cf 07 18 07 ... ff fc 4f fa ff fc 4f f2 76 70` | `0xb1` `bb36bec3 ok` `35 79 fb e6 79 01 cf 07 18 07 ... 7b 5c ff fc 4f fa ff fc 4f f2` | `0x2` `5549e33b ok` `76 70` |
| 11 | F5 tail step 11 | CF30 concatMemBlock | `slot4 == slot5 || slot6`: `True` (`0x2+0xc0=0xc2`) | `0xc2` `cc413c64 ok` `81 34 fb 18 46 43 88 a1 82 38 ... 31 8a 69 de 88 8a d4 1e 25 08` | `0x2` `16372e28 ok` `81 34` | `0xc0` `a79949b1 ok` `fb 18 46 43 88 a1 82 38 9f de ... 31 8a 69 de 88 8a d4 1e 25 08` |

## Tail event timeline

| hit | line | record hint | helper | slots | observed body/output |
|---:|---:|---|---|---|---|
| 1 | 275 | F5 tail step 1 | CF30 concatMemBlock | `s2=0x12849d30 s4=0x12849cb0 s5=0x12849d40 s6=0x12849c98 s7=0x0 s8=0x0` | slot4=`0x24` `7fadf486 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... 91 f7 aa 8a a2 f5 81 34 76 70`<br>slot5=`0x20` `c27cd52d ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5`<br>slot6=`0x4` `4976203e ok` `81 34 76 70` |
| 2 | 336 | F5 tail step 2 | CF30 concatMemBlock | `s2=0x12849d30 s4=0x12849cc8 s5=0x12849cb0 s6=0x12849d40 s7=0x0 s8=0x0` | slot4=`0x44` `0fe2acd6 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5`<br>slot5=`0x24` `7fadf486 ok` `8e bd fa 38 06 ec c5 ce e7 94 ... 91 f7 aa 8a a2 f5 81 34 76 70`<br>slot6=`0x20` `c27cd52d ok` `8e bd fa 38 06 ec c5 ce e7 94 ... ae f7 1c b6 91 f7 aa 8a a2 f5` |
| 3 | 396 | F5 tail step 3 | CF41 simon128_256Pkcs7 | `s2=0x125f0428 s4=0x12849d58 s5=0x12849cb0 s6=0x12849ce0 s7=0x0 s8=0x0` | cf41.input.slot4=`0x92` `34dbccfe ok` `08 d2 a4 80 82 04 10 02 18 ba ... 01 04 6e 6f 6e 65 a8 01 e2 05`<br>cf41.out.slot5=`0x8` `9be17165 ok` `00 00 00 00 00 00 00 00`<br>cf41.key_material.slot6=`0x20` `23e8c3ca ok` `4c 6d ce 74 7a 11 3c fa 83 41 ... 80 21 29 2a 55 f9 11 f9 98 4f`<br>cf41.post.input.slot4=`0x92` `34dbccfe ok` `08 d2 a4 80 82 04 10 02 18 ba ... 01 04 6e 6f 6e 65 a8 01 e2 05`<br>cf41.post.out.slot5=`0xa0` `29b26846 ok` `a6 34 01 c3 28 e9 e7 82 09 51 ... 92 3e cf cd cb 18 d3 74 1a f8`<br>cf41.post.key_material.slot6=`0x20` `23e8c3ca ok` `4c 6d ce 74 7a 11 3c fa 83 41 ... 80 21 29 2a 55 f9 11 f9 98 4f` |
| 4 | 424 | F5 tail step 4 | CF30 concatMemBlock | `s2=0x125f0428 s4=0x12849c98 s5=0x1271c580 s6=0x12849cb0 s7=0x0 s8=0x0` | slot4=`0xa8` `bd1c263e ok` `08 00 00 00 00 00 00 00 a6 34 ... 92 3e cf cd cb 18 d3 74 1a f8`<br>slot5=`0x8` `86ec6a6d ok` `08 00 00 00 00 00 00 00`<br>slot6=`0xa0` `29b26846 ok` `a6 34 01 c3 28 e9 e7 82 09 51 ... 92 3e cf cd cb 18 d3 74 1a f8` |
| 5 | 483 | F5 tail step 5 | CF30 concatMemBlock | `s2=0x79e6fb79 s4=0x12849c58 s5=0x12849c40 s6=0x12849c28 s7=0x0 s8=0x0` | slot4=`0x9` `5848c022 ok` `35 79 fb e6 79 01 cf 07 18`<br>slot5=`0x1` `300ca0d0 ok` `35`<br>slot6=`0x8` `c47fb1cb ok` `79 fb e6 79 01 cf 07 18` |
| 6 | 539 | F5 tail step 6 | CF30 concatMemBlock | `s2=0x79e6fb79 s4=0x12849c70 s5=0x12849c58 s6=0x12849cb0 s7=0x0 s8=0x0` | slot4=`0xb1` `bb36bec3 ok` `35 79 fb e6 79 01 cf 07 18 07 ... 7b 5c ff fc 4f fa ff fc 4f f2`<br>slot5=`0x9` `5848c022 ok` `35 79 fb e6 79 01 cf 07 18`<br>slot6=`0xa8` `0ae4e0c8 ok` `07 e6 3b 29 e7 37 82 35 c1 6e ... 7b 5c ff fc 4f fa ff fc 4f f2` |
| 7 | 596 | F5 tail step 7 | CF42 makeU16MemBlockLE | `s2=0x79e6fb79 s4=0x12849c10 s5=0x7076 s6=0x12849cb0 s7=0x0 s8=0x0` |  |
| 8 | 609 | F5 tail step 8 | CF30 concatMemBlock | `s2=0x79e6fb79 s4=0x12849c98 s5=0x12849c70 s6=0x12849c10 s7=0x0 s8=0x0` | slot4=`0xb3` `ebbffc4d ok` `35 79 fb e6 79 01 cf 07 18 07 ... ff fc 4f fa ff fc 4f f2 76 70`<br>slot5=`0xb1` `bb36bec3 ok` `35 79 fb e6 79 01 cf 07 18 07 ... 7b 5c ff fc 4f fa ff fc 4f f2`<br>slot6=`0x2` `5549e33b ok` `76 70` |
| 9 | 666 | F5 tail step 9 | CF43 aesCbcPkcs7Encrypt | `s2=0x79e6fb79 s4=0x12849c58 s5=0x12849c98 s6=0x12849d10 s7=0x12849cf8 s8=0x12849c40` |  |
| 10 | 817 | F5 tail step 10 | CF42 makeU16MemBlockLE | `s2=0x79e6fb79 s4=0x12849c28 s5=0x70763481 s6=0x12849d10 s7=0x12849cf8 s8=0x12849c40` |  |
| 11 | 830 | F5 tail step 11 | CF30 concatMemBlock | `s2=0x79e6fb79 s4=0x12849c40 s5=0x12849c28 s6=0x12849c70 s7=0x12849cf8 s8=0x12849c40` | slot4=`0xc2` `cc413c64 ok` `81 34 fb 18 46 43 88 a1 82 38 ... 31 8a 69 de 88 8a d4 1e 25 08`<br>slot5=`0x2` `16372e28 ok` `81 34`<br>slot6=`0xc0` `a79949b1 ok` `fb 18 46 43 88 a1 82 38 9f de ... 31 8a 69 de 88 8a d4 1e 25 08`<br>slot7=`0x10` `d417f7c4 ok` `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12`<br>slot8=`0xc2` `cc413c64 ok` `81 34 fb 18 46 43 88 a1 82 38 ... 31 8a 69 de 88 8a d4 1e 25 08` |
| 12 | 910 | F5 rec 0x01c1 | CF44 base64Encode | `s2=0x79e6fb79 s4=0x12849c10 s5=0x12849c40 s6=0x12849c70 s7=0x12849cf8 s8=0x12849c40` | cf44.input=`0xc2` `cc413c64 ok` `81 34 fb 18 46 43 88 a1 82 38 ... 31 8a 69 de 88 8a d4 1e 25 08` |

## CF43 low-level mode evidence

- `modeDesc[0].type` from `cf43.entry.slot8[0..4]`: `1`.
- Static dispatch mapping: type `1`: init jump 0x11CB54 -> 0x106230 AES-CBC init; process jump 0x11CC24 -> 0x1062A8 aesCbcEncrypt_350.

| hit | line | helper | registers | raw highlights |
|---:|---:|---|---|---|
| 1 | 705 | cf43.modeInitDispatcher_11CAE0 | `lr=0x1211c768 sp=0xe4ffe000 x0=0xe4ffe040 x1=0x1271c6f0 x2=0x0 x3=0x10 x4=0x124f6000 x5=0xffffffff x8=0xe4ffe0e0` |  |
| 2 | 734 | cf43.modeProcessDispatcher_11CBB4 | `lr=0x1211c8d8 sp=0xe4ffe000 x0=0xe4ffe038 x1=0xe4ffe0e0 x2=0x125f5840 x3=0x125f5840 x4=0xc0 x5=0xffffffff x8=0xea7099db` | `cf43.modeProcessDispatcher_11CBB4.x2` len=0x100 fnv=`aa8498b4` `35 79 fb e6 79 01 cf 07 ... 00 00 00 00 00 00 00 00`<br>`cf43.modeProcessDispatcher_11CBB4.x3` len=0x100 fnv=`aa8498b4` `35 79 fb e6 79 01 cf 07 ... 00 00 00 00 00 00 00 00` |
| 3 | 768 | cf43.afterModeProcess_11C8D8 | `lr=0x1211c8d8 sp=0xe4ffe000 ret_x0=0x0 x1=0xd41e x2=0xe4ffe2c8 x3=0xd41e25 x4=0x121ef8e4 saved_x1=0xe4ffe0e0 saved_x2=0x125f5840 saved_x3=0x125f5840 saved_len=0xc0` | `cf43.afterModeProcess_11C8D8.saved_x2_after` len=0xc0 fnv=`a79949b1` `fb 18 46 43 88 a1 82 38 ... 69 de 88 8a d4 1e 25 08` |

- `0x11CBB4` entry has `x2 == x3` and `x4 == 0xc0` in the focused run; bytes `0xb3..0xbf` are `0d 0d 0d 0d 0d 0d 0d 0d 0d 0d 0d 0d 0d`.
- `0x11C8D8` return buffer equals the next CF30 slot6 `0xc0` input: `True`.
- Final `0xc2` CF44 input is `prefix2 || afterModeProcess`: `True`; prefix2=`81 34`.

## Restored F5 tail shape

```c
/* Evidence-backed shape. CF42 is exact; current CF43 mode type 1 is AES-128-CBC + PKCS#7. */
pack24 = concat(digest32_or_material20, dyn4);       // hit 12: 0x20 + 0x04 = 0x24
pack44 = concat(pack24, digest32_or_material20);     // hit 13: 0x24 + 0x20 = 0x44
sm3_44 = SM3(pack44);                                // hit 14/15: CF61 -> 0x20 snapshot
transformA0 = CF41_simon128_256_pkcs7(argusPlain92, key32_material); // hit 16: slot5/output reuses earlier MEM_BLOCK storage
tailA8 = concat(le64_8, transformA0);                // hit 17: 0x08 + 0xa0 = 0xa8
prefix9 = concat(prefix1, prefix8);                  // hit 21: 0x01 + 0x08 = 0x09
mask4 = rev16_ror16(CF69(..., 2));                   // records 0x020c..0x0215, current mask ff fc 4f fa
mutatedA8[i] = tailA8[len - 1 - i] ^ mask4[i & 3];   // records 0x021f..0x022c
bodyB1 = concat(prefix9, mutatedA8);                 // hit 22: 0x09 + 0xa8 = 0xb1
suffix2 = makeU16MemBlockLE(0x7076);                 // hit 23: emits 76 70
bodyB3 = concat(bodyB1, suffix2);                    // hit 24: 0xb1 + 0x02 = 0xb3
outC0 = CF43_aes128_cbc_pkcs7_encrypt(bodyB3, key16, iv16_from_side, modeDesc_type1);
prefix2 = makeU16MemBlockLE(0x70763481);             // hit 26: emits 81 34
argusC2 = concat(prefix2, outC0);                    // hit 27: 0x02 + 0xc0 = 0xc2
x_argus = base64(argusC2);                           // hit 28
out_key = "X-Argus"; out_value = x_argus;           // hit 31/33
```

## Notes for upgrades

- The heap addresses are unstable; use lengths, helper order, and concat checks as anchors.
- `CF42`/`CF43` are native binding helpers, not managed programs `F42`/`F43`.
- `CF41` is resolved for the current F5 sample: input `0x92` is PKCS#7-padded to `0xa0` and encrypted as SIMON128/256 with 32-byte key material; computed output matches slot5 post body `true`.
- `CF42` is exact: wrapper `0x16F48C` passes hidden out=slot4 and slot5 to `0x16CC84`; `0x16CC84` does `strh w0` then `initMemBlockBySrc(out, &u16, 2)`.
- `CF43` is now resolved for the current F5 sample: hidden out=slot4, args body=slot5/key16=slot6/iv16=slot7/modeDesc=slot8; lower `0x11BF94` checks 16-byte material, PKCS#7 pads `0xb3 -> 0xc0`, selects mode type 1, and runs AES-128-CBC in place through `0x106230/0x1062A8`.
- CF43/output ownership is resolved in the mode-return log: `0x11CBB4` mutates `x2/x3` in place; at `0x11C8D8`, `saved_x2_after` equals the next CF30 slot6 `0xc0`, and final `0xc2` is `prefix2 || saved_x2_after`.
- Current sample selects CF43 mode type `1` (type `1`: init jump 0x11CB54 -> 0x106230 AES-CBC init; process jump 0x11CC24 -> 0x1062A8 aesCbcEncrypt_350).
- The output-level restoration is byte-exact once `base64(0xc2 pack) == X-Argus`; CF41 plaintext is `XArgusStruct` protobuf wire data. The `tailA8 -> mutatedA8` gap is now lifted as reverse-read + 4-byte xor mask, so remaining work is dynamic material collection for new requests/versions, not this F5 tail algorithm.

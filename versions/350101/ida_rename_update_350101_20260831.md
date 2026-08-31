# 350.101 IDA rename/comment update

Target IDB:

- `/Users/freeman/project/douyin/douyin_35_0_0/libmetasec_ml.so.i64`
- IDA MCP session: `metasec350_gui`
- imagebase: `0x0`
- saved: yes

## Applied groups

### Managed CF table

`CF00..CF101` at `0x16EA70..0x170258` now all have `cfXX_*_350`
function names and Chinese function comments.

Important promoted names:

| CF | address | name | reason |
|---:|---:|---|---|
| CF30 | `0x16F14C` | `cf30_concatMemBlocks_slot4_slot5_slot6_ret2_350` | repeated MEM_BLOCK concat in F5/F7/F8/F13 |
| CF41 | `0x16F43C` | `cf41_argusTailSimon128256_slot4_in_slot5_out_slot6_key_350` | SIMON128/256 + PKCS#7, calls managed F16 |
| CF42 | `0x16F48C` | `cf42_packU16LE_slot4_out_slot5_value_350` | exact low16 -> 2-byte LE MEM_BLOCK |
| CF43 | `0x16F4C4` | `cf43_argusTailAes128CbcPkcs7_slot4_out_slot5_body_slot6_key_350` | current F5 type=1 AES-128-CBC + PKCS#7 |
| CF48 | `0x16F660` | `cf48_shortHeaderTransform32_slot4_text_slot5_out_slot6_key_350` | short header transform, calls managed F17 |
| CF49 | `0x16F6B0` | `cf49_buildShortHeaderPack36_slot4_prefix_slot5_xform_ret2_350` | 4-byte prefix + 32-byte transform |
| CF54 | `0x16F79C` | `cf54_substringMemBlock_src5_start6_len7_dst4_350` | true-device-only substring branch |
| CF61 | `0x16F998` | `cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350` | SM3 one-shot, verified by raw vectors |
| CF79 | `0x16FD64` | `cf79_jsonAddNumber_slot4_key5_valSlot2_350` | X-Medusa JSON numeric fields, reads double slot2 |
| CF86 | `0x16FF00` | `cf86_urlsafeBase64DecodeCheck_slot4_ret2_350` | URL-safe base64 normalize/decode check |
| CF96 | `0x1700D4` | `cf96_lockedSharedRefAssign_slot4_dst_slot5_src_350` | locked shared-ref copy/addref |
| CF97 | `0x170110` | `cf97_sourceStreamReleaseHelper_slot4_ret2_350` | F8 boundary where 31-byte source stream is visible |
| CF98 | `0x170128` | `cf98_formatAllocString_slot4_fmt5_ret2_350` | header key/value string formatter |
| CF99 | `0x170188` | `cf99_formatDefaultStringToMemBlock_slot4_ret2_350` | empty/zero string defaults to `"0"` in observed run |
| CF100 | `0x1701D8` | `cf100_formatStringToMemBlock_slot4_fmt5_args6_8_350` | short header `%u-%s-%s` text builder |

Unknown or weakly proven CF entries intentionally keep conservative names like
`cfXX_nativeBinding_350` plus a Chinese comment. Do not promote those to business
names until a focused trace proves the slot ABI and output.

### Managed sign program globals

`g_managedProg_sign_F0_350..g_managedProg_sign_F54_350` already existed as
global names. Chinese line comments were added on every data slot and also on
the corresponding assignment lines inside `initManagedSignModuleLarge_350`.

The pretty/pseudocode-facing comments are on the writeback instructions:

- `g_managedModule_sign_350`: `0x170F64`
- `g_managedProg_sign_F0_350..g_managedProg_sign_F54_350`:
  `0x170F80 + F_index * 0x1C`

This makes the decompiler show comments beside:

```c
g_managedProg_sign_Fxx_350 = managedModuleFindProgram_350(v0, "Fxx");
```

instead of only on the global qword definitions.

- `F5`: X-Argus main program.
- `F7`: X-Ladon short-header program.
- `F8`: X-Medusa main program.
- `F12`: X-Medusa nested subpack / bit-pack program.
- `F13`: X-Helios/Soter short-header branch.
- `F15`: SM3 IV/state init.
- `F16`: SIMON128/256 block round program.
- `F17`: short-header ARX block transform.
- `F18..F21`: source-work outer families.
- `F22/F31/F39/F47`: source-work adapters.
- `F23/F32/F40/F48`: source-work block loops.
- `F24/F33/F41/F49`: family key/pre transforms.
- `F25/F34/F42/F50`: family schedulers.
- `F26..F29`, `F35..F38`, `F43..F46`, `F51..F54`: round primitives.
- `F30`: shared GF(2^8) multiply.

HTTP program globals were also commented:

- `g_managedModule_http_350`
- `g_managedProg_http_F0_350`
- `g_managedProg_http_F1_350`

### Algorithm helpers / wrappers

Promoted non-CF helpers:

| address | new name |
|---:|---|
| `0x10569C` | `aesKeySchedule_350` |
| `0x105AF0` | `aesEncryptBlock_350` |
| `0x105E54` | `aesDecryptBlock_350` |
| `0x10B510` | `initFilledMemBlock_slotByteLen_350` |
| `0x10BFD8` | `makeFilledMemBlock_byteLen_350` |
| `0x11BF94` | line comment only: `CF43 loc入口 / AES mode PKCS#7 body` |
| `0x11CAE0` | `cf43_modeInitDispatcher_350` |
| `0x11CBB4` | `cf43_modeProcessDispatcher_350` |
| `0x16CB88` | `cf41_cloneKeyPad32_thenSimonEncrypt_350` |
| `0x16CC84` | `packLow16ToMemBlockLE_350` |
| `0x16D520` | `sm3OneShot_F15InitUpdateFinal_350` |
| `0x16D5A0` | `sm3Update_64byteBlocks_350` |
| `0x16D680` | `sm3Final_padLenEmit32_350` |
| `0x16D86C` | `sm3Compress64_flattenedBlocks_350` |
| `0x16E794` | `shortHeaderTransform32_blocks_F17_350` |
| `0x16E8FC` | `shortHeaderArxSchedule34_350` |
| `0x16E538` | `simon128_256Pkcs7EncryptBlocks_F16_350` |
| `0x16E678` | `simon128_256ExpandKey72_350` |
| `0x16EA30` | `formatAllocStringInner_350` |
| `0x171744` | `managedSignInvokeF14_350` |
| `0x1717F4` | `managedSignInvokeF16_simonBlock_350` |
| `0x17184C` | `managedSignInvokeF17_shortBlock_350` |
| `0x1718A4` | `managedThunkAcquireFrameFromStack_350` |
| `0x17194C` | `managedThunkReleaseFrameFromX22_350` |
| `0x171960` | `managedThunkReturnVoid_350` |

## Evidence used

- `managed_cf_semantics_350101.md`
- `managed_sign_cf_table_350101.md`
- `managed_vm_decode_sourcework_350101/managed_vm_decode_summary.md`
- `cf61_sm3_recovered_350101.c`
- `cf41_simon128_256_recovered_350101.c`
- `cf43_aes128_cbc_recovered_350101.c`
- `cf48_f17_recovered_350101.c`
- `source_work_vector_selfcheck_350101.c`

## Deliberately not renamed

The remaining `sub_16D9DC..sub_16E474` functions are flattened micro-blocks
inside `sm3Compress64_flattenedBlocks_350`, not CF/F entries. They should be
renamed only if we later split the SM3 flattened control-flow graph into named
round helpers.

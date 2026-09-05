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
| CF22 | `0x16EFB0` | `cf22_appVersionRef_slot4_hiddenX8_350` | Java `MS.b(0x1000011)` UTF-8 app-version REF output; slot2 unchanged |
| CF23 | `0x16EFCC` | `cf23_sdkVersionWord_ret2_350` | guarded cached SDK `uint32` -> zero-extended slot2 (`0x04090500` fixture) |
| CF24 | `0x16EFF0` | `cf24_sdkIdentityCString_ret2_350` | guarded cached raw `v04.09.05-ml-android` C-string pointer -> slot2 |
| CF27 | `0x16F084` | `cf27_xor8InPlace_keyF8_slot4_buf_slot5_len_ret2_350` | raw in-place XOR-8, key `0x2025F8`; slot5 signed low-32-bit byte count |
| CF31 | `0x16F19C` | `cf31_protoWireSize_slot4_ret2_350` | descriptor-backed protobuf-wire-compatible size pass, shared `0x11615C` engine |
| CF33 | `0x16F218` | `cf33_protoWireWrite_slot4_slot5_ret2_350` | paired raw-buffer writer, shared `0x1165B8` engine |
| CF41 | `0x16F43C` | `cf41_argusTailSimon128256_slot4_in_slot5_out_slot6_key_350` | SIMON128/256 + PKCS#7, calls managed F16 |
| CF42 | `0x16F48C` | `cf42_packU16LE_slot4_out_slot5_value_350` | exact low16 -> 2-byte LE MEM_BLOCK |
| CF43 | `0x16F4C4` | `cf43_argusTailAes128CbcPkcs7_slot4_out_slot5_body_slot6_key_350` | current F5 type=1 AES-128-CBC + PKCS#7 |
| CF45 | `0x16F57C` | `cf45_xor8InPlace_keyE0_slot4_buf_slot5_len_ret2_350` | raw in-place XOR-8, key `0x2025E0` |
| CF46 | `0x16F5C8` | `cf46_xor8InPlace_keyE8_slot4_buf_slot5_len_ret2_350` | raw in-place XOR-8, key `0x2025E8` |
| CF47 | `0x16F614` | `cf47_xor8InPlace_keyF0_slot4_buf_slot5_len_ret2_350` | raw in-place XOR-8, key `0x2025F0` |
| CF48 | `0x16F660` | `cf48_shortHeaderTransform32_slot4_text_slot5_out_slot6_key_350` | short header transform, calls managed F17 |
| CF49 | `0x16F6B0` | `cf49_buildShortHeaderPack36_slot4_prefix_slot5_xform_ret2_350` | 4-byte prefix + 32-byte transform |
| CF54 | `0x16F79C` | `cf54_substringMemBlock_src5_start6_len7_dst4_350` | true-device-only substring branch |
| CF71 | `0x16FBD4` | `managedCf71_getTpidrEl0_350` | no slot arguments; `getTpidrEl0_350()` result is written to slot2 |
| CF61 | `0x16F998` | `cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350` | SM3 one-shot, verified by raw vectors |
| CF79 | `0x16FD64` | `managedCf79_cjsonAddNumber_350` | X-Medusa JSON numeric fields, reads double slot2 |
| CF85 | `0x16FEA0` | `managedCf85_cjsonAddStringToObjectField_350` | `*(slot4+8)` cJSON receiver; C-string key/value -> slot2 bool |
| CF87 | `0x16FF2C` | `managedCf87_cjsonAddBoolToObjectField_350` | `*(slot4+8)` cJSON receiver; `slot6 & 1` -> slot2 bool |
| CF88 | `0x16FF8C` | `managedCf88_cjsonPrintUnformattedToRef_350` | print `*(slot5+8)` unformatted into hidden slot4 shared-MEM_BLOCK ref; slot2 unchanged |
| CF90 | `0x16FFE8` | `cf90_protoWireSize_slot4_ret2_350` | CF31 alias through thunk `0x1722A4 -> 0x11615C` |
| CF91 | `0x170014` | `cf91_protoWireWrite_slot4_slot5_ret2_350` | CF33 alias through thunk `0x1722A8 -> 0x1165B8` |
| CF86 | `0x16FF00` | `cf86_urlsafeBase64DecodeCheck_slot4_ret2_350` | URL-safe base64 normalize/decode check |
| CF96 | `0x1700D4` | `cf96_lockedSharedRefAssign_slot4_dst_slot5_src_350` | locked shared-ref copy/addref |
| CF97 | `0x170110` | `cf97_sourceStreamReleaseHelper_slot4_ret2_350` | F8 boundary where 31-byte source stream is visible |
| CF98 | `0x170128` | `cf98_formatAllocString_slot4_fmt5_ret2_350` | header key/value string formatter |
| CF99 | `0x170188` | `cf99_formatDefaultStringToMemBlock_slot4_ret2_350` | empty/zero string defaults to `"0"` in observed run |
| CF100 | `0x1701D8` | `cf100_formatStringToMemBlock_slot4_fmt5_args6_8_350` | short header `%u-%s-%s` text builder |

Unknown or weakly proven CF entries intentionally keep conservative names like
`cfXX_nativeBinding_350` plus a Chinese comment. Do not promote those to business
names until a focused trace proves the slot ABI and output.

CF22/23/24 are now promoted only to their observed ABI names.  Their host
adapters take an explicit `HostSdkIdentity350` input: CF22 reads its Java value
per invocation, while CF23 and CF24 cache their independent native-style first
results.  This records the lifetime distinction without treating the local
`35.1.0` / `v04.09.05-ml-android` fixture as a universal device identity.

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
| `0x10BFD8` | `makeFilledMemBlock_len_byte_350` |
| `0x11BF94` | line comment only: `CF43 loc入口 / AES mode PKCS#7 body` |
| `0x11CAE0` | `cf43_modeInitDispatcher_350` |
| `0x11CBB4` | `cf43_modeProcessDispatcher_350` |
| `0x16CB88` | `cf41_cloneKeyPad32_thenSimonEncrypt_350` |
| `0x16CC84` | `packLow16ToMemBlockLE_350` |
| `0x0D9674` | `getTpidrEl0_350` |
| `0x123C94` | `cJSON_AddBoolToObjectFromField8_350` |
| `0x123DE8` | `cJSON_PrintUnformattedField8ToSharedMemBlock_350` |
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
- `unidbg-android/target/sign6_350101_cf71_tls_20260904.log` (`CF71`: `X0 == TPIDR_EL0` at helper return)
- static wrapper/decompiler chains for the cJSON quartet:
  `CF79 -> cJSON_AddNumberToObject_double`,
  `CF85 -> 0x123AF4 -> cJSON_AddStringToObject`,
  `CF87 -> 0x123C94 -> cJSON_AddBoolToObject`, and
  `CF88 -> 0x123DE8 -> 0x10CBF8`.

## 2026-09-04 cJSON quartet scope check

`CF79/85/87/88` are now documented and commented as one cJSON
write/serialize surface. The exact F5/X-Argus, F7/X-Ladon, and F13/X-Helios
trace intervals do not hit this quartet. It is present in the F8/X-Medusa
phase, so the four helpers must not be described as globally outside the
header-signing path: they are isolated from the Argus main signer but remain
an X-Medusa JSON/env branch to preserve during replay.

## 2026-09-04 string XOR / protobuf-wire update

This pass used and saved the matching IDB
`dyidre/materials/350101/libmetasec_ml.so.i64` (image base `0`). It received the eight wrapper renames above and
function comments at all eight wrappers, plus shared-engine comments at:

- `0x11615C` (`postDataCalcLen`): descriptor-backed wire-size engine;
- `0x1165B8` (`postDataWriteBuf`): descriptor-backed raw-buffer writer;
- `0x128D6C` (`postDataToBuf`): concrete caller that calculates size, resizes a
  MEM_BLOCK, records its `src_len`, then passes `body.mem` to the writer.
- `0x272080` and `0x274178`: F8/CF90-91 observed schema and its 24-entry
  descriptor table; comments record the local `0x299` size/write vector and
  explicitly distinguish process-local runtime pointers from module offsets.
- `0x271AD8` and `0x2723A8`: F5/CF31-33 observed schema and its 22-entry
  descriptor table; the field-15 descriptor points to nested schema
  `0x271980`, and comments record the local `0x91` size/write vector.

The four old `decryptString*` labels were narrowed to exact raw semantics:
`buf=slot4`, `len=(int32_t)slot5`, `buf[i] ^= key[i&7]`, return same `buf` in
slot2. There is no terminator or MEM_BLOCK processing inside those loops; the
readable strings from the focused trace are caller-path samples, not an ABI
requirement. Their key bytes are recorded in
`cf_string_decode_and_proto_serializer_350101.md` and covered by host
self-test vectors.

The CF31/33/90/91 names deliberately say `protoWire`, rather than claiming a
recovered official `.proto`: static code proves a dynamic
protobuf-wire-compatible descriptor serializer. The host runtime now has
explicitly bounded semantic adapters for F5 CF31/33 schema `0x271AD8` and F8
CF90/91 schema `0x272080`; both use `HostProtoWireMessage350`, never
fabricated native object memory. The deterministic local CF33 `0x91` fixture
(FNV-1a `cca2172f`, SHA-256
`cee115642ad18ce54df063a67c48262123edd9a688d68e2eb0d14393633b9d40`) and
CF91 `0x299` fixture (FNV-1a `fa8d2d9c`, SHA-256
`e165201118d59a72fc08af30a585fe563e29b8a3241f923f2dc9c58f6b50da6e`) are
byte-checked in the host self-test. Their nested bodies stay schema-anchored
opaque wire; raw trailing records, complete nested layouts, and native
lifecycle remain intentionally unimplemented, so this does not promote the
generic native ABI.

## 2026-09-04 CF00/01/02/03/58/63/64/75/78/82 follow-up

The same `dyidre/materials/350101/libmetasec_ml.so.i64` IDB was saved after
these evidence-bounded updates:

| address | IDA name / annotation scope |
|---:|---|
| `0x16EA70` | `cf00_make_filled_memblock_slot4_len5_byte6_350`: slot5 low32 is length; slot6 low8 is fill byte |
| `0x10BFD8` | `makeFilledMemBlock_len_byte_350`: preserves W1 length, moves W2 to W3 fill byte |
| `0x16EAC0` / `0x16B748` | `cf01_flattened_raw_buffer_abi_350` / `flattenedTransform_CF01_raw_buffer_350`: five raw buffer arguments, no slot2 result, and a distinct CF01 provider boundary; no direct local result vector |
| `0x16EB40` | `cf02_flattened_raw_buffer_abi_350`: five raw buffer arguments and no slot2 result; body remains provider-gated/unrecovered |
| `0x16EBC0` / `0x16C65C` | `cf03_rc4_residue_transpose_memblock_ref_350` / `cf03_rc4_residue_transpose_350`: hidden REF output, address-seeded RC4 and residue-major transpose; replay injects (but never dereferences) the captured temporary body address |
| `0x16F8F0` | `cf58_rc4_memblock_to_ref_350`: binary zero-warmup RC4, hidden REF output |
| `0x16FA34` / `0x153F80` | `cf63_second_module_f22_memblock_hash_350`: raw outer slot4 to child F22; 28-record body is read-only/no-CF and its exact u32 recurrence returns child slot2 low32 to outer slot2 |
| `0x16FA60` / `0x153ECC` | `cf64_second_module_f1_shared_frame_adapter_350` / `invoke_second_module_f1_shared_frame_350`: outer slots4/5/6/7 to child slots19/0/10/27; outer slot2 untouched. F1's 40 same-frame child-table dispatches are CF1/2/3/4/10/5/7/6/8 plus F2/F3×12/F19/F4..F18/F21/F20 (not primary module targets); direct raw stores and open transitive effects keep it opaque |
| `0x16FC94` / `0x17214C` | CF75 child-module F6 adapter: F6 clears hidden slot4 then uses flag-selected CF10/CF13 assignment. Nested F0--F7 static bodies are fully decoded (F3 writes result `0..15`; F4/F5/F0 change byte 16 flags), but CF15/source aliases/result tail/ownership are unclosed, so it remains opaque |
| `0x16FD2C` / `0x123B14` | CF78 raw C-string to ordered ID_ITEM wrapper ABI and empty-object fallback |
| `0x16FE08` / `0xD9574` | CF82 fixed `0x1EC670` VMP result to slot2; mutable `.bss` result remains replay-supplied |

CF03's KSA/PRGA and stride sites `0x16C85C`/`0x16C998`/`0x16CA5C`, and CF58's
KSA/PRGA helpers `0x1074FC`/`0x1075A0`, also carry comments. The CF01, CF02,
and CF64/CF75 annotations deliberately record effect boundaries without naming
an unrecovered transformation as if it were known. `0x15AB1C` is additionally
commented as the module-table form of `0x5e`; the primary CF table is not a
valid global interpretation of that opcode.

## Deliberately not renamed

The remaining `sub_16D9DC..sub_16E474` functions are flattened micro-blocks
inside `sm3Compress64_flattenedBlocks_350`, not CF/F entries. They should be
renamed only if we later split the SM3 flattened control-flow graph into named
round helpers.

## 2026-09-05 G-table naming and X-Argus/X-Medusa call-pack boundary

The same `dyidre/materials/350101/libmetasec_ml.so.i64` IDB was saved after
these evidence-bounded updates:

| address | IDA name / annotation scope |
|---:|---|
| `0x154328` | `managedModuleBuild_350` prototype: last binding pair renamed `program_table/program_count` -> `g_table/g_count`, matching the module-local `G` import-binding ledger (80/80 registration/import ABI closed) |
| `0x158F48` | `managedModuleDecodeBuild_350` prototype: same `g_table/g_count` rename (X6/W7 usercall args) |
| `0x1715F8` | F5/X-Argus bridge comment: X-Argus shares the `MetaSecManagedCallArg350` 0x60 full-call ABI via frame slot4; `MetaSecXArgusProtoWire92_350` documented as observed protobuf-wire view only, not a native fixed C layout |
| `0x171698` | F8/X-Medusa bridge comment: same shared 0x60 call pack via frame slot20 (not slot4); `MetaSecXMedusaFinalPack2C8_350` documented as final decoded output buffer layout only, not a call-argument extension |

Two new Local Types were imported: `MetaSecXArgusProtoWire92_350` (0x92 wire
bytes) and `MetaSecXMedusaFinalPack2C8_350` (0x2c8 final pack). Both are
deliberately annotated as observed byte-layout views; they must not be
promoted to call-pack struct fields without runtime write evidence.

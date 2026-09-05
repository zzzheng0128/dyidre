# 350.101 `X-*` header generation notes

Scope:

- SO/IDB: `douyin_35_0_0/libmetasec_ml.so.i64`
- public wrapper: `buildSignedHttpHeadersCallback_350` @ `0x14DBF4`
- inner signer: `buildSignedHttpHeadersInner_350` @ `0x149CA8`
- final container: `TREE_MAP`, serialized later as `key\r\nvalue\r\n`

Correction note (2026-08-31): earlier CF helper sequences in this report are
phase-level observations. They are still useful for material flow, but not all
events belong to the main F5/F8 bytecode body. For bytecode-record-accurate
alignment use `managed_vm_decode/*.decoded.stats.md`; the decoder now filters
runtime marks by `ManagedProgramBody350` metadata.

Readable pseudo-C reconstruction:

```text
dyidre/versions/350101/build_signed_http_headers_350_recovered.c
```

## Output observed

Clean unidbg runs already produce the same header family:

```text
X-Argus
X-Gorgon
X-Helios
X-Khronos
X-Ladon
X-Medusa
X-Soter
```

In the current logs, `X-Medusa` is the largest value:

- `sign6_350101_thread_clean_20260830_195236.log`: `X-Medusa` len `948`
- `sign6_350101_structtrace_clean_20260830_203122.log`: `X-Medusa` len `944`
- `sign6_350101_stagepack_shortfix_20260830_234025.log`: `X-Medusa` len `0x3b4`

The true-device GumTrace at `0x14A53C` copies about `0x3b1` bytes before `treeMapPut_350`.
The unidbg direct-callsite probe now confirms the key at `0x14A53C` is `X-Medusa`.

## Branch/rootfs-aligned one-request baseline

2026-08-31 用 Pixel6 350.101 真机 `.msdata/mssdk/ml` rootfs 重跑：

```text
log: unidbg/unidbg-android/target/sign6_350101_rootfs_xheaders_20260831_133245.log
rootfs: unidbg/unidbg-android/target/rootfs_pixel6_350101_20260831_132930
```

该日志的 VM multiset 已经贴到真机核心链：

```text
exeVMInner.vmCode={0x1ec670=2, 0x1ecaf0=1, 0x1f7860=1}
```

这个分支下 `0x149F60 -> 1`，`0x14A250 bit0=1`，所以 F5/F7 被跳过。
因此 `X-Argus` / `X-Ladon` 不是大包输出，而是早期 direct emit 的短值：

| hit | callsite | key | len | fnv1a | note |
|---:|---:|---|---:|---|---|
| 35 | `0x14D29C`, origin `0x14A1C0` | `X-Gorgon` | `0x34` | `712ca847` | native stage1 |
| 36 | `0x14D29C`, origin `0x14A210` | `X-Khronos` | `0x0a` | `d95aec4d` | native stage2/time |
| 37 | `0x14A2B0`, origin `0x14A2A0` | `X-Argus` | `0x08` | `affe94ed` | F5 skipped后的短值 |
| 38 | `0x14A320`, origin `0x14A308` | `X-Ladon` | `0x08` | `119c9a23` | F7 skipped后的短值 |
| 39 | `0x14A53C`, origin `0x14A52C` | `X-Medusa` | `0x3dc` | `f82b3857` | 当前大头，走 F8/原生 VMP/material |
| 40 | `0x14D30C`, origin `0x14A5A8` | `X-Helios` | `0x30` | `83fe60de` | F13 后处理 |
| 41 | `0x14A65C`, origin `0x14A64C` | `X-Soter` | `0x78` | `45c5ec43` | optional extra |

所以后续如果目标是还原当前真机 HTTP 分支，不要先追 F5/F7 的大
`X-Argus/X-Ladon`；应优先追：

1. `0x1EC670` / `0x1ECAF0`：F8 内 native binding 小 VMP；
2. `0x1F7860`：`0x12564C -> 0x124DD4` 的 mssdk material VMP；
3. `F8` / `F13` 的 managed bytecode：产出 `X-Medusa`、`X-Helios`、
   `X-Soter` 所需材料。

## Generation flow

1. `0x14DBF4 buildSignedHttpHeadersCallback_350`
   - Accepts wrapper string inputs (`s1/s2` style).
   - Normalizes them into internal CRLF key/value text.
   - Dispatches into the inner signer.

2. `0x149CA8 buildSignedHttpHeadersInner_350`
   - Validates `json_list`, `url`, `x-ss-stub`.
   - Extracts URL query/path pieces.
   - Reads `x-metasec-mode` from request `TREE_MAP`.
   - Looks up registry type `2`, which current trace maps to `ctx + 0x1e0` (`COOKIE_RISK2/op2`).

3. Native pre-sign stages:
   - `0x14A1AC signStage1_makeStubPieces_350`
   - `0x14A1FC signStage2_makeKeyPieces_350`

4. True-device early direct header insertion:
   - `0x14A2B0 treeMapPut_350`
     - true-device trace proves key is `X-Argus`
   - `0x14A320 treeMapPut_350`
     - true-device trace proves key is `X-Ladon`
   - In the branch/rootfs-aligned 350.101 path, these two offsets are hit with
     short 8-byte values because F5/F7 are skipped.
   - In non-aligned / alternate runtime state, `X-Argus`/`X-Ladon` may instead
     route through the small `treeMapPut_X22_X27_X28_350` wrapper at `0x14D290`,
     with true caller origins at `0x14A3A0` and `0x14A400`.

5. Managed sign stages:
   - `0x14A38C managedSignBuildA_350` -> program `F5`
   - `0x14A3EC managedSignBuildB_350` -> program `F7`
   - `0x14A468` computes CRC of intermediate tree/material and updates `kPskID`
   - `0x14A4E0 managedSignBuildFinal_350` -> program `F8`

6. Core signed-header insertion through wrapper:
   - `0x14D290 treeMapPut_X22_X27_X28_350`
     - wrapper body: `X0=X22 map`, `X1=X27 key`, `X2=X28 value`, tail-call `treeMapPut_350` at `0x14D29C`.
   - unidbg origin-aware direct-callsite probe confirms the true callers:
     - `0x14A1C0` -> `X-Gorgon`, len `0x34`
     - `0x14A210` -> `X-Khronos`, len `0x0a`
     - `0x14A3A0` -> `X-Argus`, len `0x104`
     - `0x14A400` -> `X-Ladon`, len `0x30`

7. Main final header insertion:
   - `0x14A53C treeMapPut_350`
   - unidbg direct-callsite probe confirms key is `X-Medusa`
   - observed value len is around `0x3b4`, matching the large Medusa output class.

8. Late managed emission/post stage:
   - `0x14A588 managedSignPostEmitF13_350`
   - `managedSignPostEmitF13_350` @ `0x1716F4` invokes `g_managedProg_sign_F13_350`
   - This runs after F8 and before optional `X-Soter`.

9. Additional signed-header insertion:
   - `0x14D300 treeMapPut_X22_X23_X24_350`
     - wrapper body: `X0=X22 map`, `X1=X23 key`, `X2=X24 value`, tail-call `treeMapPut_350` at `0x14D30C`.
   - unidbg origin-aware direct-callsite probe confirms true caller `0x14A5A8` writes `X-Helios`, len `0x30`.

10. Optional extra header insertion:
   - `0x14A65C treeMapPut_350`
   - true-device trace proves key is `X-Soter`
   - value is copied from `v308.seed_or_handle + 0x10`, length at `+0x0c` (`~0x78` in current run).

11. Success return:
   - `0x14A730` copies output `TREE_MAP` back through hidden `X8/out`
   - helper: `0x14D424 returnHeaderTreeViaX8_350`
   - helper body wraps `0x149C20 copyRefWithLock_350`

## Current callsite map

| Offset | Meaning | Confidence | Evidence |
|---:|---|---|---|
| `0x14A2B0` | insert `X-Argus` | high | true-device `strlen/memcpy` sees key `X-Argus`; registers before `treeMapPut_350`: `x1=key`, `x2=value` |
| `0x14A320` | insert `X-Ladon` | high | true-device `strlen/memcpy` sees key `X-Ladon`; registers before `treeMapPut_350`: `x1=key`, `x2=value` |
| `0x14F354` | parse raw request headers into input map | high | unidbg direct-callsite probe writes raw lowercase request headers: `cookie`, `x-ss-stub`, `x-tt-dt`, etc. |
| `0x14AE74` | copy normalized input headers into working map | high | unidbg direct-callsite probe writes uppercased/normalized request headers: `X-SS-STUB`, `X-TT-DT`, etc. |
| `0x14D29C` | `treeMapPut_X22_X27_X28_350` wrapper tail-call | high | wrapper receives map/key/value in X22/X27/X28; use LR origin to identify real header producer |
| `0x14A1C0` | insert `X-Gorgon` via `treeMapPut_X22_X27_X28_350` | high | origin-aware unidbg probe: PC=`0x14D29C`, origin=`0x14A1C0`, key=`X-Gorgon`, value len `0x34` |
| `0x14A210` | insert `X-Khronos` via `treeMapPut_X22_X27_X28_350` | high | origin-aware unidbg probe: PC=`0x14D29C`, origin=`0x14A210`, key=`X-Khronos`, value len `0x0A` |
| `0x14A3A0` | insert large-branch `X-Argus` via `treeMapPut_X22_X27_X28_350` | high for alternate branch | origin-aware probe in earlier non-aligned runs: PC=`0x14D29C`, origin=`0x14A3A0`, key=`X-Argus`, value len `0x104`; current rootfs-aligned branch skips this |
| `0x14A400` | insert large-branch `X-Ladon` via `treeMapPut_X22_X27_X28_350` | high for alternate branch | origin-aware probe in earlier non-aligned runs: PC=`0x14D29C`, origin=`0x14A400`, key=`X-Ladon`, value len `0x30`; current rootfs-aligned branch skips this |
| `0x14A53C` | insert `X-Medusa` | high | unidbg direct-callsite probe dumps key `X-Medusa`, value len `~0x3b4`; true-device copy length was `~0x3b1` |
| `0x14D30C` | `treeMapPut_X22_X23_X24_350` wrapper tail-call | high | wrapper receives map/key/value in X22/X23/X24; use LR origin to identify real header producer |
| `0x14A5A8` | insert `X-Helios` via `treeMapPut_X22_X23_X24_350` | high | origin-aware unidbg probe: PC=`0x14D30C`, origin=`0x14A5A8`, key=`X-Helios`, value len `0x30` |
| `0x14A65C` | insert `X-Soter` | high | true-device `strlen/memcpy` sees key `X-Soter`; value comes from `v308.seed_or_handle` MEM_BLOCK-like output |
| `0x120E5C` | report metric `consume_ML_DoHttpReqSignIT` | high | unidbg direct-callsite probe sees key `consume_ML_DoHttpReqSignIT` after signing |

## X-Argus/X-Ladon generation chain

The important correction is that `0x14D29C` is only a wrapper tail-call. The
generated header identity comes from the caller origin and from the `ptr/s`
output strings prepared before the wrapper copies them into `MEM_BLOCK`s.

The managed `F5/F7/F8/F13` programs execute bytecode through
`managedBytecodeRun_350` and call native helpers registered as `CF0..CF101`.
The current durable CF dictionary is:

```text
dyidre/versions/350101/managed_cf_semantics_350101.md
```

The argument-level material-flow report is:

```text
dyidre/versions/350101/x_argus_medusa_material_350101.md
```

High-impact helpers for header generation:

- `CF05/07/10/11/12/37/38/49`: MEM_BLOCK init/copy/free/concat material flow.
- `CF44`: Base64 output encoder.
- `CF61`: SM3 adapter
  (`sm3OneShot_F15InitUpdateFinal_350 -> managed F15 写 SM3 IV +
  64-byte update + final pad/len/emits 32-byte digest`).
- `CF79`: JSON numeric field writer.
- `CF31/33/54/86`: current true-device vs unidbg branch-diff anchors.

### Native pre-sign material

`0x14A1AC -> signStage1_makeStubPieces_350(0x16D204)` consumes
`MetaSecSignStage1Args350`:

```c
typedef struct MetaSecSignStage1Args350 {
    int64_t seed_or_handle;   // +0x00: var_248/sub_12D504 result
    MEM_BLOCK *x_ss_stub;     // +0x08
    MEM_BLOCK *url_or_path;   // +0x10: derived URL/query MEM_BLOCK
    uint16_t *short_code;     // +0x18
    char **out_ptr;           // +0x20
    char **out_str;           // +0x28
    int32_t mode;             // +0x30: parsed x-metasec-mode
} MetaSecSignStage1Args350;
```

Evidence inside `0x16D204`:

- reads `seed_or_handle`, `url_or_path`, `x_ss_stub`, `short_code`, `mode`;
- hashes/serializes source blocks through the `sub_1719xx` helpers;
- folds `short_code` at `0x16D35C`;
- converts bytes to hex and writes an allocated output string through
  `formatAllocString_350(out_str, ...)` at `0x16D3F8`.

`0x14A1FC -> signStage2_makeKeyPieces_350(0x16D454)` then consumes the smaller
stage2 pack:

```c
typedef struct MetaSecSignStage2Args350 {
    uint32_t seed;     // +0x00
    char **out_ptr;    // +0x08
    char **out_str;    // +0x10
} MetaSecSignStage2Args350;
```

It decrypts format strings and emits two C strings through `out_ptr/out_str`.
Those strings are then copied by helper thunks:

- `0x14D2F4 copyOutKeyStringToX27MemBlock_350`: `ptr` -> key `MEM_BLOCK` in X27
- `0x14D2E8 copyOutValueStringToX28MemBlock_350`: `s` -> value `MEM_BLOCK` in X28

This produces:

- `0x14A1C0` -> `X-Gorgon`
- `0x14A210` -> `X-Khronos`

### Managed sign pack

For the managed branch, `0x149CA8` builds stack packs and passes only the pack
pointer as slot4 into the managed wrapper. The wrapper functions do not know the
business semantics; they simply call the managed program handle.

F5/F8 use the full pack:

```c
typedef struct MetaSecManagedCallArg350 {
    int64_t seed_or_handle;        // +0x00
    JSON_LIST *json_list;          // +0x08
    MEM_BLOCK *x_ss_stub;          // +0x10
    MEM_BLOCK *url_or_path;        // +0x18
    MEM_BLOCK *aux_ref_mem;        // +0x20
    MEM_BLOCK *token_or_env_block; // +0x28
    void *bd_client_key_item;      // +0x30
    void *bd_client_key_value;     // +0x38
    int32_t request_type;          // +0x40
    char **out_key;                // +0x48: &ptr
    char **out_value;              // +0x50: &s
    int32_t metasec_mode;          // +0x58
    uint8_t final_flag;            // +0x5c, F8 path
} MetaSecManagedCallArg350;
```

Field stores in `buildSignedHttpHeadersInner_350`:

- `0x14A358`: load `json_list->json_list`
- `0x14A374`: helper fills `+0/+8/+0x10/+0x18`
- `0x14A378`: stores `+0x20/+0x28`
- `0x14A380`: stores output string slots `+0x48/+0x50`
- `0x14A388`: stores `+0x58 metasec_mode`
- `0x14A4B8..0x14A4DC`: repeats the same shape for F8 and also stores
  `+0x5c final_flag`

F7/F13 use a shorter pack rebuilt by `0x14D2B8`:

```c
typedef struct MetaSecManagedShortCallArg350 {
    int64_t seed_or_handle;    // +0x00
    MEM_BLOCK *derived_block;  // +0x08: v281.mem / derived URL material
    JSON_LIST *json_list;      // +0x10
    MEM_BLOCK *stack_memblock; // +0x18: &a2 prepared from JSON/env
    char **out_key;            // +0x20: &ptr
    char **out_value;          // +0x28: &s
} MetaSecManagedShortCallArg350;
```

Important: only the first `0x30` bytes of this short pack are freshly written.
Do not read stale bytes after `+0x30` as request type/mode unless a runtime
trace proves it.

Managed wrappers:

- `0x1715F8 managedSignBuildA_350`: slot4=`full_pack`, invokes `F5`
- `0x171648 managedSignBuildB_350`: slot4=`short_pack`, invokes `F7`
- `0x171698 managedSignBuildFinal_350`: slot20=`full_pack`, invokes `F8`
- `0x1716F4 managedSignPostEmitF13_350`: slot4=`short_pack`, invokes `F13`

F5/X-Argus 与 F8/X-Medusa 共用 `MetaSecManagedCallArg350` 的已闭合 `0x60`
调用包前缀；F8 的 slot20 与 `final_flag` 是调用约定差异，不构成 `+0x60` 的结构扩展。
因此旧 `HTTP_SIG_XArgus` / `HTTP_SIG_XMedusa` 只保留为历史命名线索，不能施加到本版本
F5/F8。作为输出材料视图，`MetaSecXArgusProtoWire92_350` 仅表示当前观测到的 protobuf
wire payload，`MetaSecXMedusaFinalPack2C8_350` 仅表示最终 decoded buffer；二者都不是
managed wrapper 的参数类型。

The managed program writes generated C strings into `arg_pack->out_key` and
`arg_pack->out_value`. Outer code then copies those strings and inserts them:

- `F5` output -> `0x14A3A0` -> `X-Argus`, len `0x104`
- `F7` output -> `0x14A400` -> `X-Ladon`, len `0x30`
- `F8` output -> `0x14A53C` -> `X-Medusa`, len around `0x3b4`
- `F13`-adjacent output -> `0x14A5A8` -> `X-Helios`, len `0x30`
- `0x14A65C` optional path -> `X-Soter`, len around `0x78`

Precise full-trace CF slicing:

| Program | Header output | Interval | CF events | Meaning |
|---|---|---:|---:|---|
| `F5` | `X-Argus` | `0x14A38C -> 0x14A3A0` | 143 | main Argus material pack, digest/concat/base64 |
| `F7` | `X-Ladon` | `0x14A3EC -> 0x14A400` | 31 | short-pack Ladon encode |
| `F8` | `X-Medusa` | `0x14A4E0 -> 0x14A53C` | 256 | largest environment/JSON collection and final Medusa encode |
| `F13` | `X-Helios`/Soter side | `0x14A588 -> 0x14A5A8` | 31 | short-pack post emission path |

### Latest unidbg stage-pack evidence

Run:

```text
unidbg/unidbg-android/target/sign6_350101_cfargs_20260830_235936.log
unidbg/unidbg-android/target/sign6_350101_cfpost_20260831_000758.log
```

Observed pack shape:

| Callsite | Program/stage | Pack | Key runtime fields | Output evidence |
|---:|---|---|---|---|
| `0x14A1AC` | native stage1 | `MetaSecSignStage1Args350` | run-specific seed, `x_ss_stub` len `0x10`, `url_or_path` is query string len `0x2c0`, `short_code=0x8`, `mode=0` | next write `0x14A1C0` -> `X-Gorgon`, len `0x34` |
| `0x14A1FC` | native stage2 | `MetaSecSignStage2Args350` | same seed, output slots `&ptr/&s` | next write `0x14A210` -> `X-Khronos`, len `0x0A` |
| `0x14A38C` | managed `F5` | full `MetaSecManagedCallArg350` | `json_list`, `x_ss_stub`, `url_or_path`, `aux_ref_mem`, `token_block`, `request_type=369`, `mode=0`, `final_flag=0` | `0x14A3A0` -> `X-Argus`, len `0x104` |
| `0x14A3EC` | managed `F7` | short `MetaSecManagedShortCallArg350` | `derived_block=\"1128\"`, `stack_memblock=\"1588093228\"`, output slots `&ptr/&s` | `0x14A400` -> `X-Ladon`, len `0x30` |
| `0x14A4E0` | managed `F8` | full `MetaSecManagedCallArg350` | same full-pack shape as F5, `final_flag=1` | `0x14A53C` -> `X-Medusa`, len `0x3b4` |
| `0x14A588` | managed `F13` | short `MetaSecManagedShortCallArg350` | same short-pack shape as F7 | `0x14A5A8` -> `X-Helios`, len `0x30`; `0x14A65C` -> `X-Soter`, len `0x78` |

The decisive correction is that the qwords after `+0x30` in the F7/F13 stack
area are leftovers from the earlier full pack. Treating those stale bytes as
`request_type/mode/final_flag` makes the structure look larger than it is and
causes bad version upgrades.

### Argument-level X-* material checkpoints

The `cfargs` run also hooked the most useful managed CF helpers and confirms the
actual material flow:

| Header | Managed/native source | Critical helper path | Stable shape |
|---|---|---|---|
| `X-Gorgon` | native stage1 at `0x14A1AC` | native `signStage1_makeStubPieces_350` | query len `0x2c0`, stub len `0x10`, output len `0x34` |
| `X-Khronos` | native stage2 at `0x14A1FC` | native `signStage2_makeKeyPieces_350` | output len `0x0a` |
| `X-Argus` | managed `F5` at `0x14A38C` | `CF61 -> CF38/CF10 -> CF61 -> ... -> CF61(0x44) -> CF44 -> CF98*2` | `CF44` input `src_len=0xc2`, `CF98` post key/value len `7/0x104` class |
| `X-Ladon` | managed `F7` at `0x14A3EC` | `CF100("%u-%s-%s") -> CF38*2 -> CF48 -> CF49 -> CF44 -> CF98*2` | short pack `"1128"` + `"1588093228"`; `CF100` post string shape `<seed-decimal>-1588093228-1128`; `CF48` text/key32 -> out32, `CF49` prefix4+out32 -> `0x24`, final len `0x30` |
| `X-Medusa` | managed `F8` at `0x14A4E0` | `CF61 -> CF07/CF10 -> CF79*8 -> CF61(0x44) -> CF07... -> CF44 -> CF98*2` | `final_flag=1`, JSON keys `cmr/cmr2/un_h/vpn/kd/fkd/pd/do`, `CF44` input `src_len=0x2c4/0x2c8` class, `CF98` post key/value len `8/0x3b0` class |
| `X-Helios` | managed `F13` at `0x14A588` | `CF100("%u-%s-%s") -> CF38*2 -> CF48 -> CF49 -> CF44 -> CF98*2` | short-pack shape like `X-Ladon`; `CF100` post string shape `<seed-decimal>-1588093228-1128`; `CF48/CF49` produce `0x24` binary pack; final len `0x30` |
| `X-Soter` | direct callsite `0x14A65C` | outside the `F13` return pair | final len `0x78` |

This gives a practical reproduction order:

1. make native stage1/stage2 agree (`X-Gorgon`, `X-Khronos`);
2. make `F5` agree until the `CF44` input length/bytes match (`X-Argus`);
3. make `F7` short-pack agree (`X-Ladon`);
4. make `F8` JSON/env material and final `CF44` input agree (`X-Medusa`);
5. then verify `F13`/direct `X-Soter`.

## Next trace probe

Use:

```text
dyidre/probes/350101/metasec_probe_350101.js mode=xheader
dyidre/probes/350101/run_metasec_probe_350101.sh xheader 90 <run_id>
```

It hooks `treeMapPut_350` at `0x11FC30`, filters by caller LR, and also hooks direct callsites because unidbg may miss the callee-entry hook. Current default direct callsites:

- `0x120E5C`
- `0x14A2B0`
- `0x14A320`
- `0x14A53C`
- `0x14A65C`
- `0x14AE74`
- `0x14D29C`
- `0x14D30C`
- `0x14F354`

Run used for current evidence:

```bash
./mvnw -pl unidbg-android \
  -Dmaven.test.skip=false -DskipTests=false \
  -Dtest=com.ss.android.ugc.aweme.Sign6_350101#testMetasec \
  -Dmetasec.dumpXHeaderPuts=true \
  -Dmetasec.xHeaderPutMaxEvents=120 \
  -Dmetasec.xHeaderPutMaxBytes=0x100 \
  test > unidbg-android/target/sign6_350101_xhdr_origin_20260830_231600.log 2>&1
```

Current conclusion:

- Raw input headers are parsed by `parseCrlfPairsToTree2_350` at `0x14F22C`; each pair is inserted at `0x14F354`.
- Normalized/uppercased working headers are inserted inside `j_doHttpX5` at `0x14AE74`.
- `X-Gorgon`, `X-Khronos`, `X-Argus`, `X-Ladon` are produced inside `buildSignedHttpHeadersInner_350`, then inserted via `treeMapPut_X22_X27_X28_350`.
- `X-Helios` is inserted via `treeMapPut_X22_X23_X24_350`.
- `X-Medusa` and `X-Soter` are direct `treeMapPut_350` calls at `0x14A53C` and `0x14A65C`.

For generation-input dumps in unidbg, enable:

```bash
-Dmetasec.dumpManagedSignPacks=true \
-Dmetasec.managedSignPackMaxEvents=32 \
-Dmetasec.managedSignPackMaxBytes=0x100
```

For managed-CF input and post-return dumps, enable:

```bash
-Dmetasec.dumpManagedCfArgs=true \
-Dmetasec.dumpManagedCfPost=true \
-Dmetasec.managedCfCallsites=0x16f998,0x16f544,0x170128,0x1701d8,0x16fd64,0x16f660,0x16f6b0 \
-Dmetasec.managedCfMaxBytes=0x100
```

`dumpManagedCfPost` hooks return offset `0x154550`, so `CF44/CF98/CF100`
outputs are visible after helper execution.

For short headers, `sign6_350101_cf48_cf49_20260831_005155.log` proves:

```text
CF100 text:  "1788108717-1588093228-1128"  // seed is dynamic
F7  CF49 pack36 -> base64 "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+"
F13 CF49 pack36 -> base64 "MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5"
```

The standalone CF48 oracle now reproduces both short headers byte-for-byte:

```bash
clang -std=c11 -Wall -Wextra -Werror \
  dyidre/versions/350101/cf48_f17_recovered_350101.c \
  -o /tmp/metasec_cf48_f17_350101
/tmp/metasec_cf48_f17_350101
```

Output:

```text
F7/X-Ladon ... out_match=true ... b64_match=true
F13/X-Helios ... out_match=true ... b64_match=true
failures=0
```

Default pack callsites:

- `0x14A1AC` native stage1 pack
- `0x14A1FC` native stage2 pack
- `0x14A38C` managed F5 pack, X-Argus
- `0x14A3EC` managed F7 pack, X-Ladon
- `0x14A4E0` managed F8 pack, X-Medusa/final
- `0x14A588` managed F13 pack, X-Helios/Soter side path

## IDA update status

Applied to 350 IDB:

- `0x149C20` -> `copyRefWithLock_350`
- `0x14D424` -> `returnHeaderTreeViaX8_350`
- `0x14D290` -> `treeMapPut_X22_X27_X28_350`
- `0x14D300` -> `treeMapPut_X22_X23_X24_350`
- `0x14D264` -> `newMemBlock24_350`
- `0x14D284` -> `newMemBlock24_loadOutputMapX22_350`
- `0x14D2E8` -> `copyOutValueStringToX28MemBlock_350`
- `0x14D2F4` -> `copyOutKeyStringToX27MemBlock_350`
- `0x14D370` -> `prepareManagedSignPackCommon_350`
- `0x1716F4` -> `managedSignPostEmitF13_350`

Key inline comments are now placed on their exact lines instead of one large function-head comment.

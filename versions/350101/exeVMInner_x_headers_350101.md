# 350.101 `exeVMInner` / `0x4CC10` in the `X-*` signing path

Scope:

- SO: `douyin_35_0_0/libmetasec_ml.so`
- HTTP/sign inner entry: `0x149CA8 buildSignedHttpHeadersInner_350`
- native VMP interpreter: `0x4CC10 exeVMInner`
- true-device trace: `dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log`
- static reference: `z/ws/mm64.cpp`

## Current conclusion

`0x4CC10 exeVMInner` is reached during the HTTP signing path, but it is not the
single function that directly returns all `X-*` headers.

The current true-device trace shows:

```text
0x149CA8 buildSignedHttpHeadersInner_350
  -> early/native + managed stages generate and insert:
       X-Gorgon
       X-Khronos
       X-Argus
       X-Ladon

  -> later managed/native helpers call native VMP wrappers
       wrapper -> 0x4CC10 exeVMInner

  -> late output insertion:
       X-Medusa
       X-Helios
       X-Soter
```

Timeline evidence from `gumtrace_getHttpHeadVerify_350.log`:

```text
105992   0x14A1C0 -> X-Gorgon insertion path
110049   0x14A210 -> X-Khronos insertion path
111410   "X-Argus"
113738   "X-Ladon"

3940163  0x4CC10 exeVMInner hit #1
3957565  0x4CC10 exeVMInner hit #2
4991324  0x4CC10 exeVMInner hit #3
5442752  0x4CC10 exeVMInner hit #4, heavy program

10469669 0x14A53C -> X-Medusa insertion path
10614490 0x14A5A8 -> X-Helios insertion path
10617661 "X-Soter"
10617763 0x14A65C -> X-Soter insertion path
```

So the current working model is:

- `X-Argus` and `X-Ladon` are produced by managed `F5/F7` and inserted before
  the observed native VMP hits.
- `X-Medusa` is produced by managed `F8` plus late material handling.
- `exeVMInner` protects subroutines/material builders used by the managed/native
  helper layer. The heavy fourth hit returns a list/object used by caller-side
  key matching and value extraction.

## `exeVMInner` ABI

The reconstructed C-side shape from `z/ws/mm64.cpp` is:

```c
void exeVMInner(
    PhoneInfo *phone,
    uint32_t *vmCode_ptr,
    uint64_t pParamList,
    uint32_t *vmData1,
    uint32_t *vmData2,
    VmParam64 *vmParam
);
```

In the real 350.101 so the native ABI is:

```text
X0 = vmCode_ptr
X1 = pParamList / stack argument window / result window
X2 = vmData1
X3 = vmData2
X4 = VmParam64*
```

`VmParam64` is passed on the wrapper stack:

```c
typedef struct VmParam64_350 {
    void *funBridge;       // +0x00 native bridge called from VM
    void *stack_end;       // +0x08 VM stack end / guard-ish bound
    void *save_LR;         // +0x10 native return sentinel
} VmParam64_350;
```

The VM uses `save_LR` as its termination sentinel: when VM control resolves back
to the saved native LR, `exeVMInner` exits and returns to the wrapper.

## True-device `0x4CC10` hits

Runtime module base for this trace:

```text
0x7102c04000
```

| Hit | Path into `0x4CC10` | VM code | VM data | Parameter window | Observed output |
|---:|---|---:|---:|---|---|
| 1 | `0x15454C -> 0x15281C -> 0xD9574 -> 0x4CC10` | `0x1EC670` | `0x262980`, `0x2629C0` | wrapper `SP+8` | wrapper returns `W0 = [SP+8]`, observed pointer-like `0x71AC15A0` |
| 2 | `0x15454C -> 0x152864 -> 0xD95F4 -> 0x4CC10` | `0x1ECAF0` | `0x262A00`, `0x262A20` | wrapper `SP+8` | wrapper returns `W0 = 0` |
| 3 | `0x16FE10 -> 0xD9574 -> 0x4CC10` | `0x1EC670` | `0x262980`, `0x2629C0` | wrapper `SP+8` | same small VM program as hit #1 |
| 4 | `0x16F2DC -> 0x12564C -> 0x124DD4 -> 0x4CC10` | `0x1F7860` | `0x26F2E0`, `0x26F300` | wrapper `SP` with four incoming qwords | heavy object/list output written through caller out-ref |

The first three are short helper-style VMP programs. The fourth is the important
large one on the current HTTP path.

## Static wrapper shapes

### `0xD9574` small VM wrapper

```text
0xD95A8  X0 = 0x1EC670
0xD95AC  X2 = 0x262980
0xD95B0  X3 = 0x2629C0
0xD95B4  X1 = SP + 0x8
0xD95B8  X4 = SP + 0x10
0xD95C0  [SP+0x10] = 0xD9980    // funBridge
         [SP+0x18] = stack_end
0xD95C4  [SP+0x20] = LR          // save_LR
0xD95C8  BL 0x4CC10
0xD95CC  W0 = [SP+0x8]
```

### `0xD95F4` small VM wrapper

```text
0xD9628  X0 = 0x1ECAF0
0xD962C  X2 = 0x262A00
0xD9630  X3 = 0x262A20
0xD9634  X1 = SP + 0x8
0xD9638  X4 = SP + 0x10
0xD9640  [SP+0x10] = 0xD9980    // funBridge
         [SP+0x18] = stack_end
0xD9644  [SP+0x20] = LR          // save_LR
0xD9648  BL 0x4CC10
0xD964C  W0 = [SP+0x8]
```

### `0x124DD4` heavy VM wrapper

This wrapper is called by `0x12564C`. It preserves four incoming qwords into the
VM parameter window, then runs the `0x1F7860` VM program:

```text
0x124E00  [SP+0x00] = incoming X8    // caller out-ref
          [SP+0x08] = incoming X0
0x124E04  [SP+0x10] = incoming X1
          [SP+0x18] = incoming X2

0x124E14  X0 = 0x1F7860              // vmCode
0x124E18  X2 = 0x26F2E0              // vmData1
0x124E1C  X3 = 0x26F300              // vmData2
0x124E20  X1 = SP                    // pParamList
0x124E24  X4 = SP + 0x20             // VmParam64
0x124E28  [SP+0x20] = 0x129B24       // funBridge
          [SP+0x28] = stack_end
0x124E2C  [SP+0x30] = LR             // save_LR
0x124E30  BL 0x4CC10
```

Runtime values for the fourth hit:

```text
incoming to 0x124DD4:
  X8 = 0x7106ee5ee0       // out-ref from 0x12564C, caller SP+0x40
  X0 = 0x7106ee5ed0       // first MEM_BLOCK-ish input
  X1 = 0x7106ee5ec0       // second MEM_BLOCK-ish input / selector side
  X2 = 0x73a728a9f8       // extra object/ref

call into exeVMInner:
  X0 = 0x7102dfb860       // base + 0x1F7860
  X1 = 0x7106ee56c0       // wrapper SP / pParamList
  X2 = 0x7102e732e0       // base + 0x26F2E0
  X3 = 0x7102e73300       // base + 0x26F300
  X4 = 0x7106ee56e0       // VmParam64

VmParam64:
  [X4+0x00] = 0x7102d29b24    // base + 0x129B24 funBridge
  [X4+0x08] = 0x7106ee5e70    // stack_end
  [X4+0x10] = 0x7102d296ac    // base + 0x1256AC saved LR
```

## How the fourth VM result is consumed

`0x12564C` prepares two input blocks, calls `0x124DD4`, then reads the object
that the VM wrote into its out-ref:

```text
0x12564C(...)
  x19 = incoming X8          // final destination ref
  x20 = incoming X1          // selector key to match
  x21 = incoming X0          // source struct with blocks at +0x08/+0x48/+0x28

  copy x21+0x08 -> SP+0x30
  copy x21+0x48 -> SP+0x20

  X8 = SP+0x40              // out-ref for 0x124DD4 / VM
  X0 = SP+0x30
  X1 = SP+0x20
  X2 = x21+0x28
  BL 0x124DD4

  X8  = [SP+0x40]           // object returned by VM
  X23 = [X8+0x08]           // vector/list
  count = [X23+0x58]
  array = [X23+0x60]

  for each item in array:
      key_string   = [item+0x18]
      value_string = [item+0x20]
      if key_string == selector:
          dst = new MEM_BLOCK(value_string)
          setObjectAddRef_5(final_destination, dst)
```

Observed runtime object flow after the fourth VM call:

```text
VM writes out-ref at 0x7106ee5ee0:
  [out+0x00] = 0x744732f870
  [out+0x08] = 0x744732dbf0

caller then reads:
  object        = [SP+0x40]        = 0x744732f870
  vector/list   = [object+0x08]    = 0x73b72d27c0
  item count    = [vector+0x58]    = 2
  item array    = [vector+0x60]    = 0x744732f0b0
```

The caller tries two entries. First compare fails, second compare succeeds. On
the successful entry, the value string observed in the trace is:

```text
jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU=
```

Length observed by `strlen`:

```text
0x2c
```

This is a late material/value selected from the VM-returned table. Do not label
it as the final `X-Medusa` or final `X-Soter` until the caller chain proves the
destination header key.

## How `exeVMInner` runs internally

The internal VM model matches the old reconstructed C++ style:

1. The wrapper provides `vmCode`, `vmData1`, `vmData2`, `pParamList`, and
   `VmParam64`.
2. `exeVMInner` creates VM stack/register state.
3. It fetches 32-bit virtual words from `vmCode`.
4. Low six bits are the primary opcode:

   ```c
   uint32_t word = *vm_pc++;
   uint32_t op = word & 0x3f;
   ```

5. The dispatcher chooses a handler and jumps with `BR X8`.
6. Handlers update virtual registers, memory, or VM-PC.
7. VM exits when control reaches the native saved-LR sentinel supplied in
   `VmParam64.save_LR`.

Evidence from focused `gumtrace_4cc10.log` decoded by
`dyidre/skills/metasec_vm_trace_decoder.py`:

```text
vm_word_reads_stream: 242
br_x8_dispatches:     371

opcodes seen in the small 0x1EC670 program:
  0x01  0x0b  0x0d  0x0f  0x10  0x11  0x13  0x14
  0x16  0x18  0x1a  0x2d  0x2e  0x30  0x34  0x3b  0x3e
```

Important caution: that focused trace starts at VM page `base+0x1EC000`, so it
matches the small `0x1EC670` program, not necessarily the heavy HTTP fourth hit
at `0x1F7860`.

## What "analyzing the VM" means

This is not only "remove junk instructions".

There are three different layers:

### Layer 1: de-junk / de-obfuscate native control flow

Goal: make IDA show the wrapper/interpreter more cleanly.

Examples in this SO:

- opaque predicates and impossible branches around `0x12564C`;
- native basic blocks that end in strange `BR X8`;
- misleading instruction/data interleaving that makes Hex-Rays produce ugly
  pseudo-C or stop at inline asm.

This layer answers:

```text
Which native blocks are real?
Which branches are fake?
Where is the real call to 0x4CC10?
```

But this layer does not recover the protected algorithm. It only cleans the
native shell.

### Layer 2: decode the VM bytecode stream

Goal: understand what the virtual program is doing.

For `exeVMInner`, the real business lives in `vmCode`:

```text
0xD9574  -> vmCode 0x1EC670
0xD95F4  -> vmCode 0x1ECAF0
0x124DD4 -> vmCode 0x1F7860
```

`0x4CC10` itself is just the interpreter. Different wrappers feed different
virtual programs into the same interpreter.

This layer answers:

```text
What virtual opcodes exist?
Which handler implements load/store/branch/call/crypto/helper?
What VM registers/stack slots are read and written?
How does pParamList flow into VM registers?
How does the VM write the result back?
```

Current state:

- we already know low six bits are the primary opcode class: `op = word & 0x3f`;
- focused `0x1EC670` trace has decoded 17 opcode families;
- the heavy HTTP program is `0x1F7860`, and needs its own focused trace/page
  decode before we can claim its exact virtual instruction sequence.

### Layer 3: reimplement / devirtualize the VM program

Goal: turn the VM behavior into reproducible C/Python/Rust logic.

There are two forms:

1. Interpreter reimplementation:

   ```text
   write our own exeVMInner-compatible interpreter
   feed vmCode/vmData/pParamList
   get the same output object/string
   ```

2. Devirtualized business-code reconstruction:

   ```text
   translate one vmCode program, for example 0x1F7860,
   into readable pseudo-C:

   input MEM_BLOCK A/B + selector
     -> decode/build table
     -> return vector/list of key/value items
   ```

For the current HTTP path, the useful end state is the second one: not just
"run a VM", but recover the protected helper as normal-looking code.

## What the current heavy VM actually did

For the fourth hit, the evidence-backed behavior is:

```text
0x12564C
  prepares two MEM_BLOCK-ish inputs from source struct
  passes them plus an extra ref into 0x124DD4

0x124DD4
  builds pParamList on stack
  runs exeVMInner with vmCode 0x1F7860

0x4CC10 / vmCode 0x1F7860
  writes an output ref pointing to an object/list

0x12564C
  reads returned object
  gets vector/list count = 2
  iterates items
  compares item+0x18 key against selector
  copies matching item+0x20 value into final output ref
```

So this VM program is currently best named:

```text
nativeVmpBuildMssdkMaterial_350
```

It is closer to "protected table/material builder + selector lookup" than to
"direct X-Argus/X-Medusa generator".

## First devirtualized result for `vmCode=0x1F7860`

The fourth true-device hit was sliced out and decoded as a standalone VM run:

```text
dyidre/versions/350101/vm_lift_1f7860/gumtrace_1f7860_slice.log
dyidre/versions/350101/vm_lift_1f7860/gumtrace_1f7860_3pages.vmtrace.asm
dyidre/versions/350101/vm_lift_1f7860/native_vmp_1f7860_recovered.c
```

Trace window:

```text
source log:  dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log
slice lines: 5442700..5782910
entry:       0x124DD4 -> 0x4CC10
return:      0x1256AC
vmCode:      0x1F7860
vmData1:     0x26F2E0
vmData2:     0x26F300
```

Three bytecode pages are needed for this run:

```text
vm pages:
  0x7102dfb000
  0x7102dfc000
  0x7102dfd000

stream VM words: 1134
BR X8 dispatches: 5437
```

Observed opcode families in this one run:

| op | Count | Current decode note |
|---:|---:|---|
| `0x00` | 2 | `LD16S`: `dst = *(int16_t *)(src+simm16)` |
| `0x01` | 31 | no-op / helper state-ish, still needs interpreter branch naming |
| `0x0d` | 1 | `ADD64_IMM`: `dst = src+simm16` |
| `0x0f` | 102 | conditional VM branch/control family |
| `0x10` | 4 | bitfield/extract/insert/rev family |
| `0x11` | 285 | VM call/jump with link `v31 = pc+8` |
| `0x14` | 7 | `ST16`: `*(src+simm16)=dst.u16` |
| `0x16` | 29 | unaligned 32-bit store/merge variant |
| `0x18` | 279 | 350-specific high-frequency handler; exact semantic still version-verify |
| `0x1a` | 301 | conditional VM branch/control family |
| `0x21` | 6 | `LD8U`: `dst = *(uint8_t *)(src+simm16)` |
| `0x28` | 4 | `ADD64_IMM`: `dst = src+simm16` |
| `0x2b` | 11 | `LD32S`: `dst = *(int32_t *)(src+simm16)` |
| `0x2d` | 35 | conditional VM branch/control family |
| `0x30` | 4 | `LD16U`: `dst = *(uint16_t *)(src+simm16)` |
| `0x34` | 3 | helper/control family, still unnamed |
| `0x35` | 3 | unknown |
| `0x3b` | 27 | `ST64`: `*(src+simm16)=dst.u64` |

Decoder correction note:

- The first trace decoder had several guessed labels (`0x11` as load,
  `0x30` as store, etc.).  After comparing with `z/ws/vm64.cpp`, the stable
  load/store/add/control families above were corrected in
  `dyidre/skills/metasec_vm_trace_decoder.py`.
- `0x18/0x34/0x35` are still intentionally conservative: they are observed in
  the 350 trace, but should not be over-named until their exact 350 handler
  blocks are checked in IDA.

The VM run makes many heap/helper calls, but the business signal is small:

```text
__memcpy_aarch64_simd  79
malloc                 55
free                   35
pthread_mutex_lock     25
pthread_mutex_unlock   26
__memset_aarch64        7
__strlen_aarch64        1
```

### Recovered output object

After `0x1F7860` returns, the out-ref contains:

```text
out_ref @ 0x7106ee5ee0:
  +0x00 = 0x744732f870  // NativeVmpResultObject350*
  +0x08 = 0x744732dbf0  // ref-count ptr, value becomes 1

NativeVmpResultObject350 @ 0x744732f870:
  +0x00 = 0x7102e732c8  // vtable/template
  +0x08 = 0x73b72d27c0  // MetaSecMssdkMaterial350*
```

The material object at `0x73b72d27c0` has the following proven fields:

```c
typedef struct MetaSecMssdkMaterial350 {
    void *template_or_schema;          // +0x00
    uint64_t field_08;                 // +0x08
    uint64_t field_10;                 // +0x10
    uint32_t seed_id;                  // +0x18, observed 0x20200924
    uint32_t field_1c;                 // +0x1c
    char *module_name;                 // +0x20, "mssdk"
    char *app_id;                      // +0x28, "1588093228"
    uint32_t enabled;                  // +0x30, 1
    uint32_t field_34;                 // +0x34
    char *sdk_version;                 // +0x38, "1128"
    uint32_t salt_id;                  // +0x40, observed 0x5fa25885
    uint32_t field_44;                 // +0x44
    uint64_t app_info_count;            // +0x48, observed 1
    MetaSecMssdkAppInfo350 **app_infos;// +0x50
    uint64_t kv_count;                 // +0x58, observed 2
    MetaSecMssdkKeyValue350 **kv_items;// +0x60
    uint64_t field_68;                 // +0x68
} MetaSecMssdkMaterial350;             // observed size 0x70
```

The list-like part is not guessed; it is proven by writes and caller reads:

```text
L323635/L323726: material+0x58 count increments to 2
L323886:         material+0x60 = 0x744732f0b0
L325844:         kv_items[0] = 0x734747a050
L326496:         kv_items[1] = 0x73474f9f10
```

Each key/value item is:

```c
typedef struct MetaSecMssdkKeyValue350 {
    void *template_or_schema; // +0x00
    uint64_t field_08;       // +0x08
    uint64_t field_10;       // +0x10
    char *key;               // +0x18
    char *value;             // +0x20
} MetaSecMssdkKeyValue350;   // observed size 0x28
```

Runtime values:

```text
item[0]:
  key   = "common_key"
  value = "y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY="

item[1]:
  key   = "sign_key"
  value = "jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU="
```

### Recovered serialized material

The trace exposes the complete protobuf-like buffer before it is freed:

```text
08 c8 a4 80 82 04
12 05 6d 73 73 64 6b
1a 0a 31 35 38 38 30 39 33 32 32 38
20 01
2a 04 31 31 32 38
30 8a e2 92 fa 0b
3a 3c 0a 18 63 6f 6d 2e 73 73 2e 61 6e 64 72 6f 69 64 2e 75 67 63 2e 61 77 65 6d 65
      12 20 41 45 41 36 31 35 41 42 39 31 30 30 31 35 30 33 38 46 37 33 43 34 37 45 34 35 44 32 31 34 36 36
42 3a 0a 0a 63 6f 6d 6d 6f 6e 5f 6b 65 79
      12 2c 79 39 62 30 78 43 59 72 42 2b 2b 53 6c 73 73 2b 41 65 43 43 6d 71 67 2f 37 78 69 4e 7a 71 43 43 7a 5a 32 70 59 4c 6a 47 67 56 59 3d
42 38 0a 08 73 69 67 6e 5f 6b 65 79
      12 2c 6a 72 33 36 4f 41 62 73 78 63 37 6e 6c 43 50 6d 41 70 37 59 4a 55 43 38 49 68 69 37 66 71 37 33 48 4c 61 52 39 36 71 4b 6f 76 55 3d
```

Decoded shape:

```protobuf
message MetaSecMssdkMaterialProto350 {
  sint32 seed_id     = 1;  // serialized 1077940808, object stores 0x20200924
  string module_name = 2;  // "mssdk"
  string app_id      = 3;  // "1588093228"
  int32  enabled     = 4;  // 1
  string sdk_version = 5;  // "1128"
  sint32 salt_id     = 6;  // serialized 3208950026, object stores 0x5fa25885
  AppInfo app_info   = 7;  // package + 32-byte ASCII material
  KeyValue kv        = 8;  // repeated common_key/sign_key
}

message AppInfo {
  string package_name = 1; // "com.ss.android.ugc.aweme"
  string material     = 2; // "AEA615AB910015038F73C47E45D21466"
}

message KeyValue {
  string key   = 1;
  string value = 2;
}
```

The `seed_id` and `salt_id` are serialized as `value << 1`, which is why the
object fields are exactly half of the on-wire varints:

```text
0x20200924 << 1 = 0x40401248 = 1077940808
0x5fa25885 << 1 = 0xbf44b10a = 3208950026
```

### Pseudo-C result

The useful devirtualized body is now:

```c
static MetaSecMssdkMaterial350 *vm_1f7860_build_mssdk_material(...)
{
    m->seed_id = 0x20200924;
    m->module_name = strdup("mssdk");
    m->app_id = strdup("1588093228");
    m->enabled = 1;
    m->sdk_version = strdup("1128");
    m->salt_id = 0x5fa25885;

    m->app_info_count = 1;
    m->app_infos[0] = {
        .package_name = "com.ss.android.ugc.aweme",
        .material = "AEA615AB910015038F73C47E45D21466",
    };

    m->kv_count = 2;
    m->kv_items[0] = {"common_key",
        "y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY="};
    m->kv_items[1] = {"sign_key",
        "jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU="};
    return m;
}
```

Full pseudo-C is in:

```text
dyidre/versions/350101/vm_lift_1f7860/native_vmp_1f7860_recovered.c
```

### How this participates in X header generation

At this point, the safest naming is:

```text
0x124DD4 nativeVmpBuildMssdkMaterial_350
0x12564C selectValueFromNativeVmpMaterial_350
```

Reason:

- `0x124DD4/vmCode=0x1F7860` builds the material object and key/value table.
- `0x12564C` selects `common_key` or `sign_key` by caller-provided selector.
- Later managed/native signing stages can consume those values to build final
  header material.

Do not rename `0x124DD4` as `buildXArgus` or `buildXMedusa`: in the current
trace, `X-Argus`/`X-Ladon` were already inserted before this heavy native VMP
hit, and `X-Medusa`/`X-Helios`/`X-Soter` are inserted later by different stages.

## Practical upgrade checklist

When moving to another version:

1. Find all direct `BL 0x4CC10` callsites.
2. For each callsite, walk backward inside the wrapper to recover:
   - `X0 = vmCode`
   - `X2 = vmData1`
   - `X3 = vmData2`
   - `X1 = pParamList`
   - `X4 = VmParam64`
   - `[X4+0] funBridge`
   - `[X4+8] stack_end`
   - `[X4+0x10] save_LR`
3. Group wrappers by `vmCode` offset; same `vmCode` means same protected VM
   program even if the caller changes.
4. For HTTP signing, do not search only for `0x4CC10`. First anchor:
   - `buildSignedHttpHeadersInner`
   - `treeMapPut` origins for `X-*`
   - managed `F5/F7/F8/F13`
   - then native VMP wrappers reached below those helpers.
5. For a heavy wrapper like `0x124DD4`, dump:
   - pParamList before `BL 0x4CC10`
   - out-ref before and after return
   - returned object `[obj+0x08]`
   - vector `[+0x58]` count and `[+0x60]` array
   - each item `[+0x18]` key and `[+0x20]` value
6. Only name the VM program after proving which caller consumes its output.

Current candidate names:

```text
0xD9574  nativeVmpSmallHelperA_350
0xD95F4  nativeVmpSmallHelperB_350
0x124DD4 nativeVmpBuildMssdkMaterial_350
0x12564C selectValueFromNativeVmpMaterial_350
0x4CC10  exeVMInner_350
```

Chinese IDA comments to use:

```text
0x4CC10  【native VMP 解释器】真正业务由 wrapper 的 vmCode 决定；X0=vmCode, X1=参数窗口, X2/X3=数据区, X4=VmParam64。
0x124DD4 【VMP wrapper】把 out-ref / 两个 MEM_BLOCK / extra ref 塞到 SP 参数窗口，运行 vmCode=0x1F7860，构造 mssdk material 对象。
0x12564C 【VMP material 选择器】读取 VM 返回的 mssdk material，按传入 key 匹配 item+0x18，命中后把 item+0x20 复制到输出 ref。
```

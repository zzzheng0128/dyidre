# 350.101 native `exeVMInner` runtime scaffold

`native_vmp_runtime.py` is the reusable base for turning the native VMP at
`libmetasec_ml.so+0x4CC10` into an interpreter.  It does **not** label unknown
handlers as implemented.  Its current role is to keep three concerns separate:

1. instruction decoding is shared with `dyidre/skills/metasec_vm_trace_decoder.py`;
2. trace coverage states exactly which opcode semantics remain unimplemented;
3. the interpreter can execute only evidence-backed load/store/arithmetic and
   direct-link instructions, failing loudly on every other opcode unless a
   handler bridge is supplied.

VM memory is also explicit: `LD32S`, `LD64`, and `LD8U` reject a read with
even one unmapped byte (`UnmappedVmMemory`) instead of silently treating
unknown host/input data as zero.  Populate every input byte needed by a replay
before stepping it.

Run its regression and inventory the heavy program:

```bash
python3 dyidre/versions/350101/vm_generic_350101/native_vmp_runtime.py --selftest

python3 dyidre/versions/350101/vm_generic_350101/native_vmp_runtime.py \
  --trace dyidre/versions/350101/vm_lift_1f7860/gumtrace_1f7860_slice.log \
  --vm-page 0x7102dfb000 --vm-page 0x7102dfc000 --vm-page 0x7102dfd000 \
  --coverage-out dyidre/versions/350101/vm_generic_350101/coverage_1f7860.json
```

For replay code, construct the program image from explicit code pages rather
than hand-copying a word dictionary:

```python
runtime = NativeVmpRuntime350.from_trace(trace_path, [page0, page1, page2])
state = VmState(code_base=entry_program_base)
```

`from_trace()` refuses a page set where one VM PC produced conflicting words,
so self-modifying code or an accidental data page cannot silently turn into a
different program image.

The coverage report is the implementation queue. For every unsupported opcode
or `0x11` selector, capture handler-side virtual-register and memory deltas,
add a narrowly scoped implementation or bridge, then replay against the same
trace before using it for another `vmCode`.

For the supplied `0x1F7860` capture, the report now contains 8,058 real
32-bit word reads and 1,132 unique/collapsed `(vm_pc, word)` entries. All
1,132 are supported by the current runtime. This is exact coverage of this
captured stream—not a claim that another VM program, build, or unseen selector
is supported.

`0x11` is deliberately selector-gated. The `0x1F7860` trace reaches only `03`
(SLL32S), `0e` (ADD64), `1d` (XOR64), `1e` (JMP_REG), `2b` (signed LT), `2c`
(OR64), and `32` (CALL_REG); a separate current GumTrace of `vmCode=0x1ec670`
also proves `17` (SLL64). Every other selector raises `UnsupportedOpcode`
unless the caller explicitly supplies an opcode bridge. The two register-PC
selectors model their ordinary VM-PC path only; native host/interpreter escape
handling is intentionally outside this portable state model.

The current handler ledger also corrects older assumptions: `0x16` is an
ordinary 32-bit store with custom fields, rather than an unaligned merge;
`0x18`/`0x1a` are scattered-field `LD64`/`ST64` with distinct offset layouts;
and `0x0f`, `0x10`, `0x21`,
`0x28`, `0x2b`, `0x30`, `0x34`, `0x35`, and `0x3b` have their current static
handler semantics implemented.

`0x0b`, `0x13`, `0x2e`, and `0x3e` are separately recovered from the latest
local generic-VM trace. They are two complementary 32-bit and 64-bit
alignment-dependent masked-store pairs, not the older generic labels. All are
executable for their evidence-backed normal paths, but none is part of the
`0x1F7860` coverage count below.

With its explicit VM page `0x6ffbcb6000`, the latest local generic-VM trace
contains 484 raw word fetches and 242 unique/collapsed stream words. All 242
are now implemented; this is a separate local-trace result and does not alter
the `0x1F7860` evidence claim.

## Explicit static spans and small-helper exit

Static code inventory is deliberately separate from trace coverage. Supply an
already-established file mapping and an exact byte span; the tool will not
assume that an ELF virtual address is a file offset:

```bash
python3 dyidre/versions/350101/vm_generic_350101/native_vmp_runtime.py \
  --static-image dyidre/materials/350101/libmetasec_ml.so \
  --static-file-offset 0x1ecaf0 --static-vm-code 0x1ecaf0 \
  --static-byte-count 0x244 \
  --static-coverage-out dyidre/versions/350101/vm_generic_350101/coverage_static_1ecaf0.json
```

For the supplied 350.101 image, the first load segment establishes the
file-offset/VM-address equality for these two short programs only:

| VM program | exact span | words | result |
|---|---|---:|---|
| `0x1ec670` | `[0x1ec670, 0x1ecaf0)` | 288 | 288/288 selector-gated words implemented |
| `0x1ecaf0` | `[0x1ecaf0, 0x1ecd34)` | 145 | 145/145 selector-gated words implemented |

The second boundary is not a heuristic: its final word at `+0x240` is
`0x07c00791` (`op11.1e`, `pc = v31`), and the byte at `+0x244` begins
non-code data. The generated reports pin both image and span hashes. They are
syntactic inventories, not reachability, ABI, or dynamic-execution claims.
Each opcode row also carries `implemented_word_count` and
`unsupported_word_count`, so a mixed `op11` selector group cannot be mistaken
for an all-or-nothing opcode count.

### Package-check static candidate, deliberately not a wrapper ABI

The integrity package-check callsite provides one additional, narrower static
candidate. It can be revalidated offline without starting a process or
executing VM code:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 \
  dyidre/versions/350101/vm_generic_350101/native_vmp_runtime.py \
  --validate-package-check-static-candidate-350 \
  dyidre/materials/350101/libmetasec_ml.so
```

This first pins the complete SO to the known 350.101 size/SHA-256 and then
checks the callsite-bounded `0x1ea850..0x1ec4d0` span: code hash, 1,824 words,
1,807 implemented selector-gated words, the 17 unsupported-word breakdown,
and the zero terminal word at `0x1ec4cc`. Its machine-readable report keeps
the generic static-span rows and adds an explicit evidence boundary.

It is intentionally absent from `KNOWN_NATIVE_VMP_WRAPPERS_350`: static
callsite provenance does not close a wrapper stack/pParam layout, result ABI,
callback arity or return type, dynamic reachability, or guard-memory side
effects. The validator does not allocate pParam, emulate the tail bridge,
dynamically load the SO, or invoke `exeVMInner`.

The archived `full_once` capture independently exercises a narrow
`0x1ecaf0` window: 70 raw code-page reads become 35 unique words, all
implemented; its observed `op11` selectors are only `0e`, `2c`, and `1e`.
The terminal `op11.1e` reaches the wrapper's saved-LR host sentinel before
the interpreter returns. For that narrow, independently verified condition,
`NativeVmpRuntime350.run(..., host_exit_sentinel=saved_lr)` may terminate
without trying to fetch a host address. The sentinel is never inferred: a
nonmatching register jump still raises `UnsupportedOpcode` at the next fetch,
and a value present in the VM word image is rejected rather than treated as a
host exit. It must also be a 4-byte-aligned host address.

`coverage_1f7860.json` also records `observed_control_edges`, retaining the
selector for observed `0x11` control transitions (the capture records
`0x11.32` successors). The Python helper
`make_trace_control_bridges()` can replay only an unambiguous captured edge;
it rejects a PC that has more than one observed successor and is therefore not
a substitute for recovering the real branch predicate.

See `opcode_recovery_350101.md` for the handler-by-handler evidence ledger.

## Closed wrapper-ABI manifest

`NativeVmpWrapperAbi350` keeps native-wrapper evidence separate from opcode
coverage and from the legacy `z/ws` `VM_XMEDUSA` layout. It records only the
three 350.101 wrappers for which both the static wrapper body and an entry
event establish the full call contract:

| name | wrapper / caller LR | vmCode | data1 / data2 | parameter window / `VmParam64` | result shape |
|---|---:|---:|---:|---:|---|
| `small_1ec670` | `0xd9574` / `0xd95cc` | `0x1ec670` | `0x262980` / `0x2629c0` | `SP+0x8` / `SP+0x10` | `u32@[pParam+0]` |
| `small_1ecaf0` | `0xd95f4` / `0xd964c` | `0x1ecaf0` | `0x262a00` / `0x262a20` | `SP+0x8` / `SP+0x10` | `u32@[pParam+0]` |
| `material_1f7860` | `0x124dd4` / `0x124e34` | `0x1f7860` | `0x26f2e0` / `0x26f300` | `SP` / `SP+0x20` | caller out-ref material |

Use `resolve_native_vmp_wrapper_abi_350(entry, vm_code, caller_lr)` only with
module-relative offsets; it fails closed for an unknown entry triple.
`validate_native_vmp_wrapper_abi_350()` additionally rejects a changed data
pointer, stack offset, or result shape. Neither executes bytecode, emulates
`funBridge`, or supplies material/output values. The entry-only pairs
`0x1f6670/0x11999c` and `0x201800/0x12acf8` deliberately remain unresolved.

The offsets are now explicitly bound to the one local sample identified in
`../metasec_so_identity.md`: `size=0x2bb410` and SHA-256
`2416637ae9c5b0fe34cbd2cb4c09a29ee3b33ca416b344a3e999c3c95730cc76`.
`validate_native_vmp_image_350(image_bytes)` checks those two values without
loading or executing the image; `validate_native_vmp_wrapper_image_350()`
requires both that identity and an exact manifest item.

For the two small wrappers only, the immutable manifest also preserves the
static evidence that was previously easy to lose in prose: `VmParam64` is
`{funBridge@+0, pParam-anchor@+8, outer-LR@+0x10}`, with anchors
`SP+0x4a0` (`1ec670`) and `SP+0x3c0` (`1ecaf0`).  Its `0xd9980` bridge is
metadata for exactly `mov x2,x0; mov x0,x1; br x2`—a tail transfer of the
primary argument, not a generic callback implementation.  The eight observed
entry-context slots below the anchor are likewise labels only.  No standalone
pParam allocation, bridge target, callback behavior, or VMP output is created
from this metadata; the material wrapper deliberately leaves these new fields
unknown.

`resolve_native_vmp_entry_observation_350()` is an additional offline check
for a complete `PC/LR/SP/X0..X4` snapshot.  It derives the module base from PC
and accepts an ABI only if the caller LR, VM code/data pointers, and X1/X4
stack relations all match the same canonical row.  It intentionally ignores
auxiliary `X9/X10`, pParam memory contents, and every runtime side effect.

## Entry discovery and the next VMP-analysis layer

`vmp_entry_analysis_process_350101.md` records how stackplz entry events are
normalized into `(vmCode offset, caller LR offset)` clusters and how those
clusters should drive later fetch/dispatch/handler collection. The accompanying
`vmp_entry_summary_350101.json` retains entry-layer machine-readable evidence,
including the opt-in complete-register ABI counts; it is deliberately not
counted as opcode coverage.

Use `dyidre/scripts/analyze_vmp_entry_uprobes.py` to repeat the mechanical
normalization against the preserved raw JSON-lines log.
Pass `--validate-known-wrapper-abi-350` to opt into the stricter complete
register check; it reports closed counts separately from entry-only pairs and
does not turn either class into opcode coverage.

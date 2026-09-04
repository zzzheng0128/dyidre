# Native VMP opcode recovery — 350.101

This is the evidence ledger for the reusable `exeVMInner_350` runtime. It
describes handlers in the supplied 350.101 `libmetasec_ml.so` only. It is not
an opcode map for another build, and trace coverage is not a claim that every
possible `vmCode` has been lifted.

The instruction reader now accepts only 32-bit `ldr`/`ldur` VM-code fetches.
That removes two former byte-read false positives: the `0x1F7860` capture has
8,058 raw word reads and a 1,132-word de-duplicated `(vm_pc, word)` stream,
not the earlier 1,134-word estimate.

## Recovered top-level handlers

| low6 op | native handler | semantic | decoding evidence |
|---:|---:|---|---|
| `0x01` | `+0x55714` | `dst = *(i32 *)(src + simm16)` | custom register/offset fields in `op01_*` |
| `0x0b` | `+0x5685c` | alignment-dependent masked `u32` store | custom base/value fields and own scattered offset |
| `0x0d` | `+0x53540` | `pc = vm_base + target26*4` | handler rebuilds a 26-bit absolute word index |
| `0x0f` | `+0x52984` / `+0x529D4` | `dst = src + simm16` | own scattered immediate in `op0f_*` |
| `0x10` | `+0x56b00` | `*(u8 *)(base + simm16) = value` | custom base/value/offset fields in `op10_*` |
| `0x13` | `+0x55fd4` | alignment-dependent masked `u64` store | distinct base/value fields and its own offset layout |
| `0x14` | `+0x54020` | branch if `lhs != rhs` | `lhs=bit31<<4 \| bits25:22`, `rhs=bit21<<4 \| bits30:27`; native `csel ..., eq` retains fallthrough on equality |
| `0x16` | `+0x56e70` | `*(u32 *)(base + simm16) = value` | ordinary AArch64 `str w`, with custom fields in `op16_*` |
| `0x18` | `+0x54a1c` | `dst = *(u64 *)(src + simm16)` | scattered source/destination fields in `op18_regs()` |
| `0x1a` | `+0x561b4` | `*(u64 *)(base + simm16) = value` | scattered base/value fields and its own `op1a_simm16()` layout |
| `0x21` | `+0x52f34` | `dst = ((u64)src < (u64)simm16)` | `cset lo`, custom fields in `op21_*` |
| `0x28` | `+0x55908` | `dst = *(u8 *)(src + simm16)` | scattered `src=bit31<<4 \| bits10:7`, `dst=bit6<<4 \| bits30:27` fields |
| `0x2b` | `+0x53b68` | branch if `(i64)reg > 0` | signed compare and custom displacement |
| `0x2d` | `+0x53db0` | branch if `lhs == rhs` | custom field/displacement reconstruction |
| `0x2e` | `+0x565e0` | alignment-dependent masked `u32` store | custom base/value fields and own scattered offset |
| `0x30` | `+0x5332c` | `dst = src \| imm16` | unsigned scattered mask in `op30_*` |
| `0x34` | `+0x531e4` | `dst = sign_extend32(imm16 << 16)` | `dst=bit21<<4 \| bits30:27`; custom immediate |
| `0x35` | `+0x5309c` | `dst = (u32)src & imm16` | custom destination/source/mask |
| `0x3b` | `+0x52d04` | `dst = sign_extend32(src) + simm16` | shares the `op01` field layout |
| `0x3e` | `+0x55d20` | alignment-dependent masked `u64` store | distinct base/value fields and its own scattered offset |

The native opaque `B.CC` paths in the `0x0f` and `0x2d` handlers are
interpreter-address hardening, not virtual branches. They are deliberately not
turned into VM control flow.

`0x16` deserves an explicit correction: it is a normal 4-byte store in this
build, not the earlier reconstructed unaligned merge operation.

`0x3e` is also a correction to the older `z/ws/vm64.cpp` label: it is **not**
the common-field `OR_IMM` operation in this build.  On its normal VM path,
it computes `addr = v[base] + simm16`, `p = addr & ~7`, and `k = addr & 7`.
For `k == 7`, it writes the complete value qword at `p`; otherwise it writes
`(old_qword & (0xffffffffffffff00 << (8*k))) | (value >> (56 - 8*k))`.
The base field is `word[31]<<4 | word[25:22]`, the value field is
`word[21]<<4 | word[10:7]`, and its signed offset reconstructs
`word[30:26] | word[20:16]<<5 | word[15:11]<<10 | word[6]<<15`, then sign
extends.  The latest local GumTrace has three independently
read-back-verified `k == 7` vectors; static handler analysis covers the other
normal alignment cases.  Its opaque native hardening side path remains outside
the portable runtime model.

`0x13` is the complementary masked-store direction. On its normal VM path,
it computes `addr = v[base] + simm16`, `p = addr & ~7`, and `k = addr & 7`.
For `k == 0`, it writes the complete value qword at `p`; otherwise it writes
`(old_qword & ((1ULL << (8*k)) - 1)) | (value << (8*k))`. Its base field is
`word[31]<<4 | word[25:22]`, its value is `word[21:17]`, and its signed
offset reconstructs `word[30:26] | word[16:6]<<5`, then sign-extends. The
latest local GumTrace has three current-word vectors (`0x02440013`,
`0x22020013`, and `0x02060013`) that take the `k == 0` full-store path;
static handler analysis covers the nonzero alignment merge. As with `0x3e`,
the opaque native hardening path is intentionally outside the portable model.

`0x0b` and `0x2e` are the corresponding 32-bit masked-store pair in this
build; neither is the old 64-bit-store/load label. Both use
`base = word[31]<<4 | word[20:17]` and align `addr = v[base] + simm16` down
to `p = addr & ~3`, with `k = addr & 3`. `0x0b` uses
`value = word[16]<<4 | word[10:7]` and
`simm16 = sx16(word[15:11] | word[30:21]<<5 | word[6]<<15)`; it fully stores
at `k == 0`, otherwise
`(old_word & ((1U << (8*k)) - 1)) | (value.u32 << (8*k))`. `0x2e` uses
`value = word[16:12]` and
`simm16 = sx16(word[30:26] | word[10:6]<<5 | word[25:21]<<10 | word[11]<<15)`;
it fully stores at `k == 3`, otherwise
`(old_word & (0xffffff00 << (8*k))) | (value.u32 >> (24 - 8*k))`.
The latest local trace has two full-store vectors per opcode (`0x0012418b`,
`0x0010810b`, `0x2c12302e`, and `0x4c10202e`); static handler analysis covers
their non-full merge paths. The opaque native hardening branches remain out of
the portable model.

## `0x11` secondary dispatch

`low6 == 0x11` first branches to `+0x4ce54`; bits `[11:6]` then select a
second handler. There is no safe generic operand layout. The runtime therefore
decodes the physical fields `[16:12]`, `[21:17]`, `[26:22]`, and `[31:27]` and
assigns roles only for the eight selectors below.

| selector | secondary handler | semantic | field roles |
|---:|---:|---|---|
| `0x03` | `+0x4dc54` | `dst = sign_extend32((u32)src << shift)` | `dst=r27`, `src=r12`, `shift=r17` |
| `0x0e` | `+0x4e0bc` | `dst = left + right` | `dst=r27`, `left=r17`, `right=r22` |
| `0x17` | `+0x4cf20` | `dst = src << encoded_shift` | `dst=r27`, `src=r22`, `encoded_shift=r17` |
| `0x1d` | `+0x4f728` | `dst = left ^ right` | `dst=r12`, `left=r22`, `right=r27` |
| `0x1e` | `+0x4f860` | `pc = target` | `target=r22` |
| `0x2b` | `+0x4f1c0` | `dst = ((i64)left < (i64)right)` | `dst=r27`, `left=r12`, `right=r22` |
| `0x2c` | `+0x4f500` | `dst = left \| right` | `dst=r27`, `left=r12`, `right=r22` |
| `0x32` | `+0x4f830` | `link = pc+4; pc = target` | `link=r12`, `target=r27` |

`0x11.17` comes from the current `gumtrace/latest/gumtrace_4cc10.log` small
`vmCode=0x1ec670` program: the dispatch lands at `+0x4cf20`, which reads
`v[r22]`, executes `lsl x9, x9, x12` where `x12` is the encoded `r17` field,
and stores `v[r27]`. It is implementation evidence for that selector, but it
does not turn the small program into coverage evidence for `0x1F7860`.

`+0x4e0bc` is deliberately listed only in the secondary table: it is the
`0x11.0e` ADD64 handler, not the top-level `0x28` handler. The trace has an
intermediate dispatch-tail fetch at that address, which previously made the
two paths look adjacent.

For `0x1e` and `0x32`, the standalone runtime models the normal virtual-PC
path. The native comparisons that escape back into host/interpreter state are
not represented by `VmState`; an uncaptured target consequently fails at
fetch time instead of being guessed. `CALL_REG` additionally appends the link
value to `VmState.call_stack` as interpreter-only bookkeeping; the native
architectural effect is the link-register write.

Any other `0x11` selector raises `UnsupportedOpcode` unless the caller supplies
an explicit opcode bridge. Adding a name to the decoder table alone does not
make a selector executable.

`0x1a` has a similarly important decoding correction. Its immediate comes
from `word[30:26] -> [4:0]`, `word[10:6] -> [9:5]`,
`word[15:11] -> [14:10]`, and `word[6] -> [15]`, then `sxth`; it is not
`imm16_common`. For example, the observed word `0xa03b2f9a` is `+0x04a8`,
whereas the old common layout incorrectly produced `+0x2a3e`.

## Bounded `0x1ec670` / `0x1ecaf0` program audit

The supplied image places two adjacent short VM programs in its first load
segment. In this segment only, the established load mapping makes their VM
addresses equal their file offsets. The static reports are therefore based on
explicit spans, rather than scanning onward until an arbitrary low-six value
looks unfamiliar:

| vmCode | bounded range | words | SHA-256 of code span | selector-gated implementation coverage |
|---:|---|---:|---|---:|
| `0x1ec670` | `[0x1ec670, 0x1ecaf0)` | 288 | `5607efcf6d14020dea2095e3f09a8b6bb171cc89ced34c291fd5df1cbe48284a` | 288 / 288 |
| `0x1ecaf0` | `[0x1ecaf0, 0x1ecd34)` | 145 | `84a935dc4444ff6b43804b1ad3ff6552956c63ff9fe6d6c3e67c8d72a20fcbd4` | 145 / 145 |

The `0x1ecaf0` end is independently structural: `+0x240` is
`0x07c00791` (`op11.1e`, `pc = v31`), while `+0x244` is the first tail-data
byte. It is consequently invalid to interpret words at and beyond `+0x244`
as further VM instructions; their apparent low-six opcode values are data
false positives.

The archived trace
`_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log`
supplies dynamic confirmation for the second span. At lines `4422872..4422880`
the wrapper gives `X0 = image_base + 0x1ecaf0` and calls `exeVMInner`; `X2`,
`X3`, `X1`, and the stack window remain VM input/output memory, not code
pages. Filtering the interpreter window `4422881..4425217` to that wrapper
anchored code page gives 70 raw 32-bit reads and 35 unique words. All 35 are
implemented; top-level counts are
`01:1 0f:2 11:4 14:1 16:1 18:12 1a:10 28:1 30:1 34:1 35:1`, and its `op11`
selectors are `0e:2 2c:1 1e:1`.

The final `0x07c00791` fetch is at archive lines `4425164`/`4425184`.
Handler `+0x4f860` resolves `v31`; the observed target matches the native
saved-LR host-return path, then the interpreter epilogue and wrapper return
`W0 = 0` (lines `4425210..4425218`). The runtime may model this only with an
explicit, 4-byte-aligned `host_exit_sentinel` passed by the caller, and that
value must be outside the supplied VM word image. It must not turn every
unmapped `JMP_REG` target into an exit.

Page selection stays evidence-gated: start from the wrapper's `X0` page and
extend only over observed VM control edges. Do not infer code pages from
frequency. In particular, stack/input pages can yield changing words at the
same address and must fail stable-image construction rather than be promoted
to VM code.

## Latest local generic-VM trace coverage

With VM page `0x6ffbcb6000` explicitly supplied, the latest local
`gumtrace_4cc10.log` has 484 raw 32-bit VM fetches and 242 unique/collapsed
stream words. All 242 are implemented after the `0x0b`, `0x13`, `0x2e`, and
`0x3e` masked-store recoveries; there are no unsupported top-level opcodes or
observed `0x11` selectors in that trace. This local result is separate from,
and does not enlarge, the `0x1F7860` coverage claim below.

## `0x1F7860` trace coverage

The current `coverage_1f7860.json` is generated from
`vm_lift_1f7860/gumtrace_1f7860_slice.log` and records:

| measure | value |
|---|---:|
| raw 32-bit VM reads | 8,058 |
| unique/collapsed stream words | 1,132 |
| exact stream words implemented | 1,132 / 1,132 |
| top-level unsupported opcodes | none observed |
| unsupported observed `0x11` selectors | none observed |

The observed `0x11` selector counts are `03:1`, `0e:30`, `1d:4`, `1e:1`,
`2b:2`, `2c:162`, and `32:85`. This is evidence that the captured program's
word stream is covered, not authorization to execute an unknown selector or a
different VM program without another handler check.

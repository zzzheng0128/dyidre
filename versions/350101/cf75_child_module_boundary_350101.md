# CF75 child-module F6 boundary — 350.101

Status: deliberately opaque.  This is a local static/dump analysis boundary,
not a claim that CF75 has no observable result.

## Entry and body identity

`CF75 @ 0x16FC94` calls `0x17214C`, which acquires a child frame, invokes
`qword_2C5B00`, then releases that frame without copying child slot2 back to
the outer frame.  The target belongs to the independent module constructed
from blob `0x2BA250`:

| item | value |
|---|---|
| program table | `0x2C5AD0` |
| F6 descriptor entry | `0x2C5B00` |
| dumped body | `0x125E7000..0x125E7750` (`0x750`, 78 records) |
| SHA-256 | `ff0b6408e6b3c609229a74639a4f2b1dbb4cbe6754f19878855b025eaf97fe98` |

The outer/child ABI is:

```text
outer.s4         -> child.s4   (hidden output object)
outer.s5         -> child.s5   (source MEM_BLOCK-like object)
outer.s6 & 1     -> child.s6   (branch flag)
outer.s2         -> unchanged
```

F6 immediately saves those values as `s16/s18/s17`, respectively.

## `0x5e` call meaning

For this module, `managedBytecodeRun_350` case `0x5e` reaches
`sub_15AB1C @ 0x15AB1C`, which obtains
`program_table[record.u32]` and invokes it through
`managedProgramInvokeCore_350` on the same frame.  It is therefore a
`CALL_PROGRAM_INDEX`, not an unconditional primary-module
`CALL_CF_INDEX`.

The decoded module table maps imports `0..16` to
`CF14, CF0, CF1, CF2, CF16, CF15, CF3, CF4, CF6, CF5, CF7, CF9, CF8, CF10,
CF11, CF12, CF13`; program index `17` is child F0.  In particular, F6's
record `0x12` invokes child F0 rather than CF17.  The 78-record F6 body has
14 such program-table calls in total.

| F6 record | table index | resolved target | bounded role |
|---:|---:|---|---|
| `0x0e` | `0x06` | CF3 | current-time result |
| `0x12` | `0x11` | child F0 | `body.mem, src_len, local+0x28` |
| `0x13` | `0x07` | CF4 | process/global object |
| `0x18` | `0x08` | CF6 | local key copy |
| `0x1b` | `0x09` | CF5 | global-tree query |
| `0x1e` | `0x0a` | CF7 | local cleanup |
| `0x2d` | `0x0b` | CF9 | local MEM_BLOCK init |
| `0x31` | `0x0c` | CF8 | bytes-to-hex/ref object |
| `0x34` | `0x0d` | CF10 | clone/add-ref to target |
| `0x36` | `0x0e` | CF11 | local ref release |
| `0x38` | `0x0a` | CF7 | local cleanup |
| `0x3b` | `0x0f` | CF12 | allocate `0x18` object |
| `0x40` | `0x0b` | CF9 | write 20-byte local result |
| `0x43` | `0x10` | CF13 | set/add-ref to target |

## Observable side-effect boundary

F6 sends the raw source body to F0:

```text
records 0x0f..0x12:
  s4 = *(u64 *)(s18 + 0x10)    // source body.mem
  s5 = *(i32 *)(s18 + 0x0c)    // signed source length
  s6 = local + 0x28
  CALL program index 17        // child F0
```

F6 itself does not directly store through `body.mem`, but F0 receives that
unaliased pointer.  The recovered F0/F2/F7 bytecode below rules out a direct
store through that pointer in those three bodies, but it still reaches an
unclosed native CF15 boundary.  Source mutation therefore remains possible
and must not be ruled out from static evidence alone.

The hidden outer-slot4 target has direct, proven writes:

```text
records 0x26..0x27:
  *(u64 *)(s16 + 0x08) = 0
  *(u64 *)(s16 + 0x00) = 0
```

It then branches on the incoming low flag:

- flag `1`: encodes F0's 20-byte local result into a block/ref and uses CF10
  to clone/add-ref it into the `s16` target;
- flag `0`: CF12 allocates a `0x18` object, CF9 writes the same 20-byte result,
  then CF13 assigns/add-refs it to `s16`.

F6's CF5 call is separate from the F0 result-byte updates documented below;
the present static boundary does not conflate it with F0's bit-2/bit-5
operations.  The two F6 ownership branches have different object shapes even
though they both mutate the target.

## Recovered F0 chain and bounded output facts

The previously missing F0 body is now statically identified.  This closes its
identity and bytecode reachability; it does **not** close the native calls or
the outer target-object lifetime.

| item | value |
|---|---|
| F0 descriptor | `0x12629800` (body header `0x12629808`) |
| code range | `0x12648000..0x12648a38` |
| body | `0xa38 = 109 x 0x18` records |
| SHA-256 | `9e3da11b08f73aa9a233f0a2c415e0c633a640866626ffcffe3d7d597059438a` |
| decode coverage | 109 known, 0 unknown |

F6 supplies `F0(s4=body.mem, s5=signed_len, s6=local+0x28)`.  F0 records
`0x10..0x12` preserve these as `s21=source`, `s20=length`, and `s18=output`.
Its `0x5e` operand resolves through the separately captured child binding
table at `0x127500e0`:

| index | target | directly established role |
|---:|---|---|
| `0x00` | CF14 | initial child-state setup |
| `0x12` | F1 | initializes F0-local state `L` |
| `0x13` | F2 | consumes `L, source, length` |
| `0x14` | F3 | emits state into `output` |
| `0x01..0x03` | CF0, CF1, CF2 | status/control path |
| `0x15` | F5 | alternate output-byte bit-2 set path |
| `0x16` | F4 | alternate output-byte bit-2 clear path |
| `0x04` | CF16 | later state/query path |

`0x15=F5` and `0x16=F4` come from their descriptor SSO names, not from
sequential dump order.  In particular, F7 is **not** F0 index `0x16`: F2
calls it through child-table index `0x17`; F2 also calls index `0x05` (CF15).
Thus the recovered reachable graph is:

```text
F0 -> {CF14, F1, F2, F3, CF0, CF1, CF2, F5 | F4, CF16}
F2 -> {CF15, F7}
F3 -> {F2}
F4/F5 -> {CF15}
F7 -> {}
```

All seven recovered bodies (`F0,F1,F2,F3,F4,F5,F7`) decode without an
unknown opcode: 1,210 records in total.  This is opcode coverage only, not a
claim that calls into CF15 or the external object ABI are reproduced.

The following output effects are direct bytecode facts under the established
F6-to-F0 ABI:

- F3 receives F0's `s18` output pointer as `s5` and directly writes
  `output[0..15]` after updating F0-local state.
- F0 takes one alternate path: F5 directly sets bit 2 of `output[16]`; F4
  directly clears that bit.  Both first call CF15 with a four-byte local
  value, so the rest of the four-byte transfer remains unclosed.
- F0 record `0x5a` then writes `output[16]` again: it clears bit 5 and sets
  it only when its computed condition is nonzero.  This is distinct from the
  bit-2 alternate path.
- Bytes `output[17..19]`, and any CF15 contribution to
  `output[16..19]`, are not established by this static peel.

For source mutation, F0 stores no value through saved `s21`; F2 stores no
value through its saved source `s17`; and F7 uses its `s5` input only for
loads while its non-stack stores go through F2's local-state `s4`.  This
eliminates a direct bytecode store to `body.mem` in F0/F2/F7.  It is not a
source-immutability proof: F2 still sends the source through CF15 and aliases
remain observable only in a pre/post trace.  F0 also has proven pool-derived
state writes and clears its own `0x58`-byte local state, so a digest-only
adapter would omit known effects.

## Evidence required before closure

A standalone bridge needs an evidence set attributable to this child module,
not to the primary sign module's independently named F6. It may come from an
already archived trace or from separately authorized collection, but it must
preserve the following pre/post state:

- the outer `s2/s4/s5/s6` and child `s4/s5/s6/s16/s17/s18` values at child-F6
  entry and return, including pointer aliases; verify that outer `s2` remains
  unchanged;
- the target at `s16 + 0x00/+0x08` before the proven clear, after assignment,
  and after any cleanup, with enough ref/object identity information to
  distinguish the CF10 and CF13 ownership paths;
- the source `MEM_BLOCK` body pointer, signed length, and raw byte range (or
  hash plus captured bytes) before and after child F0, so absence of a direct
  F6 store is not mistaken for proof that F0 leaves it unchanged;
- the recovered F0 chain's `local + 0x28` result before/after F3, F4/F5,
  F0's record-`0x5a` bit update, and every CF15 call, so the currently known
  byte ranges can be joined into an exact 20-byte result; and
- both `s6 & 1` paths, together with the F6-side CF5 predicate and the
  relevant pre/post output bytes, to establish any remaining conditional
  change and the clear-before-assignment lifetime.

Only a replay that matches these target, source, ownership, and slot effects
for both flag paths can promote CF75 from the explicit opaque boundary.

## Consequence

CF75 cannot safely be a no-op, a slot2 scalar return, or a bytes-only helper.
A future standalone implementation must recover the unresolved result tail
and CF15 effects, demonstrate source behavior, reproduce both destination
ownership paths, and preserve the initial clear-before-assignment lifetime.
Until then it stays unimplemented and may only be routed through an explicit
trace/recovery `OpaqueCfBackend350` handler.

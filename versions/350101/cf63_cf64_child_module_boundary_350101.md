# CF63 recovery / CF64 second-module boundary — 350.101

Status: CF63 is standalone-recovered; CF64 remains deliberately opaque. Both
wrappers enter the managed module constructed at `0x152B58` from blob
`0x27F9B0`, not the primary sign module.  The second-module F1 body is
`0x12742000..0x1274FBD8` (`0xDBD8`, 2,345 records, SHA-256
`c662cf0b2e5e1d78cef3e9dac57db54443cd62d9be19b235184ea9e372f961f5`).

## CF63

`0x16FA34` reads outer slot4, calls `0x153F80`, and stores only the returned
low 32-bit word in outer slot2.  The adapter acquires a cleared child frame,
raw-stores the original outer slot4 value into child slot4, invokes
`qword_2C5310` (second-module F22), reads child slot2, and releases the frame.
The dumped F22 body has only MEM_BLOCK/body reads, no raw store and no CF
call, so it is now an exact standalone handler. See
[`cf63_second_module_f22_recovered_350101.md`](cf63_second_module_f22_recovered_350101.md).

```text
outer.s4 -> child F22.s4
child F22.s2 low32 -> outer.s2
```

## CF64

`0x16FA60` forwards four values to `0x153ECC`, which builds a child frame for
`qword_2C5268` (second-module F1), then releases it without any outer-slot
write.

```text
outer.s4        -> child F1.s19
outer.s5        -> child F1.s0
low32(outer.s6) -> child F1.s10
outer.s7        -> child F1.s27
outer.s2        -> unchanged
```

## Why CF64 remains opaque

`managedFrameSetSlot_350 @ 0x1547D4` is a raw qword store and
`managedFrameAcquire_350` only clears child frame slots; neither copies nor
isolates pointed-to objects.  More importantly, second-module F1's `0x5e`
records are table-scoped calls: `managedBytecodeRun_350` case `0x5e` reaches
`sub_15AB1C @ 0x15AB1C`, which calls
`program_table[record.u32]` through `managedProgramInvokeCore_350` on the
**same child frame**.  Neither the immediate nor a same-looking `Fxx`/`CFxx`
name denotes the primary sign module.

## Recovered F1 dispatch table and first-hop bodies

F1 itself is now fully decoded (2,345 known records, no unknown opcode). All
of its 40 `0x5e` records use the same captured runtime `q1` holder
`0x125fd360`, whose dereferenced vector was `0x12613700` in that layout. Both
values are runtime allocations, not module-relative offsets; future runs must
derive `table = *q1` from the active F1 rather than add `0x613700` to the SO
base. The descriptor names and entry pointers prove this exact mapping:

| index | child target | count in F1 | child entry/body fact |
|---:|---|---:|---|
| `0x02` | CF1 | 1 | kind-3 native entry `0x1527cc` |
| `0x03` | CF2 | 1 | kind-3 native entry `0x15281c` |
| `0x04` | CF3 | 1 | kind-3 native entry `0x152840` |
| `0x05` | CF4 | 1 | kind-3 native entry `0x152864` |
| `0x06` | CF10 | 1 | kind-3 native entry `0x1529ac` |
| `0x07` | CF5 | 1 | kind-3 native entry `0x152888` |
| `0x08` | CF7 | 1 | kind-3 native entry `0x1528f8` |
| `0x09` | CF6 | 1 | kind-3 native entry `0x1528ac` |
| `0x0a` | CF8 | 1 | kind-3 native entry `0x152934` |
| `0x19` | F2 | 1 | 804 records |
| `0x1a` | F3 | 12 | 9 records |
| `0x1b` | F19 | 1 | 527 records |
| `0x1c..0x2a` | F4..F18 | 15 total | 45--799 records each |
| `0x2b` | F21 | 1 | 45 records |
| `0x2c` | F20 | 1 | 45 records |

The order at `0x2b/0x2c` is deliberate (`F21`, then `F20`).  In particular,
the old shorthand that described these calls as `F25/F26` or primary-module
CF indices was wrong and must not be reused.  The child CF1 at `0x1527cc`,
for example, is not primary CF1 at `0x16eac0`.

The offline `repeat=0` descriptor dump now also contains the direct managed
callees F2--F21, and
[`managed_vm_decode_cf64_reachable_350101`](managed_vm_decode_cf64_reachable_350101/managed_vm_decode_summary.md)
contains their mechanical lifts.  Together with the second/third-hop dumps,
all 28,076 reachable records now have a decoded opcode.  This closes bytecode
coverage and table identity, not the transitive object side effects.  The
native ABI facts for the previously opaque child indexes are recorded in
[`cf64_child_native_abi_350101.md`](cf64_child_native_abi_350101.md).

The initial values are copied into F1 shadows before the first nested F2 call:
outer `s4/s5/zeroext32(s6)/s7` become F1 `s14/s20/s2/s15`.  F1 then derives
`s17 = *(outer.s4 + 0x10)`.  At F2 entry, `s16=outer.s4`, `s6/s18=outer.s7`,
`s20=zeroext32(outer.s6)`, while `s4` and `s5` are respectively
`*(outer.s5+0x10)` and `*(outer.s5+0x0c)`; F2 can therefore observe or mutate
the forwarded objects before provenance becomes post-call state.  F1 itself
also has direct raw stores at:

```text
+0x0c4f8 / rec 0x835: ST32 [s7]       = low32(s16)
+0x0c5b8 / rec 0x83d: ST32 [s21]      = low32(s16)
+0x0c5d0 / rec 0x83e: ST8  [s6]       = low8(s20)
+0x0c6a8 / rec 0x847: ST8  [s17+0x10] = (old & 0xdf) | (predicate << 5)
+0x0da70 / rec 0x91a: ST8  [s17+0x13] = old ^ 1 if int32(s20) < 1
```

None of those five bases can yet be attributed to a particular forwarded outer
pointee.  The late subchain is now narrower than the earlier conservative
reading: F21/F20 and CF9 preserve F1 `s6/s21/s7`, and CF10 at `0x80e` reads
only slot4 before writing its result to F1-local storage through `0x1305e4`;
it does **not** call `managedFrameSetSlot_350` or replace those frame slots.
Thus records `0x821..0x823` restore the pre-F21 identities, and the bases at
`0x835/0x83d/0x83e` are respectively that pre-F21 `s7/s21/s6` state.  They
still arise from pool/post-child-call values rather than proven outer aliases.
The `s17` base can be identified early as `*(outer.s4+0x10)`, but F19/F13
later feed post-call state back into the chain, so the final flag object at
`0x847/0x91a` is not statically tied to that original object.  Most of F1's
other 1,045 `ST64` instructions have call-save/restore shape.  The raw writes
therefore rule out a scalar bridge or no-op, but cannot honestly be labeled as
confirmed writes to one specific outer object without frame/object pre/post
evidence.

## Static direct/may-effect boundary

The table below separates instruction/wrapper facts from unresolved object
provenance. “Direct” is limited to an instruction or already-typed wrapper
when it executes; it is not an execution/reachability claim.

| surface | direct static fact | may-effect / unresolved boundary |
|---|---|---|
| outer adapter | outer `s4/s5/low32(s6)/s7` are forwarded to F1, while outer `s2` is not copied back | whether F1 or descendants modify any outer pointee |
| early F1 state | those values form early F1 shadows; F1 also reads the second module's three 8-byte G package slots | a package-slot read is not a passed-target dereference or original global direction |
| early pointer flow | F1 derives one pointer from outer `s4`; F2 receives values derived from the forwarded inputs | a particular later store cannot be assigned to an outer pointee |
| five raw stores | two 32-bit and three byte stores have fixed mechanical widths | branch reachability and every store-base object's identity remain unresolved |
| post-F2 flow | F1 adopts post-F2 slot state for later computation | this is the first hard provenance break from the original outer values |
| typed child-native wrappers | their slot ABI and local fill/copy/atomic/allocation/lock/guard effects are recorded separately | whether CF64 reaches a wrapper and whether its arguments alias outer objects |
| remaining child-native targets | table identity is module-local and known | their object effects cannot inherit similarly numbered primary-module CF meanings |

Therefore:

- CF64 has no outer scalar result, so a no-op would assert an absence of all
  object/memory/global effects without evidence.
- `OpaqueCfBackend350` is the only current escape hatch, and its handler must
  provide a complete captured/recovered replay; it does not promote CF64 to a
  standalone implementation.

## F reachability is now closed; semantics are not

The `q1=0x125fd360` child vector has now been followed through every managed
`op=0x5e` edge reachable from F1.  This is a **control-flow/table-identity**
closure only.  It does not identify the side effects of the child-native
helpers or establish object ownership/aliasing.

```text
F1
  -> F2..F21
  -> F23..F28 plus the 40 second-hop branch bodies
  -> F29..F40 and F45/F49/F53/F57/F61/F65/F69/F73/F77/F81/F85
  -> child-native index 0x0b only (no additional managed F target)
```

Equivalently, the static F1 call graph reaches every child program from `F2`
through `F85` except `F22`; `F0` is the module entry and is also not on this
F1 path.  The final third-hop scan found 26 `op=0x5e` sites in 11 bodies, all
to child-native index `0x0b`; no fourth-hop managed-program edge exists in
the captured table.
Index `0x0b` is now statically typed: native entry `0x162b38` reads child
`s4/s5/s6`, calls `memset(s4, low8(s5), s6)`, and writes the destination
pointer to child `s2`.  The adjacent index `0x0c` is similarly confirmed as
`memmove(s4, s5, s6) -> s2`; it occurs in the six bulk first-hop bodies but is
not a terminal third-hop target.  The remaining child indexes `0x0d..0x16`
are now statically typed as fill/copy/CAS, lock, allocation, and guarded
object-state helpers; see
[`cf64_child_native_abi_350101.md`](cf64_child_native_abi_350101.md).

The intermediate body-call edges are mechanically evidenced as follows:

```text
F23..F28 -> (F29,F30), (F31,F32), (F33,F34), (F35,F36), (F37,F38), (F39,F40)
F42/F43 -> F45;  F47 -> F49;  F48 -> F47
F51/F52 -> F53;  F55 -> F57;  F56 -> F55
F59/F60 -> F61;  F63 -> F65;  F64 -> F63
F67/F68 -> F69;  F71 -> F73;  F72 -> F71
F75/F76 -> F77;  F79 -> F81;  F80 -> F79
F83/F84 -> F85
```

The three offline collections were all run after JNI initialization with
`repeat=0`, so they dump program descriptors/bodies without entering the
signature loop:

- second-hop descriptors: `managed_program_dumps_350101_cf64_f1_secondhop_20260904`;
- second-hop bodies:
  `managed_program_dumps_350101_cf64_secondhop_bodies_20260904` (40 bodies,
  3,900/3,900 records decoded after the `OP_17` recovery);
- third-hop descriptors/bodies:
  `managed_program_dumps_350101_cf64_thirdhop_{descriptors,bodies}_20260905`
  (23 bodies, 13,655/13,655 records decoded after the `OP_17`/`OP_7E`
  recovery).

The decoder's generic `Recognized 350.101 Source-Work Families` appendix must
not be treated as a semantic match here: it is an upgrade-pattern aid for a
different program family.  For example this child F29 is
`0x126a7800..0x126a8cd0` / 222 records, not the baseline source-work F29
shape.  The raw descriptor names, code ranges, and call tables above are the
only claims made for CF64.

## Next evidence

The generic managed-program dumper accepts
`metasec.managedProgramTableOffset` (default `0x2C58D0`); table base
`0x2C5260` has now been captured transitively through the final managed F
edge. F22 remains closed. `OP_17` and `OP_7E` are now statically recovered;
see [`cf64_child_opcode_recovery_350101.md`](cf64_child_opcode_recovery_350101.md).
The remaining CF64 evidence is dynamic alias closure, not another static
opcode/wrapper guess. The default-off `metasec.childNativeAbiProbe=true`
now establishes a CF64 adapter scope (`0x16FAB8 -> 0x153ECC`), derives the
live F1 `q1` holder/table, verifies `table[0x18] == F1`, and then correlates
selected `0x0d..0x16` native calls by the same child frame, record, holder,
SP delta, and return LR. It records pre/post slots, frame-local pointer
snapshots (not presumed outer pointees), and hidden frame status. A controlled
local Unicorn2 callback now supplies one strictly CF64-origin result: index
`0x0e` / child CF9 ran with `s6=4`, copied the observed four source bytes from
child `s5` to child `s4`, and returned child `s4` in `s2`; its frame/hidden
status remained normal. The remaining evidence is the cross-F2/F19/F13
outer-object alias closure, dynamic coverage of the other selected indexes,
and a pre/post proof for any outer pointee. The present trace does not close
those boundaries, so table coverage and static ABI typing still cannot promote
CF64 to a standalone implementation.

The next gap now has a dedicated default-off local collector:
[`cf64_alias_probe_350101.md`](cf64_alias_probe_350101.md).  It accepts only
the three direct F1 records `F2/F19/F13` (live `F1.codeBegin + 0x0c48 / 0x1728
/ 0x73c8`), pairs their kind-1 `0x154594 -> 0x154598` pre/post state, and
compares bounded outer-object samples again at F1 return.  A local Unicorn2
baseline installed and exercised the CF64→F1 scope but reported zero target
events; that is explicitly a no-hit, not an alias conclusion.

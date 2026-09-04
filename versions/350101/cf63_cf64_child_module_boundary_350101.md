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

F1 itself is now fully decoded (2,345 known records, no unknown opcode).  All
of its 40 `0x5e` records use `q1=0x125fd360`, whose captured vector begins at
`0x12613700`.  The descriptor names and entry pointers prove this exact
mapping:

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
contains their mechanical lifts.  This establishes first-hop identity, not
their transitive side effects: six bulk bodies (F2/F6/F9/F12/F15/F18) still
contain three unrecognized records each, and their nested table dispatch and
native child-CF effects remain outside the standalone bridge.

The initial values are copied into F1 shadows before the first nested F2 call;
that F2 entry sees original outer `s4/s7/s5/low32(s6)` via child
`s4/s18/s19/s20`.  Thus a nested body can observe or mutate all forwarded
object identities.  F1 itself also has direct raw stores at:

```text
+0x0c4f8 / rec 0x835: ST32 [s7]       = low32(s16)
+0x0c5b8 / rec 0x83d: ST32 [s21]      = low32(s16)
+0x0c5d0 / rec 0x83e: ST8  [s6]       = low8(s20)
+0x0c6a8 / rec 0x847: ST8  [s17+0x10] = (old & 0xdf) | (predicate << 5)
+0x0da70 / rec 0x91a: ST8  [s17+0x13] = old ^ 1 if int32(s20) < 1
```

None of those five bases can yet be attributed to a particular forwarded outer
pointee.  Immediately before the group at `0x835..0x847`, F1 calls child CF10
at record `0x80e`; records `0x821..0x823` then restore `s6/s21/s7` from its
post-call snapshot, so that child call may have replaced the pointers.  The
`s17` base is also unstable: its initial chain follows `s14` after child CF1
returns, and it is redefined repeatedly before later same-frame child calls.
Most of F1's other 1,045 `ST64` instructions have call-save/restore shape.
The raw writes alone therefore rule out a scalar bridge or no-op, but cannot
honestly be labeled as confirmed writes to one specific outer object without
the complete reachable graph or object pre/post evidence.

Therefore:

- CF64 has no outer scalar result, so a no-op would assert an absence of all
  object/memory/global effects without evidence.
- `OpaqueCfBackend350` is the only current escape hatch, and its handler must
  provide a complete captured/recovered replay; it does not promote CF64 to a
  standalone implementation.

## Next evidence

The generic managed-program dumper accepts
`metasec.managedProgramTableOffset` (default `0x2C58D0`); table base
`0x2C5260` has now been captured for F1/F22 and F2--F21 with `repeat=0` after
JNI initialization. F22 remains closed. The next CF64 evidence must instead
capture the **transitive** nested-program table and object/memory pre/post
state for the four forwarded outer values.  That is required to attribute the
known direct stores, close the child native-CF ABI, and distinguish a
preserved pointer from a mutated pointed-to object; raw table coverage alone
cannot promote CF64.

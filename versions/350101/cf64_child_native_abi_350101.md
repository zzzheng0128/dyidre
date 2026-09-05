# CF64 child-native ABI recovery — 350.101

Scope: the child managed-program vector observed at runtime address
`0x12613700` in one local layout, reached by CF64's F1.  This address is a
heap/runtime table address, **not** a `libmetasec_ml.so` module offset (it lies
outside the loaded SO image); it must not be reconstructed as
`module.base + 0x613700`.  These are **child vector indexes**, not identically
named primary-module CFs.  Every entry below was checked from the kind-3
descriptor, its native wrapper, and the direct callee in the local 350.101 SO.

## Static ABI closure for `0x0d..0x16`

| index | child entry | child-slot ABI and result | direct callee | established effect |
|---:|---:|---|---|---|
| `0x0d` (CF16) | `0x152a9c` | `s4=dst, s5=fill, s6=len` → `s2=s4` | `0x138728` | byte fill: `dst[i] = low8(s5)` for `i < s6` |
| `0x0e` (CF9) | `0x15294c` | `s4=dst, s5=src, s6=len` → `s2=s4` | `0x13847c` | normal-return path copies forward from `[s5,s5+s6)` to `[s4,s4+s6)` |
| `0x0f` | `0x162b8c` | `s4=byte*, s5.low8=expected, s6.low8=desired` → `s2=old_byte` | inline | `LDAXRB`/`STLXRB` retrying 8-bit compare-exchange |
| `0x10` (CF18) | `0x152b14` | `s4=pthread_mutex_t*` → `s2=zext32(ret)` | `pthread_mutex_lock` | locks an external mutex |
| `0x11` (CF15) | `0x152a70` | `s4=size` (zero becomes one) → `s2=allocated_ptr` | `0x1c2f40 → 0x1c2edc → malloc` | allocation; OOM has a new-handler retry/non-return path |
| `0x12` (CF17) | `0x152afc` | `s4=object`; `s2` unchanged | `0x44a98` | writes `object+0` vtable; conditionally unlocks `(*(void **)(object+8))+8` |
| `0x13` (CF11) | `0x1529c4` | `s4=guard/state` → `s2=zext32(0/1)` | `0x1c5170` | one-time guard acquire / init-owner decision, with mutex/condition/TID state |
| `0x14` (CF12) | `0x1529f0` | `s4=size` (zero becomes one) → `s2=allocated_ptr` | `0x1c2edc → malloc` | same allocation core as `0x11` |
| `0x15` (CF14) | `0x152a34` | `s4=object, s5.bit0=mutex-type` ; `s2` unchanged | `0x42aac` | writes vtable and initializes the mutex at `object+8` |
| `0x16` (CF13) | `0x152a1c` | `s4=guard/state`; `s2` unchanged | `0x1c52d0` | guard release: release-store to `s4[0]`, state update, optional condition broadcast |

For `0x0e`, the direct core has validation/lazy-access machinery before its
copy loop.  A failed validation reaches `0x125d34 → svc #0`; it is not a
different normal return.  The payload copy is forward, so it must not be
renamed as overlap-safe `memmove` without an overlap proof.

This closes the native wrapper ABI, but not CF64 as a standalone lift: the
same path now has concrete allocation, object-vtable, mutex, atomic, and
guard-state effects whose object identities must still be tied to the four
outer pointers.

## Runtime table identity

The captured layout provides a useful anchor, but is not a portability
contract:

```text
CF64 -> 0x153ECC -> F1 invoke at 0x153F50
F1 descriptor (one run)     = 0x1273e240, kind=1
F1 code (one run)           = 0x12742000..0x1274fbd8
F1 op=0x5e records           = 40
their unique q1 table holder = 0x125fd360
*holder (one run)            = 0x12613700
table[0x18]                  = F1 descriptor
```

`q1` is the holder operand of a managed `op=0x5e` record. At dispatcher entry
`0x15AB1C`, `X0` is `record + 8`, so `*(X0 + 8)` is the holder and `*holder`
is the table; `*(X0)` carries the dispatched index. It is not valid to fall
back to `*(X0)` as though it were a holder. A scan of the F1, first-hop,
second-hop, and third-hop reachable bodies found the same holder in all 417
`op=0x5e` records across 59 bodies. F1 therefore bootstraps table identity;
the eventual `0x0d..0x16` calls may originate in descendant F bodies and must
not be filtered to F1's code range.

## Static alias boundary

The outer adapter `0x16FA60 → 0x153ECC` and F1 establish this early identity
chain:

| outer CF64 | F1 initial slot | early F1 shadow |
|---|---:|---:|
| `s4` | `s19` | `s14` |
| `s5` | `s0` | `s20` |
| `zeroext32(s6)` | `s10` | `s2` |
| `s7` | `s27` | `s15` |

Child CF1 does not call `managedFrameSetSlot_350`, so these slot identities
remain valid through F1 records `0x0043..0x0046`; F1 record `0x004e` also
establishes `s17 = *(outer.s4 + 0x10)`.  Pointee mutation remains possible.
The first hard provenance break is after F2: F1 `0x0091..0x009b` adopts its
post-F2 slots, which cannot statically be equated with the original outer
values.

The formerly ambiguous late stores are now more tightly bounded.  F21/F20
and CF9 preserve F1 slots `s6/s21/s7`; CF10 (`0x1529ac`) only reads slot4 and
writes its TLS/object result to F1-local storage, rather than replacing those
slots.  Thus F1 `0x0835`, `0x083d`, and `0x083e` target the pre-F21 values of
`s7`, `s21`, and `s6` respectively.  Those values still originate from pool
and post-child-call state, not proven outer aliases.  F1 `0x0847` and
`0x091a` operate on one flag object, but its final identity after F19/F13 is
also not statically closed.

## Default-off correlated probe

`Sign6MetaSecBase` now exposes `metasec.childNativeAbiProbe=true`. It does
not change VM state. Its default `requireCf64Origin=true` is fail-closed:

1. At `0x153ECC`, it accepts only `LR == module.base + 0x16FABC`, the return
   address of CF64's `0x16FAB8` call.
2. At `0x153F50`, it captures the live F1 descriptor and child frame, scans
   that live F1 body for its unique `op=0x5e q1` holder, dereferences the
   table, and requires `table[0x18] == F1 descriptor`.
3. At the child dispatcher (`0x15AB1C`), it requires the same active child
   frame, `LR == module.base + 0x1570F0`, `record.op == 0x5e`, the record index
   equal to `W2`, the same holder/table/root-program relation, and an index in
   `0x0d..0x16` whose kind-3 target matches the static target table above.
4. It requires `SP@0x15454C == SP@0x15AB1C - 0x50`, then matches normal return
   through `0x154550` and commits after the hidden status has been copied back
   at `0x154560`.

Each verified match logs:

- pre/post slots `0..27` by default;
- slot changes, including `s2` allocation/return values;
- bounded `0x40` snapshots of pre-call `s4/s5/s6` pointers and post-call
  snapshots of the same identities; and
- bounded snapshots of current `s2/s4/s5/s6` pointers after return.
- frame status and hidden status both before the native call, immediately
  before restore, and after restore; and
- CF64 outer slot identities, live F1 descriptor, holder, table, record,
  frame, SP, and LR correlation values.

Relevant optional properties are:

```text
metasec.childNativeAbi.requireCf64Origin=true
metasec.childNativeAbi.tableAddress=<optional explicit runtime address>
metasec.childNativeAbi.indexes=0xd,0xe,0xf,0x10,0x11,0x12,0x13,0x14,0x15,0x16
metasec.childNativeAbi.slots=0-27
metasec.childNativeAbi.preRawSlots=4,5,6
metasec.childNativeAbi.postRawSlots=2,4,5,6
metasec.childNativeAbi.maxBytes=0x40
metasec.childNativeAbi.maxEvents=64
metasec.childNativeAbi.maxPending=64
```

For an explicit table-only diagnostic, set
`metasec.childNativeAbi.requireCf64Origin=false` **and** provide
`metasec.childNativeAbi.tableAddress`; that output is intentionally not CF64
provenance evidence.

The seven code hooks require a Unicorn-family backend.  Use
`-Dmetasec.backend=unicorn2` for this local probe.  When the selected backend
is Dynarmic or Hypervisor, the probe prints an explicit skip before installing
any hook; that is a backend limitation, not a no-hit result.

`repeat=0` / `dumpOnly` cannot exercise F1, and the probe deliberately does
not invoke a callback itself.  A controlled local callback has now been run
through the reactor build with:

```bash
cd /Users/freeman/project/douyin/unidbg
./mvnw -q -pl unidbg-android -am \
  -Dmaven.test.skip=false -DfailIfNoTests=false \
  -Dtest=Sign6_350101#testMetasec \
  -Dmetasec.backend=unicorn2 \
  -Dmetasec.childNativeAbiProbe=true \
  -Dmetasec.childNativeAbi.maxEvents=64 \
  -Dmetasec.childNativeAbi.maxBytes=0x40 \
  -Dmetasec.repeat=1 test
```

## One correlated local observation

One baseline callback passed the full CF64-origin filter:

- the live F1 descriptor was `0x1273e240`; its unique holder was
  `0x125fd360`, `*holder` was `0x12613700`, and `table[0x18]` was the same F1
  descriptor;
- the selected native hit was index `0x0e` / child CF9 at
  `module.base + 0x15294c`, with the expected dispatcher and BLR return LRs
  and `SP@BLR == SP@dispatcher - 0x50`;
- its child-frame arguments had `s6=4`.  The first four bytes at child `s4`
  changed from their pre-call contents to the first four bytes at child `s5`;
  `s2` changed from `0x8` to the child `s4` address; and
- frame and hidden status were both `0x23` before the call, before restore,
  and after the status commit.

This is a dynamic instance of the static CF9 forward-copy ABI, not a complete
CF64 lift.  It covers only index `0x0e` in one baseline.  In that run child
`s4/s5` were F1-internal pointers, distinct from the observed outer CF64
`s4/s5`.  Addresses and copied bytes are allocation- and input-dependent, so
the durable assertion is the pre/post equality relation above, rather than a
literal pointer or byte value.  It therefore does not prove an outer-pointee
write, close the post-F2/F19/F13 alias chain, establish overlap behavior, or
dynamically cover the other `0x0d..0x16` helpers.  The static closure and this
correlated trace consequently do not promote CF64 to a standalone
implementation.

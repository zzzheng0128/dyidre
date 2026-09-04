# 350.101 managed VM runtime

`managed_vm_runtime.py` is the standalone interpreter framework for the
`0x1555A4 managedBytecodeRun_350` VM. It is not the native `exeVMInner` VMP.

- 0x18-byte records, 0x50 qword frame slots, and the inline double view are
  represented directly.
- The complete `CF0..CF101` namespace is registered. A recovered helper is
  executable; any other index raises `UnimplementedCfBinding`.  The generated
  `cf_bindings_350101.json` now carries all 102 evidence-backed wrapper
  addresses, independently of whether a host replacement exists. The
  self-test strictly cross-checks its canonical order, fields, addresses,
  names, and implementation status against the executable registry.
- `100/102` bindings currently have standalone implementations.  In addition
  to the MEM_BLOCK/REF primitives and CF16's injected 31-bit random source,
  this includes CF41 SIMON128/256, CF58 raw RC4,
  CF43 mode-1 AES-128-CBC+PKCS#7, and CF48/F17 short-header transform.  They
  are checked respectively against the existing Argus, AES-tail, Ladon and
  Helios oracle vectors.  CF43 rejects unobserved mode types and CF41/CF48
  require already-normalized 32-byte key material.
- All currently decoded managed opcodes are executable for a primary-module
  `cf_table` program.  The last recovered handlers are `0x07`/`0x24` (float
  stores), `0x0a` (double subtraction), `0x51` (float load), `0x64`/`0x66`
  (integer subtraction and variable logical shift), `0x8f` (int32-to-double),
  and `0xa9` (signed `< 1` branch).
- `0x5c` is an *indirect VM-PC* branch.  It is executable when the caller
  supplies `Program.indirect_pc={token: record_index}`.  This preserves the
  native token-to-record relationship instead of guessing that a token is a
  byte offset.
- `0x5e` is table-scoped rather than globally a CF call.  The default
  `call_abi="cf_table"` routes its immediate to `CF0..CF101`; a secondary or
  child module dump must use `call_abi="program_table"` (or CLI
  `--call-abi program_table`).  In that mode an absent
  `program_call_handler=` raises `UnresolvedManagedProgramCall` instead of
  accidentally dispatching the index through the primary CF table.  Coverage
  reports the selected ABI and its target indices.
- CF25 now follows the native ABI: it ignores slot4 and returns the registry's
  injected `environment` object in slot2.  Construct `CfRegistry350` with an
  environment dictionary when replaying an environment-sensitive program.
- CF16 reaches a guarded, once-seeded `rand()` helper.  Its process-local seed
  is not an oracle, so construct `CfRegistry350` with `random_u31_provider=`
  when a replay needs a known value sequence.
- CF40 and CF96 both model the observable shared-reference assignment.  CF40
  returns the destination through slot2; CF96's native wrapper does not touch
  slot2, so the host runtime preserves it.
- CF62 is another no-slot2 shared-reference clone. CF63 is the pure
  second-module F22 recurrence over slot4's MEM_BLOCK and returns its exact
  low-32-bit result through slot2; the input block is not mutated. Its
  dump/algorithm/vector evidence is in
  [`cf63_second_module_f22_recovered_350101.md`](../cf63_second_module_f22_recovered_350101.md).
  CF68/CF70 wrap
  `getpid()`/`getppid()`; their providers can be injected to keep a replay
  independent of the machine running it. CF71 returns the actual AArch64
  `TPIDR_EL0` thread pointer—not a thread ID—so it requires the explicit
  `thread_pointer_provider=` captured from the replay runtime.
- CF66 and CF89 are tied to the same injectable realtime-millisecond source:
  CF66 is the integer-second form and CF89 is the millisecond form.  This
  matches the existing deterministic replay setting.
- CF93 is the no-slot2 shared-reference release counterpart to CF08.
- CF21 is the lock-protected shared-reference release counterpart: it clears
  slot4's observable ownership state and preserves slot2. CF76 lazily builds
  one process-cached MEM_BLOCK from the native UUID-v4 template. For a
  byte-for-byte replay, provide `cf76_random_bytes_provider=` with the 16
  little-endian bytes produced by its two native xorshift calls.
- CF22/CF23/CF24 share an explicit `sdk_identity_provider=` returning
  `HostSdkIdentity350(app_version, sdk_semver, sdk_flavor, sdk_platform)`.
  CF22 UTF-8-copies the per-call Java app-version result into the hidden
  slot4 `Ref` and preserves slot2; CF23 caches the exact recovered version
  word into slot2; CF24 caches a NUL-terminated `semver-flavor-platform`
  raw C-string pointer in slot2. The provider is mandatory so the captured
  `35.1.0` / `v04.09.05-ml-android` identity is never silently substituted.
- CF74 and CF84 model only the two proven trees beneath one locked native
  aggregate: the `+0x58` tree maps opaque integer keys to raw pointer values
  returned in slot2, while the `+0x30` tree maps opaque keys to MEM_BLOCKs
  copied into slot4 (or an empty block on miss). Use `HostTreeMaps350` to
  represent that bounded surface; it deliberately claims nothing about the
  aggregate's other fields or tree comparator.
- CF65 reads just one proven raw-context field: bit 0 of the 32-bit word at
  `slot4 + 0xE8`.
- CF73 is the corresponding locked raw-context read: after its native guard
  path it returns the unmodified qword at `slot4 + 0x40` in slot2. The
  single-threaded host bridge preserves that field read, not lock contention.
- CF72, CF80, CF81, CF82, and CF83 read mutable native 32-bit/global-derived
  state; replay must provide `native_globals_u32={72: ..., 80: ..., 81: ...,
  82: ..., 83: ...}` or the
  runtime fails explicitly.  CF72 preserves the native acquire-load ABI;
  replay receives the captured value rather than a fabricated atomic state.
- CF51 returns an atomically initialized native singleton pointer.  Its
  0x2d0-byte body is still opaque, therefore replay must provide
  `native_globals_ptr={51: captured_pointer}`; the runtime never invents one.
- CF57 is raw-C-string `strtoull`, including its optional endptr and 64-bit
  overflow behavior; its inputs are deliberately not treated as heap strings.
- CF58 is raw binary RC4: hidden slot4 receives a fresh same-length MEM_BLOCK
  from source slot5 and key slot6, with the standard zero-warmup KSA/PRGA.
  Either empty input clears the REF rather than creating an empty block; it
  preserves slot2 and never treats embedded NUL bytes as terminators.
- CF59 is the exact CRC-8 polynomial-`0x31`, init-0 primitive over a
  MEM_BLOCK; its `"123456789" -> 0xA2` vector is in the self-test.
- CF77 is the standard reflected CRC-32/ISO-HDLC primitive over a MEM_BLOCK;
  its `"123456789" -> 0xCBF43926` vector is in the self-test.
- CF28 preserves the native low-bit result of its empty-string comparison;
  CF39 returns the observed interior `slot4 + 0x68` HTTP-client list pointer.
  CF95 maps `pthread_mutex_lock(slot4)` to a single-threaded `HostMutex`, or
  an injected lock provider when a replay needs OS-level mutex behavior.
- CF09 copies a raw C string into a MEM_BLOCK and returns its destination;
  CF55 reserves its observed minimum-8/power-of-two capacity and CF56 appends
  one byte while preserving the native return-slot behavior.
- CF00 has the non-obvious native argument order `slot4, low32(slot5) length,
  low8(slot6) fill byte`; it preserves slot2. A negative low32 length clears
  the visible block length before the native helper's ignored error return.
- CF03 is a static address-seeded binary transform: hidden slot4 receives a
  fresh MEM_BLOCK after RC4 and residue-major transpose of slot5. Its native
  temporary-body address changes both the key and stride, so an exact replay
  must supply that captured `u64` through `cf03_temp_body_address_provider=`;
  the host only shifts/masks the address and never dereferences it. Missing or
  invalid providers preserve the output REF and slot2 instead of substituting
  a Python allocation address. See
  [`cf03_rc4_residue_transpose_350101.md`](../cf03_rc4_residue_transpose_350101.md).
- CF01/CF02 are provider-gated raw-buffer bridges for the fully decoded F0/F1
  ABI: `slot4/5/7` are output/source/auxiliary byte pointers, while low32
  `slot6/8` are source/auxiliary lengths. Their independent
  `cf01_transform_provider=` / `cf02_transform_provider=` callbacks receive
  initial output bytes and raw inputs, must return exactly the source-length
  bytes, and are atomically written back to slot4. The two flattened native
  algorithms remain unrecovered and are never shared by default; missing or
  invalid providers preserve output and slot2 rather than fabricate a result.
- CF53 is the separately wrapped generic shared-reference assignment: it
  replaces slot4 from slot5 and returns slot4 through slot2, matching the
  `0x16F750 -> 0x47C1C` wrapper/helper path.
- CF13 uses its exact positive/otherwise selector to copy slot5 context REF
  `+0x08` or `+0x80` to its hidden slot4 destination.  CF17--CF20 copy the
  proven shared
  reference fields at context offsets `+0x38`, `+0x70`, `+0xd8`, and `+0x18`.
  `RefFieldContext350` models only these evidence-backed fields; the calls
  preserve slot2.  CF67 and CF69 are the same locked operation at `+0xb0` and
  `+0x28`.  CF50/CF52 construct/destroy the three proven MEM_BLOCK members of
  `MemBlockTriplet350` at `+0x20/+0x38/+0x50` and
  `+0x50/+0x38/+0x20` respectively, both preserving slot2.
- CF92 is the conditional-unlock guard destructor: it sets the released state
  and unlocks its host mutex only when the proven `+0x10` state word is zero.
- CF94 writes the TLS-derived pointer to a `HostOutPointer350`; exact replay
  supplies `thread_local_ptr_provider=` so this runtime does not manufacture
  a TLS object or its lifecycle.
- CF97 is the direct `free(slot4)` wrapper. `SparseMemory.free()` accepts only
  exact raw `SparseMemory.alloc()` bases (and NULL), then makes the region
  unreadable; it does not mistake a still-observable freed F8 buffer for a
  CF97 output.
- CF101 is the direct `asprintf((char **)slot4, (char *)slot5, slot6)` wrapper:
  it returns the native byte count in slot2 and writes a host-owned output
  buffer through `HostOutPointer350`.  Because the wrapper provides exactly
  one variadic argument, formats requiring additional arguments (including
  `*` width/precision) are rejected rather than read from invented state.
- CF79, CF85, CF87, and CF88 now share `HostCjsonObject350`, an ordered cJSON host
  model that preserves native insertion order and duplicate keys. CF85 and
  CF87 use `HostCjsonObjectField350`, explicitly representing their recovered
  `*(void **)(slot4 + 8)` object field: they add a C-string or `slot6 & 1`
  boolean respectively, while CF79 receives the cJSON object directly and
  adds a double. CF88 reads the same field from its slot5 argument, prints it
  with cJSON's unformatted mode, and assigns the resulting shared string to
  slot4 without writing slot2. A plain dictionary remains accepted by CF79
  only for backwards-compatible last-value-wins callers. The observed scope
  is F8/X-Medusa: the exact F5/X-Argus, F7/X-Ladon and F13/X-Helios intervals
  do not reach this quartet, but it must not be treated as irrelevant to the
  complete header-signing request because F8 does reach it.
- CF27/CF36/CF45/CF46/CF47 are exact standalone raw XOR-8 handlers: slot4 is a byte
  pointer, signed low32(slot5) is the loop length, each byte is XORed with its
  recovered repeating 8-byte key, and slot2 returns slot4. They do not inspect
  C-string termination or `MEM_BLOCK` fields; readable strings such as `none`,
  `%s`, `X-Argus`, `X-Medusa`, `X-Helios`, and `sign_key` are caller-path
  examples. CF31/CF33 and CF90/CF91 have a closed protobuf-wire-compatible
  size/write ABI—size(slot4) then write(slot4, slot5). They now expose two
  deliberately narrow schema-bound host bridges: CF31/CF33 require observed
  F5 schema `+0x271AD8`, while CF90/CF91 require F8 schema `+0x272080`.
  `slot4` must be a `HostProtoWireMessage350` with the matching schema; each
  bridge accepts only recovered root field kinds, uses descriptor-table order,
  and admits nested bodies only as explicitly schema-anchored captured wire
  bytes. The write side preflights the already mapped raw slot5 range, so a
  short target cannot silently grow or be partially modified. This is not a
  generic protobuf/native-object replacement, does not model trailing raw
  fields or native lifecycle, and does not generalize its deterministic
  captured F5 (`0x91`) or F8 (`0x299`) vectors beyond supplied root values and
  anchored nested wire bodies. See
  [`cf_string_decode_and_proto_serializer_350101.md`](../cf_string_decode_and_proto_serializer_350101.md).
- CF29 is a strict MD5 bridge: slot4 is a hidden `REF_MEM_BLOCK` destination,
  slot5 is the input MEM_BLOCK, and `slot6 & 1` selects a raw 16-byte digest
  or its lowercase 32-byte hexadecimal form. It preserves slot2; the host
  model does not claim a native shared-reference control-block lifecycle.
- CF35 is a provider-gated native-VMP material selector: hidden slot4 receives
  a new MEM_BLOCK selected by exact bytes/length from slot6, while slot5 is
  forwarded unchanged to `cf35_material_provider=`. The provider must return
  the matching ordered VMP material table; its absence/failure is an error,
  not an invented empty result. A selector miss clears slot4 and preserves
  slot2. This deliberately replaces neither VMP `0x1F7860` nor its native
  context/control-block lifecycle.
- CF78 is a provider-gated raw-C-string JSON bridge: slot5 is a NUL-terminated
  byte pointer, while hidden slot4 receives a new `HostRefIdItemWrap350`
  wrapper containing an ordered `HostIdItem350` tree; slot2 is preserved.
  `cf78_json_parser_provider=` must supply native-compatible parse output and
  may return `None` for the native empty-object fallback. It intentionally
  does not treat host text or a generic JSON parser as equivalent to the
  recovered native parser.
- CF82 is a no-input VMP result bridge: its fixed native program has an
  observed path that reads mutable `.bss + 0x2c1040`, so a replay supplies the
  resulting low 32-bit word as `native_globals_u32[82]`. It writes only slot2;
  no device value is embedded and it is not a general `exeVMInner` emulator.
- CF64 remains deliberately unrecovered: its F1 body makes 40 same-frame
  module-program calls and contains direct raw stores. It passes raw outer
  object identities into that graph and has no outer scalar result, so a
  scalar bridge or no-op could silently lose object, memory, or global side
  effects. Its exact frame boundary and reachable-write evidence are recorded
  in
  [`cf63_cf64_child_module_boundary_350101.md`](../cf63_cf64_child_module_boundary_350101.md).
- CF75 remains deliberately unrecovered: its wrapper creates a child frame
  for an independent `0x2BA250` module's F6 export at `qword_2C5B00`. That
  F6 explicitly clears the hidden slot4 target and then writes one of two
  reference/object forms back; its nested F0 has a raw slot5-body pointer.
  The host runtime will not replace it with a no-op. See
  [`cf75_child_module_boundary_350101.md`](../cf75_child_module_boundary_350101.md).
- The other 2 bindings may be explicitly delegated with
  `opaque_cf_handler=OpaqueCfBackend350({cf_index: handler, ...})`.  This is a
  strict trace/recovery bridge, not a synthetic fallback: an unregistered
  index still raises `UnimplementedCfBinding` and does not count as standalone
  recovery.

Run the self-test:

```sh
python3 managed_vm_runtime.py --selftest
```

Generate exact static opcode coverage for a dumped program:

```sh
python3 managed_vm_runtime.py \
  --program-bin ../../../unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F9_0x5c0000_0x3f678.bin \
  --coverage-out coverage_f9.json
```

For a secondary/child-module body whose `0x5e` records index that module's
program table rather than the primary CF table, make the distinction explicit:

```sh
python3 managed_vm_runtime.py \
  --program-bin ../../../unidbg/unidbg-android/target/managed_program_dumps_350101_child_f6/350101_F6_0x5e7000_0x750.bin \
  --call-abi program_table
```

The remaining CF bridge state is intentionally machine-visible; this makes the
next recovery target precise instead of producing a plausible but unverified
signer.

For IDA review, run
[`ida_apply_managed_cf_350101.py`](../../../skills/ida_apply_managed_cf_350101.py)
inside an IDB made from the matching SO.  It derives all 102 wrapper EAs from
`cf_bindings_350101.json`, applies conservative CF names and evidence comments,
and preserves non-default analyst names.  It does not claim an unrecovered
wrapper is executable and does not apply guessed prototypes.

# 350.101 CF string decode and protobuf serializer recovery

This note closes two focused managed-CF evidence chains without promoting an
unobserved host-side replacement.  Static evidence came from the matching
`libmetasec_ml.so.i64` (image base `0`); the original deterministic Unicorn2
`Sign6_350101#testMetasec` run had entry/return hooks on the original eight
wrappers and passed (`1` test, `0` failures, `0` errors).  CF36 is additionally
closed by its matching SO loop, decoded bytecode call sites, and existing local
entry-trace records rather than by inventing a plaintext result.

## CF27 / CF36 / CF45 / CF46 / CF47: raw in-place XOR-8 buffers

All five wrappers have the same managed-frame shape: read slots 4 and 5,
call their respective native decoder, and write its return value to slot 2.

| CF | wrapper | flattened helper / key | observed phase → plaintext examples |
|---|---:|---|---|
| CF27 | `0x16F084` | `decryptString3 @ 0x12CF90`, key `0x2025F8`: `35 1f 7f f7 90 9f e1 b1` | F5: `none`; F7: `%s`; F13: `X-Helios` |
| CF36 | `0x16F2EC` | `sub_12B904`, key `0x2025D8`: `a5 10 71 c7 50 90 e1 b1` | F7/F13 call sites pass raw 8/9-byte buffers; no captured plaintext is claimed |
| CF45 | `0x16F57C` | `decryptString2 @ 0x12BFA8`, key `0x2025E0`: `a5 12 81 d7 60 10 71 b2` | F5/F7: `%s`; F8: `X-Medusa` |
| CF46 | `0x16F5C8` | `decryptString4 @ 0x12C648`, key `0x2025E8`: `b5 20 91 e7 40 a0 e3 b6` | F5: `X-Argus`; F8: `%s` |
| CF47 | `0x16F614` | `decryptString1 @ 0x12C9A4`, key `0x2025F0`: `a7 50 78 c9 60 97 ef f1` | F5/F13: `%s`; F8: `sign_key` |

The focused trace establishes this ABI:

```c
uint8_t *xor8_in_place(uint8_t *buf /* slot4 */, int32_t len /* low32(slot5) */) {
    for (int32_t i = 0; i < len; ++i)
        buf[i] ^= key[i & 7];
    return buf;                         // written to slot2
}
```

Every wrapper forwards slot4 to X0 and slot5 to X1.  Each helper immediately
saves X0/W1; its real continuation uses signed `i < W1`, byte loads/stores,
and the corresponding repeating 8-byte key above.  There is no `strlen`, NUL
test/write, allocation, or `MEM_BLOCK` field access.  Therefore slot4 is a raw
byte pointer and slot5 is a signed low-32-bit raw byte count—not a selector or
a structural object argument.  A negative W1 produces the native no-op and
still returns slot4.

The focused dynamic calls happen to include a terminator in their byte count:
`5 -> "none\\0"`, `3 -> "%s\\0"`, `8 -> "X-Argus\\0"`, and
`9 -> "sign_key\\0"`, `"X-Medusa\\0"`, or `"X-Helios\\0"`.  That is a
caller choice visible in the sampled path, not a helper-level C-string rule;
the XOR loop processes every byte in `[0, len)`, including a NUL when present.

The corrected raw-byte probe directly verifies the recovered equation. For
example, F5 gives `CF27: 5b 70 11 92 90 XOR 35 1f 7f f7 90 = 6e 6f 6e 65 00`
(`none\\0`) and `CF46: ed 0d d0 95 27 d5 90 b6 XOR
b5 20 91 e7 40 a0 e3 b6 = 58 2d 41 72 67 75 73 00` (`X-Argus\\0`). F8 gives
`CF47: d4 39 1f a7 3f fc 8a 88 a7 XOR keyF0 =
73 69 67 6e 5f 6b 65 79 00` (`sign_key\\0`), and `CF45` similarly yields
`X-Medusa\\0`. In every observed event `slot2 == slot4`.

For CF36, the converged loop is at `0x12BED8..0x12BF5C`, and `0x12BF60`
reloads the original X0 return value; its raw key bytes at `0x2025D8` were
cross-checked against the local SO.  The F7 and F13 decoded bytecode set slot4
to a raw stack buffer and slot5 to 8/9 immediately before the call.  This is
static/decoded-bytecode evidence, not a fabricated string result.

The linker-information/`BR` scaffolding is control-flow obfuscation and guard
handling.  The converged loop and five keys are sufficient for an exact
standalone raw-memory handler, now covered by per-key self-test vectors.  The
plaintext list remains an observed sample rather than a lookup-table model.

These are on active header paths: CF36 appears in each F5/F7/F8/F13 compact
path; the other four retain their previously observed phase coverage.  They
must not be marked as outside the main signing request.

## CF31 / CF33 / CF90 / CF91: one protobuf-style size/write pair

The two apparent pairs are aliases of one native serializer pair:

| CF | wrapper | thunk | shared implementation | ABI |
|---|---:|---:|---:|---|
| CF31 | `0x16F19C` | `j_postDataCalcLen @ 0x172234` | `postDataCalcLen @ 0x11615C` | `slot4 -> slot2` serialized byte count |
| CF33 | `0x16F218` | `j_postDataWriteBuf @ 0x172238` | `postDataWriteBuf @ 0x1165B8` | `slot4, slot5 -> slot2` bytes written/final cursor |
| CF90 | `0x16FFE8` | `j_postDataCalcLen_0 @ 0x1722A4` | `postDataCalcLen @ 0x11615C` | same as CF31 |
| CF91 | `0x170014` | `j_postDataWriteBuf_0 @ 0x1722A8` | `postDataWriteBuf @ 0x1165B8` | same as CF33 |

Static decompilation of `0x11615C` walks descriptor `+0x30` field count and
`+0x38` 72-byte field entries, accounting for presence state, field tags and
varints, fixed-width scalars, strings/bytes, repeated values, nested messages,
and trailing 24-byte raw/unknown-field records. `0x1165B8` repeats the walk,
writes `field_number << 3 | wire_type`, and emits the corresponding varint,
fixed32/fixed64, length-delimited, packed, or recursive nested-message bytes.
That is a protobuf-wire-compatible dynamic-message serializer, not a generic
opaque "post-data" callback or a recovered official `.proto` schema.

The following layout boundary is directly visible in both engines and is the
right starting point for any later host model:

```text
message +0x00  -> descriptor*
message +0x08  -> uint32_t trailing_raw_field_count
message +0x10  -> trailing_raw_field_record[24]*

descriptor +0x30 -> uint32_t field_count
descriptor +0x38 -> field_descriptor[72]*

field_descriptor +0x08 -> field number
                 +0x0c -> emission/cardinality control (observed 0/1/3)
                 +0x10 -> type code (0..16)
                 +0x14 -> auxiliary/presence offset in message
                 +0x18 -> field-value offset in message
                 +0x28 -> default/null sentinel
                 +0x30 -> flags (bit0 packed path; bit2 explicit discriminator path)
```

The labels for the two control fields are intentionally descriptive rather
than protobuf-schema claims: their exact meaning varies with the type and
presence branch.  The 24-byte trailing records are written as an already
encoded tag/flag plus raw payload.  This is enough to expose the next recovery
boundary, but not enough to fabricate arbitrary device message objects.

### F5 / CF31-33 observed schema checkpoint

A focused deterministic local run shows CF31 and CF33 share a message whose
first qword is runtime pointer `0x125F1AD8`; with module base `0x12380000`,
this is module-relative schema `0x271AD8`. Both calls use the same slot4
message, CF31 returns `0x91`, and CF33 writes exactly `0x91` bytes to raw
slot5. Its native header gives object size `0xE0`, field count `22`, descriptor
table `0x2723A8`, and zero trailing raw-field records in this vector.

The 22 descriptors are all mode `3`/flags `0`. Their type surface is the F8
root prefix: sint32 (1, 2, 3, 9, 17, 21, 22), string (4--8, 16, 20), bytes
(10, 13, 14, 18, 19), enum (11), sint64 (12), and one nested message (15).
The F5 field-15 descriptor points to a distinct nested schema `0x271980`, not
the F8 field-15 target. The captured full CF33 output has FNV-1a `cca2172f`
and SHA-256 `cee115642ad18ce54df063a67c48262123edd9a688d68e2eb0d14393633b9d40`.
This establishes one strict F5 root checkpoint; it does not establish generic
message allocation, repeated/presence behavior, or the nested schema's field
layout.

### F8 / CF90-91 observed schema checkpoint

A focused local Unicorn2 run closes one concrete schema instance without
generalising it to every post-data message. In F8, CF90 and CF91 share a
message whose first qword is runtime pointer `0x125F2080`; with that run's
module base `0x12380000`, this is module-relative schema `0x272080`
(`unk_272080` in the IDB). CF90 returns `0x299` and the immediately paired
CF91 writes exactly `0x299` bytes.

Static inspection of this schema reports an object size of `0xF8`, 24 field
descriptors at `0x274178`, one index/table at `0x204904`, and initializer
`0x172294`. The 24 descriptors are all mode `3`/flags `0`; their type surface
is bytes (fields 1, 10, 13, 14, 18, 19), sint32 (2, 3, 9, 17, 21, 22), string
(4--8, 16, 20, 24), enum (11), sint64 (12), and nested message (15 to schema
`0x271DD8`, 23 to schema `0x271F10`). The latter has further nested fields 12
and 13 to schemas `0x271C78` and `0x271D30`.

The runtime object agrees with the descriptor walk: message `[0]` is the
schema pointer, `[8]` the raw-field count, and `[16]` the raw-field pointer.
Field 1 at message `+0x18` is `{len=0x10, ptr=0x12891F38}` and field 2 at
`+0x28` is `5`; the writer begins `0A 10 ... 10 0A`, i.e. field 1 as a
16-byte length-delimited value followed by field 2's varint value 10 in the
current vector. The process-local addresses are evidence anchors only, not
portable replay constants.

This establishes that a narrow schema-specific host serializer is possible.
It does not yet authorize a generic replacement: a correct VM model still
needs evidence for the managed program's field population, guest allocation,
presence state, nested ownership, and lifecycle.

The dynamic run observes the required two-pass contract:

```text
F5 / X-Argus:
  CF31(slot4=message) -> slot2=0x91
  CF33(slot4=same message, slot5=writable buffer) -> slot2=0x91

F8 / X-Medusa:
  CF90(slot4=message) -> slot2=0x299
  CF91(slot4=same message, slot5=zeroed writable buffer) -> slot2=0x299
```

The F8 destination begins with protobuf wire-format bytes such as
`0A 10 ... 10 ... 1A ... 22 04 31 31 32 38 ...`; this independently matches the
descriptor-walker conclusion. The direct caller `postDataToBuf @ 0x128D6C`
provides the strongest ownership/capacity evidence: it calls `calcLen(msg)`,
resizes a MEM_BLOCK to that length, records `src_len=len`, and passes the raw
body pointer to `writeBuf(msg, body.mem)`. Neither write wrapper nor
`0x1165B8` receives a capacity argument or performs a capacity check; slot5
is a raw writable `uint8_t *`, and the caller must reserve at least the
preceding size-pass result. The observed return equals the size pass, making
slot2 the final cursor/number of bytes written. If the message changes between
the two calls, this implementation provides no independent protection.

CF31/CF33 belong to the F5 Argus route and CF90/CF91 to the F8 Medusa route.
Thus both pairs are relevant to complete request signing.

### Deliberately narrow F5/F8 host bridges

The standalone runtime now registers both bounded alias pairs as semantic
replay surfaces:

| pair | accepted root schema | observed native root size | fixture length |
|---|---:|---:|---:|
| CF31 / CF33 | `0x271AD8` (F5) | `0xE0` | `0x91` |
| CF90 / CF91 | `0x272080` (F8) | `0xF8` | `0x299` |

`slot4` must resolve through `HostHeap` to a `HostProtoWireMessage350` with
the matching schema offset; it is not accepted as a raw native message
pointer, and the F5/F8 schemas are not interchangeable despite their shared
native engine. The bridges encode recovered root fields in descriptor-table
order and accept only these exact value forms:

- bytes, strict UTF-8 text, signed 32/64-bit ZigZag values, and a nonzero
  unsigned-32-bit enum for their matching observed field types;
- explicitly anchored `OpaqueProtoWireMessage350` bytes for the F5 nested
  target (`0x271980`) or F8 nested targets (`0x271DD8` and `0x271F10`), because
  their full field layouts remain unclosed;
- omission of a field for the observed mode-3/default-omission state.

Unknown schemas, fields, duplicate root-field occurrences, value types,
default-present values, trailing raw field records, or unmodeled nested object
layouts fail with `ManagedVmError`.
The helper does not pretend to parse or construct native message memory. Each
size binding returns the resulting byte length; each write binding serializes
the same host message to raw `slot5` only if every output byte is already
mapped, then updates slot2. This host preflight is an explicit safety boundary
around the native no-capacity ABI, not a claim that the native writer performs
such a check.

The self-test uses a mixed root-field vector and proves deterministic
descriptor order, all-or-nothing rejection of a short destination, and
rejection of cross-schema aliases. It carries both complete deterministic local
fixtures: CF33/F5 reserializes to `0x91` bytes with SHA-256
`cee115642ad18ce54df063a67c48262123edd9a688d68e2eb0d14393633b9d40`
(trace FNV-1a `cca2172f`), while CF91/F8 reserializes to `0x299` bytes with
SHA-256 `e165201118d59a72fc08af30a585fe563e29b8a3241f923f2dc9c58f6b50da6e`
(trace FNV-1a `fa8d2d9c`). The F5 field-15 and F8 fields 15/23 inputs remain
schema-anchored opaque bodies. These are byte-level evidence for fixed local
vectors, not a claim that future device state, raw trailing records, presence
representation, or nested ownership/lifecycle is generically recovered.

## Naming and reproducibility boundary

The runtime manifest labels the bounded pairs `proto_wire_f5_size` /
`proto_wire_f5_write` and `proto_wire_f8_size` / `proto_wire_f8_write`. IDA
annotations continue to describe all four native wrappers as `protoWire`
aliases, not as a recovered official `.proto`. The XOR names denote a fully
recovered raw-buffer primitive; neither protobuf label claims a generic host
message model.

The focused trace is reproducible through the existing `Sign6MetaSecBase`
managed-CF argument/post hooks with Unicorn2, deterministic settings, and
callsites `0x16f084,0x16f19c,0x16f218,0x16f57c,0x16f5c8,0x16f614,0x16ffe8,0x170014`.
For the bounded local fixtures, optional
`-Dmetasec.dumpCf33Wire=true -Dmetasec.dumpCf33WireMaxBytes=0x91` and
`-Dmetasec.dumpCf91Wire=true -Dmetasec.dumpCf91WireMaxBytes=0x299` switches
emit only their matching post-return `slot5` bodies after the size result is
within the probe's `0x10000` ceiling; both are disabled by default.

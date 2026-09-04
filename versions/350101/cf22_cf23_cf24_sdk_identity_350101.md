# CF22 / CF23 / CF24 SDK identity bindings — 350.101

These three adjacent managed-CF wrappers share identity inputs but have three
different ABIs and lifetimes.  They occur consecutively in both the F5
(X-Argus) and F8 (X-Medusa) managed sequences.

| CF | wrapper | native helper | managed ABI | observed deterministic local result |
|---|---:|---:|---|---|
| CF22 | `0x16EFB0` | `0xAA9B4` | hidden `REF_MEM_BLOCK*` output in slot4/X8; slot2 unchanged | UTF-8 `35.1.0` |
| CF23 | `0x16EFCC` | `0x5897C -> 0x590D4` | no slot input; zero-extended `uint32` to slot2 | `0x04090500` |
| CF24 | `0x16EFF0` | `0x62260 -> 0x64338` | no slot input; cached raw `char *` to slot2 | `v04.09.05-ml-android` |

## CF22: Java app-version REF output

The wrapper obtains `frame.slot4`, moves it to AArch64 hidden result register
`X8`, and calls `0xAA9B4`; it never calls `managedFrameSetSlot`.  The helper
calls `MS.b(0x1000011, 0, 0, null, null)`, reads a Java string as UTF-8, and
assigns a shared MEM_BLOCK to the X8 `REF_MEM_BLOCK` destination.  Null, empty
or conversion failure follows the native empty-block path.

Focused local F5 and F8 captures agree on `35.1.0`:

```text
REF +0x00 = MEM_BLOCK*, +0x08 = control pointer
MEM_BLOCK +0x08 mem_len=7, +0x0c src_len=6, +0x10 body="35.1.0"
body FNV-1a = 49a0673e
```

This proves the visible destination and slot behavior, but not native control
block allocation, Java exception handling, or OOM behavior.

## CF23: guarded version word

`0x5897C` caches its first `uint32` result behind a C++ guard.  Its initializer
copies the version text, forces terminators at offsets 3 and 6, then obtains
the decimal components at offsets 1, 4 and 7.  It constructs:

```text
major << 24 | minor << 16 | patch << 8 | flavor_bits | platform_bits
```

The static first-character branches are `m -> 0`, `e -> 0x20` for the flavor,
and `i/l/w -> 1/2/3` for the platform; all other first characters contribute
zero.  The observed `v04.09.05` / `ml` / `android` identity gives
`0x04090500` in both F5 and F8.

## CF24: guarded identity C string

`0x62260` independently caches a pointer to a 64-byte native buffer.
`0x64338` decrypts the format `%s-%s-%s` and formats the semver, flavor, and
platform components.  The local return pointer was stable across F5/F8 and
its 20-byte NUL-terminated content had FNV-1a `6b643bc5`:

```text
v04.09.05-ml-android
```

## Strict standalone model

`HostSdkIdentity350` and `sdk_identity_provider=` are deliberately required by
the executable adapters.  No observed app or SDK string is a runtime default.

- CF22 evaluates `app_version` every call, sets slot4's `Ref` to a UTF-8
  `MemBlock`, and preserves slot2.
- CF23 parses only the observed `vNN.NN.NN` form and retains its first cached
  word.
- CF24 allocates one host-owned 64-byte, NUL-terminated buffer and retains its
  first pointer.

The host allocation is a lifetime-compatible replacement, not a claim about
the native global address or allocator.  The runtime self-test covers the
current fixture, CF22's empty fallback, cache stability after the provider
changes, slot preservation, and missing-provider failure.

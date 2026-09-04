# CF03 address-seeded RC4 / residue transpose — 350.101

`CF03 @ 0x16EBC0` is now recovered as a bounded binary transform.  This is a
static CFG/data-flow recovery, not a newly collected device result vector:
the one native value that cannot be reproduced by an ordinary host allocation
is the temporary `MEM_BLOCK.body.mem` address.  The executable bridge accepts
that already-captured address explicitly and never dereferences it.

## Managed ABI

| source | AArch64 use | meaning |
|---|---|---|
| slot4 | hidden `X8` | `REF_MEM_BLOCK*` destination |
| slot5 | `X0` | input `MEM_BLOCK*`; data/length are read at `+0x10/+0x0c` |
| slot6 | `X1` | raw `u64` scalar; bytes at bits `24..31` and `16..23` affect the transform |
| slot2 | — | not written by the wrapper |

The wrapper calls `0x16C65C` and returns without a
`managedFrameSetSlot(frame, 2, ...)`.  It always replaces the hidden output
only after the transform has completed.

## Recovered transform

Let `src` be the exact binary bytes of slot5, `q` be slot6, and `p` be the
captured native body address of the temporary `len(src)+7` block.  All byte
expressions below are masked to `0xff`.

```text
key = [ q>>24, p, 0x16, p>>8, 0x4a, p>>16, 0x87, q>>16 ]
A   = [ 0x87, 0x05, q>>24, q>>16, p, p>>8, p>>16 ] + RC4(key, src)
stride = 8 | ((p >> 24) & 3)       # 8..11
B   = [ bit_reverse8(stride) ] + A[0::stride] + ... + A[stride-1::stride]
```

`B` has exactly `len(src)+8` bytes.  This is a residue-major transpose of the
whole `A` buffer, not a lossy sample.  NUL bytes in `src` remain data.

The runtime exposes this narrow environmental input as:

```python
CfRegistry350(
    memory,
    heap,
    cf03_temp_body_address_provider=lambda source, raw_slot6: captured_p,
)
```

The callback must return one `u64`.  Missing, invalid, or failing providers
leave the existing slot4 `Ref` and slot2 untouched.  `p` is shifted and masked
only; it is never treated as a host pointer.

## Static check vector

```text
p      = 0x12345678
slot6  = 0xDEADBEEF11223344
input  = 00 01 02 41 00 42
key    = 11 78 16 56 4a 34 87 22
A      = 87 05 11 22 78 56 34 ae 33 31 ab e7 e8 13
B      = 50 87 ab 05 e7 11 e8 22 78 56 34 ae 33 31
```

This vector, provider-failure preservation, hidden-REF replacement, and
slot2 preservation are covered by
[`managed_vm_runtime.py`](managed_vm_runtime_350101/managed_vm_runtime.py)'s
`--selftest`.

## Static anchors

- wrapper argument moves: `0x16EBC8..0x16EC00`;
- temporary `len(src)+7` allocation: `0x16C6E4..0x16C6F4`;
- 8-byte RC4 KSA and PRGA: `0x16C85C..0x16C914` and
  `0x16C998..0x16CA4C`;
- final `len(src)+1` block, address-derived stride, and transpose:
  `0x16CA50..0x16CB40`;
- bit-reversed leading byte produced by the recovered F4 path:
  `0x16CB44..0x16CB54`.

The matching IDB uses `cf03_rc4_residue_transpose_memblock_ref_350` and
`cf03_rc4_residue_transpose_350` to make this boundary visible without
claiming that a host allocation can reproduce the native address input.

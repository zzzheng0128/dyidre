# CF64 child-F opcode recovery — 350.101

Scope: the module at `0x2C5260` reached by CF64's child F1, not the primary
sign module.  The two opcode definitions below come from the 350.101
`managedBytecodeRun_350` dispatch tables and handlers in
`libmetasec_ml.so`; they are not inferred from similarly shaped F bodies.

## `OP_17` → `SHL32_VAR`

The lower opcode dispatcher at `0x157614` subtracts one from the opcode and
indexes the halfword table at `0x203686`, with handler base `0x157640`.
For opcode `0x17`, table element `0x16` is `0x14a`, selecting handler
`0x157b68`.

That handler loads qword-slot operands `p0` and `p1`, performs AArch64
`lsl w9, w10, w9`, then sign-extends the 32-bit result into destination slot
`p2`. Its bytecode meaning is therefore:

```c
S[p2] = (int32_t)((uint32_t)S[p1] << ((uint32_t)S[p0] & 31));
```

`p3`, `imm16`, and `q1` are not operands for this opcode.  This resolves all
18 formerly-unknown records in F2/F6/F9/F12/F15/F18, all 15 in the 40
second-hop bodies, and 20 in the third-hop bodies.

## `OP_7E` → `REM_U32`

The middle dispatcher at `0x156878` subtracts `0x41`, indexes table
`0x203606`, and uses handler base `0x15689c`.  For opcode `0x7e`, table
element `0x3d` is `0x333`, selecting handler `0x157568`.

The handler uses `udiv w12, w9, w10`, then joins the common
`msub w9, w12, w10, w9` result path and sign-extends into `p2`.  This is an
unsigned 32-bit remainder.  AArch64 `UDIV` returns zero for a zero divisor,
so the interpreter preserves the dividend in that edge case:

```c
S[p2] = (int32_t)((uint32_t)S[p1] == 0
    ? (uint32_t)S[p0]
    : (uint32_t)S[p0] % (uint32_t)S[p1]);
```

The six recovered `OP_7E` records occur once each in F29/F31/F33/F35/F37/F39.

## Decoder regression result

The reusable managed decoder now renders both instructions. Re-running it
against the immutable `repeat=0` body dumps gives full mechanical coverage:

| reachable layer | bodies | records | known | unknown |
|---|---:|---:|---:|---:|
| F1 plus F2--F21 | 21 | 10,521 | 10,521 | 0 |
| second hop | 40 | 3,900 | 3,900 | 0 |
| third hop | 23 | 13,655 | 13,655 | 0 |
| total reachable F bodies | 84 | 28,076 | 28,076 | 0 |

This closes the managed-bytecode decoding and the F-table call graph under
child F1. The slot ABI and local direct callee effects of child-native targets
`0x0d..0x16` are now separately recorded in
[`cf64_child_native_abi_350101.md`](cf64_child_native_abi_350101.md). What
remains opaque is outer-object aliasing, cross-call concrete effects and
dynamic coverage, so that ABI closure does not promote CF64 to a standalone
lift. Two bounded helpers are also known: index `0x0b` is
`memset(s4, low8(s5), s6) -> s2`, and index `0x0c` is
`memmove(s4, s5, s6) -> s2`.

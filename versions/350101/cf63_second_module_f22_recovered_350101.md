# CF63 second-module F22 recovery — 350.101

Status: standalone implemented. The native wrapper `0x16FA34` forwards outer
slot4 to the `0x152B58` second module's F22 at `qword_2C5310`, then
zero-extends child slot2's low word into outer slot2.

## Evidence

The local `dumpOnly` descriptor/body capture used table base `0x2C5260` and
program ID `22` after `JNI_OnLoad`:

```text
F22 code: 0x126BB800..0x126BBAA0
body size: 0x2A0 (28 records)
SHA-256: 5ef9d0da0dff093f2effb7958f7585dcf673331dcc2c6e4bc45fbe747a82f2ed
```

All 28 records decode under the recovered managed-VM ISA. The body reads only
`child.s4 + 0x0c` (signed logical length), `child.s4 + 0x10` (body pointer),
and each input byte. It contains no `ST8/ST16/ST32/ST64` record and no
`CALL_CF` record. A direct interpreter-versus-independent recurrence check
over byte strings of lengths 0 through 64 confirmed both the child slot2
result and byte-for-byte preservation of the mapped header/body.

## Exact low-32-bit recurrence

For the non-negative logical body length `n`, initialize `x = 0x20230928`.
For each `b = data[i]`, with every intermediate reduced to `u32`:

```text
if i is even:
    t = (x << 6) ^ x
    x = (x >> 4)
    x = b ^ t ^ x
else:
    t = (x << 12) | b
    x = (x >> 7) ^ x
    x = ~(t ^ x)
```

The wrapper writes `u32(x)` to outer slot2. A native negative signed length
does not enter the loop and returns `0x20230928`; the host MEM_BLOCK model has
only non-negative visible byte lengths.

## Regression vectors

| slot4 MEM_BLOCK bytes | outer slot2 |
|---|---:|
| empty | `0x20230928` |
| `00` | `0x2AE373BA` |
| `00 01` | `0xE272EAA3` |
| `61 62 63` | `0x716D1D28` |
| `00..0F` | `0xF6A0D105` |
| ASCII `MetaSec-F22` | `0x1103E6A1` |

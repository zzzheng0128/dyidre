# F4 managed VM decode stats

- records: `17`
- known records: `17`
- unknown records: `0`
- unique ops: `5`

| op | count | mnemonic | semantic |
|---:|---:|---|---|
| `0xb2` | 6 | `AND64_IMM16` | s2 = s1 & 0xf |
| `0x18` | 4 | `SHL32_IMM` | s1 = (int32_t)(s4 << 0) |
| `0x0e` | 3 | `LSR32_IMM` | s1 = sign_extend_32((uint32_t)s1 >> 4) |
| `0x34` | 3 | `OR64` | s1 = s1 / s2 |
| `0x5b` | 1 | `RET` | return/leave with s31 |

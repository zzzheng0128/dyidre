# F6 managed VM decode stats

- records: `25`
- known records: `25`
- unknown records: `0`
- unique ops: `7`

| op | count | mnemonic | semantic |
|---:|---:|---|---|
| `0x34` | 8 | `OR64` | s30 = s29 / s0 |
| `0x58` | 5 | `LD64` | s4 = *(uint64_t *)(s5 +0x10) |
| `0x85` | 4 | `ADD64_IMM16` | s29 = s29 -0x40 |
| `0x25` | 4 | `ST64` | *(s29 +0x38) = s31 |
| `0x5e` | 2 | `CALL_CF_INDEX` | call native_binding[index=0x30] via q1 table |
| `0x52` | 1 | `LD32S` | s1 = *(int32_t *)(s5 +0xc) |
| `0x5b` | 1 | `RET` | return/leave with s31 |

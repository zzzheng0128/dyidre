# CF80 / CF81 native-global readers — 350.101

| CF | wrapper | helper | behavior |
|---|---:|---:|---|
| CF80 | `0x16FDC0` | `0xA28BC` | load `uint32_t` from native global A and write slot2 |
| CF81 | `0x16FDE4` | `0xA28C8` | load `uint32_t` from native global B and write slot2 |

Both wrappers call their helper with no data arguments, move `W0` to the
third argument of `managedFrameSetSlot_350(frame, 2, value)`, and return.
The globals reside in mutable native state, so the standalone runtime requires
`native_globals_u32={80: value_a, 81: value_b}` rather than fabricating a
zero-valued environment.

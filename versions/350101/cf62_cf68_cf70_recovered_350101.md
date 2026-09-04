# CF62 / CF68 / CF70 trivial native bindings — 350.101

These wrappers were recovered directly from the matching 350.101 SO rather
than inferred from call frequency.

| CF | wrapper | native callee | observable ABI |
|---|---:|---:|---|
| CF62 | `0x16F9F8` | `0x642B0` | copy shared ref `slot5 -> slot4`; leave slot2 unchanged |
| CF68 | `0x16FB54` | `getpid@plt` | write zero-extended `W0` into slot2 |
| CF70 | `0x16FBB0` | `getppid@plt` | write zero-extended `W0` into slot2 |

`0x642B0` clears the destination pair, copies the source object/control-block
pair, and increments `control_block[0]` when present.  It returns without the
wrapper calling `managedFrameSetSlot_350`, unlike CF40.

The standalone runtime accepts `process_id_provider=` and
`parent_process_id_provider=`.  They are necessary for deterministic replay:
host `getpid()` values are useful defaults but are not device oracle values.

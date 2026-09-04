# CF66 / CF89 realtime bindings — 350.101

| CF | wrapper | helper | slot2 value |
|---|---:|---:|---|
| CF66 | `0x16FAF8` | `0x12E0A0` | `current_time_millis / 1000` |
| CF89 | `0x16FFC4` | `0x12E09C -> 0x143858` | `current_time_millis` |

`0x1A4CC4` invokes `clock_gettime(CLOCK_REALTIME, ...)` and produces a
microsecond timestamp.  `0x143858` divides it by 1000 to produce milliseconds;
`0x12E0A0` divides that result by another 1000.  Each wrapper stores the
result through `managedFrameSetSlot_350(frame, 2, W0/X0)`.

The host runtime uses one injectable `current_time_millis_provider` for both
CFs.  This preserves their exact native relation and plugs directly into the
existing 350.101 deterministic `fixedCurrentTimeMillis` setting.

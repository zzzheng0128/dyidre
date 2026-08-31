# 350.101 managed bytecode decoder summary

- dump_dir: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_f20_f40_f43_46_350101_20260831_042856`
- out_dir: `/Users/freeman/project/douyin/dyidre/versions/350101/managed_vm_decode_f20_f40_f43_46`

| program | records | known | unknown | top ops | decoded listing | linear lift |
|---|---:|---:|---:|---|---|---|
| `F20` | 704 | 704 | 0 | 0x58:312, 0x25:309, 0x34:22, 0x85:12, 0x5e:12, 0xae:5, 0x52:4, 0xb3:3 | [`F20_350101_F20_0x879000_0x4200.decoded.asm`](F20_350101_F20_0x879000_0x4200.decoded.asm) | [`F20_350101_F20_0x879000_0x4200.linear.c`](F20_350101_F20_0x879000_0x4200.linear.c) |
| `F40` | 67 | 67 | 0 | 0x25:12, 0x34:12, 0x58:12, 0x85:10, 0x84:4, 0x59:4, 0xae:3, 0x02:2 | [`F40_350101_F40_0x62ef00_0x648.decoded.asm`](F40_350101_F40_0x62ef00_0x648.decoded.asm) | [`F40_350101_F40_0x62ef00_0x648.linear.c`](F40_350101_F40_0x62ef00_0x648.linear.c) |
| `F43` | 28 | 28 | 0 | 0x59:8, 0x85:4, 0x02:4, 0x26:4, 0x84:3, 0xb2:1, 0x6e:1, 0xae:1 | [`F43_350101_F43_0x606b00_0x2a0.decoded.asm`](F43_350101_F43_0x606b00_0x2a0.decoded.asm) | [`F43_350101_F43_0x606b00_0x2a0.linear.c`](F43_350101_F43_0x606b00_0x2a0.linear.c) |
| `F44` | 26 | 26 | 0 | 0x59:8, 0x84:5, 0x85:4, 0x26:4, 0x53:1, 0x58:1, 0xae:1, 0xa7:1 | [`F44_350101_F44_0x5d9680_0x270.decoded.asm`](F44_350101_F44_0x5d9680_0x270.decoded.asm) | [`F44_350101_F44_0x5d9680_0x270.linear.c`](F44_350101_F44_0x5d9680_0x270.linear.c) |
| `F45` | 21 | 21 | 0 | 0x59:10, 0x26:10, 0x5b:1 | [`F45_350101_F45_0x5e2200_0x1f8.decoded.asm`](F45_350101_F45_0x5e2200_0x1f8.decoded.asm) | [`F45_350101_F45_0x5e2200_0x1f8.linear.c`](F45_350101_F45_0x5e2200_0x1f8.linear.c) |
| `F46` | 154 | 154 | 0 | 0x85:31, 0x34:21, 0x5a:16, 0x5e:16, 0x58:14, 0x02:12, 0x25:11, 0x84:10 | [`F46_350101_F46_0x87e000_0xe70.decoded.asm`](F46_350101_F46_0x87e000_0xe70.decoded.asm) | [`F46_350101_F46_0x87e000_0xe70.linear.c`](F46_350101_F46_0x87e000_0xe70.linear.c) |

## Recognized 350.101 Source-Work Families

These notes are pattern anchors for upgrades. They summarize the already-recovered F8/X-Medusa source-work producer topology; the linear lifts above remain the bytecode-level evidence.

| family | outer | adapter | block loop | key/pre | scheduler | rounds | dump state |
|---|---|---|---|---|---|---|---|
| `F18/F22/F23` | `F18` | `F22` | `F23` | `F24` | `F25` | `F26, F27, F28, F29` | not present in this dump |
| `F19/F31/F32` | `F19` | `F31` | `F32` | `F33` | `F34` | `F35, F36, F37, F38` | not present in this dump |
| `F20/F39/F40` | `F20` | `F39` | `F40` | `F41` | `F42` | `F43, F44, F45, F46` | partial 6/9; missing F39, F41, F42 |
| `F21/F47/F48` | `F21` | `F47` | `F48` | `F49` | `F50` | `F51, F52, F53, F54` | not present in this dump |

Common recovered semantics:

- `F22/F31/F39/F47`: adapter = family key expansion + copy 16-byte IV to `key_area+0xb0`.
- `F23/F32/F40/F48`: block loop ABI is `s4=key_area`, `s5=data`, `s6=byte_length`.
- Per block: `block ^= key_area+0xb0`, call scheduler, then `block ^= key_area+0x10`; the final block becomes the next IV at `key_area+0xb0`.
- `F30`: shared GF(2^8) multiply with reduction byte `0x1b`.

Scheduler sequences:

- `F25`: `F26(0) -> F27 -> F28 -> F29 -> F26(1) -> F27 -> F28 -> F26(2)`
- `F34`: `F35(0) -> F36 -> F37 -> F38 -> F35(1) -> F36 -> F37 -> F35(2)`
- `F42`: `F43(0) -> F44 -> F45 -> F46 -> F43(1) -> F44 -> F45 -> F43(2)`
- `F50`: `F51(0) -> F52 -> F53 -> F54 -> F51(1) -> F52 -> F53 -> F51(2)`

Family key constants/tables:

- `F24`: const `0xbbb5de72`, table `secondary+0x33a`
- `F33`: const `0xd4638d5b`, table `secondary+0x484`
- `F41`: const `0x92a5f73b`, table `secondary+0x585`
- `F49`: const `0x89f8a1c9`, table `runtime_pool+0x171`

Upgrade rule: align this topology by shape first, not by F-number. Look for outer programs calling an adapter plus block loop, then a 20-record adapter, a 67-record block loop, a 43-record scheduler, and the shared 21-record GF multiply.

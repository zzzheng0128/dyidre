# 350.101 F8 / X-Medusa pack recovery

- Source log: `/Users/freeman/project/douyin/unidbg/unidbg-android/target/sign6_350101_f8_rawcf_20260831_033000.log`
- F8 main filter: `interp+0x00 == 0x310000010d7`
- CF44 input length: `0x2c8`
- CF44 input fnv1a from log: `c98dbe97`
- Reconstructed from CF07 fragments: `True`
- `base64(CF44 input)` equals emitted X-Medusa: `True`
- Raw CF44 input bin: `/Users/freeman/project/douyin/dyidre/versions/350101/x_medusa_pack_350101_cf44_input.bin`

## Final F8 pack layout

| dst off | len | source | status | hit | src fnv/hex preview |
| --- | --- | --- | --- | --- | --- |
| +0x0 | 0x14 | 0x1271c6a0 | 0x1018 | 61 | a1 84 94 6a 89 cf db a0 ed f1 99 29 9b 31 3a 46 86 e9 58 3c |
| +0x14 | 0x2 | 0x125d7f98 | 0x1056 | 62 | be ae |
| +0x16 | 0x1 | 0x12849e18 | 0x1097 | 63 | 00 |
| +0x17 | 0x1 | 0x12849e1c | 0x10d8 | 64 | 01 |
| +0x18 | 0x1 | 0x125e858f | 0x111c | 65 | fa |
| +0x19 | 0x2af | 0x12607700 | 0x1160 | 66 | 35 46 e8 3a 34 81 ca 06 18 11 ed b7 09 bd 98 05 f0 8e 0b bf 81 c2 24 44 45 bf 01 76 f8 4a 2f b8 f5 fb 0d bf 6c bc 31 25 ... |

This sums to `0x2c8` bytes, exactly the CF44 source length.

## Mini-pack work area

- mini-pack base: `0x1271c6a0`, len `0x14`
- bytes copied into final `+0x00`: `a1 84 94 6a 89 cf db a0 ed f1 99 29 9b 31 3a 46 86 e9 58 3c`
- pre-transform assembly hex: `05 00 00 00 2d 4b 4f ca 49 75 0d 43 3f b5 ae 2c 22 6d cc 56`
- pre-transform equals final-copy bytes: `False`
- mutation: F8 main `ST8` loop XORs all five 4-byte lanes with dynamic
  little-endian `key32`. For this rawCF run the recovered key is
  `0x6a9484a4`, and `pre ^ key32-repeat == final`.
- oracle: `f8_medusa_mini_xor_recovered_350101.c`, current `failures=0`.

| dst off | len | source | status | hit | hex |
| --- | --- | --- | --- | --- | --- |
| +0x0 | 0x4 | 0x12849f34 | 0xc57 | 51 | 05 00 00 00 |
| +0x4 | 0x10 | 0x12849f38 | 0xc94 | 52 | 2d 4b 4f ca 49 75 0d 43 3f b5 ae 2c 22 6d cc 56 |

## Large subpack work area

- subpack base: `0x12607700`, len `0x2af`
- bytes copied into final `+0x19`: `35 46 e8 3a 34 81 ca 06 18 11 ed b7 09 bd 98 05 f0 8e 0b bf 81 c2 24 44 45 bf 01 76 f8 4a 2f b8 f5 fb 0d bf 6c bc 31 25 38 fd 01 17 d0 6e 38 3d f0 b4 12 e6 a8 24 06 6b c0 5d 99 1e d9 54 80 13 0f 5a 63 02 e0 fd 1c a4 63 60 61 32 f2 c5 7f ea a2 84 64 30 42 a4 53 f2 1c 3c 83 55 17 0b f2 b9 c3 64 5a 48 82 fe 6d a9 8f 32 c8 c0 77 e0 54 1d 8f fb a7 f1 c5 ff 11 e0 ef 9a 5f 20 95 c0 2b c0 ...`
- pre-transform assembly hex preview: `35 46 e8 2a 30 01 c8 07 18 11 e5 b7 09 3d 98 05 f0 ae 0b bf 85 42 24 45 45 9f 01 66 fc ca 2f b9 b5 db 0d bf 68 bc 33 24 38 dd 09 07 d0 ee 3a 3d f0 94 1a e6 ac 24 04 6a 80 5d 99 1e d9 54 82 13 4f 7a 6b 12 e0 fd 1e a5 63 60 69 22 f2 c5 7f ea a2 84 64 30 42 a4 53 f3 1c 3c 83 45 17 8b f0 b9 83 64 52 48 86 7e 6d a8 cf 12 c8 c0 73 60 56 1c cf fb af f1 c1 ff 13 e1 ef ba 5f 20 95 c0 29 c1 ...`
- pre-transform equals final-copy bytes: `False`

| dst off | len | source | status | hit | hex preview |
| --- | --- | --- | --- | --- | --- |
| +0x0 | 0x1 | 0x12849e74 | 0xd31 | 53 | 35 |
| +0x1 | 0x8 | 0x12849e68 | 0xd6d | 54 | 46 e8 2a 30 01 c8 07 18 |
| +0x9 | 0x2a4 | 0x12607400 | 0xdaa | 55 | 11 e5 b7 09 3d 98 05 f0 ae 0b bf 85 42 24 45 45 9f 01 66 fc ca 2f b9 b5 db 0d bf 68 bc 33 24 38 dd 09 07 d0 ee 3a 3d f0 ... |
| +0x2ad | 0x2 | 0x12849f24 | 0xde8 | 56 | 69 4c |

## High-level shape

```c
MEM_BLOCK mini, sub, final, b64;
memcpy(mini + 0x00, dyn4,  0x04);
memcpy(mini + 0x04, dyn16, 0x10);

memcpy(sub + 0x000, flag1,        0x01);
memcpy(sub + 0x001, time_or_seed8, 0x08);
memcpy(sub + 0x009, blob,         blob_len);
memcpy(sub + 0x009 + blob_len, trailer2, 0x02);

mini = medusa_mutate_work_area(mini);
sub  = medusa_mutate_work_area(sub);

memcpy(final + 0x000, mini,       0x14);
memcpy(final + 0x014, const2,     0x02);
memcpy(final + 0x016, zero1,      0x01);
memcpy(final + 0x017, one1,       0x01);
memcpy(final + 0x018, marker1,    0x01);
memcpy(final + 0x019, sub,        sub_len);
X_Medusa = base64(final);
```

## Notes for next version alignment

- Filter nested managed calls by `interp+0x00`; phase text alone is not enough.
- `CF07` is byte-copy assembly; dump raw bytes, not C strings.
- `CF44` is the base64 boundary. If `base64(CF44 input)` equals `X-Medusa`, the pack reconstruction is byte-exact.
- Dynamic byte values vary with request/time/random state; layout offsets are the stable upgrade signal.
- Work-area mutation has now been pinned down in
  `f8_x_medusa_mutation_watch_350101.md`: mini is rewritten by F8 main `ST8`,
  and large subpack prefix is rewritten by nested F12 `ST64`.

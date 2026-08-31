# MetaSec 350.101 source-work runtime vectors

This report is generated from unidbg `[source-work]` logs.

## Coverage

| program | hits |
|---|---:|
| F22 | 3 |
| F23 | 3 |
| F31 | 2 |
| F32 | 2 |
| F39 | 3 |
| F40 | 3 |
| F47 | 1 |
| F48 | 1 |

## Runs

| log | programs |
|---|---|
| `unidbg/unidbg-android/target/sign6_350101_sourcework_20260831_062402.log` | F22 -> F23 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_01.log` | F39 -> F40 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_02.log` | F31 -> F32 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_03.log` | F22 -> F23 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_04.log` | F39 -> F40 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_05.log` | F31 -> F32 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_06.log` | F22 -> F23 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_07.log` | F47 -> F48 |
| `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_08.log` | F39 -> F40 |

## Family vectors

### F18 family: F22/F23

- inner chain: `F24/F25/F26/F27/F28/F29`
- evidence log: `unidbg/unidbg-android/target/sign6_350101_sourcework_20260831_062402.log`
- adapter bodyId/code: `0x2000016019` / `0x125e1400-0x125e15e0`, records=20
- loop bodyId/code: `0x500001606d` / `0x1262e100-0x1262e748`, records=67

| item | hex |
|---|---|
| F22 source_key16 | `f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4` |
| F22 iv16 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F22 post key_area+0x10 | `0c 35 6c 5d 08 85 70 6b 4e a8 de d5 46 eb 30 8a` |
| F22 post key_area+0xb0 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F23 entry data | `fc a0 86 0d 1e 8c 1e d0 c6 86 69 9d 58 36 f8 cb dc 9b c4 d7 04 f9 5c 11 f2 be 75 cd 00 ae dd 01` |
| F23 post data | `8f d4 65 c6 81 b0 29 e6 33 e7 05 68 98 8c f0 da ea db f7 03 62 c6 6f 9f 18 88 b0 cd 5b 5f dc 58` |
| F23 post key_area+0xb0 | `ea db f7 03 62 c6 6f 9f 18 88 b0 cd 5b 5f dc 58` |

Checks:

- adapter post +0xb0 == loop entry +0xb0: OK
- adapter post +0x10 == loop entry +0x10: OK
- loop post +0xb0 == post.data tail16: OK

### F19 family: F31/F32

- inner chain: `F33/F34/F35/F36/F37/F38`
- evidence log: `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_02.log`
- adapter bodyId/code: `0x200001617c` / `0x125e1800-0x125e19e0`, records=20
- loop bodyId/code: `0x50000161d0` / `0x1262e800-0x1262ee48`, records=67

| item | hex |
|---|---|
| F31 source_key16 | `f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4` |
| F31 iv16 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F31 post key_area+0x10 | `23 9e 6c dc 0e 7d a6 85 61 03 de 54 40 13 e6 64` |
| F31 post key_area+0xb0 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F32 entry data | `b0 45 d1 2e d2 a2 64 e0 8d 28 04 6d 26 5d 45 fb 8a 57 d6 38 c8 a6 b5 0c cb 10 c2 9a 8f 69 d3 01` |
| F32 post data | `ec 11 cd 83 94 76 b5 60 cd d7 37 00 c8 04 e8 a9 5a fa 4a a0 f8 f0 63 36 67 d4 65 74 1e c0 19 c3` |
| F32 post key_area+0xb0 | `5a fa 4a a0 f8 f0 63 36 67 d4 65 74 1e c0 19 c3` |

Checks:

- adapter post +0xb0 == loop entry +0xb0: OK
- adapter post +0x10 == loop entry +0x10: OK
- loop post +0xb0 == post.data tail16: OK

### F20 family: F39/F40

- inner chain: `F41/F42/F43/F44/F45/F46`
- evidence log: `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_01.log`
- adapter bodyId/code: `0x20000162df` / `0x125e1a00-0x125e1be0`, records=20
- loop bodyId/code: `0x5000016333` / `0x1262ef00-0x1262f548`, records=67

| item | hex |
|---|---|
| F39 source_key16 | `f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4` |
| F39 iv16 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F39 post key_area+0x10 | `5e 4a 47 25 13 d3 4b 3a 1c d7 f5 ad 5d bd 0b db` |
| F39 post key_area+0xb0 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F40 entry data | `74 9d e5 2d 3b 15 28 96 22 f4 27 8f d5 8e 55 d8 63 97 13 fe 67 f9 3c c3 1f 6c 0f 92 74 5a ec 01` |
| F40 post data | `48 69 a6 e6 d4 9f 7e 76 14 ca 92 00 57 59 1d 06 35 43 18 84 97 bb de 35 3d 7e 32 04 5c 89 b1 06` |
| F40 post key_area+0xb0 | `35 43 18 84 97 bb de 35 3d 7e 32 04 5c 89 b1 06` |

Checks:

- adapter post +0xb0 == loop entry +0xb0: OK
- adapter post +0x10 == loop entry +0x10: OK
- loop post +0xb0 == post.data tail16: OK

### F21 family: F47/F48

- inner chain: `F49/F50/F51/F52/F53/F54`
- evidence log: `unidbg/unidbg-android/target/sign6_350101_sourcework_sweep_07.log`
- adapter bodyId/code: `0x2000016442` / `0x125e1c00-0x125e1de0`, records=20
- loop bodyId/code: `0x5000016496` / `0x1262f600-0x1262fc48`, records=67

| item | hex |
|---|---|
| F47 source_key16 | `f1 59 33 76 76 6e a9 8d 34 f3 1b 05 7a 9d 5b e4` |
| F47 iv16 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F47 post key_area+0x10 | `80 57 74 82 3f 98 25 86 c2 ca c6 0a 71 f6 65 67` |
| F47 post key_area+0xb0 | `1f e1 09 a4 12 52 83 f4 18 de 9e 05 1a 96 9e 12` |
| F48 entry data | `74 28 15 cc 7d 88 7b 13 3d 60 ee 16 9a 67 d5 07 0c 05 e2 01 50 90 59 9d f2 ee c4 16 a6 7d 2a 01` |
| F48 post data | `22 78 1b 5b a6 9a ed 28 0c 11 1c a8 f0 d0 5f 8b 7c dd 10 44 01 b3 30 42 1d fa 15 6f 98 88 1a f0` |
| F48 post key_area+0xb0 | `7c dd 10 44 01 b3 30 42 1d fa 15 6f 98 88 1a f0` |

Checks:

- adapter post +0xb0 == loop entry +0xb0: OK
- adapter post +0x10 == loop entry +0x10: OK
- loop post +0xb0 == post.data tail16: OK

## Interpretation

- Adapter programs expand a 16-byte source key and copy the 16-byte IV into `key_area+0xb0`.
- Loop programs transform data in-place by 16-byte blocks; after each block, the current output block is copied back into `key_area+0xb0`.
- The same fixed HTTP sign request can select different source-work families across runs, so all four families need regression vectors.

The per-block writeback was confirmed by C selfcheck: using only a final writeback makes the first 16-byte block match but all second blocks differ. Updating
`key_area+0xb0` after every block makes all four families match byte-for-byte.

Regression file:

```text
dyidre/versions/350101/source_work_vector_selfcheck_350101.c
```

Current result:

```text
failures=0
```

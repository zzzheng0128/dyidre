# x0 tail timeline

- watched range: `+0x3c0..+0x500`
- write events: `378`
- phases: `2`

This report is intentionally temporal: the same offsets may mean different things in different phases because the native code reuses the buffer.

## phase 1

- event seq: `441..798`
- events: `358`
- touched: `+0x3c0..+0x500`
- non-zero: `+0x3c0..+0x500`
- top writers: `libmetasec_ml.so+0x138560`(160), `libc.so+0x1c7a8`(64), `libmetasec_ml.so+0x117f30`(40), `libmetasec_ml.so+0x117ec8`(11), `libmetasec_ml.so+0x117edc`(7), `libmetasec_ml.so+0x116b18`(6), `libc.so+0x1c1c0`(6), `libmetasec_ml.so+0x117ef4`(5), `libc.so+0x1c1cc`(5), `libmetasec_ml.so+0x117f04`(4)

`+0x3c0`  `08 d2 a4 80 82 04 10 02 18 bc c1 90 ed 0e 22 04`  `..............".`
`+0x3d0`  `31 31 32 38 2a 0f 33 39 37 33 36 35 36 30 38 32`  `1128*.3973656082`
`+0x3e0`  `30 33 34 30 30 32 0a 31 35 38 38 30 39 33 32 32`  `034002.158809322`
`+0x3f0`  `38 3a 06 33 35 2e 31 2e 30 42 14 76 30 34 2e 30`  `8:.35.1.0B.v04.0`
`+0x400`  `39 2e 30 35 2d 6d 6c 2d 61 6e 64 72 6f 69 64 48`  `9.05-ml-androidH`
`+0x410`  `80 94 c8 40 52 08 08 00 00 00 00 00 00 00 60 82`  `...@R.........`.`
`+0x420`  `8b a1 a9 0d 6a 06 cf 03 47 6f 3b 96 72 06 1f 08`  `....j...Go;.r...`
`+0x430`  `57 8a 51 5b 7a 0a 08 02 10 be e1 54 18 be e1 54`  `W.Q[z......T...T`
`+0x440`  `88 01 82 8b a1 a9 0d a2 01 04 6e 6f 6e 65 a8 01`  `..........none..`
`+0x450`  `e2 05 00 .. .. .. .. .. .. .. .. .. .. .. .. ..`  `................`
`+0x460`  `06 e7 51 8a 47 c8 24 b4 59 89 a5 75 d9 bd 67 11`  `..Q.G.$.Y..u..g.`
`+0x470`  `b2 d9 b7 36 a6 a4 28 d2 fa b6 f6 ea 71 d2 e6 67`  `...6..(.....q..g`
`+0x480`  `f3 d9 0b e4 50 c7 b6 7b 0e c4 22 ad be c2 90 0a`  `....P..{..".....`
`+0x490`  `19 52 4c 3f de ad 8a b9 46 96 47 76 3b ca 39 79`  `.RL?....F.Gv;.9y`
`+0x4a0`  `db 2d 23 52 33 0f f4 e7 df 3a d3 ae d9 63 ee 9b`  `.-#R3....:...c..`
`+0x4b0`  `23 d8 d6 0a 09 5e 19 09 6d a2 74 a8 67 57 21 a5`  `#....^..m.t.gW!.`
`+0x4c0`  `18 81 47 f0 73 9b 52 56 bb 94 52 7a 6f 69 3e 08`  `..G.s.RV..Rzoi>.`
`+0x4d0`  `2b 37 8c ad 94 6f 93 6b 41 57 81 b0 b5 43 8a e9`  `+7...o.kAW...C..`
`+0x4e0`  `3a a7 16 d5 24 df cf .. 22 31 87 ea 13 a6 2c 97`  `:...$..."1....,.`
`+0x4f0`  `9b 40 16 bf de de 80 3e 27 56 f9 47 b0 d8 58 28`  `.@.....>'V.G..X(`

## phase 2

- event seq: `829..848`
- events: `20`
- touched: `+0x3c0..+0x442`
- non-zero: `+0x3c0..+0x442`
- top writers: `libc.so+0x1c294`(2), `libc.so+0x1c29c`(2), `libc.so+0x1c2a4`(2), `libc.so+0x1c2ac`(2), `libc.so+0x1c2bc`(2), `libc.so+0x1c2c0`(2), `libc.so+0x1c2c4`(2), `libc.so+0x1c2c8`(2), `libc.so+0x1c1a4`(2), `libmetasec_ml.so+0x10b6e0`(1)

`+0x3c0`  `58 2d 53 6f 74 65 72 0d 0a 41 41 45 41 41 67 41`  `X-Soter..AAEAAgA`
`+0x3d0`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x3e0`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x3f0`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x400`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x410`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x420`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x430`  `41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41`  `AAAAAAAAAAAAAAAA`
`+0x440`  `41 0d .. .. .. .. .. .. .. .. .. .. .. .. .. ..`  `A...............`

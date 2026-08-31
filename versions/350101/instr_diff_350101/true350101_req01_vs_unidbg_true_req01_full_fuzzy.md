# MetaSec instruction sequence diff

gum=dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log
seq=unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_unicorn2_full_20260831.seq
sync_offset=0x149cbc
gum_skipped_before_sync=0
seq_skipped_before_sync=24373
matched_after_sync=10025
diffs_reported=220
stopped=diff_limit

## Matched context before divergence
- -12 off=0x87c04 true_pos=26444 seq_pos=35227 true=add x29, sp, #0x40
- -11 off=0x87c08 true_pos=26445 seq_pos=35228 true=mrs x21, tpidr_el0
- -10 off=0x87c0c true_pos=26446 seq_pos=35229 true=ldr x8, [x21, #0x28]
- -09 off=0x87c10 true_pos=26447 seq_pos=35230 true=mov x19, x1
- -08 off=0x87c14 true_pos=26448 seq_pos=35231 true=mov x20, x0
- -07 off=0x87c18 true_pos=26449 seq_pos=35232 true=str x8, [sp, #0x18]
- -06 off=0x87c1c true_pos=26450 seq_pos=35233 true=stp xzr, xzr, [x0]
- -05 off=0x87c20 true_pos=26451 seq_pos=35234 true=ldr x1, [x1]
- -04 off=0x87c24 true_pos=26452 seq_pos=35235 true=mov x0, sp
- -03 off=0x87c28 true_pos=26453 seq_pos=35236 true=bl #0x70f1babd04
- -02 off=0x12de08 true_pos=26485 seq_pos=35237 true=add x0, x8, #8
- -01 off=0x12de0c true_pos=26486 seq_pos=35238 true=bl #0x70f1ab1880

## Divergence #1
matched_before=45
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24419 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701168 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `24419 0x12001c 4`

True-device skipped before resync:
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=47 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=48 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=49 off=0x1c2ee8 cmp x0, #0
- true: pos=50 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=51 off=0x1c2ef0 mov x0, x19
- true: pos=52 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=53 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=54 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=55 off=0x330c8 add x16, x16, #0x4e8
- true: pos=56 off=0x330cc br x17
- true: pos=59 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #2
matched_before=55
- true: pos=73 off=0x11fc08 adrp x8, #0x70f1ced000
- unidbg: seq=24429 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `24429 0x120044 4`

True-device skipped before resync:
- true: pos=73 off=0x11fc08 adrp x8, #0x70f1ced000
- true: pos=74 off=0x11fc0c add x8, x8, #0x150
- true: pos=75 off=0x11fc10 str x8, [x0]
- true: pos=76 off=0x11fc14 ldr q0, [x1]
- true: pos=77 off=0x11fc18 ldr x1, [x1, #0x10]
- true: pos=78 off=0x11fc1c add x8, x0, #0x20
- true: pos=79 off=0x11fc20 stur q0, [x0, #8]
- true: pos=80 off=0x11fc24 str x1, [x0, #0x18]
- true: pos=81 off=0x11fc28 mov x0, x8
- true: pos=82 off=0x11fc2c b #0x70f1b8c7ac
- true: pos=83 off=0x10e7ac str x21, [sp, #-0x30]!
- true: pos=84 off=0x10e7b0 stp x20, x19, [sp, #0x10]
- ... 57 more

Unidbg skipped before resync:
- none

## Divergence #3
matched_before=74
- true: pos=165 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24448 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=48 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `24448 0x490d4 4`

True-device skipped before resync:
- true: pos=165 off=0x12dd04 sub sp, sp, #0x60
- true: pos=166 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=167 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=168 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=169 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=170 off=0x12dd18 add x29, sp, #0x50
- true: pos=171 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=172 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=173 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=174 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=175 off=0x12dd2c mov w10, #-0xe9
- true: pos=176 off=0x12dd30 str x8, [sp, #0x18]
- ... 36 more

Unidbg skipped before resync:
- none

## Divergence #4
matched_before=77
- true: pos=218 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24451 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x734751b090 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `24451 0x490e0 4`

True-device skipped before resync:
- true: pos=218 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=219 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=220 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=221 off=0x1c2ee8 cmp x0, #0
- true: pos=222 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=223 off=0x1c2ef0 mov x0, x19
- true: pos=224 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=225 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=226 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=227 off=0x330c8 add x16, x16, #0x4e8
- true: pos=228 off=0x330cc br x17
- true: pos=231 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #5
matched_before=82
- true: pos=240 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24456 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `24456 0x490f4 4`

True-device skipped before resync:
- true: pos=240 off=0x12de7c ldr w8, [x0, #8]
- true: pos=241 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=242 off=0x12de84 add x9, x9, #0x7b8
- true: pos=243 off=0x12de88 str x9, [x0]
- true: pos=244 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=245 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=246 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=247 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=248 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=249 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=250 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=251 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #6
matched_before=100
- true: pos=277 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24474 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701158 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `24474 0x12001c 4`

True-device skipped before resync:
- true: pos=277 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=278 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=279 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=280 off=0x1c2ee8 cmp x0, #0
- true: pos=281 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=282 off=0x1c2ef0 mov x0, x19
- true: pos=283 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=284 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=285 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=286 off=0x330c8 add x16, x16, #0x4e8
- true: pos=287 off=0x330cc br x17
- true: pos=290 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #7
matched_before=110
- true: pos=304 off=0x11fc08 adrp x8, #0x70f1ced000
- unidbg: seq=24484 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `24484 0x120044 4`

True-device skipped before resync:
- true: pos=304 off=0x11fc08 adrp x8, #0x70f1ced000
- true: pos=305 off=0x11fc0c add x8, x8, #0x150
- true: pos=306 off=0x11fc10 str x8, [x0]
- true: pos=307 off=0x11fc14 ldr q0, [x1]
- true: pos=308 off=0x11fc18 ldr x1, [x1, #0x10]
- true: pos=309 off=0x11fc1c add x8, x0, #0x20
- true: pos=310 off=0x11fc20 stur q0, [x0, #8]
- true: pos=311 off=0x11fc24 str x1, [x0, #0x18]
- true: pos=312 off=0x11fc28 mov x0, x8
- true: pos=313 off=0x11fc2c b #0x70f1b8c7ac
- true: pos=314 off=0x10e7ac str x21, [sp, #-0x30]!
- true: pos=315 off=0x10e7b0 stp x20, x19, [sp, #0x10]
- ... 57 more

Unidbg skipped before resync:
- none

## Divergence #8
matched_before=129
- true: pos=396 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24503 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `24503 0x12de08 4`

True-device skipped before resync:
- true: pos=396 off=0x12dd04 sub sp, sp, #0x60
- true: pos=397 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=398 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=399 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=400 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=401 off=0x12dd18 add x29, sp, #0x50
- true: pos=402 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=403 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=404 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=405 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=406 off=0x12dd2c mov w10, #-0xe9
- true: pos=407 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #9
matched_before=131
- true: pos=429 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=24505 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa4e8 -> x16=0x70f1cfa000 `
- unidbg_raw: `24505 0x490d4 4`

True-device skipped before resync:
- true: pos=429 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=430 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=431 off=0x33888 add x16, x16, #0x8c8
- true: pos=432 off=0x3388c br x17
- true: pos=435 off=0x12de10 str w0, [x19, #8]
- true: pos=436 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=437 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=438 off=0x12de1c cmp x8, x9
- true: pos=439 off=0x12de20 b.ne #0x70f1babe78
- true: pos=440 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=441 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=442 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #10
matched_before=134
- true: pos=449 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24508 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7347331cd0 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `24508 0x490e0 4`

True-device skipped before resync:
- true: pos=449 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=450 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=451 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=452 off=0x1c2ee8 cmp x0, #0
- true: pos=453 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=454 off=0x1c2ef0 mov x0, x19
- true: pos=455 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=456 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=457 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=458 off=0x330c8 add x16, x16, #0x4e8
- true: pos=459 off=0x330cc br x17
- true: pos=462 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #11
matched_before=139
- true: pos=471 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24513 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `24513 0x490f4 4`

True-device skipped before resync:
- true: pos=471 off=0x12de7c ldr w8, [x0, #8]
- true: pos=472 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=473 off=0x12de84 add x9, x9, #0x7b8
- true: pos=474 off=0x12de88 str x9, [x0]
- true: pos=475 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=476 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=477 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=478 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=479 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=480 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=481 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=482 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #12
matched_before=149
- true: pos=500 off=0x4303c stp x20, x19, [sp, #-0x20]!
- unidbg: seq=24523 off=0x149d60 size=4
- resync: offset=0x149d60 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac103c!0x4303c stp x20, x19, [sp, #-0x20]!; x20=0x70c6701530 x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `24523 0x149d60 4`

True-device skipped before resync:
- true: pos=500 off=0x4303c stp x20, x19, [sp, #-0x20]!
- true: pos=501 off=0x43040 stp x29, x30, [sp, #0x10]
- true: pos=502 off=0x43044 add x29, sp, #0x10
- true: pos=503 off=0x43048 adrp x8, #0x70f1d39000
- true: pos=504 off=0x4304c add x8, x8, #0xdb0
- true: pos=505 off=0x43050 ldarb w8, [x8]
- true: pos=506 off=0x43054 adrp x19, #0x70f1d39000
- true: pos=507 off=0x43058 tbz w8, #0, #0x70f1ac106c
- true: pos=508 off=0x4305c ldr x0, [x19, #0xda8]
- true: pos=509 off=0x43060 ldp x29, x30, [sp, #0x10]
- true: pos=510 off=0x43064 ldp x20, x19, [sp], #0x20
- true: pos=511 off=0x43068 ret

Unidbg skipped before resync:
- none

## Divergence #13
matched_before=154
- true: pos=517 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=24528 off=0x149d6c size=4
- resync: offset=0x149d6c true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x72f7298c90 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `24528 0x149d6c 4`

True-device skipped before resync:
- true: pos=517 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=518 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=519 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=520 off=0x10b5fc add x29, sp, #0x20
- true: pos=521 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=522 off=0x10b604 mov x19, x0
- true: pos=523 off=0x10b608 add x8, x8, #0xaf0
- true: pos=524 off=0x10b60c str x8, [x0]
- true: pos=525 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=526 off=0x10b614 mov x0, x1
- true: pos=527 off=0x10b618 mov x20, x1
- true: pos=528 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #14
matched_before=181
- true: pos=593 off=0x11fe50 add x0, x0, #0x20
- unidbg: seq=24555 off=0x10a67c size=4
- resync: offset=0x10a67c true_ahead=313 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9de50!0x11fe50 add x0, x0, #0x20; x0=0x72f7298c98 x0=0x72f7298c98 -> x0=0x72f7298cb8 `
- unidbg_raw: `24555 0x10a67c 4`

True-device skipped before resync:
- true: pos=593 off=0x11fe50 add x0, x0, #0x20
- true: pos=594 off=0x11fe54 b #0x70f1b8c834
- true: pos=595 off=0x10e834 sub sp, sp, #0x60
- true: pos=596 off=0x10e838 stp x22, x21, [sp, #0x30]
- true: pos=597 off=0x10e83c stp x20, x19, [sp, #0x40]
- true: pos=598 off=0x10e840 stp x29, x30, [sp, #0x50]
- true: pos=599 off=0x10e844 add x29, sp, #0x50
- true: pos=600 off=0x10e848 mrs x22, tpidr_el0
- true: pos=601 off=0x10e84c ldr x8, [x22, #0x28]
- true: pos=602 off=0x10e850 mov x19, x1
- true: pos=603 off=0x10e854 mov x20, x0
- true: pos=604 off=0x10e858 str x8, [sp, #0x28]
- ... 301 more

Unidbg skipped before resync:
- none

## Divergence #15
matched_before=186
- true: pos=911 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=24560 off=0x10a67c size=4
- resync: offset=0x10a694 true_ahead=46 unidbg_ahead=4
- true_raw: `[libmetasec_ml.so] 0x70f1b8d448!0x10f448 add x8, x23, #0x10; x8=0x1f x23=0x734728acd0 -> x8=0x734728ace0 `
- unidbg_raw: `24560 0x10a67c 4`

True-device skipped before resync:
- true: pos=911 off=0x10f448 add x8, x23, #0x10
- true: pos=912 off=0x10f44c add x9, x23, #0x18
- true: pos=913 off=0x10f450 cmp w0, #0
- true: pos=914 off=0x10f454 csel x19, x23, x19, ge
- true: pos=915 off=0x10f458 csel x8, x8, x9, ge
- true: pos=916 off=0x10f45c b #0x70f1b8d428
- true: pos=917 off=0x10f428 ldr x23, [x8]
- true: pos=918 off=0x10f42c cbz x23, #0x70f1b8d460
- true: pos=919 off=0x10f430 ldp x24, x8, [x21, #0x10]
- true: pos=920 off=0x10f434 ldr x1, [x23, #0x20]
- true: pos=921 off=0x10f438 mov x0, x22
- true: pos=922 off=0x10f43c blr x8
- ... 34 more

Unidbg skipped before resync:
- unidbg: seq=24560 off=0x10a67c size=4
- unidbg: seq=24561 off=0x10a680 size=4
- unidbg: seq=24562 off=0x10a68c size=4
- unidbg: seq=24563 off=0x10a690 size=4

## Divergence #16
matched_before=187
- true: pos=958 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=24565 off=0x10e8b8 size=4
- resync: offset=0x10e8b8 true_ahead=444 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d448!0x10f448 add x8, x23, #0x10; x8=0x20 x23=0x73472833d0 -> x8=0x73472833e0 `
- unidbg_raw: `24565 0x10e8b8 4`

True-device skipped before resync:
- true: pos=958 off=0x10f448 add x8, x23, #0x10
- true: pos=959 off=0x10f44c add x9, x23, #0x18
- true: pos=960 off=0x10f450 cmp w0, #0
- true: pos=961 off=0x10f454 csel x19, x23, x19, ge
- true: pos=962 off=0x10f458 csel x8, x8, x9, ge
- true: pos=963 off=0x10f45c b #0x70f1b8d428
- true: pos=964 off=0x10f428 ldr x23, [x8]
- true: pos=965 off=0x10f42c cbz x23, #0x70f1b8d460
- true: pos=966 off=0x10f430 ldp x24, x8, [x21, #0x10]
- true: pos=967 off=0x10f434 ldr x1, [x23, #0x20]
- true: pos=968 off=0x10f438 mov x0, x22
- true: pos=969 off=0x10f43c blr x8
- ... 432 more

Unidbg skipped before resync:
- none

## Divergence #17
matched_before=191
- true: pos=1406 off=0x10f4a0 ldr x8, [x0, #8]
- unidbg: seq=24569 off=0x10e8c8 size=4
- resync: offset=0x10e8c8 true_ahead=3 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d4a0!0x10f4a0 ldr x8, [x0, #8]; x8=0x70f1b8d4a0 x0=0x70c6700f98 mem_r=0x70c6700fa0 -> x8=0x734728acd0 `
- unidbg_raw: `24569 0x10e8c8 4`

True-device skipped before resync:
- true: pos=1406 off=0x10f4a0 ldr x8, [x0, #8]
- true: pos=1407 off=0x10f4a4 ldr x0, [x8, #0x20]
- true: pos=1408 off=0x10f4a8 ret

Unidbg skipped before resync:
- none

## Divergence #18
matched_before=196
- true: pos=1414 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- unidbg: seq=24574 off=0x1194d8 size=4
- resync: offset=0x1194d8 true_ahead=5 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8c8dc!0x10e8dc ldp x29, x30, [sp, #0x50]; fp=0x70c6700fd0 lr=0x70f1b8c8c8 sp=0x70c6700f80 mem_r=0x70c6700fd0 -> fp=0x70c6701020 lr=0x70f1b974d8 `
- unidbg_raw: `24574 0x1194d8 4`

True-device skipped before resync:
- true: pos=1414 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- true: pos=1415 off=0x10e8e0 ldp x20, x19, [sp, #0x40]
- true: pos=1416 off=0x10e8e4 ldp x22, x21, [sp, #0x30]
- true: pos=1417 off=0x10e8e8 add sp, sp, #0x60
- true: pos=1418 off=0x10e8ec ret

Unidbg skipped before resync:
- none

## Divergence #19
matched_before=209
- true: pos=1432 off=0x33390 adrp x16, #0x70f1cfa000
- unidbg: seq=24587 off=0x1194f4 size=4
- resync: offset=0x1194f4 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1390!0x33390 adrp x16, #0x70f1cfa000; x16=0x70f1cfa460 -> x16=0x70f1cfa000 `
- unidbg_raw: `24587 0x1194f4 4`

True-device skipped before resync:
- true: pos=1432 off=0x33390 adrp x16, #0x70f1cfa000
- true: pos=1433 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=1434 off=0x33398 add x16, x16, #0x650
- true: pos=1435 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #20
matched_before=223
- true: pos=1452 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=24601 off=0x149d80 size=4
- resync: offset=0x149d80 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `24601 0x149d80 4`

True-device skipped before resync:
- true: pos=1452 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=1453 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=1454 off=0x10b76c add x29, sp, #0x10
- true: pos=1455 off=0x10b770 mov x19, x0
- true: pos=1456 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=1457 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=1458 off=0x10b77c add x8, x8, #0xaf0
- true: pos=1459 off=0x10b780 str x8, [x19]
- true: pos=1460 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=1461 off=0x10b788 bl #0x70f1ab1330
- true: pos=1462 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=1463 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #21
matched_before=226
- true: pos=1481 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=24604 off=0x149d8c size=4
- resync: offset=0x149d8c true_ahead=1538 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6701030 sp=0x70c6701030 -> sp=0x70c6700fa0 `
- unidbg_raw: `24604 0x149d8c 4`

True-device skipped before resync:
- true: pos=1481 off=0x12c9a4 sub sp, sp, #0x90
- true: pos=1482 off=0x12c9a8 str x19, [sp, #0x70]
- true: pos=1483 off=0x12c9ac stp x29, x30, [sp, #0x80]
- true: pos=1484 off=0x12c9b0 add x29, sp, #0x80
- true: pos=1485 off=0x12c9b4 mrs x8, tpidr_el0
- true: pos=1486 off=0x12c9b8 ldr x8, [x8, #0x28]
- true: pos=1487 off=0x12c9bc stur x8, [x29, #-0x18]
- true: pos=1488 off=0x12c9c0 str x0, [sp, #0x38]
- true: pos=1489 off=0x12c9c4 str w1, [sp, #0x34]
- true: pos=1490 off=0x12c9c8 bl #0x70f1ac4840
- true: pos=1491 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=1492 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 1526 more

Unidbg skipped before resync:
- none

## Divergence #22
matched_before=230
- true: pos=3023 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=24608 off=0x149d94 size=4
- resync: offset=0x149d94 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `24608 0x149d94 4`

True-device skipped before resync:
- true: pos=3023 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=3024 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=3025 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=3026 off=0x10b5fc add x29, sp, #0x20
- true: pos=3027 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=3028 off=0x10b604 mov x19, x0
- true: pos=3029 off=0x10b608 add x8, x8, #0xaf0
- true: pos=3030 off=0x10b60c str x8, [x0]
- true: pos=3031 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=3032 off=0x10b614 mov x0, x1
- true: pos=3033 off=0x10b618 mov x20, x1
- true: pos=3034 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #23
matched_before=266
- true: pos=3106 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24644 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f80 sp=0x70c6700f80 -> sp=0x70c6700f20 `
- unidbg_raw: `24644 0x12de08 4`

True-device skipped before resync:
- true: pos=3106 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3107 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3108 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3109 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3110 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3111 off=0x12dd18 add x29, sp, #0x50
- true: pos=3112 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3113 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=3114 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=3115 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=3116 off=0x12dd2c mov w10, #-0xe9
- true: pos=3117 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #24
matched_before=268
- true: pos=3139 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=24646 off=0x60b9c size=4
- resync: offset=0x60b9c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `24646 0x60b9c 4`

True-device skipped before resync:
- true: pos=3139 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=3140 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3141 off=0x33888 add x16, x16, #0x8c8
- true: pos=3142 off=0x3388c br x17
- true: pos=3145 off=0x12de10 str w0, [x19, #8]
- true: pos=3146 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3147 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3148 off=0x12de1c cmp x8, x9
- true: pos=3149 off=0x12de20 b.ne #0x70f1babe78
- true: pos=3150 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=3151 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=3152 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #25
matched_before=271
- true: pos=3159 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24649 off=0x60ba8 size=4
- resync: offset=0x60ba8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x0 sp=0x70c6700f80 mem_w=0x70c6700f60 -> sp=0x70c6700f60 `
- unidbg_raw: `24649 0x60ba8 4`

True-device skipped before resync:
- true: pos=3159 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=3160 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=3161 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=3162 off=0x1c2ee8 cmp x0, #0
- true: pos=3163 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=3164 off=0x1c2ef0 mov x0, x19
- true: pos=3165 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=3166 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=3167 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=3168 off=0x330c8 add x16, x16, #0x4e8
- true: pos=3169 off=0x330cc br x17
- true: pos=3172 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #26
matched_before=276
- true: pos=3181 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24654 off=0x60bbc size=4
- resync: offset=0x60bbc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700f80 mem_r=0x70c6700f88 -> w8=0x0 `
- unidbg_raw: `24654 0x60bbc 4`

True-device skipped before resync:
- true: pos=3181 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3182 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=3183 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3184 off=0x12de88 str x9, [x0]
- true: pos=3185 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=3186 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3187 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=3188 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=3189 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=3190 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=3191 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=3192 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #27
matched_before=306
- true: pos=3230 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- unidbg: seq=24684 off=0x120aa8 size=4
- resync: offset=0x120aa8 true_ahead=34 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8968c!0x10b68c stp x22, x21, [sp, #-0x30]!; x22=0x0 x21=0x70c6701178 sp=0x70c6700fa0 mem_w=0x70c6700f70 -> sp=0x70c6700f70 `
- unidbg_raw: `24684 0x120aa8 4`

True-device skipped before resync:
- true: pos=3230 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- true: pos=3231 off=0x10b690 stp x20, x19, [sp, #0x10]
- true: pos=3232 off=0x10b694 stp x29, x30, [sp, #0x20]
- true: pos=3233 off=0x10b698 add x29, sp, #0x20
- true: pos=3234 off=0x10b69c adrp x8, #0x70f1ce0000
- true: pos=3235 off=0x10b6a0 add x8, x8, #0xaf0
- true: pos=3236 off=0x10b6a4 str x8, [x0]
- true: pos=3237 off=0x10b6a8 ldrsw x19, [x1, #0xc]
- true: pos=3238 off=0x10b6ac mov x21, x0
- true: pos=3239 off=0x10b6b0 str xzr, [x0, #0x10]
- true: pos=3240 off=0x10b6b4 add x0, x19, #1
- true: pos=3241 off=0x10b6b8 stp w0, w19, [x21, #8]
- ... 22 more

Unidbg skipped before resync:
- none

## Divergence #28
matched_before=323
- true: pos=3288 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24701 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f50 sp=0x70c6700f50 -> sp=0x70c6700ef0 `
- unidbg_raw: `24701 0x12de08 4`

True-device skipped before resync:
- true: pos=3288 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3289 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3290 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3291 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3292 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3293 off=0x12dd18 add x29, sp, #0x50
- true: pos=3294 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3295 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=3296 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=3297 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=3298 off=0x12dd2c mov w10, #-0xe9
- true: pos=3299 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #29
matched_before=325
- true: pos=3321 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=24703 off=0x75d54 size=4
- resync: offset=0x75d54 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `24703 0x75d54 4`

True-device skipped before resync:
- true: pos=3321 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=3322 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3323 off=0x33888 add x16, x16, #0x8c8
- true: pos=3324 off=0x3388c br x17
- true: pos=3327 off=0x12de10 str w0, [x19, #8]
- true: pos=3328 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3329 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3330 off=0x12de1c cmp x8, x9
- true: pos=3331 off=0x12de20 b.ne #0x70f1babe78
- true: pos=3332 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=3333 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=3334 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #30
matched_before=335
- true: pos=3348 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24713 off=0x75d7c size=4
- resync: offset=0x75d7c true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472e8150 x0=0x70c6700f50 mem_r=0x70c6700f58 -> w8=0x0 `
- unidbg_raw: `24713 0x75d7c 4`

True-device skipped before resync:
- true: pos=3348 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3349 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=3350 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3351 off=0x12de88 str x9, [x0]
- true: pos=3352 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=3353 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3354 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=3355 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=3356 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=3357 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=3358 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=3359 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #31
matched_before=345
- true: pos=3377 off=0x12e09c b #0x70f1bc1858
- unidbg: seq=24723 off=0x120ab8 size=4
- resync: offset=0x120ab8 true_ahead=42 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bac09c!0x12e09c b #0x70f1bc1858; `
- unidbg_raw: `24723 0x120ab8 4`

True-device skipped before resync:
- true: pos=3377 off=0x12e09c b #0x70f1bc1858
- true: pos=3378 off=0x143858 stp x29, x30, [sp, #-0x10]!
- true: pos=3379 off=0x14385c mov x29, sp
- true: pos=3380 off=0x143860 bl #0x70f1c22cc4
- true: pos=3381 off=0x1a4cc4 sub sp, sp, #0x40
- true: pos=3382 off=0x1a4cc8 str x19, [sp, #0x20]
- true: pos=3383 off=0x1a4ccc stp x29, x30, [sp, #0x30]
- true: pos=3384 off=0x1a4cd0 add x29, sp, #0x30
- true: pos=3385 off=0x1a4cd4 mrs x19, tpidr_el0
- true: pos=3386 off=0x1a4cd8 ldr x8, [x19, #0x28]
- true: pos=3387 off=0x1a4cdc str x8, [sp, #0x18]
- true: pos=3388 off=0x1a4ce0 add x1, sp, #8
- ... 30 more

Unidbg skipped before resync:
- none

## Divergence #32
matched_before=366
- true: pos=3442 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24744 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f90 sp=0x70c6700f90 -> sp=0x70c6700f30 `
- unidbg_raw: `24744 0x12de08 4`

True-device skipped before resync:
- true: pos=3442 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3443 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3444 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3445 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3446 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3447 off=0x12dd18 add x29, sp, #0x50
- true: pos=3448 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3449 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=3450 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=3451 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=3452 off=0x12dd2c mov w10, #-0xe9
- true: pos=3453 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #33
matched_before=368
- true: pos=3475 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=24746 off=0x47a18 size=4
- resync: offset=0x47a18 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x298c2203d40000 -> x16=0x70f1cfa000 `
- unidbg_raw: `24746 0x47a18 4`

True-device skipped before resync:
- true: pos=3475 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=3476 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3477 off=0x33888 add x16, x16, #0x8c8
- true: pos=3478 off=0x3388c br x17
- true: pos=3481 off=0x12de10 str w0, [x19, #8]
- true: pos=3482 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3483 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3484 off=0x12de1c cmp x8, x9
- true: pos=3485 off=0x12de20 b.ne #0x70f1babe78
- true: pos=3486 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=3487 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=3488 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #34
matched_before=385
- true: pos=3509 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24763 off=0x47a28 size=4
- resync: offset=0x47a28 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700f90 mem_r=0x70c6700f98 -> w8=0x0 `
- unidbg_raw: `24763 0x47a28 4`

True-device skipped before resync:
- true: pos=3509 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3510 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=3511 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3512 off=0x12de88 str x9, [x0]
- true: pos=3513 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=3514 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3515 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=3516 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=3517 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=3518 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=3519 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=3520 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #35
matched_before=406
- true: pos=3549 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=24784 off=0x149db0 size=4
- resync: offset=0x149db0 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `24784 0x149db0 4`

True-device skipped before resync:
- true: pos=3549 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=3550 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=3551 off=0x10b76c add x29, sp, #0x10
- true: pos=3552 off=0x10b770 mov x19, x0
- true: pos=3553 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=3554 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=3555 off=0x10b77c add x8, x8, #0xaf0
- true: pos=3556 off=0x10b780 str x8, [x19]
- true: pos=3557 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=3558 off=0x10b788 bl #0x70f1ab1330
- true: pos=3559 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=3560 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #36
matched_before=417
- true: pos=3586 off=0x12cf90 sub sp, sp, #0x90
- unidbg: seq=24795 off=0x149ddc size=4
- resync: offset=0x149ddc true_ahead=550 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baaf90!0x12cf90 sub sp, sp, #0x90; sp=0x70c6701030 sp=0x70c6701030 -> sp=0x70c6700fa0 `
- unidbg_raw: `24795 0x149ddc 4`

True-device skipped before resync:
- true: pos=3586 off=0x12cf90 sub sp, sp, #0x90
- true: pos=3587 off=0x12cf94 str x19, [sp, #0x70]
- true: pos=3588 off=0x12cf98 stp x29, x30, [sp, #0x80]
- true: pos=3589 off=0x12cf9c add x29, sp, #0x80
- true: pos=3590 off=0x12cfa0 mrs x8, tpidr_el0
- true: pos=3591 off=0x12cfa4 ldr x8, [x8, #0x28]
- true: pos=3592 off=0x12cfa8 stur x8, [x29, #-0x18]
- true: pos=3593 off=0x12cfac str x0, [sp, #0x40]
- true: pos=3594 off=0x12cfb0 str w1, [sp, #0x3c]
- true: pos=3595 off=0x12cfb4 bl #0x70f1ac4840
- true: pos=3596 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=3597 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 538 more

Unidbg skipped before resync:
- none

## Divergence #37
matched_before=860
- true: pos=4583 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=25238 off=0x137dd4 size=4
- resync: offset=0x137dd4 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x4 sp=0x70c6700fc0 mem_w=0x70c6700fa0 -> sp=0x70c6700fa0 `
- unidbg_raw: `25238 0x137dd4 4`

True-device skipped before resync:
- true: pos=4583 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=4584 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=4585 off=0x46848 add x29, sp, #0x10
- true: pos=4586 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=4587 off=0x46850 add x8, x8, #0xe00
- true: pos=4588 off=0x46854 ldarb w8, [x8]
- true: pos=4589 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=4590 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=4591 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=4592 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=4593 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=4594 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #38
matched_before=885
- true: pos=4620 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=25263 off=0x137e4c size=4
- resync: offset=0x137e4c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x4 sp=0x70c6700fc0 mem_w=0x70c6700fa0 -> sp=0x70c6700fa0 `
- unidbg_raw: `25263 0x137e4c 4`

True-device skipped before resync:
- true: pos=4620 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=4621 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=4622 off=0x46848 add x29, sp, #0x10
- true: pos=4623 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=4624 off=0x46850 add x8, x8, #0xe00
- true: pos=4625 off=0x46854 ldarb w8, [x8]
- true: pos=4626 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=4627 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=4628 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=4629 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=4630 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=4631 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #39
matched_before=886
- true: pos=4633 off=0x137e50 ldr x8, [x0]
- unidbg: seq=25264 off=0x137e84 size=4
- resync: offset=0x137e84 true_ahead=84 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5e50!0x137e50 ldr x8, [x0]; x8=0x1 x0=0x7447288af0 mem_r=0x7447288af0 -> x8=0x7327288ed0 `
- unidbg_raw: `25264 0x137e84 4`

True-device skipped before resync:
- true: pos=4633 off=0x137e50 ldr x8, [x0]
- true: pos=4634 off=0x137e54 ldr x24, [x8, #0x18]
- true: pos=4635 off=0x137e58 cbz x24, #0x70f1bb5e84
- true: pos=4636 off=0x137e5c bl #0x70f1bae4d4
- true: pos=4637 off=0x1304d4 sub sp, sp, #0x10
- true: pos=4638 off=0x1304d8 stp x29, x30, [sp]
- true: pos=4639 off=0x1304dc sub sp, sp, #0x50
- true: pos=4640 off=0x1304e0 stp x29, x30, [sp, #0x40]
- true: pos=4641 off=0x1304e4 stp x0, x1, [sp]
- true: pos=4642 off=0x1304e8 stp x2, x3, [sp, #0x10]
- true: pos=4643 off=0x1304ec stp x4, x5, [sp, #0x20]
- true: pos=4644 off=0x1304f0 stp x6, x7, [sp, #0x30]
- ... 72 more

Unidbg skipped before resync:
- none

## Divergence #40
matched_before=977
- true: pos=4808 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=25355 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `25355 0x12de08 4`

True-device skipped before resync:
- true: pos=4808 off=0x12dd04 sub sp, sp, #0x60
- true: pos=4809 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=4810 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=4811 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=4812 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=4813 off=0x12dd18 add x29, sp, #0x50
- true: pos=4814 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=4815 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=4816 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=4817 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=4818 off=0x12dd2c mov w10, #-0xe9
- true: pos=4819 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #41
matched_before=979
- true: pos=4841 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=25357 off=0x44ba4 size=4
- resync: offset=0x44ba4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `25357 0x44ba4 4`

True-device skipped before resync:
- true: pos=4841 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=4842 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=4843 off=0x33888 add x16, x16, #0x8c8
- true: pos=4844 off=0x3388c br x17
- true: pos=4847 off=0x12de10 str w0, [x19, #8]
- true: pos=4848 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=4849 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=4850 off=0x12de1c cmp x8, x9
- true: pos=4851 off=0x12de20 b.ne #0x70f1babe78
- true: pos=4852 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=4853 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=4854 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #42
matched_before=989
- true: pos=4868 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=25367 off=0x44bcc size=4
- resync: offset=0x44bcc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472cdc70 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `25367 0x44bcc 4`

True-device skipped before resync:
- true: pos=4868 off=0x12de7c ldr w8, [x0, #8]
- true: pos=4869 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=4870 off=0x12de84 add x9, x9, #0x7b8
- true: pos=4871 off=0x12de88 str x9, [x0]
- true: pos=4872 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=4873 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=4874 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=4875 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=4876 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=4877 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=4878 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=4879 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #43
matched_before=1071
- true: pos=4969 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=25449 off=0x14954c size=4
- resync: offset=0x14954c true_ahead=867 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `25449 0x14954c 4`

True-device skipped before resync:
- true: pos=4969 off=0x12c9a4 sub sp, sp, #0x90
- true: pos=4970 off=0x12c9a8 str x19, [sp, #0x70]
- true: pos=4971 off=0x12c9ac stp x29, x30, [sp, #0x80]
- true: pos=4972 off=0x12c9b0 add x29, sp, #0x80
- true: pos=4973 off=0x12c9b4 mrs x8, tpidr_el0
- true: pos=4974 off=0x12c9b8 ldr x8, [x8, #0x28]
- true: pos=4975 off=0x12c9bc stur x8, [x29, #-0x18]
- true: pos=4976 off=0x12c9c0 str x0, [sp, #0x38]
- true: pos=4977 off=0x12c9c4 str w1, [sp, #0x34]
- true: pos=4978 off=0x12c9c8 bl #0x70f1ac4840
- true: pos=4979 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=4980 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 855 more

Unidbg skipped before resync:
- none

## Divergence #44
matched_before=1520
- true: pos=6285 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=25898 off=0x137dd4 size=4
- resync: offset=0x137dd4 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x7 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `25898 0x137dd4 4`

True-device skipped before resync:
- true: pos=6285 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=6286 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=6287 off=0x46848 add x29, sp, #0x10
- true: pos=6288 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=6289 off=0x46850 add x8, x8, #0xe00
- true: pos=6290 off=0x46854 ldarb w8, [x8]
- true: pos=6291 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=6292 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=6293 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=6294 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=6295 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=6296 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #45
matched_before=1545
- true: pos=6322 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=25923 off=0x137e4c size=4
- resync: offset=0x137e4c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x7 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `25923 0x137e4c 4`

True-device skipped before resync:
- true: pos=6322 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=6323 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=6324 off=0x46848 add x29, sp, #0x10
- true: pos=6325 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=6326 off=0x46850 add x8, x8, #0xe00
- true: pos=6327 off=0x46854 ldarb w8, [x8]
- true: pos=6328 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=6329 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=6330 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=6331 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=6332 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=6333 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #46
matched_before=1546
- true: pos=6335 off=0x137e50 ldr x8, [x0]
- unidbg: seq=25924 off=0x137e84 size=4
- resync: offset=0x137e84 true_ahead=84 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5e50!0x137e50 ldr x8, [x0]; x8=0x1 x0=0x7447288af0 mem_r=0x7447288af0 -> x8=0x7327288ed0 `
- unidbg_raw: `25924 0x137e84 4`

True-device skipped before resync:
- true: pos=6335 off=0x137e50 ldr x8, [x0]
- true: pos=6336 off=0x137e54 ldr x24, [x8, #0x18]
- true: pos=6337 off=0x137e58 cbz x24, #0x70f1bb5e84
- true: pos=6338 off=0x137e5c bl #0x70f1bae4d4
- true: pos=6339 off=0x1304d4 sub sp, sp, #0x10
- true: pos=6340 off=0x1304d8 stp x29, x30, [sp]
- true: pos=6341 off=0x1304dc sub sp, sp, #0x50
- true: pos=6342 off=0x1304e0 stp x29, x30, [sp, #0x40]
- true: pos=6343 off=0x1304e4 stp x0, x1, [sp]
- true: pos=6344 off=0x1304e8 stp x2, x3, [sp, #0x10]
- true: pos=6345 off=0x1304ec stp x4, x5, [sp, #0x20]
- true: pos=6346 off=0x1304f0 stp x6, x7, [sp, #0x30]
- ... 72 more

Unidbg skipped before resync:
- none

## Divergence #47
matched_before=1615
- true: pos=6488 off=0x12cf90 sub sp, sp, #0x90
- unidbg: seq=25993 off=0x149580 size=4
- resync: offset=0x149580 true_ahead=794 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baaf90!0x12cf90 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `25993 0x149580 4`

True-device skipped before resync:
- true: pos=6488 off=0x12cf90 sub sp, sp, #0x90
- true: pos=6489 off=0x12cf94 str x19, [sp, #0x70]
- true: pos=6490 off=0x12cf98 stp x29, x30, [sp, #0x80]
- true: pos=6491 off=0x12cf9c add x29, sp, #0x80
- true: pos=6492 off=0x12cfa0 mrs x8, tpidr_el0
- true: pos=6493 off=0x12cfa4 ldr x8, [x8, #0x28]
- true: pos=6494 off=0x12cfa8 stur x8, [x29, #-0x18]
- true: pos=6495 off=0x12cfac str x0, [sp, #0x40]
- true: pos=6496 off=0x12cfb0 str w1, [sp, #0x3c]
- true: pos=6497 off=0x12cfb4 bl #0x70f1ac4840
- true: pos=6498 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=6499 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 782 more

Unidbg skipped before resync:
- none

## Divergence #48
matched_before=2066
- true: pos=7737 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=26444 off=0x137dd4 size=4
- resync: offset=0x137dd4 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x8 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `26444 0x137dd4 4`

True-device skipped before resync:
- true: pos=7737 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=7738 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=7739 off=0x46848 add x29, sp, #0x10
- true: pos=7740 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=7741 off=0x46850 add x8, x8, #0xe00
- true: pos=7742 off=0x46854 ldarb w8, [x8]
- true: pos=7743 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=7744 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=7745 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=7746 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=7747 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=7748 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #49
matched_before=2091
- true: pos=7774 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=26469 off=0x137e4c size=4
- resync: offset=0x137e4c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x8 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `26469 0x137e4c 4`

True-device skipped before resync:
- true: pos=7774 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=7775 off=0x46844 stp x29, x30, [sp, #0x10]
- true: pos=7776 off=0x46848 add x29, sp, #0x10
- true: pos=7777 off=0x4684c adrp x8, #0x70f1d39000
- true: pos=7778 off=0x46850 add x8, x8, #0xe00
- true: pos=7779 off=0x46854 ldarb w8, [x8]
- true: pos=7780 off=0x46858 adrp x19, #0x70f1d39000
- true: pos=7781 off=0x4685c tbz w8, #0, #0x70f1ac4870
- true: pos=7782 off=0x46860 ldr x0, [x19, #0xdf8]
- true: pos=7783 off=0x46864 ldp x29, x30, [sp, #0x10]
- true: pos=7784 off=0x46868 ldp x20, x19, [sp], #0x20
- true: pos=7785 off=0x4686c ret

Unidbg skipped before resync:
- none

## Divergence #50
matched_before=2092
- true: pos=7787 off=0x137e50 ldr x8, [x0]
- unidbg: seq=26470 off=0x137e84 size=4
- resync: offset=0x137e84 true_ahead=84 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5e50!0x137e50 ldr x8, [x0]; x8=0x1 x0=0x7447288af0 mem_r=0x7447288af0 -> x8=0x7327288ed0 `
- unidbg_raw: `26470 0x137e84 4`

True-device skipped before resync:
- true: pos=7787 off=0x137e50 ldr x8, [x0]
- true: pos=7788 off=0x137e54 ldr x24, [x8, #0x18]
- true: pos=7789 off=0x137e58 cbz x24, #0x70f1bb5e84
- true: pos=7790 off=0x137e5c bl #0x70f1bae4d4
- true: pos=7791 off=0x1304d4 sub sp, sp, #0x10
- true: pos=7792 off=0x1304d8 stp x29, x30, [sp]
- true: pos=7793 off=0x1304dc sub sp, sp, #0x50
- true: pos=7794 off=0x1304e0 stp x29, x30, [sp, #0x40]
- true: pos=7795 off=0x1304e4 stp x0, x1, [sp]
- true: pos=7796 off=0x1304e8 stp x2, x3, [sp, #0x10]
- true: pos=7797 off=0x1304ec stp x4, x5, [sp, #0x20]
- true: pos=7798 off=0x1304f0 stp x6, x7, [sp, #0x30]
- ... 72 more

Unidbg skipped before resync:
- none

## Divergence #51
matched_before=4258
- true: pos=10037 off=0x10b488 stp x22, x21, [sp, #-0x30]!
- unidbg: seq=28636 off=0x149974 size=4
- resync: offset=0x149974 true_ahead=39 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89488!0x10b488 stp x22, x21, [sp, #-0x30]!; x22=0x1a66971f x21=0xffffffff sp=0x70c6700e70 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `28636 0x149974 4`

True-device skipped before resync:
- true: pos=10037 off=0x10b488 stp x22, x21, [sp, #-0x30]!
- true: pos=10038 off=0x10b48c stp x20, x19, [sp, #0x10]
- true: pos=10039 off=0x10b490 stp x29, x30, [sp, #0x20]
- true: pos=10040 off=0x10b494 add x29, sp, #0x20
- true: pos=10041 off=0x10b498 adrp x8, #0x70f1ce0000
- true: pos=10042 off=0x10b49c mov x22, x0
- true: pos=10043 off=0x10b4a0 add x8, x8, #0xaf0
- true: pos=10044 off=0x10b4a4 str x8, [x0]
- true: pos=10045 off=0x10b4a8 str xzr, [x0, #0x10]
- true: pos=10046 off=0x10b4ac tbnz w2, #0x1f, #0x70f1b894f0
- true: pos=10047 off=0x10b4b0 add w8, w2, #1
- true: pos=10048 off=0x10b4b4 sxtw x0, w8
- ... 27 more

Unidbg skipped before resync:
- none

## Divergence #52
matched_before=4261
- true: pos=10086 off=0x12b904 sub sp, sp, #0x90
- unidbg: seq=28639 off=0x149980 size=4
- resync: offset=0x149980 true_ahead=1199 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ba9904!0x12b904 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `28639 0x149980 4`

True-device skipped before resync:
- true: pos=10086 off=0x12b904 sub sp, sp, #0x90
- true: pos=10087 off=0x12b908 str x19, [sp, #0x70]
- true: pos=10088 off=0x12b90c stp x29, x30, [sp, #0x80]
- true: pos=10089 off=0x12b910 add x29, sp, #0x80
- true: pos=10090 off=0x12b914 mrs x8, tpidr_el0
- true: pos=10091 off=0x12b918 ldr x8, [x8, #0x28]
- true: pos=10092 off=0x12b91c stur x8, [x29, #-0x18]
- true: pos=10093 off=0x12b920 str x0, [sp, #0x38]
- true: pos=10094 off=0x12b924 str w1, [sp, #0x34]
- true: pos=10095 off=0x12b928 bl #0x70f1ac4840
- true: pos=10096 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=10097 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 1187 more

Unidbg skipped before resync:
- none

## Divergence #53
matched_before=4264
- true: pos=11288 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=28642 off=0x14998c size=4
- resync: offset=0x14998c true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0xffffffff sp=0x70c6700e70 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `28642 0x14998c 4`

True-device skipped before resync:
- true: pos=11288 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=11289 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=11290 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=11291 off=0x10b5fc add x29, sp, #0x20
- true: pos=11292 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=11293 off=0x10b604 mov x19, x0
- true: pos=11294 off=0x10b608 add x8, x8, #0xaf0
- true: pos=11295 off=0x10b60c str x8, [x0]
- true: pos=11296 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=11297 off=0x10b614 mov x0, x1
- true: pos=11298 off=0x10b618 mov x20, x1
- true: pos=11299 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #54
matched_before=4325
- true: pos=11395 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=28703 off=0x1499ac size=4
- resync: offset=0x1499ac true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701148 sp=0x70c6700e70 mem_w=0x70c6700e50 -> sp=0x70c6700e50 `
- unidbg_raw: `28703 0x1499ac 4`

True-device skipped before resync:
- true: pos=11395 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=11396 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=11397 off=0x10b76c add x29, sp, #0x10
- true: pos=11398 off=0x10b770 mov x19, x0
- true: pos=11399 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=11400 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=11401 off=0x10b77c add x8, x8, #0xaf0
- true: pos=11402 off=0x10b780 str x8, [x19]
- true: pos=11403 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=11404 off=0x10b788 bl #0x70f1ab1330
- true: pos=11405 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=11406 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #55
matched_before=4371
- true: pos=11466 off=0x12bfa8 sub sp, sp, #0x90
- unidbg: seq=28749 off=0x149aa0 size=4
- resync: offset=0x149aa0 true_ahead=1205 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ba9fa8!0x12bfa8 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `28749 0x149aa0 4`

True-device skipped before resync:
- true: pos=11466 off=0x12bfa8 sub sp, sp, #0x90
- true: pos=11467 off=0x12bfac str x19, [sp, #0x70]
- true: pos=11468 off=0x12bfb0 stp x29, x30, [sp, #0x80]
- true: pos=11469 off=0x12bfb4 add x29, sp, #0x80
- true: pos=11470 off=0x12bfb8 mrs x8, tpidr_el0
- true: pos=11471 off=0x12bfbc ldr x8, [x8, #0x28]
- true: pos=11472 off=0x12bfc0 stur x8, [x29, #-0x18]
- true: pos=11473 off=0x12bfc4 str x0, [sp, #0x38]
- true: pos=11474 off=0x12bfc8 str w1, [sp, #0x34]
- true: pos=11475 off=0x12bfcc bl #0x70f1ac4840
- true: pos=11476 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=11477 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 1193 more

Unidbg skipped before resync:
- none

## Divergence #56
matched_before=4374
- true: pos=12674 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=28752 off=0x149aac size=4
- resync: offset=0x149aac true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6700e70 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `28752 0x149aac 4`

True-device skipped before resync:
- true: pos=12674 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=12675 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=12676 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=12677 off=0x10b5fc add x29, sp, #0x20
- true: pos=12678 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=12679 off=0x10b604 mov x19, x0
- true: pos=12680 off=0x10b608 add x8, x8, #0xaf0
- true: pos=12681 off=0x10b60c str x8, [x0]
- true: pos=12682 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=12683 off=0x10b614 mov x0, x1
- true: pos=12684 off=0x10b618 mov x20, x1
- true: pos=12685 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #57
matched_before=4435
- true: pos=12781 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=28813 off=0x149acc size=4
- resync: offset=0x149acc true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701148 sp=0x70c6700e70 mem_w=0x70c6700e50 -> sp=0x70c6700e50 `
- unidbg_raw: `28813 0x149acc 4`

True-device skipped before resync:
- true: pos=12781 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=12782 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=12783 off=0x10b76c add x29, sp, #0x10
- true: pos=12784 off=0x10b770 mov x19, x0
- true: pos=12785 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=12786 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=12787 off=0x10b77c add x8, x8, #0xaf0
- true: pos=12788 off=0x10b780 str x8, [x19]
- true: pos=12789 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=12790 off=0x10b788 bl #0x70f1ab1330
- true: pos=12791 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=12792 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #58
matched_before=4480
- true: pos=12851 off=0x12c648 sub sp, sp, #0x80
- unidbg: seq=28858 off=0x149664 size=4
- resync: offset=0x149664 true_ahead=848 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa648!0x12c648 sub sp, sp, #0x80; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700df0 `
- unidbg_raw: `28858 0x149664 4`

True-device skipped before resync:
- true: pos=12851 off=0x12c648 sub sp, sp, #0x80
- true: pos=12852 off=0x12c64c str x19, [sp, #0x60]
- true: pos=12853 off=0x12c650 stp x29, x30, [sp, #0x70]
- true: pos=12854 off=0x12c654 add x29, sp, #0x70
- true: pos=12855 off=0x12c658 mrs x8, tpidr_el0
- true: pos=12856 off=0x12c65c ldr x8, [x8, #0x28]
- true: pos=12857 off=0x12c660 stur x8, [x29, #-0x18]
- true: pos=12858 off=0x12c664 str x0, [sp, #0x38]
- true: pos=12859 off=0x12c668 str w1, [sp, #0x34]
- true: pos=12860 off=0x12c66c bl #0x70f1ac4840
- true: pos=12861 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=12862 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 836 more

Unidbg skipped before resync:
- none

## Divergence #59
matched_before=4483
- true: pos=13706 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=28861 off=0x149670 size=4
- resync: offset=0x149670 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6700e70 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `28861 0x149670 4`

True-device skipped before resync:
- true: pos=13706 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=13707 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=13708 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=13709 off=0x10b5fc add x29, sp, #0x20
- true: pos=13710 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=13711 off=0x10b604 mov x19, x0
- true: pos=13712 off=0x10b608 add x8, x8, #0xaf0
- true: pos=13713 off=0x10b60c str x8, [x0]
- true: pos=13714 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=13715 off=0x10b614 mov x0, x1
- true: pos=13716 off=0x10b618 mov x20, x1
- true: pos=13717 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #60
matched_before=4544
- true: pos=13813 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=28922 off=0x149690 size=4
- resync: offset=0x149690 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701148 sp=0x70c6700e70 mem_w=0x70c6700e50 -> sp=0x70c6700e50 `
- unidbg_raw: `28922 0x149690 4`

True-device skipped before resync:
- true: pos=13813 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=13814 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=13815 off=0x10b76c add x29, sp, #0x10
- true: pos=13816 off=0x10b770 mov x19, x0
- true: pos=13817 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=13818 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=13819 off=0x10b77c add x8, x8, #0xaf0
- true: pos=13820 off=0x10b780 str x8, [x19]
- true: pos=13821 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=13822 off=0x10b788 bl #0x70f1ab1330
- true: pos=13823 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=13824 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #61
matched_before=4587
- true: pos=13881 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=28965 off=0x149724 size=4
- resync: offset=0x149724 true_ahead=1538 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `28965 0x149724 4`

True-device skipped before resync:
- true: pos=13881 off=0x12c9a4 sub sp, sp, #0x90
- true: pos=13882 off=0x12c9a8 str x19, [sp, #0x70]
- true: pos=13883 off=0x12c9ac stp x29, x30, [sp, #0x80]
- true: pos=13884 off=0x12c9b0 add x29, sp, #0x80
- true: pos=13885 off=0x12c9b4 mrs x8, tpidr_el0
- true: pos=13886 off=0x12c9b8 ldr x8, [x8, #0x28]
- true: pos=13887 off=0x12c9bc stur x8, [x29, #-0x18]
- true: pos=13888 off=0x12c9c0 str x0, [sp, #0x38]
- true: pos=13889 off=0x12c9c4 str w1, [sp, #0x34]
- true: pos=13890 off=0x12c9c8 bl #0x70f1ac4840
- true: pos=13891 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=13892 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 1526 more

Unidbg skipped before resync:
- none

## Divergence #62
matched_before=4590
- true: pos=15422 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=28968 off=0x149730 size=4
- resync: offset=0x149730 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6700e70 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `28968 0x149730 4`

True-device skipped before resync:
- true: pos=15422 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=15423 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=15424 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=15425 off=0x10b5fc add x29, sp, #0x20
- true: pos=15426 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=15427 off=0x10b604 mov x19, x0
- true: pos=15428 off=0x10b608 add x8, x8, #0xaf0
- true: pos=15429 off=0x10b60c str x8, [x0]
- true: pos=15430 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=15431 off=0x10b614 mov x0, x1
- true: pos=15432 off=0x10b618 mov x20, x1
- true: pos=15433 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #63
matched_before=4650
- true: pos=15529 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=29028 off=0x14974c size=4
- resync: offset=0x14974c true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701148 sp=0x70c6700e70 mem_w=0x70c6700e50 -> sp=0x70c6700e50 `
- unidbg_raw: `29028 0x14974c 4`

True-device skipped before resync:
- true: pos=15529 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=15530 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=15531 off=0x10b76c add x29, sp, #0x10
- true: pos=15532 off=0x10b770 mov x19, x0
- true: pos=15533 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=15534 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=15535 off=0x10b77c add x8, x8, #0xaf0
- true: pos=15536 off=0x10b780 str x8, [x19]
- true: pos=15537 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=15538 off=0x10b788 bl #0x70f1ab1330
- true: pos=15539 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=15540 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #64
matched_before=4691
- true: pos=15596 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=29069 off=0x1498d8 size=4
- resync: offset=0x1498d8 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701148 sp=0x70c6700e70 mem_w=0x70c6700e50 -> sp=0x70c6700e50 `
- unidbg_raw: `29069 0x1498d8 4`

True-device skipped before resync:
- true: pos=15596 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=15597 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=15598 off=0x10b76c add x29, sp, #0x10
- true: pos=15599 off=0x10b770 mov x19, x0
- true: pos=15600 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=15601 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=15602 off=0x10b77c add x8, x8, #0xaf0
- true: pos=15603 off=0x10b780 str x8, [x19]
- true: pos=15604 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=15605 off=0x10b788 bl #0x70f1ab1330
- true: pos=15606 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=15607 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #65
matched_before=4757
- true: pos=15688 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=29135 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ff0 sp=0x70c6700ff0 -> sp=0x70c6700f90 `
- unidbg_raw: `29135 0x12de08 4`

True-device skipped before resync:
- true: pos=15688 off=0x12dd04 sub sp, sp, #0x60
- true: pos=15689 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=15690 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=15691 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=15692 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=15693 off=0x12dd18 add x29, sp, #0x50
- true: pos=15694 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=15695 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=15696 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=15697 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=15698 off=0x12dd2c mov w10, #-0xe9
- true: pos=15699 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #66
matched_before=4759
- true: pos=15721 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=29137 off=0x42d10 size=4
- resync: offset=0x42d10 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa620 -> x16=0x70f1cfa000 `
- unidbg_raw: `29137 0x42d10 4`

True-device skipped before resync:
- true: pos=15721 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=15722 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=15723 off=0x33888 add x16, x16, #0x8c8
- true: pos=15724 off=0x3388c br x17
- true: pos=15727 off=0x12de10 str w0, [x19, #8]
- true: pos=15728 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=15729 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=15730 off=0x12de1c cmp x8, x9
- true: pos=15731 off=0x12de20 b.ne #0x70f1babe78
- true: pos=15732 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=15733 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=15734 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #67
matched_before=4776
- true: pos=15755 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=29154 off=0x42d20 size=4
- resync: offset=0x42d20 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x4 x0=0x70c6700ff0 mem_r=0x70c6700ff8 -> w8=0x0 `
- unidbg_raw: `29154 0x42d20 4`

True-device skipped before resync:
- true: pos=15755 off=0x12de7c ldr w8, [x0, #8]
- true: pos=15756 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=15757 off=0x12de84 add x9, x9, #0x7b8
- true: pos=15758 off=0x12de88 str x9, [x0]
- true: pos=15759 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=15760 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=15761 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=15762 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=15763 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=15764 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=15765 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=15766 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #68
matched_before=4800
- true: pos=15798 off=0x12e09c b #0x70f1bc1858
- unidbg: seq=29178 off=0x149ee4 size=4
- resync: offset=0x149ee4 true_ahead=42 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bac09c!0x12e09c b #0x70f1bc1858; `
- unidbg_raw: `29178 0x149ee4 4`

True-device skipped before resync:
- true: pos=15798 off=0x12e09c b #0x70f1bc1858
- true: pos=15799 off=0x143858 stp x29, x30, [sp, #-0x10]!
- true: pos=15800 off=0x14385c mov x29, sp
- true: pos=15801 off=0x143860 bl #0x70f1c22cc4
- true: pos=15802 off=0x1a4cc4 sub sp, sp, #0x40
- true: pos=15803 off=0x1a4cc8 str x19, [sp, #0x20]
- true: pos=15804 off=0x1a4ccc stp x29, x30, [sp, #0x30]
- true: pos=15805 off=0x1a4cd0 add x29, sp, #0x30
- true: pos=15806 off=0x1a4cd4 mrs x19, tpidr_el0
- true: pos=15807 off=0x1a4cd8 ldr x8, [x19, #0x28]
- true: pos=15808 off=0x1a4cdc str x8, [sp, #0x18]
- true: pos=15809 off=0x1a4ce0 add x1, sp, #8
- ... 30 more

Unidbg skipped before resync:
- none

## Divergence #69
matched_before=4844
- true: pos=15886 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=29222 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `29222 0x12de08 4`

True-device skipped before resync:
- true: pos=15886 off=0x12dd04 sub sp, sp, #0x60
- true: pos=15887 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=15888 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=15889 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=15890 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=15891 off=0x12dd18 add x29, sp, #0x50
- true: pos=15892 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=15893 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=15894 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=15895 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=15896 off=0x12dd2c mov w10, #-0xe9
- true: pos=15897 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #70
matched_before=4846
- true: pos=15919 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=29224 off=0x44ba4 size=4
- resync: offset=0x44ba4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x2bb17303d88000 -> x16=0x70f1cfa000 `
- unidbg_raw: `29224 0x44ba4 4`

True-device skipped before resync:
- true: pos=15919 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=15920 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=15921 off=0x33888 add x16, x16, #0x8c8
- true: pos=15922 off=0x3388c br x17
- true: pos=15925 off=0x12de10 str w0, [x19, #8]
- true: pos=15926 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=15927 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=15928 off=0x12de1c cmp x8, x9
- true: pos=15929 off=0x12de20 b.ne #0x70f1babe78
- true: pos=15930 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=15931 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=15932 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #71
matched_before=4856
- true: pos=15946 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=29234 off=0x44bcc size=4
- resync: offset=0x44bcc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472cdc70 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `29234 0x44bcc 4`

True-device skipped before resync:
- true: pos=15946 off=0x12de7c ldr w8, [x0, #8]
- true: pos=15947 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=15948 off=0x12de84 add x9, x9, #0x7b8
- true: pos=15949 off=0x12de88 str x9, [x0]
- true: pos=15950 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=15951 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=15952 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=15953 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=15954 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=15955 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=15956 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=15957 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #72
matched_before=4879
- true: pos=15988 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=29257 off=0x1506d0 size=4
- resync: offset=0x1506d0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `29257 0x1506d0 4`

True-device skipped before resync:
- true: pos=15988 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=15989 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=15990 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=15991 off=0x1c2ee8 cmp x0, #0
- true: pos=15992 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=15993 off=0x1c2ef0 mov x0, x19
- true: pos=15994 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=15995 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=15996 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=15997 off=0x330c8 add x16, x16, #0x4e8
- true: pos=15998 off=0x330cc br x17
- true: pos=16001 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #73
matched_before=4882
- true: pos=16008 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- unidbg: seq=29260 off=0x1506dc size=4
- resync: offset=0x1506dc true_ahead=34 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8968c!0x10b68c stp x22, x21, [sp, #-0x30]!; x22=0x73d72805f0 x21=0x70c6703a40 sp=0x70c6700fe0 mem_w=0x70c6700fb0 -> sp=0x70c6700fb0 `
- unidbg_raw: `29260 0x1506dc 4`

True-device skipped before resync:
- true: pos=16008 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- true: pos=16009 off=0x10b690 stp x20, x19, [sp, #0x10]
- true: pos=16010 off=0x10b694 stp x29, x30, [sp, #0x20]
- true: pos=16011 off=0x10b698 add x29, sp, #0x20
- true: pos=16012 off=0x10b69c adrp x8, #0x70f1ce0000
- true: pos=16013 off=0x10b6a0 add x8, x8, #0xaf0
- true: pos=16014 off=0x10b6a4 str x8, [x0]
- true: pos=16015 off=0x10b6a8 ldrsw x19, [x1, #0xc]
- true: pos=16016 off=0x10b6ac mov x21, x0
- true: pos=16017 off=0x10b6b0 str xzr, [x0, #0x10]
- true: pos=16018 off=0x10b6b4 add x0, x19, #1
- true: pos=16019 off=0x10b6b8 stp w0, w19, [x21, #8]
- ... 22 more

Unidbg skipped before resync:
- none

## Divergence #74
matched_before=4913
- true: pos=16091 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=29291 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f90 sp=0x70c6700f90 -> sp=0x70c6700f30 `
- unidbg_raw: `29291 0x12de08 4`

True-device skipped before resync:
- true: pos=16091 off=0x12dd04 sub sp, sp, #0x60
- true: pos=16092 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=16093 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=16094 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=16095 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=16096 off=0x12dd18 add x29, sp, #0x50
- true: pos=16097 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=16098 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=16099 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=16100 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=16101 off=0x12dd2c mov w10, #-0xe9
- true: pos=16102 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #75
matched_before=4915
- true: pos=16124 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=29293 off=0x44900 size=4
- resync: offset=0x44900 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `29293 0x44900 4`

True-device skipped before resync:
- true: pos=16124 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=16125 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=16126 off=0x33888 add x16, x16, #0x8c8
- true: pos=16127 off=0x3388c br x17
- true: pos=16130 off=0x12de10 str w0, [x19, #8]
- true: pos=16131 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=16132 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=16133 off=0x12de1c cmp x8, x9
- true: pos=16134 off=0x12de20 b.ne #0x70f1babe78
- true: pos=16135 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=16136 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=16137 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #76
matched_before=4925
- true: pos=16151 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=29303 off=0x44928 size=4
- resync: offset=0x44928 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x4729ae90 x0=0x70c6700f90 mem_r=0x70c6700f98 -> w8=0x0 `
- unidbg_raw: `29303 0x44928 4`

True-device skipped before resync:
- true: pos=16151 off=0x12de7c ldr w8, [x0, #8]
- true: pos=16152 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=16153 off=0x12de84 add x9, x9, #0x7b8
- true: pos=16154 off=0x12de88 str x9, [x0]
- true: pos=16155 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=16156 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=16157 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=16158 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=16159 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=16160 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=16161 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=16162 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #77
matched_before=4973
- true: pos=16218 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=29351 off=0x12df3c size=4
- resync: offset=0x12df3c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x1f4 sp=0x70c6700f40 mem_w=0x70c6700f20 -> sp=0x70c6700f20 `
- unidbg_raw: `29351 0x12df3c 4`

True-device skipped before resync:
- true: pos=16218 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=16219 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=16220 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=16221 off=0x1c2ee8 cmp x0, #0
- true: pos=16222 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=16223 off=0x1c2ef0 mov x0, x19
- true: pos=16224 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=16225 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=16226 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=16227 off=0x330c8 add x16, x16, #0x4e8
- true: pos=16228 off=0x330cc br x17
- true: pos=16231 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #78
matched_before=5072
- true: pos=16334 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=29450 off=0x12dff8 size=4
- resync: offset=0x12dff8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x74a7342bd0 sp=0x70c6700d80 mem_w=0x70c6700d60 -> sp=0x70c6700d60 `
- unidbg_raw: `29450 0x12dff8 4`

True-device skipped before resync:
- true: pos=16334 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=16335 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=16336 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=16337 off=0x1c2ee8 cmp x0, #0
- true: pos=16338 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=16339 off=0x1c2ef0 mov x0, x19
- true: pos=16340 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=16341 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=16342 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=16343 off=0x330c8 add x16, x16, #0x4e8
- true: pos=16344 off=0x330cc br x17
- true: pos=16347 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #79
matched_before=5092
- true: pos=16371 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=29470 off=0x1a1288 size=4
- resync: offset=0x1a1288 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x1f4 sp=0x70c6700dc0 mem_w=0x70c6700da0 -> sp=0x70c6700da0 `
- unidbg_raw: `29470 0x1a1288 4`

True-device skipped before resync:
- true: pos=16371 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=16372 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=16373 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=16374 off=0x1c2ee8 cmp x0, #0
- true: pos=16375 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=16376 off=0x1c2ef0 mov x0, x19
- true: pos=16377 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=16378 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=16379 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=16380 off=0x330c8 add x16, x16, #0x4e8
- true: pos=16381 off=0x330cc br x17
- true: pos=16384 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #80
matched_before=5138
- true: pos=16434 off=0x1a4d64 sub sp, sp, #0x40
- unidbg: seq=29516 off=0x1a1ca8 size=4
- resync: offset=0x1a1ca8 true_ahead=27 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c22d64!0x1a4d64 sub sp, sp, #0x40; sp=0x70c6700d60 sp=0x70c6700d60 -> sp=0x70c6700d20 `
- unidbg_raw: `29516 0x1a1ca8 4`

True-device skipped before resync:
- true: pos=16434 off=0x1a4d64 sub sp, sp, #0x40
- true: pos=16435 off=0x1a4d68 str x19, [sp, #0x20]
- true: pos=16436 off=0x1a4d6c stp x29, x30, [sp, #0x30]
- true: pos=16437 off=0x1a4d70 add x29, sp, #0x30
- true: pos=16438 off=0x1a4d74 mrs x19, tpidr_el0
- true: pos=16439 off=0x1a4d78 ldr x8, [x19, #0x28]
- true: pos=16440 off=0x1a4d7c str x8, [sp, #0x18]
- true: pos=16441 off=0x1a4d80 add x1, sp, #8
- true: pos=16442 off=0x1a4d84 mov w0, #1
- true: pos=16443 off=0x1a4d88 bl #0x70f1ab1bb0
- true: pos=16444 off=0x33bb0 adrp x16, #0x70f1cfa000
- true: pos=16445 off=0x33bb4 ldr x17, [x16, #0xa60]
- ... 15 more

Unidbg skipped before resync:
- none

## Divergence #81
matched_before=5158
- true: pos=16483 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=29536 off=0x1a1ce0 size=4
- resync: offset=0x1a1ce0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6700d80 sp=0x70c6700d40 mem_w=0x70c6700d20 -> sp=0x70c6700d20 `
- unidbg_raw: `29536 0x1a1ce0 4`

True-device skipped before resync:
- true: pos=16483 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=16484 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=16485 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=16486 off=0x1c2ee8 cmp x0, #0
- true: pos=16487 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=16488 off=0x1c2ef0 mov x0, x19
- true: pos=16489 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=16490 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=16491 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=16492 off=0x330c8 add x16, x16, #0x4e8
- true: pos=16493 off=0x330cc br x17
- true: pos=16496 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #82
matched_before=5196
- true: pos=16538 off=0x1c2c30 stp x29, x30, [sp, #-0x10]!
- unidbg: seq=29574 off=0x1a1d44 size=4
- resync: offset=0x1a1d44 true_ahead=10 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40c30!0x1c2c30 stp x29, x30, [sp, #-0x10]!; fp=0x70c6700d60 lr=0x70f1c1fd44 sp=0x70c6700d10 mem_w=0x70c6700d00 -> sp=0x70c6700d00 `
- unidbg_raw: `29574 0x1a1d44 4`

True-device skipped before resync:
- true: pos=16538 off=0x1c2c30 stp x29, x30, [sp, #-0x10]!
- true: pos=16539 off=0x1c2c34 mov x29, sp
- true: pos=16540 off=0x1c2c38 bl #0x70f1ab1880
- true: pos=16541 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=16542 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=16543 off=0x33888 add x16, x16, #0x8c8
- true: pos=16544 off=0x3388c br x17
- true: pos=16547 off=0x1c2c3c cbnz w0, #0x70f1c40c48
- true: pos=16548 off=0x1c2c40 ldp x29, x30, [sp], #0x10
- true: pos=16549 off=0x1c2c44 ret

Unidbg skipped before resync:
- none

## Divergence #83
matched_before=5236
- true: pos=16590 off=0x1a1db0 ldr x8, [sp, #8]
- unidbg: seq=29614 off=0x1a1d88 size=4
- resync: offset=0x1a1db0 true_ahead=0 unidbg_ahead=270
- true_raw: `[libmetasec_ml.so] 0x70f1c1fdb0!0x1a1db0 ldr x8, [sp, #8]; x8=0xb8216ab sp=0x70c6700d10 mem_r=0x70c6700d18 -> x8=0x74472b5af8 `
- unidbg_raw: `29614 0x1a1d88 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=29614 off=0x1a1d88 size=4
- unidbg: seq=29615 off=0x1a1d8c size=4
- unidbg: seq=29616 off=0x1a1d90 size=4
- unidbg: seq=29617 off=0x1a2334 size=4
- unidbg: seq=29618 off=0x1a2338 size=4
- unidbg: seq=29619 off=0x1a233c size=4
- unidbg: seq=29620 off=0x1a2340 size=4
- unidbg: seq=29621 off=0x1a2344 size=4
- unidbg: seq=29622 off=0x1a23c8 size=4
- unidbg: seq=29623 off=0x1a23cc size=4
- unidbg: seq=29624 off=0x1a23d0 size=4
- unidbg: seq=29625 off=0x1a23d4 size=4
- ... 258 more

## Divergence #84
matched_before=5274
- true: pos=16628 off=0x1a25d4 mov x0, xzr
- unidbg: seq=29922 off=0x1a25a8 size=4
- resync: offset=0x1a2028 true_ahead=2 unidbg_ahead=11
- true_raw: `[libmetasec_ml.so] 0x70f1c205d4!0x1a25d4 mov x0, xzr; x0=0x70c6700ca8 -> x0=0x0 `
- unidbg_raw: `29922 0x1a25a8 4`

True-device skipped before resync:
- true: pos=16628 off=0x1a25d4 mov x0, xzr
- true: pos=16629 off=0x1a25d8 ret

Unidbg skipped before resync:
- unidbg: seq=29922 off=0x1a25a8 size=4
- unidbg: seq=29923 off=0x1a25ac size=4
- unidbg: seq=29924 off=0x1a25b0 size=4
- unidbg: seq=29925 off=0x1a25b4 size=4
- unidbg: seq=29926 off=0x1a25b8 size=4
- unidbg: seq=29927 off=0x1a25bc size=4
- unidbg: seq=29928 off=0x1a25c0 size=4
- unidbg: seq=29929 off=0x1a25c4 size=4
- unidbg: seq=29930 off=0x1a25c8 size=4
- unidbg: seq=29931 off=0x1a25cc size=4
- unidbg: seq=29932 off=0x1a25d0 size=4

## Divergence #85
matched_before=5279
- true: pos=16635 off=0x1a203c ldr x8, [x19, #0x20]
- unidbg: seq=29938 off=0x1a2098 size=4
- resync: offset=0x1a33f4 true_ahead=56 unidbg_ahead=44
- true_raw: `[libmetasec_ml.so] 0x70f1c2003c!0x1a203c ldr x8, [x19, #0x20]; x8=0x8 x19=0x70f1d44528 mem_r=0x70f1d44548 -> x8=0x202 `
- unidbg_raw: `29938 0x1a2098 4`

True-device skipped before resync:
- true: pos=16635 off=0x1a203c ldr x8, [x19, #0x20]
- true: pos=16636 off=0x1a2040 cbnz x8, #0x70f1c2004c
- true: pos=16637 off=0x1a204c mov x0, x19
- true: pos=16638 off=0x1a2050 cbz x20, #0x70f1c200f8
- true: pos=16639 off=0x1a20f8 bl #0x70f1c2035c
- true: pos=16640 off=0x1a235c ldr x8, [x0, #0x20]
- true: pos=16641 off=0x1a2360 ldp x9, x10, [x0, #8]
- true: pos=16642 off=0x1a2364 lsr x11, x8, #6
- true: pos=16643 off=0x1a2368 and x11, x11, #0x3fffffffffffff8
- true: pos=16644 off=0x1a236c cmp x10, x9
- true: pos=16645 off=0x1a2370 add x0, x9, x11
- true: pos=16646 off=0x1a2374 b.eq #0x70f1c20388
- ... 44 more

Unidbg skipped before resync:
- unidbg: seq=29938 off=0x1a2098 size=4
- unidbg: seq=29939 off=0x1a209c size=4
- unidbg: seq=29940 off=0x1a29d4 size=4
- unidbg: seq=29941 off=0x1a29d8 size=4
- unidbg: seq=29942 off=0x1a29dc size=4
- unidbg: seq=29943 off=0x1a29e0 size=4
- unidbg: seq=29944 off=0x1a29e4 size=4
- unidbg: seq=29945 off=0x1a29e8 size=4
- unidbg: seq=29946 off=0x1a29ec size=4
- unidbg: seq=29947 off=0x1a29f0 size=4
- unidbg: seq=29948 off=0x1a29f4 size=4
- unidbg: seq=29949 off=0x1a20a0 size=4
- ... 32 more

## Divergence #86
matched_before=5280
- true: pos=16692 off=0x1a3468 ret
- unidbg: seq=29983 off=0x1a33f8 size=4
- resync: offset=0x1a3468 true_ahead=0 unidbg_ahead=15
- true_raw: `[libmetasec_ml.so] 0x70f1c21468!0x1a3468 ret ; `
- unidbg_raw: `29983 0x1a33f8 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=29983 off=0x1a33f8 size=4
- unidbg: seq=29984 off=0x1a33fc size=4
- unidbg: seq=29985 off=0x1a3400 size=4
- unidbg: seq=29986 off=0x1a3404 size=4
- unidbg: seq=29987 off=0x1a3408 size=4
- unidbg: seq=29988 off=0x1a340c size=4
- unidbg: seq=29989 off=0x1a3410 size=4
- unidbg: seq=29990 off=0x1a3414 size=4
- unidbg: seq=29991 off=0x1a3418 size=4
- unidbg: seq=29992 off=0x1a341c size=4
- unidbg: seq=29993 off=0x1a3420 size=4
- unidbg: seq=29994 off=0x1a3424 size=4
- ... 3 more

## Divergence #87
matched_before=5281
- true: pos=16693 off=0x1a297c ldp x0, x1, [sp]
- unidbg: seq=29999 off=0x1a2804 size=4
- resync: offset=0x1a2550 true_ahead=101 unidbg_ahead=206
- true_raw: `[libmetasec_ml.so] 0x70f1c2097c!0x1a297c ldp x0, x1, [sp]; x0=0x70c6700c50 x1=0x0 sp=0x70c6700c50 mem_r=0x70c6700c50 -> x0=0x74472b5af8 x1=0x733730fb38 `
- unidbg_raw: `29999 0x1a2804 4`

True-device skipped before resync:
- true: pos=16693 off=0x1a297c ldp x0, x1, [sp]
- true: pos=16694 off=0x1a2980 ldr x8, [x19, #0x28]
- true: pos=16695 off=0x1a2984 ldr x9, [sp, #0x18]
- true: pos=16696 off=0x1a2988 cmp x8, x9
- true: pos=16697 off=0x1a298c b.ne #0x70f1c209a0
- true: pos=16698 off=0x1a2990 ldp x29, x30, [sp, #0x30]
- true: pos=16699 off=0x1a2994 ldr x19, [sp, #0x20]
- true: pos=16700 off=0x1a2998 add sp, sp, #0x40
- true: pos=16701 off=0x1a299c ret
- true: pos=16702 off=0x1a220c ldr x8, [x26, #0x28]
- true: pos=16703 off=0x1a2210 ldr x9, [sp, #0x28]
- true: pos=16704 off=0x1a2214 cmp x8, x9
- ... 89 more

Unidbg skipped before resync:
- unidbg: seq=29999 off=0x1a2804 size=4
- unidbg: seq=30000 off=0x1a2808 size=4
- unidbg: seq=30001 off=0x1a280c size=4
- unidbg: seq=30002 off=0x1a2810 size=4
- unidbg: seq=30003 off=0x1a2814 size=4
- unidbg: seq=30004 off=0x1a2818 size=4
- unidbg: seq=30005 off=0x1a281c size=4
- unidbg: seq=30006 off=0x1a2820 size=4
- unidbg: seq=30007 off=0x1a2824 size=4
- unidbg: seq=30008 off=0x1a20d0 size=4
- unidbg: seq=30009 off=0x1a20d4 size=4
- unidbg: seq=30010 off=0x1a20d8 size=4
- ... 194 more

## Divergence #88
matched_before=5285
- true: pos=16806 off=0x1a1c6c add x0, sp, #8
- unidbg: seq=30209 off=0x1a29c4 size=4
- resync: offset=0x1a2550 true_ahead=4 unidbg_ahead=20
- true_raw: `[libmetasec_ml.so] 0x70f1c1fc6c!0x1a1c6c add x0, sp, #8; x0=0x70c6700d70 sp=0x70c6700d70 -> x0=0x70c6700d78 `
- unidbg_raw: `30209 0x1a29c4 4`

True-device skipped before resync:
- true: pos=16806 off=0x1a1c6c add x0, sp, #8
- true: pos=16807 off=0x1a1c70 bl #0x70f1c1fe00
- true: pos=16808 off=0x1a1e00 mov x1, xzr
- true: pos=16809 off=0x1a1e04 b #0x70f1c20550

Unidbg skipped before resync:
- unidbg: seq=30209 off=0x1a29c4 size=4
- unidbg: seq=30210 off=0x1a29c8 size=4
- unidbg: seq=30211 off=0x1a29cc size=4
- unidbg: seq=30212 off=0x1a29d0 size=4
- unidbg: seq=30213 off=0x1a38ec size=4
- unidbg: seq=30214 off=0x1a38d0 size=4
- unidbg: seq=30215 off=0x1a38d4 size=4
- unidbg: seq=30216 off=0x1a38d8 size=4
- unidbg: seq=30217 off=0x1a38dc size=4
- unidbg: seq=30218 off=0x1a38e0 size=4
- unidbg: seq=30219 off=0x1a38e4 size=4
- unidbg: seq=30220 off=0x1a38e8 size=4
- ... 8 more

## Divergence #89
matched_before=5289
- true: pos=16814 off=0x1a1c74 ldr x8, [x22, #0x28]
- unidbg: seq=30233 off=0x1a29c4 size=4
- resync: offset=0x1a1c74 true_ahead=0 unidbg_ahead=264
- true_raw: `[libmetasec_ml.so] 0x70f1c1fc74!0x1a1c74 ldr x8, [x22, #0x28]; x8=0x0 x22=0x70c6703a40 mem_r=0x70c6703a68 -> x8=0x3b5ab3359d2c91e5 `
- unidbg_raw: `30233 0x1a29c4 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=30233 off=0x1a29c4 size=4
- unidbg: seq=30234 off=0x1a29c8 size=4
- unidbg: seq=30235 off=0x1a29cc size=4
- unidbg: seq=30236 off=0x1a29d0 size=4
- unidbg: seq=30237 off=0x1a38ec size=4
- unidbg: seq=30238 off=0x1a38d0 size=4
- unidbg: seq=30239 off=0x1a38d4 size=4
- unidbg: seq=30240 off=0x1a38d8 size=4
- unidbg: seq=30241 off=0x1a38dc size=4
- unidbg: seq=30242 off=0x1a38e0 size=4
- unidbg: seq=30243 off=0x1a38e4 size=4
- unidbg: seq=30244 off=0x1a38e8 size=4
- ... 252 more

## Divergence #90
matched_before=5326
- true: pos=16851 off=0x1c2f44 b #0x70f1ab1330
- unidbg: seq=30534 off=0x1a1310 size=4
- resync: offset=0x1a1310 true_ahead=5 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40f44!0x1c2f44 b #0x70f1ab1330; `
- unidbg_raw: `30534 0x1a1310 4`

True-device skipped before resync:
- true: pos=16851 off=0x1c2f44 b #0x70f1ab1330
- true: pos=16852 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=16853 off=0x33334 ldr x17, [x16, #0x620]
- true: pos=16854 off=0x33338 add x16, x16, #0x620
- true: pos=16855 off=0x3333c br x17

Unidbg skipped before resync:
- none

## Divergence #91
matched_before=5386
- true: pos=16920 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=30594 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fa0 sp=0x70c6700fa0 -> sp=0x70c6700f40 `
- unidbg_raw: `30594 0x12de08 4`

True-device skipped before resync:
- true: pos=16920 off=0x12dd04 sub sp, sp, #0x60
- true: pos=16921 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=16922 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=16923 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=16924 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=16925 off=0x12dd18 add x29, sp, #0x50
- true: pos=16926 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=16927 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=16928 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=16929 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=16930 off=0x12dd2c mov w10, #-0xe9
- true: pos=16931 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #92
matched_before=5388
- true: pos=16953 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=30596 off=0x44a04 size=4
- resync: offset=0x44a04 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa620 -> x16=0x70f1cfa000 `
- unidbg_raw: `30596 0x44a04 4`

True-device skipped before resync:
- true: pos=16953 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=16954 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=16955 off=0x33888 add x16, x16, #0x8c8
- true: pos=16956 off=0x3388c br x17
- true: pos=16959 off=0x12de10 str w0, [x19, #8]
- true: pos=16960 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=16961 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=16962 off=0x12de1c cmp x8, x9
- true: pos=16963 off=0x12de20 b.ne #0x70f1babe78
- true: pos=16964 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=16965 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=16966 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #93
matched_before=5405
- true: pos=16987 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=30613 off=0x44a14 size=4
- resync: offset=0x44a14 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x14 x0=0x70c6700fa0 mem_r=0x70c6700fa8 -> w8=0x0 `
- unidbg_raw: `30613 0x44a14 4`

True-device skipped before resync:
- true: pos=16987 off=0x12de7c ldr w8, [x0, #8]
- true: pos=16988 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=16989 off=0x12de84 add x9, x9, #0x7b8
- true: pos=16990 off=0x12de88 str x9, [x0]
- true: pos=16991 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=16992 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=16993 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=16994 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=16995 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=16996 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=16997 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=16998 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #94
matched_before=5438
- true: pos=17039 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=30646 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ff0 sp=0x70c6700ff0 -> sp=0x70c6700f90 `
- unidbg_raw: `30646 0x12de08 4`

True-device skipped before resync:
- true: pos=17039 off=0x12dd04 sub sp, sp, #0x60
- true: pos=17040 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=17041 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=17042 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=17043 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=17044 off=0x12dd18 add x29, sp, #0x50
- true: pos=17045 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=17046 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=17047 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=17048 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=17049 off=0x12dd2c mov w10, #-0xe9
- true: pos=17050 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #95
matched_before=5440
- true: pos=17072 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=30648 off=0x42d10 size=4
- resync: offset=0x42d10 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `30648 0x42d10 4`

True-device skipped before resync:
- true: pos=17072 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=17073 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=17074 off=0x33888 add x16, x16, #0x8c8
- true: pos=17075 off=0x3388c br x17
- true: pos=17078 off=0x12de10 str w0, [x19, #8]
- true: pos=17079 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=17080 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=17081 off=0x12de1c cmp x8, x9
- true: pos=17082 off=0x12de20 b.ne #0x70f1babe78
- true: pos=17083 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=17084 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=17085 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #96
matched_before=5457
- true: pos=17106 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=30665 off=0x42d20 size=4
- resync: offset=0x42d20 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x4 x0=0x70c6700ff0 mem_r=0x70c6700ff8 -> w8=0x0 `
- unidbg_raw: `30665 0x42d20 4`

True-device skipped before resync:
- true: pos=17106 off=0x12de7c ldr w8, [x0, #8]
- true: pos=17107 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=17108 off=0x12de84 add x9, x9, #0x7b8
- true: pos=17109 off=0x12de88 str x9, [x0]
- true: pos=17110 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=17111 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=17112 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=17113 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=17114 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=17115 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=17116 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=17117 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #97
matched_before=5500
- true: pos=17168 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=30708 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `30708 0x12de08 4`

True-device skipped before resync:
- true: pos=17168 off=0x12dd04 sub sp, sp, #0x60
- true: pos=17169 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=17170 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=17171 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=17172 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=17173 off=0x12dd18 add x29, sp, #0x50
- true: pos=17174 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=17175 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=17176 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=17177 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=17178 off=0x12dd2c mov w10, #-0xe9
- true: pos=17179 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #98
matched_before=5502
- true: pos=17201 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=30710 off=0x44ba4 size=4
- resync: offset=0x44ba4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `30710 0x44ba4 4`

True-device skipped before resync:
- true: pos=17201 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=17202 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=17203 off=0x33888 add x16, x16, #0x8c8
- true: pos=17204 off=0x3388c br x17
- true: pos=17207 off=0x12de10 str w0, [x19, #8]
- true: pos=17208 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=17209 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=17210 off=0x12de1c cmp x8, x9
- true: pos=17211 off=0x12de20 b.ne #0x70f1babe78
- true: pos=17212 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=17213 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=17214 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #99
matched_before=5512
- true: pos=17228 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=30720 off=0x44bcc size=4
- resync: offset=0x44bcc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472cdc70 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `30720 0x44bcc 4`

True-device skipped before resync:
- true: pos=17228 off=0x12de7c ldr w8, [x0, #8]
- true: pos=17229 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=17230 off=0x12de84 add x9, x9, #0x7b8
- true: pos=17231 off=0x12de88 str x9, [x0]
- true: pos=17232 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=17233 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=17234 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=17235 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=17236 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=17237 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=17238 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=17239 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #100
matched_before=5544
- true: pos=17279 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=30752 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ff0 sp=0x70c6700ff0 -> sp=0x70c6700f90 `
- unidbg_raw: `30752 0x12de08 4`

True-device skipped before resync:
- true: pos=17279 off=0x12dd04 sub sp, sp, #0x60
- true: pos=17280 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=17281 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=17282 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=17283 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=17284 off=0x12dd18 add x29, sp, #0x50
- true: pos=17285 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=17286 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=17287 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=17288 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=17289 off=0x12dd2c mov w10, #-0xe9
- true: pos=17290 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #101
matched_before=5546
- true: pos=17312 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=30754 off=0x42d10 size=4
- resync: offset=0x42d10 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `30754 0x42d10 4`

True-device skipped before resync:
- true: pos=17312 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=17313 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=17314 off=0x33888 add x16, x16, #0x8c8
- true: pos=17315 off=0x3388c br x17
- true: pos=17318 off=0x12de10 str w0, [x19, #8]
- true: pos=17319 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=17320 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=17321 off=0x12de1c cmp x8, x9
- true: pos=17322 off=0x12de20 b.ne #0x70f1babe78
- true: pos=17323 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=17324 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=17325 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #102
matched_before=5563
- true: pos=17346 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=30771 off=0x42d20 size=4
- resync: offset=0x42d20 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x4 x0=0x70c6700ff0 mem_r=0x70c6700ff8 -> w8=0x0 `
- unidbg_raw: `30771 0x42d20 4`

True-device skipped before resync:
- true: pos=17346 off=0x12de7c ldr w8, [x0, #8]
- true: pos=17347 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=17348 off=0x12de84 add x9, x9, #0x7b8
- true: pos=17349 off=0x12de88 str x9, [x0]
- true: pos=17350 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=17351 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=17352 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=17353 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=17354 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=17355 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=17356 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=17357 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #103
matched_before=7472
- true: pos=19274 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=32680 off=0x149f98 size=4
- resync: offset=0x149f98 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `32680 0x149f98 4`

True-device skipped before resync:
- true: pos=19274 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=19275 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=19276 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=19277 off=0x10b5fc add x29, sp, #0x20
- true: pos=19278 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=19279 off=0x10b604 mov x19, x0
- true: pos=19280 off=0x10b608 add x8, x8, #0xaf0
- true: pos=19281 off=0x10b60c str x8, [x0]
- true: pos=19282 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=19283 off=0x10b614 mov x0, x1
- true: pos=19284 off=0x10b618 mov x20, x1
- true: pos=19285 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #104
matched_before=7525
- true: pos=19373 off=0x330c0 adrp x16, #0x70f1cfa000
- unidbg: seq=32733 off=0x10b738 size=4
- resync: offset=0x10b738 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab10c0!0x330c0 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `32733 0x10b738 4`

True-device skipped before resync:
- true: pos=19373 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=19374 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=19375 off=0x330c8 add x16, x16, #0x4e8
- true: pos=19376 off=0x330cc br x17

Unidbg skipped before resync:
- none

## Divergence #105
matched_before=7531
- true: pos=19385 off=0x33a20 adrp x16, #0x70f1cfa000
- unidbg: seq=32739 off=0x10b750 size=4
- resync: offset=0x10b750 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1a20!0x33a20 adrp x16, #0x70f1cfa000; x16=0x70f1cfa4e8 -> x16=0x70f1cfa000 `
- unidbg_raw: `32739 0x10b750 4`

True-device skipped before resync:
- true: pos=19385 off=0x33a20 adrp x16, #0x70f1cfa000
- true: pos=19386 off=0x33a24 ldr x17, [x16, #0x998]
- true: pos=19387 off=0x33a28 add x16, x16, #0x998
- true: pos=19388 off=0x33a2c br x17

Unidbg skipped before resync:
- none

## Divergence #106
matched_before=7598
- true: pos=19469 off=0x330c0 adrp x16, #0x70f1cfa000
- unidbg: seq=32806 off=0x109b74 size=4
- resync: offset=0x109b74 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab10c0!0x330c0 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `32806 0x109b74 4`

True-device skipped before resync:
- true: pos=19469 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=19470 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=19471 off=0x330c8 add x16, x16, #0x4e8
- true: pos=19472 off=0x330cc br x17

Unidbg skipped before resync:
- none

## Divergence #107
matched_before=7603
- true: pos=19480 off=0x33330 adrp x16, #0x70f1cfa000
- unidbg: seq=32811 off=0x109b98 size=4
- resync: offset=0x109b98 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1330!0x33330 adrp x16, #0x70f1cfa000; x16=0x70f1cfa4e8 -> x16=0x70f1cfa000 `
- unidbg_raw: `32811 0x109b98 4`

True-device skipped before resync:
- true: pos=19480 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=19481 off=0x33334 ldr x17, [x16, #0x620]
- true: pos=19482 off=0x33338 add x16, x16, #0x620
- true: pos=19483 off=0x3333c br x17

Unidbg skipped before resync:
- none

## Divergence #108
matched_before=7624
- true: pos=19509 off=0x33a20 adrp x16, #0x70f1cfa000
- unidbg: seq=32832 off=0x10b89c size=4
- resync: offset=0x10b89c true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1a20!0x33a20 adrp x16, #0x70f1cfa000; x16=0x70f1cfa620 -> x16=0x70f1cfa000 `
- unidbg_raw: `32832 0x10b89c 4`

True-device skipped before resync:
- true: pos=19509 off=0x33a20 adrp x16, #0x70f1cfa000
- true: pos=19510 off=0x33a24 ldr x17, [x16, #0x998]
- true: pos=19511 off=0x33a28 add x16, x16, #0x998
- true: pos=19512 off=0x33a2c br x17

Unidbg skipped before resync:
- none

## Divergence #109
matched_before=7635
- true: pos=19537 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=32843 off=0x149fe0 size=4
- resync: offset=0x149fe0 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `32843 0x149fe0 4`

True-device skipped before resync:
- true: pos=19537 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=19538 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=19539 off=0x10b76c add x29, sp, #0x10
- true: pos=19540 off=0x10b770 mov x19, x0
- true: pos=19541 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=19542 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=19543 off=0x10b77c add x8, x8, #0xaf0
- true: pos=19544 off=0x10b780 str x8, [x19]
- true: pos=19545 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=19546 off=0x10b788 bl #0x70f1ab1330
- true: pos=19547 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=19548 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #110
matched_before=7674
- true: pos=19610 off=0x1c5170 str x23, [sp, #-0x40]!
- unidbg: seq=32882 off=0x14a7b8 size=4
- resync: offset=0x14a7b8 true_ahead=55 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c43170!0x1c5170 str x23, [sp, #-0x40]!; x23=0x70c6701540 sp=0x70c6701010 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `32882 0x14a7b8 4`

True-device skipped before resync:
- true: pos=19610 off=0x1c5170 str x23, [sp, #-0x40]!
- true: pos=19611 off=0x1c5174 stp x22, x21, [sp, #0x10]
- true: pos=19612 off=0x1c5178 stp x20, x19, [sp, #0x20]
- true: pos=19613 off=0x1c517c stp x29, x30, [sp, #0x30]
- true: pos=19614 off=0x1c5180 add x29, sp, #0x30
- true: pos=19615 off=0x1c5184 ldarb w8, [x0]
- true: pos=19616 off=0x1c5188 tst w8, #0xff
- true: pos=19617 off=0x1c518c b.eq #0x70f1c43198
- true: pos=19618 off=0x1c5198 mov x19, x0
- true: pos=19619 off=0x1c519c adrp x0, #0x70f1d45000
- true: pos=19620 off=0x1c51a0 add x0, x0, #0xcd0
- true: pos=19621 off=0x1c51a4 bl #0x70f1ab1880
- ... 43 more

Unidbg skipped before resync:
- none

## Divergence #111
matched_before=7677
- true: pos=19674 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=32885 off=0x14a7c4 size=4
- resync: offset=0x14a7c4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70f1d41000 sp=0x70c6701010 mem_w=0x70c6700ff0 -> sp=0x70c6700ff0 `
- unidbg_raw: `32885 0x14a7c4 4`

True-device skipped before resync:
- true: pos=19674 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=19675 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=19676 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=19677 off=0x1c2ee8 cmp x0, #0
- true: pos=19678 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=19679 off=0x1c2ef0 mov x0, x19
- true: pos=19680 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=19681 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=19682 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=19683 off=0x330c8 add x16, x16, #0x4e8
- true: pos=19684 off=0x330cc br x17
- true: pos=19687 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #112
matched_before=7680
- true: pos=19694 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=32888 off=0x14a7d0 size=4
- resync: offset=0x14a7d0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x74472ffe90 sp=0x70c6701010 mem_w=0x70c6700ff0 -> sp=0x70c6700ff0 `
- unidbg_raw: `32888 0x14a7d0 4`

True-device skipped before resync:
- true: pos=19694 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=19695 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=19696 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=19697 off=0x1c2ee8 cmp x0, #0
- true: pos=19698 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=19699 off=0x1c2ef0 mov x0, x19
- true: pos=19700 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=19701 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=19702 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=19703 off=0x330c8 add x16, x16, #0x4e8
- true: pos=19704 off=0x330cc br x17
- true: pos=19707 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #113
matched_before=7692
- true: pos=19723 off=0x579e0 adrp x8, #0x70f1cdf000
- unidbg: seq=32900 off=0x12d3a4 size=4
- resync: offset=0x12d3a4 true_ahead=9 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ad59e0!0x579e0 adrp x8, #0x70f1cdf000; x8=0x3b5ab3359d2c91e5 -> x8=0x70f1cdf000 `
- unidbg_raw: `32900 0x12d3a4 4`

True-device skipped before resync:
- true: pos=19723 off=0x579e0 adrp x8, #0x70f1cdf000
- true: pos=19724 off=0x579e4 add x8, x8, #0x100
- true: pos=19725 off=0x579e8 str x8, [x0], #8
- true: pos=19726 off=0x579ec mov x1, xzr
- true: pos=19727 off=0x579f0 b #0x70f1ab1030
- true: pos=19728 off=0x33030 adrp x16, #0x70f1cfa000
- true: pos=19729 off=0x33034 ldr x17, [x16, #0x4a0]
- true: pos=19730 off=0x33038 add x16, x16, #0x4a0
- true: pos=19731 off=0x3303c br x17

Unidbg skipped before resync:
- none

## Divergence #114
matched_before=7734
- true: pos=19776 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=32942 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f60 sp=0x70c6700f60 -> sp=0x70c6700f00 `
- unidbg_raw: `32942 0x12de08 4`

True-device skipped before resync:
- true: pos=19776 off=0x12dd04 sub sp, sp, #0x60
- true: pos=19777 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=19778 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=19779 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=19780 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=19781 off=0x12dd18 add x29, sp, #0x50
- true: pos=19782 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=19783 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=19784 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=19785 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=19786 off=0x12dd2c mov w10, #-0xe9
- true: pos=19787 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #115
matched_before=7736
- true: pos=19809 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=32944 off=0x45f0c size=4
- resync: offset=0x45f0c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa4a0 -> x16=0x70f1cfa000 `
- unidbg_raw: `32944 0x45f0c 4`

True-device skipped before resync:
- true: pos=19809 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=19810 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=19811 off=0x33888 add x16, x16, #0x8c8
- true: pos=19812 off=0x3388c br x17
- true: pos=19815 off=0x12de10 str w0, [x19, #8]
- true: pos=19816 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=19817 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=19818 off=0x12de1c cmp x8, x9
- true: pos=19819 off=0x12de20 b.ne #0x70f1babe78
- true: pos=19820 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=19821 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=19822 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #116
matched_before=7746
- true: pos=19836 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=32954 off=0x45f34 size=4
- resync: offset=0x45f34 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472ba7b0 x0=0x70c6700f60 mem_r=0x70c6700f68 -> w8=0x0 `
- unidbg_raw: `32954 0x45f34 4`

True-device skipped before resync:
- true: pos=19836 off=0x12de7c ldr w8, [x0, #8]
- true: pos=19837 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=19838 off=0x12de84 add x9, x9, #0x7b8
- true: pos=19839 off=0x12de88 str x9, [x0]
- true: pos=19840 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=19841 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=19842 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=19843 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=19844 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=19845 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=19846 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=19847 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #117
matched_before=7765
- true: pos=19874 off=0x1c2f40 b #0x70f1c40edc
- unidbg: seq=32973 off=0x12d458 size=4
- resync: offset=0x12d458 true_ahead=16 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40f40!0x1c2f40 b #0x70f1c40edc; `
- unidbg_raw: `32973 0x12d458 4`

True-device skipped before resync:
- true: pos=19874 off=0x1c2f40 b #0x70f1c40edc
- true: pos=19875 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=19876 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=19877 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=19878 off=0x1c2ee8 cmp x0, #0
- true: pos=19879 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=19880 off=0x1c2ef0 mov x0, x19
- true: pos=19881 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=19882 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=19883 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=19884 off=0x330c8 add x16, x16, #0x4e8
- true: pos=19885 off=0x330cc br x17
- ... 4 more

Unidbg skipped before resync:
- none

## Divergence #118
matched_before=7770
- true: pos=19897 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=32978 off=0x12d46c size=4
- resync: offset=0x12d46c true_ahead=1355 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6700f90 sp=0x70c6700f90 -> sp=0x70c6700f00 `
- unidbg_raw: `32978 0x12d46c 4`

True-device skipped before resync:
- true: pos=19897 off=0x12c9a4 sub sp, sp, #0x90
- true: pos=19898 off=0x12c9a8 str x19, [sp, #0x70]
- true: pos=19899 off=0x12c9ac stp x29, x30, [sp, #0x80]
- true: pos=19900 off=0x12c9b0 add x29, sp, #0x80
- true: pos=19901 off=0x12c9b4 mrs x8, tpidr_el0
- true: pos=19902 off=0x12c9b8 ldr x8, [x8, #0x28]
- true: pos=19903 off=0x12c9bc stur x8, [x29, #-0x18]
- true: pos=19904 off=0x12c9c0 str x0, [sp, #0x38]
- true: pos=19905 off=0x12c9c4 str w1, [sp, #0x34]
- true: pos=19906 off=0x12c9c8 bl #0x70f1ac4840
- true: pos=19907 off=0x46840 stp x20, x19, [sp, #-0x20]!
- true: pos=19908 off=0x46844 stp x29, x30, [sp, #0x10]
- ... 1343 more

Unidbg skipped before resync:
- none

## Divergence #119
matched_before=7780
- true: pos=21262 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=32988 off=0x12d3cc size=4
- resync: offset=0x12d3cc true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x70c6703a40 sp=0x70c6700fb0 mem_w=0x70c6700f80 -> sp=0x70c6700f80 `
- unidbg_raw: `32988 0x12d3cc 4`

True-device skipped before resync:
- true: pos=21262 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=21263 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=21264 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=21265 off=0x10b5fc add x29, sp, #0x20
- true: pos=21266 off=0x10b600 adrp x8, #0x70f1ce0000
- true: pos=21267 off=0x10b604 mov x19, x0
- true: pos=21268 off=0x10b608 add x8, x8, #0xaf0
- true: pos=21269 off=0x10b60c str x8, [x0]
- true: pos=21270 off=0x10b610 cbz x1, #0x70f1b89654
- true: pos=21271 off=0x10b614 mov x0, x1
- true: pos=21272 off=0x10b618 mov x20, x1
- true: pos=21273 off=0x10b61c bl #0x70f1ab1b40
- ... 25 more

Unidbg skipped before resync:
- none

## Divergence #120
matched_before=8302
- true: pos=21914 off=0x33390 adrp x16, #0x70f1cfa000
- unidbg: seq=33510 off=0x12b01c size=4
- resync: offset=0x12b01c true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1390!0x33390 adrp x16, #0x70f1cfa000; x16=0x70f1cfa9d0 -> x16=0x70f1cfa000 `
- unidbg_raw: `33510 0x12b01c 4`

True-device skipped before resync:
- true: pos=21914 off=0x33390 adrp x16, #0x70f1cfa000
- true: pos=21915 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=21916 off=0x33398 add x16, x16, #0x650
- true: pos=21917 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #121
matched_before=8324
- true: pos=21942 off=0x33390 adrp x16, #0x70f1cfa000
- unidbg: seq=33532 off=0x12af70 size=4
- resync: offset=0x12af70 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1390!0x33390 adrp x16, #0x70f1cfa000; x16=0x70f1cfa650 -> x16=0x70f1cfa000 `
- unidbg_raw: `33532 0x12af70 4`

True-device skipped before resync:
- true: pos=21942 off=0x33390 adrp x16, #0x70f1cfa000
- true: pos=21943 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=21944 off=0x33398 add x16, x16, #0x650
- true: pos=21945 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #122
matched_before=8338
- true: pos=21962 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=33546 off=0x12d3e4 size=4
- resync: offset=0x12d3e4 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x74572d7590 sp=0x70c6700fb0 mem_w=0x70c6700f90 -> sp=0x70c6700f90 `
- unidbg_raw: `33546 0x12d3e4 4`

True-device skipped before resync:
- true: pos=21962 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=21963 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=21964 off=0x10b76c add x29, sp, #0x10
- true: pos=21965 off=0x10b770 mov x19, x0
- true: pos=21966 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=21967 off=0x10b778 adrp x8, #0x70f1ce0000
- true: pos=21968 off=0x10b77c add x8, x8, #0xaf0
- true: pos=21969 off=0x10b780 str x8, [x19]
- true: pos=21970 off=0x10b784 cbz x0, #0x70f1b89790
- true: pos=21971 off=0x10b788 bl #0x70f1ab1330
- true: pos=21972 off=0x33330 adrp x16, #0x70f1cfa000
- true: pos=21973 off=0x33334 ldr x17, [x16, #0x620]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #123
matched_before=8341
- true: pos=21990 off=0x12ab04 str x19, [sp, #-0x20]!
- unidbg: seq=33549 off=0x12d3f0 size=4
- resync: offset=0x12d3f0 true_ahead=381 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ba8b04!0x12ab04 str x19, [sp, #-0x20]!; x19=0x74572d7590 sp=0x70c6700fb0 mem_w=0x70c6700f90 -> sp=0x70c6700f90 `
- unidbg_raw: `33549 0x12d3f0 4`

True-device skipped before resync:
- true: pos=21990 off=0x12ab04 str x19, [sp, #-0x20]!
- true: pos=21991 off=0x12ab08 stp x29, x30, [sp, #0x10]
- true: pos=21992 off=0x12ab0c add x29, sp, #0x10
- true: pos=21993 off=0x12ab10 adrp x8, #0x70f1cee000
- true: pos=21994 off=0x12ab14 add x8, x8, #0x690
- true: pos=21995 off=0x12ab18 mov w9, #-0x91d
- true: pos=21996 off=0x12ab1c mov x19, x0
- true: pos=21997 off=0x12ab20 stp x8, x1, [x0]
- true: pos=21998 off=0x12ab24 str w9, [x0, #0x10]
- true: pos=21999 off=0x12ab28 adrp x0, #0x70f1d41000
- true: pos=22000 off=0x12ab2c adrp x1, #0x70f1ba8000
- true: pos=22001 off=0x12ab30 add x0, x0, #0x360
- ... 369 more

Unidbg skipped before resync:
- none

## Divergence #124
matched_before=8347
- true: pos=22387 off=0x12ab78 str x19, [sp, #-0x20]!
- unidbg: seq=33555 off=0x12d408 size=4
- resync: offset=0x12d408 true_ahead=263 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ba8b78!0x12ab78 str x19, [sp, #-0x20]!; x19=0x74572d7590 sp=0x70c6700fb0 mem_w=0x70c6700f90 -> sp=0x70c6700f90 `
- unidbg_raw: `33555 0x12d408 4`

True-device skipped before resync:
- true: pos=22387 off=0x12ab78 str x19, [sp, #-0x20]!
- true: pos=22388 off=0x12ab7c stp x29, x30, [sp, #0x10]
- true: pos=22389 off=0x12ab80 add x29, sp, #0x10
- true: pos=22390 off=0x12ab84 ldr w8, [x0, #0x10]
- true: pos=22391 off=0x12ab88 adrp x9, #0x70f1cee000
- true: pos=22392 off=0x12ab8c add x9, x9, #0x690
- true: pos=22393 off=0x12ab90 str x9, [x0]
- true: pos=22394 off=0x12ab94 cbz w8, #0x70f1ba8ba4
- true: pos=22395 off=0x12aba4 ldr x8, [x0, #8]
- true: pos=22396 off=0x12aba8 mov x19, x0
- true: pos=22397 off=0x12abac add x0, x8, #8
- true: pos=22398 off=0x12abb0 bl #0x70f1ab1390
- ... 251 more

Unidbg skipped before resync:
- none

## Divergence #125
matched_before=8360
- true: pos=22671 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=33568 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f70 sp=0x70c6700f70 -> sp=0x70c6700f10 `
- unidbg_raw: `33568 0x12de08 4`

True-device skipped before resync:
- true: pos=22671 off=0x12dd04 sub sp, sp, #0x60
- true: pos=22672 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=22673 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=22674 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=22675 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=22676 off=0x12dd18 add x29, sp, #0x50
- true: pos=22677 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=22678 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=22679 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=22680 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=22681 off=0x12dd2c mov w10, #-0xe9
- true: pos=22682 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #126
matched_before=8362
- true: pos=22704 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=33570 off=0x45f88 size=4
- resync: offset=0x45f88 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa620 -> x16=0x70f1cfa000 `
- unidbg_raw: `33570 0x45f88 4`

True-device skipped before resync:
- true: pos=22704 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=22705 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=22706 off=0x33888 add x16, x16, #0x8c8
- true: pos=22707 off=0x3388c br x17
- true: pos=22710 off=0x12de10 str w0, [x19, #8]
- true: pos=22711 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=22712 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=22713 off=0x12de1c cmp x8, x9
- true: pos=22714 off=0x12de20 b.ne #0x70f1babe78
- true: pos=22715 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=22716 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=22717 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #127
matched_before=8379
- true: pos=22738 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=33587 off=0x45f98 size=4
- resync: offset=0x45f98 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700f70 mem_r=0x70c6700f78 -> w8=0x0 `
- unidbg_raw: `33587 0x45f98 4`

True-device skipped before resync:
- true: pos=22738 off=0x12de7c ldr w8, [x0, #8]
- true: pos=22739 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=22740 off=0x12de84 add x9, x9, #0x7b8
- true: pos=22741 off=0x12de88 str x9, [x0]
- true: pos=22742 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=22743 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=22744 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=22745 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=22746 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=22747 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=22748 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=22749 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #128
matched_before=8412
- true: pos=22790 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=33620 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fc0 sp=0x70c6700fc0 -> sp=0x70c6700f60 `
- unidbg_raw: `33620 0x12de08 4`

True-device skipped before resync:
- true: pos=22790 off=0x12dd04 sub sp, sp, #0x60
- true: pos=22791 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=22792 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=22793 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=22794 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=22795 off=0x12dd18 add x29, sp, #0x50
- true: pos=22796 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=22797 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=22798 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=22799 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=22800 off=0x12dd2c mov w10, #-0xe9
- true: pos=22801 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #129
matched_before=8414
- true: pos=22823 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=33622 off=0x14c9bc size=4
- resync: offset=0x14c9bc true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `33622 0x14c9bc 4`

True-device skipped before resync:
- true: pos=22823 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=22824 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=22825 off=0x33888 add x16, x16, #0x8c8
- true: pos=22826 off=0x3388c br x17
- true: pos=22829 off=0x12de10 str w0, [x19, #8]
- true: pos=22830 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=22831 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=22832 off=0x12de1c cmp x8, x9
- true: pos=22833 off=0x12de20 b.ne #0x70f1babe78
- true: pos=22834 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=22835 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=22836 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #130
matched_before=8417
- true: pos=22843 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33625 off=0x14c9c8 size=4
- resync: offset=0x14c9c8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x74572d7590 sp=0x70c6700fc0 mem_w=0x70c6700fa0 -> sp=0x70c6700fa0 `
- unidbg_raw: `33625 0x14c9c8 4`

True-device skipped before resync:
- true: pos=22843 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=22844 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=22845 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=22846 off=0x1c2ee8 cmp x0, #0
- true: pos=22847 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=22848 off=0x1c2ef0 mov x0, x19
- true: pos=22849 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=22850 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=22851 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=22852 off=0x330c8 add x16, x16, #0x4e8
- true: pos=22853 off=0x330cc br x17
- true: pos=22856 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #131
matched_before=8422
- true: pos=22865 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=33630 off=0x14c9dc size=4
- resync: offset=0x14c9dc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fc0 mem_r=0x70c6700fc8 -> w8=0x0 `
- unidbg_raw: `33630 0x14c9dc 4`

True-device skipped before resync:
- true: pos=22865 off=0x12de7c ldr w8, [x0, #8]
- true: pos=22866 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=22867 off=0x12de84 add x9, x9, #0x7b8
- true: pos=22868 off=0x12de88 str x9, [x0]
- true: pos=22869 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=22870 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=22871 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=22872 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=22873 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=22874 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=22875 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=22876 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #132
matched_before=8437
- true: pos=22899 off=0x1c52d0 str x21, [sp, #-0x30]!
- unidbg: seq=33645 off=0x14a7fc size=4
- resync: offset=0x14a7fc true_ahead=30 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c432d0!0x1c52d0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6701010 mem_w=0x70c6700fe0 -> sp=0x70c6700fe0 `
- unidbg_raw: `33645 0x14a7fc 4`

True-device skipped before resync:
- true: pos=22899 off=0x1c52d0 str x21, [sp, #-0x30]!
- true: pos=22900 off=0x1c52d4 stp x20, x19, [sp, #0x10]
- true: pos=22901 off=0x1c52d8 stp x29, x30, [sp, #0x20]
- true: pos=22902 off=0x1c52dc add x29, sp, #0x20
- true: pos=22903 off=0x1c52e0 mov w21, #1
- true: pos=22904 off=0x1c52e4 mov x19, x0
- true: pos=22905 off=0x1c52e8 stlrb w21, [x0]
- true: pos=22906 off=0x1c52ec adrp x0, #0x70f1d45000
- true: pos=22907 off=0x1c52f0 add x0, x0, #0xcd0
- true: pos=22908 off=0x1c52f4 bl #0x70f1ab1880
- true: pos=22909 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=22910 off=0x33884 ldr x17, [x16, #0x8c8]
- ... 18 more

Unidbg skipped before resync:
- none

## Divergence #133
matched_before=8467
- true: pos=22965 off=0x12e09c b #0x70f1bc1858
- unidbg: seq=33675 off=0x12d4c8 size=4
- resync: offset=0x12d4c8 true_ahead=42 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bac09c!0x12e09c b #0x70f1bc1858; `
- unidbg_raw: `33675 0x12d4c8 4`

True-device skipped before resync:
- true: pos=22965 off=0x12e09c b #0x70f1bc1858
- true: pos=22966 off=0x143858 stp x29, x30, [sp, #-0x10]!
- true: pos=22967 off=0x14385c mov x29, sp
- true: pos=22968 off=0x143860 bl #0x70f1c22cc4
- true: pos=22969 off=0x1a4cc4 sub sp, sp, #0x40
- true: pos=22970 off=0x1a4cc8 str x19, [sp, #0x20]
- true: pos=22971 off=0x1a4ccc stp x29, x30, [sp, #0x30]
- true: pos=22972 off=0x1a4cd0 add x29, sp, #0x30
- true: pos=22973 off=0x1a4cd4 mrs x19, tpidr_el0
- true: pos=22974 off=0x1a4cd8 ldr x8, [x19, #0x28]
- true: pos=22975 off=0x1a4cdc str x8, [sp, #0x18]
- true: pos=22976 off=0x1a4ce0 add x1, sp, #8
- ... 30 more

Unidbg skipped before resync:
- none

## Divergence #134
matched_before=8480
- true: pos=23022 off=0x33390 adrp x16, #0x70f1cfa000
- unidbg: seq=33688 off=0x12d4dc size=4
- resync: offset=0x12d4dc true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1390!0x33390 adrp x16, #0x70f1cfa000; x16=0x2ecae803df0000 -> x16=0x70f1cfa000 `
- unidbg_raw: `33688 0x12d4dc 4`

True-device skipped before resync:
- true: pos=23022 off=0x33390 adrp x16, #0x70f1cfa000
- true: pos=23023 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=23024 off=0x33398 add x16, x16, #0x650
- true: pos=23025 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #135
matched_before=8516
- true: pos=23064 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=33724 off=0x1261f0 size=4
- resync: offset=0x1261f0 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa650 -> x16=0x70f1cfa000 `
- unidbg_raw: `33724 0x1261f0 4`

True-device skipped before resync:
- true: pos=23064 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=23065 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=23066 off=0x33888 add x16, x16, #0x8c8
- true: pos=23067 off=0x3388c br x17

Unidbg skipped before resync:
- none

## Divergence #136
matched_before=8521
- true: pos=23075 off=0x10e824 ldr x0, [x0]
- unidbg: seq=33729 off=0x1261fc size=4
- resync: offset=0x1261fc true_ahead=6 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8c824!0x10e824 ldr x0, [x0]; x0=0x734734caf0 x0=0x734734caf0 mem_r=0x734734caf0 -> x0=0x734734c750 `
- unidbg_raw: `33729 0x1261fc 4`

True-device skipped before resync:
- true: pos=23075 off=0x10e824 ldr x0, [x0]
- true: pos=23076 off=0x10e828 b #0x70f1b8cc94
- true: pos=23077 off=0x10ec94 ldr x1, [x0]
- true: pos=23078 off=0x10ec98 adrp x0, #0x70f1cfb000
- true: pos=23079 off=0x10ec9c add x0, x0, #0xf80
- true: pos=23080 off=0x10eca0 ret

Unidbg skipped before resync:
- none

## Divergence #137
matched_before=8538
- true: pos=23098 off=0x10f504 ldr x8, [x0, #8]
- unidbg: seq=33746 off=0x12621c size=4
- resync: offset=0x12621c true_ahead=6 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d504!0x10f504 ldr x8, [x0, #8]; x8=0x70f1b8d504 x0=0x70c6700fc0 mem_r=0x70c6700fc8 -> x8=0x734735a2d0 `
- unidbg_raw: `33746 0x12621c 4`

True-device skipped before resync:
- true: pos=23098 off=0x10f504 ldr x8, [x0, #8]
- true: pos=23099 off=0x10f508 ldr x9, [x1, #8]
- true: pos=23100 off=0x10f50c cmp x8, x9
- true: pos=23101 off=0x10f510 b.eq #0x70f1b8d51c
- true: pos=23102 off=0x10f514 mov w0, wzr
- true: pos=23103 off=0x10f518 ret

Unidbg skipped before resync:
- none

## Divergence #138
matched_before=8543
- true: pos=23109 off=0x10f4a0 ldr x8, [x0, #8]
- unidbg: seq=33751 off=0x126230 size=4
- resync: offset=0x126230 true_ahead=3 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d4a0!0x10f4a0 ldr x8, [x0, #8]; x8=0x70f1b8d4a0 x0=0x70c6700fc0 mem_r=0x70c6700fc8 -> x8=0x734735a2d0 `
- unidbg_raw: `33751 0x126230 4`

True-device skipped before resync:
- true: pos=23109 off=0x10f4a0 ldr x8, [x0, #8]
- true: pos=23110 off=0x10f4a4 ldr x0, [x8, #0x20]
- true: pos=23111 off=0x10f4a8 ret

Unidbg skipped before resync:
- none

## Divergence #139
matched_before=8550
- true: pos=23119 off=0x44a98 ldr w8, [x0, #0x10]
- unidbg: seq=33758 off=0x12626c size=4
- resync: offset=0x12626c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac2a98!0x44a98 ldr w8, [x0, #0x10]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700ff0 -> w8=0x0 `
- unidbg_raw: `33758 0x12626c 4`

True-device skipped before resync:
- true: pos=23119 off=0x44a98 ldr w8, [x0, #0x10]
- true: pos=23120 off=0x44a9c adrp x9, #0x70f1cde000
- true: pos=23121 off=0x44aa0 add x9, x9, #0x5b8
- true: pos=23122 off=0x44aa4 str x9, [x0]
- true: pos=23123 off=0x44aa8 cbz w8, #0x70f1ac2ab0
- true: pos=23124 off=0x44ab0 ldr x8, [x0, #8]
- true: pos=23125 off=0x44ab4 add x0, x8, #8
- true: pos=23126 off=0x44ab8 b #0x70f1ab15a0
- true: pos=23127 off=0x335a0 adrp x16, #0x70f1cfa000
- true: pos=23128 off=0x335a4 ldr x17, [x16, #0x758]
- true: pos=23129 off=0x335a8 add x16, x16, #0x758
- true: pos=23130 off=0x335ac br x17

Unidbg skipped before resync:
- none

## Divergence #140
matched_before=8566
- true: pos=23149 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33774 off=0x14a03c size=4
- resync: offset=0x14a03c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `33774 0x14a03c 4`

True-device skipped before resync:
- true: pos=23149 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23150 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23151 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23152 off=0x1c2ee8 cmp x0, #0
- true: pos=23153 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23154 off=0x1c2ef0 mov x0, x19
- true: pos=23155 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23156 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23157 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23158 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23159 off=0x330cc br x17
- true: pos=23162 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #141
matched_before=8570
- true: pos=23170 off=0x10b488 stp x22, x21, [sp, #-0x30]!
- unidbg: seq=33778 off=0x14a04c size=4
- resync: offset=0x14a04c true_ahead=39 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89488!0x10b488 stp x22, x21, [sp, #-0x30]!; x22=0x739749da60 x21=0x1 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `33778 0x14a04c 4`

True-device skipped before resync:
- true: pos=23170 off=0x10b488 stp x22, x21, [sp, #-0x30]!
- true: pos=23171 off=0x10b48c stp x20, x19, [sp, #0x10]
- true: pos=23172 off=0x10b490 stp x29, x30, [sp, #0x20]
- true: pos=23173 off=0x10b494 add x29, sp, #0x20
- true: pos=23174 off=0x10b498 adrp x8, #0x70f1ce0000
- true: pos=23175 off=0x10b49c mov x22, x0
- true: pos=23176 off=0x10b4a0 add x8, x8, #0xaf0
- true: pos=23177 off=0x10b4a4 str x8, [x0]
- true: pos=23178 off=0x10b4a8 str xzr, [x0, #0x10]
- true: pos=23179 off=0x10b4ac tbnz w2, #0x1f, #0x70f1b894f0
- true: pos=23180 off=0x10b4b0 add w8, w2, #1
- true: pos=23181 off=0x10b4b4 sxtw x0, w8
- ... 27 more

Unidbg skipped before resync:
- none

## Divergence #142
matched_before=8586
- true: pos=23231 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=33794 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=126 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `33794 0x12de08 4`

True-device skipped before resync:
- true: pos=23231 off=0x12dd04 sub sp, sp, #0x60
- true: pos=23232 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=23233 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=23234 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=23235 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=23236 off=0x12dd18 add x29, sp, #0x50
- true: pos=23237 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=23238 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=23239 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=23240 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=23241 off=0x12dd2c mov w10, #-0xe9
- true: pos=23242 off=0x12dd30 str x8, [sp, #0x18]
- ... 114 more

Unidbg skipped before resync:
- none

## Divergence #143
matched_before=8588
- true: pos=23373 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=33796 off=0x478c0 size=4
- resync: offset=0x478c0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `33796 0x478c0 4`

True-device skipped before resync:
- true: pos=23373 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=23374 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=23375 off=0x33888 add x16, x16, #0x8c8
- true: pos=23376 off=0x3388c br x17
- true: pos=23379 off=0x12de10 str w0, [x19, #8]
- true: pos=23380 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=23381 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=23382 off=0x12de1c cmp x8, x9
- true: pos=23383 off=0x12de20 b.ne #0x70f1babe78
- true: pos=23384 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=23385 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=23386 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #144
matched_before=8591
- true: pos=23393 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33799 off=0x478cc size=4
- resync: offset=0x478cc true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x739749da60 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `33799 0x478cc 4`

True-device skipped before resync:
- true: pos=23393 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23394 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23395 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23396 off=0x1c2ee8 cmp x0, #0
- true: pos=23397 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23398 off=0x1c2ef0 mov x0, x19
- true: pos=23399 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23400 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23401 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23402 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23403 off=0x330cc br x17
- true: pos=23406 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #145
matched_before=8596
- true: pos=23415 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=33804 off=0x478e0 size=4
- resync: offset=0x478e0 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `33804 0x478e0 4`

True-device skipped before resync:
- true: pos=23415 off=0x12de7c ldr w8, [x0, #8]
- true: pos=23416 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=23417 off=0x12de84 add x9, x9, #0x7b8
- true: pos=23418 off=0x12de88 str x9, [x0]
- true: pos=23419 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=23420 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=23421 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=23422 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=23423 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=23424 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=23425 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=23426 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #146
matched_before=8677
- true: pos=23515 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33885 off=0x88678 size=4
- resync: offset=0x88678 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6700ff8 sp=0x70c6700f00 mem_w=0x70c6700ee0 -> sp=0x70c6700ee0 `
- unidbg_raw: `33885 0x88678 4`

True-device skipped before resync:
- true: pos=23515 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23516 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23517 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23518 off=0x1c2ee8 cmp x0, #0
- true: pos=23519 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23520 off=0x1c2ef0 mov x0, x19
- true: pos=23521 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23522 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23523 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23524 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23525 off=0x330cc br x17
- true: pos=23528 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #147
matched_before=8694
- true: pos=23549 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33902 off=0x878ac size=4
- resync: offset=0x878ac true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x73974c95c0 sp=0x70c6700eb0 mem_w=0x70c6700e90 -> sp=0x70c6700e90 `
- unidbg_raw: `33902 0x878ac 4`

True-device skipped before resync:
- true: pos=23549 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23550 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23551 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23552 off=0x1c2ee8 cmp x0, #0
- true: pos=23553 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23554 off=0x1c2ef0 mov x0, x19
- true: pos=23555 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23556 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23557 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23558 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23559 off=0x330cc br x17
- true: pos=23562 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #148
matched_before=8705
- true: pos=23577 off=0x1206dc adrp x8, #0x70f1ced000
- unidbg: seq=33913 off=0x878d8 size=4
- resync: offset=0x878d8 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9e6dc!0x1206dc adrp x8, #0x70f1ced000; x8=0x70f1b05924 -> x8=0x70f1ced000 `
- unidbg_raw: `33913 0x878d8 4`

True-device skipped before resync:
- true: pos=23577 off=0x1206dc adrp x8, #0x70f1ced000
- true: pos=23578 off=0x1206e0 add x8, x8, #0x1b8
- true: pos=23579 off=0x1206e4 str x8, [x0]
- true: pos=23580 off=0x1206e8 ldr q0, [x1]
- true: pos=23581 off=0x1206ec ldr x1, [x1, #0x10]
- true: pos=23582 off=0x1206f0 add x8, x0, #0x20
- true: pos=23583 off=0x1206f4 stur q0, [x0, #8]
- true: pos=23584 off=0x1206f8 str x1, [x0, #0x18]
- true: pos=23585 off=0x1206fc mov x0, x8
- true: pos=23586 off=0x120700 b #0x70f1b8c930
- true: pos=23587 off=0x10e930 str x21, [sp, #-0x30]!
- true: pos=23588 off=0x10e934 stp x20, x19, [sp, #0x10]
- ... 57 more

Unidbg skipped before resync:
- none

## Divergence #149
matched_before=8721
- true: pos=23666 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=33929 off=0x879b4 size=4
- resync: offset=0x879b4 true_ahead=48 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `33929 0x879b4 4`

True-device skipped before resync:
- true: pos=23666 off=0x12dd04 sub sp, sp, #0x60
- true: pos=23667 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=23668 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=23669 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=23670 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=23671 off=0x12dd18 add x29, sp, #0x50
- true: pos=23672 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=23673 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=23674 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=23675 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=23676 off=0x12dd2c mov w10, #-0xe9
- true: pos=23677 off=0x12dd30 str x8, [sp, #0x18]
- ... 36 more

Unidbg skipped before resync:
- none

## Divergence #150
matched_before=8724
- true: pos=23719 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33932 off=0x879c0 size=4
- resync: offset=0x879c0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x734732a490 sp=0x70c6700e60 mem_w=0x70c6700e40 -> sp=0x70c6700e40 `
- unidbg_raw: `33932 0x879c0 4`

True-device skipped before resync:
- true: pos=23719 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23720 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23721 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23722 off=0x1c2ee8 cmp x0, #0
- true: pos=23723 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23724 off=0x1c2ef0 mov x0, x19
- true: pos=23725 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23726 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23727 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23728 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23729 off=0x330cc br x17
- true: pos=23732 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #151
matched_before=8729
- true: pos=23741 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=33937 off=0x879d4 size=4
- resync: offset=0x879d4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `33937 0x879d4 4`

True-device skipped before resync:
- true: pos=23741 off=0x12de7c ldr w8, [x0, #8]
- true: pos=23742 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=23743 off=0x12de84 add x9, x9, #0x7b8
- true: pos=23744 off=0x12de88 str x9, [x0]
- true: pos=23745 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=23746 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=23747 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=23748 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=23749 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=23750 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=23751 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=23752 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #152
matched_before=8740
- true: pos=23771 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33948 off=0x878ec size=4
- resync: offset=0x878ec true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x73974c95c0 sp=0x70c6700eb0 mem_w=0x70c6700e90 -> sp=0x70c6700e90 `
- unidbg_raw: `33948 0x878ec 4`

True-device skipped before resync:
- true: pos=23771 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23772 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23773 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23774 off=0x1c2ee8 cmp x0, #0
- true: pos=23775 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23776 off=0x1c2ef0 mov x0, x19
- true: pos=23777 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23778 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23779 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23780 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23781 off=0x330cc br x17
- true: pos=23784 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #153
matched_before=8743
- true: pos=23791 off=0x42aac sub sp, sp, #0x30
- unidbg: seq=33951 off=0x878f8 size=4
- resync: offset=0x878f8 true_ahead=27 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac0aac!0x42aac sub sp, sp, #0x30; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e80 `
- unidbg_raw: `33951 0x878f8 4`

True-device skipped before resync:
- true: pos=23791 off=0x42aac sub sp, sp, #0x30
- true: pos=23792 off=0x42ab0 stp x20, x19, [sp, #0x10]
- true: pos=23793 off=0x42ab4 stp x29, x30, [sp, #0x20]
- true: pos=23794 off=0x42ab8 add x29, sp, #0x20
- true: pos=23795 off=0x42abc mrs x20, tpidr_el0
- true: pos=23796 off=0x42ac0 ldr x8, [x20, #0x28]
- true: pos=23797 off=0x42ac4 adrp x9, #0x70f1cde000
- true: pos=23798 off=0x42ac8 mov x19, x0
- true: pos=23799 off=0x42acc add x9, x9, #0x578
- true: pos=23800 off=0x42ad0 str x8, [sp, #8]
- true: pos=23801 off=0x42ad4 str x9, [x0]
- true: pos=23802 off=0x42ad8 tbz w1, #0, #0x70f1ac0b08
- ... 15 more

Unidbg skipped before resync:
- none

## Divergence #154
matched_before=8770
- true: pos=23847 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=33978 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e50 `
- unidbg_raw: `33978 0x12de08 4`

True-device skipped before resync:
- true: pos=23847 off=0x12dd04 sub sp, sp, #0x60
- true: pos=23848 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=23849 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=23850 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=23851 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=23852 off=0x12dd18 add x29, sp, #0x50
- true: pos=23853 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=23854 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=23855 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=23856 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=23857 off=0x12dd2c mov w10, #-0xe9
- true: pos=23858 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #155
matched_before=8772
- true: pos=23880 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=33980 off=0x77d78 size=4
- resync: offset=0x77d78 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa7e0 -> x16=0x70f1cfa000 `
- unidbg_raw: `33980 0x77d78 4`

True-device skipped before resync:
- true: pos=23880 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=23881 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=23882 off=0x33888 add x16, x16, #0x8c8
- true: pos=23883 off=0x3388c br x17
- true: pos=23886 off=0x12de10 str w0, [x19, #8]
- true: pos=23887 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=23888 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=23889 off=0x12de1c cmp x8, x9
- true: pos=23890 off=0x12de20 b.ne #0x70f1babe78
- true: pos=23891 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=23892 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=23893 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #156
matched_before=8775
- true: pos=23900 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=33983 off=0x77d84 size=4
- resync: offset=0x77d84 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x73974c95c0 sp=0x70c6700eb0 mem_w=0x70c6700e90 -> sp=0x70c6700e90 `
- unidbg_raw: `33983 0x77d84 4`

True-device skipped before resync:
- true: pos=23900 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=23901 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=23902 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=23903 off=0x1c2ee8 cmp x0, #0
- true: pos=23904 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=23905 off=0x1c2ef0 mov x0, x19
- true: pos=23906 off=0x1c2ef4 bl #0x70f1ab10c0
- true: pos=23907 off=0x330c0 adrp x16, #0x70f1cfa000
- true: pos=23908 off=0x330c4 ldr x17, [x16, #0x4e8]
- true: pos=23909 off=0x330c8 add x16, x16, #0x4e8
- true: pos=23910 off=0x330cc br x17
- true: pos=23913 off=0x1c2ef8 cbnz x0, #0x70f1c40f0c
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #157
matched_before=8780
- true: pos=23922 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=33988 off=0x77d98 size=4
- resync: offset=0x77d98 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700eb0 mem_r=0x70c6700eb8 -> w8=0x0 `
- unidbg_raw: `33988 0x77d98 4`

True-device skipped before resync:
- true: pos=23922 off=0x12de7c ldr w8, [x0, #8]
- true: pos=23923 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=23924 off=0x12de84 add x9, x9, #0x7b8
- true: pos=23925 off=0x12de88 str x9, [x0]
- true: pos=23926 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=23927 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=23928 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=23929 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=23930 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=23931 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=23932 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=23933 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #158
matched_before=8917
- true: pos=24078 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34125 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e50 `
- unidbg_raw: `34125 0x12de08 4`

True-device skipped before resync:
- true: pos=24078 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24079 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24080 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24081 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24082 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24083 off=0x12dd18 add x29, sp, #0x50
- true: pos=24084 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24085 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24086 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24087 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24088 off=0x12dd2c mov w10, #-0xe9
- true: pos=24089 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #159
matched_before=8919
- true: pos=24111 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34127 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34127 0x87c2c 4`

True-device skipped before resync:
- true: pos=24111 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24112 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24113 off=0x33888 add x16, x16, #0x8c8
- true: pos=24114 off=0x3388c br x17
- true: pos=24117 off=0x12de10 str w0, [x19, #8]
- true: pos=24118 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24119 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24120 off=0x12de1c cmp x8, x9
- true: pos=24121 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24122 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24123 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24124 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #160
matched_before=8929
- true: pos=24138 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34137 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700eb0 mem_r=0x70c6700eb8 -> w8=0x0 `
- unidbg_raw: `34137 0x87c54 4`

True-device skipped before resync:
- true: pos=24138 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24139 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24140 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24141 off=0x12de88 str x9, [x0]
- true: pos=24142 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24143 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24144 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24145 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24146 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24147 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24148 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24149 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #161
matched_before=8967
- true: pos=24195 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34175 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34175 0x12de08 4`

True-device skipped before resync:
- true: pos=24195 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24196 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24197 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24198 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24199 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24200 off=0x12dd18 add x29, sp, #0x50
- true: pos=24201 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24202 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24203 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24204 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24205 off=0x12dd2c mov w10, #-0xe9
- true: pos=24206 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #162
matched_before=8969
- true: pos=24228 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34177 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34177 0x87c2c 4`

True-device skipped before resync:
- true: pos=24228 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24229 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24230 off=0x33888 add x16, x16, #0x8c8
- true: pos=24231 off=0x3388c br x17
- true: pos=24234 off=0x12de10 str w0, [x19, #8]
- true: pos=24235 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24236 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24237 off=0x12de1c cmp x8, x9
- true: pos=24238 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24239 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24240 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24241 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #163
matched_before=8979
- true: pos=24255 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34187 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34187 0x87c54 4`

True-device skipped before resync:
- true: pos=24255 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24256 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24257 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24258 off=0x12de88 str x9, [x0]
- true: pos=24259 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24260 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24261 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24262 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24263 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24264 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24265 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24266 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #164
matched_before=8993
- true: pos=24288 off=0x91f50 mov w0, wzr
- unidbg: seq=34201 off=0x93b70 size=4
- resync: offset=0x95fe4 true_ahead=2 unidbg_ahead=2
- true_raw: `[libmetasec_ml.so] 0x70f1b0ff50!0x91f50 mov w0, wzr; w0=0x37263c50 -> w0=0x0 `
- unidbg_raw: `34201 0x93b70 4`

True-device skipped before resync:
- true: pos=24288 off=0x91f50 mov w0, wzr
- true: pos=24289 off=0x91f54 ret

Unidbg skipped before resync:
- unidbg: seq=34201 off=0x93b70 size=4
- unidbg: seq=34202 off=0x93b74 size=4

## Divergence #165
matched_before=9006
- true: pos=24303 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34216 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `34216 0x12de08 4`

True-device skipped before resync:
- true: pos=24303 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24304 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24305 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24306 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24307 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24308 off=0x12dd18 add x29, sp, #0x50
- true: pos=24309 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24310 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24311 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24312 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24313 off=0x12dd2c mov w10, #-0xe9
- true: pos=24314 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #166
matched_before=9008
- true: pos=24336 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34218 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34218 0x87ca8 4`

True-device skipped before resync:
- true: pos=24336 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24337 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24338 off=0x33888 add x16, x16, #0x8c8
- true: pos=24339 off=0x3388c br x17
- true: pos=24342 off=0x12de10 str w0, [x19, #8]
- true: pos=24343 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24344 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24345 off=0x12de1c cmp x8, x9
- true: pos=24346 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24347 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24348 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24349 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #167
matched_before=9025
- true: pos=24370 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34235 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `34235 0x87cb8 4`

True-device skipped before resync:
- true: pos=24370 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24371 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24372 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24373 off=0x12de88 str x9, [x0]
- true: pos=24374 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24375 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24376 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24377 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24378 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24379 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24380 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24381 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #168
matched_before=9050
- true: pos=24414 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34260 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34260 0x12de08 4`

True-device skipped before resync:
- true: pos=24414 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24415 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24416 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24417 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24418 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24419 off=0x12dd18 add x29, sp, #0x50
- true: pos=24420 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24421 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24422 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24423 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24424 off=0x12dd2c mov w10, #-0xe9
- true: pos=24425 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #169
matched_before=9052
- true: pos=24447 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34262 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34262 0x87c2c 4`

True-device skipped before resync:
- true: pos=24447 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24448 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24449 off=0x33888 add x16, x16, #0x8c8
- true: pos=24450 off=0x3388c br x17
- true: pos=24453 off=0x12de10 str w0, [x19, #8]
- true: pos=24454 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24455 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24456 off=0x12de1c cmp x8, x9
- true: pos=24457 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24458 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24459 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24460 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #170
matched_before=9062
- true: pos=24474 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34272 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34272 0x87c54 4`

True-device skipped before resync:
- true: pos=24474 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24475 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24476 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24477 off=0x12de88 str x9, [x0]
- true: pos=24478 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24479 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24480 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24481 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24482 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24483 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24484 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24485 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #171
matched_before=9091
- true: pos=24522 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34301 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `34301 0x12de08 4`

True-device skipped before resync:
- true: pos=24522 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24523 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24524 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24525 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24526 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24527 off=0x12dd18 add x29, sp, #0x50
- true: pos=24528 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24529 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24530 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24531 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24532 off=0x12dd2c mov w10, #-0xe9
- true: pos=24533 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #172
matched_before=9093
- true: pos=24555 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34303 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34303 0x87ca8 4`

True-device skipped before resync:
- true: pos=24555 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24556 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24557 off=0x33888 add x16, x16, #0x8c8
- true: pos=24558 off=0x3388c br x17
- true: pos=24561 off=0x12de10 str w0, [x19, #8]
- true: pos=24562 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24563 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24564 off=0x12de1c cmp x8, x9
- true: pos=24565 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24566 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24567 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24568 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #173
matched_before=9110
- true: pos=24589 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34320 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `34320 0x87cb8 4`

True-device skipped before resync:
- true: pos=24589 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24590 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24591 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24592 off=0x12de88 str x9, [x0]
- true: pos=24593 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24594 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24595 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24596 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24597 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24598 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24599 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24600 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #174
matched_before=9140
- true: pos=24638 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34350 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ec0 sp=0x70c6700ec0 -> sp=0x70c6700e60 `
- unidbg_raw: `34350 0x12de08 4`

True-device skipped before resync:
- true: pos=24638 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24639 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24640 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24641 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24642 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24643 off=0x12dd18 add x29, sp, #0x50
- true: pos=24644 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24645 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24646 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24647 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24648 off=0x12dd2c mov w10, #-0xe9
- true: pos=24649 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #175
matched_before=9142
- true: pos=24671 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34352 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34352 0x87ca8 4`

True-device skipped before resync:
- true: pos=24671 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24672 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24673 off=0x33888 add x16, x16, #0x8c8
- true: pos=24674 off=0x3388c br x17
- true: pos=24677 off=0x12de10 str w0, [x19, #8]
- true: pos=24678 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24679 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24680 off=0x12de1c cmp x8, x9
- true: pos=24681 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24682 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24683 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24684 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #176
matched_before=9159
- true: pos=24705 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34369 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700ec0 mem_r=0x70c6700ec8 -> w8=0x0 `
- unidbg_raw: `34369 0x87cb8 4`

True-device skipped before resync:
- true: pos=24705 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24706 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24707 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24708 off=0x12de88 str x9, [x0]
- true: pos=24709 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24710 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24711 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24712 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24713 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24714 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24715 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24716 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #177
matched_before=9266
- true: pos=24831 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34476 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e50 `
- unidbg_raw: `34476 0x12de08 4`

True-device skipped before resync:
- true: pos=24831 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24832 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24833 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24834 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24835 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24836 off=0x12dd18 add x29, sp, #0x50
- true: pos=24837 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24838 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24839 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24840 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24841 off=0x12dd2c mov w10, #-0xe9
- true: pos=24842 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #178
matched_before=9268
- true: pos=24864 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34478 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34478 0x87c2c 4`

True-device skipped before resync:
- true: pos=24864 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24865 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24866 off=0x33888 add x16, x16, #0x8c8
- true: pos=24867 off=0x3388c br x17
- true: pos=24870 off=0x12de10 str w0, [x19, #8]
- true: pos=24871 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24872 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24873 off=0x12de1c cmp x8, x9
- true: pos=24874 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24875 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24876 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24877 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #179
matched_before=9278
- true: pos=24891 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34488 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700eb0 mem_r=0x70c6700eb8 -> w8=0x0 `
- unidbg_raw: `34488 0x87c54 4`

True-device skipped before resync:
- true: pos=24891 off=0x12de7c ldr w8, [x0, #8]
- true: pos=24892 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=24893 off=0x12de84 add x9, x9, #0x7b8
- true: pos=24894 off=0x12de88 str x9, [x0]
- true: pos=24895 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=24896 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=24897 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=24898 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=24899 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=24900 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=24901 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=24902 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #180
matched_before=9316
- true: pos=24948 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34526 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34526 0x12de08 4`

True-device skipped before resync:
- true: pos=24948 off=0x12dd04 sub sp, sp, #0x60
- true: pos=24949 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=24950 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=24951 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=24952 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=24953 off=0x12dd18 add x29, sp, #0x50
- true: pos=24954 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=24955 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=24956 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=24957 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=24958 off=0x12dd2c mov w10, #-0xe9
- true: pos=24959 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #181
matched_before=9318
- true: pos=24981 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34528 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34528 0x87c2c 4`

True-device skipped before resync:
- true: pos=24981 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=24982 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=24983 off=0x33888 add x16, x16, #0x8c8
- true: pos=24984 off=0x3388c br x17
- true: pos=24987 off=0x12de10 str w0, [x19, #8]
- true: pos=24988 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=24989 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=24990 off=0x12de1c cmp x8, x9
- true: pos=24991 off=0x12de20 b.ne #0x70f1babe78
- true: pos=24992 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=24993 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=24994 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #182
matched_before=9328
- true: pos=25008 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34538 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34538 0x87c54 4`

True-device skipped before resync:
- true: pos=25008 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25009 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25010 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25011 off=0x12de88 str x9, [x0]
- true: pos=25012 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25013 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25014 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25015 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25016 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25017 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25018 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25019 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #183
matched_before=9342
- true: pos=25041 off=0x9285c mov w0, wzr
- unidbg: seq=34552 off=0x91f50 size=4
- resync: offset=0x95fe4 true_ahead=2 unidbg_ahead=2
- true_raw: `[libmetasec_ml.so] 0x70f1b1085c!0x9285c mov w0, wzr; w0=0x77300170 -> w0=0x0 `
- unidbg_raw: `34552 0x91f50 4`

True-device skipped before resync:
- true: pos=25041 off=0x9285c mov w0, wzr
- true: pos=25042 off=0x92860 ret

Unidbg skipped before resync:
- unidbg: seq=34552 off=0x91f50 size=4
- unidbg: seq=34553 off=0x91f54 size=4

## Divergence #184
matched_before=9355
- true: pos=25056 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34567 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `34567 0x12de08 4`

True-device skipped before resync:
- true: pos=25056 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25057 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25058 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25059 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25060 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25061 off=0x12dd18 add x29, sp, #0x50
- true: pos=25062 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25063 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25064 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25065 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25066 off=0x12dd2c mov w10, #-0xe9
- true: pos=25067 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #185
matched_before=9357
- true: pos=25089 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34569 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34569 0x87ca8 4`

True-device skipped before resync:
- true: pos=25089 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25090 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25091 off=0x33888 add x16, x16, #0x8c8
- true: pos=25092 off=0x3388c br x17
- true: pos=25095 off=0x12de10 str w0, [x19, #8]
- true: pos=25096 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25097 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25098 off=0x12de1c cmp x8, x9
- true: pos=25099 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25100 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25101 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25102 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #186
matched_before=9374
- true: pos=25123 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34586 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `34586 0x87cb8 4`

True-device skipped before resync:
- true: pos=25123 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25124 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25125 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25126 off=0x12de88 str x9, [x0]
- true: pos=25127 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25128 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25129 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25130 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25131 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25132 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25133 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25134 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #187
matched_before=9399
- true: pos=25167 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34611 off=0x12dd38 size=4
- resync: offset=0x12dd38 true_ahead=13 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34611 0x12dd38 4`

True-device skipped before resync:
- true: pos=25167 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25168 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25169 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25170 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25171 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25172 off=0x12dd18 add x29, sp, #0x50
- true: pos=25173 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25174 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25175 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25176 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25177 off=0x12dd2c mov w10, #-0xe9
- true: pos=25178 off=0x12dd30 str x8, [sp, #0x18]
- ... 1 more

Unidbg skipped before resync:
- none

## Divergence #188
matched_before=9408
- true: pos=25189 off=0x12dd5c adrp x24, #0x70f1d41000
- unidbg: seq=34620 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=9 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd5c!0x12dd5c adrp x24, #0x70f1d41000; x24=0x70f1b0679c -> x24=0x70f1d41000 `
- unidbg_raw: `34620 0x12de08 4`

True-device skipped before resync:
- true: pos=25189 off=0x12dd5c adrp x24, #0x70f1d41000
- true: pos=25190 off=0x12dd60 ldr x23, [x24, #0x438]
- true: pos=25191 off=0x12dd64 adrp x22, #0x70f1cde000
- true: pos=25192 off=0x12dd68 add x22, x22, #0x5b8
- true: pos=25193 off=0x12dd6c cbnz x23, #0x70f1babdb4
- true: pos=25194 off=0x12ddb4 ldr x8, [x19, #0x10]
- true: pos=25195 off=0x12ddb8 ubfx x24, x8, #4, #8
- true: pos=25196 off=0x12ddbc ldr x8, [x23, x24, lsl #3]
- true: pos=25197 off=0x12ddc0 cbnz x8, #0x70f1babe08

Unidbg skipped before resync:
- none

## Divergence #189
matched_before=9410
- true: pos=25200 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34622 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34622 0x87c2c 4`

True-device skipped before resync:
- true: pos=25200 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25201 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25202 off=0x33888 add x16, x16, #0x8c8
- true: pos=25203 off=0x3388c br x17
- true: pos=25206 off=0x12de10 str w0, [x19, #8]
- true: pos=25207 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25208 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25209 off=0x12de1c cmp x8, x9
- true: pos=25210 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25211 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25212 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25213 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #190
matched_before=9420
- true: pos=25227 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34632 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34632 0x87c54 4`

True-device skipped before resync:
- true: pos=25227 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25228 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25229 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25230 off=0x12de88 str x9, [x0]
- true: pos=25231 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25232 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25233 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25234 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25235 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25236 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25237 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25238 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #191
matched_before=9449
- true: pos=25275 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34661 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `34661 0x12de08 4`

True-device skipped before resync:
- true: pos=25275 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25276 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25277 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25278 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25279 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25280 off=0x12dd18 add x29, sp, #0x50
- true: pos=25281 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25282 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25283 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25284 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25285 off=0x12dd2c mov w10, #-0xe9
- true: pos=25286 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #192
matched_before=9451
- true: pos=25308 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34663 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34663 0x87ca8 4`

True-device skipped before resync:
- true: pos=25308 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25309 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25310 off=0x33888 add x16, x16, #0x8c8
- true: pos=25311 off=0x3388c br x17
- true: pos=25314 off=0x12de10 str w0, [x19, #8]
- true: pos=25315 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25316 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25317 off=0x12de1c cmp x8, x9
- true: pos=25318 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25319 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25320 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25321 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #193
matched_before=9468
- true: pos=25342 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34680 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `34680 0x87cb8 4`

True-device skipped before resync:
- true: pos=25342 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25343 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25344 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25345 off=0x12de88 str x9, [x0]
- true: pos=25346 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25347 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25348 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25349 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25350 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25351 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25352 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25353 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #194
matched_before=9498
- true: pos=25391 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34710 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ec0 sp=0x70c6700ec0 -> sp=0x70c6700e60 `
- unidbg_raw: `34710 0x12de08 4`

True-device skipped before resync:
- true: pos=25391 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25392 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25393 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25394 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25395 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25396 off=0x12dd18 add x29, sp, #0x50
- true: pos=25397 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25398 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25399 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25400 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25401 off=0x12dd2c mov w10, #-0xe9
- true: pos=25402 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #195
matched_before=9500
- true: pos=25424 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34712 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34712 0x87ca8 4`

True-device skipped before resync:
- true: pos=25424 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25425 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25426 off=0x33888 add x16, x16, #0x8c8
- true: pos=25427 off=0x3388c br x17
- true: pos=25430 off=0x12de10 str w0, [x19, #8]
- true: pos=25431 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25432 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25433 off=0x12de1c cmp x8, x9
- true: pos=25434 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25435 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25436 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25437 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #196
matched_before=9517
- true: pos=25458 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34729 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700ec0 mem_r=0x70c6700ec8 -> w8=0x0 `
- unidbg_raw: `34729 0x87cb8 4`

True-device skipped before resync:
- true: pos=25458 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25459 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25460 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25461 off=0x12de88 str x9, [x0]
- true: pos=25462 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25463 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25464 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25465 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25466 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25467 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25468 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25469 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #197
matched_before=9624
- true: pos=25584 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34836 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e50 `
- unidbg_raw: `34836 0x12de08 4`

True-device skipped before resync:
- true: pos=25584 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25585 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25586 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25587 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25588 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25589 off=0x12dd18 add x29, sp, #0x50
- true: pos=25590 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25591 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25592 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25593 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25594 off=0x12dd2c mov w10, #-0xe9
- true: pos=25595 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #198
matched_before=9626
- true: pos=25617 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34838 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34838 0x87c2c 4`

True-device skipped before resync:
- true: pos=25617 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25618 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25619 off=0x33888 add x16, x16, #0x8c8
- true: pos=25620 off=0x3388c br x17
- true: pos=25623 off=0x12de10 str w0, [x19, #8]
- true: pos=25624 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25625 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25626 off=0x12de1c cmp x8, x9
- true: pos=25627 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25628 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25629 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25630 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #199
matched_before=9636
- true: pos=25644 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34848 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700eb0 mem_r=0x70c6700eb8 -> w8=0x0 `
- unidbg_raw: `34848 0x87c54 4`

True-device skipped before resync:
- true: pos=25644 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25645 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25646 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25647 off=0x12de88 str x9, [x0]
- true: pos=25648 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25649 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25650 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25651 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25652 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25653 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25654 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25655 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #200
matched_before=9674
- true: pos=25701 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34886 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34886 0x12de08 4`

True-device skipped before resync:
- true: pos=25701 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25702 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25703 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25704 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25705 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25706 off=0x12dd18 add x29, sp, #0x50
- true: pos=25707 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25708 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25709 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25710 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25711 off=0x12dd2c mov w10, #-0xe9
- true: pos=25712 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #201
matched_before=9676
- true: pos=25734 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34888 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34888 0x87c2c 4`

True-device skipped before resync:
- true: pos=25734 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25735 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25736 off=0x33888 add x16, x16, #0x8c8
- true: pos=25737 off=0x3388c br x17
- true: pos=25740 off=0x12de10 str w0, [x19, #8]
- true: pos=25741 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25742 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25743 off=0x12de1c cmp x8, x9
- true: pos=25744 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25745 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25746 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25747 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #202
matched_before=9686
- true: pos=25761 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34898 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34898 0x87c54 4`

True-device skipped before resync:
- true: pos=25761 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25762 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25763 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25764 off=0x12de88 str x9, [x0]
- true: pos=25765 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25766 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25767 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25768 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25769 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25770 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25771 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25772 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #203
matched_before=9700
- true: pos=25794 off=0x93040 mov w0, wzr
- unidbg: seq=34912 off=0xbb398 size=4
- resync: offset=0x95fe4 true_ahead=2 unidbg_ahead=2
- true_raw: `[libmetasec_ml.so] 0x70f1b11040!0x93040 mov w0, wzr; w0=0x77300250 -> w0=0x0 `
- unidbg_raw: `34912 0xbb398 4`

True-device skipped before resync:
- true: pos=25794 off=0x93040 mov w0, wzr
- true: pos=25795 off=0x93044 ret

Unidbg skipped before resync:
- unidbg: seq=34912 off=0xbb398 size=4
- unidbg: seq=34913 off=0xbb39c size=4

## Divergence #204
matched_before=9713
- true: pos=25809 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34927 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `34927 0x12de08 4`

True-device skipped before resync:
- true: pos=25809 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25810 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25811 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25812 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25813 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25814 off=0x12dd18 add x29, sp, #0x50
- true: pos=25815 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25816 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25817 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25818 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25819 off=0x12dd2c mov w10, #-0xe9
- true: pos=25820 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #205
matched_before=9715
- true: pos=25842 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34929 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34929 0x87ca8 4`

True-device skipped before resync:
- true: pos=25842 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25843 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25844 off=0x33888 add x16, x16, #0x8c8
- true: pos=25845 off=0x3388c br x17
- true: pos=25848 off=0x12de10 str w0, [x19, #8]
- true: pos=25849 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25850 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25851 off=0x12de1c cmp x8, x9
- true: pos=25852 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25853 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25854 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25855 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #206
matched_before=9732
- true: pos=25876 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34946 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `34946 0x87cb8 4`

True-device skipped before resync:
- true: pos=25876 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25877 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25878 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25879 off=0x12de88 str x9, [x0]
- true: pos=25880 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25881 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25882 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25883 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25884 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25885 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25886 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25887 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #207
matched_before=9757
- true: pos=25920 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34971 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `34971 0x12de08 4`

True-device skipped before resync:
- true: pos=25920 off=0x12dd04 sub sp, sp, #0x60
- true: pos=25921 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=25922 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=25923 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=25924 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=25925 off=0x12dd18 add x29, sp, #0x50
- true: pos=25926 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=25927 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=25928 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=25929 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=25930 off=0x12dd2c mov w10, #-0xe9
- true: pos=25931 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #208
matched_before=9759
- true: pos=25953 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34973 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `34973 0x87c2c 4`

True-device skipped before resync:
- true: pos=25953 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=25954 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=25955 off=0x33888 add x16, x16, #0x8c8
- true: pos=25956 off=0x3388c br x17
- true: pos=25959 off=0x12de10 str w0, [x19, #8]
- true: pos=25960 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=25961 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=25962 off=0x12de1c cmp x8, x9
- true: pos=25963 off=0x12de20 b.ne #0x70f1babe78
- true: pos=25964 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=25965 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=25966 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #209
matched_before=9769
- true: pos=25980 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34983 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700e50 mem_r=0x70c6700e58 -> w8=0x0 `
- unidbg_raw: `34983 0x87c54 4`

True-device skipped before resync:
- true: pos=25980 off=0x12de7c ldr w8, [x0, #8]
- true: pos=25981 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=25982 off=0x12de84 add x9, x9, #0x7b8
- true: pos=25983 off=0x12de88 str x9, [x0]
- true: pos=25984 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=25985 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=25986 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=25987 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=25988 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=25989 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=25990 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=25991 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #210
matched_before=9798
- true: pos=26028 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35012 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e60 sp=0x70c6700e60 -> sp=0x70c6700e00 `
- unidbg_raw: `35012 0x12de08 4`

True-device skipped before resync:
- true: pos=26028 off=0x12dd04 sub sp, sp, #0x60
- true: pos=26029 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=26030 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=26031 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=26032 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=26033 off=0x12dd18 add x29, sp, #0x50
- true: pos=26034 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=26035 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=26036 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=26037 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=26038 off=0x12dd2c mov w10, #-0xe9
- true: pos=26039 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #211
matched_before=9800
- true: pos=26061 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35014 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `35014 0x87ca8 4`

True-device skipped before resync:
- true: pos=26061 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=26062 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=26063 off=0x33888 add x16, x16, #0x8c8
- true: pos=26064 off=0x3388c br x17
- true: pos=26067 off=0x12de10 str w0, [x19, #8]
- true: pos=26068 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=26069 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=26070 off=0x12de1c cmp x8, x9
- true: pos=26071 off=0x12de20 b.ne #0x70f1babe78
- true: pos=26072 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=26073 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=26074 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #212
matched_before=9817
- true: pos=26095 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35031 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x2 x0=0x70c6700e60 mem_r=0x70c6700e68 -> w8=0x0 `
- unidbg_raw: `35031 0x87cb8 4`

True-device skipped before resync:
- true: pos=26095 off=0x12de7c ldr w8, [x0, #8]
- true: pos=26096 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=26097 off=0x12de84 add x9, x9, #0x7b8
- true: pos=26098 off=0x12de88 str x9, [x0]
- true: pos=26099 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=26100 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=26101 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=26102 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=26103 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=26104 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=26105 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=26106 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #213
matched_before=9847
- true: pos=26144 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35061 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700ec0 sp=0x70c6700ec0 -> sp=0x70c6700e60 `
- unidbg_raw: `35061 0x12de08 4`

True-device skipped before resync:
- true: pos=26144 off=0x12dd04 sub sp, sp, #0x60
- true: pos=26145 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=26146 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=26147 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=26148 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=26149 off=0x12dd18 add x29, sp, #0x50
- true: pos=26150 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=26151 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=26152 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=26153 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=26154 off=0x12dd2c mov w10, #-0xe9
- true: pos=26155 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #214
matched_before=9849
- true: pos=26177 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35063 off=0x87ca8 size=4
- resync: offset=0x87ca8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `35063 0x87ca8 4`

True-device skipped before resync:
- true: pos=26177 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=26178 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=26179 off=0x33888 add x16, x16, #0x8c8
- true: pos=26180 off=0x3388c br x17
- true: pos=26183 off=0x12de10 str w0, [x19, #8]
- true: pos=26184 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=26185 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=26186 off=0x12de1c cmp x8, x9
- true: pos=26187 off=0x12de20 b.ne #0x70f1babe78
- true: pos=26188 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=26189 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=26190 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #215
matched_before=9866
- true: pos=26211 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35080 off=0x87cb8 size=4
- resync: offset=0x87cb8 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700ec0 mem_r=0x70c6700ec8 -> w8=0x0 `
- unidbg_raw: `35080 0x87cb8 4`

True-device skipped before resync:
- true: pos=26211 off=0x12de7c ldr w8, [x0, #8]
- true: pos=26212 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=26213 off=0x12de84 add x9, x9, #0x7b8
- true: pos=26214 off=0x12de88 str x9, [x0]
- true: pos=26215 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=26216 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=26217 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=26218 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=26219 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=26220 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=26221 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=26222 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #216
matched_before=9973
- true: pos=26337 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35187 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700eb0 sp=0x70c6700eb0 -> sp=0x70c6700e50 `
- unidbg_raw: `35187 0x12de08 4`

True-device skipped before resync:
- true: pos=26337 off=0x12dd04 sub sp, sp, #0x60
- true: pos=26338 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=26339 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=26340 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=26341 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=26342 off=0x12dd18 add x29, sp, #0x50
- true: pos=26343 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=26344 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=26345 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=26346 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=26347 off=0x12dd2c mov w10, #-0xe9
- true: pos=26348 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #217
matched_before=9975
- true: pos=26370 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35189 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `35189 0x87c2c 4`

True-device skipped before resync:
- true: pos=26370 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=26371 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=26372 off=0x33888 add x16, x16, #0x8c8
- true: pos=26373 off=0x3388c br x17
- true: pos=26376 off=0x12de10 str w0, [x19, #8]
- true: pos=26377 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=26378 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=26379 off=0x12de1c cmp x8, x9
- true: pos=26380 off=0x12de20 b.ne #0x70f1babe78
- true: pos=26381 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=26382 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=26383 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #218
matched_before=9985
- true: pos=26397 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35199 off=0x87c54 size=4
- resync: offset=0x87c54 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472fff30 x0=0x70c6700eb0 mem_r=0x70c6700eb8 -> w8=0x0 `
- unidbg_raw: `35199 0x87c54 4`

True-device skipped before resync:
- true: pos=26397 off=0x12de7c ldr w8, [x0, #8]
- true: pos=26398 off=0x12de80 adrp x9, #0x70f1cee000
- true: pos=26399 off=0x12de84 add x9, x9, #0x7b8
- true: pos=26400 off=0x12de88 str x9, [x0]
- true: pos=26401 off=0x12de8c cbz w8, #0x70f1babe94
- true: pos=26402 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=26403 off=0x12de98 adrp x9, #0x70f1d41000
- true: pos=26404 off=0x12de9c ldr x9, [x9, #0x438]
- true: pos=26405 off=0x12dea0 ubfx x8, x8, #4, #8
- true: pos=26406 off=0x12dea4 ldr x8, [x9, x8, lsl #3]
- true: pos=26407 off=0x12dea8 cbz x8, #0x70f1babe90
- true: pos=26408 off=0x12deac add x0, x8, #8
- ... 5 more

Unidbg skipped before resync:
- none

## Divergence #219
matched_before=10023
- true: pos=26454 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35237 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700e50 sp=0x70c6700e50 -> sp=0x70c6700df0 `
- unidbg_raw: `35237 0x12de08 4`

True-device skipped before resync:
- true: pos=26454 off=0x12dd04 sub sp, sp, #0x60
- true: pos=26455 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=26456 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=26457 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=26458 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=26459 off=0x12dd18 add x29, sp, #0x50
- true: pos=26460 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=26461 off=0x12dd20 ldr x8, [x21, #0x28]
- true: pos=26462 off=0x12dd24 adrp x9, #0x70f1cee000
- true: pos=26463 off=0x12dd28 add x9, x9, #0x7b8
- true: pos=26464 off=0x12dd2c mov w10, #-0xe9
- true: pos=26465 off=0x12dd30 str x8, [sp, #0x18]
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #220
matched_before=10025
- true: pos=26487 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35239 off=0x87c2c size=4
- resync: offset=0x87c2c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa758 -> x16=0x70f1cfa000 `
- unidbg_raw: `35239 0x87c2c 4`

True-device skipped before resync:
- true: pos=26487 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=26488 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=26489 off=0x33888 add x16, x16, #0x8c8
- true: pos=26490 off=0x3388c br x17
- true: pos=26493 off=0x12de10 str w0, [x19, #8]
- true: pos=26494 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=26495 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=26496 off=0x12de1c cmp x8, x9
- true: pos=26497 off=0x12de20 b.ne #0x70f1babe78
- true: pos=26498 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=26499 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=26500 off=0x12de2c ldp x22, x21, [sp, #0x30]
- ... 3 more

Unidbg skipped before resync:
- none


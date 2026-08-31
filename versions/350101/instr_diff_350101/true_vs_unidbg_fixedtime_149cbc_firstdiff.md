# MetaSec instruction sequence diff

gum=dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log
seq=unidbg/unidbg-android/target/sign6_350101_true_req01_instrseq_fixedtime_200k_20260831.seq
sync_offset=0x149cbc
gum_skipped_before_sync=0
seq_skipped_before_sync=24379
matched_after_sync=112
diffs_reported=8
stopped=diff_limit

## Matched context before divergence
- -20 off=0x49114 true_pos=267 seq_pos=24472 true=ret
- -19 off=0x149d54 true_pos=268 seq_pos=24473 true=add x8, sp, #0x128
- -18 off=0x149d58 true_pos=269 seq_pos=24474 true=bl #0x70f1b9e000
- -17 off=0x120000 true_pos=270 seq_pos=24475 true=sub sp, sp, #0x40
- -16 off=0x120004 true_pos=271 seq_pos=24476 true=stp x20, x19, [sp, #0x20]
- -15 off=0x120008 true_pos=272 seq_pos=24477 true=stp x29, x30, [sp, #0x30]
- -14 off=0x12000c true_pos=273 seq_pos=24478 true=add x29, sp, #0x30
- -13 off=0x120010 true_pos=274 seq_pos=24479 true=mov w0, #0x28
- -12 off=0x120014 true_pos=275 seq_pos=24480 true=mov x19, x8
- -11 off=0x120018 true_pos=276 seq_pos=24481 true=bl #0x70f1c40edc
- -10 off=0x12001c true_pos=294 seq_pos=24482 true=adrp x8, #0x70f1ad5000
- -09 off=0x120020 true_pos=295 seq_pos=24483 true=add x8, x8, #0x9f4
- -08 off=0x120024 true_pos=296 seq_pos=24484 true=adrp x9, #0x70f1ad5000
- -07 off=0x120028 true_pos=297 seq_pos=24485 true=add x9, x9, #0xa5c
- -06 off=0x12002c true_pos=298 seq_pos=24486 true=dup v0.2d, x8
- -05 off=0x120030 true_pos=299 seq_pos=24487 true=mov x1, sp
- -04 off=0x120034 true_pos=300 seq_pos=24488 true=mov x20, x0
- -03 off=0x120038 true_pos=301 seq_pos=24489 true=str q0, [sp]
- -02 off=0x12003c true_pos=302 seq_pos=24490 true=str x9, [sp, #0x10]
- -01 off=0x120040 true_pos=303 seq_pos=24491 true=bl #0x70f1b9dc08

## Divergence #1
matched_before=45
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24425 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701168 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `24425 0x12001c 4`

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
- true: pos=60 off=0x1c2f0c ldp x29, x30, [sp, #0x10]
- true: pos=61 off=0x1c2f10 ldr x19, [sp], #0x20
- true: pos=62 off=0x1c2f14 ret

Unidbg skipped before resync:
- none

## Divergence #2
matched_before=55
- true: pos=73 off=0x11fc08 adrp x8, #0x70f1ced000
- unidbg: seq=24435 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `24435 0x120044 4`

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
- true: pos=85 off=0x10e7b4 stp x29, x30, [sp, #0x20]
- true: pos=86 off=0x10e7b8 add x29, sp, #0x20
- true: pos=87 off=0x10e7bc mov x20, x0
- true: pos=88 off=0x10e7c0 mov w0, #0x28
- true: pos=89 off=0x10e7c4 mov x19, x1
- true: pos=90 off=0x10e7c8 bl #0x70f1b8c91c
- true: pos=91 off=0x10e91c b #0x70f1ab10c0
- true: pos=92 off=0x330c0 adrp x16, #0x70f1cfa000
- ... 49 more

Unidbg skipped before resync:
- none

## Divergence #3
matched_before=74
- true: pos=165 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=24454 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `24454 0x12de08 4`

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
- true: pos=177 off=0x12dd34 adrp x8, #0x70f1d41000
- true: pos=178 off=0x12dd38 str x9, [x0]
- true: pos=179 off=0x12dd3c str w10, [x0, #8]
- true: pos=180 off=0x12dd40 str x1, [x0, #0x10]
- true: pos=181 off=0x12dd44 add x8, x8, #0x430
- true: pos=182 off=0x12dd48 ldarb w8, [x8]
- true: pos=183 off=0x12dd4c adrp x20, #0x70f1d41000
- true: pos=184 off=0x12dd50 mov x19, x0
- ... 11 more

Unidbg skipped before resync:
- none

## Divergence #4
matched_before=76
- true: pos=198 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=24456 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x754035ff10 -> x16=0x70f1cfa000 `
- unidbg_raw: `24456 0x490d4 4`

True-device skipped before resync:
- true: pos=198 off=0x33880 adrp x16, #0x70f1cfa000
- true: pos=199 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=200 off=0x33888 add x16, x16, #0x8c8
- true: pos=201 off=0x3388c br x17
- true: pos=204 off=0x12de10 str w0, [x19, #8]
- true: pos=205 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=206 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=207 off=0x12de1c cmp x8, x9
- true: pos=208 off=0x12de20 b.ne #0x70f1babe78
- true: pos=209 off=0x12de24 ldp x29, x30, [sp, #0x50]
- true: pos=210 off=0x12de28 ldp x20, x19, [sp, #0x40]
- true: pos=211 off=0x12de2c ldp x22, x21, [sp, #0x30]
- true: pos=212 off=0x12de30 ldp x24, x23, [sp, #0x20]
- true: pos=213 off=0x12de34 add sp, sp, #0x60
- true: pos=214 off=0x12de38 ret

Unidbg skipped before resync:
- none

## Divergence #5
matched_before=79
- true: pos=218 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24459 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x734751b090 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `24459 0x490e0 4`

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
- true: pos=232 off=0x1c2f0c ldp x29, x30, [sp, #0x10]
- true: pos=233 off=0x1c2f10 ldr x19, [sp], #0x20
- true: pos=234 off=0x1c2f14 ret

Unidbg skipped before resync:
- none

## Divergence #6
matched_before=84
- true: pos=240 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=24464 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `24464 0x490f4 4`

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
- true: pos=252 off=0x12deb0 b #0x70f1ab15a0
- true: pos=253 off=0x335a0 adrp x16, #0x70f1cfa000
- true: pos=254 off=0x335a4 ldr x17, [x16, #0x758]
- true: pos=255 off=0x335a8 add x16, x16, #0x758
- true: pos=256 off=0x335ac br x17

Unidbg skipped before resync:
- none

## Divergence #7
matched_before=102
- true: pos=277 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=24482 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701158 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `24482 0x12001c 4`

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
- true: pos=291 off=0x1c2f0c ldp x29, x30, [sp, #0x10]
- true: pos=292 off=0x1c2f10 ldr x19, [sp], #0x20
- true: pos=293 off=0x1c2f14 ret

Unidbg skipped before resync:
- none

## Divergence #8
matched_before=112
- true: pos=304 off=0x11fc08 adrp x8, #0x70f1ced000
- unidbg: seq=24492 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `24492 0x120044 4`

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
- true: pos=316 off=0x10e7b4 stp x29, x30, [sp, #0x20]
- true: pos=317 off=0x10e7b8 add x29, sp, #0x20
- true: pos=318 off=0x10e7bc mov x20, x0
- true: pos=319 off=0x10e7c0 mov w0, #0x28
- true: pos=320 off=0x10e7c4 mov x19, x1
- true: pos=321 off=0x10e7c8 bl #0x70f1b8c91c
- true: pos=322 off=0x10e91c b #0x70f1ab10c0
- true: pos=323 off=0x330c0 adrp x16, #0x70f1cfa000
- ... 49 more

Unidbg skipped before resync:
- none


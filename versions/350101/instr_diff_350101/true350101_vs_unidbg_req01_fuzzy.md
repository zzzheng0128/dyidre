# MetaSec instruction sequence diff

gum=dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350101_full_once.log
seq=unidbg/unidbg-android/target/sign6_350101_rootfs_instrseq_unicorn2_20260831_143310.seq
sync_offset=0x149cbc
gum_skipped_before_sync=0
seq_skipped_before_sync=34815
matched_after_sync=3985
diffs_reported=61
stopped=no_resync

## Matched context before divergence
- -12 off=0x10be70 true_pos=9960 seq_pos=42392 true=ldr x10, [x8, #0x10]
- -11 off=0x10be74 true_pos=9961 seq_pos=42393 true=ldrb w10, [x10, x0]
- -10 off=0x10be78 true_pos=9962 seq_pos=42394 true=cmp w10, w1, uxtb
- -09 off=0x10be7c true_pos=9963 seq_pos=42395 true=b.eq #0x70f1b89e8c
- -08 off=0x10be80 true_pos=9964 seq_pos=42396 true=add x0, x0, #1
- -07 off=0x10be84 true_pos=9965 seq_pos=42397 true=b #0x70f1b89e68
- -06 off=0x10be68 true_pos=9966 seq_pos=42398 true=cmp x0, x9
- -05 off=0x10be6c true_pos=9967 seq_pos=42399 true=b.ge #0x70f1b89e88
- -04 off=0x10be70 true_pos=9968 seq_pos=42400 true=ldr x10, [x8, #0x10]
- -03 off=0x10be74 true_pos=9969 seq_pos=42401 true=ldrb w10, [x10, x0]
- -02 off=0x10be78 true_pos=9970 seq_pos=42402 true=cmp w10, w1, uxtb
- -01 off=0x10be7c true_pos=9971 seq_pos=42403 true=b.eq #0x70f1b89e8c

## Divergence #1
matched_before=45
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34861 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701168 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `34861 0x12001c 4`

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
- unidbg: seq=34871 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `34871 0x120044 4`

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
- unidbg: seq=34890 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `34890 0x12de08 4`

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
- ... 19 more

Unidbg skipped before resync:
- none

## Divergence #4
matched_before=76
- true: pos=198 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34892 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x754035ff10 -> x16=0x70f1cfa000 `
- unidbg_raw: `34892 0x490d4 4`

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
- ... 3 more

Unidbg skipped before resync:
- none

## Divergence #5
matched_before=79
- true: pos=218 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34895 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x734751b090 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `34895 0x490e0 4`

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

## Divergence #6
matched_before=84
- true: pos=240 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34900 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `34900 0x490f4 4`

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

## Divergence #7
matched_before=102
- true: pos=277 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34918 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x70c6701158 sp=0x70c6700ff0 mem_w=0x70c6700fd0 -> sp=0x70c6700fd0 `
- unidbg_raw: `34918 0x12001c 4`

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

## Divergence #8
matched_before=112
- true: pos=304 off=0x11fc08 adrp x8, #0x70f1ced000
- unidbg: seq=34928 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9dc08!0x11fc08 adrp x8, #0x70f1ced000; x8=0x70f1ad59f4 -> x8=0x70f1ced000 `
- unidbg_raw: `34928 0x120044 4`

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

## Divergence #9
matched_before=131
- true: pos=396 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34947 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `34947 0x12de08 4`

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

## Divergence #10
matched_before=133
- true: pos=429 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=34949 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa4e8 -> x16=0x70f1cfa000 `
- unidbg_raw: `34949 0x490d4 4`

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

## Divergence #11
matched_before=136
- true: pos=449 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34952 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7347331cd0 sp=0x70c6700fe0 mem_w=0x70c6700fc0 -> sp=0x70c6700fc0 `
- unidbg_raw: `34952 0x490e0 4`

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

## Divergence #12
matched_before=141
- true: pos=471 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34957 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `34957 0x490f4 4`

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

## Divergence #13
matched_before=151
- true: pos=500 off=0x4303c stp x20, x19, [sp, #-0x20]!
- unidbg: seq=34967 off=0x149d60 size=4
- resync: offset=0x149d60 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac103c!0x4303c stp x20, x19, [sp, #-0x20]!; x20=0x70c6701530 x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `34967 0x149d60 4`

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

## Divergence #14
matched_before=156
- true: pos=517 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=34972 off=0x149d6c size=4
- resync: offset=0x149d6c true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x72f7298c90 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `34972 0x149d6c 4`

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

## Divergence #15
matched_before=183
- true: pos=593 off=0x11fe50 add x0, x0, #0x20
- unidbg: seq=34999 off=0x10a67c size=4
- resync: offset=0x10a67c true_ahead=313 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b9de50!0x11fe50 add x0, x0, #0x20; x0=0x72f7298c98 x0=0x72f7298c98 -> x0=0x72f7298cb8 `
- unidbg_raw: `34999 0x10a67c 4`

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

## Divergence #16
matched_before=188
- true: pos=911 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=35004 off=0x10a67c size=4
- resync: offset=0x10a694 true_ahead=46 unidbg_ahead=4
- true_raw: `[libmetasec_ml.so] 0x70f1b8d448!0x10f448 add x8, x23, #0x10; x8=0x1f x23=0x734728acd0 -> x8=0x734728ace0 `
- unidbg_raw: `35004 0x10a67c 4`

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
- unidbg: seq=35004 off=0x10a67c size=4
- unidbg: seq=35005 off=0x10a680 size=4
- unidbg: seq=35006 off=0x10a68c size=4
- unidbg: seq=35007 off=0x10a690 size=4

## Divergence #17
matched_before=189
- true: pos=958 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=35009 off=0x10e8b8 size=4
- resync: offset=0x10e8b8 true_ahead=444 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d448!0x10f448 add x8, x23, #0x10; x8=0x20 x23=0x73472833d0 -> x8=0x73472833e0 `
- unidbg_raw: `35009 0x10e8b8 4`

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

## Divergence #18
matched_before=193
- true: pos=1406 off=0x10f4a0 ldr x8, [x0, #8]
- unidbg: seq=35013 off=0x10e8c8 size=4
- resync: offset=0x10e8c8 true_ahead=3 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8d4a0!0x10f4a0 ldr x8, [x0, #8]; x8=0x70f1b8d4a0 x0=0x70c6700f98 mem_r=0x70c6700fa0 -> x8=0x734728acd0 `
- unidbg_raw: `35013 0x10e8c8 4`

True-device skipped before resync:
- true: pos=1406 off=0x10f4a0 ldr x8, [x0, #8]
- true: pos=1407 off=0x10f4a4 ldr x0, [x8, #0x20]
- true: pos=1408 off=0x10f4a8 ret

Unidbg skipped before resync:
- none

## Divergence #19
matched_before=198
- true: pos=1414 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- unidbg: seq=35018 off=0x1194d8 size=4
- resync: offset=0x1194d8 true_ahead=5 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8c8dc!0x10e8dc ldp x29, x30, [sp, #0x50]; fp=0x70c6700fd0 lr=0x70f1b8c8c8 sp=0x70c6700f80 mem_r=0x70c6700fd0 -> fp=0x70c6701020 lr=0x70f1b974d8 `
- unidbg_raw: `35018 0x1194d8 4`

True-device skipped before resync:
- true: pos=1414 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- true: pos=1415 off=0x10e8e0 ldp x20, x19, [sp, #0x40]
- true: pos=1416 off=0x10e8e4 ldp x22, x21, [sp, #0x30]
- true: pos=1417 off=0x10e8e8 add sp, sp, #0x60
- true: pos=1418 off=0x10e8ec ret

Unidbg skipped before resync:
- none

## Divergence #20
matched_before=211
- true: pos=1432 off=0x33390 adrp x16, #0x70f1cfa000
- unidbg: seq=35031 off=0x1194f4 size=4
- resync: offset=0x1194f4 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1390!0x33390 adrp x16, #0x70f1cfa000; x16=0x70f1cfa460 -> x16=0x70f1cfa000 `
- unidbg_raw: `35031 0x1194f4 4`

True-device skipped before resync:
- true: pos=1432 off=0x33390 adrp x16, #0x70f1cfa000
- true: pos=1433 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=1434 off=0x33398 add x16, x16, #0x650
- true: pos=1435 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #21
matched_before=225
- true: pos=1452 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=35045 off=0x149d80 size=4
- resync: offset=0x149d80 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `35045 0x149d80 4`

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

## Divergence #22
matched_before=228
- true: pos=1481 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=35048 off=0x149d8c size=4
- resync: offset=0x149d8c true_ahead=1538 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6701030 sp=0x70c6701030 -> sp=0x70c6700fa0 `
- unidbg_raw: `35048 0x149d8c 4`

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

## Divergence #23
matched_before=232
- true: pos=3023 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=35052 off=0x149d94 size=4
- resync: offset=0x149d94 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b895f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x70c6701030 mem_w=0x70c6701000 -> sp=0x70c6701000 `
- unidbg_raw: `35052 0x149d94 4`

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

## Divergence #24
matched_before=268
- true: pos=3106 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35088 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f80 sp=0x70c6700f80 -> sp=0x70c6700f20 `
- unidbg_raw: `35088 0x12de08 4`

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

## Divergence #25
matched_before=270
- true: pos=3139 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35090 off=0x60b9c size=4
- resync: offset=0x60b9c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `35090 0x60b9c 4`

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

## Divergence #26
matched_before=273
- true: pos=3159 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=35093 off=0x60ba8 size=4
- resync: offset=0x60ba8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1c40edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x0 sp=0x70c6700f80 mem_w=0x70c6700f60 -> sp=0x70c6700f60 `
- unidbg_raw: `35093 0x60ba8 4`

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

## Divergence #27
matched_before=278
- true: pos=3181 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35098 off=0x60bbc size=4
- resync: offset=0x60bbc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700f80 mem_r=0x70c6700f88 -> w8=0x0 `
- unidbg_raw: `35098 0x60bbc 4`

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

## Divergence #28
matched_before=308
- true: pos=3230 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- unidbg: seq=35128 off=0x120aa8 size=4
- resync: offset=0x120aa8 true_ahead=34 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b8968c!0x10b68c stp x22, x21, [sp, #-0x30]!; x22=0x0 x21=0x70c6701178 sp=0x70c6700fa0 mem_w=0x70c6700f70 -> sp=0x70c6700f70 `
- unidbg_raw: `35128 0x120aa8 4`

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

## Divergence #29
matched_before=325
- true: pos=3288 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35145 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f50 sp=0x70c6700f50 -> sp=0x70c6700ef0 `
- unidbg_raw: `35145 0x12de08 4`

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

## Divergence #30
matched_before=327
- true: pos=3321 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35147 off=0x75d54 size=4
- resync: offset=0x75d54 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `35147 0x75d54 4`

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

## Divergence #31
matched_before=337
- true: pos=3348 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35157 off=0x75d7c size=4
- resync: offset=0x75d7c true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472e8150 x0=0x70c6700f50 mem_r=0x70c6700f58 -> w8=0x0 `
- unidbg_raw: `35157 0x75d7c 4`

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

## Divergence #32
matched_before=347
- true: pos=3377 off=0x12e09c b #0x70f1bc1858
- unidbg: seq=35167 off=0x120ab8 size=4
- resync: offset=0x120ab8 true_ahead=42 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bac09c!0x12e09c b #0x70f1bc1858; `
- unidbg_raw: `35167 0x120ab8 4`

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

## Divergence #33
matched_before=368
- true: pos=3442 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35188 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700f90 sp=0x70c6700f90 -> sp=0x70c6700f30 `
- unidbg_raw: `35188 0x12de08 4`

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

## Divergence #34
matched_before=370
- true: pos=3475 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=35190 off=0x47a18 size=4
- resync: offset=0x47a18 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x298c2203d40000 -> x16=0x70f1cfa000 `
- unidbg_raw: `35190 0x47a18 4`

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

## Divergence #35
matched_before=387
- true: pos=3509 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35207 off=0x47a28 size=4
- resync: offset=0x47a28 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x70c6700f90 mem_r=0x70c6700f98 -> w8=0x0 `
- unidbg_raw: `35207 0x47a28 4`

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

## Divergence #36
matched_before=408
- true: pos=3549 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=35228 off=0x149db0 size=4
- resync: offset=0x149db0 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89764!0x10b764 str x19, [sp, #-0x20]!; x19=0x70c6701658 sp=0x70c6701030 mem_w=0x70c6701010 -> sp=0x70c6701010 `
- unidbg_raw: `35228 0x149db0 4`

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

## Divergence #37
matched_before=419
- true: pos=3586 off=0x12cf90 sub sp, sp, #0x90
- unidbg: seq=35239 off=0x149ddc size=4
- resync: offset=0x149ddc true_ahead=550 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baaf90!0x12cf90 sub sp, sp, #0x90; sp=0x70c6701030 sp=0x70c6701030 -> sp=0x70c6700fa0 `
- unidbg_raw: `35239 0x149ddc 4`

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

## Divergence #38
matched_before=826
- true: pos=4547 off=0x137978 sub x0, x8, x0
- unidbg: seq=35646 off=0x137970 size=4
- resync: offset=0x137970 true_ahead=7 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x747731ba70 x8=0x747731bb33 x0=0x747731ba70 -> x0=0xc3 `
- unidbg_raw: `35646 0x137970 4`

True-device skipped before resync:
- true: pos=4547 off=0x137978 sub x0, x8, x0
- true: pos=4548 off=0x13797c ret
- true: pos=4549 off=0x63ce8 mov x21, x0
- true: pos=4550 off=0x63cec mov x0, x20
- true: pos=4551 off=0x63cf0 bl #0x70f1bb5968
- true: pos=4552 off=0x137968 cbz x0, #0x70f1bb597c
- true: pos=4553 off=0x13796c sub x8, x0, #1

Unidbg skipped before resync:
- none

## Divergence #39
matched_before=836
- true: pos=4564 off=0x137978 sub x0, x8, x0
- unidbg: seq=35656 off=0x137970 size=4
- resync: offset=0x137978 true_ahead=0 unidbg_ahead=1124
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x70c67011d0 x8=0x70c67011d4 x0=0x70c67011d0 -> x0=0x4 `
- unidbg_raw: `35656 0x137970 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=35656 off=0x137970 size=4
- unidbg: seq=35657 off=0x137974 size=4
- unidbg: seq=35658 off=0x137970 size=4
- unidbg: seq=35659 off=0x137974 size=4
- unidbg: seq=35660 off=0x137970 size=4
- unidbg: seq=35661 off=0x137974 size=4
- unidbg: seq=35662 off=0x137970 size=4
- unidbg: seq=35663 off=0x137974 size=4
- unidbg: seq=35664 off=0x137970 size=4
- unidbg: seq=35665 off=0x137974 size=4
- unidbg: seq=35666 off=0x137970 size=4
- unidbg: seq=35667 off=0x137974 size=4
- ... 1112 more

## Divergence #40
matched_before=838
- true: pos=4566 off=0x63cf4 mov x2, x0
- unidbg: seq=36782 off=0x63ce8 size=4
- resync: offset=0x63cf4 true_ahead=0 unidbg_ahead=17
- true_raw: `[libmetasec_ml.so] 0x70f1ae1cf4!0x63cf4 mov x2, x0; x2=0x0 x0=0x4 -> x2=0x4 `
- unidbg_raw: `36782 0x63ce8 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=36782 off=0x63ce8 size=4
- unidbg: seq=36783 off=0x63cec size=4
- unidbg: seq=36784 off=0x63cf0 size=4
- unidbg: seq=36785 off=0x137968 size=4
- unidbg: seq=36786 off=0x13796c size=4
- unidbg: seq=36787 off=0x137970 size=4
- unidbg: seq=36788 off=0x137974 size=4
- unidbg: seq=36789 off=0x137970 size=4
- unidbg: seq=36790 off=0x137974 size=4
- unidbg: seq=36791 off=0x137970 size=4
- unidbg: seq=36792 off=0x137974 size=4
- unidbg: seq=36793 off=0x137970 size=4
- ... 5 more

## Divergence #41
matched_before=855
- true: pos=4583 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=36816 off=0x137dd4 size=4
- resync: offset=0x137dd4 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x4 sp=0x70c6700fc0 mem_w=0x70c6700fa0 -> sp=0x70c6700fa0 `
- unidbg_raw: `36816 0x137dd4 4`

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

## Divergence #42
matched_before=880
- true: pos=4620 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=36841 off=0x137e4c size=4
- resync: offset=0x137e4c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x4 sp=0x70c6700fc0 mem_w=0x70c6700fa0 -> sp=0x70c6700fa0 `
- unidbg_raw: `36841 0x137e4c 4`

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

## Divergence #43
matched_before=881
- true: pos=4633 off=0x137e50 ldr x8, [x0]
- unidbg: seq=36842 off=0x137e84 size=4
- resync: offset=0x137e84 true_ahead=84 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5e50!0x137e50 ldr x8, [x0]; x8=0x1 x0=0x7447288af0 mem_r=0x7447288af0 -> x8=0x7327288ed0 `
- unidbg_raw: `36842 0x137e84 4`

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

## Divergence #44
matched_before=972
- true: pos=4808 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=36933 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babd04!0x12dd04 sub sp, sp, #0x60; sp=0x70c6700fe0 sp=0x70c6700fe0 -> sp=0x70c6700f80 `
- unidbg_raw: `36933 0x12de08 4`

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

## Divergence #45
matched_before=974
- true: pos=4841 off=0x33880 adrp x16, #0x70f1cfa000
- unidbg: seq=36935 off=0x44ba4 size=4
- resync: offset=0x44ba4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ab1880!0x33880 adrp x16, #0x70f1cfa000; x16=0x70f1cfa998 -> x16=0x70f1cfa000 `
- unidbg_raw: `36935 0x44ba4 4`

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

## Divergence #46
matched_before=984
- true: pos=4868 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=36945 off=0x44bcc size=4
- resync: offset=0x44bcc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1babe7c!0x12de7c ldr w8, [x0, #8]; w8=0x472cdc70 x0=0x70c6700fe0 mem_r=0x70c6700fe8 -> w8=0x0 `
- unidbg_raw: `36945 0x44bcc 4`

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

## Divergence #47
matched_before=1066
- true: pos=4969 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=37027 off=0x14954c size=4
- resync: offset=0x14954c true_ahead=867 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1baa9a4!0x12c9a4 sub sp, sp, #0x90; sp=0x70c6700e70 sp=0x70c6700e70 -> sp=0x70c6700de0 `
- unidbg_raw: `37027 0x14954c 4`

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

## Divergence #48
matched_before=1473
- true: pos=6243 off=0x137978 sub x0, x8, x0
- unidbg: seq=37434 off=0x137970 size=4
- resync: offset=0x137970 true_ahead=7 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x747731ba70 x8=0x747731bb33 x0=0x747731ba70 -> x0=0xc3 `
- unidbg_raw: `37434 0x137970 4`

True-device skipped before resync:
- true: pos=6243 off=0x137978 sub x0, x8, x0
- true: pos=6244 off=0x13797c ret
- true: pos=6245 off=0x63ce8 mov x21, x0
- true: pos=6246 off=0x63cec mov x0, x20
- true: pos=6247 off=0x63cf0 bl #0x70f1bb5968
- true: pos=6248 off=0x137968 cbz x0, #0x70f1bb597c
- true: pos=6249 off=0x13796c sub x8, x0, #1

Unidbg skipped before resync:
- none

## Divergence #49
matched_before=1489
- true: pos=6266 off=0x137978 sub x0, x8, x0
- unidbg: seq=37450 off=0x137970 size=4
- resync: offset=0x137970 true_ahead=1031 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x70c6700f58 x8=0x70c6700f5f x0=0x70c6700f58 -> x0=0x7 `
- unidbg_raw: `37450 0x137970 4`

True-device skipped before resync:
- true: pos=6266 off=0x137978 sub x0, x8, x0
- true: pos=6267 off=0x13797c ret
- true: pos=6268 off=0x63cf4 mov x2, x0
- true: pos=6269 off=0x63cf8 cmp x21, x0
- true: pos=6270 off=0x63cfc tbz w22, #0, #0x70f1ae1d14
- true: pos=6271 off=0x63d14 b.hs #0x70f1ae1d20
- true: pos=6272 off=0x63d20 mov x0, x20
- true: pos=6273 off=0x63d24 mov x1, x19
- true: pos=6274 off=0x63d28 bl #0x70f1bb5dac
- true: pos=6275 off=0x137dac stp x24, x23, [sp, #-0x40]!
- true: pos=6276 off=0x137db0 stp x22, x21, [sp, #0x10]
- true: pos=6277 off=0x137db4 stp x20, x19, [sp, #0x20]
- ... 1019 more

Unidbg skipped before resync:
- none

## Divergence #50
matched_before=1881
- true: pos=7693 off=0x137978 sub x0, x8, x0
- unidbg: seq=37842 off=0x137970 size=4
- resync: offset=0x137970 true_ahead=7 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x747731ba70 x8=0x747731bb33 x0=0x747731ba70 -> x0=0xc3 `
- unidbg_raw: `37842 0x137970 4`

True-device skipped before resync:
- true: pos=7693 off=0x137978 sub x0, x8, x0
- true: pos=7694 off=0x13797c ret
- true: pos=7695 off=0x63ce8 mov x21, x0
- true: pos=7696 off=0x63cec mov x0, x20
- true: pos=7697 off=0x63cf0 bl #0x70f1bb5968
- true: pos=7698 off=0x137968 cbz x0, #0x70f1bb597c
- true: pos=7699 off=0x13796c sub x8, x0, #1

Unidbg skipped before resync:
- none

## Divergence #51
matched_before=1899
- true: pos=7718 off=0x137978 sub x0, x8, x0
- unidbg: seq=37860 off=0x137970 size=4
- resync: offset=0x137978 true_ahead=0 unidbg_ahead=708
- true_raw: `[libmetasec_ml.so] 0x70f1bb5978!0x137978 sub x0, x8, x0; x0=0x70c6700f60 x8=0x70c6700f68 x0=0x70c6700f60 -> x0=0x8 `
- unidbg_raw: `37860 0x137970 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=37860 off=0x137970 size=4
- unidbg: seq=37861 off=0x137974 size=4
- unidbg: seq=37862 off=0x137970 size=4
- unidbg: seq=37863 off=0x137974 size=4
- unidbg: seq=37864 off=0x137970 size=4
- unidbg: seq=37865 off=0x137974 size=4
- unidbg: seq=37866 off=0x137970 size=4
- unidbg: seq=37867 off=0x137974 size=4
- unidbg: seq=37868 off=0x137970 size=4
- unidbg: seq=37869 off=0x137974 size=4
- unidbg: seq=37870 off=0x137970 size=4
- unidbg: seq=37871 off=0x137974 size=4
- ... 696 more

## Divergence #52
matched_before=1901
- true: pos=7720 off=0x63cf4 mov x2, x0
- unidbg: seq=38570 off=0x63ce8 size=4
- resync: offset=0x63cf4 true_ahead=0 unidbg_ahead=23
- true_raw: `[libmetasec_ml.so] 0x70f1ae1cf4!0x63cf4 mov x2, x0; x2=0x0 x0=0x8 -> x2=0x8 `
- unidbg_raw: `38570 0x63ce8 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=38570 off=0x63ce8 size=4
- unidbg: seq=38571 off=0x63cec size=4
- unidbg: seq=38572 off=0x63cf0 size=4
- unidbg: seq=38573 off=0x137968 size=4
- unidbg: seq=38574 off=0x13796c size=4
- unidbg: seq=38575 off=0x137970 size=4
- unidbg: seq=38576 off=0x137974 size=4
- unidbg: seq=38577 off=0x137970 size=4
- unidbg: seq=38578 off=0x137974 size=4
- unidbg: seq=38579 off=0x137970 size=4
- unidbg: seq=38580 off=0x137974 size=4
- unidbg: seq=38581 off=0x137970 size=4
- ... 11 more

## Divergence #53
matched_before=1918
- true: pos=7737 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=38610 off=0x137dd4 size=4
- resync: offset=0x137dd4 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x8 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `38610 0x137dd4 4`

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

## Divergence #54
matched_before=1943
- true: pos=7774 off=0x46840 stp x20, x19, [sp, #-0x20]!
- unidbg: seq=38635 off=0x137e4c size=4
- resync: offset=0x137e4c true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1ac4840!0x46840 stp x20, x19, [sp, #-0x20]!; x20=0x747731ba70 x19=0x8 sp=0x70c6700e00 mem_w=0x70c6700de0 -> sp=0x70c6700de0 `
- unidbg_raw: `38635 0x137e4c 4`

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

## Divergence #55
matched_before=1944
- true: pos=7787 off=0x137e50 ldr x8, [x0]
- unidbg: seq=38636 off=0x137e84 size=4
- resync: offset=0x137e84 true_ahead=84 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5e50!0x137e50 ldr x8, [x0]; x8=0x1 x0=0x7447288af0 mem_r=0x7447288af0 -> x8=0x7327288ed0 `
- unidbg_raw: `38636 0x137e84 4`

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

## Divergence #56
matched_before=1992
- true: pos=7919 off=0x137ea4 cbz w9, #0x70f1bb5eb4
- unidbg: seq=38684 off=0x137eb8 size=4
- resync: offset=0x137eb8 true_ahead=35 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1bb5ea4!0x137ea4 cbz w9, #0x70f1bb5eb4; w9=0x73 `
- unidbg_raw: `38684 0x137eb8 4`

True-device skipped before resync:
- true: pos=7919 off=0x137ea4 cbz w9, #0x70f1bb5eb4
- true: pos=7920 off=0x137ea8 subs x19, x19, #1
- true: pos=7921 off=0x137eac add x21, x21, #1
- true: pos=7922 off=0x137eb0 b.ne #0x70f1bb5e8c
- true: pos=7923 off=0x137e8c ldrb w9, [x21]
- true: pos=7924 off=0x137e90 ldrb w10, [x20], #1
- true: pos=7925 off=0x137e94 ldrb w11, [x8, x9]
- true: pos=7926 off=0x137e98 ldrb w10, [x8, x10]
- true: pos=7927 off=0x137e9c subs w0, w11, w10
- true: pos=7928 off=0x137ea0 b.ne #0x70f1bb5eb8
- true: pos=7929 off=0x137ea4 cbz w9, #0x70f1bb5eb4
- true: pos=7930 off=0x137ea8 subs x19, x19, #1
- ... 23 more

Unidbg skipped before resync:
- none

## Divergence #57
matched_before=2003
- true: pos=7965 off=0x14958c sub x8, x29, #0xac
- unidbg: seq=38695 off=0x149558 size=4
- resync: offset=0x14958c true_ahead=0 unidbg_ahead=1715
- true_raw: `[libmetasec_ml.so] 0x70f1bc758c!0x14958c sub x8, x29, #0xac; x8=0x70f1c808f0 fp=0x70c6700fd0 -> x8=0x70c6700f24 `
- unidbg_raw: `38695 0x149558 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=38695 off=0x149558 size=4
- unidbg: seq=38696 off=0x14955c size=4
- unidbg: seq=38697 off=0x149560 size=4
- unidbg: seq=38698 off=0x149564 size=4
- unidbg: seq=38699 off=0x149568 size=4
- unidbg: seq=38700 off=0x14956c size=4
- unidbg: seq=38701 off=0x149570 size=4
- unidbg: seq=38702 off=0x149574 size=4
- unidbg: seq=38703 off=0x149578 size=4
- unidbg: seq=38704 off=0x14957c size=4
- unidbg: seq=38705 off=0x149580 size=4
- unidbg: seq=38706 off=0x149584 size=4
- ... 1703 more

## Divergence #58
matched_before=2245
- true: pos=8207 off=0x10be8c ret
- unidbg: seq=40652 off=0x10be80 size=4
- resync: offset=0x10be68 true_ahead=10 unidbg_ahead=2
- true_raw: `[libmetasec_ml.so] 0x70f1b89e8c!0x10be8c ret ; `
- unidbg_raw: `40652 0x10be80 4`

True-device skipped before resync:
- true: pos=8207 off=0x10be8c ret
- true: pos=8208 off=0x1497c0 mov w20, w0
- true: pos=8209 off=0x1497c4 ldr x0, [x19]
- true: pos=8210 off=0x1497c8 ldr w2, [sp, #0x20]
- true: pos=8211 off=0x1497cc mov w1, #0x23
- true: pos=8212 off=0x1497d0 bl #0x70f1b89e58
- true: pos=8213 off=0x10be58 tbnz w2, #0x1f, #0x70f1b89e88
- true: pos=8214 off=0x10be5c ldrsw x9, [x0, #0xc]
- true: pos=8215 off=0x10be60 mov x8, x0
- true: pos=8216 off=0x10be64 sxtw x0, w2

Unidbg skipped before resync:
- unidbg: seq=40652 off=0x10be80 size=4
- unidbg: seq=40653 off=0x10be84 size=4

## Divergence #59
matched_before=2299
- true: pos=8271 off=0x10be80 add x0, x0, #1
- unidbg: seq=40708 off=0x10be8c size=4
- resync: offset=0x10be68 true_ahead=2 unidbg_ahead=10
- true_raw: `[libmetasec_ml.so] 0x70f1b89e80!0x10be80 add x0, x0, #1; x0=0xe x0=0xe -> x0=0xf `
- unidbg_raw: `40708 0x10be8c 4`

True-device skipped before resync:
- true: pos=8271 off=0x10be80 add x0, x0, #1
- true: pos=8272 off=0x10be84 b #0x70f1b89e68

Unidbg skipped before resync:
- unidbg: seq=40708 off=0x10be8c size=4
- unidbg: seq=40709 off=0x1497c0 size=4
- unidbg: seq=40710 off=0x1497c4 size=4
- unidbg: seq=40711 off=0x1497c8 size=4
- unidbg: seq=40712 off=0x1497cc size=4
- unidbg: seq=40713 off=0x1497d0 size=4
- unidbg: seq=40714 off=0x10be58 size=4
- unidbg: seq=40715 off=0x10be5c size=4
- unidbg: seq=40716 off=0x10be60 size=4
- unidbg: seq=40717 off=0x10be64 size=4

## Divergence #60
matched_before=3741
- true: pos=9715 off=0x10be88 mov w0, #-1
- unidbg: seq=42160 off=0x10be70 size=4
- resync: offset=0x10be70 true_ahead=13 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x70f1b89e88!0x10be88 mov w0, #-1; w0=0xc3 -> w0=0xffffffff `
- unidbg_raw: `42160 0x10be70 4`

True-device skipped before resync:
- true: pos=9715 off=0x10be88 mov w0, #-1
- true: pos=9716 off=0x10be8c ret
- true: pos=9717 off=0x1497d4 mov w21, w0
- true: pos=9718 off=0x1497d8 ldr x0, [x19]
- true: pos=9719 off=0x1497dc ldr w2, [sp, #0x20]
- true: pos=9720 off=0x1497e0 mov w1, #0x3f
- true: pos=9721 off=0x1497e4 bl #0x70f1b89e58
- true: pos=9722 off=0x10be58 tbnz w2, #0x1f, #0x70f1b89e88
- true: pos=9723 off=0x10be5c ldrsw x9, [x0, #0xc]
- true: pos=9724 off=0x10be60 mov x8, x0
- true: pos=9725 off=0x10be64 sxtw x0, w2
- true: pos=9726 off=0x10be68 cmp x0, x9
- ... 1 more

Unidbg skipped before resync:
- none

## Divergence #61
matched_before=3985
- true: pos=9972 off=0x10be8c ret
- unidbg: seq=42404 off=0x10be80 size=4
- resync: none in window=4096
- true_raw: `[libmetasec_ml.so] 0x70f1b89e8c!0x10be8c ret ; `
- unidbg_raw: `42404 0x10be80 4`

True-device skipped before resync:
- true: pos=9972 off=0x10be8c ret
- true: pos=9973 off=0x1497e8 cmn w20, #1
- true: pos=9974 off=0x1497ec adrp x11, #0x70f1cfc000
- true: pos=9975 off=0x1497f0 add x11, x11, #0xf04
- true: pos=9976 off=0x1497f4 csel w8, wzr, w20, eq
- true: pos=9977 off=0x1497f8 cmp w21, w8
- true: pos=9978 off=0x1497fc ldr w9, [sp, #0x20]
- true: pos=9979 off=0x149800 csel w10, w21, w8, lt
- true: pos=9980 off=0x149804 cmp w8, #0
- true: pos=9981 off=0x149808 csel w10, w21, w10, eq
- true: pos=9982 off=0x14980c cmn w21, #1
- true: pos=9983 off=0x149810 csel w8, w8, w10, eq
- ... 4084 more

Unidbg skipped before resync:
- unidbg: seq=42404 off=0x10be80 size=4
- unidbg: seq=42405 off=0x10be84 size=4
- unidbg: seq=42406 off=0x10be68 size=4
- unidbg: seq=42407 off=0x10be6c size=4
- unidbg: seq=42408 off=0x10be70 size=4
- unidbg: seq=42409 off=0x10be74 size=4
- unidbg: seq=42410 off=0x10be78 size=4
- unidbg: seq=42411 off=0x10be7c size=4
- unidbg: seq=42412 off=0x10be80 size=4
- unidbg: seq=42413 off=0x10be84 size=4
- unidbg: seq=42414 off=0x10be68 size=4
- unidbg: seq=42415 off=0x10be6c size=4
- ... 4084 more


# MetaSec instruction sequence diff

gum=dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log
seq=unidbg/unidbg-android/target/sign6_350101_rootfs_instrseq_unicorn2_20260831_143310.seq
sync_offset=0x149cbc
gum_skipped_before_sync=0
seq_skipped_before_sync=34815
matched_after_sync=1972
diffs_reported=40
stopped=diff_limit

## Matched context before divergence
- -08 off=0x137970 true_pos=5794 seq_pos=36791 true=ldrb w9, [x8, #1]!
- -07 off=0x137974 true_pos=5795 seq_pos=36792 true=cbnz w9, #0x7102d3b970
- -06 off=0x137970 true_pos=5796 seq_pos=36793 true=ldrb w9, [x8, #1]!
- -05 off=0x137974 true_pos=5797 seq_pos=36794 true=cbnz w9, #0x7102d3b970
- -04 off=0x137970 true_pos=5798 seq_pos=36795 true=ldrb w9, [x8, #1]!
- -03 off=0x137974 true_pos=5799 seq_pos=36796 true=cbnz w9, #0x7102d3b970
- -02 off=0x137978 true_pos=5938 seq_pos=36797 true=sub x0, x8, x0
- -01 off=0x13797c true_pos=5939 seq_pos=36798 true=ret

## Divergence #1
matched_before=45
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34861 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7106ee6278 sp=0x7106ee6100 mem_w=0x7106ee60e0 -> sp=0x7106ee60e0 `
- unidbg_raw: `34861 0x12001c 4`

True-device skipped before resync:
- true: pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=47 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=48 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=49 off=0x1c2ee8 cmp x0, #0
- true: pos=50 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=51 off=0x1c2ef0 mov x0, x19
- true: pos=52 off=0x1c2ef4 bl #0x7102c370c0
- true: pos=53 off=0x330c0 adrp x16, #0x7102e80000
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #2
matched_before=55
- true: pos=73 off=0x11fc08 adrp x8, #0x7102e73000
- unidbg: seq=34871 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d23c08!0x11fc08 adrp x8, #0x7102e73000; x8=0x7102c5b9f4 -> x8=0x7102e73000 `
- unidbg_raw: `34871 0x120044 4`

True-device skipped before resync:
- true: pos=73 off=0x11fc08 adrp x8, #0x7102e73000
- true: pos=74 off=0x11fc0c add x8, x8, #0x150
- true: pos=75 off=0x11fc10 str x8, [x0]
- true: pos=76 off=0x11fc14 ldr q0, [x1]
- true: pos=77 off=0x11fc18 ldr x1, [x1, #0x10]
- true: pos=78 off=0x11fc1c add x8, x0, #0x20
- true: pos=79 off=0x11fc20 stur q0, [x0, #8]
- true: pos=80 off=0x11fc24 str x1, [x0, #0x18]
- ... 61 more

Unidbg skipped before resync:
- none

## Divergence #3
matched_before=74
- true: pos=165 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34890 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=126 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31d04!0x12dd04 sub sp, sp, #0x60; sp=0x7106ee60f0 sp=0x7106ee60f0 -> sp=0x7106ee6090 `
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
- ... 118 more

Unidbg skipped before resync:
- none

## Divergence #4
matched_before=76
- true: pos=307 off=0x33880 adrp x16, #0x7102e80000
- unidbg: seq=34892 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37880!0x33880 adrp x16, #0x7102e80000; x16=0x7102e80758 -> x16=0x7102e80000 `
- unidbg_raw: `34892 0x490d4 4`

True-device skipped before resync:
- true: pos=307 off=0x33880 adrp x16, #0x7102e80000
- true: pos=308 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=309 off=0x33888 add x16, x16, #0x8c8
- true: pos=310 off=0x3388c br x17
- true: pos=313 off=0x12de10 str w0, [x19, #8]
- true: pos=314 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=315 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=316 off=0x12de1c cmp x8, x9
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #5
matched_before=79
- true: pos=327 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34895 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x73474493d0 sp=0x7106ee60f0 mem_w=0x7106ee60d0 -> sp=0x7106ee60d0 `
- unidbg_raw: `34895 0x490e0 4`

True-device skipped before resync:
- true: pos=327 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=328 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=329 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=330 off=0x1c2ee8 cmp x0, #0
- true: pos=331 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=332 off=0x1c2ef0 mov x0, x19
- true: pos=333 off=0x1c2ef4 bl #0x7102c370c0
- true: pos=334 off=0x330c0 adrp x16, #0x7102e80000
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #6
matched_before=84
- true: pos=349 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34900 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31e7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x7106ee60f0 mem_r=0x7106ee60f8 -> w8=0x0 `
- unidbg_raw: `34900 0x490f4 4`

True-device skipped before resync:
- true: pos=349 off=0x12de7c ldr w8, [x0, #8]
- true: pos=350 off=0x12de80 adrp x9, #0x7102e74000
- true: pos=351 off=0x12de84 add x9, x9, #0x7b8
- true: pos=352 off=0x12de88 str x9, [x0]
- true: pos=353 off=0x12de8c cbz w8, #0x7102d31e94
- true: pos=354 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=355 off=0x12de98 adrp x9, #0x7102ec7000
- true: pos=356 off=0x12de9c ldr x9, [x9, #0x438]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #7
matched_before=102
- true: pos=386 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34918 off=0x12001c size=4
- resync: offset=0x12001c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7106ee6268 sp=0x7106ee6100 mem_w=0x7106ee60e0 -> sp=0x7106ee60e0 `
- unidbg_raw: `34918 0x12001c 4`

True-device skipped before resync:
- true: pos=386 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=387 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=388 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=389 off=0x1c2ee8 cmp x0, #0
- true: pos=390 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=391 off=0x1c2ef0 mov x0, x19
- true: pos=392 off=0x1c2ef4 bl #0x7102c370c0
- true: pos=393 off=0x330c0 adrp x16, #0x7102e80000
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #8
matched_before=112
- true: pos=413 off=0x11fc08 adrp x8, #0x7102e73000
- unidbg: seq=34928 off=0x120044 size=4
- resync: offset=0x120044 true_ahead=69 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d23c08!0x11fc08 adrp x8, #0x7102e73000; x8=0x7102c5b9f4 -> x8=0x7102e73000 `
- unidbg_raw: `34928 0x120044 4`

True-device skipped before resync:
- true: pos=413 off=0x11fc08 adrp x8, #0x7102e73000
- true: pos=414 off=0x11fc0c add x8, x8, #0x150
- true: pos=415 off=0x11fc10 str x8, [x0]
- true: pos=416 off=0x11fc14 ldr q0, [x1]
- true: pos=417 off=0x11fc18 ldr x1, [x1, #0x10]
- true: pos=418 off=0x11fc1c add x8, x0, #0x20
- true: pos=419 off=0x11fc20 stur q0, [x0, #8]
- true: pos=420 off=0x11fc24 str x1, [x0, #0x18]
- ... 61 more

Unidbg skipped before resync:
- none

## Divergence #9
matched_before=131
- true: pos=505 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=34947 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31d04!0x12dd04 sub sp, sp, #0x60; sp=0x7106ee60f0 sp=0x7106ee60f0 -> sp=0x7106ee6090 `
- unidbg_raw: `34947 0x12de08 4`

True-device skipped before resync:
- true: pos=505 off=0x12dd04 sub sp, sp, #0x60
- true: pos=506 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=507 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=508 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=509 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=510 off=0x12dd18 add x29, sp, #0x50
- true: pos=511 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=512 off=0x12dd20 ldr x8, [x21, #0x28]
- ... 23 more

Unidbg skipped before resync:
- none

## Divergence #10
matched_before=133
- true: pos=538 off=0x33880 adrp x16, #0x7102e80000
- unidbg: seq=34949 off=0x490d4 size=4
- resync: offset=0x490d4 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37880!0x33880 adrp x16, #0x7102e80000; x16=0x7102e804e8 -> x16=0x7102e80000 `
- unidbg_raw: `34949 0x490d4 4`

True-device skipped before resync:
- true: pos=538 off=0x33880 adrp x16, #0x7102e80000
- true: pos=539 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=540 off=0x33888 add x16, x16, #0x8c8
- true: pos=541 off=0x3388c br x17
- true: pos=544 off=0x12de10 str w0, [x19, #8]
- true: pos=545 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=546 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=547 off=0x12de1c cmp x8, x9
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #11
matched_before=136
- true: pos=558 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=34952 off=0x490e0 size=4
- resync: offset=0x490e0 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7347321490 sp=0x7106ee60f0 mem_w=0x7106ee60d0 -> sp=0x7106ee60d0 `
- unidbg_raw: `34952 0x490e0 4`

True-device skipped before resync:
- true: pos=558 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=559 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=560 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=561 off=0x1c2ee8 cmp x0, #0
- true: pos=562 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=563 off=0x1c2ef0 mov x0, x19
- true: pos=564 off=0x1c2ef4 bl #0x7102c370c0
- true: pos=565 off=0x330c0 adrp x16, #0x7102e80000
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #12
matched_before=141
- true: pos=580 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=34957 off=0x490f4 size=4
- resync: offset=0x490f4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31e7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x7106ee60f0 mem_r=0x7106ee60f8 -> w8=0x0 `
- unidbg_raw: `34957 0x490f4 4`

True-device skipped before resync:
- true: pos=580 off=0x12de7c ldr w8, [x0, #8]
- true: pos=581 off=0x12de80 adrp x9, #0x7102e74000
- true: pos=582 off=0x12de84 add x9, x9, #0x7b8
- true: pos=583 off=0x12de88 str x9, [x0]
- true: pos=584 off=0x12de8c cbz w8, #0x7102d31e94
- true: pos=585 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=586 off=0x12de98 adrp x9, #0x7102ec7000
- true: pos=587 off=0x12de9c ldr x9, [x9, #0x438]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #13
matched_before=151
- true: pos=609 off=0x4303c stp x20, x19, [sp, #-0x20]!
- unidbg: seq=34967 off=0x149d60 size=4
- resync: offset=0x149d60 true_ahead=12 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c4703c!0x4303c stp x20, x19, [sp, #-0x20]!; x20=0x7106ee6640 x19=0x7106ee6768 sp=0x7106ee6140 mem_w=0x7106ee6120 -> sp=0x7106ee6120 `
- unidbg_raw: `34967 0x149d60 4`

True-device skipped before resync:
- true: pos=609 off=0x4303c stp x20, x19, [sp, #-0x20]!
- true: pos=610 off=0x43040 stp x29, x30, [sp, #0x10]
- true: pos=611 off=0x43044 add x29, sp, #0x10
- true: pos=612 off=0x43048 adrp x8, #0x7102ebf000
- true: pos=613 off=0x4304c add x8, x8, #0xdb0
- true: pos=614 off=0x43050 ldarb w8, [x8]
- true: pos=615 off=0x43054 adrp x19, #0x7102ebf000
- true: pos=616 off=0x43058 tbz w8, #0, #0x7102c4706c
- ... 4 more

Unidbg skipped before resync:
- none

## Divergence #14
matched_before=156
- true: pos=626 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=34972 off=0x149d6c size=4
- resync: offset=0x149d6c true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d0f5f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x72f7295c30 sp=0x7106ee6140 mem_w=0x7106ee6110 -> sp=0x7106ee6110 `
- unidbg_raw: `34972 0x149d6c 4`

True-device skipped before resync:
- true: pos=626 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=627 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=628 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=629 off=0x10b5fc add x29, sp, #0x20
- true: pos=630 off=0x10b600 adrp x8, #0x7102e66000
- true: pos=631 off=0x10b604 mov x19, x0
- true: pos=632 off=0x10b608 add x8, x8, #0xaf0
- true: pos=633 off=0x10b60c str x8, [x0]
- ... 29 more

Unidbg skipped before resync:
- none

## Divergence #15
matched_before=183
- true: pos=702 off=0x11fe50 add x0, x0, #0x20
- unidbg: seq=34999 off=0x10a67c size=4
- resync: offset=0x10a67c true_ahead=313 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d23e50!0x11fe50 add x0, x0, #0x20; x0=0x72f7295c38 x0=0x72f7295c38 -> x0=0x72f7295c58 `
- unidbg_raw: `34999 0x10a67c 4`

True-device skipped before resync:
- true: pos=702 off=0x11fe50 add x0, x0, #0x20
- true: pos=703 off=0x11fe54 b #0x7102d12834
- true: pos=704 off=0x10e834 sub sp, sp, #0x60
- true: pos=705 off=0x10e838 stp x22, x21, [sp, #0x30]
- true: pos=706 off=0x10e83c stp x20, x19, [sp, #0x40]
- true: pos=707 off=0x10e840 stp x29, x30, [sp, #0x50]
- true: pos=708 off=0x10e844 add x29, sp, #0x50
- true: pos=709 off=0x10e848 mrs x22, tpidr_el0
- ... 305 more

Unidbg skipped before resync:
- none

## Divergence #16
matched_before=188
- true: pos=1020 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=35004 off=0x10a67c size=4
- resync: offset=0x10a694 true_ahead=46 unidbg_ahead=4
- true_raw: `[libmetasec_ml.so] 0x7102d13448!0x10f448 add x8, x23, #0x10; x8=0x1f x23=0x73472e6390 -> x8=0x73472e63a0 `
- unidbg_raw: `35004 0x10a67c 4`

True-device skipped before resync:
- true: pos=1020 off=0x10f448 add x8, x23, #0x10
- true: pos=1021 off=0x10f44c add x9, x23, #0x18
- true: pos=1022 off=0x10f450 cmp w0, #0
- true: pos=1023 off=0x10f454 csel x19, x23, x19, ge
- true: pos=1024 off=0x10f458 csel x8, x8, x9, ge
- true: pos=1025 off=0x10f45c b #0x7102d13428
- true: pos=1026 off=0x10f428 ldr x23, [x8]
- true: pos=1027 off=0x10f42c cbz x23, #0x7102d13460
- ... 38 more

Unidbg skipped before resync:
- unidbg: seq=35004 off=0x10a67c size=4
- unidbg: seq=35005 off=0x10a680 size=4
- unidbg: seq=35006 off=0x10a68c size=4
- unidbg: seq=35007 off=0x10a690 size=4

## Divergence #17
matched_before=189
- true: pos=1067 off=0x10f448 add x8, x23, #0x10
- unidbg: seq=35009 off=0x10e8b8 size=4
- resync: offset=0x10e8b8 true_ahead=444 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d13448!0x10f448 add x8, x23, #0x10; x8=0x20 x23=0x73472e6950 -> x8=0x73472e6960 `
- unidbg_raw: `35009 0x10e8b8 4`

True-device skipped before resync:
- true: pos=1067 off=0x10f448 add x8, x23, #0x10
- true: pos=1068 off=0x10f44c add x9, x23, #0x18
- true: pos=1069 off=0x10f450 cmp w0, #0
- true: pos=1070 off=0x10f454 csel x19, x23, x19, ge
- true: pos=1071 off=0x10f458 csel x8, x8, x9, ge
- true: pos=1072 off=0x10f45c b #0x7102d13428
- true: pos=1073 off=0x10f428 ldr x23, [x8]
- true: pos=1074 off=0x10f42c cbz x23, #0x7102d13460
- ... 436 more

Unidbg skipped before resync:
- none

## Divergence #18
matched_before=193
- true: pos=1515 off=0x10f4a0 ldr x8, [x0, #8]
- unidbg: seq=35013 off=0x10e8c8 size=4
- resync: offset=0x10e8c8 true_ahead=3 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d134a0!0x10f4a0 ldr x8, [x0, #8]; x8=0x7102d134a0 x0=0x7106ee60a8 mem_r=0x7106ee60b0 -> x8=0x73472e6390 `
- unidbg_raw: `35013 0x10e8c8 4`

True-device skipped before resync:
- true: pos=1515 off=0x10f4a0 ldr x8, [x0, #8]
- true: pos=1516 off=0x10f4a4 ldr x0, [x8, #0x20]
- true: pos=1517 off=0x10f4a8 ret

Unidbg skipped before resync:
- none

## Divergence #19
matched_before=198
- true: pos=1523 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- unidbg: seq=35018 off=0x1194d8 size=4
- resync: offset=0x1194d8 true_ahead=5 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d128dc!0x10e8dc ldp x29, x30, [sp, #0x50]; fp=0x7106ee60e0 lr=0x7102d128c8 sp=0x7106ee6090 mem_r=0x7106ee60e0 -> fp=0x7106ee6130 lr=0x7102d1d4d8 `
- unidbg_raw: `35018 0x1194d8 4`

True-device skipped before resync:
- true: pos=1523 off=0x10e8dc ldp x29, x30, [sp, #0x50]
- true: pos=1524 off=0x10e8e0 ldp x20, x19, [sp, #0x40]
- true: pos=1525 off=0x10e8e4 ldp x22, x21, [sp, #0x30]
- true: pos=1526 off=0x10e8e8 add sp, sp, #0x60
- true: pos=1527 off=0x10e8ec ret

Unidbg skipped before resync:
- none

## Divergence #20
matched_before=211
- true: pos=1541 off=0x33390 adrp x16, #0x7102e80000
- unidbg: seq=35031 off=0x1194f4 size=4
- resync: offset=0x1194f4 true_ahead=4 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37390!0x33390 adrp x16, #0x7102e80000; x16=0x7102e80460 -> x16=0x7102e80000 `
- unidbg_raw: `35031 0x1194f4 4`

True-device skipped before resync:
- true: pos=1541 off=0x33390 adrp x16, #0x7102e80000
- true: pos=1542 off=0x33394 ldr x17, [x16, #0x650]
- true: pos=1543 off=0x33398 add x16, x16, #0x650
- true: pos=1544 off=0x3339c br x17

Unidbg skipped before resync:
- none

## Divergence #21
matched_before=225
- true: pos=1561 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=35045 off=0x149d80 size=4
- resync: offset=0x149d80 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d0f764!0x10b764 str x19, [sp, #-0x20]!; x19=0x7106ee6768 sp=0x7106ee6140 mem_w=0x7106ee6120 -> sp=0x7106ee6120 `
- unidbg_raw: `35045 0x149d80 4`

True-device skipped before resync:
- true: pos=1561 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=1562 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=1563 off=0x10b76c add x29, sp, #0x10
- true: pos=1564 off=0x10b770 mov x19, x0
- true: pos=1565 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=1566 off=0x10b778 adrp x8, #0x7102e66000
- true: pos=1567 off=0x10b77c add x8, x8, #0xaf0
- true: pos=1568 off=0x10b780 str x8, [x19]
- ... 13 more

Unidbg skipped before resync:
- none

## Divergence #22
matched_before=228
- true: pos=1590 off=0x12c9a4 sub sp, sp, #0x90
- unidbg: seq=35048 off=0x149d8c size=4
- resync: offset=0x149d8c true_ahead=1538 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d309a4!0x12c9a4 sub sp, sp, #0x90; sp=0x7106ee6140 sp=0x7106ee6140 -> sp=0x7106ee60b0 `
- unidbg_raw: `35048 0x149d8c 4`

True-device skipped before resync:
- true: pos=1590 off=0x12c9a4 sub sp, sp, #0x90
- true: pos=1591 off=0x12c9a8 str x19, [sp, #0x70]
- true: pos=1592 off=0x12c9ac stp x29, x30, [sp, #0x80]
- true: pos=1593 off=0x12c9b0 add x29, sp, #0x80
- true: pos=1594 off=0x12c9b4 mrs x8, tpidr_el0
- true: pos=1595 off=0x12c9b8 ldr x8, [x8, #0x28]
- true: pos=1596 off=0x12c9bc stur x8, [x29, #-0x18]
- true: pos=1597 off=0x12c9c0 str x0, [sp, #0x38]
- ... 1530 more

Unidbg skipped before resync:
- none

## Divergence #23
matched_before=232
- true: pos=3132 off=0x10b5f0 str x21, [sp, #-0x30]!
- unidbg: seq=35052 off=0x149d94 size=4
- resync: offset=0x149d94 true_ahead=37 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d0f5f0!0x10b5f0 str x21, [sp, #-0x30]!; x21=0x1 sp=0x7106ee6140 mem_w=0x7106ee6110 -> sp=0x7106ee6110 `
- unidbg_raw: `35052 0x149d94 4`

True-device skipped before resync:
- true: pos=3132 off=0x10b5f0 str x21, [sp, #-0x30]!
- true: pos=3133 off=0x10b5f4 stp x20, x19, [sp, #0x10]
- true: pos=3134 off=0x10b5f8 stp x29, x30, [sp, #0x20]
- true: pos=3135 off=0x10b5fc add x29, sp, #0x20
- true: pos=3136 off=0x10b600 adrp x8, #0x7102e66000
- true: pos=3137 off=0x10b604 mov x19, x0
- true: pos=3138 off=0x10b608 add x8, x8, #0xaf0
- true: pos=3139 off=0x10b60c str x8, [x0]
- ... 29 more

Unidbg skipped before resync:
- none

## Divergence #24
matched_before=268
- true: pos=3215 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35088 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31d04!0x12dd04 sub sp, sp, #0x60; sp=0x7106ee6090 sp=0x7106ee6090 -> sp=0x7106ee6030 `
- unidbg_raw: `35088 0x12de08 4`

True-device skipped before resync:
- true: pos=3215 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3216 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3217 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3218 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3219 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3220 off=0x12dd18 add x29, sp, #0x50
- true: pos=3221 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3222 off=0x12dd20 ldr x8, [x21, #0x28]
- ... 23 more

Unidbg skipped before resync:
- none

## Divergence #25
matched_before=270
- true: pos=3248 off=0x33880 adrp x16, #0x7102e80000
- unidbg: seq=35090 off=0x60b9c size=4
- resync: offset=0x60b9c true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37880!0x33880 adrp x16, #0x7102e80000; x16=0x7102e80998 -> x16=0x7102e80000 `
- unidbg_raw: `35090 0x60b9c 4`

True-device skipped before resync:
- true: pos=3248 off=0x33880 adrp x16, #0x7102e80000
- true: pos=3249 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3250 off=0x33888 add x16, x16, #0x8c8
- true: pos=3251 off=0x3388c br x17
- true: pos=3254 off=0x12de10 str w0, [x19, #8]
- true: pos=3255 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3256 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3257 off=0x12de1c cmp x8, x9
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #26
matched_before=273
- true: pos=3268 off=0x1c2edc str x19, [sp, #-0x20]!
- unidbg: seq=35093 off=0x60ba8 size=4
- resync: offset=0x60ba8 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x0 sp=0x7106ee6090 mem_w=0x7106ee6070 -> sp=0x7106ee6070 `
- unidbg_raw: `35093 0x60ba8 4`

True-device skipped before resync:
- true: pos=3268 off=0x1c2edc str x19, [sp, #-0x20]!
- true: pos=3269 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- true: pos=3270 off=0x1c2ee4 add x29, sp, #0x10
- true: pos=3271 off=0x1c2ee8 cmp x0, #0
- true: pos=3272 off=0x1c2eec csinc x19, x0, xzr, ne
- true: pos=3273 off=0x1c2ef0 mov x0, x19
- true: pos=3274 off=0x1c2ef4 bl #0x7102c370c0
- true: pos=3275 off=0x330c0 adrp x16, #0x7102e80000
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #27
matched_before=278
- true: pos=3290 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35098 off=0x60bbc size=4
- resync: offset=0x60bbc true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31e7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x7106ee6090 mem_r=0x7106ee6098 -> w8=0x0 `
- unidbg_raw: `35098 0x60bbc 4`

True-device skipped before resync:
- true: pos=3290 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3291 off=0x12de80 adrp x9, #0x7102e74000
- true: pos=3292 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3293 off=0x12de88 str x9, [x0]
- true: pos=3294 off=0x12de8c cbz w8, #0x7102d31e94
- true: pos=3295 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3296 off=0x12de98 adrp x9, #0x7102ec7000
- true: pos=3297 off=0x12de9c ldr x9, [x9, #0x438]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #28
matched_before=308
- true: pos=3339 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- unidbg: seq=35128 off=0x120aa8 size=4
- resync: offset=0x120aa8 true_ahead=34 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d0f68c!0x10b68c stp x22, x21, [sp, #-0x30]!; x22=0x0 x21=0x7106ee6288 sp=0x7106ee60b0 mem_w=0x7106ee6080 -> sp=0x7106ee6080 `
- unidbg_raw: `35128 0x120aa8 4`

True-device skipped before resync:
- true: pos=3339 off=0x10b68c stp x22, x21, [sp, #-0x30]!
- true: pos=3340 off=0x10b690 stp x20, x19, [sp, #0x10]
- true: pos=3341 off=0x10b694 stp x29, x30, [sp, #0x20]
- true: pos=3342 off=0x10b698 add x29, sp, #0x20
- true: pos=3343 off=0x10b69c adrp x8, #0x7102e66000
- true: pos=3344 off=0x10b6a0 add x8, x8, #0xaf0
- true: pos=3345 off=0x10b6a4 str x8, [x0]
- true: pos=3346 off=0x10b6a8 ldrsw x19, [x1, #0xc]
- ... 26 more

Unidbg skipped before resync:
- none

## Divergence #29
matched_before=325
- true: pos=3397 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35145 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31d04!0x12dd04 sub sp, sp, #0x60; sp=0x7106ee6060 sp=0x7106ee6060 -> sp=0x7106ee6000 `
- unidbg_raw: `35145 0x12de08 4`

True-device skipped before resync:
- true: pos=3397 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3398 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3399 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3400 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3401 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3402 off=0x12dd18 add x29, sp, #0x50
- true: pos=3403 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3404 off=0x12dd20 ldr x8, [x21, #0x28]
- ... 23 more

Unidbg skipped before resync:
- none

## Divergence #30
matched_before=327
- true: pos=3430 off=0x33880 adrp x16, #0x7102e80000
- unidbg: seq=35147 off=0x75d54 size=4
- resync: offset=0x75d54 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37880!0x33880 adrp x16, #0x7102e80000; x16=0x7102e80998 -> x16=0x7102e80000 `
- unidbg_raw: `35147 0x75d54 4`

True-device skipped before resync:
- true: pos=3430 off=0x33880 adrp x16, #0x7102e80000
- true: pos=3431 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3432 off=0x33888 add x16, x16, #0x8c8
- true: pos=3433 off=0x3388c br x17
- true: pos=3436 off=0x12de10 str w0, [x19, #8]
- true: pos=3437 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3438 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3439 off=0x12de1c cmp x8, x9
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #31
matched_before=337
- true: pos=3457 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35157 off=0x75d7c size=4
- resync: offset=0x75d7c true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31e7c!0x12de7c ldr w8, [x0, #8]; w8=0x472c18b0 x0=0x7106ee6060 mem_r=0x7106ee6068 -> w8=0x0 `
- unidbg_raw: `35157 0x75d7c 4`

True-device skipped before resync:
- true: pos=3457 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3458 off=0x12de80 adrp x9, #0x7102e74000
- true: pos=3459 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3460 off=0x12de88 str x9, [x0]
- true: pos=3461 off=0x12de8c cbz w8, #0x7102d31e94
- true: pos=3462 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3463 off=0x12de98 adrp x9, #0x7102ec7000
- true: pos=3464 off=0x12de9c ldr x9, [x9, #0x438]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #32
matched_before=347
- true: pos=3486 off=0x12e09c b #0x7102d47858
- unidbg: seq=35167 off=0x120ab8 size=4
- resync: offset=0x120ab8 true_ahead=42 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d3209c!0x12e09c b #0x7102d47858; `
- unidbg_raw: `35167 0x120ab8 4`

True-device skipped before resync:
- true: pos=3486 off=0x12e09c b #0x7102d47858
- true: pos=3487 off=0x143858 stp x29, x30, [sp, #-0x10]!
- true: pos=3488 off=0x14385c mov x29, sp
- true: pos=3489 off=0x143860 bl #0x7102da8cc4
- true: pos=3490 off=0x1a4cc4 sub sp, sp, #0x40
- true: pos=3491 off=0x1a4cc8 str x19, [sp, #0x20]
- true: pos=3492 off=0x1a4ccc stp x29, x30, [sp, #0x30]
- true: pos=3493 off=0x1a4cd0 add x29, sp, #0x30
- ... 34 more

Unidbg skipped before resync:
- none

## Divergence #33
matched_before=368
- true: pos=3551 off=0x12dd04 sub sp, sp, #0x60
- unidbg: seq=35188 off=0x12de08 size=4
- resync: offset=0x12de08 true_ahead=31 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31d04!0x12dd04 sub sp, sp, #0x60; sp=0x7106ee60a0 sp=0x7106ee60a0 -> sp=0x7106ee6040 `
- unidbg_raw: `35188 0x12de08 4`

True-device skipped before resync:
- true: pos=3551 off=0x12dd04 sub sp, sp, #0x60
- true: pos=3552 off=0x12dd08 stp x24, x23, [sp, #0x20]
- true: pos=3553 off=0x12dd0c stp x22, x21, [sp, #0x30]
- true: pos=3554 off=0x12dd10 stp x20, x19, [sp, #0x40]
- true: pos=3555 off=0x12dd14 stp x29, x30, [sp, #0x50]
- true: pos=3556 off=0x12dd18 add x29, sp, #0x50
- true: pos=3557 off=0x12dd1c mrs x21, tpidr_el0
- true: pos=3558 off=0x12dd20 ldr x8, [x21, #0x28]
- ... 23 more

Unidbg skipped before resync:
- none

## Divergence #34
matched_before=370
- true: pos=3584 off=0x33880 adrp x16, #0x7102e80000
- unidbg: seq=35190 off=0x47a18 size=4
- resync: offset=0x47a18 true_ahead=15 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c37880!0x33880 adrp x16, #0x7102e80000; x16=0x239590b38c8000 -> x16=0x7102e80000 `
- unidbg_raw: `35190 0x47a18 4`

True-device skipped before resync:
- true: pos=3584 off=0x33880 adrp x16, #0x7102e80000
- true: pos=3585 off=0x33884 ldr x17, [x16, #0x8c8]
- true: pos=3586 off=0x33888 add x16, x16, #0x8c8
- true: pos=3587 off=0x3388c br x17
- true: pos=3590 off=0x12de10 str w0, [x19, #8]
- true: pos=3591 off=0x12de14 ldr x8, [x21, #0x28]
- true: pos=3592 off=0x12de18 ldr x9, [sp, #0x18]
- true: pos=3593 off=0x12de1c cmp x8, x9
- ... 7 more

Unidbg skipped before resync:
- none

## Divergence #35
matched_before=387
- true: pos=3618 off=0x12de7c ldr w8, [x0, #8]
- unidbg: seq=35207 off=0x47a28 size=4
- resync: offset=0x47a28 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d31e7c!0x12de7c ldr w8, [x0, #8]; w8=0x1 x0=0x7106ee60a0 mem_r=0x7106ee60a8 -> w8=0x0 `
- unidbg_raw: `35207 0x47a28 4`

True-device skipped before resync:
- true: pos=3618 off=0x12de7c ldr w8, [x0, #8]
- true: pos=3619 off=0x12de80 adrp x9, #0x7102e74000
- true: pos=3620 off=0x12de84 add x9, x9, #0x7b8
- true: pos=3621 off=0x12de88 str x9, [x0]
- true: pos=3622 off=0x12de8c cbz w8, #0x7102d31e94
- true: pos=3623 off=0x12de94 ldr x8, [x0, #0x10]
- true: pos=3624 off=0x12de98 adrp x9, #0x7102ec7000
- true: pos=3625 off=0x12de9c ldr x9, [x9, #0x438]
- ... 9 more

Unidbg skipped before resync:
- none

## Divergence #36
matched_before=408
- true: pos=3658 off=0x10b764 str x19, [sp, #-0x20]!
- unidbg: seq=35228 off=0x149db0 size=4
- resync: offset=0x149db0 true_ahead=21 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d0f764!0x10b764 str x19, [sp, #-0x20]!; x19=0x7106ee6768 sp=0x7106ee6140 mem_w=0x7106ee6120 -> sp=0x7106ee6120 `
- unidbg_raw: `35228 0x149db0 4`

True-device skipped before resync:
- true: pos=3658 off=0x10b764 str x19, [sp, #-0x20]!
- true: pos=3659 off=0x10b768 stp x29, x30, [sp, #0x10]
- true: pos=3660 off=0x10b76c add x29, sp, #0x10
- true: pos=3661 off=0x10b770 mov x19, x0
- true: pos=3662 off=0x10b774 ldr x0, [x0, #0x10]
- true: pos=3663 off=0x10b778 adrp x8, #0x7102e66000
- true: pos=3664 off=0x10b77c add x8, x8, #0xaf0
- true: pos=3665 off=0x10b780 str x8, [x19]
- ... 13 more

Unidbg skipped before resync:
- none

## Divergence #37
matched_before=419
- true: pos=3695 off=0x12cf90 sub sp, sp, #0x90
- unidbg: seq=35239 off=0x149ddc size=4
- resync: offset=0x149ddc true_ahead=550 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d30f90!0x12cf90 sub sp, sp, #0x90; sp=0x7106ee6140 sp=0x7106ee6140 -> sp=0x7106ee60b0 `
- unidbg_raw: `35239 0x149ddc 4`

True-device skipped before resync:
- true: pos=3695 off=0x12cf90 sub sp, sp, #0x90
- true: pos=3696 off=0x12cf94 str x19, [sp, #0x70]
- true: pos=3697 off=0x12cf98 stp x29, x30, [sp, #0x80]
- true: pos=3698 off=0x12cf9c add x29, sp, #0x80
- true: pos=3699 off=0x12cfa0 mrs x8, tpidr_el0
- true: pos=3700 off=0x12cfa4 ldr x8, [x8, #0x28]
- true: pos=3701 off=0x12cfa8 stur x8, [x29, #-0x18]
- true: pos=3702 off=0x12cfac str x0, [sp, #0x40]
- ... 542 more

Unidbg skipped before resync:
- none

## Divergence #38
matched_before=1960
- true: pos=5790 off=0x137970 ldrb w9, [x8, #1]!
- unidbg: seq=36780 off=0x137978 size=4
- resync: offset=0x137970 true_ahead=0 unidbg_ahead=7
- true_raw: `[libmetasec_ml.so] 0x7102d3b970!0x137970 ldrb w9, [x8, #1]!; w9=0x26 x8=0x7367417e8a mem_r=0x7367417e8b -> w9=0x69 x8=0x7367417e8b `
- unidbg_raw: `36780 0x137978 4`

True-device skipped before resync:
- none

Unidbg skipped before resync:
- unidbg: seq=36780 off=0x137978 size=4
- unidbg: seq=36781 off=0x13797c size=4
- unidbg: seq=36782 off=0x63ce8 size=4
- unidbg: seq=36783 off=0x63cec size=4
- unidbg: seq=36784 off=0x63cf0 size=4
- unidbg: seq=36785 off=0x137968 size=4
- unidbg: seq=36786 off=0x13796c size=4

## Divergence #39
matched_before=1970
- true: pos=5800 off=0x137970 ldrb w9, [x8, #1]!
- unidbg: seq=36797 off=0x137978 size=4
- resync: offset=0x137978 true_ahead=138 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102d3b970!0x137970 ldrb w9, [x8, #1]!; w9=0x6e x8=0x7367417e8f mem_r=0x7367417e90 -> w9=0x64 x8=0x7367417e90 `
- unidbg_raw: `36797 0x137978 4`

True-device skipped before resync:
- true: pos=5800 off=0x137970 ldrb w9, [x8, #1]!
- true: pos=5801 off=0x137974 cbnz w9, #0x7102d3b970
- true: pos=5802 off=0x137970 ldrb w9, [x8, #1]!
- true: pos=5803 off=0x137974 cbnz w9, #0x7102d3b970
- true: pos=5804 off=0x137970 ldrb w9, [x8, #1]!
- true: pos=5805 off=0x137974 cbnz w9, #0x7102d3b970
- true: pos=5806 off=0x137970 ldrb w9, [x8, #1]!
- true: pos=5807 off=0x137974 cbnz w9, #0x7102d3b970
- ... 130 more

Unidbg skipped before resync:
- none

## Divergence #40
matched_before=1972
- true: pos=5940 off=0x63ce8 mov x21, x0
- unidbg: seq=36799 off=0x63cf4 size=4
- resync: offset=0x63cf4 true_ahead=17 unidbg_ahead=0
- true_raw: `[libmetasec_ml.so] 0x7102c67ce8!0x63ce8 mov x21, x0; x21=0x1 x0=0x344 -> x21=0x344 `
- unidbg_raw: `36799 0x63cf4 4`

True-device skipped before resync:
- true: pos=5940 off=0x63ce8 mov x21, x0
- true: pos=5941 off=0x63cec mov x0, x20
- true: pos=5942 off=0x63cf0 bl #0x7102d3b968
- true: pos=5943 off=0x137968 cbz x0, #0x7102d3b97c
- true: pos=5944 off=0x13796c sub x8, x0, #1
- true: pos=5945 off=0x137970 ldrb w9, [x8, #1]!
- true: pos=5946 off=0x137974 cbnz w9, #0x7102d3b970
- true: pos=5947 off=0x137970 ldrb w9, [x8, #1]!
- ... 9 more

Unidbg skipped before resync:
- none


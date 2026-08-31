# MetaSec instruction sequence diff

gum=dyidre/_archive/large_raw_traces/gumtrace_getHttpHeadVerify_350.log
seq=unidbg/unidbg-android/target/sign6_350101_rootfs_instrseq_unicorn2_20260831_143310.seq
sync_offset=0x149cbc
gum_skipped_before_sync=0
seq_skipped_before_sync=34815
matched_after_sync=45

## Matched context before divergence
- -24 off=0x149d10 true_pos=22 seq_pos=34837 true=ldur q0, [x22, #6]
- -23 off=0x149d14 true_pos=23 seq_pos=34838 true=sturb w9, [x29, #-0xcc]
- -22 off=0x149d18 true_pos=24 seq_pos=34839 true=stur w8, [x29, #-0xd0]
- -21 off=0x149d1c true_pos=25 seq_pos=34840 true=mov w8, #0x9023
- -20 off=0x149d20 true_pos=26 seq_pos=34841 true=mov w9, #0x64cd
- -19 off=0x149d24 true_pos=27 seq_pos=34842 true=mov x25, x3
- -18 off=0x149d28 true_pos=28 seq_pos=34843 true=movk w9, #0xb705, lsl #16
- -17 off=0x149d2c true_pos=29 seq_pos=34844 true=stur q0, [x29, #-0x30]
- -16 off=0x149d30 true_pos=30 seq_pos=34845 true=sturh w8, [x29, #-0xd4]
- -15 off=0x149d34 true_pos=31 seq_pos=34846 true=ldur w8, [x22, #0x15]
- -14 off=0x149d38 true_pos=32 seq_pos=34847 true=mov x20, x2
- -13 off=0x149d3c true_pos=33 seq_pos=34848 true=mov x23, x1
- -12 off=0x149d40 true_pos=34 seq_pos=34849 true=mov x28, x0
- -11 off=0x149d44 true_pos=35 seq_pos=34850 true=stur w9, [x29, #-0xd8]
- -10 off=0x149d48 true_pos=36 seq_pos=34851 true=stur w8, [x10, #0x9f]
- -09 off=0x149d4c true_pos=37 seq_pos=34852 true=add x8, sp, #0x138
- -08 off=0x149d50 true_pos=38 seq_pos=34853 true=bl #0x7102d24000
- -07 off=0x120000 true_pos=39 seq_pos=34854 true=sub sp, sp, #0x40
- -06 off=0x120004 true_pos=40 seq_pos=34855 true=stp x20, x19, [sp, #0x20]
- -05 off=0x120008 true_pos=41 seq_pos=34856 true=stp x29, x30, [sp, #0x30]
- -04 off=0x12000c true_pos=42 seq_pos=34857 true=add x29, sp, #0x30
- -03 off=0x120010 true_pos=43 seq_pos=34858 true=mov w0, #0x28
- -02 off=0x120014 true_pos=44 seq_pos=34859 true=mov x19, x8
- -01 off=0x120018 true_pos=45 seq_pos=34860 true=bl #0x7102dc6edc

## First divergence
kind=offset
- true: pos=46 off=0x1c2edc insn=str x19, [sp, #-0x20]!
  raw: `[libmetasec_ml.so] 0x7102dc6edc!0x1c2edc str x19, [sp, #-0x20]!; x19=0x7106ee6278 sp=0x7106ee6100 mem_w=0x7106ee60e0 -> sp=0x7106ee60e0 `
- unidbg: seq=34861 line=34863 off=0x12001c size=4
  raw: `34861 0x12001c 4`

## Resync search
window=512
- nearest common offset=0x12001c, true_ahead=15, unidbg_ahead=0

## True-device next window
- pos=46 off=0x1c2edc str x19, [sp, #-0x20]!
- pos=47 off=0x1c2ee0 stp x29, x30, [sp, #0x10]
- pos=48 off=0x1c2ee4 add x29, sp, #0x10
- pos=49 off=0x1c2ee8 cmp x0, #0
- pos=50 off=0x1c2eec csinc x19, x0, xzr, ne
- pos=51 off=0x1c2ef0 mov x0, x19
- pos=52 off=0x1c2ef4 bl #0x7102c370c0
- pos=53 off=0x330c0 adrp x16, #0x7102e80000
- pos=54 off=0x330c4 ldr x17, [x16, #0x4e8]
- pos=55 off=0x330c8 add x16, x16, #0x4e8
- pos=56 off=0x330cc br x17
- pos=59 off=0x1c2ef8 cbnz x0, #0x7102dc6f0c
- pos=60 off=0x1c2f0c ldp x29, x30, [sp, #0x10]
- pos=61 off=0x1c2f10 ldr x19, [sp], #0x20
- pos=62 off=0x1c2f14 ret
- pos=63 off=0x12001c adrp x8, #0x7102c5b000
- pos=64 off=0x120020 add x8, x8, #0x9f4
- pos=65 off=0x120024 adrp x9, #0x7102c5b000
- pos=66 off=0x120028 add x9, x9, #0xa5c
- pos=67 off=0x12002c dup v0.2d, x8
- pos=68 off=0x120030 mov x1, sp
- pos=69 off=0x120034 mov x20, x0
- pos=70 off=0x120038 str q0, [sp]
- pos=71 off=0x12003c str x9, [sp, #0x10]

## Unidbg next window
- seq=34861 off=0x12001c size=4
- seq=34862 off=0x120020 size=4
- seq=34863 off=0x120024 size=4
- seq=34864 off=0x120028 size=4
- seq=34865 off=0x12002c size=4
- seq=34866 off=0x120030 size=4
- seq=34867 off=0x120034 size=4
- seq=34868 off=0x120038 size=4
- seq=34869 off=0x12003c size=4
- seq=34870 off=0x120040 size=4
- seq=34871 off=0x120044 size=4
- seq=34872 off=0x120048 size=4
- seq=34873 off=0x12004c size=4
- seq=34874 off=0x120050 size=4
- seq=34875 off=0x120054 size=4
- seq=34876 off=0x120058 size=4
- seq=34877 off=0x490a0 size=4
- seq=34878 off=0x490a4 size=4
- seq=34879 off=0x490a8 size=4
- seq=34880 off=0x490ac size=4
- seq=34881 off=0x490b0 size=4
- seq=34882 off=0x490b4 size=4
- seq=34883 off=0x490b8 size=4
- seq=34884 off=0x490bc size=4

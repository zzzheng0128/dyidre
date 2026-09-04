; MetaSec managed bytecode decode: F6
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F6_0xfffffffffffe9a00_0x258.bin
; records: 25  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d c0 ff  ADD64_IMM16      s29 = s29 -0x40
0001  +0x00018  op=25  1d 1f 38 00  ST64             *(s29 +0x38) = s31
0002  +0x00030  op=25  1d 1e 30 00  ST64             *(s29 +0x30) = s30
0003  +0x00048  op=25  1d 11 28 00  ST64             *(s29 +0x28) = s17
0004  +0x00060  op=25  1d 10 20 00  ST64             *(s29 +0x20) = s16
0005  +0x00078  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
0006  +0x00090  op=52  05 01 0c 00  LD32S            s1 = *(int32_t *)(s5 +0xc)
0007  +0x000a8  op=34  04 00 10 00  OR64             s16 = s4 | s0
0008  +0x000c0  op=58  05 04 10 00  LD64             s4 = *(uint64_t *)(s5 +0x10)
0009  +0x000d8  op=85  1e 11 00 00  ADD64_IMM16      s17 = s30 +0x0
000a  +0x000f0  op=34  11 00 06 01  OR64             s6 = s17 | s0
000b  +0x00108  op=34  01 00 05 00  OR64             s5 = s1 | s0
000c  +0x00120  op=5e  30 00 00 00  CALL_CF_INDEX    call native_binding[index=0x30] via q1 table ; q1=0x1235f600 rt/so-mapped
000d  +0x00138  op=85  00 06 20 00  ADD64_IMM16      s6 = s0 +0x20
000e  +0x00150  op=34  10 00 04 00  OR64             s4 = s16 | s0
000f  +0x00168  op=34  11 00 05 00  OR64             s5 = s17 | s0
0010  +0x00180  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x1235f600 rt/so-mapped
0011  +0x00198  op=34  10 00 02 00  OR64             s2 = s16 | s0
0012  +0x001b0  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0013  +0x001c8  op=58  1d 10 20 00  LD64             s16 = *(uint64_t *)(s29 +0x20)
0014  +0x001e0  op=58  1d 11 28 00  LD64             s17 = *(uint64_t *)(s29 +0x28)
0015  +0x001f8  op=58  1d 1e 30 00  LD64             s30 = *(uint64_t *)(s29 +0x30)
0016  +0x00210  op=58  1d 1f 38 00  LD64             s31 = *(uint64_t *)(s29 +0x38)
0017  +0x00228  op=85  1d 1d 40 00  ADD64_IMM16      s29 = s29 +0x40
0018  +0x00240  op=5b  1f 00 00 00  RET              return/leave with s31

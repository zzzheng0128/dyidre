; MetaSec managed bytecode decode: F0
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f0_f1_f2_20260904/350101_F0_0x30dc00_0x2d0.bin
; records: 30  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d d0 ff  ADD64_IMM16      s29 = s29 -0x30 ; q1=0x6c622801001f1d3f
0001  +0x00018  op=25  1d 1f 28 00  ST64             *(s29 +0x28) = s31 ; q1=0x180100171d1a
0002  +0x00030  op=25  1d 1e 20 00  ST64             *(s29 +0x20) = s30 ; q1=0x80100151d1a
0003  +0x00048  op=25  1d 12 18 00  ST64             *(s29 +0x18) = s18 ; q1=0x380000131d1a
0004  +0x00060  op=25  1d 11 10 00  ST64             *(s29 +0x10) = s17 ; q1=0x280000111d3f
0005  +0x00078  op=25  1d 10 08 00  ST64             *(s29 +0x8) = s16 ; q1=0x2f011e001d3e
0006  +0x00090  op=34  1d 00 1e 01  OR64             s30 = s29 | s0 ; q1=0x10000020419
0007  +0x000a8  op=ae  04 00 0e 00  BR_EQ64          if (s4 == s0) goto record +22 ; q1=0x10000004001d
0008  +0x000c0  op=34  06 00 11 00  OR64             s17 = s6 | s0 ; q1=0xc0000040336
0009  +0x000d8  op=ae  06 00 0c 00  BR_EQ64          if (s6 == s0) goto record +22 ; q1=0x40103162c
000a  +0x000f0  op=34  05 00 10 01  OR64             s16 = s5 | s0 ; q1=0x3f1f1f060524
000b  +0x00108  op=52  04 05 0c 00  LD32S            s5 = *(int32_t *)(s4 +0xc) ; q1=0x60524
000c  +0x00120  op=34  04 00 12 01  OR64             s18 = s4 | s0 ; q1=0x10000060524
000d  +0x00138  op=85  00 06 20 00  ADD64_IMM16      s6 = s0 +0x20 ; q1=0x20000050524
000e  +0x00150  op=34  10 00 04 00  OR64             s4 = s16 | s0 ; q1=0x341f1f040305
000f  +0x00168  op=5e  00 00 00 00  CALL_CF_INDEX    call native_binding[index=0x0] via q1 table ; q1=0x1235f600 rt/so-mapped
0010  +0x00180  op=52  12 06 0c 00  LD32S            s6 = *(int32_t *)(s18 +0xc) ; q1=0x180000171104
0011  +0x00198  op=52  11 08 0c 00  LD32S            s8 = *(int32_t *)(s17 +0xc) ; q1=0x20000040019
0012  +0x001b0  op=58  11 07 10 00  LD64             s7 = *(uint64_t *)(s17 +0x10) ; q1=0xb0200000003
0013  +0x001c8  op=58  12 05 10 00  LD64             s5 = *(uint64_t *)(s18 +0x10) ; q1=0x3000004001d
0014  +0x001e0  op=58  10 04 10 00  LD64             s4 = *(uint64_t *)(s16 +0x10) ; q1=0xb0200000003
0015  +0x001f8  op=5e  01 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1] via q1 table ; q1=0x1235f600 rt/so-mapped
0016  +0x00210  op=34  1e 00 1d 00  OR64             s29 = s30 | s0 ; q1=0xb0200000014
0017  +0x00228  op=58  1d 10 08 00  LD64             s16 = *(uint64_t *)(s29 +0x8) ; q1=0xc0000051220
0018  +0x00240  op=58  1d 11 10 00  LD64             s17 = *(uint64_t *)(s29 +0x10) ; q1=0x1f010400132c
0019  +0x00258  op=58  1d 12 18 00  LD64             s18 = *(uint64_t *)(s29 +0x18) ; q1=0x2d010114152c
001a  +0x00270  op=58  1d 1e 20 00  LD64             s30 = *(uint64_t *)(s29 +0x20) ; q1=0xb0200000012
001b  +0x00288  op=58  1d 1f 28 00  LD64             s31 = *(uint64_t *)(s29 +0x28) ; q1=0x11128
001c  +0x002a0  op=85  1d 1d 30 00  ADD64_IMM16      s29 = s29 +0x30 ; q1=0x281f1f171105
001d  +0x002b8  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x3000013001d

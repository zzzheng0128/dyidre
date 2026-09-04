; MetaSec managed bytecode decode: F14
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F14_0x609900_0x498.bin
; records: 49  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 50 ff  ADD64_IMM16      s29 = s29 -0xb0
0001  +0x00018  op=25  1d 1f a8 00  ST64             *(s29 +0xa8) = s31
0002  +0x00030  op=25  1d 1e a0 00  ST64             *(s29 +0xa0) = s30
0003  +0x00048  op=25  1d 16 98 00  ST64             *(s29 +0x98) = s22
0004  +0x00060  op=25  1d 15 90 00  ST64             *(s29 +0x90) = s21
0005  +0x00078  op=25  1d 14 88 00  ST64             *(s29 +0x88) = s20
0006  +0x00090  op=25  1d 13 80 00  ST64             *(s29 +0x80) = s19
0007  +0x000a8  op=25  1d 12 78 00  ST64             *(s29 +0x78) = s18
0008  +0x000c0  op=25  1d 11 70 00  ST64             *(s29 +0x70) = s17
0009  +0x000d8  op=25  1d 10 68 00  ST64             *(s29 +0x68) = s16
000a  +0x000f0  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000b  +0x00108  op=85  1e 10 08 00  ADD64_IMM16      s16 = s30 +0x8
000c  +0x00120  op=85  00 11 00 00  ADD64_IMM16      s17 = s0 +0x0
000d  +0x00138  op=85  00 12 60 00  ADD64_IMM16      s18 = s0 +0x60
000e  +0x00150  op=34  06 00 14 01  OR64             s20 = s6 | s0
000f  +0x00168  op=34  05 00 15 00  OR64             s21 = s5 | s0
0010  +0x00180  op=34  04 00 16 01  OR64             s22 = s4 | s0
0011  +0x00198  op=34  07 00 13 01  OR64             s19 = s7 | s0
0012  +0x001b0  op=34  10 00 04 01  OR64             s4 = s16 | s0
0013  +0x001c8  op=34  11 00 05 01  OR64             s5 = s17 | s0
0014  +0x001e0  op=34  12 00 06 01  OR64             s6 = s18 | s0
0015  +0x001f8  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd360 rt/so-mapped
0016  +0x00210  op=34  10 00 04 01  OR64             s4 = s16 | s0
0017  +0x00228  op=25  1e 14 60 00  ST64             *(s30 +0x60) = s20
0018  +0x00240  op=5e  47 00 00 00  CALL_CF_INDEX    call native_binding[index=0x47] via q1 table ; q1=0x125fd360 rt/so-mapped
0019  +0x00258  op=34  10 00 04 01  OR64             s4 = s16 | s0
001a  +0x00270  op=34  16 00 05 01  OR64             s5 = s22 | s0
001b  +0x00288  op=34  15 00 06 01  OR64             s6 = s21 | s0
001c  +0x002a0  op=5e  48 00 00 00  CALL_CF_INDEX    call native_binding[index=0x48] via q1 table ; q1=0x125fd360 rt/so-mapped
001d  +0x002b8  op=34  10 00 04 01  OR64             s4 = s16 | s0
001e  +0x002d0  op=34  13 00 05 01  OR64             s5 = s19 | s0
001f  +0x002e8  op=5e  49 00 00 00  CALL_CF_INDEX    call native_binding[index=0x49] via q1 table ; q1=0x125fd360 rt/so-mapped
0020  +0x00300  op=ae  11 12 04 00  BR_EQ64          if (s17 == s18) goto record +37
0021  +0x00318  op=84  10 11 01 14  ADD64            s1 = s16 + s17
0022  +0x00330  op=85  11 11 01 00  ADD64_IMM16      s17 = s17 +0x1
0023  +0x00348  op=26  01 00 00 00  ST8              *(s1 +0x0) = (uint8_t)s0
0024  +0x00360  op=a7  11 12 fc ff  BR_NE64          if (s17 != s18) goto record +33
0025  +0x00378  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0026  +0x00390  op=58  1d 10 68 00  LD64             s16 = *(uint64_t *)(s29 +0x68)
0027  +0x003a8  op=58  1d 11 70 00  LD64             s17 = *(uint64_t *)(s29 +0x70)
0028  +0x003c0  op=58  1d 12 78 00  LD64             s18 = *(uint64_t *)(s29 +0x78)
0029  +0x003d8  op=58  1d 13 80 00  LD64             s19 = *(uint64_t *)(s29 +0x80)
002a  +0x003f0  op=58  1d 14 88 00  LD64             s20 = *(uint64_t *)(s29 +0x88)
002b  +0x00408  op=58  1d 15 90 00  LD64             s21 = *(uint64_t *)(s29 +0x90)
002c  +0x00420  op=58  1d 16 98 00  LD64             s22 = *(uint64_t *)(s29 +0x98)
002d  +0x00438  op=58  1d 1e a0 00  LD64             s30 = *(uint64_t *)(s29 +0xa0)
002e  +0x00450  op=58  1d 1f a8 00  LD64             s31 = *(uint64_t *)(s29 +0xa8)
002f  +0x00468  op=85  1d 1d b0 00  ADD64_IMM16      s29 = s29 +0xb0
0030  +0x00480  op=5b  1f 00 00 00  RET              return/leave with s31

; MetaSec managed bytecode decode: F32
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/unidbg-android/target/managed_program_f32_family_350101_20260831_045757/350101_F32_0x62e800_0x648.bin
; records: 67  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d b0 ff  ADD64_IMM16      s29 = s29 -0x50
0001  +0x00018  op=25  1d 1f 48 00  ST64             *(s29 +0x48) = s31
0002  +0x00030  op=25  1d 1e 40 00  ST64             *(s29 +0x40) = s30
0003  +0x00048  op=25  1d 17 38 00  ST64             *(s29 +0x38) = s23
0004  +0x00060  op=25  1d 16 30 00  ST64             *(s29 +0x30) = s22
0005  +0x00078  op=25  1d 15 28 00  ST64             *(s29 +0x28) = s21
0006  +0x00090  op=25  1d 14 20 00  ST64             *(s29 +0x20) = s20
0007  +0x000a8  op=25  1d 13 18 00  ST64             *(s29 +0x18) = s19
0008  +0x000c0  op=25  1d 12 10 00  ST64             *(s29 +0x10) = s18
0009  +0x000d8  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17
000a  +0x000f0  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
000b  +0x00108  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
000c  +0x00120  op=85  04 13 b0 00  ADD64_IMM16      s19 = s4 +0xb0
000d  +0x00138  op=85  00 15 00 00  ADD64_IMM16      s21 = s0 +0x0
000e  +0x00150  op=34  06 00 10 00  OR64             s16 = s6 | s0
000f  +0x00168  op=34  04 00 11 01  OR64             s17 = s4 | s0
0010  +0x00180  op=85  04 14 10 00  ADD64_IMM16      s20 = s4 +0x10
0011  +0x00198  op=85  00 16 10 00  ADD64_IMM16      s22 = s0 +0x10
0012  +0x001b0  op=34  15 00 17 01  OR64             s23 = s21 | s0
0013  +0x001c8  op=34  13 00 02 00  OR64             s2 = s19 | s0
0014  +0x001e0  op=13  17 10 01 0f  CMP_LO64         s1 = ((uint64_t)s23 < (uint64_t)s16) ? 1 : 0
0015  +0x001f8  op=ae  01 00 1c 00  BR_EQ64          if (s1 == s0) goto record +50
0016  +0x00210  op=34  05 00 12 00  OR64             s18 = s5 | s0
0017  +0x00228  op=34  15 00 03 01  OR64             s3 = s21 | s0
0018  +0x00240  op=ae  03 16 08 00  BR_EQ64          if (s3 == s22) goto record +33
0019  +0x00258  op=84  02 03 05 04  ADD64            s5 = s2 + s3
001a  +0x00270  op=84  12 03 01 14  ADD64            s1 = s18 + s3
001b  +0x00288  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1
001c  +0x002a0  op=59  01 04 00 00  LD8U             s4 = *(uint8_t *)(s1 +0x0)
001d  +0x002b8  op=59  05 05 00 00  LD8U             s5 = *(uint8_t *)(s5 +0x0)
001e  +0x002d0  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
001f  +0x002e8  op=26  01 04 00 00  ST8              *(s1 +0x0) = (uint8_t)s4
0020  +0x00300  op=a7  03 16 f8 ff  BR_NE64          if (s3 != s22) goto record +25
0021  +0x00318  op=34  12 00 04 00  OR64             s4 = s18 | s0
0022  +0x00330  op=34  11 00 05 01  OR64             s5 = s17 | s0
0023  +0x00348  op=5e  8d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0024  +0x00360  op=34  15 00 02 01  OR64             s2 = s21 | s0
0025  +0x00378  op=ae  02 16 08 00  BR_EQ64          if (s2 == s22) goto record +46
0026  +0x00390  op=84  14 02 04 00  ADD64            s4 = s20 + s2
0027  +0x003a8  op=84  12 02 01 04  ADD64            s1 = s18 + s2
0028  +0x003c0  op=85  02 02 01 00  ADD64_IMM16      s2 = s2 +0x1
0029  +0x003d8  op=59  01 03 00 00  LD8U             s3 = *(uint8_t *)(s1 +0x0)
002a  +0x003f0  op=59  04 04 00 00  LD8U             s4 = *(uint8_t *)(s4 +0x0)
002b  +0x00408  op=02  04 03 03 01  XOR64            s3 = s3 ^ s4
002c  +0x00420  op=26  01 03 00 00  ST8              *(s1 +0x0) = (uint8_t)s3
002d  +0x00438  op=a7  02 16 f8 ff  BR_NE64          if (s2 != s22) goto record +38
002e  +0x00450  op=85  17 17 10 00  ADD64_IMM16      s23 = s23 +0x10
002f  +0x00468  op=85  12 05 10 00  ADD64_IMM16      s5 = s18 +0x10
0030  +0x00480  op=34  12 00 02 01  OR64             s2 = s18 | s0
0031  +0x00498  op=5f  e2 ff ff ff  ADD_PC_IMM32     goto record +20 ; vm_pc = current_pc + 1 + -30
0032  +0x004b0  op=58  02 01 00 00  LD64             s1 = *(uint64_t *)(s2 +0x0)
0033  +0x004c8  op=58  02 02 08 00  LD64             s2 = *(uint64_t *)(s2 +0x8)
0034  +0x004e0  op=25  13 02 08 00  ST64             *(s19 +0x8) = s2
0035  +0x004f8  op=25  13 01 00 00  ST64             *(s19 +0x0) = s1
0036  +0x00510  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0037  +0x00528  op=58  1d 10 00 00  LD64             s16 = *(uint64_t *)(s29 +0x0)
0038  +0x00540  op=58  1d 11 08 00  LD64             s17 = *(uint64_t *)(s29 +0x8)
0039  +0x00558  op=58  1d 12 10 00  LD64             s18 = *(uint64_t *)(s29 +0x10)
003a  +0x00570  op=58  1d 13 18 00  LD64             s19 = *(uint64_t *)(s29 +0x18)
003b  +0x00588  op=58  1d 14 20 00  LD64             s20 = *(uint64_t *)(s29 +0x20)
003c  +0x005a0  op=58  1d 15 28 00  LD64             s21 = *(uint64_t *)(s29 +0x28)
003d  +0x005b8  op=58  1d 16 30 00  LD64             s22 = *(uint64_t *)(s29 +0x30)
003e  +0x005d0  op=58  1d 17 38 00  LD64             s23 = *(uint64_t *)(s29 +0x38)
003f  +0x005e8  op=58  1d 1e 40 00  LD64             s30 = *(uint64_t *)(s29 +0x40)
0040  +0x00600  op=58  1d 1f 48 00  LD64             s31 = *(uint64_t *)(s29 +0x48)
0041  +0x00618  op=85  1d 1d 50 00  ADD64_IMM16      s29 = s29 +0x50
0042  +0x00630  op=5b  1f 00 00 00  RET              return/leave with s31

; MetaSec managed bytecode decode: F84
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F84_0x621800_0x840.bin
; records: 88  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d e0 ff  ADD64_IMM16      s29 = s29 -0x20
0001  +0x00018  op=25  1d 1f 18 00  ST64             *(s29 +0x18) = s31
0002  +0x00030  op=25  1d 1e 10 00  ST64             *(s29 +0x10) = s30
0003  +0x00048  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17
0004  +0x00060  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
0005  +0x00078  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
0006  +0x00090  op=52  04 03 60 00  LD32S            s3 = *(int32_t *)(s4 +0x60)
0007  +0x000a8  op=b5  00 02 80 00  ADD32_IMM16      s2 = int32(s0 +0x80)
0008  +0x000c0  op=34  04 00 10 00  OR64             s16 = s4 | s0
0009  +0x000d8  op=6d  00 03 01 00  SHL64_IMM32PLUS  s1 = s3 << (0 + 32)
000a  +0x000f0  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32)
000b  +0x00108  op=84  04 01 01 00  ADD64            s1 = s4 + s1
000c  +0x00120  op=26  01 02 00 00  ST8              *(s1 +0x0) = (uint8_t)s2
000d  +0x00138  op=b5  03 02 01 00  ADD32_IMM16      s2 = int32(s3 +0x1)
000e  +0x00150  op=14  02 01 21 00  CMP_LO_IMM64     s1 = ((uint64_t)s2 < (uint64_t)33) ? 1 : 0
000f  +0x00168  op=a7  01 00 0c 00  BR_NE64          if (s1 != s0) goto record +28
0010  +0x00180  op=6d  00 02 01 00  SHL64_IMM32PLUS  s1 = s2 << (0 + 32)
0011  +0x00198  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
0012  +0x001b0  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32)
0013  +0x001c8  op=84  10 01 04 14  ADD64            s4 = s16 + s1
0014  +0x001e0  op=b5  00 01 3f 00  ADD32_IMM16      s1 = int32(s0 +0x3f)
0015  +0x001f8  op=09  01 03 01 14  SUB32            s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s3)
0016  +0x00210  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
0017  +0x00228  op=67  00 01 06 00  LSR64_IMM32PLUS  s6 = (uint64_t)s1 >> (0 + 32)
0018  +0x00240  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0019  +0x00258  op=34  10 00 04 01  OR64             s4 = s16 | s0
001a  +0x00270  op=5e  6c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6c] via q1 table ; q1=0x125fd360 rt/so-mapped
001b  +0x00288  op=b5  00 02 00 00  ADD32_IMM16      s2 = int32(s0 +0x0)
001c  +0x002a0  op=6d  00 02 01 00  SHL64_IMM32PLUS  s1 = s2 << (0 + 32)
001d  +0x002b8  op=85  00 11 00 00  ADD64_IMM16      s17 = s0 +0x0
001e  +0x002d0  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32)
001f  +0x002e8  op=34  11 00 05 01  OR64             s5 = s17 | s0
0020  +0x00300  op=84  10 01 04 00  ADD64            s4 = s16 + s1
0021  +0x00318  op=b5  00 01 20 00  ADD32_IMM16      s1 = int32(s0 +0x20)
0022  +0x00330  op=09  01 02 01 04  SUB32            s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s2)
0023  +0x00348  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
0024  +0x00360  op=67  00 01 06 00  LSR64_IMM32PLUS  s6 = (uint64_t)s1 >> (0 + 32)
0025  +0x00378  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0026  +0x00390  op=52  10 02 60 00  LD32S            s2 = *(int32_t *)(s16 +0x60)
0027  +0x003a8  op=58  10 01 58 00  LD64             s1 = *(uint64_t *)(s16 +0x58)
0028  +0x003c0  op=18  11 02 02 03  SHL32_IMM        s2 = (int32_t)(s2 << 3)
0029  +0x003d8  op=6d  00 02 02 00  SHL64_IMM32PLUS  s2 = s2 << (0 + 32)
002a  +0x003f0  op=67  00 02 02 00  LSR64_IMM32PLUS  s2 = (uint64_t)s2 >> (0 + 32)
002b  +0x00408  op=84  01 02 02 14  ADD64            s2 = s1 + s2
002c  +0x00420  op=13  02 01 01 0f  CMP_LO64         s1 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0
002d  +0x00438  op=25  10 02 58 00  ST64             *(s16 +0x58) = s2
002e  +0x00450  op=ae  01 00 0b 00  BR_EQ64          if (s1 == s0) goto record +58
002f  +0x00468  op=58  10 01 50 00  LD64             s1 = *(uint64_t *)(s16 +0x50)
0030  +0x00480  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
0031  +0x00498  op=25  10 01 50 00  ST64             *(s16 +0x50) = s1
0032  +0x004b0  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +58
0033  +0x004c8  op=58  10 01 48 00  LD64             s1 = *(uint64_t *)(s16 +0x48)
0034  +0x004e0  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
0035  +0x004f8  op=25  10 01 48 00  ST64             *(s16 +0x48) = s1
0036  +0x00510  op=a7  01 00 03 00  BR_NE64          if (s1 != s0) goto record +58
0037  +0x00528  op=58  10 01 40 00  LD64             s1 = *(uint64_t *)(s16 +0x40)
0038  +0x00540  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
0039  +0x00558  op=25  10 01 40 00  ST64             *(s16 +0x40) = s1
003a  +0x00570  op=85  00 02 20 00  ADD64_IMM16      s2 = s0 +0x20
003b  +0x00588  op=ae  11 02 13 00  BR_EQ64          if (s17 == s2) goto record +79
003c  +0x005a0  op=84  10 11 01 04  ADD64            s1 = s16 + s17
003d  +0x005b8  op=85  11 11 08 00  ADD64_IMM16      s17 = s17 +0x8
003e  +0x005d0  op=58  01 03 40 00  LD64             s3 = *(uint64_t *)(s1 +0x40)
003f  +0x005e8  op=67  00 03 04 00  LSR64_IMM32PLUS  s4 = (uint64_t)s3 >> (0 + 32)
0040  +0x00600  op=26  01 04 23 00  ST8              *(s1 +0x23) = (uint8_t)s4
0041  +0x00618  op=67  00 03 04 08  LSR64_IMM32PLUS  s4 = (uint64_t)s3 >> (8 + 32)
0042  +0x00630  op=26  01 04 22 00  ST8              *(s1 +0x22) = (uint8_t)s4
0043  +0x00648  op=67  00 03 04 10  LSR64_IMM32PLUS  s4 = (uint64_t)s3 >> (16 + 32)
0044  +0x00660  op=26  01 04 21 00  ST8              *(s1 +0x21) = (uint8_t)s4
0045  +0x00678  op=67  00 03 04 18  LSR64_IMM32PLUS  s4 = (uint64_t)s3 >> (24 + 32)
0046  +0x00690  op=26  01 04 20 00  ST8              *(s1 +0x20) = (uint8_t)s4
0047  +0x006a8  op=68  03 03 04 08  LSR64_IMM        s4 = (uint64_t)s3 >> 8
0048  +0x006c0  op=26  01 03 27 00  ST8              *(s1 +0x27) = (uint8_t)s3
0049  +0x006d8  op=26  01 04 26 00  ST8              *(s1 +0x26) = (uint8_t)s4
004a  +0x006f0  op=68  00 03 04 10  LSR64_IMM        s4 = (uint64_t)s3 >> 16
004b  +0x00708  op=68  00 03 03 18  LSR64_IMM        s3 = (uint64_t)s3 >> 24
004c  +0x00720  op=26  01 04 25 00  ST8              *(s1 +0x25) = (uint8_t)s4
004d  +0x00738  op=26  01 03 24 00  ST8              *(s1 +0x24) = (uint8_t)s3
004e  +0x00750  op=a7  11 02 ed ff  BR_NE64          if (s17 != s2) goto record +60
004f  +0x00768  op=34  10 00 04 01  OR64             s4 = s16 | s0
0050  +0x00780  op=5e  6c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6c] via q1 table ; q1=0x125fd360 rt/so-mapped
0051  +0x00798  op=34  1e 00 1d 00  OR64             s29 = s30 | s0
0052  +0x007b0  op=58  1d 10 00 00  LD64             s16 = *(uint64_t *)(s29 +0x0)
0053  +0x007c8  op=58  1d 11 08 00  LD64             s17 = *(uint64_t *)(s29 +0x8)
0054  +0x007e0  op=58  1d 1e 10 00  LD64             s30 = *(uint64_t *)(s29 +0x10)
0055  +0x007f8  op=58  1d 1f 18 00  LD64             s31 = *(uint64_t *)(s29 +0x18)
0056  +0x00810  op=85  1d 1d 20 00  ADD64_IMM16      s29 = s29 +0x20
0057  +0x00828  op=5b  1f 00 00 00  RET              return/leave with s31

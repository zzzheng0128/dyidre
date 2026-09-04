; MetaSec managed bytecode decode: F10
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F10_0x32ac00_0x990.bin
; records: 102  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d e0 ff  ADD64_IMM16      s29 = s29 -0x20
0001  +0x00018  op=25  1d 12 18 00  ST64             *(s29 +0x18) = s18
0002  +0x00030  op=25  1d 11 10 00  ST64             *(s29 +0x10) = s17
0003  +0x00048  op=25  1d 10 08 00  ST64             *(s29 +0x8) = s16
0004  +0x00060  op=18  00 05 02 00  SHL32_IMM        s2 = (int32_t)(s5 << 0)
0005  +0x00078  op=14  02 01 08 00  CMP_LO_IMM64     s1 = ((uint64_t)s2 < (uint64_t)8) ? 1 : 0
0006  +0x00090  op=ae  01 00 05 00  BR_EQ64          if (s1 == s0) goto record +12
0007  +0x000a8  op=58  1d 10 08 00  LD64             s16 = *(uint64_t *)(s29 +0x8)
0008  +0x000c0  op=58  1d 11 10 00  LD64             s17 = *(uint64_t *)(s29 +0x10)
0009  +0x000d8  op=58  1d 12 18 00  LD64             s18 = *(uint64_t *)(s29 +0x18)
000a  +0x000f0  op=85  1d 1d 20 00  ADD64_IMM16      s29 = s29 +0x20
000b  +0x00108  op=5b  1f 00 00 00  RET              return/leave with s31
000c  +0x00120  op=18  11 07 01 00  SHL32_IMM        s1 = (int32_t)(s7 << 0)
000d  +0x00138  op=b5  00 08 00 00  ADD32_IMM16      s8 = int32(s0 +0x0)
000e  +0x00150  op=b5  00 05 07 00  ADD32_IMM16      s5 = int32(s0 +0x7)
000f  +0x00168  op=b5  00 07 04 00  ADD32_IMM16      s7 = int32(s0 +0x4)
0010  +0x00180  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
0011  +0x00198  op=34  08 00 09 01  OR64             s9 = s8 | s0
0012  +0x001b0  op=67  00 01 03 00  LSR64_IMM32PLUS  s3 = (uint64_t)s1 >> (0 + 32)
0013  +0x001c8  op=ae  03 00 f3 ff  BR_EQ64          if (s3 == s0) goto record +7
0014  +0x001e0  op=6d  00 09 0a 00  SHL64_IMM32PLUS  s10 = s9 << (0 + 32)
0015  +0x001f8  op=b5  08 0b 01 00  ADD32_IMM16      s11 = int32(s8 +0x1)
0016  +0x00210  op=b5  09 01 10 00  ADD32_IMM16      s1 = int32(s9 +0x10)
0017  +0x00228  op=b5  08 10 04 00  ADD32_IMM16      s16 = int32(s8 +0x4)
0018  +0x00240  op=b5  08 0f 05 00  ADD32_IMM16      s15 = int32(s8 +0x5)
0019  +0x00258  op=b2  08 19 07 00  AND64_IMM16      s25 = s8 & 0x7
001a  +0x00270  op=b5  08 11 06 00  ADD32_IMM16      s17 = int32(s8 +0x6)
001b  +0x00288  op=b5  08 12 ff ff  ADD32_IMM16      s18 = int32(s8 -0x1)
001c  +0x002a0  op=67  00 0a 0a 00  LSR64_IMM32PLUS  s10 = (uint64_t)s10 >> (0 + 32)
001d  +0x002b8  op=b2  10 10 07 00  AND64_IMM16      s16 = s16 & 0x7
001e  +0x002d0  op=b2  0f 0f 07 00  AND64_IMM16      s15 = s15 & 0x7
001f  +0x002e8  op=33  19 19 38 00  OR_IMM16         s25 = s25 | 0x38
0020  +0x00300  op=b2  0b 18 07 00  AND64_IMM16      s24 = s11 & 0x7
0021  +0x00318  op=84  04 0a 0c 00  ADD64            s12 = s4 + s10
0022  +0x00330  op=13  02 01 0a 0f  CMP_LO64         s10 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0
0023  +0x00348  op=13  05 0b 01 0f  CMP_LO64         s1 = ((uint64_t)s5 < (uint64_t)s11) ? 1 : 0
0024  +0x00360  op=33  10 10 18 00  OR_IMM16         s16 = s16 | 0x18
0025  +0x00378  op=33  0f 0f 08 00  OR_IMM16         s15 = s15 | 0x8
0026  +0x00390  op=33  18 18 30 00  OR_IMM16         s24 = s24 | 0x30
0027  +0x003a8  op=18  00 01 01 01  SHL32_IMM        s1 = (int32_t)(s1 << 1)
0028  +0x003c0  op=1f  07 0a 0e 10  CMOVZ64          s14 = (s10 == 0) ? s7 : 0
0029  +0x003d8  op=1e  01 0a 0d 11  CMOVNZ64         s13 = (s10 != 0) ? s1 : 0
002a  +0x003f0  op=58  0c 01 00 00  LD64             s1 = *(uint64_t *)(s12 +0x0)
002b  +0x00408  op=b5  08 0c 02 00  ADD32_IMM16      s12 = int32(s8 +0x2)
002c  +0x00420  op=34  0d 0e 0d 01  OR64             s13 = s13 | s14
002d  +0x00438  op=b5  08 0e 03 00  ADD32_IMM16      s14 = int32(s8 +0x3)
002e  +0x00450  op=b2  0c 0c 07 00  AND64_IMM16      s12 = s12 & 0x7
002f  +0x00468  op=b2  0e 0e 07 00  AND64_IMM16      s14 = s14 & 0x7
0030  +0x00480  op=66  10 01 10 13  LSR64_VAR        s16 = (uint64_t)s1 >> (s16 & 63)
0031  +0x00498  op=66  0f 01 0f 00  LSR64_VAR        s15 = (uint64_t)s1 >> (s15 & 63)
0032  +0x004b0  op=66  18 01 18 13  LSR64_VAR        s24 = (uint64_t)s1 >> (s24 & 63)
0033  +0x004c8  op=33  0c 0c 20 00  OR_IMM16         s12 = s12 | 0x20
0034  +0x004e0  op=33  0d 0d 04 00  OR_IMM16         s13 = s13 | 0x4
0035  +0x004f8  op=33  0e 0e 10 00  OR_IMM16         s14 = s14 | 0x10
0036  +0x00510  op=18  10 10 10 00  SHL32_IMM        s16 = (int32_t)(s16 << 0)
0037  +0x00528  op=18  11 0f 0f 00  SHL32_IMM        s15 = (int32_t)(s15 << 0)
0038  +0x00540  op=66  0c 01 0c 00  LSR64_VAR        s12 = (uint64_t)s1 >> (s12 & 63)
0039  +0x00558  op=66  0e 01 0e 13  LSR64_VAR        s14 = (uint64_t)s1 >> (s14 & 63)
003a  +0x00570  op=18  11 10 10 06  SHL32_IMM        s16 = (int32_t)(s16 << 6)
003b  +0x00588  op=18  00 0f 0f 07  SHL32_IMM        s15 = (int32_t)(s15 << 7)
003c  +0x005a0  op=18  00 0c 0c 00  SHL32_IMM        s12 = (int32_t)(s12 << 0)
003d  +0x005b8  op=18  00 0e 0e 00  SHL32_IMM        s14 = (int32_t)(s14 << 0)
003e  +0x005d0  op=b2  10 10 40 00  AND64_IMM16      s16 = s16 & 0x40
003f  +0x005e8  op=18  00 0c 0c 02  SHL32_IMM        s12 = (int32_t)(s12 << 2)
0040  +0x00600  op=18  00 0e 0e 03  SHL32_IMM        s14 = (int32_t)(s14 << 3)
0041  +0x00618  op=34  10 0f 0f 01  OR64             s15 = s16 | s15
0042  +0x00630  op=b2  0c 0c 04 00  AND64_IMM16      s12 = s12 & 0x4
0043  +0x00648  op=b2  0e 0e 08 00  AND64_IMM16      s14 = s14 & 0x8
0044  +0x00660  op=34  0f 0e 0e 01  OR64             s14 = s15 | s14
0045  +0x00678  op=66  19 01 0f 00  LSR64_VAR        s15 = (uint64_t)s1 >> (s25 & 63)
0046  +0x00690  op=18  11 0f 0f 00  SHL32_IMM        s15 = (int32_t)(s15 << 0)
0047  +0x006a8  op=18  11 0f 0f 05  SHL32_IMM        s15 = (int32_t)(s15 << 5)
0048  +0x006c0  op=b2  0f 0f 20 00  AND64_IMM16      s15 = s15 & 0x20
0049  +0x006d8  op=34  0e 0f 0e 01  OR64             s14 = s14 | s15
004a  +0x006f0  op=18  11 18 0f 00  SHL32_IMM        s15 = (int32_t)(s24 << 0)
004b  +0x00708  op=18  10 0f 0f 04  SHL32_IMM        s15 = (int32_t)(s15 << 4)
004c  +0x00720  op=b2  0f 0f 10 00  AND64_IMM16      s15 = s15 & 0x10
004d  +0x00738  op=34  0e 0f 0e 01  OR64             s14 = s14 | s15
004e  +0x00750  op=b2  11 0f 07 00  AND64_IMM16      s15 = s17 & 0x7
004f  +0x00768  op=66  0f 01 0f 00  LSR64_VAR        s15 = (uint64_t)s1 >> (s15 & 63)
0050  +0x00780  op=18  10 0f 0f 00  SHL32_IMM        s15 = (int32_t)(s15 << 0)
0051  +0x00798  op=18  00 0f 0f 01  SHL32_IMM        s15 = (int32_t)(s15 << 1)
0052  +0x007b0  op=b2  0f 0f 02 00  AND64_IMM16      s15 = s15 & 0x2
0053  +0x007c8  op=34  0e 0f 0e 01  OR64             s14 = s14 | s15
0054  +0x007e0  op=b2  12 0f 07 00  AND64_IMM16      s15 = s18 & 0x7
0055  +0x007f8  op=33  0f 0f 28 00  OR_IMM16         s15 = s15 | 0x28
0056  +0x00810  op=66  0f 01 01 11  LSR64_VAR        s1 = (uint64_t)s1 >> (s15 & 63)
0057  +0x00828  op=18  11 01 01 00  SHL32_IMM        s1 = (int32_t)(s1 << 0)
0058  +0x00840  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
0059  +0x00858  op=34  0e 01 01 01  OR64             s1 = s14 | s1
005a  +0x00870  op=34  01 0c 01 01  OR64             s1 = s1 | s12
005b  +0x00888  op=26  06 01 00 00  ST8              *(s6 +0x0) = (uint8_t)s1
005c  +0x008a0  op=a7  0d 07 aa ff  BR_NE64          if (s13 != s7) goto record +7
005d  +0x008b8  op=b5  09 09 08 00  ADD32_IMM16      s9 = int32(s9 +0x8)
005e  +0x008d0  op=1f  08 0a 01 10  CMOVZ64          s1 = (s10 == 0) ? s8 : 0
005f  +0x008e8  op=1e  0b 0a 08 00  CMOVNZ64         s8 = (s10 != 0) ? s11 : 0
0060  +0x00900  op=85  03 03 ff ff  ADD64_IMM16      s3 = s3 -0x1
0061  +0x00918  op=85  06 06 01 00  ADD64_IMM16      s6 = s6 +0x1
0062  +0x00930  op=34  08 01 08 00  OR64             s8 = s8 | s1
0063  +0x00948  op=1f  09 0a 09 00  CMOVZ64          s9 = (s10 == 0) ? s9 : 0
0064  +0x00960  op=a7  03 00 af ff  BR_NE64          if (s3 != s0) goto record +20
0065  +0x00978  op=5f  a1 ff ff ff  ADD_PC_IMM32     goto record +7 ; vm_pc = current_pc + 1 + -95

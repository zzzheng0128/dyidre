; MetaSec managed bytecode decode: F12
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_f12_350101_20260831_035801/350101_F12_0x5d0000_0xf48.bin
; records: 163  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 80 ff  ADD64_IMM16      s29 = s29 -0x80
0001  +0x00018  op=25  1d 1f 78 00  ST64             *(s29 +0x78) = s31
0002  +0x00030  op=25  1d 1e 70 00  ST64             *(s29 +0x70) = s30 ; q1=0x766e6506
0003  +0x00048  op=25  1d 17 68 00  ST64             *(s29 +0x68) = s23 ; q1=0x30464306
0004  +0x00060  op=25  1d 16 60 00  ST64             *(s29 +0x60) = s22
0005  +0x00078  op=25  1d 15 58 00  ST64             *(s29 +0x58) = s21
0006  +0x00090  op=25  1d 14 50 00  ST64             *(s29 +0x50) = s20
0007  +0x000a8  op=25  1d 13 48 00  ST64             *(s29 +0x48) = s19 ; q1=0x100000002
0008  +0x000c0  op=25  1d 12 40 00  ST64             *(s29 +0x40) = s18
0009  +0x000d8  op=25  1d 11 38 00  ST64             *(s29 +0x38) = s17
000a  +0x000f0  op=25  1d 10 30 00  ST64             *(s29 +0x30) = s16 ; q1=0x766e6506
000b  +0x00108  op=18  10 05 08 00  SHL32_IMM        s8 = (int32_t)(s5 << 0) ; q1=0x7970636d656d0c
000c  +0x00120  op=14  08 01 08 00  CMP_LO_IMM64     s1 = ((uint64_t)s8 < (uint64_t)8) ? 1 : 0
000d  +0x00138  op=ae  01 00 02 00  BR_EQ64          if (s1 == s0) goto record +16
000e  +0x00150  op=b5  00 02 00 00  ADD32_IMM16      s2 = int32(s0 +0x0)
000f  +0x00168  op=5f  87 00 00 00  ADD_PC_IMM32     goto record +151 ; vm_pc = current_pc + 1 + 135 ; q1=0x400000005
0010  +0x00180  op=18  10 07 01 00  SHL32_IMM        s1 = (int32_t)(s7 << 0)
0011  +0x00198  op=b5  00 0b 00 00  ADD32_IMM16      s11 = int32(s0 +0x0)
0012  +0x001b0  op=85  00 09 01 00  ADD64_IMM16      s9 = s0 +0x1 ; q1=0x766e6506
0013  +0x001c8  op=25  1d 01 00 00  ST64             *(s29 +0x0) = s1 ; q1=0x3031464308
0014  +0x001e0  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
0015  +0x001f8  op=34  0b 00 03 01  OR64             s3 = s11 | s0
0016  +0x00210  op=34  0b 00 0c 01  OR64             s12 = s11 | s0
0017  +0x00228  op=25  1d 04 08 00  ST64             *(s29 +0x8) = s4 ; q1=0x700000005
0018  +0x00240  op=67  00 01 02 00  LSR64_IMM32PLUS  s2 = (uint64_t)s1 >> (0 + 32)
0019  +0x00258  op=ae  02 00 7a 00  BR_EQ64          if (s2 == s0) goto record +148
001a  +0x00270  op=59  06 0e 00 00  LD8U             s14 = *(uint8_t *)(s6 +0x0) ; q1=0x766e6506
001b  +0x00288  op=b5  0c 0f 05 00  ADD32_IMM16      s15 = int32(s12 +0x5) ; q1=0x3331464308
001c  +0x002a0  op=25  1d 06 18 00  ST64             *(s29 +0x18) = s6
001d  +0x002b8  op=08  1d 03 24 00  ST32             *(s29 +0x24) = (uint32_t)s3
001e  +0x002d0  op=25  1d 02 10 00  ST64             *(s29 +0x10) = s2
001f  +0x002e8  op=6d  00 0b 01 00  SHL64_IMM32PLUS  s1 = s11 << (0 + 32) ; q1=0xa00000008
0020  +0x00300  op=b5  0c 0d 04 00  ADD32_IMM16      s13 = int32(s12 +0x4)
0021  +0x00318  op=b5  0c 06 03 00  ADD32_IMM16      s6 = int32(s12 +0x3)
0022  +0x00330  op=b5  0c 17 02 00  ADD32_IMM16      s23 = int32(s12 +0x2) ; q1=0x766e6506
0023  +0x00348  op=b2  0c 1f 07 00  AND64_IMM16      s31 = s12 & 0x7 ; q1=0x38464306
0024  +0x00360  op=b5  0c 13 06 00  ADD32_IMM16      s19 = int32(s12 +0x6)
0025  +0x00378  op=b5  0c 12 ff ff  ADD32_IMM16      s18 = int32(s12 -0x1)
0026  +0x00390  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32)
0027  +0x003a8  op=b2  0f 0f 07 00  AND64_IMM16      s15 = s15 & 0x7 ; q1=0xd0000000a
0028  +0x003c0  op=b2  0d 0d 07 00  AND64_IMM16      s13 = s13 & 0x7
0029  +0x003d8  op=b2  06 06 07 00  AND64_IMM16      s6 = s6 & 0x7
002a  +0x003f0  op=b2  13 13 07 00  AND64_IMM16      s19 = s19 & 0x7 ; q1=0x766e6506
002b  +0x00408  op=b2  12 12 07 00  AND64_IMM16      s18 = s18 & 0x7 ; q1=0x3831464308
002c  +0x00420  op=84  04 01 01 00  ADD64            s1 = s4 + s1
002d  +0x00438  op=33  0f 0f 08 00  OR_IMM16         s15 = s15 | 0x8
002e  +0x00450  op=b2  0e 19 80 00  AND64_IMM16      s25 = s14 & 0x80
002f  +0x00468  op=0e  0d 0e 11 01  LSR32_IMM        s17 = sign_extend_32((uint32_t)s14 >> 1) ; q1=0x1000000008
0030  +0x00480  op=33  0d 14 18 00  OR_IMM16         s20 = s13 | 0x18
0031  +0x00498  op=0e  0d 0e 0d 02  LSR32_IMM        s13 = sign_extend_32((uint32_t)s14 >> 2)
0032  +0x004b0  op=0e  0b 0e 0a 06  LSR32_IMM        s10 = sign_extend_32((uint32_t)s14 >> 6) ; q1=0x766e6506
0033  +0x004c8  op=b2  0e 15 01 00  AND64_IMM16      s21 = s14 & 0x1 ; q1=0x3032464308
0034  +0x004e0  op=33  06 06 10 00  OR_IMM16         s6 = s6 | 0x10
0035  +0x004f8  op=33  12 12 28 00  OR_IMM16         s18 = s18 | 0x28
0036  +0x00510  op=b5  0b 04 10 00  ADD32_IMM16      s4 = int32(s11 +0x10)
0037  +0x00528  op=25  1d 01 28 00  ST64             *(s29 +0x28) = s1 ; q1=0x1300000005
0038  +0x00540  op=58  01 10 00 00  LD64             s16 = *(uint64_t *)(s1 +0x0)
0039  +0x00558  op=6c  0f 09 18 11  SHL64_VAR        s24 = s9 << (s15 & 63)
003a  +0x00570  op=85  00 01 ff ff  ADD64_IMM16      s1 = s0 -0x1 ; q1=0x766e6506
003b  +0x00588  op=68  00 19 19 07  LSR64_IMM        s25 = (uint64_t)s25 >> 7 ; q1=0x3332464308
003c  +0x005a0  op=b2  0d 0d 01 00  AND64_IMM16      s13 = s13 & 0x1
003d  +0x005b8  op=b2  11 11 01 00  AND64_IMM16      s17 = s17 & 0x1
003e  +0x005d0  op=b2  0a 0a 01 00  AND64_IMM16      s10 = s10 & 0x1
003f  +0x005e8  op=6c  14 09 16 00  SHL64_VAR        s22 = s9 << (s20 & 63) ; q1=0x160000000b
0040  +0x00600  op=6c  12 09 02 01  SHL64_VAR        s2 = s9 << (s18 & 63)
0041  +0x00618  op=13  08 04 04 0f  CMP_LO64         s4 = ((uint64_t)s8 < (uint64_t)s4) ? 1 : 0
0042  +0x00630  op=02  18 01 18 00  XOR64            s24 = s1 ^ s24 ; q1=0x766e6506
0043  +0x00648  op=6d  00 0d 1e 00  SHL64_IMM32PLUS  s30 = s13 << (0 + 32) ; q1=0x3632464308
0044  +0x00660  op=6d  00 15 15 00  SHL64_IMM32PLUS  s21 = s21 << (0 + 32)
0045  +0x00678  op=6d  00 11 11 00  SHL64_IMM32PLUS  s17 = s17 << (0 + 32)
0046  +0x00690  op=6c  0f 19 0f 11  SHL64_VAR        s15 = s25 << (s15 & 63)
0047  +0x006a8  op=b2  17 19 07 00  AND64_IMM16      s25 = s23 & 0x7 ; q1=0x190000000d
0048  +0x006c0  op=0e  0b 0e 17 05  LSR32_IMM        s23 = sign_extend_32((uint32_t)s14 >> 5)
0049  +0x006d8  op=02  16 01 16 01  XOR64            s22 = s1 ^ s22
004a  +0x006f0  op=b5  0c 0d 01 00  ADD32_IMM16      s13 = int32(s12 +0x1) ; q1=0x766e6506
004b  +0x00708  op=02  02 01 02 00  XOR64            s2 = s1 ^ s2 ; q1=0x3932464308
004c  +0x00720  op=b3  10 18 18 01  AND64            s24 = s16 & s24
004d  +0x00738  op=0e  0d 0e 10 04  LSR32_IMM        s16 = sign_extend_32((uint32_t)s14 >> 4)
004e  +0x00750  op=0e  00 0e 0e 03  LSR32_IMM        s14 = sign_extend_32((uint32_t)s14 >> 3)
004f  +0x00768  op=b2  17 17 01 00  AND64_IMM16      s23 = s23 & 0x1 ; q1=0x1c00000000
0050  +0x00780  op=b2  0d 07 07 00  AND64_IMM16      s7 = s13 & 0x7
0051  +0x00798  op=67  00 11 11 00  LSR64_IMM32PLUS  s17 = (uint64_t)s17 >> (0 + 32)
0052  +0x007b0  op=33  19 19 20 00  OR_IMM16         s25 = s25 | 0x20 ; q1=0x766e6506
0053  +0x007c8  op=67  00 15 15 00  LSR64_IMM32PLUS  s21 = (uint64_t)s21 >> (0 + 32) ; q1=0x3233464308
0054  +0x007e0  op=67  00 1e 1e 00  LSR64_IMM32PLUS  s30 = (uint64_t)s30 >> (0 + 32)
0055  +0x007f8  op=b2  10 10 01 00  AND64_IMM16      s16 = s16 & 0x1
0056  +0x00810  op=34  0f 18 0f 00  OR64             s15 = s15 | s24
0057  +0x00828  op=b2  0e 0e 01 00  AND64_IMM16      s14 = s14 & 0x1 ; q1=0x1f00000007
0058  +0x00840  op=33  1f 18 38 00  OR_IMM16         s24 = s31 | 0x38
0059  +0x00858  op=33  07 07 30 00  OR_IMM16         s7 = s7 | 0x30
005a  +0x00870  op=6c  13 09 1f 00  SHL64_VAR        s31 = s9 << (s19 & 63) ; q1=0x766e6506
005b  +0x00888  op=6c  13 11 11 00  SHL64_VAR        s17 = s17 << (s19 & 63) ; q1=0x3533464308
005c  +0x008a0  op=6c  19 09 03 11  SHL64_VAR        s3 = s9 << (s25 & 63)
005d  +0x008b8  op=6c  12 15 12 01  SHL64_VAR        s18 = s21 << (s18 & 63)
005e  +0x008d0  op=6c  19 1e 19 00  SHL64_VAR        s25 = s30 << (s25 & 63)
005f  +0x008e8  op=6d  00 10 10 00  SHL64_IMM32PLUS  s16 = s16 << (0 + 32) ; q1=0x2200000008
0060  +0x00900  op=6d  00 0a 0a 00  SHL64_IMM32PLUS  s10 = s10 << (0 + 32)
0061  +0x00918  op=b3  0f 16 0f 01  AND64            s15 = s15 & s22
0062  +0x00930  op=6d  00 17 16 00  SHL64_IMM32PLUS  s22 = s23 << (0 + 32) ; q1=0x766e6506
0063  +0x00948  op=6d  00 0e 0e 00  SHL64_IMM32PLUS  s14 = s14 << (0 + 32) ; q1=0x3833464308
0064  +0x00960  op=6c  07 09 05 01  SHL64_VAR        s5 = s9 << (s7 & 63)
0065  +0x00978  op=02  1f 01 13 00  XOR64            s19 = s1 ^ s31
0066  +0x00990  op=02  03 01 03 00  XOR64            s3 = s1 ^ s3
0067  +0x009a8  op=67  00 0a 0a 00  LSR64_IMM32PLUS  s10 = (uint64_t)s10 >> (0 + 32) ; q1=0x250000000f
0068  +0x009c0  op=67  00 0e 0e 00  LSR64_IMM32PLUS  s14 = (uint64_t)s14 >> (0 + 32)
0069  +0x009d8  op=67  00 10 10 00  LSR64_IMM32PLUS  s16 = (uint64_t)s16 >> (0 + 32)
006a  +0x009f0  op=02  05 01 05 01  XOR64            s5 = s1 ^ s5 ; q1=0x766e6506
006b  +0x00a08  op=6c  14 0a 0a 01  SHL64_VAR        s10 = s10 << (s20 & 63) ; q1=0x3034464308
006c  +0x00a20  op=6c  18 09 14 01  SHL64_VAR        s20 = s9 << (s24 & 63)
006d  +0x00a38  op=6c  07 10 07 01  SHL64_VAR        s7 = s16 << (s7 & 63)
006e  +0x00a50  op=34  0f 0a 0a 01  OR64             s10 = s15 | s10
006f  +0x00a68  op=6c  06 09 0f 00  SHL64_VAR        s15 = s9 << (s6 & 63) ; q1=0x2800000000
0070  +0x00a80  op=6c  06 0e 06 00  SHL64_VAR        s6 = s14 << (s6 & 63)
0071  +0x00a98  op=02  14 01 10 01  XOR64            s16 = s1 ^ s20
0072  +0x00ab0  op=67  00 16 14 00  LSR64_IMM32PLUS  s20 = (uint64_t)s22 >> (0 + 32) ; q1=0x766e6506
0073  +0x00ac8  op=02  0f 01 0f 00  XOR64            s15 = s1 ^ s15 ; q1=0x3334464308
0074  +0x00ae0  op=58  1d 01 28 00  LD64             s1 = *(uint64_t *)(s29 +0x28)
0075  +0x00af8  op=b3  0a 0f 0a 01  AND64            s10 = s10 & s15
0076  +0x00b10  op=34  0a 06 06 01  OR64             s6 = s10 | s6
0077  +0x00b28  op=6c  18 14 0a 01  SHL64_VAR        s10 = s20 << (s24 & 63) ; q1=0x2b00000008
0078  +0x00b40  op=b3  06 10 06 01  AND64            s6 = s6 & s16
0079  +0x00b58  op=34  06 0a 06 00  OR64             s6 = s6 | s10
007a  +0x00b70  op=b3  06 05 05 00  AND64            s5 = s6 & s5 ; q1=0x766e6506
007b  +0x00b88  op=34  05 07 05 01  OR64             s5 = s5 | s7 ; q1=0x3634464308
007c  +0x00ba0  op=b3  05 13 05 01  AND64            s5 = s5 & s19
007d  +0x00bb8  op=34  05 11 05 01  OR64             s5 = s5 | s17
007e  +0x00bd0  op=b3  05 02 02 00  AND64            s2 = s5 & s2
007f  +0x00be8  op=34  02 12 02 00  OR64             s2 = s2 | s18 ; q1=0x2e00000012
0080  +0x00c00  op=b3  02 03 02 00  AND64            s2 = s2 & s3
0081  +0x00c18  op=34  02 19 02 01  OR64             s2 = s2 | s25
0082  +0x00c30  op=25  01 02 00 00  ST64             *(s1 +0x0) = s2 ; q1=0x766e6506
0083  +0x00c48  op=ae  04 00 05 00  BR_EQ64          if (s4 == s0) goto record +137 ; q1=0x3136464308
0084  +0x00c60  op=52  1d 03 24 00  LD32S            s3 = *(int32_t *)(s29 +0x24)
0085  +0x00c78  op=14  0d 01 08 00  CMP_LO_IMM64     s1 = ((uint64_t)s13 < (uint64_t)8) ? 1 : 0
0086  +0x00c90  op=b5  00 0b 00 00  ADD32_IMM16      s11 = int32(s0 +0x0)
0087  +0x00ca8  op=a7  01 00 04 00  BR_NE64          if (s1 != s0) goto record +140 ; q1=0x3100000014
0088  +0x00cc0  op=5f  0d 00 00 00  ADD_PC_IMM32     goto record +150 ; vm_pc = current_pc + 1 + 13
0089  +0x00cd8  op=52  1d 03 24 00  LD32S            s3 = *(int32_t *)(s29 +0x24)
008a  +0x00cf0  op=b5  0b 0b 08 00  ADD32_IMM16      s11 = int32(s11 +0x8) ; q1=0x766e6506
008b  +0x00d08  op=34  0c 00 0d 01  OR64             s13 = s12 | s0 ; q1=0x3934464308
008c  +0x00d20  op=58  1d 02 10 00  LD64             s2 = *(uint64_t *)(s29 +0x10)
008d  +0x00d38  op=58  1d 06 18 00  LD64             s6 = *(uint64_t *)(s29 +0x18)
008e  +0x00d50  op=58  1d 04 08 00  LD64             s4 = *(uint64_t *)(s29 +0x8)
008f  +0x00d68  op=b5  03 03 01 00  ADD32_IMM16      s3 = int32(s3 +0x1) ; q1=0x3400000005
0090  +0x00d80  op=34  0d 00 0c 00  OR64             s12 = s13 | s0
0091  +0x00d98  op=85  02 02 ff ff  ADD64_IMM16      s2 = s2 -0x1
0092  +0x00db0  op=85  06 06 01 00  ADD64_IMM16      s6 = s6 +0x1 ; q1=0x766e6506
0093  +0x00dc8  op=a7  02 00 86 ff  BR_NE64          if (s2 != s0) goto record +26 ; q1=0x37464306
0094  +0x00de0  op=58  1d 02 00 00  LD64             s2 = *(uint64_t *)(s29 +0x0)
0095  +0x00df8  op=5f  01 00 00 00  ADD_PC_IMM32     goto record +151 ; vm_pc = current_pc + 1 + 1
0096  +0x00e10  op=34  03 00 02 01  OR64             s2 = s3 | s0
0097  +0x00e28  op=58  1d 10 30 00  LD64             s16 = *(uint64_t *)(s29 +0x30) ; q1=0x3700000005
0098  +0x00e40  op=58  1d 11 38 00  LD64             s17 = *(uint64_t *)(s29 +0x38)
0099  +0x00e58  op=58  1d 12 40 00  LD64             s18 = *(uint64_t *)(s29 +0x40)
009a  +0x00e70  op=58  1d 13 48 00  LD64             s19 = *(uint64_t *)(s29 +0x48) ; q1=0x766e6506
009b  +0x00e88  op=58  1d 14 50 00  LD64             s20 = *(uint64_t *)(s29 +0x50) ; q1=0x3436464308
009c  +0x00ea0  op=58  1d 15 58 00  LD64             s21 = *(uint64_t *)(s29 +0x58)
009d  +0x00eb8  op=58  1d 16 60 00  LD64             s22 = *(uint64_t *)(s29 +0x60)
009e  +0x00ed0  op=58  1d 17 68 00  LD64             s23 = *(uint64_t *)(s29 +0x68)
009f  +0x00ee8  op=58  1d 1e 70 00  LD64             s30 = *(uint64_t *)(s29 +0x70) ; q1=0x3a00000009
00a0  +0x00f00  op=58  1d 1f 78 00  LD64             s31 = *(uint64_t *)(s29 +0x78)
00a1  +0x00f18  op=85  1d 1d 80 00  ADD64_IMM16      s29 = s29 +0x80
00a2  +0x00f30  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x766e6506

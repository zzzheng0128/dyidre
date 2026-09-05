; MetaSec managed bytecode decode: F45
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F45_0x7aa000_0x5fe8.bin
; records: 1023  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d a0 fc  ADD64_IMM16      s29 = s29 -0x360
0001  +0x00018  op=25  1d 1f 58 03  ST64             *(s29 +0x358) = s31
0002  +0x00030  op=25  1d 1e 50 03  ST64             *(s29 +0x350) = s30
0003  +0x00048  op=25  1d 17 48 03  ST64             *(s29 +0x348) = s23
0004  +0x00060  op=25  1d 16 40 03  ST64             *(s29 +0x340) = s22
0005  +0x00078  op=25  1d 15 38 03  ST64             *(s29 +0x338) = s21
0006  +0x00090  op=25  1d 14 30 03  ST64             *(s29 +0x330) = s20
0007  +0x000a8  op=25  1d 13 28 03  ST64             *(s29 +0x328) = s19
0008  +0x000c0  op=25  1d 12 20 03  ST64             *(s29 +0x320) = s18
0009  +0x000d8  op=25  1d 11 18 03  ST64             *(s29 +0x318) = s17
000a  +0x000f0  op=25  1d 10 10 03  ST64             *(s29 +0x310) = s16
000b  +0x00108  op=58  04 01 e0 00  LD64             s1 = *(uint64_t *)(s4 +0xe0)
000c  +0x00120  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
000d  +0x00138  op=85  00 03 40 00  ADD64_IMM16      s3 = s0 +0x40
000e  +0x00150  op=85  1d 0b d0 02  ADD64_IMM16      s11 = s29 +0x2d0
000f  +0x00168  op=25  1d 01 b8 00  ST64             *(s29 +0xb8) = s1
0010  +0x00180  op=58  04 01 d8 00  LD64             s1 = *(uint64_t *)(s4 +0xd8)
0011  +0x00198  op=25  1d 01 b0 00  ST64             *(s29 +0xb0) = s1
0012  +0x001b0  op=58  04 01 d0 00  LD64             s1 = *(uint64_t *)(s4 +0xd0)
0013  +0x001c8  op=25  1d 01 a8 00  ST64             *(s29 +0xa8) = s1
0014  +0x001e0  op=58  04 01 c8 00  LD64             s1 = *(uint64_t *)(s4 +0xc8)
0015  +0x001f8  op=25  1d 01 a0 00  ST64             *(s29 +0xa0) = s1
0016  +0x00210  op=58  04 01 c0 00  LD64             s1 = *(uint64_t *)(s4 +0xc0)
0017  +0x00228  op=25  1d 01 80 02  ST64             *(s29 +0x280) = s1
0018  +0x00240  op=58  04 01 b8 00  LD64             s1 = *(uint64_t *)(s4 +0xb8)
0019  +0x00258  op=25  1d 01 90 00  ST64             *(s29 +0x90) = s1
001a  +0x00270  op=58  04 01 b0 00  LD64             s1 = *(uint64_t *)(s4 +0xb0)
001b  +0x00288  op=25  1d 01 88 00  ST64             *(s29 +0x88) = s1
001c  +0x002a0  op=58  04 01 a8 00  LD64             s1 = *(uint64_t *)(s4 +0xa8)
001d  +0x002b8  op=25  1d 01 80 00  ST64             *(s29 +0x80) = s1
001e  +0x002d0  op=ae  02 03 1b 00  BR_EQ64          if (s2 == s3) goto record +58
001f  +0x002e8  op=84  04 02 01 04  ADD64            s1 = s4 + s2
0020  +0x00300  op=84  0b 02 0e 14  ADD64            s14 = s11 + s2
0021  +0x00318  op=85  02 02 08 00  ADD64_IMM16      s2 = s2 +0x8
0022  +0x00330  op=5a  01 0c 00 00  LD8S             s12 = *(int8_t *)(s1 +0x0)
0023  +0x00348  op=59  01 0d 01 00  LD8U             s13 = *(uint8_t *)(s1 +0x1)
0024  +0x00360  op=6d  00 0c 0c 18  SHL64_IMM32PLUS  s12 = s12 << (24 + 32)
0025  +0x00378  op=6d  00 0d 0d 10  SHL64_IMM32PLUS  s13 = s13 << (16 + 32)
0026  +0x00390  op=34  0d 0c 0c 00  OR64             s12 = s13 | s12
0027  +0x003a8  op=59  01 0d 02 00  LD8U             s13 = *(uint8_t *)(s1 +0x2)
0028  +0x003c0  op=6d  00 0d 0d 08  SHL64_IMM32PLUS  s13 = s13 << (8 + 32)
0029  +0x003d8  op=34  0c 0d 0c 01  OR64             s12 = s12 | s13
002a  +0x003f0  op=59  01 0d 03 00  LD8U             s13 = *(uint8_t *)(s1 +0x3)
002b  +0x00408  op=6d  00 0d 0d 00  SHL64_IMM32PLUS  s13 = s13 << (0 + 32)
002c  +0x00420  op=34  0c 0d 0c 00  OR64             s12 = s12 | s13
002d  +0x00438  op=59  01 0d 04 00  LD8U             s13 = *(uint8_t *)(s1 +0x4)
002e  +0x00450  op=6e  00 0d 0d 18  SHL64_IMM        s13 = s13 << 24
002f  +0x00468  op=34  0c 0d 0c 00  OR64             s12 = s12 | s13
0030  +0x00480  op=59  01 0d 05 00  LD8U             s13 = *(uint8_t *)(s1 +0x5)
0031  +0x00498  op=6e  00 0d 0d 10  SHL64_IMM        s13 = s13 << 16
0032  +0x004b0  op=34  0c 0d 0c 00  OR64             s12 = s12 | s13
0033  +0x004c8  op=59  01 0d 07 00  LD8U             s13 = *(uint8_t *)(s1 +0x7)
0034  +0x004e0  op=59  01 01 06 00  LD8U             s1 = *(uint8_t *)(s1 +0x6)
0035  +0x004f8  op=6e  02 01 01 08  SHL64_IMM        s1 = s1 << 8
0036  +0x00510  op=02  0c 01 01 01  XOR64            s1 = s1 ^ s12
0037  +0x00528  op=02  01 0d 01 00  XOR64            s1 = s13 ^ s1
0038  +0x00540  op=25  0e 01 00 00  ST64             *(s14 +0x0) = s1
0039  +0x00558  op=a7  02 03 e5 ff  BR_NE64          if (s2 != s3) goto record +31
003a  +0x00570  op=85  00 01 00 00  ADD64_IMM16      s1 = s0 +0x0
003b  +0x00588  op=58  04 11 70 00  LD64             s17 = *(uint64_t *)(s4 +0x70)
003c  +0x005a0  op=58  04 03 78 00  LD64             s3 = *(uint64_t *)(s4 +0x78)
003d  +0x005b8  op=58  04 05 80 00  LD64             s5 = *(uint64_t *)(s4 +0x80)
003e  +0x005d0  op=58  1d 0c f0 02  LD64             s12 = *(uint64_t *)(s29 +0x2f0)
003f  +0x005e8  op=58  1d 0e 00 03  LD64             s14 = *(uint64_t *)(s29 +0x300)
0040  +0x00600  op=58  04 16 88 00  LD64             s22 = *(uint64_t *)(s4 +0x88)
0041  +0x00618  op=58  04 0f 90 00  LD64             s15 = *(uint64_t *)(s4 +0x90)
0042  +0x00630  op=58  04 1f 68 00  LD64             s31 = *(uint64_t *)(s4 +0x68)
0043  +0x00648  op=58  1d 0b f8 02  LD64             s11 = *(uint64_t *)(s29 +0x2f8)
0044  +0x00660  op=58  1d 06 e8 02  LD64             s6 = *(uint64_t *)(s29 +0x2e8)
0045  +0x00678  op=58  1d 0d 08 03  LD64             s13 = *(uint64_t *)(s29 +0x308)
0046  +0x00690  op=58  04 18 98 00  LD64             s24 = *(uint64_t *)(s4 +0x98)
0047  +0x006a8  op=58  04 19 a0 00  LD64             s25 = *(uint64_t *)(s4 +0xa0)
0048  +0x006c0  op=58  1d 02 d8 02  LD64             s2 = *(uint64_t *)(s29 +0x2d8)
0049  +0x006d8  op=58  1d 10 d0 02  LD64             s16 = *(uint64_t *)(s29 +0x2d0)
004a  +0x006f0  op=25  1d 04 78 00  ST64             *(s29 +0x78) = s4
004b  +0x00708  op=85  04 04 f0 00  ADD64_IMM16      s4 = s4 +0xf0
004c  +0x00720  op=25  1d 01 b0 02  ST64             *(s29 +0x2b0) = s1
004d  +0x00738  op=58  1d 01 e0 02  LD64             s1 = *(uint64_t *)(s29 +0x2e0)
004e  +0x00750  op=25  1d 04 98 00  ST64             *(s29 +0x98) = s4
004f  +0x00768  op=25  1d 0d 38 00  ST64             *(s29 +0x38) = s13
0050  +0x00780  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
0051  +0x00798  op=25  1d 0b 48 00  ST64             *(s29 +0x48) = s11
0052  +0x007b0  op=25  1d 0e 28 00  ST64             *(s29 +0x28) = s14
0053  +0x007c8  op=02  05 0e 09 00  XOR64            s9 = s14 ^ s5
0054  +0x007e0  op=25  1d 0c 40 00  ST64             *(s29 +0x40) = s12
0055  +0x007f8  op=02  03 0c 0a 01  XOR64            s10 = s12 ^ s3
0056  +0x00810  op=25  1d 11 c8 02  ST64             *(s29 +0x2c8) = s17
0057  +0x00828  op=02  1f 0d 0d 01  XOR64            s13 = s13 ^ s31
0058  +0x00840  op=25  1d 06 50 00  ST64             *(s29 +0x50) = s6
0059  +0x00858  op=02  18 10 10 01  XOR64            s16 = s16 ^ s24
005a  +0x00870  op=02  0f 0b 0b 01  XOR64            s11 = s11 ^ s15
005b  +0x00888  op=02  16 02 0c 00  XOR64            s12 = s2 ^ s22
005c  +0x008a0  op=25  1d 16 30 00  ST64             *(s29 +0x30) = s22
005d  +0x008b8  op=34  16 00 07 01  OR64             s7 = s22 | s0
005e  +0x008d0  op=34  0f 00 08 00  OR64             s8 = s15 | s0
005f  +0x008e8  op=34  1f 00 16 01  OR64             s22 = s31 | s0
0060  +0x00900  op=25  1d 02 68 00  ST64             *(s29 +0x68) = s2
0061  +0x00918  op=25  1d 0f 20 00  ST64             *(s29 +0x20) = s15
0062  +0x00930  op=25  1d 18 10 00  ST64             *(s29 +0x10) = s24
0063  +0x00948  op=25  1d 19 08 00  ST64             *(s29 +0x8) = s25
0064  +0x00960  op=25  1d 1f 70 00  ST64             *(s29 +0x70) = s31
0065  +0x00978  op=25  1d 03 60 00  ST64             *(s29 +0x60) = s3
0066  +0x00990  op=25  1d 03 c0 02  ST64             *(s29 +0x2c0) = s3
0067  +0x009a8  op=25  1d 05 58 00  ST64             *(s29 +0x58) = s5
0068  +0x009c0  op=25  1d 05 b8 02  ST64             *(s29 +0x2b8) = s5
0069  +0x009d8  op=02  11 01 01 01  XOR64            s1 = s1 ^ s17
006a  +0x009f0  op=02  19 06 11 01  XOR64            s17 = s6 ^ s25
006b  +0x00a08  op=34  19 00 06 01  OR64             s6 = s25 | s0
006c  +0x00a20  op=34  01 00 0e 00  OR64             s14 = s1 | s0
006d  +0x00a38  op=25  1d 01 18 00  ST64             *(s29 +0x18) = s1
006e  +0x00a50  op=58  1d 01 b0 02  LD64             s1 = *(uint64_t *)(s29 +0x2b0)
006f  +0x00a68  op=85  00 02 50 00  ADD64_IMM16      s2 = s0 +0x50
0070  +0x00a80  op=ae  01 02 5b 03  BR_EQ64          if (s1 == s2) goto record +972
0071  +0x00a98  op=58  1d 15 c0 02  LD64             s21 = *(uint64_t *)(s29 +0x2c0)
0072  +0x00ab0  op=58  1d 03 b8 02  LD64             s3 = *(uint64_t *)(s29 +0x2b8)
0073  +0x00ac8  op=34  07 00 02 01  OR64             s2 = s7 | s0
0074  +0x00ae0  op=58  1d 07 c8 02  LD64             s7 = *(uint64_t *)(s29 +0x2c8)
0075  +0x00af8  op=25  1d 0a 50 01  ST64             *(s29 +0x150) = s10
0076  +0x00b10  op=58  1d 0a 88 00  LD64             s10 = *(uint64_t *)(s29 +0x88)
0077  +0x00b28  op=58  1d 1f 80 00  LD64             s31 = *(uint64_t *)(s29 +0x80)
0078  +0x00b40  op=25  1d 0c 88 01  ST64             *(s29 +0x188) = s12
0079  +0x00b58  op=67  00 16 0c 0d  LSR64_IMM32PLUS  s12 = (uint64_t)s22 >> (13 + 32)
007a  +0x00b70  op=25  1d 0d a0 02  ST64             *(s29 +0x2a0) = s13
007b  +0x00b88  op=25  1d 11 a0 01  ST64             *(s29 +0x1a0) = s17
007c  +0x00ba0  op=67  00 18 11 0d  LSR64_IMM32PLUS  s17 = (uint64_t)s24 >> (13 + 32)
007d  +0x00bb8  op=25  1d 10 48 01  ST64             *(s29 +0x148) = s16
007e  +0x00bd0  op=67  00 06 10 15  LSR64_IMM32PLUS  s16 = (uint64_t)s6 >> (21 + 32)
007f  +0x00be8  op=25  1d 09 18 01  ST64             *(s29 +0x118) = s9
0080  +0x00c00  op=58  1d 09 90 00  LD64             s9 = *(uint64_t *)(s29 +0x90)
0081  +0x00c18  op=67  00 18 12 15  LSR64_IMM32PLUS  s18 = (uint64_t)s24 >> (21 + 32)
0082  +0x00c30  op=25  1d 0b b8 01  ST64             *(s29 +0x1b8) = s11
0083  +0x00c48  op=67  00 08 0b 0d  LSR64_IMM32PLUS  s11 = (uint64_t)s8 >> (13 + 32)
0084  +0x00c60  op=67  00 08 0f 15  LSR64_IMM32PLUS  s15 = (uint64_t)s8 >> (21 + 32)
0085  +0x00c78  op=25  1d 18 a8 02  ST64             *(s29 +0x2a8) = s24
0086  +0x00c90  op=67  00 08 18 05  LSR64_IMM32PLUS  s24 = (uint64_t)s8 >> (5 + 32)
0087  +0x00ca8  op=25  1d 0e a8 01  ST64             *(s29 +0x1a8) = s14
0088  +0x00cc0  op=67  00 16 14 15  LSR64_IMM32PLUS  s20 = (uint64_t)s22 >> (21 + 32)
0089  +0x00cd8  op=67  00 06 17 0d  LSR64_IMM32PLUS  s23 = (uint64_t)s6 >> (13 + 32)
008a  +0x00cf0  op=25  1d 16 88 02  ST64             *(s29 +0x288) = s22
008b  +0x00d08  op=25  1d 06 90 02  ST64             *(s29 +0x290) = s6
008c  +0x00d20  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
008d  +0x00d38  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
008e  +0x00d50  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
008f  +0x00d68  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0090  +0x00d80  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
0091  +0x00d98  op=67  00 02 0e 05  LSR64_IMM32PLUS  s14 = (uint64_t)s2 >> (5 + 32)
0092  +0x00db0  op=34  02 00 05 00  OR64             s5 = s2 | s0
0093  +0x00dc8  op=25  1d 02 98 02  ST64             *(s29 +0x298) = s2
0094  +0x00de0  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
0095  +0x00df8  op=b2  17 17 f8 07  AND64_IMM16      s23 = s23 & 0x7f8
0096  +0x00e10  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
0097  +0x00e28  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0098  +0x00e40  op=67  00 15 01 0d  LSR64_IMM32PLUS  s1 = (uint64_t)s21 >> (13 + 32)
0099  +0x00e58  op=67  00 03 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s3 >> (21 + 32)
009a  +0x00e70  op=67  00 07 0d 15  LSR64_IMM32PLUS  s13 = (uint64_t)s7 >> (21 + 32)
009b  +0x00e88  op=67  00 07 1e 05  LSR64_IMM32PLUS  s30 = (uint64_t)s7 >> (5 + 32)
009c  +0x00ea0  op=84  0a 0c 0c 04  ADD64            s12 = s10 + s12
009d  +0x00eb8  op=84  0a 11 11 00  ADD64            s17 = s10 + s17
009e  +0x00ed0  op=84  1f 10 10 00  ADD64            s16 = s31 + s16
009f  +0x00ee8  op=84  0a 0b 0b 04  ADD64            s11 = s10 + s11
00a0  +0x00f00  op=84  1f 12 12 14  ADD64            s18 = s31 + s18
00a1  +0x00f18  op=67  00 03 02 0d  LSR64_IMM32PLUS  s2 = (uint64_t)s3 >> (13 + 32)
00a2  +0x00f30  op=84  0a 17 17 00  ADD64            s23 = s10 + s23
00a3  +0x00f48  op=84  1f 14 14 04  ADD64            s20 = s31 + s20
00a4  +0x00f60  op=67  00 05 19 0d  LSR64_IMM32PLUS  s25 = (uint64_t)s5 >> (13 + 32)
00a5  +0x00f78  op=84  1f 0f 0f 14  ADD64            s15 = s31 + s15
00a6  +0x00f90  op=84  09 18 18 00  ADD64            s24 = s9 + s24
00a7  +0x00fa8  op=67  00 05 13 15  LSR64_IMM32PLUS  s19 = (uint64_t)s5 >> (21 + 32)
00a8  +0x00fc0  op=58  1d 05 a0 00  LD64             s5 = *(uint64_t *)(s29 +0xa0)
00a9  +0x00fd8  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
00aa  +0x00ff0  op=25  1d 07 c8 02  ST64             *(s29 +0x2c8) = s7
00ab  +0x01008  op=25  1d 15 c0 02  ST64             *(s29 +0x2c0) = s21
00ac  +0x01020  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
00ad  +0x01038  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
00ae  +0x01050  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
00af  +0x01068  op=b2  1e 1e f8 07  AND64_IMM16      s30 = s30 & 0x7f8
00b0  +0x01080  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
00b1  +0x01098  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
00b2  +0x010b0  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
00b3  +0x010c8  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
00b4  +0x010e0  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
00b5  +0x010f8  op=58  17 17 00 00  LD64             s23 = *(uint64_t *)(s23 +0x0)
00b6  +0x01110  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
00b7  +0x01128  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
00b8  +0x01140  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
00b9  +0x01158  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
00ba  +0x01170  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
00bb  +0x01188  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
00bc  +0x011a0  op=84  09 0e 0e 14  ADD64            s14 = s9 + s14
00bd  +0x011b8  op=84  0a 01 01 14  ADD64            s1 = s10 + s1
00be  +0x011d0  op=84  1f 04 04 04  ADD64            s4 = s31 + s4
00bf  +0x011e8  op=84  1f 0d 0d 00  ADD64            s13 = s31 + s13
00c0  +0x01200  op=84  09 1e 1e 04  ADD64            s30 = s9 + s30
00c1  +0x01218  op=84  0a 19 19 14  ADD64            s25 = s10 + s25
00c2  +0x01230  op=84  1f 13 13 14  ADD64            s19 = s31 + s19
00c3  +0x01248  op=84  0a 02 02 04  ADD64            s2 = s10 + s2
00c4  +0x01260  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
00c5  +0x01278  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
00c6  +0x01290  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
00c7  +0x012a8  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
00c8  +0x012c0  op=58  1e 1e 00 00  LD64             s30 = *(uint64_t *)(s30 +0x0)
00c9  +0x012d8  op=02  11 10 10 01  XOR64            s16 = s16 ^ s17
00ca  +0x012f0  op=67  00 15 11 15  LSR64_IMM32PLUS  s17 = (uint64_t)s21 >> (21 + 32)
00cb  +0x01308  op=02  0b 12 0b 00  XOR64            s11 = s18 ^ s11
00cc  +0x01320  op=02  17 14 14 01  XOR64            s20 = s20 ^ s23
00cd  +0x01338  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
00ce  +0x01350  op=58  13 13 00 00  LD64             s19 = *(uint64_t *)(s19 +0x0)
00cf  +0x01368  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
00d0  +0x01380  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
00d1  +0x01398  op=02  10 18 18 00  XOR64            s24 = s24 ^ s16
00d2  +0x013b0  op=02  0b 0e 0b 00  XOR64            s11 = s14 ^ s11
00d3  +0x013c8  op=02  01 04 01 01  XOR64            s1 = s4 ^ s1
00d4  +0x013e0  op=67  00 06 04 05  LSR64_IMM32PLUS  s4 = (uint64_t)s6 >> (5 + 32)
00d5  +0x013f8  op=02  0c 0d 0c 01  XOR64            s12 = s13 ^ s12
00d6  +0x01410  op=67  00 07 0d 0d  LSR64_IMM32PLUS  s13 = (uint64_t)s7 >> (13 + 32)
00d7  +0x01428  op=84  1f 11 11 04  ADD64            s17 = s31 + s17
00d8  +0x01440  op=02  19 0f 0f 01  XOR64            s15 = s15 ^ s25
00d9  +0x01458  op=67  00 16 19 05  LSR64_IMM32PLUS  s25 = (uint64_t)s22 >> (5 + 32)
00da  +0x01470  op=58  1d 07 98 02  LD64             s7 = *(uint64_t *)(s29 +0x298)
00db  +0x01488  op=02  02 13 02 01  XOR64            s2 = s19 ^ s2
00dc  +0x014a0  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
00dd  +0x014b8  op=02  01 1e 01 01  XOR64            s1 = s30 ^ s1
00de  +0x014d0  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
00df  +0x014e8  op=68  13 16 1e 1d  LSR64_IMM        s30 = (uint64_t)s22 >> 29
00e0  +0x01500  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
00e1  +0x01518  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
00e2  +0x01530  op=84  09 04 04 00  ADD64            s4 = s9 + s4
00e3  +0x01548  op=25  1d 01 78 02  ST64             *(s29 +0x278) = s1
00e4  +0x01560  op=34  08 00 01 01  OR64             s1 = s8 | s0
00e5  +0x01578  op=58  1d 08 80 02  LD64             s8 = *(uint64_t *)(s29 +0x280)
00e6  +0x01590  op=84  0a 0d 0d 14  ADD64            s13 = s10 + s13
00e7  +0x015a8  op=b2  1e 1e f8 07  AND64_IMM16      s30 = s30 & 0x7f8
00e8  +0x015c0  op=68  03 07 0e 1d  LSR64_IMM        s14 = (uint64_t)s7 >> 29
00e9  +0x015d8  op=84  09 19 19 04  ADD64            s25 = s9 + s25
00ea  +0x015f0  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
00eb  +0x01608  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
00ec  +0x01620  op=68  00 01 10 1d  LSR64_IMM        s16 = (uint64_t)s1 >> 29
00ed  +0x01638  op=34  01 00 16 00  OR64             s22 = s1 | s0
00ee  +0x01650  op=58  1d 01 78 02  LD64             s1 = *(uint64_t *)(s29 +0x278)
00ef  +0x01668  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
00f0  +0x01680  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
00f1  +0x01698  op=84  08 1e 12 00  ADD64            s18 = s8 + s30
00f2  +0x016b0  op=34  03 00 1e 01  OR64             s30 = s3 | s0
00f3  +0x016c8  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
00f4  +0x016e0  op=84  08 0e 0e 04  ADD64            s14 = s8 + s14
00f5  +0x016f8  op=25  1d 16 38 01  ST64             *(s29 +0x138) = s22
00f6  +0x01710  op=02  0c 04 04 01  XOR64            s4 = s4 ^ s12
00f7  +0x01728  op=68  00 03 0c 1d  LSR64_IMM        s12 = (uint64_t)s3 >> 29
00f8  +0x01740  op=58  1d 03 a8 02  LD64             s3 = *(uint64_t *)(s29 +0x2a8)
00f9  +0x01758  op=02  0d 11 0d 00  XOR64            s13 = s17 ^ s13
00fa  +0x01770  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
00fb  +0x01788  op=67  00 1e 13 05  LSR64_IMM32PLUS  s19 = (uint64_t)s30 >> (5 + 32)
00fc  +0x017a0  op=84  08 10 10 04  ADD64            s16 = s8 + s16
00fd  +0x017b8  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
00fe  +0x017d0  op=25  1d 1e b8 02  ST64             *(s29 +0x2b8) = s30
00ff  +0x017e8  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
0100  +0x01800  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
0101  +0x01818  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
0102  +0x01830  op=02  0d 19 0d 01  XOR64            s13 = s25 ^ s13
0103  +0x01848  op=67  00 03 11 05  LSR64_IMM32PLUS  s17 = (uint64_t)s3 >> (5 + 32)
0104  +0x01860  op=84  08 0c 0c 00  ADD64            s12 = s8 + s12
0105  +0x01878  op=02  01 12 01 01  XOR64            s1 = s18 ^ s1
0106  +0x01890  op=68  00 03 17 1d  LSR64_IMM        s23 = (uint64_t)s3 >> 29
0107  +0x018a8  op=67  00 15 12 05  LSR64_IMM32PLUS  s18 = (uint64_t)s21 >> (5 + 32)
0108  +0x018c0  op=84  09 13 13 14  ADD64            s19 = s9 + s19
0109  +0x018d8  op=02  18 0e 0e 00  XOR64            s14 = s14 ^ s24
010a  +0x018f0  op=68  00 07 18 15  LSR64_IMM        s24 = (uint64_t)s7 >> 21
010b  +0x01908  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
010c  +0x01920  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
010d  +0x01938  op=b2  17 17 f8 07  AND64_IMM16      s23 = s23 & 0x7f8
010e  +0x01950  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
010f  +0x01968  op=58  13 13 00 00  LD64             s19 = *(uint64_t *)(s19 +0x0)
0110  +0x01980  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0111  +0x01998  op=84  09 11 11 04  ADD64            s17 = s9 + s17
0112  +0x019b0  op=84  08 17 17 04  ADD64            s23 = s8 + s23
0113  +0x019c8  op=84  09 12 12 00  ADD64            s18 = s9 + s18
0114  +0x019e0  op=84  05 18 18 14  ADD64            s24 = s5 + s24
0115  +0x019f8  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
0116  +0x01a10  op=02  0b 0c 0b 01  XOR64            s11 = s12 ^ s11
0117  +0x01a28  op=68  00 1e 0c 15  LSR64_IMM        s12 = (uint64_t)s30 >> 21
0118  +0x01a40  op=58  17 17 00 00  LD64             s23 = *(uint64_t *)(s23 +0x0)
0119  +0x01a58  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
011a  +0x01a70  op=02  0f 13 0f 01  XOR64            s15 = s19 ^ s15
011b  +0x01a88  op=68  00 06 13 1d  LSR64_IMM        s19 = (uint64_t)s6 >> 29
011c  +0x01aa0  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
011d  +0x01ab8  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
011e  +0x01ad0  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
011f  +0x01ae8  op=02  14 11 11 00  XOR64            s17 = s17 ^ s20
0120  +0x01b00  op=68  13 06 14 15  LSR64_IMM        s20 = (uint64_t)s6 >> 21
0121  +0x01b18  op=84  05 0c 0c 00  ADD64            s12 = s5 + s12
0122  +0x01b30  op=02  04 17 04 01  XOR64            s4 = s23 ^ s4
0123  +0x01b48  op=02  02 12 02 01  XOR64            s2 = s18 ^ s2
0124  +0x01b60  op=68  03 15 12 1d  LSR64_IMM        s18 = (uint64_t)s21 >> 29
0125  +0x01b78  op=34  15 00 17 01  OR64             s23 = s21 | s0
0126  +0x01b90  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
0127  +0x01ba8  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
0128  +0x01bc0  op=02  11 10 10 00  XOR64            s16 = s16 ^ s17
0129  +0x01bd8  op=68  00 03 11 0d  LSR64_IMM        s17 = (uint64_t)s3 >> 13
012a  +0x01bf0  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
012b  +0x01c08  op=84  05 14 14 14  ADD64            s20 = s5 + s20
012c  +0x01c20  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
012d  +0x01c38  op=84  08 12 12 00  ADD64            s18 = s8 + s18
012e  +0x01c50  op=02  10 18 18 01  XOR64            s24 = s24 ^ s16
012f  +0x01c68  op=68  13 1e 10 0d  LSR64_IMM        s16 = (uint64_t)s30 >> 13
0130  +0x01c80  op=58  1d 1e 18 01  LD64             s30 = *(uint64_t *)(s29 +0x118)
0131  +0x01c98  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
0132  +0x01cb0  op=02  0e 0c 0c 01  XOR64            s12 = s12 ^ s14
0133  +0x01cc8  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
0134  +0x01ce0  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
0135  +0x01cf8  op=02  01 14 01 00  XOR64            s1 = s20 ^ s1
0136  +0x01d10  op=68  00 15 14 15  LSR64_IMM        s20 = (uint64_t)s21 >> 21
0137  +0x01d28  op=34  03 00 15 00  OR64             s21 = s3 | s0
0138  +0x01d40  op=58  1d 03 a8 00  LD64             s3 = *(uint64_t *)(s29 +0xa8)
0139  +0x01d58  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
013a  +0x01d70  op=25  1d 01 78 02  ST64             *(s29 +0x278) = s1
013b  +0x01d88  op=34  07 00 01 01  OR64             s1 = s7 | s0
013c  +0x01da0  op=34  16 00 07 00  OR64             s7 = s22 | s0
013d  +0x01db8  op=84  05 14 14 04  ADD64            s20 = s5 + s20
013e  +0x01dd0  op=84  03 11 19 04  ADD64            s25 = s3 + s17
013f  +0x01de8  op=84  08 13 11 04  ADD64            s17 = s8 + s19
0140  +0x01e00  op=68  03 16 13 15  LSR64_IMM        s19 = (uint64_t)s22 >> 21
0141  +0x01e18  op=02  0f 12 07 01  XOR64            s7 = s18 ^ s15
0142  +0x01e30  op=58  1d 12 88 02  LD64             s18 = *(uint64_t *)(s29 +0x288)
0143  +0x01e48  op=84  03 10 10 00  ADD64            s16 = s3 + s16
0144  +0x01e60  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
0145  +0x01e78  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
0146  +0x01e90  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
0147  +0x01ea8  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
0148  +0x01ec0  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
0149  +0x01ed8  op=25  1d 07 00 02  ST64             *(s29 +0x200) = s7
014a  +0x01ef0  op=58  1d 07 a0 02  LD64             s7 = *(uint64_t *)(s29 +0x2a0)
014b  +0x01f08  op=84  05 13 13 04  ADD64            s19 = s5 + s19
014c  +0x01f20  op=02  0b 14 0b 01  XOR64            s11 = s20 ^ s11
014d  +0x01f38  op=58  1d 14 c8 02  LD64             s20 = *(uint64_t *)(s29 +0x2c8)
014e  +0x01f50  op=58  13 13 00 00  LD64             s19 = *(uint64_t *)(s19 +0x0)
014f  +0x01f68  op=02  0d 11 0d 01  XOR64            s13 = s17 ^ s13
0150  +0x01f80  op=68  13 15 11 15  LSR64_IMM        s17 = (uint64_t)s21 >> 21
0151  +0x01f98  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
0152  +0x01fb0  op=68  00 14 0e 1d  LSR64_IMM        s14 = (uint64_t)s20 >> 29
0153  +0x01fc8  op=02  04 13 04 01  XOR64            s4 = s19 ^ s4
0154  +0x01fe0  op=68  13 17 13 0d  LSR64_IMM        s19 = (uint64_t)s23 >> 13
0155  +0x01ff8  op=34  16 00 17 01  OR64             s23 = s22 | s0
0156  +0x02010  op=84  05 11 11 04  ADD64            s17 = s5 + s17
0157  +0x02028  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0158  +0x02040  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
0159  +0x02058  op=84  08 0e 0e 04  ADD64            s14 = s8 + s14
015a  +0x02070  op=84  03 13 13 14  ADD64            s19 = s3 + s19
015b  +0x02088  op=58  1d 08 78 02  LD64             s8 = *(uint64_t *)(s29 +0x278)
015c  +0x020a0  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
015d  +0x020b8  op=58  13 0f 00 00  LD64             s15 = *(uint64_t *)(s19 +0x0)
015e  +0x020d0  op=58  1d 13 50 01  LD64             s19 = *(uint64_t *)(s29 +0x150)
015f  +0x020e8  op=02  02 0e 02 00  XOR64            s2 = s14 ^ s2
0160  +0x02100  op=68  00 14 0e 0d  LSR64_IMM        s14 = (uint64_t)s20 >> 13
0161  +0x02118  op=02  08 19 14 01  XOR64            s20 = s25 ^ s8
0162  +0x02130  op=68  00 16 19 05  LSR64_IMM        s25 = (uint64_t)s22 >> 5
0163  +0x02148  op=34  06 00 16 01  OR64             s22 = s6 | s0
0164  +0x02160  op=58  1d 08 b0 00  LD64             s8 = *(uint64_t *)(s29 +0xb0)
0165  +0x02178  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0166  +0x02190  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
0167  +0x021a8  op=84  03 0e 0e 14  ADD64            s14 = s3 + s14
0168  +0x021c0  op=84  08 19 19 00  ADD64            s25 = s8 + s25
0169  +0x021d8  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
016a  +0x021f0  op=02  0b 0e 06 01  XOR64            s6 = s14 ^ s11
016b  +0x02208  op=68  13 12 0b 15  LSR64_IMM        s11 = (uint64_t)s18 >> 21
016c  +0x02220  op=58  19 0e 00 00  LD64             s14 = *(uint64_t *)(s25 +0x0)
016d  +0x02238  op=58  11 19 00 00  LD64             s25 = *(uint64_t *)(s17 +0x0)
016e  +0x02250  op=58  1d 11 a8 01  LD64             s17 = *(uint64_t *)(s29 +0x1a8)
016f  +0x02268  op=25  1d 06 d0 01  ST64             *(s29 +0x1d0) = s6
0170  +0x02280  op=02  0c 0f 06 01  XOR64            s6 = s15 ^ s12
0171  +0x02298  op=68  03 01 0c 0d  LSR64_IMM        s12 = (uint64_t)s1 >> 13
0172  +0x022b0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0173  +0x022c8  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
0174  +0x022e0  op=84  05 0b 0b 04  ADD64            s11 = s5 + s11
0175  +0x022f8  op=25  1d 06 f8 00  ST64             *(s29 +0xf8) = s6
0176  +0x02310  op=58  1d 06 48 01  LD64             s6 = *(uint64_t *)(s29 +0x148)
0177  +0x02328  op=84  03 0c 0c 00  ADD64            s12 = s3 + s12
0178  +0x02340  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
0179  +0x02358  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
017a  +0x02370  op=02  04 0c 01 00  XOR64            s1 = s12 ^ s4
017b  +0x02388  op=67  00 13 04 0d  LSR64_IMM32PLUS  s4 = (uint64_t)s19 >> (13 + 32)
017c  +0x023a0  op=25  1d 01 e8 00  ST64             *(s29 +0xe8) = s1
017d  +0x023b8  op=02  18 10 01 00  XOR64            s1 = s16 ^ s24
017e  +0x023d0  op=58  1d 10 b8 01  LD64             s16 = *(uint64_t *)(s29 +0x1b8)
017f  +0x023e8  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
0180  +0x02400  op=68  03 07 18 0d  LSR64_IMM        s24 = (uint64_t)s7 >> 13
0181  +0x02418  op=25  1d 01 b0 01  ST64             *(s29 +0x1b0) = s1
0182  +0x02430  op=02  0d 19 01 00  XOR64            s1 = s25 ^ s13
0183  +0x02448  op=58  1d 19 a0 01  LD64             s25 = *(uint64_t *)(s29 +0x1a0)
0184  +0x02460  op=67  00 11 0d 0d  LSR64_IMM32PLUS  s13 = (uint64_t)s17 >> (13 + 32)
0185  +0x02478  op=84  0a 04 04 04  ADD64            s4 = s10 + s4
0186  +0x02490  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0187  +0x024a8  op=25  1d 01 f0 00  ST64             *(s29 +0xf0) = s1
0188  +0x024c0  op=02  14 0e 01 01  XOR64            s1 = s14 ^ s20
0189  +0x024d8  op=58  1d 14 88 01  LD64             s20 = *(uint64_t *)(s29 +0x188)
018a  +0x024f0  op=67  00 10 0c 0d  LSR64_IMM32PLUS  s12 = (uint64_t)s16 >> (13 + 32)
018b  +0x02508  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
018c  +0x02520  op=67  00 07 0e 0d  LSR64_IMM32PLUS  s14 = (uint64_t)s7 >> (13 + 32)
018d  +0x02538  op=25  1d 04 48 02  ST64             *(s29 +0x248) = s4
018e  +0x02550  op=67  00 07 04 05  LSR64_IMM32PLUS  s4 = (uint64_t)s7 >> (5 + 32)
018f  +0x02568  op=25  1d 01 40 01  ST64             *(s29 +0x140) = s1
0190  +0x02580  op=02  02 0b 01 00  XOR64            s1 = s11 ^ s2
0191  +0x02598  op=67  00 06 0b 0d  LSR64_IMM32PLUS  s11 = (uint64_t)s6 >> (13 + 32)
0192  +0x025b0  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
0193  +0x025c8  op=67  00 19 0f 0d  LSR64_IMM32PLUS  s15 = (uint64_t)s25 >> (13 + 32)
0194  +0x025e0  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0195  +0x025f8  op=84  0a 0d 0d 04  ADD64            s13 = s10 + s13
0196  +0x02610  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
0197  +0x02628  op=34  19 00 15 01  OR64             s21 = s25 | s0
0198  +0x02640  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0199  +0x02658  op=25  1d 01 78 01  ST64             *(s29 +0x178) = s1
019a  +0x02670  op=67  00 1e 01 0d  LSR64_IMM32PLUS  s1 = (uint64_t)s30 >> (13 + 32)
019b  +0x02688  op=67  00 14 02 0d  LSR64_IMM32PLUS  s2 = (uint64_t)s20 >> (13 + 32)
019c  +0x026a0  op=84  0a 0c 0c 00  ADD64            s12 = s10 + s12
019d  +0x026b8  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
019e  +0x026d0  op=84  0a 0e 0e 04  ADD64            s14 = s10 + s14
019f  +0x026e8  op=25  1d 0d 10 01  ST64             *(s29 +0x110) = s13
01a0  +0x02700  op=67  00 10 0d 05  LSR64_IMM32PLUS  s13 = (uint64_t)s16 >> (5 + 32)
01a1  +0x02718  op=84  09 04 04 04  ADD64            s4 = s9 + s4
01a2  +0x02730  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
01a3  +0x02748  op=84  0a 0b 0b 00  ADD64            s11 = s10 + s11
01a4  +0x02760  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01a5  +0x02778  op=25  1d 0c 30 01  ST64             *(s29 +0x130) = s12
01a6  +0x02790  op=67  00 14 0c 05  LSR64_IMM32PLUS  s12 = (uint64_t)s20 >> (5 + 32)
01a7  +0x027a8  op=84  0a 0f 0f 00  ADD64            s15 = s10 + s15
01a8  +0x027c0  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
01a9  +0x027d8  op=25  1d 0e 20 01  ST64             *(s29 +0x120) = s14
01aa  +0x027f0  op=67  00 06 0e 05  LSR64_IMM32PLUS  s14 = (uint64_t)s6 >> (5 + 32)
01ab  +0x02808  op=25  1d 04 e8 01  ST64             *(s29 +0x1e8) = s4
01ac  +0x02820  op=68  00 10 04 0d  LSR64_IMM        s4 = (uint64_t)s16 >> 13
01ad  +0x02838  op=25  1d 0b 28 01  ST64             *(s29 +0x128) = s11
01ae  +0x02850  op=67  00 11 0b 05  LSR64_IMM32PLUS  s11 = (uint64_t)s17 >> (5 + 32)
01af  +0x02868  op=84  0a 01 01 00  ADD64            s1 = s10 + s1
01b0  +0x02880  op=84  0a 02 02 14  ADD64            s2 = s10 + s2
01b1  +0x02898  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
01b2  +0x028b0  op=25  1d 0f 08 01  ST64             *(s29 +0x108) = s15
01b3  +0x028c8  op=67  00 19 0f 05  LSR64_IMM32PLUS  s15 = (uint64_t)s25 >> (5 + 32)
01b4  +0x028e0  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
01b5  +0x028f8  op=84  09 0d 0d 14  ADD64            s13 = s9 + s13
01b6  +0x02910  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
01b7  +0x02928  op=34  10 00 0a 00  OR64             s10 = s16 | s0
01b8  +0x02940  op=68  03 19 19 0d  LSR64_IMM        s25 = (uint64_t)s25 >> 13
01b9  +0x02958  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
01ba  +0x02970  op=25  1d 01 58 02  ST64             *(s29 +0x258) = s1
01bb  +0x02988  op=67  00 13 01 05  LSR64_IMM32PLUS  s1 = (uint64_t)s19 >> (5 + 32)
01bc  +0x029a0  op=25  1d 02 78 02  ST64             *(s29 +0x278) = s2
01bd  +0x029b8  op=67  00 1e 02 05  LSR64_IMM32PLUS  s2 = (uint64_t)s30 >> (5 + 32)
01be  +0x029d0  op=84  09 0c 0c 04  ADD64            s12 = s9 + s12
01bf  +0x029e8  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
01c0  +0x02a00  op=84  09 0e 0e 04  ADD64            s14 = s9 + s14
01c1  +0x02a18  op=25  1d 0d e0 01  ST64             *(s29 +0x1e0) = s13
01c2  +0x02a30  op=84  03 04 04 00  ADD64            s4 = s3 + s4
01c3  +0x02a48  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
01c4  +0x02a60  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
01c5  +0x02a78  op=84  09 0b 0b 04  ADD64            s11 = s9 + s11
01c6  +0x02a90  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01c7  +0x02aa8  op=25  1d 0c d8 01  ST64             *(s29 +0x1d8) = s12
01c8  +0x02ac0  op=84  09 0f 0f 00  ADD64            s15 = s9 + s15
01c9  +0x02ad8  op=25  1d 0e f0 01  ST64             *(s29 +0x1f0) = s14
01ca  +0x02af0  op=25  1d 04 18 02  ST64             *(s29 +0x218) = s4
01cb  +0x02b08  op=67  00 14 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s20 >> (21 + 32)
01cc  +0x02b20  op=25  1d 0b 08 02  ST64             *(s29 +0x208) = s11
01cd  +0x02b38  op=84  09 01 01 00  ADD64            s1 = s9 + s1
01ce  +0x02b50  op=68  00 14 0b 0d  LSR64_IMM        s11 = (uint64_t)s20 >> 13
01cf  +0x02b68  op=84  09 02 02 14  ADD64            s2 = s9 + s2
01d0  +0x02b80  op=34  06 00 09 01  OR64             s9 = s6 | s0
01d1  +0x02b98  op=25  1d 0f f8 01  ST64             *(s29 +0x1f8) = s15
01d2  +0x02bb0  op=25  1d 01 60 02  ST64             *(s29 +0x260) = s1
01d3  +0x02bc8  op=68  03 11 01 0d  LSR64_IMM        s1 = (uint64_t)s17 >> 13
01d4  +0x02be0  op=b2  0b 0c f8 07  AND64_IMM16      s12 = s11 & 0x7f8
01d5  +0x02bf8  op=68  13 1e 0b 0d  LSR64_IMM        s11 = (uint64_t)s30 >> 13
01d6  +0x02c10  op=25  1d 02 70 02  ST64             *(s29 +0x270) = s2
01d7  +0x02c28  op=68  03 06 02 0d  LSR64_IMM        s2 = (uint64_t)s6 >> 13
01d8  +0x02c40  op=34  10 00 06 01  OR64             s6 = s16 | s0
01d9  +0x02c58  op=68  13 13 10 0d  LSR64_IMM        s16 = (uint64_t)s19 >> 13
01da  +0x02c70  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
01db  +0x02c88  op=b2  0b 0d f8 07  AND64_IMM16      s13 = s11 & 0x7f8
01dc  +0x02ca0  op=68  13 12 0b 0d  LSR64_IMM        s11 = (uint64_t)s18 >> 13
01dd  +0x02cb8  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01de  +0x02cd0  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
01df  +0x02ce8  op=68  13 14 12 15  LSR64_IMM        s18 = (uint64_t)s20 >> 21
01e0  +0x02d00  op=b2  0b 0e f8 07  AND64_IMM16      s14 = s11 & 0x7f8
01e1  +0x02d18  op=68  13 16 0b 0d  LSR64_IMM        s11 = (uint64_t)s22 >> 13
01e2  +0x02d30  op=84  03 01 01 14  ADD64            s1 = s3 + s1
01e3  +0x02d48  op=84  03 02 02 04  ADD64            s2 = s3 + s2
01e4  +0x02d60  op=34  13 00 16 00  OR64             s22 = s19 | s0
01e5  +0x02d78  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
01e6  +0x02d90  op=b2  0b 0f f8 07  AND64_IMM16      s15 = s11 & 0x7f8
01e7  +0x02da8  op=25  1d 01 38 02  ST64             *(s29 +0x238) = s1
01e8  +0x02dc0  op=84  03 10 01 00  ADD64            s1 = s3 + s16
01e9  +0x02dd8  op=25  1d 02 10 02  ST64             *(s29 +0x210) = s2
01ea  +0x02df0  op=67  00 06 02 15  LSR64_IMM32PLUS  s2 = (uint64_t)s6 >> (21 + 32)
01eb  +0x02e08  op=68  00 17 0b 0d  LSR64_IMM        s11 = (uint64_t)s23 >> 13
01ec  +0x02e20  op=58  1d 17 c8 02  LD64             s23 = *(uint64_t *)(s29 +0x2c8)
01ed  +0x02e38  op=68  03 13 10 15  LSR64_IMM        s16 = (uint64_t)s19 >> 21
01ee  +0x02e50  op=84  03 0f 0a 04  ADD64            s10 = s3 + s15
01ef  +0x02e68  op=25  1d 01 28 02  ST64             *(s29 +0x228) = s1
01f0  +0x02e80  op=84  03 19 01 04  ADD64            s1 = s3 + s25
01f1  +0x02e98  op=b2  04 0f f8 07  AND64_IMM16      s15 = s4 & 0x7f8
01f2  +0x02eb0  op=67  00 1e 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s30 >> (21 + 32)
01f3  +0x02ec8  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01f4  +0x02ee0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
01f5  +0x02ef8  op=68  03 15 19 15  LSR64_IMM        s25 = (uint64_t)s21 >> 21
01f6  +0x02f10  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
01f7  +0x02f28  op=25  1d 0a e0 00  ST64             *(s29 +0xe0) = s10
01f8  +0x02f40  op=84  03 0e 0a 00  ADD64            s10 = s3 + s14
01f9  +0x02f58  op=25  1d 01 50 02  ST64             *(s29 +0x250) = s1
01fa  +0x02f70  op=84  03 18 01 14  ADD64            s1 = s3 + s24
01fb  +0x02f88  op=b2  04 18 f8 07  AND64_IMM16      s24 = s4 & 0x7f8
01fc  +0x02fa0  op=67  00 09 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s9 >> (21 + 32)
01fd  +0x02fb8  op=84  1f 02 02 14  ADD64            s2 = s31 + s2
01fe  +0x02fd0  op=84  03 0b 0b 04  ADD64            s11 = s3 + s11
01ff  +0x02fe8  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
0200  +0x03000  op=25  1d 0a 00 01  ST64             *(s29 +0x100) = s10
0201  +0x03018  op=84  03 0d 0a 14  ADD64            s10 = s3 + s13
0202  +0x03030  op=b2  04 0e f8 07  AND64_IMM16      s14 = s4 & 0x7f8
0203  +0x03048  op=25  1d 02 20 02  ST64             *(s29 +0x220) = s2
0204  +0x03060  op=68  13 17 02 15  LSR64_IMM        s2 = (uint64_t)s23 >> 21
0205  +0x03078  op=67  00 13 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s19 >> (21 + 32)
0206  +0x03090  op=68  00 06 13 15  LSR64_IMM        s19 = (uint64_t)s6 >> 21
0207  +0x030a8  op=25  1d 01 68 02  ST64             *(s29 +0x268) = s1
0208  +0x030c0  op=67  00 15 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s21 >> (21 + 32)
0209  +0x030d8  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
020a  +0x030f0  op=25  1d 0a 40 02  ST64             *(s29 +0x240) = s10
020b  +0x03108  op=84  03 0c 0a 14  ADD64            s10 = s3 + s12
020c  +0x03120  op=84  1f 0e 03 04  ADD64            s3 = s31 + s14
020d  +0x03138  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
020e  +0x03150  op=b2  13 13 f8 07  AND64_IMM16      s19 = s19 & 0x7f8
020f  +0x03168  op=b2  04 0d f8 07  AND64_IMM16      s13 = s4 & 0x7f8
0210  +0x03180  op=67  00 11 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s17 >> (21 + 32)
0211  +0x03198  op=34  11 00 0e 01  OR64             s14 = s17 | s0
0212  +0x031b0  op=67  00 07 0c 15  LSR64_IMM32PLUS  s12 = (uint64_t)s7 >> (21 + 32)
0213  +0x031c8  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
0214  +0x031e0  op=25  1d 03 d0 00  ST64             *(s29 +0xd0) = s3
0215  +0x031f8  op=84  1f 18 03 00  ADD64            s3 = s31 + s24
0216  +0x03210  op=84  05 02 02 00  ADD64            s2 = s5 + s2
0217  +0x03228  op=25  1d 0a 30 02  ST64             *(s29 +0x230) = s10
0218  +0x03240  op=34  11 00 0a 01  OR64             s10 = s17 | s0
0219  +0x03258  op=68  03 07 18 15  LSR64_IMM        s24 = (uint64_t)s7 >> 21
021a  +0x03270  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
021b  +0x03288  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
021c  +0x032a0  op=84  1f 01 01 00  ADD64            s1 = s31 + s1
021d  +0x032b8  op=84  1f 0d 0d 00  ADD64            s13 = s31 + s13
021e  +0x032d0  op=58  1d 07 d0 01  LD64             s7 = *(uint64_t *)(s29 +0x1d0)
021f  +0x032e8  op=25  1d 03 60 01  ST64             *(s29 +0x160) = s3
0220  +0x03300  op=84  1f 0f 03 04  ADD64            s3 = s31 + s15
0221  +0x03318  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0222  +0x03330  op=68  13 11 0f 15  LSR64_IMM        s15 = (uint64_t)s17 >> 21
0223  +0x03348  op=68  03 1e 11 15  LSR64_IMM        s17 = (uint64_t)s30 >> 21
0224  +0x03360  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0225  +0x03378  op=84  1f 04 04 04  ADD64            s4 = s31 + s4
0226  +0x03390  op=84  1f 0c 0c 04  ADD64            s12 = s31 + s12
0227  +0x033a8  op=34  1e 00 1f 00  OR64             s31 = s30 | s0
0228  +0x033c0  op=34  06 00 1e 01  OR64             s30 = s6 | s0
0229  +0x033d8  op=58  1d 06 f0 00  LD64             s6 = *(uint64_t *)(s29 +0xf0)
022a  +0x033f0  op=58  1d 0a 98 02  LD64             s10 = *(uint64_t *)(s29 +0x298)
022b  +0x03408  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
022c  +0x03420  op=25  1d 03 c0 01  ST64             *(s29 +0x1c0) = s3
022d  +0x03438  op=58  1d 03 00 02  LD64             s3 = *(uint64_t *)(s29 +0x200)
022e  +0x03450  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
022f  +0x03468  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
0230  +0x03480  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
0231  +0x03498  op=02  06 0b 0b 01  XOR64            s11 = s11 ^ s6
0232  +0x034b0  op=58  1d 06 b0 01  LD64             s6 = *(uint64_t *)(s29 +0x1b0)
0233  +0x034c8  op=02  03 02 02 00  XOR64            s2 = s2 ^ s3
0234  +0x034e0  op=84  05 13 03 04  ADD64            s3 = s5 + s19
0235  +0x034f8  op=25  1d 02 d8 00  ST64             *(s29 +0xd8) = s2
0236  +0x03510  op=68  00 09 02 15  LSR64_IMM        s2 = (uint64_t)s9 >> 21
0237  +0x03528  op=25  1d 03 98 01  ST64             *(s29 +0x198) = s3
0238  +0x03540  op=84  05 12 03 04  ADD64            s3 = s5 + s18
0239  +0x03558  op=58  1d 12 c0 02  LD64             s18 = *(uint64_t *)(s29 +0x2c0)
023a  +0x03570  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
023b  +0x03588  op=25  1d 03 80 01  ST64             *(s29 +0x180) = s3
023c  +0x035a0  op=84  05 11 03 04  ADD64            s3 = s5 + s17
023d  +0x035b8  op=58  1d 11 b8 02  LD64             s17 = *(uint64_t *)(s29 +0x2b8)
023e  +0x035d0  op=25  1d 03 68 01  ST64             *(s29 +0x168) = s3
023f  +0x035e8  op=84  05 10 03 04  ADD64            s3 = s5 + s16
0240  +0x03600  op=84  05 02 02 04  ADD64            s2 = s5 + s2
0241  +0x03618  op=b2  17 10 ff 00  AND64_IMM16      s16 = s23 & 0xff
0242  +0x03630  op=25  1d 03 58 01  ST64             *(s29 +0x158) = s3
0243  +0x03648  op=84  05 19 03 00  ADD64            s3 = s5 + s25
0244  +0x03660  op=25  1d 02 70 01  ST64             *(s29 +0x170) = s2
0245  +0x03678  op=68  00 11 02 05  LSR64_IMM        s2 = (uint64_t)s17 >> 5
0246  +0x03690  op=68  00 12 19 05  LSR64_IMM        s25 = (uint64_t)s18 >> 5
0247  +0x036a8  op=6e  02 10 10 03  SHL64_IMM        s16 = s16 << 3
0248  +0x036c0  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
0249  +0x036d8  op=25  1d 03 90 01  ST64             *(s29 +0x190) = s3
024a  +0x036f0  op=84  05 18 03 00  ADD64            s3 = s5 + s24
024b  +0x03708  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
024c  +0x03720  op=84  08 02 02 00  ADD64            s2 = s8 + s2
024d  +0x03738  op=25  1d 03 c8 01  ST64             *(s29 +0x1c8) = s3
024e  +0x03750  op=84  05 0f 03 04  ADD64            s3 = s5 + s15
024f  +0x03768  op=84  08 19 19 00  ADD64            s25 = s8 + s25
0250  +0x03780  op=68  03 17 0f 05  LSR64_IMM        s15 = (uint64_t)s23 >> 5
0251  +0x03798  op=58  1d 05 f8 00  LD64             s5 = *(uint64_t *)(s29 +0xf8)
0252  +0x037b0  op=25  1d 03 00 02  ST64             *(s29 +0x200) = s3
0253  +0x037c8  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0254  +0x037e0  op=58  1d 03 e8 00  LD64             s3 = *(uint64_t *)(s29 +0xe8)
0255  +0x037f8  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
0256  +0x03810  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
0257  +0x03828  op=84  08 0f 0f 00  ADD64            s15 = s8 + s15
0258  +0x03840  op=02  03 02 02 00  XOR64            s2 = s2 ^ s3
0259  +0x03858  op=34  17 00 03 01  OR64             s3 = s23 | s0
025a  +0x03870  op=02  06 19 19 01  XOR64            s25 = s25 ^ s6
025b  +0x03888  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
025c  +0x038a0  op=58  1d 06 90 02  LD64             s6 = *(uint64_t *)(s29 +0x290)
025d  +0x038b8  op=58  1d 03 b8 00  LD64             s3 = *(uint64_t *)(s29 +0xb8)
025e  +0x038d0  op=02  05 0f 0f 00  XOR64            s15 = s15 ^ s5
025f  +0x038e8  op=58  1d 05 88 02  LD64             s5 = *(uint64_t *)(s29 +0x288)
0260  +0x03900  op=84  03 10 10 04  ADD64            s16 = s3 + s16
0261  +0x03918  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
0262  +0x03930  op=68  13 05 18 05  LSR64_IMM        s24 = (uint64_t)s5 >> 5
0263  +0x03948  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0264  +0x03960  op=02  19 10 10 01  XOR64            s16 = s16 ^ s25
0265  +0x03978  op=68  03 0a 19 05  LSR64_IMM        s25 = (uint64_t)s10 >> 5
0266  +0x03990  op=84  08 18 18 04  ADD64            s24 = s8 + s24
0267  +0x039a8  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
0268  +0x039c0  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
0269  +0x039d8  op=25  1d 10 d0 01  ST64             *(s29 +0x1d0) = s16
026a  +0x039f0  op=84  08 19 19 00  ADD64            s25 = s8 + s25
026b  +0x03a08  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
026c  +0x03a20  op=02  07 18 18 01  XOR64            s24 = s24 ^ s7
026d  +0x03a38  op=58  1d 07 a0 02  LD64             s7 = *(uint64_t *)(s29 +0x2a0)
026e  +0x03a50  op=02  0b 19 0b 01  XOR64            s11 = s25 ^ s11
026f  +0x03a68  op=b2  06 19 ff 00  AND64_IMM16      s25 = s6 & 0xff
0270  +0x03a80  op=34  07 00 17 00  OR64             s23 = s7 | s0
0271  +0x03a98  op=6e  12 19 19 03  SHL64_IMM        s25 = s25 << 3
0272  +0x03ab0  op=84  03 19 19 00  ADD64            s25 = s3 + s25
0273  +0x03ac8  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
0274  +0x03ae0  op=02  18 19 19 01  XOR64            s25 = s25 ^ s24
0275  +0x03af8  op=b2  05 18 ff 00  AND64_IMM16      s24 = s5 & 0xff
0276  +0x03b10  op=6e  00 18 18 03  SHL64_IMM        s24 = s24 << 3
0277  +0x03b28  op=25  1d 19 b0 01  ST64             *(s29 +0x1b0) = s25
0278  +0x03b40  op=84  03 18 18 00  ADD64            s24 = s3 + s24
0279  +0x03b58  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
027a  +0x03b70  op=02  0f 18 06 01  XOR64            s6 = s24 ^ s15
027b  +0x03b88  op=b2  12 0f ff 00  AND64_IMM16      s15 = s18 & 0xff
027c  +0x03ba0  op=34  1e 00 18 01  OR64             s24 = s30 | s0
027d  +0x03bb8  op=6e  00 0f 0f 03  SHL64_IMM        s15 = s15 << 3
027e  +0x03bd0  op=02  01 06 01 01  XOR64            s1 = s6 ^ s1
027f  +0x03be8  op=25  1d 06 88 02  ST64             *(s29 +0x288) = s6
0280  +0x03c00  op=58  1d 06 80 02  LD64             s6 = *(uint64_t *)(s29 +0x280)
0281  +0x03c18  op=84  03 0f 0f 00  ADD64            s15 = s3 + s15
0282  +0x03c30  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
0283  +0x03c48  op=02  02 0f 05 01  XOR64            s5 = s15 ^ s2
0284  +0x03c60  op=b2  11 02 ff 00  AND64_IMM16      s2 = s17 & 0xff
0285  +0x03c78  op=6e  00 02 02 03  SHL64_IMM        s2 = s2 << 3
0286  +0x03c90  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
0287  +0x03ca8  op=25  1d 05 c8 02  ST64             *(s29 +0x2c8) = s5
0288  +0x03cc0  op=34  1f 00 05 01  OR64             s5 = s31 | s0
0289  +0x03cd8  op=84  03 02 02 00  ADD64            s2 = s3 + s2
028a  +0x03cf0  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
028b  +0x03d08  op=02  0b 02 0f 01  XOR64            s15 = s2 ^ s11
028c  +0x03d20  op=58  1d 02 08 01  LD64             s2 = *(uint64_t *)(s29 +0x108)
028d  +0x03d38  op=58  0c 0b 00 00  LD64             s11 = *(uint64_t *)(s12 +0x0)
028e  +0x03d50  op=68  13 14 0c 1d  LSR64_IMM        s12 = (uint64_t)s20 >> 29
028f  +0x03d68  op=25  1d 0f c0 02  ST64             *(s29 +0x2c0) = s15
0290  +0x03d80  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
0291  +0x03d98  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0292  +0x03db0  op=02  0b 10 0b 00  XOR64            s11 = s16 ^ s11
0293  +0x03dc8  op=34  0e 00 10 01  OR64             s16 = s14 | s0
0294  +0x03de0  op=84  06 0c 0c 14  ADD64            s12 = s6 + s12
0295  +0x03df8  op=02  0b 02 02 01  XOR64            s2 = s2 ^ s11
0296  +0x03e10  op=58  0d 0b 00 00  LD64             s11 = *(uint64_t *)(s13 +0x0)
0297  +0x03e28  op=68  13 1f 0d 1d  LSR64_IMM        s13 = (uint64_t)s31 >> 29
0298  +0x03e40  op=25  1d 02 b8 02  ST64             *(s29 +0x2b8) = s2
0299  +0x03e58  op=b2  0a 02 ff 00  AND64_IMM16      s2 = s10 & 0xff
029a  +0x03e70  op=58  1d 0a 40 01  LD64             s10 = *(uint64_t *)(s29 +0x140)
029b  +0x03e88  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
029c  +0x03ea0  op=6e  02 02 02 03  SHL64_IMM        s2 = s2 << 3
029d  +0x03eb8  op=02  0b 0f 0b 00  XOR64            s11 = s15 ^ s11
029e  +0x03ed0  op=84  06 0d 0d 00  ADD64            s13 = s6 + s13
029f  +0x03ee8  op=68  00 15 0f 1d  LSR64_IMM        s15 = (uint64_t)s21 >> 29
02a0  +0x03f00  op=84  03 02 02 14  ADD64            s2 = s3 + s2
02a1  +0x03f18  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
02a2  +0x03f30  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02a3  +0x03f48  op=84  06 0f 0f 00  ADD64            s15 = s6 + s15
02a4  +0x03f60  op=02  0a 02 0a 01  XOR64            s10 = s2 ^ s10
02a5  +0x03f78  op=58  1d 02 10 01  LD64             s2 = *(uint64_t *)(s29 +0x110)
02a6  +0x03f90  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02a7  +0x03fa8  op=02  0b 02 02 01  XOR64            s2 = s2 ^ s11
02a8  +0x03fc0  op=68  00 1e 0b 1d  LSR64_IMM        s11 = (uint64_t)s30 >> 29
02a9  +0x03fd8  op=25  1d 02 f0 00  ST64             *(s29 +0xf0) = s2
02aa  +0x03ff0  op=58  1d 02 20 01  LD64             s2 = *(uint64_t *)(s29 +0x120)
02ab  +0x04008  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
02ac  +0x04020  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02ad  +0x04038  op=02  04 02 02 01  XOR64            s2 = s2 ^ s4
02ae  +0x04050  op=68  13 0e 04 1d  LSR64_IMM        s4 = (uint64_t)s14 >> 29
02af  +0x04068  op=68  03 07 0e 1d  LSR64_IMM        s14 = (uint64_t)s7 >> 29
02b0  +0x04080  op=25  1d 02 e8 00  ST64             *(s29 +0xe8) = s2
02b1  +0x04098  op=58  1d 02 28 01  LD64             s2 = *(uint64_t *)(s29 +0x128)
02b2  +0x040b0  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
02b3  +0x040c8  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
02b4  +0x040e0  op=84  06 0e 11 14  ADD64            s17 = s6 + s14
02b5  +0x040f8  op=84  06 0b 0e 14  ADD64            s14 = s6 + s11
02b6  +0x04110  op=84  06 04 04 04  ADD64            s4 = s6 + s4
02b7  +0x04128  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02b8  +0x04140  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
02b9  +0x04158  op=02  01 02 01 00  XOR64            s1 = s2 ^ s1
02ba  +0x04170  op=58  1d 02 d0 00  LD64             s2 = *(uint64_t *)(s29 +0xd0)
02bb  +0x04188  op=25  1d 0c d0 00  ST64             *(s29 +0xd0) = s12
02bc  +0x041a0  op=25  1d 01 c8 00  ST64             *(s29 +0xc8) = s1
02bd  +0x041b8  op=58  1d 01 30 01  LD64             s1 = *(uint64_t *)(s29 +0x130)
02be  +0x041d0  op=25  1d 04 30 01  ST64             *(s29 +0x130) = s4
02bf  +0x041e8  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02c0  +0x04200  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02c1  +0x04218  op=02  02 19 02 00  XOR64            s2 = s25 ^ s2
02c2  +0x04230  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2
02c3  +0x04248  op=58  1d 02 78 01  LD64             s2 = *(uint64_t *)(s29 +0x178)
02c4  +0x04260  op=25  1d 01 c0 00  ST64             *(s29 +0xc0) = s1
02c5  +0x04278  op=58  1d 01 e0 00  LD64             s1 = *(uint64_t *)(s29 +0xe0)
02c6  +0x04290  op=25  1d 0d e0 00  ST64             *(s29 +0xe0) = s13
02c7  +0x042a8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02c8  +0x042c0  op=02  02 01 12 01  XOR64            s18 = s1 ^ s2
02c9  +0x042d8  op=68  13 09 01 1d  LSR64_IMM        s1 = (uint64_t)s9 >> 29
02ca  +0x042f0  op=68  13 16 02 1d  LSR64_IMM        s2 = (uint64_t)s22 >> 29
02cb  +0x04308  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
02cc  +0x04320  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
02cd  +0x04338  op=84  06 01 0d 00  ADD64            s13 = s6 + s1
02ce  +0x04350  op=58  1d 01 00 01  LD64             s1 = *(uint64_t *)(s29 +0x100)
02cf  +0x04368  op=84  06 02 02 00  ADD64            s2 = s6 + s2
02d0  +0x04380  op=58  1d 06 a8 02  LD64             s6 = *(uint64_t *)(s29 +0x2a8)
02d1  +0x04398  op=25  1d 02 98 02  ST64             *(s29 +0x298) = s2
02d2  +0x043b0  op=58  1d 02 d8 00  LD64             s2 = *(uint64_t *)(s29 +0xd8)
02d3  +0x043c8  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
02d4  +0x043e0  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02d5  +0x043f8  op=02  02 01 01 01  XOR64            s1 = s1 ^ s2
02d6  +0x04410  op=25  1d 01 f8 00  ST64             *(s29 +0xf8) = s1
02d7  +0x04428  op=b2  1e 01 ff 00  AND64_IMM16      s1 = s30 & 0xff
02d8  +0x04440  op=6e  02 01 02 03  SHL64_IMM        s2 = s1 << 3
02d9  +0x04458  op=b2  09 01 ff 00  AND64_IMM16      s1 = s9 & 0xff
02da  +0x04470  op=6e  00 01 04 03  SHL64_IMM        s4 = s1 << 3
02db  +0x04488  op=b2  1f 01 ff 00  AND64_IMM16      s1 = s31 & 0xff
02dc  +0x044a0  op=84  03 02 02 14  ADD64            s2 = s3 + s2
02dd  +0x044b8  op=6e  02 01 0b 03  SHL64_IMM        s11 = s1 << 3
02de  +0x044d0  op=b2  06 01 ff 00  AND64_IMM16      s1 = s6 & 0xff
02df  +0x044e8  op=25  1d 02 40 01  ST64             *(s29 +0x140) = s2
02e0  +0x04500  op=84  03 04 04 00  ADD64            s4 = s3 + s4
02e1  +0x04518  op=6e  00 01 0c 03  SHL64_IMM        s12 = s1 << 3
02e2  +0x04530  op=b2  15 01 ff 00  AND64_IMM16      s1 = s21 & 0xff
02e3  +0x04548  op=84  03 0b 0b 00  ADD64            s11 = s3 + s11
02e4  +0x04560  op=25  1d 04 78 01  ST64             *(s29 +0x178) = s4
02e5  +0x04578  op=68  00 05 04 05  LSR64_IMM        s4 = (uint64_t)s5 >> 5
02e6  +0x04590  op=6e  00 01 18 03  SHL64_IMM        s24 = s1 << 3
02e7  +0x045a8  op=b2  07 01 ff 00  AND64_IMM16      s1 = s7 & 0xff
02e8  +0x045c0  op=34  10 00 07 01  OR64             s7 = s16 | s0
02e9  +0x045d8  op=25  1d 0b 10 01  ST64             *(s29 +0x110) = s11
02ea  +0x045f0  op=68  13 16 0b 05  LSR64_IMM        s11 = (uint64_t)s22 >> 5
02eb  +0x04608  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
02ec  +0x04620  op=6e  02 01 19 03  SHL64_IMM        s25 = s1 << 3
02ed  +0x04638  op=b2  10 01 ff 00  AND64_IMM16      s1 = s16 & 0xff
02ee  +0x04650  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
02ef  +0x04668  op=6e  00 01 10 03  SHL64_IMM        s16 = s1 << 3
02f0  +0x04680  op=b2  16 01 ff 00  AND64_IMM16      s1 = s22 & 0xff
02f1  +0x04698  op=6e  12 01 13 03  SHL64_IMM        s19 = s1 << 3
02f2  +0x046b0  op=b2  14 01 ff 00  AND64_IMM16      s1 = s20 & 0xff
02f3  +0x046c8  op=84  03 13 02 00  ADD64            s2 = s3 + s19
02f4  +0x046e0  op=6e  02 01 1f 03  SHL64_IMM        s31 = s1 << 3
02f5  +0x046f8  op=58  1d 01 38 01  LD64             s1 = *(uint64_t *)(s29 +0x138)
02f6  +0x04710  op=84  03 0c 13 04  ADD64            s19 = s3 + s12
02f7  +0x04728  op=68  00 17 0c 05  LSR64_IMM        s12 = (uint64_t)s23 >> 5
02f8  +0x04740  op=25  1d 02 38 01  ST64             *(s29 +0x138) = s2
02f9  +0x04758  op=84  03 10 02 14  ADD64            s2 = s3 + s16
02fa  +0x04770  op=84  03 1f 1f 00  ADD64            s31 = s3 + s31
02fb  +0x04788  op=84  08 04 10 04  ADD64            s16 = s8 + s4
02fc  +0x047a0  op=25  1d 02 20 01  ST64             *(s29 +0x120) = s2
02fd  +0x047b8  op=84  03 19 02 04  ADD64            s2 = s3 + s25
02fe  +0x047d0  op=b2  01 01 ff 00  AND64_IMM16      s1 = s1 & 0xff
02ff  +0x047e8  op=68  00 15 19 05  LSR64_IMM        s25 = (uint64_t)s21 >> 5
0300  +0x04800  op=25  1d 1f 28 01  ST64             *(s29 +0x128) = s31
0301  +0x04818  op=b2  0c 15 f8 07  AND64_IMM16      s21 = s12 & 0x7f8
0302  +0x04830  op=25  1d 02 08 01  ST64             *(s29 +0x108) = s2
0303  +0x04848  op=84  03 18 02 04  ADD64            s2 = s3 + s24
0304  +0x04860  op=68  03 09 18 05  LSR64_IMM        s24 = (uint64_t)s9 >> 5
0305  +0x04878  op=6e  12 01 01 03  SHL64_IMM        s1 = s1 << 3
0306  +0x04890  op=b2  19 16 f8 07  AND64_IMM16      s22 = s25 & 0x7f8
0307  +0x048a8  op=68  00 06 19 05  LSR64_IMM        s25 = (uint64_t)s6 >> 5
0308  +0x048c0  op=58  1d 06 c0 00  LD64             s6 = *(uint64_t *)(s29 +0xc0)
0309  +0x048d8  op=84  08 15 04 04  ADD64            s4 = s8 + s21
030a  +0x048f0  op=58  1d 09 30 02  LD64             s9 = *(uint64_t *)(s29 +0x230)
030b  +0x04908  op=25  1d 02 00 01  ST64             *(s29 +0x100) = s2
030c  +0x04920  op=68  00 14 02 05  LSR64_IMM        s2 = (uint64_t)s20 >> 5
030d  +0x04938  op=b2  18 1f f8 07  AND64_IMM16      s31 = s24 & 0x7f8
030e  +0x04950  op=68  00 07 18 05  LSR64_IMM        s24 = (uint64_t)s7 >> 5
030f  +0x04968  op=84  03 01 01 14  ADD64            s1 = s3 + s1
0310  +0x04980  op=b2  19 03 f8 07  AND64_IMM16      s3 = s25 & 0x7f8
0311  +0x04998  op=84  08 16 17 04  ADD64            s23 = s8 + s22
0312  +0x049b0  op=58  1d 07 60 01  LD64             s7 = *(uint64_t *)(s29 +0x160)
0313  +0x049c8  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
0314  +0x049e0  op=b2  02 0c f8 07  AND64_IMM16      s12 = s2 & 0x7f8
0315  +0x049f8  op=b2  18 05 f8 07  AND64_IMM16      s5 = s24 & 0x7f8
0316  +0x04a10  op=84  08 03 03 14  ADD64            s3 = s8 + s3
0317  +0x04a28  op=68  00 1e 02 05  LSR64_IMM        s2 = (uint64_t)s30 >> 5
0318  +0x04a40  op=84  08 1f 1e 00  ADD64            s30 = s8 + s31
0319  +0x04a58  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
031a  +0x04a70  op=84  08 0c 19 00  ADD64            s25 = s8 + s12
031b  +0x04a88  op=84  08 0b 0c 04  ADD64            s12 = s8 + s11
031c  +0x04aa0  op=84  08 05 0b 00  ADD64            s11 = s8 + s5
031d  +0x04ab8  op=58  1d 05 d8 01  LD64             s5 = *(uint64_t *)(s29 +0x1d8)
031e  +0x04ad0  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
031f  +0x04ae8  op=58  07 1f 00 00  LD64             s31 = *(uint64_t *)(s7 +0x0)
0320  +0x04b00  op=58  1d 07 08 02  LD64             s7 = *(uint64_t *)(s29 +0x208)
0321  +0x04b18  op=b2  02 18 f8 07  AND64_IMM16      s24 = s2 & 0x7f8
0322  +0x04b30  op=58  1d 02 90 02  LD64             s2 = *(uint64_t *)(s29 +0x290)
0323  +0x04b48  op=84  08 18 18 14  ADD64            s24 = s8 + s24
0324  +0x04b60  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
0325  +0x04b78  op=02  12 03 03 00  XOR64            s3 = s3 ^ s18
0326  +0x04b90  op=02  1f 0a 1f 00  XOR64            s31 = s10 ^ s31
0327  +0x04ba8  op=68  00 02 02 05  LSR64_IMM        s2 = (uint64_t)s2 >> 5
0328  +0x04bc0  op=02  03 01 01 01  XOR64            s1 = s1 ^ s3
0329  +0x04bd8  op=58  1d 03 98 00  LD64             s3 = *(uint64_t *)(s29 +0x98)
032a  +0x04bf0  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
032b  +0x04c08  op=02  06 05 05 01  XOR64            s5 = s5 ^ s6
032c  +0x04c20  op=58  1d 06 e0 01  LD64             s6 = *(uint64_t *)(s29 +0x1e0)
032d  +0x04c38  op=84  08 02 02 00  ADD64            s2 = s8 + s2
032e  +0x04c50  op=58  1d 08 80 01  LD64             s8 = *(uint64_t *)(s29 +0x180)
032f  +0x04c68  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0330  +0x04c80  op=58  06 12 00 00  LD64             s18 = *(uint64_t *)(s6 +0x0)
0331  +0x04c98  op=58  1d 06 c8 00  LD64             s6 = *(uint64_t *)(s29 +0xc8)
0332  +0x04cb0  op=02  06 12 12 00  XOR64            s18 = s18 ^ s6
0333  +0x04cc8  op=58  1d 06 f0 01  LD64             s6 = *(uint64_t *)(s29 +0x1f0)
0334  +0x04ce0  op=58  06 14 00 00  LD64             s20 = *(uint64_t *)(s6 +0x0)
0335  +0x04cf8  op=58  1d 06 b8 02  LD64             s6 = *(uint64_t *)(s29 +0x2b8)
0336  +0x04d10  op=25  1d 0a b8 02  ST64             *(s29 +0x2b8) = s10
0337  +0x04d28  op=02  06 14 14 01  XOR64            s20 = s20 ^ s6
0338  +0x04d40  op=58  1d 06 f8 01  LD64             s6 = *(uint64_t *)(s29 +0x1f8)
0339  +0x04d58  op=58  06 15 00 00  LD64             s21 = *(uint64_t *)(s6 +0x0)
033a  +0x04d70  op=58  1d 06 e8 00  LD64             s6 = *(uint64_t *)(s29 +0xe8)
033b  +0x04d88  op=02  06 15 15 00  XOR64            s21 = s21 ^ s6
033c  +0x04da0  op=58  1d 06 e8 01  LD64             s6 = *(uint64_t *)(s29 +0x1e8)
033d  +0x04db8  op=02  15 0d 0d 00  XOR64            s13 = s13 ^ s21
033e  +0x04dd0  op=58  0e 15 00 00  LD64             s21 = *(uint64_t *)(s14 +0x0)
033f  +0x04de8  op=58  06 16 00 00  LD64             s22 = *(uint64_t *)(s6 +0x0)
0340  +0x04e00  op=58  1d 06 f0 00  LD64             s6 = *(uint64_t *)(s29 +0xf0)
0341  +0x04e18  op=02  14 15 14 01  XOR64            s20 = s21 ^ s20
0342  +0x04e30  op=58  17 15 00 00  LD64             s21 = *(uint64_t *)(s23 +0x0)
0343  +0x04e48  op=02  06 16 16 00  XOR64            s22 = s22 ^ s6
0344  +0x04e60  op=58  1d 06 48 02  LD64             s6 = *(uint64_t *)(s29 +0x248)
0345  +0x04e78  op=58  06 06 00 00  LD64             s6 = *(uint64_t *)(s6 +0x0)
0346  +0x04e90  op=02  1f 06 06 01  XOR64            s6 = s6 ^ s31
0347  +0x04ea8  op=58  07 1f 00 00  LD64             s31 = *(uint64_t *)(s7 +0x0)
0348  +0x04ec0  op=58  1d 07 d0 00  LD64             s7 = *(uint64_t *)(s29 +0xd0)
0349  +0x04ed8  op=58  07 0e 00 00  LD64             s14 = *(uint64_t *)(s7 +0x0)
034a  +0x04ef0  op=58  1d 07 e0 00  LD64             s7 = *(uint64_t *)(s29 +0xe0)
034b  +0x04f08  op=02  06 1f 06 01  XOR64            s6 = s31 ^ s6
034c  +0x04f20  op=02  06 11 06 00  XOR64            s6 = s17 ^ s6
034d  +0x04f38  op=58  0f 11 00 00  LD64             s17 = *(uint64_t *)(s15 +0x0)
034e  +0x04f50  op=02  12 0e 0e 01  XOR64            s14 = s14 ^ s18
034f  +0x04f68  op=58  1d 12 b0 02  LD64             s18 = *(uint64_t *)(s29 +0x2b0)
0350  +0x04f80  op=58  07 0f 00 00  LD64             s15 = *(uint64_t *)(s7 +0x0)
0351  +0x04f98  op=02  16 11 11 00  XOR64            s17 = s17 ^ s22
0352  +0x04fb0  op=58  1d 16 d0 01  LD64             s22 = *(uint64_t *)(s29 +0x1d0)
0353  +0x04fc8  op=84  03 12 03 04  ADD64            s3 = s3 + s18
0354  +0x04fe0  op=02  05 0f 05 00  XOR64            s5 = s15 ^ s5
0355  +0x04ff8  op=85  12 12 08 00  ADD64_IMM16      s18 = s18 +0x8
0356  +0x05010  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
0357  +0x05028  op=25  1d 12 b0 02  ST64             *(s29 +0x2b0) = s18
0358  +0x05040  op=02  01 03 07 00  XOR64            s7 = s3 ^ s1
0359  +0x05058  op=58  1d 03 c0 01  LD64             s3 = *(uint64_t *)(s29 +0x1c0)
035a  +0x05070  op=58  1d 01 58 02  LD64             s1 = *(uint64_t *)(s29 +0x258)
035b  +0x05088  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
035c  +0x050a0  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
035d  +0x050b8  op=02  03 07 03 01  XOR64            s3 = s7 ^ s3
035e  +0x050d0  op=02  03 01 01 01  XOR64            s1 = s1 ^ s3
035f  +0x050e8  op=58  1d 03 58 01  LD64             s3 = *(uint64_t *)(s29 +0x158)
0360  +0x05100  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
0361  +0x05118  op=02  05 03 03 01  XOR64            s3 = s3 ^ s5
0362  +0x05130  op=58  1d 05 68 01  LD64             s5 = *(uint64_t *)(s29 +0x168)
0363  +0x05148  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
0364  +0x05160  op=02  0e 05 05 00  XOR64            s5 = s5 ^ s14
0365  +0x05178  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0366  +0x05190  op=58  1d 08 98 01  LD64             s8 = *(uint64_t *)(s29 +0x198)
0367  +0x051a8  op=58  08 0f 00 00  LD64             s15 = *(uint64_t *)(s8 +0x0)
0368  +0x051c0  op=58  1d 08 70 01  LD64             s8 = *(uint64_t *)(s29 +0x170)
0369  +0x051d8  op=02  14 0e 0e 01  XOR64            s14 = s14 ^ s20
036a  +0x051f0  op=02  0d 0f 0d 01  XOR64            s13 = s15 ^ s13
036b  +0x05208  op=58  08 0f 00 00  LD64             s15 = *(uint64_t *)(s8 +0x0)
036c  +0x05220  op=58  1d 08 90 01  LD64             s8 = *(uint64_t *)(s29 +0x190)
036d  +0x05238  op=02  11 0f 0f 01  XOR64            s15 = s15 ^ s17
036e  +0x05250  op=58  08 11 00 00  LD64             s17 = *(uint64_t *)(s8 +0x0)
036f  +0x05268  op=58  1d 08 f8 00  LD64             s8 = *(uint64_t *)(s29 +0xf8)
0370  +0x05280  op=02  06 11 06 01  XOR64            s6 = s17 ^ s6
0371  +0x05298  op=58  13 11 00 00  LD64             s17 = *(uint64_t *)(s19 +0x0)
0372  +0x052b0  op=02  08 02 02 00  XOR64            s2 = s2 ^ s8
0373  +0x052c8  op=02  02 11 08 01  XOR64            s8 = s17 ^ s2
0374  +0x052e0  op=58  1d 02 10 02  LD64             s2 = *(uint64_t *)(s29 +0x210)
0375  +0x052f8  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0376  +0x05310  op=02  06 02 02 00  XOR64            s2 = s2 ^ s6
0377  +0x05328  op=58  1d 06 18 02  LD64             s6 = *(uint64_t *)(s29 +0x218)
0378  +0x05340  op=58  06 06 00 00  LD64             s6 = *(uint64_t *)(s6 +0x0)
0379  +0x05358  op=02  0f 06 06 01  XOR64            s6 = s6 ^ s15
037a  +0x05370  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
037b  +0x05388  op=58  1d 09 40 02  LD64             s9 = *(uint64_t *)(s29 +0x240)
037c  +0x053a0  op=02  0d 0f 0d 01  XOR64            s13 = s15 ^ s13
037d  +0x053b8  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
037e  +0x053d0  op=58  1d 09 28 02  LD64             s9 = *(uint64_t *)(s29 +0x228)
037f  +0x053e8  op=02  0e 0f 0e 01  XOR64            s14 = s15 ^ s14
0380  +0x05400  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
0381  +0x05418  op=58  1d 09 38 02  LD64             s9 = *(uint64_t *)(s29 +0x238)
0382  +0x05430  op=02  05 0f 05 01  XOR64            s5 = s15 ^ s5
0383  +0x05448  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
0384  +0x05460  op=58  1d 09 60 02  LD64             s9 = *(uint64_t *)(s29 +0x260)
0385  +0x05478  op=02  03 0f 03 01  XOR64            s3 = s15 ^ s3
0386  +0x05490  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
0387  +0x054a8  op=58  1d 09 30 01  LD64             s9 = *(uint64_t *)(s29 +0x130)
0388  +0x054c0  op=02  03 04 03 00  XOR64            s3 = s4 ^ s3
0389  +0x054d8  op=58  0b 04 00 00  LD64             s4 = *(uint64_t *)(s11 +0x0)
038a  +0x054f0  op=58  10 0b 00 00  LD64             s11 = *(uint64_t *)(s16 +0x0)
038b  +0x05508  op=02  01 0f 01 00  XOR64            s1 = s15 ^ s1
038c  +0x05520  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
038d  +0x05538  op=58  1d 09 c8 01  LD64             s9 = *(uint64_t *)(s29 +0x1c8)
038e  +0x05550  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
038f  +0x05568  op=58  0c 05 00 00  LD64             s5 = *(uint64_t *)(s12 +0x0)
0390  +0x05580  op=58  19 0c 00 00  LD64             s12 = *(uint64_t *)(s25 +0x0)
0391  +0x05598  op=02  0d 0b 0b 00  XOR64            s11 = s11 ^ s13
0392  +0x055b0  op=02  01 0f 01 01  XOR64            s1 = s15 ^ s1
0393  +0x055c8  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
0394  +0x055e0  op=58  1d 09 50 02  LD64             s9 = *(uint64_t *)(s29 +0x250)
0395  +0x055f8  op=02  06 0c 06 00  XOR64            s6 = s12 ^ s6
0396  +0x05610  op=58  18 0c 00 00  LD64             s12 = *(uint64_t *)(s24 +0x0)
0397  +0x05628  op=02  0e 05 05 00  XOR64            s5 = s5 ^ s14
0398  +0x05640  op=58  1e 18 00 00  LD64             s24 = *(uint64_t *)(s30 +0x0)
0399  +0x05658  op=02  01 0f 01 01  XOR64            s1 = s15 ^ s1
039a  +0x05670  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
039b  +0x05688  op=58  1d 09 78 02  LD64             s9 = *(uint64_t *)(s29 +0x278)
039c  +0x056a0  op=02  02 0c 02 01  XOR64            s2 = s12 ^ s2
039d  +0x056b8  op=58  09 0c 00 00  LD64             s12 = *(uint64_t *)(s9 +0x0)
039e  +0x056d0  op=58  1d 09 20 02  LD64             s9 = *(uint64_t *)(s29 +0x220)
039f  +0x056e8  op=02  01 0f 01 01  XOR64            s1 = s15 ^ s1
03a0  +0x05700  op=02  01 18 01 01  XOR64            s1 = s24 ^ s1
03a1  +0x05718  op=58  1d 18 b0 01  LD64             s24 = *(uint64_t *)(s29 +0x1b0)
03a2  +0x05730  op=58  09 0d 00 00  LD64             s13 = *(uint64_t *)(s9 +0x0)
03a3  +0x05748  op=58  1d 09 10 01  LD64             s9 = *(uint64_t *)(s29 +0x110)
03a4  +0x05760  op=02  0d 08 0d 01  XOR64            s13 = s8 ^ s13
03a5  +0x05778  op=02  0d 0c 0c 00  XOR64            s12 = s12 ^ s13
03a6  +0x05790  op=58  09 0d 00 00  LD64             s13 = *(uint64_t *)(s9 +0x0)
03a7  +0x057a8  op=58  1d 09 28 01  LD64             s9 = *(uint64_t *)(s29 +0x128)
03a8  +0x057c0  op=58  09 0e 00 00  LD64             s14 = *(uint64_t *)(s9 +0x0)
03a9  +0x057d8  op=58  1d 09 70 02  LD64             s9 = *(uint64_t *)(s29 +0x270)
03aa  +0x057f0  op=02  06 0d 0a 01  XOR64            s10 = s13 ^ s6
03ab  +0x05808  op=58  1d 06 88 02  LD64             s6 = *(uint64_t *)(s29 +0x288)
03ac  +0x05820  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
03ad  +0x05838  op=58  1d 09 00 01  LD64             s9 = *(uint64_t *)(s29 +0x100)
03ae  +0x05850  op=58  09 19 00 00  LD64             s25 = *(uint64_t *)(s9 +0x0)
03af  +0x05868  op=58  1d 09 08 01  LD64             s9 = *(uint64_t *)(s29 +0x108)
03b0  +0x05880  op=58  09 10 00 00  LD64             s16 = *(uint64_t *)(s9 +0x0)
03b1  +0x05898  op=58  1d 09 20 01  LD64             s9 = *(uint64_t *)(s29 +0x120)
03b2  +0x058b0  op=58  09 11 00 00  LD64             s17 = *(uint64_t *)(s9 +0x0)
03b3  +0x058c8  op=58  1d 09 38 01  LD64             s9 = *(uint64_t *)(s29 +0x138)
03b4  +0x058e0  op=58  09 12 00 00  LD64             s18 = *(uint64_t *)(s9 +0x0)
03b5  +0x058f8  op=58  1d 09 40 01  LD64             s9 = *(uint64_t *)(s29 +0x140)
03b6  +0x05910  op=02  05 11 0d 00  XOR64            s13 = s17 ^ s5
03b7  +0x05928  op=02  04 10 11 01  XOR64            s17 = s16 ^ s4
03b8  +0x05940  op=02  03 19 10 00  XOR64            s16 = s25 ^ s3
03b9  +0x05958  op=58  09 13 00 00  LD64             s19 = *(uint64_t *)(s9 +0x0)
03ba  +0x05970  op=58  1d 09 78 01  LD64             s9 = *(uint64_t *)(s29 +0x178)
03bb  +0x05988  op=58  09 14 00 00  LD64             s20 = *(uint64_t *)(s9 +0x0)
03bc  +0x059a0  op=58  1d 09 68 02  LD64             s9 = *(uint64_t *)(s29 +0x268)
03bd  +0x059b8  op=58  09 17 00 00  LD64             s23 = *(uint64_t *)(s9 +0x0)
03be  +0x059d0  op=58  1d 09 00 02  LD64             s9 = *(uint64_t *)(s29 +0x200)
03bf  +0x059e8  op=58  09 1e 00 00  LD64             s30 = *(uint64_t *)(s9 +0x0)
03c0  +0x05a00  op=58  1d 09 98 02  LD64             s9 = *(uint64_t *)(s29 +0x298)
03c1  +0x05a18  op=58  09 1f 00 00  LD64             s31 = *(uint64_t *)(s9 +0x0)
03c2  +0x05a30  op=02  02 0e 09 00  XOR64            s9 = s14 ^ s2
03c3  +0x05a48  op=02  0c 0f 02 00  XOR64            s2 = s15 ^ s12
03c4  +0x05a60  op=02  0b 12 0e 01  XOR64            s14 = s18 ^ s11
03c5  +0x05a78  op=02  01 13 0c 01  XOR64            s12 = s19 ^ s1
03c6  +0x05a90  op=02  02 1f 02 01  XOR64            s2 = s31 ^ s2
03c7  +0x05aa8  op=02  02 1e 02 00  XOR64            s2 = s30 ^ s2
03c8  +0x05ac0  op=02  02 17 02 01  XOR64            s2 = s23 ^ s2
03c9  +0x05ad8  op=02  02 15 02 00  XOR64            s2 = s21 ^ s2
03ca  +0x05af0  op=02  02 14 0b 01  XOR64            s11 = s20 ^ s2
03cb  +0x05b08  op=5f  a2 fc ff ff  ADD_PC_IMM32     goto record +110 ; vm_pc = current_pc + 1 + -862
03cc  +0x05b20  op=58  1d 01 08 00  LD64             s1 = *(uint64_t *)(s29 +0x8)
03cd  +0x05b38  op=58  1d 02 00 00  LD64             s2 = *(uint64_t *)(s29 +0x0)
03ce  +0x05b50  op=58  1d 03 10 00  LD64             s3 = *(uint64_t *)(s29 +0x10)
03cf  +0x05b68  op=58  1d 04 20 00  LD64             s4 = *(uint64_t *)(s29 +0x20)
03d0  +0x05b80  op=58  1d 05 30 00  LD64             s5 = *(uint64_t *)(s29 +0x30)
03d1  +0x05b98  op=58  1d 06 40 00  LD64             s6 = *(uint64_t *)(s29 +0x40)
03d2  +0x05bb0  op=58  1d 07 50 00  LD64             s7 = *(uint64_t *)(s29 +0x50)
03d3  +0x05bc8  op=58  1d 08 78 00  LD64             s8 = *(uint64_t *)(s29 +0x78)
03d4  +0x05be0  op=58  1d 12 20 03  LD64             s18 = *(uint64_t *)(s29 +0x320)
03d5  +0x05bf8  op=58  1d 13 28 03  LD64             s19 = *(uint64_t *)(s29 +0x328)
03d6  +0x05c10  op=58  1d 14 30 03  LD64             s20 = *(uint64_t *)(s29 +0x330)
03d7  +0x05c28  op=58  1d 15 38 03  LD64             s21 = *(uint64_t *)(s29 +0x338)
03d8  +0x05c40  op=58  1d 16 40 03  LD64             s22 = *(uint64_t *)(s29 +0x340)
03d9  +0x05c58  op=58  1d 17 48 03  LD64             s23 = *(uint64_t *)(s29 +0x348)
03da  +0x05c70  op=58  1d 1e 50 03  LD64             s30 = *(uint64_t *)(s29 +0x350)
03db  +0x05c88  op=58  1d 1f 58 03  LD64             s31 = *(uint64_t *)(s29 +0x358)
03dc  +0x05ca0  op=02  01 02 01 00  XOR64            s1 = s2 ^ s1
03dd  +0x05cb8  op=58  1d 02 38 00  LD64             s2 = *(uint64_t *)(s29 +0x38)
03de  +0x05cd0  op=02  01 09 01 01  XOR64            s1 = s9 ^ s1
03df  +0x05ce8  op=02  02 03 02 01  XOR64            s2 = s3 ^ s2
03e0  +0x05d00  op=58  1d 03 28 00  LD64             s3 = *(uint64_t *)(s29 +0x28)
03e1  +0x05d18  op=02  02 0a 02 00  XOR64            s2 = s10 ^ s2
03e2  +0x05d30  op=02  03 04 03 01  XOR64            s3 = s4 ^ s3
03e3  +0x05d48  op=58  1d 04 48 00  LD64             s4 = *(uint64_t *)(s29 +0x48)
03e4  +0x05d60  op=02  03 0e 03 01  XOR64            s3 = s14 ^ s3
03e5  +0x05d78  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
03e6  +0x05d90  op=58  1d 05 58 00  LD64             s5 = *(uint64_t *)(s29 +0x58)
03e7  +0x05da8  op=02  04 0d 04 01  XOR64            s4 = s13 ^ s4
03e8  +0x05dc0  op=02  05 06 05 01  XOR64            s5 = s6 ^ s5
03e9  +0x05dd8  op=58  1d 06 60 00  LD64             s6 = *(uint64_t *)(s29 +0x60)
03ea  +0x05df0  op=02  05 11 05 00  XOR64            s5 = s17 ^ s5
03eb  +0x05e08  op=58  1d 11 18 03  LD64             s17 = *(uint64_t *)(s29 +0x318)
03ec  +0x05e20  op=02  06 07 06 01  XOR64            s6 = s7 ^ s6
03ed  +0x05e38  op=58  1d 07 18 00  LD64             s7 = *(uint64_t *)(s29 +0x18)
03ee  +0x05e50  op=02  06 10 06 01  XOR64            s6 = s16 ^ s6
03ef  +0x05e68  op=58  1d 10 10 03  LD64             s16 = *(uint64_t *)(s29 +0x310)
03f0  +0x05e80  op=02  07 0b 07 01  XOR64            s7 = s11 ^ s7
03f1  +0x05e98  op=25  08 07 70 00  ST64             *(s8 +0x70) = s7
03f2  +0x05eb0  op=25  08 01 a0 00  ST64             *(s8 +0xa0) = s1
03f3  +0x05ec8  op=25  08 02 98 00  ST64             *(s8 +0x98) = s2
03f4  +0x05ee0  op=58  1d 01 70 00  LD64             s1 = *(uint64_t *)(s29 +0x70)
03f5  +0x05ef8  op=58  1d 02 68 00  LD64             s2 = *(uint64_t *)(s29 +0x68)
03f6  +0x05f10  op=25  08 03 90 00  ST64             *(s8 +0x90) = s3
03f7  +0x05f28  op=25  08 04 88 00  ST64             *(s8 +0x88) = s4
03f8  +0x05f40  op=25  08 05 80 00  ST64             *(s8 +0x80) = s5
03f9  +0x05f58  op=25  08 06 78 00  ST64             *(s8 +0x78) = s6
03fa  +0x05f70  op=02  01 02 01 01  XOR64            s1 = s2 ^ s1
03fb  +0x05f88  op=02  01 0c 01 01  XOR64            s1 = s12 ^ s1
03fc  +0x05fa0  op=25  08 01 68 00  ST64             *(s8 +0x68) = s1
03fd  +0x05fb8  op=85  1d 1d 60 03  ADD64_IMM16      s29 = s29 +0x360
03fe  +0x05fd0  op=5b  1f 00 00 00  RET              return/leave with s31

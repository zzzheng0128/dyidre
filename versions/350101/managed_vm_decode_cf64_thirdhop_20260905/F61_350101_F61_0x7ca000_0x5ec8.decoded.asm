; MetaSec managed bytecode decode: F61
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F61_0x7ca000_0x5ec8.bin
; records: 1011  record_size=0x18
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
000f  +0x00168  op=25  1d 01 c0 00  ST64             *(s29 +0xc0) = s1
0010  +0x00180  op=58  04 01 d8 00  LD64             s1 = *(uint64_t *)(s4 +0xd8)
0011  +0x00198  op=25  1d 01 b8 00  ST64             *(s29 +0xb8) = s1
0012  +0x001b0  op=58  04 01 d0 00  LD64             s1 = *(uint64_t *)(s4 +0xd0)
0013  +0x001c8  op=25  1d 01 b0 00  ST64             *(s29 +0xb0) = s1
0014  +0x001e0  op=58  04 01 c8 00  LD64             s1 = *(uint64_t *)(s4 +0xc8)
0015  +0x001f8  op=25  1d 01 a8 00  ST64             *(s29 +0xa8) = s1
0016  +0x00210  op=58  04 01 c0 00  LD64             s1 = *(uint64_t *)(s4 +0xc0)
0017  +0x00228  op=25  1d 01 a0 00  ST64             *(s29 +0xa0) = s1
0018  +0x00240  op=58  04 01 b8 00  LD64             s1 = *(uint64_t *)(s4 +0xb8)
0019  +0x00258  op=25  1d 01 98 00  ST64             *(s29 +0x98) = s1
001a  +0x00270  op=58  04 01 b0 00  LD64             s1 = *(uint64_t *)(s4 +0xb0)
001b  +0x00288  op=25  1d 01 88 00  ST64             *(s29 +0x88) = s1
001c  +0x002a0  op=58  04 01 a8 00  LD64             s1 = *(uint64_t *)(s4 +0xa8)
001d  +0x002b8  op=25  1d 01 80 00  ST64             *(s29 +0x80) = s1
001e  +0x002d0  op=ae  02 03 1b 00  BR_EQ64          if (s2 == s3) goto record +58
001f  +0x002e8  op=84  04 02 01 00  ADD64            s1 = s4 + s2
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
002c  +0x00420  op=34  0c 0d 0c 01  OR64             s12 = s12 | s13
002d  +0x00438  op=59  01 0d 04 00  LD8U             s13 = *(uint8_t *)(s1 +0x4)
002e  +0x00450  op=6e  02 0d 0d 18  SHL64_IMM        s13 = s13 << 24
002f  +0x00468  op=34  0c 0d 0c 01  OR64             s12 = s12 | s13
0030  +0x00480  op=59  01 0d 05 00  LD8U             s13 = *(uint8_t *)(s1 +0x5)
0031  +0x00498  op=6e  02 0d 0d 10  SHL64_IMM        s13 = s13 << 16
0032  +0x004b0  op=34  0c 0d 0c 01  OR64             s12 = s12 | s13
0033  +0x004c8  op=59  01 0d 07 00  LD8U             s13 = *(uint8_t *)(s1 +0x7)
0034  +0x004e0  op=59  01 01 06 00  LD8U             s1 = *(uint8_t *)(s1 +0x6)
0035  +0x004f8  op=6e  00 01 01 08  SHL64_IMM        s1 = s1 << 8
0036  +0x00510  op=02  0c 01 01 00  XOR64            s1 = s1 ^ s12
0037  +0x00528  op=02  01 0d 01 00  XOR64            s1 = s13 ^ s1
0038  +0x00540  op=25  0e 01 00 00  ST64             *(s14 +0x0) = s1
0039  +0x00558  op=a7  02 03 e5 ff  BR_NE64          if (s2 != s3) goto record +31
003a  +0x00570  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0
003b  +0x00588  op=58  04 05 70 00  LD64             s5 = *(uint64_t *)(s4 +0x70)
003c  +0x005a0  op=58  04 0c 68 00  LD64             s12 = *(uint64_t *)(s4 +0x68)
003d  +0x005b8  op=58  04 10 78 00  LD64             s16 = *(uint64_t *)(s4 +0x78)
003e  +0x005d0  op=58  1d 01 e8 02  LD64             s1 = *(uint64_t *)(s29 +0x2e8)
003f  +0x005e8  op=58  04 07 80 00  LD64             s7 = *(uint64_t *)(s4 +0x80)
0040  +0x00600  op=58  1d 02 f0 02  LD64             s2 = *(uint64_t *)(s29 +0x2f0)
0041  +0x00618  op=58  1d 06 f8 02  LD64             s6 = *(uint64_t *)(s29 +0x2f8)
0042  +0x00630  op=58  1d 0d d0 02  LD64             s13 = *(uint64_t *)(s29 +0x2d0)
0043  +0x00648  op=58  1d 0b 00 03  LD64             s11 = *(uint64_t *)(s29 +0x300)
0044  +0x00660  op=58  04 19 a0 00  LD64             s25 = *(uint64_t *)(s4 +0xa0)
0045  +0x00678  op=58  04 1f 88 00  LD64             s31 = *(uint64_t *)(s4 +0x88)
0046  +0x00690  op=58  04 0e 90 00  LD64             s14 = *(uint64_t *)(s4 +0x90)
0047  +0x006a8  op=58  04 0f 98 00  LD64             s15 = *(uint64_t *)(s4 +0x98)
0048  +0x006c0  op=58  1d 18 e0 02  LD64             s24 = *(uint64_t *)(s29 +0x2e0)
0049  +0x006d8  op=58  1d 11 08 03  LD64             s17 = *(uint64_t *)(s29 +0x308)
004a  +0x006f0  op=25  1d 04 78 00  ST64             *(s29 +0x78) = s4
004b  +0x00708  op=85  04 04 f0 00  ADD64_IMM16      s4 = s4 +0xf0
004c  +0x00720  op=25  1d 03 a8 02  ST64             *(s29 +0x2a8) = s3
004d  +0x00738  op=58  1d 03 d8 02  LD64             s3 = *(uint64_t *)(s29 +0x2d8)
004e  +0x00750  op=25  1d 04 90 00  ST64             *(s29 +0x90) = s4
004f  +0x00768  op=02  07 02 02 01  XOR64            s2 = s2 ^ s7
0050  +0x00780  op=02  10 01 01 00  XOR64            s1 = s1 ^ s16
0051  +0x00798  op=25  1d 07 c8 02  ST64             *(s29 +0x2c8) = s7
0052  +0x007b0  op=02  05 11 04 00  XOR64            s4 = s17 ^ s5
0053  +0x007c8  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17
0054  +0x007e0  op=25  1d 18 18 00  ST64             *(s29 +0x18) = s24
0055  +0x007f8  op=02  0c 18 11 01  XOR64            s17 = s24 ^ s12
0056  +0x00810  op=25  1d 0b 50 00  ST64             *(s29 +0x50) = s11
0057  +0x00828  op=02  19 0b 0a 00  XOR64            s10 = s11 ^ s25
0058  +0x00840  op=25  1d 0d 48 00  ST64             *(s29 +0x48) = s13
0059  +0x00858  op=02  0f 0d 0b 01  XOR64            s11 = s13 ^ s15
005a  +0x00870  op=25  1d 06 58 00  ST64             *(s29 +0x58) = s6
005b  +0x00888  op=02  0e 06 18 01  XOR64            s24 = s6 ^ s14
005c  +0x008a0  op=34  0e 00 07 00  OR64             s7 = s14 | s0
005d  +0x008b8  op=34  0f 00 06 00  OR64             s6 = s15 | s0
005e  +0x008d0  op=25  1d 10 b8 02  ST64             *(s29 +0x2b8) = s16
005f  +0x008e8  op=25  1d 1f 40 00  ST64             *(s29 +0x40) = s31
0060  +0x00900  op=25  1d 0e 30 00  ST64             *(s29 +0x30) = s14
0061  +0x00918  op=25  1d 0f 20 00  ST64             *(s29 +0x20) = s15
0062  +0x00930  op=25  1d 19 10 00  ST64             *(s29 +0x10) = s25
0063  +0x00948  op=25  1d 0c 70 00  ST64             *(s29 +0x70) = s12
0064  +0x00960  op=25  1d 05 60 00  ST64             *(s29 +0x60) = s5
0065  +0x00978  op=25  1d 05 c0 02  ST64             *(s29 +0x2c0) = s5
0066  +0x00990  op=25  1d 03 68 00  ST64             *(s29 +0x68) = s3
0067  +0x009a8  op=02  1f 03 0d 01  XOR64            s13 = s3 ^ s31
0068  +0x009c0  op=34  19 00 03 01  OR64             s3 = s25 | s0
0069  +0x009d8  op=25  1d 04 80 02  ST64             *(s29 +0x280) = s4
006a  +0x009f0  op=25  1d 01 28 00  ST64             *(s29 +0x28) = s1
006b  +0x00a08  op=25  1d 01 90 02  ST64             *(s29 +0x290) = s1
006c  +0x00a20  op=25  1d 02 38 00  ST64             *(s29 +0x38) = s2
006d  +0x00a38  op=25  1d 02 88 02  ST64             *(s29 +0x288) = s2
006e  +0x00a50  op=58  1d 01 a8 02  LD64             s1 = *(uint64_t *)(s29 +0x2a8)
006f  +0x00a68  op=85  00 02 50 00  ADD64_IMM16      s2 = s0 +0x50
0070  +0x00a80  op=ae  01 02 4e 03  BR_EQ64          if (s1 == s2) goto record +959
0071  +0x00a98  op=58  1d 09 c0 02  LD64             s9 = *(uint64_t *)(s29 +0x2c0)
0072  +0x00ab0  op=67  00 06 14 0d  LSR64_IMM32PLUS  s20 = (uint64_t)s6 >> (13 + 32)
0073  +0x00ac8  op=67  00 0c 17 15  LSR64_IMM32PLUS  s23 = (uint64_t)s12 >> (21 + 32)
0074  +0x00ae0  op=25  1d 0b a8 01  ST64             *(s29 +0x1a8) = s11
0075  +0x00af8  op=67  00 0c 0b 0d  LSR64_IMM32PLUS  s11 = (uint64_t)s12 >> (13 + 32)
0076  +0x00b10  op=34  0c 00 08 01  OR64             s8 = s12 | s0
0077  +0x00b28  op=25  1d 0d 88 01  ST64             *(s29 +0x188) = s13
0078  +0x00b40  op=25  1d 0a 80 01  ST64             *(s29 +0x180) = s10
0079  +0x00b58  op=25  1d 18 50 01  ST64             *(s29 +0x150) = s24
007a  +0x00b70  op=67  00 03 18 15  LSR64_IMM32PLUS  s24 = (uint64_t)s3 >> (21 + 32)
007b  +0x00b88  op=58  1d 0a 88 00  LD64             s10 = *(uint64_t *)(s29 +0x88)
007c  +0x00ba0  op=58  1d 0c 80 00  LD64             s12 = *(uint64_t *)(s29 +0x80)
007d  +0x00bb8  op=58  1d 04 c8 02  LD64             s4 = *(uint64_t *)(s29 +0x2c8)
007e  +0x00bd0  op=58  1d 13 b8 02  LD64             s19 = *(uint64_t *)(s29 +0x2b8)
007f  +0x00be8  op=67  00 06 16 15  LSR64_IMM32PLUS  s22 = (uint64_t)s6 >> (21 + 32)
0080  +0x00c00  op=67  00 03 1e 0d  LSR64_IMM32PLUS  s30 = (uint64_t)s3 >> (13 + 32)
0081  +0x00c18  op=67  00 07 12 15  LSR64_IMM32PLUS  s18 = (uint64_t)s7 >> (21 + 32)
0082  +0x00c30  op=67  00 07 19 05  LSR64_IMM32PLUS  s25 = (uint64_t)s7 >> (5 + 32)
0083  +0x00c48  op=25  1d 11 28 01  ST64             *(s29 +0x128) = s17
0084  +0x00c60  op=67  00 1f 11 15  LSR64_IMM32PLUS  s17 = (uint64_t)s31 >> (21 + 32)
0085  +0x00c78  op=25  1d 07 b0 02  ST64             *(s29 +0x2b0) = s7
0086  +0x00c90  op=67  00 1f 0e 0d  LSR64_IMM32PLUS  s14 = (uint64_t)s31 >> (13 + 32)
0087  +0x00ca8  op=67  00 1f 10 05  LSR64_IMM32PLUS  s16 = (uint64_t)s31 >> (5 + 32)
0088  +0x00cc0  op=25  1d 03 a0 02  ST64             *(s29 +0x2a0) = s3
0089  +0x00cd8  op=25  1d 06 f0 01  ST64             *(s29 +0x1f0) = s6
008a  +0x00cf0  op=25  1d 1f 08 01  ST64             *(s29 +0x108) = s31
008b  +0x00d08  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
008c  +0x00d20  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
008d  +0x00d38  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
008e  +0x00d50  op=b2  16 16 f8 07  AND64_IMM16      s22 = s22 & 0x7f8
008f  +0x00d68  op=b2  17 17 f8 07  AND64_IMM16      s23 = s23 & 0x7f8
0090  +0x00d80  op=b2  1e 1e f8 07  AND64_IMM16      s30 = s30 & 0x7f8
0091  +0x00d98  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
0092  +0x00db0  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
0093  +0x00dc8  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
0094  +0x00de0  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0095  +0x00df8  op=25  1d 08 98 02  ST64             *(s29 +0x298) = s8
0096  +0x00e10  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
0097  +0x00e28  op=67  00 09 0d 15  LSR64_IMM32PLUS  s13 = (uint64_t)s9 >> (21 + 32)
0098  +0x00e40  op=84  0a 0b 0b 00  ADD64            s11 = s10 + s11
0099  +0x00e58  op=84  0a 14 14 00  ADD64            s20 = s10 + s20
009a  +0x00e70  op=84  0c 18 18 04  ADD64            s24 = s12 + s24
009b  +0x00e88  op=67  00 04 02 15  LSR64_IMM32PLUS  s2 = (uint64_t)s4 >> (21 + 32)
009c  +0x00ea0  op=34  04 00 05 00  OR64             s5 = s4 | s0
009d  +0x00eb8  op=25  1d 04 c8 02  ST64             *(s29 +0x2c8) = s4
009e  +0x00ed0  op=67  00 07 04 0d  LSR64_IMM32PLUS  s4 = (uint64_t)s7 >> (13 + 32)
009f  +0x00ee8  op=67  00 13 01 0d  LSR64_IMM32PLUS  s1 = (uint64_t)s19 >> (13 + 32)
00a0  +0x00f00  op=67  00 09 0f 05  LSR64_IMM32PLUS  s15 = (uint64_t)s9 >> (5 + 32)
00a1  +0x00f18  op=84  0c 16 16 00  ADD64            s22 = s12 + s22
00a2  +0x00f30  op=84  0a 1e 1e 00  ADD64            s30 = s10 + s30
00a3  +0x00f48  op=58  1d 07 98 00  LD64             s7 = *(uint64_t *)(s29 +0x98)
00a4  +0x00f60  op=84  0c 17 17 14  ADD64            s23 = s12 + s23
00a5  +0x00f78  op=84  0c 11 11 14  ADD64            s17 = s12 + s17
00a6  +0x00f90  op=25  1d 09 c0 02  ST64             *(s29 +0x2c0) = s9
00a7  +0x00fa8  op=84  0c 12 12 04  ADD64            s18 = s12 + s18
00a8  +0x00fc0  op=84  0a 0e 0e 04  ADD64            s14 = s10 + s14
00a9  +0x00fd8  op=25  1d 13 b8 02  ST64             *(s29 +0x2b8) = s19
00aa  +0x00ff0  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
00ab  +0x01008  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
00ac  +0x01020  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
00ad  +0x01038  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
00ae  +0x01050  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
00af  +0x01068  op=67  00 05 15 0d  LSR64_IMM32PLUS  s21 = (uint64_t)s5 >> (13 + 32)
00b0  +0x01080  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
00b1  +0x01098  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
00b2  +0x010b0  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
00b3  +0x010c8  op=58  16 16 00 00  LD64             s22 = *(uint64_t *)(s22 +0x0)
00b4  +0x010e0  op=58  1e 1e 00 00  LD64             s30 = *(uint64_t *)(s30 +0x0)
00b5  +0x010f8  op=58  17 17 00 00  LD64             s23 = *(uint64_t *)(s23 +0x0)
00b6  +0x01110  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
00b7  +0x01128  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
00b8  +0x01140  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
00b9  +0x01158  op=34  08 00 05 01  OR64             s5 = s8 | s0
00ba  +0x01170  op=84  0c 0d 0d 04  ADD64            s13 = s12 + s13
00bb  +0x01188  op=84  0a 04 04 04  ADD64            s4 = s10 + s4
00bc  +0x011a0  op=84  0a 01 01 00  ADD64            s1 = s10 + s1
00bd  +0x011b8  op=84  0c 02 02 04  ADD64            s2 = s12 + s2
00be  +0x011d0  op=b2  15 15 f8 07  AND64_IMM16      s21 = s21 & 0x7f8
00bf  +0x011e8  op=84  07 0f 0f 00  ADD64            s15 = s7 + s15
00c0  +0x01200  op=84  07 19 19 14  ADD64            s25 = s7 + s25
00c1  +0x01218  op=84  07 10 10 00  ADD64            s16 = s7 + s16
00c2  +0x01230  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
00c3  +0x01248  op=02  14 18 18 00  XOR64            s24 = s24 ^ s20
00c4  +0x01260  op=67  00 13 14 15  LSR64_IMM32PLUS  s20 = (uint64_t)s19 >> (21 + 32)
00c5  +0x01278  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
00c6  +0x01290  op=84  0a 15 15 00  ADD64            s21 = s10 + s21
00c7  +0x012a8  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
00c8  +0x012c0  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
00c9  +0x012d8  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
00ca  +0x012f0  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
00cb  +0x01308  op=02  0e 12 0e 01  XOR64            s14 = s18 ^ s14
00cc  +0x01320  op=67  00 05 12 05  LSR64_IMM32PLUS  s18 = (uint64_t)s5 >> (5 + 32)
00cd  +0x01338  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
00ce  +0x01350  op=58  1d 05 a8 00  LD64             s5 = *(uint64_t *)(s29 +0xa8)
00cf  +0x01368  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
00d0  +0x01380  op=58  15 15 00 00  LD64             s21 = *(uint64_t *)(s21 +0x0)
00d1  +0x01398  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
00d2  +0x013b0  op=02  0b 0d 0b 00  XOR64            s11 = s13 ^ s11
00d3  +0x013c8  op=67  00 09 0d 0d  LSR64_IMM32PLUS  s13 = (uint64_t)s9 >> (13 + 32)
00d4  +0x013e0  op=84  0c 14 14 00  ADD64            s20 = s12 + s20
00d5  +0x013f8  op=02  04 16 04 01  XOR64            s4 = s22 ^ s4
00d6  +0x01410  op=02  1e 17 16 01  XOR64            s22 = s23 ^ s30
00d7  +0x01428  op=58  1d 09 c8 02  LD64             s9 = *(uint64_t *)(s29 +0x2c8)
00d8  +0x01440  op=58  1d 1e b0 02  LD64             s30 = *(uint64_t *)(s29 +0x2b0)
00d9  +0x01458  op=02  01 02 01 01  XOR64            s1 = s2 ^ s1
00da  +0x01470  op=67  00 03 02 05  LSR64_IMM32PLUS  s2 = (uint64_t)s3 >> (5 + 32)
00db  +0x01488  op=02  18 19 18 01  XOR64            s24 = s25 ^ s24
00dc  +0x014a0  op=84  07 12 12 04  ADD64            s18 = s7 + s18
00dd  +0x014b8  op=68  03 06 17 1d  LSR64_IMM        s23 = (uint64_t)s6 >> 29
00de  +0x014d0  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
00df  +0x014e8  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
00e0  +0x01500  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
00e1  +0x01518  op=02  01 0f 01 01  XOR64            s1 = s15 ^ s1
00e2  +0x01530  op=68  03 08 0f 1d  LSR64_IMM        s15 = (uint64_t)s8 >> 29
00e3  +0x01548  op=02  15 11 11 01  XOR64            s17 = s17 ^ s21
00e4  +0x01560  op=58  1d 08 a0 00  LD64             s8 = *(uint64_t *)(s29 +0xa0)
00e5  +0x01578  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
00e6  +0x01590  op=b2  17 17 f8 07  AND64_IMM16      s23 = s23 & 0x7f8
00e7  +0x015a8  op=02  04 10 04 01  XOR64            s4 = s16 ^ s4
00e8  +0x015c0  op=68  13 1f 10 1d  LSR64_IMM        s16 = (uint64_t)s31 >> 29
00e9  +0x015d8  op=84  0a 0d 0d 14  ADD64            s13 = s10 + s13
00ea  +0x015f0  op=68  13 1e 19 1d  LSR64_IMM        s25 = (uint64_t)s30 >> 29
00eb  +0x01608  op=67  00 09 15 05  LSR64_IMM32PLUS  s21 = (uint64_t)s9 >> (5 + 32)
00ec  +0x01620  op=84  07 02 02 00  ADD64            s2 = s7 + s2
00ed  +0x01638  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
00ee  +0x01650  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
00ef  +0x01668  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
00f0  +0x01680  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
00f1  +0x01698  op=b2  15 15 f8 07  AND64_IMM16      s21 = s21 & 0x7f8
00f2  +0x016b0  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
00f3  +0x016c8  op=84  08 17 17 04  ADD64            s23 = s8 + s23
00f4  +0x016e0  op=84  08 0f 0f 14  ADD64            s15 = s8 + s15
00f5  +0x016f8  op=84  08 10 10 04  ADD64            s16 = s8 + s16
00f6  +0x01710  op=84  07 15 15 14  ADD64            s21 = s7 + s21
00f7  +0x01728  op=84  08 19 19 00  ADD64            s25 = s8 + s25
00f8  +0x01740  op=58  17 17 00 00  LD64             s23 = *(uint64_t *)(s23 +0x0)
00f9  +0x01758  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
00fa  +0x01770  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
00fb  +0x01788  op=02  0d 14 0d 00  XOR64            s13 = s20 ^ s13
00fc  +0x017a0  op=67  00 06 14 05  LSR64_IMM32PLUS  s20 = (uint64_t)s6 >> (5 + 32)
00fd  +0x017b8  op=58  15 15 00 00  LD64             s21 = *(uint64_t *)(s21 +0x0)
00fe  +0x017d0  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
00ff  +0x017e8  op=02  0b 02 02 00  XOR64            s2 = s2 ^ s11
0100  +0x01800  op=68  03 09 0b 1d  LSR64_IMM        s11 = (uint64_t)s9 >> 29
0101  +0x01818  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
0102  +0x01830  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0103  +0x01848  op=02  0d 12 0d 01  XOR64            s13 = s18 ^ s13
0104  +0x01860  op=02  02 17 02 00  XOR64            s2 = s23 ^ s2
0105  +0x01878  op=34  09 00 17 01  OR64             s23 = s9 | s0
0106  +0x01890  op=02  01 0f 01 00  XOR64            s1 = s15 ^ s1
0107  +0x018a8  op=67  00 13 0f 05  LSR64_IMM32PLUS  s15 = (uint64_t)s19 >> (5 + 32)
0108  +0x018c0  op=02  18 10 18 00  XOR64            s24 = s16 ^ s24
0109  +0x018d8  op=68  00 1f 10 15  LSR64_IMM        s16 = (uint64_t)s31 >> 21
010a  +0x018f0  op=84  07 14 14 04  ADD64            s20 = s7 + s20
010b  +0x01908  op=02  0e 15 0e 01  XOR64            s14 = s21 ^ s14
010c  +0x01920  op=68  00 03 15 1d  LSR64_IMM        s21 = (uint64_t)s3 >> 29
010d  +0x01938  op=84  08 0b 0b 00  ADD64            s11 = s8 + s11
010e  +0x01950  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
010f  +0x01968  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
0110  +0x01980  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
0111  +0x01998  op=b2  15 15 f8 07  AND64_IMM16      s21 = s21 & 0x7f8
0112  +0x019b0  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
0113  +0x019c8  op=84  07 0f 0f 00  ADD64            s15 = s7 + s15
0114  +0x019e0  op=84  05 10 10 00  ADD64            s16 = s5 + s16
0115  +0x019f8  op=58  0f 0f 00 00  LD64             s15 = *(uint64_t *)(s15 +0x0)
0116  +0x01a10  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
0117  +0x01a28  op=02  16 14 14 01  XOR64            s20 = s20 ^ s22
0118  +0x01a40  op=68  03 03 16 15  LSR64_IMM        s22 = (uint64_t)s3 >> 21
0119  +0x01a58  op=58  1d 03 b0 00  LD64             s3 = *(uint64_t *)(s29 +0xb0)
011a  +0x01a70  op=02  04 0b 04 01  XOR64            s4 = s11 ^ s4
011b  +0x01a88  op=68  13 09 0b 15  LSR64_IMM        s11 = (uint64_t)s9 >> 21
011c  +0x01aa0  op=34  13 00 09 01  OR64             s9 = s19 | s0
011d  +0x01ab8  op=02  14 19 19 00  XOR64            s25 = s25 ^ s20
011e  +0x01ad0  op=68  00 06 14 0d  LSR64_IMM        s20 = (uint64_t)s6 >> 13
011f  +0x01ae8  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0120  +0x01b00  op=b2  16 16 f8 07  AND64_IMM16      s22 = s22 & 0x7f8
0121  +0x01b18  op=02  11 0f 0f 01  XOR64            s15 = s15 ^ s17
0122  +0x01b30  op=68  00 13 11 1d  LSR64_IMM        s17 = (uint64_t)s19 >> 29
0123  +0x01b48  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
0124  +0x01b60  op=84  05 0b 0b 00  ADD64            s11 = s5 + s11
0125  +0x01b78  op=84  05 16 16 00  ADD64            s22 = s5 + s22
0126  +0x01b90  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
0127  +0x01ba8  op=02  19 10 19 00  XOR64            s25 = s16 ^ s25
0128  +0x01bc0  op=84  03 14 12 00  ADD64            s18 = s3 + s20
0129  +0x01bd8  op=84  08 15 14 14  ADD64            s20 = s8 + s21
012a  +0x01bf0  op=68  03 1e 15 15  LSR64_IMM        s21 = (uint64_t)s30 >> 21
012b  +0x01c08  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
012c  +0x01c20  op=58  16 16 00 00  LD64             s22 = *(uint64_t *)(s22 +0x0)
012d  +0x01c38  op=84  08 11 11 04  ADD64            s17 = s8 + s17
012e  +0x01c50  op=b2  15 15 f8 07  AND64_IMM16      s21 = s21 & 0x7f8
012f  +0x01c68  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
0130  +0x01c80  op=58  14 14 00 00  LD64             s20 = *(uint64_t *)(s20 +0x0)
0131  +0x01c98  op=58  12 12 00 00  LD64             s18 = *(uint64_t *)(s18 +0x0)
0132  +0x01cb0  op=84  05 15 15 00  ADD64            s21 = s5 + s21
0133  +0x01cc8  op=02  18 0b 0b 01  XOR64            s11 = s11 ^ s24
0134  +0x01ce0  op=02  01 16 01 00  XOR64            s1 = s22 ^ s1
0135  +0x01cf8  op=68  13 13 16 15  LSR64_IMM        s22 = (uint64_t)s19 >> 21
0136  +0x01d10  op=34  1e 00 13 01  OR64             s19 = s30 | s0
0137  +0x01d28  op=58  15 15 00 00  LD64             s21 = *(uint64_t *)(s21 +0x0)
0138  +0x01d40  op=b2  16 16 f8 07  AND64_IMM16      s22 = s22 & 0x7f8
0139  +0x01d58  op=02  01 12 01 00  XOR64            s1 = s18 ^ s1
013a  +0x01d70  op=68  13 1e 12 05  LSR64_IMM        s18 = (uint64_t)s30 >> 5
013b  +0x01d88  op=02  0d 14 14 00  XOR64            s20 = s20 ^ s13
013c  +0x01da0  op=68  13 06 0d 15  LSR64_IMM        s13 = (uint64_t)s6 >> 21
013d  +0x01db8  op=58  1d 06 b8 00  LD64             s6 = *(uint64_t *)(s29 +0xb8)
013e  +0x01dd0  op=58  1d 1e 88 02  LD64             s30 = *(uint64_t *)(s29 +0x288)
013f  +0x01de8  op=58  1d 13 88 01  LD64             s19 = *(uint64_t *)(s29 +0x188)
0140  +0x01e00  op=84  05 16 16 14  ADD64            s22 = s5 + s22
0141  +0x01e18  op=b2  12 12 f8 07  AND64_IMM16      s18 = s18 & 0x7f8
0142  +0x01e30  op=02  02 15 02 01  XOR64            s2 = s21 ^ s2
0143  +0x01e48  op=68  03 09 15 0d  LSR64_IMM        s21 = (uint64_t)s9 >> 13
0144  +0x01e60  op=58  1d 09 c0 02  LD64             s9 = *(uint64_t *)(s29 +0x2c0)
0145  +0x01e78  op=58  16 16 00 00  LD64             s22 = *(uint64_t *)(s22 +0x0)
0146  +0x01e90  op=84  06 12 12 14  ADD64            s18 = s6 + s18
0147  +0x01ea8  op=b2  15 15 f8 07  AND64_IMM16      s21 = s21 & 0x7f8
0148  +0x01ec0  op=68  00 09 18 1d  LSR64_IMM        s24 = (uint64_t)s9 >> 29
0149  +0x01ed8  op=84  03 15 15 04  ADD64            s21 = s3 + s21
014a  +0x01ef0  op=02  04 16 04 01  XOR64            s4 = s22 ^ s4
014b  +0x01f08  op=b2  0d 16 f8 07  AND64_IMM16      s22 = s13 & 0x7f8
014c  +0x01f20  op=68  13 17 0d 0d  LSR64_IMM        s13 = (uint64_t)s23 >> 13
014d  +0x01f38  op=58  1d 17 28 01  LD64             s23 = *(uint64_t *)(s29 +0x128)
014e  +0x01f50  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
014f  +0x01f68  op=b2  0d 10 f8 07  AND64_IMM16      s16 = s13 & 0x7f8
0150  +0x01f80  op=58  1d 0d 80 02  LD64             s13 = *(uint64_t *)(s29 +0x280)
0151  +0x01f98  op=84  08 18 18 04  ADD64            s24 = s8 + s24
0152  +0x01fb0  op=84  03 10 10 00  ADD64            s16 = s3 + s16
0153  +0x01fc8  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
0154  +0x01fe0  op=58  10 10 00 00  LD64             s16 = *(uint64_t *)(s16 +0x0)
0155  +0x01ff8  op=02  0f 18 0f 01  XOR64            s15 = s24 ^ s15
0156  +0x02010  op=68  13 09 18 0d  LSR64_IMM        s24 = (uint64_t)s9 >> 13
0157  +0x02028  op=02  0e 11 09 00  XOR64            s9 = s17 ^ s14
0158  +0x02040  op=58  15 0e 00 00  LD64             s14 = *(uint64_t *)(s21 +0x0)
0159  +0x02058  op=84  05 16 11 04  ADD64            s17 = s5 + s22
015a  +0x02070  op=58  1d 16 90 02  LD64             s22 = *(uint64_t *)(s29 +0x290)
015b  +0x02088  op=58  1d 15 50 01  LD64             s21 = *(uint64_t *)(s29 +0x150)
015c  +0x020a0  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
015d  +0x020b8  op=25  1d 09 00 02  ST64             *(s29 +0x200) = s9
015e  +0x020d0  op=58  1d 09 98 02  LD64             s9 = *(uint64_t *)(s29 +0x298)
015f  +0x020e8  op=58  11 11 00 00  LD64             s17 = *(uint64_t *)(s17 +0x0)
0160  +0x02100  op=84  03 18 18 04  ADD64            s24 = s3 + s24
0161  +0x02118  op=02  0b 0e 0b 01  XOR64            s11 = s14 ^ s11
0162  +0x02130  op=67  00 15 0e 0d  LSR64_IMM32PLUS  s14 = (uint64_t)s21 >> (13 + 32)
0163  +0x02148  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
0164  +0x02160  op=25  1d 0b 00 01  ST64             *(s29 +0x100) = s11
0165  +0x02178  op=68  00 1f 0b 0d  LSR64_IMM        s11 = (uint64_t)s31 >> 13
0166  +0x02190  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0167  +0x021a8  op=58  1d 1f a0 02  LD64             s31 = *(uint64_t *)(s29 +0x2a0)
0168  +0x021c0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0169  +0x021d8  op=84  0a 0e 0e 00  ADD64            s14 = s10 + s14
016a  +0x021f0  op=02  04 18 04 01  XOR64            s4 = s24 ^ s4
016b  +0x02208  op=58  12 18 00 00  LD64             s24 = *(uint64_t *)(s18 +0x0)
016c  +0x02220  op=84  03 0b 0b 00  ADD64            s11 = s3 + s11
016d  +0x02238  op=25  1d 0e 40 01  ST64             *(s29 +0x140) = s14
016e  +0x02250  op=67  00 13 0e 05  LSR64_IMM32PLUS  s14 = (uint64_t)s19 >> (5 + 32)
016f  +0x02268  op=68  13 16 12 0d  LSR64_IMM        s18 = (uint64_t)s22 >> 13
0170  +0x02280  op=25  1d 04 c8 01  ST64             *(s29 +0x1c8) = s4
0171  +0x02298  op=68  13 09 04 15  LSR64_IMM        s4 = (uint64_t)s9 >> 21
0172  +0x022b0  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
0173  +0x022c8  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0174  +0x022e0  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
0175  +0x022f8  op=02  01 18 01 01  XOR64            s1 = s24 ^ s1
0176  +0x02310  op=67  00 17 18 0d  LSR64_IMM32PLUS  s24 = (uint64_t)s23 >> (13 + 32)
0177  +0x02328  op=84  07 0e 0e 14  ADD64            s14 = s7 + s14
0178  +0x02340  op=84  05 04 04 00  ADD64            s4 = s5 + s4
0179  +0x02358  op=25  1d 01 48 01  ST64             *(s29 +0x148) = s1
017a  +0x02370  op=02  02 0b 02 01  XOR64            s2 = s11 ^ s2
017b  +0x02388  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
017c  +0x023a0  op=25  1d 0e d0 01  ST64             *(s29 +0x1d0) = s14
017d  +0x023b8  op=68  00 1e 0e 0d  LSR64_IMM        s14 = (uint64_t)s30 >> 13
017e  +0x023d0  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
017f  +0x023e8  op=25  1d 02 f0 00  ST64             *(s29 +0xf0) = s2
0180  +0x02400  op=02  19 10 02 00  XOR64            s2 = s16 ^ s25
0181  +0x02418  op=58  1d 10 a8 01  LD64             s16 = *(uint64_t *)(s29 +0x1a8)
0182  +0x02430  op=84  0a 18 18 04  ADD64            s24 = s10 + s24
0183  +0x02448  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0184  +0x02460  op=25  1d 02 b0 01  ST64             *(s29 +0x1b0) = s2
0185  +0x02478  op=02  14 11 02 01  XOR64            s2 = s17 ^ s20
0186  +0x02490  op=58  1d 11 80 01  LD64             s17 = *(uint64_t *)(s29 +0x180)
0187  +0x024a8  op=25  1d 18 30 01  ST64             *(s29 +0x130) = s24
0188  +0x024c0  op=b2  12 14 f8 07  AND64_IMM16      s20 = s18 & 0x7f8
0189  +0x024d8  op=84  03 0e 0e 00  ADD64            s14 = s3 + s14
018a  +0x024f0  op=02  0f 04 01 01  XOR64            s1 = s4 ^ s15
018b  +0x02508  op=25  1d 02 f8 00  ST64             *(s29 +0xf8) = s2
018c  +0x02520  op=67  00 13 02 0d  LSR64_IMM32PLUS  s2 = (uint64_t)s19 >> (13 + 32)
018d  +0x02538  op=67  00 16 04 0d  LSR64_IMM32PLUS  s4 = (uint64_t)s22 >> (13 + 32)
018e  +0x02550  op=67  00 10 0b 0d  LSR64_IMM32PLUS  s11 = (uint64_t)s16 >> (13 + 32)
018f  +0x02568  op=67  00 0d 0f 0d  LSR64_IMM32PLUS  s15 = (uint64_t)s13 >> (13 + 32)
0190  +0x02580  op=67  00 10 18 05  LSR64_IMM32PLUS  s24 = (uint64_t)s16 >> (5 + 32)
0191  +0x02598  op=25  1d 0e 40 02  ST64             *(s29 +0x240) = s14
0192  +0x025b0  op=25  1d 01 78 01  ST64             *(s29 +0x178) = s1
0193  +0x025c8  op=67  00 1e 01 0d  LSR64_IMM32PLUS  s1 = (uint64_t)s30 >> (13 + 32)
0194  +0x025e0  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
0195  +0x025f8  op=67  00 11 19 0d  LSR64_IMM32PLUS  s25 = (uint64_t)s17 >> (13 + 32)
0196  +0x02610  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
0197  +0x02628  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0198  +0x02640  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
0199  +0x02658  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
019a  +0x02670  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
019b  +0x02688  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
019c  +0x026a0  op=84  0a 02 02 04  ADD64            s2 = s10 + s2
019d  +0x026b8  op=84  0a 0f 0f 00  ADD64            s15 = s10 + s15
019e  +0x026d0  op=84  0a 0b 0b 04  ADD64            s11 = s10 + s11
019f  +0x026e8  op=84  0a 04 04 00  ADD64            s4 = s10 + s4
01a0  +0x02700  op=84  07 18 18 00  ADD64            s24 = s7 + s24
01a1  +0x02718  op=84  0a 01 01 14  ADD64            s1 = s10 + s1
01a2  +0x02730  op=84  0a 19 19 04  ADD64            s25 = s10 + s25
01a3  +0x02748  op=25  1d 02 78 02  ST64             *(s29 +0x278) = s2
01a4  +0x02760  op=67  00 1e 02 05  LSR64_IMM32PLUS  s2 = (uint64_t)s30 >> (5 + 32)
01a5  +0x02778  op=25  1d 0f 20 01  ST64             *(s29 +0x120) = s15
01a6  +0x02790  op=67  00 15 0f 05  LSR64_IMM32PLUS  s15 = (uint64_t)s21 >> (5 + 32)
01a7  +0x027a8  op=25  1d 0b 38 01  ST64             *(s29 +0x138) = s11
01a8  +0x027c0  op=67  00 0d 0b 05  LSR64_IMM32PLUS  s11 = (uint64_t)s13 >> (5 + 32)
01a9  +0x027d8  op=25  1d 04 48 02  ST64             *(s29 +0x248) = s4
01aa  +0x027f0  op=67  00 17 04 05  LSR64_IMM32PLUS  s4 = (uint64_t)s23 >> (5 + 32)
01ab  +0x02808  op=34  10 00 0a 01  OR64             s10 = s16 | s0
01ac  +0x02820  op=25  1d 18 e8 01  ST64             *(s29 +0x1e8) = s24
01ad  +0x02838  op=68  13 1f 18 0d  LSR64_IMM        s24 = (uint64_t)s31 >> 13
01ae  +0x02850  op=25  1d 01 58 02  ST64             *(s29 +0x258) = s1
01af  +0x02868  op=67  00 16 01 05  LSR64_IMM32PLUS  s1 = (uint64_t)s22 >> (5 + 32)
01b0  +0x02880  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01b1  +0x02898  op=25  1d 19 18 01  ST64             *(s29 +0x118) = s25
01b2  +0x028b0  op=67  00 11 19 05  LSR64_IMM32PLUS  s25 = (uint64_t)s17 >> (5 + 32)
01b3  +0x028c8  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
01b4  +0x028e0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
01b5  +0x028f8  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
01b6  +0x02910  op=34  11 00 0a 01  OR64             s10 = s17 | s0
01b7  +0x02928  op=68  03 11 11 0d  LSR64_IMM        s17 = (uint64_t)s17 >> 13
01b8  +0x02940  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
01b9  +0x02958  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
01ba  +0x02970  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
01bb  +0x02988  op=84  07 02 02 04  ADD64            s2 = s7 + s2
01bc  +0x029a0  op=84  07 0f 0f 04  ADD64            s15 = s7 + s15
01bd  +0x029b8  op=84  07 0b 0b 00  ADD64            s11 = s7 + s11
01be  +0x029d0  op=84  07 04 04 14  ADD64            s4 = s7 + s4
01bf  +0x029e8  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
01c0  +0x02a00  op=84  03 18 18 00  ADD64            s24 = s3 + s24
01c1  +0x02a18  op=34  0a 00 12 00  OR64             s18 = s10 | s0
01c2  +0x02a30  op=84  07 01 01 04  ADD64            s1 = s7 + s1
01c3  +0x02a48  op=84  07 19 19 04  ADD64            s25 = s7 + s25
01c4  +0x02a60  op=25  1d 02 70 02  ST64             *(s29 +0x270) = s2
01c5  +0x02a78  op=68  13 10 02 0d  LSR64_IMM        s2 = (uint64_t)s16 >> 13
01c6  +0x02a90  op=34  10 00 07 01  OR64             s7 = s16 | s0
01c7  +0x02aa8  op=68  13 17 10 0d  LSR64_IMM        s16 = (uint64_t)s23 >> 13
01c8  +0x02ac0  op=25  1d 0b 08 02  ST64             *(s29 +0x208) = s11
01c9  +0x02ad8  op=68  00 13 0b 0d  LSR64_IMM        s11 = (uint64_t)s19 >> 13
01ca  +0x02af0  op=25  1d 0f d8 01  ST64             *(s29 +0x1d8) = s15
01cb  +0x02b08  op=68  03 09 0f 0d  LSR64_IMM        s15 = (uint64_t)s9 >> 13
01cc  +0x02b20  op=25  1d 04 e0 01  ST64             *(s29 +0x1e0) = s4
01cd  +0x02b38  op=68  00 15 04 0d  LSR64_IMM        s4 = (uint64_t)s21 >> 13
01ce  +0x02b50  op=58  1d 09 b0 02  LD64             s9 = *(uint64_t *)(s29 +0x2b0)
01cf  +0x02b68  op=25  1d 18 e8 00  ST64             *(s29 +0xe8) = s24
01d0  +0x02b80  op=25  1d 01 60 02  ST64             *(s29 +0x260) = s1
01d1  +0x02b98  op=68  00 0d 01 0d  LSR64_IMM        s1 = (uint64_t)s13 >> 13
01d2  +0x02bb0  op=b2  10 10 f8 07  AND64_IMM16      s16 = s16 & 0x7f8
01d3  +0x02bc8  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
01d4  +0x02be0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
01d5  +0x02bf8  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
01d6  +0x02c10  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
01d7  +0x02c28  op=25  1d 19 f8 01  ST64             *(s29 +0x1f8) = s25
01d8  +0x02c40  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
01d9  +0x02c58  op=84  03 02 02 00  ADD64            s2 = s3 + s2
01da  +0x02c70  op=84  03 0b 0b 04  ADD64            s11 = s3 + s11
01db  +0x02c88  op=84  03 0f 0f 00  ADD64            s15 = s3 + s15
01dc  +0x02ca0  op=84  03 04 04 14  ADD64            s4 = s3 + s4
01dd  +0x02cb8  op=68  13 09 19 0d  LSR64_IMM        s25 = (uint64_t)s9 >> 13
01de  +0x02cd0  op=84  03 01 01 00  ADD64            s1 = s3 + s1
01df  +0x02ce8  op=25  1d 02 10 02  ST64             *(s29 +0x210) = s2
01e0  +0x02d00  op=25  1d 0b 30 02  ST64             *(s29 +0x230) = s11
01e1  +0x02d18  op=25  1d 0f 10 01  ST64             *(s29 +0x110) = s15
01e2  +0x02d30  op=25  1d 04 18 02  ST64             *(s29 +0x218) = s4
01e3  +0x02d48  op=67  00 0d 04 15  LSR64_IMM32PLUS  s4 = (uint64_t)s13 >> (21 + 32)
01e4  +0x02d60  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
01e5  +0x02d78  op=25  1d 01 38 02  ST64             *(s29 +0x238) = s1
01e6  +0x02d90  op=84  03 14 01 14  ADD64            s1 = s3 + s20
01e7  +0x02da8  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
01e8  +0x02dc0  op=84  03 19 09 14  ADD64            s9 = s3 + s25
01e9  +0x02dd8  op=67  00 17 19 15  LSR64_IMM32PLUS  s25 = (uint64_t)s23 >> (21 + 32)
01ea  +0x02df0  op=68  00 15 14 15  LSR64_IMM        s20 = (uint64_t)s21 >> 21
01eb  +0x02e08  op=25  1d 01 28 02  ST64             *(s29 +0x228) = s1
01ec  +0x02e20  op=84  03 11 01 00  ADD64            s1 = s3 + s17
01ed  +0x02e38  op=68  13 13 11 15  LSR64_IMM        s17 = (uint64_t)s19 >> 21
01ee  +0x02e50  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
01ef  +0x02e68  op=b2  14 14 f8 07  AND64_IMM16      s20 = s20 & 0x7f8
01f0  +0x02e80  op=25  1d 01 50 02  ST64             *(s29 +0x250) = s1
01f1  +0x02e98  op=84  03 10 01 00  ADD64            s1 = s3 + s16
01f2  +0x02eb0  op=84  0c 04 03 14  ADD64            s3 = s12 + s4
01f3  +0x02ec8  op=b2  11 11 f8 07  AND64_IMM16      s17 = s17 & 0x7f8
01f4  +0x02ee0  op=34  0d 00 10 01  OR64             s16 = s13 | s0
01f5  +0x02ef8  op=68  00 0d 0d 15  LSR64_IMM        s13 = (uint64_t)s13 >> 21
01f6  +0x02f10  op=25  1d 01 68 02  ST64             *(s29 +0x268) = s1
01f7  +0x02f28  op=67  00 0a 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s10 >> (21 + 32)
01f8  +0x02f40  op=25  1d 03 d0 00  ST64             *(s29 +0xd0) = s3
01f9  +0x02f58  op=84  0c 19 0a 00  ADD64            s10 = s12 + s25
01fa  +0x02f70  op=68  03 1e 19 15  LSR64_IMM        s25 = (uint64_t)s30 >> 21
01fb  +0x02f88  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
01fc  +0x02fa0  op=b2  01 02 f8 07  AND64_IMM16      s2 = s1 & 0x7f8
01fd  +0x02fb8  op=67  00 15 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s21 >> (21 + 32)
01fe  +0x02fd0  op=b2  19 19 f8 07  AND64_IMM16      s25 = s25 & 0x7f8
01ff  +0x02fe8  op=b2  01 0b f8 07  AND64_IMM16      s11 = s1 & 0x7f8
0200  +0x03000  op=67  00 13 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s19 >> (21 + 32)
0201  +0x03018  op=84  0c 02 02 00  ADD64            s2 = s12 + s2
0202  +0x03030  op=b2  01 0e f8 07  AND64_IMM16      s14 = s1 & 0x7f8
0203  +0x03048  op=67  00 1e 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s30 >> (21 + 32)
0204  +0x03060  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0205  +0x03078  op=b2  01 0f f8 07  AND64_IMM16      s15 = s1 & 0x7f8
0206  +0x03090  op=67  00 07 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s7 >> (21 + 32)
0207  +0x030a8  op=b2  01 18 f8 07  AND64_IMM16      s24 = s1 & 0x7f8
0208  +0x030c0  op=67  00 16 01 15  LSR64_IMM32PLUS  s1 = (uint64_t)s22 >> (21 + 32)
0209  +0x030d8  op=84  0c 0f 03 14  ADD64            s3 = s12 + s15
020a  +0x030f0  op=68  13 12 0f 15  LSR64_IMM        s15 = (uint64_t)s18 >> 21
020b  +0x03108  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
020c  +0x03120  op=25  1d 03 60 01  ST64             *(s29 +0x160) = s3
020d  +0x03138  op=84  0c 0e 03 14  ADD64            s3 = s12 + s14
020e  +0x03150  op=68  03 17 0e 15  LSR64_IMM        s14 = (uint64_t)s23 >> 21
020f  +0x03168  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
0210  +0x03180  op=84  0c 01 04 14  ADD64            s4 = s12 + s1
0211  +0x03198  op=84  0c 18 01 00  ADD64            s1 = s12 + s24
0212  +0x031b0  op=25  1d 03 b8 01  ST64             *(s29 +0x1b8) = s3
0213  +0x031c8  op=84  0c 0b 03 04  ADD64            s3 = s12 + s11
0214  +0x031e0  op=68  03 16 18 15  LSR64_IMM        s24 = (uint64_t)s22 >> 21
0215  +0x031f8  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0216  +0x03210  op=25  1d 01 d8 00  ST64             *(s29 +0xd8) = s1
0217  +0x03228  op=58  1d 01 c0 02  LD64             s1 = *(uint64_t *)(s29 +0x2c0)
0218  +0x03240  op=25  1d 03 20 02  ST64             *(s29 +0x220) = s3
0219  +0x03258  op=58  1d 03 00 02  LD64             s3 = *(uint64_t *)(s29 +0x200)
021a  +0x03270  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
021b  +0x03288  op=68  00 01 0b 15  LSR64_IMM        s11 = (uint64_t)s1 >> 21
021c  +0x032a0  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
021d  +0x032b8  op=84  05 0b 0b 14  ADD64            s11 = s5 + s11
021e  +0x032d0  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
021f  +0x032e8  op=02  03 0b 03 01  XOR64            s3 = s11 ^ s3
0220  +0x03300  op=68  03 07 0b 15  LSR64_IMM        s11 = (uint64_t)s7 >> 21
0221  +0x03318  op=25  1d 03 e0 00  ST64             *(s29 +0xe0) = s3
0222  +0x03330  op=84  05 14 03 00  ADD64            s3 = s5 + s20
0223  +0x03348  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0224  +0x03360  op=58  1d 14 b8 02  LD64             s20 = *(uint64_t *)(s29 +0x2b8)
0225  +0x03378  op=25  1d 03 a0 01  ST64             *(s29 +0x1a0) = s3
0226  +0x03390  op=84  05 11 03 14  ADD64            s3 = s5 + s17
0227  +0x033a8  op=58  1d 11 c8 02  LD64             s17 = *(uint64_t *)(s29 +0x2c8)
0228  +0x033c0  op=25  1d 03 90 01  ST64             *(s29 +0x190) = s3
0229  +0x033d8  op=84  05 19 03 00  ADD64            s3 = s5 + s25
022a  +0x033f0  op=25  1d 03 68 01  ST64             *(s29 +0x168) = s3
022b  +0x03408  op=84  05 18 03 14  ADD64            s3 = s5 + s24
022c  +0x03420  op=68  03 14 18 05  LSR64_IMM        s24 = (uint64_t)s20 >> 5
022d  +0x03438  op=25  1d 03 58 01  ST64             *(s29 +0x158) = s3
022e  +0x03450  op=84  05 0f 03 04  ADD64            s3 = s5 + s15
022f  +0x03468  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0230  +0x03480  op=58  09 0f 00 00  LD64             s15 = *(uint64_t *)(s9 +0x0)
0231  +0x03498  op=25  1d 03 98 01  ST64             *(s29 +0x198) = s3
0232  +0x034b0  op=84  05 0e 03 04  ADD64            s3 = s5 + s14
0233  +0x034c8  op=84  06 18 18 00  ADD64            s24 = s6 + s24
0234  +0x034e0  op=25  1d 03 c0 01  ST64             *(s29 +0x1c0) = s3
0235  +0x034f8  op=84  05 0d 03 14  ADD64            s3 = s5 + s13
0236  +0x03510  op=68  03 01 0d 05  LSR64_IMM        s13 = (uint64_t)s1 >> 5
0237  +0x03528  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
0238  +0x03540  op=25  1d 03 00 02  ST64             *(s29 +0x200) = s3
0239  +0x03558  op=84  05 0b 03 14  ADD64            s3 = s5 + s11
023a  +0x03570  op=68  13 11 0b 05  LSR64_IMM        s11 = (uint64_t)s17 >> 5
023b  +0x03588  op=58  1d 05 98 02  LD64             s5 = *(uint64_t *)(s29 +0x298)
023c  +0x035a0  op=b2  0d 0d f8 07  AND64_IMM16      s13 = s13 & 0x7f8
023d  +0x035b8  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
023e  +0x035d0  op=25  1d 03 70 01  ST64             *(s29 +0x170) = s3
023f  +0x035e8  op=58  1d 03 f0 00  LD64             s3 = *(uint64_t *)(s29 +0xf0)
0240  +0x03600  op=84  06 0d 0d 00  ADD64            s13 = s6 + s13
0241  +0x03618  op=84  06 0b 0b 04  ADD64            s11 = s6 + s11
0242  +0x03630  op=68  03 05 0e 05  LSR64_IMM        s14 = (uint64_t)s5 >> 5
0243  +0x03648  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
0244  +0x03660  op=b2  05 0c ff 00  AND64_IMM16      s12 = s5 & 0xff
0245  +0x03678  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
0246  +0x03690  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
0247  +0x036a8  op=6e  02 0c 0c 03  SHL64_IMM        s12 = s12 << 3
0248  +0x036c0  op=84  06 0e 0e 14  ADD64            s14 = s6 + s14
0249  +0x036d8  op=02  03 0b 0b 00  XOR64            s11 = s11 ^ s3
024a  +0x036f0  op=34  01 00 03 01  OR64             s3 = s1 | s0
024b  +0x03708  op=58  1d 01 00 01  LD64             s1 = *(uint64_t *)(s29 +0x100)
024c  +0x03720  op=58  0e 0e 00 00  LD64             s14 = *(uint64_t *)(s14 +0x0)
024d  +0x03738  op=b2  03 19 ff 00  AND64_IMM16      s25 = s3 & 0xff
024e  +0x03750  op=58  1d 03 c0 00  LD64             s3 = *(uint64_t *)(s29 +0xc0)
024f  +0x03768  op=02  01 0d 0d 01  XOR64            s13 = s13 ^ s1
0250  +0x03780  op=58  1d 01 c8 01  LD64             s1 = *(uint64_t *)(s29 +0x1c8)
0251  +0x03798  op=6e  12 19 19 03  SHL64_IMM        s25 = s25 << 3
0252  +0x037b0  op=84  03 0c 0c 04  ADD64            s12 = s3 + s12
0253  +0x037c8  op=84  03 19 19 04  ADD64            s25 = s3 + s25
0254  +0x037e0  op=02  01 0e 0e 01  XOR64            s14 = s14 ^ s1
0255  +0x037f8  op=58  1d 01 f8 00  LD64             s1 = *(uint64_t *)(s29 +0xf8)
0256  +0x03810  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
0257  +0x03828  op=58  19 19 00 00  LD64             s25 = *(uint64_t *)(s25 +0x0)
0258  +0x03840  op=02  0d 0c 09 01  XOR64            s9 = s12 ^ s13
0259  +0x03858  op=b2  14 0c ff 00  AND64_IMM16      s12 = s20 & 0xff
025a  +0x03870  op=02  01 0f 0f 01  XOR64            s15 = s15 ^ s1
025b  +0x03888  op=58  1d 01 b0 01  LD64             s1 = *(uint64_t *)(s29 +0x1b0)
025c  +0x038a0  op=6e  02 0c 0c 03  SHL64_IMM        s12 = s12 << 3
025d  +0x038b8  op=02  02 09 02 00  XOR64            s2 = s9 ^ s2
025e  +0x038d0  op=25  1d 09 98 02  ST64             *(s29 +0x298) = s9
025f  +0x038e8  op=02  01 18 18 01  XOR64            s24 = s24 ^ s1
0260  +0x03900  op=84  03 0c 0c 14  ADD64            s12 = s3 + s12
0261  +0x03918  op=58  1d 01 08 01  LD64             s1 = *(uint64_t *)(s29 +0x108)
0262  +0x03930  op=58  0c 0c 00 00  LD64             s12 = *(uint64_t *)(s12 +0x0)
0263  +0x03948  op=02  18 19 19 01  XOR64            s25 = s25 ^ s24
0264  +0x03960  op=68  13 01 18 05  LSR64_IMM        s24 = (uint64_t)s1 >> 5
0265  +0x03978  op=25  1d 19 c8 01  ST64             *(s29 +0x1c8) = s25
0266  +0x03990  op=02  0b 0c 0d 01  XOR64            s13 = s12 ^ s11
0267  +0x039a8  op=b2  18 18 f8 07  AND64_IMM16      s24 = s24 & 0x7f8
0268  +0x039c0  op=b2  11 0b ff 00  AND64_IMM16      s11 = s17 & 0xff
0269  +0x039d8  op=58  0a 0c 00 00  LD64             s12 = *(uint64_t *)(s10 +0x0)
026a  +0x039f0  op=84  06 18 18 00  ADD64            s24 = s6 + s24
026b  +0x03a08  op=6e  02 0b 0b 03  SHL64_IMM        s11 = s11 << 3
026c  +0x03a20  op=25  1d 0d c0 02  ST64             *(s29 +0x2c0) = s13
026d  +0x03a38  op=84  03 0b 0b 14  ADD64            s11 = s3 + s11
026e  +0x03a50  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
026f  +0x03a68  op=02  0c 19 0c 01  XOR64            s12 = s25 ^ s12
0270  +0x03a80  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
0271  +0x03a98  op=02  0f 18 0f 01  XOR64            s15 = s24 ^ s15
0272  +0x03ab0  op=b2  1f 18 ff 00  AND64_IMM16      s24 = s31 & 0xff
0273  +0x03ac8  op=58  1d 1f f0 01  LD64             s31 = *(uint64_t *)(s29 +0x1f0)
0274  +0x03ae0  op=02  0f 0b 05 01  XOR64            s5 = s11 ^ s15
0275  +0x03af8  op=58  1d 0b 18 01  LD64             s11 = *(uint64_t *)(s29 +0x118)
0276  +0x03b10  op=6e  02 18 18 03  SHL64_IMM        s24 = s24 << 3
0277  +0x03b28  op=68  03 12 0f 1d  LSR64_IMM        s15 = (uint64_t)s18 >> 29
0278  +0x03b40  op=84  03 18 18 04  ADD64            s24 = s3 + s24
0279  +0x03b58  op=b2  0f 0f f8 07  AND64_IMM16      s15 = s15 & 0x7f8
027a  +0x03b70  op=25  1d 05 b8 02  ST64             *(s29 +0x2b8) = s5
027b  +0x03b88  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
027c  +0x03ba0  op=58  18 18 00 00  LD64             s24 = *(uint64_t *)(s24 +0x0)
027d  +0x03bb8  op=84  08 0f 09 14  ADD64            s9 = s8 + s15
027e  +0x03bd0  op=25  1d 09 c8 00  ST64             *(s29 +0xc8) = s9
027f  +0x03be8  op=02  0c 0b 0a 01  XOR64            s10 = s11 ^ s12
0280  +0x03c00  op=b2  01 0b ff 00  AND64_IMM16      s11 = s1 & 0xff
0281  +0x03c18  op=58  1d 01 20 01  LD64             s1 = *(uint64_t *)(s29 +0x120)
0282  +0x03c30  op=02  0e 18 0e 01  XOR64            s14 = s24 ^ s14
0283  +0x03c48  op=68  00 13 0c 1d  LSR64_IMM        s12 = (uint64_t)s19 >> 29
0284  +0x03c60  op=6e  12 0b 0b 03  SHL64_IMM        s11 = s11 << 3
0285  +0x03c78  op=25  1d 0a c8 02  ST64             *(s29 +0x2c8) = s10
0286  +0x03c90  op=58  1d 0a 48 01  LD64             s10 = *(uint64_t *)(s29 +0x148)
0287  +0x03ca8  op=25  1d 0e b0 01  ST64             *(s29 +0x1b0) = s14
0288  +0x03cc0  op=84  03 0b 0b 00  ADD64            s11 = s3 + s11
0289  +0x03cd8  op=58  0b 0b 00 00  LD64             s11 = *(uint64_t *)(s11 +0x0)
028a  +0x03cf0  op=02  0a 0b 0a 00  XOR64            s10 = s11 ^ s10
028b  +0x03d08  op=58  01 0b 00 00  LD64             s11 = *(uint64_t *)(s1 +0x0)
028c  +0x03d20  op=58  04 01 00 00  LD64             s1 = *(uint64_t *)(s4 +0x0)
028d  +0x03d38  op=58  1d 04 d0 00  LD64             s4 = *(uint64_t *)(s29 +0xd0)
028e  +0x03d50  op=02  01 05 01 01  XOR64            s1 = s5 ^ s1
028f  +0x03d68  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
0290  +0x03d80  op=34  15 00 05 01  OR64             s5 = s21 | s0
0291  +0x03d98  op=02  01 0b 01 01  XOR64            s1 = s11 ^ s1
0292  +0x03db0  op=68  13 15 0b 1d  LSR64_IMM        s11 = (uint64_t)s21 >> 29
0293  +0x03dc8  op=25  1d 01 f8 00  ST64             *(s29 +0xf8) = s1
0294  +0x03de0  op=58  1d 01 30 01  LD64             s1 = *(uint64_t *)(s29 +0x130)
0295  +0x03df8  op=02  04 0d 04 00  XOR64            s4 = s13 ^ s4
0296  +0x03e10  op=b2  0c 0d f8 07  AND64_IMM16      s13 = s12 & 0x7f8
0297  +0x03e28  op=68  03 1e 0c 1d  LSR64_IMM        s12 = (uint64_t)s30 >> 29
0298  +0x03e40  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
0299  +0x03e58  op=b2  0c 0c f8 07  AND64_IMM16      s12 = s12 & 0x7f8
029a  +0x03e70  op=84  08 0d 0d 04  ADD64            s13 = s8 + s13
029b  +0x03e88  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
029c  +0x03ea0  op=84  08 0c 0c 14  ADD64            s12 = s8 + s12
029d  +0x03eb8  op=58  0d 0d 00 00  LD64             s13 = *(uint64_t *)(s13 +0x0)
029e  +0x03ed0  op=02  04 01 01 00  XOR64            s1 = s1 ^ s4
029f  +0x03ee8  op=68  13 10 04 1d  LSR64_IMM        s4 = (uint64_t)s16 >> 29
02a0  +0x03f00  op=25  1d 01 f0 00  ST64             *(s29 +0xf0) = s1
02a1  +0x03f18  op=58  1d 01 38 01  LD64             s1 = *(uint64_t *)(s29 +0x138)
02a2  +0x03f30  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
02a3  +0x03f48  op=84  08 04 04 00  ADD64            s4 = s8 + s4
02a4  +0x03f60  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02a5  +0x03f78  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2
02a6  +0x03f90  op=58  1d 02 d8 00  LD64             s2 = *(uint64_t *)(s29 +0xd8)
02a7  +0x03fa8  op=25  1d 01 d0 00  ST64             *(s29 +0xd0) = s1
02a8  +0x03fc0  op=58  1d 01 40 01  LD64             s1 = *(uint64_t *)(s29 +0x140)
02a9  +0x03fd8  op=25  1d 04 40 01  ST64             *(s29 +0x140) = s4
02aa  +0x03ff0  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
02ab  +0x04008  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02ac  +0x04020  op=02  02 0e 02 01  XOR64            s2 = s14 ^ s2
02ad  +0x04038  op=68  00 17 0e 1d  LSR64_IMM        s14 = (uint64_t)s23 >> 29
02ae  +0x04050  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2
02af  +0x04068  op=58  1d 02 78 01  LD64             s2 = *(uint64_t *)(s29 +0x178)
02b0  +0x04080  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
02b1  +0x04098  op=25  1d 01 d8 00  ST64             *(s29 +0xd8) = s1
02b2  +0x040b0  op=58  1d 01 e8 00  LD64             s1 = *(uint64_t *)(s29 +0xe8)
02b3  +0x040c8  op=25  1d 0c e8 00  ST64             *(s29 +0xe8) = s12
02b4  +0x040e0  op=84  08 0e 09 00  ADD64            s9 = s8 + s14
02b5  +0x040f8  op=84  08 0b 0c 00  ADD64            s12 = s8 + s11
02b6  +0x04110  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02b7  +0x04128  op=02  02 01 14 00  XOR64            s20 = s1 ^ s2
02b8  +0x04140  op=68  03 07 01 1d  LSR64_IMM        s1 = (uint64_t)s7 >> 29
02b9  +0x04158  op=68  00 16 02 1d  LSR64_IMM        s2 = (uint64_t)s22 >> 29
02ba  +0x04170  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
02bb  +0x04188  op=b2  01 01 f8 07  AND64_IMM16      s1 = s1 & 0x7f8
02bc  +0x041a0  op=84  08 02 02 04  ADD64            s2 = s8 + s2
02bd  +0x041b8  op=84  08 01 08 00  ADD64            s8 = s8 + s1
02be  +0x041d0  op=58  1d 01 10 01  LD64             s1 = *(uint64_t *)(s29 +0x110)
02bf  +0x041e8  op=25  1d 02 78 01  ST64             *(s29 +0x178) = s2
02c0  +0x04200  op=58  1d 02 e0 00  LD64             s2 = *(uint64_t *)(s29 +0xe0)
02c1  +0x04218  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
02c2  +0x04230  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2
02c3  +0x04248  op=25  1d 01 00 01  ST64             *(s29 +0x100) = s1
02c4  +0x04260  op=b2  15 01 ff 00  AND64_IMM16      s1 = s21 & 0xff
02c5  +0x04278  op=6e  00 01 02 03  SHL64_IMM        s2 = s1 << 3
02c6  +0x04290  op=b2  07 01 ff 00  AND64_IMM16      s1 = s7 & 0xff
02c7  +0x042a8  op=6e  00 01 04 03  SHL64_IMM        s4 = s1 << 3
02c8  +0x042c0  op=b2  1e 01 ff 00  AND64_IMM16      s1 = s30 & 0xff
02c9  +0x042d8  op=84  03 02 02 00  ADD64            s2 = s3 + s2
02ca  +0x042f0  op=6e  00 01 0b 03  SHL64_IMM        s11 = s1 << 3
02cb  +0x04308  op=b2  1f 01 ff 00  AND64_IMM16      s1 = s31 & 0xff
02cc  +0x04320  op=25  1d 02 48 01  ST64             *(s29 +0x148) = s2
02cd  +0x04338  op=84  03 04 04 00  ADD64            s4 = s3 + s4
02ce  +0x04350  op=6e  02 01 0e 03  SHL64_IMM        s14 = s1 << 3
02cf  +0x04368  op=b2  12 01 ff 00  AND64_IMM16      s1 = s18 & 0xff
02d0  +0x04380  op=84  03 0b 0b 04  ADD64            s11 = s3 + s11
02d1  +0x04398  op=6e  02 01 0f 03  SHL64_IMM        s15 = s1 << 3
02d2  +0x043b0  op=b2  17 01 ff 00  AND64_IMM16      s1 = s23 & 0xff
02d3  +0x043c8  op=25  1d 0b 18 01  ST64             *(s29 +0x118) = s11
02d4  +0x043e0  op=68  13 16 0b 05  LSR64_IMM        s11 = (uint64_t)s22 >> 5
02d5  +0x043f8  op=6e  12 01 18 03  SHL64_IMM        s24 = s1 << 3
02d6  +0x04410  op=b2  10 01 ff 00  AND64_IMM16      s1 = s16 & 0xff
02d7  +0x04428  op=b2  0b 0b f8 07  AND64_IMM16      s11 = s11 & 0x7f8
02d8  +0x04440  op=6e  00 01 19 03  SHL64_IMM        s25 = s1 << 3
02d9  +0x04458  op=b2  16 01 ff 00  AND64_IMM16      s1 = s22 & 0xff
02da  +0x04470  op=6e  00 01 11 03  SHL64_IMM        s17 = s1 << 3
02db  +0x04488  op=b2  13 01 ff 00  AND64_IMM16      s1 = s19 & 0xff
02dc  +0x044a0  op=84  03 11 02 04  ADD64            s2 = s3 + s17
02dd  +0x044b8  op=6e  00 01 15 03  SHL64_IMM        s21 = s1 << 3
02de  +0x044d0  op=58  1d 01 b0 02  LD64             s1 = *(uint64_t *)(s29 +0x2b0)
02df  +0x044e8  op=25  1d 04 b0 02  ST64             *(s29 +0x2b0) = s4
02e0  +0x04500  op=68  13 1e 04 05  LSR64_IMM        s4 = (uint64_t)s30 >> 5
02e1  +0x04518  op=84  03 0e 11 00  ADD64            s17 = s3 + s14
02e2  +0x04530  op=68  03 17 0e 05  LSR64_IMM        s14 = (uint64_t)s23 >> 5
02e3  +0x04548  op=25  1d 02 38 01  ST64             *(s29 +0x138) = s2
02e4  +0x04560  op=84  03 19 02 14  ADD64            s2 = s3 + s25
02e5  +0x04578  op=84  03 15 15 00  ADD64            s21 = s3 + s21
02e6  +0x04590  op=68  03 1f 19 05  LSR64_IMM        s25 = (uint64_t)s31 >> 5
02e7  +0x045a8  op=b2  0e 0e f8 07  AND64_IMM16      s14 = s14 & 0x7f8
02e8  +0x045c0  op=b2  04 04 f8 07  AND64_IMM16      s4 = s4 & 0x7f8
02e9  +0x045d8  op=25  1d 02 20 01  ST64             *(s29 +0x120) = s2
02ea  +0x045f0  op=84  03 18 02 00  ADD64            s2 = s3 + s24
02eb  +0x04608  op=68  13 12 18 05  LSR64_IMM        s24 = (uint64_t)s18 >> 5
02ec  +0x04620  op=b2  01 01 ff 00  AND64_IMM16      s1 = s1 & 0xff
02ed  +0x04638  op=25  1d 15 30 01  ST64             *(s29 +0x130) = s21
02ee  +0x04650  op=84  06 0b 15 00  ADD64            s21 = s6 + s11
02ef  +0x04668  op=58  08 12 00 00  LD64             s18 = *(uint64_t *)(s8 +0x0)
02f0  +0x04680  op=58  1d 08 30 02  LD64             s8 = *(uint64_t *)(s29 +0x230)
02f1  +0x04698  op=25  1d 02 10 01  ST64             *(s29 +0x110) = s2
02f2  +0x046b0  op=84  03 0f 02 14  ADD64            s2 = s3 + s15
02f3  +0x046c8  op=68  00 07 0f 05  LSR64_IMM        s15 = (uint64_t)s7 >> 5
02f4  +0x046e0  op=b2  18 07 f8 07  AND64_IMM16      s7 = s24 & 0x7f8
02f5  +0x046f8  op=6e  02 01 01 03  SHL64_IMM        s1 = s1 << 3
02f6  +0x04710  op=25  1d 02 08 01  ST64             *(s29 +0x108) = s2
02f7  +0x04728  op=68  13 13 02 05  LSR64_IMM        s2 = (uint64_t)s19 >> 5
02f8  +0x04740  op=b2  0f 13 f8 07  AND64_IMM16      s19 = s15 & 0x7f8
02f9  +0x04758  op=68  00 10 0f 05  LSR64_IMM        s15 = (uint64_t)s16 >> 5
02fa  +0x04770  op=84  03 01 01 04  ADD64            s1 = s3 + s1
02fb  +0x04788  op=b2  19 03 f8 07  AND64_IMM16      s3 = s25 & 0x7f8
02fc  +0x047a0  op=84  06 04 19 04  ADD64            s25 = s6 + s4
02fd  +0x047b8  op=84  06 0e 04 14  ADD64            s4 = s6 + s14
02fe  +0x047d0  op=84  06 07 1e 14  ADD64            s30 = s6 + s7
02ff  +0x047e8  op=58  1d 07 60 01  LD64             s7 = *(uint64_t *)(s29 +0x160)
0300  +0x04800  op=58  0c 10 00 00  LD64             s16 = *(uint64_t *)(s12 +0x0)
0301  +0x04818  op=b2  02 18 f8 07  AND64_IMM16      s24 = s2 & 0x7f8
0302  +0x04830  op=68  00 05 02 05  LSR64_IMM        s2 = (uint64_t)s5 >> 5
0303  +0x04848  op=b2  0f 05 f8 07  AND64_IMM16      s5 = s15 & 0x7f8
0304  +0x04860  op=84  06 03 03 14  ADD64            s3 = s6 + s3
0305  +0x04878  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0306  +0x04890  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0)
0307  +0x048a8  op=b2  02 0f f8 07  AND64_IMM16      s15 = s2 & 0x7f8
0308  +0x048c0  op=58  1d 02 a0 02  LD64             s2 = *(uint64_t *)(s29 +0x2a0)
0309  +0x048d8  op=84  06 05 0b 00  ADD64            s11 = s6 + s5
030a  +0x048f0  op=84  06 13 05 14  ADD64            s5 = s6 + s19
030b  +0x04908  op=84  06 18 18 04  ADD64            s24 = s6 + s24
030c  +0x04920  op=58  07 0e 00 00  LD64             s14 = *(uint64_t *)(s7 +0x0)
030d  +0x04938  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
030e  +0x04950  op=58  1d 07 08 02  LD64             s7 = *(uint64_t *)(s29 +0x208)
030f  +0x04968  op=25  1d 05 a0 02  ST64             *(s29 +0x2a0) = s5
0310  +0x04980  op=58  1d 05 d0 01  LD64             s5 = *(uint64_t *)(s29 +0x1d0)
0311  +0x04998  op=84  06 0f 0f 04  ADD64            s15 = s6 + s15
0312  +0x049b0  op=68  00 02 02 05  LSR64_IMM        s2 = (uint64_t)s2 >> 5
0313  +0x049c8  op=02  0e 0a 0e 01  XOR64            s14 = s10 ^ s14
0314  +0x049e0  op=02  14 03 03 01  XOR64            s3 = s3 ^ s20
0315  +0x049f8  op=b2  02 02 f8 07  AND64_IMM16      s2 = s2 & 0x7f8
0316  +0x04a10  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
0317  +0x04a28  op=02  03 01 01 01  XOR64            s1 = s1 ^ s3
0318  +0x04a40  op=58  1d 03 90 00  LD64             s3 = *(uint64_t *)(s29 +0x90)
0319  +0x04a58  op=84  06 02 02 14  ADD64            s2 = s6 + s2
031a  +0x04a70  op=58  1d 06 d8 00  LD64             s6 = *(uint64_t *)(s29 +0xd8)
031b  +0x04a88  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
031c  +0x04aa0  op=02  06 05 05 00  XOR64            s5 = s5 ^ s6
031d  +0x04ab8  op=58  1d 06 d8 01  LD64             s6 = *(uint64_t *)(s29 +0x1d8)
031e  +0x04ad0  op=58  06 13 00 00  LD64             s19 = *(uint64_t *)(s6 +0x0)
031f  +0x04ae8  op=58  1d 06 d0 00  LD64             s6 = *(uint64_t *)(s29 +0xd0)
0320  +0x04b00  op=02  06 13 13 00  XOR64            s19 = s19 ^ s6
0321  +0x04b18  op=58  1d 06 e8 01  LD64             s6 = *(uint64_t *)(s29 +0x1e8)
0322  +0x04b30  op=02  13 0d 0d 00  XOR64            s13 = s13 ^ s19
0323  +0x04b48  op=58  1d 13 a8 02  LD64             s19 = *(uint64_t *)(s29 +0x2a8)
0324  +0x04b60  op=58  06 16 00 00  LD64             s22 = *(uint64_t *)(s6 +0x0)
0325  +0x04b78  op=58  1d 06 c8 02  LD64             s6 = *(uint64_t *)(s29 +0x2c8)
0326  +0x04b90  op=25  1d 0a c8 02  ST64             *(s29 +0x2c8) = s10
0327  +0x04ba8  op=84  03 13 03 04  ADD64            s3 = s3 + s19
0328  +0x04bc0  op=85  13 13 08 00  ADD64_IMM16      s19 = s19 +0x8
0329  +0x04bd8  op=02  06 16 16 01  XOR64            s22 = s22 ^ s6
032a  +0x04bf0  op=58  1d 06 f8 01  LD64             s6 = *(uint64_t *)(s29 +0x1f8)
032b  +0x04c08  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
032c  +0x04c20  op=25  1d 13 a8 02  ST64             *(s29 +0x2a8) = s19
032d  +0x04c38  op=02  16 10 10 01  XOR64            s16 = s16 ^ s22
032e  +0x04c50  op=58  06 17 00 00  LD64             s23 = *(uint64_t *)(s6 +0x0)
032f  +0x04c68  op=58  1d 06 f0 00  LD64             s6 = *(uint64_t *)(s29 +0xf0)
0330  +0x04c80  op=02  06 17 17 00  XOR64            s23 = s23 ^ s6
0331  +0x04c98  op=58  1d 06 e0 01  LD64             s6 = *(uint64_t *)(s29 +0x1e0)
0332  +0x04cb0  op=02  17 12 12 01  XOR64            s18 = s18 ^ s23
0333  +0x04cc8  op=58  06 1f 00 00  LD64             s31 = *(uint64_t *)(s6 +0x0)
0334  +0x04ce0  op=58  1d 06 f8 00  LD64             s6 = *(uint64_t *)(s29 +0xf8)
0335  +0x04cf8  op=02  06 1f 1f 01  XOR64            s31 = s31 ^ s6
0336  +0x04d10  op=58  1d 06 48 02  LD64             s6 = *(uint64_t *)(s29 +0x248)
0337  +0x04d28  op=58  06 06 00 00  LD64             s6 = *(uint64_t *)(s6 +0x0)
0338  +0x04d40  op=02  0e 06 06 01  XOR64            s6 = s6 ^ s14
0339  +0x04d58  op=58  07 0e 00 00  LD64             s14 = *(uint64_t *)(s7 +0x0)
033a  +0x04d70  op=58  1d 07 c8 00  LD64             s7 = *(uint64_t *)(s29 +0xc8)
033b  +0x04d88  op=02  06 0e 06 00  XOR64            s6 = s14 ^ s6
033c  +0x04da0  op=58  09 0e 00 00  LD64             s14 = *(uint64_t *)(s9 +0x0)
033d  +0x04db8  op=02  06 0e 06 00  XOR64            s6 = s14 ^ s6
033e  +0x04dd0  op=58  07 0e 00 00  LD64             s14 = *(uint64_t *)(s7 +0x0)
033f  +0x04de8  op=58  1d 07 e8 00  LD64             s7 = *(uint64_t *)(s29 +0xe8)
0340  +0x04e00  op=58  07 0c 00 00  LD64             s12 = *(uint64_t *)(s7 +0x0)
0341  +0x04e18  op=02  01 03 07 01  XOR64            s7 = s3 ^ s1
0342  +0x04e30  op=58  1d 03 b8 01  LD64             s3 = *(uint64_t *)(s29 +0x1b8)
0343  +0x04e48  op=58  1d 01 58 02  LD64             s1 = *(uint64_t *)(s29 +0x258)
0344  +0x04e60  op=02  1f 0e 0e 00  XOR64            s14 = s14 ^ s31
0345  +0x04e78  op=34  07 00 1f 01  OR64             s31 = s7 | s0
0346  +0x04e90  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
0347  +0x04ea8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0348  +0x04ec0  op=02  05 0c 05 01  XOR64            s5 = s12 ^ s5
0349  +0x04ed8  op=02  03 07 03 01  XOR64            s3 = s7 ^ s3
034a  +0x04ef0  op=58  1d 07 90 01  LD64             s7 = *(uint64_t *)(s29 +0x190)
034b  +0x04f08  op=02  03 01 01 01  XOR64            s1 = s1 ^ s3
034c  +0x04f20  op=58  1d 03 58 01  LD64             s3 = *(uint64_t *)(s29 +0x158)
034d  +0x04f38  op=58  07 0c 00 00  LD64             s12 = *(uint64_t *)(s7 +0x0)
034e  +0x04f50  op=58  1d 07 a0 01  LD64             s7 = *(uint64_t *)(s29 +0x1a0)
034f  +0x04f68  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
0350  +0x04f80  op=02  10 0c 0c 00  XOR64            s12 = s12 ^ s16
0351  +0x04f98  op=02  05 03 03 01  XOR64            s3 = s3 ^ s5
0352  +0x04fb0  op=58  1d 05 68 01  LD64             s5 = *(uint64_t *)(s29 +0x168)
0353  +0x04fc8  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
0354  +0x04fe0  op=02  0d 05 05 01  XOR64            s5 = s5 ^ s13
0355  +0x04ff8  op=58  07 0d 00 00  LD64             s13 = *(uint64_t *)(s7 +0x0)
0356  +0x05010  op=58  1d 07 70 01  LD64             s7 = *(uint64_t *)(s29 +0x170)
0357  +0x05028  op=58  07 10 00 00  LD64             s16 = *(uint64_t *)(s7 +0x0)
0358  +0x05040  op=58  1d 07 98 01  LD64             s7 = *(uint64_t *)(s29 +0x198)
0359  +0x05058  op=02  12 0d 0d 01  XOR64            s13 = s13 ^ s18
035a  +0x05070  op=02  0e 10 0e 01  XOR64            s14 = s16 ^ s14
035b  +0x05088  op=58  07 10 00 00  LD64             s16 = *(uint64_t *)(s7 +0x0)
035c  +0x050a0  op=58  1d 07 00 01  LD64             s7 = *(uint64_t *)(s29 +0x100)
035d  +0x050b8  op=02  06 10 06 01  XOR64            s6 = s16 ^ s6
035e  +0x050d0  op=58  11 10 00 00  LD64             s16 = *(uint64_t *)(s17 +0x0)
035f  +0x050e8  op=02  07 02 02 01  XOR64            s2 = s2 ^ s7
0360  +0x05100  op=02  02 10 07 01  XOR64            s7 = s16 ^ s2
0361  +0x05118  op=58  1d 02 10 02  LD64             s2 = *(uint64_t *)(s29 +0x210)
0362  +0x05130  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0363  +0x05148  op=02  06 02 02 01  XOR64            s2 = s2 ^ s6
0364  +0x05160  op=58  1d 06 18 02  LD64             s6 = *(uint64_t *)(s29 +0x218)
0365  +0x05178  op=58  06 06 00 00  LD64             s6 = *(uint64_t *)(s6 +0x0)
0366  +0x05190  op=02  0e 06 06 01  XOR64            s6 = s6 ^ s14
0367  +0x051a8  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0368  +0x051c0  op=58  1d 08 40 02  LD64             s8 = *(uint64_t *)(s29 +0x240)
0369  +0x051d8  op=02  0d 0e 0d 01  XOR64            s13 = s14 ^ s13
036a  +0x051f0  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
036b  +0x05208  op=58  1d 08 28 02  LD64             s8 = *(uint64_t *)(s29 +0x228)
036c  +0x05220  op=02  0c 0e 0c 00  XOR64            s12 = s14 ^ s12
036d  +0x05238  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
036e  +0x05250  op=58  1d 08 38 02  LD64             s8 = *(uint64_t *)(s29 +0x238)
036f  +0x05268  op=02  05 0e 05 00  XOR64            s5 = s14 ^ s5
0370  +0x05280  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0371  +0x05298  op=58  1d 08 60 02  LD64             s8 = *(uint64_t *)(s29 +0x260)
0372  +0x052b0  op=02  03 0e 03 01  XOR64            s3 = s14 ^ s3
0373  +0x052c8  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0374  +0x052e0  op=58  1d 08 40 01  LD64             s8 = *(uint64_t *)(s29 +0x140)
0375  +0x052f8  op=02  03 04 03 01  XOR64            s3 = s4 ^ s3
0376  +0x05310  op=58  0b 04 00 00  LD64             s4 = *(uint64_t *)(s11 +0x0)
0377  +0x05328  op=58  19 0b 00 00  LD64             s11 = *(uint64_t *)(s25 +0x0)
0378  +0x05340  op=02  01 0e 01 01  XOR64            s1 = s14 ^ s1
0379  +0x05358  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
037a  +0x05370  op=58  1d 08 c0 01  LD64             s8 = *(uint64_t *)(s29 +0x1c0)
037b  +0x05388  op=02  05 04 04 00  XOR64            s4 = s4 ^ s5
037c  +0x053a0  op=58  15 05 00 00  LD64             s5 = *(uint64_t *)(s21 +0x0)
037d  +0x053b8  op=02  0d 0b 0b 01  XOR64            s11 = s11 ^ s13
037e  +0x053d0  op=58  1e 15 00 00  LD64             s21 = *(uint64_t *)(s30 +0x0)
037f  +0x053e8  op=02  01 0e 01 01  XOR64            s1 = s14 ^ s1
0380  +0x05400  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0381  +0x05418  op=58  1d 08 50 02  LD64             s8 = *(uint64_t *)(s29 +0x250)
0382  +0x05430  op=02  0c 05 05 00  XOR64            s5 = s5 ^ s12
0383  +0x05448  op=58  18 0c 00 00  LD64             s12 = *(uint64_t *)(s24 +0x0)
0384  +0x05460  op=02  01 0e 01 00  XOR64            s1 = s14 ^ s1
0385  +0x05478  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0386  +0x05490  op=58  1d 08 78 02  LD64             s8 = *(uint64_t *)(s29 +0x278)
0387  +0x054a8  op=02  06 0c 06 01  XOR64            s6 = s12 ^ s6
0388  +0x054c0  op=58  0f 0c 00 00  LD64             s12 = *(uint64_t *)(s15 +0x0)
0389  +0x054d8  op=02  01 0e 01 00  XOR64            s1 = s14 ^ s1
038a  +0x054f0  op=02  02 0c 02 00  XOR64            s2 = s12 ^ s2
038b  +0x05508  op=58  08 0c 00 00  LD64             s12 = *(uint64_t *)(s8 +0x0)
038c  +0x05520  op=58  1d 08 20 02  LD64             s8 = *(uint64_t *)(s29 +0x220)
038d  +0x05538  op=58  08 0d 00 00  LD64             s13 = *(uint64_t *)(s8 +0x0)
038e  +0x05550  op=58  1d 08 18 01  LD64             s8 = *(uint64_t *)(s29 +0x118)
038f  +0x05568  op=02  0d 07 0d 00  XOR64            s13 = s7 ^ s13
0390  +0x05580  op=02  0d 0c 0c 01  XOR64            s12 = s12 ^ s13
0391  +0x05598  op=58  08 0d 00 00  LD64             s13 = *(uint64_t *)(s8 +0x0)
0392  +0x055b0  op=58  1d 08 30 01  LD64             s8 = *(uint64_t *)(s29 +0x130)
0393  +0x055c8  op=58  08 0e 00 00  LD64             s14 = *(uint64_t *)(s8 +0x0)
0394  +0x055e0  op=58  1d 08 70 02  LD64             s8 = *(uint64_t *)(s29 +0x270)
0395  +0x055f8  op=58  08 0f 00 00  LD64             s15 = *(uint64_t *)(s8 +0x0)
0396  +0x05610  op=58  1d 08 a0 02  LD64             s8 = *(uint64_t *)(s29 +0x2a0)
0397  +0x05628  op=02  02 0e 02 01  XOR64            s2 = s14 ^ s2
0398  +0x05640  op=25  1d 02 88 02  ST64             *(s29 +0x288) = s2
0399  +0x05658  op=02  06 0d 02 01  XOR64            s2 = s13 ^ s6
039a  +0x05670  op=58  1d 06 b0 01  LD64             s6 = *(uint64_t *)(s29 +0x1b0)
039b  +0x05688  op=58  08 18 00 00  LD64             s24 = *(uint64_t *)(s8 +0x0)
039c  +0x056a0  op=58  1d 08 08 01  LD64             s8 = *(uint64_t *)(s29 +0x108)
039d  +0x056b8  op=25  1d 02 90 02  ST64             *(s29 +0x290) = s2
039e  +0x056d0  op=58  08 19 00 00  LD64             s25 = *(uint64_t *)(s8 +0x0)
039f  +0x056e8  op=58  1d 08 10 01  LD64             s8 = *(uint64_t *)(s29 +0x110)
03a0  +0x05700  op=02  01 18 01 00  XOR64            s1 = s24 ^ s1
03a1  +0x05718  op=58  08 10 00 00  LD64             s16 = *(uint64_t *)(s8 +0x0)
03a2  +0x05730  op=58  1d 08 20 01  LD64             s8 = *(uint64_t *)(s29 +0x120)
03a3  +0x05748  op=58  08 11 00 00  LD64             s17 = *(uint64_t *)(s8 +0x0)
03a4  +0x05760  op=58  1d 08 38 01  LD64             s8 = *(uint64_t *)(s29 +0x138)
03a5  +0x05778  op=02  04 10 0a 01  XOR64            s10 = s16 ^ s4
03a6  +0x05790  op=58  08 12 00 00  LD64             s18 = *(uint64_t *)(s8 +0x0)
03a7  +0x057a8  op=58  1d 08 48 01  LD64             s8 = *(uint64_t *)(s29 +0x148)
03a8  +0x057c0  op=02  05 11 11 01  XOR64            s17 = s17 ^ s5
03a9  +0x057d8  op=58  08 13 00 00  LD64             s19 = *(uint64_t *)(s8 +0x0)
03aa  +0x057f0  op=58  1d 08 b0 02  LD64             s8 = *(uint64_t *)(s29 +0x2b0)
03ab  +0x05808  op=02  0b 12 02 01  XOR64            s2 = s18 ^ s11
03ac  +0x05820  op=02  03 19 0b 01  XOR64            s11 = s25 ^ s3
03ad  +0x05838  op=58  1d 03 98 02  LD64             s3 = *(uint64_t *)(s29 +0x298)
03ae  +0x05850  op=25  1d 02 80 02  ST64             *(s29 +0x280) = s2
03af  +0x05868  op=02  0c 0f 02 01  XOR64            s2 = s15 ^ s12
03b0  +0x05880  op=58  1d 0c c8 01  LD64             s12 = *(uint64_t *)(s29 +0x1c8)
03b1  +0x05898  op=58  08 14 00 00  LD64             s20 = *(uint64_t *)(s8 +0x0)
03b2  +0x058b0  op=58  1d 08 68 02  LD64             s8 = *(uint64_t *)(s29 +0x268)
03b3  +0x058c8  op=02  01 13 0d 00  XOR64            s13 = s19 ^ s1
03b4  +0x058e0  op=58  08 16 00 00  LD64             s22 = *(uint64_t *)(s8 +0x0)
03b5  +0x058f8  op=58  1d 08 00 02  LD64             s8 = *(uint64_t *)(s29 +0x200)
03b6  +0x05910  op=58  08 17 00 00  LD64             s23 = *(uint64_t *)(s8 +0x0)
03b7  +0x05928  op=58  1d 08 78 01  LD64             s8 = *(uint64_t *)(s29 +0x178)
03b8  +0x05940  op=58  08 1e 00 00  LD64             s30 = *(uint64_t *)(s8 +0x0)
03b9  +0x05958  op=02  02 1e 02 01  XOR64            s2 = s30 ^ s2
03ba  +0x05970  op=02  02 17 02 01  XOR64            s2 = s23 ^ s2
03bb  +0x05988  op=02  02 16 02 01  XOR64            s2 = s22 ^ s2
03bc  +0x059a0  op=02  02 15 02 00  XOR64            s2 = s21 ^ s2
03bd  +0x059b8  op=02  02 14 18 01  XOR64            s24 = s20 ^ s2
03be  +0x059d0  op=5f  af fc ff ff  ADD_PC_IMM32     goto record +110 ; vm_pc = current_pc + 1 + -849
03bf  +0x059e8  op=58  1d 01 48 00  LD64             s1 = *(uint64_t *)(s29 +0x48)
03c0  +0x05a00  op=58  1d 02 10 00  LD64             s2 = *(uint64_t *)(s29 +0x10)
03c1  +0x05a18  op=58  1d 03 08 00  LD64             s3 = *(uint64_t *)(s29 +0x8)
03c2  +0x05a30  op=58  1d 04 30 00  LD64             s4 = *(uint64_t *)(s29 +0x30)
03c3  +0x05a48  op=58  1d 05 40 00  LD64             s5 = *(uint64_t *)(s29 +0x40)
03c4  +0x05a60  op=58  1d 06 18 00  LD64             s6 = *(uint64_t *)(s29 +0x18)
03c5  +0x05a78  op=58  1d 07 38 00  LD64             s7 = *(uint64_t *)(s29 +0x38)
03c6  +0x05a90  op=58  1d 08 78 00  LD64             s8 = *(uint64_t *)(s29 +0x78)
03c7  +0x05aa8  op=58  1d 10 10 03  LD64             s16 = *(uint64_t *)(s29 +0x310)
03c8  +0x05ac0  op=58  1d 12 20 03  LD64             s18 = *(uint64_t *)(s29 +0x320)
03c9  +0x05ad8  op=58  1d 13 28 03  LD64             s19 = *(uint64_t *)(s29 +0x328)
03ca  +0x05af0  op=58  1d 14 30 03  LD64             s20 = *(uint64_t *)(s29 +0x330)
03cb  +0x05b08  op=58  1d 15 38 03  LD64             s21 = *(uint64_t *)(s29 +0x338)
03cc  +0x05b20  op=58  1d 16 40 03  LD64             s22 = *(uint64_t *)(s29 +0x340)
03cd  +0x05b38  op=58  1d 17 48 03  LD64             s23 = *(uint64_t *)(s29 +0x348)
03ce  +0x05b50  op=58  1d 1e 50 03  LD64             s30 = *(uint64_t *)(s29 +0x350)
03cf  +0x05b68  op=58  1d 1f 58 03  LD64             s31 = *(uint64_t *)(s29 +0x358)
03d0  +0x05b80  op=02  02 01 01 01  XOR64            s1 = s1 ^ s2
03d1  +0x05b98  op=58  1d 02 20 00  LD64             s2 = *(uint64_t *)(s29 +0x20)
03d2  +0x05bb0  op=02  07 0a 07 00  XOR64            s7 = s10 ^ s7
03d3  +0x05bc8  op=25  08 07 80 00  ST64             *(s8 +0x80) = s7
03d4  +0x05be0  op=02  03 02 02 00  XOR64            s2 = s2 ^ s3
03d5  +0x05bf8  op=58  1d 03 50 00  LD64             s3 = *(uint64_t *)(s29 +0x50)
03d6  +0x05c10  op=02  03 04 03 00  XOR64            s3 = s4 ^ s3
03d7  +0x05c28  op=58  1d 04 58 00  LD64             s4 = *(uint64_t *)(s29 +0x58)
03d8  +0x05c40  op=02  04 05 04 00  XOR64            s4 = s5 ^ s4
03d9  +0x05c58  op=58  1d 05 60 00  LD64             s5 = *(uint64_t *)(s29 +0x60)
03da  +0x05c70  op=02  04 11 04 01  XOR64            s4 = s17 ^ s4
03db  +0x05c88  op=58  1d 11 18 03  LD64             s17 = *(uint64_t *)(s29 +0x318)
03dc  +0x05ca0  op=02  05 06 05 01  XOR64            s5 = s6 ^ s5
03dd  +0x05cb8  op=58  1d 06 80 02  LD64             s6 = *(uint64_t *)(s29 +0x280)
03de  +0x05cd0  op=02  05 18 05 00  XOR64            s5 = s24 ^ s5
03df  +0x05ce8  op=02  03 06 03 01  XOR64            s3 = s6 ^ s3
03e0  +0x05d00  op=58  1d 06 90 02  LD64             s6 = *(uint64_t *)(s29 +0x290)
03e1  +0x05d18  op=02  02 06 02 01  XOR64            s2 = s6 ^ s2
03e2  +0x05d30  op=58  1d 06 88 02  LD64             s6 = *(uint64_t *)(s29 +0x288)
03e3  +0x05d48  op=02  01 06 01 00  XOR64            s1 = s6 ^ s1
03e4  +0x05d60  op=58  1d 06 28 00  LD64             s6 = *(uint64_t *)(s29 +0x28)
03e5  +0x05d78  op=02  06 0b 06 01  XOR64            s6 = s11 ^ s6
03e6  +0x05d90  op=25  08 06 78 00  ST64             *(s8 +0x78) = s6
03e7  +0x05da8  op=25  08 01 a0 00  ST64             *(s8 +0xa0) = s1
03e8  +0x05dc0  op=25  08 02 98 00  ST64             *(s8 +0x98) = s2
03e9  +0x05dd8  op=58  1d 01 70 00  LD64             s1 = *(uint64_t *)(s29 +0x70)
03ea  +0x05df0  op=58  1d 02 68 00  LD64             s2 = *(uint64_t *)(s29 +0x68)
03eb  +0x05e08  op=25  08 03 90 00  ST64             *(s8 +0x90) = s3
03ec  +0x05e20  op=25  08 04 88 00  ST64             *(s8 +0x88) = s4
03ed  +0x05e38  op=25  08 05 70 00  ST64             *(s8 +0x70) = s5
03ee  +0x05e50  op=02  01 02 01 00  XOR64            s1 = s2 ^ s1
03ef  +0x05e68  op=02  01 0d 01 01  XOR64            s1 = s13 ^ s1
03f0  +0x05e80  op=25  08 01 68 00  ST64             *(s8 +0x68) = s1
03f1  +0x05e98  op=85  1d 1d 60 03  ADD64_IMM16      s29 = s29 +0x360
03f2  +0x05eb0  op=5b  1f 00 00 00  RET              return/leave with s31

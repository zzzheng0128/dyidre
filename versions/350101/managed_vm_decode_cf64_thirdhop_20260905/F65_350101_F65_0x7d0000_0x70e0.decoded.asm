; MetaSec managed bytecode decode: F65
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F65_0x7d0000_0x70e0.bin
; records: 1204  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d d0 fc  ADD64_IMM16      s29 = s29 -0x330
0001  +0x00018  op=25  1d 1f 28 03  ST64             *(s29 +0x328) = s31
0002  +0x00030  op=25  1d 1e 20 03  ST64             *(s29 +0x320) = s30
0003  +0x00048  op=25  1d 17 18 03  ST64             *(s29 +0x318) = s23
0004  +0x00060  op=25  1d 16 10 03  ST64             *(s29 +0x310) = s22
0005  +0x00078  op=25  1d 15 08 03  ST64             *(s29 +0x308) = s21
0006  +0x00090  op=25  1d 14 00 03  ST64             *(s29 +0x300) = s20
0007  +0x000a8  op=25  1d 13 f8 02  ST64             *(s29 +0x2f8) = s19
0008  +0x000c0  op=25  1d 12 f0 02  ST64             *(s29 +0x2f0) = s18
0009  +0x000d8  op=25  1d 11 e8 02  ST64             *(s29 +0x2e8) = s17
000a  +0x000f0  op=25  1d 10 e0 02  ST64             *(s29 +0x2e0) = s16
000b  +0x00108  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
000c  +0x00120  op=59  05 01 3f 00  LD8U             s1 = *(uint8_t *)(s5 +0x3f)
000d  +0x00138  op=85  1e 11 a0 02  ADD64_IMM16      s17 = s30 +0x2a0
000e  +0x00150  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
000f  +0x00168  op=34  04 00 10 01  OR64             s16 = s4 | s0
0010  +0x00180  op=52  04 17 14 00  LD32S            s23 = *(int32_t *)(s4 +0x14)
0011  +0x00198  op=52  04 15 10 00  LD32S            s21 = *(int32_t *)(s4 +0x10)
0012  +0x001b0  op=52  04 13 0c 00  LD32S            s19 = *(int32_t *)(s4 +0xc)
0013  +0x001c8  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
0014  +0x001e0  op=08  1e 01 b4 01  ST32             *(s30 +0x1b4) = (uint32_t)s1
0015  +0x001f8  op=59  05 01 3e 00  LD8U             s1 = *(uint8_t *)(s5 +0x3e)
0016  +0x00210  op=08  1e 01 a8 01  ST32             *(s30 +0x1a8) = (uint32_t)s1
0017  +0x00228  op=59  05 01 3d 00  LD8U             s1 = *(uint8_t *)(s5 +0x3d)
0018  +0x00240  op=08  1e 01 14 01  ST32             *(s30 +0x114) = (uint32_t)s1
0019  +0x00258  op=59  05 01 3c 00  LD8U             s1 = *(uint8_t *)(s5 +0x3c)
001a  +0x00270  op=08  1e 01 54 01  ST32             *(s30 +0x154) = (uint32_t)s1
001b  +0x00288  op=59  05 01 3b 00  LD8U             s1 = *(uint8_t *)(s5 +0x3b)
001c  +0x002a0  op=08  1e 01 78 01  ST32             *(s30 +0x178) = (uint32_t)s1
001d  +0x002b8  op=59  05 01 3a 00  LD8U             s1 = *(uint8_t *)(s5 +0x3a)
001e  +0x002d0  op=08  1e 01 f0 00  ST32             *(s30 +0xf0) = (uint32_t)s1
001f  +0x002e8  op=59  05 01 39 00  LD8U             s1 = *(uint8_t *)(s5 +0x39)
0020  +0x00300  op=08  1e 01 d0 00  ST32             *(s30 +0xd0) = (uint32_t)s1
0021  +0x00318  op=59  05 01 38 00  LD8U             s1 = *(uint8_t *)(s5 +0x38)
0022  +0x00330  op=08  1e 01 f8 00  ST32             *(s30 +0xf8) = (uint32_t)s1
0023  +0x00348  op=59  05 01 37 00  LD8U             s1 = *(uint8_t *)(s5 +0x37)
0024  +0x00360  op=08  1e 01 80 01  ST32             *(s30 +0x180) = (uint32_t)s1
0025  +0x00378  op=59  05 01 36 00  LD8U             s1 = *(uint8_t *)(s5 +0x36)
0026  +0x00390  op=08  1e 01 5c 01  ST32             *(s30 +0x15c) = (uint32_t)s1
0027  +0x003a8  op=59  05 01 35 00  LD8U             s1 = *(uint8_t *)(s5 +0x35)
0028  +0x003c0  op=08  1e 01 d4 00  ST32             *(s30 +0xd4) = (uint32_t)s1
0029  +0x003d8  op=59  05 01 34 00  LD8U             s1 = *(uint8_t *)(s5 +0x34)
002a  +0x003f0  op=08  1e 01 0c 01  ST32             *(s30 +0x10c) = (uint32_t)s1
002b  +0x00408  op=59  05 01 33 00  LD8U             s1 = *(uint8_t *)(s5 +0x33)
002c  +0x00420  op=08  1e 01 a0 01  ST32             *(s30 +0x1a0) = (uint32_t)s1
002d  +0x00438  op=59  05 01 32 00  LD8U             s1 = *(uint8_t *)(s5 +0x32)
002e  +0x00450  op=08  1e 01 40 01  ST32             *(s30 +0x140) = (uint32_t)s1
002f  +0x00468  op=59  05 01 31 00  LD8U             s1 = *(uint8_t *)(s5 +0x31)
0030  +0x00480  op=08  1e 01 e0 00  ST32             *(s30 +0xe0) = (uint32_t)s1
0031  +0x00498  op=59  05 01 30 00  LD8U             s1 = *(uint8_t *)(s5 +0x30)
0032  +0x004b0  op=08  1e 01 1c 01  ST32             *(s30 +0x11c) = (uint32_t)s1
0033  +0x004c8  op=59  05 01 2f 00  LD8U             s1 = *(uint8_t *)(s5 +0x2f)
0034  +0x004e0  op=08  1e 01 44 01  ST32             *(s30 +0x144) = (uint32_t)s1
0035  +0x004f8  op=59  05 01 2e 00  LD8U             s1 = *(uint8_t *)(s5 +0x2e)
0036  +0x00510  op=08  1e 01 e8 00  ST32             *(s30 +0xe8) = (uint32_t)s1
0037  +0x00528  op=59  05 01 2d 00  LD8U             s1 = *(uint8_t *)(s5 +0x2d)
0038  +0x00540  op=08  1e 01 a4 00  ST32             *(s30 +0xa4) = (uint32_t)s1
0039  +0x00558  op=59  05 01 2c 00  LD8U             s1 = *(uint8_t *)(s5 +0x2c)
003a  +0x00570  op=08  1e 01 b8 00  ST32             *(s30 +0xb8) = (uint32_t)s1
003b  +0x00588  op=59  05 01 2b 00  LD8U             s1 = *(uint8_t *)(s5 +0x2b)
003c  +0x005a0  op=08  1e 01 cc 00  ST32             *(s30 +0xcc) = (uint32_t)s1
003d  +0x005b8  op=59  05 01 2a 00  LD8U             s1 = *(uint8_t *)(s5 +0x2a)
003e  +0x005d0  op=08  1e 01 98 00  ST32             *(s30 +0x98) = (uint32_t)s1
003f  +0x005e8  op=59  05 01 29 00  LD8U             s1 = *(uint8_t *)(s5 +0x29)
0040  +0x00600  op=08  1e 01 8c 00  ST32             *(s30 +0x8c) = (uint32_t)s1
0041  +0x00618  op=59  05 01 28 00  LD8U             s1 = *(uint8_t *)(s5 +0x28)
0042  +0x00630  op=08  1e 01 90 00  ST32             *(s30 +0x90) = (uint32_t)s1
0043  +0x00648  op=59  05 01 27 00  LD8U             s1 = *(uint8_t *)(s5 +0x27)
0044  +0x00660  op=08  1e 01 7c 01  ST32             *(s30 +0x17c) = (uint32_t)s1
0045  +0x00678  op=59  05 01 26 00  LD8U             s1 = *(uint8_t *)(s5 +0x26)
0046  +0x00690  op=08  1e 01 28 01  ST32             *(s30 +0x128) = (uint32_t)s1
0047  +0x006a8  op=59  05 01 25 00  LD8U             s1 = *(uint8_t *)(s5 +0x25)
0048  +0x006c0  op=08  1e 01 b4 00  ST32             *(s30 +0xb4) = (uint32_t)s1
0049  +0x006d8  op=59  05 01 24 00  LD8U             s1 = *(uint8_t *)(s5 +0x24)
004a  +0x006f0  op=08  1e 01 ec 00  ST32             *(s30 +0xec) = (uint32_t)s1
004b  +0x00708  op=59  05 01 23 00  LD8U             s1 = *(uint8_t *)(s5 +0x23)
004c  +0x00720  op=08  1e 01 60 01  ST32             *(s30 +0x160) = (uint32_t)s1
004d  +0x00738  op=59  05 01 22 00  LD8U             s1 = *(uint8_t *)(s5 +0x22)
004e  +0x00750  op=08  1e 01 48 01  ST32             *(s30 +0x148) = (uint32_t)s1
004f  +0x00768  op=59  05 01 21 00  LD8U             s1 = *(uint8_t *)(s5 +0x21)
0050  +0x00780  op=08  1e 01 c4 00  ST32             *(s30 +0xc4) = (uint32_t)s1
0051  +0x00798  op=59  05 01 20 00  LD8U             s1 = *(uint8_t *)(s5 +0x20)
0052  +0x007b0  op=08  1e 01 f4 00  ST32             *(s30 +0xf4) = (uint32_t)s1
0053  +0x007c8  op=59  05 01 1f 00  LD8U             s1 = *(uint8_t *)(s5 +0x1f)
0054  +0x007e0  op=08  1e 01 fc 00  ST32             *(s30 +0xfc) = (uint32_t)s1
0055  +0x007f8  op=59  05 01 1e 00  LD8U             s1 = *(uint8_t *)(s5 +0x1e)
0056  +0x00810  op=08  1e 01 b0 00  ST32             *(s30 +0xb0) = (uint32_t)s1
0057  +0x00828  op=59  05 01 1d 00  LD8U             s1 = *(uint8_t *)(s5 +0x1d)
0058  +0x00840  op=08  1e 01 74 00  ST32             *(s30 +0x74) = (uint32_t)s1
0059  +0x00858  op=59  05 01 1c 00  LD8U             s1 = *(uint8_t *)(s5 +0x1c)
005a  +0x00870  op=08  1e 01 84 00  ST32             *(s30 +0x84) = (uint32_t)s1
005b  +0x00888  op=59  05 01 1b 00  LD8U             s1 = *(uint8_t *)(s5 +0x1b)
005c  +0x008a0  op=08  1e 01 8c 01  ST32             *(s30 +0x18c) = (uint32_t)s1
005d  +0x008b8  op=59  05 01 1a 00  LD8U             s1 = *(uint8_t *)(s5 +0x1a)
005e  +0x008d0  op=08  1e 01 38 01  ST32             *(s30 +0x138) = (uint32_t)s1
005f  +0x008e8  op=59  05 01 19 00  LD8U             s1 = *(uint8_t *)(s5 +0x19)
0060  +0x00900  op=08  1e 01 a8 00  ST32             *(s30 +0xa8) = (uint32_t)s1
0061  +0x00918  op=59  05 01 18 00  LD8U             s1 = *(uint8_t *)(s5 +0x18)
0062  +0x00930  op=08  1e 01 e4 00  ST32             *(s30 +0xe4) = (uint32_t)s1
0063  +0x00948  op=59  05 01 17 00  LD8U             s1 = *(uint8_t *)(s5 +0x17)
0064  +0x00960  op=08  1e 01 3c 01  ST32             *(s30 +0x13c) = (uint32_t)s1
0065  +0x00978  op=59  05 01 16 00  LD8U             s1 = *(uint8_t *)(s5 +0x16)
0066  +0x00990  op=08  1e 01 10 01  ST32             *(s30 +0x110) = (uint32_t)s1
0067  +0x009a8  op=59  05 01 15 00  LD8U             s1 = *(uint8_t *)(s5 +0x15)
0068  +0x009c0  op=08  1e 01 70 00  ST32             *(s30 +0x70) = (uint32_t)s1
0069  +0x009d8  op=59  05 01 14 00  LD8U             s1 = *(uint8_t *)(s5 +0x14)
006a  +0x009f0  op=08  1e 01 9c 00  ST32             *(s30 +0x9c) = (uint32_t)s1
006b  +0x00a08  op=59  05 01 13 00  LD8U             s1 = *(uint8_t *)(s5 +0x13)
006c  +0x00a20  op=08  1e 01 6c 01  ST32             *(s30 +0x16c) = (uint32_t)s1
006d  +0x00a38  op=59  05 01 12 00  LD8U             s1 = *(uint8_t *)(s5 +0x12)
006e  +0x00a50  op=08  1e 01 34 01  ST32             *(s30 +0x134) = (uint32_t)s1
006f  +0x00a68  op=59  05 01 11 00  LD8U             s1 = *(uint8_t *)(s5 +0x11)
0070  +0x00a80  op=08  1e 01 d8 00  ST32             *(s30 +0xd8) = (uint32_t)s1
0071  +0x00a98  op=59  05 01 10 00  LD8U             s1 = *(uint8_t *)(s5 +0x10)
0072  +0x00ab0  op=08  1e 01 00 01  ST32             *(s30 +0x100) = (uint32_t)s1
0073  +0x00ac8  op=59  05 01 0f 00  LD8U             s1 = *(uint8_t *)(s5 +0xf)
0074  +0x00ae0  op=08  1e 01 70 01  ST32             *(s30 +0x170) = (uint32_t)s1
0075  +0x00af8  op=59  05 01 0e 00  LD8U             s1 = *(uint8_t *)(s5 +0xe)
0076  +0x00b10  op=08  1e 01 dc 00  ST32             *(s30 +0xdc) = (uint32_t)s1
0077  +0x00b28  op=59  05 01 0d 00  LD8U             s1 = *(uint8_t *)(s5 +0xd)
0078  +0x00b40  op=08  1e 01 68 00  ST32             *(s30 +0x68) = (uint32_t)s1
0079  +0x00b58  op=59  05 01 0c 00  LD8U             s1 = *(uint8_t *)(s5 +0xc)
007a  +0x00b70  op=08  1e 01 ac 00  ST32             *(s30 +0xac) = (uint32_t)s1
007b  +0x00b88  op=59  05 01 0b 00  LD8U             s1 = *(uint8_t *)(s5 +0xb)
007c  +0x00ba0  op=08  1e 01 2c 01  ST32             *(s30 +0x12c) = (uint32_t)s1
007d  +0x00bb8  op=59  05 01 0a 00  LD8U             s1 = *(uint8_t *)(s5 +0xa)
007e  +0x00bd0  op=08  1e 01 88 00  ST32             *(s30 +0x88) = (uint32_t)s1
007f  +0x00be8  op=59  05 01 09 00  LD8U             s1 = *(uint8_t *)(s5 +0x9)
0080  +0x00c00  op=08  1e 01 5c 00  ST32             *(s30 +0x5c) = (uint32_t)s1
0081  +0x00c18  op=59  05 01 08 00  LD8U             s1 = *(uint8_t *)(s5 +0x8)
0082  +0x00c30  op=08  1e 01 60 00  ST32             *(s30 +0x60) = (uint32_t)s1
0083  +0x00c48  op=59  05 01 07 00  LD8U             s1 = *(uint8_t *)(s5 +0x7)
0084  +0x00c60  op=08  1e 01 58 01  ST32             *(s30 +0x158) = (uint32_t)s1
0085  +0x00c78  op=59  05 01 06 00  LD8U             s1 = *(uint8_t *)(s5 +0x6)
0086  +0x00c90  op=08  1e 01 04 01  ST32             *(s30 +0x104) = (uint32_t)s1
0087  +0x00ca8  op=59  05 01 05 00  LD8U             s1 = *(uint8_t *)(s5 +0x5)
0088  +0x00cc0  op=08  1e 01 78 00  ST32             *(s30 +0x78) = (uint32_t)s1
0089  +0x00cd8  op=59  05 01 04 00  LD8U             s1 = *(uint8_t *)(s5 +0x4)
008a  +0x00cf0  op=08  1e 01 bc 00  ST32             *(s30 +0xbc) = (uint32_t)s1
008b  +0x00d08  op=59  05 01 03 00  LD8U             s1 = *(uint8_t *)(s5 +0x3)
008c  +0x00d20  op=08  1e 01 20 01  ST32             *(s30 +0x120) = (uint32_t)s1
008d  +0x00d38  op=59  05 01 02 00  LD8U             s1 = *(uint8_t *)(s5 +0x2)
008e  +0x00d50  op=08  1e 01 c0 00  ST32             *(s30 +0xc0) = (uint32_t)s1
008f  +0x00d68  op=59  05 01 01 00  LD8U             s1 = *(uint8_t *)(s5 +0x1)
0090  +0x00d80  op=08  1e 01 50 00  ST32             *(s30 +0x50) = (uint32_t)s1
0091  +0x00d98  op=59  05 01 00 00  LD8U             s1 = *(uint8_t *)(s5 +0x0)
0092  +0x00db0  op=34  12 00 05 00  OR64             s5 = s18 | s0
0093  +0x00dc8  op=08  1e 01 6c 00  ST32             *(s30 +0x6c) = (uint32_t)s1
0094  +0x00de0  op=52  04 01 08 00  LD32S            s1 = *(int32_t *)(s4 +0x8)
0095  +0x00df8  op=34  11 00 04 01  OR64             s4 = s17 | s0
0096  +0x00e10  op=08  1e 01 dc 01  ST32             *(s30 +0x1dc) = (uint32_t)s1
0097  +0x00e28  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0098  +0x00e40  op=52  10 14 58 00  LD32S            s20 = *(int32_t *)(s16 +0x58)
0099  +0x00e58  op=25  1e 10 d0 01  ST64             *(s30 +0x1d0) = s16
009a  +0x00e70  op=b5  00 10 20 00  ADD32_IMM16      s16 = int32(s0 +0x20)
009b  +0x00e88  op=85  00 16 10 00  ADD64_IMM16      s22 = s0 +0x10
009c  +0x00ea0  op=53  01 05 90 08  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x890 ; q1=0x125fd3a8 rt/so-mapped
009d  +0x00eb8  op=b5  00 06 00 00  ADD32_IMM16      s6 = int32(s0 +0x0)
009e  +0x00ed0  op=b5  14 01 10 00  ADD32_IMM16      s1 = int32(s20 +0x10)
009f  +0x00ee8  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
00a0  +0x00f00  op=b5  00 01 e0 ff  ADD32_IMM16      s1 = int32(s0 -0x20)
00a1  +0x00f18  op=34  02 01 03 00  OR64             s3 = s2 | s1
00a2  +0x00f30  op=09  10 02 04 00  SUB32            s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2)
00a3  +0x00f48  op=ae  12 16 1b 00  BR_EQ64          if (s18 == s22) goto record +191
00a4  +0x00f60  op=6e  12 12 07 02  SHL64_IMM        s7 = s18 << 2
00a5  +0x00f78  op=34  03 00 0a 01  OR64             s10 = s3 | s0
00a6  +0x00f90  op=34  06 00 09 01  OR64             s9 = s6 | s0
00a7  +0x00fa8  op=84  05 07 01 14  ADD64            s1 = s5 + s7
00a8  +0x00fc0  op=52  01 08 00 00  LD32S            s8 = *(int32_t *)(s1 +0x0)
00a9  +0x00fd8  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +174
00aa  +0x00ff0  op=18  11 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
00ab  +0x01008  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
00ac  +0x01020  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
00ad  +0x01038  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +170
00ae  +0x01050  op=34  03 00 0b 01  OR64             s11 = s3 | s0
00af  +0x01068  op=34  06 00 0a 00  OR64             s10 = s6 | s0
00b0  +0x01080  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +181
00b1  +0x01098  op=18  11 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
00b2  +0x010b0  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
00b3  +0x010c8  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
00b4  +0x010e0  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +177
00b5  +0x010f8  op=0d  02 08 01 00  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31))
00b6  +0x01110  op=17  04 08 08 17  SHL32_VAR        s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31))
00b7  +0x01128  op=84  11 07 07 14  ADD64            s7 = s17 + s7
00b8  +0x01140  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1
00b9  +0x01158  op=b3  09 01 01 01  AND64            s1 = s9 & s1
00ba  +0x01170  op=36  0a 00 09 01  NOR64            s9 = ~(s10 | s0)
00bb  +0x01188  op=b3  08 09 08 00  AND64            s8 = s8 & s9
00bc  +0x011a0  op=34  08 01 01 01  OR64             s1 = s8 | s1
00bd  +0x011b8  op=08  07 01 00 00  ST32             *(s7 +0x0) = (uint32_t)s1
00be  +0x011d0  op=a7  12 16 e5 ff  BR_NE64          if (s18 != s22) goto record +164
00bf  +0x011e8  op=52  1e 01 dc 02  LD32S            s1 = *(int32_t *)(s30 +0x2dc)
00c0  +0x01200  op=85  1e 11 60 02  ADD64_IMM16      s17 = s30 +0x260
00c1  +0x01218  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
00c2  +0x01230  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
00c3  +0x01248  op=34  11 00 04 00  OR64             s4 = s17 | s0
00c4  +0x01260  op=34  12 00 05 01  OR64             s5 = s18 | s0
00c5  +0x01278  op=08  1e 01 b8 01  ST32             *(s30 +0x1b8) = (uint32_t)s1
00c6  +0x01290  op=52  1e 01 d8 02  LD32S            s1 = *(int32_t *)(s30 +0x2d8)
00c7  +0x012a8  op=08  1e 01 ac 01  ST32             *(s30 +0x1ac) = (uint32_t)s1
00c8  +0x012c0  op=52  1e 01 d4 02  LD32S            s1 = *(int32_t *)(s30 +0x2d4)
00c9  +0x012d8  op=08  1e 01 7c 00  ST32             *(s30 +0x7c) = (uint32_t)s1
00ca  +0x012f0  op=52  1e 01 d0 02  LD32S            s1 = *(int32_t *)(s30 +0x2d0)
00cb  +0x01308  op=08  1e 01 c8 00  ST32             *(s30 +0xc8) = (uint32_t)s1
00cc  +0x01320  op=52  1e 01 cc 02  LD32S            s1 = *(int32_t *)(s30 +0x2cc)
00cd  +0x01338  op=08  1e 01 a0 00  ST32             *(s30 +0xa0) = (uint32_t)s1
00ce  +0x01350  op=52  1e 01 c8 02  LD32S            s1 = *(int32_t *)(s30 +0x2c8)
00cf  +0x01368  op=08  1e 01 74 01  ST32             *(s30 +0x174) = (uint32_t)s1
00d0  +0x01380  op=52  1e 01 c4 02  LD32S            s1 = *(int32_t *)(s30 +0x2c4)
00d1  +0x01398  op=08  1e 01 64 01  ST32             *(s30 +0x164) = (uint32_t)s1
00d2  +0x013b0  op=52  1e 01 c0 02  LD32S            s1 = *(int32_t *)(s30 +0x2c0)
00d3  +0x013c8  op=08  1e 01 50 01  ST32             *(s30 +0x150) = (uint32_t)s1
00d4  +0x013e0  op=52  1e 01 bc 02  LD32S            s1 = *(int32_t *)(s30 +0x2bc)
00d5  +0x013f8  op=08  1e 01 80 00  ST32             *(s30 +0x80) = (uint32_t)s1
00d6  +0x01410  op=52  1e 01 b8 02  LD32S            s1 = *(int32_t *)(s30 +0x2b8)
00d7  +0x01428  op=08  1e 01 64 00  ST32             *(s30 +0x64) = (uint32_t)s1
00d8  +0x01440  op=52  1e 01 b4 02  LD32S            s1 = *(int32_t *)(s30 +0x2b4)
00d9  +0x01458  op=08  1e 01 08 01  ST32             *(s30 +0x108) = (uint32_t)s1
00da  +0x01470  op=52  1e 01 b0 02  LD32S            s1 = *(int32_t *)(s30 +0x2b0)
00db  +0x01488  op=08  1e 01 94 00  ST32             *(s30 +0x94) = (uint32_t)s1
00dc  +0x014a0  op=52  1e 01 ac 02  LD32S            s1 = *(int32_t *)(s30 +0x2ac)
00dd  +0x014b8  op=08  1e 01 58 00  ST32             *(s30 +0x58) = (uint32_t)s1
00de  +0x014d0  op=52  1e 01 a8 02  LD32S            s1 = *(int32_t *)(s30 +0x2a8)
00df  +0x014e8  op=08  1e 01 48 00  ST32             *(s30 +0x48) = (uint32_t)s1
00e0  +0x01500  op=52  1e 01 a4 02  LD32S            s1 = *(int32_t *)(s30 +0x2a4)
00e1  +0x01518  op=08  1e 01 4c 00  ST32             *(s30 +0x4c) = (uint32_t)s1
00e2  +0x01530  op=52  1e 01 a0 02  LD32S            s1 = *(int32_t *)(s30 +0x2a0)
00e3  +0x01548  op=08  1e 01 40 00  ST32             *(s30 +0x40) = (uint32_t)s1
00e4  +0x01560  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
00e5  +0x01578  op=b5  14 01 11 00  ADD32_IMM16      s1 = int32(s20 +0x11)
00e6  +0x01590  op=53  01 05 d0 08  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x8d0 ; q1=0x125fd3a8 rt/so-mapped
00e7  +0x015a8  op=b5  00 06 00 00  ADD32_IMM16      s6 = int32(s0 +0x0)
00e8  +0x015c0  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
00e9  +0x015d8  op=b5  00 01 e0 ff  ADD32_IMM16      s1 = int32(s0 -0x20)
00ea  +0x015f0  op=34  02 01 03 01  OR64             s3 = s2 | s1
00eb  +0x01608  op=09  10 02 04 14  SUB32            s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2)
00ec  +0x01620  op=ae  12 16 1b 00  BR_EQ64          if (s18 == s22) goto record +264
00ed  +0x01638  op=6e  00 12 07 02  SHL64_IMM        s7 = s18 << 2
00ee  +0x01650  op=34  03 00 0a 00  OR64             s10 = s3 | s0
00ef  +0x01668  op=34  06 00 09 00  OR64             s9 = s6 | s0
00f0  +0x01680  op=84  05 07 01 04  ADD64            s1 = s5 + s7
00f1  +0x01698  op=52  01 08 00 00  LD32S            s8 = *(int32_t *)(s1 +0x0)
00f2  +0x016b0  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +247
00f3  +0x016c8  op=18  11 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
00f4  +0x016e0  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
00f5  +0x016f8  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
00f6  +0x01710  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +243
00f7  +0x01728  op=34  03 00 0b 00  OR64             s11 = s3 | s0
00f8  +0x01740  op=34  06 00 0a 00  OR64             s10 = s6 | s0
00f9  +0x01758  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +254
00fa  +0x01770  op=18  11 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
00fb  +0x01788  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
00fc  +0x017a0  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
00fd  +0x017b8  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +250
00fe  +0x017d0  op=0d  02 08 01 11  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31))
00ff  +0x017e8  op=17  04 08 08 07  SHL32_VAR        s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31))
0100  +0x01800  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1
0101  +0x01818  op=84  11 07 07 04  ADD64            s7 = s17 + s7
0102  +0x01830  op=b3  09 01 01 00  AND64            s1 = s9 & s1
0103  +0x01848  op=36  0a 00 09 01  NOR64            s9 = ~(s10 | s0)
0104  +0x01860  op=b3  08 09 08 01  AND64            s8 = s8 & s9
0105  +0x01878  op=34  08 01 01 00  OR64             s1 = s8 | s1
0106  +0x01890  op=08  07 01 00 00  ST32             *(s7 +0x0) = (uint32_t)s1
0107  +0x018a8  op=a7  12 16 e5 ff  BR_NE64          if (s18 != s22) goto record +237
0108  +0x018c0  op=52  1e 01 9c 02  LD32S            s1 = *(int32_t *)(s30 +0x29c)
0109  +0x018d8  op=85  1e 11 20 02  ADD64_IMM16      s17 = s30 +0x220
010a  +0x018f0  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
010b  +0x01908  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
010c  +0x01920  op=34  11 00 04 01  OR64             s4 = s17 | s0
010d  +0x01938  op=34  12 00 05 01  OR64             s5 = s18 | s0
010e  +0x01950  op=08  1e 01 24 00  ST32             *(s30 +0x24) = (uint32_t)s1
010f  +0x01968  op=52  1e 01 98 02  LD32S            s1 = *(int32_t *)(s30 +0x298)
0110  +0x01980  op=08  1e 01 34 00  ST32             *(s30 +0x34) = (uint32_t)s1
0111  +0x01998  op=52  1e 01 94 02  LD32S            s1 = *(int32_t *)(s30 +0x294)
0112  +0x019b0  op=08  1e 01 2c 00  ST32             *(s30 +0x2c) = (uint32_t)s1
0113  +0x019c8  op=52  1e 01 90 02  LD32S            s1 = *(int32_t *)(s30 +0x290)
0114  +0x019e0  op=08  1e 01 c4 01  ST32             *(s30 +0x1c4) = (uint32_t)s1
0115  +0x019f8  op=52  1e 01 8c 02  LD32S            s1 = *(int32_t *)(s30 +0x28c)
0116  +0x01a10  op=08  1e 01 bc 01  ST32             *(s30 +0x1bc) = (uint32_t)s1
0117  +0x01a28  op=52  1e 01 88 02  LD32S            s1 = *(int32_t *)(s30 +0x288)
0118  +0x01a40  op=08  1e 01 38 00  ST32             *(s30 +0x38) = (uint32_t)s1
0119  +0x01a58  op=52  1e 01 84 02  LD32S            s1 = *(int32_t *)(s30 +0x284)
011a  +0x01a70  op=08  1e 01 b0 01  ST32             *(s30 +0x1b0) = (uint32_t)s1
011b  +0x01a88  op=52  1e 01 80 02  LD32S            s1 = *(int32_t *)(s30 +0x280)
011c  +0x01aa0  op=08  1e 01 20 00  ST32             *(s30 +0x20) = (uint32_t)s1
011d  +0x01ab8  op=52  1e 01 7c 02  LD32S            s1 = *(int32_t *)(s30 +0x27c)
011e  +0x01ad0  op=08  1e 01 28 00  ST32             *(s30 +0x28) = (uint32_t)s1
011f  +0x01ae8  op=52  1e 01 78 02  LD32S            s1 = *(int32_t *)(s30 +0x278)
0120  +0x01b00  op=08  1e 01 88 01  ST32             *(s30 +0x188) = (uint32_t)s1
0121  +0x01b18  op=52  1e 01 74 02  LD32S            s1 = *(int32_t *)(s30 +0x274)
0122  +0x01b30  op=08  1e 01 30 00  ST32             *(s30 +0x30) = (uint32_t)s1
0123  +0x01b48  op=52  1e 01 70 02  LD32S            s1 = *(int32_t *)(s30 +0x270)
0124  +0x01b60  op=08  1e 01 68 01  ST32             *(s30 +0x168) = (uint32_t)s1
0125  +0x01b78  op=52  1e 01 6c 02  LD32S            s1 = *(int32_t *)(s30 +0x26c)
0126  +0x01b90  op=08  1e 01 4c 01  ST32             *(s30 +0x14c) = (uint32_t)s1
0127  +0x01ba8  op=52  1e 01 68 02  LD32S            s1 = *(int32_t *)(s30 +0x268)
0128  +0x01bc0  op=08  1e 01 18 01  ST32             *(s30 +0x118) = (uint32_t)s1
0129  +0x01bd8  op=52  1e 01 64 02  LD32S            s1 = *(int32_t *)(s30 +0x264)
012a  +0x01bf0  op=08  1e 01 24 01  ST32             *(s30 +0x124) = (uint32_t)s1
012b  +0x01c08  op=52  1e 01 60 02  LD32S            s1 = *(int32_t *)(s30 +0x260)
012c  +0x01c20  op=08  1e 01 30 01  ST32             *(s30 +0x130) = (uint32_t)s1
012d  +0x01c38  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
012e  +0x01c50  op=b5  14 01 12 00  ADD32_IMM16      s1 = int32(s20 +0x12)
012f  +0x01c68  op=53  03 05 10 09  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x910 ; q1=0x125fd3a8 rt/so-mapped
0130  +0x01c80  op=b5  00 06 00 00  ADD32_IMM16      s6 = int32(s0 +0x0)
0131  +0x01c98  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
0132  +0x01cb0  op=b5  00 01 e0 ff  ADD32_IMM16      s1 = int32(s0 -0x20)
0133  +0x01cc8  op=34  02 01 03 01  OR64             s3 = s2 | s1
0134  +0x01ce0  op=09  10 02 04 14  SUB32            s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2)
0135  +0x01cf8  op=ae  12 16 1b 00  BR_EQ64          if (s18 == s22) goto record +337
0136  +0x01d10  op=6e  02 12 07 02  SHL64_IMM        s7 = s18 << 2
0137  +0x01d28  op=34  03 00 0a 01  OR64             s10 = s3 | s0
0138  +0x01d40  op=34  06 00 09 01  OR64             s9 = s6 | s0
0139  +0x01d58  op=84  05 07 01 00  ADD64            s1 = s5 + s7
013a  +0x01d70  op=52  01 08 00 00  LD32S            s8 = *(int32_t *)(s1 +0x0)
013b  +0x01d88  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +320
013c  +0x01da0  op=18  10 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
013d  +0x01db8  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
013e  +0x01dd0  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
013f  +0x01de8  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +316
0140  +0x01e00  op=34  03 00 0b 01  OR64             s11 = s3 | s0
0141  +0x01e18  op=34  06 00 0a 01  OR64             s10 = s6 | s0
0142  +0x01e30  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +327
0143  +0x01e48  op=18  10 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
0144  +0x01e60  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
0145  +0x01e78  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
0146  +0x01e90  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +323
0147  +0x01ea8  op=0d  02 08 01 00  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31))
0148  +0x01ec0  op=17  04 08 08 00  SHL32_VAR        s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31))
0149  +0x01ed8  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1
014a  +0x01ef0  op=84  11 07 07 04  ADD64            s7 = s17 + s7
014b  +0x01f08  op=b3  09 01 01 01  AND64            s1 = s9 & s1
014c  +0x01f20  op=36  0a 00 09 00  NOR64            s9 = ~(s10 | s0)
014d  +0x01f38  op=b3  08 09 08 00  AND64            s8 = s8 & s9
014e  +0x01f50  op=34  08 01 01 01  OR64             s1 = s8 | s1
014f  +0x01f68  op=08  07 01 00 00  ST32             *(s7 +0x0) = (uint32_t)s1
0150  +0x01f80  op=a7  12 16 e5 ff  BR_NE64          if (s18 != s22) goto record +310
0151  +0x01f98  op=52  1e 01 5c 02  LD32S            s1 = *(int32_t *)(s30 +0x25c)
0152  +0x01fb0  op=85  1e 11 e0 01  ADD64_IMM16      s17 = s30 +0x1e0
0153  +0x01fc8  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
0154  +0x01fe0  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
0155  +0x01ff8  op=34  11 00 04 01  OR64             s4 = s17 | s0
0156  +0x02010  op=34  12 00 05 00  OR64             s5 = s18 | s0
0157  +0x02028  op=08  1e 01 1c 00  ST32             *(s30 +0x1c) = (uint32_t)s1
0158  +0x02040  op=52  1e 01 58 02  LD32S            s1 = *(int32_t *)(s30 +0x258)
0159  +0x02058  op=08  1e 01 cc 01  ST32             *(s30 +0x1cc) = (uint32_t)s1
015a  +0x02070  op=52  1e 01 54 02  LD32S            s1 = *(int32_t *)(s30 +0x254)
015b  +0x02088  op=08  1e 01 18 00  ST32             *(s30 +0x18) = (uint32_t)s1
015c  +0x020a0  op=52  1e 01 50 02  LD32S            s1 = *(int32_t *)(s30 +0x250)
015d  +0x020b8  op=08  1e 01 14 00  ST32             *(s30 +0x14) = (uint32_t)s1
015e  +0x020d0  op=52  1e 01 4c 02  LD32S            s1 = *(int32_t *)(s30 +0x24c)
015f  +0x020e8  op=08  1e 01 c8 01  ST32             *(s30 +0x1c8) = (uint32_t)s1
0160  +0x02100  op=52  1e 01 48 02  LD32S            s1 = *(int32_t *)(s30 +0x248)
0161  +0x02118  op=08  1e 01 0c 00  ST32             *(s30 +0xc) = (uint32_t)s1
0162  +0x02130  op=52  1e 01 44 02  LD32S            s1 = *(int32_t *)(s30 +0x244)
0163  +0x02148  op=08  1e 01 3c 00  ST32             *(s30 +0x3c) = (uint32_t)s1
0164  +0x02160  op=52  1e 01 40 02  LD32S            s1 = *(int32_t *)(s30 +0x240)
0165  +0x02178  op=08  1e 01 44 00  ST32             *(s30 +0x44) = (uint32_t)s1
0166  +0x02190  op=52  1e 01 3c 02  LD32S            s1 = *(int32_t *)(s30 +0x23c)
0167  +0x021a8  op=08  1e 01 08 00  ST32             *(s30 +0x8) = (uint32_t)s1
0168  +0x021c0  op=52  1e 01 38 02  LD32S            s1 = *(int32_t *)(s30 +0x238)
0169  +0x021d8  op=08  1e 01 10 00  ST32             *(s30 +0x10) = (uint32_t)s1
016a  +0x021f0  op=52  1e 01 34 02  LD32S            s1 = *(int32_t *)(s30 +0x234)
016b  +0x02208  op=08  1e 01 94 01  ST32             *(s30 +0x194) = (uint32_t)s1
016c  +0x02220  op=52  1e 01 30 02  LD32S            s1 = *(int32_t *)(s30 +0x230)
016d  +0x02238  op=08  1e 01 54 00  ST32             *(s30 +0x54) = (uint32_t)s1
016e  +0x02250  op=52  1e 01 2c 02  LD32S            s1 = *(int32_t *)(s30 +0x22c)
016f  +0x02268  op=08  1e 01 84 01  ST32             *(s30 +0x184) = (uint32_t)s1
0170  +0x02280  op=52  1e 01 28 02  LD32S            s1 = *(int32_t *)(s30 +0x228)
0171  +0x02298  op=08  1e 01 98 01  ST32             *(s30 +0x198) = (uint32_t)s1
0172  +0x022b0  op=52  1e 01 24 02  LD32S            s1 = *(int32_t *)(s30 +0x224)
0173  +0x022c8  op=08  1e 01 9c 01  ST32             *(s30 +0x19c) = (uint32_t)s1
0174  +0x022e0  op=52  1e 01 20 02  LD32S            s1 = *(int32_t *)(s30 +0x220)
0175  +0x022f8  op=08  1e 01 a4 01  ST32             *(s30 +0x1a4) = (uint32_t)s1
0176  +0x02310  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0177  +0x02328  op=b5  14 01 13 00  ADD32_IMM16      s1 = int32(s20 +0x13)
0178  +0x02340  op=53  04 05 50 09  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x950 ; q1=0x125fd3a8 rt/so-mapped
0179  +0x02358  op=b5  00 06 00 00  ADD32_IMM16      s6 = int32(s0 +0x0)
017a  +0x02370  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
017b  +0x02388  op=b5  00 01 e0 ff  ADD32_IMM16      s1 = int32(s0 -0x20)
017c  +0x023a0  op=34  02 01 03 01  OR64             s3 = s2 | s1
017d  +0x023b8  op=09  10 02 04 14  SUB32            s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2)
017e  +0x023d0  op=ae  12 16 1b 00  BR_EQ64          if (s18 == s22) goto record +410
017f  +0x023e8  op=6e  02 12 07 02  SHL64_IMM        s7 = s18 << 2
0180  +0x02400  op=34  03 00 0a 01  OR64             s10 = s3 | s0
0181  +0x02418  op=34  06 00 09 01  OR64             s9 = s6 | s0
0182  +0x02430  op=84  05 07 01 14  ADD64            s1 = s5 + s7
0183  +0x02448  op=52  01 08 00 00  LD32S            s8 = *(int32_t *)(s1 +0x0)
0184  +0x02460  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +393
0185  +0x02478  op=18  00 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
0186  +0x02490  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
0187  +0x024a8  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
0188  +0x024c0  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +389
0189  +0x024d8  op=34  03 00 0b 01  OR64             s11 = s3 | s0
018a  +0x024f0  op=34  06 00 0a 00  OR64             s10 = s6 | s0
018b  +0x02508  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +400
018c  +0x02520  op=18  10 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
018d  +0x02538  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
018e  +0x02550  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
018f  +0x02568  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +396
0190  +0x02580  op=0d  02 08 01 11  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31))
0191  +0x02598  op=17  04 08 08 00  SHL32_VAR        s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31))
0192  +0x025b0  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1
0193  +0x025c8  op=84  11 07 07 00  ADD64            s7 = s17 + s7
0194  +0x025e0  op=b3  09 01 01 00  AND64            s1 = s9 & s1
0195  +0x025f8  op=36  0a 00 09 01  NOR64            s9 = ~(s10 | s0)
0196  +0x02610  op=b3  08 09 08 01  AND64            s8 = s8 & s9
0197  +0x02628  op=34  08 01 01 01  OR64             s1 = s8 | s1
0198  +0x02640  op=08  07 01 00 00  ST32             *(s7 +0x0) = (uint32_t)s1
0199  +0x02658  op=a7  12 16 e5 ff  BR_NE64          if (s18 != s22) goto record +383
019a  +0x02670  op=52  1e 01 8c 00  LD32S            s1 = *(int32_t *)(s30 +0x8c)
019b  +0x02688  op=52  1e 04 98 00  LD32S            s4 = *(int32_t *)(s30 +0x98)
019c  +0x026a0  op=52  1e 08 d4 00  LD32S            s8 = *(int32_t *)(s30 +0xd4)
019d  +0x026b8  op=52  1e 02 90 00  LD32S            s2 = *(int32_t *)(s30 +0x90)
019e  +0x026d0  op=52  1e 05 5c 00  LD32S            s5 = *(int32_t *)(s30 +0x5c)
019f  +0x026e8  op=52  1e 0d cc 00  LD32S            s13 = *(int32_t *)(s30 +0xcc)
01a0  +0x02700  op=52  1e 11 0c 01  LD32S            s17 = *(int32_t *)(s30 +0x10c)
01a1  +0x02718  op=52  1e 07 70 00  LD32S            s7 = *(int32_t *)(s30 +0x70)
01a2  +0x02730  op=52  1e 0e 60 00  LD32S            s14 = *(int32_t *)(s30 +0x60)
01a3  +0x02748  op=52  1e 06 d0 00  LD32S            s6 = *(int32_t *)(s30 +0xd0)
01a4  +0x02760  op=52  1e 03 a4 00  LD32S            s3 = *(int32_t *)(s30 +0xa4)
01a5  +0x02778  op=52  1e 16 bc 00  LD32S            s22 = *(int32_t *)(s30 +0xbc)
01a6  +0x02790  op=52  1e 09 b8 00  LD32S            s9 = *(int32_t *)(s30 +0xb8)
01a7  +0x027a8  op=52  1e 0c b4 00  LD32S            s12 = *(int32_t *)(s30 +0xb4)
01a8  +0x027c0  op=52  1e 0f b0 00  LD32S            s15 = *(int32_t *)(s30 +0xb0)
01a9  +0x027d8  op=52  1e 18 14 01  LD32S            s24 = *(int32_t *)(s30 +0x114)
01aa  +0x027f0  op=52  1e 12 88 00  LD32S            s18 = *(int32_t *)(s30 +0x88)
01ab  +0x02808  op=52  1e 0b e0 00  LD32S            s11 = *(int32_t *)(s30 +0xe0)
01ac  +0x02820  op=52  1e 0a 68 00  LD32S            s10 = *(int32_t *)(s30 +0x68)
01ad  +0x02838  op=52  1e 19 a8 00  LD32S            s25 = *(int32_t *)(s30 +0xa8)
01ae  +0x02850  op=52  1e 10 c4 00  LD32S            s16 = *(int32_t *)(s30 +0xc4)
01af  +0x02868  op=08  1e 13 d8 01  ST32             *(s30 +0x1d8) = (uint32_t)s19
01b0  +0x02880  op=18  00 01 01 08  SHL32_IMM        s1 = (int32_t)(s1 << 8)
01b1  +0x02898  op=18  10 08 08 08  SHL32_IMM        s8 = (int32_t)(s8 << 8)
01b2  +0x028b0  op=18  00 04 04 10  SHL32_IMM        s4 = (int32_t)(s4 << 16)
01b3  +0x028c8  op=18  10 05 05 08  SHL32_IMM        s5 = (int32_t)(s5 << 8)
01b4  +0x028e0  op=18  11 0d 0d 18  SHL32_IMM        s13 = (int32_t)(s13 << 24)
01b5  +0x028f8  op=18  00 07 07 08  SHL32_IMM        s7 = (int32_t)(s7 << 8)
01b6  +0x02910  op=18  00 06 06 08  SHL32_IMM        s6 = (int32_t)(s6 << 8)
01b7  +0x02928  op=18  11 03 03 08  SHL32_IMM        s3 = (int32_t)(s3 << 8)
01b8  +0x02940  op=18  10 0c 0c 08  SHL32_IMM        s12 = (int32_t)(s12 << 8)
01b9  +0x02958  op=18  00 0f 0f 10  SHL32_IMM        s15 = (int32_t)(s15 << 16)
01ba  +0x02970  op=18  10 18 18 08  SHL32_IMM        s24 = (int32_t)(s24 << 8)
01bb  +0x02988  op=18  10 12 12 10  SHL32_IMM        s18 = (int32_t)(s18 << 16)
01bc  +0x029a0  op=18  11 0b 0b 08  SHL32_IMM        s11 = (int32_t)(s11 << 8)
01bd  +0x029b8  op=18  11 0a 0a 08  SHL32_IMM        s10 = (int32_t)(s10 << 8)
01be  +0x029d0  op=18  00 19 19 08  SHL32_IMM        s25 = (int32_t)(s25 << 8)
01bf  +0x029e8  op=18  10 10 10 08  SHL32_IMM        s16 = (int32_t)(s16 << 8)
01c0  +0x02a00  op=34  01 02 01 00  OR64             s1 = s1 | s2
01c1  +0x02a18  op=34  08 11 08 01  OR64             s8 = s8 | s17
01c2  +0x02a30  op=52  1e 11 9c 00  LD32S            s17 = *(int32_t *)(s30 +0x9c)
01c3  +0x02a48  op=34  05 0e 05 00  OR64             s5 = s5 | s14
01c4  +0x02a60  op=52  1e 0e f8 00  LD32S            s14 = *(int32_t *)(s30 +0xf8)
01c5  +0x02a78  op=52  1e 02 74 00  LD32S            s2 = *(int32_t *)(s30 +0x74)
01c6  +0x02a90  op=34  03 09 03 01  OR64             s3 = s3 | s9
01c7  +0x02aa8  op=52  1e 09 84 00  LD32S            s9 = *(int32_t *)(s30 +0x84)
01c8  +0x02ac0  op=34  01 04 01 01  OR64             s1 = s1 | s4
01c9  +0x02ad8  op=52  1e 04 50 00  LD32S            s4 = *(int32_t *)(s30 +0x50)
01ca  +0x02af0  op=34  05 12 05 01  OR64             s5 = s5 | s18
01cb  +0x02b08  op=52  1e 12 44 01  LD32S            s18 = *(int32_t *)(s30 +0x144)
01cc  +0x02b20  op=34  01 0d 1f 01  OR64             s31 = s1 | s13
01cd  +0x02b38  op=52  1e 01 78 00  LD32S            s1 = *(int32_t *)(s30 +0x78)
01ce  +0x02b50  op=34  07 11 07 01  OR64             s7 = s7 | s17
01cf  +0x02b68  op=52  1e 11 6c 00  LD32S            s17 = *(int32_t *)(s30 +0x6c)
01d0  +0x02b80  op=34  06 0e 06 00  OR64             s6 = s6 | s14
01d1  +0x02b98  op=52  1e 0e e8 00  LD32S            s14 = *(int32_t *)(s30 +0xe8)
01d2  +0x02bb0  op=52  1e 0d ec 00  LD32S            s13 = *(int32_t *)(s30 +0xec)
01d3  +0x02bc8  op=18  10 02 02 08  SHL32_IMM        s2 = (int32_t)(s2 << 8)
01d4  +0x02be0  op=18  10 04 04 08  SHL32_IMM        s4 = (int32_t)(s4 << 8)
01d5  +0x02bf8  op=34  02 09 14 01  OR64             s20 = s2 | s9
01d6  +0x02c10  op=52  1e 09 f0 00  LD32S            s9 = *(int32_t *)(s30 +0xf0)
01d7  +0x02c28  op=18  00 12 12 18  SHL32_IMM        s18 = (int32_t)(s18 << 24)
01d8  +0x02c40  op=34  17 00 02 01  OR64             s2 = s23 | s0
01d9  +0x02c58  op=08  1e 1f 14 01  ST32             *(s30 +0x114) = (uint32_t)s31
01da  +0x02c70  op=18  11 01 01 08  SHL32_IMM        s1 = (int32_t)(s1 << 8)
01db  +0x02c88  op=34  04 11 04 01  OR64             s4 = s4 | s17
01dc  +0x02ca0  op=02  17 15 11 01  XOR64            s17 = s21 ^ s23
01dd  +0x02cb8  op=18  11 0e 0e 10  SHL32_IMM        s14 = (int32_t)(s14 << 16)
01de  +0x02cd0  op=34  0c 0d 0c 00  OR64             s12 = s12 | s13
01df  +0x02ce8  op=52  1e 0d 1c 01  LD32S            s13 = *(int32_t *)(s30 +0x11c)
01e0  +0x02d00  op=08  1e 02 c0 01  ST32             *(s30 +0x1c0) = (uint32_t)s2
01e1  +0x02d18  op=34  01 16 01 01  OR64             s1 = s1 | s22
01e2  +0x02d30  op=52  1e 16 dc 01  LD32S            s22 = *(int32_t *)(s30 +0x1dc)
01e3  +0x02d48  op=b3  11 13 11 01  AND64            s17 = s17 & s19
01e4  +0x02d60  op=34  03 0e 03 00  OR64             s3 = s3 | s14
01e5  +0x02d78  op=08  1e 0c 0c 01  ST32             *(s30 +0x10c) = (uint32_t)s12
01e6  +0x02d90  op=34  14 0f 0c 00  OR64             s12 = s20 | s15
01e7  +0x02da8  op=52  1e 0f 54 01  LD32S            s15 = *(int32_t *)(s30 +0x154)
01e8  +0x02dc0  op=52  1e 13 dc 00  LD32S            s19 = *(int32_t *)(s30 +0xdc)
01e9  +0x02dd8  op=18  00 09 09 10  SHL32_IMM        s9 = (int32_t)(s9 << 16)
01ea  +0x02df0  op=34  15 00 14 01  OR64             s20 = s21 | s0
01eb  +0x02e08  op=52  1e 15 5c 01  LD32S            s21 = *(int32_t *)(s30 +0x15c)
01ec  +0x02e20  op=02  11 17 0e 01  XOR64            s14 = s23 ^ s17
01ed  +0x02e38  op=34  0b 0d 0b 01  OR64             s11 = s11 | s13
01ee  +0x02e50  op=52  1e 0d ac 00  LD32S            s13 = *(int32_t *)(s30 +0xac)
01ef  +0x02e68  op=52  1e 11 28 01  LD32S            s17 = *(int32_t *)(s30 +0x128)
01f0  +0x02e80  op=34  06 09 06 01  OR64             s6 = s6 | s9
01f1  +0x02e98  op=52  1e 09 f4 00  LD32S            s9 = *(int32_t *)(s30 +0xf4)
01f2  +0x02eb0  op=b4  16 1f 16 02  ADD32            s22 = int32(s22 + s31)
01f3  +0x02ec8  op=34  18 0f 0f 01  OR64             s15 = s24 | s15
01f4  +0x02ee0  op=52  1e 18 fc 00  LD32S            s24 = *(int32_t *)(s30 +0xfc)
01f5  +0x02ef8  op=18  00 13 13 10  SHL32_IMM        s19 = (int32_t)(s19 << 16)
01f6  +0x02f10  op=18  10 15 15 10  SHL32_IMM        s21 = (int32_t)(s21 << 16)
01f7  +0x02f28  op=b4  16 0e 0e 00  ADD32            s14 = int32(s22 + s14)
01f8  +0x02f40  op=52  1e 16 c0 00  LD32S            s22 = *(int32_t *)(s30 +0xc0)
01f9  +0x02f58  op=34  0a 0d 0a 01  OR64             s10 = s10 | s13
01fa  +0x02f70  op=52  1e 0d e4 00  LD32S            s13 = *(int32_t *)(s30 +0xe4)
01fb  +0x02f88  op=34  10 09 09 00  OR64             s9 = s16 | s9
01fc  +0x02fa0  op=18  11 11 11 10  SHL32_IMM        s17 = (int32_t)(s17 << 16)
01fd  +0x02fb8  op=52  1e 10 d8 00  LD32S            s16 = *(int32_t *)(s30 +0xd8)
01fe  +0x02fd0  op=34  08 15 08 00  OR64             s8 = s8 | s21
01ff  +0x02fe8  op=52  1e 15 00 01  LD32S            s21 = *(int32_t *)(s30 +0x100)
0200  +0x03000  op=18  11 18 18 18  SHL32_IMM        s24 = (int32_t)(s24 << 24)
0201  +0x03018  op=34  0a 13 0a 01  OR64             s10 = s10 | s19
0202  +0x03030  op=52  1e 13 60 01  LD32S            s19 = *(int32_t *)(s30 +0x160)
0203  +0x03048  op=18  00 16 16 10  SHL32_IMM        s22 = (int32_t)(s22 << 16)
0204  +0x03060  op=34  19 0d 0d 01  OR64             s13 = s25 | s13
0205  +0x03078  op=52  1e 19 40 01  LD32S            s25 = *(int32_t *)(s30 +0x140)
0206  +0x03090  op=18  10 10 10 08  SHL32_IMM        s16 = (int32_t)(s16 << 8)
0207  +0x030a8  op=34  04 16 04 01  OR64             s4 = s4 | s22
0208  +0x030c0  op=52  1e 16 10 01  LD32S            s22 = *(int32_t *)(s30 +0x110)
0209  +0x030d8  op=18  10 13 13 18  SHL32_IMM        s19 = (int32_t)(s19 << 24)
020a  +0x030f0  op=34  10 15 10 00  OR64             s16 = s16 | s21
020b  +0x03108  op=52  1e 15 78 01  LD32S            s21 = *(int32_t *)(s30 +0x178)
020c  +0x03120  op=18  00 19 19 10  SHL32_IMM        s25 = (int32_t)(s25 << 16)
020d  +0x03138  op=18  10 16 16 10  SHL32_IMM        s22 = (int32_t)(s22 << 16)
020e  +0x03150  op=34  0b 19 0b 01  OR64             s11 = s11 | s25
020f  +0x03168  op=18  00 15 15 18  SHL32_IMM        s21 = (int32_t)(s21 << 24)
0210  +0x03180  op=34  07 16 17 01  OR64             s23 = s7 | s22
0211  +0x03198  op=34  03 12 07 01  OR64             s7 = s3 | s18
0212  +0x031b0  op=34  0c 18 03 01  OR64             s3 = s12 | s24
0213  +0x031c8  op=52  1e 18 04 01  LD32S            s24 = *(int32_t *)(s30 +0x104)
0214  +0x031e0  op=52  1e 16 48 01  LD32S            s22 = *(int32_t *)(s30 +0x148)
0215  +0x031f8  op=52  1e 0c 0c 01  LD32S            s12 = *(int32_t *)(s30 +0x10c)
0216  +0x03210  op=52  1e 12 80 01  LD32S            s18 = *(int32_t *)(s30 +0x180)
0217  +0x03228  op=08  1e 07 28 01  ST32             *(s30 +0x128) = (uint32_t)s7
0218  +0x03240  op=18  00 18 18 10  SHL32_IMM        s24 = (int32_t)(s24 << 16)
0219  +0x03258  op=18  11 16 16 10  SHL32_IMM        s22 = (int32_t)(s22 << 16)
021a  +0x03270  op=34  0c 11 19 01  OR64             s25 = s12 | s17
021b  +0x03288  op=52  1e 0c 38 01  LD32S            s12 = *(int32_t *)(s30 +0x138)
021c  +0x032a0  op=18  10 12 12 18  SHL32_IMM        s18 = (int32_t)(s18 << 24)
021d  +0x032b8  op=34  06 15 11 01  OR64             s17 = s6 | s21
021e  +0x032d0  op=52  1e 15 34 01  LD32S            s21 = *(int32_t *)(s30 +0x134)
021f  +0x032e8  op=52  1e 06 3c 01  LD32S            s6 = *(int32_t *)(s30 +0x13c)
0220  +0x03300  op=34  01 18 18 01  OR64             s24 = s1 | s24
0221  +0x03318  op=52  1e 01 a8 01  LD32S            s1 = *(int32_t *)(s30 +0x1a8)
0222  +0x03330  op=34  09 16 09 01  OR64             s9 = s9 | s22
0223  +0x03348  op=52  1e 16 2c 01  LD32S            s22 = *(int32_t *)(s30 +0x12c)
0224  +0x03360  op=34  08 12 12 01  OR64             s18 = s8 | s18
0225  +0x03378  op=18  00 0c 0c 10  SHL32_IMM        s12 = (int32_t)(s12 << 16)
0226  +0x03390  op=34  09 13 13 01  OR64             s19 = s9 | s19
0227  +0x033a8  op=34  02 00 09 01  OR64             s9 = s2 | s0
0228  +0x033c0  op=52  1e 02 40 00  LD32S            s2 = *(int32_t *)(s30 +0x40)
0229  +0x033d8  op=18  11 15 15 10  SHL32_IMM        s21 = (int32_t)(s21 << 16)
022a  +0x033f0  op=18  11 06 06 18  SHL32_IMM        s6 = (int32_t)(s6 << 24)
022b  +0x03408  op=18  10 01 01 10  SHL32_IMM        s1 = (int32_t)(s1 << 16)
022c  +0x03420  op=18  10 16 16 18  SHL32_IMM        s22 = (int32_t)(s22 << 24)
022d  +0x03438  op=34  0d 0c 0c 01  OR64             s12 = s13 | s12
022e  +0x03450  op=34  10 15 1f 01  OR64             s31 = s16 | s21
022f  +0x03468  op=34  17 06 17 01  OR64             s23 = s23 | s6
0230  +0x03480  op=34  14 00 06 01  OR64             s6 = s20 | s0
0231  +0x03498  op=34  0f 01 0f 01  OR64             s15 = s15 | s1
0232  +0x034b0  op=52  1e 01 20 01  LD32S            s1 = *(int32_t *)(s30 +0x120)
0233  +0x034c8  op=34  05 16 0d 01  OR64             s13 = s5 | s22
0234  +0x034e0  op=b4  0e 02 08 00  ADD32            s8 = int32(s14 + s2)
0235  +0x034f8  op=52  1e 16 a0 01  LD32S            s22 = *(int32_t *)(s30 +0x1a0)
0236  +0x03510  op=08  1e 06 90 01  ST32             *(s30 +0x190) = (uint32_t)s6
0237  +0x03528  op=18  10 01 05 18  SHL32_IMM        s5 = (int32_t)(s1 << 24)
0238  +0x03540  op=52  1e 01 7c 01  LD32S            s1 = *(int32_t *)(s30 +0x17c)
0239  +0x03558  op=18  00 16 16 18  SHL32_IMM        s22 = (int32_t)(s22 << 24)
023a  +0x03570  op=34  04 05 02 01  OR64             s2 = s4 | s5
023b  +0x03588  op=52  1e 05 48 00  LD32S            s5 = *(int32_t *)(s30 +0x48)
023c  +0x035a0  op=b4  14 03 04 00  ADD32            s4 = int32(s20 + s3)
023d  +0x035b8  op=52  1e 14 d8 01  LD32S            s20 = *(int32_t *)(s30 +0x1d8)
023e  +0x035d0  op=34  0b 16 15 00  OR64             s21 = s11 | s22
023f  +0x035e8  op=52  1e 0b 58 00  LD32S            s11 = *(int32_t *)(s30 +0x58)
0240  +0x03600  op=18  11 01 01 18  SHL32_IMM        s1 = (int32_t)(s1 << 24)
0241  +0x03618  op=34  19 01 01 01  OR64             s1 = s25 | s1
0242  +0x03630  op=b4  04 05 19 02  ADD32            s25 = int32(s4 + s5)
0243  +0x03648  op=b4  09 07 04 12  ADD32            s4 = int32(s9 + s7)
0244  +0x03660  op=52  1e 05 4c 00  LD32S            s5 = *(int32_t *)(s30 +0x4c)
0245  +0x03678  op=52  1e 07 58 01  LD32S            s7 = *(int32_t *)(s30 +0x158)
0246  +0x03690  op=18  10 07 09 18  SHL32_IMM        s9 = (int32_t)(s7 << 24)
0247  +0x036a8  op=b4  04 05 04 00  ADD32            s4 = int32(s4 + s5)
0248  +0x036c0  op=52  1e 05 6c 01  LD32S            s5 = *(int32_t *)(s30 +0x16c)
0249  +0x036d8  op=52  1e 07 b4 01  LD32S            s7 = *(int32_t *)(s30 +0x1b4)
024a  +0x036f0  op=34  18 09 10 00  OR64             s16 = s24 | s9
024b  +0x03708  op=52  1e 09 2c 00  LD32S            s9 = *(int32_t *)(s30 +0x2c)
024c  +0x03720  op=18  00 07 0e 18  SHL32_IMM        s14 = (int32_t)(s7 << 24)
024d  +0x03738  op=18  11 05 05 18  SHL32_IMM        s5 = (int32_t)(s5 << 24)
024e  +0x03750  op=b4  14 11 07 12  ADD32            s7 = int32(s20 + s17)
024f  +0x03768  op=34  0f 0e 0e 01  OR64             s14 = s15 | s14
0250  +0x03780  op=34  1f 05 0f 00  OR64             s15 = s31 | s5
0251  +0x03798  op=52  1e 05 24 00  LD32S            s5 = *(int32_t *)(s30 +0x24)
0252  +0x037b0  op=b4  07 0b 07 00  ADD32            s7 = int32(s7 + s11)
0253  +0x037c8  op=52  1e 0b 70 01  LD32S            s11 = *(int32_t *)(s30 +0x170)
0254  +0x037e0  op=b4  09 12 1f 12  ADD32            s31 = int32(s9 + s18)
0255  +0x037f8  op=52  1e 09 10 00  LD32S            s9 = *(int32_t *)(s30 +0x10)
0256  +0x03810  op=b4  05 03 05 00  ADD32            s5 = int32(s5 + s3)
0257  +0x03828  op=18  00 0b 0b 18  SHL32_IMM        s11 = (int32_t)(s11 << 24)
0258  +0x03840  op=b4  09 12 09 00  ADD32            s9 = int32(s9 + s18)
0259  +0x03858  op=08  1e 05 44 01  ST32             *(s30 +0x144) = (uint32_t)s5
025a  +0x03870  op=52  1e 05 08 00  LD32S            s5 = *(int32_t *)(s30 +0x8)
025b  +0x03888  op=34  0a 0b 0b 01  OR64             s11 = s10 | s11
025c  +0x038a0  op=52  1e 0a 8c 01  LD32S            s10 = *(int32_t *)(s30 +0x18c)
025d  +0x038b8  op=08  1e 09 48 01  ST32             *(s30 +0x148) = (uint32_t)s9
025e  +0x038d0  op=52  1e 09 08 02  LD32S            s9 = *(int32_t *)(s30 +0x208)
025f  +0x038e8  op=b4  05 03 05 12  ADD32            s5 = int32(s5 + s3)
0260  +0x03900  op=18  10 0a 0a 18  SHL32_IMM        s10 = (int32_t)(s10 << 24)
0261  +0x03918  op=b4  09 12 09 02  ADD32            s9 = int32(s9 + s18)
0262  +0x03930  op=08  1e 05 54 01  ST32             *(s30 +0x154) = (uint32_t)s5
0263  +0x03948  op=52  1e 05 f0 01  LD32S            s5 = *(int32_t *)(s30 +0x1f0)
0264  +0x03960  op=34  0c 0a 0c 01  OR64             s12 = s12 | s10
0265  +0x03978  op=08  1e 09 8c 01  ST32             *(s30 +0x18c) = (uint32_t)s9
0266  +0x03990  op=52  1e 09 a0 00  LD32S            s9 = *(int32_t *)(s30 +0xa0)
0267  +0x039a8  op=b4  05 03 03 00  ADD32            s3 = int32(s5 + s3)
0268  +0x039c0  op=b4  09 17 09 12  ADD32            s9 = int32(s9 + s23)
0269  +0x039d8  op=08  1e 03 70 01  ST32             *(s30 +0x170) = (uint32_t)s3
026a  +0x039f0  op=52  1e 03 64 00  LD32S            s3 = *(int32_t *)(s30 +0x64)
026b  +0x03a08  op=b4  03 0d 05 02  ADD32            s5 = int32(s3 + s13)
026c  +0x03a20  op=52  1e 03 20 00  LD32S            s3 = *(int32_t *)(s30 +0x20)
026d  +0x03a38  op=b4  03 0d 16 12  ADD32            s22 = int32(s3 + s13)
026e  +0x03a50  op=52  1e 03 f4 01  LD32S            s3 = *(int32_t *)(s30 +0x1f4)
026f  +0x03a68  op=b4  03 0d 03 02  ADD32            s3 = int32(s3 + s13)
0270  +0x03a80  op=52  1e 0d 34 00  LD32S            s13 = *(int32_t *)(s30 +0x34)
0271  +0x03a98  op=08  1e 03 78 01  ST32             *(s30 +0x178) = (uint32_t)s3
0272  +0x03ab0  op=52  1e 03 7c 00  LD32S            s3 = *(int32_t *)(s30 +0x7c)
0273  +0x03ac8  op=b4  0d 17 0d 02  ADD32            s13 = int32(s13 + s23)
0274  +0x03ae0  op=b4  03 13 0a 02  ADD32            s10 = int32(s3 + s19)
0275  +0x03af8  op=52  1e 03 28 00  LD32S            s3 = *(int32_t *)(s30 +0x28)
0276  +0x03b10  op=08  1e 0d 40 01  ST32             *(s30 +0x140) = (uint32_t)s13
0277  +0x03b28  op=52  1e 0d 14 00  LD32S            s13 = *(int32_t *)(s30 +0x14)
0278  +0x03b40  op=b4  03 13 18 00  ADD32            s24 = int32(s3 + s19)
0279  +0x03b58  op=52  1e 03 0c 00  LD32S            s3 = *(int32_t *)(s30 +0xc)
027a  +0x03b70  op=b4  0d 17 0d 12  ADD32            s13 = int32(s13 + s23)
027b  +0x03b88  op=08  1e 0d 5c 01  ST32             *(s30 +0x15c) = (uint32_t)s13
027c  +0x03ba0  op=52  1e 0d 10 02  LD32S            s13 = *(int32_t *)(s30 +0x210)
027d  +0x03bb8  op=b4  03 13 03 02  ADD32            s3 = int32(s3 + s19)
027e  +0x03bd0  op=08  1e 03 58 01  ST32             *(s30 +0x158) = (uint32_t)s3
027f  +0x03be8  op=52  1e 03 fc 01  LD32S            s3 = *(int32_t *)(s30 +0x1fc)
0280  +0x03c00  op=b4  0d 17 0d 02  ADD32            s13 = int32(s13 + s23)
0281  +0x03c18  op=08  1e 0d a0 01  ST32             *(s30 +0x1a0) = (uint32_t)s13
0282  +0x03c30  op=52  1e 0d 94 00  LD32S            s13 = *(int32_t *)(s30 +0x94)
0283  +0x03c48  op=b4  03 13 03 02  ADD32            s3 = int32(s3 + s19)
0284  +0x03c60  op=08  1e 03 7c 01  ST32             *(s30 +0x17c) = (uint32_t)s3
0285  +0x03c78  op=52  1e 03 00 02  LD32S            s3 = *(int32_t *)(s30 +0x200)
0286  +0x03c90  op=b4  03 13 03 02  ADD32            s3 = int32(s3 + s19)
0287  +0x03ca8  op=b4  0d 01 13 00  ADD32            s19 = int32(s13 + s1)
0288  +0x03cc0  op=52  1e 0d 30 00  LD32S            s13 = *(int32_t *)(s30 +0x30)
0289  +0x03cd8  op=08  1e 03 80 01  ST32             *(s30 +0x180) = (uint32_t)s3
028a  +0x03cf0  op=52  1e 03 80 00  LD32S            s3 = *(int32_t *)(s30 +0x80)
028b  +0x03d08  op=b4  0d 01 17 12  ADD32            s23 = int32(s13 + s1)
028c  +0x03d20  op=52  1e 0d 18 00  LD32S            s13 = *(int32_t *)(s30 +0x18)
028d  +0x03d38  op=b4  03 12 03 02  ADD32            s3 = int32(s3 + s18)
028e  +0x03d50  op=52  1e 12 1c 00  LD32S            s18 = *(int32_t *)(s30 +0x1c)
028f  +0x03d68  op=b4  0d 01 0d 00  ADD32            s13 = int32(s13 + s1)
0290  +0x03d80  op=08  1e 0d 60 01  ST32             *(s30 +0x160) = (uint32_t)s13
0291  +0x03d98  op=52  1e 0d 18 02  LD32S            s13 = *(int32_t *)(s30 +0x218)
0292  +0x03db0  op=b4  12 02 12 12  ADD32            s18 = int32(s18 + s2)
0293  +0x03dc8  op=08  1e 12 6c 01  ST32             *(s30 +0x16c) = (uint32_t)s18
0294  +0x03de0  op=52  1e 12 1c 02  LD32S            s18 = *(int32_t *)(s30 +0x21c)
0295  +0x03df8  op=b4  0d 01 01 00  ADD32            s1 = int32(s13 + s1)
0296  +0x03e10  op=52  1e 0d 38 00  LD32S            s13 = *(int32_t *)(s30 +0x38)
0297  +0x03e28  op=08  1e 01 a8 01  ST32             *(s30 +0x1a8) = (uint32_t)s1
0298  +0x03e40  op=52  1e 01 c8 00  LD32S            s1 = *(int32_t *)(s30 +0xc8)
0299  +0x03e58  op=b4  0d 02 0d 12  ADD32            s13 = int32(s13 + s2)
029a  +0x03e70  op=b4  01 02 01 00  ADD32            s1 = int32(s1 + s2)
029b  +0x03e88  op=b4  12 02 02 02  ADD32            s2 = int32(s18 + s2)
029c  +0x03ea0  op=34  06 00 12 00  OR64             s18 = s6 | s0
029d  +0x03eb8  op=02  06 14 06 00  XOR64            s6 = s20 ^ s6
029e  +0x03ed0  op=08  1e 02 b4 01  ST32             *(s30 +0x1b4) = (uint32_t)s2
029f  +0x03ee8  op=2e  12 08 02 19  ROR32_IMM        s2 = ror32((uint32_t)s8, 25)
02a0  +0x03f00  op=b4  02 14 02 00  ADD32            s2 = int32(s2 + s20)
02a1  +0x03f18  op=b3  02 06 06 01  AND64            s6 = s2 & s6
02a2  +0x03f30  op=b4  13 02 08 00  ADD32            s8 = int32(s19 + s2)
02a3  +0x03f48  op=02  06 12 06 01  XOR64            s6 = s18 ^ s6
02a4  +0x03f60  op=b4  04 06 04 00  ADD32            s4 = int32(s4 + s6)
02a5  +0x03f78  op=02  02 14 06 00  XOR64            s6 = s20 ^ s2
02a6  +0x03f90  op=2e  12 04 04 14  ROR32_IMM        s4 = ror32((uint32_t)s4, 20)
02a7  +0x03fa8  op=b4  04 02 04 00  ADD32            s4 = int32(s4 + s2)
02a8  +0x03fc0  op=b3  04 06 06 00  AND64            s6 = s4 & s6
02a9  +0x03fd8  op=02  04 02 12 00  XOR64            s18 = s2 ^ s4
02aa  +0x03ff0  op=02  06 14 06 01  XOR64            s6 = s20 ^ s6
02ab  +0x04008  op=b4  19 06 06 02  ADD32            s6 = int32(s25 + s6)
02ac  +0x04020  op=52  1e 19 98 01  LD32S            s25 = *(int32_t *)(s30 +0x198)
02ad  +0x04038  op=2e  10 06 06 0f  ROR32_IMM        s6 = ror32((uint32_t)s6, 15)
02ae  +0x04050  op=b4  06 04 06 02  ADD32            s6 = int32(s6 + s4)
02af  +0x04068  op=b3  06 12 12 01  AND64            s18 = s6 & s18
02b0  +0x04080  op=b4  05 06 05 12  ADD32            s5 = int32(s5 + s6)
02b1  +0x04098  op=02  12 02 02 01  XOR64            s2 = s2 ^ s18
02b2  +0x040b0  op=02  06 04 12 01  XOR64            s18 = s4 ^ s6
02b3  +0x040c8  op=b4  07 02 02 02  ADD32            s2 = int32(s7 + s2)
02b4  +0x040e0  op=52  1e 07 08 01  LD32S            s7 = *(int32_t *)(s30 +0x108)
02b5  +0x040f8  op=2e  12 02 02 0a  ROR32_IMM        s2 = ror32((uint32_t)s2, 10)
02b6  +0x04110  op=b4  02 06 02 12  ADD32            s2 = int32(s2 + s6)
02b7  +0x04128  op=b4  07 15 07 12  ADD32            s7 = int32(s7 + s21)
02b8  +0x04140  op=b3  02 12 12 01  AND64            s18 = s2 & s18
02b9  +0x04158  op=b4  07 04 07 12  ADD32            s7 = int32(s7 + s4)
02ba  +0x04170  op=b4  03 02 03 12  ADD32            s3 = int32(s3 + s2)
02bb  +0x04188  op=02  12 04 04 01  XOR64            s4 = s4 ^ s18
02bc  +0x041a0  op=b4  08 04 04 00  ADD32            s4 = int32(s8 + s4)
02bd  +0x041b8  op=02  02 06 08 01  XOR64            s8 = s6 ^ s2
02be  +0x041d0  op=2e  01 04 04 19  ROR32_IMM        s4 = ror32((uint32_t)s4, 25)
02bf  +0x041e8  op=b4  04 02 04 12  ADD32            s4 = int32(s4 + s2)
02c0  +0x04200  op=b3  04 08 08 00  AND64            s8 = s4 & s8
02c1  +0x04218  op=02  08 06 06 00  XOR64            s6 = s6 ^ s8
02c2  +0x04230  op=52  1e 08 18 01  LD32S            s8 = *(int32_t *)(s30 +0x118)
02c3  +0x04248  op=b4  07 06 06 00  ADD32            s6 = int32(s7 + s6)
02c4  +0x04260  op=02  04 02 07 00  XOR64            s7 = s2 ^ s4
02c5  +0x04278  op=2e  10 06 06 14  ROR32_IMM        s6 = ror32((uint32_t)s6, 20)
02c6  +0x04290  op=b4  06 04 06 00  ADD32            s6 = int32(s6 + s4)
02c7  +0x042a8  op=b3  06 07 07 01  AND64            s7 = s6 & s7
02c8  +0x042c0  op=02  07 02 02 00  XOR64            s2 = s2 ^ s7
02c9  +0x042d8  op=02  06 04 07 00  XOR64            s7 = s4 ^ s6
02ca  +0x042f0  op=b4  05 02 02 02  ADD32            s2 = int32(s5 + s2)
02cb  +0x04308  op=52  1e 05 50 01  LD32S            s5 = *(int32_t *)(s30 +0x150)
02cc  +0x04320  op=2e  01 02 02 0f  ROR32_IMM        s2 = ror32((uint32_t)s2, 15)
02cd  +0x04338  op=b4  02 06 02 02  ADD32            s2 = int32(s2 + s6)
02ce  +0x04350  op=b4  05 0b 05 12  ADD32            s5 = int32(s5 + s11)
02cf  +0x04368  op=b3  02 07 07 00  AND64            s7 = s2 & s7
02d0  +0x04380  op=b4  05 04 05 00  ADD32            s5 = int32(s5 + s4)
02d1  +0x04398  op=02  07 04 04 01  XOR64            s4 = s4 ^ s7
02d2  +0x043b0  op=02  02 06 07 01  XOR64            s7 = s6 ^ s2
02d3  +0x043c8  op=b4  03 04 03 12  ADD32            s3 = int32(s3 + s4)
02d4  +0x043e0  op=52  1e 04 64 01  LD32S            s4 = *(int32_t *)(s30 +0x164)
02d5  +0x043f8  op=2e  12 03 03 0a  ROR32_IMM        s3 = ror32((uint32_t)s3, 10)
02d6  +0x04410  op=b4  03 02 03 00  ADD32            s3 = int32(s3 + s2)
02d7  +0x04428  op=b4  04 0c 04 12  ADD32            s4 = int32(s4 + s12)
02d8  +0x04440  op=b3  03 07 07 01  AND64            s7 = s3 & s7
02d9  +0x04458  op=b4  04 06 04 02  ADD32            s4 = int32(s4 + s6)
02da  +0x04470  op=02  07 06 06 01  XOR64            s6 = s6 ^ s7
02db  +0x04488  op=02  03 02 07 01  XOR64            s7 = s2 ^ s3
02dc  +0x044a0  op=b4  05 06 05 00  ADD32            s5 = int32(s5 + s6)
02dd  +0x044b8  op=52  1e 06 74 01  LD32S            s6 = *(int32_t *)(s30 +0x174)
02de  +0x044d0  op=2e  10 05 05 19  ROR32_IMM        s5 = ror32((uint32_t)s5, 25)
02df  +0x044e8  op=b4  05 03 05 02  ADD32            s5 = int32(s5 + s3)
02e0  +0x04500  op=b4  06 0e 06 02  ADD32            s6 = int32(s6 + s14)
02e1  +0x04518  op=b3  05 07 07 01  AND64            s7 = s5 & s7
02e2  +0x04530  op=b4  06 02 06 00  ADD32            s6 = int32(s6 + s2)
02e3  +0x04548  op=b4  01 05 01 00  ADD32            s1 = int32(s1 + s5)
02e4  +0x04560  op=02  07 02 02 01  XOR64            s2 = s2 ^ s7
02e5  +0x04578  op=02  05 03 07 00  XOR64            s7 = s3 ^ s5
02e6  +0x04590  op=b4  04 02 02 02  ADD32            s2 = int32(s4 + s2)
02e7  +0x045a8  op=b4  09 03 04 02  ADD32            s4 = int32(s9 + s3)
02e8  +0x045c0  op=52  1e 09 24 01  LD32S            s9 = *(int32_t *)(s30 +0x124)
02e9  +0x045d8  op=2e  01 02 02 14  ROR32_IMM        s2 = ror32((uint32_t)s2, 20)
02ea  +0x045f0  op=b4  02 05 02 00  ADD32            s2 = int32(s2 + s5)
02eb  +0x04608  op=b3  02 07 07 01  AND64            s7 = s2 & s7
02ec  +0x04620  op=02  07 03 03 01  XOR64            s3 = s3 ^ s7
02ed  +0x04638  op=b4  06 03 03 12  ADD32            s3 = int32(s6 + s3)
02ee  +0x04650  op=02  02 05 06 00  XOR64            s6 = s5 ^ s2
02ef  +0x04668  op=2e  12 03 03 0f  ROR32_IMM        s3 = ror32((uint32_t)s3, 15)
02f0  +0x04680  op=b4  03 02 03 12  ADD32            s3 = int32(s3 + s2)
02f1  +0x04698  op=b3  03 06 06 01  AND64            s6 = s3 & s6
02f2  +0x046b0  op=02  06 05 05 00  XOR64            s5 = s5 ^ s6
02f3  +0x046c8  op=02  03 02 06 01  XOR64            s6 = s2 ^ s3
02f4  +0x046e0  op=b4  04 05 04 02  ADD32            s4 = int32(s4 + s5)
02f5  +0x046f8  op=b4  0a 02 05 02  ADD32            s5 = int32(s10 + s2)
02f6  +0x04710  op=2e  01 04 04 0a  ROR32_IMM        s4 = ror32((uint32_t)s4, 10)
02f7  +0x04728  op=b4  04 03 04 00  ADD32            s4 = int32(s4 + s3)
02f8  +0x04740  op=b3  04 06 06 01  AND64            s6 = s4 & s6
02f9  +0x04758  op=02  06 02 02 01  XOR64            s2 = s2 ^ s6
02fa  +0x04770  op=02  04 03 06 01  XOR64            s6 = s3 ^ s4
02fb  +0x04788  op=b4  01 02 01 02  ADD32            s1 = int32(s1 + s2)
02fc  +0x047a0  op=52  1e 02 ac 01  LD32S            s2 = *(int32_t *)(s30 +0x1ac)
02fd  +0x047b8  op=2e  10 01 01 19  ROR32_IMM        s1 = ror32((uint32_t)s1, 25)
02fe  +0x047d0  op=b4  01 04 01 02  ADD32            s1 = int32(s1 + s4)
02ff  +0x047e8  op=b4  02 10 02 12  ADD32            s2 = int32(s2 + s16)
0300  +0x04800  op=b3  01 06 06 01  AND64            s6 = s1 & s6
0301  +0x04818  op=b4  02 03 02 00  ADD32            s2 = int32(s2 + s3)
0302  +0x04830  op=02  06 03 03 00  XOR64            s3 = s3 ^ s6
0303  +0x04848  op=02  01 04 06 01  XOR64            s6 = s4 ^ s1
0304  +0x04860  op=b4  05 03 03 12  ADD32            s3 = int32(s5 + s3)
0305  +0x04878  op=52  1e 05 b8 01  LD32S            s5 = *(int32_t *)(s30 +0x1b8)
0306  +0x04890  op=2e  10 03 03 14  ROR32_IMM        s3 = ror32((uint32_t)s3, 20)
0307  +0x048a8  op=b4  03 01 03 00  ADD32            s3 = int32(s3 + s1)
0308  +0x048c0  op=b4  05 0f 05 02  ADD32            s5 = int32(s5 + s15)
0309  +0x048d8  op=b3  03 06 06 00  AND64            s6 = s3 & s6
030a  +0x048f0  op=b4  05 04 05 12  ADD32            s5 = int32(s5 + s4)
030b  +0x04908  op=02  03 01 07 01  XOR64            s7 = s1 ^ s3
030c  +0x04920  op=02  06 04 04 01  XOR64            s4 = s4 ^ s6
030d  +0x04938  op=52  1e 06 14 01  LD32S            s6 = *(int32_t *)(s30 +0x114)
030e  +0x04950  op=b4  02 04 02 12  ADD32            s2 = int32(s2 + s4)
030f  +0x04968  op=52  1e 04 3c 00  LD32S            s4 = *(int32_t *)(s30 +0x3c)
0310  +0x04980  op=2e  01 02 02 0f  ROR32_IMM        s2 = ror32((uint32_t)s2, 15)
0311  +0x04998  op=b4  02 03 02 00  ADD32            s2 = int32(s2 + s3)
0312  +0x049b0  op=b4  04 06 04 02  ADD32            s4 = int32(s4 + s6)
0313  +0x049c8  op=b4  01 06 06 12  ADD32            s6 = int32(s1 + s6)
0314  +0x049e0  op=b3  02 07 07 01  AND64            s7 = s2 & s7
0315  +0x049f8  op=02  07 01 01 01  XOR64            s1 = s1 ^ s7
0316  +0x04a10  op=52  1e 07 f8 01  LD32S            s7 = *(int32_t *)(s30 +0x1f8)
0317  +0x04a28  op=b4  05 01 05 02  ADD32            s5 = int32(s5 + s1)
0318  +0x04a40  op=52  1e 01 44 00  LD32S            s1 = *(int32_t *)(s30 +0x44)
0319  +0x04a58  op=2e  12 05 05 0a  ROR32_IMM        s5 = ror32((uint32_t)s5, 10)
031a  +0x04a70  op=b4  07 15 14 00  ADD32            s20 = int32(s7 + s21)
031b  +0x04a88  op=b4  02 15 07 12  ADD32            s7 = int32(s2 + s21)
031c  +0x04aa0  op=b4  07 08 07 00  ADD32            s7 = int32(s7 + s8)
031d  +0x04ab8  op=b4  03 0e 08 02  ADD32            s8 = int32(s3 + s14)
031e  +0x04ad0  op=b4  05 02 05 02  ADD32            s5 = int32(s5 + s2)
031f  +0x04ae8  op=b4  01 15 01 12  ADD32            s1 = int32(s1 + s21)
0320  +0x04b00  op=b4  08 09 08 00  ADD32            s8 = int32(s8 + s9)
0321  +0x04b18  op=02  05 02 09 01  XOR64            s9 = s2 ^ s5
0322  +0x04b30  op=b3  09 03 03 01  AND64            s3 = s9 & s3
0323  +0x04b48  op=52  1e 09 4c 01  LD32S            s9 = *(int32_t *)(s30 +0x14c)
0324  +0x04b60  op=02  03 02 03 01  XOR64            s3 = s2 ^ s3
0325  +0x04b78  op=b4  06 03 03 02  ADD32            s3 = int32(s6 + s3)
0326  +0x04b90  op=52  1e 06 30 01  LD32S            s6 = *(int32_t *)(s30 +0x130)
0327  +0x04ba8  op=b4  03 06 03 00  ADD32            s3 = int32(s3 + s6)
0328  +0x04bc0  op=52  1e 06 54 00  LD32S            s6 = *(int32_t *)(s30 +0x54)
0329  +0x04bd8  op=2e  10 03 03 1b  ROR32_IMM        s3 = ror32((uint32_t)s3, 27)
032a  +0x04bf0  op=b4  06 10 13 12  ADD32            s19 = int32(s6 + s16)
032b  +0x04c08  op=52  1e 06 14 02  LD32S            s6 = *(int32_t *)(s30 +0x214)
032c  +0x04c20  op=b4  03 05 03 00  ADD32            s3 = int32(s3 + s5)
032d  +0x04c38  op=b4  06 10 15 00  ADD32            s21 = int32(s6 + s16)
032e  +0x04c50  op=b4  05 10 06 00  ADD32            s6 = int32(s5 + s16)
032f  +0x04c68  op=b4  06 09 06 12  ADD32            s6 = int32(s6 + s9)
0330  +0x04c80  op=02  03 05 09 01  XOR64            s9 = s5 ^ s3
0331  +0x04c98  op=b3  09 02 02 01  AND64            s2 = s9 & s2
0332  +0x04cb0  op=52  1e 09 28 01  LD32S            s9 = *(int32_t *)(s30 +0x128)
0333  +0x04cc8  op=02  02 05 02 01  XOR64            s2 = s5 ^ s2
0334  +0x04ce0  op=b4  08 02 02 12  ADD32            s2 = int32(s8 + s2)
0335  +0x04cf8  op=34  09 00 0a 01  OR64             s10 = s9 | s0
0336  +0x04d10  op=2e  12 02 02 17  ROR32_IMM        s2 = ror32((uint32_t)s2, 23)
0337  +0x04d28  op=b4  02 03 02 02  ADD32            s2 = int32(s2 + s3)
0338  +0x04d40  op=02  02 03 08 01  XOR64            s8 = s3 ^ s2
0339  +0x04d58  op=b3  08 05 05 00  AND64            s5 = s8 & s5
033a  +0x04d70  op=02  05 03 05 01  XOR64            s5 = s3 ^ s5
033b  +0x04d88  op=b4  07 05 05 00  ADD32            s5 = int32(s7 + s5)
033c  +0x04da0  op=52  1e 07 68 01  LD32S            s7 = *(int32_t *)(s30 +0x168)
033d  +0x04db8  op=2e  01 05 05 12  ROR32_IMM        s5 = ror32((uint32_t)s5, 18)
033e  +0x04dd0  op=b4  05 02 05 02  ADD32            s5 = int32(s5 + s2)
033f  +0x04de8  op=b4  07 11 07 02  ADD32            s7 = int32(s7 + s17)
0340  +0x04e00  op=02  05 02 08 01  XOR64            s8 = s2 ^ s5
0341  +0x04e18  op=b4  07 03 07 12  ADD32            s7 = int32(s7 + s3)
0342  +0x04e30  op=b3  08 03 03 00  AND64            s3 = s8 & s3
0343  +0x04e48  op=02  03 02 03 01  XOR64            s3 = s2 ^ s3
0344  +0x04e60  op=b4  06 03 03 12  ADD32            s3 = int32(s6 + s3)
0345  +0x04e78  op=b4  17 02 06 02  ADD32            s6 = int32(s23 + s2)
0346  +0x04e90  op=2e  01 03 03 0c  ROR32_IMM        s3 = ror32((uint32_t)s3, 12)
0347  +0x04ea8  op=b4  03 05 03 12  ADD32            s3 = int32(s3 + s5)
0348  +0x04ec0  op=02  03 05 08 01  XOR64            s8 = s5 ^ s3
0349  +0x04ed8  op=b3  08 02 02 00  AND64            s2 = s8 & s2
034a  +0x04ef0  op=02  02 05 02 00  XOR64            s2 = s5 ^ s2
034b  +0x04f08  op=b4  07 02 02 02  ADD32            s2 = int32(s7 + s2)
034c  +0x04f20  op=52  1e 07 88 01  LD32S            s7 = *(int32_t *)(s30 +0x188)
034d  +0x04f38  op=2e  12 02 02 1b  ROR32_IMM        s2 = ror32((uint32_t)s2, 27)
034e  +0x04f50  op=b4  02 03 02 00  ADD32            s2 = int32(s2 + s3)
034f  +0x04f68  op=b4  07 0f 07 00  ADD32            s7 = int32(s7 + s15)
0350  +0x04f80  op=02  02 03 08 00  XOR64            s8 = s3 ^ s2
0351  +0x04f98  op=b4  07 05 07 02  ADD32            s7 = int32(s7 + s5)
0352  +0x04fb0  op=b3  08 05 05 01  AND64            s5 = s8 & s5
0353  +0x04fc8  op=02  05 03 05 01  XOR64            s5 = s3 ^ s5
0354  +0x04fe0  op=b4  06 05 05 00  ADD32            s5 = int32(s6 + s5)
0355  +0x04ff8  op=b4  18 03 06 02  ADD32            s6 = int32(s24 + s3)
0356  +0x05010  op=2e  01 05 05 17  ROR32_IMM        s5 = ror32((uint32_t)s5, 23)
0357  +0x05028  op=b4  05 02 05 02  ADD32            s5 = int32(s5 + s2)
0358  +0x05040  op=02  05 02 08 01  XOR64            s8 = s2 ^ s5
0359  +0x05058  op=b3  08 03 03 01  AND64            s3 = s8 & s3
035a  +0x05070  op=02  03 02 03 01  XOR64            s3 = s2 ^ s3
035b  +0x05088  op=b4  07 03 03 02  ADD32            s3 = int32(s7 + s3)
035c  +0x050a0  op=b4  16 02 07 12  ADD32            s7 = int32(s22 + s2)
035d  +0x050b8  op=2e  10 03 03 12  ROR32_IMM        s3 = ror32((uint32_t)s3, 18)
035e  +0x050d0  op=b4  03 05 03 02  ADD32            s3 = int32(s3 + s5)
035f  +0x050e8  op=02  03 05 08 00  XOR64            s8 = s5 ^ s3
0360  +0x05100  op=b3  08 02 02 01  AND64            s2 = s8 & s2
0361  +0x05118  op=02  02 05 02 00  XOR64            s2 = s5 ^ s2
0362  +0x05130  op=b4  06 02 02 02  ADD32            s2 = int32(s6 + s2)
0363  +0x05148  op=52  1e 06 b0 01  LD32S            s6 = *(int32_t *)(s30 +0x1b0)
0364  +0x05160  op=2e  10 02 02 0c  ROR32_IMM        s2 = ror32((uint32_t)s2, 12)
0365  +0x05178  op=b4  02 03 02 12  ADD32            s2 = int32(s2 + s3)
0366  +0x05190  op=b4  06 09 06 00  ADD32            s6 = int32(s6 + s9)
0367  +0x051a8  op=02  02 03 08 01  XOR64            s8 = s3 ^ s2
0368  +0x051c0  op=b4  06 05 06 02  ADD32            s6 = int32(s6 + s5)
0369  +0x051d8  op=b3  08 05 05 00  AND64            s5 = s8 & s5
036a  +0x051f0  op=02  05 03 05 01  XOR64            s5 = s3 ^ s5
036b  +0x05208  op=b4  07 05 05 12  ADD32            s5 = int32(s7 + s5)
036c  +0x05220  op=b4  0d 03 07 02  ADD32            s7 = int32(s13 + s3)
036d  +0x05238  op=2e  01 05 05 1b  ROR32_IMM        s5 = ror32((uint32_t)s5, 27)
036e  +0x05250  op=b4  05 02 05 12  ADD32            s5 = int32(s5 + s2)
036f  +0x05268  op=02  05 02 08 01  XOR64            s8 = s2 ^ s5
0370  +0x05280  op=b3  08 03 03 01  AND64            s3 = s8 & s3
0371  +0x05298  op=02  03 02 03 00  XOR64            s3 = s2 ^ s3
0372  +0x052b0  op=b4  06 03 03 12  ADD32            s3 = int32(s6 + s3)
0373  +0x052c8  op=52  1e 06 bc 01  LD32S            s6 = *(int32_t *)(s30 +0x1bc)
0374  +0x052e0  op=2e  10 03 03 17  ROR32_IMM        s3 = ror32((uint32_t)s3, 23)
0375  +0x052f8  op=b4  03 05 03 12  ADD32            s3 = int32(s3 + s5)
0376  +0x05310  op=b4  06 0b 06 00  ADD32            s6 = int32(s6 + s11)
0377  +0x05328  op=02  03 05 08 01  XOR64            s8 = s5 ^ s3
0378  +0x05340  op=b4  06 02 06 02  ADD32            s6 = int32(s6 + s2)
0379  +0x05358  op=b3  08 02 02 01  AND64            s2 = s8 & s2
037a  +0x05370  op=02  02 05 02 00  XOR64            s2 = s5 ^ s2
037b  +0x05388  op=b4  07 02 02 02  ADD32            s2 = int32(s7 + s2)
037c  +0x053a0  op=52  1e 07 c4 01  LD32S            s7 = *(int32_t *)(s30 +0x1c4)
037d  +0x053b8  op=2e  12 02 02 12  ROR32_IMM        s2 = ror32((uint32_t)s2, 18)
037e  +0x053d0  op=b4  02 03 02 02  ADD32            s2 = int32(s2 + s3)
037f  +0x053e8  op=b4  07 0c 07 12  ADD32            s7 = int32(s7 + s12)
0380  +0x05400  op=02  02 03 08 00  XOR64            s8 = s3 ^ s2
0381  +0x05418  op=b4  07 05 07 00  ADD32            s7 = int32(s7 + s5)
0382  +0x05430  op=b3  08 05 05 01  AND64            s5 = s8 & s5
0383  +0x05448  op=02  05 03 05 01  XOR64            s5 = s3 ^ s5
0384  +0x05460  op=b4  06 05 05 00  ADD32            s5 = int32(s6 + s5)
0385  +0x05478  op=b4  1f 03 06 00  ADD32            s6 = int32(s31 + s3)
0386  +0x05490  op=2e  10 05 05 0c  ROR32_IMM        s5 = ror32((uint32_t)s5, 12)
0387  +0x054a8  op=b4  05 02 05 00  ADD32            s5 = int32(s5 + s2)
0388  +0x054c0  op=02  05 02 08 01  XOR64            s8 = s2 ^ s5
0389  +0x054d8  op=b3  08 03 03 01  AND64            s3 = s8 & s3
038a  +0x054f0  op=02  03 02 03 01  XOR64            s3 = s2 ^ s3
038b  +0x05508  op=b4  07 03 03 00  ADD32            s3 = int32(s7 + s3)
038c  +0x05520  op=52  1e 07 40 01  LD32S            s7 = *(int32_t *)(s30 +0x140)
038d  +0x05538  op=2e  12 03 03 1b  ROR32_IMM        s3 = ror32((uint32_t)s3, 27)
038e  +0x05550  op=b4  03 05 08 02  ADD32            s8 = int32(s3 + s5)
038f  +0x05568  op=b4  07 02 07 02  ADD32            s7 = int32(s7 + s2)
0390  +0x05580  op=02  08 05 03 00  XOR64            s3 = s5 ^ s8
0391  +0x05598  op=b3  03 02 02 01  AND64            s2 = s3 & s2
0392  +0x055b0  op=52  1e 03 44 01  LD32S            s3 = *(int32_t *)(s30 +0x144)
0393  +0x055c8  op=02  02 05 02 01  XOR64            s2 = s5 ^ s2
0394  +0x055e0  op=b4  06 02 02 02  ADD32            s2 = int32(s6 + s2)
0395  +0x055f8  op=b4  03 05 03 02  ADD32            s3 = int32(s3 + s5)
0396  +0x05610  op=2e  01 02 02 17  ROR32_IMM        s2 = ror32((uint32_t)s2, 23)
0397  +0x05628  op=b4  02 08 06 00  ADD32            s6 = int32(s2 + s8)
0398  +0x05640  op=02  06 08 02 01  XOR64            s2 = s8 ^ s6
0399  +0x05658  op=b3  02 05 02 01  AND64            s2 = s2 & s5
039a  +0x05670  op=02  02 08 02 01  XOR64            s2 = s8 ^ s2
039b  +0x05688  op=b4  07 02 02 02  ADD32            s2 = int32(s7 + s2)
039c  +0x056a0  op=2e  10 02 02 12  ROR32_IMM        s2 = ror32((uint32_t)s2, 18)
039d  +0x056b8  op=b4  02 06 05 00  ADD32            s5 = int32(s2 + s6)
039e  +0x056d0  op=02  05 06 07 01  XOR64            s7 = s6 ^ s5
039f  +0x056e8  op=b4  05 11 18 12  ADD32            s24 = int32(s5 + s17)
03a0  +0x05700  op=b3  07 08 02 01  AND64            s2 = s7 & s8
03a1  +0x05718  op=b4  08 0b 08 02  ADD32            s8 = int32(s8 + s11)
03a2  +0x05730  op=b4  18 19 18 02  ADD32            s24 = int32(s24 + s25)
03a3  +0x05748  op=52  1e 19 9c 01  LD32S            s25 = *(int32_t *)(s30 +0x19c)
03a4  +0x05760  op=02  02 06 02 00  XOR64            s2 = s6 ^ s2
03a5  +0x05778  op=b4  06 0e 06 12  ADD32            s6 = int32(s6 + s14)
03a6  +0x05790  op=b4  03 02 02 12  ADD32            s2 = int32(s3 + s2)
03a7  +0x057a8  op=52  1e 03 04 02  LD32S            s3 = *(int32_t *)(s30 +0x204)
03a8  +0x057c0  op=b4  06 19 06 12  ADD32            s6 = int32(s6 + s25)
03a9  +0x057d8  op=2e  01 02 02 0c  ROR32_IMM        s2 = ror32((uint32_t)s2, 12)
03aa  +0x057f0  op=b4  03 09 03 12  ADD32            s3 = int32(s3 + s9)
03ab  +0x05808  op=b4  02 05 09 02  ADD32            s9 = int32(s2 + s5)
03ac  +0x05820  op=02  07 09 07 00  XOR64            s7 = s9 ^ s7
03ad  +0x05838  op=02  09 05 05 01  XOR64            s5 = s5 ^ s9
03ae  +0x05850  op=b4  09 0a 02 12  ADD32            s2 = int32(s9 + s10)
03af  +0x05868  op=52  1e 0a 84 01  LD32S            s10 = *(int32_t *)(s30 +0x184)
03b0  +0x05880  op=b4  08 07 07 00  ADD32            s7 = int32(s8 + s7)
03b1  +0x05898  op=52  1e 08 a4 01  LD32S            s8 = *(int32_t *)(s30 +0x1a4)
03b2  +0x058b0  op=b4  02 0a 0a 12  ADD32            s10 = int32(s2 + s10)
03b3  +0x058c8  op=52  1e 02 94 01  LD32S            s2 = *(int32_t *)(s30 +0x194)
03b4  +0x058e0  op=b4  07 08 07 00  ADD32            s7 = int32(s7 + s8)
03b5  +0x058f8  op=2e  01 07 07 1c  ROR32_IMM        s7 = ror32((uint32_t)s7, 28)
03b6  +0x05910  op=b4  02 11 0d 00  ADD32            s13 = int32(s2 + s17)
03b7  +0x05928  op=52  1e 02 0c 02  LD32S            s2 = *(int32_t *)(s30 +0x20c)
03b8  +0x05940  op=b4  07 09 07 00  ADD32            s7 = int32(s7 + s9)
03b9  +0x05958  op=02  05 07 05 01  XOR64            s5 = s7 ^ s5
03ba  +0x05970  op=b4  13 07 08 00  ADD32            s8 = int32(s19 + s7)
03bb  +0x05988  op=b4  02 11 02 12  ADD32            s2 = int32(s2 + s17)
03bc  +0x059a0  op=b4  06 05 05 12  ADD32            s5 = int32(s6 + s5)
03bd  +0x059b8  op=02  07 09 06 01  XOR64            s6 = s9 ^ s7
03be  +0x059d0  op=2e  12 05 05 15  ROR32_IMM        s5 = ror32((uint32_t)s5, 21)
03bf  +0x059e8  op=b4  05 07 05 02  ADD32            s5 = int32(s5 + s7)
03c0  +0x05a00  op=02  06 05 06 01  XOR64            s6 = s5 ^ s6
03c1  +0x05a18  op=02  05 07 07 01  XOR64            s7 = s7 ^ s5
03c2  +0x05a30  op=b4  0d 05 09 00  ADD32            s9 = int32(s13 + s5)
03c3  +0x05a48  op=b4  18 06 06 02  ADD32            s6 = int32(s24 + s6)
03c4  +0x05a60  op=2e  12 06 06 10  ROR32_IMM        s6 = ror32((uint32_t)s6, 16)
03c5  +0x05a78  op=b4  06 05 06 02  ADD32            s6 = int32(s6 + s5)
03c6  +0x05a90  op=02  07 06 07 01  XOR64            s7 = s6 ^ s7
03c7  +0x05aa8  op=02  06 05 05 00  XOR64            s5 = s5 ^ s6
03c8  +0x05ac0  op=b4  0a 07 07 00  ADD32            s7 = int32(s10 + s7)
03c9  +0x05ad8  op=52  1e 0a e8 01  LD32S            s10 = *(int32_t *)(s30 +0x1e8)
03ca  +0x05af0  op=2e  01 07 07 09  ROR32_IMM        s7 = ror32((uint32_t)s7, 9)
03cb  +0x05b08  op=b4  07 06 07 12  ADD32            s7 = int32(s7 + s6)
03cc  +0x05b20  op=02  05 07 05 00  XOR64            s5 = s7 ^ s5
03cd  +0x05b38  op=b4  08 05 05 00  ADD32            s5 = int32(s8 + s5)
03ce  +0x05b50  op=52  1e 08 48 01  LD32S            s8 = *(int32_t *)(s30 +0x148)
03cf  +0x05b68  op=2e  12 05 05 1c  ROR32_IMM        s5 = ror32((uint32_t)s5, 28)
03d0  +0x05b80  op=b4  08 06 08 12  ADD32            s8 = int32(s8 + s6)
03d1  +0x05b98  op=b4  05 07 05 02  ADD32            s5 = int32(s5 + s7)
03d2  +0x05bb0  op=02  07 06 06 01  XOR64            s6 = s6 ^ s7
03d3  +0x05bc8  op=02  06 05 06 01  XOR64            s6 = s5 ^ s6
03d4  +0x05be0  op=b4  01 05 01 00  ADD32            s1 = int32(s1 + s5)
03d5  +0x05bf8  op=b4  09 06 06 02  ADD32            s6 = int32(s9 + s6)
03d6  +0x05c10  op=52  1e 09 54 01  LD32S            s9 = *(int32_t *)(s30 +0x154)
03d7  +0x05c28  op=2e  12 06 06 15  ROR32_IMM        s6 = ror32((uint32_t)s6, 21)
03d8  +0x05c40  op=b4  09 07 09 00  ADD32            s9 = int32(s9 + s7)
03d9  +0x05c58  op=b4  06 05 06 00  ADD32            s6 = int32(s6 + s5)
03da  +0x05c70  op=02  05 07 07 00  XOR64            s7 = s7 ^ s5
03db  +0x05c88  op=02  07 06 07 00  XOR64            s7 = s6 ^ s7
03dc  +0x05ca0  op=02  06 05 05 01  XOR64            s5 = s5 ^ s6
03dd  +0x05cb8  op=b4  04 06 04 12  ADD32            s4 = int32(s4 + s6)
03de  +0x05cd0  op=b4  08 07 07 00  ADD32            s7 = int32(s8 + s7)
03df  +0x05ce8  op=52  1e 08 5c 01  LD32S            s8 = *(int32_t *)(s30 +0x15c)
03e0  +0x05d00  op=2e  10 07 07 10  ROR32_IMM        s7 = ror32((uint32_t)s7, 16)
03e1  +0x05d18  op=b4  07 06 07 12  ADD32            s7 = int32(s7 + s6)
03e2  +0x05d30  op=02  05 07 05 00  XOR64            s5 = s7 ^ s5
03e3  +0x05d48  op=02  07 06 06 00  XOR64            s6 = s6 ^ s7
03e4  +0x05d60  op=b4  09 05 05 02  ADD32            s5 = int32(s9 + s5)
03e5  +0x05d78  op=52  1e 09 6c 01  LD32S            s9 = *(int32_t *)(s30 +0x16c)
03e6  +0x05d90  op=2e  10 05 05 09  ROR32_IMM        s5 = ror32((uint32_t)s5, 9)
03e7  +0x05da8  op=b4  05 07 05 00  ADD32            s5 = int32(s5 + s7)
03e8  +0x05dc0  op=02  06 05 06 01  XOR64            s6 = s5 ^ s6
03e9  +0x05dd8  op=b4  01 06 01 02  ADD32            s1 = int32(s1 + s6)
03ea  +0x05df0  op=52  1e 06 58 01  LD32S            s6 = *(int32_t *)(s30 +0x158)
03eb  +0x05e08  op=2e  01 01 01 1c  ROR32_IMM        s1 = ror32((uint32_t)s1, 28)
03ec  +0x05e20  op=b4  06 07 06 00  ADD32            s6 = int32(s6 + s7)
03ed  +0x05e38  op=b4  01 05 01 12  ADD32            s1 = int32(s1 + s5)
03ee  +0x05e50  op=02  05 07 07 01  XOR64            s7 = s7 ^ s5
03ef  +0x05e68  op=02  07 01 07 01  XOR64            s7 = s1 ^ s7
03f0  +0x05e80  op=b4  08 01 08 12  ADD32            s8 = int32(s8 + s1)
03f1  +0x05e98  op=b4  04 07 04 02  ADD32            s4 = int32(s4 + s7)
03f2  +0x05eb0  op=52  1e 07 c8 01  LD32S            s7 = *(int32_t *)(s30 +0x1c8)
03f3  +0x05ec8  op=2e  10 04 04 15  ROR32_IMM        s4 = ror32((uint32_t)s4, 21)
03f4  +0x05ee0  op=b4  07 0c 07 12  ADD32            s7 = int32(s7 + s12)
03f5  +0x05ef8  op=b4  04 01 04 12  ADD32            s4 = int32(s4 + s1)
03f6  +0x05f10  op=b4  07 05 07 02  ADD32            s7 = int32(s7 + s5)
03f7  +0x05f28  op=02  01 05 05 00  XOR64            s5 = s5 ^ s1
03f8  +0x05f40  op=02  04 01 01 01  XOR64            s1 = s1 ^ s4
03f9  +0x05f58  op=02  05 04 05 01  XOR64            s5 = s4 ^ s5
03fa  +0x05f70  op=b4  06 05 05 02  ADD32            s5 = int32(s6 + s5)
03fb  +0x05f88  op=52  1e 06 cc 01  LD32S            s6 = *(int32_t *)(s30 +0x1cc)
03fc  +0x05fa0  op=2e  12 05 05 10  ROR32_IMM        s5 = ror32((uint32_t)s5, 16)
03fd  +0x05fb8  op=b4  05 04 05 12  ADD32            s5 = int32(s5 + s4)
03fe  +0x05fd0  op=b4  06 0f 06 00  ADD32            s6 = int32(s6 + s15)
03ff  +0x05fe8  op=02  01 05 01 01  XOR64            s1 = s5 ^ s1
0400  +0x06000  op=b4  06 05 06 02  ADD32            s6 = int32(s6 + s5)
0401  +0x06018  op=b4  07 01 01 00  ADD32            s1 = int32(s7 + s1)
0402  +0x06030  op=52  1e 07 60 01  LD32S            s7 = *(int32_t *)(s30 +0x160)
0403  +0x06048  op=2e  10 01 01 09  ROR32_IMM        s1 = ror32((uint32_t)s1, 9)
0404  +0x06060  op=b4  07 04 07 02  ADD32            s7 = int32(s7 + s4)
0405  +0x06078  op=b4  01 05 01 12  ADD32            s1 = int32(s1 + s5)
0406  +0x06090  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
0407  +0x060a8  op=02  04 01 04 00  XOR64            s4 = s1 ^ s4
0408  +0x060c0  op=02  01 05 05 00  XOR64            s5 = s5 ^ s1
0409  +0x060d8  op=b4  08 04 04 00  ADD32            s4 = int32(s8 + s4)
040a  +0x060f0  op=52  1e 08 ec 01  LD32S            s8 = *(int32_t *)(s30 +0x1ec)
040b  +0x06108  op=2e  12 04 04 1c  ROR32_IMM        s4 = ror32((uint32_t)s4, 28)
040c  +0x06120  op=b4  04 01 04 00  ADD32            s4 = int32(s4 + s1)
040d  +0x06138  op=02  05 04 05 00  XOR64            s5 = s4 ^ s5
040e  +0x06150  op=b4  07 05 05 02  ADD32            s5 = int32(s7 + s5)
040f  +0x06168  op=02  04 01 07 01  XOR64            s7 = s1 ^ s4
0410  +0x06180  op=b4  09 01 01 12  ADD32            s1 = int32(s9 + s1)
0411  +0x06198  op=2e  12 05 05 15  ROR32_IMM        s5 = ror32((uint32_t)s5, 21)
0412  +0x061b0  op=b4  05 04 05 00  ADD32            s5 = int32(s5 + s4)
0413  +0x061c8  op=02  07 05 07 01  XOR64            s7 = s5 ^ s7
0414  +0x061e0  op=36  05 00 09 01  NOR64            s9 = ~(s5 | s0)
0415  +0x061f8  op=b4  06 07 06 00  ADD32            s6 = int32(s6 + s7)
0416  +0x06210  op=02  05 04 07 01  XOR64            s7 = s4 ^ s5
0417  +0x06228  op=b4  04 0b 04 02  ADD32            s4 = int32(s4 + s11)
0418  +0x06240  op=52  1e 0b e0 01  LD32S            s11 = *(int32_t *)(s30 +0x1e0)
0419  +0x06258  op=2e  12 06 06 10  ROR32_IMM        s6 = ror32((uint32_t)s6, 16)
041a  +0x06270  op=b4  06 05 06 12  ADD32            s6 = int32(s6 + s5)
041b  +0x06288  op=b4  05 0c 05 02  ADD32            s5 = int32(s5 + s12)
041c  +0x062a0  op=02  07 06 07 01  XOR64            s7 = s6 ^ s7
041d  +0x062b8  op=b4  01 07 01 12  ADD32            s1 = int32(s1 + s7)
041e  +0x062d0  op=52  1e 07 e4 01  LD32S            s7 = *(int32_t *)(s30 +0x1e4)
041f  +0x062e8  op=2e  01 01 01 09  ROR32_IMM        s1 = ror32((uint32_t)s1, 9)
0420  +0x06300  op=b4  01 06 01 02  ADD32            s1 = int32(s1 + s6)
0421  +0x06318  op=b4  05 07 05 02  ADD32            s5 = int32(s5 + s7)
0422  +0x06330  op=34  01 09 07 01  OR64             s7 = s1 | s9
0423  +0x06348  op=b4  01 0e 09 00  ADD32            s9 = int32(s1 + s14)
0424  +0x06360  op=02  07 06 07 01  XOR64            s7 = s6 ^ s7
0425  +0x06378  op=b4  09 08 08 02  ADD32            s8 = int32(s9 + s8)
0426  +0x06390  op=52  1e 09 70 01  LD32S            s9 = *(int32_t *)(s30 +0x170)
0427  +0x063a8  op=b4  04 07 04 12  ADD32            s4 = int32(s4 + s7)
0428  +0x063c0  op=36  01 00 07 01  NOR64            s7 = ~(s1 | s0)
0429  +0x063d8  op=b4  04 0b 04 02  ADD32            s4 = int32(s4 + s11)
042a  +0x063f0  op=36  06 00 0b 00  NOR64            s11 = ~(s6 | s0)
042b  +0x06408  op=b4  06 0f 06 00  ADD32            s6 = int32(s6 + s15)
042c  +0x06420  op=2e  12 04 04 1a  ROR32_IMM        s4 = ror32((uint32_t)s4, 26)
042d  +0x06438  op=b4  06 0a 06 00  ADD32            s6 = int32(s6 + s10)
042e  +0x06450  op=b4  04 01 04 02  ADD32            s4 = int32(s4 + s1)
042f  +0x06468  op=34  04 0b 0a 00  OR64             s10 = s4 | s11
0430  +0x06480  op=02  0a 01 01 01  XOR64            s1 = s1 ^ s10
0431  +0x06498  op=b4  05 01 01 02  ADD32            s1 = int32(s5 + s1)
0432  +0x064b0  op=2e  12 01 01 16  ROR32_IMM        s1 = ror32((uint32_t)s1, 22)
0433  +0x064c8  op=b4  01 04 01 02  ADD32            s1 = int32(s1 + s4)
0434  +0x064e0  op=34  01 07 05 01  OR64             s5 = s1 | s7
0435  +0x064f8  op=36  04 00 07 00  NOR64            s7 = ~(s4 | s0)
0436  +0x06510  op=02  05 04 05 01  XOR64            s5 = s4 ^ s5
0437  +0x06528  op=b4  09 04 04 12  ADD32            s4 = int32(s9 + s4)
0438  +0x06540  op=52  1e 09 78 01  LD32S            s9 = *(int32_t *)(s30 +0x178)
0439  +0x06558  op=b4  06 05 05 12  ADD32            s5 = int32(s6 + s5)
043a  +0x06570  op=2e  12 05 05 11  ROR32_IMM        s5 = ror32((uint32_t)s5, 17)
043b  +0x06588  op=b4  05 01 05 02  ADD32            s5 = int32(s5 + s1)
043c  +0x065a0  op=34  05 07 06 01  OR64             s6 = s5 | s7
043d  +0x065b8  op=36  01 00 07 00  NOR64            s7 = ~(s1 | s0)
043e  +0x065d0  op=02  06 01 06 01  XOR64            s6 = s1 ^ s6
043f  +0x065e8  op=b4  09 01 01 02  ADD32            s1 = int32(s9 + s1)
0440  +0x06600  op=52  1e 09 7c 01  LD32S            s9 = *(int32_t *)(s30 +0x17c)
0441  +0x06618  op=b4  08 06 06 00  ADD32            s6 = int32(s8 + s6)
0442  +0x06630  op=36  05 00 08 01  NOR64            s8 = ~(s5 | s0)
0443  +0x06648  op=2e  10 06 06 0b  ROR32_IMM        s6 = ror32((uint32_t)s6, 11)
0444  +0x06660  op=b4  06 05 06 02  ADD32            s6 = int32(s6 + s5)
0445  +0x06678  op=34  06 07 07 01  OR64             s7 = s6 | s7
0446  +0x06690  op=02  07 05 07 01  XOR64            s7 = s5 ^ s7
0447  +0x066a8  op=b4  14 05 05 12  ADD32            s5 = int32(s20 + s5)
0448  +0x066c0  op=b4  04 07 04 12  ADD32            s4 = int32(s4 + s7)
0449  +0x066d8  op=2e  12 04 04 1a  ROR32_IMM        s4 = ror32((uint32_t)s4, 26)
044a  +0x066f0  op=b4  04 06 04 12  ADD32            s4 = int32(s4 + s6)
044b  +0x06708  op=34  04 08 07 01  OR64             s7 = s4 | s8
044c  +0x06720  op=36  06 00 08 01  NOR64            s8 = ~(s6 | s0)
044d  +0x06738  op=02  07 06 07 00  XOR64            s7 = s6 ^ s7
044e  +0x06750  op=b4  09 06 06 02  ADD32            s6 = int32(s9 + s6)
044f  +0x06768  op=52  1e 09 80 01  LD32S            s9 = *(int32_t *)(s30 +0x180)
0450  +0x06780  op=b4  01 07 01 02  ADD32            s1 = int32(s1 + s7)
0451  +0x06798  op=2e  12 01 01 16  ROR32_IMM        s1 = ror32((uint32_t)s1, 22)
0452  +0x067b0  op=b4  01 04 01 00  ADD32            s1 = int32(s1 + s4)
0453  +0x067c8  op=34  01 08 07 00  OR64             s7 = s1 | s8
0454  +0x067e0  op=36  04 00 08 01  NOR64            s8 = ~(s4 | s0)
0455  +0x067f8  op=02  07 04 07 01  XOR64            s7 = s4 ^ s7
0456  +0x06810  op=b4  09 04 04 00  ADD32            s4 = int32(s9 + s4)
0457  +0x06828  op=b4  05 07 05 02  ADD32            s5 = int32(s5 + s7)
0458  +0x06840  op=2e  01 05 05 11  ROR32_IMM        s5 = ror32((uint32_t)s5, 17)
0459  +0x06858  op=b4  05 01 05 02  ADD32            s5 = int32(s5 + s1)
045a  +0x06870  op=34  05 08 07 01  OR64             s7 = s5 | s8
045b  +0x06888  op=36  01 00 08 01  NOR64            s8 = ~(s1 | s0)
045c  +0x068a0  op=02  07 01 07 01  XOR64            s7 = s1 ^ s7
045d  +0x068b8  op=b4  03 01 01 12  ADD32            s1 = int32(s3 + s1)
045e  +0x068d0  op=b4  06 07 03 00  ADD32            s3 = int32(s6 + s7)
045f  +0x068e8  op=36  05 00 07 01  NOR64            s7 = ~(s5 | s0)
0460  +0x06900  op=2e  10 03 03 0b  ROR32_IMM        s3 = ror32((uint32_t)s3, 11)
0461  +0x06918  op=b4  03 05 03 00  ADD32            s3 = int32(s3 + s5)
0462  +0x06930  op=34  03 08 06 01  OR64             s6 = s3 | s8
0463  +0x06948  op=52  1e 08 8c 01  LD32S            s8 = *(int32_t *)(s30 +0x18c)
0464  +0x06960  op=b4  02 03 02 00  ADD32            s2 = int32(s2 + s3)
0465  +0x06978  op=02  06 05 06 01  XOR64            s6 = s5 ^ s6
0466  +0x06990  op=b4  04 06 04 12  ADD32            s4 = int32(s4 + s6)
0467  +0x069a8  op=b4  08 05 05 02  ADD32            s5 = int32(s8 + s5)
0468  +0x069c0  op=58  1e 08 d0 01  LD64             s8 = *(uint64_t *)(s30 +0x1d0)
0469  +0x069d8  op=2e  12 04 04 1a  ROR32_IMM        s4 = ror32((uint32_t)s4, 26)
046a  +0x069f0  op=b4  04 03 04 00  ADD32            s4 = int32(s4 + s3)
046b  +0x06a08  op=34  04 07 06 01  OR64             s6 = s4 | s7
046c  +0x06a20  op=36  03 00 07 01  NOR64            s7 = ~(s3 | s0)
046d  +0x06a38  op=02  06 03 06 01  XOR64            s6 = s3 ^ s6
046e  +0x06a50  op=b4  01 06 01 02  ADD32            s1 = int32(s1 + s6)
046f  +0x06a68  op=36  04 00 06 00  NOR64            s6 = ~(s4 | s0)
0470  +0x06a80  op=2e  01 01 01 16  ROR32_IMM        s1 = ror32((uint32_t)s1, 22)
0471  +0x06a98  op=b4  01 04 01 02  ADD32            s1 = int32(s1 + s4)
0472  +0x06ab0  op=34  01 07 03 01  OR64             s3 = s1 | s7
0473  +0x06ac8  op=52  1e 07 a0 01  LD32S            s7 = *(int32_t *)(s30 +0x1a0)
0474  +0x06ae0  op=02  03 04 03 00  XOR64            s3 = s4 ^ s3
0475  +0x06af8  op=b4  05 03 03 02  ADD32            s3 = int32(s5 + s3)
0476  +0x06b10  op=b4  07 04 04 12  ADD32            s4 = int32(s7 + s4)
0477  +0x06b28  op=52  1e 07 a8 01  LD32S            s7 = *(int32_t *)(s30 +0x1a8)
0478  +0x06b40  op=2e  01 03 03 11  ROR32_IMM        s3 = ror32((uint32_t)s3, 17)
0479  +0x06b58  op=b4  03 01 03 02  ADD32            s3 = int32(s3 + s1)
047a  +0x06b70  op=34  03 06 05 01  OR64             s5 = s3 | s6
047b  +0x06b88  op=36  01 00 06 01  NOR64            s6 = ~(s1 | s0)
047c  +0x06ba0  op=02  05 01 05 00  XOR64            s5 = s1 ^ s5
047d  +0x06bb8  op=b4  15 01 01 00  ADD32            s1 = int32(s21 + s1)
047e  +0x06bd0  op=b4  02 05 02 00  ADD32            s2 = int32(s2 + s5)
047f  +0x06be8  op=2e  10 02 02 0b  ROR32_IMM        s2 = ror32((uint32_t)s2, 11)
0480  +0x06c00  op=b4  02 03 02 12  ADD32            s2 = int32(s2 + s3)
0481  +0x06c18  op=34  02 06 05 01  OR64             s5 = s2 | s6
0482  +0x06c30  op=36  03 00 06 01  NOR64            s6 = ~(s3 | s0)
0483  +0x06c48  op=02  05 03 05 01  XOR64            s5 = s3 ^ s5
0484  +0x06c60  op=b4  07 03 03 00  ADD32            s3 = int32(s7 + s3)
0485  +0x06c78  op=36  02 00 07 01  NOR64            s7 = ~(s2 | s0)
0486  +0x06c90  op=b4  04 05 04 00  ADD32            s4 = int32(s4 + s5)
0487  +0x06ca8  op=2e  10 04 04 1a  ROR32_IMM        s4 = ror32((uint32_t)s4, 26)
0488  +0x06cc0  op=b4  04 02 04 02  ADD32            s4 = int32(s4 + s2)
0489  +0x06cd8  op=34  04 06 05 01  OR64             s5 = s4 | s6
048a  +0x06cf0  op=52  1e 06 dc 01  LD32S            s6 = *(int32_t *)(s30 +0x1dc)
048b  +0x06d08  op=02  05 02 05 01  XOR64            s5 = s2 ^ s5
048c  +0x06d20  op=b4  01 05 01 02  ADD32            s1 = int32(s1 + s5)
048d  +0x06d38  op=b4  04 06 06 12  ADD32            s6 = int32(s4 + s6)
048e  +0x06d50  op=2e  12 01 01 16  ROR32_IMM        s1 = ror32((uint32_t)s1, 22)
048f  +0x06d68  op=08  08 06 08 00  ST32             *(s8 +0x8) = (uint32_t)s6
0490  +0x06d80  op=52  1e 06 b4 01  LD32S            s6 = *(int32_t *)(s30 +0x1b4)
0491  +0x06d98  op=b4  01 04 01 00  ADD32            s1 = int32(s1 + s4)
0492  +0x06db0  op=34  01 07 05 00  OR64             s5 = s1 | s7
0493  +0x06dc8  op=b4  06 02 02 00  ADD32            s2 = int32(s6 + s2)
0494  +0x06de0  op=52  1e 06 c0 01  LD32S            s6 = *(int32_t *)(s30 +0x1c0)
0495  +0x06df8  op=02  05 04 05 01  XOR64            s5 = s4 ^ s5
0496  +0x06e10  op=36  04 00 04 01  NOR64            s4 = ~(s4 | s0)
0497  +0x06e28  op=b4  03 05 03 00  ADD32            s3 = int32(s3 + s5)
0498  +0x06e40  op=52  1e 05 90 01  LD32S            s5 = *(int32_t *)(s30 +0x190)
0499  +0x06e58  op=b4  01 06 06 02  ADD32            s6 = int32(s1 + s6)
049a  +0x06e70  op=2e  12 03 03 11  ROR32_IMM        s3 = ror32((uint32_t)s3, 17)
049b  +0x06e88  op=08  08 06 14 00  ST32             *(s8 +0x14) = (uint32_t)s6
049c  +0x06ea0  op=b4  03 01 03 00  ADD32            s3 = int32(s3 + s1)
049d  +0x06eb8  op=b4  03 05 05 02  ADD32            s5 = int32(s3 + s5)
049e  +0x06ed0  op=08  08 05 10 00  ST32             *(s8 +0x10) = (uint32_t)s5
049f  +0x06ee8  op=52  1e 05 d8 01  LD32S            s5 = *(int32_t *)(s30 +0x1d8)
04a0  +0x06f00  op=b4  03 05 05 00  ADD32            s5 = int32(s3 + s5)
04a1  +0x06f18  op=34  03 04 03 01  OR64             s3 = s3 | s4
04a2  +0x06f30  op=02  03 01 01 00  XOR64            s1 = s1 ^ s3
04a3  +0x06f48  op=b4  02 01 01 00  ADD32            s1 = int32(s2 + s1)
04a4  +0x06f60  op=2e  12 01 01 0b  ROR32_IMM        s1 = ror32((uint32_t)s1, 11)
04a5  +0x06f78  op=b4  05 01 01 02  ADD32            s1 = int32(s5 + s1)
04a6  +0x06f90  op=08  08 01 0c 00  ST32             *(s8 +0xc) = (uint32_t)s1
04a7  +0x06fa8  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
04a8  +0x06fc0  op=58  1d 10 e0 02  LD64             s16 = *(uint64_t *)(s29 +0x2e0)
04a9  +0x06fd8  op=58  1d 11 e8 02  LD64             s17 = *(uint64_t *)(s29 +0x2e8)
04aa  +0x06ff0  op=58  1d 12 f0 02  LD64             s18 = *(uint64_t *)(s29 +0x2f0)
04ab  +0x07008  op=58  1d 13 f8 02  LD64             s19 = *(uint64_t *)(s29 +0x2f8)
04ac  +0x07020  op=58  1d 14 00 03  LD64             s20 = *(uint64_t *)(s29 +0x300)
04ad  +0x07038  op=58  1d 15 08 03  LD64             s21 = *(uint64_t *)(s29 +0x308)
04ae  +0x07050  op=58  1d 16 10 03  LD64             s22 = *(uint64_t *)(s29 +0x310)
04af  +0x07068  op=58  1d 17 18 03  LD64             s23 = *(uint64_t *)(s29 +0x318)
04b0  +0x07080  op=58  1d 1e 20 03  LD64             s30 = *(uint64_t *)(s29 +0x320)
04b1  +0x07098  op=58  1d 1f 28 03  LD64             s31 = *(uint64_t *)(s29 +0x328)
04b2  +0x070b0  op=85  1d 1d 30 03  ADD64_IMM16      s29 = s29 +0x330
04b3  +0x070c8  op=5b  1f 00 00 00  RET              return/leave with s31

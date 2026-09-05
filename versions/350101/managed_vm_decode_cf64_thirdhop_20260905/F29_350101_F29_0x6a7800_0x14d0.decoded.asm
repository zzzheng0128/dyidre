; MetaSec managed bytecode decode: F29
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F29_0x6a7800_0x14d0.bin
; records: 222  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 90 fe  ADD64_IMM16      s29 = s29 -0x170 ; q1=0xffff180d001f1d2a
0001  +0x00018  op=25  1d 1f 68 01  ST64             *(s29 +0x168) = s31 ; q1=0x80d00171d3f
0002  +0x00030  op=25  1d 1e 60 01  ST64             *(s29 +0x160) = s30 ; q1=0x380c00151d2a
0003  +0x00048  op=25  1d 17 58 01  ST64             *(s29 +0x158) = s23 ; q1=0x280c00131d2a
0004  +0x00060  op=25  1d 16 50 01  ST64             *(s29 +0x150) = s22 ; q1=0x180c00111d1a
0005  +0x00078  op=25  1d 15 48 01  ST64             *(s29 +0x148) = s21 ; q1=0x20030001041b
0006  +0x00090  op=25  1d 14 40 01  ST64             *(s29 +0x140) = s20 ; q1=0x10003001d
0007  +0x000a8  op=25  1d 13 38 01  ST64             *(s29 +0x138) = s19 ; q1=0x300011d3f
0008  +0x000c0  op=25  1d 12 30 01  ST64             *(s29 +0x130) = s18 ; q1=0x380200011d3f
0009  +0x000d8  op=25  1d 11 28 01  ST64             *(s29 +0x128) = s17 ; q1=0x300200011d2a
000a  +0x000f0  op=25  1d 10 20 01  ST64             *(s29 +0x120) = s16 ; q1=0x280200011d2a
000b  +0x00108  op=34  1d 00 1e 00  OR64             s30 = s29 | s0 ; q1=0x180200011d3f
000c  +0x00120  op=85  00 13 00 01  ADD64_IMM16      s19 = s0 +0x100 ; q1=0x100200011d3f
000d  +0x00138  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0 ; q1=0x80200011d2a
000e  +0x00150  op=85  1e 11 00 00  ADD64_IMM16      s17 = s30 +0x0 ; q1=0x200011d1a
000f  +0x00168  op=34  05 00 14 01  OR64             s20 = s5 | s0 ; q1=0x40102042c
0010  +0x00180  op=34  04 00 10 01  OR64             s16 = s4 | s0 ; q1=0x8000002021d
0011  +0x00198  op=25  1e 00 18 01  ST64             *(s30 +0x118) = s0 ; q1=0x100000d0124
0012  +0x001b0  op=25  1e 00 10 01  ST64             *(s30 +0x110) = s0 ; q1=0x3c100d0d0000
0013  +0x001c8  op=25  1e 00 08 01  ST64             *(s30 +0x108) = s0 ; q1=0x200000d0124
0014  +0x001e0  op=25  1e 00 00 01  ST64             *(s30 +0x100) = s0 ; q1=0x25000c0d0c00
0015  +0x001f8  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x3c000d0d0000
0016  +0x00210  op=34  12 00 05 01  OR64             s5 = s18 | s0 ; q1=0x400000d0124
0017  +0x00228  op=34  13 00 06 01  OR64             s6 = s19 | s0 ; q1=0x25000c0d0c00
0018  +0x00240  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0019  +0x00258  op=18  00 14 03 00  SHL32_IMM        s3 = (int32_t)(s20 << 0) ; q1=0x700000d0124
001a  +0x00270  op=b5  00 02 00 ff  ADD32_IMM16      s2 = int32(s0 -0x100) ; q1=0x380801010000
001b  +0x00288  op=53  03 04 a1 00  LD_POOL_PTR      s4 = *(uint64_t *)q1 + 0xa1 ; q1=0x125fd3a8 rt/so-mapped
001c  +0x002a0  op=34  03 00 05 00  OR64             s5 = s3 | s0 ; q1=0x251f1f030218
001d  +0x002b8  op=ae  12 13 0f 00  BR_EQ64          if (s18 == s19) goto record +45 ; q1=0x100b00011d1e
001e  +0x002d0  op=10  00 05 01 1f  ASR32_IMM        s1 = sign_extend_32((int32_t)s5 >> 31) ; q1=0x300100030437
001f  +0x002e8  op=84  11 12 06 00  ADD64            s6 = s17 + s18 ; q1=0x2000b0437
0020  +0x00300  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1 ; q1=0x1002000f041e
0021  +0x00318  op=0e  0d 01 01 18  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 24) ; q1=0x200b00061d1b
0022  +0x00330  op=b4  05 01 01 00  ADD32            s1 = int32(s5 + s1) ; q1=0xc000e1d37
0023  +0x00348  op=b3  01 02 01 01  AND64            s1 = s1 & s2 ; q1=0x18020018041b
0024  +0x00360  op=09  05 01 01 04  SUB32            s1 = sign_extend_32((uint32_t)s5 - (uint32_t)s1) ; q1=0x300b00191d1b
0025  +0x00378  op=b5  05 05 01 00  ADD32_IMM16      s5 = int32(s5 +0x1) ; q1=0x300300040419
0026  +0x00390  op=84  04 01 01 14  ADD64            s1 = s4 + s1 ; q1=0x180b00021d37
0027  +0x003a8  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x260001011300
0028  +0x003c0  op=0e  00 01 07 01  LSR32_IMM        s7 = sign_extend_32((uint32_t)s1 >> 1) ; q1=0x80000191d2a
0029  +0x003d8  op=18  00 01 01 07  SHL32_IMM        s1 = (int32_t)(s1 << 7) ; q1=0x2d010a0d0b2c
002a  +0x003f0  op=34  01 07 01 01  OR64             s1 = s1 | s7 ; q1=0x1d010d0e053e
002b  +0x00408  op=26  06 01 00 00  ST8              *(s6 +0x0) = (uint8_t)s1 ; q1=0x1d010e0c083e
002c  +0x00420  op=a7  12 13 f1 ff  BR_NE64          if (s18 != s19) goto record +30 ; q1=0x260019061800
002d  +0x00438  op=85  00 09 00 00  ADD64_IMM16      s9 = s0 +0x0 ; q1=0x26000c101e00
002e  +0x00450  op=85  00 04 10 00  ADD64_IMM16      s4 = s0 +0x10 ; q1=0x1f010600182c
002f  +0x00468  op=b5  00 06 f0 ff  ADD32_IMM16      s6 = int32(s0 -0x10) ; q1=0x2000000f1d3f
0030  +0x00480  op=85  1e 02 00 01  ADD64_IMM16      s2 = s30 +0x100 ; q1=0x300100081d2a
0031  +0x00498  op=85  1e 05 10 01  ADD64_IMM16      s5 = s30 +0x110 ; q1=0x80b00031d2a
0032  +0x004b0  op=53  03 07 a1 06  LD_POOL_PTR      s7 = *(uint64_t *)q1 + 0x6a1 ; q1=0x125fd3a8 rt/so-mapped
0033  +0x004c8  op=53  01 08 b1 06  LD_POOL_PTR      s8 = *(uint64_t *)q1 + 0x6b1 ; q1=0x125fd3a8 rt/so-mapped
0034  +0x004e0  op=ae  09 04 17 00  BR_EQ64          if (s9 == s4) goto record +76 ; q1=0x250010000100
0035  +0x004f8  op=10  0e 03 01 1f  ASR32_IMM        s1 = sign_extend_32((int32_t)s3 >> 31) ; q1=0x280100021d1a
0036  +0x00510  op=84  02 09 0b 04  ADD64            s11 = s2 + s9 ; q1=0x280a00011d37
0037  +0x00528  op=85  09 0a 01 00  ADD64_IMM16      s10 = s9 +0x1 ; q1=0x110d00020104
0038  +0x00540  op=84  05 09 09 14  ADD64            s9 = s5 + s9 ; q1=0x3e0d0b080000
0039  +0x00558  op=0e  0d 01 01 1c  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 28) ; q1=0x2006000d1d3f
003a  +0x00570  op=b4  03 01 01 02  ADD32            s1 = int32(s3 + s1) ; q1=0x2001f1d1e
003b  +0x00588  op=b3  01 06 01 01  AND64            s1 = s1 & s6 ; q1=0x600111d2a
003c  +0x005a0  op=09  03 01 01 14  SUB32            s1 = sign_extend_32((uint32_t)s3 - (uint32_t)s1) ; q1=0x100500191d2a
003d  +0x005b8  op=b5  03 03 01 00  ADD32_IMM16      s3 = int32(s3 +0x1) ; q1=0x3e0d04070000
003e  +0x005d0  op=84  08 01 0c 14  ADD64            s12 = s8 + s1 ; q1=0x3e050f070000
003f  +0x005e8  op=84  07 01 01 04  ADD64            s1 = s7 + s1 ; q1=0x100200071d1b
0040  +0x00600  op=59  0c 0c 00 00  LD8U             s12 = *(uint8_t *)(s12 +0x0) ; q1=0x7000e1d2a
0041  +0x00618  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x3e0d16130000
0042  +0x00630  op=0e  0d 0c 0d 01  LSR32_IMM        s13 = sign_extend_32((uint32_t)s12 >> 1) ; q1=0x3e1514080000
0043  +0x00648  op=18  10 0c 0c 07  SHL32_IMM        s12 = (int32_t)(s12 << 7) ; q1=0x180a00081d2a
0044  +0x00660  op=34  0c 0d 0c 01  OR64             s12 = s12 | s13 ; q1=0x3e0d101e0000
0045  +0x00678  op=26  0b 0c 00 00  ST8              *(s11 +0x0) = (uint8_t)s12 ; q1=0x381f000b0b0c
0046  +0x00690  op=0e  0d 01 0b 01  LSR32_IMM        s11 = sign_extend_32((uint32_t)s1 >> 1) ; q1=0x381f0019190c
0047  +0x006a8  op=18  10 01 01 07  SHL32_IMM        s1 = (int32_t)(s1 << 7) ; q1=0x381f00121222
0048  +0x006c0  op=34  01 0b 01 01  OR64             s1 = s1 | s11 ; q1=0x381f000f0f22
0049  +0x006d8  op=26  09 01 00 00  ST8              *(s9 +0x0) = (uint8_t)s1 ; q1=0x381f00161622
004a  +0x006f0  op=34  0a 00 09 01  OR64             s9 = s10 | s0 ; q1=0x381f00101022
004b  +0x00708  op=a7  09 04 e9 ff  BR_NE64          if (s9 != s4) goto record +53 ; q1=0x2f010500033e
004c  +0x00720  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0 ; q1=0x2d000b0b0a00
004d  +0x00738  op=ae  03 04 09 00  BR_EQ64          if (s3 == s4) goto record +87 ; q1=0x2d0011110a00
004e  +0x00750  op=84  05 03 01 14  ADD64            s1 = s5 + s3 ; q1=0x301404040a3e
004f  +0x00768  op=84  02 03 06 04  ADD64            s6 = s2 + s3 ; q1=0x40e0e072c
0050  +0x00780  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x301416160a3e
0051  +0x00798  op=59  06 06 00 00  LD8U             s6 = *(uint8_t *)(s6 +0x0) ; q1=0x2d0018181f00
0052  +0x007b0  op=02  06 01 01 01  XOR64            s1 = s1 ^ s6 ; q1=0xb0b1e
0053  +0x007c8  op=84  10 03 06 00  ADD64            s6 = s16 + s3 ; q1=0x381f0001010c
0054  +0x007e0  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1 ; q1=0x19191b
0055  +0x007f8  op=26  06 01 00 00  ST8              *(s6 +0x0) = (uint8_t)s1 ; q1=0x4041e
0056  +0x00810  op=a7  03 04 f7 ff  BR_NE64          if (s3 != s4) goto record +78 ; q1=0xe0e1b
0057  +0x00828  op=85  00 04 fe 00  ADD64_IMM16      s4 = s0 +0xfe ; q1=0x16161b
0058  +0x00840  op=85  10 05 0b 00  ADD64_IMM16      s5 = s16 +0xb ; q1=0x18181b
0059  +0x00858  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0 ; q1=0x3e150d030000
005a  +0x00870  op=b5  00 0d 00 00  ADD32_IMM16      s13 = int32(s0 +0x0) ; q1=0x401010a2c
005b  +0x00888  op=b5  00 06 f8 07  ADD32_IMM16      s6 = int32(s0 +0x7f8) ; q1=0x3e0517030000
005c  +0x008a0  op=34  04 00 07 01  OR64             s7 = s4 | s0 ; q1=0x1f010300132c
005d  +0x008b8  op=ae  03 04 73 00  BR_EQ64          if (s3 == s4) goto record +209 ; q1=0x381f000c0c0c
005e  +0x008d0  op=85  03 19 02 00  ADD64_IMM16      s25 = s3 +0x2 ; q1=0x381f00171722
005f  +0x008e8  op=59  05 08 03 00  LD8U             s8 = *(uint8_t *)(s5 +0x3) ; q1=0x2021b
0060  +0x00900  op=59  05 0a 01 00  LD8U             s10 = *(uint8_t *)(s5 +0x1) ; q1=0x381f00131322
0061  +0x00918  op=59  05 0b ff ff  LD8U             s11 = *(uint8_t *)(s5 -0x1) ; q1=0x2d010412042c
0062  +0x00930  op=59  05 09 04 00  LD8U             s9 = *(uint8_t *)(s5 +0x4) ; q1=0x191d1606133e
0063  +0x00948  op=59  05 0c 00 00  LD8U             s12 = *(uint8_t *)(s5 +0x0) ; q1=0x3e0510090000
0064  +0x00960  op=59  05 0f 02 00  LD8U             s15 = *(uint8_t *)(s5 +0x2) ; q1=0x300a00031d3f
0065  +0x00978  op=59  05 0e fd ff  LD8U             s14 = *(uint8_t *)(s5 -0x3) ; q1=0x41717072c
0066  +0x00990  op=59  05 18 fe ff  LD8U             s24 = *(uint8_t *)(s5 -0x2) ; q1=0x2600040e0400
0067  +0x009a8  op=84  11 03 12 00  ADD64            s18 = s17 + s3 ; q1=0xc0c1e
0068  +0x009c0  op=b2  19 01 03 00  AND64_IMM16      s1 = s25 & 0x3 ; q1=0x381f0010100c
0069  +0x009d8  op=a7  01 00 1d 00  BR_NE64          if (s1 != s0) goto record +135 ; q1=0x380a00091d3f
006a  +0x009f0  op=b2  08 01 ff 00  AND64_IMM16      s1 = s8 & 0xff ; q1=0x1d010102013e
006b  +0x00a08  op=b2  09 13 ff 00  AND64_IMM16      s19 = s9 & 0xff ; q1=0x17171b
006c  +0x00a20  op=b2  0f 09 ff 00  AND64_IMM16      s9 = s15 & 0xff ; q1=0x30141010073e
006d  +0x00a38  op=59  12 0f 02 00  LD8U             s15 = *(uint8_t *)(s18 +0x2) ; q1=0x381f0002020c
006e  +0x00a50  op=b2  0a 0a ff 00  AND64_IMM16      s10 = s10 & 0xff ; q1=0x1d010b0d0b3e
006f  +0x00a68  op=b2  0c 0c ff 00  AND64_IMM16      s12 = s12 & 0xff ; q1=0xb00151d1e
0070  +0x00a80  op=b2  0b 0b ff 00  AND64_IMM16      s11 = s11 & 0xff ; q1=0x1d010117013e
0071  +0x00a98  op=b2  0e 08 ff 00  AND64_IMM16      s8 = s14 & 0xff ; q1=0x180200081d1b
0072  +0x00ab0  op=b2  18 0e ff 00  AND64_IMM16      s14 = s24 & 0xff ; q1=0x3e0513050000
0073  +0x00ac8  op=84  11 01 01 00  ADD64            s1 = s17 + s1 ; q1=0x2021b
0074  +0x00ae0  op=84  11 09 14 04  ADD64            s20 = s17 + s9 ; q1=0x381f00131322
0075  +0x00af8  op=84  11 08 08 04  ADD64            s8 = s17 + s8 ; q1=0x2d000d0d0a00
0076  +0x00b10  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x2f0117001e3e
0077  +0x00b28  op=59  08 08 00 00  LD8U             s8 = *(uint8_t *)(s8 +0x0) ; q1=0x41313072c
0078  +0x00b40  op=02  0f 01 09 00  XOR64            s9 = s1 ^ s15 ; q1=0x30140e0e083e
0079  +0x00b58  op=84  11 0a 0f 14  ADD64            s15 = s17 + s10 ; q1=0xd0d1b
007a  +0x00b70  op=84  11 0c 0a 04  ADD64            s10 = s17 + s12 ; q1=0x191d0b05133e
007b  +0x00b88  op=84  11 07 0c 04  ADD64            s12 = s17 + s7 ; q1=0x280200051d1e
007c  +0x00ba0  op=84  11 0b 01 00  ADD64            s1 = s17 + s11 ; q1=0x16161b
007d  +0x00bb8  op=84  11 0e 0b 14  ADD64            s11 = s17 + s14 ; q1=0x100400171d2a
007e  +0x00bd0  op=59  0a 0a 00 00  LD8U             s10 = *(uint8_t *)(s10 +0x0) ; q1=0x381f000b0b0c
007f  +0x00be8  op=59  0c 0c 00 00  LD8U             s12 = *(uint8_t *)(s12 +0x0) ; q1=0x11111b
0080  +0x00c00  op=59  01 0e 00 00  LD8U             s14 = *(uint8_t *)(s1 +0x0) ; q1=0x381f0019190c
0081  +0x00c18  op=84  11 13 01 00  ADD64            s1 = s17 + s19 ; q1=0x3e0512150000
0082  +0x00c30  op=59  0b 0b 00 00  LD8U             s11 = *(uint8_t *)(s11 +0x0) ; q1=0x291d1303032c
0083  +0x00c48  op=02  0c 0a 18 01  XOR64            s24 = s10 ^ s12 ; q1=0x1f010200092c
0084  +0x00c60  op=59  0f 0c 00 00  LD8U             s12 = *(uint8_t *)(s15 +0x0) ; q1=0x19150f17133e
0085  +0x00c78  op=59  14 0a 00 00  LD8U             s10 = *(uint8_t *)(s20 +0x0) ; q1=0xb0b1b
0086  +0x00c90  op=59  01 0f 00 00  LD8U             s15 = *(uint8_t *)(s1 +0x0) ; q1=0x381f00131322
0087  +0x00ca8  op=b2  19 01 0f 00  AND64_IMM16      s1 = s25 & 0xf ; q1=0x1d010d110d3e
0088  +0x00cc0  op=18  00 19 19 00  SHL32_IMM        s25 = (int32_t)(s25 << 0) ; q1=0x19191b
0089  +0x00cd8  op=59  12 12 01 00  LD8U             s18 = *(uint8_t *)(s18 +0x1) ; q1=0x30140f0f053e
008a  +0x00cf0  op=85  07 07 ff ff  ADD64_IMM16      s7 = s7 -0x1 ; q1=0x2600040b0400
008b  +0x00d08  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1 ; q1=0x12121b
008c  +0x00d20  op=84  02 01 01 00  ADD64            s1 = s2 + s1 ; q1=0x1d010d100d3e
008d  +0x00d38  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x30141111073e
008e  +0x00d50  op=b4  01 19 13 02  ADD32            s19 = int32(s1 + s25) ; q1=0x11111e
008f  +0x00d68  op=b5  0d 19 08 00  ADD32_IMM16      s25 = int32(s13 +0x8) ; q1=0x2d010c120c2c
0090  +0x00d80  op=b4  0d 12 0d 02  ADD32            s13 = int32(s13 + s18) ; q1=0xb0b1e
0091  +0x00d98  op=85  05 01 08 00  ADD64_IMM16      s1 = s5 +0x8 ; q1=0x2d011111142c
0092  +0x00db0  op=b2  13 12 ff 00  AND64_IMM16      s18 = s19 & 0xff ; q1=0x300200031d1e
0093  +0x00dc8  op=84  11 12 12 00  ADD64            s18 = s17 + s18 ; q1=0x381f00141422
0094  +0x00de0  op=59  12 12 00 00  LD8U             s18 = *(uint8_t *)(s18 +0x0) ; q1=0x190d1106133e
0095  +0x00df8  op=02  0d 12 0d 01  XOR64            s13 = s18 ^ s13 ; q1=0x12121b
0096  +0x00e10  op=7e  0d 06 0d 04  REM_U32          s13 = (int32_t)((uint32_t)s6 == 0 ? (uint32_t)s13 : (uint32_t)s13 % (uint32_t)s6) ; q1=0x381f0011110c
0097  +0x00e28  op=b5  0d 16 07 00  ADD32_IMM16      s22 = int32(s13 +0x7) ; q1=0x190d1902133e
0098  +0x00e40  op=b5  0d 12 03 00  ADD32_IMM16      s18 = int32(s13 +0x3) ; q1=0x30141011033e
0099  +0x00e58  op=b5  0d 13 04 00  ADD32_IMM16      s19 = int32(s13 +0x4) ; q1=0x1915131e133e
009a  +0x00e70  op=b5  0d 14 05 00  ADD32_IMM16      s20 = int32(s13 +0x5) ; q1=0x180a00121d1b
009b  +0x00e88  op=b5  0d 15 06 00  ADD32_IMM16      s21 = int32(s13 +0x6) ; q1=0x381f00131322
009c  +0x00ea0  op=6d  00 16 16 00  SHL64_IMM32PLUS  s22 = s22 << (0 + 32) ; q1=0x101037
009d  +0x00eb8  op=6d  00 15 15 00  SHL64_IMM32PLUS  s21 = s21 << (0 + 32) ; q1=0x30141919033e
009e  +0x00ed0  op=6d  00 14 14 00  SHL64_IMM32PLUS  s20 = s20 << (0 + 32) ; q1=0x19151415133e
009f  +0x00ee8  op=6d  00 13 13 00  SHL64_IMM32PLUS  s19 = s19 << (0 + 32) ; q1=0x80b001e1d37
00a0  +0x00f00  op=6d  00 12 12 00  SHL64_IMM32PLUS  s18 = s18 << (0 + 32) ; q1=0x19191e
00a1  +0x00f18  op=6d  00 0d 17 00  SHL64_IMM32PLUS  s23 = s13 << (0 + 32) ; q1=0x13131e
00a2  +0x00f30  op=67  00 17 17 00  LSR64_IMM32PLUS  s23 = (uint64_t)s23 >> (0 + 32) ; q1=0x3a0510150000
00a3  +0x00f48  op=84  10 17 17 04  ADD64            s23 = s16 + s23 ; q1=0x29151106032c
00a4  +0x00f60  op=59  17 17 00 00  LD8U             s23 = *(uint8_t *)(s23 +0x0) ; q1=0x3a1d0e1e0000
00a5  +0x00f78  op=02  17 18 18 00  XOR64            s24 = s24 ^ s23 ; q1=0x381f0010100c
00a6  +0x00f90  op=26  05 18 05 00  ST8              *(s5 +0x5) = (uint8_t)s24 ; q1=0x381f000e0e0c
00a7  +0x00fa8  op=67  00 12 18 00  LSR64_IMM32PLUS  s24 = (uint64_t)s18 >> (0 + 32) ; q1=0x30141010063e
00a8  +0x00fc0  op=67  00 13 12 00  LSR64_IMM32PLUS  s18 = (uint64_t)s19 >> (0 + 32) ; q1=0x30140e0e083e
00a9  +0x00fd8  op=67  00 14 13 00  LSR64_IMM32PLUS  s19 = (uint64_t)s20 >> (0 + 32) ; q1=0x1d010414043e
00aa  +0x00ff0  op=67  00 15 14 00  LSR64_IMM32PLUS  s20 = (uint64_t)s21 >> (0 + 32) ; q1=0x290d1309032c
00ab  +0x01008  op=67  00 16 15 00  LSR64_IMM32PLUS  s21 = (uint64_t)s22 >> (0 + 32) ; q1=0x200600151d37
00ac  +0x01020  op=b5  0d 16 01 00  ADD32_IMM16      s22 = int32(s13 +0x1) ; q1=0x381f0013130c
00ad  +0x01038  op=b5  0d 0d 02 00  ADD32_IMM16      s13 = int32(s13 +0x2) ; q1=0x190d0e1e133e
00ae  +0x01050  op=6d  00 16 16 00  SHL64_IMM32PLUS  s22 = s22 << (0 + 32) ; q1=0x2005001e1d37
00af  +0x01068  op=84  10 18 18 04  ADD64            s24 = s16 + s24 ; q1=0x181337
00b0  +0x01080  op=84  10 12 12 04  ADD64            s18 = s16 + s18 ; q1=0x40e0e032c
00b1  +0x01098  op=84  10 13 13 04  ADD64            s19 = s16 + s19 ; q1=0x2d01020e042c
00b2  +0x010b0  op=84  10 14 14 00  ADD64            s20 = s16 + s20 ; q1=0xe101b
00b3  +0x010c8  op=67  00 16 16 00  LSR64_IMM32PLUS  s22 = (uint64_t)s22 >> (0 + 32) ; q1=0x100500111d1b
00b4  +0x010e0  op=84  10 16 16 14  ADD64            s22 = s16 + s22 ; q1=0x260002180b00
00b5  +0x010f8  op=59  16 16 00 00  LD8U             s22 = *(uint8_t *)(s22 +0x0) ; q1=0x381f0004040c
00b6  +0x01110  op=02  16 0f 0f 00  XOR64            s15 = s15 ^ s22 ; q1=0x381f000b0b0c
00b7  +0x01128  op=26  05 0f 06 00  ST8              *(s5 +0x6) = (uint8_t)s15 ; q1=0x400021d3f
00b8  +0x01140  op=6d  00 0d 0d 00  SHL64_IMM32PLUS  s13 = s13 << (0 + 32) ; q1=0x3e0d0e090000
00b9  +0x01158  op=84  10 15 0f 14  ADD64            s15 = s16 + s21 ; q1=0x4041b
00ba  +0x01170  op=67  00 0d 0d 00  LSR64_IMM32PLUS  s13 = (uint64_t)s13 >> (0 + 32) ; q1=0x381f000e0e0c
00bb  +0x01188  op=84  10 0d 0d 14  ADD64            s13 = s16 + s13 ; q1=0x2d000e0e0a00
00bc  +0x011a0  op=59  0d 0d 00 00  LD8U             s13 = *(uint8_t *)(s13 +0x0) ; q1=0x3e0d04150000
00bd  +0x011b8  op=02  0d 0e 0d 00  XOR64            s13 = s14 ^ s13 ; q1=0x3e050e110000
00be  +0x011d0  op=26  05 0d 07 00  ST8              *(s5 +0x7) = (uint8_t)s13 ; q1=0x3e0d0b110000
00bf  +0x011e8  op=59  18 0d 00 00  LD8U             s13 = *(uint8_t *)(s24 +0x0) ; q1=0x3e0d011e0000
00c0  +0x01200  op=02  0d 0c 0c 00  XOR64            s12 = s12 ^ s13 ; q1=0x381f000e0e0c
00c1  +0x01218  op=34  19 00 0d 00  OR64             s13 = s25 | s0 ; q1=0x300300021d2a
00c2  +0x01230  op=26  05 0c 08 00  ST8              *(s5 +0x8) = (uint8_t)s12 ; q1=0x180500191d1b
00c3  +0x01248  op=59  12 0c 00 00  LD8U             s12 = *(uint8_t *)(s18 +0x0) ; q1=0x381f000b0b22
00c4  +0x01260  op=02  0c 09 09 01  XOR64            s9 = s9 ^ s12 ; q1=0x2d000e0e0700
00c5  +0x01278  op=26  05 09 09 00  ST8              *(s5 +0x9) = (uint8_t)s9 ; q1=0x260002100d00
00c6  +0x01290  op=59  13 09 00 00  LD8U             s9 = *(uint8_t *)(s19 +0x0) ; q1=0x3e0d0d130000
00c7  +0x012a8  op=02  09 0b 09 00  XOR64            s9 = s11 ^ s9 ; q1=0x301401010a3e
00c8  +0x012c0  op=26  05 09 0a 00  ST8              *(s5 +0xa) = (uint8_t)s9 ; q1=0x3e0504090000
00c9  +0x012d8  op=59  14 09 00 00  LD8U             s9 = *(uint8_t *)(s20 +0x0) ; q1=0x3807000e1d1a
00ca  +0x012f0  op=02  09 0a 09 00  XOR64            s9 = s10 ^ s9 ; q1=0x380300021d3f
00cb  +0x01308  op=26  05 09 0b 00  ST8              *(s5 +0xb) = (uint8_t)s9 ; q1=0x381f000d0d0c
00cc  +0x01320  op=59  0f 09 00 00  LD8U             s9 = *(uint8_t *)(s15 +0x0) ; q1=0x3e050b130000
00cd  +0x01338  op=02  09 08 08 01  XOR64            s8 = s8 ^ s9 ; q1=0x3e0501150000
00ce  +0x01350  op=26  05 08 0c 00  ST8              *(s5 +0xc) = (uint8_t)s8 ; q1=0x1f011700192c
00cf  +0x01368  op=34  01 00 05 01  OR64             s5 = s1 | s0 ; q1=0x381f00020222
00d0  +0x01380  op=a7  03 04 8d ff  BR_NE64          if (s3 != s4) goto record +94 ; q1=0x381f0001010c
00d1  +0x01398  op=34  1e 00 1d 01  OR64             s29 = s30 | s0 ; q1=0x2d000d0d0a00
00d2  +0x013b0  op=58  1d 10 20 01  LD64             s16 = *(uint64_t *)(s29 +0x120) ; q1=0x381f000c0c0c
00d3  +0x013c8  op=58  1d 11 28 01  LD64             s17 = *(uint64_t *)(s29 +0x128) ; q1=0x301402020a3e
00d4  +0x013e0  op=58  1d 12 30 01  LD64             s18 = *(uint64_t *)(s29 +0x130) ; q1=0x3e050d100000
00d5  +0x013f8  op=58  1d 13 38 01  LD64             s19 = *(uint64_t *)(s29 +0x138) ; q1=0x30140101073e
00d6  +0x01410  op=58  1d 14 40 01  LD64             s20 = *(uint64_t *)(s29 +0x140) ; q1=0x3a0d04100000
00d7  +0x01428  op=58  1d 15 48 01  LD64             s21 = *(uint64_t *)(s29 +0x148) ; q1=0x1804000f1d3f
00d8  +0x01440  op=58  1d 16 50 01  LD64             s22 = *(uint64_t *)(s29 +0x150) ; q1=0x80a00021d2a
00d9  +0x01458  op=58  1d 17 58 01  LD64             s23 = *(uint64_t *)(s29 +0x158) ; q1=0x381f000d0d0c
00da  +0x01470  op=58  1d 1e 60 01  LD64             s30 = *(uint64_t *)(s29 +0x160) ; q1=0x300900011d1a
00db  +0x01488  op=58  1d 1f 68 01  LD64             s31 = *(uint64_t *)(s29 +0x168) ; q1=0x190d0b18133e
00dc  +0x014a0  op=85  1d 1d 70 01  ADD64_IMM16      s29 = s29 +0x170 ; q1=0x3a0d10150000
00dd  +0x014b8  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x381f0004040c

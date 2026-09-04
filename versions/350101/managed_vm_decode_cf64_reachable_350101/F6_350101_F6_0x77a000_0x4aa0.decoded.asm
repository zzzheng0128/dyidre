; MetaSec managed bytecode decode: F6
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F6_0x77a000_0x4aa0.bin
; records: 796  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d a0 fb  ADD64_IMM16      s29 = s29 -0x460
0001  +0x00018  op=25  1d 1f 58 04  ST64             *(s29 +0x458) = s31
0002  +0x00030  op=25  1d 1e 50 04  ST64             *(s29 +0x450) = s30
0003  +0x00048  op=25  1d 17 48 04  ST64             *(s29 +0x448) = s23
0004  +0x00060  op=25  1d 16 40 04  ST64             *(s29 +0x440) = s22
0005  +0x00078  op=25  1d 15 38 04  ST64             *(s29 +0x438) = s21
0006  +0x00090  op=25  1d 14 30 04  ST64             *(s29 +0x430) = s20
0007  +0x000a8  op=25  1d 13 28 04  ST64             *(s29 +0x428) = s19
0008  +0x000c0  op=25  1d 12 20 04  ST64             *(s29 +0x420) = s18
0009  +0x000d8  op=25  1d 11 18 04  ST64             *(s29 +0x418) = s17
000a  +0x000f0  op=25  1d 10 10 04  ST64             *(s29 +0x410) = s16
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000c  +0x00120  op=18  11 06 01 00  SHL32_IMM        s1 = (int32_t)(s6 << 0)
000d  +0x00138  op=b5  00 11 e0 ff  ADD32_IMM16      s17 = int32(s0 -0x20)
000e  +0x00150  op=b5  00 12 20 00  ADD32_IMM16      s18 = int32(s0 +0x20)
000f  +0x00168  op=34  07 00 15 01  OR64             s21 = s7 | s0
0010  +0x00180  op=18  11 05 16 00  SHL32_IMM        s22 = (int32_t)(s5 << 0)
0011  +0x00198  op=34  04 00 14 01  OR64             s20 = s4 | s0
0012  +0x001b0  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
0013  +0x001c8  op=85  00 06 08 00  ADD64_IMM16      s6 = s0 +0x8
0014  +0x001e0  op=53  01 07 e0 09  LD_POOL_PTR      s7 = *(uint64_t *)q1 + 0x9e0 ; q1=0x125fd3a8 rt/so-mapped
0015  +0x001f8  op=b5  00 08 00 00  ADD32_IMM16      s8 = int32(s0 +0x0)
0016  +0x00210  op=85  1e 10 b0 03  ADD64_IMM16      s16 = s30 +0x3b0
0017  +0x00228  op=08  1e 01 34 00  ST32             *(s30 +0x34) = (uint32_t)s1
0018  +0x00240  op=b5  01 01 0d 00  ADD32_IMM16      s1 = int32(s1 +0xd)
0019  +0x00258  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
001a  +0x00270  op=34  02 11 03 00  OR64             s3 = s2 | s17
001b  +0x00288  op=09  12 02 04 04  SUB32            s4 = sign_extend_32((uint32_t)s18 - (uint32_t)s2)
001c  +0x002a0  op=ae  05 06 1b 00  BR_EQ64          if (s5 == s6) goto record +56
001d  +0x002b8  op=6e  12 05 09 02  SHL64_IMM        s9 = s5 << 2
001e  +0x002d0  op=34  03 00 0c 00  OR64             s12 = s3 | s0
001f  +0x002e8  op=34  08 00 0b 01  OR64             s11 = s8 | s0
0020  +0x00300  op=84  07 09 01 04  ADD64            s1 = s7 + s9
0021  +0x00318  op=52  01 0a 00 00  LD32S            s10 = *(int32_t *)(s1 +0x0)
0022  +0x00330  op=ae  0c 00 04 00  BR_EQ64          if (s12 == s0) goto record +39
0023  +0x00348  op=18  10 0b 01 01  SHL32_IMM        s1 = (int32_t)(s11 << 1)
0024  +0x00360  op=b5  0c 0c 01 00  ADD32_IMM16      s12 = int32(s12 +0x1)
0025  +0x00378  op=33  01 0b 01 00  OR_IMM16         s11 = s1 | 0x1
0026  +0x00390  op=a7  0c 00 fc ff  BR_NE64          if (s12 != s0) goto record +35
0027  +0x003a8  op=34  03 00 0d 00  OR64             s13 = s3 | s0
0028  +0x003c0  op=34  08 00 0c 01  OR64             s12 = s8 | s0
0029  +0x003d8  op=ae  0d 00 04 00  BR_EQ64          if (s13 == s0) goto record +46
002a  +0x003f0  op=18  11 0c 01 01  SHL32_IMM        s1 = (int32_t)(s12 << 1)
002b  +0x00408  op=b5  0d 0d 01 00  ADD32_IMM16      s13 = int32(s13 +0x1)
002c  +0x00420  op=33  01 0c 01 00  OR_IMM16         s12 = s1 | 0x1
002d  +0x00438  op=a7  0d 00 fc ff  BR_NE64          if (s13 != s0) goto record +42
002e  +0x00450  op=0d  02 0a 01 00  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s10 >> (s1 & 31))
002f  +0x00468  op=17  04 0a 0a 17  OP_17            raw operands=04 0a 0a 17 imm16=5898 q1=0
0030  +0x00480  op=84  10 09 09 00  ADD64            s9 = s16 + s9
0031  +0x00498  op=85  05 05 01 00  ADD64_IMM16      s5 = s5 +0x1
0032  +0x004b0  op=b3  0b 01 01 00  AND64            s1 = s11 & s1
0033  +0x004c8  op=36  0c 00 0b 01  NOR64            s11 = ~(s12 | s0)
0034  +0x004e0  op=b3  0a 0b 0a 01  AND64            s10 = s10 & s11
0035  +0x004f8  op=34  0a 01 01 01  OR64             s1 = s10 | s1
0036  +0x00510  op=08  09 01 00 00  ST32             *(s9 +0x0) = (uint32_t)s1
0037  +0x00528  op=a7  05 06 e5 ff  BR_NE64          if (s5 != s6) goto record +29
0038  +0x00540  op=85  1e 17 b0 02  ADD64_IMM16      s23 = s30 +0x2b0
0039  +0x00558  op=85  00 13 00 00  ADD64_IMM16      s19 = s0 +0x0
003a  +0x00570  op=85  00 06 00 01  ADD64_IMM16      s6 = s0 +0x100
003b  +0x00588  op=34  17 00 04 00  OR64             s4 = s23 | s0
003c  +0x005a0  op=34  13 00 05 01  OR64             s5 = s19 | s0
003d  +0x005b8  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
003e  +0x005d0  op=52  1e 01 34 00  LD32S            s1 = *(int32_t *)(s30 +0x34)
003f  +0x005e8  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
0040  +0x00600  op=53  01 05 00 0a  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0xa00 ; q1=0x125fd3a8 rt/so-mapped
0041  +0x00618  op=b5  00 0c 00 00  ADD32_IMM16      s12 = int32(s0 +0x0)
0042  +0x00630  op=b5  01 01 0e 00  ADD32_IMM16      s1 = int32(s1 +0xe)
0043  +0x00648  op=b2  01 02 1f 00  AND64_IMM16      s2 = s1 & 0x1f
0044  +0x00660  op=34  02 11 03 00  OR64             s3 = s2 | s17
0045  +0x00678  op=09  12 02 04 14  SUB32            s4 = sign_extend_32((uint32_t)s18 - (uint32_t)s2)
0046  +0x00690  op=ae  13 06 1b 00  BR_EQ64          if (s19 == s6) goto record +98
0047  +0x006a8  op=6e  00 13 07 02  SHL64_IMM        s7 = s19 << 2
0048  +0x006c0  op=34  03 00 0a 00  OR64             s10 = s3 | s0
0049  +0x006d8  op=34  0c 00 09 01  OR64             s9 = s12 | s0
004a  +0x006f0  op=84  05 07 01 04  ADD64            s1 = s5 + s7
004b  +0x00708  op=52  01 08 00 00  LD32S            s8 = *(int32_t *)(s1 +0x0)
004c  +0x00720  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +81
004d  +0x00738  op=18  00 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
004e  +0x00750  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
004f  +0x00768  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
0050  +0x00780  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +77
0051  +0x00798  op=34  03 00 0b 01  OR64             s11 = s3 | s0
0052  +0x007b0  op=34  0c 00 0a 01  OR64             s10 = s12 | s0
0053  +0x007c8  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +88
0054  +0x007e0  op=18  10 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
0055  +0x007f8  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
0056  +0x00810  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
0057  +0x00828  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +84
0058  +0x00840  op=0d  02 08 01 01  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31))
0059  +0x00858  op=17  04 08 08 07  OP_17            raw operands=04 08 08 07 imm16=1800 q1=0
005a  +0x00870  op=85  13 13 01 00  ADD64_IMM16      s19 = s19 +0x1
005b  +0x00888  op=84  17 07 07 14  ADD64            s7 = s23 + s7
005c  +0x008a0  op=b3  09 01 01 01  AND64            s1 = s9 & s1
005d  +0x008b8  op=36  0a 00 09 01  NOR64            s9 = ~(s10 | s0)
005e  +0x008d0  op=b3  08 09 08 00  AND64            s8 = s8 & s9
005f  +0x008e8  op=34  08 01 01 01  OR64             s1 = s8 | s1
0060  +0x00900  op=08  07 01 00 00  ST32             *(s7 +0x0) = (uint32_t)s1
0061  +0x00918  op=a7  13 06 e5 ff  BR_NE64          if (s19 != s6) goto record +71
0062  +0x00930  op=25  1e 15 20 00  ST64             *(s30 +0x20) = s21
0063  +0x00948  op=85  1e 15 b0 00  ADD64_IMM16      s21 = s30 +0xb0
0064  +0x00960  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
0065  +0x00978  op=25  1e 17 38 00  ST64             *(s30 +0x38) = s23
0066  +0x00990  op=85  15 01 34 00  ADD64_IMM16      s1 = s21 +0x34
0067  +0x009a8  op=25  1e 12 40 00  ST64             *(s30 +0x40) = s18
0068  +0x009c0  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1
0069  +0x009d8  op=85  15 01 34 00  ADD64_IMM16      s1 = s21 +0x34
006a  +0x009f0  op=25  1e 01 08 00  ST64             *(s30 +0x8) = s1
006b  +0x00a08  op=33  00 01 a3 fe  OR_IMM16         s1 = s0 | 0xfea3
006c  +0x00a20  op=6e  12 01 01 10  SHL64_IMM        s1 = s1 << 16
006d  +0x00a38  op=85  01 02 0d 9f  ADD64_IMM16      s2 = s1 -0x60f3
006e  +0x00a50  op=25  1e 01 28 00  ST64             *(s30 +0x28) = s1
006f  +0x00a68  op=85  01 01 6d 9f  ADD64_IMM16      s1 = s1 -0x6093
0070  +0x00a80  op=25  1e 02 10 00  ST64             *(s30 +0x10) = s2
0071  +0x00a98  op=25  1e 01 48 00  ST64             *(s30 +0x48) = s1
0072  +0x00ab0  op=85  1e 13 70 00  ADD64_IMM16      s19 = s30 +0x70
0073  +0x00ac8  op=85  1e 11 d0 03  ADD64_IMM16      s17 = s30 +0x3d0
0074  +0x00ae0  op=ae  16 00 26 01  BR_EQ64          if (s22 == s0) goto record +411
0075  +0x00af8  op=a7  12 00 02 00  BR_NE64          if (s18 != s0) goto record +120
0076  +0x00b10  op=14  16 01 40 00  CMP_LO_IMM64     s1 = ((uint64_t)s22 < (uint64_t)64) ? 1 : 0
0077  +0x00b28  op=ae  01 00 86 00  BR_EQ64          if (s1 == s0) goto record +254
0078  +0x00b40  op=6d  00 16 02 00  SHL64_IMM32PLUS  s2 = s22 << (0 + 32)
0079  +0x00b58  op=64  06 12 01 00  SUB64            s1 = s6 - s18
007a  +0x00b70  op=84  11 12 04 14  ADD64            s4 = s17 + s18
007b  +0x00b88  op=34  14 00 05 00  OR64             s5 = s20 | s0
007c  +0x00ba0  op=67  00 02 02 00  LSR64_IMM32PLUS  s2 = (uint64_t)s2 >> (0 + 32)
007d  +0x00bb8  op=13  01 02 03 0f  CMP_LO64         s3 = ((uint64_t)s1 < (uint64_t)s2) ? 1 : 0
007e  +0x00bd0  op=18  00 03 03 00  SHL32_IMM        s3 = (int32_t)(s3 << 0)
007f  +0x00be8  op=1e  01 03 01 01  CMOVNZ64         s1 = (s3 != 0) ? s1 : 0
0080  +0x00c00  op=1f  02 03 02 10  CMOVZ64          s2 = (s3 == 0) ? s2 : 0
0081  +0x00c18  op=34  01 02 17 01  OR64             s23 = s1 | s2
0082  +0x00c30  op=34  17 00 06 01  OR64             s6 = s23 | s0
0083  +0x00c48  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd360 rt/so-mapped
0084  +0x00c60  op=18  00 17 01 00  SHL32_IMM        s1 = (int32_t)(s23 << 0)
0085  +0x00c78  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
0086  +0x00c90  op=84  14 17 14 00  ADD64            s20 = s20 + s23
0087  +0x00ca8  op=84  17 12 12 04  ADD64            s18 = s23 + s18
0088  +0x00cc0  op=09  16 01 16 00  SUB32            s22 = sign_extend_32((uint32_t)s22 - (uint32_t)s1)
0089  +0x00cd8  op=a7  12 06 e8 ff  BR_NE64          if (s18 != s6) goto record +114
008a  +0x00cf0  op=85  1e 17 b0 00  ADD64_IMM16      s23 = s30 +0xb0
008b  +0x00d08  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
008c  +0x00d20  op=85  00 06 00 02  ADD64_IMM16      s6 = s0 +0x200
008d  +0x00d38  op=25  1e 00 88 00  ST64             *(s30 +0x88) = s0
008e  +0x00d50  op=25  1e 00 80 00  ST64             *(s30 +0x80) = s0
008f  +0x00d68  op=25  1e 00 78 00  ST64             *(s30 +0x78) = s0
0090  +0x00d80  op=25  1e 00 70 00  ST64             *(s30 +0x70) = s0
0091  +0x00d98  op=34  17 00 04 00  OR64             s4 = s23 | s0
0092  +0x00db0  op=34  12 00 05 00  OR64             s5 = s18 | s0
0093  +0x00dc8  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0094  +0x00de0  op=58  1e 0e 38 00  LD64             s14 = *(uint64_t *)(s30 +0x38)
0095  +0x00df8  op=85  00 0f 20 00  ADD64_IMM16      s15 = s0 +0x20
0096  +0x00e10  op=34  12 00 02 01  OR64             s2 = s18 | s0
0097  +0x00e28  op=ae  02 0f 06 00  BR_EQ64          if (s2 == s15) goto record +158
0098  +0x00e40  op=84  10 02 03 04  ADD64            s3 = s16 + s2
0099  +0x00e58  op=84  13 02 01 14  ADD64            s1 = s19 + s2
009a  +0x00e70  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
009b  +0x00e88  op=52  03 03 00 00  LD32S            s3 = *(int32_t *)(s3 +0x0)
009c  +0x00ea0  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
009d  +0x00eb8  op=a7  02 0f fa ff  BR_NE64          if (s2 != s15) goto record +152
009e  +0x00ed0  op=34  12 00 02 01  OR64             s2 = s18 | s0
009f  +0x00ee8  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
00a0  +0x00f00  op=ae  02 06 0f 00  BR_EQ64          if (s2 == s6) goto record +176
00a1  +0x00f18  op=84  11 02 01 00  ADD64            s1 = s17 + s2
00a2  +0x00f30  op=59  01 03 00 00  LD8U             s3 = *(uint8_t *)(s1 +0x0)
00a3  +0x00f48  op=59  01 04 01 00  LD8U             s4 = *(uint8_t *)(s1 +0x1)
00a4  +0x00f60  op=18  11 03 03 18  SHL32_IMM        s3 = (int32_t)(s3 << 24)
00a5  +0x00f78  op=18  10 04 04 10  SHL32_IMM        s4 = (int32_t)(s4 << 16)
00a6  +0x00f90  op=34  04 03 03 01  OR64             s3 = s4 | s3
00a7  +0x00fa8  op=59  01 04 02 00  LD8U             s4 = *(uint8_t *)(s1 +0x2)
00a8  +0x00fc0  op=59  01 01 03 00  LD8U             s1 = *(uint8_t *)(s1 +0x3)
00a9  +0x00fd8  op=18  00 04 04 08  SHL32_IMM        s4 = (int32_t)(s4 << 8)
00aa  +0x00ff0  op=34  03 04 03 00  OR64             s3 = s3 | s4
00ab  +0x01008  op=34  03 01 01 01  OR64             s1 = s3 | s1
00ac  +0x01020  op=84  17 02 03 00  ADD64            s3 = s23 + s2
00ad  +0x01038  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
00ae  +0x01050  op=08  03 01 00 00  ST32             *(s3 +0x0) = (uint32_t)s1
00af  +0x01068  op=a7  02 06 f1 ff  BR_NE64          if (s2 != s6) goto record +161
00b0  +0x01080  op=58  1e 18 48 00  LD64             s24 = *(uint64_t *)(s30 +0x48)
00b1  +0x01098  op=34  12 00 02 00  OR64             s2 = s18 | s0
00b2  +0x010b0  op=85  00 09 c0 01  ADD64_IMM16      s9 = s0 +0x1c0
00b3  +0x010c8  op=ae  02 09 15 00  BR_EQ64          if (s2 == s9) goto record +201
00b4  +0x010e0  op=84  17 02 01 14  ADD64            s1 = s23 + s2
00b5  +0x010f8  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
00b6  +0x01110  op=52  01 03 04 00  LD32S            s3 = *(int32_t *)(s1 +0x4)
00b7  +0x01128  op=2e  12 03 04 12  ROR32_IMM        s4 = ror32((uint32_t)s3, 18)
00b8  +0x01140  op=2e  12 03 05 07  ROR32_IMM        s5 = ror32((uint32_t)s3, 7)
00b9  +0x01158  op=0e  0b 03 03 03  LSR32_IMM        s3 = sign_extend_32((uint32_t)s3 >> 3)
00ba  +0x01170  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
00bb  +0x01188  op=52  01 05 38 00  LD32S            s5 = *(int32_t *)(s1 +0x38)
00bc  +0x011a0  op=02  04 03 03 01  XOR64            s3 = s3 ^ s4
00bd  +0x011b8  op=2e  10 05 08 13  ROR32_IMM        s8 = ror32((uint32_t)s5, 19)
00be  +0x011d0  op=2e  10 05 07 11  ROR32_IMM        s7 = ror32((uint32_t)s5, 17)
00bf  +0x011e8  op=0e  0b 05 05 0a  LSR32_IMM        s5 = sign_extend_32((uint32_t)s5 >> 10)
00c0  +0x01200  op=02  07 08 04 00  XOR64            s4 = s8 ^ s7
00c1  +0x01218  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
00c2  +0x01230  op=52  01 05 24 00  LD32S            s5 = *(int32_t *)(s1 +0x24)
00c3  +0x01248  op=b4  04 05 04 12  ADD32            s4 = int32(s4 + s5)
00c4  +0x01260  op=52  01 05 00 00  LD32S            s5 = *(int32_t *)(s1 +0x0)
00c5  +0x01278  op=b4  04 05 04 00  ADD32            s4 = int32(s4 + s5)
00c6  +0x01290  op=b4  04 03 03 00  ADD32            s3 = int32(s4 + s3)
00c7  +0x012a8  op=08  01 03 40 00  ST32             *(s1 +0x40) = (uint32_t)s3
00c8  +0x012c0  op=a7  02 09 eb ff  BR_NE64          if (s2 != s9) goto record +180
00c9  +0x012d8  op=58  1e 01 28 00  LD64             s1 = *(uint64_t *)(s30 +0x28)
00ca  +0x012f0  op=52  1e 02 80 00  LD32S            s2 = *(int32_t *)(s30 +0x80)
00cb  +0x01308  op=52  1e 0c 88 00  LD32S            s12 = *(int32_t *)(s30 +0x88)
00cc  +0x01320  op=52  1e 03 7c 00  LD32S            s3 = *(int32_t *)(s30 +0x7c)
00cd  +0x01338  op=52  1e 04 84 00  LD32S            s4 = *(int32_t *)(s30 +0x84)
00ce  +0x01350  op=52  1e 05 78 00  LD32S            s5 = *(int32_t *)(s30 +0x78)
00cf  +0x01368  op=52  1e 19 8c 00  LD32S            s25 = *(int32_t *)(s30 +0x8c)
00d0  +0x01380  op=52  1e 08 70 00  LD32S            s8 = *(int32_t *)(s30 +0x70)
00d1  +0x01398  op=52  1e 0b 74 00  LD32S            s11 = *(int32_t *)(s30 +0x74)
00d2  +0x013b0  op=58  1e 09 08 00  LD64             s9 = *(uint64_t *)(s30 +0x8)
00d3  +0x013c8  op=85  01 07 0d 9f  ADD64_IMM16      s7 = s1 -0x60f3
00d4  +0x013e0  op=34  08 00 0a 00  OR64             s10 = s8 | s0
00d5  +0x013f8  op=34  19 00 08 01  OR64             s8 = s25 | s0
00d6  +0x01410  op=34  0c 00 19 01  OR64             s25 = s12 | s0
00d7  +0x01428  op=ae  07 18 98 00  BR_EQ64          if (s7 == s24) goto record +368
00d8  +0x01440  op=2e  10 0a 01 0b  ROR32_IMM        s1 = ror32((uint32_t)s10, 11)
00d9  +0x01458  op=2e  12 0a 0c 06  ROR32_IMM        s12 = ror32((uint32_t)s10, 6)
00da  +0x01470  op=34  03 04 0d 00  OR64             s13 = s3 | s4
00db  +0x01488  op=02  0c 01 01 01  XOR64            s1 = s1 ^ s12
00dc  +0x014a0  op=2e  10 0a 0c 19  ROR32_IMM        s12 = ror32((uint32_t)s10, 25)
00dd  +0x014b8  op=b3  0d 19 0d 01  AND64            s13 = s13 & s25
00de  +0x014d0  op=02  01 0c 01 01  XOR64            s1 = s12 ^ s1
00df  +0x014e8  op=52  09 0c 00 00  LD32S            s12 = *(int32_t *)(s9 +0x0)
00e0  +0x01500  op=85  09 09 04 00  ADD64_IMM16      s9 = s9 +0x4
00e1  +0x01518  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
00e2  +0x01530  op=b2  07 0b 3f 00  AND64_IMM16      s11 = s7 & 0x3f
00e3  +0x01548  op=85  07 07 01 00  ADD64_IMM16      s7 = s7 +0x1
00e4  +0x01560  op=6e  02 0b 0b 02  SHL64_IMM        s11 = s11 << 2
00e5  +0x01578  op=84  0e 0b 0b 00  ADD64            s11 = s14 + s11
00e6  +0x01590  op=52  0b 0b 00 00  LD32S            s11 = *(int32_t *)(s11 +0x0)
00e7  +0x015a8  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
00e8  +0x015c0  op=02  05 08 0b 01  XOR64            s11 = s8 ^ s5
00e9  +0x015d8  op=b3  0b 0a 0b 01  AND64            s11 = s11 & s10
00ea  +0x015f0  op=b4  01 0c 01 02  ADD32            s1 = int32(s1 + s12)
00eb  +0x01608  op=b3  03 04 0c 01  AND64            s12 = s3 & s4
00ec  +0x01620  op=02  0b 08 0b 01  XOR64            s11 = s8 ^ s11
00ed  +0x01638  op=34  0d 0c 0c 01  OR64             s12 = s13 | s12
00ee  +0x01650  op=2e  12 04 0d 02  ROR32_IMM        s13 = ror32((uint32_t)s4, 2)
00ef  +0x01668  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
00f0  +0x01680  op=2e  12 04 0b 0d  ROR32_IMM        s11 = ror32((uint32_t)s4, 13)
00f1  +0x01698  op=02  0d 0b 0b 01  XOR64            s11 = s11 ^ s13
00f2  +0x016b0  op=2e  10 04 0d 16  ROR32_IMM        s13 = ror32((uint32_t)s4, 22)
00f3  +0x016c8  op=02  0b 0d 0b 01  XOR64            s11 = s13 ^ s11
00f4  +0x016e0  op=b4  01 0b 0b 00  ADD32            s11 = int32(s1 + s11)
00f5  +0x016f8  op=b4  02 01 01 12  ADD32            s1 = int32(s2 + s1)
00f6  +0x01710  op=34  03 00 02 01  OR64             s2 = s3 | s0
00f7  +0x01728  op=34  05 00 03 01  OR64             s3 = s5 | s0
00f8  +0x01740  op=b4  0b 0c 0b 00  ADD32            s11 = int32(s11 + s12)
00f9  +0x01758  op=34  04 00 0c 01  OR64             s12 = s4 | s0
00fa  +0x01770  op=34  01 00 04 01  OR64             s4 = s1 | s0
00fb  +0x01788  op=34  0b 00 05 01  OR64             s5 = s11 | s0
00fc  +0x017a0  op=34  0a 00 0b 00  OR64             s11 = s10 | s0
00fd  +0x017b8  op=5f  d6 ff ff ff  ADD_PC_IMM32     goto record +212 ; vm_pc = current_pc + 1 + -42
00fe  +0x017d0  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
00ff  +0x017e8  op=34  15 00 04 01  OR64             s4 = s21 | s0
0100  +0x01800  op=85  00 06 00 02  ADD64_IMM16      s6 = s0 +0x200
0101  +0x01818  op=25  1e 00 88 00  ST64             *(s30 +0x88) = s0
0102  +0x01830  op=25  1e 00 80 00  ST64             *(s30 +0x80) = s0
0103  +0x01848  op=25  1e 00 78 00  ST64             *(s30 +0x78) = s0
0104  +0x01860  op=25  1e 00 70 00  ST64             *(s30 +0x70) = s0
0105  +0x01878  op=34  12 00 05 01  OR64             s5 = s18 | s0
0106  +0x01890  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0107  +0x018a8  op=58  1e 0e 38 00  LD64             s14 = *(uint64_t *)(s30 +0x38)
0108  +0x018c0  op=58  1e 18 48 00  LD64             s24 = *(uint64_t *)(s30 +0x48)
0109  +0x018d8  op=34  12 00 02 01  OR64             s2 = s18 | s0
010a  +0x018f0  op=85  00 0f 20 00  ADD64_IMM16      s15 = s0 +0x20
010b  +0x01908  op=85  00 09 c0 01  ADD64_IMM16      s9 = s0 +0x1c0
010c  +0x01920  op=ae  02 0f 06 00  BR_EQ64          if (s2 == s15) goto record +275
010d  +0x01938  op=84  10 02 03 00  ADD64            s3 = s16 + s2
010e  +0x01950  op=84  13 02 01 00  ADD64            s1 = s19 + s2
010f  +0x01968  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0110  +0x01980  op=52  03 03 00 00  LD32S            s3 = *(int32_t *)(s3 +0x0)
0111  +0x01998  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
0112  +0x019b0  op=a7  02 0f fa ff  BR_NE64          if (s2 != s15) goto record +269
0113  +0x019c8  op=34  12 00 02 01  OR64             s2 = s18 | s0
0114  +0x019e0  op=85  00 06 40 00  ADD64_IMM16      s6 = s0 +0x40
0115  +0x019f8  op=ae  02 06 0f 00  BR_EQ64          if (s2 == s6) goto record +293
0116  +0x01a10  op=84  14 02 01 04  ADD64            s1 = s20 + s2
0117  +0x01a28  op=59  01 03 00 00  LD8U             s3 = *(uint8_t *)(s1 +0x0)
0118  +0x01a40  op=59  01 04 01 00  LD8U             s4 = *(uint8_t *)(s1 +0x1)
0119  +0x01a58  op=18  10 03 03 18  SHL32_IMM        s3 = (int32_t)(s3 << 24)
011a  +0x01a70  op=18  00 04 04 10  SHL32_IMM        s4 = (int32_t)(s4 << 16)
011b  +0x01a88  op=34  04 03 03 00  OR64             s3 = s4 | s3
011c  +0x01aa0  op=59  01 04 02 00  LD8U             s4 = *(uint8_t *)(s1 +0x2)
011d  +0x01ab8  op=59  01 01 03 00  LD8U             s1 = *(uint8_t *)(s1 +0x3)
011e  +0x01ad0  op=18  11 04 04 08  SHL32_IMM        s4 = (int32_t)(s4 << 8)
011f  +0x01ae8  op=34  03 04 03 01  OR64             s3 = s3 | s4
0120  +0x01b00  op=34  03 01 01 00  OR64             s1 = s3 | s1
0121  +0x01b18  op=84  15 02 03 14  ADD64            s3 = s21 + s2
0122  +0x01b30  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0123  +0x01b48  op=08  03 01 00 00  ST32             *(s3 +0x0) = (uint32_t)s1
0124  +0x01b60  op=a7  02 06 f1 ff  BR_NE64          if (s2 != s6) goto record +278
0125  +0x01b78  op=34  12 00 02 00  OR64             s2 = s18 | s0
0126  +0x01b90  op=ae  02 09 15 00  BR_EQ64          if (s2 == s9) goto record +316
0127  +0x01ba8  op=84  15 02 01 14  ADD64            s1 = s21 + s2
0128  +0x01bc0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0129  +0x01bd8  op=52  01 03 04 00  LD32S            s3 = *(int32_t *)(s1 +0x4)
012a  +0x01bf0  op=2e  10 03 04 12  ROR32_IMM        s4 = ror32((uint32_t)s3, 18)
012b  +0x01c08  op=2e  01 03 05 07  ROR32_IMM        s5 = ror32((uint32_t)s3, 7)
012c  +0x01c20  op=0e  00 03 03 03  LSR32_IMM        s3 = sign_extend_32((uint32_t)s3 >> 3)
012d  +0x01c38  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
012e  +0x01c50  op=52  01 05 38 00  LD32S            s5 = *(int32_t *)(s1 +0x38)
012f  +0x01c68  op=02  04 03 03 01  XOR64            s3 = s3 ^ s4
0130  +0x01c80  op=2e  10 05 08 13  ROR32_IMM        s8 = ror32((uint32_t)s5, 19)
0131  +0x01c98  op=2e  01 05 07 11  ROR32_IMM        s7 = ror32((uint32_t)s5, 17)
0132  +0x01cb0  op=0e  0d 05 05 0a  LSR32_IMM        s5 = sign_extend_32((uint32_t)s5 >> 10)
0133  +0x01cc8  op=02  07 08 04 01  XOR64            s4 = s8 ^ s7
0134  +0x01ce0  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
0135  +0x01cf8  op=52  01 05 24 00  LD32S            s5 = *(int32_t *)(s1 +0x24)
0136  +0x01d10  op=b4  04 05 04 02  ADD32            s4 = int32(s4 + s5)
0137  +0x01d28  op=52  01 05 00 00  LD32S            s5 = *(int32_t *)(s1 +0x0)
0138  +0x01d40  op=b4  04 05 04 02  ADD32            s4 = int32(s4 + s5)
0139  +0x01d58  op=b4  04 03 03 02  ADD32            s3 = int32(s4 + s3)
013a  +0x01d70  op=08  01 03 40 00  ST32             *(s1 +0x40) = (uint32_t)s3
013b  +0x01d88  op=a7  02 09 eb ff  BR_NE64          if (s2 != s9) goto record +295
013c  +0x01da0  op=52  1e 02 80 00  LD32S            s2 = *(int32_t *)(s30 +0x80)
013d  +0x01db8  op=52  1e 0c 88 00  LD32S            s12 = *(int32_t *)(s30 +0x88)
013e  +0x01dd0  op=52  1e 03 7c 00  LD32S            s3 = *(int32_t *)(s30 +0x7c)
013f  +0x01de8  op=52  1e 04 84 00  LD32S            s4 = *(int32_t *)(s30 +0x84)
0140  +0x01e00  op=52  1e 05 78 00  LD32S            s5 = *(int32_t *)(s30 +0x78)
0141  +0x01e18  op=52  1e 19 8c 00  LD32S            s25 = *(int32_t *)(s30 +0x8c)
0142  +0x01e30  op=52  1e 07 70 00  LD32S            s7 = *(int32_t *)(s30 +0x70)
0143  +0x01e48  op=52  1e 0b 74 00  LD32S            s11 = *(int32_t *)(s30 +0x74)
0144  +0x01e60  op=58  1e 08 10 00  LD64             s8 = *(uint64_t *)(s30 +0x10)
0145  +0x01e78  op=58  1e 09 18 00  LD64             s9 = *(uint64_t *)(s30 +0x18)
0146  +0x01e90  op=34  07 00 0a 01  OR64             s10 = s7 | s0
0147  +0x01ea8  op=34  19 00 07 00  OR64             s7 = s25 | s0
0148  +0x01ec0  op=34  0c 00 19 01  OR64             s25 = s12 | s0
0149  +0x01ed8  op=ae  08 18 39 00  BR_EQ64          if (s8 == s24) goto record +387
014a  +0x01ef0  op=2e  12 0a 01 0b  ROR32_IMM        s1 = ror32((uint32_t)s10, 11)
014b  +0x01f08  op=2e  10 0a 0c 06  ROR32_IMM        s12 = ror32((uint32_t)s10, 6)
014c  +0x01f20  op=34  03 04 0d 00  OR64             s13 = s3 | s4
014d  +0x01f38  op=02  0c 01 01 01  XOR64            s1 = s1 ^ s12
014e  +0x01f50  op=2e  10 0a 0c 19  ROR32_IMM        s12 = ror32((uint32_t)s10, 25)
014f  +0x01f68  op=b3  0d 19 0d 00  AND64            s13 = s13 & s25
0150  +0x01f80  op=02  01 0c 01 01  XOR64            s1 = s12 ^ s1
0151  +0x01f98  op=52  09 0c 00 00  LD32S            s12 = *(int32_t *)(s9 +0x0)
0152  +0x01fb0  op=85  09 09 04 00  ADD64_IMM16      s9 = s9 +0x4
0153  +0x01fc8  op=b4  01 0b 01 00  ADD32            s1 = int32(s1 + s11)
0154  +0x01fe0  op=b2  08 0b 3f 00  AND64_IMM16      s11 = s8 & 0x3f
0155  +0x01ff8  op=85  08 08 01 00  ADD64_IMM16      s8 = s8 +0x1
0156  +0x02010  op=6e  00 0b 0b 02  SHL64_IMM        s11 = s11 << 2
0157  +0x02028  op=84  0e 0b 0b 14  ADD64            s11 = s14 + s11
0158  +0x02040  op=52  0b 0b 00 00  LD32S            s11 = *(int32_t *)(s11 +0x0)
0159  +0x02058  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
015a  +0x02070  op=02  05 07 0b 01  XOR64            s11 = s7 ^ s5
015b  +0x02088  op=b3  0b 0a 0b 01  AND64            s11 = s11 & s10
015c  +0x020a0  op=b4  01 0c 01 00  ADD32            s1 = int32(s1 + s12)
015d  +0x020b8  op=b3  03 04 0c 01  AND64            s12 = s3 & s4
015e  +0x020d0  op=02  0b 07 0b 01  XOR64            s11 = s7 ^ s11
015f  +0x020e8  op=34  0d 0c 0c 00  OR64             s12 = s13 | s12
0160  +0x02100  op=2e  10 04 0d 02  ROR32_IMM        s13 = ror32((uint32_t)s4, 2)
0161  +0x02118  op=b4  01 0b 01 00  ADD32            s1 = int32(s1 + s11)
0162  +0x02130  op=2e  01 04 0b 0d  ROR32_IMM        s11 = ror32((uint32_t)s4, 13)
0163  +0x02148  op=02  0d 0b 0b 00  XOR64            s11 = s11 ^ s13
0164  +0x02160  op=2e  01 04 0d 16  ROR32_IMM        s13 = ror32((uint32_t)s4, 22)
0165  +0x02178  op=02  0b 0d 0b 01  XOR64            s11 = s13 ^ s11
0166  +0x02190  op=b4  01 0b 0b 12  ADD32            s11 = int32(s1 + s11)
0167  +0x021a8  op=b4  02 01 01 02  ADD32            s1 = int32(s2 + s1)
0168  +0x021c0  op=34  03 00 02 01  OR64             s2 = s3 | s0
0169  +0x021d8  op=34  05 00 03 01  OR64             s3 = s5 | s0
016a  +0x021f0  op=b4  0b 0c 0b 00  ADD32            s11 = int32(s11 + s12)
016b  +0x02208  op=34  04 00 0c 01  OR64             s12 = s4 | s0
016c  +0x02220  op=34  01 00 04 00  OR64             s4 = s1 | s0
016d  +0x02238  op=34  0b 00 05 01  OR64             s5 = s11 | s0
016e  +0x02250  op=34  0a 00 0b 01  OR64             s11 = s10 | s0
016f  +0x02268  op=5f  d6 ff ff ff  ADD_PC_IMM32     goto record +326 ; vm_pc = current_pc + 1 + -42
0170  +0x02280  op=08  1e 08 8c 00  ST32             *(s30 +0x8c) = (uint32_t)s8
0171  +0x02298  op=08  1e 0a 70 00  ST32             *(s30 +0x70) = (uint32_t)s10
0172  +0x022b0  op=08  1e 0b 74 00  ST32             *(s30 +0x74) = (uint32_t)s11
0173  +0x022c8  op=08  1e 04 84 00  ST32             *(s30 +0x84) = (uint32_t)s4
0174  +0x022e0  op=08  1e 05 78 00  ST32             *(s30 +0x78) = (uint32_t)s5
0175  +0x022f8  op=08  1e 19 88 00  ST32             *(s30 +0x88) = (uint32_t)s25
0176  +0x02310  op=08  1e 03 7c 00  ST32             *(s30 +0x7c) = (uint32_t)s3
0177  +0x02328  op=08  1e 02 80 00  ST32             *(s30 +0x80) = (uint32_t)s2
0178  +0x02340  op=34  12 00 02 00  OR64             s2 = s18 | s0
0179  +0x02358  op=ae  02 0f 1d 00  BR_EQ64          if (s2 == s15) goto record +407
017a  +0x02370  op=84  13 02 04 04  ADD64            s4 = s19 + s2
017b  +0x02388  op=84  10 02 01 04  ADD64            s1 = s16 + s2
017c  +0x023a0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
017d  +0x023b8  op=52  01 03 00 00  LD32S            s3 = *(int32_t *)(s1 +0x0)
017e  +0x023d0  op=52  04 04 00 00  LD32S            s4 = *(int32_t *)(s4 +0x0)
017f  +0x023e8  op=b4  04 03 03 12  ADD32            s3 = int32(s4 + s3)
0180  +0x02400  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
0181  +0x02418  op=a7  02 0f f8 ff  BR_NE64          if (s2 != s15) goto record +378
0182  +0x02430  op=5f  14 00 00 00  ADD_PC_IMM32     goto record +407 ; vm_pc = current_pc + 1 + 20
0183  +0x02448  op=08  1e 07 8c 00  ST32             *(s30 +0x8c) = (uint32_t)s7
0184  +0x02460  op=08  1e 0a 70 00  ST32             *(s30 +0x70) = (uint32_t)s10
0185  +0x02478  op=08  1e 0b 74 00  ST32             *(s30 +0x74) = (uint32_t)s11
0186  +0x02490  op=08  1e 04 84 00  ST32             *(s30 +0x84) = (uint32_t)s4
0187  +0x024a8  op=08  1e 05 78 00  ST32             *(s30 +0x78) = (uint32_t)s5
0188  +0x024c0  op=08  1e 19 88 00  ST32             *(s30 +0x88) = (uint32_t)s25
0189  +0x024d8  op=08  1e 03 7c 00  ST32             *(s30 +0x7c) = (uint32_t)s3
018a  +0x024f0  op=08  1e 02 80 00  ST32             *(s30 +0x80) = (uint32_t)s2
018b  +0x02508  op=34  12 00 02 00  OR64             s2 = s18 | s0
018c  +0x02520  op=ae  02 0f 08 00  BR_EQ64          if (s2 == s15) goto record +405
018d  +0x02538  op=84  13 02 04 04  ADD64            s4 = s19 + s2
018e  +0x02550  op=84  10 02 01 14  ADD64            s1 = s16 + s2
018f  +0x02568  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0190  +0x02580  op=52  01 03 00 00  LD32S            s3 = *(int32_t *)(s1 +0x0)
0191  +0x02598  op=52  04 04 00 00  LD32S            s4 = *(int32_t *)(s4 +0x0)
0192  +0x025b0  op=b4  04 03 03 12  ADD32            s3 = int32(s4 + s3)
0193  +0x025c8  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
0194  +0x025e0  op=a7  02 0f f8 ff  BR_NE64          if (s2 != s15) goto record +397
0195  +0x025f8  op=b5  16 16 c0 ff  ADD32_IMM16      s22 = int32(s22 -0x40)
0196  +0x02610  op=85  14 14 40 00  ADD64_IMM16      s20 = s20 +0x40
0197  +0x02628  op=58  1e 01 40 00  LD64             s1 = *(uint64_t *)(s30 +0x40)
0198  +0x02640  op=85  01 01 00 02  ADD64_IMM16      s1 = s1 +0x200
0199  +0x02658  op=25  1e 01 40 00  ST64             *(s30 +0x40) = s1
019a  +0x02670  op=5f  d7 fe ff ff  ADD_PC_IMM32     goto record +114 ; vm_pc = current_pc + 1 + -297
019b  +0x02688  op=85  00 14 00 00  ADD64_IMM16      s20 = s0 +0x0
019c  +0x026a0  op=34  13 00 04 00  OR64             s4 = s19 | s0
019d  +0x026b8  op=34  14 00 05 00  OR64             s5 = s20 | s0
019e  +0x026d0  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
019f  +0x026e8  op=52  1e 01 34 00  LD32S            s1 = *(int32_t *)(s30 +0x34)
01a0  +0x02700  op=58  1e 15 20 00  LD64             s21 = *(uint64_t *)(s30 +0x20)
01a1  +0x02718  op=85  00 0b 40 00  ADD64_IMM16      s11 = s0 +0x40
01a2  +0x02730  op=53  01 05 00 0b  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0xb00 ; q1=0x125fd3a8 rt/so-mapped
01a3  +0x02748  op=b5  00 06 00 00  ADD32_IMM16      s6 = int32(s0 +0x0)
01a4  +0x02760  op=b5  01 01 ff ff  ADD32_IMM16      s1 = int32(s1 -0x1)
01a5  +0x02778  op=b2  01 02 07 00  AND64_IMM16      s2 = s1 & 0x7
01a6  +0x02790  op=b5  00 01 f8 ff  ADD32_IMM16      s1 = int32(s0 -0x8)
01a7  +0x027a8  op=34  02 01 03 01  OR64             s3 = s2 | s1
01a8  +0x027c0  op=b5  00 01 08 00  ADD32_IMM16      s1 = int32(s0 +0x8)
01a9  +0x027d8  op=09  01 02 04 00  SUB32            s4 = sign_extend_32((uint32_t)s1 - (uint32_t)s2)
01aa  +0x027f0  op=ae  14 0b 1a 00  BR_EQ64          if (s20 == s11) goto record +453
01ab  +0x02808  op=84  05 14 01 04  ADD64            s1 = s5 + s20
01ac  +0x02820  op=34  03 00 09 01  OR64             s9 = s3 | s0
01ad  +0x02838  op=34  06 00 08 01  OR64             s8 = s6 | s0
01ae  +0x02850  op=59  01 07 00 00  LD8U             s7 = *(uint8_t *)(s1 +0x0)
01af  +0x02868  op=ae  09 00 04 00  BR_EQ64          if (s9 == s0) goto record +436
01b0  +0x02880  op=18  00 08 01 01  SHL32_IMM        s1 = (int32_t)(s8 << 1)
01b1  +0x02898  op=b5  09 09 01 00  ADD32_IMM16      s9 = int32(s9 +0x1)
01b2  +0x028b0  op=33  01 08 01 00  OR_IMM16         s8 = s1 | 0x1
01b3  +0x028c8  op=a7  09 00 fc ff  BR_NE64          if (s9 != s0) goto record +432
01b4  +0x028e0  op=34  03 00 0a 00  OR64             s10 = s3 | s0
01b5  +0x028f8  op=34  06 00 09 00  OR64             s9 = s6 | s0
01b6  +0x02910  op=ae  0a 00 04 00  BR_EQ64          if (s10 == s0) goto record +443
01b7  +0x02928  op=18  10 09 01 01  SHL32_IMM        s1 = (int32_t)(s9 << 1)
01b8  +0x02940  op=b5  0a 0a 01 00  ADD32_IMM16      s10 = int32(s10 +0x1)
01b9  +0x02958  op=33  01 09 01 00  OR_IMM16         s9 = s1 | 0x1
01ba  +0x02970  op=a7  0a 00 fc ff  BR_NE64          if (s10 != s0) goto record +439
01bb  +0x02988  op=0d  02 07 01 01  BYTE_FROM_U32_SHIFT s2 = (uint8_t)((uint32_t)s7 >> (s1 & 31))
01bc  +0x029a0  op=17  04 07 07 07  OP_17            raw operands=04 07 07 07 imm16=1799 q1=0
01bd  +0x029b8  op=b3  01 08 01 01  AND64            s1 = s1 & s8
01be  +0x029d0  op=36  09 00 08 01  NOR64            s8 = ~(s9 | s0)
01bf  +0x029e8  op=b3  07 08 07 01  AND64            s7 = s7 & s8
01c0  +0x02a00  op=34  07 01 01 01  OR64             s1 = s7 | s1
01c1  +0x02a18  op=84  13 14 07 14  ADD64            s7 = s19 + s20
01c2  +0x02a30  op=85  14 14 01 00  ADD64_IMM16      s20 = s20 +0x1
01c3  +0x02a48  op=26  07 01 00 00  ST8              *(s7 +0x0) = (uint8_t)s1
01c4  +0x02a60  op=a7  14 0b e6 ff  BR_NE64          if (s20 != s11) goto record +427
01c5  +0x02a78  op=14  12 01 40 00  CMP_LO_IMM64     s1 = ((uint64_t)s18 < (uint64_t)64) ? 1 : 0
01c6  +0x02a90  op=a7  01 00 0d 00  BR_NE64          if (s1 != s0) goto record +468
01c7  +0x02aa8  op=34  1e 00 1d 00  OR64             s29 = s30 | s0
01c8  +0x02ac0  op=58  1d 10 10 04  LD64             s16 = *(uint64_t *)(s29 +0x410)
01c9  +0x02ad8  op=58  1d 11 18 04  LD64             s17 = *(uint64_t *)(s29 +0x418)
01ca  +0x02af0  op=58  1d 12 20 04  LD64             s18 = *(uint64_t *)(s29 +0x420)
01cb  +0x02b08  op=58  1d 13 28 04  LD64             s19 = *(uint64_t *)(s29 +0x428)
01cc  +0x02b20  op=58  1d 14 30 04  LD64             s20 = *(uint64_t *)(s29 +0x430)
01cd  +0x02b38  op=58  1d 15 38 04  LD64             s21 = *(uint64_t *)(s29 +0x438)
01ce  +0x02b50  op=58  1d 16 40 04  LD64             s22 = *(uint64_t *)(s29 +0x440)
01cf  +0x02b68  op=58  1d 17 48 04  LD64             s23 = *(uint64_t *)(s29 +0x448)
01d0  +0x02b80  op=58  1d 1e 50 04  LD64             s30 = *(uint64_t *)(s29 +0x450)
01d1  +0x02b98  op=58  1d 1f 58 04  LD64             s31 = *(uint64_t *)(s29 +0x458)
01d2  +0x02bb0  op=85  1d 1d 60 04  ADD64_IMM16      s29 = s29 +0x460
01d3  +0x02bc8  op=5b  1f 00 00 00  RET              return/leave with s31
01d4  +0x02be0  op=59  1e 02 70 00  LD8U             s2 = *(uint8_t *)(s30 +0x70)
01d5  +0x02bf8  op=84  11 12 01 04  ADD64            s1 = s17 + s18
01d6  +0x02c10  op=6e  02 12 17 03  SHL64_IMM        s23 = s18 << 3
01d7  +0x02c28  op=85  1e 16 50 00  ADD64_IMM16      s22 = s30 +0x50
01d8  +0x02c40  op=26  01 02 00 00  ST8              *(s1 +0x0) = (uint8_t)s2
01d9  +0x02c58  op=14  12 01 38 00  CMP_LO_IMM64     s1 = ((uint64_t)s18 < (uint64_t)56) ? 1 : 0
01da  +0x02c70  op=a7  01 00 48 00  BR_NE64          if (s1 != s0) goto record +547
01db  +0x02c88  op=33  11 02 01 00  OR_IMM16         s2 = s17 | 0x1
01dc  +0x02ca0  op=33  13 03 01 00  OR_IMM16         s3 = s19 | 0x1
01dd  +0x02cb8  op=85  00 04 3f 00  ADD64_IMM16      s4 = s0 +0x3f
01de  +0x02cd0  op=ae  12 04 06 00  BR_EQ64          if (s18 == s4) goto record +485
01df  +0x02ce8  op=59  03 05 00 00  LD8U             s5 = *(uint8_t *)(s3 +0x0)
01e0  +0x02d00  op=84  02 12 01 00  ADD64            s1 = s2 + s18
01e1  +0x02d18  op=85  12 12 01 00  ADD64_IMM16      s18 = s18 +0x1
01e2  +0x02d30  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1
01e3  +0x02d48  op=26  01 05 00 00  ST8              *(s1 +0x0) = (uint8_t)s5
01e4  +0x02d60  op=a7  12 04 fa ff  BR_NE64          if (s18 != s4) goto record +479
01e5  +0x02d78  op=85  00 15 00 00  ADD64_IMM16      s21 = s0 +0x0
01e6  +0x02d90  op=85  1e 14 b0 00  ADD64_IMM16      s20 = s30 +0xb0
01e7  +0x02da8  op=85  00 06 00 02  ADD64_IMM16      s6 = s0 +0x200
01e8  +0x02dc0  op=25  1e 00 68 00  ST64             *(s30 +0x68) = s0
01e9  +0x02dd8  op=25  1e 00 60 00  ST64             *(s30 +0x60) = s0
01ea  +0x02df0  op=25  1e 00 58 00  ST64             *(s30 +0x58) = s0
01eb  +0x02e08  op=25  1e 00 50 00  ST64             *(s30 +0x50) = s0
01ec  +0x02e20  op=34  14 00 04 00  OR64             s4 = s20 | s0
01ed  +0x02e38  op=34  15 00 05 01  OR64             s5 = s21 | s0
01ee  +0x02e50  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
01ef  +0x02e68  op=58  1e 12 38 00  LD64             s18 = *(uint64_t *)(s30 +0x38)
01f0  +0x02e80  op=85  00 05 40 00  ADD64_IMM16      s5 = s0 +0x40
01f1  +0x02e98  op=85  00 0e 20 00  ADD64_IMM16      s14 = s0 +0x20
01f2  +0x02eb0  op=ae  15 0e 06 00  BR_EQ64          if (s21 == s14) goto record +505
01f3  +0x02ec8  op=84  10 15 02 04  ADD64            s2 = s16 + s21
01f4  +0x02ee0  op=84  16 15 01 14  ADD64            s1 = s22 + s21
01f5  +0x02ef8  op=85  15 15 04 00  ADD64_IMM16      s21 = s21 +0x4
01f6  +0x02f10  op=52  02 02 00 00  LD32S            s2 = *(int32_t *)(s2 +0x0)
01f7  +0x02f28  op=08  01 02 00 00  ST32             *(s1 +0x0) = (uint32_t)s2
01f8  +0x02f40  op=a7  15 0e fa ff  BR_NE64          if (s21 != s14) goto record +499
01f9  +0x02f58  op=58  1e 15 20 00  LD64             s21 = *(uint64_t *)(s30 +0x20)
01fa  +0x02f70  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
01fb  +0x02f88  op=ae  02 05 0f 00  BR_EQ64          if (s2 == s5) goto record +523
01fc  +0x02fa0  op=84  11 02 01 14  ADD64            s1 = s17 + s2
01fd  +0x02fb8  op=59  01 03 00 00  LD8U             s3 = *(uint8_t *)(s1 +0x0)
01fe  +0x02fd0  op=59  01 04 01 00  LD8U             s4 = *(uint8_t *)(s1 +0x1)
01ff  +0x02fe8  op=18  00 03 03 18  SHL32_IMM        s3 = (int32_t)(s3 << 24)
0200  +0x03000  op=18  10 04 04 10  SHL32_IMM        s4 = (int32_t)(s4 << 16)
0201  +0x03018  op=34  04 03 03 01  OR64             s3 = s4 | s3
0202  +0x03030  op=59  01 04 02 00  LD8U             s4 = *(uint8_t *)(s1 +0x2)
0203  +0x03048  op=59  01 01 03 00  LD8U             s1 = *(uint8_t *)(s1 +0x3)
0204  +0x03060  op=18  11 04 04 08  SHL32_IMM        s4 = (int32_t)(s4 << 8)
0205  +0x03078  op=34  03 04 03 01  OR64             s3 = s3 | s4
0206  +0x03090  op=34  03 01 01 01  OR64             s1 = s3 | s1
0207  +0x030a8  op=84  14 02 03 00  ADD64            s3 = s20 + s2
0208  +0x030c0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0209  +0x030d8  op=08  03 01 00 00  ST32             *(s3 +0x0) = (uint32_t)s1
020a  +0x030f0  op=a7  02 05 f1 ff  BR_NE64          if (s2 != s5) goto record +508
020b  +0x03108  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
020c  +0x03120  op=85  00 01 c0 01  ADD64_IMM16      s1 = s0 +0x1c0
020d  +0x03138  op=ae  02 01 18 00  BR_EQ64          if (s2 == s1) goto record +550
020e  +0x03150  op=84  14 02 01 14  ADD64            s1 = s20 + s2
020f  +0x03168  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0210  +0x03180  op=52  01 03 04 00  LD32S            s3 = *(int32_t *)(s1 +0x4)
0211  +0x03198  op=2e  10 03 04 12  ROR32_IMM        s4 = ror32((uint32_t)s3, 18)
0212  +0x031b0  op=2e  12 03 05 07  ROR32_IMM        s5 = ror32((uint32_t)s3, 7)
0213  +0x031c8  op=0e  0d 03 03 03  LSR32_IMM        s3 = sign_extend_32((uint32_t)s3 >> 3)
0214  +0x031e0  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
0215  +0x031f8  op=52  01 05 38 00  LD32S            s5 = *(int32_t *)(s1 +0x38)
0216  +0x03210  op=02  04 03 03 01  XOR64            s3 = s3 ^ s4
0217  +0x03228  op=2e  10 05 06 13  ROR32_IMM        s6 = ror32((uint32_t)s5, 19)
0218  +0x03240  op=2e  12 05 07 11  ROR32_IMM        s7 = ror32((uint32_t)s5, 17)
0219  +0x03258  op=0e  0d 05 05 0a  LSR32_IMM        s5 = sign_extend_32((uint32_t)s5 >> 10)
021a  +0x03270  op=02  07 06 04 00  XOR64            s4 = s6 ^ s7
021b  +0x03288  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
021c  +0x032a0  op=52  01 05 24 00  LD32S            s5 = *(int32_t *)(s1 +0x24)
021d  +0x032b8  op=b4  04 05 04 02  ADD32            s4 = int32(s4 + s5)
021e  +0x032d0  op=52  01 05 00 00  LD32S            s5 = *(int32_t *)(s1 +0x0)
021f  +0x032e8  op=b4  04 05 04 12  ADD32            s4 = int32(s4 + s5)
0220  +0x03300  op=b4  04 03 03 12  ADD32            s3 = int32(s4 + s3)
0221  +0x03318  op=08  01 03 40 00  ST32             *(s1 +0x40) = (uint32_t)s3
0222  +0x03330  op=5f  e9 ff ff ff  ADD_PC_IMM32     goto record +524 ; vm_pc = current_pc + 1 + -23
0223  +0x03348  op=85  12 03 01 00  ADD64_IMM16      s3 = s18 +0x1
0224  +0x03360  op=58  1e 12 38 00  LD64             s18 = *(uint64_t *)(s30 +0x38)
0225  +0x03378  op=5f  49 00 00 00  ADD_PC_IMM32     goto record +623 ; vm_pc = current_pc + 1 + 73
0226  +0x03390  op=58  1e 01 28 00  LD64             s1 = *(uint64_t *)(s30 +0x28)
0227  +0x033a8  op=52  1e 02 60 00  LD32S            s2 = *(int32_t *)(s30 +0x60)
0228  +0x033c0  op=52  1e 0c 68 00  LD32S            s12 = *(int32_t *)(s30 +0x68)
0229  +0x033d8  op=52  1e 03 5c 00  LD32S            s3 = *(int32_t *)(s30 +0x5c)
022a  +0x033f0  op=52  1e 04 64 00  LD32S            s4 = *(int32_t *)(s30 +0x64)
022b  +0x03408  op=52  1e 05 58 00  LD32S            s5 = *(int32_t *)(s30 +0x58)
022c  +0x03420  op=52  1e 07 6c 00  LD32S            s7 = *(int32_t *)(s30 +0x6c)
022d  +0x03438  op=52  1e 09 50 00  LD32S            s9 = *(int32_t *)(s30 +0x50)
022e  +0x03450  op=52  1e 0b 54 00  LD32S            s11 = *(int32_t *)(s30 +0x54)
022f  +0x03468  op=85  14 06 34 00  ADD64_IMM16      s6 = s20 +0x34
0230  +0x03480  op=85  01 08 0d 9f  ADD64_IMM16      s8 = s1 -0x60f3
0231  +0x03498  op=58  1e 01 48 00  LD64             s1 = *(uint64_t *)(s30 +0x48)
0232  +0x034b0  op=34  09 00 0a 01  OR64             s10 = s9 | s0
0233  +0x034c8  op=34  07 00 09 01  OR64             s9 = s7 | s0
0234  +0x034e0  op=34  0c 00 07 00  OR64             s7 = s12 | s0
0235  +0x034f8  op=ae  08 01 26 00  BR_EQ64          if (s8 == s1) goto record +604
0236  +0x03510  op=2e  12 0a 01 0b  ROR32_IMM        s1 = ror32((uint32_t)s10, 11)
0237  +0x03528  op=2e  12 0a 0c 06  ROR32_IMM        s12 = ror32((uint32_t)s10, 6)
0238  +0x03540  op=34  03 04 0d 01  OR64             s13 = s3 | s4
0239  +0x03558  op=02  0c 01 01 01  XOR64            s1 = s1 ^ s12
023a  +0x03570  op=2e  10 0a 0c 19  ROR32_IMM        s12 = ror32((uint32_t)s10, 25)
023b  +0x03588  op=b3  0d 07 0d 00  AND64            s13 = s13 & s7
023c  +0x035a0  op=02  01 0c 01 01  XOR64            s1 = s12 ^ s1
023d  +0x035b8  op=52  06 0c 00 00  LD32S            s12 = *(int32_t *)(s6 +0x0)
023e  +0x035d0  op=85  06 06 04 00  ADD64_IMM16      s6 = s6 +0x4
023f  +0x035e8  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
0240  +0x03600  op=b2  08 0b 3f 00  AND64_IMM16      s11 = s8 & 0x3f
0241  +0x03618  op=85  08 08 01 00  ADD64_IMM16      s8 = s8 +0x1
0242  +0x03630  op=6e  02 0b 0b 02  SHL64_IMM        s11 = s11 << 2
0243  +0x03648  op=84  12 0b 0b 14  ADD64            s11 = s18 + s11
0244  +0x03660  op=52  0b 0b 00 00  LD32S            s11 = *(int32_t *)(s11 +0x0)
0245  +0x03678  op=b4  01 0b 01 02  ADD32            s1 = int32(s1 + s11)
0246  +0x03690  op=02  05 09 0b 01  XOR64            s11 = s9 ^ s5
0247  +0x036a8  op=b3  0b 0a 0b 01  AND64            s11 = s11 & s10
0248  +0x036c0  op=b4  01 0c 01 02  ADD32            s1 = int32(s1 + s12)
0249  +0x036d8  op=b3  03 04 0c 01  AND64            s12 = s3 & s4
024a  +0x036f0  op=02  0b 09 0b 00  XOR64            s11 = s9 ^ s11
024b  +0x03708  op=34  0d 0c 0c 01  OR64             s12 = s13 | s12
024c  +0x03720  op=2e  01 04 0d 02  ROR32_IMM        s13 = ror32((uint32_t)s4, 2)
024d  +0x03738  op=b4  01 0b 01 00  ADD32            s1 = int32(s1 + s11)
024e  +0x03750  op=2e  12 04 0b 0d  ROR32_IMM        s11 = ror32((uint32_t)s4, 13)
024f  +0x03768  op=02  0d 0b 0b 01  XOR64            s11 = s11 ^ s13
0250  +0x03780  op=2e  01 04 0d 16  ROR32_IMM        s13 = ror32((uint32_t)s4, 22)
0251  +0x03798  op=02  0b 0d 0b 00  XOR64            s11 = s13 ^ s11
0252  +0x037b0  op=b4  01 0b 0b 12  ADD32            s11 = int32(s1 + s11)
0253  +0x037c8  op=b4  02 01 01 02  ADD32            s1 = int32(s2 + s1)
0254  +0x037e0  op=34  03 00 02 01  OR64             s2 = s3 | s0
0255  +0x037f8  op=34  05 00 03 01  OR64             s3 = s5 | s0
0256  +0x03810  op=b4  0b 0c 0b 00  ADD32            s11 = int32(s11 + s12)
0257  +0x03828  op=34  04 00 0c 00  OR64             s12 = s4 | s0
0258  +0x03840  op=34  01 00 04 01  OR64             s4 = s1 | s0
0259  +0x03858  op=34  0b 00 05 01  OR64             s5 = s11 | s0
025a  +0x03870  op=34  0a 00 0b 00  OR64             s11 = s10 | s0
025b  +0x03888  op=5f  d5 ff ff ff  ADD_PC_IMM32     goto record +561 ; vm_pc = current_pc + 1 + -43
025c  +0x038a0  op=08  1e 09 6c 00  ST32             *(s30 +0x6c) = (uint32_t)s9
025d  +0x038b8  op=08  1e 0a 50 00  ST32             *(s30 +0x50) = (uint32_t)s10
025e  +0x038d0  op=08  1e 0b 54 00  ST32             *(s30 +0x54) = (uint32_t)s11
025f  +0x038e8  op=08  1e 04 64 00  ST32             *(s30 +0x64) = (uint32_t)s4
0260  +0x03900  op=08  1e 05 58 00  ST32             *(s30 +0x58) = (uint32_t)s5
0261  +0x03918  op=08  1e 07 68 00  ST32             *(s30 +0x68) = (uint32_t)s7
0262  +0x03930  op=08  1e 03 5c 00  ST32             *(s30 +0x5c) = (uint32_t)s3
0263  +0x03948  op=08  1e 02 60 00  ST32             *(s30 +0x60) = (uint32_t)s2
0264  +0x03960  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0265  +0x03978  op=ae  02 0e 08 00  BR_EQ64          if (s2 == s14) goto record +622
0266  +0x03990  op=84  16 02 04 00  ADD64            s4 = s22 + s2
0267  +0x039a8  op=84  10 02 01 14  ADD64            s1 = s16 + s2
0268  +0x039c0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0269  +0x039d8  op=52  01 03 00 00  LD32S            s3 = *(int32_t *)(s1 +0x0)
026a  +0x039f0  op=52  04 04 00 00  LD32S            s4 = *(int32_t *)(s4 +0x0)
026b  +0x03a08  op=b4  04 03 03 02  ADD32            s3 = int32(s4 + s3)
026c  +0x03a20  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
026d  +0x03a38  op=a7  02 0e f8 ff  BR_NE64          if (s2 != s14) goto record +614
026e  +0x03a50  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0
026f  +0x03a68  op=58  1e 01 40 00  LD64             s1 = *(uint64_t *)(s30 +0x40)
0270  +0x03a80  op=33  13 04 01 00  OR_IMM16         s4 = s19 | 0x1
0271  +0x03a98  op=84  01 17 02 04  ADD64            s2 = s1 + s23
0272  +0x03ab0  op=14  03 01 38 00  CMP_LO_IMM64     s1 = ((uint64_t)s3 < (uint64_t)56) ? 1 : 0
0273  +0x03ac8  op=ae  01 00 06 00  BR_EQ64          if (s1 == s0) goto record +634
0274  +0x03ae0  op=59  04 05 00 00  LD8U             s5 = *(uint8_t *)(s4 +0x0)
0275  +0x03af8  op=84  11 03 01 00  ADD64            s1 = s17 + s3
0276  +0x03b10  op=85  04 04 01 00  ADD64_IMM16      s4 = s4 +0x1
0277  +0x03b28  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1
0278  +0x03b40  op=26  01 05 00 00  ST8              *(s1 +0x0) = (uint8_t)s5
0279  +0x03b58  op=5f  f8 ff ff ff  ADD_PC_IMM32     goto record +626 ; vm_pc = current_pc + 1 + -8
027a  +0x03b70  op=67  00 02 01 18  LSR64_IMM32PLUS  s1 = (uint64_t)s2 >> (24 + 32)
027b  +0x03b88  op=26  1e 02 0f 04  ST8              *(s30 +0x40f) = (uint8_t)s2
027c  +0x03ba0  op=67  00 02 03 10  LSR64_IMM32PLUS  s3 = (uint64_t)s2 >> (16 + 32)
027d  +0x03bb8  op=67  00 02 04 08  LSR64_IMM32PLUS  s4 = (uint64_t)s2 >> (8 + 32)
027e  +0x03bd0  op=67  00 02 05 00  LSR64_IMM32PLUS  s5 = (uint64_t)s2 >> (0 + 32)
027f  +0x03be8  op=85  00 14 00 00  ADD64_IMM16      s20 = s0 +0x0
0280  +0x03c00  op=85  1e 13 b0 00  ADD64_IMM16      s19 = s30 +0xb0
0281  +0x03c18  op=85  00 06 00 02  ADD64_IMM16      s6 = s0 +0x200
0282  +0x03c30  op=25  1e 00 68 00  ST64             *(s30 +0x68) = s0
0283  +0x03c48  op=25  1e 00 60 00  ST64             *(s30 +0x60) = s0
0284  +0x03c60  op=25  1e 00 58 00  ST64             *(s30 +0x58) = s0
0285  +0x03c78  op=25  1e 00 50 00  ST64             *(s30 +0x50) = s0
0286  +0x03c90  op=26  1e 01 08 04  ST8              *(s30 +0x408) = (uint8_t)s1
0287  +0x03ca8  op=68  00 02 01 08  LSR64_IMM        s1 = (uint64_t)s2 >> 8
0288  +0x03cc0  op=26  1e 05 0b 04  ST8              *(s30 +0x40b) = (uint8_t)s5
0289  +0x03cd8  op=26  1e 04 0a 04  ST8              *(s30 +0x40a) = (uint8_t)s4
028a  +0x03cf0  op=26  1e 03 09 04  ST8              *(s30 +0x409) = (uint8_t)s3
028b  +0x03d08  op=34  13 00 04 01  OR64             s4 = s19 | s0
028c  +0x03d20  op=34  14 00 05 00  OR64             s5 = s20 | s0
028d  +0x03d38  op=26  1e 01 0e 04  ST8              *(s30 +0x40e) = (uint8_t)s1
028e  +0x03d50  op=68  00 02 01 10  LSR64_IMM        s1 = (uint64_t)s2 >> 16
028f  +0x03d68  op=26  1e 01 0d 04  ST8              *(s30 +0x40d) = (uint8_t)s1
0290  +0x03d80  op=68  03 02 01 18  LSR64_IMM        s1 = (uint64_t)s2 >> 24
0291  +0x03d98  op=26  1e 01 0c 04  ST8              *(s30 +0x40c) = (uint8_t)s1
0292  +0x03db0  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0293  +0x03dc8  op=85  00 05 40 00  ADD64_IMM16      s5 = s0 +0x40
0294  +0x03de0  op=85  00 0e 20 00  ADD64_IMM16      s14 = s0 +0x20
0295  +0x03df8  op=ae  14 0e 06 00  BR_EQ64          if (s20 == s14) goto record +668
0296  +0x03e10  op=84  10 14 02 14  ADD64            s2 = s16 + s20
0297  +0x03e28  op=84  16 14 01 04  ADD64            s1 = s22 + s20
0298  +0x03e40  op=85  14 14 04 00  ADD64_IMM16      s20 = s20 +0x4
0299  +0x03e58  op=52  02 02 00 00  LD32S            s2 = *(int32_t *)(s2 +0x0)
029a  +0x03e70  op=08  01 02 00 00  ST32             *(s1 +0x0) = (uint32_t)s2
029b  +0x03e88  op=a7  14 0e fa ff  BR_NE64          if (s20 != s14) goto record +662
029c  +0x03ea0  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
029d  +0x03eb8  op=ae  02 05 0f 00  BR_EQ64          if (s2 == s5) goto record +685
029e  +0x03ed0  op=84  11 02 01 14  ADD64            s1 = s17 + s2
029f  +0x03ee8  op=59  01 03 00 00  LD8U             s3 = *(uint8_t *)(s1 +0x0)
02a0  +0x03f00  op=59  01 04 01 00  LD8U             s4 = *(uint8_t *)(s1 +0x1)
02a1  +0x03f18  op=18  10 03 03 18  SHL32_IMM        s3 = (int32_t)(s3 << 24)
02a2  +0x03f30  op=18  11 04 04 10  SHL32_IMM        s4 = (int32_t)(s4 << 16)
02a3  +0x03f48  op=34  04 03 03 00  OR64             s3 = s4 | s3
02a4  +0x03f60  op=59  01 04 02 00  LD8U             s4 = *(uint8_t *)(s1 +0x2)
02a5  +0x03f78  op=59  01 01 03 00  LD8U             s1 = *(uint8_t *)(s1 +0x3)
02a6  +0x03f90  op=18  00 04 04 08  SHL32_IMM        s4 = (int32_t)(s4 << 8)
02a7  +0x03fa8  op=34  03 04 03 01  OR64             s3 = s3 | s4
02a8  +0x03fc0  op=34  03 01 01 00  OR64             s1 = s3 | s1
02a9  +0x03fd8  op=84  13 02 03 14  ADD64            s3 = s19 + s2
02aa  +0x03ff0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
02ab  +0x04008  op=08  03 01 00 00  ST32             *(s3 +0x0) = (uint32_t)s1
02ac  +0x04020  op=a7  02 05 f1 ff  BR_NE64          if (s2 != s5) goto record +670
02ad  +0x04038  op=58  1e 0f 48 00  LD64             s15 = *(uint64_t *)(s30 +0x48)
02ae  +0x04050  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
02af  +0x04068  op=85  00 08 c0 01  ADD64_IMM16      s8 = s0 +0x1c0
02b0  +0x04080  op=ae  02 08 15 00  BR_EQ64          if (s2 == s8) goto record +710
02b1  +0x04098  op=84  13 02 01 04  ADD64            s1 = s19 + s2
02b2  +0x040b0  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
02b3  +0x040c8  op=52  01 03 04 00  LD32S            s3 = *(int32_t *)(s1 +0x4)
02b4  +0x040e0  op=2e  01 03 04 12  ROR32_IMM        s4 = ror32((uint32_t)s3, 18)
02b5  +0x040f8  op=2e  01 03 05 07  ROR32_IMM        s5 = ror32((uint32_t)s3, 7)
02b6  +0x04110  op=0e  0d 03 03 03  LSR32_IMM        s3 = sign_extend_32((uint32_t)s3 >> 3)
02b7  +0x04128  op=02  05 04 04 01  XOR64            s4 = s4 ^ s5
02b8  +0x04140  op=52  01 05 38 00  LD32S            s5 = *(int32_t *)(s1 +0x38)
02b9  +0x04158  op=02  04 03 03 01  XOR64            s3 = s3 ^ s4
02ba  +0x04170  op=2e  10 05 06 13  ROR32_IMM        s6 = ror32((uint32_t)s5, 19)
02bb  +0x04188  op=2e  01 05 07 11  ROR32_IMM        s7 = ror32((uint32_t)s5, 17)
02bc  +0x041a0  op=0e  00 05 05 0a  LSR32_IMM        s5 = sign_extend_32((uint32_t)s5 >> 10)
02bd  +0x041b8  op=02  07 06 04 01  XOR64            s4 = s6 ^ s7
02be  +0x041d0  op=02  04 05 04 01  XOR64            s4 = s5 ^ s4
02bf  +0x041e8  op=52  01 05 24 00  LD32S            s5 = *(int32_t *)(s1 +0x24)
02c0  +0x04200  op=b4  04 05 04 02  ADD32            s4 = int32(s4 + s5)
02c1  +0x04218  op=52  01 05 00 00  LD32S            s5 = *(int32_t *)(s1 +0x0)
02c2  +0x04230  op=b4  04 05 04 12  ADD32            s4 = int32(s4 + s5)
02c3  +0x04248  op=b4  04 03 03 12  ADD32            s3 = int32(s4 + s3)
02c4  +0x04260  op=08  01 03 40 00  ST32             *(s1 +0x40) = (uint32_t)s3
02c5  +0x04278  op=a7  02 08 eb ff  BR_NE64          if (s2 != s8) goto record +689
02c6  +0x04290  op=58  1e 01 28 00  LD64             s1 = *(uint64_t *)(s30 +0x28)
02c7  +0x042a8  op=52  1e 02 60 00  LD32S            s2 = *(int32_t *)(s30 +0x60)
02c8  +0x042c0  op=52  1e 0c 68 00  LD32S            s12 = *(int32_t *)(s30 +0x68)
02c9  +0x042d8  op=52  1e 03 5c 00  LD32S            s3 = *(int32_t *)(s30 +0x5c)
02ca  +0x042f0  op=52  1e 04 64 00  LD32S            s4 = *(int32_t *)(s30 +0x64)
02cb  +0x04308  op=52  1e 05 58 00  LD32S            s5 = *(int32_t *)(s30 +0x58)
02cc  +0x04320  op=52  1e 07 6c 00  LD32S            s7 = *(int32_t *)(s30 +0x6c)
02cd  +0x04338  op=52  1e 09 50 00  LD32S            s9 = *(int32_t *)(s30 +0x50)
02ce  +0x04350  op=52  1e 0b 54 00  LD32S            s11 = *(int32_t *)(s30 +0x54)
02cf  +0x04368  op=85  13 06 34 00  ADD64_IMM16      s6 = s19 +0x34
02d0  +0x04380  op=85  01 08 0d 9f  ADD64_IMM16      s8 = s1 -0x60f3
02d1  +0x04398  op=34  09 00 0a 01  OR64             s10 = s9 | s0
02d2  +0x043b0  op=34  07 00 09 00  OR64             s9 = s7 | s0
02d3  +0x043c8  op=34  0c 00 07 01  OR64             s7 = s12 | s0
02d4  +0x043e0  op=ae  08 0f 26 00  BR_EQ64          if (s8 == s15) goto record +763
02d5  +0x043f8  op=2e  10 0a 01 0b  ROR32_IMM        s1 = ror32((uint32_t)s10, 11)
02d6  +0x04410  op=2e  12 0a 0c 06  ROR32_IMM        s12 = ror32((uint32_t)s10, 6)
02d7  +0x04428  op=34  03 04 0d 01  OR64             s13 = s3 | s4
02d8  +0x04440  op=02  0c 01 01 01  XOR64            s1 = s1 ^ s12
02d9  +0x04458  op=2e  12 0a 0c 19  ROR32_IMM        s12 = ror32((uint32_t)s10, 25)
02da  +0x04470  op=b3  0d 07 0d 01  AND64            s13 = s13 & s7
02db  +0x04488  op=02  01 0c 01 01  XOR64            s1 = s12 ^ s1
02dc  +0x044a0  op=52  06 0c 00 00  LD32S            s12 = *(int32_t *)(s6 +0x0)
02dd  +0x044b8  op=85  06 06 04 00  ADD64_IMM16      s6 = s6 +0x4
02de  +0x044d0  op=b4  01 0b 01 12  ADD32            s1 = int32(s1 + s11)
02df  +0x044e8  op=b2  08 0b 3f 00  AND64_IMM16      s11 = s8 & 0x3f
02e0  +0x04500  op=85  08 08 01 00  ADD64_IMM16      s8 = s8 +0x1
02e1  +0x04518  op=6e  12 0b 0b 02  SHL64_IMM        s11 = s11 << 2
02e2  +0x04530  op=84  12 0b 0b 14  ADD64            s11 = s18 + s11
02e3  +0x04548  op=52  0b 0b 00 00  LD32S            s11 = *(int32_t *)(s11 +0x0)
02e4  +0x04560  op=b4  01 0b 01 00  ADD32            s1 = int32(s1 + s11)
02e5  +0x04578  op=02  05 09 0b 01  XOR64            s11 = s9 ^ s5
02e6  +0x04590  op=b3  0b 0a 0b 01  AND64            s11 = s11 & s10
02e7  +0x045a8  op=b4  01 0c 01 02  ADD32            s1 = int32(s1 + s12)
02e8  +0x045c0  op=b3  03 04 0c 01  AND64            s12 = s3 & s4
02e9  +0x045d8  op=02  0b 09 0b 01  XOR64            s11 = s9 ^ s11
02ea  +0x045f0  op=34  0d 0c 0c 00  OR64             s12 = s13 | s12
02eb  +0x04608  op=2e  01 04 0d 02  ROR32_IMM        s13 = ror32((uint32_t)s4, 2)
02ec  +0x04620  op=b4  01 0b 01 00  ADD32            s1 = int32(s1 + s11)
02ed  +0x04638  op=2e  12 04 0b 0d  ROR32_IMM        s11 = ror32((uint32_t)s4, 13)
02ee  +0x04650  op=02  0d 0b 0b 01  XOR64            s11 = s11 ^ s13
02ef  +0x04668  op=2e  01 04 0d 16  ROR32_IMM        s13 = ror32((uint32_t)s4, 22)
02f0  +0x04680  op=02  0b 0d 0b 00  XOR64            s11 = s13 ^ s11
02f1  +0x04698  op=b4  01 0b 0b 12  ADD32            s11 = int32(s1 + s11)
02f2  +0x046b0  op=b4  02 01 01 00  ADD32            s1 = int32(s2 + s1)
02f3  +0x046c8  op=34  03 00 02 01  OR64             s2 = s3 | s0
02f4  +0x046e0  op=34  05 00 03 01  OR64             s3 = s5 | s0
02f5  +0x046f8  op=b4  0b 0c 0b 00  ADD32            s11 = int32(s11 + s12)
02f6  +0x04710  op=34  04 00 0c 01  OR64             s12 = s4 | s0
02f7  +0x04728  op=34  01 00 04 00  OR64             s4 = s1 | s0
02f8  +0x04740  op=34  0b 00 05 01  OR64             s5 = s11 | s0
02f9  +0x04758  op=34  0a 00 0b 01  OR64             s11 = s10 | s0
02fa  +0x04770  op=5f  d6 ff ff ff  ADD_PC_IMM32     goto record +721 ; vm_pc = current_pc + 1 + -42
02fb  +0x04788  op=08  1e 09 6c 00  ST32             *(s30 +0x6c) = (uint32_t)s9
02fc  +0x047a0  op=08  1e 0a 50 00  ST32             *(s30 +0x50) = (uint32_t)s10
02fd  +0x047b8  op=08  1e 0b 54 00  ST32             *(s30 +0x54) = (uint32_t)s11
02fe  +0x047d0  op=08  1e 04 64 00  ST32             *(s30 +0x64) = (uint32_t)s4
02ff  +0x047e8  op=08  1e 05 58 00  ST32             *(s30 +0x58) = (uint32_t)s5
0300  +0x04800  op=08  1e 07 68 00  ST32             *(s30 +0x68) = (uint32_t)s7
0301  +0x04818  op=08  1e 03 5c 00  ST32             *(s30 +0x5c) = (uint32_t)s3
0302  +0x04830  op=08  1e 02 60 00  ST32             *(s30 +0x60) = (uint32_t)s2
0303  +0x04848  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0304  +0x04860  op=ae  02 0e 08 00  BR_EQ64          if (s2 == s14) goto record +781
0305  +0x04878  op=84  16 02 04 04  ADD64            s4 = s22 + s2
0306  +0x04890  op=84  10 02 01 00  ADD64            s1 = s16 + s2
0307  +0x048a8  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0308  +0x048c0  op=52  01 03 00 00  LD32S            s3 = *(int32_t *)(s1 +0x0)
0309  +0x048d8  op=52  04 04 00 00  LD32S            s4 = *(int32_t *)(s4 +0x0)
030a  +0x048f0  op=b4  04 03 03 00  ADD32            s3 = int32(s4 + s3)
030b  +0x04908  op=08  01 03 00 00  ST32             *(s1 +0x0) = (uint32_t)s3
030c  +0x04920  op=a7  02 0e f8 ff  BR_NE64          if (s2 != s14) goto record +773
030d  +0x04938  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
030e  +0x04950  op=ae  02 0e b8 fe  BR_EQ64          if (s2 == s14) goto record +455
030f  +0x04968  op=84  10 02 01 04  ADD64            s1 = s16 + s2
0310  +0x04980  op=84  15 02 04 14  ADD64            s4 = s21 + s2
0311  +0x04998  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0312  +0x049b0  op=52  01 01 00 00  LD32S            s1 = *(int32_t *)(s1 +0x0)
0313  +0x049c8  op=0e  0b 01 03 08  LSR32_IMM        s3 = sign_extend_32((uint32_t)s1 >> 8)
0314  +0x049e0  op=26  04 01 03 00  ST8              *(s4 +0x3) = (uint8_t)s1
0315  +0x049f8  op=26  04 03 02 00  ST8              *(s4 +0x2) = (uint8_t)s3
0316  +0x04a10  op=0e  00 01 03 10  LSR32_IMM        s3 = sign_extend_32((uint32_t)s1 >> 16)
0317  +0x04a28  op=0e  0d 01 01 18  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 24)
0318  +0x04a40  op=26  04 03 01 00  ST8              *(s4 +0x1) = (uint8_t)s3
0319  +0x04a58  op=26  04 01 00 00  ST8              *(s4 +0x0) = (uint8_t)s1
031a  +0x04a70  op=a7  02 0e f4 ff  BR_NE64          if (s2 != s14) goto record +783
031b  +0x04a88  op=5f  ab fe ff ff  ADD_PC_IMM32     goto record +455 ; vm_pc = current_pc + 1 + -341

; MetaSec managed bytecode decode: F64
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F64_0x654c00_0x10c8.bin
; records: 179  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 60 ff  ADD64_IMM16      s29 = s29 -0xa0
0001  +0x00018  op=25  1d 1f 98 00  ST64             *(s29 +0x98) = s31
0002  +0x00030  op=25  1d 1e 90 00  ST64             *(s29 +0x90) = s30
0003  +0x00048  op=25  1d 15 88 00  ST64             *(s29 +0x88) = s21
0004  +0x00060  op=25  1d 14 80 00  ST64             *(s29 +0x80) = s20
0005  +0x00078  op=25  1d 13 78 00  ST64             *(s29 +0x78) = s19
0006  +0x00090  op=25  1d 12 70 00  ST64             *(s29 +0x70) = s18
0007  +0x000a8  op=25  1d 11 68 00  ST64             *(s29 +0x68) = s17
0008  +0x000c0  op=25  1d 10 60 00  ST64             *(s29 +0x60) = s16
0009  +0x000d8  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000a  +0x000f0  op=52  04 15 00 00  LD32S            s21 = *(int32_t *)(s4 +0x0)
000b  +0x00108  op=85  00 14 40 00  ADD64_IMM16      s20 = s0 +0x40
000c  +0x00120  op=85  1e 12 18 00  ADD64_IMM16      s18 = s30 +0x18
000d  +0x00138  op=85  00 13 00 00  ADD64_IMM16      s19 = s0 +0x0
000e  +0x00150  op=34  05 00 10 01  OR64             s16 = s5 | s0
000f  +0x00168  op=34  04 00 11 01  OR64             s17 = s4 | s0
0010  +0x00180  op=34  12 00 04 00  OR64             s4 = s18 | s0
0011  +0x00198  op=34  13 00 05 00  OR64             s5 = s19 | s0
0012  +0x001b0  op=34  14 00 06 01  OR64             s6 = s20 | s0
0013  +0x001c8  op=18  11 15 01 03  SHL32_IMM        s1 = (int32_t)(s21 << 3)
0014  +0x001e0  op=08  1e 01 58 00  ST32             *(s30 +0x58) = (uint32_t)s1
0015  +0x001f8  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd360 rt/so-mapped
0016  +0x00210  op=b2  15 02 3f 00  AND64_IMM16      s2 = s21 & 0x3f
0017  +0x00228  op=b5  00 03 7c 00  ADD32_IMM16      s3 = int32(s0 +0x7c)
0018  +0x00240  op=b5  00 04 3c 00  ADD32_IMM16      s4 = int32(s0 +0x3c)
0019  +0x00258  op=b5  00 05 f8 ff  ADD32_IMM16      s5 = int32(s0 -0x8)
001a  +0x00270  op=53  04 07 90 09  LD_POOL_PTR      s7 = *(uint64_t *)q1 + 0x990 ; q1=0x125fd3a8 rt/so-mapped
001b  +0x00288  op=b5  00 08 00 00  ADD32_IMM16      s8 = int32(s0 +0x0)
001c  +0x002a0  op=14  02 01 3c 00  CMP_LO_IMM64     s1 = ((uint64_t)s2 < (uint64_t)60) ? 1 : 0
001d  +0x002b8  op=1f  03 01 03 00  CMOVZ64          s3 = (s1 == 0) ? s3 : 0
001e  +0x002d0  op=1e  04 01 01 11  CMOVNZ64         s1 = (s1 != 0) ? s4 : 0
001f  +0x002e8  op=52  11 04 58 00  LD32S            s4 = *(int32_t *)(s17 +0x58)
0020  +0x00300  op=34  01 03 03 01  OR64             s3 = s1 | s3
0021  +0x00318  op=b5  00 01 08 00  ADD32_IMM16      s1 = int32(s0 +0x8)
0022  +0x00330  op=b5  04 04 04 00  ADD32_IMM16      s4 = int32(s4 +0x4)
0023  +0x00348  op=b2  04 04 07 00  AND64_IMM16      s4 = s4 & 0x7
0024  +0x00360  op=34  04 05 05 01  OR64             s5 = s4 | s5
0025  +0x00378  op=09  01 04 06 14  SUB32            s6 = sign_extend_32((uint32_t)s1 - (uint32_t)s4)
0026  +0x00390  op=ae  13 14 1a 00  BR_EQ64          if (s19 == s20) goto record +65
0027  +0x003a8  op=84  07 13 01 04  ADD64            s1 = s7 + s19
0028  +0x003c0  op=34  05 00 0b 01  OR64             s11 = s5 | s0
0029  +0x003d8  op=34  08 00 0a 00  OR64             s10 = s8 | s0
002a  +0x003f0  op=59  01 09 00 00  LD8U             s9 = *(uint8_t *)(s1 +0x0)
002b  +0x00408  op=ae  0b 00 04 00  BR_EQ64          if (s11 == s0) goto record +48
002c  +0x00420  op=18  10 0a 01 01  SHL32_IMM        s1 = (int32_t)(s10 << 1)
002d  +0x00438  op=b5  0b 0b 01 00  ADD32_IMM16      s11 = int32(s11 +0x1)
002e  +0x00450  op=33  01 0a 01 00  OR_IMM16         s10 = s1 | 0x1
002f  +0x00468  op=a7  0b 00 fc ff  BR_NE64          if (s11 != s0) goto record +44
0030  +0x00480  op=34  05 00 0c 01  OR64             s12 = s5 | s0
0031  +0x00498  op=34  08 00 0b 01  OR64             s11 = s8 | s0
0032  +0x004b0  op=ae  0c 00 04 00  BR_EQ64          if (s12 == s0) goto record +55
0033  +0x004c8  op=18  00 0b 01 01  SHL32_IMM        s1 = (int32_t)(s11 << 1)
0034  +0x004e0  op=b5  0c 0c 01 00  ADD32_IMM16      s12 = int32(s12 +0x1)
0035  +0x004f8  op=33  01 0b 01 00  OR_IMM16         s11 = s1 | 0x1
0036  +0x00510  op=a7  0c 00 fc ff  BR_NE64          if (s12 != s0) goto record +51
0037  +0x00528  op=0d  04 09 01 11  BYTE_FROM_U32_SHIFT s4 = (uint8_t)((uint32_t)s9 >> (s1 & 31))
0038  +0x00540  op=17  06 09 09 00  SHL32_VAR        s9 = (int32_t)((uint32_t)s9 << ((uint32_t)s6 & 31))
0039  +0x00558  op=b3  01 0a 01 01  AND64            s1 = s1 & s10
003a  +0x00570  op=36  0b 00 0a 00  NOR64            s10 = ~(s11 | s0)
003b  +0x00588  op=b3  09 0a 09 00  AND64            s9 = s9 & s10
003c  +0x005a0  op=34  09 01 01 01  OR64             s1 = s9 | s1
003d  +0x005b8  op=84  12 13 09 00  ADD64            s9 = s18 + s19
003e  +0x005d0  op=85  13 13 01 00  ADD64_IMM16      s19 = s19 +0x1
003f  +0x005e8  op=26  09 01 00 00  ST8              *(s9 +0x0) = (uint8_t)s1
0040  +0x00600  op=a7  13 14 e6 ff  BR_NE64          if (s19 != s20) goto record +39
0041  +0x00618  op=09  03 02 01 04  SUB32            s1 = sign_extend_32((uint32_t)s3 - (uint32_t)s2)
0042  +0x00630  op=85  1e 05 18 00  ADD64_IMM16      s5 = s30 +0x18
0043  +0x00648  op=34  11 00 04 01  OR64             s4 = s17 | s0
0044  +0x00660  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
0045  +0x00678  op=67  00 01 06 00  LSR64_IMM32PLUS  s6 = (uint64_t)s1 >> (0 + 32)
0046  +0x00690  op=5e  41 00 00 00  CALL_CF_INDEX    call native_binding[index=0x41] via q1 table ; q1=0x125fd360 rt/so-mapped
0047  +0x006a8  op=85  00 12 04 00  ADD64_IMM16      s18 = s0 +0x4
0048  +0x006c0  op=85  1e 05 58 00  ADD64_IMM16      s5 = s30 +0x58
0049  +0x006d8  op=34  11 00 04 01  OR64             s4 = s17 | s0
004a  +0x006f0  op=34  12 00 06 00  OR64             s6 = s18 | s0
004b  +0x00708  op=5e  41 00 00 00  CALL_CF_INDEX    call native_binding[index=0x41] via q1 table ; q1=0x125fd360 rt/so-mapped
004c  +0x00720  op=25  1e 00 08 00  ST64             *(s30 +0x8) = s0
004d  +0x00738  op=25  1e 00 00 00  ST64             *(s30 +0x0) = s0
004e  +0x00750  op=b5  00 01 20 00  ADD32_IMM16      s1 = int32(s0 +0x20)
004f  +0x00768  op=b5  00 04 e0 ff  ADD32_IMM16      s4 = int32(s0 -0x20)
0050  +0x00780  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0051  +0x00798  op=53  04 06 d0 09  LD_POOL_PTR      s6 = *(uint64_t *)q1 + 0x9d0 ; q1=0x125fd3a8 rt/so-mapped
0052  +0x007b0  op=b5  00 07 00 00  ADD32_IMM16      s7 = int32(s0 +0x0)
0053  +0x007c8  op=85  1e 08 00 00  ADD64_IMM16      s8 = s30 +0x0
0054  +0x007e0  op=52  11 03 58 00  LD32S            s3 = *(int32_t *)(s17 +0x58)
0055  +0x007f8  op=b5  03 03 15 00  ADD32_IMM16      s3 = int32(s3 +0x15)
0056  +0x00810  op=b2  03 03 1f 00  AND64_IMM16      s3 = s3 & 0x1f
0057  +0x00828  op=34  03 04 04 01  OR64             s4 = s3 | s4
0058  +0x00840  op=09  01 03 05 00  SUB32            s5 = sign_extend_32((uint32_t)s1 - (uint32_t)s3)
0059  +0x00858  op=ae  02 12 1b 00  BR_EQ64          if (s2 == s18) goto record +117
005a  +0x00870  op=6e  00 02 09 02  SHL64_IMM        s9 = s2 << 2
005b  +0x00888  op=34  04 00 0c 01  OR64             s12 = s4 | s0
005c  +0x008a0  op=34  07 00 0b 01  OR64             s11 = s7 | s0
005d  +0x008b8  op=84  06 09 01 04  ADD64            s1 = s6 + s9
005e  +0x008d0  op=52  01 0a 00 00  LD32S            s10 = *(int32_t *)(s1 +0x0)
005f  +0x008e8  op=ae  0c 00 04 00  BR_EQ64          if (s12 == s0) goto record +100
0060  +0x00900  op=18  10 0b 01 01  SHL32_IMM        s1 = (int32_t)(s11 << 1)
0061  +0x00918  op=b5  0c 0c 01 00  ADD32_IMM16      s12 = int32(s12 +0x1)
0062  +0x00930  op=33  01 0b 01 00  OR_IMM16         s11 = s1 | 0x1
0063  +0x00948  op=a7  0c 00 fc ff  BR_NE64          if (s12 != s0) goto record +96
0064  +0x00960  op=34  04 00 0d 00  OR64             s13 = s4 | s0
0065  +0x00978  op=34  07 00 0c 00  OR64             s12 = s7 | s0
0066  +0x00990  op=ae  0d 00 04 00  BR_EQ64          if (s13 == s0) goto record +107
0067  +0x009a8  op=18  11 0c 01 01  SHL32_IMM        s1 = (int32_t)(s12 << 1)
0068  +0x009c0  op=b5  0d 0d 01 00  ADD32_IMM16      s13 = int32(s13 +0x1)
0069  +0x009d8  op=33  01 0c 01 00  OR_IMM16         s12 = s1 | 0x1
006a  +0x009f0  op=a7  0d 00 fc ff  BR_NE64          if (s13 != s0) goto record +103
006b  +0x00a08  op=0d  03 0a 01 00  BYTE_FROM_U32_SHIFT s3 = (uint8_t)((uint32_t)s10 >> (s1 & 31))
006c  +0x00a20  op=17  05 0a 0a 07  SHL32_VAR        s10 = (int32_t)((uint32_t)s10 << ((uint32_t)s5 & 31))
006d  +0x00a38  op=85  02 02 01 00  ADD64_IMM16      s2 = s2 +0x1
006e  +0x00a50  op=84  08 09 09 04  ADD64            s9 = s8 + s9
006f  +0x00a68  op=b3  0b 01 01 00  AND64            s1 = s11 & s1
0070  +0x00a80  op=36  0c 00 0b 01  NOR64            s11 = ~(s12 | s0)
0071  +0x00a98  op=b3  0a 0b 0a 00  AND64            s10 = s10 & s11
0072  +0x00ab0  op=34  0a 01 01 01  OR64             s1 = s10 | s1
0073  +0x00ac8  op=08  09 01 00 00  ST32             *(s9 +0x0) = (uint32_t)s1
0074  +0x00ae0  op=a7  02 12 e5 ff  BR_NE64          if (s2 != s18) goto record +90
0075  +0x00af8  op=52  11 01 14 00  LD32S            s1 = *(int32_t *)(s17 +0x14)
0076  +0x00b10  op=52  1e 03 0c 00  LD32S            s3 = *(int32_t *)(s30 +0xc)
0077  +0x00b28  op=52  11 02 10 00  LD32S            s2 = *(int32_t *)(s17 +0x10)
0078  +0x00b40  op=52  1e 04 08 00  LD32S            s4 = *(int32_t *)(s30 +0x8)
0079  +0x00b58  op=52  1e 05 04 00  LD32S            s5 = *(int32_t *)(s30 +0x4)
007a  +0x00b70  op=02  03 01 01 01  XOR64            s1 = s1 ^ s3
007b  +0x00b88  op=52  11 03 0c 00  LD32S            s3 = *(int32_t *)(s17 +0xc)
007c  +0x00ba0  op=02  04 02 02 01  XOR64            s2 = s2 ^ s4
007d  +0x00bb8  op=52  1e 04 00 00  LD32S            s4 = *(int32_t *)(s30 +0x0)
007e  +0x00bd0  op=08  11 01 14 00  ST32             *(s17 +0x14) = (uint32_t)s1
007f  +0x00be8  op=08  11 02 10 00  ST32             *(s17 +0x10) = (uint32_t)s2
0080  +0x00c00  op=02  05 03 01 00  XOR64            s1 = s3 ^ s5
0081  +0x00c18  op=08  11 01 0c 00  ST32             *(s17 +0xc) = (uint32_t)s1
0082  +0x00c30  op=52  11 01 08 00  LD32S            s1 = *(int32_t *)(s17 +0x8)
0083  +0x00c48  op=02  04 01 01 01  XOR64            s1 = s1 ^ s4
0084  +0x00c60  op=08  11 01 08 00  ST32             *(s17 +0x8) = (uint32_t)s1
0085  +0x00c78  op=26  10 01 00 00  ST8              *(s16 +0x0) = (uint8_t)s1
0086  +0x00c90  op=52  11 01 08 00  LD32S            s1 = *(int32_t *)(s17 +0x8)
0087  +0x00ca8  op=0e  00 01 01 08  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 8)
0088  +0x00cc0  op=26  10 01 01 00  ST8              *(s16 +0x1) = (uint8_t)s1
0089  +0x00cd8  op=55  11 01 0a 00  LD16U            s1 = *(uint16_t *)(s17 +0xa)
008a  +0x00cf0  op=26  10 01 02 00  ST8              *(s16 +0x2) = (uint8_t)s1
008b  +0x00d08  op=59  11 01 0b 00  LD8U             s1 = *(uint8_t *)(s17 +0xb)
008c  +0x00d20  op=26  10 01 03 00  ST8              *(s16 +0x3) = (uint8_t)s1
008d  +0x00d38  op=52  11 01 0c 00  LD32S            s1 = *(int32_t *)(s17 +0xc)
008e  +0x00d50  op=26  10 01 04 00  ST8              *(s16 +0x4) = (uint8_t)s1
008f  +0x00d68  op=52  11 01 0c 00  LD32S            s1 = *(int32_t *)(s17 +0xc)
0090  +0x00d80  op=0e  00 01 01 08  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 8)
0091  +0x00d98  op=26  10 01 05 00  ST8              *(s16 +0x5) = (uint8_t)s1
0092  +0x00db0  op=55  11 01 0e 00  LD16U            s1 = *(uint16_t *)(s17 +0xe)
0093  +0x00dc8  op=26  10 01 06 00  ST8              *(s16 +0x6) = (uint8_t)s1
0094  +0x00de0  op=59  11 01 0f 00  LD8U             s1 = *(uint8_t *)(s17 +0xf)
0095  +0x00df8  op=26  10 01 07 00  ST8              *(s16 +0x7) = (uint8_t)s1
0096  +0x00e10  op=52  11 01 10 00  LD32S            s1 = *(int32_t *)(s17 +0x10)
0097  +0x00e28  op=26  10 01 08 00  ST8              *(s16 +0x8) = (uint8_t)s1
0098  +0x00e40  op=52  11 01 10 00  LD32S            s1 = *(int32_t *)(s17 +0x10)
0099  +0x00e58  op=0e  0b 01 01 08  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 8)
009a  +0x00e70  op=26  10 01 09 00  ST8              *(s16 +0x9) = (uint8_t)s1
009b  +0x00e88  op=55  11 01 12 00  LD16U            s1 = *(uint16_t *)(s17 +0x12)
009c  +0x00ea0  op=26  10 01 0a 00  ST8              *(s16 +0xa) = (uint8_t)s1
009d  +0x00eb8  op=59  11 01 13 00  LD8U             s1 = *(uint8_t *)(s17 +0x13)
009e  +0x00ed0  op=26  10 01 0b 00  ST8              *(s16 +0xb) = (uint8_t)s1
009f  +0x00ee8  op=52  11 01 14 00  LD32S            s1 = *(int32_t *)(s17 +0x14)
00a0  +0x00f00  op=26  10 01 0c 00  ST8              *(s16 +0xc) = (uint8_t)s1
00a1  +0x00f18  op=52  11 01 14 00  LD32S            s1 = *(int32_t *)(s17 +0x14)
00a2  +0x00f30  op=0e  0b 01 01 08  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 8)
00a3  +0x00f48  op=26  10 01 0d 00  ST8              *(s16 +0xd) = (uint8_t)s1
00a4  +0x00f60  op=55  11 01 16 00  LD16U            s1 = *(uint16_t *)(s17 +0x16)
00a5  +0x00f78  op=26  10 01 0e 00  ST8              *(s16 +0xe) = (uint8_t)s1
00a6  +0x00f90  op=59  11 01 17 00  LD8U             s1 = *(uint8_t *)(s17 +0x17)
00a7  +0x00fa8  op=26  10 01 0f 00  ST8              *(s16 +0xf) = (uint8_t)s1
00a8  +0x00fc0  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
00a9  +0x00fd8  op=58  1d 10 60 00  LD64             s16 = *(uint64_t *)(s29 +0x60)
00aa  +0x00ff0  op=58  1d 11 68 00  LD64             s17 = *(uint64_t *)(s29 +0x68)
00ab  +0x01008  op=58  1d 12 70 00  LD64             s18 = *(uint64_t *)(s29 +0x70)
00ac  +0x01020  op=58  1d 13 78 00  LD64             s19 = *(uint64_t *)(s29 +0x78)
00ad  +0x01038  op=58  1d 14 80 00  LD64             s20 = *(uint64_t *)(s29 +0x80)
00ae  +0x01050  op=58  1d 15 88 00  LD64             s21 = *(uint64_t *)(s29 +0x88)
00af  +0x01068  op=58  1d 1e 90 00  LD64             s30 = *(uint64_t *)(s29 +0x90)
00b0  +0x01080  op=58  1d 1f 98 00  LD64             s31 = *(uint64_t *)(s29 +0x98)
00b1  +0x01098  op=85  1d 1d a0 00  ADD64_IMM16      s29 = s29 +0xa0
00b2  +0x010b0  op=5b  1f 00 00 00  RET              return/leave with s31

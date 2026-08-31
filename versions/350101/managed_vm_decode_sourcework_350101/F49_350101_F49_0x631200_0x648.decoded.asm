; MetaSec managed bytecode decode: F49
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F49_0x631200_0x648.bin
; records: 67  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  05 03 01 00  ADD64_IMM16      s3 = s5 +0x1
0001  +0x00018  op=85  04 02 01 00  ADD64_IMM16      s2 = s4 +0x1
0002  +0x00030  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
0003  +0x00048  op=85  00 06 10 00  ADD64_IMM16      s6 = s0 +0x10
0004  +0x00060  op=ae  05 06 10 00  BR_EQ64          if (s5 == s6) goto record +21
0005  +0x00078  op=84  03 05 07 14  ADD64            s7 = s3 + s5
0006  +0x00090  op=84  02 05 01 04  ADD64            s1 = s2 + s5
0007  +0x000a8  op=85  05 05 04 00  ADD64_IMM16      s5 = s5 +0x4
0008  +0x000c0  op=59  07 08 ff ff  LD8U             s8 = *(uint8_t *)(s7 -0x1)
0009  +0x000d8  op=01  08 08 c9 00  XOR_IMM16        s8 = s8 ^ 0xc9
000a  +0x000f0  op=26  01 08 ff ff  ST8              *(s1 -0x1) = (uint8_t)s8
000b  +0x00108  op=59  07 08 00 00  LD8U             s8 = *(uint8_t *)(s7 +0x0)
000c  +0x00120  op=01  08 08 a1 00  XOR_IMM16        s8 = s8 ^ 0xa1
000d  +0x00138  op=26  01 08 00 00  ST8              *(s1 +0x0) = (uint8_t)s8
000e  +0x00150  op=59  07 08 01 00  LD8U             s8 = *(uint8_t *)(s7 +0x1)
000f  +0x00168  op=01  08 08 f8 00  XOR_IMM16        s8 = s8 ^ 0xf8
0010  +0x00180  op=26  01 08 01 00  ST8              *(s1 +0x1) = (uint8_t)s8
0011  +0x00198  op=59  07 07 02 00  LD8U             s7 = *(uint8_t *)(s7 +0x2)
0012  +0x001b0  op=01  07 07 89 00  XOR_IMM16        s7 = s7 ^ 0x89
0013  +0x001c8  op=26  01 07 02 00  ST8              *(s1 +0x2) = (uint8_t)s7
0014  +0x001e0  op=a7  05 06 f0 ff  BR_NE64          if (s5 != s6) goto record +5
0015  +0x001f8  op=54  00 01 f8 89  CONST_HI16       s1 = sign_extend_32(0x89f8 << 16)
0016  +0x00210  op=85  04 02 13 00  ADD64_IMM16      s2 = s4 +0x13
0017  +0x00228  op=85  00 03 04 00  ADD64_IMM16      s3 = s0 +0x4
0018  +0x00240  op=b5  00 04 08 00  ADD32_IMM16      s4 = int32(s0 +0x8)
0019  +0x00258  op=85  00 05 0c 00  ADD64_IMM16      s5 = s0 +0xc
001a  +0x00270  op=53  01 06 71 01  LD_POOL_PTR      s6 = *(uint64_t *)q1 + 0x171 ; q1=0x125fd408 rt/so-mapped
001b  +0x00288  op=33  01 07 c9 a1  OR_IMM16         s7 = s1 | 0xa1c9
001c  +0x002a0  op=ae  03 05 25 00  BR_EQ64          if (s3 == s5) goto record +66
001d  +0x002b8  op=59  02 0a fc ff  LD8U             s10 = *(uint8_t *)(s2 -0x4)
001e  +0x002d0  op=59  02 09 fa ff  LD8U             s9 = *(uint8_t *)(s2 -0x6)
001f  +0x002e8  op=59  02 08 f9 ff  LD8U             s8 = *(uint8_t *)(s2 -0x7)
0020  +0x00300  op=59  02 0b fb ff  LD8U             s11 = *(uint8_t *)(s2 -0x5)
0021  +0x00318  op=b2  03 01 03 00  AND64_IMM16      s1 = s3 & 0x3
0022  +0x00330  op=a7  01 00 0f 00  BR_NE64          if (s1 != s0) goto record +50
0023  +0x00348  op=b2  09 09 ff 00  AND64_IMM16      s9 = s9 & 0xff
0024  +0x00360  op=b2  0a 01 ff 00  AND64_IMM16      s1 = s10 & 0xff
0025  +0x00378  op=b2  08 08 ff 00  AND64_IMM16      s8 = s8 & 0xff
0026  +0x00390  op=b2  0b 0c ff 00  AND64_IMM16      s12 = s11 & 0xff
0027  +0x003a8  op=84  06 09 09 04  ADD64            s9 = s6 + s9
0028  +0x003c0  op=84  06 08 0a 04  ADD64            s10 = s6 + s8
0029  +0x003d8  op=b2  04 08 18 00  AND64_IMM16      s8 = s4 & 0x18
002a  +0x003f0  op=84  06 01 01 14  ADD64            s1 = s6 + s1
002b  +0x00408  op=59  09 09 00 00  LD8U             s9 = *(uint8_t *)(s9 +0x0)
002c  +0x00420  op=0d  08 07 08 01  BYTE_FROM_U32_SHIFT s8 = (uint8_t)((uint32_t)s7 >> (s8 & 31))
002d  +0x00438  op=59  01 0b 00 00  LD8U             s11 = *(uint8_t *)(s1 +0x0)
002e  +0x00450  op=84  06 0c 01 14  ADD64            s1 = s6 + s12
002f  +0x00468  op=59  0a 0a 00 00  LD8U             s10 = *(uint8_t *)(s10 +0x0)
0030  +0x00480  op=02  09 08 08 00  XOR64            s8 = s8 ^ s9
0031  +0x00498  op=59  01 09 00 00  LD8U             s9 = *(uint8_t *)(s1 +0x0)
0032  +0x004b0  op=59  02 01 ef ff  LD8U             s1 = *(uint8_t *)(s2 -0x11)
0033  +0x004c8  op=59  02 0c f0 ff  LD8U             s12 = *(uint8_t *)(s2 -0x10)
0034  +0x004e0  op=b5  04 04 02 00  ADD32_IMM16      s4 = int32(s4 +0x2)
0035  +0x004f8  op=85  03 03 01 00  ADD64_IMM16      s3 = s3 +0x1
0036  +0x00510  op=02  01 0b 01 01  XOR64            s1 = s11 ^ s1
0037  +0x00528  op=59  02 0b ee ff  LD8U             s11 = *(uint8_t *)(s2 -0x12)
0038  +0x00540  op=02  0c 0a 0a 01  XOR64            s10 = s10 ^ s12
0039  +0x00558  op=02  0b 09 09 00  XOR64            s9 = s9 ^ s11
003a  +0x00570  op=59  02 0b ed ff  LD8U             s11 = *(uint8_t *)(s2 -0x13)
003b  +0x00588  op=02  0b 08 08 01  XOR64            s8 = s8 ^ s11
003c  +0x005a0  op=26  02 08 fd ff  ST8              *(s2 -0x3) = (uint8_t)s8
003d  +0x005b8  op=26  02 09 fe ff  ST8              *(s2 -0x2) = (uint8_t)s9
003e  +0x005d0  op=26  02 01 ff ff  ST8              *(s2 -0x1) = (uint8_t)s1
003f  +0x005e8  op=26  02 0a 00 00  ST8              *(s2 +0x0) = (uint8_t)s10
0040  +0x00600  op=85  02 02 04 00  ADD64_IMM16      s2 = s2 +0x4
0041  +0x00618  op=a7  03 05 db ff  BR_NE64          if (s3 != s5) goto record +29
0042  +0x00630  op=5b  1f 00 00 00  RET              return/leave with s31

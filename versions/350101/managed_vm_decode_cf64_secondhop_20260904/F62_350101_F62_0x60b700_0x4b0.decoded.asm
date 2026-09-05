; MetaSec managed bytecode decode: F62
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F62_0x60b700_0x4b0.bin
; records: 50  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d f0 ff  ADD64_IMM16      s29 = s29 -0x10
0001  +0x00018  op=25  1d 00 08 00  ST64             *(s29 +0x8) = s0
0002  +0x00030  op=25  1d 00 00 00  ST64             *(s29 +0x0) = s0
0003  +0x00048  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0004  +0x00060  op=85  00 07 04 00  ADD64_IMM16      s7 = s0 +0x4
0005  +0x00078  op=53  04 08 80 08  LD_POOL_PTR      s8 = *(uint64_t *)q1 + 0x880 ; q1=0x125fd3a8 rt/so-mapped
0006  +0x00090  op=b5  00 09 00 00  ADD32_IMM16      s9 = int32(s0 +0x0)
0007  +0x000a8  op=85  1d 0a 00 00  ADD64_IMM16      s10 = s29 +0x0
0008  +0x000c0  op=52  04 01 58 00  LD32S            s1 = *(int32_t *)(s4 +0x58)
0009  +0x000d8  op=b5  01 01 0f 00  ADD32_IMM16      s1 = int32(s1 +0xf)
000a  +0x000f0  op=b2  01 03 1f 00  AND64_IMM16      s3 = s1 & 0x1f
000b  +0x00108  op=b5  00 01 e0 ff  ADD32_IMM16      s1 = int32(s0 -0x20)
000c  +0x00120  op=34  03 01 05 00  OR64             s5 = s3 | s1
000d  +0x00138  op=b5  00 01 20 00  ADD32_IMM16      s1 = int32(s0 +0x20)
000e  +0x00150  op=09  01 03 06 14  SUB32            s6 = sign_extend_32((uint32_t)s1 - (uint32_t)s3)
000f  +0x00168  op=ae  02 07 1b 00  BR_EQ64          if (s2 == s7) goto record +43
0010  +0x00180  op=6e  12 02 0b 02  SHL64_IMM        s11 = s2 << 2
0011  +0x00198  op=34  05 00 0e 01  OR64             s14 = s5 | s0
0012  +0x001b0  op=34  09 00 0d 01  OR64             s13 = s9 | s0
0013  +0x001c8  op=84  08 0b 01 00  ADD64            s1 = s8 + s11
0014  +0x001e0  op=52  01 0c 00 00  LD32S            s12 = *(int32_t *)(s1 +0x0)
0015  +0x001f8  op=ae  0e 00 04 00  BR_EQ64          if (s14 == s0) goto record +26
0016  +0x00210  op=18  00 0d 01 01  SHL32_IMM        s1 = (int32_t)(s13 << 1)
0017  +0x00228  op=b5  0e 0e 01 00  ADD32_IMM16      s14 = int32(s14 +0x1)
0018  +0x00240  op=33  01 0d 01 00  OR_IMM16         s13 = s1 | 0x1
0019  +0x00258  op=a7  0e 00 fc ff  BR_NE64          if (s14 != s0) goto record +22
001a  +0x00270  op=34  05 00 0f 01  OR64             s15 = s5 | s0
001b  +0x00288  op=34  09 00 0e 01  OR64             s14 = s9 | s0
001c  +0x002a0  op=ae  0f 00 04 00  BR_EQ64          if (s15 == s0) goto record +33
001d  +0x002b8  op=18  10 0e 01 01  SHL32_IMM        s1 = (int32_t)(s14 << 1)
001e  +0x002d0  op=b5  0f 0f 01 00  ADD32_IMM16      s15 = int32(s15 +0x1)
001f  +0x002e8  op=33  01 0e 01 00  OR_IMM16         s14 = s1 | 0x1
0020  +0x00300  op=a7  0f 00 fc ff  BR_NE64          if (s15 != s0) goto record +29
0021  +0x00318  op=0d  03 0c 01 01  BYTE_FROM_U32_SHIFT s3 = (uint8_t)((uint32_t)s12 >> (s1 & 31))
0022  +0x00330  op=17  06 0c 0c 17  SHL32_VAR        s12 = (int32_t)((uint32_t)s12 << ((uint32_t)s6 & 31))
0023  +0x00348  op=84  0a 0b 0b 04  ADD64            s11 = s10 + s11
0024  +0x00360  op=85  02 02 01 00  ADD64_IMM16      s2 = s2 +0x1
0025  +0x00378  op=b3  0d 01 01 00  AND64            s1 = s13 & s1
0026  +0x00390  op=36  0e 00 0d 01  NOR64            s13 = ~(s14 | s0)
0027  +0x003a8  op=b3  0c 0d 0c 00  AND64            s12 = s12 & s13
0028  +0x003c0  op=34  0c 01 01 00  OR64             s1 = s12 | s1
0029  +0x003d8  op=08  0b 01 00 00  ST32             *(s11 +0x0) = (uint32_t)s1
002a  +0x003f0  op=a7  02 07 e5 ff  BR_NE64          if (s2 != s7) goto record +16
002b  +0x00408  op=25  04 00 00 00  ST64             *(s4 +0x0) = s0
002c  +0x00420  op=58  1d 01 00 00  LD64             s1 = *(uint64_t *)(s29 +0x0)
002d  +0x00438  op=58  1d 02 08 00  LD64             s2 = *(uint64_t *)(s29 +0x8)
002e  +0x00450  op=25  04 02 10 00  ST64             *(s4 +0x10) = s2
002f  +0x00468  op=25  04 01 08 00  ST64             *(s4 +0x8) = s1
0030  +0x00480  op=85  1d 1d 10 00  ADD64_IMM16      s29 = s29 +0x10
0031  +0x00498  op=5b  1f 00 00 00  RET              return/leave with s31

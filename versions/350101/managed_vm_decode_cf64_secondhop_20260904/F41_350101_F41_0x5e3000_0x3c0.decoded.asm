; MetaSec managed bytecode decode: F41
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F41_0x5e3000_0x3c0.bin
; records: 40  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0001  +0x00018  op=85  00 03 0b 00  ADD64_IMM16      s3 = s0 +0xb
0002  +0x00030  op=b5  00 06 c0 ff  ADD32_IMM16      s6 = int32(s0 -0x40) ; q1=0x12274848 rt/so-mapped
0003  +0x00048  op=53  03 07 c8 06  LD_POOL_PTR      s7 = *(uint64_t *)q1 + 0x6c8 ; q1=0x125fd3a8 rt/so-mapped
0004  +0x00060  op=b5  00 08 40 00  ADD32_IMM16      s8 = int32(s0 +0x40)
0005  +0x00078  op=85  00 09 ff ff  ADD64_IMM16      s9 = s0 -0x1
0006  +0x00090  op=34  02 00 0a 01  OR64             s10 = s2 | s0
0007  +0x000a8  op=ae  0a 03 1f 00  BR_EQ64          if (s10 == s3) goto record +39
0008  +0x000c0  op=52  04 01 40 01  LD32S            s1 = *(int32_t *)(s4 +0x140)
0009  +0x000d8  op=6e  02 0a 0b 03  SHL64_IMM        s11 = s10 << 3
000a  +0x000f0  op=34  02 00 18 01  OR64             s24 = s2 | s0 ; q1=0x12274848 rt/so-mapped
000b  +0x00108  op=b5  01 01 12 00  ADD32_IMM16      s1 = int32(s1 +0x12)
000c  +0x00120  op=b2  01 0c 3f 00  AND64_IMM16      s12 = s1 & 0x3f
000d  +0x00138  op=84  07 0b 01 00  ADD64            s1 = s7 + s11
000e  +0x00150  op=34  0c 06 0f 00  OR64             s15 = s12 | s6
000f  +0x00168  op=58  01 0d 00 00  LD64             s13 = *(uint64_t *)(s1 +0x0)
0010  +0x00180  op=09  08 0c 0e 04  SUB32            s14 = sign_extend_32((uint32_t)s8 - (uint32_t)s12)
0011  +0x00198  op=34  0f 00 19 00  OR64             s25 = s15 | s0
0012  +0x001b0  op=ae  19 00 04 00  BR_EQ64          if (s25 == s0) goto record +23 ; q1=0x12274848 rt/so-mapped
0013  +0x001c8  op=6e  02 18 01 01  SHL64_IMM        s1 = s24 << 1
0014  +0x001e0  op=b5  19 19 01 00  ADD32_IMM16      s25 = int32(s25 +0x1)
0015  +0x001f8  op=33  01 18 01 00  OR_IMM16         s24 = s1 | 0x1
0016  +0x00210  op=a7  19 00 fc ff  BR_NE64          if (s25 != s0) goto record +19
0017  +0x00228  op=34  02 00 19 01  OR64             s25 = s2 | s0
0018  +0x00240  op=ae  0f 00 04 00  BR_EQ64          if (s15 == s0) goto record +29
0019  +0x00258  op=6e  00 19 01 01  SHL64_IMM        s1 = s25 << 1
001a  +0x00270  op=b5  0f 0f 01 00  ADD32_IMM16      s15 = int32(s15 +0x1) ; q1=0x12274848 rt/so-mapped
001b  +0x00288  op=33  01 19 01 00  OR_IMM16         s25 = s1 | 0x1
001c  +0x002a0  op=a7  0f 00 fc ff  BR_NE64          if (s15 != s0) goto record +25
001d  +0x002b8  op=66  0c 0d 0c 00  LSR64_VAR        s12 = (uint64_t)s13 >> (s12 & 63)
001e  +0x002d0  op=02  19 09 01 01  XOR64            s1 = s9 ^ s25
001f  +0x002e8  op=6c  0e 0d 0e 00  SHL64_VAR        s14 = s13 << (s14 & 63)
0020  +0x00300  op=84  05 0b 0b 14  ADD64            s11 = s5 + s11
0021  +0x00318  op=85  0a 0a 01 00  ADD64_IMM16      s10 = s10 +0x1
0022  +0x00330  op=b3  0e 01 01 01  AND64            s1 = s14 & s1 ; q1=0x12274848 rt/so-mapped
0023  +0x00348  op=b3  18 0c 0c 01  AND64            s12 = s24 & s12
0024  +0x00360  op=34  01 0c 01 00  OR64             s1 = s1 | s12
0025  +0x00378  op=25  0b 01 00 00  ST64             *(s11 +0x0) = s1
0026  +0x00390  op=a7  0a 03 e1 ff  BR_NE64          if (s10 != s3) goto record +8
0027  +0x003a8  op=5b  1f 00 00 00  RET              return/leave with s31

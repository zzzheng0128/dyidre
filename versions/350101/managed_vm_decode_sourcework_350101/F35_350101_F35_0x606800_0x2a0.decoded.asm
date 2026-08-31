; MetaSec managed bytecode decode: F35
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/unidbg-android/target/managed_program_f32_family_350101_20260831_045757/350101_F35_0x606800_0x2a0.bin
; records: 28  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=b2  04 01 ff 00  AND64_IMM16      s1 = s4 & 0xff ; q1=0xffff080000001d1a
0001  +0x00018  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0 ; q1=0x2001d
0002  +0x00030  op=85  00 04 10 00  ADD64_IMM16      s4 = s0 +0x10 ; q1=0x20108010f
0003  +0x00048  op=6e  00 01 01 04  SHL64_IMM        s1 = s1 << 4 ; q1=0xa1d19
0004  +0x00060  op=84  01 06 01 00  ADD64            s1 = s1 + s6 ; q1=0x1b0000010109
0005  +0x00078  op=85  01 02 03 00  ADD64_IMM16      s2 = s1 +0x3 ; q1=0x201f1f010009
0006  +0x00090  op=ae  03 04 14 00  BR_EQ64          if (s3 == s4) goto record +27 ; q1=0x200000010009
0007  +0x000a8  op=84  02 03 01 04  ADD64            s1 = s2 + s3 ; q1=0x1b0000070232
0008  +0x000c0  op=84  05 03 07 14  ADD64            s7 = s5 + s3 ; q1=0x1f010e00052c
0009  +0x000d8  op=85  03 03 04 00  ADD64_IMM16      s3 = s3 +0x4 ; q1=0x3014010b083e
000a  +0x000f0  op=59  01 06 fd ff  LD8U             s6 = *(uint8_t *)(s1 -0x3) ; q1=0x40000000e32
000b  +0x00108  op=59  07 08 03 00  LD8U             s8 = *(uint8_t *)(s7 +0x3) ; q1=0x100000e0e09
000c  +0x00120  op=02  08 06 06 00  XOR64            s6 = s6 ^ s8 ; q1=0x3c1f1f000e18
000d  +0x00138  op=26  07 06 03 00  ST8              *(s7 +0x3) = (uint8_t)s6 ; q1=0x2f010e00093e
000e  +0x00150  op=59  07 06 00 00  LD8U             s6 = *(uint8_t *)(s7 +0x0) ; q1=0x1010e0000
000f  +0x00168  op=59  01 08 fe ff  LD8U             s8 = *(uint8_t *)(s1 -0x2) ; q1=0x100000e010d
0010  +0x00180  op=02  06 08 06 01  XOR64            s6 = s8 ^ s6 ; q1=0x2c01010c032c
0011  +0x00198  op=26  07 06 00 00  ST8              *(s7 +0x0) = (uint8_t)s6 ; q1=0x2d000b0b0a00
0012  +0x001b0  op=59  07 08 02 00  LD8U             s8 = *(uint8_t *)(s7 +0x2) ; q1=0x1e0101010d2c
0013  +0x001c8  op=59  01 09 ff ff  LD8U             s9 = *(uint8_t *)(s1 -0x1) ; q1=0x24000c0d0c00
0014  +0x001e0  op=59  07 06 01 00  LD8U             s6 = *(uint8_t *)(s7 +0x1) ; q1=0x10b2b
0015  +0x001f8  op=02  08 09 08 01  XOR64            s8 = s9 ^ s8 ; q1=0x42a
0016  +0x00210  op=26  07 08 02 00  ST8              *(s7 +0x2) = (uint8_t)s8 ; q1=0x80000021d1e
0017  +0x00228  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0) ; q1=0x8000001043f
0018  +0x00240  op=02  06 01 01 01  XOR64            s1 = s1 ^ s6 ; q1=0xa0000001f00
0019  +0x00258  op=26  07 01 01 00  ST8              *(s7 +0x1) = (uint8_t)s1 ; q1=0x80100011037
001a  +0x00270  op=a7  03 04 ec ff  BR_NE64          if (s3 != s4) goto record +7 ; q1=0x8010001103f
001b  +0x00288  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x100011037

; MetaSec managed bytecode decode: F27
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F27_0x5d8c80_0x270.bin
; records: 26  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=53  03 01 08 03  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x308 ; q1=0x125fd408 rt/so-mapped
0001  +0x00018  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0
0002  +0x00030  op=85  00 03 04 00  ADD64_IMM16      s3 = s0 +0x4
0003  +0x00048  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0004  +0x00060  op=85  01 05 3a 03  ADD64_IMM16      s5 = s1 +0x33a
0005  +0x00078  op=ae  02 03 13 00  BR_EQ64          if (s2 == s3) goto record +25
0006  +0x00090  op=84  04 02 01 04  ADD64            s1 = s4 + s2
0007  +0x000a8  op=85  02 02 01 00  ADD64_IMM16      s2 = s2 +0x1
0008  +0x000c0  op=59  01 06 0c 00  LD8U             s6 = *(uint8_t *)(s1 +0xc)
0009  +0x000d8  op=59  01 07 08 00  LD8U             s7 = *(uint8_t *)(s1 +0x8)
000a  +0x000f0  op=59  01 08 00 00  LD8U             s8 = *(uint8_t *)(s1 +0x0)
000b  +0x00108  op=59  01 09 04 00  LD8U             s9 = *(uint8_t *)(s1 +0x4)
000c  +0x00120  op=84  05 06 06 00  ADD64            s6 = s5 + s6
000d  +0x00138  op=84  05 07 07 00  ADD64            s7 = s5 + s7
000e  +0x00150  op=84  05 08 08 00  ADD64            s8 = s5 + s8
000f  +0x00168  op=84  05 09 09 00  ADD64            s9 = s5 + s9
0010  +0x00180  op=59  07 07 00 00  LD8U             s7 = *(uint8_t *)(s7 +0x0)
0011  +0x00198  op=59  06 06 00 00  LD8U             s6 = *(uint8_t *)(s6 +0x0)
0012  +0x001b0  op=59  08 08 00 00  LD8U             s8 = *(uint8_t *)(s8 +0x0)
0013  +0x001c8  op=59  09 09 00 00  LD8U             s9 = *(uint8_t *)(s9 +0x0)
0014  +0x001e0  op=26  01 09 0c 00  ST8              *(s1 +0xc) = (uint8_t)s9
0015  +0x001f8  op=26  01 08 04 00  ST8              *(s1 +0x4) = (uint8_t)s8
0016  +0x00210  op=26  01 06 08 00  ST8              *(s1 +0x8) = (uint8_t)s6
0017  +0x00228  op=26  01 07 00 00  ST8              *(s1 +0x0) = (uint8_t)s7
0018  +0x00240  op=a7  02 03 ed ff  BR_NE64          if (s2 != s3) goto record +6
0019  +0x00258  op=5b  1f 00 00 00  RET              return/leave with s31

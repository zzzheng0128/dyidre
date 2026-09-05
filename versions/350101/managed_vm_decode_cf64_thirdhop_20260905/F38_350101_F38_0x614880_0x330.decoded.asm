; MetaSec managed bytecode decode: F38
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F38_0x614880_0x330.bin
; records: 34  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  05 02 20 00  ADD64_IMM16      s2 = s5 +0x20
0001  +0x00018  op=85  04 03 20 00  ADD64_IMM16      s3 = s4 +0x20
0002  +0x00030  op=85  00 04 00 00  ADD64_IMM16      s4 = s0 +0x0
0003  +0x00048  op=85  00 05 00 08  ADD64_IMM16      s5 = s0 +0x800
0004  +0x00060  op=ae  04 05 1c 00  BR_EQ64          if (s4 == s5) goto record +33
0005  +0x00078  op=84  03 04 06 14  ADD64            s6 = s3 + s4
0006  +0x00090  op=84  02 04 01 04  ADD64            s1 = s2 + s4
0007  +0x000a8  op=85  04 04 40 00  ADD64_IMM16      s4 = s4 +0x40
0008  +0x000c0  op=58  06 07 e0 ff  LD64             s7 = *(uint64_t *)(s6 -0x20)
0009  +0x000d8  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
000a  +0x000f0  op=25  01 07 f0 ff  ST64             *(s1 -0x10) = s7
000b  +0x00108  op=58  06 07 e8 ff  LD64             s7 = *(uint64_t *)(s6 -0x18)
000c  +0x00120  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
000d  +0x00138  op=25  01 07 e0 ff  ST64             *(s1 -0x20) = s7
000e  +0x00150  op=58  06 07 f0 ff  LD64             s7 = *(uint64_t *)(s6 -0x10)
000f  +0x00168  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
0010  +0x00180  op=25  01 07 10 00  ST64             *(s1 +0x10) = s7
0011  +0x00198  op=58  06 07 f8 ff  LD64             s7 = *(uint64_t *)(s6 -0x8)
0012  +0x001b0  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
0013  +0x001c8  op=25  01 07 e8 ff  ST64             *(s1 -0x18) = s7
0014  +0x001e0  op=58  06 07 00 00  LD64             s7 = *(uint64_t *)(s6 +0x0)
0015  +0x001f8  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
0016  +0x00210  op=25  01 07 08 00  ST64             *(s1 +0x8) = s7
0017  +0x00228  op=58  06 07 08 00  LD64             s7 = *(uint64_t *)(s6 +0x8)
0018  +0x00240  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
0019  +0x00258  op=25  01 07 f8 ff  ST64             *(s1 -0x8) = s7
001a  +0x00270  op=58  06 07 10 00  LD64             s7 = *(uint64_t *)(s6 +0x10)
001b  +0x00288  op=72  01 07 07 05  ROL64_32MINUS_IMM s7 = rol64(s7, 32 - 5)
001c  +0x002a0  op=25  01 07 18 00  ST64             *(s1 +0x18) = s7
001d  +0x002b8  op=58  06 06 18 00  LD64             s6 = *(uint64_t *)(s6 +0x18)
001e  +0x002d0  op=72  01 06 06 05  ROL64_32MINUS_IMM s6 = rol64(s6, 32 - 5)
001f  +0x002e8  op=25  01 06 00 00  ST64             *(s1 +0x0) = s6
0020  +0x00300  op=a7  04 05 e4 ff  BR_NE64          if (s4 != s5) goto record +5
0021  +0x00318  op=5b  1f 00 00 00  RET              return/leave with s31

; MetaSec managed bytecode decode: F17
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f16_f17_f18_20260831_031044/350101_F17_0x8721c0_0x198.bin
; records: 17  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=58  05 07 08 00  LD64             s7 = *(uint64_t *)(s5 +0x8)
0001  +0x00018  op=58  05 02 00 00  LD64             s2 = *(uint64_t *)(s5 +0x0)
0002  +0x00030  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0
0003  +0x00048  op=85  00 05 10 01  ADD64_IMM16      s5 = s0 +0x110
0004  +0x00060  op=ae  03 05 09 00  BR_EQ64          if (s3 == s5) goto record +14
0005  +0x00078  op=73  13 07 01 08  ROR64_IMM        s1 = ror64(s7, 8)
0006  +0x00090  op=84  04 03 07 14  ADD64            s7 = s4 + s3
0007  +0x000a8  op=85  03 03 08 00  ADD64_IMM16      s3 = s3 +0x8
0008  +0x000c0  op=58  07 07 00 00  LD64             s7 = *(uint64_t *)(s7 +0x0)
0009  +0x000d8  op=84  01 02 01 00  ADD64            s1 = s1 + s2
000a  +0x000f0  op=02  07 01 07 01  XOR64            s7 = s1 ^ s7
000b  +0x00108  op=72  01 02 01 1d  ROL64_32MINUS_IMM s1 = rol64(s2, 32 - 29)
000c  +0x00120  op=02  07 01 02 01  XOR64            s2 = s1 ^ s7
000d  +0x00138  op=a7  03 05 f7 ff  BR_NE64          if (s3 != s5) goto record +5
000e  +0x00150  op=25  06 07 08 00  ST64             *(s6 +0x8) = s7
000f  +0x00168  op=25  06 02 00 00  ST64             *(s6 +0x0) = s2
0010  +0x00180  op=5b  1f 00 00 00  RET              return/leave with s31

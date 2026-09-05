; MetaSec managed bytecode decode: F44
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F44_0x5e1200_0x1f8.bin
; records: 21  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  04 04 68 00  ADD64_IMM16      s4 = s4 +0x68
0001  +0x00018  op=85  00 02 1f 00  ADD64_IMM16      s2 = s0 +0x1f
0002  +0x00030  op=85  00 03 ff ff  ADD64_IMM16      s3 = s0 -0x1 ; q1=0x766e6506
0003  +0x00048  op=ae  02 03 10 00  BR_EQ64          if (s2 == s3) goto record +20 ; q1=0x30464306
0004  +0x00060  op=55  04 06 06 00  LD16U            s6 = *(uint16_t *)(s4 +0x6)
0005  +0x00078  op=84  05 02 01 00  ADD64            s1 = s5 + s2
0006  +0x00090  op=85  02 02 fc ff  ADD64_IMM16      s2 = s2 -0x4
0007  +0x000a8  op=26  01 06 00 00  ST8              *(s1 +0x0) = (uint8_t)s6 ; q1=0x100000001
0008  +0x000c0  op=58  04 06 00 00  LD64             s6 = *(uint64_t *)(s4 +0x0)
0009  +0x000d8  op=67  00 06 06 08  LSR64_IMM32PLUS  s6 = (uint64_t)s6 >> (8 + 32)
000a  +0x000f0  op=26  01 06 ff ff  ST8              *(s1 -0x1) = (uint8_t)s6 ; q1=0x766e6506
000b  +0x00108  op=85  04 06 08 00  ADD64_IMM16      s6 = s4 +0x8 ; q1=0x32464306
000c  +0x00120  op=58  04 07 00 00  LD64             s7 = *(uint64_t *)(s4 +0x0)
000d  +0x00138  op=68  13 07 07 18  LSR64_IMM        s7 = (uint64_t)s7 >> 24
000e  +0x00150  op=26  01 07 fe ff  ST8              *(s1 -0x2) = (uint8_t)s7
000f  +0x00168  op=58  04 04 00 00  LD64             s4 = *(uint64_t *)(s4 +0x0) ; q1=0x400000007
0010  +0x00180  op=68  00 04 04 08  LSR64_IMM        s4 = (uint64_t)s4 >> 8
0011  +0x00198  op=26  01 04 fd ff  ST8              *(s1 -0x3) = (uint8_t)s4
0012  +0x001b0  op=34  06 00 04 00  OR64             s4 = s6 | s0 ; q1=0x766e6506
0013  +0x001c8  op=a7  02 03 f0 ff  BR_NE64          if (s2 != s3) goto record +4 ; q1=0x3031464308
0014  +0x001e0  op=5b  1f 00 00 00  RET              return/leave with s31

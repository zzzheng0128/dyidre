; MetaSec managed bytecode decode: F28
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F28_0x5d8f00_0x228.bin
; records: 23  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=59  04 02 0a 00  LD8U             s2 = *(uint8_t *)(s4 +0xa)
0001  +0x00018  op=59  04 03 0e 00  LD8U             s3 = *(uint8_t *)(s4 +0xe)
0002  +0x00030  op=59  04 05 05 00  LD8U             s5 = *(uint8_t *)(s4 +0x5)
0003  +0x00048  op=59  04 06 0d 00  LD8U             s6 = *(uint8_t *)(s4 +0xd)
0004  +0x00060  op=59  04 07 09 00  LD8U             s7 = *(uint8_t *)(s4 +0x9)
0005  +0x00078  op=59  04 08 01 00  LD8U             s8 = *(uint8_t *)(s4 +0x1)
0006  +0x00090  op=59  04 01 02 00  LD8U             s1 = *(uint8_t *)(s4 +0x2)
0007  +0x000a8  op=26  04 08 09 00  ST8              *(s4 +0x9) = (uint8_t)s8
0008  +0x000c0  op=26  04 07 01 00  ST8              *(s4 +0x1) = (uint8_t)s7
0009  +0x000d8  op=26  04 06 05 00  ST8              *(s4 +0x5) = (uint8_t)s6
000a  +0x000f0  op=26  04 05 0d 00  ST8              *(s4 +0xd) = (uint8_t)s5
000b  +0x00108  op=26  04 03 02 00  ST8              *(s4 +0x2) = (uint8_t)s3
000c  +0x00120  op=26  04 02 0e 00  ST8              *(s4 +0xe) = (uint8_t)s2
000d  +0x00138  op=59  04 02 06 00  LD8U             s2 = *(uint8_t *)(s4 +0x6)
000e  +0x00150  op=26  04 02 0a 00  ST8              *(s4 +0xa) = (uint8_t)s2
000f  +0x00168  op=26  04 01 06 00  ST8              *(s4 +0x6) = (uint8_t)s1
0010  +0x00180  op=59  04 01 0f 00  LD8U             s1 = *(uint8_t *)(s4 +0xf)
0011  +0x00198  op=59  04 02 03 00  LD8U             s2 = *(uint8_t *)(s4 +0x3)
0012  +0x001b0  op=59  04 03 0b 00  LD8U             s3 = *(uint8_t *)(s4 +0xb)
0013  +0x001c8  op=26  04 03 0f 00  ST8              *(s4 +0xf) = (uint8_t)s3
0014  +0x001e0  op=26  04 02 0b 00  ST8              *(s4 +0xb) = (uint8_t)s2
0015  +0x001f8  op=26  04 01 03 00  ST8              *(s4 +0x3) = (uint8_t)s1
0016  +0x00210  op=5b  1f 00 00 00  RET              return/leave with s31

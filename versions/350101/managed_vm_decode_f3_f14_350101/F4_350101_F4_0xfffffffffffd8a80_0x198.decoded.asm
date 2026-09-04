; MetaSec managed bytecode decode: F4
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F4_0xfffffffffffd8a80_0x198.bin
; records: 17  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=18  00 04 01 00  SHL32_IMM        s1 = (int32_t)(s4 << 0)
0001  +0x00018  op=b2  01 02 0f 00  AND64_IMM16      s2 = s1 & 0xf
0002  +0x00030  op=b2  01 01 f0 00  AND64_IMM16      s1 = s1 & 0xf0
0003  +0x00048  op=18  10 02 02 04  SHL32_IMM        s2 = (int32_t)(s2 << 4)
0004  +0x00060  op=0e  0b 01 01 04  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 4)
0005  +0x00078  op=34  01 02 01 00  OR64             s1 = s1 | s2
0006  +0x00090  op=b2  01 02 33 00  AND64_IMM16      s2 = s1 & 0x33
0007  +0x000a8  op=0e  0b 01 01 02  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 2)
0008  +0x000c0  op=18  11 02 02 02  SHL32_IMM        s2 = (int32_t)(s2 << 2)
0009  +0x000d8  op=b2  01 01 33 00  AND64_IMM16      s1 = s1 & 0x33
000a  +0x000f0  op=34  01 02 01 01  OR64             s1 = s1 | s2
000b  +0x00108  op=b2  01 02 55 00  AND64_IMM16      s2 = s1 & 0x55
000c  +0x00120  op=0e  0d 01 01 01  LSR32_IMM        s1 = sign_extend_32((uint32_t)s1 >> 1)
000d  +0x00138  op=18  10 02 02 01  SHL32_IMM        s2 = (int32_t)(s2 << 1)
000e  +0x00150  op=b2  01 01 55 00  AND64_IMM16      s1 = s1 & 0x55
000f  +0x00168  op=34  01 02 02 00  OR64             s2 = s1 | s2
0010  +0x00180  op=5b  1f 00 00 00  RET              return/leave with s31

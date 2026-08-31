; MetaSec managed bytecode decode: F15
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F15_0x606200_0x2a0.bin
; records: 28  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=54  00 01 31 16  CONST_HI16       s1 = sign_extend_32(0x1631 << 16) ; q1=0xffff1800001f1d2a
0001  +0x00018  op=54  05 07 8d e3  CONST_HI16       s7 = sign_extend_32(0xe38d << 16) ; q1=0x80000101d1a
0002  +0x00030  op=54  00 08 fb b0  CONST_HI16       s8 = sign_extend_32(0xb0fb << 16) ; q1=0x2f011000043e
0003  +0x00048  op=54  02 02 6f a9  CONST_HI16       s2 = sign_extend_32(0xa96f << 16) ; q1=0x20013
0004  +0x00060  op=54  05 03 8a da  CONST_HI16       s3 = sign_extend_32(0xda8a << 16) ; q1=0x20100004010d
0005  +0x00078  op=54  00 05 24 17  CONST_HI16       s5 = sign_extend_32(0x1724 << 16) ; q1=0x130000030204
0006  +0x00090  op=54  05 06 14 49  CONST_HI16       s6 = sign_extend_32(0x4914 << 16) ; q1=0x70000000105
0007  +0x000a8  op=33  07 07 4d ee  OR_IMM16         s7 = s7 | 0xee4d ; q1=0x1d010104013e
0008  +0x000c0  op=33  08 08 4e 0e  OR_IMM16         s8 = s8 | 0xe4e ; q1=0x2d010104012c
0009  +0x000d8  op=33  01 01 aa 38  OR_IMM16         s1 = s1 | 0x38aa ; q1=0x1d010404013e
000a  +0x000f0  op=33  02 02 bc 30  OR_IMM16         s2 = s2 | 0x30bc ; q1=0x10524
000b  +0x00108  op=33  06 06 b9 b2  OR_IMM16         s6 = s6 | 0xb2b9 ; q1=0x1f010101062c
000c  +0x00120  op=33  05 05 d7 42  OR_IMM16         s5 = s5 | 0x42d7 ; q1=0x260004060400
000d  +0x00138  op=33  03 03 00 06  OR_IMM16         s3 = s3 | 0x600 ; q1=0x270004000100
000e  +0x00150  op=08  04 08 24 00  ST32             *(s4 +0x24) = (uint32_t)s8 ; q1=0x10000050519
000f  +0x00168  op=08  04 07 20 00  ST32             *(s4 +0x20) = (uint32_t)s7 ; q1=0x40000041e2b
0010  +0x00180  op=08  04 01 1c 00  ST32             *(s4 +0x1c) = (uint32_t)s1 ; q1=0x40000051e19
0011  +0x00198  op=54  00 01 80 73  CONST_HI16       s1 = sign_extend_32(0x7380 << 16) ; q1=0xe0000000014
0012  +0x001b0  op=08  04 02 18 00  ST32             *(s4 +0x18) = (uint32_t)s2 ; q1=0x3b0300010122
0013  +0x001c8  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0 ; q1=0x1f011d001e2c
0014  +0x001e0  op=08  04 03 14 00  ST32             *(s4 +0x14) = (uint32_t)s3 ; q1=0x1000001e1d1e
0015  +0x001f8  op=08  04 05 10 00  ST32             *(s4 +0x10) = (uint32_t)s5 ; q1=0x2000001d1d1d
0016  +0x00210  op=08  04 06 0c 00  ST32             *(s4 +0xc) = (uint32_t)s6
0017  +0x00228  op=08  04 00 04 00  ST32             *(s4 +0x4) = (uint32_t)s0
0018  +0x00240  op=08  04 00 00 00  ST32             *(s4 +0x0) = (uint32_t)s0
0019  +0x00258  op=33  01 01 6f 16  OR_IMM16         s1 = s1 | 0x166f
001a  +0x00270  op=08  04 01 08 00  ST32             *(s4 +0x8) = (uint32_t)s1
001b  +0x00288  op=5b  1f 00 00 00  RET              return/leave with s31

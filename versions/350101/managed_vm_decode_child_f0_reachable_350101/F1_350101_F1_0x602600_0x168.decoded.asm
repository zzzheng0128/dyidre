; MetaSec managed bytecode decode: F1
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F1_0x602600_0x168.bin
; records: 15  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=54  05 01 c2 eb  CONST_HI16       s1 = sign_extend_32(0xebc2 << 16) ; q1=0xffff2801001f1d3f
0001  +0x00018  op=54  05 02 10 7c  CONST_HI16       s2 = sign_extend_32(0x7c10 << 16) ; q1=0x180100131d1a
0002  +0x00030  op=54  02 03 b5 c8  CONST_HI16       s3 = sign_extend_32(0xc8b5 << 16) ; q1=0x480080100111d1a
0003  +0x00048  op=33  01 01 cd f8  OR_IMM16         s1 = s1 | 0xf8cd ; q1=0x4402f011e001d3e
0004  +0x00060  op=33  02 02 93 4d  OR_IMM16         s2 = s2 | 0x4d93 ; q1=0x782f011200053e
0005  +0x00078  op=08  04 01 10 00  ST32             *(s4 +0x10) = (uint32_t)s1 ; q1=0x48300000001e3f
0006  +0x00090  op=33  03 01 70 25  OR_IMM16         s1 = s3 | 0x2570 ; q1=0x281f380000001e2b
0007  +0x000a8  op=08  04 02 14 00  ST32             *(s4 +0x14) = (uint32_t)s2 ; q1=0x110000004121e
0008  +0x000c0  op=08  04 00 04 00  ST32             *(s4 +0x4) = (uint32_t)s0 ; q1=0x3280000061e19
0009  +0x000d8  op=08  04 00 00 00  ST32             *(s4 +0x0) = (uint32_t)s0 ; q1=0x83070000000012
000a  +0x000f0  op=08  04 01 0c 00  ST32             *(s4 +0xc) = (uint32_t)s1 ; q1=0x4000000005010f
000b  +0x00108  op=54  02 01 e0 79  CONST_HI16       s1 = sign_extend_32(0x79e0 << 16) ; q1=0xf250004001200
000c  +0x00120  op=33  01 01 fb f2  OR_IMM16         s1 = s1 | 0xf2fb ; q1=0x682f010400133e
000d  +0x00138  op=08  04 01 08 00  ST32             *(s4 +0x8) = (uint32_t)s1 ; q1=0x937090000000003
000e  +0x00150  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x81250013000200

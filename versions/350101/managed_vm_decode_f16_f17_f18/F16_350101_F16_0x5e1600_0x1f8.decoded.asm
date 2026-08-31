; MetaSec managed bytecode decode: F16
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f16_f17_f18_20260831_031044/350101_F16_0x5e1600_0x1f8.bin
; records: 21  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=58  05 08 08 00  LD64             s8 = *(uint64_t *)(s5 +0x8)
0001  +0x00018  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
0002  +0x00030  op=85  00 02 00 00  ADD64_IMM16      s2 = s0 +0x0 ; q1=0x12274848 rt/so-mapped
0003  +0x00048  op=85  00 03 40 02  ADD64_IMM16      s3 = s0 +0x240
0004  +0x00060  op=34  08 00 07 00  OR64             s7 = s8 | s0
0005  +0x00078  op=ae  02 03 0c 00  BR_EQ64          if (s2 == s3) goto record +18
0006  +0x00090  op=72  01 07 01 18  ROL64_32MINUS_IMM s1 = rol64(s7, 32 - 24)
0007  +0x000a8  op=72  01 07 08 1f  ROL64_32MINUS_IMM s8 = rol64(s7, 32 - 31)
0008  +0x000c0  op=b3  08 01 01 00  AND64            s1 = s8 & s1
0009  +0x000d8  op=72  01 07 08 1e  ROL64_32MINUS_IMM s8 = rol64(s7, 32 - 30)
000a  +0x000f0  op=02  08 05 05 00  XOR64            s5 = s5 ^ s8 ; q1=0x12274848 rt/so-mapped
000b  +0x00108  op=02  05 01 01 01  XOR64            s1 = s1 ^ s5
000c  +0x00120  op=84  04 02 05 14  ADD64            s5 = s4 + s2
000d  +0x00138  op=85  02 02 08 00  ADD64_IMM16      s2 = s2 +0x8
000e  +0x00150  op=58  05 05 00 00  LD64             s5 = *(uint64_t *)(s5 +0x0)
000f  +0x00168  op=02  01 05 08 01  XOR64            s8 = s5 ^ s1
0010  +0x00180  op=34  07 00 05 01  OR64             s5 = s7 | s0
0011  +0x00198  op=5f  f2 ff ff ff  ADD_PC_IMM32     goto record +4 ; vm_pc = current_pc + 1 + -14
0012  +0x001b0  op=25  06 07 08 00  ST64             *(s6 +0x8) = s7 ; q1=0x12274848 rt/so-mapped
0013  +0x001c8  op=25  06 05 00 00  ST64             *(s6 +0x0) = s5
0014  +0x001e0  op=5b  1f 00 00 00  RET              return/leave with s31

; MetaSec managed bytecode decode: F2
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f0_f1_f2_20260904/350101_F2_0xfffffffffffe9500_0x270.bin
; records: 26  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=18  00 05 01 00  SHL32_IMM        s1 = (int32_t)(s5 << 0)
0001  +0x00018  op=15  01 02 01 00  CMP_LT_IMM64S    s2 = ((int64_t)s1 < 1) ? 1 : 0
0002  +0x00030  op=1f  01 02 03 00  CMOVZ64          s3 = (s2 == 0) ? s1 : 0
0003  +0x00048  op=b5  00 02 00 00  ADD32_IMM16      s2 = int32(s0 +0x0)
0004  +0x00060  op=34  02 00 05 01  OR64             s5 = s2 | s0
0005  +0x00078  op=ae  03 05 13 00  BR_EQ64          if (s3 == s5) goto record +25
0006  +0x00090  op=b2  05 01 01 00  AND64_IMM16      s1 = s5 & 0x1
0007  +0x000a8  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +15
0008  +0x000c0  op=18  11 02 01 07  SHL32_IMM        s1 = (int32_t)(s2 << 7)
0009  +0x000d8  op=02  01 02 01 01  XOR64            s1 = s2 ^ s1
000a  +0x000f0  op=0e  00 02 02 03  LSR32_IMM        s2 = sign_extend_32((uint32_t)s2 >> 3)
000b  +0x00108  op=02  01 02 01 01  XOR64            s1 = s2 ^ s1
000c  +0x00120  op=59  04 02 00 00  LD8U             s2 = *(uint8_t *)(s4 +0x0)
000d  +0x00138  op=02  01 02 02 01  XOR64            s2 = s2 ^ s1
000e  +0x00150  op=5f  07 00 00 00  ADD_PC_IMM32     goto record +22 ; vm_pc = current_pc + 1 + 7
000f  +0x00168  op=59  04 01 00 00  LD8U             s1 = *(uint8_t *)(s4 +0x0)
0010  +0x00180  op=18  10 02 06 0b  SHL32_IMM        s6 = (int32_t)(s2 << 11)
0011  +0x00198  op=34  06 01 01 01  OR64             s1 = s6 | s1
0012  +0x001b0  op=0e  0b 02 06 05  LSR32_IMM        s6 = sign_extend_32((uint32_t)s2 >> 5)
0013  +0x001c8  op=02  02 06 02 01  XOR64            s2 = s6 ^ s2
0014  +0x001e0  op=02  02 01 01 01  XOR64            s1 = s1 ^ s2
0015  +0x001f8  op=36  01 00 02 01  NOR64            s2 = ~(s1 | s0)
0016  +0x00210  op=b5  05 05 01 00  ADD32_IMM16      s5 = int32(s5 +0x1)
0017  +0x00228  op=85  04 04 01 00  ADD64_IMM16      s4 = s4 +0x1
0018  +0x00240  op=a7  03 05 ed ff  BR_NE64          if (s3 != s5) goto record +6
0019  +0x00258  op=5b  1f 00 00 00  RET              return/leave with s31

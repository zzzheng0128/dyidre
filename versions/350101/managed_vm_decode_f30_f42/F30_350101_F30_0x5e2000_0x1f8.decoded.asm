; MetaSec managed bytecode decode: F30
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_f30_f42_350101_20260831_044228/350101_F30_0x5e2000_0x1f8.bin
; records: 21  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=18  11 05 05 00  SHL32_IMM        s5 = (int32_t)(s5 << 0)
0001  +0x00018  op=18  10 04 03 00  SHL32_IMM        s3 = (int32_t)(s4 << 0)
0002  +0x00030  op=b5  00 02 00 00  ADD32_IMM16      s2 = int32(s0 +0x0)
0003  +0x00048  op=b2  03 01 ff 00  AND64_IMM16      s1 = s3 & 0xff
0004  +0x00060  op=ae  01 00 0f 00  BR_EQ64          if (s1 == s0) goto record +20
0005  +0x00078  op=23  04 05 04 11  SEXT8_SLOT       s4 = (int64_t)(int8_t)(uint8_t)s5
0006  +0x00090  op=18  10 05 01 01  SHL32_IMM        s1 = (int32_t)(s5 << 1)
0007  +0x000a8  op=15  04 04 00 00  CMP_LT_IMM64S    s4 = ((int64_t)s4 < 0) ? 1 : 0
0008  +0x000c0  op=1f  01 04 06 00  CMOVZ64          s6 = (s4 == 0) ? s1 : 0
0009  +0x000d8  op=01  01 01 1b 00  XOR_IMM16        s1 = s1 ^ 0x1b
000a  +0x000f0  op=1e  01 04 01 00  CMOVNZ64         s1 = (s4 != 0) ? s1 : 0
000b  +0x00108  op=b2  03 04 01 00  AND64_IMM16      s4 = s3 & 0x1
000c  +0x00120  op=b2  03 03 fe 00  AND64_IMM16      s3 = s3 & 0xfe
000d  +0x00138  op=09  00 04 04 14  SUB32            s4 = sign_extend_32((uint32_t)s0 - (uint32_t)s4)
000e  +0x00150  op=34  01 06 01 01  OR64             s1 = s1 | s6
000f  +0x00168  op=0e  0b 03 03 01  LSR32_IMM        s3 = sign_extend_32((uint32_t)s3 >> 1)
0010  +0x00180  op=b3  04 05 04 01  AND64            s4 = s4 & s5
0011  +0x00198  op=34  01 00 05 01  OR64             s5 = s1 | s0
0012  +0x001b0  op=02  04 02 02 01  XOR64            s2 = s2 ^ s4
0013  +0x001c8  op=5f  ef ff ff ff  ADD_PC_IMM32     goto record +3 ; vm_pc = current_pc + 1 + -17
0014  +0x001e0  op=5b  1f 00 00 00  RET              return/leave with s31

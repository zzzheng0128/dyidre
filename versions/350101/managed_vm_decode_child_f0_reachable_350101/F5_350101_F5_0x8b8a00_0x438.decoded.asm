; MetaSec managed bytecode decode: F5
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F5_0x8b8a00_0x438.bin
; records: 45  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d e0 ff  ADD64_IMM16      s29 = s29 -0x20
0001  +0x00018  op=25  1d 1f 18 00  ST64             *(s29 +0x18) = s31
0002  +0x00030  op=25  1d 1e 10 00  ST64             *(s29 +0x10) = s30
0003  +0x00048  op=25  1d 10 08 00  ST64             *(s29 +0x8) = s16
0004  +0x00060  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
0005  +0x00078  op=54  02 01 22 20  CONST_HI16       s1 = sign_extend_32(0x2022 << 16)
0006  +0x00090  op=34  06 00 10 01  OR64             s16 = s6 | s0
0007  +0x000a8  op=b5  00 02 00 00  ADD32_IMM16      s2 = int32(s0 +0x0)
0008  +0x000c0  op=b5  00 03 0c 00  ADD32_IMM16      s3 = int32(s0 +0xc)
0009  +0x000d8  op=34  06 00 05 01  OR64             s5 = s6 | s0
000a  +0x000f0  op=33  01 04 20 04  OR_IMM16         s4 = s1 | 0x420
000b  +0x00108  op=ae  02 03 13 00  BR_EQ64          if (s2 == s3) goto record +31
000c  +0x00120  op=b2  02 01 01 00  AND64_IMM16      s1 = s2 & 0x1
000d  +0x00138  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +21
000e  +0x00150  op=18  00 04 01 07  SHL32_IMM        s1 = (int32_t)(s4 << 7)
000f  +0x00168  op=02  01 04 01 01  XOR64            s1 = s4 ^ s1
0010  +0x00180  op=0e  00 04 04 03  LSR32_IMM        s4 = sign_extend_32((uint32_t)s4 >> 3)
0011  +0x00198  op=02  01 04 01 00  XOR64            s1 = s4 ^ s1
0012  +0x001b0  op=59  05 04 00 00  LD8U             s4 = *(uint8_t *)(s5 +0x0)
0013  +0x001c8  op=02  01 04 04 01  XOR64            s4 = s4 ^ s1
0014  +0x001e0  op=5f  07 00 00 00  ADD_PC_IMM32     goto record +28 ; vm_pc = current_pc + 1 + 7
0015  +0x001f8  op=59  05 01 00 00  LD8U             s1 = *(uint8_t *)(s5 +0x0)
0016  +0x00210  op=18  10 04 06 0b  SHL32_IMM        s6 = (int32_t)(s4 << 11)
0017  +0x00228  op=34  06 01 01 01  OR64             s1 = s6 | s1
0018  +0x00240  op=0e  0b 04 06 05  LSR32_IMM        s6 = sign_extend_32((uint32_t)s4 >> 5)
0019  +0x00258  op=02  04 06 04 01  XOR64            s4 = s6 ^ s4
001a  +0x00270  op=02  04 01 01 01  XOR64            s1 = s1 ^ s4
001b  +0x00288  op=36  01 00 04 00  NOR64            s4 = ~(s1 | s0)
001c  +0x002a0  op=b5  02 02 01 00  ADD32_IMM16      s2 = int32(s2 +0x1)
001d  +0x002b8  op=85  05 05 01 00  ADD64_IMM16      s5 = s5 +0x1
001e  +0x002d0  op=a7  02 03 ed ff  BR_NE64          if (s2 != s3) goto record +12
001f  +0x002e8  op=08  1e 04 04 00  ST32             *(s30 +0x4) = (uint32_t)s4
0020  +0x00300  op=85  10 04 10 00  ADD64_IMM16      s4 = s16 +0x10
0021  +0x00318  op=85  1e 05 04 00  ADD64_IMM16      s5 = s30 +0x4
0022  +0x00330  op=85  00 06 04 00  ADD64_IMM16      s6 = s0 +0x4
0023  +0x00348  op=5e  05 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5] via q1 table ; q1=0x125fd420 rt/so-mapped
0024  +0x00360  op=59  10 01 10 00  LD8U             s1 = *(uint8_t *)(s16 +0x10)
0025  +0x00378  op=33  01 01 04 00  OR_IMM16         s1 = s1 | 0x4
0026  +0x00390  op=26  10 01 10 00  ST8              *(s16 +0x10) = (uint8_t)s1
0027  +0x003a8  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0028  +0x003c0  op=58  1d 10 08 00  LD64             s16 = *(uint64_t *)(s29 +0x8)
0029  +0x003d8  op=58  1d 1e 10 00  LD64             s30 = *(uint64_t *)(s29 +0x10)
002a  +0x003f0  op=58  1d 1f 18 00  LD64             s31 = *(uint64_t *)(s29 +0x18)
002b  +0x00408  op=85  1d 1d 20 00  ADD64_IMM16      s29 = s29 +0x20
002c  +0x00420  op=5b  1f 00 00 00  RET              return/leave with s31

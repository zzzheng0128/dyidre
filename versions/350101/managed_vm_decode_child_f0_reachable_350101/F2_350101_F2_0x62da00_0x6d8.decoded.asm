; MetaSec managed bytecode decode: F2
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F2_0x62da00_0x6d8.bin
; records: 73  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d c0 ff  ADD64_IMM16      s29 = s29 -0x40
0001  +0x00018  op=25  1d 1f 38 00  ST64             *(s29 +0x38) = s31
0002  +0x00030  op=25  1d 1e 30 00  ST64             *(s29 +0x30) = s30 ; q1=0x324604
0003  +0x00048  op=25  1d 15 28 00  ST64             *(s29 +0x28) = s21 ; q1=0x6900000000
0004  +0x00060  op=25  1d 14 20 00  ST64             *(s29 +0x20) = s20
0005  +0x00078  op=25  1d 13 18 00  ST64             *(s29 +0x18) = s19
0006  +0x00090  op=25  1d 12 10 00  ST64             *(s29 +0x10) = s18 ; q1=0x354604
0007  +0x000a8  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17 ; q1=0x6c00000000
0008  +0x000c0  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
0009  +0x000d8  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000a  +0x000f0  op=ae  06 00 33 00  BR_EQ64          if (s6 == s0) goto record +62 ; q1=0x384604
000b  +0x00108  op=34  06 00 10 01  OR64             s16 = s6 | s0 ; q1=0x6f00000000
000c  +0x00120  op=52  04 01 00 00  LD32S            s1 = *(int32_t *)(s4 +0x0)
000d  +0x00138  op=34  04 00 12 01  OR64             s18 = s4 | s0
000e  +0x00150  op=34  05 00 11 01  OR64             s17 = s5 | s0 ; q1=0x31314606
000f  +0x00168  op=18  10 10 02 00  SHL32_IMM        s2 = (int32_t)(s16 << 0) ; q1=0x7200000000
0010  +0x00180  op=b4  01 02 02 12  ADD32            s2 = int32(s1 + s2)
0011  +0x00198  op=08  04 02 00 00  ST32             *(s4 +0x0) = (uint32_t)s2
0012  +0x001b0  op=13  02 01 04 0f  CMP_LO64         s4 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0 ; q1=0x30324606
0013  +0x001c8  op=b2  01 02 3f 00  AND64_IMM16      s2 = s1 & 0x3f ; q1=0x7500000000
0014  +0x001e0  op=b5  00 01 40 00  ADD32_IMM16      s1 = int32(s0 +0x40)
0015  +0x001f8  op=09  01 02 01 04  SUB32            s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s2)
0016  +0x00210  op=6d  00 01 03 00  SHL64_IMM32PLUS  s3 = s1 << (0 + 32) ; q1=0x33314606
0017  +0x00228  op=ae  04 00 03 00  BR_EQ64          if (s4 == s0) goto record +27 ; q1=0x7800000000
0018  +0x00240  op=52  12 01 04 00  LD32S            s1 = *(int32_t *)(s18 +0x4)
0019  +0x00258  op=b5  01 01 01 00  ADD32_IMM16      s1 = int32(s1 +0x1)
001a  +0x00270  op=08  12 01 04 00  ST32             *(s18 +0x4) = (uint32_t)s1 ; q1=0x36314606
001b  +0x00288  op=b5  00 15 00 00  ADD32_IMM16      s21 = int32(s0 +0x0) ; q1=0x7b00000000
001c  +0x002a0  op=ae  02 00 17 00  BR_EQ64          if (s2 == s0) goto record +52
001d  +0x002b8  op=67  00 03 13 00  LSR64_IMM32PLUS  s19 = (uint64_t)s3 >> (0 + 32)
001e  +0x002d0  op=13  10 13 01 0f  CMP_LO64         s1 = ((uint64_t)s16 < (uint64_t)s19) ? 1 : 0 ; q1=0x33324606
001f  +0x002e8  op=ae  01 00 02 00  BR_EQ64          if (s1 == s0) goto record +34 ; q1=0x7e00000000
0020  +0x00300  op=34  02 00 15 00  OR64             s21 = s2 | s0
0021  +0x00318  op=5f  12 00 00 00  ADD_PC_IMM32     goto record +52 ; vm_pc = current_pc + 1 + 18
0022  +0x00330  op=6d  00 02 01 00  SHL64_IMM32PLUS  s1 = s2 << (0 + 32) ; q1=0x39334606
0023  +0x00348  op=85  12 14 18 00  ADD64_IMM16      s20 = s18 +0x18 ; q1=0x8100000000
0024  +0x00360  op=34  11 00 05 01  OR64             s5 = s17 | s0
0025  +0x00378  op=34  13 00 06 01  OR64             s6 = s19 | s0
0026  +0x00390  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32) ; q1=0x38344606
0027  +0x003a8  op=84  14 01 04 14  ADD64            s4 = s20 + s1 ; q1=0x8400000000
0028  +0x003c0  op=5e  05 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5] via q1 table ; q1=0x125fd420 rt/so-mapped
0029  +0x003d8  op=34  12 00 04 01  OR64             s4 = s18 | s0
002a  +0x003f0  op=34  14 00 05 01  OR64             s5 = s20 | s0 ; q1=0x36324606
002b  +0x00408  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd420 rt/so-mapped
002c  +0x00420  op=64  10 13 10 12  SUB64            s16 = s16 - s19
002d  +0x00438  op=84  11 13 11 00  ADD64            s17 = s17 + s19
002e  +0x00450  op=5f  05 00 00 00  ADD_PC_IMM32     goto record +52 ; vm_pc = current_pc + 1 + 5 ; q1=0x39324606
002f  +0x00468  op=34  12 00 04 00  OR64             s4 = s18 | s0 ; q1=0x8a00000000
0030  +0x00480  op=34  11 00 05 01  OR64             s5 = s17 | s0
0031  +0x00498  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd420 rt/so-mapped
0032  +0x004b0  op=85  10 10 c0 ff  ADD64_IMM16      s16 = s16 -0x40 ; q1=0x34334606
0033  +0x004c8  op=85  11 11 40 00  ADD64_IMM16      s17 = s17 +0x40 ; q1=0x8d00000000
0034  +0x004e0  op=14  10 01 40 00  CMP_LO_IMM64     s1 = ((uint64_t)s16 < (uint64_t)64) ? 1 : 0
0035  +0x004f8  op=ae  01 00 f9 ff  BR_EQ64          if (s1 == s0) goto record +47
0036  +0x00510  op=ae  10 00 07 00  BR_EQ64          if (s16 == s0) goto record +62 ; q1=0x37334606
0037  +0x00528  op=6d  00 15 01 00  SHL64_IMM32PLUS  s1 = s21 << (0 + 32) ; q1=0x9000000000
0038  +0x00540  op=34  11 00 05 01  OR64             s5 = s17 | s0
0039  +0x00558  op=34  10 00 06 01  OR64             s6 = s16 | s0
003a  +0x00570  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32) ; q1=0x32344606
003b  +0x00588  op=84  12 01 01 04  ADD64            s1 = s18 + s1 ; q1=0x9300000000
003c  +0x005a0  op=85  01 04 18 00  ADD64_IMM16      s4 = s1 +0x18
003d  +0x005b8  op=5e  05 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5] via q1 table ; q1=0x125fd420 rt/so-mapped
003e  +0x005d0  op=34  1e 00 1d 00  OR64             s29 = s30 | s0 ; q1=0x35344606
003f  +0x005e8  op=58  1d 10 00 00  LD64             s16 = *(uint64_t *)(s29 +0x0) ; q1=0x9600000000
0040  +0x00600  op=58  1d 11 08 00  LD64             s17 = *(uint64_t *)(s29 +0x8)
0041  +0x00618  op=58  1d 12 10 00  LD64             s18 = *(uint64_t *)(s29 +0x10)
0042  +0x00630  op=58  1d 13 18 00  LD64             s19 = *(uint64_t *)(s29 +0x18) ; q1=0x30354606
0043  +0x00648  op=58  1d 14 20 00  LD64             s20 = *(uint64_t *)(s29 +0x20) ; q1=0x9900000000
0044  +0x00660  op=58  1d 15 28 00  LD64             s21 = *(uint64_t *)(s29 +0x28)
0045  +0x00678  op=58  1d 1e 30 00  LD64             s30 = *(uint64_t *)(s29 +0x30)
0046  +0x00690  op=58  1d 1f 38 00  LD64             s31 = *(uint64_t *)(s29 +0x38) ; q1=0x33354606
0047  +0x006a8  op=85  1d 1d 40 00  ADD64_IMM16      s29 = s29 +0x40 ; q1=0x9c00000000
0048  +0x006c0  op=5b  1f 00 00 00  RET              return/leave with s31

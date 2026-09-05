; MetaSec managed bytecode decode: F75
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F75_0x61fa00_0x948.bin
; records: 99  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d c0 ff  ADD64_IMM16      s29 = s29 -0x40
0001  +0x00018  op=25  1d 1f 38 00  ST64             *(s29 +0x38) = s31
0002  +0x00030  op=25  1d 1e 30 00  ST64             *(s29 +0x30) = s30
0003  +0x00048  op=25  1d 14 28 00  ST64             *(s29 +0x28) = s20
0004  +0x00060  op=25  1d 13 20 00  ST64             *(s29 +0x20) = s19
0005  +0x00078  op=25  1d 12 18 00  ST64             *(s29 +0x18) = s18
0006  +0x00090  op=25  1d 11 10 00  ST64             *(s29 +0x10) = s17
0007  +0x000a8  op=25  1d 10 08 00  ST64             *(s29 +0x8) = s16
0008  +0x000c0  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
0009  +0x000d8  op=52  04 02 60 00  LD32S            s2 = *(int32_t *)(s4 +0x60)
000a  +0x000f0  op=34  05 00 11 00  OR64             s17 = s5 | s0
000b  +0x00108  op=34  04 00 10 01  OR64             s16 = s4 | s0
000c  +0x00120  op=18  10 06 14 00  SHL32_IMM        s20 = (int32_t)(s6 << 0)
000d  +0x00138  op=ae  02 00 27 00  BR_EQ64          if (s2 == s0) goto record +53
000e  +0x00150  op=6d  00 02 01 00  SHL64_IMM32PLUS  s1 = s2 << (0 + 32)
000f  +0x00168  op=67  00 01 01 00  LSR64_IMM32PLUS  s1 = (uint64_t)s1 >> (0 + 32)
0010  +0x00180  op=84  10 01 04 14  ADD64            s4 = s16 + s1
0011  +0x00198  op=b5  00 01 40 00  ADD32_IMM16      s1 = int32(s0 +0x40)
0012  +0x001b0  op=09  01 02 13 14  SUB32            s19 = sign_extend_32((uint32_t)s1 - (uint32_t)s2)
0013  +0x001c8  op=13  14 13 01 0f  CMP_LO64         s1 = ((uint64_t)s20 < (uint64_t)s19) ? 1 : 0
0014  +0x001e0  op=ae  01 00 07 00  BR_EQ64          if (s1 == s0) goto record +28
0015  +0x001f8  op=6d  00 14 01 00  SHL64_IMM32PLUS  s1 = s20 << (0 + 32)
0016  +0x00210  op=34  11 00 05 01  OR64             s5 = s17 | s0
0017  +0x00228  op=67  00 01 06 00  LSR64_IMM32PLUS  s6 = (uint64_t)s1 >> (0 + 32)
0018  +0x00240  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd360 rt/so-mapped
0019  +0x00258  op=52  10 01 60 00  LD32S            s1 = *(int32_t *)(s16 +0x60)
001a  +0x00270  op=b4  01 14 14 12  ADD32            s20 = int32(s1 + s20)
001b  +0x00288  op=5f  3c 00 00 00  ADD_PC_IMM32     goto record +88 ; vm_pc = current_pc + 1 + 60
001c  +0x002a0  op=6d  00 13 01 00  SHL64_IMM32PLUS  s1 = s19 << (0 + 32)
001d  +0x002b8  op=34  11 00 05 01  OR64             s5 = s17 | s0
001e  +0x002d0  op=67  00 01 12 00  LSR64_IMM32PLUS  s18 = (uint64_t)s1 >> (0 + 32)
001f  +0x002e8  op=34  12 00 06 01  OR64             s6 = s18 | s0
0020  +0x00300  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd360 rt/so-mapped
0021  +0x00318  op=34  10 00 04 01  OR64             s4 = s16 | s0
0022  +0x00330  op=5e  6a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6a] via q1 table ; q1=0x125fd360 rt/so-mapped
0023  +0x00348  op=58  10 01 58 00  LD64             s1 = *(uint64_t *)(s16 +0x58)
0024  +0x00360  op=85  01 02 00 02  ADD64_IMM16      s2 = s1 +0x200
0025  +0x00378  op=14  01 01 00 fe  CMP_LO_IMM64     s1 = ((uint64_t)s1 < (uint64_t)-512) ? 1 : 0
0026  +0x00390  op=25  10 02 58 00  ST64             *(s16 +0x58) = s2
0027  +0x003a8  op=a7  01 00 0b 00  BR_NE64          if (s1 != s0) goto record +51
0028  +0x003c0  op=58  10 01 50 00  LD64             s1 = *(uint64_t *)(s16 +0x50)
0029  +0x003d8  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
002a  +0x003f0  op=25  10 01 50 00  ST64             *(s16 +0x50) = s1
002b  +0x00408  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +51
002c  +0x00420  op=58  10 01 48 00  LD64             s1 = *(uint64_t *)(s16 +0x48)
002d  +0x00438  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
002e  +0x00450  op=25  10 01 48 00  ST64             *(s16 +0x48) = s1
002f  +0x00468  op=a7  01 00 03 00  BR_NE64          if (s1 != s0) goto record +51
0030  +0x00480  op=58  10 01 40 00  LD64             s1 = *(uint64_t *)(s16 +0x40)
0031  +0x00498  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
0032  +0x004b0  op=25  10 01 40 00  ST64             *(s16 +0x40) = s1
0033  +0x004c8  op=09  14 13 14 14  SUB32            s20 = sign_extend_32((uint32_t)s20 - (uint32_t)s19)
0034  +0x004e0  op=84  11 12 11 00  ADD64            s17 = s17 + s18
0035  +0x004f8  op=6d  00 14 01 00  SHL64_IMM32PLUS  s1 = s20 << (0 + 32)
0036  +0x00510  op=85  00 13 40 00  ADD64_IMM16      s19 = s0 +0x40
0037  +0x00528  op=67  00 01 12 00  LSR64_IMM32PLUS  s18 = (uint64_t)s1 >> (0 + 32)
0038  +0x00540  op=14  14 01 40 00  CMP_LO_IMM64     s1 = ((uint64_t)s20 < (uint64_t)64) ? 1 : 0
0039  +0x00558  op=a7  01 00 1a 00  BR_NE64          if (s1 != s0) goto record +84
003a  +0x00570  op=34  10 00 04 00  OR64             s4 = s16 | s0
003b  +0x00588  op=34  11 00 05 00  OR64             s5 = s17 | s0
003c  +0x005a0  op=34  13 00 06 00  OR64             s6 = s19 | s0
003d  +0x005b8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd360 rt/so-mapped
003e  +0x005d0  op=34  10 00 04 01  OR64             s4 = s16 | s0
003f  +0x005e8  op=5e  6a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6a] via q1 table ; q1=0x125fd360 rt/so-mapped
0040  +0x00600  op=58  10 01 58 00  LD64             s1 = *(uint64_t *)(s16 +0x58)
0041  +0x00618  op=85  01 02 00 02  ADD64_IMM16      s2 = s1 +0x200
0042  +0x00630  op=14  01 01 00 fe  CMP_LO_IMM64     s1 = ((uint64_t)s1 < (uint64_t)-512) ? 1 : 0
0043  +0x00648  op=25  10 02 58 00  ST64             *(s16 +0x58) = s2
0044  +0x00660  op=a7  01 00 0b 00  BR_NE64          if (s1 != s0) goto record +80
0045  +0x00678  op=58  10 01 50 00  LD64             s1 = *(uint64_t *)(s16 +0x50)
0046  +0x00690  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
0047  +0x006a8  op=25  10 01 50 00  ST64             *(s16 +0x50) = s1
0048  +0x006c0  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +80
0049  +0x006d8  op=58  10 01 48 00  LD64             s1 = *(uint64_t *)(s16 +0x48)
004a  +0x006f0  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
004b  +0x00708  op=25  10 01 48 00  ST64             *(s16 +0x48) = s1
004c  +0x00720  op=a7  01 00 03 00  BR_NE64          if (s1 != s0) goto record +80
004d  +0x00738  op=58  10 01 40 00  LD64             s1 = *(uint64_t *)(s16 +0x40)
004e  +0x00750  op=85  01 01 01 00  ADD64_IMM16      s1 = s1 +0x1
004f  +0x00768  op=25  10 01 40 00  ST64             *(s16 +0x40) = s1
0050  +0x00780  op=85  12 12 c0 ff  ADD64_IMM16      s18 = s18 -0x40
0051  +0x00798  op=b5  14 14 c0 ff  ADD32_IMM16      s20 = int32(s20 -0x40)
0052  +0x007b0  op=85  11 11 40 00  ADD64_IMM16      s17 = s17 +0x40
0053  +0x007c8  op=5f  e4 ff ff ff  ADD_PC_IMM32     goto record +56 ; vm_pc = current_pc + 1 + -28
0054  +0x007e0  op=34  10 00 04 01  OR64             s4 = s16 | s0
0055  +0x007f8  op=34  11 00 05 01  OR64             s5 = s17 | s0
0056  +0x00810  op=34  12 00 06 01  OR64             s6 = s18 | s0
0057  +0x00828  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd360 rt/so-mapped
0058  +0x00840  op=08  10 14 60 00  ST32             *(s16 +0x60) = (uint32_t)s20
0059  +0x00858  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
005a  +0x00870  op=58  1d 10 08 00  LD64             s16 = *(uint64_t *)(s29 +0x8)
005b  +0x00888  op=58  1d 11 10 00  LD64             s17 = *(uint64_t *)(s29 +0x10)
005c  +0x008a0  op=58  1d 12 18 00  LD64             s18 = *(uint64_t *)(s29 +0x18)
005d  +0x008b8  op=58  1d 13 20 00  LD64             s19 = *(uint64_t *)(s29 +0x20)
005e  +0x008d0  op=58  1d 14 28 00  LD64             s20 = *(uint64_t *)(s29 +0x28)
005f  +0x008e8  op=58  1d 1e 30 00  LD64             s30 = *(uint64_t *)(s29 +0x30)
0060  +0x00900  op=58  1d 1f 38 00  LD64             s31 = *(uint64_t *)(s29 +0x38)
0061  +0x00918  op=85  1d 1d 40 00  ADD64_IMM16      s29 = s29 +0x40
0062  +0x00930  op=5b  1f 00 00 00  RET              return/leave with s31

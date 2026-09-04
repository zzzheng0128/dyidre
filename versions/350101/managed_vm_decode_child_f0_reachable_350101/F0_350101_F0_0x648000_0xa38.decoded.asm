; MetaSec managed bytecode decode: F0
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_20260904/350101_F0_0x648000_0xa38.bin
; records: 109  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 40 ff  ADD64_IMM16      s29 = s29 -0xc0 ; q1=0xffff2801001f1d1a
0001  +0x00018  op=25  1d 1f b8 00  ST64             *(s29 +0xb8) = s31 ; q1=0x180100171d1a
0002  +0x00030  op=25  1d 1e b0 00  ST64             *(s29 +0xb0) = s30 ; q1=0x480080100151d3f
0003  +0x00048  op=25  1d 17 a8 00  ST64             *(s29 +0xa8) = s23 ; q1=0x440380000131d3f
0004  +0x00060  op=25  1d 16 a0 00  ST64             *(s29 +0xa0) = s22 ; q1=0x78280000111d1a
0005  +0x00078  op=25  1d 15 98 00  ST64             *(s29 +0x98) = s21 ; q1=0x48010000030524
0006  +0x00090  op=25  1d 14 90 00  ST64             *(s29 +0x90) = s20 ; q1=0x281f0200001f0524
0007  +0x000a8  op=25  1d 13 88 00  ST64             *(s29 +0x88) = s19 ; q1=0x11d0000090524
0008  +0x000c0  op=25  1d 12 80 00  ST64             *(s29 +0x80) = s18 ; q1=0x31c0000140524
0009  +0x000d8  op=25  1d 11 78 00  ST64             *(s29 +0x78) = s17 ; q1=0x832d0000100524
000a  +0x000f0  op=25  1d 10 70 00  ST64             *(s29 +0x70) = s16 ; q1=0x402100000a0524
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0 ; q1=0xf3100001e0524
000c  +0x00120  op=53  04 01 68 00  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x68 ; q1=0x125fd468 rt/so-mapped
000d  +0x00138  op=85  1e 10 10 00  ADD64_IMM16      s16 = s30 +0x10 ; q1=0x937090000190524
000e  +0x00150  op=85  00 11 00 00  ADD64_IMM16      s17 = s0 +0x0 ; q1=0x81050000170524
000f  +0x00168  op=85  00 13 58 00  ADD64_IMM16      s19 = s0 +0x58 ; q1=0x8432500000e0524
0010  +0x00180  op=34  06 00 12 01  OR64             s18 = s6 | s0 ; q1=0x180000120524
0011  +0x00198  op=34  05 00 14 01  OR64             s20 = s5 | s0 ; q1=0x100000021d3f
0012  +0x001b0  op=34  04 00 15 01  OR64             s21 = s4 | s0 ; q1=0x13101f1f113e
0013  +0x001c8  op=58  01 16 00 00  LD64             s22 = *(uint64_t *)(s1 +0x0) ; q1=0x180b0b0000
0014  +0x001e0  op=53  03 01 78 00  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x78 ; q1=0x125fd468 rt/so-mapped
0015  +0x001f8  op=34  10 00 04 01  OR64             s4 = s16 | s0 ; q1=0x1c0000041d17
0016  +0x00210  op=34  11 00 05 01  OR64             s5 = s17 | s0 ; q1=0x818180000
0017  +0x00228  op=34  13 00 06 01  OR64             s6 = s19 | s0 ; q1=0x811110000
0018  +0x00240  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0) ; q1=0x13081717113e
0019  +0x00258  op=25  1e 01 08 00  ST64             *(s30 +0x8) = s1 ; q1=0x80c0c0000
001a  +0x00270  op=53  01 01 88 00  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x88 ; q1=0x125fd468 rt/so-mapped
001b  +0x00288  op=58  01 17 00 00  LD64             s23 = *(uint64_t *)(s1 +0x0) ; q1=0x1d010804013e
001c  +0x002a0  op=5e  00 00 00 00  CALL_CF_INDEX    call native_binding[index=0x0] via q1 table ; q1=0x125fd420 rt/so-mapped
001d  +0x002b8  op=34  10 00 04 01  OR64             s4 = s16 | s0 ; q1=0x2e00000a0524
001e  +0x002d0  op=5e  12 00 00 00  CALL_CF_INDEX    call native_binding[index=0x12] via q1 table ; q1=0x125fd420 rt/so-mapped
001f  +0x002e8  op=34  10 00 04 00  OR64             s4 = s16 | s0 ; q1=0xc0000011d2b
0020  +0x00300  op=34  15 00 05 01  OR64             s5 = s21 | s0 ; q1=0x2500061f0600
0021  +0x00318  op=34  14 00 06 01  OR64             s6 = s20 | s0 ; q1=0x807070000
0022  +0x00330  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x125fd420 rt/so-mapped
0023  +0x00348  op=34  10 00 04 01  OR64             s4 = s16 | s0 ; q1=0x180000041d2b
0024  +0x00360  op=34  12 00 05 01  OR64             s5 = s18 | s0 ; q1=0x240000190524
0025  +0x00378  op=5e  14 00 00 00  CALL_CF_INDEX    call native_binding[index=0x14] via q1 table ; q1=0x125fd420 rt/so-mapped
0026  +0x00390  op=5e  01 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1] via q1 table ; q1=0x125fd420 rt/so-mapped
0027  +0x003a8  op=34  02 00 14 01  OR64             s20 = s2 | s0 ; q1=0x2310121f102c
0028  +0x003c0  op=b5  00 15 01 00  ADD32_IMM16      s21 = int32(s0 +0x1) ; q1=0xc00000b0524
0029  +0x003d8  op=5e  02 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2] via q1 table ; q1=0x125fd420 rt/so-mapped
002a  +0x003f0  op=18  10 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0) ; q1=0x814160000
002b  +0x00408  op=ae  01 15 0a 00  BR_EQ64          if (s1 == s21) goto record +54 ; q1=0x23100101102c
002c  +0x00420  op=5e  03 00 00 00  CALL_CF_INDEX    call native_binding[index=0x3] via q1 table ; q1=0x125fd420 rt/so-mapped
002d  +0x00438  op=18  11 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0) ; q1=0x1e0000010524
002e  +0x00450  op=ae  01 15 07 00  BR_EQ64          if (s1 == s21) goto record +54 ; q1=0x1f011016102c
002f  +0x00468  op=54  02 02 59 f6  CONST_HI16       s2 = sign_extend_32(0xf659 << 16) ; q1=0x2f0116161e3e
0030  +0x00480  op=18  10 14 01 00  SHL32_IMM        s1 = (int32_t)(s20 << 0) ; q1=0x1f01111e112c
0031  +0x00498  op=33  02 02 50 08  OR_IMM16         s2 = s2 | 0x850 ; q1=0x13100a02113e
0032  +0x004b0  op=ae  01 02 03 00  BR_EQ64          if (s1 == s2) goto record +54 ; q1=0x400000b0524
0033  +0x004c8  op=34  12 00 06 01  OR64             s6 = s18 | s0 ; q1=0x2f01101e103e
0034  +0x004e0  op=5e  15 00 00 00  CALL_CF_INDEX    call native_binding[index=0x15] via q1 table ; q1=0x125fd420 rt/so-mapped
0035  +0x004f8  op=5f  02 00 00 00  ADD_PC_IMM32     goto record +56 ; vm_pc = current_pc + 1 + 2 ; q1=0x3b0000160524
0036  +0x00510  op=34  12 00 06 01  OR64             s6 = s18 | s0 ; q1=0x20b03062c
0037  +0x00528  op=5e  16 00 00 00  CALL_CF_INDEX    call native_binding[index=0x16] via q1 table ; q1=0x125fd420 rt/so-mapped
0038  +0x00540  op=59  16 01 00 00  LD8U             s1 = *(uint8_t *)(s22 +0x0) ; q1=0x2f01140b143e
0039  +0x00558  op=ae  01 00 03 00  BR_EQ64          if (s1 == s0) goto record +61 ; q1=0x23100e0b102c
003a  +0x00570  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8) ; q1=0x1a0000010524
003b  +0x00588  op=52  01 02 00 00  LD32S            s2 = *(int32_t *)(s1 +0x0) ; q1=0x60000090524
003c  +0x005a0  op=5f  17 00 00 00  ADD_PC_IMM32     goto record +84 ; vm_pc = current_pc + 1 + 23 ; q1=0x3e0000190524
003d  +0x005b8  op=52  17 02 00 00  LD32S            s2 = *(int32_t *)(s23 +0x0) ; q1=0x2f0103010c3e
003e  +0x005d0  op=a7  02 00 0f 00  BR_NE64          if (s2 != s0) goto record +78 ; q1=0x1009090000
003f  +0x005e8  op=85  1e 04 68 00  ADD64_IMM16      s4 = s30 +0x68 ; q1=0x13100c0c113e
0040  +0x00600  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd420 rt/so-mapped
0041  +0x00618  op=58  1e 01 68 00  LD64             s1 = *(uint64_t *)(s30 +0x68) ; q1=0x4683d00000c0524
0042  +0x00630  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0) ; q1=0x25d0e0000020524
0043  +0x00648  op=58  01 02 f0 01  LD64             s2 = *(uint64_t *)(s1 +0x1f0) ; q1=0x2a12f011e1e0c3e
0044  +0x00660  op=58  01 01 e8 01  LD64             s1 = *(uint64_t *)(s1 +0x1e8) ; q1=0x64923100202102c
0045  +0x00678  op=13  01 02 04 0f  CMP_LO64         s4 = ((uint64_t)s1 < (uint64_t)s2) ? 1 : 0 ; q1=0x49825000c091700
0046  +0x00690  op=64  01 02 03 02  SUB64            s3 = s1 - s2 ; q1=0x5ac0250002021800
0047  +0x006a8  op=64  02 01 01 12  SUB64            s1 = s2 - s1 ; q1=0xc6002f0119191e3e
0048  +0x006c0  op=18  00 04 04 00  SHL32_IMM        s4 = (int32_t)(s4 << 0) ; q1=0x63001f0000080524
0049  +0x006d8  op=1f  03 04 03 00  CMOVZ64          s3 = (s4 == 0) ? s3 : 0 ; q1=0x9ce5001018180000
004a  +0x006f0  op=1e  01 04 01 00  CMOVNZ64         s1 = (s4 != 0) ? s1 : 0 ; q1=0x4c230000090524
004b  +0x00708  op=34  01 03 01 00  OR64             s1 = s1 | s3 ; q1=0x2d03700000f0524
004c  +0x00720  op=18  00 01 02 00  SHL32_IMM        s2 = (int32_t)(s1 << 0) ; q1=0x3daf330000080524
004d  +0x00738  op=08  17 02 00 00  ST32             *(s23 +0x0) = (uint32_t)s2 ; q1=0x2cc0b0000010524
004e  +0x00750  op=b5  00 01 10 00  ADD32_IMM16      s1 = int32(s0 +0x10) ; q1=0x8631f010916072c
004f  +0x00768  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2 ; q1=0x859f23180f0f102c
0050  +0x00780  op=14  01 02 01 00  CMP_LO_IMM64     s2 = ((uint64_t)s1 < (uint64_t)1) ? 1 : 0 ; q1=0x509325000f0f0d00
0051  +0x00798  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8) ; q1=0x52af2f011218123e
0052  +0x007b0  op=08  01 02 00 00  ST32             *(s1 +0x0) = (uint32_t)s2 ; q1=0x2d4001816070000
0053  +0x007c8  op=26  16 15 00 00  ST8              *(s22 +0x0) = (uint8_t)s21 ; q1=0x5a13181e07113e
0054  +0x007e0  op=02  02 15 01 00  XOR64            s1 = s21 ^ s2 ; q1=0x186f23180707102c
0055  +0x007f8  op=59  12 02 10 00  LD8U             s2 = *(uint8_t *)(s18 +0x10) ; q1=0x30a0018100d0000
0056  +0x00810  op=13  00 01 01 0f  CMP_LO64         s1 = ((uint64_t)s0 < (uint64_t)s1) ? 1 : 0 ; q1=0xf7af25001e160e00
0057  +0x00828  op=18  00 01 01 05  SHL32_IMM        s1 = (int32_t)(s1 << 5) ; q1=0x10a53f00000a0524
0058  +0x00840  op=b2  02 02 df 00  AND64_IMM16      s2 = s2 & 0xdf ; q1=0xc600170000030524
0059  +0x00858  op=34  02 01 01 00  OR64             s1 = s2 | s1 ; q1=0x23313180e01113e
005a  +0x00870  op=26  12 01 10 00  ST8              *(s18 +0x10) = (uint8_t)s1 ; q1=0x7be323180a0a102c
005b  +0x00888  op=ae  11 13 04 00  BR_EQ64          if (s17 == s19) goto record +96 ; q1=0xb1c03519131f123e
005c  +0x008a0  op=84  10 11 01 00  ADD64            s1 = s16 + s17 ; q1=0x8340001803030000
005d  +0x008b8  op=85  11 11 01 00  ADD64_IMM16      s17 = s17 +0x1 ; q1=0xd713181801113e
005e  +0x008d0  op=26  01 00 00 00  ST8              *(s1 +0x0) = (uint8_t)s0 ; q1=0x9ff52f011003143e
005f  +0x008e8  op=a7  11 13 fc ff  BR_NE64          if (s17 != s19) goto record +92 ; q1=0x80ef241f0805020f
0060  +0x00900  op=34  1e 00 1d 01  OR64             s29 = s30 | s0 ; q1=0xe8b5070819140526
0061  +0x00918  op=58  1d 10 70 00  LD64             s16 = *(uint64_t *)(s29 +0x70) ; q1=0xbfc035061d02000f
0062  +0x00930  op=58  1d 11 78 00  LD64             s17 = *(uint64_t *)(s29 +0x78) ; q1=0xb5e123180101102c
0063  +0x00948  op=58  1d 12 80 00  LD64             s18 = *(uint64_t *)(s29 +0x80) ; q1=0x18c21e1304181826
0064  +0x00960  op=58  1d 13 88 00  LD64             s19 = *(uint64_t *)(s29 +0x88) ; q1=0x55210002171f132c
0065  +0x00978  op=58  1d 14 90 00  LD64             s20 = *(uint64_t *)(s29 +0x90) ; q1=0xce701e011613172c
0066  +0x00990  op=58  1d 15 98 00  LD64             s21 = *(uint64_t *)(s29 +0x98) ; q1=0x128030121915093e
0067  +0x009a8  op=58  1d 16 a0 00  LD64             s22 = *(uint64_t *)(s29 +0xa0) ; q1=0xc621210016170700
0068  +0x009c0  op=58  1d 17 a8 00  LD64             s23 = *(uint64_t *)(s29 +0xa8) ; q1=0xca9d210019040f00
0069  +0x009d8  op=58  1d 1e b0 00  LD64             s30 = *(uint64_t *)(s29 +0xb0) ; q1=0xae73301203030a3e
006a  +0x009f0  op=58  1d 1f b8 00  LD64             s31 = *(uint64_t *)(s29 +0xb8) ; q1=0x5500021403030100
006b  +0x00a08  op=85  1d 1d c0 00  ADD64_IMM16      s29 = s29 +0xc0 ; q1=0x50c024000a0a0300
006c  +0x00a20  op=5b  1f 00 00 00  RET              return/leave with s31 ; q1=0x164021000a0a1900

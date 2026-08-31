; MetaSec managed bytecode decode: F38
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/unidbg-android/target/managed_program_f32_family_350101_20260831_045757/350101_F38_0x7bf000_0xe70.bin
; records: 154  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 90 ff  ADD64_IMM16      s29 = s29 -0x70
0001  +0x00018  op=25  1d 1f 68 00  ST64             *(s29 +0x68) = s31
0002  +0x00030  op=25  1d 1e 60 00  ST64             *(s29 +0x60) = s30
0003  +0x00048  op=25  1d 17 58 00  ST64             *(s29 +0x58) = s23
0004  +0x00060  op=25  1d 16 50 00  ST64             *(s29 +0x50) = s22
0005  +0x00078  op=25  1d 15 48 00  ST64             *(s29 +0x48) = s21
0006  +0x00090  op=25  1d 14 40 00  ST64             *(s29 +0x40) = s20
0007  +0x000a8  op=25  1d 13 38 00  ST64             *(s29 +0x38) = s19
0008  +0x000c0  op=25  1d 12 30 00  ST64             *(s29 +0x30) = s18
0009  +0x000d8  op=25  1d 11 28 00  ST64             *(s29 +0x28) = s17
000a  +0x000f0  op=25  1d 10 20 00  ST64             *(s29 +0x20) = s16
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000c  +0x00120  op=25  1e 04 08 00  ST64             *(s30 +0x8) = s4
000d  +0x00138  op=85  04 02 01 00  ADD64_IMM16      s2 = s4 +0x1
000e  +0x00150  op=85  00 03 00 00  ADD64_IMM16      s3 = s0 +0x0
000f  +0x00168  op=85  00 04 10 00  ADD64_IMM16      s4 = s0 +0x10
0010  +0x00180  op=85  1e 16 10 00  ADD64_IMM16      s22 = s30 +0x10
0011  +0x00198  op=ae  03 04 0c 00  BR_EQ64          if (s3 == s4) goto record +30
0012  +0x001b0  op=84  02 03 05 04  ADD64            s5 = s2 + s3
0013  +0x001c8  op=84  16 03 01 14  ADD64            s1 = s22 + s3
0014  +0x001e0  op=85  03 03 04 00  ADD64_IMM16      s3 = s3 +0x4
0015  +0x001f8  op=59  05 06 ff ff  LD8U             s6 = *(uint8_t *)(s5 -0x1)
0016  +0x00210  op=26  01 06 03 00  ST8              *(s1 +0x3) = (uint8_t)s6
0017  +0x00228  op=59  05 06 00 00  LD8U             s6 = *(uint8_t *)(s5 +0x0)
0018  +0x00240  op=26  01 06 00 00  ST8              *(s1 +0x0) = (uint8_t)s6
0019  +0x00258  op=59  05 06 01 00  LD8U             s6 = *(uint8_t *)(s5 +0x1)
001a  +0x00270  op=26  01 06 02 00  ST8              *(s1 +0x2) = (uint8_t)s6
001b  +0x00288  op=59  05 05 02 00  LD8U             s5 = *(uint8_t *)(s5 +0x2)
001c  +0x002a0  op=26  01 05 01 00  ST8              *(s1 +0x1) = (uint8_t)s5
001d  +0x002b8  op=a7  03 04 f4 ff  BR_NE64          if (s3 != s4) goto record +18
001e  +0x002d0  op=85  00 11 00 00  ADD64_IMM16      s17 = s0 +0x0
001f  +0x002e8  op=85  00 17 04 00  ADD64_IMM16      s23 = s0 +0x4
0020  +0x00300  op=85  00 13 01 00  ADD64_IMM16      s19 = s0 +0x1
0021  +0x00318  op=ae  11 17 18 00  BR_EQ64          if (s17 == s23) goto record +58
0022  +0x00330  op=84  16 11 12 00  ADD64            s18 = s22 + s17
0023  +0x00348  op=85  00 04 02 00  ADD64_IMM16      s4 = s0 +0x2
0024  +0x00360  op=5a  12 05 00 00  LD8S             s5 = *(int8_t *)(s18 +0x0)
0025  +0x00378  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0026  +0x00390  op=5a  12 05 04 00  LD8S             s5 = *(int8_t *)(s18 +0x4)
0027  +0x003a8  op=85  00 04 03 00  ADD64_IMM16      s4 = s0 +0x3
0028  +0x003c0  op=34  02 00 14 00  OR64             s20 = s2 | s0
0029  +0x003d8  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
002a  +0x003f0  op=5a  12 05 08 00  LD8S             s5 = *(int8_t *)(s18 +0x8)
002b  +0x00408  op=34  13 00 04 01  OR64             s4 = s19 | s0
002c  +0x00420  op=34  02 00 15 01  OR64             s21 = s2 | s0
002d  +0x00438  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
002e  +0x00450  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
002f  +0x00468  op=5a  12 05 0c 00  LD8S             s5 = *(int8_t *)(s18 +0xc)
0030  +0x00480  op=85  11 10 01 00  ADD64_IMM16      s16 = s17 +0x1
0031  +0x00498  op=34  13 00 04 00  OR64             s4 = s19 | s0
0032  +0x004b0  op=84  01 11 11 00  ADD64            s17 = s1 + s17
0033  +0x004c8  op=02  15 14 01 00  XOR64            s1 = s20 ^ s21
0034  +0x004e0  op=02  01 02 14 01  XOR64            s20 = s2 ^ s1
0035  +0x004f8  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0036  +0x00510  op=02  14 02 01 01  XOR64            s1 = s2 ^ s20
0037  +0x00528  op=26  11 01 00 00  ST8              *(s17 +0x0) = (uint8_t)s1
0038  +0x00540  op=34  10 00 11 01  OR64             s17 = s16 | s0
0039  +0x00558  op=a7  11 17 e8 ff  BR_NE64          if (s17 != s23) goto record +34
003a  +0x00570  op=85  00 11 01 00  ADD64_IMM16      s17 = s0 +0x1
003b  +0x00588  op=85  00 13 03 00  ADD64_IMM16      s19 = s0 +0x3
003c  +0x005a0  op=85  00 01 08 00  ADD64_IMM16      s1 = s0 +0x8
003d  +0x005b8  op=ae  17 01 18 00  BR_EQ64          if (s23 == s1) goto record +86
003e  +0x005d0  op=84  16 17 10 00  ADD64            s16 = s22 + s23
003f  +0x005e8  op=34  11 00 04 00  OR64             s4 = s17 | s0
0040  +0x00600  op=5a  10 05 fc ff  LD8S             s5 = *(int8_t *)(s16 -0x4)
0041  +0x00618  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0042  +0x00630  op=5a  10 05 00 00  LD8S             s5 = *(int8_t *)(s16 +0x0)
0043  +0x00648  op=85  00 04 02 00  ADD64_IMM16      s4 = s0 +0x2
0044  +0x00660  op=34  02 00 14 01  OR64             s20 = s2 | s0
0045  +0x00678  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0046  +0x00690  op=5a  10 05 04 00  LD8S             s5 = *(int8_t *)(s16 +0x4)
0047  +0x006a8  op=34  13 00 04 00  OR64             s4 = s19 | s0
0048  +0x006c0  op=34  02 00 15 01  OR64             s21 = s2 | s0
0049  +0x006d8  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
004a  +0x006f0  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
004b  +0x00708  op=5a  10 05 08 00  LD8S             s5 = *(int8_t *)(s16 +0x8)
004c  +0x00720  op=85  17 12 01 00  ADD64_IMM16      s18 = s23 +0x1
004d  +0x00738  op=34  11 00 04 01  OR64             s4 = s17 | s0
004e  +0x00750  op=84  01 17 17 14  ADD64            s23 = s1 + s23
004f  +0x00768  op=02  15 14 01 01  XOR64            s1 = s20 ^ s21
0050  +0x00780  op=02  01 02 14 01  XOR64            s20 = s2 ^ s1
0051  +0x00798  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0052  +0x007b0  op=02  14 02 01 00  XOR64            s1 = s2 ^ s20
0053  +0x007c8  op=26  17 01 00 00  ST8              *(s23 +0x0) = (uint8_t)s1
0054  +0x007e0  op=34  12 00 17 01  OR64             s23 = s18 | s0
0055  +0x007f8  op=5f  e6 ff ff ff  ADD_PC_IMM32     goto record +60 ; vm_pc = current_pc + 1 + -26
0056  +0x00810  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
0057  +0x00828  op=85  00 12 00 00  ADD64_IMM16      s18 = s0 +0x0
0058  +0x00840  op=85  00 15 04 00  ADD64_IMM16      s21 = s0 +0x4
0059  +0x00858  op=85  00 11 01 00  ADD64_IMM16      s17 = s0 +0x1
005a  +0x00870  op=85  01 17 08 00  ADD64_IMM16      s23 = s1 +0x8
005b  +0x00888  op=ae  12 15 16 00  BR_EQ64          if (s18 == s21) goto record +114
005c  +0x008a0  op=84  16 12 10 04  ADD64            s16 = s22 + s18
005d  +0x008b8  op=34  11 00 04 00  OR64             s4 = s17 | s0
005e  +0x008d0  op=5a  10 05 00 00  LD8S             s5 = *(int8_t *)(s16 +0x0)
005f  +0x008e8  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0060  +0x00900  op=5a  10 05 04 00  LD8S             s5 = *(int8_t *)(s16 +0x4)
0061  +0x00918  op=34  11 00 04 01  OR64             s4 = s17 | s0
0062  +0x00930  op=34  02 00 14 01  OR64             s20 = s2 | s0
0063  +0x00948  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0064  +0x00960  op=5a  10 05 08 00  LD8S             s5 = *(int8_t *)(s16 +0x8)
0065  +0x00978  op=85  00 04 02 00  ADD64_IMM16      s4 = s0 +0x2
0066  +0x00990  op=85  12 13 01 00  ADD64_IMM16      s19 = s18 +0x1
0067  +0x009a8  op=84  17 12 12 14  ADD64            s18 = s23 + s18
0068  +0x009c0  op=02  02 14 14 01  XOR64            s20 = s20 ^ s2
0069  +0x009d8  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
006a  +0x009f0  op=5a  10 05 0c 00  LD8S             s5 = *(int8_t *)(s16 +0xc)
006b  +0x00a08  op=85  00 04 03 00  ADD64_IMM16      s4 = s0 +0x3
006c  +0x00a20  op=02  14 02 14 01  XOR64            s20 = s2 ^ s20
006d  +0x00a38  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
006e  +0x00a50  op=02  14 02 01 00  XOR64            s1 = s2 ^ s20
006f  +0x00a68  op=26  12 01 00 00  ST8              *(s18 +0x0) = (uint8_t)s1
0070  +0x00a80  op=34  13 00 12 01  OR64             s18 = s19 | s0
0071  +0x00a98  op=a7  12 15 ea ff  BR_NE64          if (s18 != s21) goto record +92
0072  +0x00ab0  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
0073  +0x00ac8  op=85  00 17 00 00  ADD64_IMM16      s23 = s0 +0x0
0074  +0x00ae0  op=85  00 11 01 00  ADD64_IMM16      s17 = s0 +0x1
0075  +0x00af8  op=85  01 14 0c 00  ADD64_IMM16      s20 = s1 +0xc
0076  +0x00b10  op=ae  17 15 16 00  BR_EQ64          if (s23 == s21) goto record +141
0077  +0x00b28  op=84  16 17 10 00  ADD64            s16 = s22 + s23
0078  +0x00b40  op=85  00 04 03 00  ADD64_IMM16      s4 = s0 +0x3
0079  +0x00b58  op=5a  10 05 00 00  LD8S             s5 = *(int8_t *)(s16 +0x0)
007a  +0x00b70  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
007b  +0x00b88  op=5a  10 05 04 00  LD8S             s5 = *(int8_t *)(s16 +0x4)
007c  +0x00ba0  op=34  11 00 04 00  OR64             s4 = s17 | s0
007d  +0x00bb8  op=34  02 00 13 01  OR64             s19 = s2 | s0
007e  +0x00bd0  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
007f  +0x00be8  op=5a  10 05 08 00  LD8S             s5 = *(int8_t *)(s16 +0x8)
0080  +0x00c00  op=34  11 00 04 00  OR64             s4 = s17 | s0
0081  +0x00c18  op=85  17 12 01 00  ADD64_IMM16      s18 = s23 +0x1
0082  +0x00c30  op=84  14 17 17 00  ADD64            s23 = s20 + s23
0083  +0x00c48  op=02  02 13 13 01  XOR64            s19 = s19 ^ s2
0084  +0x00c60  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0085  +0x00c78  op=5a  10 05 0c 00  LD8S             s5 = *(int8_t *)(s16 +0xc)
0086  +0x00c90  op=85  00 04 02 00  ADD64_IMM16      s4 = s0 +0x2
0087  +0x00ca8  op=02  13 02 13 01  XOR64            s19 = s2 ^ s19
0088  +0x00cc0  op=5e  8b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0089  +0x00cd8  op=02  13 02 01 01  XOR64            s1 = s2 ^ s19
008a  +0x00cf0  op=26  17 01 00 00  ST8              *(s23 +0x0) = (uint8_t)s1
008b  +0x00d08  op=34  12 00 17 01  OR64             s23 = s18 | s0
008c  +0x00d20  op=a7  17 15 ea ff  BR_NE64          if (s23 != s21) goto record +119
008d  +0x00d38  op=34  1e 00 1d 00  OR64             s29 = s30 | s0
008e  +0x00d50  op=58  1d 10 20 00  LD64             s16 = *(uint64_t *)(s29 +0x20)
008f  +0x00d68  op=58  1d 11 28 00  LD64             s17 = *(uint64_t *)(s29 +0x28)
0090  +0x00d80  op=58  1d 12 30 00  LD64             s18 = *(uint64_t *)(s29 +0x30)
0091  +0x00d98  op=58  1d 13 38 00  LD64             s19 = *(uint64_t *)(s29 +0x38)
0092  +0x00db0  op=58  1d 14 40 00  LD64             s20 = *(uint64_t *)(s29 +0x40)
0093  +0x00dc8  op=58  1d 15 48 00  LD64             s21 = *(uint64_t *)(s29 +0x48)
0094  +0x00de0  op=58  1d 16 50 00  LD64             s22 = *(uint64_t *)(s29 +0x50)
0095  +0x00df8  op=58  1d 17 58 00  LD64             s23 = *(uint64_t *)(s29 +0x58)
0096  +0x00e10  op=58  1d 1e 60 00  LD64             s30 = *(uint64_t *)(s29 +0x60)
0097  +0x00e28  op=58  1d 1f 68 00  LD64             s31 = *(uint64_t *)(s29 +0x68)
0098  +0x00e40  op=85  1d 1d 70 00  ADD64_IMM16      s29 = s29 +0x70
0099  +0x00e58  op=5b  1f 00 00 00  RET              return/leave with s31

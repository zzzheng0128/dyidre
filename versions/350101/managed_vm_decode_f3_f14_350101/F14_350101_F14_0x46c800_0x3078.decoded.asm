; MetaSec managed bytecode decode: F14
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F14_0x46c800_0x3078.bin
; records: 517  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d b0 fd  ADD64_IMM16      s29 = s29 -0x250
0001  +0x00018  op=25  1d 1f 48 02  ST64             *(s29 +0x248) = s31
0002  +0x00030  op=25  1d 1e 40 02  ST64             *(s29 +0x240) = s30
0003  +0x00048  op=25  1d 17 38 02  ST64             *(s29 +0x238) = s23
0004  +0x00060  op=25  1d 16 30 02  ST64             *(s29 +0x230) = s22
0005  +0x00078  op=25  1d 15 28 02  ST64             *(s29 +0x228) = s21
0006  +0x00090  op=25  1d 14 20 02  ST64             *(s29 +0x220) = s20
0007  +0x000a8  op=25  1d 13 18 02  ST64             *(s29 +0x218) = s19
0008  +0x000c0  op=25  1d 12 10 02  ST64             *(s29 +0x210) = s18
0009  +0x000d8  op=25  1d 11 08 02  ST64             *(s29 +0x208) = s17
000a  +0x000f0  op=25  1d 10 00 02  ST64             *(s29 +0x200) = s16
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000c  +0x00120  op=53  04 02 79 00  LD_POOL_PTR      s2 = *(uint64_t *)q1 + 0x79 ; q1=0x1235f648 rt/so-mapped
000d  +0x00138  op=53  04 01 08 03  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x308 ; q1=0x1235f648 rt/so-mapped
000e  +0x00150  op=53  01 05 85 00  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x85 ; q1=0x1235f648 rt/so-mapped
000f  +0x00168  op=85  1e 17 68 01  ADD64_IMM16      s23 = s30 +0x168
0010  +0x00180  op=b5  00 06 80 00  ADD32_IMM16      s6 = int32(s0 +0x80)
0011  +0x00198  op=59  02 03 02 00  LD8U             s3 = *(uint8_t *)(s2 +0x2)
0012  +0x001b0  op=55  02 02 00 00  LD16U            s2 = *(uint16_t *)(s2 +0x0)
0013  +0x001c8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0014  +0x001e0  op=26  1e 03 fe 01  ST8              *(s30 +0x1fe) = (uint8_t)s3
0015  +0x001f8  op=19  1e 02 fc 01  ST16             *(s30 +0x1fc) = (uint16_t)s2
0016  +0x00210  op=53  04 03 7c 00  LD_POOL_PTR      s3 = *(uint64_t *)q1 + 0x7c ; q1=0x1235f648 rt/so-mapped
0017  +0x00228  op=55  01 02 5c 01  LD16U            s2 = *(uint16_t *)(s1 +0x15c)
0018  +0x00240  op=59  01 01 5e 01  LD8U             s1 = *(uint8_t *)(s1 +0x15e)
0019  +0x00258  op=26  1e 01 fa 01  ST8              *(s30 +0x1fa) = (uint8_t)s1
001a  +0x00270  op=58  03 01 00 00  LD64             s1 = *(uint64_t *)(s3 +0x0)
001b  +0x00288  op=19  1e 02 f8 01  ST16             *(s30 +0x1f8) = (uint16_t)s2
001c  +0x002a0  op=59  03 02 08 00  LD8U             s2 = *(uint8_t *)(s3 +0x8)
001d  +0x002b8  op=53  04 03 90 00  LD_POOL_PTR      s3 = *(uint64_t *)q1 + 0x90 ; q1=0x1235f648 rt/so-mapped
001e  +0x002d0  op=25  1e 01 e8 01  ST64             *(s30 +0x1e8) = s1
001f  +0x002e8  op=52  05 01 07 00  LD32S            s1 = *(int32_t *)(s5 +0x7)
0020  +0x00300  op=26  1e 02 f0 01  ST8              *(s30 +0x1f0) = (uint8_t)s2
0021  +0x00318  op=08  1e 01 df 01  ST32             *(s30 +0x1df) = (uint32_t)s1
0022  +0x00330  op=58  05 01 00 00  LD64             s1 = *(uint64_t *)(s5 +0x0)
0023  +0x00348  op=25  1e 01 d8 01  ST64             *(s30 +0x1d8) = s1
0024  +0x00360  op=59  03 01 08 00  LD8U             s1 = *(uint8_t *)(s3 +0x8)
0025  +0x00378  op=26  1e 01 d0 01  ST8              *(s30 +0x1d0) = (uint8_t)s1
0026  +0x00390  op=58  03 01 00 00  LD64             s1 = *(uint64_t *)(s3 +0x0)
0027  +0x003a8  op=25  1e 01 c8 01  ST64             *(s30 +0x1c8) = s1
0028  +0x003c0  op=58  04 01 28 00  LD64             s1 = *(uint64_t *)(s4 +0x28)
0029  +0x003d8  op=58  04 15 10 00  LD64             s21 = *(uint64_t *)(s4 +0x10)
002a  +0x003f0  op=58  04 14 18 00  LD64             s20 = *(uint64_t *)(s4 +0x18)
002b  +0x00408  op=58  04 12 20 00  LD64             s18 = *(uint64_t *)(s4 +0x20)
002c  +0x00420  op=58  04 16 08 00  LD64             s22 = *(uint64_t *)(s4 +0x8)
002d  +0x00438  op=25  1e 01 08 00  ST64             *(s30 +0x8) = s1
002e  +0x00450  op=58  04 01 30 00  LD64             s1 = *(uint64_t *)(s4 +0x30)
002f  +0x00468  op=25  1e 01 10 00  ST64             *(s30 +0x10) = s1
0030  +0x00480  op=58  04 01 38 00  LD64             s1 = *(uint64_t *)(s4 +0x38)
0031  +0x00498  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1
0032  +0x004b0  op=58  04 01 00 00  LD64             s1 = *(uint64_t *)(s4 +0x0)
0033  +0x004c8  op=34  17 00 04 01  OR64             s4 = s23 | s0
0034  +0x004e0  op=26  1e 06 c4 01  ST8              *(s30 +0x1c4) = (uint8_t)s6
0035  +0x004f8  op=85  01 13 a0 00  ADD64_IMM16      s19 = s1 +0xa0
0036  +0x00510  op=34  13 00 05 00  OR64             s5 = s19 | s0
0037  +0x00528  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x1235f600 rt/so-mapped
0038  +0x00540  op=58  1e 05 68 01  LD64             s5 = *(uint64_t *)(s30 +0x168)
0039  +0x00558  op=85  1e 04 b0 01  ADD64_IMM16      s4 = s30 +0x1b0
003a  +0x00570  op=5e  12 00 00 00  CALL_CF_INDEX    call native_binding[index=0x12] via q1 table ; q1=0x1235f600 rt/so-mapped
003b  +0x00588  op=34  17 00 04 01  OR64             s4 = s23 | s0
003c  +0x005a0  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x1235f600 rt/so-mapped
003d  +0x005b8  op=34  16 00 04 00  OR64             s4 = s22 | s0
003e  +0x005d0  op=25  1e 00 a8 01  ST64             *(s30 +0x1a8) = s0
003f  +0x005e8  op=25  1e 00 a0 01  ST64             *(s30 +0x1a0) = s0
0040  +0x00600  op=5e  1a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1a] via q1 table ; q1=0x1235f600 rt/so-mapped
0041  +0x00618  op=18  11 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0)
0042  +0x00630  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
0043  +0x00648  op=ae  01 00 12 00  BR_EQ64          if (s1 == s0) goto record +86
0044  +0x00660  op=85  00 04 18 00  ADD64_IMM16      s4 = s0 +0x18
0045  +0x00678  op=5e  47 00 00 00  CALL_CF_INDEX    call native_binding[index=0x47] via q1 table ; q1=0x1235f600 rt/so-mapped
0046  +0x00690  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
0047  +0x006a8  op=85  00 06 10 00  ADD64_IMM16      s6 = s0 +0x10
0048  +0x006c0  op=34  02 00 04 00  OR64             s4 = s2 | s0
0049  +0x006d8  op=34  02 00 16 01  OR64             s22 = s2 | s0
004a  +0x006f0  op=5e  1e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1e] via q1 table ; q1=0x1235f600 rt/so-mapped
004b  +0x00708  op=85  1e 04 a0 01  ADD64_IMM16      s4 = s30 +0x1a0
004c  +0x00720  op=34  16 00 05 01  OR64             s5 = s22 | s0
004d  +0x00738  op=5e  5e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5e] via q1 table ; q1=0x1235f600 rt/so-mapped
004e  +0x00750  op=58  1e 03 a0 01  LD64             s3 = *(uint64_t *)(s30 +0x1a0)
004f  +0x00768  op=b5  00 02 45 00  ADD32_IMM16      s2 = int32(s0 +0x45)
0050  +0x00780  op=b5  00 01 3f 00  ADD32_IMM16      s1 = int32(s0 +0x3f)
0051  +0x00798  op=58  03 04 10 00  LD64             s4 = *(uint64_t *)(s3 +0x10)
0052  +0x007b0  op=26  04 02 0e 00  ST8              *(s4 +0xe) = (uint8_t)s2
0053  +0x007c8  op=58  03 02 10 00  LD64             s2 = *(uint64_t *)(s3 +0x10)
0054  +0x007e0  op=26  02 01 0f 00  ST8              *(s2 +0xf) = (uint8_t)s1
0055  +0x007f8  op=5f  0a 00 00 00  ADD_PC_IMM32     goto record +96 ; vm_pc = current_pc + 1 + 10
0056  +0x00810  op=85  1e 17 68 01  ADD64_IMM16      s23 = s30 +0x168
0057  +0x00828  op=85  00 06 00 00  ADD64_IMM16      s6 = s0 +0x0
0058  +0x00840  op=34  16 00 05 01  OR64             s5 = s22 | s0
0059  +0x00858  op=34  17 00 04 01  OR64             s4 = s23 | s0
005a  +0x00870  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x1235f600 rt/so-mapped
005b  +0x00888  op=85  1e 04 a0 01  ADD64_IMM16      s4 = s30 +0x1a0
005c  +0x008a0  op=34  17 00 05 01  OR64             s5 = s23 | s0
005d  +0x008b8  op=5e  27 00 00 00  CALL_CF_INDEX    call native_binding[index=0x27] via q1 table ; q1=0x1235f600 rt/so-mapped
005e  +0x008d0  op=34  17 00 04 01  OR64             s4 = s23 | s0
005f  +0x008e8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
0060  +0x00900  op=34  15 00 04 01  OR64             s4 = s21 | s0
0061  +0x00918  op=25  1e 00 98 01  ST64             *(s30 +0x198) = s0
0062  +0x00930  op=25  1e 00 90 01  ST64             *(s30 +0x190) = s0
0063  +0x00948  op=5e  1a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1a] via q1 table ; q1=0x1235f600 rt/so-mapped
0064  +0x00960  op=18  00 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0)
0065  +0x00978  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
0066  +0x00990  op=ae  01 00 12 00  BR_EQ64          if (s1 == s0) goto record +121
0067  +0x009a8  op=85  00 04 18 00  ADD64_IMM16      s4 = s0 +0x18
0068  +0x009c0  op=5e  47 00 00 00  CALL_CF_INDEX    call native_binding[index=0x47] via q1 table ; q1=0x1235f600 rt/so-mapped
0069  +0x009d8  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
006a  +0x009f0  op=85  00 06 10 00  ADD64_IMM16      s6 = s0 +0x10
006b  +0x00a08  op=34  02 00 04 01  OR64             s4 = s2 | s0
006c  +0x00a20  op=34  02 00 15 01  OR64             s21 = s2 | s0
006d  +0x00a38  op=5e  1e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1e] via q1 table ; q1=0x1235f600 rt/so-mapped
006e  +0x00a50  op=85  1e 04 90 01  ADD64_IMM16      s4 = s30 +0x190
006f  +0x00a68  op=34  15 00 05 01  OR64             s5 = s21 | s0
0070  +0x00a80  op=5e  5e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5e] via q1 table ; q1=0x1235f600 rt/so-mapped
0071  +0x00a98  op=58  1e 03 90 01  LD64             s3 = *(uint64_t *)(s30 +0x190)
0072  +0x00ab0  op=b5  00 02 45 00  ADD32_IMM16      s2 = int32(s0 +0x45)
0073  +0x00ac8  op=b5  00 01 3f 00  ADD32_IMM16      s1 = int32(s0 +0x3f)
0074  +0x00ae0  op=58  03 04 10 00  LD64             s4 = *(uint64_t *)(s3 +0x10)
0075  +0x00af8  op=26  04 02 0e 00  ST8              *(s4 +0xe) = (uint8_t)s2
0076  +0x00b10  op=58  03 02 10 00  LD64             s2 = *(uint64_t *)(s3 +0x10)
0077  +0x00b28  op=26  02 01 0f 00  ST8              *(s2 +0xf) = (uint8_t)s1
0078  +0x00b40  op=5f  37 00 00 00  ADD_PC_IMM32     goto record +176 ; vm_pc = current_pc + 1 + 55
0079  +0x00b58  op=85  00 04 18 00  ADD64_IMM16      s4 = s0 +0x18
007a  +0x00b70  op=5e  47 00 00 00  CALL_CF_INDEX    call native_binding[index=0x47] via q1 table ; q1=0x1235f600 rt/so-mapped
007b  +0x00b88  op=34  02 00 04 01  OR64             s4 = s2 | s0
007c  +0x00ba0  op=34  02 00 16 00  OR64             s22 = s2 | s0
007d  +0x00bb8  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x1235f600 rt/so-mapped
007e  +0x00bd0  op=85  1e 04 68 01  ADD64_IMM16      s4 = s30 +0x168
007f  +0x00be8  op=34  16 00 05 01  OR64             s5 = s22 | s0
0080  +0x00c00  op=5e  48 00 00 00  CALL_CF_INDEX    call native_binding[index=0x48] via q1 table ; q1=0x1235f600 rt/so-mapped
0081  +0x00c18  op=58  1e 04 68 01  LD64             s4 = *(uint64_t *)(s30 +0x168)
0082  +0x00c30  op=85  00 05 10 00  ADD64_IMM16      s5 = s0 +0x10
0083  +0x00c48  op=5e  5f 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5f] via q1 table ; q1=0x1235f600 rt/so-mapped
0084  +0x00c60  op=b5  00 10 00 00  ADD32_IMM16      s16 = int32(s0 +0x0)
0085  +0x00c78  op=85  00 11 00 00  ADD64_IMM16      s17 = s0 +0x0
0086  +0x00c90  op=34  10 00 02 01  OR64             s2 = s16 | s0
0087  +0x00ca8  op=14  11 01 20 00  CMP_LO_IMM64     s1 = ((uint64_t)s17 < (uint64_t)32) ? 1 : 0
0088  +0x00cc0  op=ae  01 00 1b 00  BR_EQ64          if (s1 == s0) goto record +164
0089  +0x00cd8  op=52  15 01 0c 00  LD32S            s1 = *(int32_t *)(s21 +0xc)
008a  +0x00cf0  op=16  11 01 01 00  CMP_LT64S        s1 = ((int64_t)s17 < (int64_t)s1) ? 1 : 0
008b  +0x00d08  op=ae  01 00 18 00  BR_EQ64          if (s1 == s0) goto record +164
008c  +0x00d20  op=58  15 01 10 00  LD64             s1 = *(uint64_t *)(s21 +0x10)
008d  +0x00d38  op=84  01 11 01 14  ADD64            s1 = s1 + s17
008e  +0x00d50  op=59  01 04 00 00  LD8U             s4 = *(uint8_t *)(s1 +0x0)
008f  +0x00d68  op=b5  04 03 d0 ff  ADD32_IMM16      s3 = int32(s4 -0x30)
0090  +0x00d80  op=b2  03 01 ff 00  AND64_IMM16      s1 = s3 & 0xff
0091  +0x00d98  op=14  01 01 0a 00  CMP_LO_IMM64     s1 = ((uint64_t)s1 < (uint64_t)10) ? 1 : 0
0092  +0x00db0  op=a7  01 00 07 00  BR_NE64          if (s1 != s0) goto record +154
0093  +0x00dc8  op=b5  04 03 9f ff  ADD32_IMM16      s3 = int32(s4 -0x61)
0094  +0x00de0  op=b5  04 01 a9 ff  ADD32_IMM16      s1 = int32(s4 -0x57)
0095  +0x00df8  op=b2  03 03 ff 00  AND64_IMM16      s3 = s3 & 0xff
0096  +0x00e10  op=14  03 03 06 00  CMP_LO_IMM64     s3 = ((uint64_t)s3 < (uint64_t)6) ? 1 : 0
0097  +0x00e28  op=1e  01 03 01 11  CMOVNZ64         s1 = (s3 != 0) ? s1 : 0
0098  +0x00e40  op=1f  00 03 03 00  CMOVZ64          s3 = (s3 == 0) ? s0 : 0
0099  +0x00e58  op=34  03 01 03 01  OR64             s3 = s3 | s1
009a  +0x00e70  op=b2  11 01 01 00  AND64_IMM16      s1 = s17 & 0x1
009b  +0x00e88  op=a7  01 00 02 00  BR_NE64          if (s1 != s0) goto record +158
009c  +0x00ea0  op=18  11 03 02 04  SHL32_IMM        s2 = (int32_t)(s3 << 4)
009d  +0x00eb8  op=5f  04 00 00 00  ADD_PC_IMM32     goto record +162 ; vm_pc = current_pc + 1 + 4
009e  +0x00ed0  op=58  1e 04 68 01  LD64             s4 = *(uint64_t *)(s30 +0x168)
009f  +0x00ee8  op=b4  03 02 05 00  ADD32            s5 = int32(s3 + s2)
00a0  +0x00f00  op=5e  60 00 00 00  CALL_CF_INDEX    call native_binding[index=0x60] via q1 table ; q1=0x1235f600 rt/so-mapped
00a1  +0x00f18  op=34  10 00 02 00  OR64             s2 = s16 | s0
00a2  +0x00f30  op=85  11 11 01 00  ADD64_IMM16      s17 = s17 +0x1
00a3  +0x00f48  op=5f  e3 ff ff ff  ADD_PC_IMM32     goto record +135 ; vm_pc = current_pc + 1 + -29
00a4  +0x00f60  op=85  1e 15 50 01  ADD64_IMM16      s21 = s30 +0x150
00a5  +0x00f78  op=58  1e 05 68 01  LD64             s5 = *(uint64_t *)(s30 +0x168)
00a6  +0x00f90  op=85  00 06 00 00  ADD64_IMM16      s6 = s0 +0x0
00a7  +0x00fa8  op=34  15 00 04 01  OR64             s4 = s21 | s0
00a8  +0x00fc0  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x1235f600 rt/so-mapped
00a9  +0x00fd8  op=85  1e 04 90 01  ADD64_IMM16      s4 = s30 +0x190
00aa  +0x00ff0  op=34  15 00 05 01  OR64             s5 = s21 | s0
00ab  +0x01008  op=5e  27 00 00 00  CALL_CF_INDEX    call native_binding[index=0x27] via q1 table ; q1=0x1235f600 rt/so-mapped
00ac  +0x01020  op=34  15 00 04 00  OR64             s4 = s21 | s0
00ad  +0x01038  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
00ae  +0x01050  op=85  1e 04 68 01  ADD64_IMM16      s4 = s30 +0x168
00af  +0x01068  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
00b0  +0x01080  op=34  14 00 04 00  OR64             s4 = s20 | s0
00b1  +0x01098  op=25  1e 00 88 01  ST64             *(s30 +0x188) = s0
00b2  +0x010b0  op=25  1e 00 80 01  ST64             *(s30 +0x180) = s0
00b3  +0x010c8  op=5e  1a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1a] via q1 table ; q1=0x1235f600 rt/so-mapped
00b4  +0x010e0  op=18  11 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0)
00b5  +0x010f8  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
00b6  +0x01110  op=ae  01 00 12 00  BR_EQ64          if (s1 == s0) goto record +201
00b7  +0x01128  op=85  00 04 18 00  ADD64_IMM16      s4 = s0 +0x18
00b8  +0x01140  op=5e  47 00 00 00  CALL_CF_INDEX    call native_binding[index=0x47] via q1 table ; q1=0x1235f600 rt/so-mapped
00b9  +0x01158  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
00ba  +0x01170  op=85  00 06 10 00  ADD64_IMM16      s6 = s0 +0x10
00bb  +0x01188  op=34  02 00 04 00  OR64             s4 = s2 | s0
00bc  +0x011a0  op=34  02 00 14 01  OR64             s20 = s2 | s0
00bd  +0x011b8  op=5e  1e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1e] via q1 table ; q1=0x1235f600 rt/so-mapped
00be  +0x011d0  op=85  1e 04 80 01  ADD64_IMM16      s4 = s30 +0x180
00bf  +0x011e8  op=34  14 00 05 00  OR64             s5 = s20 | s0
00c0  +0x01200  op=5e  5e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5e] via q1 table ; q1=0x1235f600 rt/so-mapped
00c1  +0x01218  op=58  1e 03 80 01  LD64             s3 = *(uint64_t *)(s30 +0x180)
00c2  +0x01230  op=b5  00 02 45 00  ADD32_IMM16      s2 = int32(s0 +0x45)
00c3  +0x01248  op=b5  00 01 3f 00  ADD32_IMM16      s1 = int32(s0 +0x3f)
00c4  +0x01260  op=58  03 04 10 00  LD64             s4 = *(uint64_t *)(s3 +0x10)
00c5  +0x01278  op=26  04 02 0e 00  ST8              *(s4 +0xe) = (uint8_t)s2
00c6  +0x01290  op=58  03 02 10 00  LD64             s2 = *(uint64_t *)(s3 +0x10)
00c7  +0x012a8  op=26  02 01 0f 00  ST8              *(s2 +0xf) = (uint8_t)s1
00c8  +0x012c0  op=5f  0a 00 00 00  ADD_PC_IMM32     goto record +211 ; vm_pc = current_pc + 1 + 10
00c9  +0x012d8  op=85  1e 15 68 01  ADD64_IMM16      s21 = s30 +0x168
00ca  +0x012f0  op=85  00 06 00 00  ADD64_IMM16      s6 = s0 +0x0
00cb  +0x01308  op=34  14 00 05 01  OR64             s5 = s20 | s0
00cc  +0x01320  op=34  15 00 04 01  OR64             s4 = s21 | s0
00cd  +0x01338  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x1235f600 rt/so-mapped
00ce  +0x01350  op=85  1e 04 80 01  ADD64_IMM16      s4 = s30 +0x180
00cf  +0x01368  op=34  15 00 05 00  OR64             s5 = s21 | s0
00d0  +0x01380  op=5e  27 00 00 00  CALL_CF_INDEX    call native_binding[index=0x27] via q1 table ; q1=0x1235f600 rt/so-mapped
00d1  +0x01398  op=34  15 00 04 00  OR64             s4 = s21 | s0
00d2  +0x013b0  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
00d3  +0x013c8  op=85  1e 14 00 01  ADD64_IMM16      s20 = s30 +0x100
00d4  +0x013e0  op=34  13 00 05 01  OR64             s5 = s19 | s0
00d5  +0x013f8  op=34  14 00 04 00  OR64             s4 = s20 | s0
00d6  +0x01410  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x1235f600 rt/so-mapped
00d7  +0x01428  op=58  1e 15 00 01  LD64             s21 = *(uint64_t *)(s30 +0x100)
00d8  +0x01440  op=85  1e 04 c8 01  ADD64_IMM16      s4 = s30 +0x1c8
00d9  +0x01458  op=85  00 05 09 00  ADD64_IMM16      s5 = s0 +0x9
00da  +0x01470  op=5e  2c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2c] via q1 table ; q1=0x1235f600 rt/so-mapped
00db  +0x01488  op=85  1e 16 50 01  ADD64_IMM16      s22 = s30 +0x150
00dc  +0x014a0  op=34  02 00 05 01  OR64             s5 = s2 | s0
00dd  +0x014b8  op=34  16 00 04 01  OR64             s4 = s22 | s0
00de  +0x014d0  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x1235f600 rt/so-mapped
00df  +0x014e8  op=85  1e 17 20 01  ADD64_IMM16      s23 = s30 +0x120
00e0  +0x01500  op=34  15 00 05 01  OR64             s5 = s21 | s0
00e1  +0x01518  op=34  16 00 06 01  OR64             s6 = s22 | s0
00e2  +0x01530  op=34  17 00 04 01  OR64             s4 = s23 | s0
00e3  +0x01548  op=5e  21 00 00 00  CALL_CF_INDEX    call native_binding[index=0x21] via q1 table ; q1=0x1235f600 rt/so-mapped
00e4  +0x01560  op=85  1e 15 38 01  ADD64_IMM16      s21 = s30 +0x138
00e5  +0x01578  op=58  1e 05 20 01  LD64             s5 = *(uint64_t *)(s30 +0x120)
00e6  +0x01590  op=34  15 00 04 01  OR64             s4 = s21 | s0
00e7  +0x015a8  op=5e  22 00 00 00  CALL_CF_INDEX    call native_binding[index=0x22] via q1 table ; q1=0x1235f600 rt/so-mapped
00e8  +0x015c0  op=58  1e 05 38 01  LD64             s5 = *(uint64_t *)(s30 +0x138)
00e9  +0x015d8  op=85  1e 04 68 01  ADD64_IMM16      s4 = s30 +0x168
00ea  +0x015f0  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x1235f600 rt/so-mapped
00eb  +0x01608  op=34  15 00 04 01  OR64             s4 = s21 | s0
00ec  +0x01620  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
00ed  +0x01638  op=34  17 00 04 01  OR64             s4 = s23 | s0
00ee  +0x01650  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
00ef  +0x01668  op=34  16 00 04 01  OR64             s4 = s22 | s0
00f0  +0x01680  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
00f1  +0x01698  op=34  14 00 04 01  OR64             s4 = s20 | s0
00f2  +0x016b0  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x1235f600 rt/so-mapped
00f3  +0x016c8  op=85  1e 15 e0 00  ADD64_IMM16      s21 = s30 +0xe0
00f4  +0x016e0  op=34  13 00 05 00  OR64             s5 = s19 | s0
00f5  +0x016f8  op=34  15 00 04 01  OR64             s4 = s21 | s0
00f6  +0x01710  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x1235f600 rt/so-mapped
00f7  +0x01728  op=85  1e 04 d8 01  ADD64_IMM16      s4 = s30 +0x1d8
00f8  +0x01740  op=85  00 05 0b 00  ADD64_IMM16      s5 = s0 +0xb
00f9  +0x01758  op=58  1e 13 e0 00  LD64             s19 = *(uint64_t *)(s30 +0xe0)
00fa  +0x01770  op=5e  2d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2d] via q1 table ; q1=0x1235f600 rt/so-mapped
00fb  +0x01788  op=85  1e 16 38 01  ADD64_IMM16      s22 = s30 +0x138
00fc  +0x017a0  op=34  02 00 05 00  OR64             s5 = s2 | s0
00fd  +0x017b8  op=34  16 00 04 01  OR64             s4 = s22 | s0
00fe  +0x017d0  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x1235f600 rt/so-mapped
00ff  +0x017e8  op=85  1e 17 00 01  ADD64_IMM16      s23 = s30 +0x100
0100  +0x01800  op=34  13 00 05 00  OR64             s5 = s19 | s0
0101  +0x01818  op=34  16 00 06 00  OR64             s6 = s22 | s0
0102  +0x01830  op=34  17 00 04 01  OR64             s4 = s23 | s0
0103  +0x01848  op=5e  21 00 00 00  CALL_CF_INDEX    call native_binding[index=0x21] via q1 table ; q1=0x1235f600 rt/so-mapped
0104  +0x01860  op=85  1e 13 20 01  ADD64_IMM16      s19 = s30 +0x120
0105  +0x01878  op=58  1e 05 00 01  LD64             s5 = *(uint64_t *)(s30 +0x100)
0106  +0x01890  op=34  13 00 04 00  OR64             s4 = s19 | s0
0107  +0x018a8  op=5e  22 00 00 00  CALL_CF_INDEX    call native_binding[index=0x22] via q1 table ; q1=0x1235f600 rt/so-mapped
0108  +0x018c0  op=85  1e 14 50 01  ADD64_IMM16      s20 = s30 +0x150
0109  +0x018d8  op=58  1e 05 20 01  LD64             s5 = *(uint64_t *)(s30 +0x120)
010a  +0x018f0  op=34  14 00 04 00  OR64             s4 = s20 | s0
010b  +0x01908  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x1235f600 rt/so-mapped
010c  +0x01920  op=34  13 00 04 01  OR64             s4 = s19 | s0
010d  +0x01938  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
010e  +0x01950  op=34  17 00 04 00  OR64             s4 = s23 | s0
010f  +0x01968  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
0110  +0x01980  op=34  16 00 04 01  OR64             s4 = s22 | s0
0111  +0x01998  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0112  +0x019b0  op=34  15 00 04 00  OR64             s4 = s21 | s0
0113  +0x019c8  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x1235f600 rt/so-mapped
0114  +0x019e0  op=85  1e 17 38 01  ADD64_IMM16      s23 = s30 +0x138
0115  +0x019f8  op=34  17 00 04 00  OR64             s4 = s23 | s0
0116  +0x01a10  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x1235f600 rt/so-mapped
0117  +0x01a28  op=85  1e 13 20 01  ADD64_IMM16      s19 = s30 +0x120
0118  +0x01a40  op=85  00 15 0e 00  ADD64_IMM16      s21 = s0 +0xe
0119  +0x01a58  op=85  00 16 02 00  ADD64_IMM16      s22 = s0 +0x2
011a  +0x01a70  op=58  1e 05 a0 01  LD64             s5 = *(uint64_t *)(s30 +0x1a0)
011b  +0x01a88  op=34  13 00 04 01  OR64             s4 = s19 | s0
011c  +0x01aa0  op=34  15 00 06 01  OR64             s6 = s21 | s0
011d  +0x01ab8  op=34  16 00 07 01  OR64             s7 = s22 | s0
011e  +0x01ad0  op=5e  53 00 00 00  CALL_CF_INDEX    call native_binding[index=0x53] via q1 table ; q1=0x1235f600 rt/so-mapped
011f  +0x01ae8  op=34  17 00 04 00  OR64             s4 = s23 | s0
0120  +0x01b00  op=34  13 00 05 01  OR64             s5 = s19 | s0
0121  +0x01b18  op=5e  33 00 00 00  CALL_CF_INDEX    call native_binding[index=0x33] via q1 table ; q1=0x1235f600 rt/so-mapped
0122  +0x01b30  op=34  13 00 04 00  OR64             s4 = s19 | s0
0123  +0x01b48  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0124  +0x01b60  op=85  1e 13 20 01  ADD64_IMM16      s19 = s30 +0x120
0125  +0x01b78  op=58  1e 05 90 01  LD64             s5 = *(uint64_t *)(s30 +0x190)
0126  +0x01b90  op=34  15 00 06 01  OR64             s6 = s21 | s0
0127  +0x01ba8  op=34  16 00 07 01  OR64             s7 = s22 | s0
0128  +0x01bc0  op=34  13 00 04 01  OR64             s4 = s19 | s0
0129  +0x01bd8  op=5e  53 00 00 00  CALL_CF_INDEX    call native_binding[index=0x53] via q1 table ; q1=0x1235f600 rt/so-mapped
012a  +0x01bf0  op=34  17 00 04 01  OR64             s4 = s23 | s0
012b  +0x01c08  op=34  13 00 05 01  OR64             s5 = s19 | s0
012c  +0x01c20  op=5e  33 00 00 00  CALL_CF_INDEX    call native_binding[index=0x33] via q1 table ; q1=0x1235f600 rt/so-mapped
012d  +0x01c38  op=34  13 00 04 01  OR64             s4 = s19 | s0
012e  +0x01c50  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
012f  +0x01c68  op=85  1e 13 20 01  ADD64_IMM16      s19 = s30 +0x120
0130  +0x01c80  op=58  1e 05 80 01  LD64             s5 = *(uint64_t *)(s30 +0x180)
0131  +0x01c98  op=34  15 00 06 01  OR64             s6 = s21 | s0
0132  +0x01cb0  op=34  16 00 07 01  OR64             s7 = s22 | s0
0133  +0x01cc8  op=34  13 00 04 01  OR64             s4 = s19 | s0
0134  +0x01ce0  op=5e  53 00 00 00  CALL_CF_INDEX    call native_binding[index=0x53] via q1 table ; q1=0x1235f600 rt/so-mapped
0135  +0x01cf8  op=34  17 00 04 00  OR64             s4 = s23 | s0
0136  +0x01d10  op=34  13 00 05 00  OR64             s5 = s19 | s0
0137  +0x01d28  op=5e  33 00 00 00  CALL_CF_INDEX    call native_binding[index=0x33] via q1 table ; q1=0x1235f600 rt/so-mapped
0138  +0x01d40  op=34  13 00 04 01  OR64             s4 = s19 | s0
0139  +0x01d58  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
013a  +0x01d70  op=85  1e 15 20 01  ADD64_IMM16      s21 = s30 +0x120
013b  +0x01d88  op=85  1e 05 c4 01  ADD64_IMM16      s5 = s30 +0x1c4
013c  +0x01da0  op=85  00 06 01 00  ADD64_IMM16      s6 = s0 +0x1
013d  +0x01db8  op=34  15 00 04 01  OR64             s4 = s21 | s0
013e  +0x01dd0  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x1235f600 rt/so-mapped
013f  +0x01de8  op=58  1e 01 b0 01  LD64             s1 = *(uint64_t *)(s30 +0x1b0)
0140  +0x01e00  op=85  00 13 00 00  ADD64_IMM16      s19 = s0 +0x0
0141  +0x01e18  op=34  13 00 05 01  OR64             s5 = s19 | s0
0142  +0x01e30  op=34  13 00 06 01  OR64             s6 = s19 | s0
0143  +0x01e48  op=58  01 04 10 00  LD64             s4 = *(uint64_t *)(s1 +0x10)
0144  +0x01e60  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x1235f600 rt/so-mapped
0145  +0x01e78  op=85  1e 16 00 01  ADD64_IMM16      s22 = s30 +0x100
0146  +0x01e90  op=85  00 10 04 00  ADD64_IMM16      s16 = s0 +0x4
0147  +0x01ea8  op=85  1e 05 1c 01  ADD64_IMM16      s5 = s30 +0x11c
0148  +0x01ec0  op=08  1e 02 1c 01  ST32             *(s30 +0x11c) = (uint32_t)s2
0149  +0x01ed8  op=34  16 00 04 00  OR64             s4 = s22 | s0
014a  +0x01ef0  op=34  10 00 06 01  OR64             s6 = s16 | s0
014b  +0x01f08  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x1235f600 rt/so-mapped
014c  +0x01f20  op=85  1e 11 c8 00  ADD64_IMM16      s17 = s30 +0xc8
014d  +0x01f38  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
014e  +0x01f50  op=34  12 00 05 01  OR64             s5 = s18 | s0
014f  +0x01f68  op=34  17 00 06 01  OR64             s6 = s23 | s0
0150  +0x01f80  op=34  11 00 04 01  OR64             s4 = s17 | s0
0151  +0x01f98  op=08  1e 01 fc 00  ST32             *(s30 +0xfc) = (uint32_t)s1
0152  +0x01fb0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
0153  +0x01fc8  op=85  1e 17 b0 00  ADD64_IMM16      s23 = s30 +0xb0
0154  +0x01fe0  op=85  1e 05 fc 00  ADD64_IMM16      s5 = s30 +0xfc
0155  +0x01ff8  op=34  10 00 06 01  OR64             s6 = s16 | s0
0156  +0x02010  op=34  17 00 04 00  OR64             s4 = s23 | s0
0157  +0x02028  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x1235f600 rt/so-mapped
0158  +0x02040  op=85  1e 12 e0 00  ADD64_IMM16      s18 = s30 +0xe0
0159  +0x02058  op=34  11 00 05 01  OR64             s5 = s17 | s0
015a  +0x02070  op=34  17 00 06 01  OR64             s6 = s23 | s0
015b  +0x02088  op=34  12 00 04 01  OR64             s4 = s18 | s0
015c  +0x020a0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
015d  +0x020b8  op=34  17 00 04 00  OR64             s4 = s23 | s0
015e  +0x020d0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
015f  +0x020e8  op=34  11 00 04 00  OR64             s4 = s17 | s0
0160  +0x02100  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0161  +0x02118  op=85  1e 10 b0 00  ADD64_IMM16      s16 = s30 +0xb0
0162  +0x02130  op=34  15 00 05 01  OR64             s5 = s21 | s0
0163  +0x02148  op=34  16 00 06 01  OR64             s6 = s22 | s0
0164  +0x02160  op=34  10 00 04 00  OR64             s4 = s16 | s0
0165  +0x02178  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
0166  +0x02190  op=85  1e 11 c8 00  ADD64_IMM16      s17 = s30 +0xc8
0167  +0x021a8  op=34  10 00 05 01  OR64             s5 = s16 | s0
0168  +0x021c0  op=34  14 00 06 00  OR64             s6 = s20 | s0
0169  +0x021d8  op=34  11 00 04 01  OR64             s4 = s17 | s0
016a  +0x021f0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
016b  +0x02208  op=34  10 00 04 00  OR64             s4 = s16 | s0
016c  +0x02220  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
016d  +0x02238  op=85  1e 10 98 00  ADD64_IMM16      s16 = s30 +0x98
016e  +0x02250  op=34  12 00 05 01  OR64             s5 = s18 | s0
016f  +0x02268  op=34  11 00 06 01  OR64             s6 = s17 | s0
0170  +0x02280  op=34  10 00 04 01  OR64             s4 = s16 | s0
0171  +0x02298  op=5e  62 00 00 00  CALL_CF_INDEX    call native_binding[index=0x62] via q1 table ; q1=0x1235f600 rt/so-mapped
0172  +0x022b0  op=85  1e 11 b0 00  ADD64_IMM16      s17 = s30 +0xb0
0173  +0x022c8  op=58  1e 05 98 00  LD64             s5 = *(uint64_t *)(s30 +0x98)
0174  +0x022e0  op=34  11 00 04 01  OR64             s4 = s17 | s0
0175  +0x022f8  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x1235f600 rt/so-mapped
0176  +0x02310  op=34  10 00 04 01  OR64             s4 = s16 | s0
0177  +0x02328  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
0178  +0x02340  op=85  1e 10 80 00  ADD64_IMM16      s16 = s30 +0x80
0179  +0x02358  op=34  15 00 05 01  OR64             s5 = s21 | s0
017a  +0x02370  op=34  16 00 06 01  OR64             s6 = s22 | s0
017b  +0x02388  op=34  10 00 04 00  OR64             s4 = s16 | s0
017c  +0x023a0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
017d  +0x023b8  op=85  1e 04 98 00  ADD64_IMM16      s4 = s30 +0x98
017e  +0x023d0  op=34  10 00 05 00  OR64             s5 = s16 | s0
017f  +0x023e8  op=34  11 00 06 00  OR64             s6 = s17 | s0
0180  +0x02400  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
0181  +0x02418  op=34  10 00 04 01  OR64             s4 = s16 | s0
0182  +0x02430  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0183  +0x02448  op=85  1e 10 60 00  ADD64_IMM16      s16 = s30 +0x60
0184  +0x02460  op=52  1e 14 a4 00  LD32S            s20 = *(int32_t *)(s30 +0xa4)
0185  +0x02478  op=34  15 00 05 00  OR64             s5 = s21 | s0
0186  +0x02490  op=34  16 00 06 00  OR64             s6 = s22 | s0
0187  +0x024a8  op=34  10 00 04 01  OR64             s4 = s16 | s0
0188  +0x024c0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
0189  +0x024d8  op=85  1e 11 80 00  ADD64_IMM16      s17 = s30 +0x80
018a  +0x024f0  op=34  10 00 05 01  OR64             s5 = s16 | s0
018b  +0x02508  op=34  12 00 06 01  OR64             s6 = s18 | s0
018c  +0x02520  op=34  11 00 04 01  OR64             s4 = s17 | s0
018d  +0x02538  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
018e  +0x02550  op=34  11 00 04 01  OR64             s4 = s17 | s0
018f  +0x02568  op=5e  63 00 00 00  CALL_CF_INDEX    call native_binding[index=0x63] via q1 table ; q1=0x1235f600 rt/so-mapped
0190  +0x02580  op=34  11 00 04 00  OR64             s4 = s17 | s0
0191  +0x02598  op=34  02 00 12 01  OR64             s18 = s2 | s0
0192  +0x025b0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0193  +0x025c8  op=34  10 00 04 00  OR64             s4 = s16 | s0
0194  +0x025e0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
0195  +0x025f8  op=85  1e 10 80 00  ADD64_IMM16      s16 = s30 +0x80
0196  +0x02610  op=26  1e 12 7c 00  ST8              *(s30 +0x7c) = (uint8_t)s18
0197  +0x02628  op=34  10 00 04 01  OR64             s4 = s16 | s0
0198  +0x02640  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x1235f600 rt/so-mapped
0199  +0x02658  op=52  1e 05 a4 00  LD32S            s5 = *(int32_t *)(s30 +0xa4)
019a  +0x02670  op=34  10 00 04 00  OR64             s4 = s16 | s0
019b  +0x02688  op=34  13 00 06 01  OR64             s6 = s19 | s0
019c  +0x026a0  op=5e  00 00 00 00  CALL_CF_INDEX    call native_binding[index=0x0] via q1 table ; q1=0x1235f600 rt/so-mapped
019d  +0x026b8  op=15  14 01 01 00  CMP_LT_IMM64S    s1 = ((int64_t)s20 < 1) ? 1 : 0
019e  +0x026d0  op=1f  14 01 01 00  CMOVZ64          s1 = (s1 == 0) ? s20 : 0
019f  +0x026e8  op=6d  00 01 01 00  SHL64_IMM32PLUS  s1 = s1 << (0 + 32)
01a0  +0x02700  op=67  00 01 02 00  LSR64_IMM32PLUS  s2 = (uint64_t)s1 >> (0 + 32)
01a1  +0x02718  op=ae  02 13 0a 00  BR_EQ64          if (s2 == s19) goto record +428
01a2  +0x02730  op=58  1e 03 a8 00  LD64             s3 = *(uint64_t *)(s30 +0xa8)
01a3  +0x02748  op=58  1e 01 90 00  LD64             s1 = *(uint64_t *)(s30 +0x90)
01a4  +0x02760  op=59  1e 04 7c 00  LD8U             s4 = *(uint8_t *)(s30 +0x7c)
01a5  +0x02778  op=84  03 13 03 04  ADD64            s3 = s3 + s19
01a6  +0x02790  op=84  01 13 01 04  ADD64            s1 = s1 + s19
01a7  +0x027a8  op=85  13 13 01 00  ADD64_IMM16      s19 = s19 +0x1
01a8  +0x027c0  op=59  03 03 00 00  LD8U             s3 = *(uint8_t *)(s3 +0x0)
01a9  +0x027d8  op=02  04 03 03 00  XOR64            s3 = s3 ^ s4
01aa  +0x027f0  op=26  01 03 00 00  ST8              *(s1 +0x0) = (uint8_t)s3
01ab  +0x02808  op=a7  02 13 f6 ff  BR_NE64          if (s2 != s19) goto record +418
01ac  +0x02820  op=85  1e 12 60 00  ADD64_IMM16      s18 = s30 +0x60
01ad  +0x02838  op=34  12 00 04 00  OR64             s4 = s18 | s0
01ae  +0x02850  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x1235f600 rt/so-mapped
01af  +0x02868  op=85  1e 13 48 00  ADD64_IMM16      s19 = s30 +0x48
01b0  +0x02880  op=85  1e 05 7c 00  ADD64_IMM16      s5 = s30 +0x7c
01b1  +0x02898  op=85  00 06 01 00  ADD64_IMM16      s6 = s0 +0x1
01b2  +0x028b0  op=34  13 00 04 00  OR64             s4 = s19 | s0
01b3  +0x028c8  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x1235f600 rt/so-mapped
01b4  +0x028e0  op=85  1e 10 20 00  ADD64_IMM16      s16 = s30 +0x20
01b5  +0x028f8  op=85  1e 14 80 00  ADD64_IMM16      s20 = s30 +0x80
01b6  +0x02910  op=34  13 00 05 01  OR64             s5 = s19 | s0
01b7  +0x02928  op=34  10 00 04 01  OR64             s4 = s16 | s0
01b8  +0x02940  op=34  14 00 06 01  OR64             s6 = s20 | s0
01b9  +0x02958  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x1235f600 rt/so-mapped
01ba  +0x02970  op=85  1e 11 38 00  ADD64_IMM16      s17 = s30 +0x38
01bb  +0x02988  op=34  10 00 05 01  OR64             s5 = s16 | s0
01bc  +0x029a0  op=34  11 00 04 01  OR64             s4 = s17 | s0
01bd  +0x029b8  op=5e  2b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2b] via q1 table ; q1=0x1235f600 rt/so-mapped
01be  +0x029d0  op=58  1e 05 38 00  LD64             s5 = *(uint64_t *)(s30 +0x38)
01bf  +0x029e8  op=34  12 00 04 01  OR64             s4 = s18 | s0
01c0  +0x02a00  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x1235f600 rt/so-mapped
01c1  +0x02a18  op=34  11 00 04 00  OR64             s4 = s17 | s0
01c2  +0x02a30  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
01c3  +0x02a48  op=34  10 00 04 01  OR64             s4 = s16 | s0
01c4  +0x02a60  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01c5  +0x02a78  op=85  00 10 03 00  ADD64_IMM16      s16 = s0 +0x3
01c6  +0x02a90  op=85  1e 04 f8 01  ADD64_IMM16      s4 = s30 +0x1f8
01c7  +0x02aa8  op=34  10 00 05 00  OR64             s5 = s16 | s0
01c8  +0x02ac0  op=5e  2f 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2f] via q1 table ; q1=0x1235f600 rt/so-mapped
01c9  +0x02ad8  op=85  1e 04 e8 01  ADD64_IMM16      s4 = s30 +0x1e8
01ca  +0x02af0  op=85  00 05 09 00  ADD64_IMM16      s5 = s0 +0x9
01cb  +0x02b08  op=34  02 00 11 01  OR64             s17 = s2 | s0
01cc  +0x02b20  op=5e  19 00 00 00  CALL_CF_INDEX    call native_binding[index=0x19] via q1 table ; q1=0x1235f600 rt/so-mapped
01cd  +0x02b38  op=58  1e 04 10 00  LD64             s4 = *(uint64_t *)(s30 +0x10)
01ce  +0x02b50  op=34  02 00 06 00  OR64             s6 = s2 | s0
01cf  +0x02b68  op=34  11 00 05 01  OR64             s5 = s17 | s0
01d0  +0x02b80  op=5e  64 00 00 00  CALL_CF_INDEX    call native_binding[index=0x64] via q1 table ; q1=0x1235f600 rt/so-mapped
01d1  +0x02b98  op=85  1e 04 fc 01  ADD64_IMM16      s4 = s30 +0x1fc
01d2  +0x02bb0  op=34  10 00 05 00  OR64             s5 = s16 | s0
01d3  +0x02bc8  op=5e  20 00 00 00  CALL_CF_INDEX    call native_binding[index=0x20] via q1 table ; q1=0x1235f600 rt/so-mapped
01d4  +0x02be0  op=58  1e 06 70 00  LD64             s6 = *(uint64_t *)(s30 +0x70)
01d5  +0x02bf8  op=58  1e 04 18 00  LD64             s4 = *(uint64_t *)(s30 +0x18)
01d6  +0x02c10  op=34  02 00 05 00  OR64             s5 = s2 | s0
01d7  +0x02c28  op=5e  64 00 00 00  CALL_CF_INDEX    call native_binding[index=0x64] via q1 table ; q1=0x1235f600 rt/so-mapped
01d8  +0x02c40  op=34  13 00 04 01  OR64             s4 = s19 | s0
01d9  +0x02c58  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01da  +0x02c70  op=34  12 00 04 01  OR64             s4 = s18 | s0
01db  +0x02c88  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01dc  +0x02ca0  op=34  14 00 04 01  OR64             s4 = s20 | s0
01dd  +0x02cb8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01de  +0x02cd0  op=85  1e 04 98 00  ADD64_IMM16      s4 = s30 +0x98
01df  +0x02ce8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01e0  +0x02d00  op=85  1e 04 b0 00  ADD64_IMM16      s4 = s30 +0xb0
01e1  +0x02d18  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01e2  +0x02d30  op=85  1e 04 c8 00  ADD64_IMM16      s4 = s30 +0xc8
01e3  +0x02d48  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01e4  +0x02d60  op=85  1e 04 e0 00  ADD64_IMM16      s4 = s30 +0xe0
01e5  +0x02d78  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01e6  +0x02d90  op=85  1e 04 00 01  ADD64_IMM16      s4 = s30 +0x100
01e7  +0x02da8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01e8  +0x02dc0  op=85  1e 04 20 01  ADD64_IMM16      s4 = s30 +0x120
01e9  +0x02dd8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01ea  +0x02df0  op=85  1e 04 38 01  ADD64_IMM16      s4 = s30 +0x138
01eb  +0x02e08  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01ec  +0x02e20  op=85  1e 04 50 01  ADD64_IMM16      s4 = s30 +0x150
01ed  +0x02e38  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01ee  +0x02e50  op=85  1e 04 68 01  ADD64_IMM16      s4 = s30 +0x168
01ef  +0x02e68  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x1235f600 rt/so-mapped
01f0  +0x02e80  op=85  1e 04 80 01  ADD64_IMM16      s4 = s30 +0x180
01f1  +0x02e98  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
01f2  +0x02eb0  op=85  1e 04 90 01  ADD64_IMM16      s4 = s30 +0x190
01f3  +0x02ec8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
01f4  +0x02ee0  op=85  1e 04 a0 01  ADD64_IMM16      s4 = s30 +0x1a0
01f5  +0x02ef8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
01f6  +0x02f10  op=85  1e 04 b0 01  ADD64_IMM16      s4 = s30 +0x1b0
01f7  +0x02f28  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x1235f600 rt/so-mapped
01f8  +0x02f40  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
01f9  +0x02f58  op=58  1d 10 00 02  LD64             s16 = *(uint64_t *)(s29 +0x200)
01fa  +0x02f70  op=58  1d 11 08 02  LD64             s17 = *(uint64_t *)(s29 +0x208)
01fb  +0x02f88  op=58  1d 12 10 02  LD64             s18 = *(uint64_t *)(s29 +0x210)
01fc  +0x02fa0  op=58  1d 13 18 02  LD64             s19 = *(uint64_t *)(s29 +0x218)
01fd  +0x02fb8  op=58  1d 14 20 02  LD64             s20 = *(uint64_t *)(s29 +0x220)
01fe  +0x02fd0  op=58  1d 15 28 02  LD64             s21 = *(uint64_t *)(s29 +0x228)
01ff  +0x02fe8  op=58  1d 16 30 02  LD64             s22 = *(uint64_t *)(s29 +0x230)
0200  +0x03000  op=58  1d 17 38 02  LD64             s23 = *(uint64_t *)(s29 +0x238)
0201  +0x03018  op=58  1d 1e 40 02  LD64             s30 = *(uint64_t *)(s29 +0x240)
0202  +0x03030  op=58  1d 1f 48 02  LD64             s31 = *(uint64_t *)(s29 +0x248)
0203  +0x03048  op=85  1d 1d 50 02  ADD64_IMM16      s29 = s29 +0x250
0204  +0x03060  op=5b  1f 00 00 00  RET              return/leave with s31

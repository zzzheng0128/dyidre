; MetaSec managed bytecode decode: F5
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F5_0x67b000_0x4728.bin
; records: 759  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d c0 fb  ADD64_IMM16      s29 = s29 -0x440
0001  +0x00018  op=25  1d 1f 38 04  ST64             *(s29 +0x438) = s31
0002  +0x00030  op=25  1d 1e 30 04  ST64             *(s29 +0x430) = s30 ; q1=0x1700000000
0003  +0x00048  op=25  1d 17 28 04  ST64             *(s29 +0x428) = s23
0004  +0x00060  op=25  1d 16 20 04  ST64             *(s29 +0x420) = s22 ; q1=0x54
0005  +0x00078  op=25  1d 15 18 04  ST64             *(s29 +0x418) = s21 ; q1=0x126296f8 rt/so-mapped
0006  +0x00090  op=25  1d 14 10 04  ST64             *(s29 +0x410) = s20 ; q1=0x1262a300 rt/so-mapped
0007  +0x000a8  op=25  1d 13 08 04  ST64             *(s29 +0x408) = s19
0008  +0x000c0  op=25  1d 12 00 04  ST64             *(s29 +0x400) = s18 ; q1=0x1800000002
0009  +0x000d8  op=25  1d 11 f8 03  ST64             *(s29 +0x3f8) = s17
000a  +0x000f0  op=25  1d 10 f0 03  ST64             *(s29 +0x3f0) = s16 ; q1=0x24a4
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0 ; q1=0x12629578 rt/so-mapped
000c  +0x00120  op=58  04 01 50 00  LD64             s1 = *(uint64_t *)(s4 +0x50) ; q1=0x1262a4e0 rt/so-mapped
000d  +0x00138  op=34  04 00 11 01  OR64             s17 = s4 | s0
000e  +0x00150  op=52  04 13 58 00  LD32S            s19 = *(int32_t *)(s4 +0x58) ; q1=0x1900000004
000f  +0x00168  op=58  04 17 18 00  LD64             s23 = *(uint64_t *)(s4 +0x18)
0010  +0x00180  op=58  04 16 10 00  LD64             s22 = *(uint64_t *)(s4 +0x10) ; q1=0xc90
0011  +0x00198  op=58  04 12 08 00  LD64             s18 = *(uint64_t *)(s4 +0x8) ; q1=0x126295b8 rt/so-mapped
0012  +0x001b0  op=85  00 06 e0 00  ADD64_IMM16      s6 = s0 +0xe0 ; q1=0x125de150 rt/so-mapped
0013  +0x001c8  op=25  1e 01 30 00  ST64             *(s30 +0x30) = s1
0014  +0x001e0  op=58  04 01 48 00  LD64             s1 = *(uint64_t *)(s4 +0x48) ; q1=0x1a00000005
0015  +0x001f8  op=25  1e 01 28 00  ST64             *(s30 +0x28) = s1
0016  +0x00210  op=58  04 01 38 00  LD64             s1 = *(uint64_t *)(s4 +0x38) ; q1=0x24
0017  +0x00228  op=25  1e 01 10 00  ST64             *(s30 +0x10) = s1 ; q1=0x126295f8 rt/so-mapped
0018  +0x00240  op=58  04 01 30 00  LD64             s1 = *(uint64_t *)(s4 +0x30) ; q1=0x1262a520 rt/so-mapped
0019  +0x00258  op=25  1e 01 20 00  ST64             *(s30 +0x20) = s1
001a  +0x00270  op=58  04 01 28 00  LD64             s1 = *(uint64_t *)(s4 +0x28) ; q1=0x1b00000004
001b  +0x00288  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1
001c  +0x002a0  op=58  04 01 20 00  LD64             s1 = *(uint64_t *)(s4 +0x20) ; q1=0x83c
001d  +0x002b8  op=25  1e 01 40 00  ST64             *(s30 +0x40) = s1 ; q1=0x12629638 rt/so-mapped
001e  +0x002d0  op=58  04 01 00 00  LD64             s1 = *(uint64_t *)(s4 +0x0) ; q1=0x1262a560 rt/so-mapped
001f  +0x002e8  op=85  1e 04 10 03  ADD64_IMM16      s4 = s30 +0x310
0020  +0x00300  op=25  1e 01 38 00  ST64             *(s30 +0x38) = s1 ; q1=0x1c00000004
0021  +0x00318  op=53  04 01 88 02  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x288 ; q1=0x125fd408 rt/so-mapped
0022  +0x00330  op=58  01 10 00 00  LD64             s16 = *(uint64_t *)(s1 +0x0) ; q1=0x7bc
0023  +0x00348  op=53  01 01 08 03  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x308 ; q1=0x125fd408 rt/so-mapped
0024  +0x00360  op=58  01 14 00 00  LD64             s20 = *(uint64_t *)(s1 +0x0) ; q1=0x1262a640 rt/so-mapped
0025  +0x00378  op=53  04 01 78 02  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x278 ; q1=0x125fd408 rt/so-mapped
0026  +0x00390  op=58  01 05 00 00  LD64             s5 = *(uint64_t *)(s1 +0x0) ; q1=0x1d00000006
0027  +0x003a8  op=5e  03 00 00 00  CALL_CF_INDEX    call native_binding[index=0x3] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0028  +0x003c0  op=85  1e 04 f8 02  ADD64_IMM16      s4 = s30 +0x2f8 ; q1=0xc4
0029  +0x003d8  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
002a  +0x003f0  op=85  1e 04 e0 02  ADD64_IMM16      s4 = s30 +0x2e0 ; q1=0x1262a680 rt/so-mapped
002b  +0x00408  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
002c  +0x00420  op=b5  00 01 01 00  ADD32_IMM16      s1 = int32(s0 +0x1) ; q1=0x1e00000004
002d  +0x00438  op=25  1e 14 48 00  ST64             *(s30 +0x48) = s20
002e  +0x00450  op=25  1e 16 08 00  ST64             *(s30 +0x8) = s22 ; q1=0xc70
002f  +0x00468  op=a7  13 01 08 00  BR_NE64          if (s19 != s1) goto record +56 ; q1=0x12629738 rt/so-mapped
0030  +0x00480  op=85  14 15 65 00  ADD64_IMM16      s21 = s20 +0x65 ; q1=0x1262a6c0 rt/so-mapped
0031  +0x00498  op=85  1e 04 f8 02  ADD64_IMM16      s4 = s30 +0x2f8
0032  +0x004b0  op=34  15 00 05 01  OR64             s5 = s21 | s0 ; q1=0x1f00000004
0033  +0x004c8  op=5e  05 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0034  +0x004e0  op=85  1e 04 e0 02  ADD64_IMM16      s4 = s30 +0x2e0 ; q1=0x83c
0035  +0x004f8  op=34  15 00 05 01  OR64             s5 = s21 | s0 ; q1=0x12629778 rt/so-mapped
0036  +0x00510  op=5e  05 00 00 00  CALL_CF_INDEX    call native_binding[index=0x5] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0037  +0x00528  op=5f  12 00 00 00  ADD_PC_IMM32     goto record +74 ; vm_pc = current_pc + 1 + 18
0038  +0x00540  op=85  1e 15 e0 01  ADD64_IMM16      s21 = s30 +0x1e0 ; q1=0x2000000006
0039  +0x00558  op=34  17 00 05 01  OR64             s5 = s23 | s0
003a  +0x00570  op=34  15 00 04 00  OR64             s4 = s21 | s0 ; q1=0xc4
003b  +0x00588  op=5e  6d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
003c  +0x005a0  op=85  1e 04 f8 02  ADD64_IMM16      s4 = s30 +0x2f8 ; q1=0x1262a740 rt/so-mapped
003d  +0x005b8  op=34  15 00 05 01  OR64             s5 = s21 | s0
003e  +0x005d0  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF10 copyMemBlockData
003f  +0x005e8  op=34  15 00 04 01  OR64             s4 = s21 | s0
0040  +0x00600  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0041  +0x00618  op=85  1e 15 e0 01  ADD64_IMM16      s21 = s30 +0x1e0 ; q1=0x126297f8 rt/so-mapped
0042  +0x00630  op=34  16 00 05 00  OR64             s5 = s22 | s0 ; q1=0x1262a780 rt/so-mapped
0043  +0x00648  op=34  15 00 04 00  OR64             s4 = s21 | s0
0044  +0x00660  op=5e  6d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0045  +0x00678  op=85  1e 04 e0 02  ADD64_IMM16      s4 = s30 +0x2e0
0046  +0x00690  op=34  15 00 05 00  OR64             s5 = s21 | s0 ; q1=0x83c
0047  +0x006a8  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF10 copyMemBlockData
0048  +0x006c0  op=34  15 00 04 01  OR64             s4 = s21 | s0 ; q1=0x1262a7c0 rt/so-mapped
0049  +0x006d8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
004a  +0x006f0  op=54  00 01 20 20  CONST_HI16       s1 = sign_extend_32(0x2020 << 16) ; q1=0x2300000006
004b  +0x00708  op=85  1e 04 c8 02  ADD64_IMM16      s4 = s30 +0x2c8
004c  +0x00720  op=53  04 05 28 00  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x28 ; q1=0x125fd408 rt/so-mapped
004d  +0x00738  op=25  1e 17 00 00  ST64             *(s30 +0x0) = s23 ; q1=0x126298b8 rt/so-mapped
004e  +0x00750  op=08  1e 13 ec 03  ST32             *(s30 +0x3ec) = (uint32_t)s19 ; q1=0x1262a800 rt/so-mapped
004f  +0x00768  op=33  01 01 29 09  OR_IMM16         s1 = s1 | 0x929
0050  +0x00780  op=08  1e 01 28 03  ST32             *(s30 +0x328) = (uint32_t)s1 ; q1=0x2400000004
0051  +0x00798  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0052  +0x007b0  op=85  1e 15 b8 02  ADD64_IMM16      s21 = s30 +0x2b8 ; q1=0xc5c
0053  +0x007c8  op=34  12 00 05 01  OR64             s5 = s18 | s0 ; q1=0x126298f8 rt/so-mapped
0054  +0x007e0  op=34  15 00 04 01  OR64             s4 = s21 | s0 ; q1=0x1262ae40 rt/so-mapped
0055  +0x007f8  op=5e  09 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0056  +0x00810  op=85  1e 16 a8 02  ADD64_IMM16      s22 = s30 +0x2a8 ; q1=0x2500000004
0057  +0x00828  op=34  15 00 05 01  OR64             s5 = s21 | s0
0058  +0x00840  op=34  16 00 04 01  OR64             s4 = s22 | s0 ; q1=0x7bc
0059  +0x00858  op=5e  0a 00 00 00  CALL_CF_INDEX    call native_binding[index=0xa] via q1 table ; q1=0x125fd3c0 rt/so-mapped
005a  +0x00870  op=34  16 00 04 01  OR64             s4 = s22 | s0 ; q1=0x1262ae80 rt/so-mapped
005b  +0x00888  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd3c0 rt/so-mapped
005c  +0x008a0  op=34  16 00 04 01  OR64             s4 = s22 | s0 ; q1=0x2600000006
005d  +0x008b8  op=34  02 00 15 01  OR64             s21 = s2 | s0
005e  +0x008d0  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
005f  +0x008e8  op=18  11 15 01 00  SHL32_IMM        s1 = (int32_t)(s21 << 0) ; q1=0x12629978 rt/so-mapped
0060  +0x00900  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1 ; q1=0x1262aec0 rt/so-mapped
0061  +0x00918  op=a7  01 00 03 00  BR_NE64          if (s1 != s0) goto record +101
0062  +0x00930  op=58  1e 05 b8 02  LD64             s5 = *(uint64_t *)(s30 +0x2b8) ; q1=0x2700000004
0063  +0x00948  op=85  1e 04 c8 02  ADD64_IMM16      s4 = s30 +0x2c8
0064  +0x00960  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF10 copyMemBlockData
0065  +0x00978  op=58  1e 01 d8 02  LD64             s1 = *(uint64_t *)(s30 +0x2d8) ; q1=0x126299b8 rt/so-mapped
0066  +0x00990  op=25  1e 01 38 03  ST64             *(s30 +0x338) = s1 ; q1=0x1262af00 rt/so-mapped
0067  +0x009a8  op=b5  00 01 01 00  ADD32_IMM16      s1 = int32(s0 +0x1)
0068  +0x009c0  op=08  1e 01 2c 03  ST32             *(s30 +0x32c) = (uint32_t)s1 ; q1=0x2800000004
0069  +0x009d8  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd3c0 rt/so-mapped
006a  +0x009f0  op=85  1e 17 98 02  ADD64_IMM16      s23 = s30 +0x298 ; q1=0x78c
006b  +0x00a08  op=34  12 00 05 01  OR64             s5 = s18 | s0 ; q1=0x126299f8 rt/so-mapped
006c  +0x00a20  op=08  1e 02 30 03  ST32             *(s30 +0x330) = (uint32_t)s2 ; q1=0x1262af40 rt/so-mapped
006d  +0x00a38  op=34  17 00 04 01  OR64             s4 = s23 | s0
006e  +0x00a50  op=5e  0e 00 00 00  CALL_CF_INDEX    call native_binding[index=0xe] via q1 table ; q1=0x125fd3c0 rt/so-mapped
006f  +0x00a68  op=85  1e 16 88 02  ADD64_IMM16      s22 = s30 +0x288
0070  +0x00a80  op=34  12 00 05 00  OR64             s5 = s18 | s0 ; q1=0xc4
0071  +0x00a98  op=34  16 00 04 01  OR64             s4 = s22 | s0 ; q1=0x12629a38 rt/so-mapped
0072  +0x00ab0  op=5e  0f 00 00 00  CALL_CF_INDEX    call native_binding[index=0xf] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0073  +0x00ac8  op=85  1e 15 78 02  ADD64_IMM16      s21 = s30 +0x278
0074  +0x00ae0  op=34  12 00 05 00  OR64             s5 = s18 | s0 ; q1=0x2a00000004
0075  +0x00af8  op=34  15 00 04 01  OR64             s4 = s21 | s0
0076  +0x00b10  op=5e  10 00 00 00  CALL_CF_INDEX    call native_binding[index=0x10] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0077  +0x00b28  op=85  1e 04 60 02  ADD64_IMM16      s4 = s30 +0x260 ; q1=0x12629a78 rt/so-mapped
0078  +0x00b40  op=53  03 05 28 00  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x28 ; q1=0x125fd408 rt/so-mapped
0079  +0x00b58  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
007a  +0x00b70  op=85  1e 13 50 02  ADD64_IMM16      s19 = s30 +0x250 ; q1=0x2b00000001
007b  +0x00b88  op=34  17 00 05 01  OR64             s5 = s23 | s0
007c  +0x00ba0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0xb4
007d  +0x00bb8  op=5e  0a 00 00 00  CALL_CF_INDEX    call native_binding[index=0xa] via q1 table ; q1=0x125fd3c0 rt/so-mapped
007e  +0x00bd0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x125d7290 rt/so-mapped
007f  +0x00be8  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0080  +0x00c00  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x2c00000001
0081  +0x00c18  op=34  02 00 14 01  OR64             s20 = s2 | s0
0082  +0x00c30  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0083  +0x00c48  op=18  10 14 01 00  SHL32_IMM        s1 = (int32_t)(s20 << 0) ; q1=0x12629af8 rt/so-mapped
0084  +0x00c60  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1 ; q1=0x125d7280 rt/so-mapped
0085  +0x00c78  op=ae  01 00 1a 00  BR_EQ64          if (s1 == s0) goto record +160
0086  +0x00c90  op=85  1e 13 40 02  ADD64_IMM16      s19 = s30 +0x240 ; q1=0x2d00000001
0087  +0x00ca8  op=34  15 00 05 01  OR64             s5 = s21 | s0
0088  +0x00cc0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x2a0
0089  +0x00cd8  op=5e  0a 00 00 00  CALL_CF_INDEX    call native_binding[index=0xa] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008a  +0x00cf0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x125de130 rt/so-mapped
008b  +0x00d08  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008c  +0x00d20  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x2e00000005
008d  +0x00d38  op=34  02 00 14 00  OR64             s20 = s2 | s0
008e  +0x00d50  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008f  +0x00d68  op=18  00 14 01 00  SHL32_IMM        s1 = (int32_t)(s20 << 0) ; q1=0x12629b78 rt/so-mapped
0090  +0x00d80  op=34  15 00 17 01  OR64             s23 = s21 | s0 ; q1=0x1262afc0 rt/so-mapped
0091  +0x00d98  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
0092  +0x00db0  op=ae  01 00 0d 00  BR_EQ64          if (s1 == s0) goto record +160 ; q1=0x2f0000000c
0093  +0x00dc8  op=85  1e 13 30 02  ADD64_IMM16      s19 = s30 +0x230
0094  +0x00de0  op=34  16 00 05 01  OR64             s5 = s22 | s0 ; q1=0x18c
0095  +0x00df8  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x12629bb8 rt/so-mapped
0096  +0x00e10  op=5e  0a 00 00 00  CALL_CF_INDEX    call native_binding[index=0xa] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0097  +0x00e28  op=34  13 00 04 01  OR64             s4 = s19 | s0
0098  +0x00e40  op=5e  0b 00 00 00  CALL_CF_INDEX    call native_binding[index=0xb] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0099  +0x00e58  op=34  13 00 04 00  OR64             s4 = s19 | s0
009a  +0x00e70  op=34  02 00 14 01  OR64             s20 = s2 | s0 ; q1=0x160
009b  +0x00e88  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
009c  +0x00ea0  op=18  10 14 01 00  SHL32_IMM        s1 = (int32_t)(s20 << 0) ; q1=0x125de170 rt/so-mapped
009d  +0x00eb8  op=34  16 00 17 00  OR64             s23 = s22 | s0
009e  +0x00ed0  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1 ; q1=0x3100000005
009f  +0x00ee8  op=a7  01 00 03 00  BR_NE64          if (s1 != s0) goto record +163
00a0  +0x00f00  op=58  17 05 00 00  LD64             s5 = *(uint64_t *)(s23 +0x0) ; q1=0x54
00a1  +0x00f18  op=85  1e 04 60 02  ADD64_IMM16      s4 = s30 +0x260 ; q1=0x12629c38 rt/so-mapped
00a2  +0x00f30  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF10 copyMemBlockData
00a3  +0x00f48  op=58  1e 01 70 02  LD64             s1 = *(uint64_t *)(s30 +0x270)
00a4  +0x00f60  op=25  1e 01 40 03  ST64             *(s30 +0x340) = s1 ; q1=0x3200000001
00a5  +0x00f78  op=58  12 01 08 00  LD64             s1 = *(uint64_t *)(s18 +0x8)
00a6  +0x00f90  op=52  01 01 0c 00  LD32S            s1 = *(int32_t *)(s1 +0xc) ; q1=0xc8
00a7  +0x00fa8  op=ae  01 00 04 00  BR_EQ64          if (s1 == s0) goto record +172 ; q1=0x12629c78 rt/so-mapped
00a8  +0x00fc0  op=58  1e 13 38 00  LD64             s19 = *(uint64_t *)(s30 +0x38) ; q1=0x12660000 rt/so-mapped
00a9  +0x00fd8  op=58  1e 15 48 00  LD64             s21 = *(uint64_t *)(s30 +0x48)
00aa  +0x00ff0  op=18  10 13 02 00  SHL32_IMM        s2 = (int32_t)(s19 << 0) ; q1=0x330000000d
00ab  +0x01008  op=5f  09 00 00 00  ADD_PC_IMM32     goto record +181 ; vm_pc = current_pc + 1 + 9
00ac  +0x01020  op=58  12 02 80 00  LD64             s2 = *(uint64_t *)(s18 +0x80) ; q1=0x124
00ad  +0x01038  op=58  1e 13 38 00  LD64             s19 = *(uint64_t *)(s30 +0x38) ; q1=0x12629cb8 rt/so-mapped
00ae  +0x01050  op=58  1e 15 48 00  LD64             s21 = *(uint64_t *)(s30 +0x48) ; q1=0x125de190 rt/so-mapped
00af  +0x01068  op=52  02 02 0c 00  LD32S            s2 = *(int32_t *)(s2 +0xc)
00b0  +0x01080  op=18  00 13 01 00  SHL32_IMM        s1 = (int32_t)(s19 << 0) ; q1=0x3400000005
00b1  +0x01098  op=15  02 02 01 00  CMP_LT_IMM64S    s2 = ((int64_t)s2 < 1) ? 1 : 0
00b2  +0x010b0  op=1e  01 02 01 01  CMOVNZ64         s1 = (s2 != 0) ? s1 : 0 ; q1=0x2c8
00b3  +0x010c8  op=1f  00 02 02 00  CMOVZ64          s2 = (s2 == 0) ? s0 : 0 ; q1=0x12629cf8 rt/so-mapped
00b4  +0x010e0  op=34  02 01 02 01  OR64             s2 = s2 | s1 ; q1=0x125d7200 rt/so-mapped
00b5  +0x010f8  op=85  12 16 a0 00  ADD64_IMM16      s22 = s18 +0xa0
00b6  +0x01110  op=85  1e 17 e0 01  ADD64_IMM16      s23 = s30 +0x1e0 ; q1=0x3500000001
00b7  +0x01128  op=08  1e 02 b8 03  ST32             *(s30 +0x3b8) = (uint32_t)s2
00b8  +0x01140  op=34  17 00 04 01  OR64             s4 = s23 | s0 ; q1=0x2a0
00b9  +0x01158  op=34  16 00 05 01  OR64             s5 = s22 | s0 ; q1=0x12629d38 rt/so-mapped
00ba  +0x01170  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00bb  +0x01188  op=58  1e 05 e0 01  LD64             s5 = *(uint64_t *)(s30 +0x1e0)
00bc  +0x011a0  op=85  1e 04 20 02  ADD64_IMM16      s4 = s30 +0x220 ; q1=0x3600000005
00bd  +0x011b8  op=5e  12 00 00 00  CALL_CF_INDEX    call native_binding[index=0x12] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00be  +0x011d0  op=34  17 00 04 01  OR64             s4 = s23 | s0 ; q1=0xa0
00bf  +0x011e8  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00c0  +0x01200  op=58  1e 01 20 02  LD64             s1 = *(uint64_t *)(s30 +0x220) ; q1=0x12660040 rt/so-mapped
00c1  +0x01218  op=85  1e 04 10 02  ADD64_IMM16      s4 = s30 +0x210
00c2  +0x01230  op=58  01 01 10 00  LD64             s1 = *(uint64_t *)(s1 +0x10) ; q1=0x370000000c
00c3  +0x01248  op=25  1e 01 48 03  ST64             *(s30 +0x348) = s1
00c4  +0x01260  op=5e  14 00 00 00  CALL_CF_INDEX    call native_binding[index=0x14] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00c5  +0x01278  op=58  1e 01 10 02  LD64             s1 = *(uint64_t *)(s30 +0x210) ; q1=0x12629db8 rt/so-mapped
00c6  +0x01290  op=58  01 01 10 00  LD64             s1 = *(uint64_t *)(s1 +0x10) ; q1=0x125d7210 rt/so-mapped
00c7  +0x012a8  op=25  1e 01 50 03  ST64             *(s30 +0x350) = s1
00c8  +0x012c0  op=5e  15 00 00 00  CALL_CF_INDEX    call native_binding[index=0x15] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00c9  +0x012d8  op=08  1e 02 60 03  ST32             *(s30 +0x360) = (uint32_t)s2
00ca  +0x012f0  op=5e  16 00 00 00  CALL_CF_INDEX    call native_binding[index=0x16] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00cb  +0x01308  op=58  1e 04 40 00  LD64             s4 = *(uint64_t *)(s30 +0x40) ; q1=0x12629df8 rt/so-mapped
00cc  +0x01320  op=25  1e 02 58 03  ST64             *(s30 +0x358) = s2 ; q1=0x125d7220 rt/so-mapped
00cd  +0x01338  op=58  1e 05 f0 02  LD64             s5 = *(uint64_t *)(s30 +0x2f0)
00ce  +0x01350  op=53  03 01 29 00  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x29 ; q1=0x125fd408 rt/so-mapped
00cf  +0x01368  op=85  00 03 06 00  ADD64_IMM16      s3 = s0 +0x6
00d0  +0x01380  op=52  04 02 0c 00  LD32S            s2 = *(int32_t *)(s4 +0xc) ; q1=0xc8
00d1  +0x01398  op=58  04 04 10 00  LD64             s4 = *(uint64_t *)(s4 +0x10) ; q1=0x12629e38 rt/so-mapped
00d2  +0x013b0  op=25  1e 04 70 03  ST64             *(s30 +0x370) = s4 ; q1=0x12660080 rt/so-mapped
00d3  +0x013c8  op=58  1e 04 08 03  LD64             s4 = *(uint64_t *)(s30 +0x308)
00d4  +0x013e0  op=25  1e 13 80 03  ST64             *(s30 +0x380) = s19 ; q1=0x3a0000000d
00d5  +0x013f8  op=25  1e 05 90 03  ST64             *(s30 +0x390) = s5
00d6  +0x01410  op=25  1e 04 a0 03  ST64             *(s30 +0x3a0) = s4 ; q1=0x124
00d7  +0x01428  op=25  1e 03 98 03  ST64             *(s30 +0x398) = s3 ; q1=0x12629e78 rt/so-mapped
00d8  +0x01440  op=25  1e 03 88 03  ST64             *(s30 +0x388) = s3 ; q1=0x12627ee0 rt/so-mapped
00d9  +0x01458  op=25  1e 02 68 03  ST64             *(s30 +0x368) = s2
00da  +0x01470  op=59  01 02 04 00  LD8U             s2 = *(uint8_t *)(s1 +0x4) ; q1=0x3b00000005
00db  +0x01488  op=52  01 01 00 00  LD32S            s1 = *(int32_t *)(s1 +0x0)
00dc  +0x014a0  op=08  1e 00 78 03  ST32             *(s30 +0x378) = (uint32_t)s0 ; q1=0x2cc
00dd  +0x014b8  op=26  1e 02 0c 02  ST8              *(s30 +0x20c) = (uint8_t)s2 ; q1=0x12629eb8 rt/so-mapped
00de  +0x014d0  op=08  1e 01 08 02  ST32             *(s30 +0x208) = (uint32_t)s1 ; q1=0x125d7230 rt/so-mapped
00df  +0x014e8  op=58  10 01 10 00  LD64             s1 = *(uint64_t *)(s16 +0x10)
00e0  +0x01500  op=25  1e 01 f0 01  ST64             *(s30 +0x1f0) = s1 ; q1=0x3c00000001
00e1  +0x01518  op=58  10 01 08 00  LD64             s1 = *(uint64_t *)(s16 +0x8)
00e2  +0x01530  op=25  1e 01 e8 01  ST64             *(s30 +0x1e8) = s1 ; q1=0x2a0
00e3  +0x01548  op=58  10 01 00 00  LD64             s1 = *(uint64_t *)(s16 +0x0) ; q1=0x12629ef8 rt/so-mapped
00e4  +0x01560  op=25  1e 01 e0 01  ST64             *(s30 +0x1e0) = s1 ; q1=0x12627f00 rt/so-mapped
00e5  +0x01578  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00e6  +0x01590  op=85  1e 13 c8 01  ADD64_IMM16      s19 = s30 +0x1c8 ; q1=0x3d00000005
00e7  +0x015a8  op=85  15 05 86 00  ADD64_IMM16      s5 = s21 +0x86
00e8  +0x015c0  op=58  02 14 00 00  LD64             s20 = *(uint64_t *)(s2 +0x0) ; q1=0xa0
00e9  +0x015d8  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x12629f38 rt/so-mapped
00ea  +0x015f0  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00eb  +0x01608  op=34  14 00 04 01  OR64             s4 = s20 | s0
00ec  +0x01620  op=34  13 00 05 01  OR64             s5 = s19 | s0 ; q1=0x3e0000000c
00ed  +0x01638  op=5e  18 00 00 00  CALL_CF_INDEX    call native_binding[index=0x18] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00ee  +0x01650  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x18c
00ef  +0x01668  op=08  1e 02 f8 01  ST32             *(s30 +0x1f8) = (uint32_t)s2 ; q1=0x12629f78 rt/so-mapped
00f0  +0x01680  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00f1  +0x01698  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00f2  +0x016b0  op=85  1e 13 c8 01  ADD64_IMM16      s19 = s30 +0x1c8 ; q1=0x3f00000001
00f3  +0x016c8  op=85  15 05 a8 00  ADD64_IMM16      s5 = s21 +0xa8
00f4  +0x016e0  op=58  02 14 00 00  LD64             s20 = *(uint64_t *)(s2 +0x0) ; q1=0x160
00f5  +0x016f8  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x12629fb8 rt/so-mapped
00f6  +0x01710  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00f7  +0x01728  op=34  14 00 04 01  OR64             s4 = s20 | s0
00f8  +0x01740  op=34  13 00 05 01  OR64             s5 = s19 | s0 ; q1=0x4000000001
00f9  +0x01758  op=5e  18 00 00 00  CALL_CF_INDEX    call native_binding[index=0x18] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00fa  +0x01770  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0xc8
00fb  +0x01788  op=08  1e 02 00 02  ST32             *(s30 +0x200) = (uint32_t)s2 ; q1=0x12629ff8 rt/so-mapped
00fc  +0x017a0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00fd  +0x017b8  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd3c0 rt/so-mapped
00fe  +0x017d0  op=85  1e 13 c8 01  ADD64_IMM16      s19 = s30 +0x1c8 ; q1=0x410000000d
00ff  +0x017e8  op=85  15 05 ca 00  ADD64_IMM16      s5 = s21 +0xca
0100  +0x01800  op=58  02 14 00 00  LD64             s20 = *(uint64_t *)(s2 +0x0) ; q1=0x124
0101  +0x01818  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x126af038 rt/so-mapped
0102  +0x01830  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0103  +0x01848  op=34  14 00 04 00  OR64             s4 = s20 | s0
0104  +0x01860  op=34  13 00 05 01  OR64             s5 = s19 | s0 ; q1=0x4200000005
0105  +0x01878  op=5e  18 00 00 00  CALL_CF_INDEX    call native_binding[index=0x18] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0106  +0x01890  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x2cc
0107  +0x018a8  op=08  1e 02 fc 01  ST32             *(s30 +0x1fc) = (uint32_t)s2 ; q1=0x126af078 rt/so-mapped
0108  +0x018c0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0109  +0x018d8  op=5e  17 00 00 00  CALL_CF_INDEX    call native_binding[index=0x17] via q1 table ; q1=0x125fd3c0 rt/so-mapped
010a  +0x018f0  op=85  1e 13 c8 01  ADD64_IMM16      s19 = s30 +0x1c8 ; q1=0x4300000001
010b  +0x01908  op=53  01 05 2e 00  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0x2e ; q1=0x125fd408 rt/so-mapped
010c  +0x01920  op=58  02 14 00 00  LD64             s20 = *(uint64_t *)(s2 +0x0) ; q1=0x2a0
010d  +0x01938  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x126b01f8 rt/so-mapped
010e  +0x01950  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
010f  +0x01968  op=34  14 00 04 01  OR64             s4 = s20 | s0
0110  +0x01980  op=34  13 00 05 01  OR64             s5 = s19 | s0 ; q1=0x4400000005
0111  +0x01998  op=5e  18 00 00 00  CALL_CF_INDEX    call native_binding[index=0x18] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0112  +0x019b0  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0xa0
0113  +0x019c8  op=08  1e 02 04 02  ST32             *(s30 +0x204) = (uint32_t)s2 ; q1=0x126b0238 rt/so-mapped
0114  +0x019e0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0115  +0x019f8  op=58  1e 01 18 00  LD64             s1 = *(uint64_t *)(s30 +0x18)
0116  +0x01a10  op=25  1e 17 a8 03  ST64             *(s30 +0x3a8) = s23 ; q1=0x450000000c
0117  +0x01a28  op=85  1e 04 08 02  ADD64_IMM16      s4 = s30 +0x208
0118  +0x01a40  op=85  00 05 05 00  ADD64_IMM16      s5 = s0 +0x5 ; q1=0x18c
0119  +0x01a58  op=58  01 01 10 00  LD64             s1 = *(uint64_t *)(s1 +0x10) ; q1=0x126b0278 rt/so-mapped
011a  +0x01a70  op=25  1e 01 b0 03  ST64             *(s30 +0x3b0) = s1 ; q1=0x125d72a8 rt/so-mapped
011b  +0x01a88  op=52  11 01 40 00  LD32S            s1 = *(int32_t *)(s17 +0x40)
011c  +0x01aa0  op=08  1e 01 e8 03  ST32             *(s30 +0x3e8) = (uint32_t)s1 ; q1=0x4600000001
011d  +0x01ab8  op=5e  19 00 00 00  CALL_CF_INDEX    call native_binding[index=0x19] via q1 table ; q1=0x125fd3c0 rt/so-mapped
011e  +0x01ad0  op=85  1e 04 c8 01  ADD64_IMM16      s4 = s30 +0x1c8 ; q1=0x160
011f  +0x01ae8  op=34  02 00 11 01  OR64             s17 = s2 | s0 ; q1=0x126b02b8 rt/so-mapped
0120  +0x01b00  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0121  +0x01b18  op=85  1e 04 b0 01  ADD64_IMM16      s4 = s30 +0x1b0
0122  +0x01b30  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0123  +0x01b48  op=58  1e 10 20 00  LD64             s16 = *(uint64_t *)(s30 +0x20)
0124  +0x01b60  op=34  10 00 04 01  OR64             s4 = s16 | s0 ; q1=0xc8
0125  +0x01b78  op=5e  1a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0126  +0x01b90  op=18  00 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0) ; q1=0x12660180 rt/so-mapped
0127  +0x01ba8  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1
0128  +0x01bc0  op=a7  01 00 05 00  BR_NE64          if (s1 != s0) goto record +302 ; q1=0x480000000d
0129  +0x01bd8  op=58  1e 04 10 00  LD64             s4 = *(uint64_t *)(s30 +0x10)
012a  +0x01bf0  op=5e  1a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
012b  +0x01c08  op=18  11 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0) ; q1=0x126b0338 rt/so-mapped
012c  +0x01c20  op=b2  01 01 01 00  AND64_IMM16      s1 = s1 & 0x1 ; q1=0x12627f60 rt/so-mapped
012d  +0x01c38  op=ae  01 00 02 00  BR_EQ64          if (s1 == s0) goto record +304
012e  +0x01c50  op=25  1e 11 e0 03  ST64             *(s30 +0x3e0) = s17 ; q1=0x4900000005
012f  +0x01c68  op=5f  2c 00 00 00  ADD_PC_IMM32     goto record +348 ; vm_pc = current_pc + 1 + 44
0130  +0x01c80  op=58  1e 13 10 00  LD64             s19 = *(uint64_t *)(s30 +0x10) ; q1=0x2cc
0131  +0x01c98  op=85  1e 11 98 01  ADD64_IMM16      s17 = s30 +0x198 ; q1=0x126b0378 rt/so-mapped
0132  +0x01cb0  op=85  00 06 00 00  ADD64_IMM16      s6 = s0 +0x0 ; q1=0x125d72c8 rt/so-mapped
0133  +0x01cc8  op=34  10 00 05 01  OR64             s5 = s16 | s0
0134  +0x01ce0  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x4a00000001
0135  +0x01cf8  op=58  13 01 10 00  LD64             s1 = *(uint64_t *)(s19 +0x10)
0136  +0x01d10  op=25  1e 01 e0 03  ST64             *(s30 +0x3e0) = s1 ; q1=0x2a0
0137  +0x01d28  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0138  +0x01d40  op=58  1e 05 98 01  LD64             s5 = *(uint64_t *)(s30 +0x198) ; q1=0x12627f80 rt/so-mapped
0139  +0x01d58  op=85  1e 04 c8 01  ADD64_IMM16      s4 = s30 +0x1c8
013a  +0x01d70  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped
013b  +0x01d88  op=34  11 00 04 00  OR64             s4 = s17 | s0
013c  +0x01da0  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
013d  +0x01db8  op=58  1e 01 d8 01  LD64             s1 = *(uint64_t *)(s30 +0x1d8) ; q1=0x126b03f8 rt/so-mapped
013e  +0x01dd0  op=85  1e 10 80 01  ADD64_IMM16      s16 = s30 +0x180 ; q1=0x126601c0 rt/so-mapped
013f  +0x01de8  op=58  1e 05 00 00  LD64             s5 = *(uint64_t *)(s30 +0x0)
0140  +0x01e00  op=58  1e 06 08 00  LD64             s6 = *(uint64_t *)(s30 +0x8) ; q1=0x4c0000000c
0141  +0x01e18  op=34  10 00 04 01  OR64             s4 = s16 | s0
0142  +0x01e30  op=25  1e 01 c8 03  ST64             *(s30 +0x3c8) = s1 ; q1=0x18c
0143  +0x01e48  op=52  1e 01 d4 01  LD32S            s1 = *(int32_t *)(s30 +0x1d4) ; q1=0x126b0438 rt/so-mapped
0144  +0x01e60  op=25  1e 01 c0 03  ST64             *(s30 +0x3c0) = s1 ; q1=0x125d72d8 rt/so-mapped
0145  +0x01e78  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0146  +0x01e90  op=85  1e 11 98 01  ADD64_IMM16      s17 = s30 +0x198 ; q1=0x4d00000001
0147  +0x01ea8  op=34  10 00 05 01  OR64             s5 = s16 | s0
0148  +0x01ec0  op=34  13 00 06 01  OR64             s6 = s19 | s0 ; q1=0x160
0149  +0x01ed8  op=34  11 00 04 00  OR64             s4 = s17 | s0 ; q1=0x126b0478 rt/so-mapped
014a  +0x01ef0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
014b  +0x01f08  op=34  10 00 04 01  OR64             s4 = s16 | s0
014c  +0x01f20  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
014d  +0x01f38  op=85  1e 10 80 01  ADD64_IMM16      s16 = s30 +0x180
014e  +0x01f50  op=34  11 00 05 00  OR64             s5 = s17 | s0 ; q1=0xc8
014f  +0x01f68  op=34  10 00 04 01  OR64             s4 = s16 | s0 ; q1=0x126b04b8 rt/so-mapped
0150  +0x01f80  op=5e  6d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0151  +0x01f98  op=85  1e 04 b0 01  ADD64_IMM16      s4 = s30 +0x1b0
0152  +0x01fb0  op=34  10 00 05 01  OR64             s5 = s16 | s0 ; q1=0x4f0000000d
0153  +0x01fc8  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0154  +0x01fe0  op=34  10 00 04 00  OR64             s4 = s16 | s0 ; q1=0x124
0155  +0x01ff8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0156  +0x02010  op=58  1e 01 c0 01  LD64             s1 = *(uint64_t *)(s30 +0x1c0) ; q1=0x12627fa0 rt/so-mapped
0157  +0x02028  op=34  11 00 04 00  OR64             s4 = s17 | s0
0158  +0x02040  op=25  1e 01 d8 03  ST64             *(s30 +0x3d8) = s1 ; q1=0x5000000005
0159  +0x02058  op=52  1e 01 bc 01  LD32S            s1 = *(int32_t *)(s30 +0x1bc)
015a  +0x02070  op=25  1e 01 d0 03  ST64             *(s30 +0x3d0) = s1 ; q1=0x2cc
015b  +0x02088  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
015c  +0x020a0  op=85  1e 10 10 03  ADD64_IMM16      s16 = s30 +0x310 ; q1=0x125d72f8 rt/so-mapped
015d  +0x020b8  op=34  10 00 04 01  OR64             s4 = s16 | s0
015e  +0x020d0  op=5e  1d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
015f  +0x020e8  op=85  00 15 00 00  ADD64_IMM16      s21 = s0 +0x0
0160  +0x02100  op=34  02 00 06 01  OR64             s6 = s2 | s0 ; q1=0x2a0
0161  +0x02118  op=85  1e 04 98 01  ADD64_IMM16      s4 = s30 +0x198 ; q1=0x126b0578 rt/so-mapped
0162  +0x02130  op=34  15 00 05 01  OR64             s5 = s21 | s0 ; q1=0x12627fc0 rt/so-mapped
0163  +0x02148  op=5e  1e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1e] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0164  +0x02160  op=58  1e 05 a8 01  LD64             s5 = *(uint64_t *)(s30 +0x1a8) ; q1=0x5200000005
0165  +0x02178  op=34  10 00 04 01  OR64             s4 = s16 | s0
0166  +0x02190  op=5e  1f 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1f] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0167  +0x021a8  op=53  01 01 4f 00  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x4f ; q1=0x125fd408 rt/so-mapped
0168  +0x021c0  op=59  01 02 08 00  LD8U             s2 = *(uint8_t *)(s1 +0x8) ; q1=0x12660240 rt/so-mapped
0169  +0x021d8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
016a  +0x021f0  op=26  1e 02 78 01  ST8              *(s30 +0x178) = (uint8_t)s2 ; q1=0x530000000c
016b  +0x02208  op=25  1e 01 70 01  ST64             *(s30 +0x170) = s1
016c  +0x02220  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd3c0 rt/so-mapped
016d  +0x02238  op=85  1e 17 08 01  ADD64_IMM16      s23 = s30 +0x108 ; q1=0x126b05f8 rt/so-mapped
016e  +0x02250  op=18  11 02 10 00  SHL32_IMM        s16 = (int32_t)(s2 << 0) ; q1=0x125d7308 rt/so-mapped
016f  +0x02268  op=34  16 00 05 01  OR64             s5 = s22 | s0
0170  +0x02280  op=0e  00 10 01 10  LSR32_IMM        s1 = sign_extend_32((uint32_t)s16 >> 16) ; q1=0x5400000001
0171  +0x02298  op=34  17 00 04 01  OR64             s4 = s23 | s0
0172  +0x022b0  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1 ; q1=0x160
0173  +0x022c8  op=19  1e 01 6c 01  ST16             *(s30 +0x16c) = (uint16_t)s1 ; q1=0x126b0638 rt/so-mapped
0174  +0x022e0  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0175  +0x022f8  op=85  1e 04 70 01  ADD64_IMM16      s4 = s30 +0x170 ; q1=0x125d7320 rt/so-mapped
0176  +0x02310  op=85  00 05 09 00  ADD64_IMM16      s5 = s0 +0x9 ; q1=0x550000000e
0177  +0x02328  op=58  1e 13 08 01  LD64             s19 = *(uint64_t *)(s30 +0x108)
0178  +0x02340  op=5e  20 00 00 00  CALL_CF_INDEX    call native_binding[index=0x20] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0179  +0x02358  op=85  1e 14 50 01  ADD64_IMM16      s20 = s30 +0x150 ; q1=0x126b0678 rt/so-mapped
017a  +0x02370  op=34  02 00 05 01  OR64             s5 = s2 | s0 ; q1=0x12627fe0 rt/so-mapped
017b  +0x02388  op=34  14 00 04 01  OR64             s4 = s20 | s0
017c  +0x023a0  op=5e  08 00 00 00  CALL_CF_INDEX    call native_binding[index=0x8] via q1 table ; q1=0x125fd3c0 rt/so-mapped
017d  +0x023b8  op=85  1e 11 20 01  ADD64_IMM16      s17 = s30 +0x120
017e  +0x023d0  op=34  13 00 05 00  OR64             s5 = s19 | s0 ; q1=0x378
017f  +0x023e8  op=34  14 00 06 01  OR64             s6 = s20 | s0 ; q1=0x126b06b8 rt/so-mapped
0180  +0x02400  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x1267a000 rt/so-mapped
0181  +0x02418  op=5e  21 00 00 00  CALL_CF_INDEX    call native_binding[index=0x21] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0182  +0x02430  op=85  1e 13 38 01  ADD64_IMM16      s19 = s30 +0x138 ; q1=0x5700000005
0183  +0x02448  op=58  1e 05 20 01  LD64             s5 = *(uint64_t *)(s30 +0x120)
0184  +0x02460  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x88
0185  +0x02478  op=5e  22 00 00 00  CALL_CF_INDEX    call native_binding[index=0x22] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0186  +0x02490  op=85  1e 16 80 01  ADD64_IMM16      s22 = s30 +0x180 ; q1=0x1267a020 rt/so-mapped
0187  +0x024a8  op=58  1e 05 38 01  LD64             s5 = *(uint64_t *)(s30 +0x138)
0188  +0x024c0  op=34  16 00 04 01  OR64             s4 = s22 | s0 ; q1=0x5800000011
0189  +0x024d8  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
018a  +0x024f0  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x378
018b  +0x02508  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
018c  +0x02520  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x1267a040 rt/so-mapped
018d  +0x02538  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
018e  +0x02550  op=34  14 00 04 00  OR64             s4 = s20 | s0 ; q1=0x5900000005
018f  +0x02568  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0190  +0x02580  op=34  17 00 04 01  OR64             s4 = s23 | s0 ; q1=0x88
0191  +0x02598  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0192  +0x025b0  op=85  1e 11 38 01  ADD64_IMM16      s17 = s30 +0x138 ; q1=0x1267a060 rt/so-mapped
0193  +0x025c8  op=85  00 13 10 00  ADD64_IMM16      s19 = s0 +0x10
0194  +0x025e0  op=58  1e 05 90 01  LD64             s5 = *(uint64_t *)(s30 +0x190) ; q1=0x5a00000011
0195  +0x025f8  op=34  11 00 04 01  OR64             s4 = s17 | s0
0196  +0x02610  op=34  13 00 06 01  OR64             s6 = s19 | s0 ; q1=0x378
0197  +0x02628  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
0198  +0x02640  op=85  1e 14 20 01  ADD64_IMM16      s20 = s30 +0x120 ; q1=0x1267a080 rt/so-mapped
0199  +0x02658  op=34  11 00 05 00  OR64             s5 = s17 | s0
019a  +0x02670  op=34  15 00 06 00  OR64             s6 = s21 | s0 ; q1=0x5b00000005
019b  +0x02688  op=34  14 00 04 01  OR64             s4 = s20 | s0
019c  +0x026a0  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
019d  +0x026b8  op=58  1e 05 20 01  LD64             s5 = *(uint64_t *)(s30 +0x120) ; q1=0x126b07f8 rt/so-mapped
019e  +0x026d0  op=85  1e 04 50 01  ADD64_IMM16      s4 = s30 +0x150 ; q1=0x1267a0a0 rt/so-mapped
019f  +0x026e8  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01a0  +0x02700  op=34  14 00 04 01  OR64             s4 = s20 | s0 ; q1=0x5c00000011
01a1  +0x02718  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01a2  +0x02730  op=34  11 00 04 00  OR64             s4 = s17 | s0 ; q1=0x378
01a3  +0x02748  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01a4  +0x02760  op=58  1e 01 90 01  LD64             s1 = *(uint64_t *)(s30 +0x190) ; q1=0x1267a0c0 rt/so-mapped
01a5  +0x02778  op=85  1e 11 20 01  ADD64_IMM16      s17 = s30 +0x120
01a6  +0x02790  op=34  13 00 06 01  OR64             s6 = s19 | s0 ; q1=0x5d00000005
01a7  +0x027a8  op=34  11 00 04 00  OR64             s4 = s17 | s0
01a8  +0x027c0  op=85  01 05 10 00  ADD64_IMM16      s5 = s1 +0x10 ; q1=0x88
01a9  +0x027d8  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
01aa  +0x027f0  op=85  1e 13 08 01  ADD64_IMM16      s19 = s30 +0x108 ; q1=0x1267a0e0 rt/so-mapped
01ab  +0x02808  op=34  11 00 05 01  OR64             s5 = s17 | s0
01ac  +0x02820  op=34  15 00 06 00  OR64             s6 = s21 | s0 ; q1=0x5e00000011
01ad  +0x02838  op=34  13 00 04 01  OR64             s4 = s19 | s0
01ae  +0x02850  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01af  +0x02868  op=58  1e 05 08 01  LD64             s5 = *(uint64_t *)(s30 +0x108) ; q1=0x126b08b8 rt/so-mapped
01b0  +0x02880  op=85  1e 04 38 01  ADD64_IMM16      s4 = s30 +0x138 ; q1=0x1267a100 rt/so-mapped
01b1  +0x02898  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01b2  +0x028b0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x5f00000005
01b3  +0x028c8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01b4  +0x028e0  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x88
01b5  +0x028f8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01b6  +0x02910  op=85  1e 11 d8 00  ADD64_IMM16      s17 = s30 +0xd8 ; q1=0x1267a120 rt/so-mapped
01b7  +0x02928  op=85  1e 05 20 01  ADD64_IMM16      s5 = s30 +0x120
01b8  +0x02940  op=85  00 06 04 00  ADD64_IMM16      s6 = s0 +0x4 ; q1=0x6000000011
01b9  +0x02958  op=25  1e 10 20 00  ST64             *(s30 +0x20) = s16
01ba  +0x02970  op=08  1e 10 20 01  ST32             *(s30 +0x120) = (uint32_t)s16 ; q1=0x378
01bb  +0x02988  op=34  11 00 04 00  OR64             s4 = s17 | s0 ; q1=0x126b0938 rt/so-mapped
01bc  +0x029a0  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
01bd  +0x029b8  op=85  1e 13 f0 00  ADD64_IMM16      s19 = s30 +0xf0
01be  +0x029d0  op=34  16 00 05 01  OR64             s5 = s22 | s0 ; q1=0x6100000005
01bf  +0x029e8  op=34  11 00 06 01  OR64             s6 = s17 | s0
01c0  +0x02a00  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x88
01c1  +0x02a18  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01c2  +0x02a30  op=85  1e 14 08 01  ADD64_IMM16      s20 = s30 +0x108 ; q1=0x125d7338 rt/so-mapped
01c3  +0x02a48  op=34  13 00 05 00  OR64             s5 = s19 | s0
01c4  +0x02a60  op=34  16 00 06 01  OR64             s6 = s22 | s0 ; q1=0x6200000001
01c5  +0x02a78  op=34  14 00 04 01  OR64             s4 = s20 | s0
01c6  +0x02a90  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01c7  +0x02aa8  op=85  1e 04 20 01  ADD64_IMM16      s4 = s30 +0x120 ; q1=0x126b09b8 rt/so-mapped
01c8  +0x02ac0  op=34  14 00 05 01  OR64             s5 = s20 | s0 ; q1=0x1267a160 rt/so-mapped
01c9  +0x02ad8  op=5e  6d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01ca  +0x02af0  op=34  14 00 04 01  OR64             s4 = s20 | s0 ; q1=0x6300000005
01cb  +0x02b08  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01cc  +0x02b20  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x12e4
01cd  +0x02b38  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01ce  +0x02b50  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x125d7348 rt/so-mapped
01cf  +0x02b68  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01d0  +0x02b80  op=52  1e 05 8c 01  LD32S            s5 = *(int32_t *)(s30 +0x18c) ; q1=0x6400000001
01d1  +0x02b98  op=58  1e 04 90 01  LD64             s4 = *(uint64_t *)(s30 +0x190)
01d2  +0x02bb0  op=5e  69 00 00 00  CALL_CF_INDEX    call native_binding[index=0x69] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01d3  +0x02bc8  op=85  1e 04 08 01  ADD64_IMM16      s4 = s30 +0x108 ; q1=0x126b0a38 rt/so-mapped
01d4  +0x02be0  op=26  1e 02 d4 00  ST8              *(s30 +0xd4) = (uint8_t)s2 ; q1=0x1267a180 rt/so-mapped
01d5  +0x02bf8  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01d6  +0x02c10  op=34  12 00 04 01  OR64             s4 = s18 | s0 ; q1=0x6500000005
01d7  +0x02c28  op=5e  25 00 00 00  CALL_CF_INDEX    call native_binding[index=0x25] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01d8  +0x02c40  op=52  02 01 00 00  LD32S            s1 = *(int32_t *)(s2 +0x0) ; q1=0x12d4
01d9  +0x02c58  op=b5  00 02 01 00  ADD32_IMM16      s2 = int32(s0 +0x1) ; q1=0x126b0a78 rt/so-mapped
01da  +0x02c70  op=a7  01 02 1a 00  BR_NE64          if (s1 != s2) goto record +501 ; q1=0x125d7358 rt/so-mapped
01db  +0x02c88  op=85  1e 11 f0 00  ADD64_IMM16      s17 = s30 +0xf0
01dc  +0x02ca0  op=58  1e 06 38 00  LD64             s6 = *(uint64_t *)(s30 +0x38) ; q1=0x6600000001
01dd  +0x02cb8  op=85  1e 05 98 01  ADD64_IMM16      s5 = s30 +0x198
01de  +0x02cd0  op=25  1e 00 e0 00  ST64             *(s30 +0xe0) = s0 ; q1=0xfcc
01df  +0x02ce8  op=25  1e 00 d8 00  ST64             *(s30 +0xd8) = s0 ; q1=0x126b0ab8 rt/so-mapped
01e0  +0x02d00  op=34  11 00 04 00  OR64             s4 = s17 | s0 ; q1=0x1267a1a0 rt/so-mapped
01e1  +0x02d18  op=5e  26 00 00 00  CALL_CF_INDEX    call native_binding[index=0x26] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01e2  +0x02d30  op=85  1e 13 d8 00  ADD64_IMM16      s19 = s30 +0xd8 ; q1=0x6700000005
01e3  +0x02d48  op=34  11 00 05 01  OR64             s5 = s17 | s0
01e4  +0x02d60  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x12d0
01e5  +0x02d78  op=5e  27 00 00 00  CALL_CF_INDEX    call native_binding[index=0x27] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01e6  +0x02d90  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x125d7368 rt/so-mapped
01e7  +0x02da8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01e8  +0x02dc0  op=85  1e 11 f0 00  ADD64_IMM16      s17 = s30 +0xf0 ; q1=0x6800000001
01e9  +0x02dd8  op=58  1e 06 d8 00  LD64             s6 = *(uint64_t *)(s30 +0xd8)
01ea  +0x02df0  op=58  1e 05 40 00  LD64             s5 = *(uint64_t *)(s30 +0x40) ; q1=0xff0
01eb  +0x02e08  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x126b0b38 rt/so-mapped
01ec  +0x02e20  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01ed  +0x02e38  op=85  1e 04 08 01  ADD64_IMM16      s4 = s30 +0x108
01ee  +0x02e50  op=34  11 00 05 01  OR64             s5 = s17 | s0 ; q1=0x6900000005
01ef  +0x02e68  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01f0  +0x02e80  op=34  11 00 04 00  OR64             s4 = s17 | s0 ; q1=0x12e4
01f1  +0x02e98  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01f2  +0x02eb0  op=34  13 00 04 00  OR64             s4 = s19 | s0 ; q1=0x125d7378 rt/so-mapped
01f3  +0x02ec8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01f4  +0x02ee0  op=5f  17 00 00 00  ADD_PC_IMM32     goto record +524 ; vm_pc = current_pc + 1 + 23 ; q1=0x6a00000001
01f5  +0x02ef8  op=34  12 00 04 01  OR64             s4 = s18 | s0
01f6  +0x02f10  op=5e  25 00 00 00  CALL_CF_INDEX    call native_binding[index=0x25] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01f7  +0x02f28  op=52  02 01 00 00  LD32S            s1 = *(int32_t *)(s2 +0x0) ; q1=0x126b0bb8 rt/so-mapped
01f8  +0x02f40  op=a7  01 00 13 00  BR_NE64          if (s1 != s0) goto record +524 ; q1=0x1267a1e0 rt/so-mapped
01f9  +0x02f58  op=85  1e 11 f0 00  ADD64_IMM16      s17 = s30 +0xf0
01fa  +0x02f70  op=34  11 00 04 01  OR64             s4 = s17 | s0 ; q1=0x6b00000005
01fb  +0x02f88  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
01fc  +0x02fa0  op=85  1e 04 98 01  ADD64_IMM16      s4 = s30 +0x198 ; q1=0x12e8
01fd  +0x02fb8  op=85  1e 06 20 01  ADD64_IMM16      s6 = s30 +0x120 ; q1=0x126b0bf8 rt/so-mapped
01fe  +0x02fd0  op=34  11 00 05 00  OR64             s5 = s17 | s0 ; q1=0x125d7388 rt/so-mapped
01ff  +0x02fe8  op=5e  28 00 00 00  CALL_CF_INDEX    call native_binding[index=0x28] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0200  +0x03000  op=85  1e 13 d8 00  ADD64_IMM16      s19 = s30 +0xd8 ; q1=0x6c00000001
0201  +0x03018  op=58  1e 05 40 00  LD64             s5 = *(uint64_t *)(s30 +0x40)
0202  +0x03030  op=34  11 00 06 01  OR64             s6 = s17 | s0 ; q1=0xfd4
0203  +0x03048  op=34  13 00 04 01  OR64             s4 = s19 | s0 ; q1=0x126b0c38 rt/so-mapped
0204  +0x03060  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0205  +0x03078  op=85  1e 04 08 01  ADD64_IMM16      s4 = s30 +0x108
0206  +0x03090  op=34  13 00 05 01  OR64             s5 = s19 | s0
0207  +0x030a8  op=5e  06 00 00 00  CALL_CF_INDEX    call native_binding[index=0x6] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF10 copyMemBlockData
0208  +0x030c0  op=34  13 00 04 01  OR64             s4 = s19 | s0
0209  +0x030d8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
020a  +0x030f0  op=34  11 00 04 01  OR64             s4 = s17 | s0
020b  +0x03108  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
020c  +0x03120  op=85  1e 04 6c 01  ADD64_IMM16      s4 = s30 +0x16c
020d  +0x03138  op=85  00 05 02 00  ADD64_IMM16      s5 = s0 +0x2
020e  +0x03150  op=5e  69 00 00 00  CALL_CF_INDEX    call native_binding[index=0x69] via q1 table ; q1=0x125fd3c0 rt/so-mapped
020f  +0x03168  op=18  11 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0)
0210  +0x03180  op=52  1e 06 14 01  LD32S            s6 = *(int32_t *)(s30 +0x114)
0211  +0x03198  op=85  1e 04 f0 00  ADD64_IMM16      s4 = s30 +0xf0
0212  +0x031b0  op=34  15 00 05 01  OR64             s5 = s21 | s0
0213  +0x031c8  op=00  01 01 01 03  REV16_32         s1 = sign_extend_32(rev16((uint32_t)s1))
0214  +0x031e0  op=2e  12 01 01 10  ROR32_IMM        s1 = ror32((uint32_t)s1, 16)
0215  +0x031f8  op=08  1e 01 d0 00  ST32             *(s30 +0xd0) = (uint32_t)s1
0216  +0x03210  op=5e  1e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1e] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0217  +0x03228  op=52  1e 01 14 01  LD32S            s1 = *(int32_t *)(s30 +0x114)
0218  +0x03240  op=85  1e 04 d0 00  ADD64_IMM16      s4 = s30 +0xd0
0219  +0x03258  op=15  01 02 01 00  CMP_LT_IMM64S    s2 = ((int64_t)s1 < 1) ? 1 : 0
021a  +0x03270  op=b5  01 03 ff ff  ADD32_IMM16      s3 = int32(s1 -0x1)
021b  +0x03288  op=1f  01 02 02 00  CMOVZ64          s2 = (s2 == 0) ? s1 : 0
021c  +0x032a0  op=6d  00 02 02 00  SHL64_IMM32PLUS  s2 = s2 << (0 + 32)
021d  +0x032b8  op=67  00 02 02 00  LSR64_IMM32PLUS  s2 = (uint64_t)s2 >> (0 + 32)
021e  +0x032d0  op=ae  02 15 0e 00  BR_EQ64          if (s2 == s21) goto record +557
021f  +0x032e8  op=58  1e 05 18 01  LD64             s5 = *(uint64_t *)(s30 +0x118)
0220  +0x03300  op=18  00 03 01 00  SHL32_IMM        s1 = (int32_t)(s3 << 0)
0221  +0x03318  op=b5  03 03 ff ff  ADD32_IMM16      s3 = int32(s3 -0x1)
0222  +0x03330  op=84  05 01 01 00  ADD64            s1 = s5 + s1
0223  +0x03348  op=b2  15 05 03 00  AND64_IMM16      s5 = s21 & 0x3
0224  +0x03360  op=34  04 05 05 01  OR64             s5 = s4 | s5
0225  +0x03378  op=59  01 01 00 00  LD8U             s1 = *(uint8_t *)(s1 +0x0)
0226  +0x03390  op=59  05 05 00 00  LD8U             s5 = *(uint8_t *)(s5 +0x0)
0227  +0x033a8  op=02  05 01 01 01  XOR64            s1 = s1 ^ s5
0228  +0x033c0  op=58  1e 05 00 01  LD64             s5 = *(uint64_t *)(s30 +0x100)
0229  +0x033d8  op=84  05 15 05 00  ADD64            s5 = s5 + s21
022a  +0x033f0  op=85  15 15 01 00  ADD64_IMM16      s21 = s21 +0x1
022b  +0x03408  op=26  05 01 00 00  ST8              *(s5 +0x0) = (uint8_t)s1
022c  +0x03420  op=a7  02 15 f2 ff  BR_NE64          if (s2 != s21) goto record +543
022d  +0x03438  op=58  1e 01 08 03  LD64             s1 = *(uint64_t *)(s30 +0x308)
022e  +0x03450  op=34  12 00 04 01  OR64             s4 = s18 | s0
022f  +0x03468  op=59  01 10 00 00  LD8U             s16 = *(uint8_t *)(s1 +0x0)
0230  +0x03480  op=58  1e 01 f0 02  LD64             s1 = *(uint64_t *)(s30 +0x2f0)
0231  +0x03498  op=59  01 11 00 00  LD8U             s17 = *(uint8_t *)(s1 +0x0)
0232  +0x034b0  op=5e  25 00 00 00  CALL_CF_INDEX    call native_binding[index=0x25] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0233  +0x034c8  op=52  02 01 00 00  LD32S            s1 = *(int32_t *)(s2 +0x0)
0234  +0x034e0  op=b2  11 02 3f 00  AND64_IMM16      s2 = s17 & 0x3f
0235  +0x034f8  op=b2  10 03 3f 00  AND64_IMM16      s3 = s16 & 0x3f
0236  +0x03510  op=85  00 04 03 00  ADD64_IMM16      s4 = s0 +0x3
0237  +0x03528  op=85  00 11 01 00  ADD64_IMM16      s17 = s0 +0x1
0238  +0x03540  op=85  1e 15 80 00  ADD64_IMM16      s21 = s30 +0x80
0239  +0x03558  op=85  1e 13 d4 00  ADD64_IMM16      s19 = s30 +0xd4
023a  +0x03570  op=6d  00 02 02 08  SHL64_IMM32PLUS  s2 = s2 << (8 + 32)
023b  +0x03588  op=6d  00 03 03 0e  SHL64_IMM32PLUS  s3 = s3 << (14 + 32)
023c  +0x035a0  op=6d  00 04 10 1b  SHL64_IMM32PLUS  s16 = s4 << (27 + 32)
023d  +0x035b8  op=6d  00 11 04 01  SHL64_IMM32PLUS  s4 = s17 << (1 + 32)
023e  +0x035d0  op=01  01 01 01 00  XOR_IMM16        s1 = s1 ^ 0x1
023f  +0x035e8  op=34  03 02 02 00  OR64             s2 = s3 | s2
0240  +0x03600  op=6d  00 11 03 00  SHL64_IMM32PLUS  s3 = s17 << (0 + 32)
0241  +0x03618  op=18  00 01 01 00  SHL32_IMM        s1 = (int32_t)(s1 << 0)
0242  +0x03630  op=85  03 12 ff ff  ADD64_IMM16      s18 = s3 -0x1
0243  +0x03648  op=1e  03 01 03 11  CMOVNZ64         s3 = (s1 != 0) ? s3 : 0
0244  +0x03660  op=1f  04 01 01 00  CMOVZ64          s1 = (s1 == 0) ? s4 : 0
0245  +0x03678  op=34  01 03 01 01  OR64             s1 = s1 | s3
0246  +0x03690  op=34  02 01 14 00  OR64             s20 = s2 | s1
0247  +0x036a8  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0248  +0x036c0  op=b3  02 12 01 00  AND64            s1 = s2 & s18
0249  +0x036d8  op=34  15 00 04 01  OR64             s4 = s21 | s0
024a  +0x036f0  op=34  13 00 05 01  OR64             s5 = s19 | s0
024b  +0x03708  op=34  11 00 06 01  OR64             s6 = s17 | s0
024c  +0x03720  op=34  14 01 01 00  OR64             s1 = s20 | s1
024d  +0x03738  op=34  01 10 01 01  OR64             s1 = s1 | s16
024e  +0x03750  op=25  1e 01 c8 00  ST64             *(s30 +0xc8) = s1
024f  +0x03768  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
0250  +0x03780  op=85  1e 16 68 00  ADD64_IMM16      s22 = s30 +0x68
0251  +0x03798  op=85  1e 05 c8 00  ADD64_IMM16      s5 = s30 +0xc8
0252  +0x037b0  op=85  00 06 08 00  ADD64_IMM16      s6 = s0 +0x8
0253  +0x037c8  op=34  16 00 04 01  OR64             s4 = s22 | s0
0254  +0x037e0  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
0255  +0x037f8  op=85  1e 17 98 00  ADD64_IMM16      s23 = s30 +0x98
0256  +0x03810  op=34  15 00 05 01  OR64             s5 = s21 | s0
0257  +0x03828  op=34  16 00 06 01  OR64             s6 = s22 | s0
0258  +0x03840  op=34  17 00 04 01  OR64             s4 = s23 | s0
0259  +0x03858  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
025a  +0x03870  op=85  1e 10 b0 00  ADD64_IMM16      s16 = s30 +0xb0
025b  +0x03888  op=85  1e 06 f0 00  ADD64_IMM16      s6 = s30 +0xf0
025c  +0x038a0  op=34  17 00 05 00  OR64             s5 = s23 | s0
025d  +0x038b8  op=34  10 00 04 01  OR64             s4 = s16 | s0
025e  +0x038d0  op=25  1e 06 40 00  ST64             *(s30 +0x40) = s6
025f  +0x038e8  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0260  +0x03900  op=85  1e 14 50 00  ADD64_IMM16      s20 = s30 +0x50
0261  +0x03918  op=58  1e 05 18 00  LD64             s5 = *(uint64_t *)(s30 +0x18)
0262  +0x03930  op=34  14 00 04 01  OR64             s4 = s20 | s0
0263  +0x03948  op=5e  29 00 00 00  CALL_CF_INDEX    call native_binding[index=0x29] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0264  +0x03960  op=85  1e 11 d8 00  ADD64_IMM16      s17 = s30 +0xd8
0265  +0x03978  op=34  10 00 05 00  OR64             s5 = s16 | s0
0266  +0x03990  op=34  14 00 06 01  OR64             s6 = s20 | s0
0267  +0x039a8  op=34  11 00 04 00  OR64             s4 = s17 | s0
0268  +0x039c0  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0269  +0x039d8  op=34  14 00 04 01  OR64             s4 = s20 | s0
026a  +0x039f0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
026b  +0x03a08  op=34  10 00 04 00  OR64             s4 = s16 | s0
026c  +0x03a20  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
026d  +0x03a38  op=34  17 00 04 01  OR64             s4 = s23 | s0
026e  +0x03a50  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
026f  +0x03a68  op=34  16 00 04 00  OR64             s4 = s22 | s0
0270  +0x03a80  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0271  +0x03a98  op=34  15 00 04 01  OR64             s4 = s21 | s0
0272  +0x03ab0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0273  +0x03ac8  op=85  1e 10 98 00  ADD64_IMM16      s16 = s30 +0x98
0274  +0x03ae0  op=85  1e 15 50 01  ADD64_IMM16      s21 = s30 +0x150
0275  +0x03af8  op=85  1e 16 38 01  ADD64_IMM16      s22 = s30 +0x138
0276  +0x03b10  op=b5  00 01 01 00  ADD32_IMM16      s1 = int32(s0 +0x1)
0277  +0x03b28  op=85  1e 08 80 00  ADD64_IMM16      s8 = s30 +0x80
0278  +0x03b40  op=34  11 00 05 01  OR64             s5 = s17 | s0
0279  +0x03b58  op=34  10 00 04 01  OR64             s4 = s16 | s0
027a  +0x03b70  op=34  15 00 06 01  OR64             s6 = s21 | s0
027b  +0x03b88  op=34  16 00 07 01  OR64             s7 = s22 | s0
027c  +0x03ba0  op=08  1e 01 80 00  ST32             *(s30 +0x80) = (uint32_t)s1
027d  +0x03bb8  op=5e  2a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
027e  +0x03bd0  op=85  1e 17 b0 00  ADD64_IMM16      s23 = s30 +0xb0
027f  +0x03be8  op=58  1e 05 98 00  LD64             s5 = *(uint64_t *)(s30 +0x98)
0280  +0x03c00  op=34  17 00 04 01  OR64             s4 = s23 | s0
0281  +0x03c18  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0282  +0x03c30  op=34  10 00 04 01  OR64             s4 = s16 | s0
0283  +0x03c48  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0284  +0x03c60  op=85  1e 14 68 00  ADD64_IMM16      s20 = s30 +0x68
0285  +0x03c78  op=58  1e 05 20 00  LD64             s5 = *(uint64_t *)(s30 +0x20)
0286  +0x03c90  op=34  14 00 04 01  OR64             s4 = s20 | s0
0287  +0x03ca8  op=5e  29 00 00 00  CALL_CF_INDEX    call native_binding[index=0x29] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0288  +0x03cc0  op=85  1e 12 80 00  ADD64_IMM16      s18 = s30 +0x80
0289  +0x03cd8  op=34  14 00 05 01  OR64             s5 = s20 | s0
028a  +0x03cf0  op=34  17 00 06 00  OR64             s6 = s23 | s0
028b  +0x03d08  op=34  12 00 04 01  OR64             s4 = s18 | s0
028c  +0x03d20  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
028d  +0x03d38  op=85  1e 13 50 00  ADD64_IMM16      s19 = s30 +0x50
028e  +0x03d50  op=34  12 00 05 01  OR64             s5 = s18 | s0
028f  +0x03d68  op=34  13 00 04 00  OR64             s4 = s19 | s0
0290  +0x03d80  op=5e  2b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2b] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF44 base64Encode
0291  +0x03d98  op=85  1e 10 98 00  ADD64_IMM16      s16 = s30 +0x98
0292  +0x03db0  op=58  1e 05 50 00  LD64             s5 = *(uint64_t *)(s30 +0x50)
0293  +0x03dc8  op=34  10 00 04 00  OR64             s4 = s16 | s0
0294  +0x03de0  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0295  +0x03df8  op=34  13 00 04 01  OR64             s4 = s19 | s0
0296  +0x03e10  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0297  +0x03e28  op=34  12 00 04 01  OR64             s4 = s18 | s0
0298  +0x03e40  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0299  +0x03e58  op=34  14 00 04 01  OR64             s4 = s20 | s0
029a  +0x03e70  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
029b  +0x03e88  op=58  1e 03 48 00  LD64             s3 = *(uint64_t *)(s30 +0x48)
029c  +0x03ea0  op=54  02 01 b5 05  CONST_HI16       s1 = sign_extend_32(0x5b5 << 16)
029d  +0x03eb8  op=85  00 13 03 00  ADD64_IMM16      s19 = s0 +0x3
029e  +0x03ed0  op=85  1e 04 50 00  ADD64_IMM16      s4 = s30 +0x50
029f  +0x03ee8  op=85  01 01 a9 86  ADD64_IMM16      s1 = s1 -0x7957
02a0  +0x03f00  op=34  13 00 05 01  OR64             s5 = s19 | s0
02a1  +0x03f18  op=59  03 02 5e 01  LD8U             s2 = *(uint8_t *)(s3 +0x15e)
02a2  +0x03f30  op=6e  12 01 01 11  SHL64_IMM        s1 = s1 << 17
02a3  +0x03f48  op=85  01 01 5d 79  ADD64_IMM16      s1 = s1 +0x795d
02a4  +0x03f60  op=26  1e 02 6a 00  ST8              *(s30 +0x6a) = (uint8_t)s2
02a5  +0x03f78  op=6e  02 01 01 14  SHL64_IMM        s1 = s1 << 20
02a6  +0x03f90  op=55  03 02 5c 01  LD16U            s2 = *(uint16_t *)(s3 +0x15c)
02a7  +0x03fa8  op=85  01 01 ed 0d  ADD64_IMM16      s1 = s1 +0xded
02a8  +0x03fc0  op=19  1e 02 68 00  ST16             *(s30 +0x68) = (uint16_t)s2
02a9  +0x03fd8  op=59  03 02 f8 00  LD8U             s2 = *(uint8_t *)(s3 +0xf8)
02aa  +0x03ff0  op=26  1e 02 52 00  ST8              *(s30 +0x52) = (uint8_t)s2
02ab  +0x04008  op=55  03 02 f6 00  LD16U            s2 = *(uint16_t *)(s3 +0xf6)
02ac  +0x04020  op=25  1e 01 80 00  ST64             *(s30 +0x80) = s1
02ad  +0x04038  op=19  1e 02 50 00  ST16             *(s30 +0x50) = (uint16_t)s2
02ae  +0x04050  op=5e  2c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02af  +0x04068  op=85  1e 04 80 00  ADD64_IMM16      s4 = s30 +0x80
02b0  +0x04080  op=85  00 05 08 00  ADD64_IMM16      s5 = s0 +0x8
02b1  +0x04098  op=34  02 00 12 01  OR64             s18 = s2 | s0
02b2  +0x040b0  op=5e  2d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02b3  +0x040c8  op=58  1e 04 28 00  LD64             s4 = *(uint64_t *)(s30 +0x28)
02b4  +0x040e0  op=34  02 00 06 01  OR64             s6 = s2 | s0
02b5  +0x040f8  op=34  12 00 05 01  OR64             s5 = s18 | s0
02b6  +0x04110  op=5e  2e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2e] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF98 formatAllocString
02b7  +0x04128  op=85  1e 04 68 00  ADD64_IMM16      s4 = s30 +0x68
02b8  +0x04140  op=34  13 00 05 00  OR64             s5 = s19 | s0
02b9  +0x04158  op=5e  2f 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2f] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02ba  +0x04170  op=58  1e 06 a8 00  LD64             s6 = *(uint64_t *)(s30 +0xa8)
02bb  +0x04188  op=58  1e 04 30 00  LD64             s4 = *(uint64_t *)(s30 +0x30)
02bc  +0x041a0  op=34  02 00 05 01  OR64             s5 = s2 | s0
02bd  +0x041b8  op=5e  2e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2e] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF98 formatAllocString
02be  +0x041d0  op=34  10 00 04 01  OR64             s4 = s16 | s0
02bf  +0x041e8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02c0  +0x04200  op=34  17 00 04 01  OR64             s4 = s23 | s0
02c1  +0x04218  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02c2  +0x04230  op=34  11 00 04 00  OR64             s4 = s17 | s0
02c3  +0x04248  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02c4  +0x04260  op=58  1e 04 40 00  LD64             s4 = *(uint64_t *)(s30 +0x40)
02c5  +0x04278  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02c6  +0x04290  op=85  1e 04 08 01  ADD64_IMM16      s4 = s30 +0x108
02c7  +0x042a8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02c8  +0x042c0  op=85  1e 04 20 01  ADD64_IMM16      s4 = s30 +0x120
02c9  +0x042d8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02ca  +0x042f0  op=34  16 00 04 01  OR64             s4 = s22 | s0
02cb  +0x04308  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02cc  +0x04320  op=34  15 00 04 00  OR64             s4 = s21 | s0
02cd  +0x04338  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02ce  +0x04350  op=85  1e 04 80 01  ADD64_IMM16      s4 = s30 +0x180
02cf  +0x04368  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02d0  +0x04380  op=85  1e 04 98 01  ADD64_IMM16      s4 = s30 +0x198
02d1  +0x04398  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02d2  +0x043b0  op=85  1e 04 b0 01  ADD64_IMM16      s4 = s30 +0x1b0
02d3  +0x043c8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02d4  +0x043e0  op=85  1e 04 c8 01  ADD64_IMM16      s4 = s30 +0x1c8
02d5  +0x043f8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02d6  +0x04410  op=85  1e 04 10 02  ADD64_IMM16      s4 = s30 +0x210
02d7  +0x04428  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02d8  +0x04440  op=85  1e 04 20 02  ADD64_IMM16      s4 = s30 +0x220
02d9  +0x04458  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02da  +0x04470  op=85  1e 04 60 02  ADD64_IMM16      s4 = s30 +0x260
02db  +0x04488  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02dc  +0x044a0  op=85  1e 04 78 02  ADD64_IMM16      s4 = s30 +0x278
02dd  +0x044b8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02de  +0x044d0  op=85  1e 04 88 02  ADD64_IMM16      s4 = s30 +0x288
02df  +0x044e8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02e0  +0x04500  op=85  1e 04 98 02  ADD64_IMM16      s4 = s30 +0x298
02e1  +0x04518  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02e2  +0x04530  op=85  1e 04 b8 02  ADD64_IMM16      s4 = s30 +0x2b8
02e3  +0x04548  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02e4  +0x04560  op=85  1e 04 c8 02  ADD64_IMM16      s4 = s30 +0x2c8
02e5  +0x04578  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02e6  +0x04590  op=85  1e 04 e0 02  ADD64_IMM16      s4 = s30 +0x2e0
02e7  +0x045a8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02e8  +0x045c0  op=85  1e 04 f8 02  ADD64_IMM16      s4 = s30 +0x2f8
02e9  +0x045d8  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
02ea  +0x045f0  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
02eb  +0x04608  op=58  1d 10 f0 03  LD64             s16 = *(uint64_t *)(s29 +0x3f0)
02ec  +0x04620  op=58  1d 11 f8 03  LD64             s17 = *(uint64_t *)(s29 +0x3f8)
02ed  +0x04638  op=58  1d 12 00 04  LD64             s18 = *(uint64_t *)(s29 +0x400)
02ee  +0x04650  op=58  1d 13 08 04  LD64             s19 = *(uint64_t *)(s29 +0x408)
02ef  +0x04668  op=58  1d 14 10 04  LD64             s20 = *(uint64_t *)(s29 +0x410)
02f0  +0x04680  op=58  1d 15 18 04  LD64             s21 = *(uint64_t *)(s29 +0x418)
02f1  +0x04698  op=58  1d 16 20 04  LD64             s22 = *(uint64_t *)(s29 +0x420)
02f2  +0x046b0  op=58  1d 17 28 04  LD64             s23 = *(uint64_t *)(s29 +0x428)
02f3  +0x046c8  op=58  1d 1e 30 04  LD64             s30 = *(uint64_t *)(s29 +0x430)
02f4  +0x046e0  op=58  1d 1f 38 04  LD64             s31 = *(uint64_t *)(s29 +0x438)
02f5  +0x046f8  op=85  1d 1d 40 04  ADD64_IMM16      s29 = s29 +0x440
02f6  +0x04710  op=5b  1f 00 00 00  RET              return/leave with s31

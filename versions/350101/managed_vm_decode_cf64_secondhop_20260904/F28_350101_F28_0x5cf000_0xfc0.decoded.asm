; MetaSec managed bytecode decode: F28
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F28_0x5cf000_0xfc0.bin
; records: 168  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d 70 ff  ADD64_IMM16      s29 = s29 -0x90
0001  +0x00018  op=25  1d 1f 88 00  ST64             *(s29 +0x88) = s31
0002  +0x00030  op=25  1d 1e 80 00  ST64             *(s29 +0x80) = s30
0003  +0x00048  op=25  1d 17 78 00  ST64             *(s29 +0x78) = s23
0004  +0x00060  op=25  1d 16 70 00  ST64             *(s29 +0x70) = s22
0005  +0x00078  op=25  1d 15 68 00  ST64             *(s29 +0x68) = s21
0006  +0x00090  op=25  1d 14 60 00  ST64             *(s29 +0x60) = s20
0007  +0x000a8  op=25  1d 13 58 00  ST64             *(s29 +0x58) = s19
0008  +0x000c0  op=25  1d 12 50 00  ST64             *(s29 +0x50) = s18
0009  +0x000d8  op=25  1d 11 48 00  ST64             *(s29 +0x48) = s17
000a  +0x000f0  op=25  1d 10 40 00  ST64             *(s29 +0x40) = s16
000b  +0x00108  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
000c  +0x00120  op=53  01 01 68 0f  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0xf68 ; q1=0x125fd3a8 rt/so-mapped
000d  +0x00138  op=53  01 02 58 0f  LD_POOL_PTR      s2 = *(uint64_t *)q1 + 0xf58 ; q1=0x125fd3a8 rt/so-mapped
000e  +0x00150  op=53  04 03 48 0f  LD_POOL_PTR      s3 = *(uint64_t *)q1 + 0xf48 ; q1=0x125fd3a8 rt/so-mapped
000f  +0x00168  op=53  04 05 28 0f  LD_POOL_PTR      s5 = *(uint64_t *)q1 + 0xf28 ; q1=0x125fd3a8 rt/so-mapped
0010  +0x00180  op=34  04 00 10 00  OR64             s16 = s4 | s0
0011  +0x00198  op=53  03 04 38 0f  LD_POOL_PTR      s4 = *(uint64_t *)q1 + 0xf38 ; q1=0x125fd3a8 rt/so-mapped
0012  +0x001b0  op=53  03 06 18 0f  LD_POOL_PTR      s6 = *(uint64_t *)q1 + 0xf18 ; q1=0x125fd3a8 rt/so-mapped
0013  +0x001c8  op=53  03 07 08 0f  LD_POOL_PTR      s7 = *(uint64_t *)q1 + 0xf08 ; q1=0x125fd3a8 rt/so-mapped
0014  +0x001e0  op=53  03 08 78 0c  LD_POOL_PTR      s8 = *(uint64_t *)q1 + 0xc78 ; q1=0x125fd3a8 rt/so-mapped
0015  +0x001f8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0016  +0x00210  op=58  05 14 00 00  LD64             s20 = *(uint64_t *)(s5 +0x0)
0017  +0x00228  op=58  03 03 00 00  LD64             s3 = *(uint64_t *)(s3 +0x0)
0018  +0x00240  op=58  02 02 00 00  LD64             s2 = *(uint64_t *)(s2 +0x0)
0019  +0x00258  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
001a  +0x00270  op=58  06 15 00 00  LD64             s21 = *(uint64_t *)(s6 +0x0)
001b  +0x00288  op=58  08 12 00 00  LD64             s18 = *(uint64_t *)(s8 +0x0)
001c  +0x002a0  op=58  07 16 00 00  LD64             s22 = *(uint64_t *)(s7 +0x0)
001d  +0x002b8  op=58  04 13 00 00  LD64             s19 = *(uint64_t *)(s4 +0x0)
001e  +0x002d0  op=34  05 00 06 01  OR64             s6 = s5 | s0
001f  +0x002e8  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1
0020  +0x00300  op=53  04 01 78 0f  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0xf78 ; q1=0x125fd3a8 rt/so-mapped
0021  +0x00318  op=25  1e 03 08 00  ST64             *(s30 +0x8) = s3
0022  +0x00330  op=25  1e 02 10 00  ST64             *(s30 +0x10) = s2
0023  +0x00348  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0024  +0x00360  op=25  1e 01 20 00  ST64             *(s30 +0x20) = s1
0025  +0x00378  op=53  01 01 88 0f  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0xf88 ; q1=0x125fd3a8 rt/so-mapped
0026  +0x00390  op=58  01 17 00 00  LD64             s23 = *(uint64_t *)(s1 +0x0)
0027  +0x003a8  op=53  03 01 98 0f  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0xf98 ; q1=0x125fd3a8 rt/so-mapped
0028  +0x003c0  op=58  01 11 00 00  LD64             s17 = *(uint64_t *)(s1 +0x0)
0029  +0x003d8  op=34  11 00 04 01  OR64             s4 = s17 | s0
002a  +0x003f0  op=5e  0f 00 00 00  CALL_CF_INDEX    call native_binding[index=0xf] via q1 table ; q1=0x125fd360 rt/so-mapped
002b  +0x00408  op=b2  02 01 01 00  AND64_IMM16      s1 = s2 & 0x1
002c  +0x00420  op=ae  01 00 6c 00  BR_EQ64          if (s1 == s0) goto record +153
002d  +0x00438  op=58  16 01 00 00  LD64             s1 = *(uint64_t *)(s22 +0x0)
002e  +0x00450  op=a7  01 00 48 00  BR_NE64          if (s1 != s0) goto record +119
002f  +0x00468  op=58  17 01 00 00  LD64             s1 = *(uint64_t *)(s23 +0x0)
0030  +0x00480  op=85  12 02 10 00  ADD64_IMM16      s2 = s18 +0x10
0031  +0x00498  op=85  01 04 08 00  ADD64_IMM16      s4 = s1 +0x8
0032  +0x004b0  op=25  1e 01 30 00  ST64             *(s30 +0x30) = s1
0033  +0x004c8  op=25  1e 02 28 00  ST64             *(s30 +0x28) = s2
0034  +0x004e0  op=5e  10 00 00 00  CALL_CF_INDEX    call native_binding[index=0x10] via q1 table ; q1=0x125fd360 rt/so-mapped
0035  +0x004f8  op=08  1e 02 38 00  ST32             *(s30 +0x38) = (uint32_t)s2
0036  +0x00510  op=58  16 01 00 00  LD64             s1 = *(uint64_t *)(s22 +0x0)
0037  +0x00528  op=a7  01 00 3d 00  BR_NE64          if (s1 != s0) goto record +117
0038  +0x00540  op=85  00 12 00 08  ADD64_IMM16      s18 = s0 +0x800
0039  +0x00558  op=34  12 00 04 00  OR64             s4 = s18 | s0
003a  +0x00570  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
003b  +0x00588  op=34  02 00 04 01  OR64             s4 = s2 | s0
003c  +0x005a0  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
003d  +0x005b8  op=34  12 00 06 00  OR64             s6 = s18 | s0
003e  +0x005d0  op=25  1e 02 00 00  ST64             *(s30 +0x0) = s2
003f  +0x005e8  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd360 rt/so-mapped
0040  +0x00600  op=34  12 00 04 00  OR64             s4 = s18 | s0
0041  +0x00618  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
0042  +0x00630  op=34  12 00 04 01  OR64             s4 = s18 | s0
0043  +0x00648  op=25  15 02 00 00  ST64             *(s21 +0x0) = s2
0044  +0x00660  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
0045  +0x00678  op=34  12 00 04 01  OR64             s4 = s18 | s0
0046  +0x00690  op=25  14 02 00 00  ST64             *(s20 +0x0) = s2
0047  +0x006a8  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
0048  +0x006c0  op=34  12 00 04 01  OR64             s4 = s18 | s0
0049  +0x006d8  op=25  13 02 00 00  ST64             *(s19 +0x0) = s2
004a  +0x006f0  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
004b  +0x00708  op=58  1e 17 08 00  LD64             s23 = *(uint64_t *)(s30 +0x8)
004c  +0x00720  op=34  12 00 04 00  OR64             s4 = s18 | s0
004d  +0x00738  op=25  17 02 00 00  ST64             *(s23 +0x0) = s2
004e  +0x00750  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
004f  +0x00768  op=58  1e 11 10 00  LD64             s17 = *(uint64_t *)(s30 +0x10)
0050  +0x00780  op=34  12 00 04 01  OR64             s4 = s18 | s0
0051  +0x00798  op=25  11 02 00 00  ST64             *(s17 +0x0) = s2
0052  +0x007b0  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
0053  +0x007c8  op=58  1e 01 18 00  LD64             s1 = *(uint64_t *)(s30 +0x18)
0054  +0x007e0  op=34  12 00 04 01  OR64             s4 = s18 | s0
0055  +0x007f8  op=25  01 02 00 00  ST64             *(s1 +0x0) = s2
0056  +0x00810  op=5e  11 00 00 00  CALL_CF_INDEX    call native_binding[index=0x11] via q1 table ; q1=0x125fd360 rt/so-mapped
0057  +0x00828  op=58  1e 12 00 00  LD64             s18 = *(uint64_t *)(s30 +0x0)
0058  +0x00840  op=58  1e 01 20 00  LD64             s1 = *(uint64_t *)(s30 +0x20)
0059  +0x00858  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
005a  +0x00870  op=34  12 00 04 01  OR64             s4 = s18 | s0
005b  +0x00888  op=25  01 02 00 00  ST64             *(s1 +0x0) = s2
005c  +0x008a0  op=5e  60 00 00 00  CALL_CF_INDEX    call native_binding[index=0x60] via q1 table ; q1=0x125fd360 rt/so-mapped
005d  +0x008b8  op=58  15 05 00 00  LD64             s5 = *(uint64_t *)(s21 +0x0)
005e  +0x008d0  op=34  12 00 04 01  OR64             s4 = s18 | s0
005f  +0x008e8  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0060  +0x00900  op=58  14 05 00 00  LD64             s5 = *(uint64_t *)(s20 +0x0)
0061  +0x00918  op=58  15 04 00 00  LD64             s4 = *(uint64_t *)(s21 +0x0)
0062  +0x00930  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0063  +0x00948  op=58  13 05 00 00  LD64             s5 = *(uint64_t *)(s19 +0x0)
0064  +0x00960  op=58  14 04 00 00  LD64             s4 = *(uint64_t *)(s20 +0x0)
0065  +0x00978  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0066  +0x00990  op=58  17 05 00 00  LD64             s5 = *(uint64_t *)(s23 +0x0)
0067  +0x009a8  op=58  13 04 00 00  LD64             s4 = *(uint64_t *)(s19 +0x0)
0068  +0x009c0  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0069  +0x009d8  op=58  11 05 00 00  LD64             s5 = *(uint64_t *)(s17 +0x0)
006a  +0x009f0  op=58  17 04 00 00  LD64             s4 = *(uint64_t *)(s23 +0x0)
006b  +0x00a08  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
006c  +0x00a20  op=58  1e 17 18 00  LD64             s23 = *(uint64_t *)(s30 +0x18)
006d  +0x00a38  op=58  11 04 00 00  LD64             s4 = *(uint64_t *)(s17 +0x0)
006e  +0x00a50  op=58  17 05 00 00  LD64             s5 = *(uint64_t *)(s23 +0x0)
006f  +0x00a68  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0070  +0x00a80  op=58  1e 01 20 00  LD64             s1 = *(uint64_t *)(s30 +0x20)
0071  +0x00a98  op=58  17 04 00 00  LD64             s4 = *(uint64_t *)(s23 +0x0)
0072  +0x00ab0  op=58  01 05 00 00  LD64             s5 = *(uint64_t *)(s1 +0x0)
0073  +0x00ac8  op=5e  61 00 00 00  CALL_CF_INDEX    call native_binding[index=0x61] via q1 table ; q1=0x125fd360 rt/so-mapped
0074  +0x00ae0  op=25  16 12 00 00  ST64             *(s22 +0x0) = s18
0075  +0x00af8  op=85  1e 04 28 00  ADD64_IMM16      s4 = s30 +0x28
0076  +0x00b10  op=5e  12 00 00 00  CALL_CF_INDEX    call native_binding[index=0x12] via q1 table ; q1=0x125fd360 rt/so-mapped
0077  +0x00b28  op=ae  10 00 14 00  BR_EQ64          if (s16 == s0) goto record +140
0078  +0x00b40  op=58  16 01 00 00  LD64             s1 = *(uint64_t *)(s22 +0x0)
0079  +0x00b58  op=25  10 01 a8 00  ST64             *(s16 +0xa8) = s1
007a  +0x00b70  op=58  15 01 00 00  LD64             s1 = *(uint64_t *)(s21 +0x0)
007b  +0x00b88  op=25  10 01 b0 00  ST64             *(s16 +0xb0) = s1
007c  +0x00ba0  op=58  14 01 00 00  LD64             s1 = *(uint64_t *)(s20 +0x0)
007d  +0x00bb8  op=25  10 01 b8 00  ST64             *(s16 +0xb8) = s1
007e  +0x00bd0  op=58  13 01 00 00  LD64             s1 = *(uint64_t *)(s19 +0x0)
007f  +0x00be8  op=25  10 01 c0 00  ST64             *(s16 +0xc0) = s1
0080  +0x00c00  op=58  1e 01 08 00  LD64             s1 = *(uint64_t *)(s30 +0x8)
0081  +0x00c18  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0082  +0x00c30  op=25  10 01 c8 00  ST64             *(s16 +0xc8) = s1
0083  +0x00c48  op=58  1e 01 10 00  LD64             s1 = *(uint64_t *)(s30 +0x10)
0084  +0x00c60  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0085  +0x00c78  op=25  10 01 d0 00  ST64             *(s16 +0xd0) = s1
0086  +0x00c90  op=58  1e 01 18 00  LD64             s1 = *(uint64_t *)(s30 +0x18)
0087  +0x00ca8  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
0088  +0x00cc0  op=25  10 01 d8 00  ST64             *(s16 +0xd8) = s1
0089  +0x00cd8  op=58  1e 01 20 00  LD64             s1 = *(uint64_t *)(s30 +0x20)
008a  +0x00cf0  op=58  01 01 00 00  LD64             s1 = *(uint64_t *)(s1 +0x0)
008b  +0x00d08  op=25  10 01 e0 00  ST64             *(s16 +0xe0) = s1
008c  +0x00d20  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
008d  +0x00d38  op=58  1d 10 40 00  LD64             s16 = *(uint64_t *)(s29 +0x40)
008e  +0x00d50  op=58  1d 11 48 00  LD64             s17 = *(uint64_t *)(s29 +0x48)
008f  +0x00d68  op=58  1d 12 50 00  LD64             s18 = *(uint64_t *)(s29 +0x50)
0090  +0x00d80  op=58  1d 13 58 00  LD64             s19 = *(uint64_t *)(s29 +0x58)
0091  +0x00d98  op=58  1d 14 60 00  LD64             s20 = *(uint64_t *)(s29 +0x60)
0092  +0x00db0  op=58  1d 15 68 00  LD64             s21 = *(uint64_t *)(s29 +0x68)
0093  +0x00dc8  op=58  1d 16 70 00  LD64             s22 = *(uint64_t *)(s29 +0x70)
0094  +0x00de0  op=58  1d 17 78 00  LD64             s23 = *(uint64_t *)(s29 +0x78)
0095  +0x00df8  op=58  1d 1e 80 00  LD64             s30 = *(uint64_t *)(s29 +0x80)
0096  +0x00e10  op=58  1d 1f 88 00  LD64             s31 = *(uint64_t *)(s29 +0x88)
0097  +0x00e28  op=85  1d 1d 90 00  ADD64_IMM16      s29 = s29 +0x90
0098  +0x00e40  op=5b  1f 00 00 00  RET              return/leave with s31
0099  +0x00e58  op=34  11 00 04 01  OR64             s4 = s17 | s0
009a  +0x00e70  op=5e  13 00 00 00  CALL_CF_INDEX    call native_binding[index=0x13] via q1 table ; q1=0x125fd360 rt/so-mapped
009b  +0x00e88  op=18  00 02 01 00  SHL32_IMM        s1 = (int32_t)(s2 << 0)
009c  +0x00ea0  op=ae  01 00 90 ff  BR_EQ64          if (s1 == s0) goto record +45
009d  +0x00eb8  op=85  00 04 30 00  ADD64_IMM16      s4 = s0 +0x30
009e  +0x00ed0  op=5e  14 00 00 00  CALL_CF_INDEX    call native_binding[index=0x14] via q1 table ; q1=0x125fd360 rt/so-mapped
009f  +0x00ee8  op=34  02 00 04 01  OR64             s4 = s2 | s0
00a0  +0x00f00  op=85  00 05 00 00  ADD64_IMM16      s5 = s0 +0x0
00a1  +0x00f18  op=25  1e 02 00 00  ST64             *(s30 +0x0) = s2
00a2  +0x00f30  op=5e  15 00 00 00  CALL_CF_INDEX    call native_binding[index=0x15] via q1 table ; q1=0x125fd360 rt/so-mapped
00a3  +0x00f48  op=58  1e 01 00 00  LD64             s1 = *(uint64_t *)(s30 +0x0)
00a4  +0x00f60  op=34  11 00 04 01  OR64             s4 = s17 | s0
00a5  +0x00f78  op=25  17 01 00 00  ST64             *(s23 +0x0) = s1
00a6  +0x00f90  op=5e  16 00 00 00  CALL_CF_INDEX    call native_binding[index=0x16] via q1 table ; q1=0x125fd360 rt/so-mapped
00a7  +0x00fa8  op=5f  85 ff ff ff  ADD_PC_IMM32     goto record +45 ; vm_pc = current_pc + 1 + -123

; MetaSec managed bytecode decode: F7
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F7_0x5d1000_0xea0.bin
; records: 156  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d e0 fe  ADD64_IMM16      s29 = s29 -0x120
0001  +0x00018  op=25  1d 1f 18 01  ST64             *(s29 +0x118) = s31
0002  +0x00030  op=25  1d 1e 10 01  ST64             *(s29 +0x110) = s30 ; q1=0x12274848 rt/so-mapped
0003  +0x00048  op=25  1d 17 08 01  ST64             *(s29 +0x108) = s23
0004  +0x00060  op=25  1d 16 00 01  ST64             *(s29 +0x100) = s22
0005  +0x00078  op=25  1d 15 f8 00  ST64             *(s29 +0xf8) = s21
0006  +0x00090  op=25  1d 14 f0 00  ST64             *(s29 +0xf0) = s20
0007  +0x000a8  op=25  1d 13 e8 00  ST64             *(s29 +0xe8) = s19
0008  +0x000c0  op=25  1d 12 e0 00  ST64             *(s29 +0xe0) = s18
0009  +0x000d8  op=25  1d 11 d8 00  ST64             *(s29 +0xd8) = s17
000a  +0x000f0  op=25  1d 10 d0 00  ST64             *(s29 +0xd0) = s16 ; q1=0x12274848 rt/so-mapped
000b  +0x00108  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
000c  +0x00120  op=58  04 01 28 00  LD64             s1 = *(uint64_t *)(s4 +0x28)
000d  +0x00138  op=58  04 14 08 00  LD64             s20 = *(uint64_t *)(s4 +0x8)
000e  +0x00150  op=58  04 15 00 00  LD64             s21 = *(uint64_t *)(s4 +0x0)
000f  +0x00168  op=58  04 11 18 00  LD64             s17 = *(uint64_t *)(s4 +0x18)
0010  +0x00180  op=58  04 10 10 00  LD64             s16 = *(uint64_t *)(s4 +0x10)
0011  +0x00198  op=25  1e 01 18 00  ST64             *(s30 +0x18) = s1
0012  +0x001b0  op=58  04 01 20 00  LD64             s1 = *(uint64_t *)(s4 +0x20) ; q1=0x12274848 rt/so-mapped
0013  +0x001c8  op=25  1e 01 10 00  ST64             *(s30 +0x10) = s1
0014  +0x001e0  op=53  04 01 08 03  LD_POOL_PTR      s1 = *(uint64_t *)q1 + 0x308 ; q1=0x125fd408 rt/so-mapped
0015  +0x001f8  op=58  01 13 00 00  LD64             s19 = *(uint64_t *)(s1 +0x0)
0016  +0x00210  op=5e  0d 00 00 00  CALL_CF_INDEX    call native_binding[index=0xd] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0017  +0x00228  op=85  1e 12 98 00  ADD64_IMM16      s18 = s30 +0x98
0018  +0x00240  op=34  10 00 05 00  OR64             s5 = s16 | s0
0019  +0x00258  op=08  1e 02 cc 00  ST32             *(s30 +0xcc) = (uint32_t)s2
001a  +0x00270  op=34  12 00 04 01  OR64             s4 = s18 | s0 ; q1=0x12274848 rt/so-mapped
001b  +0x00288  op=5e  09 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9] via q1 table ; q1=0x125fd3c0 rt/so-mapped
001c  +0x002a0  op=58  1e 05 98 00  LD64             s5 = *(uint64_t *)(s30 +0x98)
001d  +0x002b8  op=85  1e 04 b0 00  ADD64_IMM16      s4 = s30 +0xb0
001e  +0x002d0  op=25  1e 04 08 00  ST64             *(s30 +0x8) = s4
001f  +0x002e8  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0020  +0x00300  op=34  12 00 04 01  OR64             s4 = s18 | s0
0021  +0x00318  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0022  +0x00330  op=85  1e 12 98 00  ADD64_IMM16      s18 = s30 +0x98 ; q1=0x12274848 rt/so-mapped
0023  +0x00348  op=34  12 00 04 00  OR64             s4 = s18 | s0
0024  +0x00360  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0025  +0x00378  op=58  11 07 10 00  LD64             s7 = *(uint64_t *)(s17 +0x10)
0026  +0x00390  op=58  1e 08 c0 00  LD64             s8 = *(uint64_t *)(s30 +0xc0)
0027  +0x003a8  op=85  13 05 ec 00  ADD64_IMM16      s5 = s19 +0xec
0028  +0x003c0  op=34  12 00 04 00  OR64             s4 = s18 | s0
0029  +0x003d8  op=34  15 00 06 01  OR64             s6 = s21 | s0
002a  +0x003f0  op=34  13 00 10 01  OR64             s16 = s19 | s0 ; q1=0x12274848 rt/so-mapped
002b  +0x00408  op=5e  31 00 00 00  CALL_CF_INDEX    call native_binding[index=0x31] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF100 format/crypto glue
002c  +0x00420  op=85  1e 15 50 00  ADD64_IMM16      s21 = s30 +0x50
002d  +0x00438  op=85  1e 16 cc 00  ADD64_IMM16      s22 = s30 +0xcc
002e  +0x00450  op=85  00 17 04 00  ADD64_IMM16      s23 = s0 +0x4
002f  +0x00468  op=34  15 00 04 01  OR64             s4 = s21 | s0
0030  +0x00480  op=34  16 00 05 01  OR64             s5 = s22 | s0
0031  +0x00498  op=34  17 00 06 01  OR64             s6 = s23 | s0
0032  +0x004b0  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
0033  +0x004c8  op=85  1e 11 68 00  ADD64_IMM16      s17 = s30 +0x68
0034  +0x004e0  op=34  15 00 05 00  OR64             s5 = s21 | s0
0035  +0x004f8  op=34  14 00 06 00  OR64             s6 = s20 | s0
0036  +0x00510  op=34  11 00 04 01  OR64             s4 = s17 | s0
0037  +0x00528  op=5e  1c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0038  +0x00540  op=85  1e 13 38 00  ADD64_IMM16      s19 = s30 +0x38
0039  +0x00558  op=85  00 06 01 00  ADD64_IMM16      s6 = s0 +0x1
003a  +0x00570  op=34  11 00 05 00  OR64             s5 = s17 | s0 ; q1=0x12274848 rt/so-mapped
003b  +0x00588  op=34  13 00 04 01  OR64             s4 = s19 | s0
003c  +0x005a0  op=5e  1b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x1b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
003d  +0x005b8  op=85  1e 14 80 00  ADD64_IMM16      s20 = s30 +0x80
003e  +0x005d0  op=58  1e 05 38 00  LD64             s5 = *(uint64_t *)(s30 +0x38)
003f  +0x005e8  op=34  14 00 04 00  OR64             s4 = s20 | s0
0040  +0x00600  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0041  +0x00618  op=34  13 00 04 01  OR64             s4 = s19 | s0
0042  +0x00630  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0043  +0x00648  op=34  11 00 04 00  OR64             s4 = s17 | s0
0044  +0x00660  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0045  +0x00678  op=34  15 00 04 01  OR64             s4 = s21 | s0
0046  +0x00690  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0047  +0x006a8  op=85  1e 15 68 00  ADD64_IMM16      s21 = s30 +0x68
0048  +0x006c0  op=34  16 00 05 01  OR64             s5 = s22 | s0
0049  +0x006d8  op=34  17 00 06 01  OR64             s6 = s23 | s0
004a  +0x006f0  op=34  15 00 04 01  OR64             s4 = s21 | s0 ; q1=0x12274848 rt/so-mapped
004b  +0x00708  op=5e  24 00 00 00  CALL_CF_INDEX    call native_binding[index=0x24] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF38 initMemBlockBySrc
004c  +0x00720  op=85  1e 16 50 00  ADD64_IMM16      s22 = s30 +0x50
004d  +0x00738  op=34  16 00 04 00  OR64             s4 = s22 | s0
004e  +0x00750  op=5e  04 00 00 00  CALL_CF_INDEX    call native_binding[index=0x4] via q1 table ; q1=0x125fd3c0 rt/so-mapped
004f  +0x00768  op=34  12 00 04 01  OR64             s4 = s18 | s0
0050  +0x00780  op=34  16 00 05 00  OR64             s5 = s22 | s0
0051  +0x00798  op=34  14 00 06 01  OR64             s6 = s20 | s0
0052  +0x007b0  op=5e  32 00 00 00  CALL_CF_INDEX    call native_binding[index=0x32] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF48 short flattened transform
0053  +0x007c8  op=34  15 00 04 01  OR64             s4 = s21 | s0
0054  +0x007e0  op=34  16 00 05 01  OR64             s5 = s22 | s0
0055  +0x007f8  op=5e  33 00 00 00  CALL_CF_INDEX    call native_binding[index=0x33] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF49 concat transformed short block
0056  +0x00810  op=85  1e 11 28 00  ADD64_IMM16      s17 = s30 +0x28
0057  +0x00828  op=34  15 00 05 01  OR64             s5 = s21 | s0
0058  +0x00840  op=34  11 00 04 00  OR64             s4 = s17 | s0
0059  +0x00858  op=5e  2b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2b] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF44 base64Encode
005a  +0x00870  op=85  1e 17 38 00  ADD64_IMM16      s23 = s30 +0x38 ; q1=0x12274848 rt/so-mapped
005b  +0x00888  op=58  1e 05 28 00  LD64             s5 = *(uint64_t *)(s30 +0x28)
005c  +0x008a0  op=34  17 00 04 01  OR64             s4 = s23 | s0
005d  +0x008b8  op=5e  23 00 00 00  CALL_CF_INDEX    call native_binding[index=0x23] via q1 table ; q1=0x125fd3c0 rt/so-mapped
005e  +0x008d0  op=34  11 00 04 01  OR64             s4 = s17 | s0
005f  +0x008e8  op=5e  0c 00 00 00  CALL_CF_INDEX    call native_binding[index=0xc] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0060  +0x00900  op=59  10 03 f8 00  LD8U             s3 = *(uint8_t *)(s16 +0xf8)
0061  +0x00918  op=54  00 01 8f b1  CONST_HI16       s1 = sign_extend_32(0xb18f << 16)
0062  +0x00930  op=53  01 02 58 00  LD_POOL_PTR      s2 = *(uint64_t *)q1 + 0x58 ; q1=0x125fd408 rt/so-mapped
0063  +0x00948  op=85  00 11 03 00  ADD64_IMM16      s17 = s0 +0x3
0064  +0x00960  op=85  1e 04 20 00  ADD64_IMM16      s4 = s30 +0x20
0065  +0x00978  op=33  01 01 35 ff  OR_IMM16         s1 = s1 | 0xff35
0066  +0x00990  op=34  11 00 05 01  OR64             s5 = s17 | s0
0067  +0x009a8  op=26  1e 03 26 00  ST8              *(s30 +0x26) = (uint8_t)s3
0068  +0x009c0  op=6e  00 01 01 10  SHL64_IMM        s1 = s1 << 16
0069  +0x009d8  op=55  10 03 f6 00  LD16U            s3 = *(uint16_t *)(s16 +0xf6)
006a  +0x009f0  op=85  01 01 3d a6  ADD64_IMM16      s1 = s1 -0x59c3 ; q1=0x12274848 rt/so-mapped
006b  +0x00a08  op=6e  12 01 01 10  SHL64_IMM        s1 = s1 << 16
006c  +0x00a20  op=19  1e 03 24 00  ST16             *(s30 +0x24) = (uint16_t)s3
006d  +0x00a38  op=59  02 03 02 00  LD8U             s3 = *(uint8_t *)(s2 +0x2)
006e  +0x00a50  op=55  02 02 00 00  LD16U            s2 = *(uint16_t *)(s2 +0x0)
006f  +0x00a68  op=85  01 01 fd 3d  ADD64_IMM16      s1 = s1 +0x3dfd
0070  +0x00a80  op=25  1e 01 28 00  ST64             *(s30 +0x28) = s1
0071  +0x00a98  op=26  1e 03 22 00  ST8              *(s30 +0x22) = (uint8_t)s3
0072  +0x00ab0  op=19  1e 02 20 00  ST16             *(s30 +0x20) = (uint16_t)s2 ; q1=0x12274848 rt/so-mapped
0073  +0x00ac8  op=5e  19 00 00 00  CALL_CF_INDEX    call native_binding[index=0x19] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0074  +0x00ae0  op=85  1e 04 28 00  ADD64_IMM16      s4 = s30 +0x28
0075  +0x00af8  op=85  00 05 08 00  ADD64_IMM16      s5 = s0 +0x8
0076  +0x00b10  op=34  02 00 13 00  OR64             s19 = s2 | s0
0077  +0x00b28  op=5e  20 00 00 00  CALL_CF_INDEX    call native_binding[index=0x20] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0078  +0x00b40  op=58  1e 04 10 00  LD64             s4 = *(uint64_t *)(s30 +0x10)
0079  +0x00b58  op=34  02 00 06 00  OR64             s6 = s2 | s0
007a  +0x00b70  op=34  13 00 05 00  OR64             s5 = s19 | s0 ; q1=0x12274848 rt/so-mapped
007b  +0x00b88  op=5e  2e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2e] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF98 formatAllocString
007c  +0x00ba0  op=85  1e 04 24 00  ADD64_IMM16      s4 = s30 +0x24
007d  +0x00bb8  op=34  11 00 05 00  OR64             s5 = s17 | s0
007e  +0x00bd0  op=5e  2c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
007f  +0x00be8  op=58  1e 06 48 00  LD64             s6 = *(uint64_t *)(s30 +0x48)
0080  +0x00c00  op=58  1e 04 18 00  LD64             s4 = *(uint64_t *)(s30 +0x18)
0081  +0x00c18  op=34  02 00 05 01  OR64             s5 = s2 | s0
0082  +0x00c30  op=5e  2e 00 00 00  CALL_CF_INDEX    call native_binding[index=0x2e] via q1 table ; q1=0x125fd3c0 rt/so-mapped  ; runtime: CF98 formatAllocString
0083  +0x00c48  op=34  17 00 04 01  OR64             s4 = s23 | s0
0084  +0x00c60  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0085  +0x00c78  op=34  16 00 04 00  OR64             s4 = s22 | s0
0086  +0x00c90  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0087  +0x00ca8  op=34  15 00 04 01  OR64             s4 = s21 | s0
0088  +0x00cc0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0089  +0x00cd8  op=34  14 00 04 01  OR64             s4 = s20 | s0
008a  +0x00cf0  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008b  +0x00d08  op=34  12 00 04 01  OR64             s4 = s18 | s0
008c  +0x00d20  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008d  +0x00d38  op=58  1e 04 08 00  LD64             s4 = *(uint64_t *)(s30 +0x8)
008e  +0x00d50  op=5e  07 00 00 00  CALL_CF_INDEX    call native_binding[index=0x7] via q1 table ; q1=0x125fd3c0 rt/so-mapped
008f  +0x00d68  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0090  +0x00d80  op=58  1d 10 d0 00  LD64             s16 = *(uint64_t *)(s29 +0xd0)
0091  +0x00d98  op=58  1d 11 d8 00  LD64             s17 = *(uint64_t *)(s29 +0xd8)
0092  +0x00db0  op=58  1d 12 e0 00  LD64             s18 = *(uint64_t *)(s29 +0xe0) ; q1=0x12274848 rt/so-mapped
0093  +0x00dc8  op=58  1d 13 e8 00  LD64             s19 = *(uint64_t *)(s29 +0xe8)
0094  +0x00de0  op=58  1d 14 f0 00  LD64             s20 = *(uint64_t *)(s29 +0xf0)
0095  +0x00df8  op=58  1d 15 f8 00  LD64             s21 = *(uint64_t *)(s29 +0xf8)
0096  +0x00e10  op=58  1d 16 00 01  LD64             s22 = *(uint64_t *)(s29 +0x100)
0097  +0x00e28  op=58  1d 17 08 01  LD64             s23 = *(uint64_t *)(s29 +0x108)
0098  +0x00e40  op=58  1d 1e 10 01  LD64             s30 = *(uint64_t *)(s29 +0x110)
0099  +0x00e58  op=58  1d 1f 18 01  LD64             s31 = *(uint64_t *)(s29 +0x118)
009a  +0x00e70  op=85  1d 1d 20 01  ADD64_IMM16      s29 = s29 +0x120 ; q1=0x12274848 rt/so-mapped
009b  +0x00e88  op=5b  1f 00 00 00  RET              return/leave with s31

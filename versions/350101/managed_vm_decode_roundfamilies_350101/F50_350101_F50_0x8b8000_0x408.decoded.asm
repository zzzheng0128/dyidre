; MetaSec managed bytecode decode: F50
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F50_0x8b8000_0x408.bin
; records: 43  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d d0 ff  ADD64_IMM16      s29 = s29 -0x30
0001  +0x00018  op=25  1d 1f 28 00  ST64             *(s29 +0x28) = s31
0002  +0x00030  op=25  1d 1e 20 00  ST64             *(s29 +0x20) = s30
0003  +0x00048  op=25  1d 13 18 00  ST64             *(s29 +0x18) = s19
0004  +0x00060  op=25  1d 12 10 00  ST64             *(s29 +0x10) = s18
0005  +0x00078  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17
0006  +0x00090  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
0007  +0x000a8  op=34  1d 00 1e 00  OR64             s30 = s29 | s0
0008  +0x000c0  op=34  05 00 10 01  OR64             s16 = s5 | s0
0009  +0x000d8  op=34  04 00 11 00  OR64             s17 = s4 | s0
000a  +0x000f0  op=85  00 04 00 00  ADD64_IMM16      s4 = s0 +0x0
000b  +0x00108  op=34  11 00 05 00  OR64             s5 = s17 | s0
000c  +0x00120  op=34  10 00 06 01  OR64             s6 = s16 | s0
000d  +0x00138  op=5e  9a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
000e  +0x00150  op=b5  00 12 01 00  ADD32_IMM16      s18 = int32(s0 +0x1)
000f  +0x00168  op=b5  00 13 02 00  ADD32_IMM16      s19 = int32(s0 +0x2)
0010  +0x00180  op=34  11 00 04 01  OR64             s4 = s17 | s0
0011  +0x00198  op=5e  9b 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9b] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0012  +0x001b0  op=34  11 00 04 01  OR64             s4 = s17 | s0
0013  +0x001c8  op=5e  9c 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9c] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0014  +0x001e0  op=b2  12 01 ff 00  AND64_IMM16      s1 = s18 & 0xff
0015  +0x001f8  op=ae  01 13 08 00  BR_EQ64          if (s1 == s19) goto record +30
0016  +0x00210  op=34  11 00 04 01  OR64             s4 = s17 | s0
0017  +0x00228  op=5e  9d 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9d] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0018  +0x00240  op=34  12 00 04 01  OR64             s4 = s18 | s0
0019  +0x00258  op=34  11 00 05 01  OR64             s5 = s17 | s0
001a  +0x00270  op=34  10 00 06 01  OR64             s6 = s16 | s0
001b  +0x00288  op=5e  9a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
001c  +0x002a0  op=b5  12 12 01 00  ADD32_IMM16      s18 = int32(s18 +0x1)
001d  +0x002b8  op=5f  f2 ff ff ff  ADD_PC_IMM32     goto record +16 ; vm_pc = current_pc + 1 + -14
001e  +0x002d0  op=85  00 04 02 00  ADD64_IMM16      s4 = s0 +0x2
001f  +0x002e8  op=34  11 00 05 00  OR64             s5 = s17 | s0
0020  +0x00300  op=34  10 00 06 01  OR64             s6 = s16 | s0
0021  +0x00318  op=5e  9a 00 00 00  CALL_CF_INDEX    call native_binding[index=0x9a] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0022  +0x00330  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
0023  +0x00348  op=58  1d 10 00 00  LD64             s16 = *(uint64_t *)(s29 +0x0)
0024  +0x00360  op=58  1d 11 08 00  LD64             s17 = *(uint64_t *)(s29 +0x8)
0025  +0x00378  op=58  1d 12 10 00  LD64             s18 = *(uint64_t *)(s29 +0x10)
0026  +0x00390  op=58  1d 13 18 00  LD64             s19 = *(uint64_t *)(s29 +0x18)
0027  +0x003a8  op=58  1d 1e 20 00  LD64             s30 = *(uint64_t *)(s29 +0x20)
0028  +0x003c0  op=58  1d 1f 28 00  LD64             s31 = *(uint64_t *)(s29 +0x28)
0029  +0x003d8  op=85  1d 1d 30 00  ADD64_IMM16      s29 = s29 +0x30
002a  +0x003f0  op=5b  1f 00 00 00  RET              return/leave with s31

; MetaSec managed bytecode decode: F47
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_adapters_350101_20260831_053000/350101_F47_0x5e1c00_0x1e0.bin
; records: 20  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=85  1d 1d e0 ff  ADD64_IMM16      s29 = s29 -0x20
0001  +0x00018  op=25  1d 1f 18 00  ST64             *(s29 +0x18) = s31
0002  +0x00030  op=25  1d 1e 10 00  ST64             *(s29 +0x10) = s30
0003  +0x00048  op=25  1d 11 08 00  ST64             *(s29 +0x8) = s17
0004  +0x00060  op=25  1d 10 00 00  ST64             *(s29 +0x0) = s16
0005  +0x00078  op=34  1d 00 1e 01  OR64             s30 = s29 | s0
0006  +0x00090  op=34  06 00 10 00  OR64             s16 = s6 | s0
0007  +0x000a8  op=34  04 00 11 01  OR64             s17 = s4 | s0
0008  +0x000c0  op=5e  98 00 00 00  CALL_CF_INDEX    call native_binding[index=0x98] via q1 table ; q1=0x125fd3c0 rt/so-mapped
0009  +0x000d8  op=85  11 04 b0 00  ADD64_IMM16      s4 = s17 +0xb0
000a  +0x000f0  op=85  00 06 10 00  ADD64_IMM16      s6 = s0 +0x10
000b  +0x00108  op=34  10 00 05 01  OR64             s5 = s16 | s0
000c  +0x00120  op=5e  36 00 00 00  CALL_CF_INDEX    call native_binding[index=0x36] via q1 table ; q1=0x125fd3c0 rt/so-mapped
000d  +0x00138  op=34  1e 00 1d 01  OR64             s29 = s30 | s0
000e  +0x00150  op=58  1d 10 00 00  LD64             s16 = *(uint64_t *)(s29 +0x0)
000f  +0x00168  op=58  1d 11 08 00  LD64             s17 = *(uint64_t *)(s29 +0x8)
0010  +0x00180  op=58  1d 1e 10 00  LD64             s30 = *(uint64_t *)(s29 +0x10)
0011  +0x00198  op=58  1d 1f 18 00  LD64             s31 = *(uint64_t *)(s29 +0x18)
0012  +0x001b0  op=85  1d 1d 20 00  ADD64_IMM16      s29 = s29 +0x20
0013  +0x001c8  op=5b  1f 00 00 00  RET              return/leave with s31

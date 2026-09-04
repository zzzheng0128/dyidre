; MetaSec managed bytecode decode: F3
; source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F3_0x750000_0xd8.bin
; records: 9  record_size=0x18
; slot base: qword slots=frame->buf+0x8100, f32=+0x8200, f64=+0x8280

0000  +0x00000  op=58  04 01 00 00  LD64             s1 = *(uint64_t *)(s4 +0x0)
0001  +0x00018  op=58  04 02 10 00  LD64             s2 = *(uint64_t *)(s4 +0x10)
0002  +0x00030  op=02  02 01 01 01  XOR64            s1 = s1 ^ s2
0003  +0x00048  op=25  05 01 00 00  ST64             *(s5 +0x0) = s1
0004  +0x00060  op=58  04 01 08 00  LD64             s1 = *(uint64_t *)(s4 +0x8)
0005  +0x00078  op=58  04 02 18 00  LD64             s2 = *(uint64_t *)(s4 +0x18)
0006  +0x00090  op=02  02 01 01 00  XOR64            s1 = s1 ^ s2
0007  +0x000a8  op=25  05 01 08 00  ST64             *(s5 +0x8) = s1
0008  +0x000c0  op=5b  1f 00 00 00  RET              return/leave with s31

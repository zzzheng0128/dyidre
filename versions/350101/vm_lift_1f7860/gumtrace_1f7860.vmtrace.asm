# metasec VM trace decoder
# image_base: 0x7102c04000
# vm_pages: 0x7102dfb000
# native_rows: 339360
# vm_word_reads_raw: 882
# vm_word_reads_stream: 442
# br_x8_dispatches: 5437

# opcode histogram from stream view:
#   op 0x00:    2  LD16S           dst = *(int16_t *)(src + simm16), from z/ws/vm64.cpp
#   op 0x01:    8  OP01            unknown/no-op-ish in current reconstruction
#   op 0x0d:    1  ADD64_IMM       dst = src + simm16, from z/ws/vm64.cpp
#   op 0x0f:   34  BR_COND         conditional VM-PC control family, from z/ws/vm64.cpp
#   op 0x10:    1  BITFIELD        bitfield extract/insert/sign-extend/rev family, from z/ws/vm64.cpp
#   op 0x11:  109  CALL_IMM_LINK31 VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
#   op 0x14:    1  ST16            *(src + simm16) = dst.u16, from z/ws/vm64.cpp
#   op 0x16:   12  ST32_UNALIGNED_R unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
#   op 0x18:  111  OP18            350 trace hits this handler; exact semantics still version-verify
#   op 0x1a:  145  BR_COND         conditional VM-PC control family, from z/ws/vm64.cpp
#   op 0x2b:    1  LD32S           dst = *(int32_t *)(src + simm16), from z/ws/vm64.cpp
#   op 0x2d:    5  BR_COND         conditional VM-PC control family, from z/ws/vm64.cpp
#   op 0x30:    3  LD16U           dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
#   op 0x34:    2  OP34            unknown/no-op-ish in current reconstruction
#   op 0x3b:    7  ST64            *(src + simm16) = dst.u64, from z/ws/vm64.cpp

# top BR X8 targets:
#   0x4ce54: 1393  CALL_IMM_LINK31/op11 (primary op11 handler)
#   0x54a1c:  715  OP18/op18 (primary op18 handler)
#   0x4e0bc:  475  secondary/unknown target
#   0x52d04:  463  ST64/op3b (primary op3b handler)
#   0x52984:  329  BR_COND/op0f (primary op0f handler)
#   0x561b4:  301  BR_COND/op1a (primary op1a handler)
#   0x54020:  234  ST16/op14 (primary op14 handler)
#   0x55908:  231  secondary/unknown target
#   0x4f728:  231  secondary/unknown target
#   0x56b00:  222  BITFIELD/op10 (primary op10 handler)
#   0x4f1c0:  220  secondary/unknown target
#   0x4dc54:  219  secondary/unknown target
#   0x4f500:  162  secondary/unknown target
#   0x4f830:   85  secondary/unknown target
#   0x53db0:   35  BR_COND/op2d (primary op2d handler)
#   0x55714:   31  OP01/op01 (primary op01 handler)
#   0x56e70:   29  ST32_UNALIGNED_R/op16 (primary op16 handler)
#   0x52f34:   15  secondary/unknown target
#   0x5309c:   12  secondary/unknown target
#   0x116f34:   12  secondary/unknown target
#   0x53b68:   11  secondary/unknown target
#   0x5332c:    4  LD16U/op30 (primary op30 handler)
#   0x531e4:    3  OP34/op34 (primary op34 handler)
#   0x116f0c:    3  secondary/unknown target
#   0x53540:    1  ADD64_IMM/op0d (primary op0d handler)
#   0x4f860:    1  secondary/unknown target

# VM word fetch sites:
#   0x56264:  144  01:1, 0f:12, 11:16, 18:52, 1a:60, 30:1, 3b:2
#   0x54acc:  111  01:3, 0d:1, 10:1, 11:33, 14:1, 16:2, 18:19, 1a:45, 2d:4, 3b:2
#   0x4f5d8:   57  0f:2, 11:48, 18:3, 1a:3, 34:1
#   0x52ab8:   34  0f:4, 11:2, 16:2, 18:13, 1a:13
#   0x4f8e0:   27  0f:9, 11:4, 18:13, 34:1
#   0x4e194:   25  0f:4, 18:4, 1a:17
#   0x56f24:   12  0f:1, 11:1, 18:4, 1a:4, 2d:1, 30:1
#   0x5581c:    8  0f:1, 11:1, 16:2, 18:1, 2b:1, 3b:2
#   0x52d8c:    7  01:1, 16:6
#   0x53f4c:    5  01:3, 11:1, 3b:1
#   0x533dc:    3  11:1, 18:1, 1a:1
#   0x532f4:    2  11:1, 30:1
#   0x4cd94:    1  0f:1
#   0x536b0:    1  11:1
#   0x53d04:    1  1a:1
#   0x541f4:    1  18:1
#   0x56c18:    1  1a:1
#   0x11dac0:    1  00:1
#   0x11db84:    1  00:1

# stream view: unique/collapsed VM words in first-observed order
0000 vm+0x0000 pc=0x7102dfb860 word=0xef5b878f op=0x0f BR_COND         fetch=0x4cd94 line=150    branch_cond? target=pc+4-0x1c488 src=v26 cmp=v27 lo12=0x78f ; conditional VM-PC control family, from z/ws/vm64.cpp
0001 vm+0x0004 pc=0x7102dfb864 word=0xa03b2f9a op=0x1a BR_COND         fetch=0x52ab8 line=252    branch_cond? target=pc+4+0xa8f8 src=v1 cmp=v27 lo12=0xf9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0002 vm+0x0008 pc=0x7102dfb868 word=0x803b2f1a op=0x1a BR_COND         fetch=0x56264 line=312    branch_cond? target=pc+4+0xa0f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0003 vm+0x000c pc=0x7102dfb86c word=0xe03b239a op=0x1a BR_COND         fetch=0x56264 line=368    branch_cond? target=pc+4+0xb838 src=v1 cmp=v27 lo12=0x39a ; conditional VM-PC control family, from z/ws/vm64.cpp
0004 vm+0x0010 pc=0x7102dfb870 word=0xc03b231a op=0x1a BR_COND         fetch=0x56264 line=424    branch_cond? target=pc+4+0xb030 src=v1 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0005 vm+0x0014 pc=0x7102dfb874 word=0xa03b229a op=0x1a BR_COND         fetch=0x56264 line=480    branch_cond? target=pc+4+0xa828 src=v1 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0006 vm+0x0018 pc=0x7102dfb878 word=0x803b221a op=0x1a BR_COND         fetch=0x56264 line=536    branch_cond? target=pc+4+0xa020 src=v1 cmp=v27 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0007 vm+0x001c pc=0x7102dfb87c word=0xe03b199a op=0x1a BR_COND         fetch=0x56264 line=592    branch_cond? target=pc+4+0x7898 src=v1 cmp=v27 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0008 vm+0x0020 pc=0x7102dfb880 word=0xc03b191a op=0x1a BR_COND         fetch=0x56264 line=648    branch_cond? target=pc+4+0x7090 src=v1 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0009 vm+0x0024 pc=0x7102dfb884 word=0xa03b189a op=0x1a BR_COND         fetch=0x56264 line=704    branch_cond? target=pc+4+0x6888 src=v1 cmp=v27 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0010 vm+0x0028 pc=0x7102dfb888 word=0x803b181a op=0x1a BR_COND         fetch=0x56264 line=760    branch_cond? target=pc+4+0x6080 src=v1 cmp=v27 lo12=0x81a ; conditional VM-PC control family, from z/ws/vm64.cpp
0011 vm+0x002c pc=0x7102dfb88c word=0x81c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=816    call_imm? target=vm_base+0x81c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0012 vm+0x0030 pc=0x7102dfb890 word=0x3c19e7f4 op=0x34 OP34            fetch=0x4f5d8 line=899    op34? dst=v25 src=v0 lo12=0x7f4 imm16=0xe3df ; unknown/no-op-ish in current reconstruction
0013 vm+0x0034 pc=0x7102dfb894 word=0x1a02dbb0 op=0x30 LD16U           fetch=0x532f4 line=980    v2 = load_u16 [v16 + -0x2e52] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0014 vm+0x0038 pc=0x7102dfb898 word=0x010002d8 op=0x18 OP18            fetch=0x533dc line=1038   op18/version-specific? dst=v0 src=v8 lo12=0x2d8 imm16=0x000b ; 350 trace hits this handler; exact semantics still version-verify
0015 vm+0x003c pc=0x7102dfb89c word=0x08680391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=1094   call_imm? target=vm_base+0x868038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0016 vm+0x0040 pc=0x7102dfb8a0 word=0x00980218 op=0x18 OP18            fetch=0x4e194 line=1176   op18/version-specific? dst=v24 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0017 vm+0x0044 pc=0x7102dfb8a4 word=0x801a411a op=0x1a BR_COND         fetch=0x54acc line=1233   branch_cond? target=pc+4+0x12010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0018 vm+0x0048 pc=0x7102dfb8a8 word=0x00900218 op=0x18 OP18            fetch=0x56264 line=1288   op18/version-specific? dst=v16 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0019 vm+0x004c pc=0x7102dfb8ac word=0xa01a111a op=0x1a BR_COND         fetch=0x54acc line=1344   branch_cond? target=pc+4+0x6810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0020 vm+0x0050 pc=0x7102dfb8b0 word=0x00880258 op=0x18 OP18            fetch=0x56264 line=1399   op18/version-specific? dst=v8 src=v4 lo12=0x258 imm16=0x0009 ; 350 trace hits this handler; exact semantics still version-verify
0021 vm+0x0054 pc=0x7102dfb8b4 word=0x00800218 op=0x18 OP18            fetch=0x54acc line=1455   op18/version-specific? dst=v0 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0022 vm+0x0058 pc=0x7102dfb8b8 word=0xa01a191a op=0x1a BR_COND         fetch=0x54acc line=1510   branch_cond? target=pc+4+0x6890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0023 vm+0x005c pc=0x7102dfb8bc word=0x00880298 op=0x18 OP18            fetch=0x56264 line=1565   op18/version-specific? dst=v8 src=v4 lo12=0x298 imm16=0x000a ; 350 trace hits this handler; exact semantics still version-verify
0024 vm+0x0060 pc=0x7102dfb8c0 word=0xe01a411a op=0x1a BR_COND         fetch=0x54acc line=1621   branch_cond? target=pc+4+0x13810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0025 vm+0x0064 pc=0x7102dfb8c4 word=0x01500358 op=0x18 OP18            fetch=0x56264 line=1676   op18/version-specific? dst=v16 src=v10 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0026 vm+0x0068 pc=0x7102dfb8c8 word=0x00d80358 op=0x18 OP18            fetch=0x54acc line=1732   op18/version-specific? dst=v24 src=v6 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0027 vm+0x006c pc=0x7102dfb8cc word=0x00800b18 op=0x18 OP18            fetch=0x54acc line=1787   op18/version-specific? dst=v0 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0028 vm+0x0070 pc=0x7102dfb8d0 word=0xe01a311a op=0x1a BR_COND         fetch=0x54acc line=1842   branch_cond? target=pc+4+0xf810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0029 vm+0x0074 pc=0x7102dfb8d4 word=0x00880b18 op=0x18 OP18            fetch=0x56264 line=1897   op18/version-specific? dst=v8 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0030 vm+0x0078 pc=0x7102dfb8d8 word=0xe01a491a op=0x1a BR_COND         fetch=0x54acc line=1953   branch_cond? target=pc+4+0x13890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0031 vm+0x007c pc=0x7102dfb8dc word=0x00900b18 op=0x18 OP18            fetch=0x56264 line=2008   op18/version-specific? dst=v16 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0032 vm+0x0080 pc=0x7102dfb8e0 word=0xe01a391a op=0x1a BR_COND         fetch=0x54acc line=2064   branch_cond? target=pc+4+0xf890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0033 vm+0x0084 pc=0x7102dfb8e4 word=0x00980b18 op=0x18 OP18            fetch=0x56264 line=2119   op18/version-specific? dst=v24 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0034 vm+0x0088 pc=0x7102dfb8e8 word=0xa01a491a op=0x1a BR_COND         fetch=0x54acc line=2175   branch_cond? target=pc+4+0x12890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0035 vm+0x008c pc=0x7102dfb8ec word=0x00801318 op=0x18 OP18            fetch=0x56264 line=2230   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0036 vm+0x0090 pc=0x7102dfb8f0 word=0xc01a391a op=0x1a BR_COND         fetch=0x54acc line=2286   branch_cond? target=pc+4+0xf090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0037 vm+0x0094 pc=0x7102dfb8f4 word=0x00881318 op=0x18 OP18            fetch=0x56264 line=2341   op18/version-specific? dst=v8 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0038 vm+0x0098 pc=0x7102dfb8f8 word=0xa01a391a op=0x1a BR_COND         fetch=0x54acc line=2397   branch_cond? target=pc+4+0xe890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0039 vm+0x009c pc=0x7102dfb8fc word=0x01d01358 op=0x18 OP18            fetch=0x56264 line=2452   op18/version-specific? dst=v16 src=v14 lo12=0x358 imm16=0x100d ; 350 trace hits this handler; exact semantics still version-verify
0040 vm+0x00a0 pc=0x7102dfb900 word=0x00981318 op=0x18 OP18            fetch=0x54acc line=2508   op18/version-specific? dst=v24 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0041 vm+0x00a4 pc=0x7102dfb904 word=0x801a491a op=0x1a BR_COND         fetch=0x54acc line=2563   branch_cond? target=pc+4+0x12090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0042 vm+0x00a8 pc=0x7102dfb908 word=0x00801b18 op=0x18 OP18            fetch=0x56264 line=2618   op18/version-specific? dst=v0 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0043 vm+0x00ac pc=0x7102dfb90c word=0xa01a411a op=0x1a BR_COND         fetch=0x54acc line=2674   branch_cond? target=pc+4+0x12810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0044 vm+0x00b0 pc=0x7102dfb910 word=0x00881b18 op=0x18 OP18            fetch=0x56264 line=2729   op18/version-specific? dst=v8 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0045 vm+0x00b4 pc=0x7102dfb914 word=0x801a391a op=0x1a BR_COND         fetch=0x54acc line=2785   branch_cond? target=pc+4+0xe090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0046 vm+0x00b8 pc=0x7102dfb918 word=0x00901b18 op=0x18 OP18            fetch=0x56264 line=2840   op18/version-specific? dst=v16 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0047 vm+0x00bc pc=0x7102dfb91c word=0xc01a511a op=0x1a BR_COND         fetch=0x54acc line=2896   branch_cond? target=pc+4+0x17010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0048 vm+0x00c0 pc=0x7102dfb920 word=0x00981b18 op=0x18 OP18            fetch=0x56264 line=2951   op18/version-specific? dst=v24 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0049 vm+0x00c4 pc=0x7102dfb924 word=0xa01a311a op=0x1a BR_COND         fetch=0x54acc line=3007   branch_cond? target=pc+4+0xe810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0050 vm+0x00c8 pc=0x7102dfb928 word=0x00802318 op=0x18 OP18            fetch=0x56264 line=3062   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0051 vm+0x00cc pc=0x7102dfb92c word=0xe01a291a op=0x1a BR_COND         fetch=0x54acc line=3118   branch_cond? target=pc+4+0xb890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0052 vm+0x00d0 pc=0x7102dfb930 word=0x00882318 op=0x18 OP18            fetch=0x56264 line=3173   op18/version-specific? dst=v8 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0053 vm+0x00d4 pc=0x7102dfb934 word=0xc01a291a op=0x1a BR_COND         fetch=0x54acc line=3229   branch_cond? target=pc+4+0xb090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0054 vm+0x00d8 pc=0x7102dfb938 word=0x00902318 op=0x18 OP18            fetch=0x56264 line=3284   op18/version-specific? dst=v16 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0055 vm+0x00dc pc=0x7102dfb93c word=0xc01a311a op=0x1a BR_COND         fetch=0x54acc line=3340   branch_cond? target=pc+4+0xf010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0056 vm+0x00e0 pc=0x7102dfb940 word=0x00900298 op=0x18 OP18            fetch=0x56264 line=3395   op18/version-specific? dst=v16 src=v4 lo12=0x298 imm16=0x000a ; 350 trace hits this handler; exact semantics still version-verify
0057 vm+0x00e4 pc=0x7102dfb944 word=0xa01a291a op=0x1a BR_COND         fetch=0x54acc line=3451   branch_cond? target=pc+4+0xa890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0058 vm+0x00e8 pc=0x7102dfb948 word=0x00982318 op=0x18 OP18            fetch=0x56264 line=3506   op18/version-specific? dst=v24 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0059 vm+0x00ec pc=0x7102dfb94c word=0x801a291a op=0x1a BR_COND         fetch=0x54acc line=3562   branch_cond? target=pc+4+0xa090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0060 vm+0x00f0 pc=0x7102dfb950 word=0x01880358 op=0x18 OP18            fetch=0x56264 line=3617   op18/version-specific? dst=v8 src=v12 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0061 vm+0x00f4 pc=0x7102dfb954 word=0x00800318 op=0x18 OP18            fetch=0x54acc line=3673   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x000c ; 350 trace hits this handler; exact semantics still version-verify
0062 vm+0x00f8 pc=0x7102dfb958 word=0x00400098 op=0x18 OP18            fetch=0x54acc line=3728   op18/version-specific? dst=v0 src=v2 lo12=0x098 imm16=0x0002 ; 350 trace hits this handler; exact semantics still version-verify
0063 vm+0x00fc pc=0x7102dfb95c word=0xe03a101a op=0x1a BR_COND         fetch=0x54acc line=3783   branch_cond? target=pc+4+0x7800 src=v1 cmp=v26 lo12=0x01a ; conditional VM-PC control family, from z/ws/vm64.cpp
0064 vm+0x0100 pc=0x7102dfb960 word=0x9a1ac00f op=0x0f BR_COND         fetch=0x56264 line=3838   branch_cond? target=pc+4-0xda00 src=v16 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0065 vm+0x0104 pc=0x7102dfb964 word=0xa01a519a op=0x1a BR_COND         fetch=0x52ab8 line=3927   branch_cond? target=pc+4+0x16818 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0066 vm+0x0108 pc=0x7102dfb968 word=0xc03a119a op=0x1a BR_COND         fetch=0x56264 line=3987   branch_cond? target=pc+4+0x7018 src=v1 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0067 vm+0x010c pc=0x7102dfb96c word=0xa03a109a op=0x1a BR_COND         fetch=0x56264 line=4043   branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0068 vm+0x0110 pc=0x7102dfb970 word=0x1902c3f0 op=0x30 LD16U           fetch=0x56264 line=4099   v2 = load_u16 [v8 + -0x3e71] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0069 vm+0x0114 pc=0x7102dfb974 word=0x24440391 op=0x11 CALL_IMM_LINK31 fetch=0x533dc line=4155   call_imm? target=vm_base+0x2444038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0070 vm+0x0118 pc=0x7102dfb978 word=0xa85a404f op=0x0f BR_COND         fetch=0x4e194 line=4238   branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0071 vm+0x011c pc=0x7102dfb97c word=0xc01a4a1a op=0x1a BR_COND         fetch=0x52ab8 line=4328   branch_cond? target=pc+4+0x130a0 src=v0 cmp=v26 lo12=0xa1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0072 vm+0x0120 pc=0x7102dfb980 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=4388   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0073 vm+0x0124 pc=0x7102dfb984 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=4471   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0074 vm+0x0128 pc=0x7102dfb988 word=0xa4680391 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=4616   call_imm? target=vm_base+0xa468038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0075 vm+0x012c pc=0x7102dfb98c word=0x0800200f op=0x0f BR_COND         fetch=0x4e194 line=4701   branch_cond? target=pc+4+0x8200 src=v0 cmp=v0 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0076 vm+0x0130 pc=0x7102dfb990 word=0x80800218 op=0x18 OP18            fetch=0x52ab8 line=4791   op18/version-specific? dst=v0 src=v4 lo12=0x218 imm16=0x0808 ; 350 trace hits this handler; exact semantics still version-verify
0077 vm+0x0134 pc=0x7102dfb994 word=0xe03a089a op=0x1a BR_COND         fetch=0x54acc line=4851   branch_cond? target=pc+4+0x3888 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0078 vm+0x0138 pc=0x7102dfb998 word=0xc03a091a op=0x1a BR_COND         fetch=0x56264 line=4906   branch_cond? target=pc+4+0x3090 src=v1 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0079 vm+0x013c pc=0x7102dfb99c word=0x246c0391 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=4962   call_imm? target=vm_base+0x246c038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0080 vm+0x0140 pc=0x7102dfb9a0 word=0xa83a804f op=0x0f BR_COND         fetch=0x4e194 line=5045   branch_cond? target=pc+4-0x1d5fc src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0081 vm+0x0144 pc=0x7102dfb9a4 word=0xc01a421a op=0x1a BR_COND         fetch=0x52ab8 line=5135   branch_cond? target=pc+4+0x13020 src=v0 cmp=v26 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0082 vm+0x0148 pc=0x7102dfb9a8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=5195   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0083 vm+0x014c pc=0x7102dfb9ac word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=5278   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0084 vm+0x0150 pc=0x7102dfb9b0 word=0x0c6a0391 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=5393   call_imm? target=vm_base+0xc6a038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0085 vm+0x0154 pc=0x7102dfb9b4 word=0x801a509a op=0x1a BR_COND         fetch=0x4e194 line=5478   branch_cond? target=pc+4+0x16008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0086 vm+0x0158 pc=0x7102dfb9b8 word=0x84801698 op=0x18 OP18            fetch=0x56264 line=5535   op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x185a ; 350 trace hits this handler; exact semantics still version-verify
0087 vm+0x015c pc=0x7102dfb9bc word=0x00800016 op=0x16 ST32_UNALIGNED_R fetch=0x54acc line=5591   store_unaligned_u32(right/high-byte merge) [v4 + +0x0], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0088 vm+0x0160 pc=0x7102dfb9c0 word=0x000400ad op=0x2d BR_COND         fetch=0x56f24 line=5647   branch_cond? target=pc+4+0x8 src=v0 cmp=v4 lo12=0x0ad ; conditional VM-PC control family, from z/ws/vm64.cpp
0089 vm+0x0164 pc=0x7102dfb9c4 word=0x0801003b op=0x3b ST64            fetch=0x53f4c line=5741   store_u64 [v0 + +0x80], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0090 vm+0x0168 pc=0x7102dfb9c8 word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=5788   store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0091 vm+0x016c pc=0x7102dfb9cc word=0xc01a191a op=0x1a BR_COND         fetch=0x56f24 line=5845   branch_cond? target=pc+4+0x7090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0092 vm+0x0170 pc=0x7102dfb9d0 word=0x80501a18 op=0x18 OP18            fetch=0x56264 line=5901   op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0093 vm+0x0174 pc=0x7102dfb9d4 word=0x838856d8 op=0x18 OP18            fetch=0x54acc line=5957   op18/version-specific? dst=v8 src=v28 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0094 vm+0x0178 pc=0x7102dfb9d8 word=0xa03b0f1a op=0x1a BR_COND         fetch=0x54acc line=6012   branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0095 vm+0x017c pc=0x7102dfb9dc word=0x803a089a op=0x1a BR_COND         fetch=0x56264 line=6067   branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0096 vm+0x0180 pc=0x7102dfb9e0 word=0xa83a004f op=0x0f BR_COND         fetch=0x56264 line=6123   branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0097 vm+0x0184 pc=0x7102dfb9e4 word=0x81005698 op=0x18 OP18            fetch=0x52ab8 line=6212   op18/version-specific? dst=v0 src=v8 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0098 vm+0x0188 pc=0x7102dfb9e8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=6272   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0099 vm+0x018c pc=0x7102dfb9ec word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=6354   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0100 vm+0x0190 pc=0x7102dfb9f0 word=0x80800118 op=0x18 OP18            fetch=0x4f8e0 line=6466   op18/version-specific? dst=v0 src=v4 lo12=0x118 imm16=0x0804 ; 350 trace hits this handler; exact semantics still version-verify
0101 vm+0x0194 pc=0x7102dfb9f4 word=0x0004036d op=0x2d BR_COND         fetch=0x54acc line=6524   branch_cond? target=pc+4+0x34 src=v0 cmp=v4 lo12=0x36d ; conditional VM-PC control family, from z/ws/vm64.cpp
0102 vm+0x0198 pc=0x7102dfb9f8 word=0x24660391 op=0x11 CALL_IMM_LINK31 fetch=0x53f4c line=6617   call_imm? target=vm_base+0x2466038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0103 vm+0x019c pc=0x7102dfb9fc word=0x80581218 op=0x18 OP18            fetch=0x4e194 line=6701   op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x1808 ; 350 trace hits this handler; exact semantics still version-verify
0104 vm+0x01a0 pc=0x7102dfba00 word=0xe03a011a op=0x1a BR_COND         fetch=0x54acc line=6758   branch_cond? target=pc+4+0x3810 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0105 vm+0x01a4 pc=0x7102dfba04 word=0x915ac00f op=0x0f BR_COND         fetch=0x56264 line=6813   branch_cond? target=pc+4-0xdc00 src=v10 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0106 vm+0x01a8 pc=0x7102dfba08 word=0xc03a011a op=0x1a BR_COND         fetch=0x52ab8 line=6902   branch_cond? target=pc+4+0x3010 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0107 vm+0x01ac pc=0x7102dfba0c word=0xa03a009a op=0x1a BR_COND         fetch=0x56264 line=6962   branch_cond? target=pc+4+0x2808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0108 vm+0x01b0 pc=0x7102dfba10 word=0xa81a404f op=0x0f BR_COND         fetch=0x56264 line=7018   branch_cond? target=pc+4+0x12a04 src=v0 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0109 vm+0x01b4 pc=0x7102dfba14 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x52ab8 line=7107   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0110 vm+0x01b8 pc=0x7102dfba18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=7194   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0111 vm+0x01bc pc=0x7102dfba1c word=0x3439e7f4 op=0x34 OP34            fetch=0x4f8e0 line=25223  op34? dst=v25 src=v1 lo12=0x7f4 imm16=0xe35f ; unknown/no-op-ish in current reconstruction
0112 vm+0x01c0 pc=0x7102dfba20 word=0x95c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x532f4 line=25305  call_imm? target=vm_base+0x95c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0113 vm+0x01c4 pc=0x7102dfba24 word=0x80983698 op=0x18 OP18            fetch=0x4f5d8 line=25390  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0114 vm+0x01c8 pc=0x7102dfba28 word=0x0017200d op=0x0d ADD64_IMM       fetch=0x54acc line=25447  v23 = (u64)v0 + +0x2000 ; dst = src + simm16, from z/ws/vm64.cpp
0115 vm+0x025c pc=0x7102dfbabc word=0x9c440391 op=0x11 CALL_IMM_LINK31 fetch=0x536b0 line=25550  call_imm? target=vm_base+0x9c44038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0116 vm+0x0260 pc=0x7102dfbac0 word=0x80985698 op=0x18 OP18            fetch=0x4e194 line=25634  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0117 vm+0x0264 pc=0x7102dfbac4 word=0x000400ad op=0x2d BR_COND         fetch=0x54acc line=25691  branch_cond? target=pc+4+0x8 src=v0 cmp=v4 lo12=0x0ad ; conditional VM-PC control family, from z/ws/vm64.cpp
0118 vm+0x0268 pc=0x7102dfbac8 word=0x080c2001 op=0x01 OP01            fetch=0x53f4c line=25784  op01? dst=v12 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0119 vm+0x026c pc=0x7102dfbacc word=0x0806002b op=0x2b LD32S           fetch=0x5581c line=25863  v6 = load_i32 [v0 + +0x80] ; dst = *(int32_t *)(src + simm16), from z/ws/vm64.cpp
0120 vm+0x0288 pc=0x7102dfbae8 word=0xe01b319a op=0x1a BR_COND         fetch=0x53d04 line=25959  branch_cond? target=pc+4+0xf818 src=v0 cmp=v27 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0121 vm+0x028c pc=0x7102dfbaec word=0x80481a18 op=0x18 OP18            fetch=0x56264 line=26017  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0122 vm+0x0290 pc=0x7102dfbaf0 word=0x80985698 op=0x18 OP18            fetch=0x54acc line=26073  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0123 vm+0x0294 pc=0x7102dfbaf4 word=0xe03a111a op=0x1a BR_COND         fetch=0x54acc line=26128  branch_cond? target=pc+4+0x7810 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0124 vm+0x0298 pc=0x7102dfbaf8 word=0xc03b171a op=0x1a BR_COND         fetch=0x56264 line=26183  branch_cond? target=pc+4+0x7070 src=v1 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0125 vm+0x029c pc=0x7102dfbafc word=0xa03a109a op=0x1a BR_COND         fetch=0x56264 line=26239  branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0126 vm+0x02a0 pc=0x7102dfbb00 word=0xa85a404f op=0x0f BR_COND         fetch=0x56264 line=26295  branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0127 vm+0x02a4 pc=0x7102dfbb04 word=0x80d04ed8 op=0x18 OP18            fetch=0x52ab8 line=26384  op18/version-specific? dst=v16 src=v6 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0128 vm+0x02a8 pc=0x7102dfbb08 word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=26444  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0129 vm+0x02ac pc=0x7102dfbb0c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=26526  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0130 vm+0x02b0 pc=0x7102dfbb10 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=26610  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0131 vm+0x02b4 pc=0x7102dfbb14 word=0x80805e98 op=0x18 OP18            fetch=0x4f8e0 line=26755  op18/version-specific? dst=v0 src=v4 lo12=0xe98 imm16=0x583a ; 350 trace hits this handler; exact semantics still version-verify
0132 vm+0x02b8 pc=0x7102dfbb18 word=0x81d856d8 op=0x18 OP18            fetch=0x54acc line=26813  op18/version-specific? dst=v24 src=v14 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0133 vm+0x02bc pc=0x7102dfbb1c word=0x000400ed op=0x2d BR_COND         fetch=0x54acc line=26868  branch_cond? target=pc+4+0xc src=v0 cmp=v4 lo12=0x0ed ; conditional VM-PC control family, from z/ws/vm64.cpp
0134 vm+0x02c0 pc=0x7102dfbb20 word=0x08002001 op=0x01 OP01            fetch=0x53f4c line=26961  op01? dst=v0 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0135 vm+0x02c4 pc=0x7102dfbb24 word=0x0801103b op=0x3b ST64            fetch=0x5581c line=27040  store_u64 [v0 + +0x1080], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0136 vm+0x02c8 pc=0x7102dfbb28 word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=27090  store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0137 vm+0x02cc pc=0x7102dfbb2c word=0x0c640391 op=0x11 CALL_IMM_LINK31 fetch=0x56f24 line=27147  call_imm? target=vm_base+0xc64038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0138 vm+0x02d0 pc=0x7102dfbb30 word=0xa01a209a op=0x1a BR_COND         fetch=0x4e194 line=27230  branch_cond? target=pc+4+0xa808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0139 vm+0x02d4 pc=0x7102dfbb34 word=0x80483e98 op=0x18 OP18            fetch=0x56264 line=27287  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0140 vm+0x02d8 pc=0x7102dfbb38 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=27343  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0141 vm+0x02dc pc=0x7102dfbb3c word=0x801a209a op=0x1a BR_COND         fetch=0x4e194 line=27425  branch_cond? target=pc+4+0xa008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0142 vm+0x02e0 pc=0x7102dfbb40 word=0x80503e98 op=0x18 OP18            fetch=0x56264 line=27482  op18/version-specific? dst=v16 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0143 vm+0x02e4 pc=0x7102dfbb44 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=27538  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0144 vm+0x02e8 pc=0x7102dfbb48 word=0xa01a389a op=0x1a BR_COND         fetch=0x4e194 line=27620  branch_cond? target=pc+4+0xe888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0145 vm+0x02ec pc=0x7102dfbb4c word=0x80484e98 op=0x18 OP18            fetch=0x56264 line=27677  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0146 vm+0x02f0 pc=0x7102dfbb50 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=27733  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0147 vm+0x02f4 pc=0x7102dfbb54 word=0xa01a489a op=0x1a BR_COND         fetch=0x4e194 line=27815  branch_cond? target=pc+4+0x12888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0148 vm+0x02f8 pc=0x7102dfbb58 word=0x80583e98 op=0x18 OP18            fetch=0x56264 line=27872  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0149 vm+0x02fc pc=0x7102dfbb5c word=0xac420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=27928  call_imm? target=vm_base+0xac42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0150 vm+0x0300 pc=0x7102dfbb60 word=0x80584e98 op=0x18 OP18            fetch=0x4e194 line=28010  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0151 vm+0x0304 pc=0x7102dfbb64 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=28067  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0152 vm+0x0308 pc=0x7102dfbb68 word=0xe01a489a op=0x1a BR_COND         fetch=0x4e194 line=28149  branch_cond? target=pc+4+0x13888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0153 vm+0x030c pc=0x7102dfbb6c word=0x80584698 op=0x18 OP18            fetch=0x56264 line=28206  op18/version-specific? dst=v24 src=v2 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0154 vm+0x0310 pc=0x7102dfbb70 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=28262  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0155 vm+0x0314 pc=0x7102dfbb74 word=0xe01a189a op=0x1a BR_COND         fetch=0x4e194 line=28344  branch_cond? target=pc+4+0x7888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0156 vm+0x0318 pc=0x7102dfbb78 word=0x80501a18 op=0x18 OP18            fetch=0x56264 line=28401  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0157 vm+0x031c pc=0x7102dfbb7c word=0xa03b0f1a op=0x1a BR_COND         fetch=0x54acc line=28457  branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0158 vm+0x0320 pc=0x7102dfbb80 word=0x803a089a op=0x1a BR_COND         fetch=0x56264 line=28512  branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0159 vm+0x0324 pc=0x7102dfbb84 word=0xa83a004f op=0x0f BR_COND         fetch=0x56264 line=28568  branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0160 vm+0x0328 pc=0x7102dfbb88 word=0x808056d8 op=0x18 OP18            fetch=0x52ab8 line=28657  op18/version-specific? dst=v0 src=v4 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0161 vm+0x032c pc=0x7102dfbb8c word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=28717  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0162 vm+0x0330 pc=0x7102dfbb90 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=28799  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0163 vm+0x0334 pc=0x7102dfbb94 word=0xe01a411a op=0x1a BR_COND         fetch=0x4f5d8 line=28883  branch_cond? target=pc+4+0x13810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0164 vm+0x0338 pc=0x7102dfbb98 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=28940  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0165 vm+0x033c pc=0x7102dfbb9c word=0xa85a404f op=0x0f BR_COND         fetch=0x4f8e0 line=29051  branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0166 vm+0x0340 pc=0x7102dfbba0 word=0x80481a18 op=0x18 OP18            fetch=0x52ab8 line=29142  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0167 vm+0x0344 pc=0x7102dfbba4 word=0xe03b139a op=0x1a BR_COND         fetch=0x54acc line=29202  branch_cond? target=pc+4+0x7838 src=v1 cmp=v27 lo12=0x39a ; conditional VM-PC control family, from z/ws/vm64.cpp
0168 vm+0x0348 pc=0x7102dfbba8 word=0xc03b171a op=0x1a BR_COND         fetch=0x56264 line=29257  branch_cond? target=pc+4+0x7070 src=v1 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0169 vm+0x034c pc=0x7102dfbbac word=0xa03a109a op=0x1a BR_COND         fetch=0x56264 line=29313  branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0170 vm+0x0350 pc=0x7102dfbbb0 word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=29369  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0171 vm+0x0354 pc=0x7102dfbbb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=29452  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0172 vm+0x0358 pc=0x7102dfbbb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=29536  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0173 vm+0x035c pc=0x7102dfbbbc word=0x80984698 op=0x18 OP18            fetch=0x4f8e0 line=29681  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0174 vm+0x0360 pc=0x7102dfbbc0 word=0x000400ed op=0x2d BR_COND         fetch=0x54acc line=29739  branch_cond? target=pc+4+0xc src=v0 cmp=v4 lo12=0x0ed ; conditional VM-PC control family, from z/ws/vm64.cpp
0175 vm+0x0364 pc=0x7102dfbbc4 word=0x08002001 op=0x01 OP01            fetch=0x53f4c line=29832  op01? dst=v0 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0176 vm+0x0368 pc=0x7102dfbbc8 word=0x0801103b op=0x3b ST64            fetch=0x5581c line=29911  store_u64 [v0 + +0x1080], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0177 vm+0x036c pc=0x7102dfbbcc word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=29961  store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0178 vm+0x0370 pc=0x7102dfbbd0 word=0x9b02c330 op=0x30 LD16U           fetch=0x56f24 line=30018  v2 = load_u16 [v24 + -0x3674] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0179 vm+0x0374 pc=0x7102dfbbd4 word=0xe01a209a op=0x1a BR_COND         fetch=0x533dc line=30074  branch_cond? target=pc+4+0xb808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0180 vm+0x0378 pc=0x7102dfbbd8 word=0x80484698 op=0x18 OP18            fetch=0x56264 line=30130  op18/version-specific? dst=v8 src=v2 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0181 vm+0x037c pc=0x7102dfbbdc word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=30186  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0182 vm+0x0380 pc=0x7102dfbbe0 word=0xc01a209a op=0x1a BR_COND         fetch=0x4e194 line=30268  branch_cond? target=pc+4+0xb008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0183 vm+0x0384 pc=0x7102dfbbe4 word=0x80404e98 op=0x18 OP18            fetch=0x56264 line=30325  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0184 vm+0x0388 pc=0x7102dfbbe8 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=30381  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0185 vm+0x038c pc=0x7102dfbbec word=0xc01a389a op=0x1a BR_COND         fetch=0x4e194 line=30463  branch_cond? target=pc+4+0xf088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0186 vm+0x0390 pc=0x7102dfbbf0 word=0x80501a18 op=0x18 OP18            fetch=0x56264 line=30520  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0187 vm+0x0394 pc=0x7102dfbbf4 word=0xa03b0f1a op=0x1a BR_COND         fetch=0x54acc line=30576  branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0188 vm+0x0398 pc=0x7102dfbbf8 word=0x803a089a op=0x1a BR_COND         fetch=0x56264 line=30631  branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0189 vm+0x039c pc=0x7102dfbbfc word=0xa83a004f op=0x0f BR_COND         fetch=0x56264 line=30687  branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0190 vm+0x03a0 pc=0x7102dfbc00 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x52ab8 line=30776  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0191 vm+0x03a4 pc=0x7102dfbc04 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=30863  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0192 vm+0x03a8 pc=0x7102dfbc08 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=30947  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0193 vm+0x03ac pc=0x7102dfbc0c word=0xabfa800f op=0x0f BR_COND         fetch=0x4f8e0 line=31059  branch_cond? target=pc+4-0x1d600 src=v31 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0194 vm+0x03b0 pc=0x7102dfbc10 word=0xe01a129a op=0x1a BR_COND         fetch=0x52ab8 line=31150  branch_cond? target=pc+4+0x7828 src=v0 cmp=v26 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0195 vm+0x03b4 pc=0x7102dfbc14 word=0x80500398 op=0x18 OP18            fetch=0x56264 line=31210  op18/version-specific? dst=v16 src=v2 lo12=0x398 imm16=0x080e ; 350 trace hits this handler; exact semantics still version-verify
0196 vm+0x03b8 pc=0x7102dfbc18 word=0x08001001 op=0x01 OP01            fetch=0x54acc line=31266  op01? dst=v0 src=v0 lo12=0x001 imm16=0x1080 ; unknown/no-op-ish in current reconstruction
0197 vm+0x03bc pc=0x7102dfbc1c word=0x835c13d6 op=0x16 ST32_UNALIGNED_R fetch=0x5581c line=31343  store_unaligned_u32(right/high-byte merge) [v26 + +0x180f], v28 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0198 vm+0x03c0 pc=0x7102dfbc20 word=0x80582218 op=0x18 OP18            fetch=0x56f24 line=31404  op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0199 vm+0x03c4 pc=0x7102dfbc24 word=0xe01bff1a op=0x1a BR_COND         fetch=0x54acc line=31460  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0200 vm+0x03c8 pc=0x7102dfbc28 word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=31515  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0201 vm+0x03cc pc=0x7102dfbc2c word=0x81184e98 op=0x18 OP18            fetch=0x56264 line=31571  op18/version-specific? dst=v24 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0202 vm+0x03d0 pc=0x7102dfbc30 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=31627  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0203 vm+0x03d4 pc=0x7102dfbc34 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=31709  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0204 vm+0x03d8 pc=0x7102dfbc38 word=0x9bdb800f op=0x0f BR_COND         fetch=0x4f8e0 line=31827  branch_cond? target=pc+4-0x1da00 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0205 vm+0x03dc pc=0x7102dfbc3c word=0x80581a18 op=0x18 OP18            fetch=0x52ab8 line=31918  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0206 vm+0x03e0 pc=0x7102dfbc40 word=0x808046d8 op=0x18 OP18            fetch=0x54acc line=31978  op18/version-specific? dst=v0 src=v4 lo12=0x6d8 imm16=0x481b ; 350 trace hits this handler; exact semantics still version-verify
0207 vm+0x03e4 pc=0x7102dfbc44 word=0x801bf91a op=0x1a BR_COND         fetch=0x54acc line=32033  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0208 vm+0x03e8 pc=0x7102dfbc48 word=0xe01bf71a op=0x1a BR_COND         fetch=0x56264 line=32088  branch_cond? target=pc+4-0x790 src=v0 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0209 vm+0x03ec pc=0x7102dfbc4c word=0xc01af09a op=0x1a BR_COND         fetch=0x56264 line=32144  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0210 vm+0x03f0 pc=0x7102dfbc50 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=32200  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0211 vm+0x03f4 pc=0x7102dfbc54 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=32283  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0212 vm+0x03f8 pc=0x7102dfbc58 word=0xc01b119a op=0x1a BR_COND         fetch=0x4f5d8 line=32367  branch_cond? target=pc+4+0x7018 src=v0 cmp=v27 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0213 vm+0x03fc pc=0x7102dfbc5c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=32424  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0214 vm+0x0400 pc=0x7102dfbc60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=32507  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0215 vm+0x0404 pc=0x7102dfbc64 word=0xb7800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=32671  call_imm? target=vm_base+0xb7800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0216 vm+0x0408 pc=0x7102dfbc68 word=0xabba800f op=0x0f BR_COND         fetch=0x4f5d8 line=32756  branch_cond? target=pc+4-0x1d600 src=v29 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0217 vm+0x040c pc=0x7102dfbc6c word=0x801a1a9a op=0x1a BR_COND         fetch=0x52ab8 line=32846  branch_cond? target=pc+4+0x60a8 src=v0 cmp=v26 lo12=0xa9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0218 vm+0x0410 pc=0x7102dfbc70 word=0xf21b000f op=0x0f BR_COND         fetch=0x56264 line=32906  branch_cond? target=pc+4+0x3c00 src=v16 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0219 vm+0x0414 pc=0x7102dfbc74 word=0x801b4f1a op=0x1a BR_COND         fetch=0x52ab8 line=32995  branch_cond? target=pc+4+0x120f0 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0220 vm+0x0418 pc=0x7102dfbc78 word=0xe01b3b9a op=0x1a BR_COND         fetch=0x56264 line=33055  branch_cond? target=pc+4+0xf8b8 src=v0 cmp=v27 lo12=0xb9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0221 vm+0x041c pc=0x7102dfbc7c word=0x99da800f op=0x0f BR_COND         fetch=0x56264 line=33111  branch_cond? target=pc+4-0x1da00 src=v14 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0222 vm+0x0420 pc=0x7102dfbc80 word=0xa01a419a op=0x1a BR_COND         fetch=0x52ab8 line=33200  branch_cond? target=pc+4+0x12818 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0223 vm+0x0424 pc=0x7102dfbc84 word=0x1004003b op=0x3b ST64            fetch=0x56264 line=33260  store_u64 [v0 + +0x100], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0224 vm+0x0428 pc=0x7102dfbc88 word=0x89fcd001 op=0x01 OP01            fetch=0x52d8c line=33306  op01? dst=v28 src=v15 lo12=0x001 imm16=0xd880 ; unknown/no-op-ish in current reconstruction
0225 vm+0x042c pc=0x7102dfbc8c word=0x83501396 op=0x16 ST32_UNALIGNED_R fetch=0x5581c line=33384  store_unaligned_u32(right/high-byte merge) [v26 + +0x180e], v16 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0226 vm+0x0430 pc=0x7102dfbc90 word=0x80402218 op=0x18 OP18            fetch=0x56f24 line=33445  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0227 vm+0x0434 pc=0x7102dfbc94 word=0x83482796 op=0x16 ST32_UNALIGNED_R fetch=0x54acc line=33501  store_unaligned_u32(right/high-byte merge) [v26 + +0x281e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0228 vm+0x0438 pc=0x7102dfbc98 word=0x801af19a op=0x1a BR_COND         fetch=0x56f24 line=33557  branch_cond? target=pc+4-0x1fe8 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0229 vm+0x043c pc=0x7102dfbc9c word=0xe01bef1a op=0x1a BR_COND         fetch=0x56264 line=33613  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0230 vm+0x0440 pc=0x7102dfbca0 word=0xc01ae89a op=0x1a BR_COND         fetch=0x56264 line=33669  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0231 vm+0x0444 pc=0x7102dfbca4 word=0x81c84ed8 op=0x18 OP18            fetch=0x56264 line=33725  op18/version-specific? dst=v8 src=v14 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0232 vm+0x0448 pc=0x7102dfbca8 word=0x25c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=33781  call_imm? target=vm_base+0x25c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0233 vm+0x044c pc=0x7102dfbcac word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=33863  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0234 vm+0x0450 pc=0x7102dfbcb0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=33947  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0235 vm+0x0454 pc=0x7102dfbcb4 word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=34088  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0236 vm+0x0458 pc=0x7102dfbcb8 word=0x801bff1a op=0x1a BR_COND         fetch=0x54acc line=34146  branch_cond? target=pc+4-0x1f10 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0237 vm+0x045c pc=0x7102dfbcbc word=0xe01bf31a op=0x1a BR_COND         fetch=0x56264 line=34201  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0238 vm+0x0460 pc=0x7102dfbcc0 word=0xc01af09a op=0x1a BR_COND         fetch=0x56264 line=34257  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0239 vm+0x0464 pc=0x7102dfbcc4 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=34313  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0240 vm+0x0468 pc=0x7102dfbcc8 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34396  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0241 vm+0x046c pc=0x7102dfbccc word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34480  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0242 vm+0x0470 pc=0x7102dfbcd0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34564  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0243 vm+0x0474 pc=0x7102dfbcd4 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=34826  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0244 vm+0x0478 pc=0x7102dfbcd8 word=0xe01bff1a op=0x1a BR_COND         fetch=0x54acc line=34884  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0245 vm+0x047c pc=0x7102dfbcdc word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=34939  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0246 vm+0x0480 pc=0x7102dfbce0 word=0x81184e98 op=0x18 OP18            fetch=0x56264 line=34995  op18/version-specific? dst=v24 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0247 vm+0x0484 pc=0x7102dfbce4 word=0x839816d8 op=0x18 OP18            fetch=0x54acc line=35051  op18/version-specific? dst=v24 src=v28 lo12=0x6d8 imm16=0x181b ; 350 trace hits this handler; exact semantics still version-verify
0248 vm+0x0488 pc=0x7102dfbce8 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=35106  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0249 vm+0x048c pc=0x7102dfbcec word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35188  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0250 vm+0x0490 pc=0x7102dfbcf0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35272  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0251 vm+0x0494 pc=0x7102dfbcf4 word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=35390  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0252 vm+0x0498 pc=0x7102dfbcf8 word=0x801bf91a op=0x1a BR_COND         fetch=0x54acc line=35448  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0253 vm+0x049c pc=0x7102dfbcfc word=0xe01bf31a op=0x1a BR_COND         fetch=0x56264 line=35503  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0254 vm+0x04a0 pc=0x7102dfbd00 word=0xc01af09a op=0x1a BR_COND         fetch=0x56264 line=35559  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0255 vm+0x04a4 pc=0x7102dfbd04 word=0x801b329a op=0x1a BR_COND         fetch=0x56264 line=35615  branch_cond? target=pc+4+0xe028 src=v0 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0256 vm+0x04a8 pc=0x7102dfbd08 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=35671  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0257 vm+0x04ac pc=0x7102dfbd0c word=0x81501698 op=0x18 OP18            fetch=0x4f5d8 line=35754  op18/version-specific? dst=v16 src=v10 lo12=0x698 imm16=0x181a ; 350 trace hits this handler; exact semantics still version-verify
0258 vm+0x04b0 pc=0x7102dfbd10 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=35811  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0259 vm+0x04b4 pc=0x7102dfbd14 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35893  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0260 vm+0x04b8 pc=0x7102dfbd18 word=0xab9a800f op=0x0f BR_COND         fetch=0x4f8e0 line=36057  branch_cond? target=pc+4-0x1d600 src=v28 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0261 vm+0x04bc pc=0x7102dfbd1c word=0x91fa400f op=0x0f BR_COND         fetch=0x52ab8 line=36148  branch_cond? target=pc+4+0x12400 src=v15 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0262 vm+0x04c0 pc=0x7102dfbd20 word=0x80482a18 op=0x18 OP18            fetch=0x52ab8 line=36241  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x2828 ; 350 trace hits this handler; exact semantics still version-verify
0263 vm+0x04c4 pc=0x7102dfbd24 word=0xf51a0010 op=0x10 BITFIELD        fetch=0x54acc line=36301  bitfield/rev/extract? dst=v26 src=v8 lo12=0x010 ; bitfield extract/insert/sign-extend/rev family, from z/ws/vm64.cpp
0264 vm+0x04c8 pc=0x7102dfbd28 word=0x801beb1a op=0x1a BR_COND         fetch=0x56c18 line=36382  branch_cond? target=pc+4-0x5f50 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0265 vm+0x04cc pc=0x7102dfbd2c word=0xa01a091a op=0x1a BR_COND         fetch=0x56264 line=36440  branch_cond? target=pc+4+0x2890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0266 vm+0x04d0 pc=0x7102dfbd30 word=0xe01ae11a op=0x1a BR_COND         fetch=0x56264 line=36496  branch_cond? target=pc+4-0x47f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0267 vm+0x04d4 pc=0x7102dfbd34 word=0xc01ae09a op=0x1a BR_COND         fetch=0x56264 line=36552  branch_cond? target=pc+4-0x4ff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0268 vm+0x04d8 pc=0x7102dfbd38 word=0x81083e98 op=0x18 OP18            fetch=0x56264 line=36608  op18/version-specific? dst=v8 src=v8 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0269 vm+0x04dc pc=0x7102dfbd3c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=36664  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0270 vm+0x04e0 pc=0x7102dfbd40 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=36746  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0271 vm+0x04e4 pc=0x7102dfbd44 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=38012  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0272 vm+0x04e8 pc=0x7102dfbd48 word=0xe01bfb1a op=0x1a BR_COND         fetch=0x54acc line=38070  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0273 vm+0x04ec pc=0x7102dfbd4c word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=38125  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0274 vm+0x04f0 pc=0x7102dfbd50 word=0x80984ed8 op=0x18 OP18            fetch=0x56264 line=38181  op18/version-specific? dst=v24 src=v4 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0275 vm+0x04f4 pc=0x7102dfbd54 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=38237  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0276 vm+0x04f8 pc=0x7102dfbd58 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38319  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0277 vm+0x04fc pc=0x7102dfbd5c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38403  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0278 vm+0x0500 pc=0x7102dfbd60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38487  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0279 vm+0x0504 pc=0x7102dfbd64 word=0x80983e98 op=0x18 OP18            fetch=0x4f8e0 line=38605  op18/version-specific? dst=v24 src=v4 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0280 vm+0x0508 pc=0x7102dfbd68 word=0x00500118 op=0x18 OP18            fetch=0x54acc line=38663  op18/version-specific? dst=v16 src=v2 lo12=0x118 imm16=0x0004 ; 350 trace hits this handler; exact semantics still version-verify
0281 vm+0x050c pc=0x7102dfbd6c word=0x100c2001 op=0x01 OP01            fetch=0x54acc line=38718  op01? dst=v12 src=v0 lo12=0x001 imm16=0x2100 ; unknown/no-op-ish in current reconstruction
0282 vm+0x0510 pc=0x7102dfbd70 word=0x80c02218 op=0x18 OP18            fetch=0x5581c line=38795  op18/version-specific? dst=v0 src=v6 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0283 vm+0x0514 pc=0x7102dfbd74 word=0x814846d8 op=0x18 OP18            fetch=0x54acc line=38855  op18/version-specific? dst=v8 src=v10 lo12=0x6d8 imm16=0x481b ; 350 trace hits this handler; exact semantics still version-verify
0284 vm+0x0518 pc=0x7102dfbd78 word=0xe01bea9a op=0x1a BR_COND         fetch=0x54acc line=38910  branch_cond? target=pc+4-0x4758 src=v0 cmp=v27 lo12=0xa9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0285 vm+0x051c pc=0x7102dfbd7c word=0xc01ae99a op=0x1a BR_COND         fetch=0x56264 line=38965  branch_cond? target=pc+4-0x4f68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0286 vm+0x0520 pc=0x7102dfbd80 word=0x17fc27fb op=0x3b ST64            fetch=0x56264 line=39021  store_u64 [v31 + +0x215f], v28 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0287 vm+0x0524 pc=0x7102dfbd84 word=0x83482796 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=39067  store_unaligned_u32(right/high-byte merge) [v26 + +0x281e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0288 vm+0x0528 pc=0x7102dfbd88 word=0x0802200f op=0x0f BR_COND         fetch=0x56f24 line=39124  branch_cond? target=pc+4+0x8200 src=v0 cmp=v2 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0289 vm+0x052c pc=0x7102dfbd8c word=0x801af09a op=0x1a BR_COND         fetch=0x52ab8 line=39213  branch_cond? target=pc+4-0x1ff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0290 vm+0x0530 pc=0x7102dfbd90 word=0x25c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=39273  call_imm? target=vm_base+0x25c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0291 vm+0x0534 pc=0x7102dfbd94 word=0x81401e98 op=0x18 OP18            fetch=0x4f5d8 line=39356  op18/version-specific? dst=v0 src=v10 lo12=0xe98 imm16=0x183a ; 350 trace hits this handler; exact semantics still version-verify
0292 vm+0x0538 pc=0x7102dfbd98 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=39413  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0293 vm+0x053c pc=0x7102dfbd9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=39495  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0294 vm+0x0540 pc=0x7102dfbda0 word=0xab7ac00f op=0x0f BR_COND         fetch=0x4f8e0 line=39650  branch_cond? target=pc+4-0xd600 src=v27 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0295 vm+0x0544 pc=0x7102dfbda4 word=0x80c87ed8 op=0x18 OP18            fetch=0x52ab8 line=39741  op18/version-specific? dst=v8 src=v6 lo12=0xed8 imm16=0x783b ; 350 trace hits this handler; exact semantics still version-verify
0296 vm+0x0548 pc=0x7102dfbda8 word=0x80480a18 op=0x18 OP18            fetch=0x54acc line=39801  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0297 vm+0x054c pc=0x7102dfbdac word=0x80981e98 op=0x18 OP18            fetch=0x54acc line=39856  op18/version-specific? dst=v24 src=v4 lo12=0xe98 imm16=0x183a ; 350 trace hits this handler; exact semantics still version-verify
0298 vm+0x0550 pc=0x7102dfbdb0 word=0xa01ae11a op=0x1a BR_COND         fetch=0x54acc line=39911  branch_cond? target=pc+4-0x57f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0299 vm+0x0554 pc=0x7102dfbdb4 word=0x801be31a op=0x1a BR_COND         fetch=0x56264 line=39966  branch_cond? target=pc+4-0x5fd0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0300 vm+0x0558 pc=0x7102dfbdb8 word=0xe01ad89a op=0x1a BR_COND         fetch=0x56264 line=40022  branch_cond? target=pc+4-0x8778 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0301 vm+0x055c pc=0x7102dfbdbc word=0x81002698 op=0x18 OP18            fetch=0x56264 line=40078  op18/version-specific? dst=v0 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0302 vm+0x0560 pc=0x7102dfbdc0 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=40134  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0303 vm+0x0564 pc=0x7102dfbdc4 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=40216  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0304 vm+0x0568 pc=0x7102dfbdc8 word=0xab5a400f op=0x0f BR_COND         fetch=0x4f8e0 line=40357  branch_cond? target=pc+4+0x12a00 src=v26 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0305 vm+0x056c pc=0x7102dfbdcc word=0x91da000f op=0x0f BR_COND         fetch=0x52ab8 line=40448  branch_cond? target=pc+4+0x2400 src=v14 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0306 vm+0x0570 pc=0x7102dfbdd0 word=0x83400416 op=0x16 ST32_UNALIGNED_R fetch=0x52ab8 line=40541  store_unaligned_u32(right/high-byte merge) [v26 + +0x810], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0307 vm+0x0574 pc=0x7102dfbdd4 word=0x80502a18 op=0x18 OP18            fetch=0x56f24 line=40602  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x2828 ; 350 trace hits this handler; exact semantics still version-verify
0308 vm+0x0578 pc=0x7102dfbdd8 word=0x80c04e98 op=0x18 OP18            fetch=0x54acc line=40658  op18/version-specific? dst=v0 src=v6 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0309 vm+0x057c pc=0x7102dfbddc word=0xc01ad99a op=0x1a BR_COND         fetch=0x54acc line=40713  branch_cond? target=pc+4-0x8f68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0310 vm+0x0580 pc=0x7102dfbde0 word=0xa01bdb1a op=0x1a BR_COND         fetch=0x56264 line=40768  branch_cond? target=pc+4-0x9750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0311 vm+0x0584 pc=0x7102dfbde4 word=0x801bd99a op=0x1a BR_COND         fetch=0x56264 line=40824  branch_cond? target=pc+4-0x9f68 src=v0 cmp=v27 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0312 vm+0x0588 pc=0x7102dfbde8 word=0x9c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=40880  call_imm? target=vm_base+0x9c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0313 vm+0x058c pc=0x7102dfbdec word=0xe01bd29a op=0x1a BR_COND         fetch=0x4f5d8 line=40963  branch_cond? target=pc+4-0x87d8 src=v0 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0314 vm+0x0590 pc=0x7102dfbdf0 word=0xc01a091a op=0x1a BR_COND         fetch=0x56264 line=41020  branch_cond? target=pc+4+0x3090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0315 vm+0x0594 pc=0x7102dfbdf4 word=0xc01ad11a op=0x1a BR_COND         fetch=0x56264 line=41076  branch_cond? target=pc+4-0x8ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0316 vm+0x0598 pc=0x7102dfbdf8 word=0xa01ad09a op=0x1a BR_COND         fetch=0x56264 line=41132  branch_cond? target=pc+4-0x97f8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0317 vm+0x059c pc=0x7102dfbdfc word=0x81082698 op=0x18 OP18            fetch=0x56264 line=41188  op18/version-specific? dst=v8 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0318 vm+0x05a0 pc=0x7102dfbe00 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=41244  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0319 vm+0x05a4 pc=0x7102dfbe04 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=41326  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0320 vm+0x-168 pc=0x7102dfb6f8 word=0x00000000 op=0x00 LD16S           fetch=0x11dac0 line=44380  v0 = load_i16 [v0 + +0x0] ; dst = *(int16_t *)(src + simm16), from z/ws/vm64.cpp
0321 vm+0x-164 pc=0x7102dfb6fc word=0x00000000 op=0x00 LD16S           fetch=0x11db84 line=46887  v0 = load_i16 [v0 + +0x0] ; dst = *(int16_t *)(src + simm16), from z/ws/vm64.cpp
0322 vm+0x05a8 pc=0x7102dfbe08 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=57037  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0323 vm+0x05ac pc=0x7102dfbe0c word=0xe01bfb1a op=0x1a BR_COND         fetch=0x54acc line=57095  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0324 vm+0x05b0 pc=0x7102dfbe10 word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=57150  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0325 vm+0x05b4 pc=0x7102dfbe14 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=57206  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0326 vm+0x05b8 pc=0x7102dfbe18 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57289  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0327 vm+0x05bc pc=0x7102dfbe1c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57373  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0328 vm+0x05c0 pc=0x7102dfbe20 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57457  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0329 vm+0x05c4 pc=0x7102dfbe24 word=0x80407698 op=0x18 OP18            fetch=0x4f8e0 line=57575  op18/version-specific? dst=v0 src=v2 lo12=0x698 imm16=0x781a ; 350 trace hits this handler; exact semantics still version-verify
0330 vm+0x05c8 pc=0x7102dfbe28 word=0x00460014 op=0x14 ST16            fetch=0x54acc line=57633  store_u16 [v2 + +0x0], v6 ; *(src + simm16) = dst.u16, from z/ws/vm64.cpp
0331 vm+0x05e4 pc=0x7102dfbe44 word=0x80482e98 op=0x18 OP18            fetch=0x541f4 line=57727  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0332 vm+0x05e8 pc=0x7102dfbe48 word=0x80982698 op=0x18 OP18            fetch=0x54acc line=57784  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0333 vm+0x05ec pc=0x7102dfbe4c word=0x08820391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=57839  call_imm? target=vm_base+0x882038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0334 vm+0x05f0 pc=0x7102dfbe50 word=0x801a189a op=0x1a BR_COND         fetch=0x4e194 line=57921  branch_cond? target=pc+4+0x6088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0335 vm+0x05f4 pc=0x7102dfbe54 word=0x80402e98 op=0x18 OP18            fetch=0x56264 line=57978  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0336 vm+0x05f8 pc=0x7102dfbe58 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=58034  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0337 vm+0x05fc pc=0x7102dfbe5c word=0x801a109a op=0x1a BR_COND         fetch=0x4e194 line=58116  branch_cond? target=pc+4+0x6008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0338 vm+0x0600 pc=0x7102dfbe60 word=0x80503698 op=0x18 OP18            fetch=0x56264 line=58173  op18/version-specific? dst=v16 src=v2 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0339 vm+0x0604 pc=0x7102dfbe64 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=58229  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0340 vm+0x0608 pc=0x7102dfbe68 word=0xc01a309a op=0x1a BR_COND         fetch=0x4e194 line=58311  branch_cond? target=pc+4+0xf008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0341 vm+0x060c pc=0x7102dfbe6c word=0x80502e98 op=0x18 OP18            fetch=0x56264 line=58368  op18/version-specific? dst=v16 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0342 vm+0x0610 pc=0x7102dfbe70 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=58424  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0343 vm+0x0614 pc=0x7102dfbe74 word=0xe01a089a op=0x1a BR_COND         fetch=0x4e194 line=58506  branch_cond? target=pc+4+0x3888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0344 vm+0x0618 pc=0x7102dfbe78 word=0x80582e98 op=0x18 OP18            fetch=0x56264 line=58563  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0345 vm+0x061c pc=0x7102dfbe7c word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=58619  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0346 vm+0x0620 pc=0x7102dfbe80 word=0xe01a109a op=0x1a BR_COND         fetch=0x4e194 line=58701  branch_cond? target=pc+4+0x7808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0347 vm+0x0624 pc=0x7102dfbe84 word=0x80483698 op=0x18 OP18            fetch=0x56264 line=58758  op18/version-specific? dst=v8 src=v2 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0348 vm+0x0628 pc=0x7102dfbe88 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=58814  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0349 vm+0x062c pc=0x7102dfbe8c word=0x801a289a op=0x1a BR_COND         fetch=0x4e194 line=58896  branch_cond? target=pc+4+0xa088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0350 vm+0x0630 pc=0x7102dfbe90 word=0x80505698 op=0x18 OP18            fetch=0x56264 line=58953  op18/version-specific? dst=v16 src=v2 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0351 vm+0x0634 pc=0x7102dfbe94 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=59009  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0352 vm+0x0638 pc=0x7102dfbe98 word=0xc01a509a op=0x1a BR_COND         fetch=0x4e194 line=59091  branch_cond? target=pc+4+0x17008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0353 vm+0x063c pc=0x7102dfbe9c word=0x80403e98 op=0x18 OP18            fetch=0x56264 line=59148  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0354 vm+0x0640 pc=0x7102dfbea0 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=59204  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0355 vm+0x0644 pc=0x7102dfbea4 word=0xe01a209a op=0x1a BR_COND         fetch=0x4e194 line=59286  branch_cond? target=pc+4+0xb808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0356 vm+0x0648 pc=0x7102dfbea8 word=0x80480218 op=0x18 OP18            fetch=0x56264 line=59343  op18/version-specific? dst=v8 src=v2 lo12=0x218 imm16=0x0808 ; 350 trace hits this handler; exact semantics still version-verify
0357 vm+0x064c pc=0x7102dfbeac word=0x80807698 op=0x18 OP18            fetch=0x54acc line=59399  op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x781a ; 350 trace hits this handler; exact semantics still version-verify
0358 vm+0x0650 pc=0x7102dfbeb0 word=0x801ad11a op=0x1a BR_COND         fetch=0x54acc line=59454  branch_cond? target=pc+4-0x9ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0359 vm+0x0654 pc=0x7102dfbeb4 word=0x91ba400f op=0x0f BR_COND         fetch=0x56264 line=59509  branch_cond? target=pc+4+0x12400 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0360 vm+0x0658 pc=0x7102dfbeb8 word=0xa01a311a op=0x1a BR_COND         fetch=0x52ab8 line=59598  branch_cond? target=pc+4+0xe810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0361 vm+0x065c pc=0x7102dfbebc word=0xe01ac91a op=0x1a BR_COND         fetch=0x56264 line=59658  branch_cond? target=pc+4-0xc770 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0362 vm+0x0660 pc=0x7102dfbec0 word=0xc01ac89a op=0x1a BR_COND         fetch=0x56264 line=59714  branch_cond? target=pc+4-0xcf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0363 vm+0x0664 pc=0x7102dfbec4 word=0xab3a800f op=0x0f BR_COND         fetch=0x56264 line=59770  branch_cond? target=pc+4-0x1d600 src=v25 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0364 vm+0x0668 pc=0x7102dfbec8 word=0x81103e98 op=0x18 OP18            fetch=0x52ab8 line=59859  op18/version-specific? dst=v16 src=v8 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0365 vm+0x066c pc=0x7102dfbecc word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=59919  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0366 vm+0x0670 pc=0x7102dfbed0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=60001  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0367 vm+0x0674 pc=0x7102dfbed4 word=0x80586e98 op=0x18 OP18            fetch=0x4f8e0 line=60150  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x683a ; 350 trace hits this handler; exact semantics still version-verify
0368 vm+0x0678 pc=0x7102dfbed8 word=0x10001001 op=0x01 OP01            fetch=0x54acc line=60208  op01? dst=v0 src=v0 lo12=0x001 imm16=0x1100 ; unknown/no-op-ish in current reconstruction
0369 vm+0x067c pc=0x7102dfbedc word=0xab1a400f op=0x0f BR_COND         fetch=0x5581c line=60285  branch_cond? target=pc+4+0x12a00 src=v24 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0370 vm+0x0680 pc=0x7102dfbee0 word=0xa1ba000f op=0x0f BR_COND         fetch=0x52ab8 line=60378  branch_cond? target=pc+4+0x2800 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0371 vm+0x0684 pc=0x7102dfbee4 word=0xc01a2a1a op=0x1a BR_COND         fetch=0x52ab8 line=60471  branch_cond? target=pc+4+0xb0a0 src=v0 cmp=v26 lo12=0xa1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0372 vm+0x0688 pc=0x7102dfbee8 word=0x1800200f op=0x0f BR_COND         fetch=0x56264 line=60531  branch_cond? target=pc+4+0x8600 src=v0 cmp=v0 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0373 vm+0x068c pc=0x7102dfbeec word=0x83442356 op=0x16 ST32_UNALIGNED_R fetch=0x52ab8 line=60620  store_unaligned_u32(right/high-byte merge) [v26 + +0x280d], v4 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0374 vm+0x0690 pc=0x7102dfbef0 word=0x80882218 op=0x18 OP18            fetch=0x56f24 line=60681  op18/version-specific? dst=v8 src=v4 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0375 vm+0x0694 pc=0x7102dfbef4 word=0x801ac99a op=0x1a BR_COND         fetch=0x54acc line=60737  branch_cond? target=pc+4-0xdf68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0376 vm+0x0698 pc=0x7102dfbef8 word=0x99b4d001 op=0x01 OP01            fetch=0x56264 line=60792  op01? dst=v20 src=v13 lo12=0x001 imm16=0xd980 ; unknown/no-op-ish in current reconstruction
0377 vm+0x069c pc=0x7102dfbefc word=0x08c20391 op=0x11 CALL_IMM_LINK31 fetch=0x5581c line=60870  call_imm? target=vm_base+0x8c2038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0378 vm+0x06a0 pc=0x7102dfbf00 word=0x0fe2e7cf op=0x0f BR_COND         fetch=0x4e194 line=60957  branch_cond? target=pc+4-0x7c84 src=v31 cmp=v2 lo12=0x7cf ; conditional VM-PC control family, from z/ws/vm64.cpp
0379 vm+0x06a4 pc=0x7102dfbf04 word=0xe01ac09a op=0x1a BR_COND         fetch=0x52ab8 line=61047  branch_cond? target=pc+4-0xc7f8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0380 vm+0x06a8 pc=0x7102dfbf08 word=0xc01ac21a op=0x1a BR_COND         fetch=0x56264 line=61107  branch_cond? target=pc+4-0xcfe0 src=v0 cmp=v26 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0381 vm+0x06ac pc=0x7102dfbf0c word=0xa01ac11a op=0x1a BR_COND         fetch=0x56264 line=61163  branch_cond? target=pc+4-0xd7f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0382 vm+0x06b0 pc=0x7102dfbf10 word=0x81102698 op=0x18 OP18            fetch=0x56264 line=61219  op18/version-specific? dst=v16 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0383 vm+0x06b4 pc=0x7102dfbf14 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=61275  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0384 vm+0x06b8 pc=0x7102dfbf18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=61357  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0385 vm+0x06bc pc=0x7102dfbf1c word=0x93fb800f op=0x0f BR_COND         fetch=0x4f8e0 line=61632  branch_cond? target=pc+4-0x1dc00 src=v31 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0386 vm+0x06c0 pc=0x7102dfbf20 word=0x80582218 op=0x18 OP18            fetch=0x52ab8 line=61723  op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0387 vm+0x06c4 pc=0x7102dfbf24 word=0xe01bfb1a op=0x1a BR_COND         fetch=0x54acc line=61783  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0388 vm+0x06c8 pc=0x7102dfbf28 word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=61838  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0389 vm+0x06cc pc=0x7102dfbf2c word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=61894  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0390 vm+0x06d0 pc=0x7102dfbf30 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=61977  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0391 vm+0x06d4 pc=0x7102dfbf34 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=62061  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0392 vm+0x06d8 pc=0x7102dfbf38 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=62145  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0393 vm+0x06dc pc=0x7102dfbf3c word=0x8cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=62263  call_imm? target=vm_base+0x8cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0394 vm+0x06e0 pc=0x7102dfbf40 word=0x9bbb800f op=0x0f BR_COND         fetch=0x4f5d8 line=62348  branch_cond? target=pc+4-0x1da00 src=v29 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0395 vm+0x06e4 pc=0x7102dfbf44 word=0x91ba200f op=0x0f BR_COND         fetch=0x52ab8 line=62438  branch_cond? target=pc+4+0xa400 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0396 vm+0x06e8 pc=0x7102dfbf48 word=0x80402218 op=0x18 OP18            fetch=0x52ab8 line=62531  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0397 vm+0x06ec pc=0x7102dfbf4c word=0x1804003b op=0x3b ST64            fetch=0x54acc line=62591  store_u64 [v0 + +0x180], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0398 vm+0x06f0 pc=0x7102dfbf50 word=0x83483796 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=62636  store_unaligned_u32(right/high-byte merge) [v26 + +0x381e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0399 vm+0x06f4 pc=0x7102dfbf54 word=0xa01a291a op=0x1a BR_COND         fetch=0x56f24 line=62693  branch_cond? target=pc+4+0xa890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0400 vm+0x06f8 pc=0x7102dfbf58 word=0x801af11a op=0x1a BR_COND         fetch=0x56264 line=62749  branch_cond? target=pc+4-0x1ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0401 vm+0x06fc pc=0x7102dfbf5c word=0x83804ed8 op=0x18 OP18            fetch=0x56264 line=62805  op18/version-specific? dst=v0 src=v28 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0402 vm+0x0700 pc=0x7102dfbf60 word=0xe01bef1a op=0x1a BR_COND         fetch=0x54acc line=62861  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0403 vm+0x0704 pc=0x7102dfbf64 word=0xc01ae89a op=0x1a BR_COND         fetch=0x56264 line=62916  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0404 vm+0x0708 pc=0x7102dfbf68 word=0x81084e98 op=0x18 OP18            fetch=0x56264 line=62972  op18/version-specific? dst=v8 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0405 vm+0x070c pc=0x7102dfbf6c word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=63028  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0406 vm+0x0710 pc=0x7102dfbf70 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63110  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0407 vm+0x0714 pc=0x7102dfbf74 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63194  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0408 vm+0x0718 pc=0x7102dfbf78 word=0xbbdb800f op=0x0f BR_COND         fetch=0x4f8e0 line=63335  branch_cond? target=pc+4-0x1d200 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0409 vm+0x071c pc=0x7102dfbf7c word=0x80581a18 op=0x18 OP18            fetch=0x52ab8 line=63426  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0410 vm+0x0720 pc=0x7102dfbf80 word=0x801bff1a op=0x1a BR_COND         fetch=0x54acc line=63486  branch_cond? target=pc+4-0x1f10 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0411 vm+0x0724 pc=0x7102dfbf84 word=0xe01bf31a op=0x1a BR_COND         fetch=0x56264 line=63541  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0412 vm+0x0728 pc=0x7102dfbf88 word=0xc01af09a op=0x1a BR_COND         fetch=0x56264 line=63597  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0413 vm+0x072c pc=0x7102dfbf8c word=0x814036d8 op=0x18 OP18            fetch=0x56264 line=63653  op18/version-specific? dst=v0 src=v10 lo12=0x6d8 imm16=0x381b ; 350 trace hits this handler; exact semantics still version-verify
0414 vm+0x0730 pc=0x7102dfbf90 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x54acc line=63709  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0415 vm+0x0734 pc=0x7102dfbf94 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63791  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0416 vm+0x0738 pc=0x7102dfbf98 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63875  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0417 vm+0x073c pc=0x7102dfbf9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63959  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0418 vm+0x0740 pc=0x7102dfbfa0 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=64123  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0419 vm+0x0744 pc=0x7102dfbfa4 word=0xe01bff1a op=0x1a BR_COND         fetch=0x54acc line=64181  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0420 vm+0x0748 pc=0x7102dfbfa8 word=0xc01af89a op=0x1a BR_COND         fetch=0x56264 line=64236  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0421 vm+0x074c pc=0x7102dfbfac word=0x24400b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=64292  call_imm? target=vm_base+0x24400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0422 vm+0x0750 pc=0x7102dfbfb0 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64375  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0423 vm+0x0754 pc=0x7102dfbfb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64459  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0424 vm+0x0758 pc=0x7102dfbfb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64543  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0425 vm+0x075c pc=0x7102dfbfbc word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=64661  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0426 vm+0x0760 pc=0x7102dfbfc0 word=0x80804698 op=0x18 OP18            fetch=0x54acc line=64719  op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0427 vm+0x0764 pc=0x7102dfbfc4 word=0x801af91a op=0x1a BR_COND         fetch=0x54acc line=64774  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0428 vm+0x0768 pc=0x7102dfbfc8 word=0xe01bf31a op=0x1a BR_COND         fetch=0x56264 line=64829  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0429 vm+0x076c pc=0x7102dfbfcc word=0xc01af09a op=0x1a BR_COND         fetch=0x56264 line=64885  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0430 vm+0x0770 pc=0x7102dfbfd0 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x56264 line=64941  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0431 vm+0x0774 pc=0x7102dfbfd4 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65024  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0432 vm+0x0778 pc=0x7102dfbfd8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65108  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0433 vm+0x077c pc=0x7102dfbfdc word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65192  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0434 vm+0x0780 pc=0x7102dfbfe0 word=0x91fae00f op=0x0f BR_COND         fetch=0x4f8e0 line=65451  branch_cond? target=pc+4-0x5c00 src=v15 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0435 vm+0x0784 pc=0x7102dfbfe4 word=0x80402218 op=0x18 OP18            fetch=0x52ab8 line=65542  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0436 vm+0x0788 pc=0x7102dfbfe8 word=0x1804003b op=0x3b ST64            fetch=0x54acc line=65602  store_u64 [v0 + +0x180], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0437 vm+0x078c pc=0x7102dfbfec word=0x83483796 op=0x16 ST32_UNALIGNED_R fetch=0x52d8c line=65647  store_unaligned_u32(right/high-byte merge) [v26 + +0x381e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0438 vm+0x0790 pc=0x7102dfbff0 word=0xc01a111a op=0x1a BR_COND         fetch=0x56f24 line=65704  branch_cond? target=pc+4+0x7010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0439 vm+0x0794 pc=0x7102dfbff4 word=0x801af11a op=0x1a BR_COND         fetch=0x56264 line=65760  branch_cond? target=pc+4-0x1ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0440 vm+0x0798 pc=0x7102dfbff8 word=0xe01bef1a op=0x1a BR_COND         fetch=0x56264 line=65816  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0441 vm+0x079c pc=0x7102dfbffc word=0xc01ae89a op=0x1a BR_COND         fetch=0x56264 line=65872  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp

# exec view: every observed BR X8 and first VM word read before next BR
0000 br@0x4cdf4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb860 word=0xef5b878f op=0x0f BR_COND         fetch=0x529e4 line=199    branch_cond? target=pc+4-0x1c488 src=v26 cmp=v27 lo12=0x78f ; conditional VM-PC control family, from z/ws/vm64.cpp
0001 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb864 word=0xa03b2f9a op=0x1a BR_COND         fetch=0x561b8 line=269    branch_cond? target=pc+4+0xa8f8 src=v1 cmp=v27 lo12=0xf9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0002 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb868 word=0x803b2f1a op=0x1a BR_COND         fetch=0x561b8 line=325    branch_cond? target=pc+4+0xa0f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0003 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb86c word=0xe03b239a op=0x1a BR_COND         fetch=0x561b8 line=381    branch_cond? target=pc+4+0xb838 src=v1 cmp=v27 lo12=0x39a ; conditional VM-PC control family, from z/ws/vm64.cpp
0004 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb870 word=0xc03b231a op=0x1a BR_COND         fetch=0x561b8 line=437    branch_cond? target=pc+4+0xb030 src=v1 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0005 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb874 word=0xa03b229a op=0x1a BR_COND         fetch=0x561b8 line=493    branch_cond? target=pc+4+0xa828 src=v1 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0006 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb878 word=0x803b221a op=0x1a BR_COND         fetch=0x561b8 line=549    branch_cond? target=pc+4+0xa020 src=v1 cmp=v27 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0007 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb87c word=0xe03b199a op=0x1a BR_COND         fetch=0x561b8 line=605    branch_cond? target=pc+4+0x7898 src=v1 cmp=v27 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0008 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb880 word=0xc03b191a op=0x1a BR_COND         fetch=0x561b8 line=661    branch_cond? target=pc+4+0x7090 src=v1 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0009 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb884 word=0xa03b189a op=0x1a BR_COND         fetch=0x561b8 line=717    branch_cond? target=pc+4+0x6888 src=v1 cmp=v27 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0010 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb888 word=0x803b181a op=0x1a BR_COND         fetch=0x561b8 line=773    branch_cond? target=pc+4+0x6080 src=v1 cmp=v27 lo12=0x81a ; conditional VM-PC control family, from z/ws/vm64.cpp
0011 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb88c word=0x81c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=832    call_imm? target=vm_base+0x81c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0012 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfb890 word=0x3c19e7f4 op=0x34 OP34            fetch=0x4f5d8 line=899    op34? dst=v25 src=v0 lo12=0x7f4 imm16=0xe3df ; unknown/no-op-ish in current reconstruction
0013 br@0x4f608 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7102dfb890 word=0x3c19e7f4 op=0x34 OP34            fetch=0x53244 line=936    op34? dst=v25 src=v0 lo12=0x7f4 imm16=0xe3df ; unknown/no-op-ish in current reconstruction
0014 br@0x53328 -> 0x5332c LD16U/op30 (primary op30 handler)          vm_pc=0x7102dfb894 word=0x1a02dbb0 op=0x30 LD16U           fetch=0x53330 line=995    v2 = load_u16 [v16 + -0x2e52] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0015 br@0x53408 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb898 word=0x010002d8 op=0x18 OP18            fetch=0x54a20 line=1051   op18/version-specific? dst=v0 src=v8 lo12=0x2d8 imm16=0x000b ; 350 trace hits this handler; exact semantics still version-verify
0016 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb89c word=0x08680391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=1109   call_imm? target=vm_base+0x868038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0017 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb8a0 word=0x00980218 op=0x18 OP18            fetch=0x4e194 line=1176   op18/version-specific? dst=v24 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0018 br@0x4e1c4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8a0 word=0x00980218 op=0x18 OP18            fetch=0x54a20 line=1190   op18/version-specific? dst=v24 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0019 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8a4 word=0x801a411a op=0x1a BR_COND         fetch=0x561b8 line=1245   branch_cond? target=pc+4+0x12010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0020 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8a8 word=0x00900218 op=0x18 OP18            fetch=0x54a20 line=1301   op18/version-specific? dst=v16 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0021 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8ac word=0xa01a111a op=0x1a BR_COND         fetch=0x561b8 line=1356   branch_cond? target=pc+4+0x6810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0022 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8b0 word=0x00880258 op=0x18 OP18            fetch=0x54a20 line=1412   op18/version-specific? dst=v8 src=v4 lo12=0x258 imm16=0x0009 ; 350 trace hits this handler; exact semantics still version-verify
0023 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8b4 word=0x00800218 op=0x18 OP18            fetch=0x54a20 line=1467   op18/version-specific? dst=v0 src=v4 lo12=0x218 imm16=0x0008 ; 350 trace hits this handler; exact semantics still version-verify
0024 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8b8 word=0xa01a191a op=0x1a BR_COND         fetch=0x561b8 line=1522   branch_cond? target=pc+4+0x6890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0025 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8bc word=0x00880298 op=0x18 OP18            fetch=0x54a20 line=1578   op18/version-specific? dst=v8 src=v4 lo12=0x298 imm16=0x000a ; 350 trace hits this handler; exact semantics still version-verify
0026 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8c0 word=0xe01a411a op=0x1a BR_COND         fetch=0x561b8 line=1633   branch_cond? target=pc+4+0x13810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0027 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8c4 word=0x01500358 op=0x18 OP18            fetch=0x54a20 line=1689   op18/version-specific? dst=v16 src=v10 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0028 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8c8 word=0x00d80358 op=0x18 OP18            fetch=0x54a20 line=1744   op18/version-specific? dst=v24 src=v6 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0029 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8cc word=0x00800b18 op=0x18 OP18            fetch=0x54a20 line=1799   op18/version-specific? dst=v0 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0030 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8d0 word=0xe01a311a op=0x1a BR_COND         fetch=0x561b8 line=1854   branch_cond? target=pc+4+0xf810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0031 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8d4 word=0x00880b18 op=0x18 OP18            fetch=0x54a20 line=1910   op18/version-specific? dst=v8 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0032 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8d8 word=0xe01a491a op=0x1a BR_COND         fetch=0x561b8 line=1965   branch_cond? target=pc+4+0x13890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0033 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8dc word=0x00900b18 op=0x18 OP18            fetch=0x54a20 line=2021   op18/version-specific? dst=v16 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0034 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8e0 word=0xe01a391a op=0x1a BR_COND         fetch=0x561b8 line=2076   branch_cond? target=pc+4+0xf890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0035 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8e4 word=0x00980b18 op=0x18 OP18            fetch=0x54a20 line=2132   op18/version-specific? dst=v24 src=v4 lo12=0xb18 imm16=0x002c ; 350 trace hits this handler; exact semantics still version-verify
0036 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8e8 word=0xa01a491a op=0x1a BR_COND         fetch=0x561b8 line=2187   branch_cond? target=pc+4+0x12890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0037 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8ec word=0x00801318 op=0x18 OP18            fetch=0x54a20 line=2243   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0038 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8f0 word=0xc01a391a op=0x1a BR_COND         fetch=0x561b8 line=2298   branch_cond? target=pc+4+0xf090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0039 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8f4 word=0x00881318 op=0x18 OP18            fetch=0x54a20 line=2354   op18/version-specific? dst=v8 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0040 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb8f8 word=0xa01a391a op=0x1a BR_COND         fetch=0x561b8 line=2409   branch_cond? target=pc+4+0xe890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0041 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb8fc word=0x01d01358 op=0x18 OP18            fetch=0x54a20 line=2465   op18/version-specific? dst=v16 src=v14 lo12=0x358 imm16=0x100d ; 350 trace hits this handler; exact semantics still version-verify
0042 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb900 word=0x00981318 op=0x18 OP18            fetch=0x54a20 line=2520   op18/version-specific? dst=v24 src=v4 lo12=0x318 imm16=0x100c ; 350 trace hits this handler; exact semantics still version-verify
0043 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb904 word=0x801a491a op=0x1a BR_COND         fetch=0x561b8 line=2575   branch_cond? target=pc+4+0x12090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0044 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb908 word=0x00801b18 op=0x18 OP18            fetch=0x54a20 line=2631   op18/version-specific? dst=v0 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0045 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb90c word=0xa01a411a op=0x1a BR_COND         fetch=0x561b8 line=2686   branch_cond? target=pc+4+0x12810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0046 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb910 word=0x00881b18 op=0x18 OP18            fetch=0x54a20 line=2742   op18/version-specific? dst=v8 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0047 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb914 word=0x801a391a op=0x1a BR_COND         fetch=0x561b8 line=2797   branch_cond? target=pc+4+0xe090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0048 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb918 word=0x00901b18 op=0x18 OP18            fetch=0x54a20 line=2853   op18/version-specific? dst=v16 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0049 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb91c word=0xc01a511a op=0x1a BR_COND         fetch=0x561b8 line=2908   branch_cond? target=pc+4+0x17010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0050 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb920 word=0x00981b18 op=0x18 OP18            fetch=0x54a20 line=2964   op18/version-specific? dst=v24 src=v4 lo12=0xb18 imm16=0x102c ; 350 trace hits this handler; exact semantics still version-verify
0051 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb924 word=0xa01a311a op=0x1a BR_COND         fetch=0x561b8 line=3019   branch_cond? target=pc+4+0xe810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0052 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb928 word=0x00802318 op=0x18 OP18            fetch=0x54a20 line=3075   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0053 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb92c word=0xe01a291a op=0x1a BR_COND         fetch=0x561b8 line=3130   branch_cond? target=pc+4+0xb890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0054 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb930 word=0x00882318 op=0x18 OP18            fetch=0x54a20 line=3186   op18/version-specific? dst=v8 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0055 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb934 word=0xc01a291a op=0x1a BR_COND         fetch=0x561b8 line=3241   branch_cond? target=pc+4+0xb090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0056 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb938 word=0x00902318 op=0x18 OP18            fetch=0x54a20 line=3297   op18/version-specific? dst=v16 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0057 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb93c word=0xc01a311a op=0x1a BR_COND         fetch=0x561b8 line=3352   branch_cond? target=pc+4+0xf010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0058 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb940 word=0x00900298 op=0x18 OP18            fetch=0x54a20 line=3408   op18/version-specific? dst=v16 src=v4 lo12=0x298 imm16=0x000a ; 350 trace hits this handler; exact semantics still version-verify
0059 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb944 word=0xa01a291a op=0x1a BR_COND         fetch=0x561b8 line=3463   branch_cond? target=pc+4+0xa890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0060 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb948 word=0x00982318 op=0x18 OP18            fetch=0x54a20 line=3519   op18/version-specific? dst=v24 src=v4 lo12=0x318 imm16=0x200c ; 350 trace hits this handler; exact semantics still version-verify
0061 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb94c word=0x801a291a op=0x1a BR_COND         fetch=0x561b8 line=3574   branch_cond? target=pc+4+0xa090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0062 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb950 word=0x01880358 op=0x18 OP18            fetch=0x54a20 line=3630   op18/version-specific? dst=v8 src=v12 lo12=0x358 imm16=0x000d ; 350 trace hits this handler; exact semantics still version-verify
0063 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb954 word=0x00800318 op=0x18 OP18            fetch=0x54a20 line=3685   op18/version-specific? dst=v0 src=v4 lo12=0x318 imm16=0x000c ; 350 trace hits this handler; exact semantics still version-verify
0064 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb958 word=0x00400098 op=0x18 OP18            fetch=0x54a20 line=3740   op18/version-specific? dst=v0 src=v2 lo12=0x098 imm16=0x0002 ; 350 trace hits this handler; exact semantics still version-verify
0065 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb95c word=0xe03a101a op=0x1a BR_COND         fetch=0x561b8 line=3795   branch_cond? target=pc+4+0x7800 src=v1 cmp=v26 lo12=0x01a ; conditional VM-PC control family, from z/ws/vm64.cpp
0066 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb960 word=0x9a1ac00f op=0x0f BR_COND         fetch=0x529e4 line=3874   branch_cond? target=pc+4-0xda00 src=v16 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0067 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb964 word=0xa01a519a op=0x1a BR_COND         fetch=0x561b8 line=3944   branch_cond? target=pc+4+0x16818 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0068 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb968 word=0xc03a119a op=0x1a BR_COND         fetch=0x561b8 line=4000   branch_cond? target=pc+4+0x7018 src=v1 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0069 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb96c word=0xa03a109a op=0x1a BR_COND         fetch=0x561b8 line=4056   branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0070 br@0x56290 -> 0x5332c LD16U/op30 (primary op30 handler)          vm_pc=0x7102dfb970 word=0x1902c3f0 op=0x30 LD16U           fetch=0x53330 line=4112   v2 = load_u16 [v8 + -0x3e71] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0071 br@0x53408 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb974 word=0x24440391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=4171   call_imm? target=vm_base+0x2444038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0072 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb978 word=0xa85a404f op=0x0f BR_COND         fetch=0x4e194 line=4238   branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0073 br@0x4e1c4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb978 word=0xa85a404f op=0x0f BR_COND         fetch=0x529e4 line=4275   branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0074 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb97c word=0xc01a4a1a op=0x1a BR_COND         fetch=0x561b8 line=4345   branch_cond? target=pc+4+0x130a0 src=v0 cmp=v26 lo12=0xa1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0075 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb980 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=4404   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0076 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfb984 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=4471   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0077 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb984 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=4488   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0078 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfb988 word=0xa4680391 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=4616   call_imm? target=vm_base+0xa468038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0079 br@0x4f914 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb988 word=0xa4680391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=4634   call_imm? target=vm_base+0xa468038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0080 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb98c word=0x0800200f op=0x0f BR_COND         fetch=0x4e194 line=4701   branch_cond? target=pc+4+0x8200 src=v0 cmp=v0 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0081 br@0x4e1c4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb98c word=0x0800200f op=0x0f BR_COND         fetch=0x529e4 line=4738   branch_cond? target=pc+4+0x8200 src=v0 cmp=v0 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0082 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb990 word=0x80800218 op=0x18 OP18            fetch=0x54a20 line=4808   op18/version-specific? dst=v0 src=v4 lo12=0x218 imm16=0x0808 ; 350 trace hits this handler; exact semantics still version-verify
0083 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb994 word=0xe03a089a op=0x1a BR_COND         fetch=0x561b8 line=4863   branch_cond? target=pc+4+0x3888 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0084 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb998 word=0xc03a091a op=0x1a BR_COND         fetch=0x561b8 line=4919   branch_cond? target=pc+4+0x3090 src=v1 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0085 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb99c word=0x246c0391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=4978   call_imm? target=vm_base+0x246c038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0086 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb9a0 word=0xa83a804f op=0x0f BR_COND         fetch=0x4e194 line=5045   branch_cond? target=pc+4-0x1d5fc src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0087 br@0x4e1c4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb9a0 word=0xa83a804f op=0x0f BR_COND         fetch=0x529e4 line=5082   branch_cond? target=pc+4-0x1d5fc src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0088 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb9a4 word=0xc01a421a op=0x1a BR_COND         fetch=0x561b8 line=5152   branch_cond? target=pc+4+0x13020 src=v0 cmp=v26 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0089 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9a8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=5211   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0090 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfb9ac word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=5278   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0091 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9ac word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=5295   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0092 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfb9b0 word=0x0c6a0391 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=5393   call_imm? target=vm_base+0xc6a038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0093 br@0x4f914 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9b0 word=0x0c6a0391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=5411   call_imm? target=vm_base+0xc6a038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0094 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb9b4 word=0x801a509a op=0x1a BR_COND         fetch=0x4e194 line=5478   branch_cond? target=pc+4+0x16008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0095 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb9b4 word=0x801a509a op=0x1a BR_COND         fetch=0x561b8 line=5492   branch_cond? target=pc+4+0x16008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0096 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9b8 word=0x84801698 op=0x18 OP18            fetch=0x54a20 line=5548   op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x185a ; 350 trace hits this handler; exact semantics still version-verify
0097 br@0x54af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfb9bc word=0x00800016 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=5603   store_unaligned_u32(right/high-byte merge) [v4 + +0x0], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0098 br@0x56f50 -> 0x53db0 BR_COND/op2d (primary op2d handler)        vm_pc=0x7102dfb9c0 word=0x000400ad op=0x2d BR_COND         fetch=0x53db8 line=5661   branch_cond? target=pc+4+0x8 src=v0 cmp=v4 lo12=0x0ad ; conditional VM-PC control family, from z/ws/vm64.cpp
0099 br@0x53f7c -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfb9c4 word=0x0801003b op=0x3b ST64            fetch=0x52d08 line=5755   store_u64 [v0 + +0x80], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0100 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfb9c8 word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=5801   store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0101 br@0x56f50 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb9cc word=0xc01a191a op=0x1a BR_COND         fetch=0x561b8 line=5858   branch_cond? target=pc+4+0x7090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0102 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9d0 word=0x80501a18 op=0x18 OP18            fetch=0x54a20 line=5914   op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0103 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9d4 word=0x838856d8 op=0x18 OP18            fetch=0x54a20 line=5969   op18/version-specific? dst=v8 src=v28 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0104 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb9d8 word=0xa03b0f1a op=0x1a BR_COND         fetch=0x561b8 line=6024   branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0105 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfb9dc word=0x803a089a op=0x1a BR_COND         fetch=0x561b8 line=6080   branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0106 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfb9e0 word=0xa83a004f op=0x0f BR_COND         fetch=0x529e4 line=6159   branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0107 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9e4 word=0x81005698 op=0x18 OP18            fetch=0x54a20 line=6229   op18/version-specific? dst=v0 src=v8 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0108 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9e8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=6287   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0109 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfb9ec word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=6354   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0110 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9ec word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=6371   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0111 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfb9f0 word=0x80800118 op=0x18 OP18            fetch=0x4f8e0 line=6466   op18/version-specific? dst=v0 src=v4 lo12=0x118 imm16=0x0804 ; 350 trace hits this handler; exact semantics still version-verify
0112 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9f0 word=0x80800118 op=0x18 OP18            fetch=0x54a20 line=6481   op18/version-specific? dst=v0 src=v4 lo12=0x118 imm16=0x0804 ; 350 trace hits this handler; exact semantics still version-verify
0113 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler)        vm_pc=0x7102dfb9f4 word=0x0004036d op=0x2d BR_COND         fetch=0x53db8 line=6537   branch_cond? target=pc+4+0x34 src=v0 cmp=v4 lo12=0x36d ; conditional VM-PC control family, from z/ws/vm64.cpp
0114 br@0x53f7c -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfb9f8 word=0x24660391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=6634   call_imm? target=vm_base+0x2466038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0115 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfb9fc word=0x80581218 op=0x18 OP18            fetch=0x4e194 line=6701   op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x1808 ; 350 trace hits this handler; exact semantics still version-verify
0116 br@0x4e1c4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfb9fc word=0x80581218 op=0x18 OP18            fetch=0x54a20 line=6715   op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x1808 ; 350 trace hits this handler; exact semantics still version-verify
0117 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfba00 word=0xe03a011a op=0x1a BR_COND         fetch=0x561b8 line=6770   branch_cond? target=pc+4+0x3810 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0118 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfba04 word=0x915ac00f op=0x0f BR_COND         fetch=0x529e4 line=6849   branch_cond? target=pc+4-0xdc00 src=v10 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0119 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfba08 word=0xc03a011a op=0x1a BR_COND         fetch=0x561b8 line=6919   branch_cond? target=pc+4+0x3010 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0120 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfba0c word=0xa03a009a op=0x1a BR_COND         fetch=0x561b8 line=6975   branch_cond? target=pc+4+0x2808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0121 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfba10 word=0xa81a404f op=0x0f BR_COND         fetch=0x529e4 line=7054   branch_cond? target=pc+4+0x12a04 src=v0 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0122 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfba14 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=7127   call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0123 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfba18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=7194   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0124 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfba18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=7211   call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0125 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfba1c word=0x3439e7f4 op=0x34 OP34            fetch=0x4f8e0 line=25223  op34? dst=v25 src=v1 lo12=0x7f4 imm16=0xe35f ; unknown/no-op-ish in current reconstruction
0126 br@0x4f914 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7102dfba1c word=0x3439e7f4 op=0x34 OP34            fetch=0x53244 line=25261  op34? dst=v25 src=v1 lo12=0x7f4 imm16=0xe35f ; unknown/no-op-ish in current reconstruction
0127 br@0x53328 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfba20 word=0x95c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=25323  call_imm? target=vm_base+0x95c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0128 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfba24 word=0x80983698 op=0x18 OP18            fetch=0x4f5d8 line=25390  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0129 br@0x4f608 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfba24 word=0x80983698 op=0x18 OP18            fetch=0x54a20 line=25404  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0130 br@0x54af4 -> 0x53540 ADD64_IMM/op0d (primary op0d handler)      vm_pc=0x7102dfba28 word=0x0017200d op=0x0d ADD64_IMM       fetch=0x535a0 line=25482  v23 = (u64)v0 + +0x2000 ; dst = src + simm16, from z/ws/vm64.cpp
0131 br@0x536e0 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbabc word=0x9c440391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=25567  call_imm? target=vm_base+0x9c44038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0132 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbac0 word=0x80985698 op=0x18 OP18            fetch=0x4e194 line=25634  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0133 br@0x4e1c4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbac0 word=0x80985698 op=0x18 OP18            fetch=0x54a20 line=25648  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0134 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler)        vm_pc=0x7102dfbac4 word=0x000400ad op=0x2d BR_COND         fetch=0x53db8 line=25704  branch_cond? target=pc+4+0x8 src=v0 cmp=v4 lo12=0x0ad ; conditional VM-PC control family, from z/ws/vm64.cpp
0135 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbac8 word=0x080c2001 op=0x01 OP01            fetch=0x55770 line=25820  op01? dst=v12 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0136 br@0x55858 -> 0x53b68 secondary/unknown target                   vm_pc=0x7102dfbacc word=0x0806002b op=0x2b LD32S           fetch=0x53b70 line=25881  v6 = load_i32 [v0 + +0x80] ; dst = *(int32_t *)(src + simm16), from z/ws/vm64.cpp
0137 br@0x53d38 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbae8 word=0xe01b319a op=0x1a BR_COND         fetch=0x561b8 line=25974  branch_cond? target=pc+4+0xf818 src=v0 cmp=v27 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0138 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbaec word=0x80481a18 op=0x18 OP18            fetch=0x54a20 line=26030  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0139 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbaf0 word=0x80985698 op=0x18 OP18            fetch=0x54a20 line=26085  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0140 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbaf4 word=0xe03a111a op=0x1a BR_COND         fetch=0x561b8 line=26140  branch_cond? target=pc+4+0x7810 src=v1 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0141 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbaf8 word=0xc03b171a op=0x1a BR_COND         fetch=0x561b8 line=26196  branch_cond? target=pc+4+0x7070 src=v1 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0142 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbafc word=0xa03a109a op=0x1a BR_COND         fetch=0x561b8 line=26252  branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0143 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbb00 word=0xa85a404f op=0x0f BR_COND         fetch=0x529e4 line=26331  branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0144 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb04 word=0x80d04ed8 op=0x18 OP18            fetch=0x54a20 line=26401  op18/version-specific? dst=v16 src=v6 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0145 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb08 word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=26459  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0146 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbb0c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=26526  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0147 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb0c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=26543  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0148 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbb10 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=26610  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0149 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb10 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=26627  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0150 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbb14 word=0x80805e98 op=0x18 OP18            fetch=0x4f8e0 line=26755  op18/version-specific? dst=v0 src=v4 lo12=0xe98 imm16=0x583a ; 350 trace hits this handler; exact semantics still version-verify
0151 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb14 word=0x80805e98 op=0x18 OP18            fetch=0x54a20 line=26770  op18/version-specific? dst=v0 src=v4 lo12=0xe98 imm16=0x583a ; 350 trace hits this handler; exact semantics still version-verify
0152 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb18 word=0x81d856d8 op=0x18 OP18            fetch=0x54a20 line=26825  op18/version-specific? dst=v24 src=v14 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0153 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler)        vm_pc=0x7102dfbb1c word=0x000400ed op=0x2d BR_COND         fetch=0x53db8 line=26881  branch_cond? target=pc+4+0xc src=v0 cmp=v4 lo12=0x0ed ; conditional VM-PC control family, from z/ws/vm64.cpp
0154 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbb20 word=0x08002001 op=0x01 OP01            fetch=0x55770 line=26997  op01? dst=v0 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0155 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbb24 word=0x0801103b op=0x3b ST64            fetch=0x52d08 line=27057  store_u64 [v0 + +0x1080], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0156 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbb28 word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=27103  store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0157 br@0x56f50 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb2c word=0x0c640391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=27163  call_imm? target=vm_base+0xc64038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0158 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb30 word=0xa01a209a op=0x1a BR_COND         fetch=0x4e194 line=27230  branch_cond? target=pc+4+0xa808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0159 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb30 word=0xa01a209a op=0x1a BR_COND         fetch=0x561b8 line=27244  branch_cond? target=pc+4+0xa808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0160 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb34 word=0x80483e98 op=0x18 OP18            fetch=0x54a20 line=27300  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0161 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb38 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=27358  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0162 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb3c word=0x801a209a op=0x1a BR_COND         fetch=0x4e194 line=27425  branch_cond? target=pc+4+0xa008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0163 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb3c word=0x801a209a op=0x1a BR_COND         fetch=0x561b8 line=27439  branch_cond? target=pc+4+0xa008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0164 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb40 word=0x80503e98 op=0x18 OP18            fetch=0x54a20 line=27495  op18/version-specific? dst=v16 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0165 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb44 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=27553  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0166 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb48 word=0xa01a389a op=0x1a BR_COND         fetch=0x4e194 line=27620  branch_cond? target=pc+4+0xe888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0167 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb48 word=0xa01a389a op=0x1a BR_COND         fetch=0x561b8 line=27634  branch_cond? target=pc+4+0xe888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0168 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb4c word=0x80484e98 op=0x18 OP18            fetch=0x54a20 line=27690  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0169 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb50 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=27748  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0170 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb54 word=0xa01a489a op=0x1a BR_COND         fetch=0x4e194 line=27815  branch_cond? target=pc+4+0x12888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0171 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb54 word=0xa01a489a op=0x1a BR_COND         fetch=0x561b8 line=27829  branch_cond? target=pc+4+0x12888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0172 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb58 word=0x80583e98 op=0x18 OP18            fetch=0x54a20 line=27885  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0173 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb5c word=0xac420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=27943  call_imm? target=vm_base+0xac42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0174 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb60 word=0x80584e98 op=0x18 OP18            fetch=0x4e194 line=28010  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0175 br@0x4e1c4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb60 word=0x80584e98 op=0x18 OP18            fetch=0x54a20 line=28024  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0176 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb64 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=28082  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0177 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb68 word=0xe01a489a op=0x1a BR_COND         fetch=0x4e194 line=28149  branch_cond? target=pc+4+0x13888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0178 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb68 word=0xe01a489a op=0x1a BR_COND         fetch=0x561b8 line=28163  branch_cond? target=pc+4+0x13888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0179 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb6c word=0x80584698 op=0x18 OP18            fetch=0x54a20 line=28219  op18/version-specific? dst=v24 src=v2 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0180 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb70 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=28277  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0181 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbb74 word=0xe01a189a op=0x1a BR_COND         fetch=0x4e194 line=28344  branch_cond? target=pc+4+0x7888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0182 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb74 word=0xe01a189a op=0x1a BR_COND         fetch=0x561b8 line=28358  branch_cond? target=pc+4+0x7888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0183 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb78 word=0x80501a18 op=0x18 OP18            fetch=0x54a20 line=28414  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0184 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb7c word=0xa03b0f1a op=0x1a BR_COND         fetch=0x561b8 line=28469  branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0185 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb80 word=0x803a089a op=0x1a BR_COND         fetch=0x561b8 line=28525  branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0186 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbb84 word=0xa83a004f op=0x0f BR_COND         fetch=0x529e4 line=28604  branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0187 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbb88 word=0x808056d8 op=0x18 OP18            fetch=0x54a20 line=28674  op18/version-specific? dst=v0 src=v4 lo12=0x6d8 imm16=0x581b ; 350 trace hits this handler; exact semantics still version-verify
0188 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb8c word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=28732  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0189 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbb90 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=28799  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0190 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb90 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=28816  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0191 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbb94 word=0xe01a411a op=0x1a BR_COND         fetch=0x4f5d8 line=28883  branch_cond? target=pc+4+0x13810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0192 br@0x4f608 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbb94 word=0xe01a411a op=0x1a BR_COND         fetch=0x561b8 line=28897  branch_cond? target=pc+4+0x13810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0193 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbb98 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=28956  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0194 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbb9c word=0xa85a404f op=0x0f BR_COND         fetch=0x4f8e0 line=29051  branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0195 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbb9c word=0xa85a404f op=0x0f BR_COND         fetch=0x529e4 line=29089  branch_cond? target=pc+4+0x12a04 src=v2 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0196 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbba0 word=0x80481a18 op=0x18 OP18            fetch=0x54a20 line=29159  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0197 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbba4 word=0xe03b139a op=0x1a BR_COND         fetch=0x561b8 line=29214  branch_cond? target=pc+4+0x7838 src=v1 cmp=v27 lo12=0x39a ; conditional VM-PC control family, from z/ws/vm64.cpp
0198 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbba8 word=0xc03b171a op=0x1a BR_COND         fetch=0x561b8 line=29270  branch_cond? target=pc+4+0x7070 src=v1 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0199 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbac word=0xa03a109a op=0x1a BR_COND         fetch=0x561b8 line=29326  branch_cond? target=pc+4+0x6808 src=v1 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0200 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbbb0 word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=29385  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0201 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbbb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=29452  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0202 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbbb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=29469  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0203 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbbb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=29536  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0204 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbbb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=29553  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0205 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbbbc word=0x80984698 op=0x18 OP18            fetch=0x4f8e0 line=29681  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0206 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbbbc word=0x80984698 op=0x18 OP18            fetch=0x54a20 line=29696  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0207 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler)        vm_pc=0x7102dfbbc0 word=0x000400ed op=0x2d BR_COND         fetch=0x53db8 line=29752  branch_cond? target=pc+4+0xc src=v0 cmp=v4 lo12=0x0ed ; conditional VM-PC control family, from z/ws/vm64.cpp
0208 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbbc4 word=0x08002001 op=0x01 OP01            fetch=0x55770 line=29868  op01? dst=v0 src=v0 lo12=0x001 imm16=0x2080 ; unknown/no-op-ish in current reconstruction
0209 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbbc8 word=0x0801103b op=0x3b ST64            fetch=0x52d08 line=29928  store_u64 [v0 + +0x1080], v1 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0210 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbbcc word=0x00801016 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=29974  store_unaligned_u32(right/high-byte merge) [v4 + +0x1000], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0211 br@0x56f50 -> 0x5332c LD16U/op30 (primary op30 handler)          vm_pc=0x7102dfbbd0 word=0x9b02c330 op=0x30 LD16U           fetch=0x53330 line=30031  v2 = load_u16 [v24 + -0x3674] ; dst = *(uint16_t *)(src + simm16), from z/ws/vm64.cpp
0212 br@0x53408 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbd4 word=0xe01a209a op=0x1a BR_COND         fetch=0x561b8 line=30087  branch_cond? target=pc+4+0xb808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0213 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbbd8 word=0x80484698 op=0x18 OP18            fetch=0x54a20 line=30143  op18/version-specific? dst=v8 src=v2 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0214 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbbdc word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=30201  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0215 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbbe0 word=0xc01a209a op=0x1a BR_COND         fetch=0x4e194 line=30268  branch_cond? target=pc+4+0xb008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0216 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbe0 word=0xc01a209a op=0x1a BR_COND         fetch=0x561b8 line=30282  branch_cond? target=pc+4+0xb008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0217 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbbe4 word=0x80404e98 op=0x18 OP18            fetch=0x54a20 line=30338  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0218 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbbe8 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=30396  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0219 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbbec word=0xc01a389a op=0x1a BR_COND         fetch=0x4e194 line=30463  branch_cond? target=pc+4+0xf088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0220 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbec word=0xc01a389a op=0x1a BR_COND         fetch=0x561b8 line=30477  branch_cond? target=pc+4+0xf088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0221 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbbf0 word=0x80501a18 op=0x18 OP18            fetch=0x54a20 line=30533  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0222 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbf4 word=0xa03b0f1a op=0x1a BR_COND         fetch=0x561b8 line=30588  branch_cond? target=pc+4+0x28f0 src=v1 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0223 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbbf8 word=0x803a089a op=0x1a BR_COND         fetch=0x561b8 line=30644  branch_cond? target=pc+4+0x2088 src=v1 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0224 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbbfc word=0xa83a004f op=0x0f BR_COND         fetch=0x529e4 line=30723  branch_cond? target=pc+4+0x2a04 src=v1 cmp=v26 lo12=0x04f ; conditional VM-PC control family, from z/ws/vm64.cpp
0225 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc00 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=30796  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0226 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc04 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=30863  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0227 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc04 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=30880  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0228 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc08 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=30947  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0229 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc08 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=30964  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0230 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbc0c word=0xabfa800f op=0x0f BR_COND         fetch=0x4f8e0 line=31059  branch_cond? target=pc+4-0x1d600 src=v31 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0231 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbc0c word=0xabfa800f op=0x0f BR_COND         fetch=0x529e4 line=31097  branch_cond? target=pc+4-0x1d600 src=v31 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0232 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc10 word=0xe01a129a op=0x1a BR_COND         fetch=0x561b8 line=31167  branch_cond? target=pc+4+0x7828 src=v0 cmp=v26 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0233 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc14 word=0x80500398 op=0x18 OP18            fetch=0x54a20 line=31223  op18/version-specific? dst=v16 src=v2 lo12=0x398 imm16=0x080e ; 350 trace hits this handler; exact semantics still version-verify
0234 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbc18 word=0x08001001 op=0x01 OP01            fetch=0x55770 line=31300  op01? dst=v0 src=v0 lo12=0x001 imm16=0x1080 ; unknown/no-op-ish in current reconstruction
0235 br@0x55858 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbc1c word=0x835c13d6 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=31360  store_unaligned_u32(right/high-byte merge) [v26 + +0x180f], v28 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0236 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc20 word=0x80582218 op=0x18 OP18            fetch=0x54a20 line=31417  op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0237 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc24 word=0xe01bff1a op=0x1a BR_COND         fetch=0x561b8 line=31472  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0238 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc28 word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=31528  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0239 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc2c word=0x81184e98 op=0x18 OP18            fetch=0x54a20 line=31584  op18/version-specific? dst=v24 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0240 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc30 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=31642  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0241 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc34 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=31709  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0242 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc34 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=31726  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0243 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbc38 word=0x9bdb800f op=0x0f BR_COND         fetch=0x4f8e0 line=31827  branch_cond? target=pc+4-0x1da00 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0244 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbc38 word=0x9bdb800f op=0x0f BR_COND         fetch=0x529e4 line=31865  branch_cond? target=pc+4-0x1da00 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0245 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc3c word=0x80581a18 op=0x18 OP18            fetch=0x54a20 line=31935  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0246 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc40 word=0x808046d8 op=0x18 OP18            fetch=0x54a20 line=31990  op18/version-specific? dst=v0 src=v4 lo12=0x6d8 imm16=0x481b ; 350 trace hits this handler; exact semantics still version-verify
0247 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc44 word=0x801bf91a op=0x1a BR_COND         fetch=0x561b8 line=32045  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0248 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc48 word=0xe01bf71a op=0x1a BR_COND         fetch=0x561b8 line=32101  branch_cond? target=pc+4-0x790 src=v0 cmp=v27 lo12=0x71a ; conditional VM-PC control family, from z/ws/vm64.cpp
0249 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc4c word=0xc01af09a op=0x1a BR_COND         fetch=0x561b8 line=32157  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0250 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc50 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=32216  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0251 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc54 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=32283  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0252 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc54 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=32300  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0253 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc58 word=0xc01b119a op=0x1a BR_COND         fetch=0x4f5d8 line=32367  branch_cond? target=pc+4+0x7018 src=v0 cmp=v27 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0254 br@0x4f608 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc58 word=0xc01b119a op=0x1a BR_COND         fetch=0x561b8 line=32381  branch_cond? target=pc+4+0x7018 src=v0 cmp=v27 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0255 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc5c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=32440  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0256 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=32507  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0257 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=32524  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0258 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbc64 word=0xb7800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=32671  call_imm? target=vm_base+0xb7800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0259 br@0x4f914 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbc64 word=0xb7800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=32689  call_imm? target=vm_base+0xb7800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0260 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbc68 word=0xabba800f op=0x0f BR_COND         fetch=0x4f5d8 line=32756  branch_cond? target=pc+4-0x1d600 src=v29 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0261 br@0x4f608 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbc68 word=0xabba800f op=0x0f BR_COND         fetch=0x529e4 line=32793  branch_cond? target=pc+4-0x1d600 src=v29 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0262 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc6c word=0x801a1a9a op=0x1a BR_COND         fetch=0x561b8 line=32863  branch_cond? target=pc+4+0x60a8 src=v0 cmp=v26 lo12=0xa9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0263 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbc70 word=0xf21b000f op=0x0f BR_COND         fetch=0x529e4 line=32942  branch_cond? target=pc+4+0x3c00 src=v16 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0264 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc74 word=0x801b4f1a op=0x1a BR_COND         fetch=0x561b8 line=33012  branch_cond? target=pc+4+0x120f0 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0265 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc78 word=0xe01b3b9a op=0x1a BR_COND         fetch=0x561b8 line=33068  branch_cond? target=pc+4+0xf8b8 src=v0 cmp=v27 lo12=0xb9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0266 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbc7c word=0x99da800f op=0x0f BR_COND         fetch=0x529e4 line=33147  branch_cond? target=pc+4-0x1da00 src=v14 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0267 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc80 word=0xa01a419a op=0x1a BR_COND         fetch=0x561b8 line=33217  branch_cond? target=pc+4+0x12818 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0268 br@0x56290 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbc84 word=0x1004003b op=0x3b ST64            fetch=0x52d08 line=33273  store_u64 [v0 + +0x100], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0269 br@0x52db8 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbc88 word=0x89fcd001 op=0x01 OP01            fetch=0x55770 line=33341  op01? dst=v28 src=v15 lo12=0x001 imm16=0xd880 ; unknown/no-op-ish in current reconstruction
0270 br@0x55858 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbc8c word=0x83501396 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=33401  store_unaligned_u32(right/high-byte merge) [v26 + +0x180e], v16 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0271 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbc90 word=0x80402218 op=0x18 OP18            fetch=0x54a20 line=33458  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0272 br@0x54af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbc94 word=0x83482796 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=33513  store_unaligned_u32(right/high-byte merge) [v26 + +0x281e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0273 br@0x56f50 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc98 word=0x801af19a op=0x1a BR_COND         fetch=0x561b8 line=33570  branch_cond? target=pc+4-0x1fe8 src=v0 cmp=v26 lo12=0x19a ; conditional VM-PC control family, from z/ws/vm64.cpp
0274 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbc9c word=0xe01bef1a op=0x1a BR_COND         fetch=0x561b8 line=33626  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0275 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbca0 word=0xc01ae89a op=0x1a BR_COND         fetch=0x561b8 line=33682  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0276 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbca4 word=0x81c84ed8 op=0x18 OP18            fetch=0x54a20 line=33738  op18/version-specific? dst=v8 src=v14 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0277 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbca8 word=0x25c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=33796  call_imm? target=vm_base+0x25c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0278 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcac word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=33863  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0279 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcac word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=33880  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0280 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcb0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=33947  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0281 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcb0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=33964  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0282 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbcb4 word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=34088  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0283 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbcb4 word=0x80581a18 op=0x18 OP18            fetch=0x54a20 line=34103  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0284 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcb8 word=0x801bff1a op=0x1a BR_COND         fetch=0x561b8 line=34158  branch_cond? target=pc+4-0x1f10 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0285 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcbc word=0xe01bf31a op=0x1a BR_COND         fetch=0x561b8 line=34214  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0286 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcc0 word=0xc01af09a op=0x1a BR_COND         fetch=0x561b8 line=34270  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0287 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcc4 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=34329  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0288 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcc8 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34396  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0289 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcc8 word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=34413  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0290 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbccc word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34480  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0291 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbccc word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=34497  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0292 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcd0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=34564  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0293 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcd0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=34581  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0294 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbcd4 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=34826  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0295 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbcd4 word=0x80500a18 op=0x18 OP18            fetch=0x54a20 line=34841  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0296 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcd8 word=0xe01bff1a op=0x1a BR_COND         fetch=0x561b8 line=34896  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0297 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcdc word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=34952  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0298 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbce0 word=0x81184e98 op=0x18 OP18            fetch=0x54a20 line=35008  op18/version-specific? dst=v24 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0299 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbce4 word=0x839816d8 op=0x18 OP18            fetch=0x54a20 line=35063  op18/version-specific? dst=v24 src=v28 lo12=0x6d8 imm16=0x181b ; 350 trace hits this handler; exact semantics still version-verify
0300 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbce8 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35121  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0301 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcec word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35188  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0302 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcec word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35205  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0303 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbcf0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35272  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0304 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbcf0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35289  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0305 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbcf4 word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=35390  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0306 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbcf4 word=0x80581a18 op=0x18 OP18            fetch=0x54a20 line=35405  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0307 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcf8 word=0x801bf91a op=0x1a BR_COND         fetch=0x561b8 line=35460  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v27 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0308 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbcfc word=0xe01bf31a op=0x1a BR_COND         fetch=0x561b8 line=35516  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0309 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd00 word=0xc01af09a op=0x1a BR_COND         fetch=0x561b8 line=35572  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0310 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd04 word=0x801b329a op=0x1a BR_COND         fetch=0x561b8 line=35628  branch_cond? target=pc+4+0xe028 src=v0 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0311 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd08 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35687  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0312 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd0c word=0x81501698 op=0x18 OP18            fetch=0x4f5d8 line=35754  op18/version-specific? dst=v16 src=v10 lo12=0x698 imm16=0x181a ; 350 trace hits this handler; exact semantics still version-verify
0313 br@0x4f608 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd0c word=0x81501698 op=0x18 OP18            fetch=0x54a20 line=35768  op18/version-specific? dst=v16 src=v10 lo12=0x698 imm16=0x181a ; 350 trace hits this handler; exact semantics still version-verify
0314 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd10 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35826  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0315 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd14 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=35893  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0316 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd14 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=35910  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0317 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbd18 word=0xab9a800f op=0x0f BR_COND         fetch=0x4f8e0 line=36057  branch_cond? target=pc+4-0x1d600 src=v28 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0318 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbd18 word=0xab9a800f op=0x0f BR_COND         fetch=0x529e4 line=36095  branch_cond? target=pc+4-0x1d600 src=v28 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0319 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbd1c word=0x91fa400f op=0x0f BR_COND         fetch=0x529e4 line=36188  branch_cond? target=pc+4+0x12400 src=v15 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0320 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd20 word=0x80482a18 op=0x18 OP18            fetch=0x54a20 line=36258  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x2828 ; 350 trace hits this handler; exact semantics still version-verify
0321 br@0x54af4 -> 0x56b00 BITFIELD/op10 (primary op10 handler)       vm_pc=0x7102dfbd24 word=0xf51a0010 op=0x10 BITFIELD        fetch=0x56b60 line=36336  bitfield/rev/extract? dst=v26 src=v8 lo12=0x010 ; bitfield extract/insert/sign-extend/rev family, from z/ws/vm64.cpp
0322 br@0x56c4c -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd28 word=0x801beb1a op=0x1a BR_COND         fetch=0x561b8 line=36397  branch_cond? target=pc+4-0x5f50 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0323 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd2c word=0xa01a091a op=0x1a BR_COND         fetch=0x561b8 line=36453  branch_cond? target=pc+4+0x2890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0324 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd30 word=0xe01ae11a op=0x1a BR_COND         fetch=0x561b8 line=36509  branch_cond? target=pc+4-0x47f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0325 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd34 word=0xc01ae09a op=0x1a BR_COND         fetch=0x561b8 line=36565  branch_cond? target=pc+4-0x4ff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0326 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd38 word=0x81083e98 op=0x18 OP18            fetch=0x54a20 line=36621  op18/version-specific? dst=v8 src=v8 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0327 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd3c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=36679  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0328 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd40 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=36746  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0329 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd40 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=36763  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0330 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbd44 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=38012  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0331 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd44 word=0x80500a18 op=0x18 OP18            fetch=0x54a20 line=38027  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0332 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd48 word=0xe01bfb1a op=0x1a BR_COND         fetch=0x561b8 line=38082  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0333 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd4c word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=38138  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0334 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd50 word=0x80984ed8 op=0x18 OP18            fetch=0x54a20 line=38194  op18/version-specific? dst=v24 src=v4 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0335 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd54 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=38252  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0336 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd58 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38319  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0337 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd58 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=38336  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0338 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd5c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38403  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0339 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd5c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=38420  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0340 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=38487  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0341 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd60 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=38504  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0342 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbd64 word=0x80983e98 op=0x18 OP18            fetch=0x4f8e0 line=38605  op18/version-specific? dst=v24 src=v4 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0343 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd64 word=0x80983e98 op=0x18 OP18            fetch=0x54a20 line=38620  op18/version-specific? dst=v24 src=v4 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0344 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd68 word=0x00500118 op=0x18 OP18            fetch=0x54a20 line=38675  op18/version-specific? dst=v16 src=v2 lo12=0x118 imm16=0x0004 ; 350 trace hits this handler; exact semantics still version-verify
0345 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbd6c word=0x100c2001 op=0x01 OP01            fetch=0x55770 line=38752  op01? dst=v12 src=v0 lo12=0x001 imm16=0x2100 ; unknown/no-op-ish in current reconstruction
0346 br@0x55858 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd70 word=0x80c02218 op=0x18 OP18            fetch=0x54a20 line=38812  op18/version-specific? dst=v0 src=v6 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0347 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd74 word=0x814846d8 op=0x18 OP18            fetch=0x54a20 line=38867  op18/version-specific? dst=v8 src=v10 lo12=0x6d8 imm16=0x481b ; 350 trace hits this handler; exact semantics still version-verify
0348 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd78 word=0xe01bea9a op=0x1a BR_COND         fetch=0x561b8 line=38922  branch_cond? target=pc+4-0x4758 src=v0 cmp=v27 lo12=0xa9a ; conditional VM-PC control family, from z/ws/vm64.cpp
0349 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd7c word=0xc01ae99a op=0x1a BR_COND         fetch=0x561b8 line=38978  branch_cond? target=pc+4-0x4f68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0350 br@0x56290 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbd80 word=0x17fc27fb op=0x3b ST64            fetch=0x52d08 line=39034  store_u64 [v31 + +0x215f], v28 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0351 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbd84 word=0x83482796 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=39080  store_unaligned_u32(right/high-byte merge) [v26 + +0x281e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0352 br@0x56f50 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbd88 word=0x0802200f op=0x0f BR_COND         fetch=0x529e4 line=39160  branch_cond? target=pc+4+0x8200 src=v0 cmp=v2 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0353 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbd8c word=0x801af09a op=0x1a BR_COND         fetch=0x561b8 line=39230  branch_cond? target=pc+4-0x1ff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0354 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd90 word=0x25c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=39289  call_imm? target=vm_base+0x25c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0355 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd94 word=0x81401e98 op=0x18 OP18            fetch=0x4f5d8 line=39356  op18/version-specific? dst=v0 src=v10 lo12=0xe98 imm16=0x183a ; 350 trace hits this handler; exact semantics still version-verify
0356 br@0x4f608 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbd94 word=0x81401e98 op=0x18 OP18            fetch=0x54a20 line=39370  op18/version-specific? dst=v0 src=v10 lo12=0xe98 imm16=0x183a ; 350 trace hits this handler; exact semantics still version-verify
0357 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd98 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=39428  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0358 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbd9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=39495  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0359 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbd9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=39512  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0360 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbda0 word=0xab7ac00f op=0x0f BR_COND         fetch=0x4f8e0 line=39650  branch_cond? target=pc+4-0xd600 src=v27 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0361 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbda0 word=0xab7ac00f op=0x0f BR_COND         fetch=0x529e4 line=39688  branch_cond? target=pc+4-0xd600 src=v27 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0362 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbda4 word=0x80c87ed8 op=0x18 OP18            fetch=0x54a20 line=39758  op18/version-specific? dst=v8 src=v6 lo12=0xed8 imm16=0x783b ; 350 trace hits this handler; exact semantics still version-verify
0363 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbda8 word=0x80480a18 op=0x18 OP18            fetch=0x54a20 line=39813  op18/version-specific? dst=v8 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0364 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbdac word=0x80981e98 op=0x18 OP18            fetch=0x54a20 line=39868  op18/version-specific? dst=v24 src=v4 lo12=0xe98 imm16=0x183a ; 350 trace hits this handler; exact semantics still version-verify
0365 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdb0 word=0xa01ae11a op=0x1a BR_COND         fetch=0x561b8 line=39923  branch_cond? target=pc+4-0x57f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0366 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdb4 word=0x801be31a op=0x1a BR_COND         fetch=0x561b8 line=39979  branch_cond? target=pc+4-0x5fd0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0367 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdb8 word=0xe01ad89a op=0x1a BR_COND         fetch=0x561b8 line=40035  branch_cond? target=pc+4-0x8778 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0368 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbdbc word=0x81002698 op=0x18 OP18            fetch=0x54a20 line=40091  op18/version-specific? dst=v0 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0369 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbdc0 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=40149  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0370 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbdc4 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=40216  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0371 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbdc4 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=40233  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0372 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbdc8 word=0xab5a400f op=0x0f BR_COND         fetch=0x4f8e0 line=40357  branch_cond? target=pc+4+0x12a00 src=v26 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0373 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbdc8 word=0xab5a400f op=0x0f BR_COND         fetch=0x529e4 line=40395  branch_cond? target=pc+4+0x12a00 src=v26 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0374 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbdcc word=0x91da000f op=0x0f BR_COND         fetch=0x529e4 line=40488  branch_cond? target=pc+4+0x2400 src=v14 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0375 br@0x52af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbdd0 word=0x83400416 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=40558  store_unaligned_u32(right/high-byte merge) [v26 + +0x810], v0 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0376 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbdd4 word=0x80502a18 op=0x18 OP18            fetch=0x54a20 line=40615  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x2828 ; 350 trace hits this handler; exact semantics still version-verify
0377 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbdd8 word=0x80c04e98 op=0x18 OP18            fetch=0x54a20 line=40670  op18/version-specific? dst=v0 src=v6 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0378 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbddc word=0xc01ad99a op=0x1a BR_COND         fetch=0x561b8 line=40725  branch_cond? target=pc+4-0x8f68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0379 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbde0 word=0xa01bdb1a op=0x1a BR_COND         fetch=0x561b8 line=40781  branch_cond? target=pc+4-0x9750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0380 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbde4 word=0x801bd99a op=0x1a BR_COND         fetch=0x561b8 line=40837  branch_cond? target=pc+4-0x9f68 src=v0 cmp=v27 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0381 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbde8 word=0x9c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=40896  call_imm? target=vm_base+0x9c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0382 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbdec word=0xe01bd29a op=0x1a BR_COND         fetch=0x4f5d8 line=40963  branch_cond? target=pc+4-0x87d8 src=v0 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0383 br@0x4f608 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdec word=0xe01bd29a op=0x1a BR_COND         fetch=0x561b8 line=40977  branch_cond? target=pc+4-0x87d8 src=v0 cmp=v27 lo12=0x29a ; conditional VM-PC control family, from z/ws/vm64.cpp
0384 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdf0 word=0xc01a091a op=0x1a BR_COND         fetch=0x561b8 line=41033  branch_cond? target=pc+4+0x3090 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0385 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdf4 word=0xc01ad11a op=0x1a BR_COND         fetch=0x561b8 line=41089  branch_cond? target=pc+4-0x8ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0386 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbdf8 word=0xa01ad09a op=0x1a BR_COND         fetch=0x561b8 line=41145  branch_cond? target=pc+4-0x97f8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0387 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbdfc word=0x81082698 op=0x18 OP18            fetch=0x54a20 line=41201  op18/version-specific? dst=v8 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0388 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe00 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=41259  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0389 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbe04 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=41326  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0390 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe04 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=41343  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0391 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfb6f8 word=0x00000000 op=0x00 LD16S           fetch=0x11dac0 line=44380  v0 = load_i16 [v0 + +0x0] ; dst = *(int16_t *)(src + simm16), from z/ws/vm64.cpp
0392 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe08 word=0x80500a18 op=0x18 OP18            fetch=0x54a20 line=57052  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0393 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe0c word=0xe01bfb1a op=0x1a BR_COND         fetch=0x561b8 line=57107  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0394 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe10 word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=57163  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0395 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe14 word=0x24800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=57222  call_imm? target=vm_base+0x24800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0396 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbe18 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57289  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0397 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe18 word=0x2f800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=57306  call_imm? target=vm_base+0x2f800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0398 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbe1c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57373  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0399 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe1c word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=57390  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0400 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbe20 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=57457  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0401 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe20 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=57474  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0402 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbe24 word=0x80407698 op=0x18 OP18            fetch=0x4f8e0 line=57575  op18/version-specific? dst=v0 src=v2 lo12=0x698 imm16=0x781a ; 350 trace hits this handler; exact semantics still version-verify
0403 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe24 word=0x80407698 op=0x18 OP18            fetch=0x54a20 line=57590  op18/version-specific? dst=v0 src=v2 lo12=0x698 imm16=0x781a ; 350 trace hits this handler; exact semantics still version-verify
0404 br@0x54af4 -> 0x54020 ST16/op14 (primary op14 handler)           vm_pc=0x7102dfbe28 word=0x00460014 op=0x14 ST16            fetch=0x54028 line=57646  store_u16 [v2 + +0x0], v6 ; *(src + simm16) = dst.u16, from z/ws/vm64.cpp
0405 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe44 word=0x80482e98 op=0x18 OP18            fetch=0x54a20 line=57741  op18/version-specific? dst=v8 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0406 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe48 word=0x80982698 op=0x18 OP18            fetch=0x54a20 line=57796  op18/version-specific? dst=v24 src=v4 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0407 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe4c word=0x08820391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=57854  call_imm? target=vm_base+0x882038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0408 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe50 word=0x801a189a op=0x1a BR_COND         fetch=0x4e194 line=57921  branch_cond? target=pc+4+0x6088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0409 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe50 word=0x801a189a op=0x1a BR_COND         fetch=0x561b8 line=57935  branch_cond? target=pc+4+0x6088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0410 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe54 word=0x80402e98 op=0x18 OP18            fetch=0x54a20 line=57991  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0411 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe58 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=58049  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0412 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe5c word=0x801a109a op=0x1a BR_COND         fetch=0x4e194 line=58116  branch_cond? target=pc+4+0x6008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0413 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe5c word=0x801a109a op=0x1a BR_COND         fetch=0x561b8 line=58130  branch_cond? target=pc+4+0x6008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0414 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe60 word=0x80503698 op=0x18 OP18            fetch=0x54a20 line=58186  op18/version-specific? dst=v16 src=v2 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0415 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe64 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=58244  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0416 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe68 word=0xc01a309a op=0x1a BR_COND         fetch=0x4e194 line=58311  branch_cond? target=pc+4+0xf008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0417 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe68 word=0xc01a309a op=0x1a BR_COND         fetch=0x561b8 line=58325  branch_cond? target=pc+4+0xf008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0418 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe6c word=0x80502e98 op=0x18 OP18            fetch=0x54a20 line=58381  op18/version-specific? dst=v16 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0419 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe70 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=58439  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0420 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe74 word=0xe01a089a op=0x1a BR_COND         fetch=0x4e194 line=58506  branch_cond? target=pc+4+0x3888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0421 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe74 word=0xe01a089a op=0x1a BR_COND         fetch=0x561b8 line=58520  branch_cond? target=pc+4+0x3888 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0422 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe78 word=0x80582e98 op=0x18 OP18            fetch=0x54a20 line=58576  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x283a ; 350 trace hits this handler; exact semantics still version-verify
0423 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe7c word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=58634  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0424 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe80 word=0xe01a109a op=0x1a BR_COND         fetch=0x4e194 line=58701  branch_cond? target=pc+4+0x7808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0425 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe80 word=0xe01a109a op=0x1a BR_COND         fetch=0x561b8 line=58715  branch_cond? target=pc+4+0x7808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0426 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe84 word=0x80483698 op=0x18 OP18            fetch=0x54a20 line=58771  op18/version-specific? dst=v8 src=v2 lo12=0x698 imm16=0x381a ; 350 trace hits this handler; exact semantics still version-verify
0427 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe88 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=58829  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0428 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe8c word=0x801a289a op=0x1a BR_COND         fetch=0x4e194 line=58896  branch_cond? target=pc+4+0xa088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0429 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe8c word=0x801a289a op=0x1a BR_COND         fetch=0x561b8 line=58910  branch_cond? target=pc+4+0xa088 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0430 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe90 word=0x80505698 op=0x18 OP18            fetch=0x54a20 line=58966  op18/version-specific? dst=v16 src=v2 lo12=0x698 imm16=0x581a ; 350 trace hits this handler; exact semantics still version-verify
0431 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbe94 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=59024  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0432 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbe98 word=0xc01a509a op=0x1a BR_COND         fetch=0x4e194 line=59091  branch_cond? target=pc+4+0x17008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0433 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbe98 word=0xc01a509a op=0x1a BR_COND         fetch=0x561b8 line=59105  branch_cond? target=pc+4+0x17008 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0434 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbe9c word=0x80403e98 op=0x18 OP18            fetch=0x54a20 line=59161  op18/version-specific? dst=v0 src=v2 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0435 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbea0 word=0x0c420391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=59219  call_imm? target=vm_base+0xc42038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0436 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbea4 word=0xe01a209a op=0x1a BR_COND         fetch=0x4e194 line=59286  branch_cond? target=pc+4+0xb808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0437 br@0x4e1c4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbea4 word=0xe01a209a op=0x1a BR_COND         fetch=0x561b8 line=59300  branch_cond? target=pc+4+0xb808 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0438 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbea8 word=0x80480218 op=0x18 OP18            fetch=0x54a20 line=59356  op18/version-specific? dst=v8 src=v2 lo12=0x218 imm16=0x0808 ; 350 trace hits this handler; exact semantics still version-verify
0439 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbeac word=0x80807698 op=0x18 OP18            fetch=0x54a20 line=59411  op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x781a ; 350 trace hits this handler; exact semantics still version-verify
0440 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbeb0 word=0x801ad11a op=0x1a BR_COND         fetch=0x561b8 line=59466  branch_cond? target=pc+4-0x9ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0441 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbeb4 word=0x91ba400f op=0x0f BR_COND         fetch=0x529e4 line=59545  branch_cond? target=pc+4+0x12400 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0442 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbeb8 word=0xa01a311a op=0x1a BR_COND         fetch=0x561b8 line=59615  branch_cond? target=pc+4+0xe810 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0443 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbebc word=0xe01ac91a op=0x1a BR_COND         fetch=0x561b8 line=59671  branch_cond? target=pc+4-0xc770 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0444 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbec0 word=0xc01ac89a op=0x1a BR_COND         fetch=0x561b8 line=59727  branch_cond? target=pc+4-0xcf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0445 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbec4 word=0xab3a800f op=0x0f BR_COND         fetch=0x529e4 line=59806  branch_cond? target=pc+4-0x1d600 src=v25 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0446 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbec8 word=0x81103e98 op=0x18 OP18            fetch=0x54a20 line=59876  op18/version-specific? dst=v16 src=v8 lo12=0xe98 imm16=0x383a ; 350 trace hits this handler; exact semantics still version-verify
0447 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbecc word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=59934  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0448 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbed0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=60001  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0449 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbed0 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=60018  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0450 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbed4 word=0x80586e98 op=0x18 OP18            fetch=0x4f8e0 line=60150  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x683a ; 350 trace hits this handler; exact semantics still version-verify
0451 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbed4 word=0x80586e98 op=0x18 OP18            fetch=0x54a20 line=60165  op18/version-specific? dst=v24 src=v2 lo12=0xe98 imm16=0x683a ; 350 trace hits this handler; exact semantics still version-verify
0452 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbed8 word=0x10001001 op=0x01 OP01            fetch=0x55770 line=60242  op01? dst=v0 src=v0 lo12=0x001 imm16=0x1100 ; unknown/no-op-ish in current reconstruction
0453 br@0x55858 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbedc word=0xab1a400f op=0x0f BR_COND         fetch=0x529e4 line=60325  branch_cond? target=pc+4+0x12a00 src=v24 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0454 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbee0 word=0xa1ba000f op=0x0f BR_COND         fetch=0x529e4 line=60418  branch_cond? target=pc+4+0x2800 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0455 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbee4 word=0xc01a2a1a op=0x1a BR_COND         fetch=0x561b8 line=60488  branch_cond? target=pc+4+0xb0a0 src=v0 cmp=v26 lo12=0xa1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0456 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbee8 word=0x1800200f op=0x0f BR_COND         fetch=0x529e4 line=60567  branch_cond? target=pc+4+0x8600 src=v0 cmp=v0 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0457 br@0x52af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbeec word=0x83442356 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=60637  store_unaligned_u32(right/high-byte merge) [v26 + +0x280d], v4 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0458 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbef0 word=0x80882218 op=0x18 OP18            fetch=0x54a20 line=60694  op18/version-specific? dst=v8 src=v4 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0459 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbef4 word=0x801ac99a op=0x1a BR_COND         fetch=0x561b8 line=60749  branch_cond? target=pc+4-0xdf68 src=v0 cmp=v26 lo12=0x99a ; conditional VM-PC control family, from z/ws/vm64.cpp
0460 br@0x56290 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7102dfbef8 word=0x99b4d001 op=0x01 OP01            fetch=0x55770 line=60827  op01? dst=v20 src=v13 lo12=0x001 imm16=0xd980 ; unknown/no-op-ish in current reconstruction
0461 br@0x55858 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbefc word=0x08c20391 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=60890  call_imm? target=vm_base+0x8c2038, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0462 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7102dfbf00 word=0x0fe2e7cf op=0x0f BR_COND         fetch=0x4e194 line=60957  branch_cond? target=pc+4-0x7c84 src=v31 cmp=v2 lo12=0x7cf ; conditional VM-PC control family, from z/ws/vm64.cpp
0463 br@0x4e1c4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbf00 word=0x0fe2e7cf op=0x0f BR_COND         fetch=0x529e4 line=60994  branch_cond? target=pc+4-0x7c84 src=v31 cmp=v2 lo12=0x7cf ; conditional VM-PC control family, from z/ws/vm64.cpp
0464 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf04 word=0xe01ac09a op=0x1a BR_COND         fetch=0x561b8 line=61064  branch_cond? target=pc+4-0xc7f8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0465 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf08 word=0xc01ac21a op=0x1a BR_COND         fetch=0x561b8 line=61120  branch_cond? target=pc+4-0xcfe0 src=v0 cmp=v26 lo12=0x21a ; conditional VM-PC control family, from z/ws/vm64.cpp
0466 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf0c word=0xa01ac11a op=0x1a BR_COND         fetch=0x561b8 line=61176  branch_cond? target=pc+4-0xd7f0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0467 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf10 word=0x81102698 op=0x18 OP18            fetch=0x54a20 line=61232  op18/version-specific? dst=v16 src=v8 lo12=0x698 imm16=0x281a ; 350 trace hits this handler; exact semantics still version-verify
0468 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf14 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=61290  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0469 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=61357  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0470 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf18 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=61374  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0471 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbf1c word=0x93fb800f op=0x0f BR_COND         fetch=0x4f8e0 line=61632  branch_cond? target=pc+4-0x1dc00 src=v31 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0472 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbf1c word=0x93fb800f op=0x0f BR_COND         fetch=0x529e4 line=61670  branch_cond? target=pc+4-0x1dc00 src=v31 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0473 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf20 word=0x80582218 op=0x18 OP18            fetch=0x54a20 line=61740  op18/version-specific? dst=v24 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0474 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf24 word=0xe01bfb1a op=0x1a BR_COND         fetch=0x561b8 line=61795  branch_cond? target=pc+4-0x750 src=v0 cmp=v27 lo12=0xb1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0475 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf28 word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=61851  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0476 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf2c word=0x24c00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=61910  call_imm? target=vm_base+0x24c00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0477 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf30 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=61977  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0478 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf30 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=61994  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0479 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf34 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=62061  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0480 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf34 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=62078  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0481 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf38 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=62145  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0482 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf38 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=62162  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0483 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbf3c word=0x8cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f8e0 line=62263  call_imm? target=vm_base+0x8cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0484 br@0x4f914 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf3c word=0x8cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=62281  call_imm? target=vm_base+0x8cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0485 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf40 word=0x9bbb800f op=0x0f BR_COND         fetch=0x4f5d8 line=62348  branch_cond? target=pc+4-0x1da00 src=v29 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0486 br@0x4f608 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbf40 word=0x9bbb800f op=0x0f BR_COND         fetch=0x529e4 line=62385  branch_cond? target=pc+4-0x1da00 src=v29 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0487 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbf44 word=0x91ba200f op=0x0f BR_COND         fetch=0x529e4 line=62478  branch_cond? target=pc+4+0xa400 src=v13 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0488 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf48 word=0x80402218 op=0x18 OP18            fetch=0x54a20 line=62548  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0489 br@0x54af4 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbf4c word=0x1804003b op=0x3b ST64            fetch=0x52d08 line=62603  store_u64 [v0 + +0x180], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0490 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbf50 word=0x83483796 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=62649  store_unaligned_u32(right/high-byte merge) [v26 + +0x381e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0491 br@0x56f50 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf54 word=0xa01a291a op=0x1a BR_COND         fetch=0x561b8 line=62706  branch_cond? target=pc+4+0xa890 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0492 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf58 word=0x801af11a op=0x1a BR_COND         fetch=0x561b8 line=62762  branch_cond? target=pc+4-0x1ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0493 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf5c word=0x83804ed8 op=0x18 OP18            fetch=0x54a20 line=62818  op18/version-specific? dst=v0 src=v28 lo12=0xed8 imm16=0x483b ; 350 trace hits this handler; exact semantics still version-verify
0494 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf60 word=0xe01bef1a op=0x1a BR_COND         fetch=0x561b8 line=62873  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0495 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf64 word=0xc01ae89a op=0x1a BR_COND         fetch=0x561b8 line=62929  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0496 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf68 word=0x81084e98 op=0x18 OP18            fetch=0x54a20 line=62985  op18/version-specific? dst=v8 src=v8 lo12=0xe98 imm16=0x483a ; 350 trace hits this handler; exact semantics still version-verify
0497 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf6c word=0x2cc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63043  call_imm? target=vm_base+0x2cc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0498 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf70 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63110  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0499 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf70 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63127  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0500 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf74 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63194  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0501 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf74 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63211  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0502 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbf78 word=0xbbdb800f op=0x0f BR_COND         fetch=0x4f8e0 line=63335  branch_cond? target=pc+4-0x1d200 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0503 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbf78 word=0xbbdb800f op=0x0f BR_COND         fetch=0x529e4 line=63373  branch_cond? target=pc+4-0x1d200 src=v30 cmp=v27 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0504 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf7c word=0x80581a18 op=0x18 OP18            fetch=0x54a20 line=63443  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0505 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf80 word=0x801bff1a op=0x1a BR_COND         fetch=0x561b8 line=63498  branch_cond? target=pc+4-0x1f10 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0506 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf84 word=0xe01bf31a op=0x1a BR_COND         fetch=0x561b8 line=63554  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0507 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbf88 word=0xc01af09a op=0x1a BR_COND         fetch=0x561b8 line=63610  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0508 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbf8c word=0x814036d8 op=0x18 OP18            fetch=0x54a20 line=63666  op18/version-specific? dst=v0 src=v10 lo12=0x6d8 imm16=0x381b ; 350 trace hits this handler; exact semantics still version-verify
0509 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf90 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63724  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0510 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf94 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63791  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0511 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf94 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63808  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0512 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf98 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63875  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0513 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf98 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63892  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0514 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbf9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=63959  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0515 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbf9c word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=63976  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0516 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbfa0 word=0x80500a18 op=0x18 OP18            fetch=0x4f8e0 line=64123  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0517 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbfa0 word=0x80500a18 op=0x18 OP18            fetch=0x54a20 line=64138  op18/version-specific? dst=v16 src=v2 lo12=0xa18 imm16=0x0828 ; 350 trace hits this handler; exact semantics still version-verify
0518 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbfa4 word=0xe01bff1a op=0x1a BR_COND         fetch=0x561b8 line=64193  branch_cond? target=pc+4-0x710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0519 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbfa8 word=0xc01af89a op=0x1a BR_COND         fetch=0x561b8 line=64249  branch_cond? target=pc+4-0xf78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0520 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfac word=0x24400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=64308  call_imm? target=vm_base+0x24400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0521 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfb0 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64375  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0522 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfb0 word=0x2c800b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=64392  call_imm? target=vm_base+0x2c800b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0523 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64459  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0524 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfb4 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=64476  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0525 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=64543  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0526 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfb8 word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=64560  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0527 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbfbc word=0x80581a18 op=0x18 OP18            fetch=0x4f8e0 line=64661  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0528 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbfbc word=0x80581a18 op=0x18 OP18            fetch=0x54a20 line=64676  op18/version-specific? dst=v24 src=v2 lo12=0xa18 imm16=0x1828 ; 350 trace hits this handler; exact semantics still version-verify
0529 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbfc0 word=0x80804698 op=0x18 OP18            fetch=0x54a20 line=64731  op18/version-specific? dst=v0 src=v4 lo12=0x698 imm16=0x481a ; 350 trace hits this handler; exact semantics still version-verify
0530 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbfc4 word=0x801af91a op=0x1a BR_COND         fetch=0x561b8 line=64786  branch_cond? target=pc+4-0x1f70 src=v0 cmp=v26 lo12=0x91a ; conditional VM-PC control family, from z/ws/vm64.cpp
0531 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbfc8 word=0xe01bf31a op=0x1a BR_COND         fetch=0x561b8 line=64842  branch_cond? target=pc+4-0x7d0 src=v0 cmp=v27 lo12=0x31a ; conditional VM-PC control family, from z/ws/vm64.cpp
0532 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbfcc word=0xc01af09a op=0x1a BR_COND         fetch=0x561b8 line=64898  branch_cond? target=pc+4-0xff8 src=v0 cmp=v26 lo12=0x09a ; conditional VM-PC control family, from z/ws/vm64.cpp
0533 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfd0 word=0x25400b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=64957  call_imm? target=vm_base+0x25400b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0534 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfd4 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65024  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0535 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfd4 word=0x2dc00b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=65041  call_imm? target=vm_base+0x2dc00b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0536 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfd8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65108  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0537 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfd8 word=0xcc000b11 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=65125  call_imm? target=vm_base+0xcc000b0, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0538 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7102dfbfdc word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4f5d8 line=65192  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0539 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) vm_pc=0x7102dfbfdc word=0xc801fc91 op=0x11 CALL_IMM_LINK31 fetch=0x4ce64 line=65209  call_imm? target=vm_base+0xc801fc8, link=v31=pc+8 ; VM call/jump with link v31 = pc+8, from z/ws/vm64.cpp
0540 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7102dfbfe0 word=0x91fae00f op=0x0f BR_COND         fetch=0x4f8e0 line=65451  branch_cond? target=pc+4-0x5c00 src=v15 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0541 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler)        vm_pc=0x7102dfbfe0 word=0x91fae00f op=0x0f BR_COND         fetch=0x529e4 line=65489  branch_cond? target=pc+4-0x5c00 src=v15 cmp=v26 lo12=0x00f ; conditional VM-PC control family, from z/ws/vm64.cpp
0542 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler)           vm_pc=0x7102dfbfe4 word=0x80402218 op=0x18 OP18            fetch=0x54a20 line=65559  op18/version-specific? dst=v0 src=v2 lo12=0x218 imm16=0x2808 ; 350 trace hits this handler; exact semantics still version-verify
0543 br@0x54af4 -> 0x52d04 ST64/op3b (primary op3b handler)           vm_pc=0x7102dfbfe8 word=0x1804003b op=0x3b ST64            fetch=0x52d08 line=65614  store_u64 [v0 + +0x180], v4 ; *(src + simm16) = dst.u64, from z/ws/vm64.cpp
0544 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) vm_pc=0x7102dfbfec word=0x83483796 op=0x16 ST32_UNALIGNED_R fetch=0x56e74 line=65660  store_unaligned_u32(right/high-byte merge) [v26 + +0x381e], v8 ; unaligned 32-bit store/merge variant, from z/ws/vm64.cpp
0545 br@0x56f50 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbff0 word=0xc01a111a op=0x1a BR_COND         fetch=0x561b8 line=65717  branch_cond? target=pc+4+0x7010 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0546 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbff4 word=0x801af11a op=0x1a BR_COND         fetch=0x561b8 line=65773  branch_cond? target=pc+4-0x1ff0 src=v0 cmp=v26 lo12=0x11a ; conditional VM-PC control family, from z/ws/vm64.cpp
0547 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbff8 word=0xe01bef1a op=0x1a BR_COND         fetch=0x561b8 line=65829  branch_cond? target=pc+4-0x4710 src=v0 cmp=v27 lo12=0xf1a ; conditional VM-PC control family, from z/ws/vm64.cpp
0548 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler)        vm_pc=0x7102dfbffc word=0xc01ae89a op=0x1a BR_COND         fetch=0x561b8 line=65885  branch_cond? target=pc+4-0x4f78 src=v0 cmp=v26 lo12=0x89a ; conditional VM-PC control family, from z/ws/vm64.cpp
0549 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0550 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0551 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0552 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0553 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0554 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0555 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0556 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0557 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0558 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0559 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0560 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0561 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0562 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0563 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0564 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0565 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0566 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0567 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0568 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0569 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0570 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0571 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0572 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0573 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0574 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0575 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0576 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0577 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0578 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0579 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0580 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0581 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0582 br@0x52db8 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0583 br@0x54af4 -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0584 br@0x56c4c -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0585 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0586 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0587 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0588 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0589 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0590 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0591 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0592 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0593 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0594 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0595 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0596 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0597 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0598 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0599 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0600 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0601 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0602 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0603 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0604 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0605 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0606 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0607 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0608 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0609 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0610 br@0x4f608 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0611 br@0x53098 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0612 br@0x53f7c -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0613 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0614 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0615 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0616 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0617 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0618 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0619 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0620 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0621 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0622 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0623 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0624 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0625 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0626 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0627 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0628 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0629 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0630 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0631 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0632 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0633 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0634 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0635 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0636 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0637 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0638 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0639 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0640 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0641 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0642 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0643 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0644 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0645 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0646 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0647 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0648 br@0x54224 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0649 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0650 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0651 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0652 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0653 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0654 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0655 br@0x4f608 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0656 br@0x53098 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0657 br@0x53f7c -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0658 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0659 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0660 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0661 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0662 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0663 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0664 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0665 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0666 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0667 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0668 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0669 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0670 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0671 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0672 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0673 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0674 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0675 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0676 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0677 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0678 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0679 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0680 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0681 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0682 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0683 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0684 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0685 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0686 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0687 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0688 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0689 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0690 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0691 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0692 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0693 br@0x54224 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0694 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0695 br@0x53098 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0696 br@0x53f7c -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0697 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0698 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0699 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0700 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0701 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0702 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0703 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0704 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0705 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0706 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0707 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0708 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0709 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0710 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0711 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0712 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0713 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0714 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0715 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0716 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0717 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0718 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0719 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0720 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0721 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0722 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0723 br@0x54224 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0724 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0725 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0726 br@0x55a74 -> 0x5309c secondary/unknown target ; no VM word read before next BR
0727 br@0x53170 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0728 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0729 br@0x4f82c -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0730 br@0x52af4 -> 0x52f34 secondary/unknown target ; no VM word read before next BR
0731 br@0x53098 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0732 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0733 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
0734 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0735 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
0736 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0737 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0738 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0739 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0740 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0741 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0742 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0743 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0744 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0745 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0746 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0747 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0748 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0749 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0750 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0751 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0752 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0753 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0754 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0755 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0756 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0757 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0758 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0759 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0760 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0761 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0762 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0763 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0764 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0765 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0766 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0767 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0768 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0769 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0770 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0771 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0772 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0773 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0774 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0775 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0776 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0777 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0778 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0779 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0780 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0781 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0782 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0783 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0784 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0785 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0786 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0787 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0788 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
0789 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0790 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
0791 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0792 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
0793 br@0x55858 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
0794 br@0x53d38 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0795 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0796 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0797 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0798 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0799 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0800 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0801 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0802 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0803 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0804 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0805 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0806 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0807 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0808 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0809 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0810 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0811 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0812 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0813 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0814 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0815 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0816 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0817 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0818 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0819 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0820 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0821 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0822 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0823 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0824 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0825 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0826 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0827 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0828 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0829 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0830 br@0x52af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0831 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0832 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0833 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0834 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0835 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0836 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0837 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0838 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0839 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0840 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0841 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0842 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0843 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0844 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0845 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0846 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0847 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0848 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0849 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0850 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0851 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0852 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0853 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0854 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0855 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0856 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0857 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0858 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0859 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0860 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0861 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0862 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0863 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0864 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0865 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0866 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0867 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0868 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0869 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0870 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0871 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0872 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0873 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0874 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0875 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0876 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0877 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0878 br@0x54af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
0879 br@0x56f50 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0880 br@0x53f7c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0881 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
0882 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0883 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0884 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0885 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0886 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0887 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0888 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0889 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0890 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0891 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0892 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0893 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0894 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0895 br@0x52db8 -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0896 br@0x56c4c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
0897 br@0x55858 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
0898 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0899 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0900 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
0901 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0902 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0903 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
0904 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0905 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0906 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0907 br@0x52af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
0908 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0909 br@0x52db8 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0910 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0911 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0912 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
0913 br@0x4f238 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
0914 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0915 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0916 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0917 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0918 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
0919 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0920 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0921 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0922 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0923 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0924 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0925 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0926 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0927 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0928 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0929 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0930 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
0931 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0932 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0933 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0934 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0935 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0936 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
0937 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0938 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0939 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0940 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0941 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0942 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0943 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0944 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0945 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0946 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0947 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0948 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
0949 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0950 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0951 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0952 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0953 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0954 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
0955 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0956 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0957 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0958 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0959 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0960 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0961 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0962 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0963 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0964 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0965 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0966 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
0967 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0968 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0969 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0970 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0971 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0972 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
0973 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0974 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0975 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0976 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0977 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0978 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0979 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0980 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0981 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
0982 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0983 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0984 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
0985 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
0986 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0987 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0988 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0989 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0990 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
0991 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
0992 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0993 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
0994 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
0995 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
0996 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
0997 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
0998 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
0999 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1000 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1001 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1002 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1003 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1004 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1005 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1006 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1007 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1008 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1009 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1010 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1011 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1012 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1013 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1014 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1015 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1016 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1017 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1018 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1019 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1020 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1021 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1022 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1023 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1024 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1025 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1026 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1027 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1028 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1029 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1030 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1031 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1032 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1033 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1034 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1035 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1036 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1037 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1038 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1039 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1040 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1041 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1042 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1043 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1044 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1045 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1046 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1047 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1048 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1049 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1050 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1051 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1052 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1053 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1054 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1055 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1056 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1057 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1058 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1059 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1060 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1061 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1062 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1063 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1064 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1065 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1066 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1067 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1068 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1069 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1070 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1071 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1072 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1073 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1074 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1075 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1076 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1077 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1078 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1079 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1080 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1081 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1082 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1083 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1084 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1085 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1086 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1087 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1088 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1089 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1090 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1091 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1092 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1093 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1094 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1095 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1096 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1097 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1098 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1099 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1100 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1101 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1102 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1103 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1104 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1105 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1106 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1107 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1108 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1109 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1110 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1111 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1112 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1113 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1114 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1115 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1116 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1117 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1118 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1119 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1120 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1121 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1122 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1123 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1124 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1125 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1126 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1127 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1128 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1129 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1130 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1131 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1132 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1133 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1134 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1135 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1136 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1137 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1138 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1139 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1140 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1141 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1142 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1143 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1144 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1145 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1146 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1147 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1148 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1149 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1150 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1151 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1152 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1153 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1154 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1155 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1156 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1157 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1158 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1159 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1160 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1161 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1162 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1163 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1164 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1165 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1166 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1167 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1168 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1169 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1170 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1171 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1172 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1173 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1174 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1175 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1176 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1177 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1178 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1179 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1180 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1181 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1182 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1183 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1184 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1185 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1186 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1187 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1188 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1189 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1190 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1191 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1192 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1193 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1194 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1195 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1196 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1197 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1198 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1199 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1200 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1201 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1202 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1203 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1204 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1205 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1206 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1207 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1208 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1209 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1210 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1211 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1212 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1213 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1214 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1215 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1216 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1217 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1218 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1219 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1220 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1221 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1222 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1223 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1224 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1225 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1226 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1227 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1228 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1229 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1230 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1231 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1232 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1233 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1234 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1235 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1236 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1237 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1238 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1239 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1240 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1241 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1242 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1243 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1244 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1245 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1246 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1247 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1248 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1249 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1250 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1251 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1252 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1253 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1254 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1255 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1256 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1257 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1258 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1259 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1260 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1261 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1262 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1263 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1264 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1265 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1266 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1267 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1268 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1269 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1270 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1271 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1272 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1273 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1274 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1275 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1276 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1277 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1278 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1279 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1280 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1281 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1282 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1283 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1284 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1285 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1286 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1287 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1288 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1289 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1290 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1291 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1292 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1293 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1294 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1295 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1296 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1297 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1298 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1299 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1300 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1301 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1302 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1303 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1304 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1305 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1306 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1307 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1308 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1309 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1310 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1311 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1312 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1313 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1314 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1315 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1316 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1317 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1318 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1319 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1320 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1321 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1322 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1323 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1324 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1325 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1326 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1327 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1328 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1329 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1330 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1331 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1332 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1333 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1334 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1335 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1336 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1337 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1338 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1339 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1340 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1341 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1342 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1343 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1344 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1345 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1346 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1347 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1348 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1349 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1350 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1351 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1352 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1353 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1354 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1355 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1356 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1357 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1358 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1359 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1360 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1361 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1362 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1363 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1364 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1365 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1366 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1367 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1368 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1369 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1370 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1371 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1372 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1373 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1374 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1375 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1376 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1377 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1378 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1379 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1380 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1381 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1382 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1383 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1384 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1385 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1386 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1387 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1388 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1389 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1390 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1391 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1392 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1393 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1394 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1395 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1396 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1397 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1398 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1399 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1400 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1401 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1402 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1403 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1404 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1405 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1406 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1407 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1408 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1409 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1410 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1411 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1412 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1413 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1414 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1415 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1416 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1417 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1418 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1419 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1420 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1421 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1422 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1423 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1424 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1425 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1426 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1427 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1428 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1429 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1430 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1431 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1432 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1433 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1434 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1435 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1436 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1437 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1438 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1439 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1440 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1441 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1442 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1443 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1444 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1445 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1446 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1447 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1448 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1449 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1450 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1451 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1452 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1453 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1454 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1455 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1456 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1457 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1458 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1459 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1460 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1461 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1462 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1463 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1464 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1465 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1466 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1467 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1468 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1469 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1470 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1471 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1472 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1473 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1474 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1475 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1476 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1477 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1478 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1479 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1480 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1481 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1482 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1483 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1484 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1485 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1486 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1487 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1488 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1489 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1490 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1491 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1492 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1493 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1494 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1495 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1496 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1497 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1498 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1499 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1500 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1501 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1502 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1503 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1504 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1505 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1506 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1507 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1508 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1509 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1510 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1511 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1512 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1513 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1514 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1515 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1516 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1517 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1518 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1519 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1520 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1521 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1522 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1523 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1524 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1525 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1526 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1527 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1528 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1529 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1530 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1531 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1532 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1533 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1534 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1535 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1536 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1537 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1538 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1539 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1540 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1541 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1542 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1543 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1544 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1545 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1546 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1547 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1548 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1549 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1550 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1551 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1552 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1553 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1554 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1555 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1556 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1557 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1558 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1559 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1560 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1561 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1562 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1563 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1564 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1565 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1566 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1567 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1568 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1569 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1570 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1571 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1572 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1573 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1574 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1575 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1576 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1577 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1578 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1579 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1580 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1581 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1582 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1583 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1584 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1585 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1586 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1587 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1588 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1589 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1590 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1591 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1592 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1593 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1594 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1595 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1596 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1597 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1598 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1599 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1600 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1601 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1602 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1603 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1604 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1605 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1606 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1607 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1608 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1609 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1610 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1611 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1612 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1613 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1614 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1615 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1616 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1617 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1618 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1619 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1620 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1621 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1622 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1623 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1624 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1625 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1626 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1627 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1628 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1629 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1630 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1631 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1632 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1633 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1634 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1635 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1636 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1637 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1638 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1639 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1640 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1641 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1642 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1643 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1644 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1645 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1646 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1647 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1648 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1649 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1650 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1651 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1652 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1653 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1654 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1655 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1656 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1657 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1658 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1659 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1660 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1661 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1662 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1663 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1664 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1665 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1666 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1667 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1668 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1669 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1670 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1671 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1672 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1673 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1674 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1675 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1676 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1677 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1678 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1679 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1680 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1681 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1682 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1683 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1684 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1685 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1686 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1687 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1688 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1689 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1690 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1691 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1692 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1693 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1694 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1695 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1696 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1697 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1698 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1699 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1700 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1701 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1702 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1703 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1704 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1705 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1706 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1707 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1708 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1709 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1710 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1711 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1712 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1713 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1714 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1715 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1716 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1717 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1718 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1719 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1720 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1721 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1722 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1723 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1724 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1725 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1726 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1727 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1728 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1729 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1730 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1731 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1732 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1733 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1734 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1735 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1736 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1737 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1738 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1739 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1740 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1741 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1742 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1743 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1744 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1745 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1746 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1747 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1748 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1749 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1750 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1751 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1752 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1753 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1754 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1755 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1756 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1757 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1758 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1759 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1760 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1761 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1762 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1763 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1764 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1765 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1766 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1767 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1768 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1769 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1770 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1771 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1772 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1773 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1774 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1775 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1776 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1777 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1778 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1779 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1780 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1781 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1782 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1783 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1784 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1785 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1786 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1787 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1788 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1789 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1790 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1791 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1792 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1793 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1794 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1795 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1796 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1797 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1798 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1799 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1800 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1801 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1802 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1803 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1804 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1805 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1806 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1807 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1808 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1809 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1810 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1811 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1812 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1813 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1814 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1815 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1816 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1817 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1818 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1819 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1820 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1821 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1822 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1823 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1824 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1825 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1826 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1827 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1828 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1829 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1830 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1831 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1832 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1833 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1834 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1835 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1836 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1837 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1838 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1839 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1840 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1841 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1842 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1843 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1844 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1845 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1846 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1847 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1848 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1849 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1850 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1851 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1852 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1853 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1854 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1855 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1856 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1857 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1858 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1859 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1860 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1861 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1862 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1863 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1864 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1865 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1866 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1867 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1868 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1869 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1870 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1871 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1872 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1873 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1874 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1875 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1876 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1877 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1878 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1879 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1880 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1881 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1882 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1883 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1884 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1885 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1886 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1887 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1888 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1889 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1890 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1891 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1892 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1893 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1894 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1895 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1896 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1897 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1898 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1899 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1900 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1901 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1902 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1903 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1904 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1905 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1906 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1907 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1908 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1909 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1910 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1911 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1912 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1913 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1914 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1915 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1916 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1917 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1918 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1919 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1920 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1921 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1922 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1923 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1924 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1925 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1926 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1927 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1928 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1929 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1930 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1931 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1932 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1933 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1934 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1935 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1936 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1937 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1938 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1939 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1940 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1941 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1942 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1943 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1944 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1945 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1946 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1947 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1948 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1949 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1950 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1951 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1952 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1953 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1954 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1955 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1956 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1957 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1958 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1959 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1960 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1961 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1962 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1963 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1964 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1965 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1966 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1967 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1968 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1969 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1970 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1971 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1972 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1973 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1974 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1975 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1976 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1977 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1978 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1979 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1980 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1981 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1982 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1983 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1984 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
1985 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1986 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
1987 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
1988 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1989 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
1990 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
1991 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1992 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
1993 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
1994 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
1995 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1996 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
1997 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
1998 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
1999 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2000 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2001 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2002 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2003 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2004 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2005 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2006 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2007 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2008 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2009 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2010 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2011 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2012 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2013 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2014 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2015 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2016 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2017 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2018 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2019 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2020 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2021 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2022 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2023 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2024 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2025 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2026 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2027 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2028 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2029 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2030 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2031 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2032 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2033 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2034 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2035 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2036 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2037 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2038 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2039 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2040 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2041 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2042 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2043 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2044 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2045 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2046 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2047 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2048 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2049 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2050 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2051 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2052 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2053 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2054 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2055 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2056 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2057 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2058 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2059 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2060 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2061 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2062 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2063 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2064 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2065 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2066 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2067 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2068 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2069 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2070 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2071 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2072 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2073 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2074 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2075 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2076 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2077 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2078 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2079 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2080 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2081 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2082 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2083 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2084 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2085 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2086 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2087 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2088 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2089 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2090 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2091 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2092 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2093 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2094 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2095 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2096 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2097 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2098 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2099 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2100 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2101 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2102 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2103 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2104 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2105 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2106 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2107 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2108 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2109 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2110 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2111 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2112 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2113 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2114 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2115 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2116 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2117 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2118 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2119 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2120 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2121 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2122 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2123 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2124 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2125 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2126 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2127 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2128 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2129 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2130 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2131 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2132 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2133 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2134 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2135 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2136 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2137 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2138 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2139 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2140 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2141 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2142 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2143 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2144 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2145 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2146 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2147 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2148 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2149 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2150 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2151 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2152 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2153 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2154 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2155 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2156 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2157 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2158 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2159 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2160 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2161 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2162 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2163 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2164 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2165 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2166 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2167 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2168 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2169 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2170 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2171 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2172 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2173 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2174 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2175 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2176 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2177 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2178 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2179 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2180 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2181 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2182 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2183 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2184 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2185 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2186 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2187 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2188 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2189 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2190 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2191 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2192 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2193 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2194 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2195 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2196 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2197 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2198 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2199 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2200 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2201 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2202 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2203 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2204 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2205 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2206 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2207 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2208 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2209 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2210 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2211 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2212 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2213 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2214 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2215 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2216 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2217 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2218 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2219 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2220 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2221 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2222 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2223 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2224 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2225 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2226 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2227 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2228 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2229 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2230 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2231 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2232 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2233 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2234 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2235 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2236 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2237 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2238 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2239 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2240 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2241 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2242 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2243 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2244 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2245 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2246 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2247 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2248 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2249 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2250 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2251 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2252 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2253 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2254 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2255 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2256 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2257 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2258 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2259 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2260 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2261 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2262 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2263 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2264 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2265 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2266 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2267 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2268 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2269 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2270 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2271 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2272 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2273 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2274 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2275 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2276 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2277 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2278 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2279 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2280 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2281 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2282 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2283 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2284 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2285 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2286 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2287 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2288 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2289 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2290 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2291 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2292 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2293 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2294 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2295 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2296 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2297 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2298 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2299 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2300 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2301 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2302 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2303 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2304 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2305 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2306 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2307 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2308 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2309 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2310 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2311 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2312 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2313 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2314 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2315 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2316 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2317 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2318 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2319 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2320 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2321 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2322 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2323 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2324 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2325 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2326 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2327 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2328 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2329 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2330 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2331 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2332 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2333 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2334 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2335 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2336 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2337 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2338 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2339 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2340 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2341 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2342 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2343 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2344 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2345 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2346 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2347 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2348 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2349 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2350 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2351 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2352 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2353 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2354 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2355 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2356 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2357 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2358 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2359 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2360 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2361 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2362 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2363 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2364 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2365 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2366 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2367 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2368 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2369 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2370 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2371 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2372 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2373 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2374 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2375 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2376 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2377 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2378 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2379 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2380 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2381 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2382 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2383 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2384 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2385 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2386 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2387 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2388 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2389 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2390 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2391 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2392 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2393 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2394 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2395 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2396 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2397 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2398 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2399 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2400 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2401 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2402 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2403 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2404 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2405 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2406 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2407 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2408 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2409 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2410 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2411 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2412 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2413 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2414 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2415 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2416 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2417 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2418 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2419 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2420 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2421 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2422 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2423 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2424 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2425 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2426 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2427 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2428 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2429 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2430 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2431 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2432 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2433 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2434 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2435 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2436 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2437 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2438 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2439 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2440 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2441 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2442 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2443 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2444 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2445 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2446 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2447 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2448 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2449 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2450 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2451 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2452 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2453 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2454 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2455 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2456 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2457 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2458 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2459 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2460 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2461 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2462 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2463 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2464 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2465 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2466 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2467 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2468 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2469 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2470 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2471 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2472 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2473 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2474 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2475 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2476 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2477 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2478 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2479 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2480 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2481 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2482 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2483 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2484 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2485 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2486 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2487 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2488 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2489 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2490 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2491 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2492 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2493 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2494 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2495 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2496 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2497 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2498 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2499 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2500 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2501 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2502 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2503 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2504 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2505 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2506 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2507 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2508 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2509 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2510 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2511 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2512 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2513 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2514 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2515 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2516 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2517 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2518 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2519 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2520 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2521 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2522 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2523 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2524 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2525 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2526 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2527 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2528 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2529 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2530 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2531 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2532 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2533 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2534 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2535 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2536 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2537 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2538 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2539 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2540 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2541 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2542 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2543 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2544 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2545 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2546 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2547 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2548 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2549 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2550 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2551 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2552 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2553 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2554 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2555 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2556 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2557 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2558 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2559 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2560 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2561 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2562 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2563 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2564 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2565 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2566 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2567 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2568 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2569 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2570 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2571 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2572 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2573 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2574 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2575 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2576 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2577 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2578 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2579 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2580 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2581 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2582 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2583 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2584 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2585 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2586 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2587 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2588 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2589 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2590 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2591 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2592 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2593 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2594 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2595 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2596 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2597 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2598 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2599 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2600 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2601 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2602 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2603 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2604 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2605 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2606 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2607 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2608 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2609 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2610 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2611 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2612 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2613 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2614 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2615 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2616 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2617 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2618 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2619 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2620 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2621 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2622 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2623 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2624 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2625 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2626 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2627 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2628 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2629 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2630 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2631 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2632 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2633 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2634 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2635 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2636 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2637 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2638 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2639 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2640 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2641 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2642 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2643 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2644 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2645 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2646 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2647 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2648 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2649 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2650 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2651 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2652 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2653 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2654 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2655 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2656 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2657 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2658 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2659 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2660 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2661 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2662 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2663 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2664 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2665 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2666 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2667 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2668 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2669 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2670 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2671 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2672 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2673 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2674 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2675 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2676 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2677 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2678 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2679 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2680 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2681 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2682 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2683 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2684 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2685 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2686 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2687 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2688 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2689 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2690 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2691 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2692 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2693 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2694 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2695 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2696 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2697 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2698 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2699 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2700 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2701 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2702 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2703 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2704 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2705 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2706 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2707 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2708 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2709 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2710 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2711 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2712 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2713 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2714 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2715 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2716 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2717 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2718 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2719 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2720 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2721 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2722 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2723 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2724 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2725 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2726 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2727 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2728 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2729 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2730 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2731 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2732 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2733 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2734 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2735 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2736 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2737 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2738 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2739 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2740 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2741 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2742 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2743 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2744 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2745 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2746 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2747 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2748 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2749 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2750 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2751 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2752 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2753 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2754 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2755 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2756 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2757 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2758 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2759 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2760 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2761 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2762 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2763 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2764 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2765 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2766 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2767 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2768 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2769 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2770 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2771 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2772 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2773 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2774 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2775 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2776 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2777 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2778 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2779 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2780 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2781 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2782 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2783 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2784 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2785 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2786 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2787 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2788 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2789 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2790 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2791 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2792 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2793 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2794 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2795 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2796 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2797 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2798 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2799 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2800 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2801 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2802 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2803 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2804 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2805 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2806 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2807 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2808 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2809 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2810 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2811 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2812 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2813 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2814 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2815 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2816 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2817 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2818 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2819 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2820 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2821 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2822 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2823 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2824 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2825 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2826 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2827 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2828 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2829 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2830 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2831 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2832 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2833 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2834 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2835 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2836 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2837 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2838 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2839 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2840 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2841 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2842 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2843 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2844 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2845 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2846 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2847 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2848 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2849 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2850 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2851 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2852 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2853 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2854 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2855 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2856 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2857 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2858 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2859 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2860 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2861 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2862 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2863 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2864 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2865 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2866 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2867 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2868 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2869 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2870 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2871 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2872 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2873 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2874 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2875 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2876 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2877 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2878 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2879 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2880 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2881 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2882 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2883 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2884 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2885 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2886 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2887 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2888 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2889 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2890 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2891 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2892 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2893 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2894 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2895 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2896 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2897 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2898 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2899 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2900 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2901 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2902 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2903 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2904 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2905 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2906 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2907 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2908 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2909 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2910 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2911 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2912 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2913 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2914 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2915 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2916 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2917 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2918 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2919 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2920 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2921 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2922 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2923 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2924 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2925 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2926 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2927 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2928 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2929 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2930 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2931 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2932 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2933 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2934 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2935 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2936 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2937 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2938 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2939 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2940 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2941 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2942 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2943 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2944 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2945 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2946 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2947 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2948 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2949 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2950 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2951 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2952 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2953 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2954 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2955 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2956 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2957 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2958 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2959 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2960 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2961 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2962 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2963 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2964 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2965 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2966 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2967 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2968 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2969 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2970 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2971 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2972 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2973 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2974 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2975 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2976 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2977 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2978 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2979 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2980 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2981 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2982 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
2983 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
2984 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2985 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2986 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2987 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2988 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
2989 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
2990 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2991 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
2992 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
2993 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
2994 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
2995 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
2996 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2997 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
2998 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
2999 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3000 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3001 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3002 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3003 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3004 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3005 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3006 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3007 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3008 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3009 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3010 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3011 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3012 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3013 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3014 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3015 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3016 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3017 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3018 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3019 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3020 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3021 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3022 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3023 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3024 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3025 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3026 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3027 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3028 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3029 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3030 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3031 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3032 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3033 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3034 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3035 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3036 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3037 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3038 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3039 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3040 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3041 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3042 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3043 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3044 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3045 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3046 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3047 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3048 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3049 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3050 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3051 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3052 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3053 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3054 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3055 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3056 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3057 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3058 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3059 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3060 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3061 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3062 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3063 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3064 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3065 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3066 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3067 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3068 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3069 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3070 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3071 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3072 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3073 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3074 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3075 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3076 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3077 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3078 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3079 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3080 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3081 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3082 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3083 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3084 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3085 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3086 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3087 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3088 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3089 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3090 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3091 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3092 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3093 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3094 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3095 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3096 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3097 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3098 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3099 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3100 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3101 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3102 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3103 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3104 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3105 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3106 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3107 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3108 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3109 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3110 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3111 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3112 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3113 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3114 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3115 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3116 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3117 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3118 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3119 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3120 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3121 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3122 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3123 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3124 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3125 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3126 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3127 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3128 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3129 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3130 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3131 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3132 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3133 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3134 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3135 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3136 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3137 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3138 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3139 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3140 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3141 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3142 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3143 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3144 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3145 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3146 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3147 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3148 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3149 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3150 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3151 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3152 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3153 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3154 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3155 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3156 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3157 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3158 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3159 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3160 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3161 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3162 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3163 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3164 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3165 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3166 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3167 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3168 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3169 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3170 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3171 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3172 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3173 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3174 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3175 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3176 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3177 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3178 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3179 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3180 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3181 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3182 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3183 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3184 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3185 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3186 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3187 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3188 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3189 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3190 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3191 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3192 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3193 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3194 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3195 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3196 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3197 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3198 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3199 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3200 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3201 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3202 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3203 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3204 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3205 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3206 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3207 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3208 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3209 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3210 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3211 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3212 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3213 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3214 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3215 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3216 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3217 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3218 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3219 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3220 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3221 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3222 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3223 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3224 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3225 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3226 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3227 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3228 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3229 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3230 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3231 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3232 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3233 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3234 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3235 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3236 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3237 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3238 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3239 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3240 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3241 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3242 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3243 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3244 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3245 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3246 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3247 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3248 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3249 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3250 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3251 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3252 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3253 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3254 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3255 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3256 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3257 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3258 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3259 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3260 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3261 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3262 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3263 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3264 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3265 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3266 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3267 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3268 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3269 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3270 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3271 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3272 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3273 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3274 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3275 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3276 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3277 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3278 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3279 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3280 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3281 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3282 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3283 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3284 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3285 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3286 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3287 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3288 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3289 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3290 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3291 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3292 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3293 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3294 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3295 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3296 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3297 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3298 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3299 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3300 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3301 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3302 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3303 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3304 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3305 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3306 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3307 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3308 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3309 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3310 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3311 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3312 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3313 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3314 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3315 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3316 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3317 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3318 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3319 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3320 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3321 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3322 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3323 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3324 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3325 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3326 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3327 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3328 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3329 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3330 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3331 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3332 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3333 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3334 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3335 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3336 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3337 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3338 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3339 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3340 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3341 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3342 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3343 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3344 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3345 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3346 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3347 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3348 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3349 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3350 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3351 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3352 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3353 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3354 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3355 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3356 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3357 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3358 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3359 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3360 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3361 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3362 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3363 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3364 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3365 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3366 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3367 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3368 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3369 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3370 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3371 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3372 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3373 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3374 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3375 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3376 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3377 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3378 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3379 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3380 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3381 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3382 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3383 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3384 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3385 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3386 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3387 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3388 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3389 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3390 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3391 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3392 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3393 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3394 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3395 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3396 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3397 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3398 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3399 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3400 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3401 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3402 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3403 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3404 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3405 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3406 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3407 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3408 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3409 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3410 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3411 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3412 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3413 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3414 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3415 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3416 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3417 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3418 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3419 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3420 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3421 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3422 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3423 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3424 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3425 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3426 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3427 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3428 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3429 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3430 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3431 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3432 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3433 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3434 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3435 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3436 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3437 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3438 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3439 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3440 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3441 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3442 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3443 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3444 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3445 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3446 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3447 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3448 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3449 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3450 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3451 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3452 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3453 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3454 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3455 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3456 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3457 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3458 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3459 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3460 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3461 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3462 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3463 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3464 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3465 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3466 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3467 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3468 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3469 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3470 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3471 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3472 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3473 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3474 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3475 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3476 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3477 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3478 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3479 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3480 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3481 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3482 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3483 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3484 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3485 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3486 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3487 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3488 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3489 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3490 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3491 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3492 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3493 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3494 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3495 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3496 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3497 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3498 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3499 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3500 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3501 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3502 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3503 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3504 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3505 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3506 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3507 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3508 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3509 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3510 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3511 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3512 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3513 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3514 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3515 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3516 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3517 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3518 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3519 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3520 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3521 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3522 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3523 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3524 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3525 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3526 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3527 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3528 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3529 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3530 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3531 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3532 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3533 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3534 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3535 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3536 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3537 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3538 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3539 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3540 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3541 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3542 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3543 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3544 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3545 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3546 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3547 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3548 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3549 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3550 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3551 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3552 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3553 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3554 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3555 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3556 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3557 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3558 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3559 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3560 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3561 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3562 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3563 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3564 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3565 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3566 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3567 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3568 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3569 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3570 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3571 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3572 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3573 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3574 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3575 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3576 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3577 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3578 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3579 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3580 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3581 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3582 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3583 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3584 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3585 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3586 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3587 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3588 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3589 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3590 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3591 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3592 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3593 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3594 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3595 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3596 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3597 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3598 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3599 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3600 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3601 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3602 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3603 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3604 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3605 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3606 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3607 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3608 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3609 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3610 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3611 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3612 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3613 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3614 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3615 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3616 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3617 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3618 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3619 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3620 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3621 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3622 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3623 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3624 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3625 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3626 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3627 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3628 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3629 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3630 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3631 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3632 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3633 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3634 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3635 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3636 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3637 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3638 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3639 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3640 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3641 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3642 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3643 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3644 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3645 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3646 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3647 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3648 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3649 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3650 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3651 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3652 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3653 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3654 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3655 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3656 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3657 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3658 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3659 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3660 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3661 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3662 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3663 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3664 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3665 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3666 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3667 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3668 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3669 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3670 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3671 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3672 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3673 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3674 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3675 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3676 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3677 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3678 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3679 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3680 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3681 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3682 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3683 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3684 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3685 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3686 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3687 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3688 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3689 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3690 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3691 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3692 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3693 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3694 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3695 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3696 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3697 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3698 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3699 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3700 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3701 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3702 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3703 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3704 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3705 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3706 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3707 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3708 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3709 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3710 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3711 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3712 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3713 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3714 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3715 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3716 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3717 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3718 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3719 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3720 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3721 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3722 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3723 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3724 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3725 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3726 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3727 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3728 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3729 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3730 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3731 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3732 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3733 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3734 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3735 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3736 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3737 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3738 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3739 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3740 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3741 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3742 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3743 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3744 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3745 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3746 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3747 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3748 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3749 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3750 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3751 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3752 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3753 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3754 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3755 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3756 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3757 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3758 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3759 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3760 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3761 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3762 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3763 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3764 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3765 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3766 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3767 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3768 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3769 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3770 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3771 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3772 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3773 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3774 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3775 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3776 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3777 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3778 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3779 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3780 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3781 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3782 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3783 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3784 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3785 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3786 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3787 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3788 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3789 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3790 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3791 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3792 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3793 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3794 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3795 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3796 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3797 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3798 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3799 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3800 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3801 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3802 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3803 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3804 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3805 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3806 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3807 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3808 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3809 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3810 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3811 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3812 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3813 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3814 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3815 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3816 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3817 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3818 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3819 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3820 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3821 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3822 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3823 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3824 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3825 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3826 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3827 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3828 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3829 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3830 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3831 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3832 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3833 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3834 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3835 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3836 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3837 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3838 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3839 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3840 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3841 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3842 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3843 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3844 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3845 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3846 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3847 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3848 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3849 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3850 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3851 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3852 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3853 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3854 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3855 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3856 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3857 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3858 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3859 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3860 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3861 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3862 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3863 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3864 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3865 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3866 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3867 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3868 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3869 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3870 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3871 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3872 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3873 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3874 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3875 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3876 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3877 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3878 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3879 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3880 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3881 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3882 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3883 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3884 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3885 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3886 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3887 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3888 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3889 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3890 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3891 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3892 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3893 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3894 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3895 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3896 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3897 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3898 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3899 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3900 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3901 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3902 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3903 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3904 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3905 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3906 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3907 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3908 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3909 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3910 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3911 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3912 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3913 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3914 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3915 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3916 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3917 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3918 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3919 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3920 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3921 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3922 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3923 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3924 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3925 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3926 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3927 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3928 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3929 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3930 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3931 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3932 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3933 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3934 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3935 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3936 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3937 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3938 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3939 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3940 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3941 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3942 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3943 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3944 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3945 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3946 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3947 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3948 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3949 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3950 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3951 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3952 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3953 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3954 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3955 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3956 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3957 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3958 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3959 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3960 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3961 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3962 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3963 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3964 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3965 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3966 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3967 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3968 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3969 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3970 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3971 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3972 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3973 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3974 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3975 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3976 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3977 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3978 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3979 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3980 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3981 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3982 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
3983 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3984 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
3985 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
3986 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3987 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
3988 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
3989 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3990 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
3991 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
3992 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3993 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3994 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
3995 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3996 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
3997 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
3998 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
3999 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4000 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4001 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4002 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4003 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4004 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4005 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4006 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4007 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4008 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4009 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4010 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4011 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4012 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4013 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4014 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4015 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4016 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4017 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4018 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4019 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4020 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4021 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4022 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4023 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4024 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4025 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4026 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4027 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4028 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4029 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4030 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4031 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4032 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4033 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4034 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4035 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4036 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4037 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4038 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4039 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4040 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4041 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4042 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4043 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4044 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4045 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4046 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4047 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4048 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4049 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4050 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4051 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4052 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4053 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4054 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4055 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4056 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4057 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4058 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4059 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4060 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4061 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4062 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4063 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4064 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4065 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4066 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4067 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4068 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4069 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4070 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4071 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4072 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4073 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4074 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4075 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4076 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4077 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4078 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4079 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4080 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4081 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4082 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4083 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4084 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4085 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4086 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4087 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4088 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4089 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4090 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4091 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4092 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4093 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4094 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4095 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4096 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4097 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4098 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4099 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4100 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4101 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4102 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4103 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4104 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4105 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4106 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4107 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4108 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4109 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4110 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4111 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4112 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4113 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4114 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4115 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4116 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4117 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4118 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4119 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4120 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4121 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4122 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4123 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4124 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4125 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4126 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4127 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4128 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4129 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4130 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4131 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4132 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4133 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4134 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4135 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4136 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4137 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4138 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4139 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4140 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4141 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4142 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4143 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4144 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4145 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4146 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4147 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4148 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4149 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4150 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4151 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4152 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4153 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4154 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4155 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4156 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4157 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4158 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4159 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4160 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4161 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4162 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4163 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4164 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4165 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4166 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4167 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4168 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4169 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4170 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4171 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4172 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4173 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4174 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4175 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4176 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4177 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4178 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4179 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4180 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4181 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4182 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4183 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4184 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4185 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4186 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4187 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4188 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4189 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4190 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4191 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4192 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4193 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4194 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4195 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4196 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4197 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4198 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4199 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4200 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4201 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4202 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4203 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4204 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4205 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4206 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4207 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4208 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4209 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4210 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4211 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4212 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4213 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4214 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4215 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4216 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4217 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4218 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4219 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4220 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4221 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4222 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4223 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4224 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4225 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4226 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4227 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4228 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4229 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4230 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4231 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4232 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4233 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4234 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4235 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4236 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4237 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4238 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4239 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4240 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4241 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4242 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4243 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4244 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4245 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4246 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4247 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4248 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4249 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4250 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4251 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4252 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4253 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4254 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4255 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4256 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4257 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4258 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4259 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4260 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4261 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4262 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4263 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4264 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4265 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4266 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4267 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4268 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4269 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4270 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4271 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4272 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4273 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4274 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4275 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4276 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4277 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4278 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4279 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4280 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4281 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4282 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4283 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4284 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4285 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4286 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4287 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4288 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4289 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4290 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4291 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4292 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4293 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4294 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4295 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4296 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4297 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4298 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4299 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4300 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4301 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4302 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4303 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4304 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4305 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4306 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4307 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4308 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4309 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4310 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4311 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4312 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4313 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4314 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4315 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4316 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4317 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4318 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4319 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4320 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4321 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4322 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4323 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4324 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4325 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4326 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4327 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4328 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4329 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4330 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4331 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4332 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4333 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4334 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4335 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4336 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4337 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4338 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4339 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4340 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4341 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4342 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4343 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4344 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4345 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4346 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4347 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4348 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4349 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4350 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4351 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4352 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4353 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4354 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4355 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4356 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4357 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4358 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4359 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4360 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4361 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4362 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4363 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4364 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4365 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4366 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4367 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4368 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4369 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4370 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4371 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4372 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4373 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4374 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4375 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4376 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4377 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4378 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4379 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4380 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4381 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4382 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4383 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4384 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4385 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4386 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4387 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4388 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4389 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4390 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4391 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4392 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4393 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4394 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4395 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4396 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4397 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4398 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4399 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4400 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4401 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4402 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4403 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4404 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4405 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4406 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4407 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4408 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4409 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4410 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4411 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4412 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4413 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4414 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4415 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4416 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4417 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4418 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4419 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4420 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4421 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4422 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4423 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4424 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4425 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4426 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4427 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4428 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4429 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4430 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4431 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4432 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4433 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4434 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4435 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4436 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4437 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4438 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4439 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4440 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4441 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4442 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4443 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4444 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4445 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4446 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4447 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4448 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4449 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4450 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4451 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4452 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4453 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4454 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4455 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4456 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4457 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4458 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4459 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4460 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4461 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4462 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4463 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4464 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4465 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4466 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4467 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4468 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4469 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4470 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4471 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4472 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4473 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4474 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4475 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4476 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4477 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4478 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4479 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4480 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4481 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4482 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4483 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4484 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4485 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4486 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4487 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4488 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4489 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4490 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4491 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4492 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4493 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4494 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4495 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4496 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4497 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4498 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4499 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4500 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4501 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4502 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4503 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4504 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4505 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4506 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4507 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4508 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4509 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4510 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4511 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4512 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4513 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4514 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4515 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4516 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4517 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4518 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4519 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4520 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4521 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4522 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4523 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4524 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4525 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4526 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4527 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4528 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4529 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4530 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4531 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4532 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4533 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4534 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4535 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4536 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4537 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4538 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4539 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4540 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4541 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4542 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4543 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4544 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4545 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4546 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4547 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4548 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4549 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4550 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4551 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4552 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4553 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4554 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4555 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4556 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4557 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4558 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4559 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4560 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4561 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4562 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4563 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4564 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4565 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4566 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4567 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4568 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4569 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4570 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4571 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4572 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4573 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4574 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4575 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4576 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4577 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4578 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4579 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4580 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4581 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4582 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4583 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4584 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4585 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4586 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4587 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4588 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4589 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4590 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4591 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4592 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4593 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4594 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4595 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4596 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4597 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4598 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4599 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4600 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4601 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4602 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4603 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4604 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4605 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4606 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4607 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4608 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4609 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4610 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4611 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4612 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4613 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4614 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4615 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4616 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4617 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4618 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4619 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4620 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4621 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4622 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4623 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4624 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4625 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4626 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4627 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4628 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4629 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4630 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4631 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4632 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4633 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4634 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4635 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4636 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4637 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4638 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4639 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4640 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4641 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4642 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4643 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4644 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4645 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4646 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4647 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4648 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4649 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4650 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4651 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4652 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4653 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4654 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4655 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4656 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4657 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4658 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4659 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4660 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4661 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4662 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4663 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4664 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4665 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4666 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4667 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4668 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4669 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4670 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4671 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4672 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4673 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4674 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4675 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4676 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4677 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4678 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4679 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4680 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4681 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4682 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4683 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4684 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4685 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4686 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4687 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4688 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4689 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4690 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4691 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4692 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4693 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4694 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4695 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4696 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4697 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4698 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4699 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4700 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4701 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4702 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4703 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4704 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4705 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4706 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4707 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4708 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4709 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4710 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4711 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4712 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4713 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4714 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4715 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4716 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4717 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4718 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4719 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4720 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4721 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4722 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4723 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4724 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4725 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4726 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4727 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4728 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4729 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4730 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4731 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4732 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4733 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4734 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4735 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4736 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4737 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4738 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4739 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4740 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4741 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4742 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4743 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4744 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4745 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4746 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4747 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4748 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4749 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4750 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4751 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4752 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4753 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4754 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4755 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4756 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4757 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4758 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4759 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4760 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4761 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4762 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4763 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4764 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4765 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4766 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4767 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4768 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4769 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4770 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4771 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4772 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4773 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4774 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4775 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4776 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4777 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4778 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4779 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4780 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4781 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4782 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4783 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4784 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4785 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4786 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4787 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4788 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4789 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4790 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4791 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4792 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4793 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4794 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4795 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4796 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4797 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4798 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4799 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4800 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4801 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4802 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4803 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4804 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4805 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4806 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4807 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4808 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4809 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4810 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4811 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4812 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4813 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4814 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4815 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4816 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4817 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4818 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4819 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4820 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4821 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4822 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4823 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4824 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4825 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4826 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4827 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4828 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4829 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4830 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4831 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4832 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4833 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4834 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4835 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4836 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4837 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4838 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4839 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4840 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4841 br@0x4e1c4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4842 br@0x4ce94 -> 0x4dc54 secondary/unknown target ; no VM word read before next BR
4843 br@0x4dcd0 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4844 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4845 br@0x4ce94 -> 0x4e0bc secondary/unknown target ; no VM word read before next BR
4846 br@0x4e1c4 -> 0x55908 secondary/unknown target ; no VM word read before next BR
4847 br@0x55a74 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4848 br@0x4ce94 -> 0x4f728 secondary/unknown target ; no VM word read before next BR
4849 br@0x4f82c -> 0x56b00 BITFIELD/op10 (primary op10 handler) ; no VM word read before next BR
4850 br@0x56c4c -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4851 br@0x52db8 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4852 br@0x52af4 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4853 br@0x52db8 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4854 br@0x4ce94 -> 0x4f1c0 secondary/unknown target ; no VM word read before next BR
4855 br@0x4f238 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
4856 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4857 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4858 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4859 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4860 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4861 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4862 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4863 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4864 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4865 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4866 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4867 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4868 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4869 br@0x4f914 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
4870 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
4871 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4872 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
4873 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4874 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4875 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4876 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4877 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4878 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4879 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4880 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4881 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4882 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4883 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4884 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4885 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4886 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4887 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4888 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4889 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4890 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4891 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4892 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4893 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4894 br@0x4f914 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
4895 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
4896 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4897 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
4898 br@0x56f50 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
4899 br@0x53d38 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4900 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4901 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4902 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4903 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4904 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4905 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4906 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4907 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4908 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4909 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4910 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4911 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4912 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4913 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4914 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4915 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4916 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4917 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4918 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4919 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4920 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4921 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4922 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4923 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4924 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4925 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4926 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4927 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4928 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4929 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4930 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4931 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4932 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4933 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4934 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4935 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4936 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4937 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4938 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4939 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4940 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4941 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4942 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4943 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4944 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4945 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4946 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4947 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
4948 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
4949 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
4950 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
4951 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4952 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
4953 br@0x55858 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
4954 br@0x53d38 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
4955 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4956 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4957 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4958 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4959 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4960 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4961 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4962 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4963 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4964 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4965 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4966 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
4967 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4968 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4969 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4970 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4971 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4972 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4973 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4974 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4975 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4976 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4977 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4978 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4979 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4980 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4981 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4982 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4983 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4984 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4985 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4986 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4987 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4988 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
4989 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
4990 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4991 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
4992 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4993 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
4994 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4995 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4996 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4997 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
4998 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
4999 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5000 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5001 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5002 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5003 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5004 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5005 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5006 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5007 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5008 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5009 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5010 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5011 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5012 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5013 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5014 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5015 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5016 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5017 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5018 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5019 br@0x55858 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5020 br@0x53d38 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5021 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5022 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5023 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5024 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5025 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5026 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5027 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5028 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5029 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5030 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5031 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5032 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5033 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5034 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5035 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5036 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5037 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5038 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5039 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5040 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5041 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5042 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5043 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5044 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5045 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5046 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5047 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5048 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5049 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5050 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5051 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5052 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5053 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5054 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5055 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5056 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5057 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5058 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5059 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5060 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5061 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5062 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5063 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5064 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5065 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5066 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5067 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5068 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5069 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5070 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5071 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5072 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5073 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5074 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5075 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5076 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5077 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5078 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5079 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5080 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5081 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5082 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5083 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5084 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5085 br@0x55858 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5086 br@0x53d38 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5087 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5088 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5089 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5090 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5091 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5092 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5093 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5094 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5095 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5096 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5097 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5098 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5099 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5100 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5101 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5102 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5103 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5104 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5105 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5106 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5107 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5108 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5109 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5110 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5111 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5112 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5113 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5114 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5115 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5116 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5117 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5118 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5119 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5120 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5121 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5122 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5123 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5124 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5125 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5126 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5127 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5128 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5129 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5130 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5131 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5132 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5133 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5134 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5135 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5136 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5137 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5138 br@0x56f50 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5139 br@0x53d38 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5140 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5141 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5142 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5143 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5144 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5145 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5146 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5147 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5148 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5149 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5150 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5151 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5152 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5153 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5154 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5155 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5156 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5157 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5158 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5159 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5160 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5161 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5162 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5163 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5164 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5165 br@0x56f50 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5166 br@0x53d38 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5167 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5168 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5169 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5170 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5171 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5172 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5173 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5174 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5175 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5176 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5177 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5178 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5179 br@0x55858 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5180 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5181 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5182 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5183 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5184 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5185 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5186 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5187 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5188 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5189 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5190 br@0x116f08 -> 0x116f0c secondary/unknown target ; no VM word read before next BR
5191 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5192 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5193 br@0x116f08 -> 0x116f0c secondary/unknown target ; no VM word read before next BR
5194 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5195 br@0x116f08 -> 0x116f0c secondary/unknown target ; no VM word read before next BR
5196 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5197 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5198 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5199 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5200 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5201 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5202 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5203 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5204 br@0x116f08 -> 0x116f34 secondary/unknown target ; no VM word read before next BR
5205 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5206 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5207 br@0x53f7c -> 0x531e4 OP34/op34 (primary op34 handler) ; no VM word read before next BR
5208 br@0x53328 -> 0x5332c LD16U/op30 (primary op30 handler) ; no VM word read before next BR
5209 br@0x53408 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5210 br@0x55858 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5211 br@0x53f7c -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
5212 br@0x54224 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5213 br@0x56290 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5214 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5215 br@0x52db8 -> 0x54020 ST16/op14 (primary op14 handler) ; no VM word read before next BR
5216 br@0x54224 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5217 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5218 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5219 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5220 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5221 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5222 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5223 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5224 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5225 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5226 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5227 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5228 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5229 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5230 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5231 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5232 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5233 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5234 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5235 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5236 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5237 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5238 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5239 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5240 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5241 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5242 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5243 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5244 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5245 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5246 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5247 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5248 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5249 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5250 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5251 br@0x52af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5252 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5253 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5254 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5255 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5256 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5257 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5258 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5259 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5260 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5261 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5262 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5263 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5264 br@0x54af4 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5265 br@0x56f50 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5266 br@0x56290 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5267 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5268 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5269 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5270 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5271 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5272 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5273 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5274 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5275 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5276 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5277 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5278 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5279 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5280 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5281 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5282 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5283 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5284 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5285 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5286 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5287 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5288 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5289 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5290 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5291 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5292 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5293 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5294 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5295 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5296 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5297 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5298 br@0x56f50 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5299 br@0x53d38 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5300 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5301 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5302 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5303 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5304 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5305 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5306 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5307 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5308 br@0x4f914 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5309 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5310 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5311 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5312 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5313 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5314 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5315 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5316 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5317 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5318 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5319 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5320 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5321 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5322 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5323 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5324 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5325 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5326 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5327 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5328 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5329 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5330 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5331 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5332 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5333 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5334 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5335 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5336 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5337 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5338 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5339 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5340 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5341 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5342 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5343 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5344 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5345 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5346 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5347 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5348 br@0x56f50 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5349 br@0x54af4 -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5350 br@0x55858 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5351 br@0x53d38 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5352 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5353 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5354 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5355 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5356 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5357 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5358 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5359 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5360 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5361 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5362 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5363 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5364 br@0x53f7c -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5365 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5366 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5367 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5368 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5369 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5370 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5371 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5372 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5373 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5374 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5375 br@0x4f914 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5376 br@0x56290 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5377 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5378 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5379 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5380 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5381 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5382 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5383 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5384 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5385 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5386 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5387 br@0x4f914 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5388 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5389 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5390 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5391 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5392 br@0x56290 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5393 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5394 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5395 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5396 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5397 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5398 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5399 br@0x54af4 -> 0x53db0 BR_COND/op2d (primary op2d handler) ; no VM word read before next BR
5400 br@0x53f7c -> 0x55714 OP01/op01 (primary op01 handler) ; no VM word read before next BR
5401 br@0x55858 -> 0x52d04 ST64/op3b (primary op3b handler) ; no VM word read before next BR
5402 br@0x52db8 -> 0x56e70 ST32_UNALIGNED_R/op16 (primary op16 handler) ; no VM word read before next BR
5403 br@0x56f50 -> 0x53b68 secondary/unknown target ; no VM word read before next BR
5404 br@0x53d38 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5405 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5406 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5407 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5408 br@0x52af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5409 br@0x54af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5410 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5411 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5412 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5413 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5414 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5415 br@0x54af4 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5416 br@0x56290 -> 0x561b4 BR_COND/op1a (primary op1a handler) ; no VM word read before next BR
5417 br@0x56290 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5418 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5419 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5420 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5421 br@0x4ce94 -> 0x4f500 secondary/unknown target ; no VM word read before next BR
5422 br@0x4f608 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5423 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
5424 br@0x4f914 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5425 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5426 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5427 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5428 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5429 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5430 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5431 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5432 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5433 br@0x54af4 -> 0x54a1c OP18/op18 (primary op18 handler) ; no VM word read before next BR
5434 br@0x54af4 -> 0x52984 BR_COND/op0f (primary op0f handler) ; no VM word read before next BR
5435 br@0x52af4 -> 0x4ce54 CALL_IMM_LINK31/op11 (primary op11 handler) ; no VM word read before next BR
5436 br@0x4ce94 -> 0x4f860 secondary/unknown target ; no VM word read before next BR


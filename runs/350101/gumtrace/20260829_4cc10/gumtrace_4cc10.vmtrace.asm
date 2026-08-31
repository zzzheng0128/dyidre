# metasec VM trace decoder
# image_base: 0x7105474000
# vm_pages: 0x7105660000
# native_rows: 20121
# vm_word_reads_raw: 484
# vm_word_reads_stream: 242
# br_x8_dispatches: 371

# opcode histogram from stream view:
#   op 0x01:    3  OP01            unknown/no-op-ish in current reconstruction
#   op 0x0b:    2  MUL_OR_ALU_SUB  multiply/ALU subfamily; needs subdecode
#   op 0x0d:    1  LD64_UNALIGNED  unaligned 64-bit load/merge style
#   op 0x0f:   21  ATOMIC_EX       atomic/exclusive/cmpxchg-like family
#   op 0x10:    4  LD16S           int16 load/sign-extend style
#   op 0x11:   53  LD32S           int32 load/sign-extend style
#   op 0x13:    3  OP13            unknown/no-op-ish in current reconstruction
#   op 0x14:    7  BR_COND         conditional VM branch / VM-PC control
#   op 0x16:    4  OP16            unknown/no-op-ish in current reconstruction
#   op 0x18:   62  OR_IMM          register OR immediate-style op
#   op 0x1a:   43  CONV            integer/float conversion family
#   op 0x2d:    2  AND_IMM         register AND immediate-style op
#   op 0x2e:    2  LD32_UNALIGNED  unaligned 32-bit load/merge style
#   op 0x30:   12  ST64            64-bit store *(addr)=reg style
#   op 0x34:   13  OP34            unknown/no-op-ish in current reconstruction
#   op 0x3b:    7  OP3B            unknown/no-op-ish in current reconstruction
#   op 0x3e:    3  LD8U            uint8 load/zero-extend style

# top BR X8 targets:
#   0x54a1c:   62  OR_IMM/op18 (primary op18 handler)
#   0x4ce54:   53  LD32S/op11 (primary op11 handler)
#   0x561b4:   43  CONV/op1a (primary op1a handler)
#   0x12be58:   22  secondary/unknown target
#   0x52984:   21  ATOMIC_EX/op0f (primary op0f handler)
#   0x12bed8:   21  secondary/unknown target
#   0x12bf28:   21  secondary/unknown target
#   0x4f500:   20  secondary/unknown target
#   0x4e0bc:   19  secondary/unknown target
#   0x531e4:   13  OP34/op34 (primary op34 handler)
#   0x5332c:   12  ST64/op30 (primary op30 handler)
#   0x54020:    7  BR_COND/op14 (primary op14 handler)
#   0x4f830:    7  secondary/unknown target
#   0x52d04:    7  OP3B/op3b (primary op3b handler)
#   0x4cf20:    6  secondary/unknown target
#   0x56b00:    4  LD16S/op10 (primary op10 handler)
#   0x56e70:    4  OP16/op16 (primary op16 handler)
#   0x55714:    3  OP01/op01 (primary op01 handler)
#   0x55d20:    3  LD8U/op3e (primary op3e handler)
#   0x55fd4:    3  OP13/op13 (primary op13 handler)
#   0x53db0:    2  AND_IMM/op2d (primary op2d handler)
#   0x565e0:    2  LD32_UNALIGNED/op2e (primary op2e handler)
#   0x5685c:    2  MUL_OR_ALU_SUB/op0b (primary op0b handler)
#   0x12b9f0:    1  secondary/unknown target
#   0x12ba40:    1  secondary/unknown target
#   0x12ba78:    1  secondary/unknown target
#   0x12bb14:    1  secondary/unknown target
#   0x12bb8c:    1  secondary/unknown target
#   0x12bbec:    1  secondary/unknown target
#   0x12bccc:    1  secondary/unknown target
#   0x12bd10:    1  secondary/unknown target
#   0x12bd38:    1  secondary/unknown target

# VM word fetch sites:
#   0x54acc:   62  0f:4, 11:9, 14:6, 16:1, 18:25, 1a:12, 2d:1, 2e:2, 34:1, 3b:1
#   0x56264:   43  0f:4, 11:8, 16:1, 18:11, 1a:18, 34:1
#   0x52ab8:   21  0f:1, 11:8, 18:1, 1a:5, 30:1, 34:1, 3b:2, 3e:2
#   0x4f5d8:   20  11:14, 18:3, 1a:2, 34:1
#   0x4e194:   19  01:1, 0f:1, 11:1, 18:12, 1a:2, 34:1, 3b:1
#   0x532f4:   13  0f:3, 11:1, 30:8, 34:1
#   0x533dc:   12  11:7, 18:1, 1a:1, 2d:1, 34:2
#   0x4f8e0:    7  0f:1, 11:2, 18:2, 30:1, 34:1
#   0x52d8c:    7  01:1, 0f:1, 18:2, 3b:3
#   0x541f4:    7  0d:1, 11:1, 1a:1, 30:1, 34:3
#   0x4cff0:    6  0f:4, 30:1, 34:1
#   0x56c18:    4  0b:2, 10:2
#   0x56f24:    4  18:2, 1a:2
#   0x5581c:    3  14:1, 16:2
#   0x55ee8:    3  10:2, 11:1
#   0x5617c:    3  13:1, 18:2
#   0x53f4c:    2  11:1, 18:1
#   0x567ec:    2  0f:1, 3e:1
#   0x56a14:    2  13:2
#   0x4cd94:    1  0f:1
#   0x536b0:    1  01:1

# stream view: unique/collapsed VM words in first-observed order
0000 vm+0x0000 pc=0x7105660670 word=0xee5b87cf op=0x0f ATOMIC_EX       fetch=0x4cd94 line=93     atomic/ex? dst=r28 src=r19 lo12=0x7cf ; atomic/exclusive/cmpxchg-like family
0001 vm+0x0004 pc=0x7105660674 word=0xa01b6f9a op=0x1a CONV            fetch=0x52ab8 line=195    convert? dst=r28 src=r1 sub6=0x3e ; integer/float conversion family
0002 vm+0x0008 pc=0x7105660678 word=0x801b6f1a op=0x1a CONV            fetch=0x56264 line=255    convert? dst=r28 src=r1 sub6=0x3c ; integer/float conversion family
0003 vm+0x000c pc=0x710566067c word=0xe01b639a op=0x1a CONV            fetch=0x56264 line=311    convert? dst=r28 src=r1 sub6=0x0e ; integer/float conversion family
0004 vm+0x0010 pc=0x7105660680 word=0xc01b631a op=0x1a CONV            fetch=0x56264 line=367    convert? dst=r28 src=r1 sub6=0x0c ; integer/float conversion family
0005 vm+0x0014 pc=0x7105660684 word=0xa01b629a op=0x1a CONV            fetch=0x56264 line=423    convert? dst=r28 src=r1 sub6=0x0a ; integer/float conversion family
0006 vm+0x0018 pc=0x7105660688 word=0x801b621a op=0x1a CONV            fetch=0x56264 line=479    convert? dst=r28 src=r1 sub6=0x08 ; integer/float conversion family
0007 vm+0x001c pc=0x710566068c word=0xe01b599a op=0x1a CONV            fetch=0x56264 line=535    convert? dst=r28 src=r1 sub6=0x26 ; integer/float conversion family
0008 vm+0x0020 pc=0x7105660690 word=0xc01b591a op=0x1a CONV            fetch=0x56264 line=591    convert? dst=r28 src=r1 sub6=0x24 ; integer/float conversion family
0009 vm+0x0024 pc=0x7105660694 word=0xa01b589a op=0x1a CONV            fetch=0x56264 line=647    convert? dst=r28 src=r1 sub6=0x22 ; integer/float conversion family
0010 vm+0x0028 pc=0x7105660698 word=0x801b581a op=0x1a CONV            fetch=0x56264 line=703    convert? dst=r28 src=r1 sub6=0x20 ; integer/float conversion family
0011 vm+0x002c pc=0x710566069c word=0x00980298 op=0x18 OR_IMM          fetch=0x56264 line=759    r25 = r5 | 0x000a ; register OR immediate-style op
0012 vm+0x0030 pc=0x71056606a0 word=0x0c1a87f4 op=0x34 OP34            fetch=0x54acc line=815    op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0013 vm+0x0034 pc=0x71056606a4 word=0x610b88f0 op=0x30 ST64            fetch=0x532f4 line=894    store64? [r9 + -0x79dd], r12 ; 64-bit store *(addr)=reg style
0014 vm+0x0038 pc=0x71056606a8 word=0xb5440391 op=0x11 LD32S           fetch=0x533dc line=952    r5 = load_i32? [r11 + +0xb4e] ; int32 load/sign-extend style
0015 vm+0x003c pc=0x71056606ac word=0x88006001 op=0x01 OP01            fetch=0x4e194 line=1035   op01? r16=r1 r21=r1 lo12=0x001 imm16=0x6880 ; unknown/no-op-ish in current reconstruction
0016 vm+0x0040 pc=0x71056606b0 word=0x00410214 op=0x14 BR_COND         fetch=0x5581c line=1114   branch_cond? delta=+0x20 src=r3 cmp=r2 ; conditional VM branch / VM-PC control
0017 vm+0x0044 pc=0x71056606b4 word=0x89c00b11 op=0x11 LD32S           fetch=0x541f4 line=1213   r1 = load_i32? [r15 + +0x8ac] ; int32 load/sign-extend style
0018 vm+0x0048 pc=0x71056606b8 word=0xc01a111a op=0x1a CONV            fetch=0x4f5d8 line=1297   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0019 vm+0x004c pc=0x71056606bc word=0xe01a121a op=0x1a CONV            fetch=0x56264 line=1354   convert? dst=r27 src=r1 sub6=0x08 ; integer/float conversion family
0020 vm+0x0050 pc=0x71056606c0 word=0x00480b18 op=0x18 OR_IMM          fetch=0x56264 line=1410   r9 = r3 | 0x002c ; register OR immediate-style op
0021 vm+0x0054 pc=0x71056606c4 word=0x801a089a op=0x1a CONV            fetch=0x54acc line=1466   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0022 vm+0x0058 pc=0x71056606c8 word=0x00500b18 op=0x18 OR_IMM          fetch=0x56264 line=1521   r17 = r3 | 0x002c ; register OR immediate-style op
0023 vm+0x005c pc=0x71056606cc word=0xe01a089a op=0x1a CONV            fetch=0x54acc line=1577   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0024 vm+0x0060 pc=0x71056606d0 word=0x00580b18 op=0x18 OR_IMM          fetch=0x56264 line=1632   r25 = r3 | 0x002c ; register OR immediate-style op
0025 vm+0x0064 pc=0x71056606d4 word=0xc01a089a op=0x1a CONV            fetch=0x54acc line=1688   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0026 vm+0x0068 pc=0x71056606d8 word=0x00500a98 op=0x18 OR_IMM          fetch=0x56264 line=1743   r17 = r3 | 0x002a ; register OR immediate-style op
0027 vm+0x006c pc=0x71056606dc word=0x801a109a op=0x1a CONV            fetch=0x54acc line=1799   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0028 vm+0x0070 pc=0x71056606e0 word=0x00480a98 op=0x18 OR_IMM          fetch=0x56264 line=1854   r9 = r3 | 0x002a ; register OR immediate-style op
0029 vm+0x0074 pc=0x71056606e4 word=0xa01a089a op=0x1a CONV            fetch=0x54acc line=1910   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0030 vm+0x0078 pc=0x71056606e8 word=0x00800ad8 op=0x18 OR_IMM          fetch=0x56264 line=1965   r1 = r5 | 0x002b ; register OR immediate-style op
0031 vm+0x007c pc=0x71056606ec word=0x00800298 op=0x18 OR_IMM          fetch=0x54acc line=2021   r1 = r5 | 0x000a ; register OR immediate-style op
0032 vm+0x0080 pc=0x71056606f0 word=0x00c802d8 op=0x18 OR_IMM          fetch=0x54acc line=2076   r9 = r7 | 0x000b ; register OR immediate-style op
0033 vm+0x0084 pc=0x71056606f4 word=0x011002d8 op=0x18 OR_IMM          fetch=0x54acc line=2131   r17 = r9 | 0x000b ; register OR immediate-style op
0034 vm+0x0088 pc=0x71056606f8 word=0x00400318 op=0x18 OR_IMM          fetch=0x54acc line=2186   r1 = r3 | 0x000c ; register OR immediate-style op
0035 vm+0x008c pc=0x71056606fc word=0x00080358 op=0x18 OR_IMM          fetch=0x54acc line=2241   r9 = r1 | 0x000d ; register OR immediate-style op
0036 vm+0x0090 pc=0x7105660700 word=0x03900358 op=0x18 OR_IMM          fetch=0x54acc line=2296   r17 = r29 | 0x000d ; register OR immediate-style op
0037 vm+0x0094 pc=0x7105660704 word=0x01d80358 op=0x18 OR_IMM          fetch=0x54acc line=2351   r25 = r15 | 0x000d ; register OR immediate-style op
0038 vm+0x0098 pc=0x7105660708 word=0x00c00b18 op=0x18 OR_IMM          fetch=0x54acc line=2406   r1 = r7 | 0x002c ; register OR immediate-style op
0039 vm+0x009c pc=0x710566070c word=0xe01a019a op=0x1a CONV            fetch=0x54acc line=2461   convert? dst=r27 src=r1 sub6=0x06 ; integer/float conversion family
0040 vm+0x00a0 pc=0x7105660710 word=0x25420391 op=0x11 LD32S           fetch=0x56264 line=2516   r3 = load_i32? [r11 + +0x24e] ; int32 load/sign-extend style
0041 vm+0x00a4 pc=0x7105660714 word=0xa01a111a op=0x1a CONV            fetch=0x4e194 line=2599   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0042 vm+0x00a8 pc=0x7105660718 word=0x0d440391 op=0x11 LD32S           fetch=0x56264 line=2656   r5 = load_i32? [r11 + +0xce] ; int32 load/sign-extend style
0043 vm+0x00ac pc=0x710566071c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=2739   r1 = r3 | 0x0002 ; register OR immediate-style op
0044 vm+0x00b0 pc=0x7105660720 word=0x907a000f op=0x0f ATOMIC_EX       fetch=0x54acc line=2796   atomic/ex? dst=r27 src=r4 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0045 vm+0x00b4 pc=0x7105660724 word=0xe01a511a op=0x1a CONV            fetch=0x52ab8 line=2884   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0046 vm+0x00b8 pc=0x7105660728 word=0xc01a509a op=0x1a CONV            fetch=0x56264 line=2944   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0047 vm+0x00bc pc=0x710566072c word=0xa95a800f op=0x0f ATOMIC_EX       fetch=0x56264 line=3000   atomic/ex? dst=r27 src=r11 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0048 vm+0x00c0 pc=0x7105660730 word=0xc9c00b11 op=0x11 LD32S           fetch=0x52ab8 line=3089   r1 = load_i32? [r15 + +0xcac] ; int32 load/sign-extend style
0049 vm+0x00c4 pc=0x7105660734 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=3176   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0050 vm+0x00c8 pc=0x7105660738 word=0x0d640391 op=0x11 LD32S           fetch=0x4f8e0 line=3404   r5 = load_i32? [r12 + +0xce] ; int32 load/sign-extend style
0051 vm+0x00cc pc=0x710566073c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=3489   r1 = r3 | 0x0002 ; register OR immediate-style op
0052 vm+0x00d0 pc=0x7105660740 word=0x81801e98 op=0x18 OR_IMM          fetch=0x54acc line=3546   r1 = r13 | 0x183a ; register OR immediate-style op
0053 vm+0x00d4 pc=0x7105660744 word=0x00480054 op=0x14 BR_COND         fetch=0x54acc line=3601   branch_cond? delta=+0x4 src=r3 cmp=r9 ; conditional VM branch / VM-PC control
0054 vm+0x0178 pc=0x71056607e8 word=0x0c1a87f4 op=0x34 OP34            fetch=0x541f4 line=3695   op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0055 vm+0x017c pc=0x71056607ec word=0x610588b0 op=0x30 ST64            fetch=0x532f4 line=3776   store64? [r9 + -0x79de], r6 ; 64-bit store *(addr)=reg style
0056 vm+0x0180 pc=0x71056607f0 word=0x140c02ed op=0x2d AND_IMM         fetch=0x533dc line=3834   r13 = r1 & 0x014b ; register AND immediate-style op
0057 vm+0x0184 pc=0x71056607f4 word=0x08a40391 op=0x11 LD32S           fetch=0x53f4c line=3928   r5 = load_i32? [r6 + +0x8e] ; int32 load/sign-extend style
0058 vm+0x0188 pc=0x71056607f8 word=0x01c000d8 op=0x18 OR_IMM          fetch=0x4e194 line=4012   r1 = r15 | 0x0003 ; register OR immediate-style op
0059 vm+0x018c pc=0x71056607fc word=0x940e022d op=0x2d AND_IMM         fetch=0x54acc line=4069   r15 = r1 & 0x0948 ; register AND immediate-style op
0060 vm+0x0190 pc=0x7105660800 word=0x80400e98 op=0x18 OR_IMM          fetch=0x53f4c line=4162   r1 = r3 | 0x083a ; register OR immediate-style op
0061 vm+0x0194 pc=0x7105660804 word=0xa5420391 op=0x11 LD32S           fetch=0x54acc line=4219   r3 = load_i32? [r11 + +0xa4e] ; int32 load/sign-extend style
0062 vm+0x0198 pc=0x7105660808 word=0x80580698 op=0x18 OR_IMM          fetch=0x4e194 line=4301   r25 = r3 | 0x081a ; register OR immediate-style op
0063 vm+0x019c pc=0x710566080c word=0x25420391 op=0x11 LD32S           fetch=0x54acc line=4358   r3 = load_i32? [r11 + +0x24e] ; int32 load/sign-extend style
0064 vm+0x01a0 pc=0x7105660810 word=0x043a87f4 op=0x34 OP34            fetch=0x4e194 line=4440   op34? r16=r27 r21=r2 lo12=0x7f4 imm16=0x805f ; unknown/no-op-ish in current reconstruction
0065 vm+0x01a4 pc=0x7105660814 word=0xe1078870 op=0x30 ST64            fetch=0x532f4 line=4521   store64? [r9 + -0x71df], r8 ; 64-bit store *(addr)=reg style
0066 vm+0x01a8 pc=0x7105660818 word=0x83880ed8 op=0x18 OR_IMM          fetch=0x533dc line=4579   r9 = r29 | 0x083b ; register OR immediate-style op
0067 vm+0x01ac pc=0x710566081c word=0x94fc0391 op=0x11 LD32S           fetch=0x54acc line=4635   r29 = load_i32? [r8 + +0x94e] ; int32 load/sign-extend style
0068 vm+0x01b0 pc=0x7105660820 word=0x80400118 op=0x18 OR_IMM          fetch=0x4e194 line=4717   r1 = r3 | 0x0804 ; register OR immediate-style op
0069 vm+0x01b4 pc=0x7105660824 word=0x00570054 op=0x14 BR_COND         fetch=0x54acc line=4774   branch_cond? delta=+0x4 src=r3 cmp=r24 ; conditional VM branch / VM-PC control
0070 vm+0x01b8 pc=0x7105660828 word=0xe2038830 op=0x30 ST64            fetch=0x541f4 line=4868   store64? [r17 + -0x71e0], r4 ; 64-bit store *(addr)=reg style
0071 vm+0x01bc pc=0x710566082c word=0xe01b021a op=0x1a CONV            fetch=0x533dc line=4925   convert? dst=r28 src=r1 sub6=0x08 ; integer/float conversion family
0072 vm+0x01c0 pc=0x7105660830 word=0xa5c00b11 op=0x11 LD32S           fetch=0x56264 line=4981   r1 = load_i32? [r15 + +0xa6c] ; int32 load/sign-extend style
0073 vm+0x01c4 pc=0x7105660834 word=0x81c816d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=5064   r9 = r15 | 0x181b ; register OR immediate-style op
0074 vm+0x01c8 pc=0x7105660838 word=0x086e0391 op=0x11 LD32S           fetch=0x54acc line=5121   r15 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0075 vm+0x01cc pc=0x710566083c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=5203   r1 = r3 | 0x0002 ; register OR immediate-style op
0076 vm+0x01d0 pc=0x7105660840 word=0x1000780f op=0x0f ATOMIC_EX       fetch=0x54acc line=5260   atomic/ex? dst=r1 src=r1 lo12=0x80f ; atomic/exclusive/cmpxchg-like family
0077 vm+0x01d4 pc=0x7105660844 word=0xe01a391a op=0x1a CONV            fetch=0x52ab8 line=5348   convert? dst=r27 src=r1 sub6=0x24 ; integer/float conversion family
0078 vm+0x01d8 pc=0x7105660848 word=0xc01a389a op=0x1a CONV            fetch=0x56264 line=5408   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0079 vm+0x01dc pc=0x710566084c word=0xa8fa800f op=0x0f ATOMIC_EX       fetch=0x56264 line=5464   atomic/ex? dst=r27 src=r8 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0080 vm+0x01e0 pc=0x7105660850 word=0x801a0b1a op=0x1a CONV            fetch=0x52ab8 line=5553   convert? dst=r27 src=r1 sub6=0x2c ; integer/float conversion family
0081 vm+0x01e4 pc=0x7105660854 word=0xcc400b11 op=0x11 LD32S           fetch=0x56264 line=5613   r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0082 vm+0x01e8 pc=0x7105660858 word=0xc01a021a op=0x1a CONV            fetch=0x4f5d8 line=5696   convert? dst=r27 src=r1 sub6=0x08 ; integer/float conversion family
0083 vm+0x01ec pc=0x710566085c word=0xc801fc91 op=0x11 LD32S           fetch=0x56264 line=5753   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0084 vm+0x01f0 pc=0x7105660860 word=0xe2039030 op=0x30 ST64            fetch=0x4f8e0 line=5868   store64? [r17 + -0x6200], r4 ; 64-bit store *(addr)=reg style
0085 vm+0x01f4 pc=0x7105660864 word=0x10022eb4 op=0x34 OP34            fetch=0x533dc line=5926   op34? r16=r3 r21=r1 lo12=0xeb4 imm16=0x213a ; unknown/no-op-ish in current reconstruction
0086 vm+0x01f8 pc=0x7105660868 word=0x1264cfcf op=0x0f ATOMIC_EX       fetch=0x532f4 line=6006   atomic/ex? dst=r5 src=r20 lo12=0xfcf ; atomic/exclusive/cmpxchg-like family
0087 vm+0x01fc pc=0x710566086c word=0x1c118974 op=0x34 OP34            fetch=0x52ab8 line=6097   op34? r16=r18 r21=r1 lo12=0x974 imm16=0x81e5 ; unknown/no-op-ish in current reconstruction
0088 vm+0x0200 pc=0x7105660870 word=0x10a205d1 op=0x11 LD32S           fetch=0x532f4 line=6181   r3 = load_i32? [r6 + +0x117] ; int32 load/sign-extend style
0089 vm+0x0204 pc=0x7105660874 word=0x7a4691b0 op=0x30 ST64            fetch=0x4cff0 line=6264   store64? [r19 + -0x687a], r7 ; 64-bit store *(addr)=reg style
0090 vm+0x0208 pc=0x7105660878 word=0x086e0391 op=0x11 LD32S           fetch=0x533dc line=6321   r15 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0091 vm+0x020c pc=0x710566087c word=0xbd000b11 op=0x11 LD32S           fetch=0x4e194 line=6404   r1 = load_i32? [r9 + +0xbec] ; int32 load/sign-extend style
0092 vm+0x0210 pc=0x7105660880 word=0x811806d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=6488   r25 = r9 | 0x081b ; register OR immediate-style op
0093 vm+0x0214 pc=0x7105660884 word=0x20fa003b op=0x3b OP3B            fetch=0x54acc line=6545   op3b? r16=r27 r21=r8 lo12=0x03b imm16=0x0200 ; unknown/no-op-ish in current reconstruction
0094 vm+0x0218 pc=0x7105660888 word=0x30e1003b op=0x3b OP3B            fetch=0x52d8c line=6590   op3b? r16=r2 r21=r8 lo12=0x03b imm16=0x0300 ; unknown/no-op-ish in current reconstruction
0095 vm+0x021c pc=0x710566088c word=0xa8da800f op=0x0f ATOMIC_EX       fetch=0x52d8c line=6636   atomic/ex? dst=r27 src=r7 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0096 vm+0x0220 pc=0x7105660890 word=0x380f003b op=0x3b OP3B            fetch=0x52ab8 line=6725   op3b? r16=r16 r21=r1 lo12=0x03b imm16=0x0380 ; unknown/no-op-ish in current reconstruction
0097 vm+0x0224 pc=0x7105660894 word=0x40fd003b op=0x3b OP3B            fetch=0x52d8c line=6775   op3b? r16=r30 r21=r8 lo12=0x03b imm16=0x0400 ; unknown/no-op-ish in current reconstruction
0098 vm+0x0228 pc=0x7105660898 word=0x82404698 op=0x18 OR_IMM          fetch=0x52d8c line=6821   r1 = r19 | 0x481a ; register OR immediate-style op
0099 vm+0x022c pc=0x710566089c word=0x2c12302e op=0x2e LD32_UNALIGNED  fetch=0x54acc line=6877   ld32_unaligned? r16=r19 r21=r1 lo12=0x02e imm16=0x32c0 ; unaligned 32-bit load/merge style
0100 vm+0x0230 pc=0x71056608a0 word=0x17045a4f op=0x0f ATOMIC_EX       fetch=0x567ec line=6990   atomic/ex? dst=r5 src=r25 lo12=0xa4f ; atomic/exclusive/cmpxchg-like family
0101 vm+0x0234 pc=0x71056608a4 word=0x10a005d1 op=0x11 LD32S           fetch=0x52ab8 line=7081   r1 = load_i32? [r6 + +0x117] ; int32 load/sign-extend style
0102 vm+0x0238 pc=0x71056608a8 word=0x1244978f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=7166   atomic/ex? dst=r5 src=r19 lo12=0x78f ; atomic/exclusive/cmpxchg-like family
0103 vm+0x023c pc=0x71056608ac word=0x1e40013e op=0x3e LD8U            fetch=0x52ab8 line=7256   r1 = load_u8? [r19 + +0x1c4] ; uint8 load/zero-extend style
0104 vm+0x0240 pc=0x71056608b0 word=0x01d20310 op=0x10 LD16S           fetch=0x55ee8 line=7356   r19 = load_i16? [r15 + +0xc] ; int16 load/sign-extend style
0105 vm+0x0244 pc=0x71056608b4 word=0x01b20210 op=0x10 LD16S           fetch=0x56c18 line=7440   r19 = load_i16? [r14 + +0x8] ; int16 load/sign-extend style
0106 vm+0x0248 pc=0x71056608b8 word=0x01920410 op=0x10 LD16S           fetch=0x56c18 line=7524   r19 = load_i16? [r13 + +0x10] ; int16 load/sign-extend style
0107 vm+0x024c pc=0x71056608bc word=0x0012418b op=0x0b MUL_OR_ALU_SUB  fetch=0x56c18 line=7608   mul_or_alu_sub? r16=r19 r21=r1 lo12=0x18b imm16=0x4006 ; multiply/ALU subfamily; needs subdecode
0108 vm+0x0250 pc=0x71056608c0 word=0x02440013 op=0x13 OP13            fetch=0x56a14 line=7704   op13? r16=r5 r21=r19 lo12=0x013 imm16=0x0000 ; unknown/no-op-ish in current reconstruction
0109 vm+0x0254 pc=0x71056608c4 word=0x00400098 op=0x18 OR_IMM          fetch=0x5617c line=7796   r1 = r3 | 0x0002 ; register OR immediate-style op
0110 vm+0x0258 pc=0x71056608c8 word=0xe01a349a op=0x1a CONV            fetch=0x54acc line=7854   convert? dst=r27 src=r1 sub6=0x12 ; integer/float conversion family
0111 vm+0x025c pc=0x71056608cc word=0x834071d6 op=0x16 OP16            fetch=0x56264 line=7909   op16? r16=r1 r21=r27 lo12=0x1d6 imm16=0x7807 ; unknown/no-op-ish in current reconstruction
0112 vm+0x0260 pc=0x71056608d0 word=0xc01a309a op=0x1a CONV            fetch=0x56f24 line=7966   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0113 vm+0x0264 pc=0x71056608d4 word=0x25000b11 op=0x11 LD32S           fetch=0x56264 line=8022   r1 = load_i32? [r9 + +0x26c] ; int32 load/sign-extend style
0114 vm+0x0268 pc=0x71056608d8 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=8105   r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0115 vm+0x026c pc=0x71056608dc word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=8189   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0116 vm+0x0270 pc=0x71056608e0 word=0x81100698 op=0x18 OR_IMM          fetch=0x4f8e0 line=9452   r17 = r9 | 0x081a ; register OR immediate-style op
0117 vm+0x0274 pc=0x71056608e4 word=0x81800e98 op=0x18 OR_IMM          fetch=0x54acc line=9510   r1 = r13 | 0x083a ; register OR immediate-style op
0118 vm+0x0278 pc=0x71056608e8 word=0x80883e98 op=0x18 OR_IMM          fetch=0x54acc line=9565   r9 = r5 | 0x383a ; register OR immediate-style op
0119 vm+0x027c pc=0x71056608ec word=0x80400118 op=0x18 OR_IMM          fetch=0x54acc line=9620   r1 = r3 | 0x0804 ; register OR immediate-style op
0120 vm+0x0280 pc=0x71056608f0 word=0x00440014 op=0x14 BR_COND         fetch=0x54acc line=9675   branch_cond? delta=+0x0 src=r3 cmp=r5 ; conditional VM branch / VM-PC control
0121 vm+0x0284 pc=0x71056608f4 word=0x0c1a87f4 op=0x34 OP34            fetch=0x541f4 line=9769   op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0122 vm+0x0288 pc=0x71056608f8 word=0x610388b0 op=0x30 ST64            fetch=0x532f4 line=9850   store64? [r9 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0123 vm+0x028c pc=0x71056608fc word=0x087c0391 op=0x11 LD32S           fetch=0x533dc line=9908   r29 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0124 vm+0x0290 pc=0x7105660900 word=0x0002011a op=0x1a CONV            fetch=0x4e194 line=9991   convert? dst=r3 src=r1 sub6=0x04 ; integer/float conversion family
0125 vm+0x0294 pc=0x7105660904 word=0x80500e98 op=0x18 OR_IMM          fetch=0x56264 line=10048  r17 = r3 | 0x083a ; register OR immediate-style op
0126 vm+0x0298 pc=0x7105660908 word=0xf5420391 op=0x11 LD32S           fetch=0x54acc line=10104  r3 = load_i32? [r11 + +0xf4e] ; int32 load/sign-extend style
0127 vm+0x029c pc=0x710566090c word=0x80580e98 op=0x18 OR_IMM          fetch=0x4e194 line=10186  r25 = r3 | 0x083a ; register OR immediate-style op
0128 vm+0x02a0 pc=0x7105660910 word=0xad420391 op=0x11 LD32S           fetch=0x54acc line=10243  r3 = load_i32? [r11 + +0xace] ; int32 load/sign-extend style
0129 vm+0x02a4 pc=0x7105660914 word=0x80400118 op=0x18 OR_IMM          fetch=0x4e194 line=10325  r1 = r3 | 0x0804 ; register OR immediate-style op
0130 vm+0x02a8 pc=0x7105660918 word=0xe01a089a op=0x1a CONV            fetch=0x54acc line=10382  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0131 vm+0x02ac pc=0x710566091c word=0x808016d8 op=0x18 OR_IMM          fetch=0x56264 line=10437  r1 = r5 | 0x181b ; register OR immediate-style op
0132 vm+0x02b0 pc=0x7105660920 word=0x0ce40391 op=0x11 LD32S           fetch=0x54acc line=10493  r5 = load_i32? [r8 + +0xce] ; int32 load/sign-extend style
0133 vm+0x02b4 pc=0x7105660924 word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=10575  r1 = r3 | 0x0002 ; register OR immediate-style op
0134 vm+0x02b8 pc=0x7105660928 word=0x005a0054 op=0x14 BR_COND         fetch=0x54acc line=10632  branch_cond? delta=+0x4 src=r3 cmp=r27 ; conditional VM branch / VM-PC control
0135 vm+0x02bc pc=0x710566092c word=0x0c1a87f4 op=0x34 OP34            fetch=0x541f4 line=10726  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0136 vm+0x02c0 pc=0x7105660930 word=0x620388b0 op=0x30 ST64            fetch=0x532f4 line=10807  store64? [r17 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0137 vm+0x02c4 pc=0x7105660934 word=0x87800b11 op=0x11 LD32S           fetch=0x533dc line=10865  r1 = load_i32? [r29 + +0x86c] ; int32 load/sign-extend style
0138 vm+0x02c8 pc=0x7105660938 word=0xf5000b11 op=0x11 LD32S           fetch=0x4f5d8 line=10948  r1 = load_i32? [r9 + +0xf6c] ; int32 load/sign-extend style
0139 vm+0x02cc pc=0x710566093c word=0x810816d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=11032  r9 = r9 | 0x181b ; register OR immediate-style op
0140 vm+0x02d0 pc=0x7105660940 word=0x08680391 op=0x11 LD32S           fetch=0x54acc line=11089  r9 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0141 vm+0x02d4 pc=0x7105660944 word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=11171  r1 = r3 | 0x0002 ; register OR immediate-style op
0142 vm+0x02d8 pc=0x7105660948 word=0x1000a80f op=0x0f ATOMIC_EX       fetch=0x54acc line=11228  atomic/ex? dst=r1 src=r1 lo12=0x80f ; atomic/exclusive/cmpxchg-like family
0143 vm+0x02dc pc=0x710566094c word=0xe01a391a op=0x1a CONV            fetch=0x52ab8 line=11316  convert? dst=r27 src=r1 sub6=0x24 ; integer/float conversion family
0144 vm+0x02e0 pc=0x7105660950 word=0xc01a389a op=0x1a CONV            fetch=0x56264 line=11376  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0145 vm+0x02e4 pc=0x7105660954 word=0xa8fa800f op=0x0f ATOMIC_EX       fetch=0x56264 line=11432  atomic/ex? dst=r27 src=r8 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0146 vm+0x02e8 pc=0x7105660958 word=0x99800b11 op=0x11 LD32S           fetch=0x52ab8 line=11521  r1 = load_i32? [r13 + +0x9ac] ; int32 load/sign-extend style
0147 vm+0x02ec pc=0x710566095c word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=11608  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0148 vm+0x02f0 pc=0x7105660960 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=11692  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0149 vm+0x02f4 pc=0x7105660964 word=0x080c3834 op=0x34 OP34            fetch=0x4f8e0 line=11808  op34? r16=r13 r21=r1 lo12=0x834 imm16=0x30a0 ; unknown/no-op-ish in current reconstruction
0150 vm+0x02f8 pc=0x7105660968 word=0x0b823a8f op=0x0f ATOMIC_EX       fetch=0x532f4 line=11890  atomic/ex? dst=r3 src=r29 lo12=0xa8f ; atomic/exclusive/cmpxchg-like family
0151 vm+0x02fc pc=0x710566096c word=0x086e05d1 op=0x11 LD32S           fetch=0x52ab8 line=11981  r15 = load_i32? [r4 + +0x97] ; int32 load/sign-extend style
0152 vm+0x0300 pc=0x7105660970 word=0x0c02fa0f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=12066  atomic/ex? dst=r3 src=r1 lo12=0xa0f ; atomic/exclusive/cmpxchg-like family
0153 vm+0x0304 pc=0x7105660974 word=0x086005d1 op=0x11 LD32S           fetch=0x52ab8 line=12156  r1 = load_i32? [r4 + +0x97] ; int32 load/sign-extend style
0154 vm+0x0308 pc=0x7105660978 word=0x1400b7f4 op=0x34 OP34            fetch=0x4cff0 line=12241  op34? r16=r1 r21=r1 lo12=0x7f4 imm16=0xb15f ; unknown/no-op-ish in current reconstruction
0155 vm+0x030c pc=0x710566097c word=0x181a04f4 op=0x34 OP34            fetch=0x532f4 line=12322  op34? r16=r27 r21=r1 lo12=0x4f4 imm16=0x0193 ; unknown/no-op-ish in current reconstruction
0156 vm+0x0310 pc=0x7105660980 word=0x1b06cf0f op=0x0f ATOMIC_EX       fetch=0x532f4 line=12404  atomic/ex? dst=r7 src=r25 lo12=0xf0f ; atomic/exclusive/cmpxchg-like family
0157 vm+0x0314 pc=0x7105660984 word=0x09c24f0f op=0x0f ATOMIC_EX       fetch=0x52ab8 line=12495  atomic/ex? dst=r3 src=r15 lo12=0xf0f ; atomic/exclusive/cmpxchg-like family
0158 vm+0x0318 pc=0x7105660988 word=0x7d84b130 op=0x30 ST64            fetch=0x52ab8 line=12588  store64? [r13 + -0x483c], r5 ; 64-bit store *(addr)=reg style
0159 vm+0x031c pc=0x710566098c word=0x241a87f4 op=0x34 OP34            fetch=0x533dc line=12648  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x825f ; unknown/no-op-ish in current reconstruction
0160 vm+0x0320 pc=0x7105660990 word=0x63099230 op=0x30 ST64            fetch=0x532f4 line=12728  store64? [r25 + -0x69f8], r10 ; 64-bit store *(addr)=reg style
0161 vm+0x0324 pc=0x7105660994 word=0x21280391 op=0x11 LD32S           fetch=0x533dc line=12786  r9 = load_i32? [r10 + +0x20e] ; int32 load/sign-extend style
0162 vm+0x0328 pc=0x7105660998 word=0xa8da800f op=0x0f ATOMIC_EX       fetch=0x4e194 line=12869  atomic/ex? dst=r27 src=r7 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0163 vm+0x032c pc=0x710566099c word=0x3015003b op=0x3b OP3B            fetch=0x52ab8 line=12959  op3b? r16=r22 r21=r1 lo12=0x03b imm16=0x0300 ; unknown/no-op-ish in current reconstruction
0164 vm+0x0330 pc=0x71056609a0 word=0x3850003b op=0x3b OP3B            fetch=0x52d8c line=13009  op3b? r16=r17 r21=r3 lo12=0x03b imm16=0x0380 ; unknown/no-op-ish in current reconstruction
0165 vm+0x0334 pc=0x71056609a4 word=0x82004698 op=0x18 OR_IMM          fetch=0x52d8c line=13055  r1 = r17 | 0x481a ; register OR immediate-style op
0166 vm+0x0338 pc=0x71056609a8 word=0x4c10202e op=0x2e LD32_UNALIGNED  fetch=0x54acc line=13111  ld32_unaligned? r16=r17 r21=r1 lo12=0x02e imm16=0x24c0 ; unaligned 32-bit load/merge style
0167 vm+0x033c pc=0x71056609ac word=0x3e0000be op=0x3e LD8U            fetch=0x567ec line=13224  r1 = load_u8? [r17 + +0x3c2] ; uint8 load/zero-extend style
0168 vm+0x0340 pc=0x71056609b0 word=0x18e205d1 op=0x11 LD32S           fetch=0x55ee8 line=13322  r3 = load_i32? [r8 + +0x197] ; int32 load/sign-extend style
0169 vm+0x0344 pc=0x71056609b4 word=0x1d26eacf op=0x0f ATOMIC_EX       fetch=0x4cff0 line=13405  atomic/ex? dst=r7 src=r10 lo12=0xacf ; atomic/exclusive/cmpxchg-like family
0170 vm+0x0348 pc=0x71056609b8 word=0x18e005d1 op=0x11 LD32S           fetch=0x52ab8 line=13495  r1 = load_i32? [r8 + +0x197] ; int32 load/sign-extend style
0171 vm+0x034c pc=0x71056609bc word=0x19866b8f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=13580  atomic/ex? dst=r7 src=r13 lo12=0xb8f ; atomic/exclusive/cmpxchg-like family
0172 vm+0x0350 pc=0x71056609c0 word=0x1e0001be op=0x3e LD8U            fetch=0x52ab8 line=13670  r1 = load_u8? [r17 + +0x1c6] ; uint8 load/zero-extend style
0173 vm+0x0354 pc=0x71056609c4 word=0x02900390 op=0x10 LD16S           fetch=0x55ee8 line=13770  r17 = load_i16? [r21 + +0xe] ; int16 load/sign-extend style
0174 vm+0x0358 pc=0x71056609c8 word=0x0010810b op=0x0b MUL_OR_ALU_SUB  fetch=0x56c18 line=13854  mul_or_alu_sub? r16=r17 r21=r1 lo12=0x10b imm16=0x8004 ; multiply/ALU subfamily; needs subdecode
0175 vm+0x035c pc=0x71056609cc word=0x22020013 op=0x13 OP13            fetch=0x56a14 line=13950  op13? r16=r3 r21=r17 lo12=0x013 imm16=0x0200 ; unknown/no-op-ish in current reconstruction
0176 vm+0x0360 pc=0x71056609d0 word=0x02060013 op=0x13 OP13            fetch=0x5617c line=14042  op13? r16=r7 r21=r17 lo12=0x013 imm16=0x0000 ; unknown/no-op-ish in current reconstruction
0177 vm+0x0364 pc=0x71056609d4 word=0x00400218 op=0x18 OR_IMM          fetch=0x5617c line=14134  r1 = r3 | 0x0008 ; register OR immediate-style op
0178 vm+0x0368 pc=0x71056609d8 word=0x834061d6 op=0x16 OP16            fetch=0x54acc line=14192  op16? r16=r1 r21=r27 lo12=0x1d6 imm16=0x6807 ; unknown/no-op-ish in current reconstruction
0179 vm+0x036c pc=0x71056609dc word=0xe01a341a op=0x1a CONV            fetch=0x56f24 line=14248  convert? dst=r27 src=r1 sub6=0x10 ; integer/float conversion family
0180 vm+0x0370 pc=0x71056609e0 word=0xc01a309a op=0x1a CONV            fetch=0x56264 line=14304  convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0181 vm+0x0374 pc=0x71056609e4 word=0x27800b11 op=0x11 LD32S           fetch=0x56264 line=14360  r1 = load_i32? [r29 + +0x26c] ; int32 load/sign-extend style
0182 vm+0x0378 pc=0x71056609e8 word=0xf4000b11 op=0x11 LD32S           fetch=0x4f5d8 line=14443  r1 = load_i32? [r1 + +0xf6c] ; int32 load/sign-extend style
0183 vm+0x037c pc=0x71056609ec word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=14527  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0184 vm+0x0380 pc=0x71056609f0 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=14611  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0185 vm+0x0384 pc=0x71056609f4 word=0x34c00b11 op=0x11 LD32S           fetch=0x4f8e0 line=16294  r1 = load_i32? [r7 + +0x36c] ; int32 load/sign-extend style
0186 vm+0x0388 pc=0x71056609f8 word=0x0c1a87f4 op=0x34 OP34            fetch=0x4f5d8 line=16379  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0187 vm+0x038c pc=0x71056609fc word=0x610388b0 op=0x30 ST64            fetch=0x532f4 line=16460  store64? [r9 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0188 vm+0x0390 pc=0x7105660a00 word=0x10640391 op=0x11 LD32S           fetch=0x533dc line=16518  r5 = load_i32? [r4 + +0x10e] ; int32 load/sign-extend style
0189 vm+0x0394 pc=0x7105660a04 word=0x80c83e98 op=0x18 OR_IMM          fetch=0x4e194 line=16601  r9 = r7 | 0x383a ; register OR immediate-style op
0190 vm+0x0398 pc=0x7105660a08 word=0x00400118 op=0x18 OR_IMM          fetch=0x54acc line=16658  r1 = r3 | 0x0004 ; register OR immediate-style op
0191 vm+0x039c pc=0x7105660a0c word=0x00410014 op=0x14 BR_COND         fetch=0x54acc line=16713  branch_cond? delta=+0x0 src=r3 cmp=r2 ; conditional VM branch / VM-PC control
0192 vm+0x03a0 pc=0x7105660a10 word=0x0004019a op=0x1a CONV            fetch=0x541f4 line=16807  convert? dst=r5 src=r1 sub6=0x06 ; integer/float conversion family
0193 vm+0x03a4 pc=0x7105660a14 word=0x0c1a87f4 op=0x34 OP34            fetch=0x56264 line=16864  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0194 vm+0x03a8 pc=0x7105660a18 word=0x610188f0 op=0x30 ST64            fetch=0x532f4 line=16944  store64? [r9 + -0x79dd], r2 ; 64-bit store *(addr)=reg style
0195 vm+0x03ac pc=0x7105660a1c word=0x0c240391 op=0x11 LD32S           fetch=0x533dc line=17002  r5 = load_i32? [r2 + +0xce] ; int32 load/sign-extend style
0196 vm+0x03b0 pc=0x7105660a20 word=0x008000d8 op=0x18 OR_IMM          fetch=0x4e194 line=17085  r1 = r5 | 0x0003 ; register OR immediate-style op
0197 vm+0x03b4 pc=0x7105660a24 word=0x00400318 op=0x18 OR_IMM          fetch=0x54acc line=17142  r1 = r3 | 0x000c ; register OR immediate-style op
0198 vm+0x03b8 pc=0x7105660a28 word=0x00583898 op=0x18 OR_IMM          fetch=0x54acc line=17197  r25 = r3 | 0x3022 ; register OR immediate-style op
0199 vm+0x03bc pc=0x7105660a2c word=0x801b339a op=0x1a CONV            fetch=0x54acc line=17252  convert? dst=r28 src=r1 sub6=0x0e ; integer/float conversion family
0200 vm+0x03c0 pc=0x7105660a30 word=0xe01a2b1a op=0x1a CONV            fetch=0x56264 line=17307  convert? dst=r27 src=r1 sub6=0x2c ; integer/float conversion family
0201 vm+0x03c4 pc=0x7105660a34 word=0xc01a289a op=0x1a CONV            fetch=0x56264 line=17363  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0202 vm+0x03c8 pc=0x7105660a38 word=0xa8ba800f op=0x0f ATOMIC_EX       fetch=0x56264 line=17419  atomic/ex? dst=r27 src=r6 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0203 vm+0x03cc pc=0x7105660a3c word=0x99800b11 op=0x11 LD32S           fetch=0x52ab8 line=17508  r1 = load_i32? [r13 + +0x9ac] ; int32 load/sign-extend style
0204 vm+0x03d0 pc=0x7105660a40 word=0x25400b11 op=0x11 LD32S           fetch=0x4f5d8 line=17595  r1 = load_i32? [r11 + +0x26c] ; int32 load/sign-extend style
0205 vm+0x03d4 pc=0x7105660a44 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=17679  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0206 vm+0x03d8 pc=0x7105660a48 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=17763  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0207 vm+0x03dc pc=0x7105660a4c word=0xa89a000f op=0x0f ATOMIC_EX       fetch=0x4f8e0 line=17864  atomic/ex? dst=r27 src=r5 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0208 vm+0x03e0 pc=0x7105660a50 word=0x80400198 op=0x18 OR_IMM          fetch=0x52ab8 line=17955  r1 = r3 | 0x0806 ; register OR immediate-style op
0209 vm+0x03e4 pc=0x7105660a54 word=0x00484098 op=0x18 OR_IMM          fetch=0x54acc line=18015  r9 = r3 | 0x4002 ; register OR immediate-style op
0210 vm+0x03e8 pc=0x7105660a58 word=0x801b291a op=0x1a CONV            fetch=0x54acc line=18070  convert? dst=r28 src=r1 sub6=0x24 ; integer/float conversion family
0211 vm+0x03ec pc=0x7105660a5c word=0x80980e98 op=0x18 OR_IMM          fetch=0x56264 line=18125  r25 = r5 | 0x083a ; register OR immediate-style op
0212 vm+0x03f0 pc=0x7105660a60 word=0xe01a211a op=0x1a CONV            fetch=0x54acc line=18181  convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0213 vm+0x03f4 pc=0x7105660a64 word=0x80883698 op=0x18 OR_IMM          fetch=0x56264 line=18236  r9 = r5 | 0x381a ; register OR immediate-style op
0214 vm+0x03f8 pc=0x7105660a68 word=0xc01a211a op=0x1a CONV            fetch=0x54acc line=18292  convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0215 vm+0x03fc pc=0x7105660a6c word=0xa01b219a op=0x1a CONV            fetch=0x56264 line=18347  convert? dst=r28 src=r1 sub6=0x06 ; integer/float conversion family
0216 vm+0x0400 pc=0x7105660a70 word=0x801a209a op=0x1a CONV            fetch=0x56264 line=18403  convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0217 vm+0x0404 pc=0x7105660a74 word=0x27800b11 op=0x11 LD32S           fetch=0x56264 line=18459  r1 = load_i32? [r29 + +0x26c] ; int32 load/sign-extend style
0218 vm+0x0408 pc=0x7105660a78 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=18542  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0219 vm+0x040c pc=0x7105660a7c word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=18626  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0220 vm+0x0410 pc=0x7105660a80 word=0x80501698 op=0x18 OR_IMM          fetch=0x4f8e0 line=18730  r17 = r3 | 0x181a ; register OR immediate-style op
0221 vm+0x0414 pc=0x7105660a84 word=0x0c020391 op=0x11 LD32S           fetch=0x54acc line=18788  r3 = load_i32? [r1 + +0xce] ; int32 load/sign-extend style
0222 vm+0x0418 pc=0x7105660a88 word=0x1800003b op=0x3b OP3B            fetch=0x4e194 line=18870  op3b? r16=r1 r21=r1 lo12=0x03b imm16=0x0180 ; unknown/no-op-ish in current reconstruction
0223 vm+0x041c pc=0x7105660a8c word=0x90a8d001 op=0x01 OP01            fetch=0x52d8c line=18917  op01? r16=r9 r21=r6 lo12=0x001 imm16=0xd900 ; unknown/no-op-ish in current reconstruction
0224 vm+0x0420 pc=0x7105660a90 word=0x00402016 op=0x16 OP16            fetch=0x5581c line=18995  op16? r16=r1 r21=r3 lo12=0x016 imm16=0x2000 ; unknown/no-op-ish in current reconstruction
0225 vm+0x0424 pc=0x7105660a94 word=0x81181698 op=0x18 OR_IMM          fetch=0x56f24 line=19056  r25 = r9 | 0x181a ; register OR immediate-style op
0226 vm+0x0428 pc=0x7105660a98 word=0x00c80014 op=0x14 BR_COND         fetch=0x54acc line=19112  branch_cond? delta=+0x0 src=r7 cmp=r9 ; conditional VM branch / VM-PC control
0227 vm+0x042c pc=0x7105660a9c word=0x0012400d op=0x0d LD64_UNALIGNED  fetch=0x541f4 line=19206  ld64_unaligned? r16=r19 r21=r1 lo12=0x00d imm16=0x4000 ; unaligned 64-bit load/merge style
0228 vm+0x0448 pc=0x7105660ab8 word=0x90006001 op=0x01 OP01            fetch=0x536b0 line=19311  op01? r16=r1 r21=r1 lo12=0x001 imm16=0x6900 ; unknown/no-op-ish in current reconstruction
0229 vm+0x044c pc=0x7105660abc word=0x01002016 op=0x16 OP16            fetch=0x5581c line=19390  op16? r16=r1 r21=r9 lo12=0x016 imm16=0x2000 ; unknown/no-op-ish in current reconstruction
0230 vm+0x0450 pc=0x7105660ac0 word=0x80005ed8 op=0x18 OR_IMM          fetch=0x56f24 line=19451  r1 = r1 | 0x583b ; register OR immediate-style op
0231 vm+0x0454 pc=0x7105660ac4 word=0x80485ed8 op=0x18 OR_IMM          fetch=0x54acc line=19507  r9 = r3 | 0x583b ; register OR immediate-style op
0232 vm+0x0458 pc=0x7105660ac8 word=0x80905ed8 op=0x18 OR_IMM          fetch=0x54acc line=19562  r17 = r5 | 0x583b ; register OR immediate-style op
0233 vm+0x045c pc=0x7105660acc word=0x80d85ed8 op=0x18 OR_IMM          fetch=0x54acc line=19617  r25 = r7 | 0x583b ; register OR immediate-style op
0234 vm+0x0460 pc=0x7105660ad0 word=0x810066d8 op=0x18 OR_IMM          fetch=0x54acc line=19672  r1 = r9 | 0x681b ; register OR immediate-style op
0235 vm+0x0464 pc=0x7105660ad4 word=0x814866d8 op=0x18 OR_IMM          fetch=0x54acc line=19727  r9 = r11 | 0x681b ; register OR immediate-style op
0236 vm+0x0468 pc=0x7105660ad8 word=0x819066d8 op=0x18 OR_IMM          fetch=0x54acc line=19782  r17 = r13 | 0x681b ; register OR immediate-style op
0237 vm+0x046c pc=0x7105660adc word=0x81d866d8 op=0x18 OR_IMM          fetch=0x54acc line=19837  r25 = r15 | 0x681b ; register OR immediate-style op
0238 vm+0x0470 pc=0x7105660ae0 word=0x83806ed8 op=0x18 OR_IMM          fetch=0x54acc line=19892  r1 = r29 | 0x683b ; register OR immediate-style op
0239 vm+0x0474 pc=0x7105660ae4 word=0x83c86ed8 op=0x18 OR_IMM          fetch=0x54acc line=19947  r9 = r31 | 0x683b ; register OR immediate-style op
0240 vm+0x0478 pc=0x7105660ae8 word=0xe9bb800f op=0x0f ATOMIC_EX       fetch=0x54acc line=20002  atomic/ex? dst=r28 src=r14 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0241 vm+0x047c pc=0x7105660aec word=0x07c00791 op=0x11 LD32S           fetch=0x52ab8 line=20090  r1 = load_i32? [r31 + +0x5e] ; int32 load/sign-extend style

# exec view: every observed BR X8 and first VM word read before next BR
0000 br@0x4cdf4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660670 word=0xee5b87cf op=0x0f ATOMIC_EX       fetch=0x529e4 line=142    atomic/ex? dst=r28 src=r19 lo12=0x7cf ; atomic/exclusive/cmpxchg-like family
0001 br@0x52af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660674 word=0xa01b6f9a op=0x1a CONV            fetch=0x561b8 line=212    convert? dst=r28 src=r1 sub6=0x3e ; integer/float conversion family
0002 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660678 word=0x801b6f1a op=0x1a CONV            fetch=0x561b8 line=268    convert? dst=r28 src=r1 sub6=0x3c ; integer/float conversion family
0003 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x710566067c word=0xe01b639a op=0x1a CONV            fetch=0x561b8 line=324    convert? dst=r28 src=r1 sub6=0x0e ; integer/float conversion family
0004 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660680 word=0xc01b631a op=0x1a CONV            fetch=0x561b8 line=380    convert? dst=r28 src=r1 sub6=0x0c ; integer/float conversion family
0005 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660684 word=0xa01b629a op=0x1a CONV            fetch=0x561b8 line=436    convert? dst=r28 src=r1 sub6=0x0a ; integer/float conversion family
0006 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660688 word=0x801b621a op=0x1a CONV            fetch=0x561b8 line=492    convert? dst=r28 src=r1 sub6=0x08 ; integer/float conversion family
0007 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x710566068c word=0xe01b599a op=0x1a CONV            fetch=0x561b8 line=548    convert? dst=r28 src=r1 sub6=0x26 ; integer/float conversion family
0008 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660690 word=0xc01b591a op=0x1a CONV            fetch=0x561b8 line=604    convert? dst=r28 src=r1 sub6=0x24 ; integer/float conversion family
0009 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660694 word=0xa01b589a op=0x1a CONV            fetch=0x561b8 line=660    convert? dst=r28 src=r1 sub6=0x22 ; integer/float conversion family
0010 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660698 word=0x801b581a op=0x1a CONV            fetch=0x561b8 line=716    convert? dst=r28 src=r1 sub6=0x20 ; integer/float conversion family
0011 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566069c word=0x00980298 op=0x18 OR_IMM          fetch=0x54a20 line=772    r25 = r5 | 0x000a ; register OR immediate-style op
0012 br@0x54af4 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x71056606a0 word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=850    op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0013 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x71056606a4 word=0x610b88f0 op=0x30 ST64            fetch=0x53330 line=909    store64? [r9 + -0x79dd], r12 ; 64-bit store *(addr)=reg style
0014 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056606a8 word=0xb5440391 op=0x11 LD32S           fetch=0x4ce64 line=968    r5 = load_i32? [r11 + +0xb4e] ; int32 load/sign-extend style
0015 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x71056606ac word=0x88006001 op=0x01 OP01            fetch=0x4e194 line=1035   op01? r16=r1 r21=r1 lo12=0x001 imm16=0x6880 ; unknown/no-op-ish in current reconstruction
0016 br@0x4e1c4 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x71056606ac word=0x88006001 op=0x01 OP01            fetch=0x55770 line=1071   op01? r16=r1 r21=r1 lo12=0x001 imm16=0x6880 ; unknown/no-op-ish in current reconstruction
0017 br@0x55858 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x71056606b0 word=0x00410214 op=0x14 BR_COND         fetch=0x54028 line=1132   branch_cond? delta=+0x20 src=r3 cmp=r2 ; conditional VM branch / VM-PC control
0018 br@0x54224 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056606b4 word=0x89c00b11 op=0x11 LD32S           fetch=0x4ce64 line=1230   r1 = load_i32? [r15 + +0x8ac] ; int32 load/sign-extend style
0019 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056606b8 word=0xc01a111a op=0x1a CONV            fetch=0x4f5d8 line=1297   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0020 br@0x4f608 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606b8 word=0xc01a111a op=0x1a CONV            fetch=0x561b8 line=1311   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0021 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606bc word=0xe01a121a op=0x1a CONV            fetch=0x561b8 line=1367   convert? dst=r27 src=r1 sub6=0x08 ; integer/float conversion family
0022 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606c0 word=0x00480b18 op=0x18 OR_IMM          fetch=0x54a20 line=1423   r9 = r3 | 0x002c ; register OR immediate-style op
0023 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606c4 word=0x801a089a op=0x1a CONV            fetch=0x561b8 line=1478   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0024 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606c8 word=0x00500b18 op=0x18 OR_IMM          fetch=0x54a20 line=1534   r17 = r3 | 0x002c ; register OR immediate-style op
0025 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606cc word=0xe01a089a op=0x1a CONV            fetch=0x561b8 line=1589   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0026 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606d0 word=0x00580b18 op=0x18 OR_IMM          fetch=0x54a20 line=1645   r25 = r3 | 0x002c ; register OR immediate-style op
0027 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606d4 word=0xc01a089a op=0x1a CONV            fetch=0x561b8 line=1700   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0028 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606d8 word=0x00500a98 op=0x18 OR_IMM          fetch=0x54a20 line=1756   r17 = r3 | 0x002a ; register OR immediate-style op
0029 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606dc word=0x801a109a op=0x1a CONV            fetch=0x561b8 line=1811   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0030 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606e0 word=0x00480a98 op=0x18 OR_IMM          fetch=0x54a20 line=1867   r9 = r3 | 0x002a ; register OR immediate-style op
0031 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056606e4 word=0xa01a089a op=0x1a CONV            fetch=0x561b8 line=1922   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0032 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606e8 word=0x00800ad8 op=0x18 OR_IMM          fetch=0x54a20 line=1978   r1 = r5 | 0x002b ; register OR immediate-style op
0033 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606ec word=0x00800298 op=0x18 OR_IMM          fetch=0x54a20 line=2033   r1 = r5 | 0x000a ; register OR immediate-style op
0034 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606f0 word=0x00c802d8 op=0x18 OR_IMM          fetch=0x54a20 line=2088   r9 = r7 | 0x000b ; register OR immediate-style op
0035 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606f4 word=0x011002d8 op=0x18 OR_IMM          fetch=0x54a20 line=2143   r17 = r9 | 0x000b ; register OR immediate-style op
0036 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606f8 word=0x00400318 op=0x18 OR_IMM          fetch=0x54a20 line=2198   r1 = r3 | 0x000c ; register OR immediate-style op
0037 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056606fc word=0x00080358 op=0x18 OR_IMM          fetch=0x54a20 line=2253   r9 = r1 | 0x000d ; register OR immediate-style op
0038 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660700 word=0x03900358 op=0x18 OR_IMM          fetch=0x54a20 line=2308   r17 = r29 | 0x000d ; register OR immediate-style op
0039 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660704 word=0x01d80358 op=0x18 OR_IMM          fetch=0x54a20 line=2363   r25 = r15 | 0x000d ; register OR immediate-style op
0040 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660708 word=0x00c00b18 op=0x18 OR_IMM          fetch=0x54a20 line=2418   r1 = r7 | 0x002c ; register OR immediate-style op
0041 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x710566070c word=0xe01a019a op=0x1a CONV            fetch=0x561b8 line=2473   convert? dst=r27 src=r1 sub6=0x06 ; integer/float conversion family
0042 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660710 word=0x25420391 op=0x11 LD32S           fetch=0x4ce64 line=2532   r3 = load_i32? [r11 + +0x24e] ; int32 load/sign-extend style
0043 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660714 word=0xa01a111a op=0x1a CONV            fetch=0x4e194 line=2599   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0044 br@0x4e1c4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660714 word=0xa01a111a op=0x1a CONV            fetch=0x561b8 line=2613   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0045 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660718 word=0x0d440391 op=0x11 LD32S           fetch=0x4ce64 line=2672   r5 = load_i32? [r11 + +0xce] ; int32 load/sign-extend style
0046 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x710566071c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=2739   r1 = r3 | 0x0002 ; register OR immediate-style op
0047 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566071c word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=2753   r1 = r3 | 0x0002 ; register OR immediate-style op
0048 br@0x54af4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660720 word=0x907a000f op=0x0f ATOMIC_EX       fetch=0x529e4 line=2831   atomic/ex? dst=r27 src=r4 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0049 br@0x52af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660724 word=0xe01a511a op=0x1a CONV            fetch=0x561b8 line=2901   convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0050 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660728 word=0xc01a509a op=0x1a CONV            fetch=0x561b8 line=2957   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0051 br@0x56290 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x710566072c word=0xa95a800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=3036   atomic/ex? dst=r27 src=r11 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0052 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660730 word=0xc9c00b11 op=0x11 LD32S           fetch=0x4ce64 line=3109   r1 = load_i32? [r15 + +0xcac] ; int32 load/sign-extend style
0053 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660734 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=3176   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0054 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660734 word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=3193   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0055 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7105660738 word=0x0d640391 op=0x11 LD32S           fetch=0x4f8e0 line=3404   r5 = load_i32? [r12 + +0xce] ; int32 load/sign-extend style
0056 br@0x4f914 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660738 word=0x0d640391 op=0x11 LD32S           fetch=0x4ce64 line=3422   r5 = load_i32? [r12 + +0xce] ; int32 load/sign-extend style
0057 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x710566073c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=3489   r1 = r3 | 0x0002 ; register OR immediate-style op
0058 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566073c word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=3503   r1 = r3 | 0x0002 ; register OR immediate-style op
0059 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660740 word=0x81801e98 op=0x18 OR_IMM          fetch=0x54a20 line=3558   r1 = r13 | 0x183a ; register OR immediate-style op
0060 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x7105660744 word=0x00480054 op=0x14 BR_COND         fetch=0x54028 line=3614   branch_cond? delta=+0x4 src=r3 cmp=r9 ; conditional VM branch / VM-PC control
0061 br@0x54224 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x71056607e8 word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=3732   op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0062 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x71056607ec word=0x610588b0 op=0x30 ST64            fetch=0x53330 line=3791   store64? [r9 + -0x79de], r6 ; 64-bit store *(addr)=reg style
0063 br@0x53408 -> 0x53db0 AND_IMM/op2d (primary op2d handler)        vm_pc=0x71056607f0 word=0x140c02ed op=0x2d AND_IMM         fetch=0x53db8 line=3848   r13 = r1 & 0x014b ; register AND immediate-style op
0064 br@0x53f7c -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056607f4 word=0x08a40391 op=0x11 LD32S           fetch=0x4ce64 line=3945   r5 = load_i32? [r6 + +0x8e] ; int32 load/sign-extend style
0065 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x71056607f8 word=0x01c000d8 op=0x18 OR_IMM          fetch=0x4e194 line=4012   r1 = r15 | 0x0003 ; register OR immediate-style op
0066 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056607f8 word=0x01c000d8 op=0x18 OR_IMM          fetch=0x54a20 line=4026   r1 = r15 | 0x0003 ; register OR immediate-style op
0067 br@0x54af4 -> 0x53db0 AND_IMM/op2d (primary op2d handler)        vm_pc=0x71056607fc word=0x940e022d op=0x2d AND_IMM         fetch=0x53db8 line=4082   r15 = r1 & 0x0948 ; register AND immediate-style op
0068 br@0x53f7c -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660800 word=0x80400e98 op=0x18 OR_IMM          fetch=0x54a20 line=4176   r1 = r3 | 0x083a ; register OR immediate-style op
0069 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660804 word=0xa5420391 op=0x11 LD32S           fetch=0x4ce64 line=4234   r3 = load_i32? [r11 + +0xa4e] ; int32 load/sign-extend style
0070 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660808 word=0x80580698 op=0x18 OR_IMM          fetch=0x4e194 line=4301   r25 = r3 | 0x081a ; register OR immediate-style op
0071 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660808 word=0x80580698 op=0x18 OR_IMM          fetch=0x54a20 line=4315   r25 = r3 | 0x081a ; register OR immediate-style op
0072 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566080c word=0x25420391 op=0x11 LD32S           fetch=0x4ce64 line=4373   r3 = load_i32? [r11 + +0x24e] ; int32 load/sign-extend style
0073 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660810 word=0x043a87f4 op=0x34 OP34            fetch=0x4e194 line=4440   op34? r16=r27 r21=r2 lo12=0x7f4 imm16=0x805f ; unknown/no-op-ish in current reconstruction
0074 br@0x4e1c4 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7105660810 word=0x043a87f4 op=0x34 OP34            fetch=0x53244 line=4477   op34? r16=r27 r21=r2 lo12=0x7f4 imm16=0x805f ; unknown/no-op-ish in current reconstruction
0075 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660814 word=0xe1078870 op=0x30 ST64            fetch=0x53330 line=4536   store64? [r9 + -0x71df], r8 ; 64-bit store *(addr)=reg style
0076 br@0x53408 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660818 word=0x83880ed8 op=0x18 OR_IMM          fetch=0x54a20 line=4592   r9 = r29 | 0x083b ; register OR immediate-style op
0077 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566081c word=0x94fc0391 op=0x11 LD32S           fetch=0x4ce64 line=4650   r29 = load_i32? [r8 + +0x94e] ; int32 load/sign-extend style
0078 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660820 word=0x80400118 op=0x18 OR_IMM          fetch=0x4e194 line=4717   r1 = r3 | 0x0804 ; register OR immediate-style op
0079 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660820 word=0x80400118 op=0x18 OR_IMM          fetch=0x54a20 line=4731   r1 = r3 | 0x0804 ; register OR immediate-style op
0080 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x7105660824 word=0x00570054 op=0x14 BR_COND         fetch=0x54028 line=4787   branch_cond? delta=+0x4 src=r3 cmp=r24 ; conditional VM branch / VM-PC control
0081 br@0x54224 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660828 word=0xe2038830 op=0x30 ST64            fetch=0x53330 line=4882   store64? [r17 + -0x71e0], r4 ; 64-bit store *(addr)=reg style
0082 br@0x53408 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x710566082c word=0xe01b021a op=0x1a CONV            fetch=0x561b8 line=4938   convert? dst=r28 src=r1 sub6=0x08 ; integer/float conversion family
0083 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660830 word=0xa5c00b11 op=0x11 LD32S           fetch=0x4ce64 line=4997   r1 = load_i32? [r15 + +0xa6c] ; int32 load/sign-extend style
0084 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660834 word=0x81c816d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=5064   r9 = r15 | 0x181b ; register OR immediate-style op
0085 br@0x4f608 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660834 word=0x81c816d8 op=0x18 OR_IMM          fetch=0x54a20 line=5078   r9 = r15 | 0x181b ; register OR immediate-style op
0086 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660838 word=0x086e0391 op=0x11 LD32S           fetch=0x4ce64 line=5136   r15 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0087 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x710566083c word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=5203   r1 = r3 | 0x0002 ; register OR immediate-style op
0088 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566083c word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=5217   r1 = r3 | 0x0002 ; register OR immediate-style op
0089 br@0x54af4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660840 word=0x1000780f op=0x0f ATOMIC_EX       fetch=0x529e4 line=5295   atomic/ex? dst=r1 src=r1 lo12=0x80f ; atomic/exclusive/cmpxchg-like family
0090 br@0x52af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660844 word=0xe01a391a op=0x1a CONV            fetch=0x561b8 line=5365   convert? dst=r27 src=r1 sub6=0x24 ; integer/float conversion family
0091 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660848 word=0xc01a389a op=0x1a CONV            fetch=0x561b8 line=5421   convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0092 br@0x56290 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x710566084c word=0xa8fa800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=5500   atomic/ex? dst=r27 src=r8 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0093 br@0x52af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660850 word=0x801a0b1a op=0x1a CONV            fetch=0x561b8 line=5570   convert? dst=r27 src=r1 sub6=0x2c ; integer/float conversion family
0094 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660854 word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=5629   r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0095 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660858 word=0xc01a021a op=0x1a CONV            fetch=0x4f5d8 line=5696   convert? dst=r27 src=r1 sub6=0x08 ; integer/float conversion family
0096 br@0x4f608 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660858 word=0xc01a021a op=0x1a CONV            fetch=0x561b8 line=5710   convert? dst=r27 src=r1 sub6=0x08 ; integer/float conversion family
0097 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566085c word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=5769   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0098 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7105660860 word=0xe2039030 op=0x30 ST64            fetch=0x4f8e0 line=5868   store64? [r17 + -0x6200], r4 ; 64-bit store *(addr)=reg style
0099 br@0x4f914 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660860 word=0xe2039030 op=0x30 ST64            fetch=0x53330 line=5883   store64? [r17 + -0x6200], r4 ; 64-bit store *(addr)=reg style
0100 br@0x53408 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7105660864 word=0x10022eb4 op=0x34 OP34            fetch=0x53244 line=5962   op34? r16=r3 r21=r1 lo12=0xeb4 imm16=0x213a ; unknown/no-op-ish in current reconstruction
0101 br@0x53328 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660868 word=0x1264cfcf op=0x0f ATOMIC_EX       fetch=0x529e4 line=6044   atomic/ex? dst=r5 src=r20 lo12=0xfcf ; atomic/exclusive/cmpxchg-like family
0102 br@0x52af4 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x710566086c word=0x1c118974 op=0x34 OP34            fetch=0x53244 line=6137   op34? r16=r18 r21=r1 lo12=0x974 imm16=0x81e5 ; unknown/no-op-ish in current reconstruction
0103 br@0x53328 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660870 word=0x10a205d1 op=0x11 LD32S           fetch=0x4ce64 line=6199   r3 = load_i32? [r6 + +0x117] ; int32 load/sign-extend style
0104 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x7105660874 word=0x7a4691b0 op=0x30 ST64            fetch=0x4cff0 line=6264   store64? [r19 + -0x687a], r7 ; 64-bit store *(addr)=reg style
0105 br@0x4d020 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660874 word=0x7a4691b0 op=0x30 ST64            fetch=0x53330 line=6278   store64? [r19 + -0x687a], r7 ; 64-bit store *(addr)=reg style
0106 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660878 word=0x086e0391 op=0x11 LD32S           fetch=0x4ce64 line=6337   r15 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0107 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x710566087c word=0xbd000b11 op=0x11 LD32S           fetch=0x4e194 line=6404   r1 = load_i32? [r9 + +0xbec] ; int32 load/sign-extend style
0108 br@0x4e1c4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566087c word=0xbd000b11 op=0x11 LD32S           fetch=0x4ce64 line=6421   r1 = load_i32? [r9 + +0xbec] ; int32 load/sign-extend style
0109 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660880 word=0x811806d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=6488   r25 = r9 | 0x081b ; register OR immediate-style op
0110 br@0x4f608 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660880 word=0x811806d8 op=0x18 OR_IMM          fetch=0x54a20 line=6502   r25 = r9 | 0x081b ; register OR immediate-style op
0111 br@0x54af4 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x7105660884 word=0x20fa003b op=0x3b OP3B            fetch=0x52d08 line=6557   op3b? r16=r27 r21=r8 lo12=0x03b imm16=0x0200 ; unknown/no-op-ish in current reconstruction
0112 br@0x52db8 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x7105660888 word=0x30e1003b op=0x3b OP3B            fetch=0x52d08 line=6603   op3b? r16=r2 r21=r8 lo12=0x03b imm16=0x0300 ; unknown/no-op-ish in current reconstruction
0113 br@0x52db8 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x710566088c word=0xa8da800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=6672   atomic/ex? dst=r27 src=r7 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0114 br@0x52af4 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x7105660890 word=0x380f003b op=0x3b OP3B            fetch=0x52d08 line=6742   op3b? r16=r16 r21=r1 lo12=0x03b imm16=0x0380 ; unknown/no-op-ish in current reconstruction
0115 br@0x52db8 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x7105660894 word=0x40fd003b op=0x3b OP3B            fetch=0x52d08 line=6788   op3b? r16=r30 r21=r8 lo12=0x03b imm16=0x0400 ; unknown/no-op-ish in current reconstruction
0116 br@0x52db8 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660898 word=0x82404698 op=0x18 OR_IMM          fetch=0x54a20 line=6834   r1 = r19 | 0x481a ; register OR immediate-style op
0117 br@0x54af4 -> 0x565e0 LD32_UNALIGNED/op2e (primary op2e handler) vm_pc=0x710566089c word=0x2c12302e op=0x2e LD32_UNALIGNED  fetch=0x56630 line=6908   ld32_unaligned? r16=r19 r21=r1 lo12=0x02e imm16=0x32c0 ; unaligned 32-bit load/merge style
0118 br@0x56820 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x71056608a0 word=0x17045a4f op=0x0f ATOMIC_EX       fetch=0x529e4 line=7028   atomic/ex? dst=r5 src=r25 lo12=0xa4f ; atomic/exclusive/cmpxchg-like family
0119 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056608a4 word=0x10a005d1 op=0x11 LD32S           fetch=0x4ce64 line=7101   r1 = load_i32? [r6 + +0x117] ; int32 load/sign-extend style
0120 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x71056608a8 word=0x1244978f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=7166   atomic/ex? dst=r5 src=r19 lo12=0x78f ; atomic/exclusive/cmpxchg-like family
0121 br@0x4d020 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x71056608a8 word=0x1244978f op=0x0f ATOMIC_EX       fetch=0x529e4 line=7203   atomic/ex? dst=r5 src=r19 lo12=0x78f ; atomic/exclusive/cmpxchg-like family
0122 br@0x52af4 -> 0x55d20 LD8U/op3e (primary op3e handler)           vm_pc=0x71056608ac word=0x1e40013e op=0x3e LD8U            fetch=0x55d74 line=7293   r1 = load_u8? [r19 + +0x1c4] ; uint8 load/zero-extend style
0123 br@0x55f1c -> 0x56b00 LD16S/op10 (primary op10 handler)          vm_pc=0x71056608b0 word=0x01d20310 op=0x10 LD16S           fetch=0x56b60 line=7394   r19 = load_i16? [r15 + +0xc] ; int16 load/sign-extend style
0124 br@0x56c4c -> 0x56b00 LD16S/op10 (primary op10 handler)          vm_pc=0x71056608b4 word=0x01b20210 op=0x10 LD16S           fetch=0x56b60 line=7478   r19 = load_i16? [r14 + +0x8] ; int16 load/sign-extend style
0125 br@0x56c4c -> 0x56b00 LD16S/op10 (primary op10 handler)          vm_pc=0x71056608b8 word=0x01920410 op=0x10 LD16S           fetch=0x56b60 line=7562   r19 = load_i16? [r13 + +0x10] ; int16 load/sign-extend style
0126 br@0x56c4c -> 0x5685c MUL_OR_ALU_SUB/op0b (primary op0b handler) vm_pc=0x71056608bc word=0x0012418b op=0x0b MUL_OR_ALU_SUB  fetch=0x56860 line=7623   mul_or_alu_sub? r16=r19 r21=r1 lo12=0x18b imm16=0x4006 ; multiply/ALU subfamily; needs subdecode
0127 br@0x56a48 -> 0x55fd4 OP13/op13 (primary op13 handler)           vm_pc=0x71056608c0 word=0x02440013 op=0x13 OP13            fetch=0x56024 line=7738   op13? r16=r5 r21=r19 lo12=0x013 imm16=0x0000 ; unknown/no-op-ish in current reconstruction
0128 br@0x561b0 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056608c4 word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=7811   r1 = r3 | 0x0002 ; register OR immediate-style op
0129 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056608c8 word=0xe01a349a op=0x1a CONV            fetch=0x561b8 line=7866   convert? dst=r27 src=r1 sub6=0x12 ; integer/float conversion family
0130 br@0x56290 -> 0x56e70 OP16/op16 (primary op16 handler)           vm_pc=0x71056608cc word=0x834071d6 op=0x16 OP16            fetch=0x56e74 line=7922   op16? r16=r1 r21=r27 lo12=0x1d6 imm16=0x7807 ; unknown/no-op-ish in current reconstruction
0131 br@0x56f50 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056608d0 word=0xc01a309a op=0x1a CONV            fetch=0x561b8 line=7979   convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0132 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056608d4 word=0x25000b11 op=0x11 LD32S           fetch=0x4ce64 line=8038   r1 = load_i32? [r9 + +0x26c] ; int32 load/sign-extend style
0133 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056608d8 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=8105   r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0134 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056608d8 word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=8122   r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0135 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056608dc word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=8189   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0136 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056608dc word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=8206   r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0137 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x71056608e0 word=0x81100698 op=0x18 OR_IMM          fetch=0x4f8e0 line=9452   r17 = r9 | 0x081a ; register OR immediate-style op
0138 br@0x4f914 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056608e0 word=0x81100698 op=0x18 OR_IMM          fetch=0x54a20 line=9467   r17 = r9 | 0x081a ; register OR immediate-style op
0139 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056608e4 word=0x81800e98 op=0x18 OR_IMM          fetch=0x54a20 line=9522   r1 = r13 | 0x083a ; register OR immediate-style op
0140 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056608e8 word=0x80883e98 op=0x18 OR_IMM          fetch=0x54a20 line=9577   r9 = r5 | 0x383a ; register OR immediate-style op
0141 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056608ec word=0x80400118 op=0x18 OR_IMM          fetch=0x54a20 line=9632   r1 = r3 | 0x0804 ; register OR immediate-style op
0142 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x71056608f0 word=0x00440014 op=0x14 BR_COND         fetch=0x54028 line=9688   branch_cond? delta=+0x0 src=r3 cmp=r5 ; conditional VM branch / VM-PC control
0143 br@0x54224 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x71056608f4 word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=9806   op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0144 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x71056608f8 word=0x610388b0 op=0x30 ST64            fetch=0x53330 line=9865   store64? [r9 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0145 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056608fc word=0x087c0391 op=0x11 LD32S           fetch=0x4ce64 line=9924   r29 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0146 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660900 word=0x0002011a op=0x1a CONV            fetch=0x4e194 line=9991   convert? dst=r3 src=r1 sub6=0x04 ; integer/float conversion family
0147 br@0x4e1c4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660900 word=0x0002011a op=0x1a CONV            fetch=0x561b8 line=10005  convert? dst=r3 src=r1 sub6=0x04 ; integer/float conversion family
0148 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660904 word=0x80500e98 op=0x18 OR_IMM          fetch=0x54a20 line=10061  r17 = r3 | 0x083a ; register OR immediate-style op
0149 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660908 word=0xf5420391 op=0x11 LD32S           fetch=0x4ce64 line=10119  r3 = load_i32? [r11 + +0xf4e] ; int32 load/sign-extend style
0150 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x710566090c word=0x80580e98 op=0x18 OR_IMM          fetch=0x4e194 line=10186  r25 = r3 | 0x083a ; register OR immediate-style op
0151 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566090c word=0x80580e98 op=0x18 OR_IMM          fetch=0x54a20 line=10200  r25 = r3 | 0x083a ; register OR immediate-style op
0152 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660910 word=0xad420391 op=0x11 LD32S           fetch=0x4ce64 line=10258  r3 = load_i32? [r11 + +0xace] ; int32 load/sign-extend style
0153 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660914 word=0x80400118 op=0x18 OR_IMM          fetch=0x4e194 line=10325  r1 = r3 | 0x0804 ; register OR immediate-style op
0154 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660914 word=0x80400118 op=0x18 OR_IMM          fetch=0x54a20 line=10339  r1 = r3 | 0x0804 ; register OR immediate-style op
0155 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660918 word=0xe01a089a op=0x1a CONV            fetch=0x561b8 line=10394  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0156 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566091c word=0x808016d8 op=0x18 OR_IMM          fetch=0x54a20 line=10450  r1 = r5 | 0x181b ; register OR immediate-style op
0157 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660920 word=0x0ce40391 op=0x11 LD32S           fetch=0x4ce64 line=10508  r5 = load_i32? [r8 + +0xce] ; int32 load/sign-extend style
0158 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660924 word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=10575  r1 = r3 | 0x0002 ; register OR immediate-style op
0159 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660924 word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=10589  r1 = r3 | 0x0002 ; register OR immediate-style op
0160 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x7105660928 word=0x005a0054 op=0x14 BR_COND         fetch=0x54028 line=10645  branch_cond? delta=+0x4 src=r3 cmp=r27 ; conditional VM branch / VM-PC control
0161 br@0x54224 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x710566092c word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=10763  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0162 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660930 word=0x620388b0 op=0x30 ST64            fetch=0x53330 line=10822  store64? [r17 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0163 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660934 word=0x87800b11 op=0x11 LD32S           fetch=0x4ce64 line=10881  r1 = load_i32? [r29 + +0x86c] ; int32 load/sign-extend style
0164 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660938 word=0xf5000b11 op=0x11 LD32S           fetch=0x4f5d8 line=10948  r1 = load_i32? [r9 + +0xf6c] ; int32 load/sign-extend style
0165 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660938 word=0xf5000b11 op=0x11 LD32S           fetch=0x4ce64 line=10965  r1 = load_i32? [r9 + +0xf6c] ; int32 load/sign-extend style
0166 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x710566093c word=0x810816d8 op=0x18 OR_IMM          fetch=0x4f5d8 line=11032  r9 = r9 | 0x181b ; register OR immediate-style op
0167 br@0x4f608 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x710566093c word=0x810816d8 op=0x18 OR_IMM          fetch=0x54a20 line=11046  r9 = r9 | 0x181b ; register OR immediate-style op
0168 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660940 word=0x08680391 op=0x11 LD32S           fetch=0x4ce64 line=11104  r9 = load_i32? [r4 + +0x8e] ; int32 load/sign-extend style
0169 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660944 word=0x00400098 op=0x18 OR_IMM          fetch=0x4e194 line=11171  r1 = r3 | 0x0002 ; register OR immediate-style op
0170 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660944 word=0x00400098 op=0x18 OR_IMM          fetch=0x54a20 line=11185  r1 = r3 | 0x0002 ; register OR immediate-style op
0171 br@0x54af4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660948 word=0x1000a80f op=0x0f ATOMIC_EX       fetch=0x529e4 line=11263  atomic/ex? dst=r1 src=r1 lo12=0x80f ; atomic/exclusive/cmpxchg-like family
0172 br@0x52af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x710566094c word=0xe01a391a op=0x1a CONV            fetch=0x561b8 line=11333  convert? dst=r27 src=r1 sub6=0x24 ; integer/float conversion family
0173 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660950 word=0xc01a389a op=0x1a CONV            fetch=0x561b8 line=11389  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0174 br@0x56290 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660954 word=0xa8fa800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=11468  atomic/ex? dst=r27 src=r8 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0175 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660958 word=0x99800b11 op=0x11 LD32S           fetch=0x4ce64 line=11541  r1 = load_i32? [r13 + +0x9ac] ; int32 load/sign-extend style
0176 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x710566095c word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=11608  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0177 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566095c word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=11625  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0178 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660960 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=11692  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0179 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660960 word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=11709  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0180 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7105660964 word=0x080c3834 op=0x34 OP34            fetch=0x4f8e0 line=11808  op34? r16=r13 r21=r1 lo12=0x834 imm16=0x30a0 ; unknown/no-op-ish in current reconstruction
0181 br@0x4f914 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7105660964 word=0x080c3834 op=0x34 OP34            fetch=0x53244 line=11846  op34? r16=r13 r21=r1 lo12=0x834 imm16=0x30a0 ; unknown/no-op-ish in current reconstruction
0182 br@0x53328 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660968 word=0x0b823a8f op=0x0f ATOMIC_EX       fetch=0x529e4 line=11928  atomic/ex? dst=r3 src=r29 lo12=0xa8f ; atomic/exclusive/cmpxchg-like family
0183 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x710566096c word=0x086e05d1 op=0x11 LD32S           fetch=0x4ce64 line=12001  r15 = load_i32? [r4 + +0x97] ; int32 load/sign-extend style
0184 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x7105660970 word=0x0c02fa0f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=12066  atomic/ex? dst=r3 src=r1 lo12=0xa0f ; atomic/exclusive/cmpxchg-like family
0185 br@0x4d020 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660970 word=0x0c02fa0f op=0x0f ATOMIC_EX       fetch=0x529e4 line=12103  atomic/ex? dst=r3 src=r1 lo12=0xa0f ; atomic/exclusive/cmpxchg-like family
0186 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660974 word=0x086005d1 op=0x11 LD32S           fetch=0x4ce64 line=12176  r1 = load_i32? [r4 + +0x97] ; int32 load/sign-extend style
0187 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x7105660978 word=0x1400b7f4 op=0x34 OP34            fetch=0x4cff0 line=12241  op34? r16=r1 r21=r1 lo12=0x7f4 imm16=0xb15f ; unknown/no-op-ish in current reconstruction
0188 br@0x4d020 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7105660978 word=0x1400b7f4 op=0x34 OP34            fetch=0x53244 line=12278  op34? r16=r1 r21=r1 lo12=0x7f4 imm16=0xb15f ; unknown/no-op-ish in current reconstruction
0189 br@0x53328 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x710566097c word=0x181a04f4 op=0x34 OP34            fetch=0x53244 line=12360  op34? r16=r27 r21=r1 lo12=0x4f4 imm16=0x0193 ; unknown/no-op-ish in current reconstruction
0190 br@0x53328 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660980 word=0x1b06cf0f op=0x0f ATOMIC_EX       fetch=0x529e4 line=12442  atomic/ex? dst=r7 src=r25 lo12=0xf0f ; atomic/exclusive/cmpxchg-like family
0191 br@0x52af4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660984 word=0x09c24f0f op=0x0f ATOMIC_EX       fetch=0x529e4 line=12535  atomic/ex? dst=r3 src=r15 lo12=0xf0f ; atomic/exclusive/cmpxchg-like family
0192 br@0x52af4 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660988 word=0x7d84b130 op=0x30 ST64            fetch=0x53330 line=12605  store64? [r13 + -0x483c], r5 ; 64-bit store *(addr)=reg style
0193 br@0x53408 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x710566098c word=0x241a87f4 op=0x34 OP34            fetch=0x53244 line=12684  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x825f ; unknown/no-op-ish in current reconstruction
0194 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660990 word=0x63099230 op=0x30 ST64            fetch=0x53330 line=12743  store64? [r25 + -0x69f8], r10 ; 64-bit store *(addr)=reg style
0195 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660994 word=0x21280391 op=0x11 LD32S           fetch=0x4ce64 line=12802  r9 = load_i32? [r10 + +0x20e] ; int32 load/sign-extend style
0196 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660998 word=0xa8da800f op=0x0f ATOMIC_EX       fetch=0x4e194 line=12869  atomic/ex? dst=r27 src=r7 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0197 br@0x4e1c4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660998 word=0xa8da800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=12906  atomic/ex? dst=r27 src=r7 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0198 br@0x52af4 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x710566099c word=0x3015003b op=0x3b OP3B            fetch=0x52d08 line=12976  op3b? r16=r22 r21=r1 lo12=0x03b imm16=0x0300 ; unknown/no-op-ish in current reconstruction
0199 br@0x52db8 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x71056609a0 word=0x3850003b op=0x3b OP3B            fetch=0x52d08 line=13022  op3b? r16=r17 r21=r3 lo12=0x03b imm16=0x0380 ; unknown/no-op-ish in current reconstruction
0200 br@0x52db8 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056609a4 word=0x82004698 op=0x18 OR_IMM          fetch=0x54a20 line=13068  r1 = r17 | 0x481a ; register OR immediate-style op
0201 br@0x54af4 -> 0x565e0 LD32_UNALIGNED/op2e (primary op2e handler) vm_pc=0x71056609a8 word=0x4c10202e op=0x2e LD32_UNALIGNED  fetch=0x56630 line=13142  ld32_unaligned? r16=r17 r21=r1 lo12=0x02e imm16=0x24c0 ; unaligned 32-bit load/merge style
0202 br@0x56820 -> 0x55d20 LD8U/op3e (primary op3e handler)           vm_pc=0x71056609ac word=0x3e0000be op=0x3e LD8U            fetch=0x55d74 line=13259  r1 = load_u8? [r17 + +0x3c2] ; uint8 load/zero-extend style
0203 br@0x55f1c -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609b0 word=0x18e205d1 op=0x11 LD32S           fetch=0x4ce64 line=13340  r3 = load_i32? [r8 + +0x197] ; int32 load/sign-extend style
0204 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x71056609b4 word=0x1d26eacf op=0x0f ATOMIC_EX       fetch=0x4cff0 line=13405  atomic/ex? dst=r7 src=r10 lo12=0xacf ; atomic/exclusive/cmpxchg-like family
0205 br@0x4d020 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x71056609b4 word=0x1d26eacf op=0x0f ATOMIC_EX       fetch=0x529e4 line=13442  atomic/ex? dst=r7 src=r10 lo12=0xacf ; atomic/exclusive/cmpxchg-like family
0206 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609b8 word=0x18e005d1 op=0x11 LD32S           fetch=0x4ce64 line=13515  r1 = load_i32? [r8 + +0x197] ; int32 load/sign-extend style
0207 br@0x4ce94 -> 0x4cf20 secondary/unknown target                   vm_pc=0x71056609bc word=0x19866b8f op=0x0f ATOMIC_EX       fetch=0x4cff0 line=13580  atomic/ex? dst=r7 src=r13 lo12=0xb8f ; atomic/exclusive/cmpxchg-like family
0208 br@0x4d020 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x71056609bc word=0x19866b8f op=0x0f ATOMIC_EX       fetch=0x529e4 line=13617  atomic/ex? dst=r7 src=r13 lo12=0xb8f ; atomic/exclusive/cmpxchg-like family
0209 br@0x52af4 -> 0x55d20 LD8U/op3e (primary op3e handler)           vm_pc=0x71056609c0 word=0x1e0001be op=0x3e LD8U            fetch=0x55d74 line=13707  r1 = load_u8? [r17 + +0x1c6] ; uint8 load/zero-extend style
0210 br@0x55f1c -> 0x56b00 LD16S/op10 (primary op10 handler)          vm_pc=0x71056609c4 word=0x02900390 op=0x10 LD16S           fetch=0x56b60 line=13808  r17 = load_i16? [r21 + +0xe] ; int16 load/sign-extend style
0211 br@0x56c4c -> 0x5685c MUL_OR_ALU_SUB/op0b (primary op0b handler) vm_pc=0x71056609c8 word=0x0010810b op=0x0b MUL_OR_ALU_SUB  fetch=0x56860 line=13869  mul_or_alu_sub? r16=r17 r21=r1 lo12=0x10b imm16=0x8004 ; multiply/ALU subfamily; needs subdecode
0212 br@0x56a48 -> 0x55fd4 OP13/op13 (primary op13 handler)           vm_pc=0x71056609cc word=0x22020013 op=0x13 OP13            fetch=0x56024 line=13984  op13? r16=r3 r21=r17 lo12=0x013 imm16=0x0200 ; unknown/no-op-ish in current reconstruction
0213 br@0x561b0 -> 0x55fd4 OP13/op13 (primary op13 handler)           vm_pc=0x71056609d0 word=0x02060013 op=0x13 OP13            fetch=0x56024 line=14076  op13? r16=r7 r21=r17 lo12=0x013 imm16=0x0000 ; unknown/no-op-ish in current reconstruction
0214 br@0x561b0 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x71056609d4 word=0x00400218 op=0x18 OR_IMM          fetch=0x54a20 line=14149  r1 = r3 | 0x0008 ; register OR immediate-style op
0215 br@0x54af4 -> 0x56e70 OP16/op16 (primary op16 handler)           vm_pc=0x71056609d8 word=0x834061d6 op=0x16 OP16            fetch=0x56e74 line=14204  op16? r16=r1 r21=r27 lo12=0x1d6 imm16=0x6807 ; unknown/no-op-ish in current reconstruction
0216 br@0x56f50 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056609dc word=0xe01a341a op=0x1a CONV            fetch=0x561b8 line=14261  convert? dst=r27 src=r1 sub6=0x10 ; integer/float conversion family
0217 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x71056609e0 word=0xc01a309a op=0x1a CONV            fetch=0x561b8 line=14317  convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0218 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609e4 word=0x27800b11 op=0x11 LD32S           fetch=0x4ce64 line=14376  r1 = load_i32? [r29 + +0x26c] ; int32 load/sign-extend style
0219 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056609e8 word=0xf4000b11 op=0x11 LD32S           fetch=0x4f5d8 line=14443  r1 = load_i32? [r1 + +0xf6c] ; int32 load/sign-extend style
0220 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609e8 word=0xf4000b11 op=0x11 LD32S           fetch=0x4ce64 line=14460  r1 = load_i32? [r1 + +0xf6c] ; int32 load/sign-extend style
0221 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056609ec word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=14527  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0222 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609ec word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=14544  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0223 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056609f0 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=14611  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0224 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609f0 word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=14628  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0225 br@0x4ce94 -> 0x4f830 secondary/unknown target ; no VM word read before next BR
0226 br@0x12b9ec -> 0x12b9f0 secondary/unknown target ; no VM word read before next BR
0227 br@0x12ba3c -> 0x12ba40 secondary/unknown target ; no VM word read before next BR
0228 br@0x12ba74 -> 0x12ba78 secondary/unknown target ; no VM word read before next BR
0229 br@0x12baf4 -> 0x12bb14 secondary/unknown target ; no VM word read before next BR
0230 br@0x12bb88 -> 0x12bb8c secondary/unknown target ; no VM word read before next BR
0231 br@0x12bbe8 -> 0x12bbec secondary/unknown target ; no VM word read before next BR
0232 br@0x12bc10 -> 0x12bccc secondary/unknown target ; no VM word read before next BR
0233 br@0x12bd0c -> 0x12bd10 secondary/unknown target ; no VM word read before next BR
0234 br@0x12bd34 -> 0x12bd38 secondary/unknown target ; no VM word read before next BR
0235 br@0x12bd78 -> 0x12bd7c secondary/unknown target ; no VM word read before next BR
0236 br@0x12be54 -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0237 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0238 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0239 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0240 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0241 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0242 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0243 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0244 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0245 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0246 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0247 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0248 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0249 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0250 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0251 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0252 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0253 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0254 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0255 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0256 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0257 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0258 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0259 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0260 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0261 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0262 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0263 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0264 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0265 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0266 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0267 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0268 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0269 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0270 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0271 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0272 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0273 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0274 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0275 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0276 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0277 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0278 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0279 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0280 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0281 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0282 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0283 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0284 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0285 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0286 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0287 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0288 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0289 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0290 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0291 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0292 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0293 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0294 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0295 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0296 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0297 br@0x12bea8 -> 0x12bed8 secondary/unknown target ; no VM word read before next BR
0298 br@0x12bf24 -> 0x12bf28 secondary/unknown target ; no VM word read before next BR
0299 br@0x12bf5c -> 0x12be58 secondary/unknown target ; no VM word read before next BR
0300 br@0x12bea8 -> 0x12beac secondary/unknown target ; no VM word read before next BR
0301 br@0x12bed4 -> 0x12bf60 secondary/unknown target                   vm_pc=0x71056609f4 word=0x34c00b11 op=0x11 LD32S           fetch=0x4f8e0 line=16294  r1 = load_i32? [r7 + +0x36c] ; int32 load/sign-extend style
0302 br@0x4f914 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x71056609f4 word=0x34c00b11 op=0x11 LD32S           fetch=0x4ce64 line=16312  r1 = load_i32? [r7 + +0x36c] ; int32 load/sign-extend style
0303 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x71056609f8 word=0x0c1a87f4 op=0x34 OP34            fetch=0x4f5d8 line=16379  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0304 br@0x4f608 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x71056609f8 word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=16416  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0305 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x71056609fc word=0x610388b0 op=0x30 ST64            fetch=0x53330 line=16475  store64? [r9 + -0x79de], r4 ; 64-bit store *(addr)=reg style
0306 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a00 word=0x10640391 op=0x11 LD32S           fetch=0x4ce64 line=16534  r5 = load_i32? [r4 + +0x10e] ; int32 load/sign-extend style
0307 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660a04 word=0x80c83e98 op=0x18 OR_IMM          fetch=0x4e194 line=16601  r9 = r7 | 0x383a ; register OR immediate-style op
0308 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a04 word=0x80c83e98 op=0x18 OR_IMM          fetch=0x54a20 line=16615  r9 = r7 | 0x383a ; register OR immediate-style op
0309 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a08 word=0x00400118 op=0x18 OR_IMM          fetch=0x54a20 line=16670  r1 = r3 | 0x0004 ; register OR immediate-style op
0310 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x7105660a0c word=0x00410014 op=0x14 BR_COND         fetch=0x54028 line=16726  branch_cond? delta=+0x0 src=r3 cmp=r2 ; conditional VM branch / VM-PC control
0311 br@0x54224 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a10 word=0x0004019a op=0x1a CONV            fetch=0x561b8 line=16821  convert? dst=r5 src=r1 sub6=0x06 ; integer/float conversion family
0312 br@0x56290 -> 0x531e4 OP34/op34 (primary op34 handler)           vm_pc=0x7105660a14 word=0x0c1a87f4 op=0x34 OP34            fetch=0x53244 line=16900  op34? r16=r27 r21=r1 lo12=0x7f4 imm16=0x80df ; unknown/no-op-ish in current reconstruction
0313 br@0x53328 -> 0x5332c ST64/op30 (primary op30 handler)           vm_pc=0x7105660a18 word=0x610188f0 op=0x30 ST64            fetch=0x53330 line=16959  store64? [r9 + -0x79dd], r2 ; 64-bit store *(addr)=reg style
0314 br@0x53408 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a1c word=0x0c240391 op=0x11 LD32S           fetch=0x4ce64 line=17018  r5 = load_i32? [r2 + +0xce] ; int32 load/sign-extend style
0315 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660a20 word=0x008000d8 op=0x18 OR_IMM          fetch=0x4e194 line=17085  r1 = r5 | 0x0003 ; register OR immediate-style op
0316 br@0x4e1c4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a20 word=0x008000d8 op=0x18 OR_IMM          fetch=0x54a20 line=17099  r1 = r5 | 0x0003 ; register OR immediate-style op
0317 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a24 word=0x00400318 op=0x18 OR_IMM          fetch=0x54a20 line=17154  r1 = r3 | 0x000c ; register OR immediate-style op
0318 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a28 word=0x00583898 op=0x18 OR_IMM          fetch=0x54a20 line=17209  r25 = r3 | 0x3022 ; register OR immediate-style op
0319 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a2c word=0x801b339a op=0x1a CONV            fetch=0x561b8 line=17264  convert? dst=r28 src=r1 sub6=0x0e ; integer/float conversion family
0320 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a30 word=0xe01a2b1a op=0x1a CONV            fetch=0x561b8 line=17320  convert? dst=r27 src=r1 sub6=0x2c ; integer/float conversion family
0321 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a34 word=0xc01a289a op=0x1a CONV            fetch=0x561b8 line=17376  convert? dst=r27 src=r1 sub6=0x22 ; integer/float conversion family
0322 br@0x56290 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660a38 word=0xa8ba800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=17455  atomic/ex? dst=r27 src=r6 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0323 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a3c word=0x99800b11 op=0x11 LD32S           fetch=0x4ce64 line=17528  r1 = load_i32? [r13 + +0x9ac] ; int32 load/sign-extend style
0324 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660a40 word=0x25400b11 op=0x11 LD32S           fetch=0x4f5d8 line=17595  r1 = load_i32? [r11 + +0x26c] ; int32 load/sign-extend style
0325 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a40 word=0x25400b11 op=0x11 LD32S           fetch=0x4ce64 line=17612  r1 = load_i32? [r11 + +0x26c] ; int32 load/sign-extend style
0326 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660a44 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=17679  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0327 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a44 word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=17696  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0328 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660a48 word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=17763  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0329 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a48 word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=17780  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0330 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7105660a4c word=0xa89a000f op=0x0f ATOMIC_EX       fetch=0x4f8e0 line=17864  atomic/ex? dst=r27 src=r5 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0331 br@0x4f914 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660a4c word=0xa89a000f op=0x0f ATOMIC_EX       fetch=0x529e4 line=17902  atomic/ex? dst=r27 src=r5 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0332 br@0x52af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a50 word=0x80400198 op=0x18 OR_IMM          fetch=0x54a20 line=17972  r1 = r3 | 0x0806 ; register OR immediate-style op
0333 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a54 word=0x00484098 op=0x18 OR_IMM          fetch=0x54a20 line=18027  r9 = r3 | 0x4002 ; register OR immediate-style op
0334 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a58 word=0x801b291a op=0x1a CONV            fetch=0x561b8 line=18082  convert? dst=r28 src=r1 sub6=0x24 ; integer/float conversion family
0335 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a5c word=0x80980e98 op=0x18 OR_IMM          fetch=0x54a20 line=18138  r25 = r5 | 0x083a ; register OR immediate-style op
0336 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a60 word=0xe01a211a op=0x1a CONV            fetch=0x561b8 line=18193  convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0337 br@0x56290 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a64 word=0x80883698 op=0x18 OR_IMM          fetch=0x54a20 line=18249  r9 = r5 | 0x381a ; register OR immediate-style op
0338 br@0x54af4 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a68 word=0xc01a211a op=0x1a CONV            fetch=0x561b8 line=18304  convert? dst=r27 src=r1 sub6=0x04 ; integer/float conversion family
0339 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a6c word=0xa01b219a op=0x1a CONV            fetch=0x561b8 line=18360  convert? dst=r28 src=r1 sub6=0x06 ; integer/float conversion family
0340 br@0x56290 -> 0x561b4 CONV/op1a (primary op1a handler)           vm_pc=0x7105660a70 word=0x801a209a op=0x1a CONV            fetch=0x561b8 line=18416  convert? dst=r27 src=r1 sub6=0x02 ; integer/float conversion family
0341 br@0x56290 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a74 word=0x27800b11 op=0x11 LD32S           fetch=0x4ce64 line=18475  r1 = load_i32? [r29 + +0x26c] ; int32 load/sign-extend style
0342 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660a78 word=0xcc400b11 op=0x11 LD32S           fetch=0x4f5d8 line=18542  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0343 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a78 word=0xcc400b11 op=0x11 LD32S           fetch=0x4ce64 line=18559  r1 = load_i32? [r3 + +0xcec] ; int32 load/sign-extend style
0344 br@0x4ce94 -> 0x4f500 secondary/unknown target                   vm_pc=0x7105660a7c word=0xc801fc91 op=0x11 LD32S           fetch=0x4f5d8 line=18626  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0345 br@0x4f608 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a7c word=0xc801fc91 op=0x11 LD32S           fetch=0x4ce64 line=18643  r2 = load_i32? [r1 + -0x34e] ; int32 load/sign-extend style
0346 br@0x4ce94 -> 0x4f830 secondary/unknown target                   vm_pc=0x7105660a80 word=0x80501698 op=0x18 OR_IMM          fetch=0x4f8e0 line=18730  r17 = r3 | 0x181a ; register OR immediate-style op
0347 br@0x4f914 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a80 word=0x80501698 op=0x18 OR_IMM          fetch=0x54a20 line=18745  r17 = r3 | 0x181a ; register OR immediate-style op
0348 br@0x54af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660a84 word=0x0c020391 op=0x11 LD32S           fetch=0x4ce64 line=18803  r3 = load_i32? [r1 + +0xce] ; int32 load/sign-extend style
0349 br@0x4ce94 -> 0x4e0bc secondary/unknown target                   vm_pc=0x7105660a88 word=0x1800003b op=0x3b OP3B            fetch=0x4e194 line=18870  op3b? r16=r1 r21=r1 lo12=0x03b imm16=0x0180 ; unknown/no-op-ish in current reconstruction
0350 br@0x4e1c4 -> 0x52d04 OP3B/op3b (primary op3b handler)           vm_pc=0x7105660a88 word=0x1800003b op=0x3b OP3B            fetch=0x52d08 line=18884  op3b? r16=r1 r21=r1 lo12=0x03b imm16=0x0180 ; unknown/no-op-ish in current reconstruction
0351 br@0x52db8 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7105660a8c word=0x90a8d001 op=0x01 OP01            fetch=0x55770 line=18952  op01? r16=r9 r21=r6 lo12=0x001 imm16=0xd900 ; unknown/no-op-ish in current reconstruction
0352 br@0x55858 -> 0x56e70 OP16/op16 (primary op16 handler)           vm_pc=0x7105660a90 word=0x00402016 op=0x16 OP16            fetch=0x56e74 line=19012  op16? r16=r1 r21=r3 lo12=0x016 imm16=0x2000 ; unknown/no-op-ish in current reconstruction
0353 br@0x56f50 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660a94 word=0x81181698 op=0x18 OR_IMM          fetch=0x54a20 line=19069  r25 = r9 | 0x181a ; register OR immediate-style op
0354 br@0x54af4 -> 0x54020 BR_COND/op14 (primary op14 handler)        vm_pc=0x7105660a98 word=0x00c80014 op=0x14 BR_COND         fetch=0x54028 line=19125  branch_cond? delta=+0x0 src=r7 cmp=r9 ; conditional VM branch / VM-PC control
0355 br@0x54224 -> 0x53540 LD64_UNALIGNED/op0d (primary op0d handler) vm_pc=0x7105660a9c word=0x0012400d op=0x0d LD64_UNALIGNED  fetch=0x535a0 line=19243  ld64_unaligned? r16=r19 r21=r1 lo12=0x00d imm16=0x4000 ; unaligned 64-bit load/merge style
0356 br@0x536e0 -> 0x55714 OP01/op01 (primary op01 handler)           vm_pc=0x7105660ab8 word=0x90006001 op=0x01 OP01            fetch=0x55770 line=19347  op01? r16=r1 r21=r1 lo12=0x001 imm16=0x6900 ; unknown/no-op-ish in current reconstruction
0357 br@0x55858 -> 0x56e70 OP16/op16 (primary op16 handler)           vm_pc=0x7105660abc word=0x01002016 op=0x16 OP16            fetch=0x56e74 line=19407  op16? r16=r1 r21=r9 lo12=0x016 imm16=0x2000 ; unknown/no-op-ish in current reconstruction
0358 br@0x56f50 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ac0 word=0x80005ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19464  r1 = r1 | 0x583b ; register OR immediate-style op
0359 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ac4 word=0x80485ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19519  r9 = r3 | 0x583b ; register OR immediate-style op
0360 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ac8 word=0x80905ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19574  r17 = r5 | 0x583b ; register OR immediate-style op
0361 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660acc word=0x80d85ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19629  r25 = r7 | 0x583b ; register OR immediate-style op
0362 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ad0 word=0x810066d8 op=0x18 OR_IMM          fetch=0x54a20 line=19684  r1 = r9 | 0x681b ; register OR immediate-style op
0363 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ad4 word=0x814866d8 op=0x18 OR_IMM          fetch=0x54a20 line=19739  r9 = r11 | 0x681b ; register OR immediate-style op
0364 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ad8 word=0x819066d8 op=0x18 OR_IMM          fetch=0x54a20 line=19794  r17 = r13 | 0x681b ; register OR immediate-style op
0365 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660adc word=0x81d866d8 op=0x18 OR_IMM          fetch=0x54a20 line=19849  r25 = r15 | 0x681b ; register OR immediate-style op
0366 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ae0 word=0x83806ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19904  r1 = r29 | 0x683b ; register OR immediate-style op
0367 br@0x54af4 -> 0x54a1c OR_IMM/op18 (primary op18 handler)         vm_pc=0x7105660ae4 word=0x83c86ed8 op=0x18 OR_IMM          fetch=0x54a20 line=19959  r9 = r31 | 0x683b ; register OR immediate-style op
0368 br@0x54af4 -> 0x52984 ATOMIC_EX/op0f (primary op0f handler)      vm_pc=0x7105660ae8 word=0xe9bb800f op=0x0f ATOMIC_EX       fetch=0x529e4 line=20037  atomic/ex? dst=r28 src=r14 lo12=0x00f ; atomic/exclusive/cmpxchg-like family
0369 br@0x52af4 -> 0x4ce54 LD32S/op11 (primary op11 handler)          vm_pc=0x7105660aec word=0x07c00791 op=0x11 LD32S           fetch=0x4ce64 line=20110  r1 = load_i32? [r31 + +0x5e] ; int32 load/sign-extend style
0370 br@0x4ce94 -> 0x4f860 secondary/unknown target ; no VM word read before next BR


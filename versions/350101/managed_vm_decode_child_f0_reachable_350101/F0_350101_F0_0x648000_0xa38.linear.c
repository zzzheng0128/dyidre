/*
 * Auto-generated linear C-like lift for 350.101 managed program F0.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_20260904/350101_F0_0x648000_0xa38.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F0_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 40 ff ADD64_IMM16: s29 = s29 -0xc0 q1=0xffff2801001f1d1a */
    S[29] = S[29] + (-0xc0);

L_0001:
    /* +0x00018 op=0x25 1d 1f b8 00 ST64: *(s29 +0xb8) = s31 q1=0x180100171d1a */
    *(uint64_t *)((uint8_t *)S[29] + 0xb8) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e b0 00 ST64: *(s29 +0xb0) = s30 q1=0x480080100151d3f */
    *(uint64_t *)((uint8_t *)S[29] + 0xb0) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 a8 00 ST64: *(s29 +0xa8) = s23 q1=0x440380000131d3f */
    *(uint64_t *)((uint8_t *)S[29] + 0xa8) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 a0 00 ST64: *(s29 +0xa0) = s22 q1=0x78280000111d1a */
    *(uint64_t *)((uint8_t *)S[29] + 0xa0) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 98 00 ST64: *(s29 +0x98) = s21 q1=0x48010000030524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x98) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 90 00 ST64: *(s29 +0x90) = s20 q1=0x281f0200001f0524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x90) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 88 00 ST64: *(s29 +0x88) = s19 q1=0x11d0000090524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x88) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 80 00 ST64: *(s29 +0x80) = s18 q1=0x31c0000140524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x80) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 78 00 ST64: *(s29 +0x78) = s17 q1=0x832d0000100524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x78) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 70 00 ST64: *(s29 +0x70) = s16 q1=0x402100000a0524 */
    *(uint64_t *)((uint8_t *)S[29] + 0x70) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 q1=0xf3100001e0524 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x53 04 01 68 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x68 q1=0x125fd468 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd468 + 0x68;

L_000d:
    /* +0x00138 op=0x85 1e 10 10 00 ADD64_IMM16: s16 = s30 +0x10 q1=0x937090000190524 */
    S[16] = S[30] + 0x10;

L_000e:
    /* +0x00150 op=0x85 00 11 00 00 ADD64_IMM16: s17 = s0 +0x0 q1=0x81050000170524 */
    S[17] = S[0] + 0x0;

L_000f:
    /* +0x00168 op=0x85 00 13 58 00 ADD64_IMM16: s19 = s0 +0x58 q1=0x8432500000e0524 */
    S[19] = S[0] + 0x58;

L_0010:
    /* +0x00180 op=0x34 06 00 12 01 OR64: s18 = s6 | s0 q1=0x180000120524 */
    S[18] = S[6] | S[0];

L_0011:
    /* +0x00198 op=0x34 05 00 14 01 OR64: s20 = s5 | s0 q1=0x100000021d3f */
    S[20] = S[5] | S[0];

L_0012:
    /* +0x001b0 op=0x34 04 00 15 01 OR64: s21 = s4 | s0 q1=0x13101f1f113e */
    S[21] = S[4] | S[0];

L_0013:
    /* +0x001c8 op=0x58 01 16 00 00 LD64: s22 = *(uint64_t *)(s1 +0x0) q1=0x180b0b0000 */
    S[22] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0014:
    /* +0x001e0 op=0x53 03 01 78 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x78 q1=0x125fd468 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd468 + 0x78;

L_0015:
    /* +0x001f8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 q1=0x1c0000041d17 */
    S[4] = S[16] | S[0];

L_0016:
    /* +0x00210 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 q1=0x818180000 */
    S[5] = S[17] | S[0];

L_0017:
    /* +0x00228 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 q1=0x811110000 */
    S[6] = S[19] | S[0];

L_0018:
    /* +0x00240 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) q1=0x13081717113e */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0019:
    /* +0x00258 op=0x25 1e 01 08 00 ST64: *(s30 +0x8) = s1 q1=0x80c0c0000 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[1];

L_001a:
    /* +0x00270 op=0x53 01 01 88 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x88 q1=0x125fd468 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd468 + 0x88;

L_001b:
    /* +0x00288 op=0x58 01 17 00 00 LD64: s23 = *(uint64_t *)(s1 +0x0) q1=0x1d010804013e */
    S[23] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_001c:
    /* +0x002a0 op=0x5e 00 00 00 00 CALL_CF_INDEX: call native_binding[index=0x0] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x0, (void *)(uintptr_t)0x125fd420);

L_001d:
    /* +0x002b8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 q1=0x2e00000a0524 */
    S[4] = S[16] | S[0];

L_001e:
    /* +0x002d0 op=0x5e 12 00 00 00 CALL_CF_INDEX: call native_binding[index=0x12] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x12, (void *)(uintptr_t)0x125fd420);

L_001f:
    /* +0x002e8 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 q1=0xc0000011d2b */
    S[4] = S[16] | S[0];

L_0020:
    /* +0x00300 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 q1=0x2500061f0600 */
    S[5] = S[21] | S[0];

L_0021:
    /* +0x00318 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 q1=0x807070000 */
    S[6] = S[20] | S[0];

L_0022:
    /* +0x00330 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd420);

L_0023:
    /* +0x00348 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 q1=0x180000041d2b */
    S[4] = S[16] | S[0];

L_0024:
    /* +0x00360 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 q1=0x240000190524 */
    S[5] = S[18] | S[0];

L_0025:
    /* +0x00378 op=0x5e 14 00 00 00 CALL_CF_INDEX: call native_binding[index=0x14] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x14, (void *)(uintptr_t)0x125fd420);

L_0026:
    /* +0x00390 op=0x5e 01 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x1, (void *)(uintptr_t)0x125fd420);

L_0027:
    /* +0x003a8 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 q1=0x2310121f102c */
    S[20] = S[2] | S[0];

L_0028:
    /* +0x003c0 op=0xb5 00 15 01 00 ADD32_IMM16: s21 = int32(s0 +0x1) q1=0xc00000b0524 */
    S[21] = (int32_t)((uint32_t)S[0] + 0x1);

L_0029:
    /* +0x003d8 op=0x5e 02 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x2, (void *)(uintptr_t)0x125fd420);

L_002a:
    /* +0x003f0 op=0x18 10 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) q1=0x814160000 */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_002b:
    /* +0x00408 op=0xae 01 15 0a 00 BR_EQ64: if (s1 == s21) goto record +54 q1=0x23100101102c */
    if (S[1] == S[21]) goto L_0036;

L_002c:
    /* +0x00420 op=0x5e 03 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x3, (void *)(uintptr_t)0x125fd420);

L_002d:
    /* +0x00438 op=0x18 11 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) q1=0x1e0000010524 */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_002e:
    /* +0x00450 op=0xae 01 15 07 00 BR_EQ64: if (s1 == s21) goto record +54 q1=0x1f011016102c */
    if (S[1] == S[21]) goto L_0036;

L_002f:
    /* +0x00468 op=0x54 02 02 59 f6 CONST_HI16: s2 = sign_extend_32(0xf659 << 16) q1=0x2f0116161e3e */
    S[2] = (int32_t)(0xf659 << 16);

L_0030:
    /* +0x00480 op=0x18 10 14 01 00 SHL32_IMM: s1 = (int32_t)(s20 << 0) q1=0x1f01111e112c */
    S[1] = (int32_t)((uint32_t)S[20] << 0);

L_0031:
    /* +0x00498 op=0x33 02 02 50 08 OR_IMM16: s2 = s2 | 0x850 q1=0x13100a02113e */
    S[2] = S[2] | 0x850;

L_0032:
    /* +0x004b0 op=0xae 01 02 03 00 BR_EQ64: if (s1 == s2) goto record +54 q1=0x400000b0524 */
    if (S[1] == S[2]) goto L_0036;

L_0033:
    /* +0x004c8 op=0x34 12 00 06 01 OR64: s6 = s18 | s0 q1=0x2f01101e103e */
    S[6] = S[18] | S[0];

L_0034:
    /* +0x004e0 op=0x5e 15 00 00 00 CALL_CF_INDEX: call native_binding[index=0x15] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x15, (void *)(uintptr_t)0x125fd420);

L_0035:
    /* +0x004f8 op=0x5f 02 00 00 00 ADD_PC_IMM32: goto record +56 ; vm_pc = current_pc + 1 + 2 q1=0x3b0000160524 */
    goto L_0038;

L_0036:
    /* +0x00510 op=0x34 12 00 06 01 OR64: s6 = s18 | s0 q1=0x20b03062c */
    S[6] = S[18] | S[0];

L_0037:
    /* +0x00528 op=0x5e 16 00 00 00 CALL_CF_INDEX: call native_binding[index=0x16] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x16, (void *)(uintptr_t)0x125fd420);

L_0038:
    /* +0x00540 op=0x59 16 01 00 00 LD8U: s1 = *(uint8_t *)(s22 +0x0) q1=0x2f01140b143e */
    S[1] = *(uint8_t *)((uint8_t *)S[22] + 0x0);

L_0039:
    /* +0x00558 op=0xae 01 00 03 00 BR_EQ64: if (s1 == s0) goto record +61 q1=0x23100e0b102c */
    if (S[1] == S[0]) goto L_003d;

L_003a:
    /* +0x00570 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) q1=0x1a0000010524 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_003b:
    /* +0x00588 op=0x52 01 02 00 00 LD32S: s2 = *(int32_t *)(s1 +0x0) q1=0x60000090524 */
    S[2] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_003c:
    /* +0x005a0 op=0x5f 17 00 00 00 ADD_PC_IMM32: goto record +84 ; vm_pc = current_pc + 1 + 23 q1=0x3e0000190524 */
    goto L_0054;

L_003d:
    /* +0x005b8 op=0x52 17 02 00 00 LD32S: s2 = *(int32_t *)(s23 +0x0) q1=0x2f0103010c3e */
    S[2] = *(int32_t *)((uint8_t *)S[23] + 0x0);

L_003e:
    /* +0x005d0 op=0xa7 02 00 0f 00 BR_NE64: if (s2 != s0) goto record +78 q1=0x1009090000 */
    if (S[2] != S[0]) goto L_004e;

L_003f:
    /* +0x005e8 op=0x85 1e 04 68 00 ADD64_IMM16: s4 = s30 +0x68 q1=0x13100c0c113e */
    S[4] = S[30] + 0x68;

L_0040:
    /* +0x00600 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd420);

L_0041:
    /* +0x00618 op=0x58 1e 01 68 00 LD64: s1 = *(uint64_t *)(s30 +0x68) q1=0x4683d00000c0524 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x68);

L_0042:
    /* +0x00630 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) q1=0x25d0e0000020524 */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0043:
    /* +0x00648 op=0x58 01 02 f0 01 LD64: s2 = *(uint64_t *)(s1 +0x1f0) q1=0x2a12f011e1e0c3e */
    S[2] = *(uint64_t *)((uint8_t *)S[1] + 0x1f0);

L_0044:
    /* +0x00660 op=0x58 01 01 e8 01 LD64: s1 = *(uint64_t *)(s1 +0x1e8) q1=0x64923100202102c */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x1e8);

L_0045:
    /* +0x00678 op=0x13 01 02 04 0f CMP_LO64: s4 = ((uint64_t)s1 < (uint64_t)s2) ? 1 : 0 q1=0x49825000c091700 */
    S[4] = ((uint64_t)S[1] < (uint64_t)S[2]) ? 1 : 0;

L_0046:
    /* +0x00690 op=0x64 01 02 03 02 SUB64: s3 = s1 - s2 q1=0x5ac0250002021800 */
    S[3] = S[1] - S[2];

L_0047:
    /* +0x006a8 op=0x64 02 01 01 12 SUB64: s1 = s2 - s1 q1=0xc6002f0119191e3e */
    S[1] = S[2] - S[1];

L_0048:
    /* +0x006c0 op=0x18 00 04 04 00 SHL32_IMM: s4 = (int32_t)(s4 << 0) q1=0x63001f0000080524 */
    S[4] = (int32_t)((uint32_t)S[4] << 0);

L_0049:
    /* +0x006d8 op=0x1f 03 04 03 00 CMOVZ64: s3 = (s4 == 0) ? s3 : 0 q1=0x9ce5001018180000 */
    S[3] = (S[4] == 0) ? S[3] : 0;

L_004a:
    /* +0x006f0 op=0x1e 01 04 01 00 CMOVNZ64: s1 = (s4 != 0) ? s1 : 0 q1=0x4c230000090524 */
    S[1] = (S[4] != 0) ? S[1] : 0;

L_004b:
    /* +0x00708 op=0x34 01 03 01 00 OR64: s1 = s1 | s3 q1=0x2d03700000f0524 */
    S[1] = S[1] | S[3];

L_004c:
    /* +0x00720 op=0x18 00 01 02 00 SHL32_IMM: s2 = (int32_t)(s1 << 0) q1=0x3daf330000080524 */
    S[2] = (int32_t)((uint32_t)S[1] << 0);

L_004d:
    /* +0x00738 op=0x08 17 02 00 00 ST32: *(s23 +0x0) = (uint32_t)s2 q1=0x2cc0b0000010524 */
    *(uint32_t *)((uint8_t *)S[23] + 0x0) = (uint32_t)S[2];

L_004e:
    /* +0x00750 op=0xb5 00 01 10 00 ADD32_IMM16: s1 = int32(s0 +0x10) q1=0x8631f010916072c */
    S[1] = (int32_t)((uint32_t)S[0] + 0x10);

L_004f:
    /* +0x00768 op=0x02 02 01 01 00 XOR64: s1 = s1 ^ s2 q1=0x859f23180f0f102c */
    S[1] = S[1] ^ S[2];

L_0050:
    /* +0x00780 op=0x14 01 02 01 00 CMP_LO_IMM64: s2 = ((uint64_t)s1 < (uint64_t)1) ? 1 : 0 q1=0x509325000f0f0d00 */
    S[2] = ((uint64_t)S[1] < (uint64_t)0x1) ? 1 : 0;

L_0051:
    /* +0x00798 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) q1=0x52af2f011218123e */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_0052:
    /* +0x007b0 op=0x08 01 02 00 00 ST32: *(s1 +0x0) = (uint32_t)s2 q1=0x2d4001816070000 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[2];

L_0053:
    /* +0x007c8 op=0x26 16 15 00 00 ST8: *(s22 +0x0) = (uint8_t)s21 q1=0x5a13181e07113e */
    *(uint8_t *)((uint8_t *)S[22] + 0x0) = (uint8_t)S[21];

L_0054:
    /* +0x007e0 op=0x02 02 15 01 00 XOR64: s1 = s21 ^ s2 q1=0x186f23180707102c */
    S[1] = S[21] ^ S[2];

L_0055:
    /* +0x007f8 op=0x59 12 02 10 00 LD8U: s2 = *(uint8_t *)(s18 +0x10) q1=0x30a0018100d0000 */
    S[2] = *(uint8_t *)((uint8_t *)S[18] + 0x10);

L_0056:
    /* +0x00810 op=0x13 00 01 01 0f CMP_LO64: s1 = ((uint64_t)s0 < (uint64_t)s1) ? 1 : 0 q1=0xf7af25001e160e00 */
    S[1] = ((uint64_t)S[0] < (uint64_t)S[1]) ? 1 : 0;

L_0057:
    /* +0x00828 op=0x18 00 01 01 05 SHL32_IMM: s1 = (int32_t)(s1 << 5) q1=0x10a53f00000a0524 */
    S[1] = (int32_t)((uint32_t)S[1] << 5);

L_0058:
    /* +0x00840 op=0xb2 02 02 df 00 AND64_IMM16: s2 = s2 & 0xdf q1=0xc600170000030524 */
    S[2] = S[2] & 0xdf;

L_0059:
    /* +0x00858 op=0x34 02 01 01 00 OR64: s1 = s2 | s1 q1=0x23313180e01113e */
    S[1] = S[2] | S[1];

L_005a:
    /* +0x00870 op=0x26 12 01 10 00 ST8: *(s18 +0x10) = (uint8_t)s1 q1=0x7be323180a0a102c */
    *(uint8_t *)((uint8_t *)S[18] + 0x10) = (uint8_t)S[1];

L_005b:
    /* +0x00888 op=0xae 11 13 04 00 BR_EQ64: if (s17 == s19) goto record +96 q1=0xb1c03519131f123e */
    if (S[17] == S[19]) goto L_0060;

L_005c:
    /* +0x008a0 op=0x84 10 11 01 00 ADD64: s1 = s16 + s17 q1=0x8340001803030000 */
    S[1] = S[16] + S[17];

L_005d:
    /* +0x008b8 op=0x85 11 11 01 00 ADD64_IMM16: s17 = s17 +0x1 q1=0xd713181801113e */
    S[17] = S[17] + 0x1;

L_005e:
    /* +0x008d0 op=0x26 01 00 00 00 ST8: *(s1 +0x0) = (uint8_t)s0 q1=0x9ff52f011003143e */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[0];

L_005f:
    /* +0x008e8 op=0xa7 11 13 fc ff BR_NE64: if (s17 != s19) goto record +92 q1=0x80ef241f0805020f */
    if (S[17] != S[19]) goto L_005c;

L_0060:
    /* +0x00900 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 q1=0xe8b5070819140526 */
    S[29] = S[30] | S[0];

L_0061:
    /* +0x00918 op=0x58 1d 10 70 00 LD64: s16 = *(uint64_t *)(s29 +0x70) q1=0xbfc035061d02000f */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x70);

L_0062:
    /* +0x00930 op=0x58 1d 11 78 00 LD64: s17 = *(uint64_t *)(s29 +0x78) q1=0xb5e123180101102c */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x78);

L_0063:
    /* +0x00948 op=0x58 1d 12 80 00 LD64: s18 = *(uint64_t *)(s29 +0x80) q1=0x18c21e1304181826 */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x80);

L_0064:
    /* +0x00960 op=0x58 1d 13 88 00 LD64: s19 = *(uint64_t *)(s29 +0x88) q1=0x55210002171f132c */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x88);

L_0065:
    /* +0x00978 op=0x58 1d 14 90 00 LD64: s20 = *(uint64_t *)(s29 +0x90) q1=0xce701e011613172c */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x90);

L_0066:
    /* +0x00990 op=0x58 1d 15 98 00 LD64: s21 = *(uint64_t *)(s29 +0x98) q1=0x128030121915093e */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x98);

L_0067:
    /* +0x009a8 op=0x58 1d 16 a0 00 LD64: s22 = *(uint64_t *)(s29 +0xa0) q1=0xc621210016170700 */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0xa0);

L_0068:
    /* +0x009c0 op=0x58 1d 17 a8 00 LD64: s23 = *(uint64_t *)(s29 +0xa8) q1=0xca9d210019040f00 */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0xa8);

L_0069:
    /* +0x009d8 op=0x58 1d 1e b0 00 LD64: s30 = *(uint64_t *)(s29 +0xb0) q1=0xae73301203030a3e */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0xb0);

L_006a:
    /* +0x009f0 op=0x58 1d 1f b8 00 LD64: s31 = *(uint64_t *)(s29 +0xb8) q1=0x5500021403030100 */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0xb8);

L_006b:
    /* +0x00a08 op=0x85 1d 1d c0 00 ADD64_IMM16: s29 = s29 +0xc0 q1=0x50c024000a0a0300 */
    S[29] = S[29] + 0xc0;

L_006c:
    /* +0x00a20 op=0x5b 1f 00 00 00 RET: return/leave with s31 q1=0x164021000a0a1900 */
    return; /* RET s31 */

}

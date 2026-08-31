/*
 * Auto-generated linear C-like lift for 350.101 managed program F29.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F29_0x731000_0xe70.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F29_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 90 ff ADD64_IMM16: s29 = s29 -0x70 */
    S[29] = S[29] + (-0x70);

L_0001:
    /* +0x00018 op=0x25 1d 1f 68 00 ST64: *(s29 +0x68) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x68) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 60 00 ST64: *(s29 +0x60) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x60) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 58 00 ST64: *(s29 +0x58) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x58) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 50 00 ST64: *(s29 +0x50) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x50) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 48 00 ST64: *(s29 +0x48) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x48) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 40 00 ST64: *(s29 +0x40) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x40) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 38 00 ST64: *(s29 +0x38) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x38) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 30 00 ST64: *(s29 +0x30) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x30) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 28 00 ST64: *(s29 +0x28) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 20 00 ST64: *(s29 +0x20) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x25 1e 04 08 00 ST64: *(s30 +0x8) = s4 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[4];

L_000d:
    /* +0x00138 op=0x85 04 02 01 00 ADD64_IMM16: s2 = s4 +0x1 */
    S[2] = S[4] + 0x1;

L_000e:
    /* +0x00150 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 */
    S[3] = S[0] + 0x0;

L_000f:
    /* +0x00168 op=0x85 00 04 10 00 ADD64_IMM16: s4 = s0 +0x10 */
    S[4] = S[0] + 0x10;

L_0010:
    /* +0x00180 op=0x85 1e 16 10 00 ADD64_IMM16: s22 = s30 +0x10 */
    S[22] = S[30] + 0x10;

L_0011:
    /* +0x00198 op=0xae 03 04 0c 00 BR_EQ64: if (s3 == s4) goto record +30 */
    if (S[3] == S[4]) goto L_001e;

L_0012:
    /* +0x001b0 op=0x84 02 03 05 14 ADD64: s5 = s2 + s3 */
    S[5] = S[2] + S[3];

L_0013:
    /* +0x001c8 op=0x84 16 03 01 00 ADD64: s1 = s22 + s3 */
    S[1] = S[22] + S[3];

L_0014:
    /* +0x001e0 op=0x85 03 03 04 00 ADD64_IMM16: s3 = s3 +0x4 */
    S[3] = S[3] + 0x4;

L_0015:
    /* +0x001f8 op=0x59 05 06 ff ff LD8U: s6 = *(uint8_t *)(s5 -0x1) */
    S[6] = *(uint8_t *)((uint8_t *)S[5] + (-0x1));

L_0016:
    /* +0x00210 op=0x26 01 06 01 00 ST8: *(s1 +0x1) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[1] + 0x1) = (uint8_t)S[6];

L_0017:
    /* +0x00228 op=0x59 05 06 00 00 LD8U: s6 = *(uint8_t *)(s5 +0x0) */
    S[6] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0018:
    /* +0x00240 op=0x26 01 06 03 00 ST8: *(s1 +0x3) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[1] + 0x3) = (uint8_t)S[6];

L_0019:
    /* +0x00258 op=0x59 05 06 01 00 LD8U: s6 = *(uint8_t *)(s5 +0x1) */
    S[6] = *(uint8_t *)((uint8_t *)S[5] + 0x1);

L_001a:
    /* +0x00270 op=0x26 01 06 00 00 ST8: *(s1 +0x0) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[6];

L_001b:
    /* +0x00288 op=0x59 05 05 02 00 LD8U: s5 = *(uint8_t *)(s5 +0x2) */
    S[5] = *(uint8_t *)((uint8_t *)S[5] + 0x2);

L_001c:
    /* +0x002a0 op=0x26 01 05 02 00 ST8: *(s1 +0x2) = (uint8_t)s5 */
    *(uint8_t *)((uint8_t *)S[1] + 0x2) = (uint8_t)S[5];

L_001d:
    /* +0x002b8 op=0xa7 03 04 f4 ff BR_NE64: if (s3 != s4) goto record +18 */
    if (S[3] != S[4]) goto L_0012;

L_001e:
    /* +0x002d0 op=0x85 00 11 00 00 ADD64_IMM16: s17 = s0 +0x0 */
    S[17] = S[0] + 0x0;

L_001f:
    /* +0x002e8 op=0x85 00 17 04 00 ADD64_IMM16: s23 = s0 +0x4 */
    S[23] = S[0] + 0x4;

L_0020:
    /* +0x00300 op=0x85 00 13 01 00 ADD64_IMM16: s19 = s0 +0x1 */
    S[19] = S[0] + 0x1;

L_0021:
    /* +0x00318 op=0xae 11 17 18 00 BR_EQ64: if (s17 == s23) goto record +58 */
    if (S[17] == S[23]) goto L_003a;

L_0022:
    /* +0x00330 op=0x84 16 11 12 14 ADD64: s18 = s22 + s17 */
    S[18] = S[22] + S[17];

L_0023:
    /* +0x00348 op=0x85 00 04 02 00 ADD64_IMM16: s4 = s0 +0x2 */
    S[4] = S[0] + 0x2;

L_0024:
    /* +0x00360 op=0x5a 12 05 00 00 LD8S: s5 = *(int8_t *)(s18 +0x0) */
    S[5] = *(int8_t *)((uint8_t *)S[18] + 0x0);

L_0025:
    /* +0x00378 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0026:
    /* +0x00390 op=0x5a 12 05 04 00 LD8S: s5 = *(int8_t *)(s18 +0x4) */
    S[5] = *(int8_t *)((uint8_t *)S[18] + 0x4);

L_0027:
    /* +0x003a8 op=0x85 00 04 03 00 ADD64_IMM16: s4 = s0 +0x3 */
    S[4] = S[0] + 0x3;

L_0028:
    /* +0x003c0 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_0029:
    /* +0x003d8 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_002a:
    /* +0x003f0 op=0x5a 12 05 08 00 LD8S: s5 = *(int8_t *)(s18 +0x8) */
    S[5] = *(int8_t *)((uint8_t *)S[18] + 0x8);

L_002b:
    /* +0x00408 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_002c:
    /* +0x00420 op=0x34 02 00 15 01 OR64: s21 = s2 | s0 */
    S[21] = S[2] | S[0];

L_002d:
    /* +0x00438 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_002e:
    /* +0x00450 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_002f:
    /* +0x00468 op=0x5a 12 05 0c 00 LD8S: s5 = *(int8_t *)(s18 +0xc) */
    S[5] = *(int8_t *)((uint8_t *)S[18] + 0xc);

L_0030:
    /* +0x00480 op=0x85 11 10 01 00 ADD64_IMM16: s16 = s17 +0x1 */
    S[16] = S[17] + 0x1;

L_0031:
    /* +0x00498 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0032:
    /* +0x004b0 op=0x84 01 11 11 04 ADD64: s17 = s1 + s17 */
    S[17] = S[1] + S[17];

L_0033:
    /* +0x004c8 op=0x02 15 14 01 01 XOR64: s1 = s20 ^ s21 */
    S[1] = S[20] ^ S[21];

L_0034:
    /* +0x004e0 op=0x02 01 02 14 00 XOR64: s20 = s2 ^ s1 */
    S[20] = S[2] ^ S[1];

L_0035:
    /* +0x004f8 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0036:
    /* +0x00510 op=0x02 14 02 01 00 XOR64: s1 = s2 ^ s20 */
    S[1] = S[2] ^ S[20];

L_0037:
    /* +0x00528 op=0x26 11 01 00 00 ST8: *(s17 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[17] + 0x0) = (uint8_t)S[1];

L_0038:
    /* +0x00540 op=0x34 10 00 11 01 OR64: s17 = s16 | s0 */
    S[17] = S[16] | S[0];

L_0039:
    /* +0x00558 op=0xa7 11 17 e8 ff BR_NE64: if (s17 != s23) goto record +34 */
    if (S[17] != S[23]) goto L_0022;

L_003a:
    /* +0x00570 op=0x85 00 11 01 00 ADD64_IMM16: s17 = s0 +0x1 */
    S[17] = S[0] + 0x1;

L_003b:
    /* +0x00588 op=0x85 00 13 03 00 ADD64_IMM16: s19 = s0 +0x3 */
    S[19] = S[0] + 0x3;

L_003c:
    /* +0x005a0 op=0x85 00 01 08 00 ADD64_IMM16: s1 = s0 +0x8 */
    S[1] = S[0] + 0x8;

L_003d:
    /* +0x005b8 op=0xae 17 01 18 00 BR_EQ64: if (s23 == s1) goto record +86 */
    if (S[23] == S[1]) goto L_0056;

L_003e:
    /* +0x005d0 op=0x84 16 17 10 04 ADD64: s16 = s22 + s23 */
    S[16] = S[22] + S[23];

L_003f:
    /* +0x005e8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0040:
    /* +0x00600 op=0x5a 10 05 fc ff LD8S: s5 = *(int8_t *)(s16 -0x4) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + (-0x4));

L_0041:
    /* +0x00618 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0042:
    /* +0x00630 op=0x5a 10 05 00 00 LD8S: s5 = *(int8_t *)(s16 +0x0) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x0);

L_0043:
    /* +0x00648 op=0x85 00 04 02 00 ADD64_IMM16: s4 = s0 +0x2 */
    S[4] = S[0] + 0x2;

L_0044:
    /* +0x00660 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_0045:
    /* +0x00678 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0046:
    /* +0x00690 op=0x5a 10 05 04 00 LD8S: s5 = *(int8_t *)(s16 +0x4) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x4);

L_0047:
    /* +0x006a8 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0048:
    /* +0x006c0 op=0x34 02 00 15 00 OR64: s21 = s2 | s0 */
    S[21] = S[2] | S[0];

L_0049:
    /* +0x006d8 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_004a:
    /* +0x006f0 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_004b:
    /* +0x00708 op=0x5a 10 05 08 00 LD8S: s5 = *(int8_t *)(s16 +0x8) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x8);

L_004c:
    /* +0x00720 op=0x85 17 12 01 00 ADD64_IMM16: s18 = s23 +0x1 */
    S[18] = S[23] + 0x1;

L_004d:
    /* +0x00738 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_004e:
    /* +0x00750 op=0x84 01 17 17 04 ADD64: s23 = s1 + s23 */
    S[23] = S[1] + S[23];

L_004f:
    /* +0x00768 op=0x02 15 14 01 00 XOR64: s1 = s20 ^ s21 */
    S[1] = S[20] ^ S[21];

L_0050:
    /* +0x00780 op=0x02 01 02 14 00 XOR64: s20 = s2 ^ s1 */
    S[20] = S[2] ^ S[1];

L_0051:
    /* +0x00798 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0052:
    /* +0x007b0 op=0x02 14 02 01 00 XOR64: s1 = s2 ^ s20 */
    S[1] = S[2] ^ S[20];

L_0053:
    /* +0x007c8 op=0x26 17 01 00 00 ST8: *(s23 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[23] + 0x0) = (uint8_t)S[1];

L_0054:
    /* +0x007e0 op=0x34 12 00 17 01 OR64: s23 = s18 | s0 */
    S[23] = S[18] | S[0];

L_0055:
    /* +0x007f8 op=0x5f e6 ff ff ff ADD_PC_IMM32: goto record +60 ; vm_pc = current_pc + 1 + -26 */
    goto L_003c;

L_0056:
    /* +0x00810 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_0057:
    /* +0x00828 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_0058:
    /* +0x00840 op=0x85 00 15 04 00 ADD64_IMM16: s21 = s0 +0x4 */
    S[21] = S[0] + 0x4;

L_0059:
    /* +0x00858 op=0x85 00 11 01 00 ADD64_IMM16: s17 = s0 +0x1 */
    S[17] = S[0] + 0x1;

L_005a:
    /* +0x00870 op=0x85 01 17 08 00 ADD64_IMM16: s23 = s1 +0x8 */
    S[23] = S[1] + 0x8;

L_005b:
    /* +0x00888 op=0xae 12 15 16 00 BR_EQ64: if (s18 == s21) goto record +114 */
    if (S[18] == S[21]) goto L_0072;

L_005c:
    /* +0x008a0 op=0x84 16 12 10 00 ADD64: s16 = s22 + s18 */
    S[16] = S[22] + S[18];

L_005d:
    /* +0x008b8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_005e:
    /* +0x008d0 op=0x5a 10 05 00 00 LD8S: s5 = *(int8_t *)(s16 +0x0) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x0);

L_005f:
    /* +0x008e8 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0060:
    /* +0x00900 op=0x5a 10 05 04 00 LD8S: s5 = *(int8_t *)(s16 +0x4) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x4);

L_0061:
    /* +0x00918 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0062:
    /* +0x00930 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_0063:
    /* +0x00948 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0064:
    /* +0x00960 op=0x5a 10 05 08 00 LD8S: s5 = *(int8_t *)(s16 +0x8) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x8);

L_0065:
    /* +0x00978 op=0x85 00 04 02 00 ADD64_IMM16: s4 = s0 +0x2 */
    S[4] = S[0] + 0x2;

L_0066:
    /* +0x00990 op=0x85 12 13 01 00 ADD64_IMM16: s19 = s18 +0x1 */
    S[19] = S[18] + 0x1;

L_0067:
    /* +0x009a8 op=0x84 17 12 12 14 ADD64: s18 = s23 + s18 */
    S[18] = S[23] + S[18];

L_0068:
    /* +0x009c0 op=0x02 02 14 14 01 XOR64: s20 = s20 ^ s2 */
    S[20] = S[20] ^ S[2];

L_0069:
    /* +0x009d8 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_006a:
    /* +0x009f0 op=0x5a 10 05 0c 00 LD8S: s5 = *(int8_t *)(s16 +0xc) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0xc);

L_006b:
    /* +0x00a08 op=0x85 00 04 03 00 ADD64_IMM16: s4 = s0 +0x3 */
    S[4] = S[0] + 0x3;

L_006c:
    /* +0x00a20 op=0x02 14 02 14 01 XOR64: s20 = s2 ^ s20 */
    S[20] = S[2] ^ S[20];

L_006d:
    /* +0x00a38 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_006e:
    /* +0x00a50 op=0x02 14 02 01 01 XOR64: s1 = s2 ^ s20 */
    S[1] = S[2] ^ S[20];

L_006f:
    /* +0x00a68 op=0x26 12 01 00 00 ST8: *(s18 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[18] + 0x0) = (uint8_t)S[1];

L_0070:
    /* +0x00a80 op=0x34 13 00 12 00 OR64: s18 = s19 | s0 */
    S[18] = S[19] | S[0];

L_0071:
    /* +0x00a98 op=0xa7 12 15 ea ff BR_NE64: if (s18 != s21) goto record +92 */
    if (S[18] != S[21]) goto L_005c;

L_0072:
    /* +0x00ab0 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_0073:
    /* +0x00ac8 op=0x85 00 17 00 00 ADD64_IMM16: s23 = s0 +0x0 */
    S[23] = S[0] + 0x0;

L_0074:
    /* +0x00ae0 op=0x85 00 11 01 00 ADD64_IMM16: s17 = s0 +0x1 */
    S[17] = S[0] + 0x1;

L_0075:
    /* +0x00af8 op=0x85 01 14 0c 00 ADD64_IMM16: s20 = s1 +0xc */
    S[20] = S[1] + 0xc;

L_0076:
    /* +0x00b10 op=0xae 17 15 16 00 BR_EQ64: if (s23 == s21) goto record +141 */
    if (S[23] == S[21]) goto L_008d;

L_0077:
    /* +0x00b28 op=0x84 16 17 10 00 ADD64: s16 = s22 + s23 */
    S[16] = S[22] + S[23];

L_0078:
    /* +0x00b40 op=0x85 00 04 03 00 ADD64_IMM16: s4 = s0 +0x3 */
    S[4] = S[0] + 0x3;

L_0079:
    /* +0x00b58 op=0x5a 10 05 00 00 LD8S: s5 = *(int8_t *)(s16 +0x0) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x0);

L_007a:
    /* +0x00b70 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_007b:
    /* +0x00b88 op=0x5a 10 05 04 00 LD8S: s5 = *(int8_t *)(s16 +0x4) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x4);

L_007c:
    /* +0x00ba0 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_007d:
    /* +0x00bb8 op=0x34 02 00 13 01 OR64: s19 = s2 | s0 */
    S[19] = S[2] | S[0];

L_007e:
    /* +0x00bd0 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_007f:
    /* +0x00be8 op=0x5a 10 05 08 00 LD8S: s5 = *(int8_t *)(s16 +0x8) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0x8);

L_0080:
    /* +0x00c00 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0081:
    /* +0x00c18 op=0x85 17 12 01 00 ADD64_IMM16: s18 = s23 +0x1 */
    S[18] = S[23] + 0x1;

L_0082:
    /* +0x00c30 op=0x84 14 17 17 14 ADD64: s23 = s20 + s23 */
    S[23] = S[20] + S[23];

L_0083:
    /* +0x00c48 op=0x02 02 13 13 00 XOR64: s19 = s19 ^ s2 */
    S[19] = S[19] ^ S[2];

L_0084:
    /* +0x00c60 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0085:
    /* +0x00c78 op=0x5a 10 05 0c 00 LD8S: s5 = *(int8_t *)(s16 +0xc) */
    S[5] = *(int8_t *)((uint8_t *)S[16] + 0xc);

L_0086:
    /* +0x00c90 op=0x85 00 04 02 00 ADD64_IMM16: s4 = s0 +0x2 */
    S[4] = S[0] + 0x2;

L_0087:
    /* +0x00ca8 op=0x02 13 02 13 00 XOR64: s19 = s2 ^ s19 */
    S[19] = S[2] ^ S[19];

L_0088:
    /* +0x00cc0 op=0x5e 8b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8b, (void *)(uintptr_t)0x125fd3c0);

L_0089:
    /* +0x00cd8 op=0x02 13 02 01 01 XOR64: s1 = s2 ^ s19 */
    S[1] = S[2] ^ S[19];

L_008a:
    /* +0x00cf0 op=0x26 17 01 00 00 ST8: *(s23 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[23] + 0x0) = (uint8_t)S[1];

L_008b:
    /* +0x00d08 op=0x34 12 00 17 01 OR64: s23 = s18 | s0 */
    S[23] = S[18] | S[0];

L_008c:
    /* +0x00d20 op=0xa7 17 15 ea ff BR_NE64: if (s23 != s21) goto record +119 */
    if (S[23] != S[21]) goto L_0077;

L_008d:
    /* +0x00d38 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_008e:
    /* +0x00d50 op=0x58 1d 10 20 00 LD64: s16 = *(uint64_t *)(s29 +0x20) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_008f:
    /* +0x00d68 op=0x58 1d 11 28 00 LD64: s17 = *(uint64_t *)(s29 +0x28) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_0090:
    /* +0x00d80 op=0x58 1d 12 30 00 LD64: s18 = *(uint64_t *)(s29 +0x30) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x30);

L_0091:
    /* +0x00d98 op=0x58 1d 13 38 00 LD64: s19 = *(uint64_t *)(s29 +0x38) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x38);

L_0092:
    /* +0x00db0 op=0x58 1d 14 40 00 LD64: s20 = *(uint64_t *)(s29 +0x40) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x40);

L_0093:
    /* +0x00dc8 op=0x58 1d 15 48 00 LD64: s21 = *(uint64_t *)(s29 +0x48) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x48);

L_0094:
    /* +0x00de0 op=0x58 1d 16 50 00 LD64: s22 = *(uint64_t *)(s29 +0x50) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x50);

L_0095:
    /* +0x00df8 op=0x58 1d 17 58 00 LD64: s23 = *(uint64_t *)(s29 +0x58) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x58);

L_0096:
    /* +0x00e10 op=0x58 1d 1e 60 00 LD64: s30 = *(uint64_t *)(s29 +0x60) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x60);

L_0097:
    /* +0x00e28 op=0x58 1d 1f 68 00 LD64: s31 = *(uint64_t *)(s29 +0x68) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x68);

L_0098:
    /* +0x00e40 op=0x85 1d 1d 70 00 ADD64_IMM16: s29 = s29 +0x70 */
    S[29] = S[29] + 0x70;

L_0099:
    /* +0x00e58 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

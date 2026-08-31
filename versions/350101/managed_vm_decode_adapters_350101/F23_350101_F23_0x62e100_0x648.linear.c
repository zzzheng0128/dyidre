/*
 * Auto-generated linear C-like lift for 350.101 managed program F23.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_adapters_350101_20260831_053000/350101_F23_0x62e100_0x648.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F23_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d b0 ff ADD64_IMM16: s29 = s29 -0x50 */
    S[29] = S[29] + (-0x50);

L_0001:
    /* +0x00018 op=0x25 1d 1f 48 00 ST64: *(s29 +0x48) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x48) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 40 00 ST64: *(s29 +0x40) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x40) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 38 00 ST64: *(s29 +0x38) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x38) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 30 00 ST64: *(s29 +0x30) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x30) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 28 00 ST64: *(s29 +0x28) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 20 00 ST64: *(s29 +0x20) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 18 00 ST64: *(s29 +0x18) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 10 00 ST64: *(s29 +0x10) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 08 00 ST64: *(s29 +0x8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 00 00 ST64: *(s29 +0x0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x85 04 13 b0 00 ADD64_IMM16: s19 = s4 +0xb0 */
    S[19] = S[4] + 0xb0;

L_000d:
    /* +0x00138 op=0x85 00 15 00 00 ADD64_IMM16: s21 = s0 +0x0 */
    S[21] = S[0] + 0x0;

L_000e:
    /* +0x00150 op=0x34 06 00 10 01 OR64: s16 = s6 | s0 */
    S[16] = S[6] | S[0];

L_000f:
    /* +0x00168 op=0x34 04 00 11 00 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_0010:
    /* +0x00180 op=0x85 04 14 10 00 ADD64_IMM16: s20 = s4 +0x10 */
    S[20] = S[4] + 0x10;

L_0011:
    /* +0x00198 op=0x85 00 16 10 00 ADD64_IMM16: s22 = s0 +0x10 */
    S[22] = S[0] + 0x10;

L_0012:
    /* +0x001b0 op=0x34 15 00 17 00 OR64: s23 = s21 | s0 */
    S[23] = S[21] | S[0];

L_0013:
    /* +0x001c8 op=0x34 13 00 02 01 OR64: s2 = s19 | s0 */
    S[2] = S[19] | S[0];

L_0014:
    /* +0x001e0 op=0x13 17 10 01 0f CMP_LO64: s1 = ((uint64_t)s23 < (uint64_t)s16) ? 1 : 0 */
    S[1] = ((uint64_t)S[23] < (uint64_t)S[16]) ? 1 : 0;

L_0015:
    /* +0x001f8 op=0xae 01 00 1c 00 BR_EQ64: if (s1 == s0) goto record +50 */
    if (S[1] == S[0]) goto L_0032;

L_0016:
    /* +0x00210 op=0x34 05 00 12 00 OR64: s18 = s5 | s0 */
    S[18] = S[5] | S[0];

L_0017:
    /* +0x00228 op=0x34 15 00 03 01 OR64: s3 = s21 | s0 */
    S[3] = S[21] | S[0];

L_0018:
    /* +0x00240 op=0xae 03 16 08 00 BR_EQ64: if (s3 == s22) goto record +33 */
    if (S[3] == S[22]) goto L_0021;

L_0019:
    /* +0x00258 op=0x84 02 03 05 00 ADD64: s5 = s2 + s3 */
    S[5] = S[2] + S[3];

L_001a:
    /* +0x00270 op=0x84 12 03 01 00 ADD64: s1 = s18 + s3 */
    S[1] = S[18] + S[3];

L_001b:
    /* +0x00288 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_001c:
    /* +0x002a0 op=0x59 01 04 00 00 LD8U: s4 = *(uint8_t *)(s1 +0x0) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_001d:
    /* +0x002b8 op=0x59 05 05 00 00 LD8U: s5 = *(uint8_t *)(s5 +0x0) */
    S[5] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_001e:
    /* +0x002d0 op=0x02 05 04 04 01 XOR64: s4 = s4 ^ s5 */
    S[4] = S[4] ^ S[5];

L_001f:
    /* +0x002e8 op=0x26 01 04 00 00 ST8: *(s1 +0x0) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[4];

L_0020:
    /* +0x00300 op=0xa7 03 16 f8 ff BR_NE64: if (s3 != s22) goto record +25 */
    if (S[3] != S[22]) goto L_0019;

L_0021:
    /* +0x00318 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0022:
    /* +0x00330 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0023:
    /* +0x00348 op=0x5e 86 00 00 00 CALL_CF_INDEX: call native_binding[index=0x86] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x86, (void *)(uintptr_t)0x125fd3c0);

L_0024:
    /* +0x00360 op=0x34 15 00 02 01 OR64: s2 = s21 | s0 */
    S[2] = S[21] | S[0];

L_0025:
    /* +0x00378 op=0xae 02 16 08 00 BR_EQ64: if (s2 == s22) goto record +46 */
    if (S[2] == S[22]) goto L_002e;

L_0026:
    /* +0x00390 op=0x84 14 02 04 00 ADD64: s4 = s20 + s2 */
    S[4] = S[20] + S[2];

L_0027:
    /* +0x003a8 op=0x84 12 02 01 14 ADD64: s1 = s18 + s2 */
    S[1] = S[18] + S[2];

L_0028:
    /* +0x003c0 op=0x85 02 02 01 00 ADD64_IMM16: s2 = s2 +0x1 */
    S[2] = S[2] + 0x1;

L_0029:
    /* +0x003d8 op=0x59 01 03 00 00 LD8U: s3 = *(uint8_t *)(s1 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_002a:
    /* +0x003f0 op=0x59 04 04 00 00 LD8U: s4 = *(uint8_t *)(s4 +0x0) */
    S[4] = *(uint8_t *)((uint8_t *)S[4] + 0x0);

L_002b:
    /* +0x00408 op=0x02 04 03 03 00 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_002c:
    /* +0x00420 op=0x26 01 03 00 00 ST8: *(s1 +0x0) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[3];

L_002d:
    /* +0x00438 op=0xa7 02 16 f8 ff BR_NE64: if (s2 != s22) goto record +38 */
    if (S[2] != S[22]) goto L_0026;

L_002e:
    /* +0x00450 op=0x85 17 17 10 00 ADD64_IMM16: s23 = s23 +0x10 */
    S[23] = S[23] + 0x10;

L_002f:
    /* +0x00468 op=0x85 12 05 10 00 ADD64_IMM16: s5 = s18 +0x10 */
    S[5] = S[18] + 0x10;

L_0030:
    /* +0x00480 op=0x34 12 00 02 01 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_0031:
    /* +0x00498 op=0x5f e2 ff ff ff ADD_PC_IMM32: goto record +20 ; vm_pc = current_pc + 1 + -30 */
    goto L_0014;

L_0032:
    /* +0x004b0 op=0x58 02 01 00 00 LD64: s1 = *(uint64_t *)(s2 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_0033:
    /* +0x004c8 op=0x58 02 02 08 00 LD64: s2 = *(uint64_t *)(s2 +0x8) */
    S[2] = *(uint64_t *)((uint8_t *)S[2] + 0x8);

L_0034:
    /* +0x004e0 op=0x25 13 02 08 00 ST64: *(s19 +0x8) = s2 */
    *(uint64_t *)((uint8_t *)S[19] + 0x8) = S[2];

L_0035:
    /* +0x004f8 op=0x25 13 01 00 00 ST64: *(s19 +0x0) = s1 */
    *(uint64_t *)((uint8_t *)S[19] + 0x0) = S[1];

L_0036:
    /* +0x00510 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0037:
    /* +0x00528 op=0x58 1d 10 00 00 LD64: s16 = *(uint64_t *)(s29 +0x0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_0038:
    /* +0x00540 op=0x58 1d 11 08 00 LD64: s17 = *(uint64_t *)(s29 +0x8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0039:
    /* +0x00558 op=0x58 1d 12 10 00 LD64: s18 = *(uint64_t *)(s29 +0x10) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_003a:
    /* +0x00570 op=0x58 1d 13 18 00 LD64: s19 = *(uint64_t *)(s29 +0x18) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_003b:
    /* +0x00588 op=0x58 1d 14 20 00 LD64: s20 = *(uint64_t *)(s29 +0x20) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_003c:
    /* +0x005a0 op=0x58 1d 15 28 00 LD64: s21 = *(uint64_t *)(s29 +0x28) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_003d:
    /* +0x005b8 op=0x58 1d 16 30 00 LD64: s22 = *(uint64_t *)(s29 +0x30) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x30);

L_003e:
    /* +0x005d0 op=0x58 1d 17 38 00 LD64: s23 = *(uint64_t *)(s29 +0x38) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x38);

L_003f:
    /* +0x005e8 op=0x58 1d 1e 40 00 LD64: s30 = *(uint64_t *)(s29 +0x40) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x40);

L_0040:
    /* +0x00600 op=0x58 1d 1f 48 00 LD64: s31 = *(uint64_t *)(s29 +0x48) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x48);

L_0041:
    /* +0x00618 op=0x85 1d 1d 50 00 ADD64_IMM16: s29 = s29 +0x50 */
    S[29] = S[29] + 0x50;

L_0042:
    /* +0x00630 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

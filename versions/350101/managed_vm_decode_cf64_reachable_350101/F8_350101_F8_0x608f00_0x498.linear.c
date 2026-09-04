/*
 * Auto-generated linear C-like lift for 350.101 managed program F8.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F8_0x608f00_0x498.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F8_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 50 ff ADD64_IMM16: s29 = s29 -0xb0 */
    S[29] = S[29] + (-0xb0);

L_0001:
    /* +0x00018 op=0x25 1d 1f a8 00 ST64: *(s29 +0xa8) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0xa8) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e a0 00 ST64: *(s29 +0xa0) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0xa0) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 16 98 00 ST64: *(s29 +0x98) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x98) = S[22];

L_0004:
    /* +0x00060 op=0x25 1d 15 90 00 ST64: *(s29 +0x90) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x90) = S[21];

L_0005:
    /* +0x00078 op=0x25 1d 14 88 00 ST64: *(s29 +0x88) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x88) = S[20];

L_0006:
    /* +0x00090 op=0x25 1d 13 80 00 ST64: *(s29 +0x80) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x80) = S[19];

L_0007:
    /* +0x000a8 op=0x25 1d 12 78 00 ST64: *(s29 +0x78) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x78) = S[18];

L_0008:
    /* +0x000c0 op=0x25 1d 11 70 00 ST64: *(s29 +0x70) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x70) = S[17];

L_0009:
    /* +0x000d8 op=0x25 1d 10 68 00 ST64: *(s29 +0x68) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x68) = S[16];

L_000a:
    /* +0x000f0 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000b:
    /* +0x00108 op=0x85 1e 10 08 00 ADD64_IMM16: s16 = s30 +0x8 */
    S[16] = S[30] + 0x8;

L_000c:
    /* +0x00120 op=0x85 00 11 00 00 ADD64_IMM16: s17 = s0 +0x0 */
    S[17] = S[0] + 0x0;

L_000d:
    /* +0x00138 op=0x85 00 12 60 00 ADD64_IMM16: s18 = s0 +0x60 */
    S[18] = S[0] + 0x60;

L_000e:
    /* +0x00150 op=0x34 06 00 14 00 OR64: s20 = s6 | s0 */
    S[20] = S[6] | S[0];

L_000f:
    /* +0x00168 op=0x34 05 00 15 01 OR64: s21 = s5 | s0 */
    S[21] = S[5] | S[0];

L_0010:
    /* +0x00180 op=0x34 04 00 16 01 OR64: s22 = s4 | s0 */
    S[22] = S[4] | S[0];

L_0011:
    /* +0x00198 op=0x34 07 00 13 01 OR64: s19 = s7 | s0 */
    S[19] = S[7] | S[0];

L_0012:
    /* +0x001b0 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0013:
    /* +0x001c8 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0014:
    /* +0x001e0 op=0x34 12 00 06 00 OR64: s6 = s18 | s0 */
    S[6] = S[18] | S[0];

L_0015:
    /* +0x001f8 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd360);

L_0016:
    /* +0x00210 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0017:
    /* +0x00228 op=0x25 1e 14 60 00 ST64: *(s30 +0x60) = s20 */
    *(uint64_t *)((uint8_t *)S[30] + 0x60) = S[20];

L_0018:
    /* +0x00240 op=0x5e 39 00 00 00 CALL_CF_INDEX: call native_binding[index=0x39] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x39, (void *)(uintptr_t)0x125fd360);

L_0019:
    /* +0x00258 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_001a:
    /* +0x00270 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_001b:
    /* +0x00288 op=0x34 15 00 06 01 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_001c:
    /* +0x002a0 op=0x5e 3a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3a] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x3a, (void *)(uintptr_t)0x125fd360);

L_001d:
    /* +0x002b8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_001e:
    /* +0x002d0 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_001f:
    /* +0x002e8 op=0x5e 3b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3b] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x3b, (void *)(uintptr_t)0x125fd360);

L_0020:
    /* +0x00300 op=0xae 11 12 04 00 BR_EQ64: if (s17 == s18) goto record +37 */
    if (S[17] == S[18]) goto L_0025;

L_0021:
    /* +0x00318 op=0x84 10 11 01 00 ADD64: s1 = s16 + s17 */
    S[1] = S[16] + S[17];

L_0022:
    /* +0x00330 op=0x85 11 11 01 00 ADD64_IMM16: s17 = s17 +0x1 */
    S[17] = S[17] + 0x1;

L_0023:
    /* +0x00348 op=0x26 01 00 00 00 ST8: *(s1 +0x0) = (uint8_t)s0 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[0];

L_0024:
    /* +0x00360 op=0xa7 11 12 fc ff BR_NE64: if (s17 != s18) goto record +33 */
    if (S[17] != S[18]) goto L_0021;

L_0025:
    /* +0x00378 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0026:
    /* +0x00390 op=0x58 1d 10 68 00 LD64: s16 = *(uint64_t *)(s29 +0x68) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x68);

L_0027:
    /* +0x003a8 op=0x58 1d 11 70 00 LD64: s17 = *(uint64_t *)(s29 +0x70) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x70);

L_0028:
    /* +0x003c0 op=0x58 1d 12 78 00 LD64: s18 = *(uint64_t *)(s29 +0x78) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x78);

L_0029:
    /* +0x003d8 op=0x58 1d 13 80 00 LD64: s19 = *(uint64_t *)(s29 +0x80) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x80);

L_002a:
    /* +0x003f0 op=0x58 1d 14 88 00 LD64: s20 = *(uint64_t *)(s29 +0x88) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x88);

L_002b:
    /* +0x00408 op=0x58 1d 15 90 00 LD64: s21 = *(uint64_t *)(s29 +0x90) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x90);

L_002c:
    /* +0x00420 op=0x58 1d 16 98 00 LD64: s22 = *(uint64_t *)(s29 +0x98) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x98);

L_002d:
    /* +0x00438 op=0x58 1d 1e a0 00 LD64: s30 = *(uint64_t *)(s29 +0xa0) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0xa0);

L_002e:
    /* +0x00450 op=0x58 1d 1f a8 00 LD64: s31 = *(uint64_t *)(s29 +0xa8) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0xa8);

L_002f:
    /* +0x00468 op=0x85 1d 1d b0 00 ADD64_IMM16: s29 = s29 +0xb0 */
    S[29] = S[29] + 0xb0;

L_0030:
    /* +0x00480 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

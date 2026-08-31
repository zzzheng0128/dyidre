/*
 * Auto-generated linear C-like lift for 350.101 managed program F52.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F52_0x5d9900_0x240.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F52_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0001:
    /* +0x00018 op=0x85 00 03 04 00 ADD64_IMM16: s3 = s0 +0x4 */
    S[3] = S[0] + 0x4;

L_0002:
    /* +0x00030 op=0x53 01 05 71 01 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x171 q1=0x125fd408 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x171;

L_0003:
    /* +0x00048 op=0xae 02 03 13 00 BR_EQ64: if (s2 == s3) goto record +23 */
    if (S[2] == S[3]) goto L_0017;

L_0004:
    /* +0x00060 op=0x84 04 02 01 14 ADD64: s1 = s4 + s2 */
    S[1] = S[4] + S[2];

L_0005:
    /* +0x00078 op=0x85 02 02 01 00 ADD64_IMM16: s2 = s2 +0x1 */
    S[2] = S[2] + 0x1;

L_0006:
    /* +0x00090 op=0x59 01 07 04 00 LD8U: s7 = *(uint8_t *)(s1 +0x4) */
    S[7] = *(uint8_t *)((uint8_t *)S[1] + 0x4);

L_0007:
    /* +0x000a8 op=0x59 01 09 00 00 LD8U: s9 = *(uint8_t *)(s1 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0008:
    /* +0x000c0 op=0x59 01 06 08 00 LD8U: s6 = *(uint8_t *)(s1 +0x8) */
    S[6] = *(uint8_t *)((uint8_t *)S[1] + 0x8);

L_0009:
    /* +0x000d8 op=0x59 01 08 0c 00 LD8U: s8 = *(uint8_t *)(s1 +0xc) */
    S[8] = *(uint8_t *)((uint8_t *)S[1] + 0xc);

L_000a:
    /* +0x000f0 op=0x84 05 07 07 14 ADD64: s7 = s5 + s7 */
    S[7] = S[5] + S[7];

L_000b:
    /* +0x00108 op=0x84 05 09 09 14 ADD64: s9 = s5 + s9 */
    S[9] = S[5] + S[9];

L_000c:
    /* +0x00120 op=0x84 05 06 06 04 ADD64: s6 = s5 + s6 */
    S[6] = S[5] + S[6];

L_000d:
    /* +0x00138 op=0x84 05 08 08 14 ADD64: s8 = s5 + s8 */
    S[8] = S[5] + S[8];

L_000e:
    /* +0x00150 op=0x59 09 09 00 00 LD8U: s9 = *(uint8_t *)(s9 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[9] + 0x0);

L_000f:
    /* +0x00168 op=0x59 07 07 00 00 LD8U: s7 = *(uint8_t *)(s7 +0x0) */
    S[7] = *(uint8_t *)((uint8_t *)S[7] + 0x0);

L_0010:
    /* +0x00180 op=0x59 06 06 00 00 LD8U: s6 = *(uint8_t *)(s6 +0x0) */
    S[6] = *(uint8_t *)((uint8_t *)S[6] + 0x0);

L_0011:
    /* +0x00198 op=0x26 01 09 0c 00 ST8: *(s1 +0xc) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[1] + 0xc) = (uint8_t)S[9];

L_0012:
    /* +0x001b0 op=0x26 01 07 08 00 ST8: *(s1 +0x8) = (uint8_t)s7 */
    *(uint8_t *)((uint8_t *)S[1] + 0x8) = (uint8_t)S[7];

L_0013:
    /* +0x001c8 op=0x59 08 07 00 00 LD8U: s7 = *(uint8_t *)(s8 +0x0) */
    S[7] = *(uint8_t *)((uint8_t *)S[8] + 0x0);

L_0014:
    /* +0x001e0 op=0x26 01 07 04 00 ST8: *(s1 +0x4) = (uint8_t)s7 */
    *(uint8_t *)((uint8_t *)S[1] + 0x4) = (uint8_t)S[7];

L_0015:
    /* +0x001f8 op=0x26 01 06 00 00 ST8: *(s1 +0x0) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[6];

L_0016:
    /* +0x00210 op=0xa7 02 03 ed ff BR_NE64: if (s2 != s3) goto record +4 */
    if (S[2] != S[3]) goto L_0004;

L_0017:
    /* +0x00228 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

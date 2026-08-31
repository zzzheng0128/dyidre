/*
 * Auto-generated linear C-like lift for 350.101 managed program F28.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F28_0x5d8f00_0x228.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F28_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x59 04 02 0a 00 LD8U: s2 = *(uint8_t *)(s4 +0xa) */
    S[2] = *(uint8_t *)((uint8_t *)S[4] + 0xa);

L_0001:
    /* +0x00018 op=0x59 04 03 0e 00 LD8U: s3 = *(uint8_t *)(s4 +0xe) */
    S[3] = *(uint8_t *)((uint8_t *)S[4] + 0xe);

L_0002:
    /* +0x00030 op=0x59 04 05 05 00 LD8U: s5 = *(uint8_t *)(s4 +0x5) */
    S[5] = *(uint8_t *)((uint8_t *)S[4] + 0x5);

L_0003:
    /* +0x00048 op=0x59 04 06 0d 00 LD8U: s6 = *(uint8_t *)(s4 +0xd) */
    S[6] = *(uint8_t *)((uint8_t *)S[4] + 0xd);

L_0004:
    /* +0x00060 op=0x59 04 07 09 00 LD8U: s7 = *(uint8_t *)(s4 +0x9) */
    S[7] = *(uint8_t *)((uint8_t *)S[4] + 0x9);

L_0005:
    /* +0x00078 op=0x59 04 08 01 00 LD8U: s8 = *(uint8_t *)(s4 +0x1) */
    S[8] = *(uint8_t *)((uint8_t *)S[4] + 0x1);

L_0006:
    /* +0x00090 op=0x59 04 01 02 00 LD8U: s1 = *(uint8_t *)(s4 +0x2) */
    S[1] = *(uint8_t *)((uint8_t *)S[4] + 0x2);

L_0007:
    /* +0x000a8 op=0x26 04 08 09 00 ST8: *(s4 +0x9) = (uint8_t)s8 */
    *(uint8_t *)((uint8_t *)S[4] + 0x9) = (uint8_t)S[8];

L_0008:
    /* +0x000c0 op=0x26 04 07 01 00 ST8: *(s4 +0x1) = (uint8_t)s7 */
    *(uint8_t *)((uint8_t *)S[4] + 0x1) = (uint8_t)S[7];

L_0009:
    /* +0x000d8 op=0x26 04 06 05 00 ST8: *(s4 +0x5) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[4] + 0x5) = (uint8_t)S[6];

L_000a:
    /* +0x000f0 op=0x26 04 05 0d 00 ST8: *(s4 +0xd) = (uint8_t)s5 */
    *(uint8_t *)((uint8_t *)S[4] + 0xd) = (uint8_t)S[5];

L_000b:
    /* +0x00108 op=0x26 04 03 02 00 ST8: *(s4 +0x2) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[4] + 0x2) = (uint8_t)S[3];

L_000c:
    /* +0x00120 op=0x26 04 02 0e 00 ST8: *(s4 +0xe) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xe) = (uint8_t)S[2];

L_000d:
    /* +0x00138 op=0x59 04 02 06 00 LD8U: s2 = *(uint8_t *)(s4 +0x6) */
    S[2] = *(uint8_t *)((uint8_t *)S[4] + 0x6);

L_000e:
    /* +0x00150 op=0x26 04 02 0a 00 ST8: *(s4 +0xa) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xa) = (uint8_t)S[2];

L_000f:
    /* +0x00168 op=0x26 04 01 06 00 ST8: *(s4 +0x6) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[4] + 0x6) = (uint8_t)S[1];

L_0010:
    /* +0x00180 op=0x59 04 01 0f 00 LD8U: s1 = *(uint8_t *)(s4 +0xf) */
    S[1] = *(uint8_t *)((uint8_t *)S[4] + 0xf);

L_0011:
    /* +0x00198 op=0x59 04 02 03 00 LD8U: s2 = *(uint8_t *)(s4 +0x3) */
    S[2] = *(uint8_t *)((uint8_t *)S[4] + 0x3);

L_0012:
    /* +0x001b0 op=0x59 04 03 0b 00 LD8U: s3 = *(uint8_t *)(s4 +0xb) */
    S[3] = *(uint8_t *)((uint8_t *)S[4] + 0xb);

L_0013:
    /* +0x001c8 op=0x26 04 03 0f 00 ST8: *(s4 +0xf) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[4] + 0xf) = (uint8_t)S[3];

L_0014:
    /* +0x001e0 op=0x26 04 02 0b 00 ST8: *(s4 +0xb) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xb) = (uint8_t)S[2];

L_0015:
    /* +0x001f8 op=0x26 04 01 03 00 ST8: *(s4 +0x3) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[4] + 0x3) = (uint8_t)S[1];

L_0016:
    /* +0x00210 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

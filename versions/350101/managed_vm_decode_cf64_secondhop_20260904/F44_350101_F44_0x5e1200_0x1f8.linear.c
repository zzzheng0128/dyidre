/*
 * Auto-generated linear C-like lift for 350.101 managed program F44.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F44_0x5e1200_0x1f8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F44_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 04 04 68 00 ADD64_IMM16: s4 = s4 +0x68 */
    S[4] = S[4] + 0x68;

L_0001:
    /* +0x00018 op=0x85 00 02 1f 00 ADD64_IMM16: s2 = s0 +0x1f */
    S[2] = S[0] + 0x1f;

L_0002:
    /* +0x00030 op=0x85 00 03 ff ff ADD64_IMM16: s3 = s0 -0x1 q1=0x766e6506 */
    S[3] = S[0] + (-0x1);

L_0003:
    /* +0x00048 op=0xae 02 03 10 00 BR_EQ64: if (s2 == s3) goto record +20 q1=0x30464306 */
    if (S[2] == S[3]) goto L_0014;

L_0004:
    /* +0x00060 op=0x55 04 06 06 00 LD16U: s6 = *(uint16_t *)(s4 +0x6) */
    S[6] = *(uint16_t *)((uint8_t *)S[4] + 0x6);

L_0005:
    /* +0x00078 op=0x84 05 02 01 00 ADD64: s1 = s5 + s2 */
    S[1] = S[5] + S[2];

L_0006:
    /* +0x00090 op=0x85 02 02 fc ff ADD64_IMM16: s2 = s2 -0x4 */
    S[2] = S[2] + (-0x4);

L_0007:
    /* +0x000a8 op=0x26 01 06 00 00 ST8: *(s1 +0x0) = (uint8_t)s6 q1=0x100000001 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[6];

L_0008:
    /* +0x000c0 op=0x58 04 06 00 00 LD64: s6 = *(uint64_t *)(s4 +0x0) */
    S[6] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_0009:
    /* +0x000d8 op=0x67 00 06 06 08 LSR64_IMM32PLUS: s6 = (uint64_t)s6 >> (8 + 32) */
    S[6] = (uint64_t)S[6] >> (8 + 32);

L_000a:
    /* +0x000f0 op=0x26 01 06 ff ff ST8: *(s1 -0x1) = (uint8_t)s6 q1=0x766e6506 */
    *(uint8_t *)((uint8_t *)S[1] + (-0x1)) = (uint8_t)S[6];

L_000b:
    /* +0x00108 op=0x85 04 06 08 00 ADD64_IMM16: s6 = s4 +0x8 q1=0x32464306 */
    S[6] = S[4] + 0x8;

L_000c:
    /* +0x00120 op=0x58 04 07 00 00 LD64: s7 = *(uint64_t *)(s4 +0x0) */
    S[7] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_000d:
    /* +0x00138 op=0x68 13 07 07 18 LSR64_IMM: s7 = (uint64_t)s7 >> 24 */
    S[7] = (uint64_t)S[7] >> 24;

L_000e:
    /* +0x00150 op=0x26 01 07 fe ff ST8: *(s1 -0x2) = (uint8_t)s7 */
    *(uint8_t *)((uint8_t *)S[1] + (-0x2)) = (uint8_t)S[7];

L_000f:
    /* +0x00168 op=0x58 04 04 00 00 LD64: s4 = *(uint64_t *)(s4 +0x0) q1=0x400000007 */
    S[4] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_0010:
    /* +0x00180 op=0x68 00 04 04 08 LSR64_IMM: s4 = (uint64_t)s4 >> 8 */
    S[4] = (uint64_t)S[4] >> 8;

L_0011:
    /* +0x00198 op=0x26 01 04 fd ff ST8: *(s1 -0x3) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + (-0x3)) = (uint8_t)S[4];

L_0012:
    /* +0x001b0 op=0x34 06 00 04 00 OR64: s4 = s6 | s0 q1=0x766e6506 */
    S[4] = S[6] | S[0];

L_0013:
    /* +0x001c8 op=0xa7 02 03 f0 ff BR_NE64: if (s2 != s3) goto record +4 q1=0x3031464308 */
    if (S[2] != S[3]) goto L_0004;

L_0014:
    /* +0x001e0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

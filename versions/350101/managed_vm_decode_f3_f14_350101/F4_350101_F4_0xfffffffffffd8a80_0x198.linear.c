/*
 * Auto-generated linear C-like lift for 350.101 managed program F4.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F4_0xfffffffffffd8a80_0x198.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F4_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x18 00 04 01 00 SHL32_IMM: s1 = (int32_t)(s4 << 0) */
    S[1] = (int32_t)((uint32_t)S[4] << 0);

L_0001:
    /* +0x00018 op=0xb2 01 02 0f 00 AND64_IMM16: s2 = s1 & 0xf */
    S[2] = S[1] & 0xf;

L_0002:
    /* +0x00030 op=0xb2 01 01 f0 00 AND64_IMM16: s1 = s1 & 0xf0 */
    S[1] = S[1] & 0xf0;

L_0003:
    /* +0x00048 op=0x18 10 02 02 04 SHL32_IMM: s2 = (int32_t)(s2 << 4) */
    S[2] = (int32_t)((uint32_t)S[2] << 4);

L_0004:
    /* +0x00060 op=0x0e 0b 01 01 04 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 4) */
    S[1] = (int32_t)((uint32_t)S[1] >> 4);

L_0005:
    /* +0x00078 op=0x34 01 02 01 00 OR64: s1 = s1 | s2 */
    S[1] = S[1] | S[2];

L_0006:
    /* +0x00090 op=0xb2 01 02 33 00 AND64_IMM16: s2 = s1 & 0x33 */
    S[2] = S[1] & 0x33;

L_0007:
    /* +0x000a8 op=0x0e 0b 01 01 02 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 2) */
    S[1] = (int32_t)((uint32_t)S[1] >> 2);

L_0008:
    /* +0x000c0 op=0x18 11 02 02 02 SHL32_IMM: s2 = (int32_t)(s2 << 2) */
    S[2] = (int32_t)((uint32_t)S[2] << 2);

L_0009:
    /* +0x000d8 op=0xb2 01 01 33 00 AND64_IMM16: s1 = s1 & 0x33 */
    S[1] = S[1] & 0x33;

L_000a:
    /* +0x000f0 op=0x34 01 02 01 01 OR64: s1 = s1 | s2 */
    S[1] = S[1] | S[2];

L_000b:
    /* +0x00108 op=0xb2 01 02 55 00 AND64_IMM16: s2 = s1 & 0x55 */
    S[2] = S[1] & 0x55;

L_000c:
    /* +0x00120 op=0x0e 0d 01 01 01 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 1) */
    S[1] = (int32_t)((uint32_t)S[1] >> 1);

L_000d:
    /* +0x00138 op=0x18 10 02 02 01 SHL32_IMM: s2 = (int32_t)(s2 << 1) */
    S[2] = (int32_t)((uint32_t)S[2] << 1);

L_000e:
    /* +0x00150 op=0xb2 01 01 55 00 AND64_IMM16: s1 = s1 & 0x55 */
    S[1] = S[1] & 0x55;

L_000f:
    /* +0x00168 op=0x34 01 02 02 00 OR64: s2 = s1 | s2 */
    S[2] = S[1] | S[2];

L_0010:
    /* +0x00180 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

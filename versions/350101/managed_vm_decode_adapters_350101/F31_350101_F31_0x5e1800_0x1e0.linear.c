/*
 * Auto-generated linear C-like lift for 350.101 managed program F31.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_adapters_350101_20260831_053000/350101_F31_0x5e1800_0x1e0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F31_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d e0 ff ADD64_IMM16: s29 = s29 -0x20 */
    S[29] = S[29] + (-0x20);

L_0001:
    /* +0x00018 op=0x25 1d 1f 18 00 ST64: *(s29 +0x18) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 10 00 ST64: *(s29 +0x10) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 11 08 00 ST64: *(s29 +0x8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[17];

L_0004:
    /* +0x00060 op=0x25 1d 10 00 00 ST64: *(s29 +0x0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[16];

L_0005:
    /* +0x00078 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0006:
    /* +0x00090 op=0x34 06 00 10 01 OR64: s16 = s6 | s0 */
    S[16] = S[6] | S[0];

L_0007:
    /* +0x000a8 op=0x34 04 00 11 01 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_0008:
    /* +0x000c0 op=0x5e 8c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8c, (void *)(uintptr_t)0x125fd3c0);

L_0009:
    /* +0x000d8 op=0x85 11 04 b0 00 ADD64_IMM16: s4 = s17 +0xb0 */
    S[4] = S[17] + 0xb0;

L_000a:
    /* +0x000f0 op=0x85 00 06 10 00 ADD64_IMM16: s6 = s0 +0x10 */
    S[6] = S[0] + 0x10;

L_000b:
    /* +0x00108 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_000c:
    /* +0x00120 op=0x5e 36 00 00 00 CALL_CF_INDEX: call native_binding[index=0x36] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x36, (void *)(uintptr_t)0x125fd3c0);

L_000d:
    /* +0x00138 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_000e:
    /* +0x00150 op=0x58 1d 10 00 00 LD64: s16 = *(uint64_t *)(s29 +0x0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_000f:
    /* +0x00168 op=0x58 1d 11 08 00 LD64: s17 = *(uint64_t *)(s29 +0x8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0010:
    /* +0x00180 op=0x58 1d 1e 10 00 LD64: s30 = *(uint64_t *)(s29 +0x10) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0011:
    /* +0x00198 op=0x58 1d 1f 18 00 LD64: s31 = *(uint64_t *)(s29 +0x18) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_0012:
    /* +0x001b0 op=0x85 1d 1d 20 00 ADD64_IMM16: s29 = s29 +0x20 */
    S[29] = S[29] + 0x20;

L_0013:
    /* +0x001c8 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

/*
 * Auto-generated linear C-like lift for 350.101 managed program F6.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F6_0xfffffffffffe9a00_0x258.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F6_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d c0 ff ADD64_IMM16: s29 = s29 -0x40 */
    S[29] = S[29] + (-0x40);

L_0001:
    /* +0x00018 op=0x25 1d 1f 38 00 ST64: *(s29 +0x38) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x38) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 30 00 ST64: *(s29 +0x30) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x30) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 11 28 00 ST64: *(s29 +0x28) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[17];

L_0004:
    /* +0x00060 op=0x25 1d 10 20 00 ST64: *(s29 +0x20) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[16];

L_0005:
    /* +0x00078 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0006:
    /* +0x00090 op=0x52 05 01 0c 00 LD32S: s1 = *(int32_t *)(s5 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[5] + 0xc);

L_0007:
    /* +0x000a8 op=0x34 04 00 10 00 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_0008:
    /* +0x000c0 op=0x58 05 04 10 00 LD64: s4 = *(uint64_t *)(s5 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[5] + 0x10);

L_0009:
    /* +0x000d8 op=0x85 1e 11 00 00 ADD64_IMM16: s17 = s30 +0x0 */
    S[17] = S[30] + 0x0;

L_000a:
    /* +0x000f0 op=0x34 11 00 06 01 OR64: s6 = s17 | s0 */
    S[6] = S[17] | S[0];

L_000b:
    /* +0x00108 op=0x34 01 00 05 00 OR64: s5 = s1 | s0 */
    S[5] = S[1] | S[0];

L_000c:
    /* +0x00120 op=0x5e 30 00 00 00 CALL_CF_INDEX: call native_binding[index=0x30] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x30, (void *)(uintptr_t)0x1235f600);

L_000d:
    /* +0x00138 op=0x85 00 06 20 00 ADD64_IMM16: s6 = s0 +0x20 */
    S[6] = S[0] + 0x20;

L_000e:
    /* +0x00150 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_000f:
    /* +0x00168 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0010:
    /* +0x00180 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x1235f600);

L_0011:
    /* +0x00198 op=0x34 10 00 02 00 OR64: s2 = s16 | s0 */
    S[2] = S[16] | S[0];

L_0012:
    /* +0x001b0 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0013:
    /* +0x001c8 op=0x58 1d 10 20 00 LD64: s16 = *(uint64_t *)(s29 +0x20) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_0014:
    /* +0x001e0 op=0x58 1d 11 28 00 LD64: s17 = *(uint64_t *)(s29 +0x28) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_0015:
    /* +0x001f8 op=0x58 1d 1e 30 00 LD64: s30 = *(uint64_t *)(s29 +0x30) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x30);

L_0016:
    /* +0x00210 op=0x58 1d 1f 38 00 LD64: s31 = *(uint64_t *)(s29 +0x38) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x38);

L_0017:
    /* +0x00228 op=0x85 1d 1d 40 00 ADD64_IMM16: s29 = s29 +0x40 */
    S[29] = S[29] + 0x40;

L_0018:
    /* +0x00240 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

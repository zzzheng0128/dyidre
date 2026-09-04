/*
 * Auto-generated linear C-like lift for 350.101 managed program F0.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f0_f1_f2_20260904/350101_F0_0x30dc00_0x2d0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F0_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d d0 ff ADD64_IMM16: s29 = s29 -0x30 q1=0x6c622801001f1d3f */
    S[29] = S[29] + (-0x30);

L_0001:
    /* +0x00018 op=0x25 1d 1f 28 00 ST64: *(s29 +0x28) = s31 q1=0x180100171d1a */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 20 00 ST64: *(s29 +0x20) = s30 q1=0x80100151d1a */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 12 18 00 ST64: *(s29 +0x18) = s18 q1=0x380000131d1a */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[18];

L_0004:
    /* +0x00060 op=0x25 1d 11 10 00 ST64: *(s29 +0x10) = s17 q1=0x280000111d3f */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[17];

L_0005:
    /* +0x00078 op=0x25 1d 10 08 00 ST64: *(s29 +0x8) = s16 q1=0x2f011e001d3e */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[16];

L_0006:
    /* +0x00090 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 q1=0x10000020419 */
    S[30] = S[29] | S[0];

L_0007:
    /* +0x000a8 op=0xae 04 00 0e 00 BR_EQ64: if (s4 == s0) goto record +22 q1=0x10000004001d */
    if (S[4] == S[0]) goto L_0016;

L_0008:
    /* +0x000c0 op=0x34 06 00 11 00 OR64: s17 = s6 | s0 q1=0xc0000040336 */
    S[17] = S[6] | S[0];

L_0009:
    /* +0x000d8 op=0xae 06 00 0c 00 BR_EQ64: if (s6 == s0) goto record +22 q1=0x40103162c */
    if (S[6] == S[0]) goto L_0016;

L_000a:
    /* +0x000f0 op=0x34 05 00 10 01 OR64: s16 = s5 | s0 q1=0x3f1f1f060524 */
    S[16] = S[5] | S[0];

L_000b:
    /* +0x00108 op=0x52 04 05 0c 00 LD32S: s5 = *(int32_t *)(s4 +0xc) q1=0x60524 */
    S[5] = *(int32_t *)((uint8_t *)S[4] + 0xc);

L_000c:
    /* +0x00120 op=0x34 04 00 12 01 OR64: s18 = s4 | s0 q1=0x10000060524 */
    S[18] = S[4] | S[0];

L_000d:
    /* +0x00138 op=0x85 00 06 20 00 ADD64_IMM16: s6 = s0 +0x20 q1=0x20000050524 */
    S[6] = S[0] + 0x20;

L_000e:
    /* +0x00150 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 q1=0x341f1f040305 */
    S[4] = S[16] | S[0];

L_000f:
    /* +0x00168 op=0x5e 00 00 00 00 CALL_CF_INDEX: call native_binding[index=0x0] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x0, (void *)(uintptr_t)0x1235f600);

L_0010:
    /* +0x00180 op=0x52 12 06 0c 00 LD32S: s6 = *(int32_t *)(s18 +0xc) q1=0x180000171104 */
    S[6] = *(int32_t *)((uint8_t *)S[18] + 0xc);

L_0011:
    /* +0x00198 op=0x52 11 08 0c 00 LD32S: s8 = *(int32_t *)(s17 +0xc) q1=0x20000040019 */
    S[8] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_0012:
    /* +0x001b0 op=0x58 11 07 10 00 LD64: s7 = *(uint64_t *)(s17 +0x10) q1=0xb0200000003 */
    S[7] = *(uint64_t *)((uint8_t *)S[17] + 0x10);

L_0013:
    /* +0x001c8 op=0x58 12 05 10 00 LD64: s5 = *(uint64_t *)(s18 +0x10) q1=0x3000004001d */
    S[5] = *(uint64_t *)((uint8_t *)S[18] + 0x10);

L_0014:
    /* +0x001e0 op=0x58 10 04 10 00 LD64: s4 = *(uint64_t *)(s16 +0x10) q1=0xb0200000003 */
    S[4] = *(uint64_t *)((uint8_t *)S[16] + 0x10);

L_0015:
    /* +0x001f8 op=0x5e 01 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1, (void *)(uintptr_t)0x1235f600);

L_0016:
    /* +0x00210 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 q1=0xb0200000014 */
    S[29] = S[30] | S[0];

L_0017:
    /* +0x00228 op=0x58 1d 10 08 00 LD64: s16 = *(uint64_t *)(s29 +0x8) q1=0xc0000051220 */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0018:
    /* +0x00240 op=0x58 1d 11 10 00 LD64: s17 = *(uint64_t *)(s29 +0x10) q1=0x1f010400132c */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0019:
    /* +0x00258 op=0x58 1d 12 18 00 LD64: s18 = *(uint64_t *)(s29 +0x18) q1=0x2d010114152c */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_001a:
    /* +0x00270 op=0x58 1d 1e 20 00 LD64: s30 = *(uint64_t *)(s29 +0x20) q1=0xb0200000012 */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_001b:
    /* +0x00288 op=0x58 1d 1f 28 00 LD64: s31 = *(uint64_t *)(s29 +0x28) q1=0x11128 */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_001c:
    /* +0x002a0 op=0x85 1d 1d 30 00 ADD64_IMM16: s29 = s29 +0x30 q1=0x281f1f171105 */
    S[29] = S[29] + 0x30;

L_001d:
    /* +0x002b8 op=0x5b 1f 00 00 00 RET: return/leave with s31 q1=0x3000013001d */
    return; /* RET s31 */

}

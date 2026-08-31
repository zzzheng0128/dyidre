/*
 * Auto-generated linear C-like lift for 350.101 managed program F16.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f16_f17_f18_20260831_031044/350101_F16_0x5e1600_0x1f8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F16_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x58 05 08 08 00 LD64: s8 = *(uint64_t *)(s5 +0x8) */
    S[8] = *(uint64_t *)((uint8_t *)S[5] + 0x8);

L_0001:
    /* +0x00018 op=0x58 05 05 00 00 LD64: s5 = *(uint64_t *)(s5 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[5] + 0x0);

L_0002:
    /* +0x00030 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 q1=0x12274848 */
    S[2] = S[0] + 0x0;

L_0003:
    /* +0x00048 op=0x85 00 03 40 02 ADD64_IMM16: s3 = s0 +0x240 */
    S[3] = S[0] + 0x240;

L_0004:
    /* +0x00060 op=0x34 08 00 07 00 OR64: s7 = s8 | s0 */
    S[7] = S[8] | S[0];

L_0005:
    /* +0x00078 op=0xae 02 03 0c 00 BR_EQ64: if (s2 == s3) goto record +18 */
    if (S[2] == S[3]) goto L_0012;

L_0006:
    /* +0x00090 op=0x72 01 07 01 18 ROL64_32MINUS_IMM: s1 = rol64(s7, 32 - 24) */
    S[1] = rol64(S[7], 32 - 24);

L_0007:
    /* +0x000a8 op=0x72 01 07 08 1f ROL64_32MINUS_IMM: s8 = rol64(s7, 32 - 31) */
    S[8] = rol64(S[7], 32 - 31);

L_0008:
    /* +0x000c0 op=0xb3 08 01 01 00 AND64: s1 = s8 & s1 */
    S[1] = S[8] & S[1];

L_0009:
    /* +0x000d8 op=0x72 01 07 08 1e ROL64_32MINUS_IMM: s8 = rol64(s7, 32 - 30) */
    S[8] = rol64(S[7], 32 - 30);

L_000a:
    /* +0x000f0 op=0x02 08 05 05 00 XOR64: s5 = s5 ^ s8 q1=0x12274848 */
    S[5] = S[5] ^ S[8];

L_000b:
    /* +0x00108 op=0x02 05 01 01 01 XOR64: s1 = s1 ^ s5 */
    S[1] = S[1] ^ S[5];

L_000c:
    /* +0x00120 op=0x84 04 02 05 14 ADD64: s5 = s4 + s2 */
    S[5] = S[4] + S[2];

L_000d:
    /* +0x00138 op=0x85 02 02 08 00 ADD64_IMM16: s2 = s2 +0x8 */
    S[2] = S[2] + 0x8;

L_000e:
    /* +0x00150 op=0x58 05 05 00 00 LD64: s5 = *(uint64_t *)(s5 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[5] + 0x0);

L_000f:
    /* +0x00168 op=0x02 01 05 08 01 XOR64: s8 = s5 ^ s1 */
    S[8] = S[5] ^ S[1];

L_0010:
    /* +0x00180 op=0x34 07 00 05 01 OR64: s5 = s7 | s0 */
    S[5] = S[7] | S[0];

L_0011:
    /* +0x00198 op=0x5f f2 ff ff ff ADD_PC_IMM32: goto record +4 ; vm_pc = current_pc + 1 + -14 */
    goto L_0004;

L_0012:
    /* +0x001b0 op=0x25 06 07 08 00 ST64: *(s6 +0x8) = s7 q1=0x12274848 */
    *(uint64_t *)((uint8_t *)S[6] + 0x8) = S[7];

L_0013:
    /* +0x001c8 op=0x25 06 05 00 00 ST64: *(s6 +0x0) = s5 */
    *(uint64_t *)((uint8_t *)S[6] + 0x0) = S[5];

L_0014:
    /* +0x001e0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

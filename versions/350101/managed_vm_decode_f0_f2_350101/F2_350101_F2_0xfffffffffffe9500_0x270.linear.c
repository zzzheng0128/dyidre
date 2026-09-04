/*
 * Auto-generated linear C-like lift for 350.101 managed program F2.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f0_f1_f2_20260904/350101_F2_0xfffffffffffe9500_0x270.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F2_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x18 00 05 01 00 SHL32_IMM: s1 = (int32_t)(s5 << 0) */
    S[1] = (int32_t)((uint32_t)S[5] << 0);

L_0001:
    /* +0x00018 op=0x15 01 02 01 00 CMP_LT_IMM64S: s2 = ((int64_t)s1 < 1) ? 1 : 0 */
    S[2] = ((int64_t)S[1] < 0x1) ? 1 : 0;

L_0002:
    /* +0x00030 op=0x1f 01 02 03 00 CMOVZ64: s3 = (s2 == 0) ? s1 : 0 */
    S[3] = (S[2] == 0) ? S[1] : 0;

L_0003:
    /* +0x00048 op=0xb5 00 02 00 00 ADD32_IMM16: s2 = int32(s0 +0x0) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x0);

L_0004:
    /* +0x00060 op=0x34 02 00 05 01 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_0005:
    /* +0x00078 op=0xae 03 05 13 00 BR_EQ64: if (s3 == s5) goto record +25 */
    if (S[3] == S[5]) goto L_0019;

L_0006:
    /* +0x00090 op=0xb2 05 01 01 00 AND64_IMM16: s1 = s5 & 0x1 */
    S[1] = S[5] & 0x1;

L_0007:
    /* +0x000a8 op=0xa7 01 00 07 00 BR_NE64: if (s1 != s0) goto record +15 */
    if (S[1] != S[0]) goto L_000f;

L_0008:
    /* +0x000c0 op=0x18 11 02 01 07 SHL32_IMM: s1 = (int32_t)(s2 << 7) */
    S[1] = (int32_t)((uint32_t)S[2] << 7);

L_0009:
    /* +0x000d8 op=0x02 01 02 01 01 XOR64: s1 = s2 ^ s1 */
    S[1] = S[2] ^ S[1];

L_000a:
    /* +0x000f0 op=0x0e 00 02 02 03 LSR32_IMM: s2 = sign_extend_32((uint32_t)s2 >> 3) */
    S[2] = (int32_t)((uint32_t)S[2] >> 3);

L_000b:
    /* +0x00108 op=0x02 01 02 01 01 XOR64: s1 = s2 ^ s1 */
    S[1] = S[2] ^ S[1];

L_000c:
    /* +0x00120 op=0x59 04 02 00 00 LD8U: s2 = *(uint8_t *)(s4 +0x0) */
    S[2] = *(uint8_t *)((uint8_t *)S[4] + 0x0);

L_000d:
    /* +0x00138 op=0x02 01 02 02 01 XOR64: s2 = s2 ^ s1 */
    S[2] = S[2] ^ S[1];

L_000e:
    /* +0x00150 op=0x5f 07 00 00 00 ADD_PC_IMM32: goto record +22 ; vm_pc = current_pc + 1 + 7 */
    goto L_0016;

L_000f:
    /* +0x00168 op=0x59 04 01 00 00 LD8U: s1 = *(uint8_t *)(s4 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[4] + 0x0);

L_0010:
    /* +0x00180 op=0x18 10 02 06 0b SHL32_IMM: s6 = (int32_t)(s2 << 11) */
    S[6] = (int32_t)((uint32_t)S[2] << 11);

L_0011:
    /* +0x00198 op=0x34 06 01 01 01 OR64: s1 = s6 | s1 */
    S[1] = S[6] | S[1];

L_0012:
    /* +0x001b0 op=0x0e 0b 02 06 05 LSR32_IMM: s6 = sign_extend_32((uint32_t)s2 >> 5) */
    S[6] = (int32_t)((uint32_t)S[2] >> 5);

L_0013:
    /* +0x001c8 op=0x02 02 06 02 01 XOR64: s2 = s6 ^ s2 */
    S[2] = S[6] ^ S[2];

L_0014:
    /* +0x001e0 op=0x02 02 01 01 01 XOR64: s1 = s1 ^ s2 */
    S[1] = S[1] ^ S[2];

L_0015:
    /* +0x001f8 op=0x36 01 00 02 01 NOR64: s2 = ~(s1 | s0) */
    S[2] = ~(S[1] | S[0]);

L_0016:
    /* +0x00210 op=0xb5 05 05 01 00 ADD32_IMM16: s5 = int32(s5 +0x1) */
    S[5] = (int32_t)((uint32_t)S[5] + 0x1);

L_0017:
    /* +0x00228 op=0x85 04 04 01 00 ADD64_IMM16: s4 = s4 +0x1 */
    S[4] = S[4] + 0x1;

L_0018:
    /* +0x00240 op=0xa7 03 05 ed ff BR_NE64: if (s3 != s5) goto record +6 */
    if (S[3] != S[5]) goto L_0006;

L_0019:
    /* +0x00258 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

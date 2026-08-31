/*
 * Auto-generated linear C-like lift for 350.101 managed program F30.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_f30_f42_350101_20260831_044228/350101_F30_0x5e2000_0x1f8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F30_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x18 11 05 05 00 SHL32_IMM: s5 = (int32_t)(s5 << 0) */
    S[5] = (int32_t)((uint32_t)S[5] << 0);

L_0001:
    /* +0x00018 op=0x18 10 04 03 00 SHL32_IMM: s3 = (int32_t)(s4 << 0) */
    S[3] = (int32_t)((uint32_t)S[4] << 0);

L_0002:
    /* +0x00030 op=0xb5 00 02 00 00 ADD32_IMM16: s2 = int32(s0 +0x0) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x0);

L_0003:
    /* +0x00048 op=0xb2 03 01 ff 00 AND64_IMM16: s1 = s3 & 0xff */
    S[1] = S[3] & 0xff;

L_0004:
    /* +0x00060 op=0xae 01 00 0f 00 BR_EQ64: if (s1 == s0) goto record +20 */
    if (S[1] == S[0]) goto L_0014;

L_0005:
    /* +0x00078 op=0x23 04 05 04 11 SEXT8_SLOT: s4 = (int64_t)(int8_t)(uint8_t)s5 */
    S[4] = (int64_t)(int8_t)(uint8_t)S[5];

L_0006:
    /* +0x00090 op=0x18 10 05 01 01 SHL32_IMM: s1 = (int32_t)(s5 << 1) */
    S[1] = (int32_t)((uint32_t)S[5] << 1);

L_0007:
    /* +0x000a8 op=0x15 04 04 00 00 CMP_LT_IMM64S: s4 = ((int64_t)s4 < 0) ? 1 : 0 */
    S[4] = ((int64_t)S[4] < 0x0) ? 1 : 0;

L_0008:
    /* +0x000c0 op=0x1f 01 04 06 00 CMOVZ64: s6 = (s4 == 0) ? s1 : 0 */
    S[6] = (S[4] == 0) ? S[1] : 0;

L_0009:
    /* +0x000d8 op=0x01 01 01 1b 00 XOR_IMM16: s1 = s1 ^ 0x1b */
    S[1] = S[1] ^ 0x1b;

L_000a:
    /* +0x000f0 op=0x1e 01 04 01 00 CMOVNZ64: s1 = (s4 != 0) ? s1 : 0 */
    S[1] = (S[4] != 0) ? S[1] : 0;

L_000b:
    /* +0x00108 op=0xb2 03 04 01 00 AND64_IMM16: s4 = s3 & 0x1 */
    S[4] = S[3] & 0x1;

L_000c:
    /* +0x00120 op=0xb2 03 03 fe 00 AND64_IMM16: s3 = s3 & 0xfe */
    S[3] = S[3] & 0xfe;

L_000d:
    /* +0x00138 op=0x09 00 04 04 14 SUB32: s4 = sign_extend_32((uint32_t)s0 - (uint32_t)s4) */
    S[4] = (int32_t)((uint32_t)S[0] - (uint32_t)S[4]);

L_000e:
    /* +0x00150 op=0x34 01 06 01 01 OR64: s1 = s1 | s6 */
    S[1] = S[1] | S[6];

L_000f:
    /* +0x00168 op=0x0e 0b 03 03 01 LSR32_IMM: s3 = sign_extend_32((uint32_t)s3 >> 1) */
    S[3] = (int32_t)((uint32_t)S[3] >> 1);

L_0010:
    /* +0x00180 op=0xb3 04 05 04 01 AND64: s4 = s4 & s5 */
    S[4] = S[4] & S[5];

L_0011:
    /* +0x00198 op=0x34 01 00 05 01 OR64: s5 = s1 | s0 */
    S[5] = S[1] | S[0];

L_0012:
    /* +0x001b0 op=0x02 04 02 02 01 XOR64: s2 = s2 ^ s4 */
    S[2] = S[2] ^ S[4];

L_0013:
    /* +0x001c8 op=0x5f ef ff ff ff ADD_PC_IMM32: goto record +3 ; vm_pc = current_pc + 1 + -17 */
    goto L_0003;

L_0014:
    /* +0x001e0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

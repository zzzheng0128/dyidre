/*
 * Auto-generated linear C-like lift for 350.101 managed program F17.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_f16_f17_f18_20260831_031044/350101_F17_0x8721c0_0x198.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F17_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x58 05 07 08 00 LD64: s7 = *(uint64_t *)(s5 +0x8) */
    S[7] = *(uint64_t *)((uint8_t *)S[5] + 0x8);

L_0001:
    /* +0x00018 op=0x58 05 02 00 00 LD64: s2 = *(uint64_t *)(s5 +0x0) */
    S[2] = *(uint64_t *)((uint8_t *)S[5] + 0x0);

L_0002:
    /* +0x00030 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 */
    S[3] = S[0] + 0x0;

L_0003:
    /* +0x00048 op=0x85 00 05 10 01 ADD64_IMM16: s5 = s0 +0x110 */
    S[5] = S[0] + 0x110;

L_0004:
    /* +0x00060 op=0xae 03 05 09 00 BR_EQ64: if (s3 == s5) goto record +14 */
    if (S[3] == S[5]) goto L_000e;

L_0005:
    /* +0x00078 op=0x73 13 07 01 08 ROR64_IMM: s1 = ror64(s7, 8) */
    S[1] = ror64(S[7], 8);

L_0006:
    /* +0x00090 op=0x84 04 03 07 14 ADD64: s7 = s4 + s3 */
    S[7] = S[4] + S[3];

L_0007:
    /* +0x000a8 op=0x85 03 03 08 00 ADD64_IMM16: s3 = s3 +0x8 */
    S[3] = S[3] + 0x8;

L_0008:
    /* +0x000c0 op=0x58 07 07 00 00 LD64: s7 = *(uint64_t *)(s7 +0x0) */
    S[7] = *(uint64_t *)((uint8_t *)S[7] + 0x0);

L_0009:
    /* +0x000d8 op=0x84 01 02 01 00 ADD64: s1 = s1 + s2 */
    S[1] = S[1] + S[2];

L_000a:
    /* +0x000f0 op=0x02 07 01 07 01 XOR64: s7 = s1 ^ s7 */
    S[7] = S[1] ^ S[7];

L_000b:
    /* +0x00108 op=0x72 01 02 01 1d ROL64_32MINUS_IMM: s1 = rol64(s2, 32 - 29) */
    S[1] = rol64(S[2], 32 - 29);

L_000c:
    /* +0x00120 op=0x02 07 01 02 01 XOR64: s2 = s1 ^ s7 */
    S[2] = S[1] ^ S[7];

L_000d:
    /* +0x00138 op=0xa7 03 05 f7 ff BR_NE64: if (s3 != s5) goto record +5 */
    if (S[3] != S[5]) goto L_0005;

L_000e:
    /* +0x00150 op=0x25 06 07 08 00 ST64: *(s6 +0x8) = s7 */
    *(uint64_t *)((uint8_t *)S[6] + 0x8) = S[7];

L_000f:
    /* +0x00168 op=0x25 06 02 00 00 ST64: *(s6 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[6] + 0x0) = S[2];

L_0010:
    /* +0x00180 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

/*
 * Auto-generated linear C-like lift for 350.101 managed program F3.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F3_0x750000_0xd8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F3_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x58 04 01 00 00 LD64: s1 = *(uint64_t *)(s4 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_0001:
    /* +0x00018 op=0x58 04 02 10 00 LD64: s2 = *(uint64_t *)(s4 +0x10) */
    S[2] = *(uint64_t *)((uint8_t *)S[4] + 0x10);

L_0002:
    /* +0x00030 op=0x02 02 01 01 01 XOR64: s1 = s1 ^ s2 */
    S[1] = S[1] ^ S[2];

L_0003:
    /* +0x00048 op=0x25 05 01 00 00 ST64: *(s5 +0x0) = s1 */
    *(uint64_t *)((uint8_t *)S[5] + 0x0) = S[1];

L_0004:
    /* +0x00060 op=0x58 04 01 08 00 LD64: s1 = *(uint64_t *)(s4 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x8);

L_0005:
    /* +0x00078 op=0x58 04 02 18 00 LD64: s2 = *(uint64_t *)(s4 +0x18) */
    S[2] = *(uint64_t *)((uint8_t *)S[4] + 0x18);

L_0006:
    /* +0x00090 op=0x02 02 01 01 00 XOR64: s1 = s1 ^ s2 */
    S[1] = S[1] ^ S[2];

L_0007:
    /* +0x000a8 op=0x25 05 01 08 00 ST64: *(s5 +0x8) = s1 */
    *(uint64_t *)((uint8_t *)S[5] + 0x8) = S[1];

L_0008:
    /* +0x000c0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

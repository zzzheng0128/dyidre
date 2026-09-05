/*
 * Auto-generated linear C-like lift for 350.101 managed program F38.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F38_0x614880_0x330.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F38_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 05 02 20 00 ADD64_IMM16: s2 = s5 +0x20 */
    S[2] = S[5] + 0x20;

L_0001:
    /* +0x00018 op=0x85 04 03 20 00 ADD64_IMM16: s3 = s4 +0x20 */
    S[3] = S[4] + 0x20;

L_0002:
    /* +0x00030 op=0x85 00 04 00 00 ADD64_IMM16: s4 = s0 +0x0 */
    S[4] = S[0] + 0x0;

L_0003:
    /* +0x00048 op=0x85 00 05 00 08 ADD64_IMM16: s5 = s0 +0x800 */
    S[5] = S[0] + 0x800;

L_0004:
    /* +0x00060 op=0xae 04 05 1c 00 BR_EQ64: if (s4 == s5) goto record +33 */
    if (S[4] == S[5]) goto L_0021;

L_0005:
    /* +0x00078 op=0x84 03 04 06 14 ADD64: s6 = s3 + s4 */
    S[6] = S[3] + S[4];

L_0006:
    /* +0x00090 op=0x84 02 04 01 04 ADD64: s1 = s2 + s4 */
    S[1] = S[2] + S[4];

L_0007:
    /* +0x000a8 op=0x85 04 04 40 00 ADD64_IMM16: s4 = s4 +0x40 */
    S[4] = S[4] + 0x40;

L_0008:
    /* +0x000c0 op=0x58 06 07 e0 ff LD64: s7 = *(uint64_t *)(s6 -0x20) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + (-0x20));

L_0009:
    /* +0x000d8 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_000a:
    /* +0x000f0 op=0x25 01 07 f0 ff ST64: *(s1 -0x10) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + (-0x10)) = S[7];

L_000b:
    /* +0x00108 op=0x58 06 07 e8 ff LD64: s7 = *(uint64_t *)(s6 -0x18) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + (-0x18));

L_000c:
    /* +0x00120 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_000d:
    /* +0x00138 op=0x25 01 07 e0 ff ST64: *(s1 -0x20) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + (-0x20)) = S[7];

L_000e:
    /* +0x00150 op=0x58 06 07 f0 ff LD64: s7 = *(uint64_t *)(s6 -0x10) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + (-0x10));

L_000f:
    /* +0x00168 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_0010:
    /* +0x00180 op=0x25 01 07 10 00 ST64: *(s1 +0x10) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + 0x10) = S[7];

L_0011:
    /* +0x00198 op=0x58 06 07 f8 ff LD64: s7 = *(uint64_t *)(s6 -0x8) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + (-0x8));

L_0012:
    /* +0x001b0 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_0013:
    /* +0x001c8 op=0x25 01 07 e8 ff ST64: *(s1 -0x18) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + (-0x18)) = S[7];

L_0014:
    /* +0x001e0 op=0x58 06 07 00 00 LD64: s7 = *(uint64_t *)(s6 +0x0) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + 0x0);

L_0015:
    /* +0x001f8 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_0016:
    /* +0x00210 op=0x25 01 07 08 00 ST64: *(s1 +0x8) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + 0x8) = S[7];

L_0017:
    /* +0x00228 op=0x58 06 07 08 00 LD64: s7 = *(uint64_t *)(s6 +0x8) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + 0x8);

L_0018:
    /* +0x00240 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_0019:
    /* +0x00258 op=0x25 01 07 f8 ff ST64: *(s1 -0x8) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + (-0x8)) = S[7];

L_001a:
    /* +0x00270 op=0x58 06 07 10 00 LD64: s7 = *(uint64_t *)(s6 +0x10) */
    S[7] = *(uint64_t *)((uint8_t *)S[6] + 0x10);

L_001b:
    /* +0x00288 op=0x72 01 07 07 05 ROL64_32MINUS_IMM: s7 = rol64(s7, 32 - 5) */
    S[7] = rol64(S[7], 32 - 5);

L_001c:
    /* +0x002a0 op=0x25 01 07 18 00 ST64: *(s1 +0x18) = s7 */
    *(uint64_t *)((uint8_t *)S[1] + 0x18) = S[7];

L_001d:
    /* +0x002b8 op=0x58 06 06 18 00 LD64: s6 = *(uint64_t *)(s6 +0x18) */
    S[6] = *(uint64_t *)((uint8_t *)S[6] + 0x18);

L_001e:
    /* +0x002d0 op=0x72 01 06 06 05 ROL64_32MINUS_IMM: s6 = rol64(s6, 32 - 5) */
    S[6] = rol64(S[6], 32 - 5);

L_001f:
    /* +0x002e8 op=0x25 01 06 00 00 ST64: *(s1 +0x0) = s6 */
    *(uint64_t *)((uint8_t *)S[1] + 0x0) = S[6];

L_0020:
    /* +0x00300 op=0xa7 04 05 e4 ff BR_NE64: if (s4 != s5) goto record +5 */
    if (S[4] != S[5]) goto L_0005;

L_0021:
    /* +0x00318 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

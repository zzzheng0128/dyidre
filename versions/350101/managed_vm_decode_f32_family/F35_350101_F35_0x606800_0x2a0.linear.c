/*
 * Auto-generated linear C-like lift for 350.101 managed program F35.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/unidbg-android/target/managed_program_f32_family_350101_20260831_045757/350101_F35_0x606800_0x2a0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F35_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0xb2 04 01 ff 00 AND64_IMM16: s1 = s4 & 0xff q1=0xffff080000001d1a */
    S[1] = S[4] & 0xff;

L_0001:
    /* +0x00018 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 q1=0x2001d */
    S[3] = S[0] + 0x0;

L_0002:
    /* +0x00030 op=0x85 00 04 10 00 ADD64_IMM16: s4 = s0 +0x10 q1=0x20108010f */
    S[4] = S[0] + 0x10;

L_0003:
    /* +0x00048 op=0x6e 00 01 01 04 SHL64_IMM: s1 = s1 << 4 q1=0xa1d19 */
    S[1] = S[1] << 4;

L_0004:
    /* +0x00060 op=0x84 01 06 01 00 ADD64: s1 = s1 + s6 q1=0x1b0000010109 */
    S[1] = S[1] + S[6];

L_0005:
    /* +0x00078 op=0x85 01 02 03 00 ADD64_IMM16: s2 = s1 +0x3 q1=0x201f1f010009 */
    S[2] = S[1] + 0x3;

L_0006:
    /* +0x00090 op=0xae 03 04 14 00 BR_EQ64: if (s3 == s4) goto record +27 q1=0x200000010009 */
    if (S[3] == S[4]) goto L_001b;

L_0007:
    /* +0x000a8 op=0x84 02 03 01 04 ADD64: s1 = s2 + s3 q1=0x1b0000070232 */
    S[1] = S[2] + S[3];

L_0008:
    /* +0x000c0 op=0x84 05 03 07 14 ADD64: s7 = s5 + s3 q1=0x1f010e00052c */
    S[7] = S[5] + S[3];

L_0009:
    /* +0x000d8 op=0x85 03 03 04 00 ADD64_IMM16: s3 = s3 +0x4 q1=0x3014010b083e */
    S[3] = S[3] + 0x4;

L_000a:
    /* +0x000f0 op=0x59 01 06 fd ff LD8U: s6 = *(uint8_t *)(s1 -0x3) q1=0x40000000e32 */
    S[6] = *(uint8_t *)((uint8_t *)S[1] + (-0x3));

L_000b:
    /* +0x00108 op=0x59 07 08 03 00 LD8U: s8 = *(uint8_t *)(s7 +0x3) q1=0x100000e0e09 */
    S[8] = *(uint8_t *)((uint8_t *)S[7] + 0x3);

L_000c:
    /* +0x00120 op=0x02 08 06 06 00 XOR64: s6 = s6 ^ s8 q1=0x3c1f1f000e18 */
    S[6] = S[6] ^ S[8];

L_000d:
    /* +0x00138 op=0x26 07 06 03 00 ST8: *(s7 +0x3) = (uint8_t)s6 q1=0x2f010e00093e */
    *(uint8_t *)((uint8_t *)S[7] + 0x3) = (uint8_t)S[6];

L_000e:
    /* +0x00150 op=0x59 07 06 00 00 LD8U: s6 = *(uint8_t *)(s7 +0x0) q1=0x1010e0000 */
    S[6] = *(uint8_t *)((uint8_t *)S[7] + 0x0);

L_000f:
    /* +0x00168 op=0x59 01 08 fe ff LD8U: s8 = *(uint8_t *)(s1 -0x2) q1=0x100000e010d */
    S[8] = *(uint8_t *)((uint8_t *)S[1] + (-0x2));

L_0010:
    /* +0x00180 op=0x02 06 08 06 01 XOR64: s6 = s8 ^ s6 q1=0x2c01010c032c */
    S[6] = S[8] ^ S[6];

L_0011:
    /* +0x00198 op=0x26 07 06 00 00 ST8: *(s7 +0x0) = (uint8_t)s6 q1=0x2d000b0b0a00 */
    *(uint8_t *)((uint8_t *)S[7] + 0x0) = (uint8_t)S[6];

L_0012:
    /* +0x001b0 op=0x59 07 08 02 00 LD8U: s8 = *(uint8_t *)(s7 +0x2) q1=0x1e0101010d2c */
    S[8] = *(uint8_t *)((uint8_t *)S[7] + 0x2);

L_0013:
    /* +0x001c8 op=0x59 01 09 ff ff LD8U: s9 = *(uint8_t *)(s1 -0x1) q1=0x24000c0d0c00 */
    S[9] = *(uint8_t *)((uint8_t *)S[1] + (-0x1));

L_0014:
    /* +0x001e0 op=0x59 07 06 01 00 LD8U: s6 = *(uint8_t *)(s7 +0x1) q1=0x10b2b */
    S[6] = *(uint8_t *)((uint8_t *)S[7] + 0x1);

L_0015:
    /* +0x001f8 op=0x02 08 09 08 01 XOR64: s8 = s9 ^ s8 q1=0x42a */
    S[8] = S[9] ^ S[8];

L_0016:
    /* +0x00210 op=0x26 07 08 02 00 ST8: *(s7 +0x2) = (uint8_t)s8 q1=0x80000021d1e */
    *(uint8_t *)((uint8_t *)S[7] + 0x2) = (uint8_t)S[8];

L_0017:
    /* +0x00228 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) q1=0x8000001043f */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0018:
    /* +0x00240 op=0x02 06 01 01 01 XOR64: s1 = s1 ^ s6 q1=0xa0000001f00 */
    S[1] = S[1] ^ S[6];

L_0019:
    /* +0x00258 op=0x26 07 01 01 00 ST8: *(s7 +0x1) = (uint8_t)s1 q1=0x80100011037 */
    *(uint8_t *)((uint8_t *)S[7] + 0x1) = (uint8_t)S[1];

L_001a:
    /* +0x00270 op=0xa7 03 04 ec ff BR_NE64: if (s3 != s4) goto record +7 q1=0x8010001103f */
    if (S[3] != S[4]) goto L_0007;

L_001b:
    /* +0x00288 op=0x5b 1f 00 00 00 RET: return/leave with s31 q1=0x100011037 */
    return; /* RET s31 */

}

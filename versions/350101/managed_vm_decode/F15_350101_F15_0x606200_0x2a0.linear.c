/*
 * Auto-generated linear C-like lift for 350.101 managed program F15.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F15_0x606200_0x2a0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F15_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x54 00 01 31 16 CONST_HI16: s1 = sign_extend_32(0x1631 << 16) q1=0xffff1800001f1d2a */
    S[1] = (int32_t)(0x1631 << 16);

L_0001:
    /* +0x00018 op=0x54 05 07 8d e3 CONST_HI16: s7 = sign_extend_32(0xe38d << 16) q1=0x80000101d1a */
    S[7] = (int32_t)(0xe38d << 16);

L_0002:
    /* +0x00030 op=0x54 00 08 fb b0 CONST_HI16: s8 = sign_extend_32(0xb0fb << 16) q1=0x2f011000043e */
    S[8] = (int32_t)(0xb0fb << 16);

L_0003:
    /* +0x00048 op=0x54 02 02 6f a9 CONST_HI16: s2 = sign_extend_32(0xa96f << 16) q1=0x20013 */
    S[2] = (int32_t)(0xa96f << 16);

L_0004:
    /* +0x00060 op=0x54 05 03 8a da CONST_HI16: s3 = sign_extend_32(0xda8a << 16) q1=0x20100004010d */
    S[3] = (int32_t)(0xda8a << 16);

L_0005:
    /* +0x00078 op=0x54 00 05 24 17 CONST_HI16: s5 = sign_extend_32(0x1724 << 16) q1=0x130000030204 */
    S[5] = (int32_t)(0x1724 << 16);

L_0006:
    /* +0x00090 op=0x54 05 06 14 49 CONST_HI16: s6 = sign_extend_32(0x4914 << 16) q1=0x70000000105 */
    S[6] = (int32_t)(0x4914 << 16);

L_0007:
    /* +0x000a8 op=0x33 07 07 4d ee OR_IMM16: s7 = s7 | 0xee4d q1=0x1d010104013e */
    S[7] = S[7] | 0xee4d;

L_0008:
    /* +0x000c0 op=0x33 08 08 4e 0e OR_IMM16: s8 = s8 | 0xe4e q1=0x2d010104012c */
    S[8] = S[8] | 0xe4e;

L_0009:
    /* +0x000d8 op=0x33 01 01 aa 38 OR_IMM16: s1 = s1 | 0x38aa q1=0x1d010404013e */
    S[1] = S[1] | 0x38aa;

L_000a:
    /* +0x000f0 op=0x33 02 02 bc 30 OR_IMM16: s2 = s2 | 0x30bc q1=0x10524 */
    S[2] = S[2] | 0x30bc;

L_000b:
    /* +0x00108 op=0x33 06 06 b9 b2 OR_IMM16: s6 = s6 | 0xb2b9 q1=0x1f010101062c */
    S[6] = S[6] | 0xb2b9;

L_000c:
    /* +0x00120 op=0x33 05 05 d7 42 OR_IMM16: s5 = s5 | 0x42d7 q1=0x260004060400 */
    S[5] = S[5] | 0x42d7;

L_000d:
    /* +0x00138 op=0x33 03 03 00 06 OR_IMM16: s3 = s3 | 0x600 q1=0x270004000100 */
    S[3] = S[3] | 0x600;

L_000e:
    /* +0x00150 op=0x08 04 08 24 00 ST32: *(s4 +0x24) = (uint32_t)s8 q1=0x10000050519 */
    *(uint32_t *)((uint8_t *)S[4] + 0x24) = (uint32_t)S[8];

L_000f:
    /* +0x00168 op=0x08 04 07 20 00 ST32: *(s4 +0x20) = (uint32_t)s7 q1=0x40000041e2b */
    *(uint32_t *)((uint8_t *)S[4] + 0x20) = (uint32_t)S[7];

L_0010:
    /* +0x00180 op=0x08 04 01 1c 00 ST32: *(s4 +0x1c) = (uint32_t)s1 q1=0x40000051e19 */
    *(uint32_t *)((uint8_t *)S[4] + 0x1c) = (uint32_t)S[1];

L_0011:
    /* +0x00198 op=0x54 00 01 80 73 CONST_HI16: s1 = sign_extend_32(0x7380 << 16) q1=0xe0000000014 */
    S[1] = (int32_t)(0x7380 << 16);

L_0012:
    /* +0x001b0 op=0x08 04 02 18 00 ST32: *(s4 +0x18) = (uint32_t)s2 q1=0x3b0300010122 */
    *(uint32_t *)((uint8_t *)S[4] + 0x18) = (uint32_t)S[2];

L_0013:
    /* +0x001c8 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 q1=0x1f011d001e2c */
    S[2] = S[0] + 0x0;

L_0014:
    /* +0x001e0 op=0x08 04 03 14 00 ST32: *(s4 +0x14) = (uint32_t)s3 q1=0x1000001e1d1e */
    *(uint32_t *)((uint8_t *)S[4] + 0x14) = (uint32_t)S[3];

L_0015:
    /* +0x001f8 op=0x08 04 05 10 00 ST32: *(s4 +0x10) = (uint32_t)s5 q1=0x2000001d1d1d */
    *(uint32_t *)((uint8_t *)S[4] + 0x10) = (uint32_t)S[5];

L_0016:
    /* +0x00210 op=0x08 04 06 0c 00 ST32: *(s4 +0xc) = (uint32_t)s6 */
    *(uint32_t *)((uint8_t *)S[4] + 0xc) = (uint32_t)S[6];

L_0017:
    /* +0x00228 op=0x08 04 00 04 00 ST32: *(s4 +0x4) = (uint32_t)s0 */
    *(uint32_t *)((uint8_t *)S[4] + 0x4) = (uint32_t)S[0];

L_0018:
    /* +0x00240 op=0x08 04 00 00 00 ST32: *(s4 +0x0) = (uint32_t)s0 */
    *(uint32_t *)((uint8_t *)S[4] + 0x0) = (uint32_t)S[0];

L_0019:
    /* +0x00258 op=0x33 01 01 6f 16 OR_IMM16: s1 = s1 | 0x166f */
    S[1] = S[1] | 0x166f;

L_001a:
    /* +0x00270 op=0x08 04 01 08 00 ST32: *(s4 +0x8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[4] + 0x8) = (uint32_t)S[1];

L_001b:
    /* +0x00288 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

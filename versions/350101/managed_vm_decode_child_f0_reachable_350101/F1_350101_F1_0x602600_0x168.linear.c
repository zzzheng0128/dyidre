/*
 * Auto-generated linear C-like lift for 350.101 managed program F1.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F1_0x602600_0x168.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F1_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x54 05 01 c2 eb CONST_HI16: s1 = sign_extend_32(0xebc2 << 16) q1=0xffff2801001f1d3f */
    S[1] = (int32_t)(0xebc2 << 16);

L_0001:
    /* +0x00018 op=0x54 05 02 10 7c CONST_HI16: s2 = sign_extend_32(0x7c10 << 16) q1=0x180100131d1a */
    S[2] = (int32_t)(0x7c10 << 16);

L_0002:
    /* +0x00030 op=0x54 02 03 b5 c8 CONST_HI16: s3 = sign_extend_32(0xc8b5 << 16) q1=0x480080100111d1a */
    S[3] = (int32_t)(0xc8b5 << 16);

L_0003:
    /* +0x00048 op=0x33 01 01 cd f8 OR_IMM16: s1 = s1 | 0xf8cd q1=0x4402f011e001d3e */
    S[1] = S[1] | 0xf8cd;

L_0004:
    /* +0x00060 op=0x33 02 02 93 4d OR_IMM16: s2 = s2 | 0x4d93 q1=0x782f011200053e */
    S[2] = S[2] | 0x4d93;

L_0005:
    /* +0x00078 op=0x08 04 01 10 00 ST32: *(s4 +0x10) = (uint32_t)s1 q1=0x48300000001e3f */
    *(uint32_t *)((uint8_t *)S[4] + 0x10) = (uint32_t)S[1];

L_0006:
    /* +0x00090 op=0x33 03 01 70 25 OR_IMM16: s1 = s3 | 0x2570 q1=0x281f380000001e2b */
    S[1] = S[3] | 0x2570;

L_0007:
    /* +0x000a8 op=0x08 04 02 14 00 ST32: *(s4 +0x14) = (uint32_t)s2 q1=0x110000004121e */
    *(uint32_t *)((uint8_t *)S[4] + 0x14) = (uint32_t)S[2];

L_0008:
    /* +0x000c0 op=0x08 04 00 04 00 ST32: *(s4 +0x4) = (uint32_t)s0 q1=0x3280000061e19 */
    *(uint32_t *)((uint8_t *)S[4] + 0x4) = (uint32_t)S[0];

L_0009:
    /* +0x000d8 op=0x08 04 00 00 00 ST32: *(s4 +0x0) = (uint32_t)s0 q1=0x83070000000012 */
    *(uint32_t *)((uint8_t *)S[4] + 0x0) = (uint32_t)S[0];

L_000a:
    /* +0x000f0 op=0x08 04 01 0c 00 ST32: *(s4 +0xc) = (uint32_t)s1 q1=0x4000000005010f */
    *(uint32_t *)((uint8_t *)S[4] + 0xc) = (uint32_t)S[1];

L_000b:
    /* +0x00108 op=0x54 02 01 e0 79 CONST_HI16: s1 = sign_extend_32(0x79e0 << 16) q1=0xf250004001200 */
    S[1] = (int32_t)(0x79e0 << 16);

L_000c:
    /* +0x00120 op=0x33 01 01 fb f2 OR_IMM16: s1 = s1 | 0xf2fb q1=0x682f010400133e */
    S[1] = S[1] | 0xf2fb;

L_000d:
    /* +0x00138 op=0x08 04 01 08 00 ST32: *(s4 +0x8) = (uint32_t)s1 q1=0x937090000000003 */
    *(uint32_t *)((uint8_t *)S[4] + 0x8) = (uint32_t)S[1];

L_000e:
    /* +0x00150 op=0x5b 1f 00 00 00 RET: return/leave with s31 q1=0x81250013000200 */
    return; /* RET s31 */

}

/*
 * Auto-generated linear C-like lift for 350.101 managed program F82.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F82_0x5e4400_0x3c0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F82_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0001:
    /* +0x00018 op=0x85 00 03 0b 00 ADD64_IMM16: s3 = s0 +0xb */
    S[3] = S[0] + 0xb;

L_0002:
    /* +0x00030 op=0xb5 00 06 c0 ff ADD32_IMM16: s6 = int32(s0 -0x40) */
    S[6] = (int32_t)((uint32_t)S[0] + (-0x40));

L_0003:
    /* +0x00048 op=0x53 03 07 40 0b LD_POOL_PTR: s7 = *(uint64_t *)q1 + 0xb40 q1=0x125fd3a8 */
    S[7] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xb40;

L_0004:
    /* +0x00060 op=0xb5 00 08 40 00 ADD32_IMM16: s8 = int32(s0 +0x40) */
    S[8] = (int32_t)((uint32_t)S[0] + 0x40);

L_0005:
    /* +0x00078 op=0x85 00 09 ff ff ADD64_IMM16: s9 = s0 -0x1 */
    S[9] = S[0] + (-0x1);

L_0006:
    /* +0x00090 op=0x34 02 00 0a 01 OR64: s10 = s2 | s0 */
    S[10] = S[2] | S[0];

L_0007:
    /* +0x000a8 op=0xae 0a 03 1f 00 BR_EQ64: if (s10 == s3) goto record +39 */
    if (S[10] == S[3]) goto L_0027;

L_0008:
    /* +0x000c0 op=0x52 04 01 40 01 LD32S: s1 = *(int32_t *)(s4 +0x140) */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0x140);

L_0009:
    /* +0x000d8 op=0x6e 00 0a 0b 03 SHL64_IMM: s11 = s10 << 3 */
    S[11] = S[10] << 3;

L_000a:
    /* +0x000f0 op=0x34 02 00 18 01 OR64: s24 = s2 | s0 */
    S[24] = S[2] | S[0];

L_000b:
    /* +0x00108 op=0xb5 01 01 03 00 ADD32_IMM16: s1 = int32(s1 +0x3) */
    S[1] = (int32_t)((uint32_t)S[1] + 0x3);

L_000c:
    /* +0x00120 op=0xb2 01 0c 3f 00 AND64_IMM16: s12 = s1 & 0x3f */
    S[12] = S[1] & 0x3f;

L_000d:
    /* +0x00138 op=0x84 07 0b 01 04 ADD64: s1 = s7 + s11 */
    S[1] = S[7] + S[11];

L_000e:
    /* +0x00150 op=0x34 0c 06 0f 00 OR64: s15 = s12 | s6 */
    S[15] = S[12] | S[6];

L_000f:
    /* +0x00168 op=0x58 01 0d 00 00 LD64: s13 = *(uint64_t *)(s1 +0x0) */
    S[13] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0010:
    /* +0x00180 op=0x09 08 0c 0e 04 SUB32: s14 = sign_extend_32((uint32_t)s8 - (uint32_t)s12) */
    S[14] = (int32_t)((uint32_t)S[8] - (uint32_t)S[12]);

L_0011:
    /* +0x00198 op=0x34 0f 00 19 00 OR64: s25 = s15 | s0 */
    S[25] = S[15] | S[0];

L_0012:
    /* +0x001b0 op=0xae 19 00 04 00 BR_EQ64: if (s25 == s0) goto record +23 */
    if (S[25] == S[0]) goto L_0017;

L_0013:
    /* +0x001c8 op=0x6e 00 18 01 01 SHL64_IMM: s1 = s24 << 1 */
    S[1] = S[24] << 1;

L_0014:
    /* +0x001e0 op=0xb5 19 19 01 00 ADD32_IMM16: s25 = int32(s25 +0x1) */
    S[25] = (int32_t)((uint32_t)S[25] + 0x1);

L_0015:
    /* +0x001f8 op=0x33 01 18 01 00 OR_IMM16: s24 = s1 | 0x1 */
    S[24] = S[1] | 0x1;

L_0016:
    /* +0x00210 op=0xa7 19 00 fc ff BR_NE64: if (s25 != s0) goto record +19 */
    if (S[25] != S[0]) goto L_0013;

L_0017:
    /* +0x00228 op=0x34 02 00 19 01 OR64: s25 = s2 | s0 */
    S[25] = S[2] | S[0];

L_0018:
    /* +0x00240 op=0xae 0f 00 04 00 BR_EQ64: if (s15 == s0) goto record +29 */
    if (S[15] == S[0]) goto L_001d;

L_0019:
    /* +0x00258 op=0x6e 12 19 01 01 SHL64_IMM: s1 = s25 << 1 */
    S[1] = S[25] << 1;

L_001a:
    /* +0x00270 op=0xb5 0f 0f 01 00 ADD32_IMM16: s15 = int32(s15 +0x1) */
    S[15] = (int32_t)((uint32_t)S[15] + 0x1);

L_001b:
    /* +0x00288 op=0x33 01 19 01 00 OR_IMM16: s25 = s1 | 0x1 */
    S[25] = S[1] | 0x1;

L_001c:
    /* +0x002a0 op=0xa7 0f 00 fc ff BR_NE64: if (s15 != s0) goto record +25 */
    if (S[15] != S[0]) goto L_0019;

L_001d:
    /* +0x002b8 op=0x66 0c 0d 0c 00 LSR64_VAR: s12 = (uint64_t)s13 >> (s12 & 63) */
    S[12] = (uint64_t)S[13] >> (S[12] & 63);

L_001e:
    /* +0x002d0 op=0x02 19 09 01 01 XOR64: s1 = s9 ^ s25 */
    S[1] = S[9] ^ S[25];

L_001f:
    /* +0x002e8 op=0x6c 0e 0d 0e 00 SHL64_VAR: s14 = s13 << (s14 & 63) */
    S[14] = S[13] << (S[14] & 63);

L_0020:
    /* +0x00300 op=0x84 05 0b 0b 04 ADD64: s11 = s5 + s11 */
    S[11] = S[5] + S[11];

L_0021:
    /* +0x00318 op=0x85 0a 0a 01 00 ADD64_IMM16: s10 = s10 +0x1 */
    S[10] = S[10] + 0x1;

L_0022:
    /* +0x00330 op=0xb3 0e 01 01 01 AND64: s1 = s14 & s1 */
    S[1] = S[14] & S[1];

L_0023:
    /* +0x00348 op=0xb3 18 0c 0c 01 AND64: s12 = s24 & s12 */
    S[12] = S[24] & S[12];

L_0024:
    /* +0x00360 op=0x34 01 0c 01 01 OR64: s1 = s1 | s12 */
    S[1] = S[1] | S[12];

L_0025:
    /* +0x00378 op=0x25 0b 01 00 00 ST64: *(s11 +0x0) = s1 */
    *(uint64_t *)((uint8_t *)S[11] + 0x0) = S[1];

L_0026:
    /* +0x00390 op=0xa7 0a 03 e1 ff BR_NE64: if (s10 != s3) goto record +8 */
    if (S[10] != S[3]) goto L_0008;

L_0027:
    /* +0x003a8 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

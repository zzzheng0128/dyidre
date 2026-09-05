/*
 * Auto-generated linear C-like lift for 350.101 managed program F62.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F62_0x60b700_0x4b0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F62_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d f0 ff ADD64_IMM16: s29 = s29 -0x10 */
    S[29] = S[29] + (-0x10);

L_0001:
    /* +0x00018 op=0x25 1d 00 08 00 ST64: *(s29 +0x8) = s0 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[0];

L_0002:
    /* +0x00030 op=0x25 1d 00 00 00 ST64: *(s29 +0x0) = s0 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[0];

L_0003:
    /* +0x00048 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0004:
    /* +0x00060 op=0x85 00 07 04 00 ADD64_IMM16: s7 = s0 +0x4 */
    S[7] = S[0] + 0x4;

L_0005:
    /* +0x00078 op=0x53 04 08 80 08 LD_POOL_PTR: s8 = *(uint64_t *)q1 + 0x880 q1=0x125fd3a8 */
    S[8] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x880;

L_0006:
    /* +0x00090 op=0xb5 00 09 00 00 ADD32_IMM16: s9 = int32(s0 +0x0) */
    S[9] = (int32_t)((uint32_t)S[0] + 0x0);

L_0007:
    /* +0x000a8 op=0x85 1d 0a 00 00 ADD64_IMM16: s10 = s29 +0x0 */
    S[10] = S[29] + 0x0;

L_0008:
    /* +0x000c0 op=0x52 04 01 58 00 LD32S: s1 = *(int32_t *)(s4 +0x58) */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0x58);

L_0009:
    /* +0x000d8 op=0xb5 01 01 0f 00 ADD32_IMM16: s1 = int32(s1 +0xf) */
    S[1] = (int32_t)((uint32_t)S[1] + 0xf);

L_000a:
    /* +0x000f0 op=0xb2 01 03 1f 00 AND64_IMM16: s3 = s1 & 0x1f */
    S[3] = S[1] & 0x1f;

L_000b:
    /* +0x00108 op=0xb5 00 01 e0 ff ADD32_IMM16: s1 = int32(s0 -0x20) */
    S[1] = (int32_t)((uint32_t)S[0] + (-0x20));

L_000c:
    /* +0x00120 op=0x34 03 01 05 00 OR64: s5 = s3 | s1 */
    S[5] = S[3] | S[1];

L_000d:
    /* +0x00138 op=0xb5 00 01 20 00 ADD32_IMM16: s1 = int32(s0 +0x20) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x20);

L_000e:
    /* +0x00150 op=0x09 01 03 06 14 SUB32: s6 = sign_extend_32((uint32_t)s1 - (uint32_t)s3) */
    S[6] = (int32_t)((uint32_t)S[1] - (uint32_t)S[3]);

L_000f:
    /* +0x00168 op=0xae 02 07 1b 00 BR_EQ64: if (s2 == s7) goto record +43 */
    if (S[2] == S[7]) goto L_002b;

L_0010:
    /* +0x00180 op=0x6e 12 02 0b 02 SHL64_IMM: s11 = s2 << 2 */
    S[11] = S[2] << 2;

L_0011:
    /* +0x00198 op=0x34 05 00 0e 01 OR64: s14 = s5 | s0 */
    S[14] = S[5] | S[0];

L_0012:
    /* +0x001b0 op=0x34 09 00 0d 01 OR64: s13 = s9 | s0 */
    S[13] = S[9] | S[0];

L_0013:
    /* +0x001c8 op=0x84 08 0b 01 00 ADD64: s1 = s8 + s11 */
    S[1] = S[8] + S[11];

L_0014:
    /* +0x001e0 op=0x52 01 0c 00 00 LD32S: s12 = *(int32_t *)(s1 +0x0) */
    S[12] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0015:
    /* +0x001f8 op=0xae 0e 00 04 00 BR_EQ64: if (s14 == s0) goto record +26 */
    if (S[14] == S[0]) goto L_001a;

L_0016:
    /* +0x00210 op=0x18 00 0d 01 01 SHL32_IMM: s1 = (int32_t)(s13 << 1) */
    S[1] = (int32_t)((uint32_t)S[13] << 1);

L_0017:
    /* +0x00228 op=0xb5 0e 0e 01 00 ADD32_IMM16: s14 = int32(s14 +0x1) */
    S[14] = (int32_t)((uint32_t)S[14] + 0x1);

L_0018:
    /* +0x00240 op=0x33 01 0d 01 00 OR_IMM16: s13 = s1 | 0x1 */
    S[13] = S[1] | 0x1;

L_0019:
    /* +0x00258 op=0xa7 0e 00 fc ff BR_NE64: if (s14 != s0) goto record +22 */
    if (S[14] != S[0]) goto L_0016;

L_001a:
    /* +0x00270 op=0x34 05 00 0f 01 OR64: s15 = s5 | s0 */
    S[15] = S[5] | S[0];

L_001b:
    /* +0x00288 op=0x34 09 00 0e 01 OR64: s14 = s9 | s0 */
    S[14] = S[9] | S[0];

L_001c:
    /* +0x002a0 op=0xae 0f 00 04 00 BR_EQ64: if (s15 == s0) goto record +33 */
    if (S[15] == S[0]) goto L_0021;

L_001d:
    /* +0x002b8 op=0x18 10 0e 01 01 SHL32_IMM: s1 = (int32_t)(s14 << 1) */
    S[1] = (int32_t)((uint32_t)S[14] << 1);

L_001e:
    /* +0x002d0 op=0xb5 0f 0f 01 00 ADD32_IMM16: s15 = int32(s15 +0x1) */
    S[15] = (int32_t)((uint32_t)S[15] + 0x1);

L_001f:
    /* +0x002e8 op=0x33 01 0e 01 00 OR_IMM16: s14 = s1 | 0x1 */
    S[14] = S[1] | 0x1;

L_0020:
    /* +0x00300 op=0xa7 0f 00 fc ff BR_NE64: if (s15 != s0) goto record +29 */
    if (S[15] != S[0]) goto L_001d;

L_0021:
    /* +0x00318 op=0x0d 03 0c 01 01 BYTE_FROM_U32_SHIFT: s3 = (uint8_t)((uint32_t)s12 >> (s1 & 31)) */
    S[3] = (uint8_t)((uint32_t)S[12] >> (S[1] & 31));

L_0022:
    /* +0x00330 op=0x17 06 0c 0c 17 SHL32_VAR: s12 = (int32_t)((uint32_t)s12 << ((uint32_t)s6 & 31)) */
    S[12] = (int32_t)((uint32_t)S[12] << ((uint32_t)S[6] & 31));

L_0023:
    /* +0x00348 op=0x84 0a 0b 0b 04 ADD64: s11 = s10 + s11 */
    S[11] = S[10] + S[11];

L_0024:
    /* +0x00360 op=0x85 02 02 01 00 ADD64_IMM16: s2 = s2 +0x1 */
    S[2] = S[2] + 0x1;

L_0025:
    /* +0x00378 op=0xb3 0d 01 01 00 AND64: s1 = s13 & s1 */
    S[1] = S[13] & S[1];

L_0026:
    /* +0x00390 op=0x36 0e 00 0d 01 NOR64: s13 = ~(s14 | s0) */
    S[13] = ~(S[14] | S[0]);

L_0027:
    /* +0x003a8 op=0xb3 0c 0d 0c 00 AND64: s12 = s12 & s13 */
    S[12] = S[12] & S[13];

L_0028:
    /* +0x003c0 op=0x34 0c 01 01 00 OR64: s1 = s12 | s1 */
    S[1] = S[12] | S[1];

L_0029:
    /* +0x003d8 op=0x08 0b 01 00 00 ST32: *(s11 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[11] + 0x0) = (uint32_t)S[1];

L_002a:
    /* +0x003f0 op=0xa7 02 07 e5 ff BR_NE64: if (s2 != s7) goto record +16 */
    if (S[2] != S[7]) goto L_0010;

L_002b:
    /* +0x00408 op=0x25 04 00 00 00 ST64: *(s4 +0x0) = s0 */
    *(uint64_t *)((uint8_t *)S[4] + 0x0) = S[0];

L_002c:
    /* +0x00420 op=0x58 1d 01 00 00 LD64: s1 = *(uint64_t *)(s29 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_002d:
    /* +0x00438 op=0x58 1d 02 08 00 LD64: s2 = *(uint64_t *)(s29 +0x8) */
    S[2] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_002e:
    /* +0x00450 op=0x25 04 02 10 00 ST64: *(s4 +0x10) = s2 */
    *(uint64_t *)((uint8_t *)S[4] + 0x10) = S[2];

L_002f:
    /* +0x00468 op=0x25 04 01 08 00 ST64: *(s4 +0x8) = s1 */
    *(uint64_t *)((uint8_t *)S[4] + 0x8) = S[1];

L_0030:
    /* +0x00480 op=0x85 1d 1d 10 00 ADD64_IMM16: s29 = s29 +0x10 */
    S[29] = S[29] + 0x10;

L_0031:
    /* +0x00498 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

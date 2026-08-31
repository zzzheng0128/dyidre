/*
 * Auto-generated linear C-like lift for 350.101 managed program F24.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_roundfamilies_350101_20260831_053127/350101_F24_0x62fd00_0x678.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F24_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x53 03 01 08 03 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x308 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x308;

L_0001:
    /* +0x00018 op=0x85 05 03 01 00 ADD64_IMM16: s3 = s5 +0x1 */
    S[3] = S[5] + 0x1;

L_0002:
    /* +0x00030 op=0x85 04 02 01 00 ADD64_IMM16: s2 = s4 +0x1 */
    S[2] = S[4] + 0x1;

L_0003:
    /* +0x00048 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_0004:
    /* +0x00060 op=0x85 00 07 10 00 ADD64_IMM16: s7 = s0 +0x10 */
    S[7] = S[0] + 0x10;

L_0005:
    /* +0x00078 op=0x58 01 06 00 00 LD64: s6 = *(uint64_t *)(s1 +0x0) */
    S[6] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0006:
    /* +0x00090 op=0xae 05 07 10 00 BR_EQ64: if (s5 == s7) goto record +23 */
    if (S[5] == S[7]) goto L_0017;

L_0007:
    /* +0x000a8 op=0x84 03 05 08 04 ADD64: s8 = s3 + s5 */
    S[8] = S[3] + S[5];

L_0008:
    /* +0x000c0 op=0x84 02 05 01 04 ADD64: s1 = s2 + s5 */
    S[1] = S[2] + S[5];

L_0009:
    /* +0x000d8 op=0x85 05 05 04 00 ADD64_IMM16: s5 = s5 +0x4 */
    S[5] = S[5] + 0x4;

L_000a:
    /* +0x000f0 op=0x59 08 09 ff ff LD8U: s9 = *(uint8_t *)(s8 -0x1) */
    S[9] = *(uint8_t *)((uint8_t *)S[8] + (-0x1));

L_000b:
    /* +0x00108 op=0x01 09 09 72 00 XOR_IMM16: s9 = s9 ^ 0x72 */
    S[9] = S[9] ^ 0x72;

L_000c:
    /* +0x00120 op=0x26 01 09 ff ff ST8: *(s1 -0x1) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[1] + (-0x1)) = (uint8_t)S[9];

L_000d:
    /* +0x00138 op=0x59 08 09 00 00 LD8U: s9 = *(uint8_t *)(s8 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[8] + 0x0);

L_000e:
    /* +0x00150 op=0x01 09 09 de 00 XOR_IMM16: s9 = s9 ^ 0xde */
    S[9] = S[9] ^ 0xde;

L_000f:
    /* +0x00168 op=0x26 01 09 00 00 ST8: *(s1 +0x0) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[9];

L_0010:
    /* +0x00180 op=0x59 08 09 01 00 LD8U: s9 = *(uint8_t *)(s8 +0x1) */
    S[9] = *(uint8_t *)((uint8_t *)S[8] + 0x1);

L_0011:
    /* +0x00198 op=0x01 09 09 b5 00 XOR_IMM16: s9 = s9 ^ 0xb5 */
    S[9] = S[9] ^ 0xb5;

L_0012:
    /* +0x001b0 op=0x26 01 09 01 00 ST8: *(s1 +0x1) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[1] + 0x1) = (uint8_t)S[9];

L_0013:
    /* +0x001c8 op=0x59 08 08 02 00 LD8U: s8 = *(uint8_t *)(s8 +0x2) */
    S[8] = *(uint8_t *)((uint8_t *)S[8] + 0x2);

L_0014:
    /* +0x001e0 op=0x01 08 08 bb 00 XOR_IMM16: s8 = s8 ^ 0xbb */
    S[8] = S[8] ^ 0xbb;

L_0015:
    /* +0x001f8 op=0x26 01 08 02 00 ST8: *(s1 +0x2) = (uint8_t)s8 */
    *(uint8_t *)((uint8_t *)S[1] + 0x2) = (uint8_t)S[8];

L_0016:
    /* +0x00210 op=0xa7 05 07 f0 ff BR_NE64: if (s5 != s7) goto record +7 */
    if (S[5] != S[7]) goto L_0007;

L_0017:
    /* +0x00228 op=0x54 05 01 b5 bb CONST_HI16: s1 = sign_extend_32(0xbbb5 << 16) */
    S[1] = (int32_t)(0xbbb5 << 16);

L_0018:
    /* +0x00240 op=0x85 04 02 13 00 ADD64_IMM16: s2 = s4 +0x13 */
    S[2] = S[4] + 0x13;

L_0019:
    /* +0x00258 op=0x85 00 03 04 00 ADD64_IMM16: s3 = s0 +0x4 */
    S[3] = S[0] + 0x4;

L_001a:
    /* +0x00270 op=0xb5 00 04 08 00 ADD32_IMM16: s4 = int32(s0 +0x8) */
    S[4] = (int32_t)((uint32_t)S[0] + 0x8);

L_001b:
    /* +0x00288 op=0x85 00 05 0c 00 ADD64_IMM16: s5 = s0 +0xc */
    S[5] = S[0] + 0xc;

L_001c:
    /* +0x002a0 op=0x85 06 06 3a 03 ADD64_IMM16: s6 = s6 +0x33a */
    S[6] = S[6] + 0x33a;

L_001d:
    /* +0x002b8 op=0x33 01 07 72 de OR_IMM16: s7 = s1 | 0xde72 */
    S[7] = S[1] | 0xde72;

L_001e:
    /* +0x002d0 op=0xae 03 05 25 00 BR_EQ64: if (s3 == s5) goto record +68 */
    if (S[3] == S[5]) goto L_0044;

L_001f:
    /* +0x002e8 op=0x59 02 0a fc ff LD8U: s10 = *(uint8_t *)(s2 -0x4) */
    S[10] = *(uint8_t *)((uint8_t *)S[2] + (-0x4));

L_0020:
    /* +0x00300 op=0x59 02 09 fa ff LD8U: s9 = *(uint8_t *)(s2 -0x6) */
    S[9] = *(uint8_t *)((uint8_t *)S[2] + (-0x6));

L_0021:
    /* +0x00318 op=0x59 02 08 f9 ff LD8U: s8 = *(uint8_t *)(s2 -0x7) */
    S[8] = *(uint8_t *)((uint8_t *)S[2] + (-0x7));

L_0022:
    /* +0x00330 op=0x59 02 0b fb ff LD8U: s11 = *(uint8_t *)(s2 -0x5) */
    S[11] = *(uint8_t *)((uint8_t *)S[2] + (-0x5));

L_0023:
    /* +0x00348 op=0xb2 03 01 03 00 AND64_IMM16: s1 = s3 & 0x3 */
    S[1] = S[3] & 0x3;

L_0024:
    /* +0x00360 op=0xa7 01 00 0f 00 BR_NE64: if (s1 != s0) goto record +52 */
    if (S[1] != S[0]) goto L_0034;

L_0025:
    /* +0x00378 op=0xb2 09 09 ff 00 AND64_IMM16: s9 = s9 & 0xff */
    S[9] = S[9] & 0xff;

L_0026:
    /* +0x00390 op=0xb2 0a 01 ff 00 AND64_IMM16: s1 = s10 & 0xff */
    S[1] = S[10] & 0xff;

L_0027:
    /* +0x003a8 op=0xb2 08 08 ff 00 AND64_IMM16: s8 = s8 & 0xff */
    S[8] = S[8] & 0xff;

L_0028:
    /* +0x003c0 op=0xb2 0b 0c ff 00 AND64_IMM16: s12 = s11 & 0xff */
    S[12] = S[11] & 0xff;

L_0029:
    /* +0x003d8 op=0x84 06 09 09 00 ADD64: s9 = s6 + s9 */
    S[9] = S[6] + S[9];

L_002a:
    /* +0x003f0 op=0x84 06 08 0a 14 ADD64: s10 = s6 + s8 */
    S[10] = S[6] + S[8];

L_002b:
    /* +0x00408 op=0xb2 04 08 18 00 AND64_IMM16: s8 = s4 & 0x18 */
    S[8] = S[4] & 0x18;

L_002c:
    /* +0x00420 op=0x84 06 01 01 14 ADD64: s1 = s6 + s1 */
    S[1] = S[6] + S[1];

L_002d:
    /* +0x00438 op=0x59 09 09 00 00 LD8U: s9 = *(uint8_t *)(s9 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[9] + 0x0);

L_002e:
    /* +0x00450 op=0x0d 08 07 08 00 BYTE_FROM_U32_SHIFT: s8 = (uint8_t)((uint32_t)s7 >> (s8 & 31)) */
    S[8] = (uint8_t)((uint32_t)S[7] >> (S[8] & 31));

L_002f:
    /* +0x00468 op=0x59 01 0b 00 00 LD8U: s11 = *(uint8_t *)(s1 +0x0) */
    S[11] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0030:
    /* +0x00480 op=0x84 06 0c 01 04 ADD64: s1 = s6 + s12 */
    S[1] = S[6] + S[12];

L_0031:
    /* +0x00498 op=0x59 0a 0a 00 00 LD8U: s10 = *(uint8_t *)(s10 +0x0) */
    S[10] = *(uint8_t *)((uint8_t *)S[10] + 0x0);

L_0032:
    /* +0x004b0 op=0x02 09 08 08 01 XOR64: s8 = s8 ^ s9 */
    S[8] = S[8] ^ S[9];

L_0033:
    /* +0x004c8 op=0x59 01 09 00 00 LD8U: s9 = *(uint8_t *)(s1 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0034:
    /* +0x004e0 op=0x59 02 01 ef ff LD8U: s1 = *(uint8_t *)(s2 -0x11) */
    S[1] = *(uint8_t *)((uint8_t *)S[2] + (-0x11));

L_0035:
    /* +0x004f8 op=0x59 02 0c f0 ff LD8U: s12 = *(uint8_t *)(s2 -0x10) */
    S[12] = *(uint8_t *)((uint8_t *)S[2] + (-0x10));

L_0036:
    /* +0x00510 op=0xb5 04 04 02 00 ADD32_IMM16: s4 = int32(s4 +0x2) */
    S[4] = (int32_t)((uint32_t)S[4] + 0x2);

L_0037:
    /* +0x00528 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_0038:
    /* +0x00540 op=0x02 01 0b 01 01 XOR64: s1 = s11 ^ s1 */
    S[1] = S[11] ^ S[1];

L_0039:
    /* +0x00558 op=0x59 02 0b ee ff LD8U: s11 = *(uint8_t *)(s2 -0x12) */
    S[11] = *(uint8_t *)((uint8_t *)S[2] + (-0x12));

L_003a:
    /* +0x00570 op=0x02 0c 0a 0a 00 XOR64: s10 = s10 ^ s12 */
    S[10] = S[10] ^ S[12];

L_003b:
    /* +0x00588 op=0x02 0b 09 09 00 XOR64: s9 = s9 ^ s11 */
    S[9] = S[9] ^ S[11];

L_003c:
    /* +0x005a0 op=0x59 02 0b ed ff LD8U: s11 = *(uint8_t *)(s2 -0x13) */
    S[11] = *(uint8_t *)((uint8_t *)S[2] + (-0x13));

L_003d:
    /* +0x005b8 op=0x02 0b 08 08 01 XOR64: s8 = s8 ^ s11 */
    S[8] = S[8] ^ S[11];

L_003e:
    /* +0x005d0 op=0x26 02 08 fd ff ST8: *(s2 -0x3) = (uint8_t)s8 */
    *(uint8_t *)((uint8_t *)S[2] + (-0x3)) = (uint8_t)S[8];

L_003f:
    /* +0x005e8 op=0x26 02 09 fe ff ST8: *(s2 -0x2) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[2] + (-0x2)) = (uint8_t)S[9];

L_0040:
    /* +0x00600 op=0x26 02 01 ff ff ST8: *(s2 -0x1) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[2] + (-0x1)) = (uint8_t)S[1];

L_0041:
    /* +0x00618 op=0x26 02 0a 00 00 ST8: *(s2 +0x0) = (uint8_t)s10 */
    *(uint8_t *)((uint8_t *)S[2] + 0x0) = (uint8_t)S[10];

L_0042:
    /* +0x00630 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0043:
    /* +0x00648 op=0xa7 03 05 db ff BR_NE64: if (s3 != s5) goto record +31 */
    if (S[3] != S[5]) goto L_001f;

L_0044:
    /* +0x00660 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

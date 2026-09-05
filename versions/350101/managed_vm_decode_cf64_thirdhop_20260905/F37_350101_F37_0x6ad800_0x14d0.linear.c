/*
 * Auto-generated linear C-like lift for 350.101 managed program F37.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F37_0x6ad800_0x14d0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F37_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 90 fe ADD64_IMM16: s29 = s29 -0x170 */
    S[29] = S[29] + (-0x170);

L_0001:
    /* +0x00018 op=0x25 1d 1f 68 01 ST64: *(s29 +0x168) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x168) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 60 01 ST64: *(s29 +0x160) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x160) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 58 01 ST64: *(s29 +0x158) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x158) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 50 01 ST64: *(s29 +0x150) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x150) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 48 01 ST64: *(s29 +0x148) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x148) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 40 01 ST64: *(s29 +0x140) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x140) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 38 01 ST64: *(s29 +0x138) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x138) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 30 01 ST64: *(s29 +0x130) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x130) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 28 01 ST64: *(s29 +0x128) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x128) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 20 01 ST64: *(s29 +0x120) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x120) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x85 00 13 00 01 ADD64_IMM16: s19 = s0 +0x100 */
    S[19] = S[0] + 0x100;

L_000d:
    /* +0x00138 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_000e:
    /* +0x00150 op=0x85 1e 11 00 00 ADD64_IMM16: s17 = s30 +0x0 */
    S[17] = S[30] + 0x0;

L_000f:
    /* +0x00168 op=0x34 05 00 14 01 OR64: s20 = s5 | s0 */
    S[20] = S[5] | S[0];

L_0010:
    /* +0x00180 op=0x34 04 00 10 01 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_0011:
    /* +0x00198 op=0x25 1e 00 18 01 ST64: *(s30 +0x118) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x118) = S[0];

L_0012:
    /* +0x001b0 op=0x25 1e 00 10 01 ST64: *(s30 +0x110) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x110) = S[0];

L_0013:
    /* +0x001c8 op=0x25 1e 00 08 01 ST64: *(s30 +0x108) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x108) = S[0];

L_0014:
    /* +0x001e0 op=0x25 1e 00 00 01 ST64: *(s30 +0x100) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x100) = S[0];

L_0015:
    /* +0x001f8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0016:
    /* +0x00210 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_0017:
    /* +0x00228 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 */
    S[6] = S[19] | S[0];

L_0018:
    /* +0x00240 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0019:
    /* +0x00258 op=0x18 11 14 03 00 SHL32_IMM: s3 = (int32_t)(s20 << 0) */
    S[3] = (int32_t)((uint32_t)S[20] << 0);

L_001a:
    /* +0x00270 op=0xb5 00 02 00 ff ADD32_IMM16: s2 = int32(s0 -0x100) */
    S[2] = (int32_t)((uint32_t)S[0] + (-0x100));

L_001b:
    /* +0x00288 op=0x53 03 04 a1 04 LD_POOL_PTR: s4 = *(uint64_t *)q1 + 0x4a1 q1=0x125fd3a8 */
    S[4] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x4a1;

L_001c:
    /* +0x002a0 op=0x34 03 00 05 00 OR64: s5 = s3 | s0 */
    S[5] = S[3] | S[0];

L_001d:
    /* +0x002b8 op=0xae 12 13 0f 00 BR_EQ64: if (s18 == s19) goto record +45 */
    if (S[18] == S[19]) goto L_002d;

L_001e:
    /* +0x002d0 op=0x10 0e 05 01 1f ASR32_IMM: s1 = sign_extend_32((int32_t)s5 >> 31) */
    S[1] = (int32_t)((int32_t)S[5] >> 31);

L_001f:
    /* +0x002e8 op=0x84 11 12 06 14 ADD64: s6 = s17 + s18 */
    S[6] = S[17] + S[18];

L_0020:
    /* +0x00300 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_0021:
    /* +0x00318 op=0x0e 0b 01 01 18 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 24) */
    S[1] = (int32_t)((uint32_t)S[1] >> 24);

L_0022:
    /* +0x00330 op=0xb4 05 01 01 00 ADD32: s1 = int32(s5 + s1) */
    S[1] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0023:
    /* +0x00348 op=0xb3 01 02 01 00 AND64: s1 = s1 & s2 */
    S[1] = S[1] & S[2];

L_0024:
    /* +0x00360 op=0x09 05 01 01 00 SUB32: s1 = sign_extend_32((uint32_t)s5 - (uint32_t)s1) */
    S[1] = (int32_t)((uint32_t)S[5] - (uint32_t)S[1]);

L_0025:
    /* +0x00378 op=0xb5 05 05 01 00 ADD32_IMM16: s5 = int32(s5 +0x1) */
    S[5] = (int32_t)((uint32_t)S[5] + 0x1);

L_0026:
    /* +0x00390 op=0x84 04 01 01 04 ADD64: s1 = s4 + s1 */
    S[1] = S[4] + S[1];

L_0027:
    /* +0x003a8 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0028:
    /* +0x003c0 op=0x0e 0d 01 07 05 LSR32_IMM: s7 = sign_extend_32((uint32_t)s1 >> 5) */
    S[7] = (int32_t)((uint32_t)S[1] >> 5);

L_0029:
    /* +0x003d8 op=0x18 00 01 01 03 SHL32_IMM: s1 = (int32_t)(s1 << 3) */
    S[1] = (int32_t)((uint32_t)S[1] << 3);

L_002a:
    /* +0x003f0 op=0x34 01 07 01 01 OR64: s1 = s1 | s7 */
    S[1] = S[1] | S[7];

L_002b:
    /* +0x00408 op=0x26 06 01 00 00 ST8: *(s6 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[6] + 0x0) = (uint8_t)S[1];

L_002c:
    /* +0x00420 op=0xa7 12 13 f1 ff BR_NE64: if (s18 != s19) goto record +30 */
    if (S[18] != S[19]) goto L_001e;

L_002d:
    /* +0x00438 op=0x85 00 09 00 00 ADD64_IMM16: s9 = s0 +0x0 */
    S[9] = S[0] + 0x0;

L_002e:
    /* +0x00450 op=0x85 00 04 10 00 ADD64_IMM16: s4 = s0 +0x10 */
    S[4] = S[0] + 0x10;

L_002f:
    /* +0x00468 op=0xb5 00 06 f0 ff ADD32_IMM16: s6 = int32(s0 -0x10) */
    S[6] = (int32_t)((uint32_t)S[0] + (-0x10));

L_0030:
    /* +0x00480 op=0x85 1e 02 00 01 ADD64_IMM16: s2 = s30 +0x100 */
    S[2] = S[30] + 0x100;

L_0031:
    /* +0x00498 op=0x85 1e 05 10 01 ADD64_IMM16: s5 = s30 +0x110 */
    S[5] = S[30] + 0x110;

L_0032:
    /* +0x004b0 op=0x53 01 07 a1 06 LD_POOL_PTR: s7 = *(uint64_t *)q1 + 0x6a1 q1=0x125fd3a8 */
    S[7] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x6a1;

L_0033:
    /* +0x004c8 op=0x53 03 08 b1 06 LD_POOL_PTR: s8 = *(uint64_t *)q1 + 0x6b1 q1=0x125fd3a8 */
    S[8] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x6b1;

L_0034:
    /* +0x004e0 op=0xae 09 04 17 00 BR_EQ64: if (s9 == s4) goto record +76 */
    if (S[9] == S[4]) goto L_004c;

L_0035:
    /* +0x004f8 op=0x10 00 03 01 1f ASR32_IMM: s1 = sign_extend_32((int32_t)s3 >> 31) */
    S[1] = (int32_t)((int32_t)S[3] >> 31);

L_0036:
    /* +0x00510 op=0x84 02 09 0b 04 ADD64: s11 = s2 + s9 */
    S[11] = S[2] + S[9];

L_0037:
    /* +0x00528 op=0x85 09 0a 01 00 ADD64_IMM16: s10 = s9 +0x1 */
    S[10] = S[9] + 0x1;

L_0038:
    /* +0x00540 op=0x84 05 09 09 04 ADD64: s9 = s5 + s9 */
    S[9] = S[5] + S[9];

L_0039:
    /* +0x00558 op=0x0e 00 01 01 1c LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 28) */
    S[1] = (int32_t)((uint32_t)S[1] >> 28);

L_003a:
    /* +0x00570 op=0xb4 03 01 01 00 ADD32: s1 = int32(s3 + s1) */
    S[1] = (int32_t)((uint32_t)S[3] + (uint32_t)S[1]);

L_003b:
    /* +0x00588 op=0xb3 01 06 01 01 AND64: s1 = s1 & s6 */
    S[1] = S[1] & S[6];

L_003c:
    /* +0x005a0 op=0x09 03 01 01 04 SUB32: s1 = sign_extend_32((uint32_t)s3 - (uint32_t)s1) */
    S[1] = (int32_t)((uint32_t)S[3] - (uint32_t)S[1]);

L_003d:
    /* +0x005b8 op=0xb5 03 03 01 00 ADD32_IMM16: s3 = int32(s3 +0x1) */
    S[3] = (int32_t)((uint32_t)S[3] + 0x1);

L_003e:
    /* +0x005d0 op=0x84 08 01 0c 04 ADD64: s12 = s8 + s1 */
    S[12] = S[8] + S[1];

L_003f:
    /* +0x005e8 op=0x84 07 01 01 14 ADD64: s1 = s7 + s1 */
    S[1] = S[7] + S[1];

L_0040:
    /* +0x00600 op=0x59 0c 0c 00 00 LD8U: s12 = *(uint8_t *)(s12 +0x0) */
    S[12] = *(uint8_t *)((uint8_t *)S[12] + 0x0);

L_0041:
    /* +0x00618 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0042:
    /* +0x00630 op=0x0e 0b 0c 0d 05 LSR32_IMM: s13 = sign_extend_32((uint32_t)s12 >> 5) */
    S[13] = (int32_t)((uint32_t)S[12] >> 5);

L_0043:
    /* +0x00648 op=0x18 10 0c 0c 03 SHL32_IMM: s12 = (int32_t)(s12 << 3) */
    S[12] = (int32_t)((uint32_t)S[12] << 3);

L_0044:
    /* +0x00660 op=0x34 0c 0d 0c 01 OR64: s12 = s12 | s13 */
    S[12] = S[12] | S[13];

L_0045:
    /* +0x00678 op=0x26 0b 0c 00 00 ST8: *(s11 +0x0) = (uint8_t)s12 */
    *(uint8_t *)((uint8_t *)S[11] + 0x0) = (uint8_t)S[12];

L_0046:
    /* +0x00690 op=0x0e 0d 01 0b 05 LSR32_IMM: s11 = sign_extend_32((uint32_t)s1 >> 5) */
    S[11] = (int32_t)((uint32_t)S[1] >> 5);

L_0047:
    /* +0x006a8 op=0x18 10 01 01 03 SHL32_IMM: s1 = (int32_t)(s1 << 3) */
    S[1] = (int32_t)((uint32_t)S[1] << 3);

L_0048:
    /* +0x006c0 op=0x34 01 0b 01 00 OR64: s1 = s1 | s11 */
    S[1] = S[1] | S[11];

L_0049:
    /* +0x006d8 op=0x26 09 01 00 00 ST8: *(s9 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[9] + 0x0) = (uint8_t)S[1];

L_004a:
    /* +0x006f0 op=0x34 0a 00 09 01 OR64: s9 = s10 | s0 */
    S[9] = S[10] | S[0];

L_004b:
    /* +0x00708 op=0xa7 09 04 e9 ff BR_NE64: if (s9 != s4) goto record +53 */
    if (S[9] != S[4]) goto L_0035;

L_004c:
    /* +0x00720 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 */
    S[3] = S[0] + 0x0;

L_004d:
    /* +0x00738 op=0xae 03 04 09 00 BR_EQ64: if (s3 == s4) goto record +87 */
    if (S[3] == S[4]) goto L_0057;

L_004e:
    /* +0x00750 op=0x84 05 03 01 04 ADD64: s1 = s5 + s3 */
    S[1] = S[5] + S[3];

L_004f:
    /* +0x00768 op=0x84 02 03 06 14 ADD64: s6 = s2 + s3 */
    S[6] = S[2] + S[3];

L_0050:
    /* +0x00780 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0051:
    /* +0x00798 op=0x59 06 06 00 00 LD8U: s6 = *(uint8_t *)(s6 +0x0) */
    S[6] = *(uint8_t *)((uint8_t *)S[6] + 0x0);

L_0052:
    /* +0x007b0 op=0x02 06 01 01 00 XOR64: s1 = s1 ^ s6 */
    S[1] = S[1] ^ S[6];

L_0053:
    /* +0x007c8 op=0x84 10 03 06 14 ADD64: s6 = s16 + s3 */
    S[6] = S[16] + S[3];

L_0054:
    /* +0x007e0 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_0055:
    /* +0x007f8 op=0x26 06 01 00 00 ST8: *(s6 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[6] + 0x0) = (uint8_t)S[1];

L_0056:
    /* +0x00810 op=0xa7 03 04 f7 ff BR_NE64: if (s3 != s4) goto record +78 */
    if (S[3] != S[4]) goto L_004e;

L_0057:
    /* +0x00828 op=0x85 00 04 fe 00 ADD64_IMM16: s4 = s0 +0xfe */
    S[4] = S[0] + 0xfe;

L_0058:
    /* +0x00840 op=0x85 10 05 0b 00 ADD64_IMM16: s5 = s16 +0xb */
    S[5] = S[16] + 0xb;

L_0059:
    /* +0x00858 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 */
    S[3] = S[0] + 0x0;

L_005a:
    /* +0x00870 op=0xb5 00 0d 00 00 ADD32_IMM16: s13 = int32(s0 +0x0) */
    S[13] = (int32_t)((uint32_t)S[0] + 0x0);

L_005b:
    /* +0x00888 op=0xb5 00 06 f8 07 ADD32_IMM16: s6 = int32(s0 +0x7f8) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x7f8);

L_005c:
    /* +0x008a0 op=0x34 04 00 07 01 OR64: s7 = s4 | s0 */
    S[7] = S[4] | S[0];

L_005d:
    /* +0x008b8 op=0xae 03 04 73 00 BR_EQ64: if (s3 == s4) goto record +209 */
    if (S[3] == S[4]) goto L_00d1;

L_005e:
    /* +0x008d0 op=0x85 03 19 02 00 ADD64_IMM16: s25 = s3 +0x2 */
    S[25] = S[3] + 0x2;

L_005f:
    /* +0x008e8 op=0x59 05 08 01 00 LD8U: s8 = *(uint8_t *)(s5 +0x1) */
    S[8] = *(uint8_t *)((uint8_t *)S[5] + 0x1);

L_0060:
    /* +0x00900 op=0x59 05 0a 04 00 LD8U: s10 = *(uint8_t *)(s5 +0x4) */
    S[10] = *(uint8_t *)((uint8_t *)S[5] + 0x4);

L_0061:
    /* +0x00918 op=0x59 05 0b 00 00 LD8U: s11 = *(uint8_t *)(s5 +0x0) */
    S[11] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0062:
    /* +0x00930 op=0x59 05 09 02 00 LD8U: s9 = *(uint8_t *)(s5 +0x2) */
    S[9] = *(uint8_t *)((uint8_t *)S[5] + 0x2);

L_0063:
    /* +0x00948 op=0x59 05 0c fe ff LD8U: s12 = *(uint8_t *)(s5 -0x2) */
    S[12] = *(uint8_t *)((uint8_t *)S[5] + (-0x2));

L_0064:
    /* +0x00960 op=0x59 05 0f fd ff LD8U: s15 = *(uint8_t *)(s5 -0x3) */
    S[15] = *(uint8_t *)((uint8_t *)S[5] + (-0x3));

L_0065:
    /* +0x00978 op=0x59 05 0e 03 00 LD8U: s14 = *(uint8_t *)(s5 +0x3) */
    S[14] = *(uint8_t *)((uint8_t *)S[5] + 0x3);

L_0066:
    /* +0x00990 op=0x59 05 18 ff ff LD8U: s24 = *(uint8_t *)(s5 -0x1) */
    S[24] = *(uint8_t *)((uint8_t *)S[5] + (-0x1));

L_0067:
    /* +0x009a8 op=0x84 11 03 12 14 ADD64: s18 = s17 + s3 */
    S[18] = S[17] + S[3];

L_0068:
    /* +0x009c0 op=0xb2 19 01 03 00 AND64_IMM16: s1 = s25 & 0x3 */
    S[1] = S[25] & 0x3;

L_0069:
    /* +0x009d8 op=0xa7 01 00 1d 00 BR_NE64: if (s1 != s0) goto record +135 */
    if (S[1] != S[0]) goto L_0087;

L_006a:
    /* +0x009f0 op=0xb2 08 01 ff 00 AND64_IMM16: s1 = s8 & 0xff */
    S[1] = S[8] & 0xff;

L_006b:
    /* +0x00a08 op=0xb2 09 13 ff 00 AND64_IMM16: s19 = s9 & 0xff */
    S[19] = S[9] & 0xff;

L_006c:
    /* +0x00a20 op=0xb2 0f 09 ff 00 AND64_IMM16: s9 = s15 & 0xff */
    S[9] = S[15] & 0xff;

L_006d:
    /* +0x00a38 op=0x59 12 0f 02 00 LD8U: s15 = *(uint8_t *)(s18 +0x2) */
    S[15] = *(uint8_t *)((uint8_t *)S[18] + 0x2);

L_006e:
    /* +0x00a50 op=0xb2 0a 0a ff 00 AND64_IMM16: s10 = s10 & 0xff */
    S[10] = S[10] & 0xff;

L_006f:
    /* +0x00a68 op=0xb2 0c 0c ff 00 AND64_IMM16: s12 = s12 & 0xff */
    S[12] = S[12] & 0xff;

L_0070:
    /* +0x00a80 op=0xb2 0b 0b ff 00 AND64_IMM16: s11 = s11 & 0xff */
    S[11] = S[11] & 0xff;

L_0071:
    /* +0x00a98 op=0xb2 0e 08 ff 00 AND64_IMM16: s8 = s14 & 0xff */
    S[8] = S[14] & 0xff;

L_0072:
    /* +0x00ab0 op=0xb2 18 0e ff 00 AND64_IMM16: s14 = s24 & 0xff */
    S[14] = S[24] & 0xff;

L_0073:
    /* +0x00ac8 op=0x84 11 01 01 14 ADD64: s1 = s17 + s1 */
    S[1] = S[17] + S[1];

L_0074:
    /* +0x00ae0 op=0x84 11 09 14 14 ADD64: s20 = s17 + s9 */
    S[20] = S[17] + S[9];

L_0075:
    /* +0x00af8 op=0x84 11 08 08 04 ADD64: s8 = s17 + s8 */
    S[8] = S[17] + S[8];

L_0076:
    /* +0x00b10 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0077:
    /* +0x00b28 op=0x59 08 08 00 00 LD8U: s8 = *(uint8_t *)(s8 +0x0) */
    S[8] = *(uint8_t *)((uint8_t *)S[8] + 0x0);

L_0078:
    /* +0x00b40 op=0x02 0f 01 09 00 XOR64: s9 = s1 ^ s15 */
    S[9] = S[1] ^ S[15];

L_0079:
    /* +0x00b58 op=0x84 11 0a 0f 04 ADD64: s15 = s17 + s10 */
    S[15] = S[17] + S[10];

L_007a:
    /* +0x00b70 op=0x84 11 0c 0a 14 ADD64: s10 = s17 + s12 */
    S[10] = S[17] + S[12];

L_007b:
    /* +0x00b88 op=0x84 11 07 0c 04 ADD64: s12 = s17 + s7 */
    S[12] = S[17] + S[7];

L_007c:
    /* +0x00ba0 op=0x84 11 0b 01 00 ADD64: s1 = s17 + s11 */
    S[1] = S[17] + S[11];

L_007d:
    /* +0x00bb8 op=0x84 11 0e 0b 14 ADD64: s11 = s17 + s14 */
    S[11] = S[17] + S[14];

L_007e:
    /* +0x00bd0 op=0x59 0a 0a 00 00 LD8U: s10 = *(uint8_t *)(s10 +0x0) */
    S[10] = *(uint8_t *)((uint8_t *)S[10] + 0x0);

L_007f:
    /* +0x00be8 op=0x59 0c 0c 00 00 LD8U: s12 = *(uint8_t *)(s12 +0x0) */
    S[12] = *(uint8_t *)((uint8_t *)S[12] + 0x0);

L_0080:
    /* +0x00c00 op=0x59 01 0e 00 00 LD8U: s14 = *(uint8_t *)(s1 +0x0) */
    S[14] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0081:
    /* +0x00c18 op=0x84 11 13 01 04 ADD64: s1 = s17 + s19 */
    S[1] = S[17] + S[19];

L_0082:
    /* +0x00c30 op=0x59 0b 0b 00 00 LD8U: s11 = *(uint8_t *)(s11 +0x0) */
    S[11] = *(uint8_t *)((uint8_t *)S[11] + 0x0);

L_0083:
    /* +0x00c48 op=0x02 0c 0a 18 01 XOR64: s24 = s10 ^ s12 */
    S[24] = S[10] ^ S[12];

L_0084:
    /* +0x00c60 op=0x59 0f 0c 00 00 LD8U: s12 = *(uint8_t *)(s15 +0x0) */
    S[12] = *(uint8_t *)((uint8_t *)S[15] + 0x0);

L_0085:
    /* +0x00c78 op=0x59 14 0a 00 00 LD8U: s10 = *(uint8_t *)(s20 +0x0) */
    S[10] = *(uint8_t *)((uint8_t *)S[20] + 0x0);

L_0086:
    /* +0x00c90 op=0x59 01 0f 00 00 LD8U: s15 = *(uint8_t *)(s1 +0x0) */
    S[15] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0087:
    /* +0x00ca8 op=0xb2 19 01 0f 00 AND64_IMM16: s1 = s25 & 0xf */
    S[1] = S[25] & 0xf;

L_0088:
    /* +0x00cc0 op=0x18 11 19 19 00 SHL32_IMM: s25 = (int32_t)(s25 << 0) */
    S[25] = (int32_t)((uint32_t)S[25] << 0);

L_0089:
    /* +0x00cd8 op=0x59 12 12 01 00 LD8U: s18 = *(uint8_t *)(s18 +0x1) */
    S[18] = *(uint8_t *)((uint8_t *)S[18] + 0x1);

L_008a:
    /* +0x00cf0 op=0x85 07 07 ff ff ADD64_IMM16: s7 = s7 -0x1 */
    S[7] = S[7] + (-0x1);

L_008b:
    /* +0x00d08 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_008c:
    /* +0x00d20 op=0x84 02 01 01 04 ADD64: s1 = s2 + s1 */
    S[1] = S[2] + S[1];

L_008d:
    /* +0x00d38 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_008e:
    /* +0x00d50 op=0xb4 01 19 13 00 ADD32: s19 = int32(s1 + s25) */
    S[19] = (int32_t)((uint32_t)S[1] + (uint32_t)S[25]);

L_008f:
    /* +0x00d68 op=0xb5 0d 19 08 00 ADD32_IMM16: s25 = int32(s13 +0x8) */
    S[25] = (int32_t)((uint32_t)S[13] + 0x8);

L_0090:
    /* +0x00d80 op=0xb4 0d 12 0d 00 ADD32: s13 = int32(s13 + s18) */
    S[13] = (int32_t)((uint32_t)S[13] + (uint32_t)S[18]);

L_0091:
    /* +0x00d98 op=0x85 05 01 08 00 ADD64_IMM16: s1 = s5 +0x8 */
    S[1] = S[5] + 0x8;

L_0092:
    /* +0x00db0 op=0xb2 13 12 ff 00 AND64_IMM16: s18 = s19 & 0xff */
    S[18] = S[19] & 0xff;

L_0093:
    /* +0x00dc8 op=0x84 11 12 12 14 ADD64: s18 = s17 + s18 */
    S[18] = S[17] + S[18];

L_0094:
    /* +0x00de0 op=0x59 12 12 00 00 LD8U: s18 = *(uint8_t *)(s18 +0x0) */
    S[18] = *(uint8_t *)((uint8_t *)S[18] + 0x0);

L_0095:
    /* +0x00df8 op=0x02 0d 12 0d 00 XOR64: s13 = s18 ^ s13 */
    S[13] = S[18] ^ S[13];

L_0096:
    /* +0x00e10 op=0x7e 0d 06 0d 03 REM_U32: s13 = (int32_t)((uint32_t)s6 == 0 ? (uint32_t)s13 : (uint32_t)s13 % (uint32_t)s6) */
    S[13] = (int32_t)((uint32_t)S[6] == 0 ? (uint32_t)S[13] : (uint32_t)S[13] % (uint32_t)S[6]);

L_0097:
    /* +0x00e28 op=0xb5 0d 16 07 00 ADD32_IMM16: s22 = int32(s13 +0x7) */
    S[22] = (int32_t)((uint32_t)S[13] + 0x7);

L_0098:
    /* +0x00e40 op=0xb5 0d 12 03 00 ADD32_IMM16: s18 = int32(s13 +0x3) */
    S[18] = (int32_t)((uint32_t)S[13] + 0x3);

L_0099:
    /* +0x00e58 op=0xb5 0d 13 04 00 ADD32_IMM16: s19 = int32(s13 +0x4) */
    S[19] = (int32_t)((uint32_t)S[13] + 0x4);

L_009a:
    /* +0x00e70 op=0xb5 0d 14 05 00 ADD32_IMM16: s20 = int32(s13 +0x5) */
    S[20] = (int32_t)((uint32_t)S[13] + 0x5);

L_009b:
    /* +0x00e88 op=0xb5 0d 15 06 00 ADD32_IMM16: s21 = int32(s13 +0x6) */
    S[21] = (int32_t)((uint32_t)S[13] + 0x6);

L_009c:
    /* +0x00ea0 op=0x6d 00 16 16 00 SHL64_IMM32PLUS: s22 = s22 << (0 + 32) */
    S[22] = S[22] << (0 + 32);

L_009d:
    /* +0x00eb8 op=0x6d 00 15 15 00 SHL64_IMM32PLUS: s21 = s21 << (0 + 32) */
    S[21] = S[21] << (0 + 32);

L_009e:
    /* +0x00ed0 op=0x6d 00 14 14 00 SHL64_IMM32PLUS: s20 = s20 << (0 + 32) */
    S[20] = S[20] << (0 + 32);

L_009f:
    /* +0x00ee8 op=0x6d 00 13 13 00 SHL64_IMM32PLUS: s19 = s19 << (0 + 32) */
    S[19] = S[19] << (0 + 32);

L_00a0:
    /* +0x00f00 op=0x6d 00 12 12 00 SHL64_IMM32PLUS: s18 = s18 << (0 + 32) */
    S[18] = S[18] << (0 + 32);

L_00a1:
    /* +0x00f18 op=0x6d 00 0d 17 00 SHL64_IMM32PLUS: s23 = s13 << (0 + 32) */
    S[23] = S[13] << (0 + 32);

L_00a2:
    /* +0x00f30 op=0x67 00 17 17 00 LSR64_IMM32PLUS: s23 = (uint64_t)s23 >> (0 + 32) */
    S[23] = (uint64_t)S[23] >> (0 + 32);

L_00a3:
    /* +0x00f48 op=0x84 10 17 17 04 ADD64: s23 = s16 + s23 */
    S[23] = S[16] + S[23];

L_00a4:
    /* +0x00f60 op=0x59 17 17 00 00 LD8U: s23 = *(uint8_t *)(s23 +0x0) */
    S[23] = *(uint8_t *)((uint8_t *)S[23] + 0x0);

L_00a5:
    /* +0x00f78 op=0x02 17 18 18 00 XOR64: s24 = s24 ^ s23 */
    S[24] = S[24] ^ S[23];

L_00a6:
    /* +0x00f90 op=0x26 05 18 05 00 ST8: *(s5 +0x5) = (uint8_t)s24 */
    *(uint8_t *)((uint8_t *)S[5] + 0x5) = (uint8_t)S[24];

L_00a7:
    /* +0x00fa8 op=0x67 00 12 18 00 LSR64_IMM32PLUS: s24 = (uint64_t)s18 >> (0 + 32) */
    S[24] = (uint64_t)S[18] >> (0 + 32);

L_00a8:
    /* +0x00fc0 op=0x67 00 13 12 00 LSR64_IMM32PLUS: s18 = (uint64_t)s19 >> (0 + 32) */
    S[18] = (uint64_t)S[19] >> (0 + 32);

L_00a9:
    /* +0x00fd8 op=0x67 00 14 13 00 LSR64_IMM32PLUS: s19 = (uint64_t)s20 >> (0 + 32) */
    S[19] = (uint64_t)S[20] >> (0 + 32);

L_00aa:
    /* +0x00ff0 op=0x67 00 15 14 00 LSR64_IMM32PLUS: s20 = (uint64_t)s21 >> (0 + 32) */
    S[20] = (uint64_t)S[21] >> (0 + 32);

L_00ab:
    /* +0x01008 op=0x67 00 16 15 00 LSR64_IMM32PLUS: s21 = (uint64_t)s22 >> (0 + 32) */
    S[21] = (uint64_t)S[22] >> (0 + 32);

L_00ac:
    /* +0x01020 op=0xb5 0d 16 01 00 ADD32_IMM16: s22 = int32(s13 +0x1) */
    S[22] = (int32_t)((uint32_t)S[13] + 0x1);

L_00ad:
    /* +0x01038 op=0xb5 0d 0d 02 00 ADD32_IMM16: s13 = int32(s13 +0x2) */
    S[13] = (int32_t)((uint32_t)S[13] + 0x2);

L_00ae:
    /* +0x01050 op=0x6d 00 16 16 00 SHL64_IMM32PLUS: s22 = s22 << (0 + 32) */
    S[22] = S[22] << (0 + 32);

L_00af:
    /* +0x01068 op=0x84 10 18 18 00 ADD64: s24 = s16 + s24 */
    S[24] = S[16] + S[24];

L_00b0:
    /* +0x01080 op=0x84 10 12 12 14 ADD64: s18 = s16 + s18 */
    S[18] = S[16] + S[18];

L_00b1:
    /* +0x01098 op=0x84 10 13 13 04 ADD64: s19 = s16 + s19 */
    S[19] = S[16] + S[19];

L_00b2:
    /* +0x010b0 op=0x84 10 14 14 04 ADD64: s20 = s16 + s20 */
    S[20] = S[16] + S[20];

L_00b3:
    /* +0x010c8 op=0x67 00 16 16 00 LSR64_IMM32PLUS: s22 = (uint64_t)s22 >> (0 + 32) */
    S[22] = (uint64_t)S[22] >> (0 + 32);

L_00b4:
    /* +0x010e0 op=0x84 10 16 16 00 ADD64: s22 = s16 + s22 */
    S[22] = S[16] + S[22];

L_00b5:
    /* +0x010f8 op=0x59 16 16 00 00 LD8U: s22 = *(uint8_t *)(s22 +0x0) */
    S[22] = *(uint8_t *)((uint8_t *)S[22] + 0x0);

L_00b6:
    /* +0x01110 op=0x02 16 0f 0f 00 XOR64: s15 = s15 ^ s22 */
    S[15] = S[15] ^ S[22];

L_00b7:
    /* +0x01128 op=0x26 05 0f 06 00 ST8: *(s5 +0x6) = (uint8_t)s15 */
    *(uint8_t *)((uint8_t *)S[5] + 0x6) = (uint8_t)S[15];

L_00b8:
    /* +0x01140 op=0x6d 00 0d 0d 00 SHL64_IMM32PLUS: s13 = s13 << (0 + 32) */
    S[13] = S[13] << (0 + 32);

L_00b9:
    /* +0x01158 op=0x84 10 15 0f 04 ADD64: s15 = s16 + s21 */
    S[15] = S[16] + S[21];

L_00ba:
    /* +0x01170 op=0x67 00 0d 0d 00 LSR64_IMM32PLUS: s13 = (uint64_t)s13 >> (0 + 32) */
    S[13] = (uint64_t)S[13] >> (0 + 32);

L_00bb:
    /* +0x01188 op=0x84 10 0d 0d 14 ADD64: s13 = s16 + s13 */
    S[13] = S[16] + S[13];

L_00bc:
    /* +0x011a0 op=0x59 0d 0d 00 00 LD8U: s13 = *(uint8_t *)(s13 +0x0) */
    S[13] = *(uint8_t *)((uint8_t *)S[13] + 0x0);

L_00bd:
    /* +0x011b8 op=0x02 0d 0e 0d 01 XOR64: s13 = s14 ^ s13 */
    S[13] = S[14] ^ S[13];

L_00be:
    /* +0x011d0 op=0x26 05 0d 07 00 ST8: *(s5 +0x7) = (uint8_t)s13 */
    *(uint8_t *)((uint8_t *)S[5] + 0x7) = (uint8_t)S[13];

L_00bf:
    /* +0x011e8 op=0x59 18 0d 00 00 LD8U: s13 = *(uint8_t *)(s24 +0x0) */
    S[13] = *(uint8_t *)((uint8_t *)S[24] + 0x0);

L_00c0:
    /* +0x01200 op=0x02 0d 0c 0c 01 XOR64: s12 = s12 ^ s13 */
    S[12] = S[12] ^ S[13];

L_00c1:
    /* +0x01218 op=0x34 19 00 0d 00 OR64: s13 = s25 | s0 */
    S[13] = S[25] | S[0];

L_00c2:
    /* +0x01230 op=0x26 05 0c 08 00 ST8: *(s5 +0x8) = (uint8_t)s12 */
    *(uint8_t *)((uint8_t *)S[5] + 0x8) = (uint8_t)S[12];

L_00c3:
    /* +0x01248 op=0x59 12 0c 00 00 LD8U: s12 = *(uint8_t *)(s18 +0x0) */
    S[12] = *(uint8_t *)((uint8_t *)S[18] + 0x0);

L_00c4:
    /* +0x01260 op=0x02 0c 09 09 01 XOR64: s9 = s9 ^ s12 */
    S[9] = S[9] ^ S[12];

L_00c5:
    /* +0x01278 op=0x26 05 09 09 00 ST8: *(s5 +0x9) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[5] + 0x9) = (uint8_t)S[9];

L_00c6:
    /* +0x01290 op=0x59 13 09 00 00 LD8U: s9 = *(uint8_t *)(s19 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[19] + 0x0);

L_00c7:
    /* +0x012a8 op=0x02 09 0b 09 00 XOR64: s9 = s11 ^ s9 */
    S[9] = S[11] ^ S[9];

L_00c8:
    /* +0x012c0 op=0x26 05 09 0a 00 ST8: *(s5 +0xa) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[5] + 0xa) = (uint8_t)S[9];

L_00c9:
    /* +0x012d8 op=0x59 14 09 00 00 LD8U: s9 = *(uint8_t *)(s20 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[20] + 0x0);

L_00ca:
    /* +0x012f0 op=0x02 09 0a 09 01 XOR64: s9 = s10 ^ s9 */
    S[9] = S[10] ^ S[9];

L_00cb:
    /* +0x01308 op=0x26 05 09 0b 00 ST8: *(s5 +0xb) = (uint8_t)s9 */
    *(uint8_t *)((uint8_t *)S[5] + 0xb) = (uint8_t)S[9];

L_00cc:
    /* +0x01320 op=0x59 0f 09 00 00 LD8U: s9 = *(uint8_t *)(s15 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[15] + 0x0);

L_00cd:
    /* +0x01338 op=0x02 09 08 08 01 XOR64: s8 = s8 ^ s9 */
    S[8] = S[8] ^ S[9];

L_00ce:
    /* +0x01350 op=0x26 05 08 0c 00 ST8: *(s5 +0xc) = (uint8_t)s8 */
    *(uint8_t *)((uint8_t *)S[5] + 0xc) = (uint8_t)S[8];

L_00cf:
    /* +0x01368 op=0x34 01 00 05 01 OR64: s5 = s1 | s0 */
    S[5] = S[1] | S[0];

L_00d0:
    /* +0x01380 op=0xa7 03 04 8d ff BR_NE64: if (s3 != s4) goto record +94 */
    if (S[3] != S[4]) goto L_005e;

L_00d1:
    /* +0x01398 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_00d2:
    /* +0x013b0 op=0x58 1d 10 20 01 LD64: s16 = *(uint64_t *)(s29 +0x120) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x120);

L_00d3:
    /* +0x013c8 op=0x58 1d 11 28 01 LD64: s17 = *(uint64_t *)(s29 +0x128) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x128);

L_00d4:
    /* +0x013e0 op=0x58 1d 12 30 01 LD64: s18 = *(uint64_t *)(s29 +0x130) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x130);

L_00d5:
    /* +0x013f8 op=0x58 1d 13 38 01 LD64: s19 = *(uint64_t *)(s29 +0x138) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x138);

L_00d6:
    /* +0x01410 op=0x58 1d 14 40 01 LD64: s20 = *(uint64_t *)(s29 +0x140) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x140);

L_00d7:
    /* +0x01428 op=0x58 1d 15 48 01 LD64: s21 = *(uint64_t *)(s29 +0x148) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x148);

L_00d8:
    /* +0x01440 op=0x58 1d 16 50 01 LD64: s22 = *(uint64_t *)(s29 +0x150) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x150);

L_00d9:
    /* +0x01458 op=0x58 1d 17 58 01 LD64: s23 = *(uint64_t *)(s29 +0x158) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x158);

L_00da:
    /* +0x01470 op=0x58 1d 1e 60 01 LD64: s30 = *(uint64_t *)(s29 +0x160) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x160);

L_00db:
    /* +0x01488 op=0x58 1d 1f 68 01 LD64: s31 = *(uint64_t *)(s29 +0x168) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x168);

L_00dc:
    /* +0x014a0 op=0x85 1d 1d 70 01 ADD64_IMM16: s29 = s29 +0x170 */
    S[29] = S[29] + 0x170;

L_00dd:
    /* +0x014b8 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

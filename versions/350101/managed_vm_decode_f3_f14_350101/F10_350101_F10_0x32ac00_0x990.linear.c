/*
 * Auto-generated linear C-like lift for 350.101 managed program F10.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F10_0x32ac00_0x990.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F10_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d e0 ff ADD64_IMM16: s29 = s29 -0x20 */
    S[29] = S[29] + (-0x20);

L_0001:
    /* +0x00018 op=0x25 1d 12 18 00 ST64: *(s29 +0x18) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[18];

L_0002:
    /* +0x00030 op=0x25 1d 11 10 00 ST64: *(s29 +0x10) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[17];

L_0003:
    /* +0x00048 op=0x25 1d 10 08 00 ST64: *(s29 +0x8) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[16];

L_0004:
    /* +0x00060 op=0x18 00 05 02 00 SHL32_IMM: s2 = (int32_t)(s5 << 0) */
    S[2] = (int32_t)((uint32_t)S[5] << 0);

L_0005:
    /* +0x00078 op=0x14 02 01 08 00 CMP_LO_IMM64: s1 = ((uint64_t)s2 < (uint64_t)8) ? 1 : 0 */
    S[1] = ((uint64_t)S[2] < (uint64_t)0x8) ? 1 : 0;

L_0006:
    /* +0x00090 op=0xae 01 00 05 00 BR_EQ64: if (s1 == s0) goto record +12 */
    if (S[1] == S[0]) goto L_000c;

L_0007:
    /* +0x000a8 op=0x58 1d 10 08 00 LD64: s16 = *(uint64_t *)(s29 +0x8) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0008:
    /* +0x000c0 op=0x58 1d 11 10 00 LD64: s17 = *(uint64_t *)(s29 +0x10) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0009:
    /* +0x000d8 op=0x58 1d 12 18 00 LD64: s18 = *(uint64_t *)(s29 +0x18) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_000a:
    /* +0x000f0 op=0x85 1d 1d 20 00 ADD64_IMM16: s29 = s29 +0x20 */
    S[29] = S[29] + 0x20;

L_000b:
    /* +0x00108 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

L_000c:
    /* +0x00120 op=0x18 11 07 01 00 SHL32_IMM: s1 = (int32_t)(s7 << 0) */
    S[1] = (int32_t)((uint32_t)S[7] << 0);

L_000d:
    /* +0x00138 op=0xb5 00 08 00 00 ADD32_IMM16: s8 = int32(s0 +0x0) */
    S[8] = (int32_t)((uint32_t)S[0] + 0x0);

L_000e:
    /* +0x00150 op=0xb5 00 05 07 00 ADD32_IMM16: s5 = int32(s0 +0x7) */
    S[5] = (int32_t)((uint32_t)S[0] + 0x7);

L_000f:
    /* +0x00168 op=0xb5 00 07 04 00 ADD32_IMM16: s7 = int32(s0 +0x4) */
    S[7] = (int32_t)((uint32_t)S[0] + 0x4);

L_0010:
    /* +0x00180 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) */
    S[1] = S[1] << (0 + 32);

L_0011:
    /* +0x00198 op=0x34 08 00 09 01 OR64: s9 = s8 | s0 */
    S[9] = S[8] | S[0];

L_0012:
    /* +0x001b0 op=0x67 00 01 03 00 LSR64_IMM32PLUS: s3 = (uint64_t)s1 >> (0 + 32) */
    S[3] = (uint64_t)S[1] >> (0 + 32);

L_0013:
    /* +0x001c8 op=0xae 03 00 f3 ff BR_EQ64: if (s3 == s0) goto record +7 */
    if (S[3] == S[0]) goto L_0007;

L_0014:
    /* +0x001e0 op=0x6d 00 09 0a 00 SHL64_IMM32PLUS: s10 = s9 << (0 + 32) */
    S[10] = S[9] << (0 + 32);

L_0015:
    /* +0x001f8 op=0xb5 08 0b 01 00 ADD32_IMM16: s11 = int32(s8 +0x1) */
    S[11] = (int32_t)((uint32_t)S[8] + 0x1);

L_0016:
    /* +0x00210 op=0xb5 09 01 10 00 ADD32_IMM16: s1 = int32(s9 +0x10) */
    S[1] = (int32_t)((uint32_t)S[9] + 0x10);

L_0017:
    /* +0x00228 op=0xb5 08 10 04 00 ADD32_IMM16: s16 = int32(s8 +0x4) */
    S[16] = (int32_t)((uint32_t)S[8] + 0x4);

L_0018:
    /* +0x00240 op=0xb5 08 0f 05 00 ADD32_IMM16: s15 = int32(s8 +0x5) */
    S[15] = (int32_t)((uint32_t)S[8] + 0x5);

L_0019:
    /* +0x00258 op=0xb2 08 19 07 00 AND64_IMM16: s25 = s8 & 0x7 */
    S[25] = S[8] & 0x7;

L_001a:
    /* +0x00270 op=0xb5 08 11 06 00 ADD32_IMM16: s17 = int32(s8 +0x6) */
    S[17] = (int32_t)((uint32_t)S[8] + 0x6);

L_001b:
    /* +0x00288 op=0xb5 08 12 ff ff ADD32_IMM16: s18 = int32(s8 -0x1) */
    S[18] = (int32_t)((uint32_t)S[8] + (-0x1));

L_001c:
    /* +0x002a0 op=0x67 00 0a 0a 00 LSR64_IMM32PLUS: s10 = (uint64_t)s10 >> (0 + 32) */
    S[10] = (uint64_t)S[10] >> (0 + 32);

L_001d:
    /* +0x002b8 op=0xb2 10 10 07 00 AND64_IMM16: s16 = s16 & 0x7 */
    S[16] = S[16] & 0x7;

L_001e:
    /* +0x002d0 op=0xb2 0f 0f 07 00 AND64_IMM16: s15 = s15 & 0x7 */
    S[15] = S[15] & 0x7;

L_001f:
    /* +0x002e8 op=0x33 19 19 38 00 OR_IMM16: s25 = s25 | 0x38 */
    S[25] = S[25] | 0x38;

L_0020:
    /* +0x00300 op=0xb2 0b 18 07 00 AND64_IMM16: s24 = s11 & 0x7 */
    S[24] = S[11] & 0x7;

L_0021:
    /* +0x00318 op=0x84 04 0a 0c 00 ADD64: s12 = s4 + s10 */
    S[12] = S[4] + S[10];

L_0022:
    /* +0x00330 op=0x13 02 01 0a 0f CMP_LO64: s10 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0 */
    S[10] = ((uint64_t)S[2] < (uint64_t)S[1]) ? 1 : 0;

L_0023:
    /* +0x00348 op=0x13 05 0b 01 0f CMP_LO64: s1 = ((uint64_t)s5 < (uint64_t)s11) ? 1 : 0 */
    S[1] = ((uint64_t)S[5] < (uint64_t)S[11]) ? 1 : 0;

L_0024:
    /* +0x00360 op=0x33 10 10 18 00 OR_IMM16: s16 = s16 | 0x18 */
    S[16] = S[16] | 0x18;

L_0025:
    /* +0x00378 op=0x33 0f 0f 08 00 OR_IMM16: s15 = s15 | 0x8 */
    S[15] = S[15] | 0x8;

L_0026:
    /* +0x00390 op=0x33 18 18 30 00 OR_IMM16: s24 = s24 | 0x30 */
    S[24] = S[24] | 0x30;

L_0027:
    /* +0x003a8 op=0x18 00 01 01 01 SHL32_IMM: s1 = (int32_t)(s1 << 1) */
    S[1] = (int32_t)((uint32_t)S[1] << 1);

L_0028:
    /* +0x003c0 op=0x1f 07 0a 0e 10 CMOVZ64: s14 = (s10 == 0) ? s7 : 0 */
    S[14] = (S[10] == 0) ? S[7] : 0;

L_0029:
    /* +0x003d8 op=0x1e 01 0a 0d 11 CMOVNZ64: s13 = (s10 != 0) ? s1 : 0 */
    S[13] = (S[10] != 0) ? S[1] : 0;

L_002a:
    /* +0x003f0 op=0x58 0c 01 00 00 LD64: s1 = *(uint64_t *)(s12 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[12] + 0x0);

L_002b:
    /* +0x00408 op=0xb5 08 0c 02 00 ADD32_IMM16: s12 = int32(s8 +0x2) */
    S[12] = (int32_t)((uint32_t)S[8] + 0x2);

L_002c:
    /* +0x00420 op=0x34 0d 0e 0d 01 OR64: s13 = s13 | s14 */
    S[13] = S[13] | S[14];

L_002d:
    /* +0x00438 op=0xb5 08 0e 03 00 ADD32_IMM16: s14 = int32(s8 +0x3) */
    S[14] = (int32_t)((uint32_t)S[8] + 0x3);

L_002e:
    /* +0x00450 op=0xb2 0c 0c 07 00 AND64_IMM16: s12 = s12 & 0x7 */
    S[12] = S[12] & 0x7;

L_002f:
    /* +0x00468 op=0xb2 0e 0e 07 00 AND64_IMM16: s14 = s14 & 0x7 */
    S[14] = S[14] & 0x7;

L_0030:
    /* +0x00480 op=0x66 10 01 10 13 LSR64_VAR: s16 = (uint64_t)s1 >> (s16 & 63) */
    S[16] = (uint64_t)S[1] >> (S[16] & 63);

L_0031:
    /* +0x00498 op=0x66 0f 01 0f 00 LSR64_VAR: s15 = (uint64_t)s1 >> (s15 & 63) */
    S[15] = (uint64_t)S[1] >> (S[15] & 63);

L_0032:
    /* +0x004b0 op=0x66 18 01 18 13 LSR64_VAR: s24 = (uint64_t)s1 >> (s24 & 63) */
    S[24] = (uint64_t)S[1] >> (S[24] & 63);

L_0033:
    /* +0x004c8 op=0x33 0c 0c 20 00 OR_IMM16: s12 = s12 | 0x20 */
    S[12] = S[12] | 0x20;

L_0034:
    /* +0x004e0 op=0x33 0d 0d 04 00 OR_IMM16: s13 = s13 | 0x4 */
    S[13] = S[13] | 0x4;

L_0035:
    /* +0x004f8 op=0x33 0e 0e 10 00 OR_IMM16: s14 = s14 | 0x10 */
    S[14] = S[14] | 0x10;

L_0036:
    /* +0x00510 op=0x18 10 10 10 00 SHL32_IMM: s16 = (int32_t)(s16 << 0) */
    S[16] = (int32_t)((uint32_t)S[16] << 0);

L_0037:
    /* +0x00528 op=0x18 11 0f 0f 00 SHL32_IMM: s15 = (int32_t)(s15 << 0) */
    S[15] = (int32_t)((uint32_t)S[15] << 0);

L_0038:
    /* +0x00540 op=0x66 0c 01 0c 00 LSR64_VAR: s12 = (uint64_t)s1 >> (s12 & 63) */
    S[12] = (uint64_t)S[1] >> (S[12] & 63);

L_0039:
    /* +0x00558 op=0x66 0e 01 0e 13 LSR64_VAR: s14 = (uint64_t)s1 >> (s14 & 63) */
    S[14] = (uint64_t)S[1] >> (S[14] & 63);

L_003a:
    /* +0x00570 op=0x18 11 10 10 06 SHL32_IMM: s16 = (int32_t)(s16 << 6) */
    S[16] = (int32_t)((uint32_t)S[16] << 6);

L_003b:
    /* +0x00588 op=0x18 00 0f 0f 07 SHL32_IMM: s15 = (int32_t)(s15 << 7) */
    S[15] = (int32_t)((uint32_t)S[15] << 7);

L_003c:
    /* +0x005a0 op=0x18 00 0c 0c 00 SHL32_IMM: s12 = (int32_t)(s12 << 0) */
    S[12] = (int32_t)((uint32_t)S[12] << 0);

L_003d:
    /* +0x005b8 op=0x18 00 0e 0e 00 SHL32_IMM: s14 = (int32_t)(s14 << 0) */
    S[14] = (int32_t)((uint32_t)S[14] << 0);

L_003e:
    /* +0x005d0 op=0xb2 10 10 40 00 AND64_IMM16: s16 = s16 & 0x40 */
    S[16] = S[16] & 0x40;

L_003f:
    /* +0x005e8 op=0x18 00 0c 0c 02 SHL32_IMM: s12 = (int32_t)(s12 << 2) */
    S[12] = (int32_t)((uint32_t)S[12] << 2);

L_0040:
    /* +0x00600 op=0x18 00 0e 0e 03 SHL32_IMM: s14 = (int32_t)(s14 << 3) */
    S[14] = (int32_t)((uint32_t)S[14] << 3);

L_0041:
    /* +0x00618 op=0x34 10 0f 0f 01 OR64: s15 = s16 | s15 */
    S[15] = S[16] | S[15];

L_0042:
    /* +0x00630 op=0xb2 0c 0c 04 00 AND64_IMM16: s12 = s12 & 0x4 */
    S[12] = S[12] & 0x4;

L_0043:
    /* +0x00648 op=0xb2 0e 0e 08 00 AND64_IMM16: s14 = s14 & 0x8 */
    S[14] = S[14] & 0x8;

L_0044:
    /* +0x00660 op=0x34 0f 0e 0e 01 OR64: s14 = s15 | s14 */
    S[14] = S[15] | S[14];

L_0045:
    /* +0x00678 op=0x66 19 01 0f 00 LSR64_VAR: s15 = (uint64_t)s1 >> (s25 & 63) */
    S[15] = (uint64_t)S[1] >> (S[25] & 63);

L_0046:
    /* +0x00690 op=0x18 11 0f 0f 00 SHL32_IMM: s15 = (int32_t)(s15 << 0) */
    S[15] = (int32_t)((uint32_t)S[15] << 0);

L_0047:
    /* +0x006a8 op=0x18 11 0f 0f 05 SHL32_IMM: s15 = (int32_t)(s15 << 5) */
    S[15] = (int32_t)((uint32_t)S[15] << 5);

L_0048:
    /* +0x006c0 op=0xb2 0f 0f 20 00 AND64_IMM16: s15 = s15 & 0x20 */
    S[15] = S[15] & 0x20;

L_0049:
    /* +0x006d8 op=0x34 0e 0f 0e 01 OR64: s14 = s14 | s15 */
    S[14] = S[14] | S[15];

L_004a:
    /* +0x006f0 op=0x18 11 18 0f 00 SHL32_IMM: s15 = (int32_t)(s24 << 0) */
    S[15] = (int32_t)((uint32_t)S[24] << 0);

L_004b:
    /* +0x00708 op=0x18 10 0f 0f 04 SHL32_IMM: s15 = (int32_t)(s15 << 4) */
    S[15] = (int32_t)((uint32_t)S[15] << 4);

L_004c:
    /* +0x00720 op=0xb2 0f 0f 10 00 AND64_IMM16: s15 = s15 & 0x10 */
    S[15] = S[15] & 0x10;

L_004d:
    /* +0x00738 op=0x34 0e 0f 0e 01 OR64: s14 = s14 | s15 */
    S[14] = S[14] | S[15];

L_004e:
    /* +0x00750 op=0xb2 11 0f 07 00 AND64_IMM16: s15 = s17 & 0x7 */
    S[15] = S[17] & 0x7;

L_004f:
    /* +0x00768 op=0x66 0f 01 0f 00 LSR64_VAR: s15 = (uint64_t)s1 >> (s15 & 63) */
    S[15] = (uint64_t)S[1] >> (S[15] & 63);

L_0050:
    /* +0x00780 op=0x18 10 0f 0f 00 SHL32_IMM: s15 = (int32_t)(s15 << 0) */
    S[15] = (int32_t)((uint32_t)S[15] << 0);

L_0051:
    /* +0x00798 op=0x18 00 0f 0f 01 SHL32_IMM: s15 = (int32_t)(s15 << 1) */
    S[15] = (int32_t)((uint32_t)S[15] << 1);

L_0052:
    /* +0x007b0 op=0xb2 0f 0f 02 00 AND64_IMM16: s15 = s15 & 0x2 */
    S[15] = S[15] & 0x2;

L_0053:
    /* +0x007c8 op=0x34 0e 0f 0e 01 OR64: s14 = s14 | s15 */
    S[14] = S[14] | S[15];

L_0054:
    /* +0x007e0 op=0xb2 12 0f 07 00 AND64_IMM16: s15 = s18 & 0x7 */
    S[15] = S[18] & 0x7;

L_0055:
    /* +0x007f8 op=0x33 0f 0f 28 00 OR_IMM16: s15 = s15 | 0x28 */
    S[15] = S[15] | 0x28;

L_0056:
    /* +0x00810 op=0x66 0f 01 01 11 LSR64_VAR: s1 = (uint64_t)s1 >> (s15 & 63) */
    S[1] = (uint64_t)S[1] >> (S[15] & 63);

L_0057:
    /* +0x00828 op=0x18 11 01 01 00 SHL32_IMM: s1 = (int32_t)(s1 << 0) */
    S[1] = (int32_t)((uint32_t)S[1] << 0);

L_0058:
    /* +0x00840 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_0059:
    /* +0x00858 op=0x34 0e 01 01 01 OR64: s1 = s14 | s1 */
    S[1] = S[14] | S[1];

L_005a:
    /* +0x00870 op=0x34 01 0c 01 01 OR64: s1 = s1 | s12 */
    S[1] = S[1] | S[12];

L_005b:
    /* +0x00888 op=0x26 06 01 00 00 ST8: *(s6 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[6] + 0x0) = (uint8_t)S[1];

L_005c:
    /* +0x008a0 op=0xa7 0d 07 aa ff BR_NE64: if (s13 != s7) goto record +7 */
    if (S[13] != S[7]) goto L_0007;

L_005d:
    /* +0x008b8 op=0xb5 09 09 08 00 ADD32_IMM16: s9 = int32(s9 +0x8) */
    S[9] = (int32_t)((uint32_t)S[9] + 0x8);

L_005e:
    /* +0x008d0 op=0x1f 08 0a 01 10 CMOVZ64: s1 = (s10 == 0) ? s8 : 0 */
    S[1] = (S[10] == 0) ? S[8] : 0;

L_005f:
    /* +0x008e8 op=0x1e 0b 0a 08 00 CMOVNZ64: s8 = (s10 != 0) ? s11 : 0 */
    S[8] = (S[10] != 0) ? S[11] : 0;

L_0060:
    /* +0x00900 op=0x85 03 03 ff ff ADD64_IMM16: s3 = s3 -0x1 */
    S[3] = S[3] + (-0x1);

L_0061:
    /* +0x00918 op=0x85 06 06 01 00 ADD64_IMM16: s6 = s6 +0x1 */
    S[6] = S[6] + 0x1;

L_0062:
    /* +0x00930 op=0x34 08 01 08 00 OR64: s8 = s8 | s1 */
    S[8] = S[8] | S[1];

L_0063:
    /* +0x00948 op=0x1f 09 0a 09 00 CMOVZ64: s9 = (s10 == 0) ? s9 : 0 */
    S[9] = (S[10] == 0) ? S[9] : 0;

L_0064:
    /* +0x00960 op=0xa7 03 00 af ff BR_NE64: if (s3 != s0) goto record +20 */
    if (S[3] != S[0]) goto L_0014;

L_0065:
    /* +0x00978 op=0x5f a1 ff ff ff ADD_PC_IMM32: goto record +7 ; vm_pc = current_pc + 1 + -95 */
    goto L_0007;

}

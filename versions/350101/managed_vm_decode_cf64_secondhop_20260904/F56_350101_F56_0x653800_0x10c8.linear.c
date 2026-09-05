/*
 * Auto-generated linear C-like lift for 350.101 managed program F56.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F56_0x653800_0x10c8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F56_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 60 ff ADD64_IMM16: s29 = s29 -0xa0 */
    S[29] = S[29] + (-0xa0);

L_0001:
    /* +0x00018 op=0x25 1d 1f 98 00 ST64: *(s29 +0x98) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x98) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 90 00 ST64: *(s29 +0x90) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x90) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 15 88 00 ST64: *(s29 +0x88) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x88) = S[21];

L_0004:
    /* +0x00060 op=0x25 1d 14 80 00 ST64: *(s29 +0x80) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x80) = S[20];

L_0005:
    /* +0x00078 op=0x25 1d 13 78 00 ST64: *(s29 +0x78) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x78) = S[19];

L_0006:
    /* +0x00090 op=0x25 1d 12 70 00 ST64: *(s29 +0x70) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x70) = S[18];

L_0007:
    /* +0x000a8 op=0x25 1d 11 68 00 ST64: *(s29 +0x68) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x68) = S[17];

L_0008:
    /* +0x000c0 op=0x25 1d 10 60 00 ST64: *(s29 +0x60) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x60) = S[16];

L_0009:
    /* +0x000d8 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000a:
    /* +0x000f0 op=0x52 04 15 00 00 LD32S: s21 = *(int32_t *)(s4 +0x0) */
    S[21] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_000b:
    /* +0x00108 op=0x85 00 14 40 00 ADD64_IMM16: s20 = s0 +0x40 */
    S[20] = S[0] + 0x40;

L_000c:
    /* +0x00120 op=0x85 1e 12 18 00 ADD64_IMM16: s18 = s30 +0x18 */
    S[18] = S[30] + 0x18;

L_000d:
    /* +0x00138 op=0x85 00 13 00 00 ADD64_IMM16: s19 = s0 +0x0 */
    S[19] = S[0] + 0x0;

L_000e:
    /* +0x00150 op=0x34 05 00 10 00 OR64: s16 = s5 | s0 */
    S[16] = S[5] | S[0];

L_000f:
    /* +0x00168 op=0x34 04 00 11 00 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_0010:
    /* +0x00180 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0011:
    /* +0x00198 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0012:
    /* +0x001b0 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_0013:
    /* +0x001c8 op=0x18 11 15 01 03 SHL32_IMM: s1 = (int32_t)(s21 << 3) */
    S[1] = (int32_t)((uint32_t)S[21] << 3);

L_0014:
    /* +0x001e0 op=0x08 1e 01 58 00 ST32: *(s30 +0x58) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x58) = (uint32_t)S[1];

L_0015:
    /* +0x001f8 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0016:
    /* +0x00210 op=0xb2 15 02 3f 00 AND64_IMM16: s2 = s21 & 0x3f */
    S[2] = S[21] & 0x3f;

L_0017:
    /* +0x00228 op=0xb5 00 03 7c 00 ADD32_IMM16: s3 = int32(s0 +0x7c) */
    S[3] = (int32_t)((uint32_t)S[0] + 0x7c);

L_0018:
    /* +0x00240 op=0xb5 00 04 3c 00 ADD32_IMM16: s4 = int32(s0 +0x3c) */
    S[4] = (int32_t)((uint32_t)S[0] + 0x3c);

L_0019:
    /* +0x00258 op=0xb5 00 05 f8 ff ADD32_IMM16: s5 = int32(s0 -0x8) */
    S[5] = (int32_t)((uint32_t)S[0] + (-0x8));

L_001a:
    /* +0x00270 op=0x53 03 07 90 09 LD_POOL_PTR: s7 = *(uint64_t *)q1 + 0x990 q1=0x125fd3a8 */
    S[7] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x990;

L_001b:
    /* +0x00288 op=0xb5 00 08 00 00 ADD32_IMM16: s8 = int32(s0 +0x0) */
    S[8] = (int32_t)((uint32_t)S[0] + 0x0);

L_001c:
    /* +0x002a0 op=0x14 02 01 3c 00 CMP_LO_IMM64: s1 = ((uint64_t)s2 < (uint64_t)60) ? 1 : 0 */
    S[1] = ((uint64_t)S[2] < (uint64_t)0x3c) ? 1 : 0;

L_001d:
    /* +0x002b8 op=0x1f 03 01 03 00 CMOVZ64: s3 = (s1 == 0) ? s3 : 0 */
    S[3] = (S[1] == 0) ? S[3] : 0;

L_001e:
    /* +0x002d0 op=0x1e 04 01 01 00 CMOVNZ64: s1 = (s1 != 0) ? s4 : 0 */
    S[1] = (S[1] != 0) ? S[4] : 0;

L_001f:
    /* +0x002e8 op=0x52 11 04 58 00 LD32S: s4 = *(int32_t *)(s17 +0x58) */
    S[4] = *(int32_t *)((uint8_t *)S[17] + 0x58);

L_0020:
    /* +0x00300 op=0x34 01 03 03 01 OR64: s3 = s1 | s3 */
    S[3] = S[1] | S[3];

L_0021:
    /* +0x00318 op=0xb5 00 01 08 00 ADD32_IMM16: s1 = int32(s0 +0x8) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x8);

L_0022:
    /* +0x00330 op=0xb5 04 04 ff ff ADD32_IMM16: s4 = int32(s4 -0x1) */
    S[4] = (int32_t)((uint32_t)S[4] + (-0x1));

L_0023:
    /* +0x00348 op=0xb2 04 04 07 00 AND64_IMM16: s4 = s4 & 0x7 */
    S[4] = S[4] & 0x7;

L_0024:
    /* +0x00360 op=0x34 04 05 05 01 OR64: s5 = s4 | s5 */
    S[5] = S[4] | S[5];

L_0025:
    /* +0x00378 op=0x09 01 04 06 04 SUB32: s6 = sign_extend_32((uint32_t)s1 - (uint32_t)s4) */
    S[6] = (int32_t)((uint32_t)S[1] - (uint32_t)S[4]);

L_0026:
    /* +0x00390 op=0xae 13 14 1a 00 BR_EQ64: if (s19 == s20) goto record +65 */
    if (S[19] == S[20]) goto L_0041;

L_0027:
    /* +0x003a8 op=0x84 07 13 01 14 ADD64: s1 = s7 + s19 */
    S[1] = S[7] + S[19];

L_0028:
    /* +0x003c0 op=0x34 05 00 0b 01 OR64: s11 = s5 | s0 */
    S[11] = S[5] | S[0];

L_0029:
    /* +0x003d8 op=0x34 08 00 0a 01 OR64: s10 = s8 | s0 */
    S[10] = S[8] | S[0];

L_002a:
    /* +0x003f0 op=0x59 01 09 00 00 LD8U: s9 = *(uint8_t *)(s1 +0x0) */
    S[9] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_002b:
    /* +0x00408 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +48 */
    if (S[11] == S[0]) goto L_0030;

L_002c:
    /* +0x00420 op=0x18 10 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_002d:
    /* +0x00438 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_002e:
    /* +0x00450 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_002f:
    /* +0x00468 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +44 */
    if (S[11] != S[0]) goto L_002c;

L_0030:
    /* +0x00480 op=0x34 05 00 0c 01 OR64: s12 = s5 | s0 */
    S[12] = S[5] | S[0];

L_0031:
    /* +0x00498 op=0x34 08 00 0b 01 OR64: s11 = s8 | s0 */
    S[11] = S[8] | S[0];

L_0032:
    /* +0x004b0 op=0xae 0c 00 04 00 BR_EQ64: if (s12 == s0) goto record +55 */
    if (S[12] == S[0]) goto L_0037;

L_0033:
    /* +0x004c8 op=0x18 11 0b 01 01 SHL32_IMM: s1 = (int32_t)(s11 << 1) */
    S[1] = (int32_t)((uint32_t)S[11] << 1);

L_0034:
    /* +0x004e0 op=0xb5 0c 0c 01 00 ADD32_IMM16: s12 = int32(s12 +0x1) */
    S[12] = (int32_t)((uint32_t)S[12] + 0x1);

L_0035:
    /* +0x004f8 op=0x33 01 0b 01 00 OR_IMM16: s11 = s1 | 0x1 */
    S[11] = S[1] | 0x1;

L_0036:
    /* +0x00510 op=0xa7 0c 00 fc ff BR_NE64: if (s12 != s0) goto record +51 */
    if (S[12] != S[0]) goto L_0033;

L_0037:
    /* +0x00528 op=0x0d 04 09 01 11 BYTE_FROM_U32_SHIFT: s4 = (uint8_t)((uint32_t)s9 >> (s1 & 31)) */
    S[4] = (uint8_t)((uint32_t)S[9] >> (S[1] & 31));

L_0038:
    /* +0x00540 op=0x17 06 09 09 07 SHL32_VAR: s9 = (int32_t)((uint32_t)s9 << ((uint32_t)s6 & 31)) */
    S[9] = (int32_t)((uint32_t)S[9] << ((uint32_t)S[6] & 31));

L_0039:
    /* +0x00558 op=0xb3 01 0a 01 01 AND64: s1 = s1 & s10 */
    S[1] = S[1] & S[10];

L_003a:
    /* +0x00570 op=0x36 0b 00 0a 01 NOR64: s10 = ~(s11 | s0) */
    S[10] = ~(S[11] | S[0]);

L_003b:
    /* +0x00588 op=0xb3 09 0a 09 00 AND64: s9 = s9 & s10 */
    S[9] = S[9] & S[10];

L_003c:
    /* +0x005a0 op=0x34 09 01 01 01 OR64: s1 = s9 | s1 */
    S[1] = S[9] | S[1];

L_003d:
    /* +0x005b8 op=0x84 12 13 09 00 ADD64: s9 = s18 + s19 */
    S[9] = S[18] + S[19];

L_003e:
    /* +0x005d0 op=0x85 13 13 01 00 ADD64_IMM16: s19 = s19 +0x1 */
    S[19] = S[19] + 0x1;

L_003f:
    /* +0x005e8 op=0x26 09 01 00 00 ST8: *(s9 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[9] + 0x0) = (uint8_t)S[1];

L_0040:
    /* +0x00600 op=0xa7 13 14 e6 ff BR_NE64: if (s19 != s20) goto record +39 */
    if (S[19] != S[20]) goto L_0027;

L_0041:
    /* +0x00618 op=0x09 03 02 01 04 SUB32: s1 = sign_extend_32((uint32_t)s3 - (uint32_t)s2) */
    S[1] = (int32_t)((uint32_t)S[3] - (uint32_t)S[2]);

L_0042:
    /* +0x00630 op=0x85 1e 05 18 00 ADD64_IMM16: s5 = s30 +0x18 */
    S[5] = S[30] + 0x18;

L_0043:
    /* +0x00648 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0044:
    /* +0x00660 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) */
    S[1] = S[1] << (0 + 32);

L_0045:
    /* +0x00678 op=0x67 00 01 06 00 LSR64_IMM32PLUS: s6 = (uint64_t)s1 >> (0 + 32) */
    S[6] = (uint64_t)S[1] >> (0 + 32);

L_0046:
    /* +0x00690 op=0x5e 3a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3a] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x3a, (void *)(uintptr_t)0x125fd360);

L_0047:
    /* +0x006a8 op=0x85 00 12 04 00 ADD64_IMM16: s18 = s0 +0x4 */
    S[18] = S[0] + 0x4;

L_0048:
    /* +0x006c0 op=0x85 1e 05 58 00 ADD64_IMM16: s5 = s30 +0x58 */
    S[5] = S[30] + 0x58;

L_0049:
    /* +0x006d8 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_004a:
    /* +0x006f0 op=0x34 12 00 06 00 OR64: s6 = s18 | s0 */
    S[6] = S[18] | S[0];

L_004b:
    /* +0x00708 op=0x5e 3a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3a] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x3a, (void *)(uintptr_t)0x125fd360);

L_004c:
    /* +0x00720 op=0x25 1e 00 08 00 ST64: *(s30 +0x8) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[0];

L_004d:
    /* +0x00738 op=0x25 1e 00 00 00 ST64: *(s30 +0x0) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x0) = S[0];

L_004e:
    /* +0x00750 op=0xb5 00 01 20 00 ADD32_IMM16: s1 = int32(s0 +0x20) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x20);

L_004f:
    /* +0x00768 op=0xb5 00 04 e0 ff ADD32_IMM16: s4 = int32(s0 -0x20) */
    S[4] = (int32_t)((uint32_t)S[0] + (-0x20));

L_0050:
    /* +0x00780 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0051:
    /* +0x00798 op=0x53 04 06 d0 09 LD_POOL_PTR: s6 = *(uint64_t *)q1 + 0x9d0 q1=0x125fd3a8 */
    S[6] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x9d0;

L_0052:
    /* +0x007b0 op=0xb5 00 07 00 00 ADD32_IMM16: s7 = int32(s0 +0x0) */
    S[7] = (int32_t)((uint32_t)S[0] + 0x0);

L_0053:
    /* +0x007c8 op=0x85 1e 08 00 00 ADD64_IMM16: s8 = s30 +0x0 */
    S[8] = S[30] + 0x0;

L_0054:
    /* +0x007e0 op=0x52 11 03 58 00 LD32S: s3 = *(int32_t *)(s17 +0x58) */
    S[3] = *(int32_t *)((uint8_t *)S[17] + 0x58);

L_0055:
    /* +0x007f8 op=0xb5 03 03 08 00 ADD32_IMM16: s3 = int32(s3 +0x8) */
    S[3] = (int32_t)((uint32_t)S[3] + 0x8);

L_0056:
    /* +0x00810 op=0xb2 03 03 1f 00 AND64_IMM16: s3 = s3 & 0x1f */
    S[3] = S[3] & 0x1f;

L_0057:
    /* +0x00828 op=0x34 03 04 04 01 OR64: s4 = s3 | s4 */
    S[4] = S[3] | S[4];

L_0058:
    /* +0x00840 op=0x09 01 03 05 04 SUB32: s5 = sign_extend_32((uint32_t)s1 - (uint32_t)s3) */
    S[5] = (int32_t)((uint32_t)S[1] - (uint32_t)S[3]);

L_0059:
    /* +0x00858 op=0xae 02 12 1b 00 BR_EQ64: if (s2 == s18) goto record +117 */
    if (S[2] == S[18]) goto L_0075;

L_005a:
    /* +0x00870 op=0x6e 00 02 09 02 SHL64_IMM: s9 = s2 << 2 */
    S[9] = S[2] << 2;

L_005b:
    /* +0x00888 op=0x34 04 00 0c 01 OR64: s12 = s4 | s0 */
    S[12] = S[4] | S[0];

L_005c:
    /* +0x008a0 op=0x34 07 00 0b 00 OR64: s11 = s7 | s0 */
    S[11] = S[7] | S[0];

L_005d:
    /* +0x008b8 op=0x84 06 09 01 00 ADD64: s1 = s6 + s9 */
    S[1] = S[6] + S[9];

L_005e:
    /* +0x008d0 op=0x52 01 0a 00 00 LD32S: s10 = *(int32_t *)(s1 +0x0) */
    S[10] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_005f:
    /* +0x008e8 op=0xae 0c 00 04 00 BR_EQ64: if (s12 == s0) goto record +100 */
    if (S[12] == S[0]) goto L_0064;

L_0060:
    /* +0x00900 op=0x18 10 0b 01 01 SHL32_IMM: s1 = (int32_t)(s11 << 1) */
    S[1] = (int32_t)((uint32_t)S[11] << 1);

L_0061:
    /* +0x00918 op=0xb5 0c 0c 01 00 ADD32_IMM16: s12 = int32(s12 +0x1) */
    S[12] = (int32_t)((uint32_t)S[12] + 0x1);

L_0062:
    /* +0x00930 op=0x33 01 0b 01 00 OR_IMM16: s11 = s1 | 0x1 */
    S[11] = S[1] | 0x1;

L_0063:
    /* +0x00948 op=0xa7 0c 00 fc ff BR_NE64: if (s12 != s0) goto record +96 */
    if (S[12] != S[0]) goto L_0060;

L_0064:
    /* +0x00960 op=0x34 04 00 0d 01 OR64: s13 = s4 | s0 */
    S[13] = S[4] | S[0];

L_0065:
    /* +0x00978 op=0x34 07 00 0c 01 OR64: s12 = s7 | s0 */
    S[12] = S[7] | S[0];

L_0066:
    /* +0x00990 op=0xae 0d 00 04 00 BR_EQ64: if (s13 == s0) goto record +107 */
    if (S[13] == S[0]) goto L_006b;

L_0067:
    /* +0x009a8 op=0x18 00 0c 01 01 SHL32_IMM: s1 = (int32_t)(s12 << 1) */
    S[1] = (int32_t)((uint32_t)S[12] << 1);

L_0068:
    /* +0x009c0 op=0xb5 0d 0d 01 00 ADD32_IMM16: s13 = int32(s13 +0x1) */
    S[13] = (int32_t)((uint32_t)S[13] + 0x1);

L_0069:
    /* +0x009d8 op=0x33 01 0c 01 00 OR_IMM16: s12 = s1 | 0x1 */
    S[12] = S[1] | 0x1;

L_006a:
    /* +0x009f0 op=0xa7 0d 00 fc ff BR_NE64: if (s13 != s0) goto record +103 */
    if (S[13] != S[0]) goto L_0067;

L_006b:
    /* +0x00a08 op=0x0d 03 0a 01 11 BYTE_FROM_U32_SHIFT: s3 = (uint8_t)((uint32_t)s10 >> (s1 & 31)) */
    S[3] = (uint8_t)((uint32_t)S[10] >> (S[1] & 31));

L_006c:
    /* +0x00a20 op=0x17 05 0a 0a 07 SHL32_VAR: s10 = (int32_t)((uint32_t)s10 << ((uint32_t)s5 & 31)) */
    S[10] = (int32_t)((uint32_t)S[10] << ((uint32_t)S[5] & 31));

L_006d:
    /* +0x00a38 op=0x85 02 02 01 00 ADD64_IMM16: s2 = s2 +0x1 */
    S[2] = S[2] + 0x1;

L_006e:
    /* +0x00a50 op=0x84 08 09 09 04 ADD64: s9 = s8 + s9 */
    S[9] = S[8] + S[9];

L_006f:
    /* +0x00a68 op=0xb3 0b 01 01 01 AND64: s1 = s11 & s1 */
    S[1] = S[11] & S[1];

L_0070:
    /* +0x00a80 op=0x36 0c 00 0b 00 NOR64: s11 = ~(s12 | s0) */
    S[11] = ~(S[12] | S[0]);

L_0071:
    /* +0x00a98 op=0xb3 0a 0b 0a 01 AND64: s10 = s10 & s11 */
    S[10] = S[10] & S[11];

L_0072:
    /* +0x00ab0 op=0x34 0a 01 01 01 OR64: s1 = s10 | s1 */
    S[1] = S[10] | S[1];

L_0073:
    /* +0x00ac8 op=0x08 09 01 00 00 ST32: *(s9 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[9] + 0x0) = (uint32_t)S[1];

L_0074:
    /* +0x00ae0 op=0xa7 02 12 e5 ff BR_NE64: if (s2 != s18) goto record +90 */
    if (S[2] != S[18]) goto L_005a;

L_0075:
    /* +0x00af8 op=0x52 11 01 14 00 LD32S: s1 = *(int32_t *)(s17 +0x14) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_0076:
    /* +0x00b10 op=0x52 1e 03 0c 00 LD32S: s3 = *(int32_t *)(s30 +0xc) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0xc);

L_0077:
    /* +0x00b28 op=0x52 11 02 10 00 LD32S: s2 = *(int32_t *)(s17 +0x10) */
    S[2] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_0078:
    /* +0x00b40 op=0x52 1e 04 08 00 LD32S: s4 = *(int32_t *)(s30 +0x8) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x8);

L_0079:
    /* +0x00b58 op=0x52 1e 05 04 00 LD32S: s5 = *(int32_t *)(s30 +0x4) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x4);

L_007a:
    /* +0x00b70 op=0x02 03 01 01 01 XOR64: s1 = s1 ^ s3 */
    S[1] = S[1] ^ S[3];

L_007b:
    /* +0x00b88 op=0x52 11 03 0c 00 LD32S: s3 = *(int32_t *)(s17 +0xc) */
    S[3] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_007c:
    /* +0x00ba0 op=0x02 04 02 02 01 XOR64: s2 = s2 ^ s4 */
    S[2] = S[2] ^ S[4];

L_007d:
    /* +0x00bb8 op=0x52 1e 04 00 00 LD32S: s4 = *(int32_t *)(s30 +0x0) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x0);

L_007e:
    /* +0x00bd0 op=0x08 11 01 14 00 ST32: *(s17 +0x14) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[17] + 0x14) = (uint32_t)S[1];

L_007f:
    /* +0x00be8 op=0x08 11 02 10 00 ST32: *(s17 +0x10) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[17] + 0x10) = (uint32_t)S[2];

L_0080:
    /* +0x00c00 op=0x02 05 03 01 01 XOR64: s1 = s3 ^ s5 */
    S[1] = S[3] ^ S[5];

L_0081:
    /* +0x00c18 op=0x08 11 01 0c 00 ST32: *(s17 +0xc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[17] + 0xc) = (uint32_t)S[1];

L_0082:
    /* +0x00c30 op=0x52 11 01 08 00 LD32S: s1 = *(int32_t *)(s17 +0x8) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x8);

L_0083:
    /* +0x00c48 op=0x02 04 01 01 00 XOR64: s1 = s1 ^ s4 */
    S[1] = S[1] ^ S[4];

L_0084:
    /* +0x00c60 op=0x08 11 01 08 00 ST32: *(s17 +0x8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[17] + 0x8) = (uint32_t)S[1];

L_0085:
    /* +0x00c78 op=0x26 10 01 00 00 ST8: *(s16 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x0) = (uint8_t)S[1];

L_0086:
    /* +0x00c90 op=0x52 11 01 08 00 LD32S: s1 = *(int32_t *)(s17 +0x8) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x8);

L_0087:
    /* +0x00ca8 op=0x0e 0d 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_0088:
    /* +0x00cc0 op=0x26 10 01 01 00 ST8: *(s16 +0x1) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x1) = (uint8_t)S[1];

L_0089:
    /* +0x00cd8 op=0x55 11 01 0a 00 LD16U: s1 = *(uint16_t *)(s17 +0xa) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0xa);

L_008a:
    /* +0x00cf0 op=0x26 10 01 02 00 ST8: *(s16 +0x2) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x2) = (uint8_t)S[1];

L_008b:
    /* +0x00d08 op=0x59 11 01 0b 00 LD8U: s1 = *(uint8_t *)(s17 +0xb) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0xb);

L_008c:
    /* +0x00d20 op=0x26 10 01 03 00 ST8: *(s16 +0x3) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x3) = (uint8_t)S[1];

L_008d:
    /* +0x00d38 op=0x52 11 01 0c 00 LD32S: s1 = *(int32_t *)(s17 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_008e:
    /* +0x00d50 op=0x26 10 01 04 00 ST8: *(s16 +0x4) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x4) = (uint8_t)S[1];

L_008f:
    /* +0x00d68 op=0x52 11 01 0c 00 LD32S: s1 = *(int32_t *)(s17 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_0090:
    /* +0x00d80 op=0x0e 0d 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_0091:
    /* +0x00d98 op=0x26 10 01 05 00 ST8: *(s16 +0x5) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x5) = (uint8_t)S[1];

L_0092:
    /* +0x00db0 op=0x55 11 01 0e 00 LD16U: s1 = *(uint16_t *)(s17 +0xe) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0xe);

L_0093:
    /* +0x00dc8 op=0x26 10 01 06 00 ST8: *(s16 +0x6) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x6) = (uint8_t)S[1];

L_0094:
    /* +0x00de0 op=0x59 11 01 0f 00 LD8U: s1 = *(uint8_t *)(s17 +0xf) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0xf);

L_0095:
    /* +0x00df8 op=0x26 10 01 07 00 ST8: *(s16 +0x7) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x7) = (uint8_t)S[1];

L_0096:
    /* +0x00e10 op=0x52 11 01 10 00 LD32S: s1 = *(int32_t *)(s17 +0x10) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_0097:
    /* +0x00e28 op=0x26 10 01 08 00 ST8: *(s16 +0x8) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x8) = (uint8_t)S[1];

L_0098:
    /* +0x00e40 op=0x52 11 01 10 00 LD32S: s1 = *(int32_t *)(s17 +0x10) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_0099:
    /* +0x00e58 op=0x0e 0d 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_009a:
    /* +0x00e70 op=0x26 10 01 09 00 ST8: *(s16 +0x9) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x9) = (uint8_t)S[1];

L_009b:
    /* +0x00e88 op=0x55 11 01 12 00 LD16U: s1 = *(uint16_t *)(s17 +0x12) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0x12);

L_009c:
    /* +0x00ea0 op=0x26 10 01 0a 00 ST8: *(s16 +0xa) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xa) = (uint8_t)S[1];

L_009d:
    /* +0x00eb8 op=0x59 11 01 13 00 LD8U: s1 = *(uint8_t *)(s17 +0x13) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0x13);

L_009e:
    /* +0x00ed0 op=0x26 10 01 0b 00 ST8: *(s16 +0xb) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xb) = (uint8_t)S[1];

L_009f:
    /* +0x00ee8 op=0x52 11 01 14 00 LD32S: s1 = *(int32_t *)(s17 +0x14) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_00a0:
    /* +0x00f00 op=0x26 10 01 0c 00 ST8: *(s16 +0xc) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xc) = (uint8_t)S[1];

L_00a1:
    /* +0x00f18 op=0x52 11 01 14 00 LD32S: s1 = *(int32_t *)(s17 +0x14) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_00a2:
    /* +0x00f30 op=0x0e 0b 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_00a3:
    /* +0x00f48 op=0x26 10 01 0d 00 ST8: *(s16 +0xd) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xd) = (uint8_t)S[1];

L_00a4:
    /* +0x00f60 op=0x55 11 01 16 00 LD16U: s1 = *(uint16_t *)(s17 +0x16) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0x16);

L_00a5:
    /* +0x00f78 op=0x26 10 01 0e 00 ST8: *(s16 +0xe) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xe) = (uint8_t)S[1];

L_00a6:
    /* +0x00f90 op=0x59 11 01 17 00 LD8U: s1 = *(uint8_t *)(s17 +0x17) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0x17);

L_00a7:
    /* +0x00fa8 op=0x26 10 01 0f 00 ST8: *(s16 +0xf) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xf) = (uint8_t)S[1];

L_00a8:
    /* +0x00fc0 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_00a9:
    /* +0x00fd8 op=0x58 1d 10 60 00 LD64: s16 = *(uint64_t *)(s29 +0x60) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x60);

L_00aa:
    /* +0x00ff0 op=0x58 1d 11 68 00 LD64: s17 = *(uint64_t *)(s29 +0x68) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x68);

L_00ab:
    /* +0x01008 op=0x58 1d 12 70 00 LD64: s18 = *(uint64_t *)(s29 +0x70) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x70);

L_00ac:
    /* +0x01020 op=0x58 1d 13 78 00 LD64: s19 = *(uint64_t *)(s29 +0x78) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x78);

L_00ad:
    /* +0x01038 op=0x58 1d 14 80 00 LD64: s20 = *(uint64_t *)(s29 +0x80) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x80);

L_00ae:
    /* +0x01050 op=0x58 1d 15 88 00 LD64: s21 = *(uint64_t *)(s29 +0x88) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x88);

L_00af:
    /* +0x01068 op=0x58 1d 1e 90 00 LD64: s30 = *(uint64_t *)(s29 +0x90) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x90);

L_00b0:
    /* +0x01080 op=0x58 1d 1f 98 00 LD64: s31 = *(uint64_t *)(s29 +0x98) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x98);

L_00b1:
    /* +0x01098 op=0x85 1d 1d a0 00 ADD64_IMM16: s29 = s29 +0xa0 */
    S[29] = S[29] + 0xa0;

L_00b2:
    /* +0x010b0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

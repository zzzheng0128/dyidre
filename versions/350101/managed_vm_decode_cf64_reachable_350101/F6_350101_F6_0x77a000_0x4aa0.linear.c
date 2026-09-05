/*
 * Auto-generated linear C-like lift for 350.101 managed program F6.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F6_0x77a000_0x4aa0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F6_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d a0 fb ADD64_IMM16: s29 = s29 -0x460 */
    S[29] = S[29] + (-0x460);

L_0001:
    /* +0x00018 op=0x25 1d 1f 58 04 ST64: *(s29 +0x458) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x458) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 50 04 ST64: *(s29 +0x450) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x450) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 48 04 ST64: *(s29 +0x448) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x448) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 40 04 ST64: *(s29 +0x440) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x440) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 38 04 ST64: *(s29 +0x438) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x438) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 30 04 ST64: *(s29 +0x430) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x430) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 28 04 ST64: *(s29 +0x428) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x428) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 20 04 ST64: *(s29 +0x420) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x420) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 18 04 ST64: *(s29 +0x418) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x418) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 10 04 ST64: *(s29 +0x410) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x410) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x18 11 06 01 00 SHL32_IMM: s1 = (int32_t)(s6 << 0) */
    S[1] = (int32_t)((uint32_t)S[6] << 0);

L_000d:
    /* +0x00138 op=0xb5 00 11 e0 ff ADD32_IMM16: s17 = int32(s0 -0x20) */
    S[17] = (int32_t)((uint32_t)S[0] + (-0x20));

L_000e:
    /* +0x00150 op=0xb5 00 12 20 00 ADD32_IMM16: s18 = int32(s0 +0x20) */
    S[18] = (int32_t)((uint32_t)S[0] + 0x20);

L_000f:
    /* +0x00168 op=0x34 07 00 15 01 OR64: s21 = s7 | s0 */
    S[21] = S[7] | S[0];

L_0010:
    /* +0x00180 op=0x18 11 05 16 00 SHL32_IMM: s22 = (int32_t)(s5 << 0) */
    S[22] = (int32_t)((uint32_t)S[5] << 0);

L_0011:
    /* +0x00198 op=0x34 04 00 14 01 OR64: s20 = s4 | s0 */
    S[20] = S[4] | S[0];

L_0012:
    /* +0x001b0 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_0013:
    /* +0x001c8 op=0x85 00 06 08 00 ADD64_IMM16: s6 = s0 +0x8 */
    S[6] = S[0] + 0x8;

L_0014:
    /* +0x001e0 op=0x53 01 07 e0 09 LD_POOL_PTR: s7 = *(uint64_t *)q1 + 0x9e0 q1=0x125fd3a8 */
    S[7] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x9e0;

L_0015:
    /* +0x001f8 op=0xb5 00 08 00 00 ADD32_IMM16: s8 = int32(s0 +0x0) */
    S[8] = (int32_t)((uint32_t)S[0] + 0x0);

L_0016:
    /* +0x00210 op=0x85 1e 10 b0 03 ADD64_IMM16: s16 = s30 +0x3b0 */
    S[16] = S[30] + 0x3b0;

L_0017:
    /* +0x00228 op=0x08 1e 01 34 00 ST32: *(s30 +0x34) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x34) = (uint32_t)S[1];

L_0018:
    /* +0x00240 op=0xb5 01 01 0d 00 ADD32_IMM16: s1 = int32(s1 +0xd) */
    S[1] = (int32_t)((uint32_t)S[1] + 0xd);

L_0019:
    /* +0x00258 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_001a:
    /* +0x00270 op=0x34 02 11 03 00 OR64: s3 = s2 | s17 */
    S[3] = S[2] | S[17];

L_001b:
    /* +0x00288 op=0x09 12 02 04 04 SUB32: s4 = sign_extend_32((uint32_t)s18 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[18] - (uint32_t)S[2]);

L_001c:
    /* +0x002a0 op=0xae 05 06 1b 00 BR_EQ64: if (s5 == s6) goto record +56 */
    if (S[5] == S[6]) goto L_0038;

L_001d:
    /* +0x002b8 op=0x6e 12 05 09 02 SHL64_IMM: s9 = s5 << 2 */
    S[9] = S[5] << 2;

L_001e:
    /* +0x002d0 op=0x34 03 00 0c 00 OR64: s12 = s3 | s0 */
    S[12] = S[3] | S[0];

L_001f:
    /* +0x002e8 op=0x34 08 00 0b 01 OR64: s11 = s8 | s0 */
    S[11] = S[8] | S[0];

L_0020:
    /* +0x00300 op=0x84 07 09 01 04 ADD64: s1 = s7 + s9 */
    S[1] = S[7] + S[9];

L_0021:
    /* +0x00318 op=0x52 01 0a 00 00 LD32S: s10 = *(int32_t *)(s1 +0x0) */
    S[10] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0022:
    /* +0x00330 op=0xae 0c 00 04 00 BR_EQ64: if (s12 == s0) goto record +39 */
    if (S[12] == S[0]) goto L_0027;

L_0023:
    /* +0x00348 op=0x18 10 0b 01 01 SHL32_IMM: s1 = (int32_t)(s11 << 1) */
    S[1] = (int32_t)((uint32_t)S[11] << 1);

L_0024:
    /* +0x00360 op=0xb5 0c 0c 01 00 ADD32_IMM16: s12 = int32(s12 +0x1) */
    S[12] = (int32_t)((uint32_t)S[12] + 0x1);

L_0025:
    /* +0x00378 op=0x33 01 0b 01 00 OR_IMM16: s11 = s1 | 0x1 */
    S[11] = S[1] | 0x1;

L_0026:
    /* +0x00390 op=0xa7 0c 00 fc ff BR_NE64: if (s12 != s0) goto record +35 */
    if (S[12] != S[0]) goto L_0023;

L_0027:
    /* +0x003a8 op=0x34 03 00 0d 00 OR64: s13 = s3 | s0 */
    S[13] = S[3] | S[0];

L_0028:
    /* +0x003c0 op=0x34 08 00 0c 01 OR64: s12 = s8 | s0 */
    S[12] = S[8] | S[0];

L_0029:
    /* +0x003d8 op=0xae 0d 00 04 00 BR_EQ64: if (s13 == s0) goto record +46 */
    if (S[13] == S[0]) goto L_002e;

L_002a:
    /* +0x003f0 op=0x18 11 0c 01 01 SHL32_IMM: s1 = (int32_t)(s12 << 1) */
    S[1] = (int32_t)((uint32_t)S[12] << 1);

L_002b:
    /* +0x00408 op=0xb5 0d 0d 01 00 ADD32_IMM16: s13 = int32(s13 +0x1) */
    S[13] = (int32_t)((uint32_t)S[13] + 0x1);

L_002c:
    /* +0x00420 op=0x33 01 0c 01 00 OR_IMM16: s12 = s1 | 0x1 */
    S[12] = S[1] | 0x1;

L_002d:
    /* +0x00438 op=0xa7 0d 00 fc ff BR_NE64: if (s13 != s0) goto record +42 */
    if (S[13] != S[0]) goto L_002a;

L_002e:
    /* +0x00450 op=0x0d 02 0a 01 00 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s10 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[10] >> (S[1] & 31));

L_002f:
    /* +0x00468 op=0x17 04 0a 0a 17 SHL32_VAR: s10 = (int32_t)((uint32_t)s10 << ((uint32_t)s4 & 31)) */
    S[10] = (int32_t)((uint32_t)S[10] << ((uint32_t)S[4] & 31));

L_0030:
    /* +0x00480 op=0x84 10 09 09 00 ADD64: s9 = s16 + s9 */
    S[9] = S[16] + S[9];

L_0031:
    /* +0x00498 op=0x85 05 05 01 00 ADD64_IMM16: s5 = s5 +0x1 */
    S[5] = S[5] + 0x1;

L_0032:
    /* +0x004b0 op=0xb3 0b 01 01 00 AND64: s1 = s11 & s1 */
    S[1] = S[11] & S[1];

L_0033:
    /* +0x004c8 op=0x36 0c 00 0b 01 NOR64: s11 = ~(s12 | s0) */
    S[11] = ~(S[12] | S[0]);

L_0034:
    /* +0x004e0 op=0xb3 0a 0b 0a 01 AND64: s10 = s10 & s11 */
    S[10] = S[10] & S[11];

L_0035:
    /* +0x004f8 op=0x34 0a 01 01 01 OR64: s1 = s10 | s1 */
    S[1] = S[10] | S[1];

L_0036:
    /* +0x00510 op=0x08 09 01 00 00 ST32: *(s9 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[9] + 0x0) = (uint32_t)S[1];

L_0037:
    /* +0x00528 op=0xa7 05 06 e5 ff BR_NE64: if (s5 != s6) goto record +29 */
    if (S[5] != S[6]) goto L_001d;

L_0038:
    /* +0x00540 op=0x85 1e 17 b0 02 ADD64_IMM16: s23 = s30 +0x2b0 */
    S[23] = S[30] + 0x2b0;

L_0039:
    /* +0x00558 op=0x85 00 13 00 00 ADD64_IMM16: s19 = s0 +0x0 */
    S[19] = S[0] + 0x0;

L_003a:
    /* +0x00570 op=0x85 00 06 00 01 ADD64_IMM16: s6 = s0 +0x100 */
    S[6] = S[0] + 0x100;

L_003b:
    /* +0x00588 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_003c:
    /* +0x005a0 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_003d:
    /* +0x005b8 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_003e:
    /* +0x005d0 op=0x52 1e 01 34 00 LD32S: s1 = *(int32_t *)(s30 +0x34) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x34);

L_003f:
    /* +0x005e8 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_0040:
    /* +0x00600 op=0x53 01 05 00 0a LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0xa00 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xa00;

L_0041:
    /* +0x00618 op=0xb5 00 0c 00 00 ADD32_IMM16: s12 = int32(s0 +0x0) */
    S[12] = (int32_t)((uint32_t)S[0] + 0x0);

L_0042:
    /* +0x00630 op=0xb5 01 01 0e 00 ADD32_IMM16: s1 = int32(s1 +0xe) */
    S[1] = (int32_t)((uint32_t)S[1] + 0xe);

L_0043:
    /* +0x00648 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_0044:
    /* +0x00660 op=0x34 02 11 03 00 OR64: s3 = s2 | s17 */
    S[3] = S[2] | S[17];

L_0045:
    /* +0x00678 op=0x09 12 02 04 14 SUB32: s4 = sign_extend_32((uint32_t)s18 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[18] - (uint32_t)S[2]);

L_0046:
    /* +0x00690 op=0xae 13 06 1b 00 BR_EQ64: if (s19 == s6) goto record +98 */
    if (S[19] == S[6]) goto L_0062;

L_0047:
    /* +0x006a8 op=0x6e 00 13 07 02 SHL64_IMM: s7 = s19 << 2 */
    S[7] = S[19] << 2;

L_0048:
    /* +0x006c0 op=0x34 03 00 0a 00 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_0049:
    /* +0x006d8 op=0x34 0c 00 09 01 OR64: s9 = s12 | s0 */
    S[9] = S[12] | S[0];

L_004a:
    /* +0x006f0 op=0x84 05 07 01 04 ADD64: s1 = s5 + s7 */
    S[1] = S[5] + S[7];

L_004b:
    /* +0x00708 op=0x52 01 08 00 00 LD32S: s8 = *(int32_t *)(s1 +0x0) */
    S[8] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_004c:
    /* +0x00720 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +81 */
    if (S[10] == S[0]) goto L_0051;

L_004d:
    /* +0x00738 op=0x18 00 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_004e:
    /* +0x00750 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_004f:
    /* +0x00768 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_0050:
    /* +0x00780 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +77 */
    if (S[10] != S[0]) goto L_004d;

L_0051:
    /* +0x00798 op=0x34 03 00 0b 01 OR64: s11 = s3 | s0 */
    S[11] = S[3] | S[0];

L_0052:
    /* +0x007b0 op=0x34 0c 00 0a 01 OR64: s10 = s12 | s0 */
    S[10] = S[12] | S[0];

L_0053:
    /* +0x007c8 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +88 */
    if (S[11] == S[0]) goto L_0058;

L_0054:
    /* +0x007e0 op=0x18 10 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_0055:
    /* +0x007f8 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_0056:
    /* +0x00810 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_0057:
    /* +0x00828 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +84 */
    if (S[11] != S[0]) goto L_0054;

L_0058:
    /* +0x00840 op=0x0d 02 08 01 01 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[8] >> (S[1] & 31));

L_0059:
    /* +0x00858 op=0x17 04 08 08 07 SHL32_VAR: s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31)) */
    S[8] = (int32_t)((uint32_t)S[8] << ((uint32_t)S[4] & 31));

L_005a:
    /* +0x00870 op=0x85 13 13 01 00 ADD64_IMM16: s19 = s19 +0x1 */
    S[19] = S[19] + 0x1;

L_005b:
    /* +0x00888 op=0x84 17 07 07 14 ADD64: s7 = s23 + s7 */
    S[7] = S[23] + S[7];

L_005c:
    /* +0x008a0 op=0xb3 09 01 01 01 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_005d:
    /* +0x008b8 op=0x36 0a 00 09 01 NOR64: s9 = ~(s10 | s0) */
    S[9] = ~(S[10] | S[0]);

L_005e:
    /* +0x008d0 op=0xb3 08 09 08 00 AND64: s8 = s8 & s9 */
    S[8] = S[8] & S[9];

L_005f:
    /* +0x008e8 op=0x34 08 01 01 01 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_0060:
    /* +0x00900 op=0x08 07 01 00 00 ST32: *(s7 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[7] + 0x0) = (uint32_t)S[1];

L_0061:
    /* +0x00918 op=0xa7 13 06 e5 ff BR_NE64: if (s19 != s6) goto record +71 */
    if (S[19] != S[6]) goto L_0047;

L_0062:
    /* +0x00930 op=0x25 1e 15 20 00 ST64: *(s30 +0x20) = s21 */
    *(uint64_t *)((uint8_t *)S[30] + 0x20) = S[21];

L_0063:
    /* +0x00948 op=0x85 1e 15 b0 00 ADD64_IMM16: s21 = s30 +0xb0 */
    S[21] = S[30] + 0xb0;

L_0064:
    /* +0x00960 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_0065:
    /* +0x00978 op=0x25 1e 17 38 00 ST64: *(s30 +0x38) = s23 */
    *(uint64_t *)((uint8_t *)S[30] + 0x38) = S[23];

L_0066:
    /* +0x00990 op=0x85 15 01 34 00 ADD64_IMM16: s1 = s21 +0x34 */
    S[1] = S[21] + 0x34;

L_0067:
    /* +0x009a8 op=0x25 1e 12 40 00 ST64: *(s30 +0x40) = s18 */
    *(uint64_t *)((uint8_t *)S[30] + 0x40) = S[18];

L_0068:
    /* +0x009c0 op=0x25 1e 01 18 00 ST64: *(s30 +0x18) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[1];

L_0069:
    /* +0x009d8 op=0x85 15 01 34 00 ADD64_IMM16: s1 = s21 +0x34 */
    S[1] = S[21] + 0x34;

L_006a:
    /* +0x009f0 op=0x25 1e 01 08 00 ST64: *(s30 +0x8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[1];

L_006b:
    /* +0x00a08 op=0x33 00 01 a3 fe OR_IMM16: s1 = s0 | 0xfea3 */
    S[1] = S[0] | 0xfea3;

L_006c:
    /* +0x00a20 op=0x6e 12 01 01 10 SHL64_IMM: s1 = s1 << 16 */
    S[1] = S[1] << 16;

L_006d:
    /* +0x00a38 op=0x85 01 02 0d 9f ADD64_IMM16: s2 = s1 -0x60f3 */
    S[2] = S[1] + (-0x60f3);

L_006e:
    /* +0x00a50 op=0x25 1e 01 28 00 ST64: *(s30 +0x28) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x28) = S[1];

L_006f:
    /* +0x00a68 op=0x85 01 01 6d 9f ADD64_IMM16: s1 = s1 -0x6093 */
    S[1] = S[1] + (-0x6093);

L_0070:
    /* +0x00a80 op=0x25 1e 02 10 00 ST64: *(s30 +0x10) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x10) = S[2];

L_0071:
    /* +0x00a98 op=0x25 1e 01 48 00 ST64: *(s30 +0x48) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x48) = S[1];

L_0072:
    /* +0x00ab0 op=0x85 1e 13 70 00 ADD64_IMM16: s19 = s30 +0x70 */
    S[19] = S[30] + 0x70;

L_0073:
    /* +0x00ac8 op=0x85 1e 11 d0 03 ADD64_IMM16: s17 = s30 +0x3d0 */
    S[17] = S[30] + 0x3d0;

L_0074:
    /* +0x00ae0 op=0xae 16 00 26 01 BR_EQ64: if (s22 == s0) goto record +411 */
    if (S[22] == S[0]) goto L_019b;

L_0075:
    /* +0x00af8 op=0xa7 12 00 02 00 BR_NE64: if (s18 != s0) goto record +120 */
    if (S[18] != S[0]) goto L_0078;

L_0076:
    /* +0x00b10 op=0x14 16 01 40 00 CMP_LO_IMM64: s1 = ((uint64_t)s22 < (uint64_t)64) ? 1 : 0 */
    S[1] = ((uint64_t)S[22] < (uint64_t)0x40) ? 1 : 0;

L_0077:
    /* +0x00b28 op=0xae 01 00 86 00 BR_EQ64: if (s1 == s0) goto record +254 */
    if (S[1] == S[0]) goto L_00fe;

L_0078:
    /* +0x00b40 op=0x6d 00 16 02 00 SHL64_IMM32PLUS: s2 = s22 << (0 + 32) */
    S[2] = S[22] << (0 + 32);

L_0079:
    /* +0x00b58 op=0x64 06 12 01 00 SUB64: s1 = s6 - s18 */
    S[1] = S[6] - S[18];

L_007a:
    /* +0x00b70 op=0x84 11 12 04 14 ADD64: s4 = s17 + s18 */
    S[4] = S[17] + S[18];

L_007b:
    /* +0x00b88 op=0x34 14 00 05 00 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_007c:
    /* +0x00ba0 op=0x67 00 02 02 00 LSR64_IMM32PLUS: s2 = (uint64_t)s2 >> (0 + 32) */
    S[2] = (uint64_t)S[2] >> (0 + 32);

L_007d:
    /* +0x00bb8 op=0x13 01 02 03 0f CMP_LO64: s3 = ((uint64_t)s1 < (uint64_t)s2) ? 1 : 0 */
    S[3] = ((uint64_t)S[1] < (uint64_t)S[2]) ? 1 : 0;

L_007e:
    /* +0x00bd0 op=0x18 00 03 03 00 SHL32_IMM: s3 = (int32_t)(s3 << 0) */
    S[3] = (int32_t)((uint32_t)S[3] << 0);

L_007f:
    /* +0x00be8 op=0x1e 01 03 01 01 CMOVNZ64: s1 = (s3 != 0) ? s1 : 0 */
    S[1] = (S[3] != 0) ? S[1] : 0;

L_0080:
    /* +0x00c00 op=0x1f 02 03 02 10 CMOVZ64: s2 = (s3 == 0) ? s2 : 0 */
    S[2] = (S[3] == 0) ? S[2] : 0;

L_0081:
    /* +0x00c18 op=0x34 01 02 17 01 OR64: s23 = s1 | s2 */
    S[23] = S[1] | S[2];

L_0082:
    /* +0x00c30 op=0x34 17 00 06 01 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_0083:
    /* +0x00c48 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd360);

L_0084:
    /* +0x00c60 op=0x18 00 17 01 00 SHL32_IMM: s1 = (int32_t)(s23 << 0) */
    S[1] = (int32_t)((uint32_t)S[23] << 0);

L_0085:
    /* +0x00c78 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_0086:
    /* +0x00c90 op=0x84 14 17 14 00 ADD64: s20 = s20 + s23 */
    S[20] = S[20] + S[23];

L_0087:
    /* +0x00ca8 op=0x84 17 12 12 04 ADD64: s18 = s23 + s18 */
    S[18] = S[23] + S[18];

L_0088:
    /* +0x00cc0 op=0x09 16 01 16 00 SUB32: s22 = sign_extend_32((uint32_t)s22 - (uint32_t)s1) */
    S[22] = (int32_t)((uint32_t)S[22] - (uint32_t)S[1]);

L_0089:
    /* +0x00cd8 op=0xa7 12 06 e8 ff BR_NE64: if (s18 != s6) goto record +114 */
    if (S[18] != S[6]) goto L_0072;

L_008a:
    /* +0x00cf0 op=0x85 1e 17 b0 00 ADD64_IMM16: s23 = s30 +0xb0 */
    S[23] = S[30] + 0xb0;

L_008b:
    /* +0x00d08 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_008c:
    /* +0x00d20 op=0x85 00 06 00 02 ADD64_IMM16: s6 = s0 +0x200 */
    S[6] = S[0] + 0x200;

L_008d:
    /* +0x00d38 op=0x25 1e 00 88 00 ST64: *(s30 +0x88) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x88) = S[0];

L_008e:
    /* +0x00d50 op=0x25 1e 00 80 00 ST64: *(s30 +0x80) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x80) = S[0];

L_008f:
    /* +0x00d68 op=0x25 1e 00 78 00 ST64: *(s30 +0x78) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x78) = S[0];

L_0090:
    /* +0x00d80 op=0x25 1e 00 70 00 ST64: *(s30 +0x70) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x70) = S[0];

L_0091:
    /* +0x00d98 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0092:
    /* +0x00db0 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_0093:
    /* +0x00dc8 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0094:
    /* +0x00de0 op=0x58 1e 0e 38 00 LD64: s14 = *(uint64_t *)(s30 +0x38) */
    S[14] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_0095:
    /* +0x00df8 op=0x85 00 0f 20 00 ADD64_IMM16: s15 = s0 +0x20 */
    S[15] = S[0] + 0x20;

L_0096:
    /* +0x00e10 op=0x34 12 00 02 01 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_0097:
    /* +0x00e28 op=0xae 02 0f 06 00 BR_EQ64: if (s2 == s15) goto record +158 */
    if (S[2] == S[15]) goto L_009e;

L_0098:
    /* +0x00e40 op=0x84 10 02 03 04 ADD64: s3 = s16 + s2 */
    S[3] = S[16] + S[2];

L_0099:
    /* +0x00e58 op=0x84 13 02 01 14 ADD64: s1 = s19 + s2 */
    S[1] = S[19] + S[2];

L_009a:
    /* +0x00e70 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_009b:
    /* +0x00e88 op=0x52 03 03 00 00 LD32S: s3 = *(int32_t *)(s3 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[3] + 0x0);

L_009c:
    /* +0x00ea0 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_009d:
    /* +0x00eb8 op=0xa7 02 0f fa ff BR_NE64: if (s2 != s15) goto record +152 */
    if (S[2] != S[15]) goto L_0098;

L_009e:
    /* +0x00ed0 op=0x34 12 00 02 01 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_009f:
    /* +0x00ee8 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_00a0:
    /* +0x00f00 op=0xae 02 06 0f 00 BR_EQ64: if (s2 == s6) goto record +176 */
    if (S[2] == S[6]) goto L_00b0;

L_00a1:
    /* +0x00f18 op=0x84 11 02 01 00 ADD64: s1 = s17 + s2 */
    S[1] = S[17] + S[2];

L_00a2:
    /* +0x00f30 op=0x59 01 03 00 00 LD8U: s3 = *(uint8_t *)(s1 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_00a3:
    /* +0x00f48 op=0x59 01 04 01 00 LD8U: s4 = *(uint8_t *)(s1 +0x1) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x1);

L_00a4:
    /* +0x00f60 op=0x18 11 03 03 18 SHL32_IMM: s3 = (int32_t)(s3 << 24) */
    S[3] = (int32_t)((uint32_t)S[3] << 24);

L_00a5:
    /* +0x00f78 op=0x18 10 04 04 10 SHL32_IMM: s4 = (int32_t)(s4 << 16) */
    S[4] = (int32_t)((uint32_t)S[4] << 16);

L_00a6:
    /* +0x00f90 op=0x34 04 03 03 01 OR64: s3 = s4 | s3 */
    S[3] = S[4] | S[3];

L_00a7:
    /* +0x00fa8 op=0x59 01 04 02 00 LD8U: s4 = *(uint8_t *)(s1 +0x2) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x2);

L_00a8:
    /* +0x00fc0 op=0x59 01 01 03 00 LD8U: s1 = *(uint8_t *)(s1 +0x3) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x3);

L_00a9:
    /* +0x00fd8 op=0x18 00 04 04 08 SHL32_IMM: s4 = (int32_t)(s4 << 8) */
    S[4] = (int32_t)((uint32_t)S[4] << 8);

L_00aa:
    /* +0x00ff0 op=0x34 03 04 03 00 OR64: s3 = s3 | s4 */
    S[3] = S[3] | S[4];

L_00ab:
    /* +0x01008 op=0x34 03 01 01 01 OR64: s1 = s3 | s1 */
    S[1] = S[3] | S[1];

L_00ac:
    /* +0x01020 op=0x84 17 02 03 00 ADD64: s3 = s23 + s2 */
    S[3] = S[23] + S[2];

L_00ad:
    /* +0x01038 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_00ae:
    /* +0x01050 op=0x08 03 01 00 00 ST32: *(s3 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[3] + 0x0) = (uint32_t)S[1];

L_00af:
    /* +0x01068 op=0xa7 02 06 f1 ff BR_NE64: if (s2 != s6) goto record +161 */
    if (S[2] != S[6]) goto L_00a1;

L_00b0:
    /* +0x01080 op=0x58 1e 18 48 00 LD64: s24 = *(uint64_t *)(s30 +0x48) */
    S[24] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_00b1:
    /* +0x01098 op=0x34 12 00 02 00 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_00b2:
    /* +0x010b0 op=0x85 00 09 c0 01 ADD64_IMM16: s9 = s0 +0x1c0 */
    S[9] = S[0] + 0x1c0;

L_00b3:
    /* +0x010c8 op=0xae 02 09 15 00 BR_EQ64: if (s2 == s9) goto record +201 */
    if (S[2] == S[9]) goto L_00c9;

L_00b4:
    /* +0x010e0 op=0x84 17 02 01 14 ADD64: s1 = s23 + s2 */
    S[1] = S[23] + S[2];

L_00b5:
    /* +0x010f8 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_00b6:
    /* +0x01110 op=0x52 01 03 04 00 LD32S: s3 = *(int32_t *)(s1 +0x4) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x4);

L_00b7:
    /* +0x01128 op=0x2e 12 03 04 12 ROR32_IMM: s4 = ror32((uint32_t)s3, 18) */
    S[4] = ror32((uint32_t)S[3], 18);

L_00b8:
    /* +0x01140 op=0x2e 12 03 05 07 ROR32_IMM: s5 = ror32((uint32_t)s3, 7) */
    S[5] = ror32((uint32_t)S[3], 7);

L_00b9:
    /* +0x01158 op=0x0e 0b 03 03 03 LSR32_IMM: s3 = sign_extend_32((uint32_t)s3 >> 3) */
    S[3] = (int32_t)((uint32_t)S[3] >> 3);

L_00ba:
    /* +0x01170 op=0x02 05 04 04 01 XOR64: s4 = s4 ^ s5 */
    S[4] = S[4] ^ S[5];

L_00bb:
    /* +0x01188 op=0x52 01 05 38 00 LD32S: s5 = *(int32_t *)(s1 +0x38) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x38);

L_00bc:
    /* +0x011a0 op=0x02 04 03 03 01 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_00bd:
    /* +0x011b8 op=0x2e 10 05 08 13 ROR32_IMM: s8 = ror32((uint32_t)s5, 19) */
    S[8] = ror32((uint32_t)S[5], 19);

L_00be:
    /* +0x011d0 op=0x2e 10 05 07 11 ROR32_IMM: s7 = ror32((uint32_t)s5, 17) */
    S[7] = ror32((uint32_t)S[5], 17);

L_00bf:
    /* +0x011e8 op=0x0e 0b 05 05 0a LSR32_IMM: s5 = sign_extend_32((uint32_t)s5 >> 10) */
    S[5] = (int32_t)((uint32_t)S[5] >> 10);

L_00c0:
    /* +0x01200 op=0x02 07 08 04 00 XOR64: s4 = s8 ^ s7 */
    S[4] = S[8] ^ S[7];

L_00c1:
    /* +0x01218 op=0x02 04 05 04 01 XOR64: s4 = s5 ^ s4 */
    S[4] = S[5] ^ S[4];

L_00c2:
    /* +0x01230 op=0x52 01 05 24 00 LD32S: s5 = *(int32_t *)(s1 +0x24) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x24);

L_00c3:
    /* +0x01248 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_00c4:
    /* +0x01260 op=0x52 01 05 00 00 LD32S: s5 = *(int32_t *)(s1 +0x0) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_00c5:
    /* +0x01278 op=0xb4 04 05 04 00 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_00c6:
    /* +0x01290 op=0xb4 04 03 03 00 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_00c7:
    /* +0x012a8 op=0x08 01 03 40 00 ST32: *(s1 +0x40) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x40) = (uint32_t)S[3];

L_00c8:
    /* +0x012c0 op=0xa7 02 09 eb ff BR_NE64: if (s2 != s9) goto record +180 */
    if (S[2] != S[9]) goto L_00b4;

L_00c9:
    /* +0x012d8 op=0x58 1e 01 28 00 LD64: s1 = *(uint64_t *)(s30 +0x28) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x28);

L_00ca:
    /* +0x012f0 op=0x52 1e 02 80 00 LD32S: s2 = *(int32_t *)(s30 +0x80) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x80);

L_00cb:
    /* +0x01308 op=0x52 1e 0c 88 00 LD32S: s12 = *(int32_t *)(s30 +0x88) */
    S[12] = *(int32_t *)((uint8_t *)S[30] + 0x88);

L_00cc:
    /* +0x01320 op=0x52 1e 03 7c 00 LD32S: s3 = *(int32_t *)(s30 +0x7c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x7c);

L_00cd:
    /* +0x01338 op=0x52 1e 04 84 00 LD32S: s4 = *(int32_t *)(s30 +0x84) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x84);

L_00ce:
    /* +0x01350 op=0x52 1e 05 78 00 LD32S: s5 = *(int32_t *)(s30 +0x78) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x78);

L_00cf:
    /* +0x01368 op=0x52 1e 19 8c 00 LD32S: s25 = *(int32_t *)(s30 +0x8c) */
    S[25] = *(int32_t *)((uint8_t *)S[30] + 0x8c);

L_00d0:
    /* +0x01380 op=0x52 1e 08 70 00 LD32S: s8 = *(int32_t *)(s30 +0x70) */
    S[8] = *(int32_t *)((uint8_t *)S[30] + 0x70);

L_00d1:
    /* +0x01398 op=0x52 1e 0b 74 00 LD32S: s11 = *(int32_t *)(s30 +0x74) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x74);

L_00d2:
    /* +0x013b0 op=0x58 1e 09 08 00 LD64: s9 = *(uint64_t *)(s30 +0x8) */
    S[9] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_00d3:
    /* +0x013c8 op=0x85 01 07 0d 9f ADD64_IMM16: s7 = s1 -0x60f3 */
    S[7] = S[1] + (-0x60f3);

L_00d4:
    /* +0x013e0 op=0x34 08 00 0a 00 OR64: s10 = s8 | s0 */
    S[10] = S[8] | S[0];

L_00d5:
    /* +0x013f8 op=0x34 19 00 08 01 OR64: s8 = s25 | s0 */
    S[8] = S[25] | S[0];

L_00d6:
    /* +0x01410 op=0x34 0c 00 19 01 OR64: s25 = s12 | s0 */
    S[25] = S[12] | S[0];

L_00d7:
    /* +0x01428 op=0xae 07 18 98 00 BR_EQ64: if (s7 == s24) goto record +368 */
    if (S[7] == S[24]) goto L_0170;

L_00d8:
    /* +0x01440 op=0x2e 10 0a 01 0b ROR32_IMM: s1 = ror32((uint32_t)s10, 11) */
    S[1] = ror32((uint32_t)S[10], 11);

L_00d9:
    /* +0x01458 op=0x2e 12 0a 0c 06 ROR32_IMM: s12 = ror32((uint32_t)s10, 6) */
    S[12] = ror32((uint32_t)S[10], 6);

L_00da:
    /* +0x01470 op=0x34 03 04 0d 00 OR64: s13 = s3 | s4 */
    S[13] = S[3] | S[4];

L_00db:
    /* +0x01488 op=0x02 0c 01 01 01 XOR64: s1 = s1 ^ s12 */
    S[1] = S[1] ^ S[12];

L_00dc:
    /* +0x014a0 op=0x2e 10 0a 0c 19 ROR32_IMM: s12 = ror32((uint32_t)s10, 25) */
    S[12] = ror32((uint32_t)S[10], 25);

L_00dd:
    /* +0x014b8 op=0xb3 0d 19 0d 01 AND64: s13 = s13 & s25 */
    S[13] = S[13] & S[25];

L_00de:
    /* +0x014d0 op=0x02 01 0c 01 01 XOR64: s1 = s12 ^ s1 */
    S[1] = S[12] ^ S[1];

L_00df:
    /* +0x014e8 op=0x52 09 0c 00 00 LD32S: s12 = *(int32_t *)(s9 +0x0) */
    S[12] = *(int32_t *)((uint8_t *)S[9] + 0x0);

L_00e0:
    /* +0x01500 op=0x85 09 09 04 00 ADD64_IMM16: s9 = s9 +0x4 */
    S[9] = S[9] + 0x4;

L_00e1:
    /* +0x01518 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_00e2:
    /* +0x01530 op=0xb2 07 0b 3f 00 AND64_IMM16: s11 = s7 & 0x3f */
    S[11] = S[7] & 0x3f;

L_00e3:
    /* +0x01548 op=0x85 07 07 01 00 ADD64_IMM16: s7 = s7 +0x1 */
    S[7] = S[7] + 0x1;

L_00e4:
    /* +0x01560 op=0x6e 02 0b 0b 02 SHL64_IMM: s11 = s11 << 2 */
    S[11] = S[11] << 2;

L_00e5:
    /* +0x01578 op=0x84 0e 0b 0b 00 ADD64: s11 = s14 + s11 */
    S[11] = S[14] + S[11];

L_00e6:
    /* +0x01590 op=0x52 0b 0b 00 00 LD32S: s11 = *(int32_t *)(s11 +0x0) */
    S[11] = *(int32_t *)((uint8_t *)S[11] + 0x0);

L_00e7:
    /* +0x015a8 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_00e8:
    /* +0x015c0 op=0x02 05 08 0b 01 XOR64: s11 = s8 ^ s5 */
    S[11] = S[8] ^ S[5];

L_00e9:
    /* +0x015d8 op=0xb3 0b 0a 0b 01 AND64: s11 = s11 & s10 */
    S[11] = S[11] & S[10];

L_00ea:
    /* +0x015f0 op=0xb4 01 0c 01 02 ADD32: s1 = int32(s1 + s12) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[12]);

L_00eb:
    /* +0x01608 op=0xb3 03 04 0c 01 AND64: s12 = s3 & s4 */
    S[12] = S[3] & S[4];

L_00ec:
    /* +0x01620 op=0x02 0b 08 0b 01 XOR64: s11 = s8 ^ s11 */
    S[11] = S[8] ^ S[11];

L_00ed:
    /* +0x01638 op=0x34 0d 0c 0c 01 OR64: s12 = s13 | s12 */
    S[12] = S[13] | S[12];

L_00ee:
    /* +0x01650 op=0x2e 12 04 0d 02 ROR32_IMM: s13 = ror32((uint32_t)s4, 2) */
    S[13] = ror32((uint32_t)S[4], 2);

L_00ef:
    /* +0x01668 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_00f0:
    /* +0x01680 op=0x2e 12 04 0b 0d ROR32_IMM: s11 = ror32((uint32_t)s4, 13) */
    S[11] = ror32((uint32_t)S[4], 13);

L_00f1:
    /* +0x01698 op=0x02 0d 0b 0b 01 XOR64: s11 = s11 ^ s13 */
    S[11] = S[11] ^ S[13];

L_00f2:
    /* +0x016b0 op=0x2e 10 04 0d 16 ROR32_IMM: s13 = ror32((uint32_t)s4, 22) */
    S[13] = ror32((uint32_t)S[4], 22);

L_00f3:
    /* +0x016c8 op=0x02 0b 0d 0b 01 XOR64: s11 = s13 ^ s11 */
    S[11] = S[13] ^ S[11];

L_00f4:
    /* +0x016e0 op=0xb4 01 0b 0b 00 ADD32: s11 = int32(s1 + s11) */
    S[11] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_00f5:
    /* +0x016f8 op=0xb4 02 01 01 12 ADD32: s1 = int32(s2 + s1) */
    S[1] = (int32_t)((uint32_t)S[2] + (uint32_t)S[1]);

L_00f6:
    /* +0x01710 op=0x34 03 00 02 01 OR64: s2 = s3 | s0 */
    S[2] = S[3] | S[0];

L_00f7:
    /* +0x01728 op=0x34 05 00 03 01 OR64: s3 = s5 | s0 */
    S[3] = S[5] | S[0];

L_00f8:
    /* +0x01740 op=0xb4 0b 0c 0b 00 ADD32: s11 = int32(s11 + s12) */
    S[11] = (int32_t)((uint32_t)S[11] + (uint32_t)S[12]);

L_00f9:
    /* +0x01758 op=0x34 04 00 0c 01 OR64: s12 = s4 | s0 */
    S[12] = S[4] | S[0];

L_00fa:
    /* +0x01770 op=0x34 01 00 04 01 OR64: s4 = s1 | s0 */
    S[4] = S[1] | S[0];

L_00fb:
    /* +0x01788 op=0x34 0b 00 05 01 OR64: s5 = s11 | s0 */
    S[5] = S[11] | S[0];

L_00fc:
    /* +0x017a0 op=0x34 0a 00 0b 00 OR64: s11 = s10 | s0 */
    S[11] = S[10] | S[0];

L_00fd:
    /* +0x017b8 op=0x5f d6 ff ff ff ADD_PC_IMM32: goto record +212 ; vm_pc = current_pc + 1 + -42 */
    goto L_00d4;

L_00fe:
    /* +0x017d0 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_00ff:
    /* +0x017e8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0100:
    /* +0x01800 op=0x85 00 06 00 02 ADD64_IMM16: s6 = s0 +0x200 */
    S[6] = S[0] + 0x200;

L_0101:
    /* +0x01818 op=0x25 1e 00 88 00 ST64: *(s30 +0x88) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x88) = S[0];

L_0102:
    /* +0x01830 op=0x25 1e 00 80 00 ST64: *(s30 +0x80) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x80) = S[0];

L_0103:
    /* +0x01848 op=0x25 1e 00 78 00 ST64: *(s30 +0x78) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x78) = S[0];

L_0104:
    /* +0x01860 op=0x25 1e 00 70 00 ST64: *(s30 +0x70) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x70) = S[0];

L_0105:
    /* +0x01878 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_0106:
    /* +0x01890 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0107:
    /* +0x018a8 op=0x58 1e 0e 38 00 LD64: s14 = *(uint64_t *)(s30 +0x38) */
    S[14] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_0108:
    /* +0x018c0 op=0x58 1e 18 48 00 LD64: s24 = *(uint64_t *)(s30 +0x48) */
    S[24] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_0109:
    /* +0x018d8 op=0x34 12 00 02 01 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_010a:
    /* +0x018f0 op=0x85 00 0f 20 00 ADD64_IMM16: s15 = s0 +0x20 */
    S[15] = S[0] + 0x20;

L_010b:
    /* +0x01908 op=0x85 00 09 c0 01 ADD64_IMM16: s9 = s0 +0x1c0 */
    S[9] = S[0] + 0x1c0;

L_010c:
    /* +0x01920 op=0xae 02 0f 06 00 BR_EQ64: if (s2 == s15) goto record +275 */
    if (S[2] == S[15]) goto L_0113;

L_010d:
    /* +0x01938 op=0x84 10 02 03 00 ADD64: s3 = s16 + s2 */
    S[3] = S[16] + S[2];

L_010e:
    /* +0x01950 op=0x84 13 02 01 00 ADD64: s1 = s19 + s2 */
    S[1] = S[19] + S[2];

L_010f:
    /* +0x01968 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0110:
    /* +0x01980 op=0x52 03 03 00 00 LD32S: s3 = *(int32_t *)(s3 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[3] + 0x0);

L_0111:
    /* +0x01998 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_0112:
    /* +0x019b0 op=0xa7 02 0f fa ff BR_NE64: if (s2 != s15) goto record +269 */
    if (S[2] != S[15]) goto L_010d;

L_0113:
    /* +0x019c8 op=0x34 12 00 02 01 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_0114:
    /* +0x019e0 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_0115:
    /* +0x019f8 op=0xae 02 06 0f 00 BR_EQ64: if (s2 == s6) goto record +293 */
    if (S[2] == S[6]) goto L_0125;

L_0116:
    /* +0x01a10 op=0x84 14 02 01 04 ADD64: s1 = s20 + s2 */
    S[1] = S[20] + S[2];

L_0117:
    /* +0x01a28 op=0x59 01 03 00 00 LD8U: s3 = *(uint8_t *)(s1 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0118:
    /* +0x01a40 op=0x59 01 04 01 00 LD8U: s4 = *(uint8_t *)(s1 +0x1) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x1);

L_0119:
    /* +0x01a58 op=0x18 10 03 03 18 SHL32_IMM: s3 = (int32_t)(s3 << 24) */
    S[3] = (int32_t)((uint32_t)S[3] << 24);

L_011a:
    /* +0x01a70 op=0x18 00 04 04 10 SHL32_IMM: s4 = (int32_t)(s4 << 16) */
    S[4] = (int32_t)((uint32_t)S[4] << 16);

L_011b:
    /* +0x01a88 op=0x34 04 03 03 00 OR64: s3 = s4 | s3 */
    S[3] = S[4] | S[3];

L_011c:
    /* +0x01aa0 op=0x59 01 04 02 00 LD8U: s4 = *(uint8_t *)(s1 +0x2) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x2);

L_011d:
    /* +0x01ab8 op=0x59 01 01 03 00 LD8U: s1 = *(uint8_t *)(s1 +0x3) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x3);

L_011e:
    /* +0x01ad0 op=0x18 11 04 04 08 SHL32_IMM: s4 = (int32_t)(s4 << 8) */
    S[4] = (int32_t)((uint32_t)S[4] << 8);

L_011f:
    /* +0x01ae8 op=0x34 03 04 03 01 OR64: s3 = s3 | s4 */
    S[3] = S[3] | S[4];

L_0120:
    /* +0x01b00 op=0x34 03 01 01 00 OR64: s1 = s3 | s1 */
    S[1] = S[3] | S[1];

L_0121:
    /* +0x01b18 op=0x84 15 02 03 14 ADD64: s3 = s21 + s2 */
    S[3] = S[21] + S[2];

L_0122:
    /* +0x01b30 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0123:
    /* +0x01b48 op=0x08 03 01 00 00 ST32: *(s3 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[3] + 0x0) = (uint32_t)S[1];

L_0124:
    /* +0x01b60 op=0xa7 02 06 f1 ff BR_NE64: if (s2 != s6) goto record +278 */
    if (S[2] != S[6]) goto L_0116;

L_0125:
    /* +0x01b78 op=0x34 12 00 02 00 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_0126:
    /* +0x01b90 op=0xae 02 09 15 00 BR_EQ64: if (s2 == s9) goto record +316 */
    if (S[2] == S[9]) goto L_013c;

L_0127:
    /* +0x01ba8 op=0x84 15 02 01 14 ADD64: s1 = s21 + s2 */
    S[1] = S[21] + S[2];

L_0128:
    /* +0x01bc0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0129:
    /* +0x01bd8 op=0x52 01 03 04 00 LD32S: s3 = *(int32_t *)(s1 +0x4) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x4);

L_012a:
    /* +0x01bf0 op=0x2e 10 03 04 12 ROR32_IMM: s4 = ror32((uint32_t)s3, 18) */
    S[4] = ror32((uint32_t)S[3], 18);

L_012b:
    /* +0x01c08 op=0x2e 01 03 05 07 ROR32_IMM: s5 = ror32((uint32_t)s3, 7) */
    S[5] = ror32((uint32_t)S[3], 7);

L_012c:
    /* +0x01c20 op=0x0e 00 03 03 03 LSR32_IMM: s3 = sign_extend_32((uint32_t)s3 >> 3) */
    S[3] = (int32_t)((uint32_t)S[3] >> 3);

L_012d:
    /* +0x01c38 op=0x02 05 04 04 01 XOR64: s4 = s4 ^ s5 */
    S[4] = S[4] ^ S[5];

L_012e:
    /* +0x01c50 op=0x52 01 05 38 00 LD32S: s5 = *(int32_t *)(s1 +0x38) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x38);

L_012f:
    /* +0x01c68 op=0x02 04 03 03 01 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_0130:
    /* +0x01c80 op=0x2e 10 05 08 13 ROR32_IMM: s8 = ror32((uint32_t)s5, 19) */
    S[8] = ror32((uint32_t)S[5], 19);

L_0131:
    /* +0x01c98 op=0x2e 01 05 07 11 ROR32_IMM: s7 = ror32((uint32_t)s5, 17) */
    S[7] = ror32((uint32_t)S[5], 17);

L_0132:
    /* +0x01cb0 op=0x0e 0d 05 05 0a LSR32_IMM: s5 = sign_extend_32((uint32_t)s5 >> 10) */
    S[5] = (int32_t)((uint32_t)S[5] >> 10);

L_0133:
    /* +0x01cc8 op=0x02 07 08 04 01 XOR64: s4 = s8 ^ s7 */
    S[4] = S[8] ^ S[7];

L_0134:
    /* +0x01ce0 op=0x02 04 05 04 01 XOR64: s4 = s5 ^ s4 */
    S[4] = S[5] ^ S[4];

L_0135:
    /* +0x01cf8 op=0x52 01 05 24 00 LD32S: s5 = *(int32_t *)(s1 +0x24) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x24);

L_0136:
    /* +0x01d10 op=0xb4 04 05 04 02 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_0137:
    /* +0x01d28 op=0x52 01 05 00 00 LD32S: s5 = *(int32_t *)(s1 +0x0) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0138:
    /* +0x01d40 op=0xb4 04 05 04 02 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_0139:
    /* +0x01d58 op=0xb4 04 03 03 02 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_013a:
    /* +0x01d70 op=0x08 01 03 40 00 ST32: *(s1 +0x40) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x40) = (uint32_t)S[3];

L_013b:
    /* +0x01d88 op=0xa7 02 09 eb ff BR_NE64: if (s2 != s9) goto record +295 */
    if (S[2] != S[9]) goto L_0127;

L_013c:
    /* +0x01da0 op=0x52 1e 02 80 00 LD32S: s2 = *(int32_t *)(s30 +0x80) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x80);

L_013d:
    /* +0x01db8 op=0x52 1e 0c 88 00 LD32S: s12 = *(int32_t *)(s30 +0x88) */
    S[12] = *(int32_t *)((uint8_t *)S[30] + 0x88);

L_013e:
    /* +0x01dd0 op=0x52 1e 03 7c 00 LD32S: s3 = *(int32_t *)(s30 +0x7c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x7c);

L_013f:
    /* +0x01de8 op=0x52 1e 04 84 00 LD32S: s4 = *(int32_t *)(s30 +0x84) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x84);

L_0140:
    /* +0x01e00 op=0x52 1e 05 78 00 LD32S: s5 = *(int32_t *)(s30 +0x78) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x78);

L_0141:
    /* +0x01e18 op=0x52 1e 19 8c 00 LD32S: s25 = *(int32_t *)(s30 +0x8c) */
    S[25] = *(int32_t *)((uint8_t *)S[30] + 0x8c);

L_0142:
    /* +0x01e30 op=0x52 1e 07 70 00 LD32S: s7 = *(int32_t *)(s30 +0x70) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x70);

L_0143:
    /* +0x01e48 op=0x52 1e 0b 74 00 LD32S: s11 = *(int32_t *)(s30 +0x74) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x74);

L_0144:
    /* +0x01e60 op=0x58 1e 08 10 00 LD64: s8 = *(uint64_t *)(s30 +0x10) */
    S[8] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_0145:
    /* +0x01e78 op=0x58 1e 09 18 00 LD64: s9 = *(uint64_t *)(s30 +0x18) */
    S[9] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_0146:
    /* +0x01e90 op=0x34 07 00 0a 01 OR64: s10 = s7 | s0 */
    S[10] = S[7] | S[0];

L_0147:
    /* +0x01ea8 op=0x34 19 00 07 00 OR64: s7 = s25 | s0 */
    S[7] = S[25] | S[0];

L_0148:
    /* +0x01ec0 op=0x34 0c 00 19 01 OR64: s25 = s12 | s0 */
    S[25] = S[12] | S[0];

L_0149:
    /* +0x01ed8 op=0xae 08 18 39 00 BR_EQ64: if (s8 == s24) goto record +387 */
    if (S[8] == S[24]) goto L_0183;

L_014a:
    /* +0x01ef0 op=0x2e 12 0a 01 0b ROR32_IMM: s1 = ror32((uint32_t)s10, 11) */
    S[1] = ror32((uint32_t)S[10], 11);

L_014b:
    /* +0x01f08 op=0x2e 10 0a 0c 06 ROR32_IMM: s12 = ror32((uint32_t)s10, 6) */
    S[12] = ror32((uint32_t)S[10], 6);

L_014c:
    /* +0x01f20 op=0x34 03 04 0d 00 OR64: s13 = s3 | s4 */
    S[13] = S[3] | S[4];

L_014d:
    /* +0x01f38 op=0x02 0c 01 01 01 XOR64: s1 = s1 ^ s12 */
    S[1] = S[1] ^ S[12];

L_014e:
    /* +0x01f50 op=0x2e 10 0a 0c 19 ROR32_IMM: s12 = ror32((uint32_t)s10, 25) */
    S[12] = ror32((uint32_t)S[10], 25);

L_014f:
    /* +0x01f68 op=0xb3 0d 19 0d 00 AND64: s13 = s13 & s25 */
    S[13] = S[13] & S[25];

L_0150:
    /* +0x01f80 op=0x02 01 0c 01 01 XOR64: s1 = s12 ^ s1 */
    S[1] = S[12] ^ S[1];

L_0151:
    /* +0x01f98 op=0x52 09 0c 00 00 LD32S: s12 = *(int32_t *)(s9 +0x0) */
    S[12] = *(int32_t *)((uint8_t *)S[9] + 0x0);

L_0152:
    /* +0x01fb0 op=0x85 09 09 04 00 ADD64_IMM16: s9 = s9 +0x4 */
    S[9] = S[9] + 0x4;

L_0153:
    /* +0x01fc8 op=0xb4 01 0b 01 00 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0154:
    /* +0x01fe0 op=0xb2 08 0b 3f 00 AND64_IMM16: s11 = s8 & 0x3f */
    S[11] = S[8] & 0x3f;

L_0155:
    /* +0x01ff8 op=0x85 08 08 01 00 ADD64_IMM16: s8 = s8 +0x1 */
    S[8] = S[8] + 0x1;

L_0156:
    /* +0x02010 op=0x6e 00 0b 0b 02 SHL64_IMM: s11 = s11 << 2 */
    S[11] = S[11] << 2;

L_0157:
    /* +0x02028 op=0x84 0e 0b 0b 14 ADD64: s11 = s14 + s11 */
    S[11] = S[14] + S[11];

L_0158:
    /* +0x02040 op=0x52 0b 0b 00 00 LD32S: s11 = *(int32_t *)(s11 +0x0) */
    S[11] = *(int32_t *)((uint8_t *)S[11] + 0x0);

L_0159:
    /* +0x02058 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_015a:
    /* +0x02070 op=0x02 05 07 0b 01 XOR64: s11 = s7 ^ s5 */
    S[11] = S[7] ^ S[5];

L_015b:
    /* +0x02088 op=0xb3 0b 0a 0b 01 AND64: s11 = s11 & s10 */
    S[11] = S[11] & S[10];

L_015c:
    /* +0x020a0 op=0xb4 01 0c 01 00 ADD32: s1 = int32(s1 + s12) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[12]);

L_015d:
    /* +0x020b8 op=0xb3 03 04 0c 01 AND64: s12 = s3 & s4 */
    S[12] = S[3] & S[4];

L_015e:
    /* +0x020d0 op=0x02 0b 07 0b 01 XOR64: s11 = s7 ^ s11 */
    S[11] = S[7] ^ S[11];

L_015f:
    /* +0x020e8 op=0x34 0d 0c 0c 00 OR64: s12 = s13 | s12 */
    S[12] = S[13] | S[12];

L_0160:
    /* +0x02100 op=0x2e 10 04 0d 02 ROR32_IMM: s13 = ror32((uint32_t)s4, 2) */
    S[13] = ror32((uint32_t)S[4], 2);

L_0161:
    /* +0x02118 op=0xb4 01 0b 01 00 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0162:
    /* +0x02130 op=0x2e 01 04 0b 0d ROR32_IMM: s11 = ror32((uint32_t)s4, 13) */
    S[11] = ror32((uint32_t)S[4], 13);

L_0163:
    /* +0x02148 op=0x02 0d 0b 0b 00 XOR64: s11 = s11 ^ s13 */
    S[11] = S[11] ^ S[13];

L_0164:
    /* +0x02160 op=0x2e 01 04 0d 16 ROR32_IMM: s13 = ror32((uint32_t)s4, 22) */
    S[13] = ror32((uint32_t)S[4], 22);

L_0165:
    /* +0x02178 op=0x02 0b 0d 0b 01 XOR64: s11 = s13 ^ s11 */
    S[11] = S[13] ^ S[11];

L_0166:
    /* +0x02190 op=0xb4 01 0b 0b 12 ADD32: s11 = int32(s1 + s11) */
    S[11] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0167:
    /* +0x021a8 op=0xb4 02 01 01 02 ADD32: s1 = int32(s2 + s1) */
    S[1] = (int32_t)((uint32_t)S[2] + (uint32_t)S[1]);

L_0168:
    /* +0x021c0 op=0x34 03 00 02 01 OR64: s2 = s3 | s0 */
    S[2] = S[3] | S[0];

L_0169:
    /* +0x021d8 op=0x34 05 00 03 01 OR64: s3 = s5 | s0 */
    S[3] = S[5] | S[0];

L_016a:
    /* +0x021f0 op=0xb4 0b 0c 0b 00 ADD32: s11 = int32(s11 + s12) */
    S[11] = (int32_t)((uint32_t)S[11] + (uint32_t)S[12]);

L_016b:
    /* +0x02208 op=0x34 04 00 0c 01 OR64: s12 = s4 | s0 */
    S[12] = S[4] | S[0];

L_016c:
    /* +0x02220 op=0x34 01 00 04 00 OR64: s4 = s1 | s0 */
    S[4] = S[1] | S[0];

L_016d:
    /* +0x02238 op=0x34 0b 00 05 01 OR64: s5 = s11 | s0 */
    S[5] = S[11] | S[0];

L_016e:
    /* +0x02250 op=0x34 0a 00 0b 01 OR64: s11 = s10 | s0 */
    S[11] = S[10] | S[0];

L_016f:
    /* +0x02268 op=0x5f d6 ff ff ff ADD_PC_IMM32: goto record +326 ; vm_pc = current_pc + 1 + -42 */
    goto L_0146;

L_0170:
    /* +0x02280 op=0x08 1e 08 8c 00 ST32: *(s30 +0x8c) = (uint32_t)s8 */
    *(uint32_t *)((uint8_t *)S[30] + 0x8c) = (uint32_t)S[8];

L_0171:
    /* +0x02298 op=0x08 1e 0a 70 00 ST32: *(s30 +0x70) = (uint32_t)s10 */
    *(uint32_t *)((uint8_t *)S[30] + 0x70) = (uint32_t)S[10];

L_0172:
    /* +0x022b0 op=0x08 1e 0b 74 00 ST32: *(s30 +0x74) = (uint32_t)s11 */
    *(uint32_t *)((uint8_t *)S[30] + 0x74) = (uint32_t)S[11];

L_0173:
    /* +0x022c8 op=0x08 1e 04 84 00 ST32: *(s30 +0x84) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x84) = (uint32_t)S[4];

L_0174:
    /* +0x022e0 op=0x08 1e 05 78 00 ST32: *(s30 +0x78) = (uint32_t)s5 */
    *(uint32_t *)((uint8_t *)S[30] + 0x78) = (uint32_t)S[5];

L_0175:
    /* +0x022f8 op=0x08 1e 19 88 00 ST32: *(s30 +0x88) = (uint32_t)s25 */
    *(uint32_t *)((uint8_t *)S[30] + 0x88) = (uint32_t)S[25];

L_0176:
    /* +0x02310 op=0x08 1e 03 7c 00 ST32: *(s30 +0x7c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x7c) = (uint32_t)S[3];

L_0177:
    /* +0x02328 op=0x08 1e 02 80 00 ST32: *(s30 +0x80) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x80) = (uint32_t)S[2];

L_0178:
    /* +0x02340 op=0x34 12 00 02 00 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_0179:
    /* +0x02358 op=0xae 02 0f 1d 00 BR_EQ64: if (s2 == s15) goto record +407 */
    if (S[2] == S[15]) goto L_0197;

L_017a:
    /* +0x02370 op=0x84 13 02 04 04 ADD64: s4 = s19 + s2 */
    S[4] = S[19] + S[2];

L_017b:
    /* +0x02388 op=0x84 10 02 01 04 ADD64: s1 = s16 + s2 */
    S[1] = S[16] + S[2];

L_017c:
    /* +0x023a0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_017d:
    /* +0x023b8 op=0x52 01 03 00 00 LD32S: s3 = *(int32_t *)(s1 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_017e:
    /* +0x023d0 op=0x52 04 04 00 00 LD32S: s4 = *(int32_t *)(s4 +0x0) */
    S[4] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_017f:
    /* +0x023e8 op=0xb4 04 03 03 12 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_0180:
    /* +0x02400 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_0181:
    /* +0x02418 op=0xa7 02 0f f8 ff BR_NE64: if (s2 != s15) goto record +378 */
    if (S[2] != S[15]) goto L_017a;

L_0182:
    /* +0x02430 op=0x5f 14 00 00 00 ADD_PC_IMM32: goto record +407 ; vm_pc = current_pc + 1 + 20 */
    goto L_0197;

L_0183:
    /* +0x02448 op=0x08 1e 07 8c 00 ST32: *(s30 +0x8c) = (uint32_t)s7 */
    *(uint32_t *)((uint8_t *)S[30] + 0x8c) = (uint32_t)S[7];

L_0184:
    /* +0x02460 op=0x08 1e 0a 70 00 ST32: *(s30 +0x70) = (uint32_t)s10 */
    *(uint32_t *)((uint8_t *)S[30] + 0x70) = (uint32_t)S[10];

L_0185:
    /* +0x02478 op=0x08 1e 0b 74 00 ST32: *(s30 +0x74) = (uint32_t)s11 */
    *(uint32_t *)((uint8_t *)S[30] + 0x74) = (uint32_t)S[11];

L_0186:
    /* +0x02490 op=0x08 1e 04 84 00 ST32: *(s30 +0x84) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x84) = (uint32_t)S[4];

L_0187:
    /* +0x024a8 op=0x08 1e 05 78 00 ST32: *(s30 +0x78) = (uint32_t)s5 */
    *(uint32_t *)((uint8_t *)S[30] + 0x78) = (uint32_t)S[5];

L_0188:
    /* +0x024c0 op=0x08 1e 19 88 00 ST32: *(s30 +0x88) = (uint32_t)s25 */
    *(uint32_t *)((uint8_t *)S[30] + 0x88) = (uint32_t)S[25];

L_0189:
    /* +0x024d8 op=0x08 1e 03 7c 00 ST32: *(s30 +0x7c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x7c) = (uint32_t)S[3];

L_018a:
    /* +0x024f0 op=0x08 1e 02 80 00 ST32: *(s30 +0x80) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x80) = (uint32_t)S[2];

L_018b:
    /* +0x02508 op=0x34 12 00 02 00 OR64: s2 = s18 | s0 */
    S[2] = S[18] | S[0];

L_018c:
    /* +0x02520 op=0xae 02 0f 08 00 BR_EQ64: if (s2 == s15) goto record +405 */
    if (S[2] == S[15]) goto L_0195;

L_018d:
    /* +0x02538 op=0x84 13 02 04 04 ADD64: s4 = s19 + s2 */
    S[4] = S[19] + S[2];

L_018e:
    /* +0x02550 op=0x84 10 02 01 14 ADD64: s1 = s16 + s2 */
    S[1] = S[16] + S[2];

L_018f:
    /* +0x02568 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0190:
    /* +0x02580 op=0x52 01 03 00 00 LD32S: s3 = *(int32_t *)(s1 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0191:
    /* +0x02598 op=0x52 04 04 00 00 LD32S: s4 = *(int32_t *)(s4 +0x0) */
    S[4] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_0192:
    /* +0x025b0 op=0xb4 04 03 03 12 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_0193:
    /* +0x025c8 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_0194:
    /* +0x025e0 op=0xa7 02 0f f8 ff BR_NE64: if (s2 != s15) goto record +397 */
    if (S[2] != S[15]) goto L_018d;

L_0195:
    /* +0x025f8 op=0xb5 16 16 c0 ff ADD32_IMM16: s22 = int32(s22 -0x40) */
    S[22] = (int32_t)((uint32_t)S[22] + (-0x40));

L_0196:
    /* +0x02610 op=0x85 14 14 40 00 ADD64_IMM16: s20 = s20 +0x40 */
    S[20] = S[20] + 0x40;

L_0197:
    /* +0x02628 op=0x58 1e 01 40 00 LD64: s1 = *(uint64_t *)(s30 +0x40) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_0198:
    /* +0x02640 op=0x85 01 01 00 02 ADD64_IMM16: s1 = s1 +0x200 */
    S[1] = S[1] + 0x200;

L_0199:
    /* +0x02658 op=0x25 1e 01 40 00 ST64: *(s30 +0x40) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x40) = S[1];

L_019a:
    /* +0x02670 op=0x5f d7 fe ff ff ADD_PC_IMM32: goto record +114 ; vm_pc = current_pc + 1 + -297 */
    goto L_0072;

L_019b:
    /* +0x02688 op=0x85 00 14 00 00 ADD64_IMM16: s20 = s0 +0x0 */
    S[20] = S[0] + 0x0;

L_019c:
    /* +0x026a0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_019d:
    /* +0x026b8 op=0x34 14 00 05 00 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_019e:
    /* +0x026d0 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_019f:
    /* +0x026e8 op=0x52 1e 01 34 00 LD32S: s1 = *(int32_t *)(s30 +0x34) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x34);

L_01a0:
    /* +0x02700 op=0x58 1e 15 20 00 LD64: s21 = *(uint64_t *)(s30 +0x20) */
    S[21] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_01a1:
    /* +0x02718 op=0x85 00 0b 40 00 ADD64_IMM16: s11 = s0 +0x40 */
    S[11] = S[0] + 0x40;

L_01a2:
    /* +0x02730 op=0x53 01 05 00 0b LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0xb00 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xb00;

L_01a3:
    /* +0x02748 op=0xb5 00 06 00 00 ADD32_IMM16: s6 = int32(s0 +0x0) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x0);

L_01a4:
    /* +0x02760 op=0xb5 01 01 ff ff ADD32_IMM16: s1 = int32(s1 -0x1) */
    S[1] = (int32_t)((uint32_t)S[1] + (-0x1));

L_01a5:
    /* +0x02778 op=0xb2 01 02 07 00 AND64_IMM16: s2 = s1 & 0x7 */
    S[2] = S[1] & 0x7;

L_01a6:
    /* +0x02790 op=0xb5 00 01 f8 ff ADD32_IMM16: s1 = int32(s0 -0x8) */
    S[1] = (int32_t)((uint32_t)S[0] + (-0x8));

L_01a7:
    /* +0x027a8 op=0x34 02 01 03 01 OR64: s3 = s2 | s1 */
    S[3] = S[2] | S[1];

L_01a8:
    /* +0x027c0 op=0xb5 00 01 08 00 ADD32_IMM16: s1 = int32(s0 +0x8) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x8);

L_01a9:
    /* +0x027d8 op=0x09 01 02 04 00 SUB32: s4 = sign_extend_32((uint32_t)s1 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[1] - (uint32_t)S[2]);

L_01aa:
    /* +0x027f0 op=0xae 14 0b 1a 00 BR_EQ64: if (s20 == s11) goto record +453 */
    if (S[20] == S[11]) goto L_01c5;

L_01ab:
    /* +0x02808 op=0x84 05 14 01 04 ADD64: s1 = s5 + s20 */
    S[1] = S[5] + S[20];

L_01ac:
    /* +0x02820 op=0x34 03 00 09 01 OR64: s9 = s3 | s0 */
    S[9] = S[3] | S[0];

L_01ad:
    /* +0x02838 op=0x34 06 00 08 01 OR64: s8 = s6 | s0 */
    S[8] = S[6] | S[0];

L_01ae:
    /* +0x02850 op=0x59 01 07 00 00 LD8U: s7 = *(uint8_t *)(s1 +0x0) */
    S[7] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_01af:
    /* +0x02868 op=0xae 09 00 04 00 BR_EQ64: if (s9 == s0) goto record +436 */
    if (S[9] == S[0]) goto L_01b4;

L_01b0:
    /* +0x02880 op=0x18 00 08 01 01 SHL32_IMM: s1 = (int32_t)(s8 << 1) */
    S[1] = (int32_t)((uint32_t)S[8] << 1);

L_01b1:
    /* +0x02898 op=0xb5 09 09 01 00 ADD32_IMM16: s9 = int32(s9 +0x1) */
    S[9] = (int32_t)((uint32_t)S[9] + 0x1);

L_01b2:
    /* +0x028b0 op=0x33 01 08 01 00 OR_IMM16: s8 = s1 | 0x1 */
    S[8] = S[1] | 0x1;

L_01b3:
    /* +0x028c8 op=0xa7 09 00 fc ff BR_NE64: if (s9 != s0) goto record +432 */
    if (S[9] != S[0]) goto L_01b0;

L_01b4:
    /* +0x028e0 op=0x34 03 00 0a 00 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_01b5:
    /* +0x028f8 op=0x34 06 00 09 00 OR64: s9 = s6 | s0 */
    S[9] = S[6] | S[0];

L_01b6:
    /* +0x02910 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +443 */
    if (S[10] == S[0]) goto L_01bb;

L_01b7:
    /* +0x02928 op=0x18 10 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_01b8:
    /* +0x02940 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_01b9:
    /* +0x02958 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_01ba:
    /* +0x02970 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +439 */
    if (S[10] != S[0]) goto L_01b7;

L_01bb:
    /* +0x02988 op=0x0d 02 07 01 01 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s7 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[7] >> (S[1] & 31));

L_01bc:
    /* +0x029a0 op=0x17 04 07 07 07 SHL32_VAR: s7 = (int32_t)((uint32_t)s7 << ((uint32_t)s4 & 31)) */
    S[7] = (int32_t)((uint32_t)S[7] << ((uint32_t)S[4] & 31));

L_01bd:
    /* +0x029b8 op=0xb3 01 08 01 01 AND64: s1 = s1 & s8 */
    S[1] = S[1] & S[8];

L_01be:
    /* +0x029d0 op=0x36 09 00 08 01 NOR64: s8 = ~(s9 | s0) */
    S[8] = ~(S[9] | S[0]);

L_01bf:
    /* +0x029e8 op=0xb3 07 08 07 01 AND64: s7 = s7 & s8 */
    S[7] = S[7] & S[8];

L_01c0:
    /* +0x02a00 op=0x34 07 01 01 01 OR64: s1 = s7 | s1 */
    S[1] = S[7] | S[1];

L_01c1:
    /* +0x02a18 op=0x84 13 14 07 14 ADD64: s7 = s19 + s20 */
    S[7] = S[19] + S[20];

L_01c2:
    /* +0x02a30 op=0x85 14 14 01 00 ADD64_IMM16: s20 = s20 +0x1 */
    S[20] = S[20] + 0x1;

L_01c3:
    /* +0x02a48 op=0x26 07 01 00 00 ST8: *(s7 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[7] + 0x0) = (uint8_t)S[1];

L_01c4:
    /* +0x02a60 op=0xa7 14 0b e6 ff BR_NE64: if (s20 != s11) goto record +427 */
    if (S[20] != S[11]) goto L_01ab;

L_01c5:
    /* +0x02a78 op=0x14 12 01 40 00 CMP_LO_IMM64: s1 = ((uint64_t)s18 < (uint64_t)64) ? 1 : 0 */
    S[1] = ((uint64_t)S[18] < (uint64_t)0x40) ? 1 : 0;

L_01c6:
    /* +0x02a90 op=0xa7 01 00 0d 00 BR_NE64: if (s1 != s0) goto record +468 */
    if (S[1] != S[0]) goto L_01d4;

L_01c7:
    /* +0x02aa8 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_01c8:
    /* +0x02ac0 op=0x58 1d 10 10 04 LD64: s16 = *(uint64_t *)(s29 +0x410) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x410);

L_01c9:
    /* +0x02ad8 op=0x58 1d 11 18 04 LD64: s17 = *(uint64_t *)(s29 +0x418) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x418);

L_01ca:
    /* +0x02af0 op=0x58 1d 12 20 04 LD64: s18 = *(uint64_t *)(s29 +0x420) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x420);

L_01cb:
    /* +0x02b08 op=0x58 1d 13 28 04 LD64: s19 = *(uint64_t *)(s29 +0x428) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x428);

L_01cc:
    /* +0x02b20 op=0x58 1d 14 30 04 LD64: s20 = *(uint64_t *)(s29 +0x430) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x430);

L_01cd:
    /* +0x02b38 op=0x58 1d 15 38 04 LD64: s21 = *(uint64_t *)(s29 +0x438) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x438);

L_01ce:
    /* +0x02b50 op=0x58 1d 16 40 04 LD64: s22 = *(uint64_t *)(s29 +0x440) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x440);

L_01cf:
    /* +0x02b68 op=0x58 1d 17 48 04 LD64: s23 = *(uint64_t *)(s29 +0x448) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x448);

L_01d0:
    /* +0x02b80 op=0x58 1d 1e 50 04 LD64: s30 = *(uint64_t *)(s29 +0x450) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x450);

L_01d1:
    /* +0x02b98 op=0x58 1d 1f 58 04 LD64: s31 = *(uint64_t *)(s29 +0x458) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x458);

L_01d2:
    /* +0x02bb0 op=0x85 1d 1d 60 04 ADD64_IMM16: s29 = s29 +0x460 */
    S[29] = S[29] + 0x460;

L_01d3:
    /* +0x02bc8 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

L_01d4:
    /* +0x02be0 op=0x59 1e 02 70 00 LD8U: s2 = *(uint8_t *)(s30 +0x70) */
    S[2] = *(uint8_t *)((uint8_t *)S[30] + 0x70);

L_01d5:
    /* +0x02bf8 op=0x84 11 12 01 04 ADD64: s1 = s17 + s18 */
    S[1] = S[17] + S[18];

L_01d6:
    /* +0x02c10 op=0x6e 02 12 17 03 SHL64_IMM: s23 = s18 << 3 */
    S[23] = S[18] << 3;

L_01d7:
    /* +0x02c28 op=0x85 1e 16 50 00 ADD64_IMM16: s22 = s30 +0x50 */
    S[22] = S[30] + 0x50;

L_01d8:
    /* +0x02c40 op=0x26 01 02 00 00 ST8: *(s1 +0x0) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[2];

L_01d9:
    /* +0x02c58 op=0x14 12 01 38 00 CMP_LO_IMM64: s1 = ((uint64_t)s18 < (uint64_t)56) ? 1 : 0 */
    S[1] = ((uint64_t)S[18] < (uint64_t)0x38) ? 1 : 0;

L_01da:
    /* +0x02c70 op=0xa7 01 00 48 00 BR_NE64: if (s1 != s0) goto record +547 */
    if (S[1] != S[0]) goto L_0223;

L_01db:
    /* +0x02c88 op=0x33 11 02 01 00 OR_IMM16: s2 = s17 | 0x1 */
    S[2] = S[17] | 0x1;

L_01dc:
    /* +0x02ca0 op=0x33 13 03 01 00 OR_IMM16: s3 = s19 | 0x1 */
    S[3] = S[19] | 0x1;

L_01dd:
    /* +0x02cb8 op=0x85 00 04 3f 00 ADD64_IMM16: s4 = s0 +0x3f */
    S[4] = S[0] + 0x3f;

L_01de:
    /* +0x02cd0 op=0xae 12 04 06 00 BR_EQ64: if (s18 == s4) goto record +485 */
    if (S[18] == S[4]) goto L_01e5;

L_01df:
    /* +0x02ce8 op=0x59 03 05 00 00 LD8U: s5 = *(uint8_t *)(s3 +0x0) */
    S[5] = *(uint8_t *)((uint8_t *)S[3] + 0x0);

L_01e0:
    /* +0x02d00 op=0x84 02 12 01 00 ADD64: s1 = s2 + s18 */
    S[1] = S[2] + S[18];

L_01e1:
    /* +0x02d18 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_01e2:
    /* +0x02d30 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_01e3:
    /* +0x02d48 op=0x26 01 05 00 00 ST8: *(s1 +0x0) = (uint8_t)s5 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[5];

L_01e4:
    /* +0x02d60 op=0xa7 12 04 fa ff BR_NE64: if (s18 != s4) goto record +479 */
    if (S[18] != S[4]) goto L_01df;

L_01e5:
    /* +0x02d78 op=0x85 00 15 00 00 ADD64_IMM16: s21 = s0 +0x0 */
    S[21] = S[0] + 0x0;

L_01e6:
    /* +0x02d90 op=0x85 1e 14 b0 00 ADD64_IMM16: s20 = s30 +0xb0 */
    S[20] = S[30] + 0xb0;

L_01e7:
    /* +0x02da8 op=0x85 00 06 00 02 ADD64_IMM16: s6 = s0 +0x200 */
    S[6] = S[0] + 0x200;

L_01e8:
    /* +0x02dc0 op=0x25 1e 00 68 00 ST64: *(s30 +0x68) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x68) = S[0];

L_01e9:
    /* +0x02dd8 op=0x25 1e 00 60 00 ST64: *(s30 +0x60) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x60) = S[0];

L_01ea:
    /* +0x02df0 op=0x25 1e 00 58 00 ST64: *(s30 +0x58) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x58) = S[0];

L_01eb:
    /* +0x02e08 op=0x25 1e 00 50 00 ST64: *(s30 +0x50) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x50) = S[0];

L_01ec:
    /* +0x02e20 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_01ed:
    /* +0x02e38 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_01ee:
    /* +0x02e50 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_01ef:
    /* +0x02e68 op=0x58 1e 12 38 00 LD64: s18 = *(uint64_t *)(s30 +0x38) */
    S[18] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_01f0:
    /* +0x02e80 op=0x85 00 05 40 00 ADD64_IMM16: s5 = s0 +0x40 */
    S[5] = S[0] + 0x40;

L_01f1:
    /* +0x02e98 op=0x85 00 0e 20 00 ADD64_IMM16: s14 = s0 +0x20 */
    S[14] = S[0] + 0x20;

L_01f2:
    /* +0x02eb0 op=0xae 15 0e 06 00 BR_EQ64: if (s21 == s14) goto record +505 */
    if (S[21] == S[14]) goto L_01f9;

L_01f3:
    /* +0x02ec8 op=0x84 10 15 02 04 ADD64: s2 = s16 + s21 */
    S[2] = S[16] + S[21];

L_01f4:
    /* +0x02ee0 op=0x84 16 15 01 14 ADD64: s1 = s22 + s21 */
    S[1] = S[22] + S[21];

L_01f5:
    /* +0x02ef8 op=0x85 15 15 04 00 ADD64_IMM16: s21 = s21 +0x4 */
    S[21] = S[21] + 0x4;

L_01f6:
    /* +0x02f10 op=0x52 02 02 00 00 LD32S: s2 = *(int32_t *)(s2 +0x0) */
    S[2] = *(int32_t *)((uint8_t *)S[2] + 0x0);

L_01f7:
    /* +0x02f28 op=0x08 01 02 00 00 ST32: *(s1 +0x0) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[2];

L_01f8:
    /* +0x02f40 op=0xa7 15 0e fa ff BR_NE64: if (s21 != s14) goto record +499 */
    if (S[21] != S[14]) goto L_01f3;

L_01f9:
    /* +0x02f58 op=0x58 1e 15 20 00 LD64: s21 = *(uint64_t *)(s30 +0x20) */
    S[21] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_01fa:
    /* +0x02f70 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_01fb:
    /* +0x02f88 op=0xae 02 05 0f 00 BR_EQ64: if (s2 == s5) goto record +523 */
    if (S[2] == S[5]) goto L_020b;

L_01fc:
    /* +0x02fa0 op=0x84 11 02 01 14 ADD64: s1 = s17 + s2 */
    S[1] = S[17] + S[2];

L_01fd:
    /* +0x02fb8 op=0x59 01 03 00 00 LD8U: s3 = *(uint8_t *)(s1 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_01fe:
    /* +0x02fd0 op=0x59 01 04 01 00 LD8U: s4 = *(uint8_t *)(s1 +0x1) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x1);

L_01ff:
    /* +0x02fe8 op=0x18 00 03 03 18 SHL32_IMM: s3 = (int32_t)(s3 << 24) */
    S[3] = (int32_t)((uint32_t)S[3] << 24);

L_0200:
    /* +0x03000 op=0x18 10 04 04 10 SHL32_IMM: s4 = (int32_t)(s4 << 16) */
    S[4] = (int32_t)((uint32_t)S[4] << 16);

L_0201:
    /* +0x03018 op=0x34 04 03 03 01 OR64: s3 = s4 | s3 */
    S[3] = S[4] | S[3];

L_0202:
    /* +0x03030 op=0x59 01 04 02 00 LD8U: s4 = *(uint8_t *)(s1 +0x2) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x2);

L_0203:
    /* +0x03048 op=0x59 01 01 03 00 LD8U: s1 = *(uint8_t *)(s1 +0x3) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x3);

L_0204:
    /* +0x03060 op=0x18 11 04 04 08 SHL32_IMM: s4 = (int32_t)(s4 << 8) */
    S[4] = (int32_t)((uint32_t)S[4] << 8);

L_0205:
    /* +0x03078 op=0x34 03 04 03 01 OR64: s3 = s3 | s4 */
    S[3] = S[3] | S[4];

L_0206:
    /* +0x03090 op=0x34 03 01 01 01 OR64: s1 = s3 | s1 */
    S[1] = S[3] | S[1];

L_0207:
    /* +0x030a8 op=0x84 14 02 03 00 ADD64: s3 = s20 + s2 */
    S[3] = S[20] + S[2];

L_0208:
    /* +0x030c0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0209:
    /* +0x030d8 op=0x08 03 01 00 00 ST32: *(s3 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[3] + 0x0) = (uint32_t)S[1];

L_020a:
    /* +0x030f0 op=0xa7 02 05 f1 ff BR_NE64: if (s2 != s5) goto record +508 */
    if (S[2] != S[5]) goto L_01fc;

L_020b:
    /* +0x03108 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_020c:
    /* +0x03120 op=0x85 00 01 c0 01 ADD64_IMM16: s1 = s0 +0x1c0 */
    S[1] = S[0] + 0x1c0;

L_020d:
    /* +0x03138 op=0xae 02 01 18 00 BR_EQ64: if (s2 == s1) goto record +550 */
    if (S[2] == S[1]) goto L_0226;

L_020e:
    /* +0x03150 op=0x84 14 02 01 14 ADD64: s1 = s20 + s2 */
    S[1] = S[20] + S[2];

L_020f:
    /* +0x03168 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0210:
    /* +0x03180 op=0x52 01 03 04 00 LD32S: s3 = *(int32_t *)(s1 +0x4) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x4);

L_0211:
    /* +0x03198 op=0x2e 10 03 04 12 ROR32_IMM: s4 = ror32((uint32_t)s3, 18) */
    S[4] = ror32((uint32_t)S[3], 18);

L_0212:
    /* +0x031b0 op=0x2e 12 03 05 07 ROR32_IMM: s5 = ror32((uint32_t)s3, 7) */
    S[5] = ror32((uint32_t)S[3], 7);

L_0213:
    /* +0x031c8 op=0x0e 0d 03 03 03 LSR32_IMM: s3 = sign_extend_32((uint32_t)s3 >> 3) */
    S[3] = (int32_t)((uint32_t)S[3] >> 3);

L_0214:
    /* +0x031e0 op=0x02 05 04 04 01 XOR64: s4 = s4 ^ s5 */
    S[4] = S[4] ^ S[5];

L_0215:
    /* +0x031f8 op=0x52 01 05 38 00 LD32S: s5 = *(int32_t *)(s1 +0x38) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x38);

L_0216:
    /* +0x03210 op=0x02 04 03 03 01 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_0217:
    /* +0x03228 op=0x2e 10 05 06 13 ROR32_IMM: s6 = ror32((uint32_t)s5, 19) */
    S[6] = ror32((uint32_t)S[5], 19);

L_0218:
    /* +0x03240 op=0x2e 12 05 07 11 ROR32_IMM: s7 = ror32((uint32_t)s5, 17) */
    S[7] = ror32((uint32_t)S[5], 17);

L_0219:
    /* +0x03258 op=0x0e 0d 05 05 0a LSR32_IMM: s5 = sign_extend_32((uint32_t)s5 >> 10) */
    S[5] = (int32_t)((uint32_t)S[5] >> 10);

L_021a:
    /* +0x03270 op=0x02 07 06 04 00 XOR64: s4 = s6 ^ s7 */
    S[4] = S[6] ^ S[7];

L_021b:
    /* +0x03288 op=0x02 04 05 04 01 XOR64: s4 = s5 ^ s4 */
    S[4] = S[5] ^ S[4];

L_021c:
    /* +0x032a0 op=0x52 01 05 24 00 LD32S: s5 = *(int32_t *)(s1 +0x24) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x24);

L_021d:
    /* +0x032b8 op=0xb4 04 05 04 02 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_021e:
    /* +0x032d0 op=0x52 01 05 00 00 LD32S: s5 = *(int32_t *)(s1 +0x0) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_021f:
    /* +0x032e8 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_0220:
    /* +0x03300 op=0xb4 04 03 03 12 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_0221:
    /* +0x03318 op=0x08 01 03 40 00 ST32: *(s1 +0x40) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x40) = (uint32_t)S[3];

L_0222:
    /* +0x03330 op=0x5f e9 ff ff ff ADD_PC_IMM32: goto record +524 ; vm_pc = current_pc + 1 + -23 */
    goto L_020c;

L_0223:
    /* +0x03348 op=0x85 12 03 01 00 ADD64_IMM16: s3 = s18 +0x1 */
    S[3] = S[18] + 0x1;

L_0224:
    /* +0x03360 op=0x58 1e 12 38 00 LD64: s18 = *(uint64_t *)(s30 +0x38) */
    S[18] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_0225:
    /* +0x03378 op=0x5f 49 00 00 00 ADD_PC_IMM32: goto record +623 ; vm_pc = current_pc + 1 + 73 */
    goto L_026f;

L_0226:
    /* +0x03390 op=0x58 1e 01 28 00 LD64: s1 = *(uint64_t *)(s30 +0x28) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x28);

L_0227:
    /* +0x033a8 op=0x52 1e 02 60 00 LD32S: s2 = *(int32_t *)(s30 +0x60) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x60);

L_0228:
    /* +0x033c0 op=0x52 1e 0c 68 00 LD32S: s12 = *(int32_t *)(s30 +0x68) */
    S[12] = *(int32_t *)((uint8_t *)S[30] + 0x68);

L_0229:
    /* +0x033d8 op=0x52 1e 03 5c 00 LD32S: s3 = *(int32_t *)(s30 +0x5c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x5c);

L_022a:
    /* +0x033f0 op=0x52 1e 04 64 00 LD32S: s4 = *(int32_t *)(s30 +0x64) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x64);

L_022b:
    /* +0x03408 op=0x52 1e 05 58 00 LD32S: s5 = *(int32_t *)(s30 +0x58) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x58);

L_022c:
    /* +0x03420 op=0x52 1e 07 6c 00 LD32S: s7 = *(int32_t *)(s30 +0x6c) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x6c);

L_022d:
    /* +0x03438 op=0x52 1e 09 50 00 LD32S: s9 = *(int32_t *)(s30 +0x50) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x50);

L_022e:
    /* +0x03450 op=0x52 1e 0b 54 00 LD32S: s11 = *(int32_t *)(s30 +0x54) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x54);

L_022f:
    /* +0x03468 op=0x85 14 06 34 00 ADD64_IMM16: s6 = s20 +0x34 */
    S[6] = S[20] + 0x34;

L_0230:
    /* +0x03480 op=0x85 01 08 0d 9f ADD64_IMM16: s8 = s1 -0x60f3 */
    S[8] = S[1] + (-0x60f3);

L_0231:
    /* +0x03498 op=0x58 1e 01 48 00 LD64: s1 = *(uint64_t *)(s30 +0x48) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_0232:
    /* +0x034b0 op=0x34 09 00 0a 01 OR64: s10 = s9 | s0 */
    S[10] = S[9] | S[0];

L_0233:
    /* +0x034c8 op=0x34 07 00 09 01 OR64: s9 = s7 | s0 */
    S[9] = S[7] | S[0];

L_0234:
    /* +0x034e0 op=0x34 0c 00 07 00 OR64: s7 = s12 | s0 */
    S[7] = S[12] | S[0];

L_0235:
    /* +0x034f8 op=0xae 08 01 26 00 BR_EQ64: if (s8 == s1) goto record +604 */
    if (S[8] == S[1]) goto L_025c;

L_0236:
    /* +0x03510 op=0x2e 12 0a 01 0b ROR32_IMM: s1 = ror32((uint32_t)s10, 11) */
    S[1] = ror32((uint32_t)S[10], 11);

L_0237:
    /* +0x03528 op=0x2e 12 0a 0c 06 ROR32_IMM: s12 = ror32((uint32_t)s10, 6) */
    S[12] = ror32((uint32_t)S[10], 6);

L_0238:
    /* +0x03540 op=0x34 03 04 0d 01 OR64: s13 = s3 | s4 */
    S[13] = S[3] | S[4];

L_0239:
    /* +0x03558 op=0x02 0c 01 01 01 XOR64: s1 = s1 ^ s12 */
    S[1] = S[1] ^ S[12];

L_023a:
    /* +0x03570 op=0x2e 10 0a 0c 19 ROR32_IMM: s12 = ror32((uint32_t)s10, 25) */
    S[12] = ror32((uint32_t)S[10], 25);

L_023b:
    /* +0x03588 op=0xb3 0d 07 0d 00 AND64: s13 = s13 & s7 */
    S[13] = S[13] & S[7];

L_023c:
    /* +0x035a0 op=0x02 01 0c 01 01 XOR64: s1 = s12 ^ s1 */
    S[1] = S[12] ^ S[1];

L_023d:
    /* +0x035b8 op=0x52 06 0c 00 00 LD32S: s12 = *(int32_t *)(s6 +0x0) */
    S[12] = *(int32_t *)((uint8_t *)S[6] + 0x0);

L_023e:
    /* +0x035d0 op=0x85 06 06 04 00 ADD64_IMM16: s6 = s6 +0x4 */
    S[6] = S[6] + 0x4;

L_023f:
    /* +0x035e8 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0240:
    /* +0x03600 op=0xb2 08 0b 3f 00 AND64_IMM16: s11 = s8 & 0x3f */
    S[11] = S[8] & 0x3f;

L_0241:
    /* +0x03618 op=0x85 08 08 01 00 ADD64_IMM16: s8 = s8 +0x1 */
    S[8] = S[8] + 0x1;

L_0242:
    /* +0x03630 op=0x6e 02 0b 0b 02 SHL64_IMM: s11 = s11 << 2 */
    S[11] = S[11] << 2;

L_0243:
    /* +0x03648 op=0x84 12 0b 0b 14 ADD64: s11 = s18 + s11 */
    S[11] = S[18] + S[11];

L_0244:
    /* +0x03660 op=0x52 0b 0b 00 00 LD32S: s11 = *(int32_t *)(s11 +0x0) */
    S[11] = *(int32_t *)((uint8_t *)S[11] + 0x0);

L_0245:
    /* +0x03678 op=0xb4 01 0b 01 02 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0246:
    /* +0x03690 op=0x02 05 09 0b 01 XOR64: s11 = s9 ^ s5 */
    S[11] = S[9] ^ S[5];

L_0247:
    /* +0x036a8 op=0xb3 0b 0a 0b 01 AND64: s11 = s11 & s10 */
    S[11] = S[11] & S[10];

L_0248:
    /* +0x036c0 op=0xb4 01 0c 01 02 ADD32: s1 = int32(s1 + s12) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[12]);

L_0249:
    /* +0x036d8 op=0xb3 03 04 0c 01 AND64: s12 = s3 & s4 */
    S[12] = S[3] & S[4];

L_024a:
    /* +0x036f0 op=0x02 0b 09 0b 00 XOR64: s11 = s9 ^ s11 */
    S[11] = S[9] ^ S[11];

L_024b:
    /* +0x03708 op=0x34 0d 0c 0c 01 OR64: s12 = s13 | s12 */
    S[12] = S[13] | S[12];

L_024c:
    /* +0x03720 op=0x2e 01 04 0d 02 ROR32_IMM: s13 = ror32((uint32_t)s4, 2) */
    S[13] = ror32((uint32_t)S[4], 2);

L_024d:
    /* +0x03738 op=0xb4 01 0b 01 00 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_024e:
    /* +0x03750 op=0x2e 12 04 0b 0d ROR32_IMM: s11 = ror32((uint32_t)s4, 13) */
    S[11] = ror32((uint32_t)S[4], 13);

L_024f:
    /* +0x03768 op=0x02 0d 0b 0b 01 XOR64: s11 = s11 ^ s13 */
    S[11] = S[11] ^ S[13];

L_0250:
    /* +0x03780 op=0x2e 01 04 0d 16 ROR32_IMM: s13 = ror32((uint32_t)s4, 22) */
    S[13] = ror32((uint32_t)S[4], 22);

L_0251:
    /* +0x03798 op=0x02 0b 0d 0b 00 XOR64: s11 = s13 ^ s11 */
    S[11] = S[13] ^ S[11];

L_0252:
    /* +0x037b0 op=0xb4 01 0b 0b 12 ADD32: s11 = int32(s1 + s11) */
    S[11] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_0253:
    /* +0x037c8 op=0xb4 02 01 01 02 ADD32: s1 = int32(s2 + s1) */
    S[1] = (int32_t)((uint32_t)S[2] + (uint32_t)S[1]);

L_0254:
    /* +0x037e0 op=0x34 03 00 02 01 OR64: s2 = s3 | s0 */
    S[2] = S[3] | S[0];

L_0255:
    /* +0x037f8 op=0x34 05 00 03 01 OR64: s3 = s5 | s0 */
    S[3] = S[5] | S[0];

L_0256:
    /* +0x03810 op=0xb4 0b 0c 0b 00 ADD32: s11 = int32(s11 + s12) */
    S[11] = (int32_t)((uint32_t)S[11] + (uint32_t)S[12]);

L_0257:
    /* +0x03828 op=0x34 04 00 0c 00 OR64: s12 = s4 | s0 */
    S[12] = S[4] | S[0];

L_0258:
    /* +0x03840 op=0x34 01 00 04 01 OR64: s4 = s1 | s0 */
    S[4] = S[1] | S[0];

L_0259:
    /* +0x03858 op=0x34 0b 00 05 01 OR64: s5 = s11 | s0 */
    S[5] = S[11] | S[0];

L_025a:
    /* +0x03870 op=0x34 0a 00 0b 00 OR64: s11 = s10 | s0 */
    S[11] = S[10] | S[0];

L_025b:
    /* +0x03888 op=0x5f d5 ff ff ff ADD_PC_IMM32: goto record +561 ; vm_pc = current_pc + 1 + -43 */
    goto L_0231;

L_025c:
    /* +0x038a0 op=0x08 1e 09 6c 00 ST32: *(s30 +0x6c) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x6c) = (uint32_t)S[9];

L_025d:
    /* +0x038b8 op=0x08 1e 0a 50 00 ST32: *(s30 +0x50) = (uint32_t)s10 */
    *(uint32_t *)((uint8_t *)S[30] + 0x50) = (uint32_t)S[10];

L_025e:
    /* +0x038d0 op=0x08 1e 0b 54 00 ST32: *(s30 +0x54) = (uint32_t)s11 */
    *(uint32_t *)((uint8_t *)S[30] + 0x54) = (uint32_t)S[11];

L_025f:
    /* +0x038e8 op=0x08 1e 04 64 00 ST32: *(s30 +0x64) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x64) = (uint32_t)S[4];

L_0260:
    /* +0x03900 op=0x08 1e 05 58 00 ST32: *(s30 +0x58) = (uint32_t)s5 */
    *(uint32_t *)((uint8_t *)S[30] + 0x58) = (uint32_t)S[5];

L_0261:
    /* +0x03918 op=0x08 1e 07 68 00 ST32: *(s30 +0x68) = (uint32_t)s7 */
    *(uint32_t *)((uint8_t *)S[30] + 0x68) = (uint32_t)S[7];

L_0262:
    /* +0x03930 op=0x08 1e 03 5c 00 ST32: *(s30 +0x5c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x5c) = (uint32_t)S[3];

L_0263:
    /* +0x03948 op=0x08 1e 02 60 00 ST32: *(s30 +0x60) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x60) = (uint32_t)S[2];

L_0264:
    /* +0x03960 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0265:
    /* +0x03978 op=0xae 02 0e 08 00 BR_EQ64: if (s2 == s14) goto record +622 */
    if (S[2] == S[14]) goto L_026e;

L_0266:
    /* +0x03990 op=0x84 16 02 04 00 ADD64: s4 = s22 + s2 */
    S[4] = S[22] + S[2];

L_0267:
    /* +0x039a8 op=0x84 10 02 01 14 ADD64: s1 = s16 + s2 */
    S[1] = S[16] + S[2];

L_0268:
    /* +0x039c0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0269:
    /* +0x039d8 op=0x52 01 03 00 00 LD32S: s3 = *(int32_t *)(s1 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_026a:
    /* +0x039f0 op=0x52 04 04 00 00 LD32S: s4 = *(int32_t *)(s4 +0x0) */
    S[4] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_026b:
    /* +0x03a08 op=0xb4 04 03 03 02 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_026c:
    /* +0x03a20 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_026d:
    /* +0x03a38 op=0xa7 02 0e f8 ff BR_NE64: if (s2 != s14) goto record +614 */
    if (S[2] != S[14]) goto L_0266;

L_026e:
    /* +0x03a50 op=0x85 00 03 00 00 ADD64_IMM16: s3 = s0 +0x0 */
    S[3] = S[0] + 0x0;

L_026f:
    /* +0x03a68 op=0x58 1e 01 40 00 LD64: s1 = *(uint64_t *)(s30 +0x40) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_0270:
    /* +0x03a80 op=0x33 13 04 01 00 OR_IMM16: s4 = s19 | 0x1 */
    S[4] = S[19] | 0x1;

L_0271:
    /* +0x03a98 op=0x84 01 17 02 04 ADD64: s2 = s1 + s23 */
    S[2] = S[1] + S[23];

L_0272:
    /* +0x03ab0 op=0x14 03 01 38 00 CMP_LO_IMM64: s1 = ((uint64_t)s3 < (uint64_t)56) ? 1 : 0 */
    S[1] = ((uint64_t)S[3] < (uint64_t)0x38) ? 1 : 0;

L_0273:
    /* +0x03ac8 op=0xae 01 00 06 00 BR_EQ64: if (s1 == s0) goto record +634 */
    if (S[1] == S[0]) goto L_027a;

L_0274:
    /* +0x03ae0 op=0x59 04 05 00 00 LD8U: s5 = *(uint8_t *)(s4 +0x0) */
    S[5] = *(uint8_t *)((uint8_t *)S[4] + 0x0);

L_0275:
    /* +0x03af8 op=0x84 11 03 01 00 ADD64: s1 = s17 + s3 */
    S[1] = S[17] + S[3];

L_0276:
    /* +0x03b10 op=0x85 04 04 01 00 ADD64_IMM16: s4 = s4 +0x1 */
    S[4] = S[4] + 0x1;

L_0277:
    /* +0x03b28 op=0x85 03 03 01 00 ADD64_IMM16: s3 = s3 +0x1 */
    S[3] = S[3] + 0x1;

L_0278:
    /* +0x03b40 op=0x26 01 05 00 00 ST8: *(s1 +0x0) = (uint8_t)s5 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[5];

L_0279:
    /* +0x03b58 op=0x5f f8 ff ff ff ADD_PC_IMM32: goto record +626 ; vm_pc = current_pc + 1 + -8 */
    goto L_0272;

L_027a:
    /* +0x03b70 op=0x67 00 02 01 18 LSR64_IMM32PLUS: s1 = (uint64_t)s2 >> (24 + 32) */
    S[1] = (uint64_t)S[2] >> (24 + 32);

L_027b:
    /* +0x03b88 op=0x26 1e 02 0f 04 ST8: *(s30 +0x40f) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40f) = (uint8_t)S[2];

L_027c:
    /* +0x03ba0 op=0x67 00 02 03 10 LSR64_IMM32PLUS: s3 = (uint64_t)s2 >> (16 + 32) */
    S[3] = (uint64_t)S[2] >> (16 + 32);

L_027d:
    /* +0x03bb8 op=0x67 00 02 04 08 LSR64_IMM32PLUS: s4 = (uint64_t)s2 >> (8 + 32) */
    S[4] = (uint64_t)S[2] >> (8 + 32);

L_027e:
    /* +0x03bd0 op=0x67 00 02 05 00 LSR64_IMM32PLUS: s5 = (uint64_t)s2 >> (0 + 32) */
    S[5] = (uint64_t)S[2] >> (0 + 32);

L_027f:
    /* +0x03be8 op=0x85 00 14 00 00 ADD64_IMM16: s20 = s0 +0x0 */
    S[20] = S[0] + 0x0;

L_0280:
    /* +0x03c00 op=0x85 1e 13 b0 00 ADD64_IMM16: s19 = s30 +0xb0 */
    S[19] = S[30] + 0xb0;

L_0281:
    /* +0x03c18 op=0x85 00 06 00 02 ADD64_IMM16: s6 = s0 +0x200 */
    S[6] = S[0] + 0x200;

L_0282:
    /* +0x03c30 op=0x25 1e 00 68 00 ST64: *(s30 +0x68) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x68) = S[0];

L_0283:
    /* +0x03c48 op=0x25 1e 00 60 00 ST64: *(s30 +0x60) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x60) = S[0];

L_0284:
    /* +0x03c60 op=0x25 1e 00 58 00 ST64: *(s30 +0x58) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x58) = S[0];

L_0285:
    /* +0x03c78 op=0x25 1e 00 50 00 ST64: *(s30 +0x50) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x50) = S[0];

L_0286:
    /* +0x03c90 op=0x26 1e 01 08 04 ST8: *(s30 +0x408) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x408) = (uint8_t)S[1];

L_0287:
    /* +0x03ca8 op=0x68 00 02 01 08 LSR64_IMM: s1 = (uint64_t)s2 >> 8 */
    S[1] = (uint64_t)S[2] >> 8;

L_0288:
    /* +0x03cc0 op=0x26 1e 05 0b 04 ST8: *(s30 +0x40b) = (uint8_t)s5 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40b) = (uint8_t)S[5];

L_0289:
    /* +0x03cd8 op=0x26 1e 04 0a 04 ST8: *(s30 +0x40a) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40a) = (uint8_t)S[4];

L_028a:
    /* +0x03cf0 op=0x26 1e 03 09 04 ST8: *(s30 +0x409) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[30] + 0x409) = (uint8_t)S[3];

L_028b:
    /* +0x03d08 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_028c:
    /* +0x03d20 op=0x34 14 00 05 00 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_028d:
    /* +0x03d38 op=0x26 1e 01 0e 04 ST8: *(s30 +0x40e) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40e) = (uint8_t)S[1];

L_028e:
    /* +0x03d50 op=0x68 00 02 01 10 LSR64_IMM: s1 = (uint64_t)s2 >> 16 */
    S[1] = (uint64_t)S[2] >> 16;

L_028f:
    /* +0x03d68 op=0x26 1e 01 0d 04 ST8: *(s30 +0x40d) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40d) = (uint8_t)S[1];

L_0290:
    /* +0x03d80 op=0x68 03 02 01 18 LSR64_IMM: s1 = (uint64_t)s2 >> 24 */
    S[1] = (uint64_t)S[2] >> 24;

L_0291:
    /* +0x03d98 op=0x26 1e 01 0c 04 ST8: *(s30 +0x40c) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x40c) = (uint8_t)S[1];

L_0292:
    /* +0x03db0 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0293:
    /* +0x03dc8 op=0x85 00 05 40 00 ADD64_IMM16: s5 = s0 +0x40 */
    S[5] = S[0] + 0x40;

L_0294:
    /* +0x03de0 op=0x85 00 0e 20 00 ADD64_IMM16: s14 = s0 +0x20 */
    S[14] = S[0] + 0x20;

L_0295:
    /* +0x03df8 op=0xae 14 0e 06 00 BR_EQ64: if (s20 == s14) goto record +668 */
    if (S[20] == S[14]) goto L_029c;

L_0296:
    /* +0x03e10 op=0x84 10 14 02 14 ADD64: s2 = s16 + s20 */
    S[2] = S[16] + S[20];

L_0297:
    /* +0x03e28 op=0x84 16 14 01 04 ADD64: s1 = s22 + s20 */
    S[1] = S[22] + S[20];

L_0298:
    /* +0x03e40 op=0x85 14 14 04 00 ADD64_IMM16: s20 = s20 +0x4 */
    S[20] = S[20] + 0x4;

L_0299:
    /* +0x03e58 op=0x52 02 02 00 00 LD32S: s2 = *(int32_t *)(s2 +0x0) */
    S[2] = *(int32_t *)((uint8_t *)S[2] + 0x0);

L_029a:
    /* +0x03e70 op=0x08 01 02 00 00 ST32: *(s1 +0x0) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[2];

L_029b:
    /* +0x03e88 op=0xa7 14 0e fa ff BR_NE64: if (s20 != s14) goto record +662 */
    if (S[20] != S[14]) goto L_0296;

L_029c:
    /* +0x03ea0 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_029d:
    /* +0x03eb8 op=0xae 02 05 0f 00 BR_EQ64: if (s2 == s5) goto record +685 */
    if (S[2] == S[5]) goto L_02ad;

L_029e:
    /* +0x03ed0 op=0x84 11 02 01 14 ADD64: s1 = s17 + s2 */
    S[1] = S[17] + S[2];

L_029f:
    /* +0x03ee8 op=0x59 01 03 00 00 LD8U: s3 = *(uint8_t *)(s1 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_02a0:
    /* +0x03f00 op=0x59 01 04 01 00 LD8U: s4 = *(uint8_t *)(s1 +0x1) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x1);

L_02a1:
    /* +0x03f18 op=0x18 10 03 03 18 SHL32_IMM: s3 = (int32_t)(s3 << 24) */
    S[3] = (int32_t)((uint32_t)S[3] << 24);

L_02a2:
    /* +0x03f30 op=0x18 11 04 04 10 SHL32_IMM: s4 = (int32_t)(s4 << 16) */
    S[4] = (int32_t)((uint32_t)S[4] << 16);

L_02a3:
    /* +0x03f48 op=0x34 04 03 03 00 OR64: s3 = s4 | s3 */
    S[3] = S[4] | S[3];

L_02a4:
    /* +0x03f60 op=0x59 01 04 02 00 LD8U: s4 = *(uint8_t *)(s1 +0x2) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x2);

L_02a5:
    /* +0x03f78 op=0x59 01 01 03 00 LD8U: s1 = *(uint8_t *)(s1 +0x3) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x3);

L_02a6:
    /* +0x03f90 op=0x18 00 04 04 08 SHL32_IMM: s4 = (int32_t)(s4 << 8) */
    S[4] = (int32_t)((uint32_t)S[4] << 8);

L_02a7:
    /* +0x03fa8 op=0x34 03 04 03 01 OR64: s3 = s3 | s4 */
    S[3] = S[3] | S[4];

L_02a8:
    /* +0x03fc0 op=0x34 03 01 01 00 OR64: s1 = s3 | s1 */
    S[1] = S[3] | S[1];

L_02a9:
    /* +0x03fd8 op=0x84 13 02 03 14 ADD64: s3 = s19 + s2 */
    S[3] = S[19] + S[2];

L_02aa:
    /* +0x03ff0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_02ab:
    /* +0x04008 op=0x08 03 01 00 00 ST32: *(s3 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[3] + 0x0) = (uint32_t)S[1];

L_02ac:
    /* +0x04020 op=0xa7 02 05 f1 ff BR_NE64: if (s2 != s5) goto record +670 */
    if (S[2] != S[5]) goto L_029e;

L_02ad:
    /* +0x04038 op=0x58 1e 0f 48 00 LD64: s15 = *(uint64_t *)(s30 +0x48) */
    S[15] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_02ae:
    /* +0x04050 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_02af:
    /* +0x04068 op=0x85 00 08 c0 01 ADD64_IMM16: s8 = s0 +0x1c0 */
    S[8] = S[0] + 0x1c0;

L_02b0:
    /* +0x04080 op=0xae 02 08 15 00 BR_EQ64: if (s2 == s8) goto record +710 */
    if (S[2] == S[8]) goto L_02c6;

L_02b1:
    /* +0x04098 op=0x84 13 02 01 04 ADD64: s1 = s19 + s2 */
    S[1] = S[19] + S[2];

L_02b2:
    /* +0x040b0 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_02b3:
    /* +0x040c8 op=0x52 01 03 04 00 LD32S: s3 = *(int32_t *)(s1 +0x4) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x4);

L_02b4:
    /* +0x040e0 op=0x2e 01 03 04 12 ROR32_IMM: s4 = ror32((uint32_t)s3, 18) */
    S[4] = ror32((uint32_t)S[3], 18);

L_02b5:
    /* +0x040f8 op=0x2e 01 03 05 07 ROR32_IMM: s5 = ror32((uint32_t)s3, 7) */
    S[5] = ror32((uint32_t)S[3], 7);

L_02b6:
    /* +0x04110 op=0x0e 0d 03 03 03 LSR32_IMM: s3 = sign_extend_32((uint32_t)s3 >> 3) */
    S[3] = (int32_t)((uint32_t)S[3] >> 3);

L_02b7:
    /* +0x04128 op=0x02 05 04 04 01 XOR64: s4 = s4 ^ s5 */
    S[4] = S[4] ^ S[5];

L_02b8:
    /* +0x04140 op=0x52 01 05 38 00 LD32S: s5 = *(int32_t *)(s1 +0x38) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x38);

L_02b9:
    /* +0x04158 op=0x02 04 03 03 01 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_02ba:
    /* +0x04170 op=0x2e 10 05 06 13 ROR32_IMM: s6 = ror32((uint32_t)s5, 19) */
    S[6] = ror32((uint32_t)S[5], 19);

L_02bb:
    /* +0x04188 op=0x2e 01 05 07 11 ROR32_IMM: s7 = ror32((uint32_t)s5, 17) */
    S[7] = ror32((uint32_t)S[5], 17);

L_02bc:
    /* +0x041a0 op=0x0e 00 05 05 0a LSR32_IMM: s5 = sign_extend_32((uint32_t)s5 >> 10) */
    S[5] = (int32_t)((uint32_t)S[5] >> 10);

L_02bd:
    /* +0x041b8 op=0x02 07 06 04 01 XOR64: s4 = s6 ^ s7 */
    S[4] = S[6] ^ S[7];

L_02be:
    /* +0x041d0 op=0x02 04 05 04 01 XOR64: s4 = s5 ^ s4 */
    S[4] = S[5] ^ S[4];

L_02bf:
    /* +0x041e8 op=0x52 01 05 24 00 LD32S: s5 = *(int32_t *)(s1 +0x24) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x24);

L_02c0:
    /* +0x04200 op=0xb4 04 05 04 02 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_02c1:
    /* +0x04218 op=0x52 01 05 00 00 LD32S: s5 = *(int32_t *)(s1 +0x0) */
    S[5] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_02c2:
    /* +0x04230 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_02c3:
    /* +0x04248 op=0xb4 04 03 03 12 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_02c4:
    /* +0x04260 op=0x08 01 03 40 00 ST32: *(s1 +0x40) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x40) = (uint32_t)S[3];

L_02c5:
    /* +0x04278 op=0xa7 02 08 eb ff BR_NE64: if (s2 != s8) goto record +689 */
    if (S[2] != S[8]) goto L_02b1;

L_02c6:
    /* +0x04290 op=0x58 1e 01 28 00 LD64: s1 = *(uint64_t *)(s30 +0x28) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x28);

L_02c7:
    /* +0x042a8 op=0x52 1e 02 60 00 LD32S: s2 = *(int32_t *)(s30 +0x60) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x60);

L_02c8:
    /* +0x042c0 op=0x52 1e 0c 68 00 LD32S: s12 = *(int32_t *)(s30 +0x68) */
    S[12] = *(int32_t *)((uint8_t *)S[30] + 0x68);

L_02c9:
    /* +0x042d8 op=0x52 1e 03 5c 00 LD32S: s3 = *(int32_t *)(s30 +0x5c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x5c);

L_02ca:
    /* +0x042f0 op=0x52 1e 04 64 00 LD32S: s4 = *(int32_t *)(s30 +0x64) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x64);

L_02cb:
    /* +0x04308 op=0x52 1e 05 58 00 LD32S: s5 = *(int32_t *)(s30 +0x58) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x58);

L_02cc:
    /* +0x04320 op=0x52 1e 07 6c 00 LD32S: s7 = *(int32_t *)(s30 +0x6c) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x6c);

L_02cd:
    /* +0x04338 op=0x52 1e 09 50 00 LD32S: s9 = *(int32_t *)(s30 +0x50) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x50);

L_02ce:
    /* +0x04350 op=0x52 1e 0b 54 00 LD32S: s11 = *(int32_t *)(s30 +0x54) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x54);

L_02cf:
    /* +0x04368 op=0x85 13 06 34 00 ADD64_IMM16: s6 = s19 +0x34 */
    S[6] = S[19] + 0x34;

L_02d0:
    /* +0x04380 op=0x85 01 08 0d 9f ADD64_IMM16: s8 = s1 -0x60f3 */
    S[8] = S[1] + (-0x60f3);

L_02d1:
    /* +0x04398 op=0x34 09 00 0a 01 OR64: s10 = s9 | s0 */
    S[10] = S[9] | S[0];

L_02d2:
    /* +0x043b0 op=0x34 07 00 09 00 OR64: s9 = s7 | s0 */
    S[9] = S[7] | S[0];

L_02d3:
    /* +0x043c8 op=0x34 0c 00 07 01 OR64: s7 = s12 | s0 */
    S[7] = S[12] | S[0];

L_02d4:
    /* +0x043e0 op=0xae 08 0f 26 00 BR_EQ64: if (s8 == s15) goto record +763 */
    if (S[8] == S[15]) goto L_02fb;

L_02d5:
    /* +0x043f8 op=0x2e 10 0a 01 0b ROR32_IMM: s1 = ror32((uint32_t)s10, 11) */
    S[1] = ror32((uint32_t)S[10], 11);

L_02d6:
    /* +0x04410 op=0x2e 12 0a 0c 06 ROR32_IMM: s12 = ror32((uint32_t)s10, 6) */
    S[12] = ror32((uint32_t)S[10], 6);

L_02d7:
    /* +0x04428 op=0x34 03 04 0d 01 OR64: s13 = s3 | s4 */
    S[13] = S[3] | S[4];

L_02d8:
    /* +0x04440 op=0x02 0c 01 01 01 XOR64: s1 = s1 ^ s12 */
    S[1] = S[1] ^ S[12];

L_02d9:
    /* +0x04458 op=0x2e 12 0a 0c 19 ROR32_IMM: s12 = ror32((uint32_t)s10, 25) */
    S[12] = ror32((uint32_t)S[10], 25);

L_02da:
    /* +0x04470 op=0xb3 0d 07 0d 01 AND64: s13 = s13 & s7 */
    S[13] = S[13] & S[7];

L_02db:
    /* +0x04488 op=0x02 01 0c 01 01 XOR64: s1 = s12 ^ s1 */
    S[1] = S[12] ^ S[1];

L_02dc:
    /* +0x044a0 op=0x52 06 0c 00 00 LD32S: s12 = *(int32_t *)(s6 +0x0) */
    S[12] = *(int32_t *)((uint8_t *)S[6] + 0x0);

L_02dd:
    /* +0x044b8 op=0x85 06 06 04 00 ADD64_IMM16: s6 = s6 +0x4 */
    S[6] = S[6] + 0x4;

L_02de:
    /* +0x044d0 op=0xb4 01 0b 01 12 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_02df:
    /* +0x044e8 op=0xb2 08 0b 3f 00 AND64_IMM16: s11 = s8 & 0x3f */
    S[11] = S[8] & 0x3f;

L_02e0:
    /* +0x04500 op=0x85 08 08 01 00 ADD64_IMM16: s8 = s8 +0x1 */
    S[8] = S[8] + 0x1;

L_02e1:
    /* +0x04518 op=0x6e 12 0b 0b 02 SHL64_IMM: s11 = s11 << 2 */
    S[11] = S[11] << 2;

L_02e2:
    /* +0x04530 op=0x84 12 0b 0b 14 ADD64: s11 = s18 + s11 */
    S[11] = S[18] + S[11];

L_02e3:
    /* +0x04548 op=0x52 0b 0b 00 00 LD32S: s11 = *(int32_t *)(s11 +0x0) */
    S[11] = *(int32_t *)((uint8_t *)S[11] + 0x0);

L_02e4:
    /* +0x04560 op=0xb4 01 0b 01 00 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_02e5:
    /* +0x04578 op=0x02 05 09 0b 01 XOR64: s11 = s9 ^ s5 */
    S[11] = S[9] ^ S[5];

L_02e6:
    /* +0x04590 op=0xb3 0b 0a 0b 01 AND64: s11 = s11 & s10 */
    S[11] = S[11] & S[10];

L_02e7:
    /* +0x045a8 op=0xb4 01 0c 01 02 ADD32: s1 = int32(s1 + s12) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[12]);

L_02e8:
    /* +0x045c0 op=0xb3 03 04 0c 01 AND64: s12 = s3 & s4 */
    S[12] = S[3] & S[4];

L_02e9:
    /* +0x045d8 op=0x02 0b 09 0b 01 XOR64: s11 = s9 ^ s11 */
    S[11] = S[9] ^ S[11];

L_02ea:
    /* +0x045f0 op=0x34 0d 0c 0c 00 OR64: s12 = s13 | s12 */
    S[12] = S[13] | S[12];

L_02eb:
    /* +0x04608 op=0x2e 01 04 0d 02 ROR32_IMM: s13 = ror32((uint32_t)s4, 2) */
    S[13] = ror32((uint32_t)S[4], 2);

L_02ec:
    /* +0x04620 op=0xb4 01 0b 01 00 ADD32: s1 = int32(s1 + s11) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_02ed:
    /* +0x04638 op=0x2e 12 04 0b 0d ROR32_IMM: s11 = ror32((uint32_t)s4, 13) */
    S[11] = ror32((uint32_t)S[4], 13);

L_02ee:
    /* +0x04650 op=0x02 0d 0b 0b 01 XOR64: s11 = s11 ^ s13 */
    S[11] = S[11] ^ S[13];

L_02ef:
    /* +0x04668 op=0x2e 01 04 0d 16 ROR32_IMM: s13 = ror32((uint32_t)s4, 22) */
    S[13] = ror32((uint32_t)S[4], 22);

L_02f0:
    /* +0x04680 op=0x02 0b 0d 0b 00 XOR64: s11 = s13 ^ s11 */
    S[11] = S[13] ^ S[11];

L_02f1:
    /* +0x04698 op=0xb4 01 0b 0b 12 ADD32: s11 = int32(s1 + s11) */
    S[11] = (int32_t)((uint32_t)S[1] + (uint32_t)S[11]);

L_02f2:
    /* +0x046b0 op=0xb4 02 01 01 00 ADD32: s1 = int32(s2 + s1) */
    S[1] = (int32_t)((uint32_t)S[2] + (uint32_t)S[1]);

L_02f3:
    /* +0x046c8 op=0x34 03 00 02 01 OR64: s2 = s3 | s0 */
    S[2] = S[3] | S[0];

L_02f4:
    /* +0x046e0 op=0x34 05 00 03 01 OR64: s3 = s5 | s0 */
    S[3] = S[5] | S[0];

L_02f5:
    /* +0x046f8 op=0xb4 0b 0c 0b 00 ADD32: s11 = int32(s11 + s12) */
    S[11] = (int32_t)((uint32_t)S[11] + (uint32_t)S[12]);

L_02f6:
    /* +0x04710 op=0x34 04 00 0c 01 OR64: s12 = s4 | s0 */
    S[12] = S[4] | S[0];

L_02f7:
    /* +0x04728 op=0x34 01 00 04 00 OR64: s4 = s1 | s0 */
    S[4] = S[1] | S[0];

L_02f8:
    /* +0x04740 op=0x34 0b 00 05 01 OR64: s5 = s11 | s0 */
    S[5] = S[11] | S[0];

L_02f9:
    /* +0x04758 op=0x34 0a 00 0b 01 OR64: s11 = s10 | s0 */
    S[11] = S[10] | S[0];

L_02fa:
    /* +0x04770 op=0x5f d6 ff ff ff ADD_PC_IMM32: goto record +721 ; vm_pc = current_pc + 1 + -42 */
    goto L_02d1;

L_02fb:
    /* +0x04788 op=0x08 1e 09 6c 00 ST32: *(s30 +0x6c) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x6c) = (uint32_t)S[9];

L_02fc:
    /* +0x047a0 op=0x08 1e 0a 50 00 ST32: *(s30 +0x50) = (uint32_t)s10 */
    *(uint32_t *)((uint8_t *)S[30] + 0x50) = (uint32_t)S[10];

L_02fd:
    /* +0x047b8 op=0x08 1e 0b 54 00 ST32: *(s30 +0x54) = (uint32_t)s11 */
    *(uint32_t *)((uint8_t *)S[30] + 0x54) = (uint32_t)S[11];

L_02fe:
    /* +0x047d0 op=0x08 1e 04 64 00 ST32: *(s30 +0x64) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x64) = (uint32_t)S[4];

L_02ff:
    /* +0x047e8 op=0x08 1e 05 58 00 ST32: *(s30 +0x58) = (uint32_t)s5 */
    *(uint32_t *)((uint8_t *)S[30] + 0x58) = (uint32_t)S[5];

L_0300:
    /* +0x04800 op=0x08 1e 07 68 00 ST32: *(s30 +0x68) = (uint32_t)s7 */
    *(uint32_t *)((uint8_t *)S[30] + 0x68) = (uint32_t)S[7];

L_0301:
    /* +0x04818 op=0x08 1e 03 5c 00 ST32: *(s30 +0x5c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x5c) = (uint32_t)S[3];

L_0302:
    /* +0x04830 op=0x08 1e 02 60 00 ST32: *(s30 +0x60) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x60) = (uint32_t)S[2];

L_0303:
    /* +0x04848 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_0304:
    /* +0x04860 op=0xae 02 0e 08 00 BR_EQ64: if (s2 == s14) goto record +781 */
    if (S[2] == S[14]) goto L_030d;

L_0305:
    /* +0x04878 op=0x84 16 02 04 04 ADD64: s4 = s22 + s2 */
    S[4] = S[22] + S[2];

L_0306:
    /* +0x04890 op=0x84 10 02 01 00 ADD64: s1 = s16 + s2 */
    S[1] = S[16] + S[2];

L_0307:
    /* +0x048a8 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0308:
    /* +0x048c0 op=0x52 01 03 00 00 LD32S: s3 = *(int32_t *)(s1 +0x0) */
    S[3] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0309:
    /* +0x048d8 op=0x52 04 04 00 00 LD32S: s4 = *(int32_t *)(s4 +0x0) */
    S[4] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_030a:
    /* +0x048f0 op=0xb4 04 03 03 00 ADD32: s3 = int32(s4 + s3) */
    S[3] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_030b:
    /* +0x04908 op=0x08 01 03 00 00 ST32: *(s1 +0x0) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[1] + 0x0) = (uint32_t)S[3];

L_030c:
    /* +0x04920 op=0xa7 02 0e f8 ff BR_NE64: if (s2 != s14) goto record +773 */
    if (S[2] != S[14]) goto L_0305;

L_030d:
    /* +0x04938 op=0x85 00 02 00 00 ADD64_IMM16: s2 = s0 +0x0 */
    S[2] = S[0] + 0x0;

L_030e:
    /* +0x04950 op=0xae 02 0e b8 fe BR_EQ64: if (s2 == s14) goto record +455 */
    if (S[2] == S[14]) goto L_01c7;

L_030f:
    /* +0x04968 op=0x84 10 02 01 04 ADD64: s1 = s16 + s2 */
    S[1] = S[16] + S[2];

L_0310:
    /* +0x04980 op=0x84 15 02 04 14 ADD64: s4 = s21 + s2 */
    S[4] = S[21] + S[2];

L_0311:
    /* +0x04998 op=0x85 02 02 04 00 ADD64_IMM16: s2 = s2 +0x4 */
    S[2] = S[2] + 0x4;

L_0312:
    /* +0x049b0 op=0x52 01 01 00 00 LD32S: s1 = *(int32_t *)(s1 +0x0) */
    S[1] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0313:
    /* +0x049c8 op=0x0e 0b 01 03 08 LSR32_IMM: s3 = sign_extend_32((uint32_t)s1 >> 8) */
    S[3] = (int32_t)((uint32_t)S[1] >> 8);

L_0314:
    /* +0x049e0 op=0x26 04 01 03 00 ST8: *(s4 +0x3) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[4] + 0x3) = (uint8_t)S[1];

L_0315:
    /* +0x049f8 op=0x26 04 03 02 00 ST8: *(s4 +0x2) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[4] + 0x2) = (uint8_t)S[3];

L_0316:
    /* +0x04a10 op=0x0e 00 01 03 10 LSR32_IMM: s3 = sign_extend_32((uint32_t)s1 >> 16) */
    S[3] = (int32_t)((uint32_t)S[1] >> 16);

L_0317:
    /* +0x04a28 op=0x0e 0d 01 01 18 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 24) */
    S[1] = (int32_t)((uint32_t)S[1] >> 24);

L_0318:
    /* +0x04a40 op=0x26 04 03 01 00 ST8: *(s4 +0x1) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[4] + 0x1) = (uint8_t)S[3];

L_0319:
    /* +0x04a58 op=0x26 04 01 00 00 ST8: *(s4 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[4] + 0x0) = (uint8_t)S[1];

L_031a:
    /* +0x04a70 op=0xa7 02 0e f4 ff BR_NE64: if (s2 != s14) goto record +783 */
    if (S[2] != S[14]) goto L_030f;

L_031b:
    /* +0x04a88 op=0x5f ab fe ff ff ADD_PC_IMM32: goto record +455 ; vm_pc = current_pc + 1 + -341 */
    goto L_01c7;

}

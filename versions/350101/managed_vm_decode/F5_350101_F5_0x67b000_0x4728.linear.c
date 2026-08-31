/*
 * Auto-generated linear C-like lift for 350.101 managed program F5.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F5_0x67b000_0x4728.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F5_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d c0 fb ADD64_IMM16: s29 = s29 -0x440 */
    S[29] = S[29] + (-0x440);

L_0001:
    /* +0x00018 op=0x25 1d 1f 38 04 ST64: *(s29 +0x438) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x438) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 30 04 ST64: *(s29 +0x430) = s30 q1=0x1700000000 */
    *(uint64_t *)((uint8_t *)S[29] + 0x430) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 28 04 ST64: *(s29 +0x428) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x428) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 20 04 ST64: *(s29 +0x420) = s22 q1=0x54 */
    *(uint64_t *)((uint8_t *)S[29] + 0x420) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 18 04 ST64: *(s29 +0x418) = s21 q1=0x126296f8 */
    *(uint64_t *)((uint8_t *)S[29] + 0x418) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 10 04 ST64: *(s29 +0x410) = s20 q1=0x1262a300 */
    *(uint64_t *)((uint8_t *)S[29] + 0x410) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 08 04 ST64: *(s29 +0x408) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x408) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 00 04 ST64: *(s29 +0x400) = s18 q1=0x1800000002 */
    *(uint64_t *)((uint8_t *)S[29] + 0x400) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 f8 03 ST64: *(s29 +0x3f8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x3f8) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 f0 03 ST64: *(s29 +0x3f0) = s16 q1=0x24a4 */
    *(uint64_t *)((uint8_t *)S[29] + 0x3f0) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 q1=0x12629578 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x58 04 01 50 00 LD64: s1 = *(uint64_t *)(s4 +0x50) q1=0x1262a4e0 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x50);

L_000d:
    /* +0x00138 op=0x34 04 00 11 01 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_000e:
    /* +0x00150 op=0x52 04 13 58 00 LD32S: s19 = *(int32_t *)(s4 +0x58) q1=0x1900000004 */
    S[19] = *(int32_t *)((uint8_t *)S[4] + 0x58);

L_000f:
    /* +0x00168 op=0x58 04 17 18 00 LD64: s23 = *(uint64_t *)(s4 +0x18) */
    S[23] = *(uint64_t *)((uint8_t *)S[4] + 0x18);

L_0010:
    /* +0x00180 op=0x58 04 16 10 00 LD64: s22 = *(uint64_t *)(s4 +0x10) q1=0xc90 */
    S[22] = *(uint64_t *)((uint8_t *)S[4] + 0x10);

L_0011:
    /* +0x00198 op=0x58 04 12 08 00 LD64: s18 = *(uint64_t *)(s4 +0x8) q1=0x126295b8 */
    S[18] = *(uint64_t *)((uint8_t *)S[4] + 0x8);

L_0012:
    /* +0x001b0 op=0x85 00 06 e0 00 ADD64_IMM16: s6 = s0 +0xe0 q1=0x125de150 */
    S[6] = S[0] + 0xe0;

L_0013:
    /* +0x001c8 op=0x25 1e 01 30 00 ST64: *(s30 +0x30) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x30) = S[1];

L_0014:
    /* +0x001e0 op=0x58 04 01 48 00 LD64: s1 = *(uint64_t *)(s4 +0x48) q1=0x1a00000005 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x48);

L_0015:
    /* +0x001f8 op=0x25 1e 01 28 00 ST64: *(s30 +0x28) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x28) = S[1];

L_0016:
    /* +0x00210 op=0x58 04 01 38 00 LD64: s1 = *(uint64_t *)(s4 +0x38) q1=0x24 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x38);

L_0017:
    /* +0x00228 op=0x25 1e 01 10 00 ST64: *(s30 +0x10) = s1 q1=0x126295f8 */
    *(uint64_t *)((uint8_t *)S[30] + 0x10) = S[1];

L_0018:
    /* +0x00240 op=0x58 04 01 30 00 LD64: s1 = *(uint64_t *)(s4 +0x30) q1=0x1262a520 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x30);

L_0019:
    /* +0x00258 op=0x25 1e 01 20 00 ST64: *(s30 +0x20) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x20) = S[1];

L_001a:
    /* +0x00270 op=0x58 04 01 28 00 LD64: s1 = *(uint64_t *)(s4 +0x28) q1=0x1b00000004 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x28);

L_001b:
    /* +0x00288 op=0x25 1e 01 18 00 ST64: *(s30 +0x18) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[1];

L_001c:
    /* +0x002a0 op=0x58 04 01 20 00 LD64: s1 = *(uint64_t *)(s4 +0x20) q1=0x83c */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x20);

L_001d:
    /* +0x002b8 op=0x25 1e 01 40 00 ST64: *(s30 +0x40) = s1 q1=0x12629638 */
    *(uint64_t *)((uint8_t *)S[30] + 0x40) = S[1];

L_001e:
    /* +0x002d0 op=0x58 04 01 00 00 LD64: s1 = *(uint64_t *)(s4 +0x0) q1=0x1262a560 */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_001f:
    /* +0x002e8 op=0x85 1e 04 10 03 ADD64_IMM16: s4 = s30 +0x310 */
    S[4] = S[30] + 0x310;

L_0020:
    /* +0x00300 op=0x25 1e 01 38 00 ST64: *(s30 +0x38) = s1 q1=0x1c00000004 */
    *(uint64_t *)((uint8_t *)S[30] + 0x38) = S[1];

L_0021:
    /* +0x00318 op=0x53 04 01 88 02 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x288 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x288;

L_0022:
    /* +0x00330 op=0x58 01 10 00 00 LD64: s16 = *(uint64_t *)(s1 +0x0) q1=0x7bc */
    S[16] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0023:
    /* +0x00348 op=0x53 01 01 08 03 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x308 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x308;

L_0024:
    /* +0x00360 op=0x58 01 14 00 00 LD64: s20 = *(uint64_t *)(s1 +0x0) q1=0x1262a640 */
    S[20] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0025:
    /* +0x00378 op=0x53 04 01 78 02 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x278 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x278;

L_0026:
    /* +0x00390 op=0x58 01 05 00 00 LD64: s5 = *(uint64_t *)(s1 +0x0) q1=0x1d00000006 */
    S[5] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0027:
    /* +0x003a8 op=0x5e 03 00 00 00 CALL_CF_INDEX: call native_binding[index=0x3] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x3, (void *)(uintptr_t)0x125fd3c0);

L_0028:
    /* +0x003c0 op=0x85 1e 04 f8 02 ADD64_IMM16: s4 = s30 +0x2f8 q1=0xc4 */
    S[4] = S[30] + 0x2f8;

L_0029:
    /* +0x003d8 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_002a:
    /* +0x003f0 op=0x85 1e 04 e0 02 ADD64_IMM16: s4 = s30 +0x2e0 q1=0x1262a680 */
    S[4] = S[30] + 0x2e0;

L_002b:
    /* +0x00408 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_002c:
    /* +0x00420 op=0xb5 00 01 01 00 ADD32_IMM16: s1 = int32(s0 +0x1) q1=0x1e00000004 */
    S[1] = (int32_t)((uint32_t)S[0] + 0x1);

L_002d:
    /* +0x00438 op=0x25 1e 14 48 00 ST64: *(s30 +0x48) = s20 */
    *(uint64_t *)((uint8_t *)S[30] + 0x48) = S[20];

L_002e:
    /* +0x00450 op=0x25 1e 16 08 00 ST64: *(s30 +0x8) = s22 q1=0xc70 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[22];

L_002f:
    /* +0x00468 op=0xa7 13 01 08 00 BR_NE64: if (s19 != s1) goto record +56 q1=0x12629738 */
    if (S[19] != S[1]) goto L_0038;

L_0030:
    /* +0x00480 op=0x85 14 15 65 00 ADD64_IMM16: s21 = s20 +0x65 q1=0x1262a6c0 */
    S[21] = S[20] + 0x65;

L_0031:
    /* +0x00498 op=0x85 1e 04 f8 02 ADD64_IMM16: s4 = s30 +0x2f8 */
    S[4] = S[30] + 0x2f8;

L_0032:
    /* +0x004b0 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 q1=0x1f00000004 */
    S[5] = S[21] | S[0];

L_0033:
    /* +0x004c8 op=0x5e 05 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x5, (void *)(uintptr_t)0x125fd3c0);

L_0034:
    /* +0x004e0 op=0x85 1e 04 e0 02 ADD64_IMM16: s4 = s30 +0x2e0 q1=0x83c */
    S[4] = S[30] + 0x2e0;

L_0035:
    /* +0x004f8 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 q1=0x12629778 */
    S[5] = S[21] | S[0];

L_0036:
    /* +0x00510 op=0x5e 05 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x5, (void *)(uintptr_t)0x125fd3c0);

L_0037:
    /* +0x00528 op=0x5f 12 00 00 00 ADD_PC_IMM32: goto record +74 ; vm_pc = current_pc + 1 + 18 */
    goto L_004a;

L_0038:
    /* +0x00540 op=0x85 1e 15 e0 01 ADD64_IMM16: s21 = s30 +0x1e0 q1=0x2000000006 */
    S[21] = S[30] + 0x1e0;

L_0039:
    /* +0x00558 op=0x34 17 00 05 01 OR64: s5 = s23 | s0 */
    S[5] = S[23] | S[0];

L_003a:
    /* +0x00570 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 q1=0xc4 */
    S[4] = S[21] | S[0];

L_003b:
    /* +0x00588 op=0x5e 6d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6d, (void *)(uintptr_t)0x125fd3c0);

L_003c:
    /* +0x005a0 op=0x85 1e 04 f8 02 ADD64_IMM16: s4 = s30 +0x2f8 q1=0x1262a740 */
    S[4] = S[30] + 0x2f8;

L_003d:
    /* +0x005b8 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_003e:
    /* +0x005d0 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table runtime: CF10 copyMemBlockData q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_003f:
    /* +0x005e8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0040:
    /* +0x00600 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0041:
    /* +0x00618 op=0x85 1e 15 e0 01 ADD64_IMM16: s21 = s30 +0x1e0 q1=0x126297f8 */
    S[21] = S[30] + 0x1e0;

L_0042:
    /* +0x00630 op=0x34 16 00 05 00 OR64: s5 = s22 | s0 q1=0x1262a780 */
    S[5] = S[22] | S[0];

L_0043:
    /* +0x00648 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0044:
    /* +0x00660 op=0x5e 6d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6d, (void *)(uintptr_t)0x125fd3c0);

L_0045:
    /* +0x00678 op=0x85 1e 04 e0 02 ADD64_IMM16: s4 = s30 +0x2e0 */
    S[4] = S[30] + 0x2e0;

L_0046:
    /* +0x00690 op=0x34 15 00 05 00 OR64: s5 = s21 | s0 q1=0x83c */
    S[5] = S[21] | S[0];

L_0047:
    /* +0x006a8 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table runtime: CF10 copyMemBlockData q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_0048:
    /* +0x006c0 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 q1=0x1262a7c0 */
    S[4] = S[21] | S[0];

L_0049:
    /* +0x006d8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_004a:
    /* +0x006f0 op=0x54 00 01 20 20 CONST_HI16: s1 = sign_extend_32(0x2020 << 16) q1=0x2300000006 */
    S[1] = (int32_t)(0x2020 << 16);

L_004b:
    /* +0x00708 op=0x85 1e 04 c8 02 ADD64_IMM16: s4 = s30 +0x2c8 */
    S[4] = S[30] + 0x2c8;

L_004c:
    /* +0x00720 op=0x53 04 05 28 00 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x28 q1=0x125fd408 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x28;

L_004d:
    /* +0x00738 op=0x25 1e 17 00 00 ST64: *(s30 +0x0) = s23 q1=0x126298b8 */
    *(uint64_t *)((uint8_t *)S[30] + 0x0) = S[23];

L_004e:
    /* +0x00750 op=0x08 1e 13 ec 03 ST32: *(s30 +0x3ec) = (uint32_t)s19 q1=0x1262a800 */
    *(uint32_t *)((uint8_t *)S[30] + 0x3ec) = (uint32_t)S[19];

L_004f:
    /* +0x00768 op=0x33 01 01 29 09 OR_IMM16: s1 = s1 | 0x929 */
    S[1] = S[1] | 0x929;

L_0050:
    /* +0x00780 op=0x08 1e 01 28 03 ST32: *(s30 +0x328) = (uint32_t)s1 q1=0x2400000004 */
    *(uint32_t *)((uint8_t *)S[30] + 0x328) = (uint32_t)S[1];

L_0051:
    /* +0x00798 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_0052:
    /* +0x007b0 op=0x85 1e 15 b8 02 ADD64_IMM16: s21 = s30 +0x2b8 q1=0xc5c */
    S[21] = S[30] + 0x2b8;

L_0053:
    /* +0x007c8 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 q1=0x126298f8 */
    S[5] = S[18] | S[0];

L_0054:
    /* +0x007e0 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 q1=0x1262ae40 */
    S[4] = S[21] | S[0];

L_0055:
    /* +0x007f8 op=0x5e 09 00 00 00 CALL_CF_INDEX: call native_binding[index=0x9] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x9, (void *)(uintptr_t)0x125fd3c0);

L_0056:
    /* +0x00810 op=0x85 1e 16 a8 02 ADD64_IMM16: s22 = s30 +0x2a8 q1=0x2500000004 */
    S[22] = S[30] + 0x2a8;

L_0057:
    /* +0x00828 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0058:
    /* +0x00840 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 q1=0x7bc */
    S[4] = S[22] | S[0];

L_0059:
    /* +0x00858 op=0x5e 0a 00 00 00 CALL_CF_INDEX: call native_binding[index=0xa] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xa, (void *)(uintptr_t)0x125fd3c0);

L_005a:
    /* +0x00870 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 q1=0x1262ae80 */
    S[4] = S[22] | S[0];

L_005b:
    /* +0x00888 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd3c0);

L_005c:
    /* +0x008a0 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 q1=0x2600000006 */
    S[4] = S[22] | S[0];

L_005d:
    /* +0x008b8 op=0x34 02 00 15 01 OR64: s21 = s2 | s0 */
    S[21] = S[2] | S[0];

L_005e:
    /* +0x008d0 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_005f:
    /* +0x008e8 op=0x18 11 15 01 00 SHL32_IMM: s1 = (int32_t)(s21 << 0) q1=0x12629978 */
    S[1] = (int32_t)((uint32_t)S[21] << 0);

L_0060:
    /* +0x00900 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 q1=0x1262aec0 */
    S[1] = S[1] & 0x1;

L_0061:
    /* +0x00918 op=0xa7 01 00 03 00 BR_NE64: if (s1 != s0) goto record +101 */
    if (S[1] != S[0]) goto L_0065;

L_0062:
    /* +0x00930 op=0x58 1e 05 b8 02 LD64: s5 = *(uint64_t *)(s30 +0x2b8) q1=0x2700000004 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x2b8);

L_0063:
    /* +0x00948 op=0x85 1e 04 c8 02 ADD64_IMM16: s4 = s30 +0x2c8 */
    S[4] = S[30] + 0x2c8;

L_0064:
    /* +0x00960 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table runtime: CF10 copyMemBlockData q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_0065:
    /* +0x00978 op=0x58 1e 01 d8 02 LD64: s1 = *(uint64_t *)(s30 +0x2d8) q1=0x126299b8 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x2d8);

L_0066:
    /* +0x00990 op=0x25 1e 01 38 03 ST64: *(s30 +0x338) = s1 q1=0x1262af00 */
    *(uint64_t *)((uint8_t *)S[30] + 0x338) = S[1];

L_0067:
    /* +0x009a8 op=0xb5 00 01 01 00 ADD32_IMM16: s1 = int32(s0 +0x1) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x1);

L_0068:
    /* +0x009c0 op=0x08 1e 01 2c 03 ST32: *(s30 +0x32c) = (uint32_t)s1 q1=0x2800000004 */
    *(uint32_t *)((uint8_t *)S[30] + 0x32c) = (uint32_t)S[1];

L_0069:
    /* +0x009d8 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd3c0);

L_006a:
    /* +0x009f0 op=0x85 1e 17 98 02 ADD64_IMM16: s23 = s30 +0x298 q1=0x78c */
    S[23] = S[30] + 0x298;

L_006b:
    /* +0x00a08 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 q1=0x126299f8 */
    S[5] = S[18] | S[0];

L_006c:
    /* +0x00a20 op=0x08 1e 02 30 03 ST32: *(s30 +0x330) = (uint32_t)s2 q1=0x1262af40 */
    *(uint32_t *)((uint8_t *)S[30] + 0x330) = (uint32_t)S[2];

L_006d:
    /* +0x00a38 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_006e:
    /* +0x00a50 op=0x5e 0e 00 00 00 CALL_CF_INDEX: call native_binding[index=0xe] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xe, (void *)(uintptr_t)0x125fd3c0);

L_006f:
    /* +0x00a68 op=0x85 1e 16 88 02 ADD64_IMM16: s22 = s30 +0x288 */
    S[22] = S[30] + 0x288;

L_0070:
    /* +0x00a80 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 q1=0xc4 */
    S[5] = S[18] | S[0];

L_0071:
    /* +0x00a98 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 q1=0x12629a38 */
    S[4] = S[22] | S[0];

L_0072:
    /* +0x00ab0 op=0x5e 0f 00 00 00 CALL_CF_INDEX: call native_binding[index=0xf] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xf, (void *)(uintptr_t)0x125fd3c0);

L_0073:
    /* +0x00ac8 op=0x85 1e 15 78 02 ADD64_IMM16: s21 = s30 +0x278 */
    S[21] = S[30] + 0x278;

L_0074:
    /* +0x00ae0 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 q1=0x2a00000004 */
    S[5] = S[18] | S[0];

L_0075:
    /* +0x00af8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0076:
    /* +0x00b10 op=0x5e 10 00 00 00 CALL_CF_INDEX: call native_binding[index=0x10] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x10, (void *)(uintptr_t)0x125fd3c0);

L_0077:
    /* +0x00b28 op=0x85 1e 04 60 02 ADD64_IMM16: s4 = s30 +0x260 q1=0x12629a78 */
    S[4] = S[30] + 0x260;

L_0078:
    /* +0x00b40 op=0x53 03 05 28 00 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x28 q1=0x125fd408 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x28;

L_0079:
    /* +0x00b58 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_007a:
    /* +0x00b70 op=0x85 1e 13 50 02 ADD64_IMM16: s19 = s30 +0x250 q1=0x2b00000001 */
    S[19] = S[30] + 0x250;

L_007b:
    /* +0x00b88 op=0x34 17 00 05 01 OR64: s5 = s23 | s0 */
    S[5] = S[23] | S[0];

L_007c:
    /* +0x00ba0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0xb4 */
    S[4] = S[19] | S[0];

L_007d:
    /* +0x00bb8 op=0x5e 0a 00 00 00 CALL_CF_INDEX: call native_binding[index=0xa] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xa, (void *)(uintptr_t)0x125fd3c0);

L_007e:
    /* +0x00bd0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x125d7290 */
    S[4] = S[19] | S[0];

L_007f:
    /* +0x00be8 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd3c0);

L_0080:
    /* +0x00c00 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x2c00000001 */
    S[4] = S[19] | S[0];

L_0081:
    /* +0x00c18 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_0082:
    /* +0x00c30 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0083:
    /* +0x00c48 op=0x18 10 14 01 00 SHL32_IMM: s1 = (int32_t)(s20 << 0) q1=0x12629af8 */
    S[1] = (int32_t)((uint32_t)S[20] << 0);

L_0084:
    /* +0x00c60 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 q1=0x125d7280 */
    S[1] = S[1] & 0x1;

L_0085:
    /* +0x00c78 op=0xae 01 00 1a 00 BR_EQ64: if (s1 == s0) goto record +160 */
    if (S[1] == S[0]) goto L_00a0;

L_0086:
    /* +0x00c90 op=0x85 1e 13 40 02 ADD64_IMM16: s19 = s30 +0x240 q1=0x2d00000001 */
    S[19] = S[30] + 0x240;

L_0087:
    /* +0x00ca8 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0088:
    /* +0x00cc0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x2a0 */
    S[4] = S[19] | S[0];

L_0089:
    /* +0x00cd8 op=0x5e 0a 00 00 00 CALL_CF_INDEX: call native_binding[index=0xa] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xa, (void *)(uintptr_t)0x125fd3c0);

L_008a:
    /* +0x00cf0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x125de130 */
    S[4] = S[19] | S[0];

L_008b:
    /* +0x00d08 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd3c0);

L_008c:
    /* +0x00d20 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x2e00000005 */
    S[4] = S[19] | S[0];

L_008d:
    /* +0x00d38 op=0x34 02 00 14 00 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_008e:
    /* +0x00d50 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_008f:
    /* +0x00d68 op=0x18 00 14 01 00 SHL32_IMM: s1 = (int32_t)(s20 << 0) q1=0x12629b78 */
    S[1] = (int32_t)((uint32_t)S[20] << 0);

L_0090:
    /* +0x00d80 op=0x34 15 00 17 01 OR64: s23 = s21 | s0 q1=0x1262afc0 */
    S[23] = S[21] | S[0];

L_0091:
    /* +0x00d98 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_0092:
    /* +0x00db0 op=0xae 01 00 0d 00 BR_EQ64: if (s1 == s0) goto record +160 q1=0x2f0000000c */
    if (S[1] == S[0]) goto L_00a0;

L_0093:
    /* +0x00dc8 op=0x85 1e 13 30 02 ADD64_IMM16: s19 = s30 +0x230 */
    S[19] = S[30] + 0x230;

L_0094:
    /* +0x00de0 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 q1=0x18c */
    S[5] = S[22] | S[0];

L_0095:
    /* +0x00df8 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x12629bb8 */
    S[4] = S[19] | S[0];

L_0096:
    /* +0x00e10 op=0x5e 0a 00 00 00 CALL_CF_INDEX: call native_binding[index=0xa] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xa, (void *)(uintptr_t)0x125fd3c0);

L_0097:
    /* +0x00e28 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0098:
    /* +0x00e40 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd3c0);

L_0099:
    /* +0x00e58 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_009a:
    /* +0x00e70 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 q1=0x160 */
    S[20] = S[2] | S[0];

L_009b:
    /* +0x00e88 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_009c:
    /* +0x00ea0 op=0x18 10 14 01 00 SHL32_IMM: s1 = (int32_t)(s20 << 0) q1=0x125de170 */
    S[1] = (int32_t)((uint32_t)S[20] << 0);

L_009d:
    /* +0x00eb8 op=0x34 16 00 17 00 OR64: s23 = s22 | s0 */
    S[23] = S[22] | S[0];

L_009e:
    /* +0x00ed0 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 q1=0x3100000005 */
    S[1] = S[1] & 0x1;

L_009f:
    /* +0x00ee8 op=0xa7 01 00 03 00 BR_NE64: if (s1 != s0) goto record +163 */
    if (S[1] != S[0]) goto L_00a3;

L_00a0:
    /* +0x00f00 op=0x58 17 05 00 00 LD64: s5 = *(uint64_t *)(s23 +0x0) q1=0x54 */
    S[5] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_00a1:
    /* +0x00f18 op=0x85 1e 04 60 02 ADD64_IMM16: s4 = s30 +0x260 q1=0x12629c38 */
    S[4] = S[30] + 0x260;

L_00a2:
    /* +0x00f30 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table runtime: CF10 copyMemBlockData q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_00a3:
    /* +0x00f48 op=0x58 1e 01 70 02 LD64: s1 = *(uint64_t *)(s30 +0x270) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x270);

L_00a4:
    /* +0x00f60 op=0x25 1e 01 40 03 ST64: *(s30 +0x340) = s1 q1=0x3200000001 */
    *(uint64_t *)((uint8_t *)S[30] + 0x340) = S[1];

L_00a5:
    /* +0x00f78 op=0x58 12 01 08 00 LD64: s1 = *(uint64_t *)(s18 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[18] + 0x8);

L_00a6:
    /* +0x00f90 op=0x52 01 01 0c 00 LD32S: s1 = *(int32_t *)(s1 +0xc) q1=0xc8 */
    S[1] = *(int32_t *)((uint8_t *)S[1] + 0xc);

L_00a7:
    /* +0x00fa8 op=0xae 01 00 04 00 BR_EQ64: if (s1 == s0) goto record +172 q1=0x12629c78 */
    if (S[1] == S[0]) goto L_00ac;

L_00a8:
    /* +0x00fc0 op=0x58 1e 13 38 00 LD64: s19 = *(uint64_t *)(s30 +0x38) q1=0x12660000 */
    S[19] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_00a9:
    /* +0x00fd8 op=0x58 1e 15 48 00 LD64: s21 = *(uint64_t *)(s30 +0x48) */
    S[21] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_00aa:
    /* +0x00ff0 op=0x18 10 13 02 00 SHL32_IMM: s2 = (int32_t)(s19 << 0) q1=0x330000000d */
    S[2] = (int32_t)((uint32_t)S[19] << 0);

L_00ab:
    /* +0x01008 op=0x5f 09 00 00 00 ADD_PC_IMM32: goto record +181 ; vm_pc = current_pc + 1 + 9 */
    goto L_00b5;

L_00ac:
    /* +0x01020 op=0x58 12 02 80 00 LD64: s2 = *(uint64_t *)(s18 +0x80) q1=0x124 */
    S[2] = *(uint64_t *)((uint8_t *)S[18] + 0x80);

L_00ad:
    /* +0x01038 op=0x58 1e 13 38 00 LD64: s19 = *(uint64_t *)(s30 +0x38) q1=0x12629cb8 */
    S[19] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_00ae:
    /* +0x01050 op=0x58 1e 15 48 00 LD64: s21 = *(uint64_t *)(s30 +0x48) q1=0x125de190 */
    S[21] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_00af:
    /* +0x01068 op=0x52 02 02 0c 00 LD32S: s2 = *(int32_t *)(s2 +0xc) */
    S[2] = *(int32_t *)((uint8_t *)S[2] + 0xc);

L_00b0:
    /* +0x01080 op=0x18 00 13 01 00 SHL32_IMM: s1 = (int32_t)(s19 << 0) q1=0x3400000005 */
    S[1] = (int32_t)((uint32_t)S[19] << 0);

L_00b1:
    /* +0x01098 op=0x15 02 02 01 00 CMP_LT_IMM64S: s2 = ((int64_t)s2 < 1) ? 1 : 0 */
    S[2] = ((int64_t)S[2] < 0x1) ? 1 : 0;

L_00b2:
    /* +0x010b0 op=0x1e 01 02 01 01 CMOVNZ64: s1 = (s2 != 0) ? s1 : 0 q1=0x2c8 */
    S[1] = (S[2] != 0) ? S[1] : 0;

L_00b3:
    /* +0x010c8 op=0x1f 00 02 02 00 CMOVZ64: s2 = (s2 == 0) ? s0 : 0 q1=0x12629cf8 */
    S[2] = (S[2] == 0) ? S[0] : 0;

L_00b4:
    /* +0x010e0 op=0x34 02 01 02 01 OR64: s2 = s2 | s1 q1=0x125d7200 */
    S[2] = S[2] | S[1];

L_00b5:
    /* +0x010f8 op=0x85 12 16 a0 00 ADD64_IMM16: s22 = s18 +0xa0 */
    S[22] = S[18] + 0xa0;

L_00b6:
    /* +0x01110 op=0x85 1e 17 e0 01 ADD64_IMM16: s23 = s30 +0x1e0 q1=0x3500000001 */
    S[23] = S[30] + 0x1e0;

L_00b7:
    /* +0x01128 op=0x08 1e 02 b8 03 ST32: *(s30 +0x3b8) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x3b8) = (uint32_t)S[2];

L_00b8:
    /* +0x01140 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 q1=0x2a0 */
    S[4] = S[23] | S[0];

L_00b9:
    /* +0x01158 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 q1=0x12629d38 */
    S[5] = S[22] | S[0];

L_00ba:
    /* +0x01170 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd3c0);

L_00bb:
    /* +0x01188 op=0x58 1e 05 e0 01 LD64: s5 = *(uint64_t *)(s30 +0x1e0) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x1e0);

L_00bc:
    /* +0x011a0 op=0x85 1e 04 20 02 ADD64_IMM16: s4 = s30 +0x220 q1=0x3600000005 */
    S[4] = S[30] + 0x220;

L_00bd:
    /* +0x011b8 op=0x5e 12 00 00 00 CALL_CF_INDEX: call native_binding[index=0x12] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x12, (void *)(uintptr_t)0x125fd3c0);

L_00be:
    /* +0x011d0 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 q1=0xa0 */
    S[4] = S[23] | S[0];

L_00bf:
    /* +0x011e8 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd3c0);

L_00c0:
    /* +0x01200 op=0x58 1e 01 20 02 LD64: s1 = *(uint64_t *)(s30 +0x220) q1=0x12660040 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x220);

L_00c1:
    /* +0x01218 op=0x85 1e 04 10 02 ADD64_IMM16: s4 = s30 +0x210 */
    S[4] = S[30] + 0x210;

L_00c2:
    /* +0x01230 op=0x58 01 01 10 00 LD64: s1 = *(uint64_t *)(s1 +0x10) q1=0x370000000c */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x10);

L_00c3:
    /* +0x01248 op=0x25 1e 01 48 03 ST64: *(s30 +0x348) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x348) = S[1];

L_00c4:
    /* +0x01260 op=0x5e 14 00 00 00 CALL_CF_INDEX: call native_binding[index=0x14] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x14, (void *)(uintptr_t)0x125fd3c0);

L_00c5:
    /* +0x01278 op=0x58 1e 01 10 02 LD64: s1 = *(uint64_t *)(s30 +0x210) q1=0x12629db8 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x210);

L_00c6:
    /* +0x01290 op=0x58 01 01 10 00 LD64: s1 = *(uint64_t *)(s1 +0x10) q1=0x125d7210 */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x10);

L_00c7:
    /* +0x012a8 op=0x25 1e 01 50 03 ST64: *(s30 +0x350) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x350) = S[1];

L_00c8:
    /* +0x012c0 op=0x5e 15 00 00 00 CALL_CF_INDEX: call native_binding[index=0x15] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x15, (void *)(uintptr_t)0x125fd3c0);

L_00c9:
    /* +0x012d8 op=0x08 1e 02 60 03 ST32: *(s30 +0x360) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x360) = (uint32_t)S[2];

L_00ca:
    /* +0x012f0 op=0x5e 16 00 00 00 CALL_CF_INDEX: call native_binding[index=0x16] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x16, (void *)(uintptr_t)0x125fd3c0);

L_00cb:
    /* +0x01308 op=0x58 1e 04 40 00 LD64: s4 = *(uint64_t *)(s30 +0x40) q1=0x12629df8 */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_00cc:
    /* +0x01320 op=0x25 1e 02 58 03 ST64: *(s30 +0x358) = s2 q1=0x125d7220 */
    *(uint64_t *)((uint8_t *)S[30] + 0x358) = S[2];

L_00cd:
    /* +0x01338 op=0x58 1e 05 f0 02 LD64: s5 = *(uint64_t *)(s30 +0x2f0) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x2f0);

L_00ce:
    /* +0x01350 op=0x53 03 01 29 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x29 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x29;

L_00cf:
    /* +0x01368 op=0x85 00 03 06 00 ADD64_IMM16: s3 = s0 +0x6 */
    S[3] = S[0] + 0x6;

L_00d0:
    /* +0x01380 op=0x52 04 02 0c 00 LD32S: s2 = *(int32_t *)(s4 +0xc) q1=0xc8 */
    S[2] = *(int32_t *)((uint8_t *)S[4] + 0xc);

L_00d1:
    /* +0x01398 op=0x58 04 04 10 00 LD64: s4 = *(uint64_t *)(s4 +0x10) q1=0x12629e38 */
    S[4] = *(uint64_t *)((uint8_t *)S[4] + 0x10);

L_00d2:
    /* +0x013b0 op=0x25 1e 04 70 03 ST64: *(s30 +0x370) = s4 q1=0x12660080 */
    *(uint64_t *)((uint8_t *)S[30] + 0x370) = S[4];

L_00d3:
    /* +0x013c8 op=0x58 1e 04 08 03 LD64: s4 = *(uint64_t *)(s30 +0x308) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x308);

L_00d4:
    /* +0x013e0 op=0x25 1e 13 80 03 ST64: *(s30 +0x380) = s19 q1=0x3a0000000d */
    *(uint64_t *)((uint8_t *)S[30] + 0x380) = S[19];

L_00d5:
    /* +0x013f8 op=0x25 1e 05 90 03 ST64: *(s30 +0x390) = s5 */
    *(uint64_t *)((uint8_t *)S[30] + 0x390) = S[5];

L_00d6:
    /* +0x01410 op=0x25 1e 04 a0 03 ST64: *(s30 +0x3a0) = s4 q1=0x124 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3a0) = S[4];

L_00d7:
    /* +0x01428 op=0x25 1e 03 98 03 ST64: *(s30 +0x398) = s3 q1=0x12629e78 */
    *(uint64_t *)((uint8_t *)S[30] + 0x398) = S[3];

L_00d8:
    /* +0x01440 op=0x25 1e 03 88 03 ST64: *(s30 +0x388) = s3 q1=0x12627ee0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x388) = S[3];

L_00d9:
    /* +0x01458 op=0x25 1e 02 68 03 ST64: *(s30 +0x368) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x368) = S[2];

L_00da:
    /* +0x01470 op=0x59 01 02 04 00 LD8U: s2 = *(uint8_t *)(s1 +0x4) q1=0x3b00000005 */
    S[2] = *(uint8_t *)((uint8_t *)S[1] + 0x4);

L_00db:
    /* +0x01488 op=0x52 01 01 00 00 LD32S: s1 = *(int32_t *)(s1 +0x0) */
    S[1] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_00dc:
    /* +0x014a0 op=0x08 1e 00 78 03 ST32: *(s30 +0x378) = (uint32_t)s0 q1=0x2cc */
    *(uint32_t *)((uint8_t *)S[30] + 0x378) = (uint32_t)S[0];

L_00dd:
    /* +0x014b8 op=0x26 1e 02 0c 02 ST8: *(s30 +0x20c) = (uint8_t)s2 q1=0x12629eb8 */
    *(uint8_t *)((uint8_t *)S[30] + 0x20c) = (uint8_t)S[2];

L_00de:
    /* +0x014d0 op=0x08 1e 01 08 02 ST32: *(s30 +0x208) = (uint32_t)s1 q1=0x125d7230 */
    *(uint32_t *)((uint8_t *)S[30] + 0x208) = (uint32_t)S[1];

L_00df:
    /* +0x014e8 op=0x58 10 01 10 00 LD64: s1 = *(uint64_t *)(s16 +0x10) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x10);

L_00e0:
    /* +0x01500 op=0x25 1e 01 f0 01 ST64: *(s30 +0x1f0) = s1 q1=0x3c00000001 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1f0) = S[1];

L_00e1:
    /* +0x01518 op=0x58 10 01 08 00 LD64: s1 = *(uint64_t *)(s16 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x8);

L_00e2:
    /* +0x01530 op=0x25 1e 01 e8 01 ST64: *(s30 +0x1e8) = s1 q1=0x2a0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1e8) = S[1];

L_00e3:
    /* +0x01548 op=0x58 10 01 00 00 LD64: s1 = *(uint64_t *)(s16 +0x0) q1=0x12629ef8 */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x0);

L_00e4:
    /* +0x01560 op=0x25 1e 01 e0 01 ST64: *(s30 +0x1e0) = s1 q1=0x12627f00 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1e0) = S[1];

L_00e5:
    /* +0x01578 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd3c0);

L_00e6:
    /* +0x01590 op=0x85 1e 13 c8 01 ADD64_IMM16: s19 = s30 +0x1c8 q1=0x3d00000005 */
    S[19] = S[30] + 0x1c8;

L_00e7:
    /* +0x015a8 op=0x85 15 05 86 00 ADD64_IMM16: s5 = s21 +0x86 */
    S[5] = S[21] + 0x86;

L_00e8:
    /* +0x015c0 op=0x58 02 14 00 00 LD64: s20 = *(uint64_t *)(s2 +0x0) q1=0xa0 */
    S[20] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_00e9:
    /* +0x015d8 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x12629f38 */
    S[4] = S[19] | S[0];

L_00ea:
    /* +0x015f0 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_00eb:
    /* +0x01608 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_00ec:
    /* +0x01620 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 q1=0x3e0000000c */
    S[5] = S[19] | S[0];

L_00ed:
    /* +0x01638 op=0x5e 18 00 00 00 CALL_CF_INDEX: call native_binding[index=0x18] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x18, (void *)(uintptr_t)0x125fd3c0);

L_00ee:
    /* +0x01650 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x18c */
    S[4] = S[19] | S[0];

L_00ef:
    /* +0x01668 op=0x08 1e 02 f8 01 ST32: *(s30 +0x1f8) = (uint32_t)s2 q1=0x12629f78 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1f8) = (uint32_t)S[2];

L_00f0:
    /* +0x01680 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_00f1:
    /* +0x01698 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd3c0);

L_00f2:
    /* +0x016b0 op=0x85 1e 13 c8 01 ADD64_IMM16: s19 = s30 +0x1c8 q1=0x3f00000001 */
    S[19] = S[30] + 0x1c8;

L_00f3:
    /* +0x016c8 op=0x85 15 05 a8 00 ADD64_IMM16: s5 = s21 +0xa8 */
    S[5] = S[21] + 0xa8;

L_00f4:
    /* +0x016e0 op=0x58 02 14 00 00 LD64: s20 = *(uint64_t *)(s2 +0x0) q1=0x160 */
    S[20] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_00f5:
    /* +0x016f8 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x12629fb8 */
    S[4] = S[19] | S[0];

L_00f6:
    /* +0x01710 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_00f7:
    /* +0x01728 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_00f8:
    /* +0x01740 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 q1=0x4000000001 */
    S[5] = S[19] | S[0];

L_00f9:
    /* +0x01758 op=0x5e 18 00 00 00 CALL_CF_INDEX: call native_binding[index=0x18] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x18, (void *)(uintptr_t)0x125fd3c0);

L_00fa:
    /* +0x01770 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0xc8 */
    S[4] = S[19] | S[0];

L_00fb:
    /* +0x01788 op=0x08 1e 02 00 02 ST32: *(s30 +0x200) = (uint32_t)s2 q1=0x12629ff8 */
    *(uint32_t *)((uint8_t *)S[30] + 0x200) = (uint32_t)S[2];

L_00fc:
    /* +0x017a0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_00fd:
    /* +0x017b8 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd3c0);

L_00fe:
    /* +0x017d0 op=0x85 1e 13 c8 01 ADD64_IMM16: s19 = s30 +0x1c8 q1=0x410000000d */
    S[19] = S[30] + 0x1c8;

L_00ff:
    /* +0x017e8 op=0x85 15 05 ca 00 ADD64_IMM16: s5 = s21 +0xca */
    S[5] = S[21] + 0xca;

L_0100:
    /* +0x01800 op=0x58 02 14 00 00 LD64: s20 = *(uint64_t *)(s2 +0x0) q1=0x124 */
    S[20] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_0101:
    /* +0x01818 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x126af038 */
    S[4] = S[19] | S[0];

L_0102:
    /* +0x01830 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_0103:
    /* +0x01848 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0104:
    /* +0x01860 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 q1=0x4200000005 */
    S[5] = S[19] | S[0];

L_0105:
    /* +0x01878 op=0x5e 18 00 00 00 CALL_CF_INDEX: call native_binding[index=0x18] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x18, (void *)(uintptr_t)0x125fd3c0);

L_0106:
    /* +0x01890 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x2cc */
    S[4] = S[19] | S[0];

L_0107:
    /* +0x018a8 op=0x08 1e 02 fc 01 ST32: *(s30 +0x1fc) = (uint32_t)s2 q1=0x126af078 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1fc) = (uint32_t)S[2];

L_0108:
    /* +0x018c0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0109:
    /* +0x018d8 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd3c0);

L_010a:
    /* +0x018f0 op=0x85 1e 13 c8 01 ADD64_IMM16: s19 = s30 +0x1c8 q1=0x4300000001 */
    S[19] = S[30] + 0x1c8;

L_010b:
    /* +0x01908 op=0x53 01 05 2e 00 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x2e q1=0x125fd408 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x2e;

L_010c:
    /* +0x01920 op=0x58 02 14 00 00 LD64: s20 = *(uint64_t *)(s2 +0x0) q1=0x2a0 */
    S[20] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_010d:
    /* +0x01938 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x126b01f8 */
    S[4] = S[19] | S[0];

L_010e:
    /* +0x01950 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_010f:
    /* +0x01968 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0110:
    /* +0x01980 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 q1=0x4400000005 */
    S[5] = S[19] | S[0];

L_0111:
    /* +0x01998 op=0x5e 18 00 00 00 CALL_CF_INDEX: call native_binding[index=0x18] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x18, (void *)(uintptr_t)0x125fd3c0);

L_0112:
    /* +0x019b0 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0xa0 */
    S[4] = S[19] | S[0];

L_0113:
    /* +0x019c8 op=0x08 1e 02 04 02 ST32: *(s30 +0x204) = (uint32_t)s2 q1=0x126b0238 */
    *(uint32_t *)((uint8_t *)S[30] + 0x204) = (uint32_t)S[2];

L_0114:
    /* +0x019e0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0115:
    /* +0x019f8 op=0x58 1e 01 18 00 LD64: s1 = *(uint64_t *)(s30 +0x18) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_0116:
    /* +0x01a10 op=0x25 1e 17 a8 03 ST64: *(s30 +0x3a8) = s23 q1=0x450000000c */
    *(uint64_t *)((uint8_t *)S[30] + 0x3a8) = S[23];

L_0117:
    /* +0x01a28 op=0x85 1e 04 08 02 ADD64_IMM16: s4 = s30 +0x208 */
    S[4] = S[30] + 0x208;

L_0118:
    /* +0x01a40 op=0x85 00 05 05 00 ADD64_IMM16: s5 = s0 +0x5 q1=0x18c */
    S[5] = S[0] + 0x5;

L_0119:
    /* +0x01a58 op=0x58 01 01 10 00 LD64: s1 = *(uint64_t *)(s1 +0x10) q1=0x126b0278 */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x10);

L_011a:
    /* +0x01a70 op=0x25 1e 01 b0 03 ST64: *(s30 +0x3b0) = s1 q1=0x125d72a8 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3b0) = S[1];

L_011b:
    /* +0x01a88 op=0x52 11 01 40 00 LD32S: s1 = *(int32_t *)(s17 +0x40) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x40);

L_011c:
    /* +0x01aa0 op=0x08 1e 01 e8 03 ST32: *(s30 +0x3e8) = (uint32_t)s1 q1=0x4600000001 */
    *(uint32_t *)((uint8_t *)S[30] + 0x3e8) = (uint32_t)S[1];

L_011d:
    /* +0x01ab8 op=0x5e 19 00 00 00 CALL_CF_INDEX: call native_binding[index=0x19] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x19, (void *)(uintptr_t)0x125fd3c0);

L_011e:
    /* +0x01ad0 op=0x85 1e 04 c8 01 ADD64_IMM16: s4 = s30 +0x1c8 q1=0x160 */
    S[4] = S[30] + 0x1c8;

L_011f:
    /* +0x01ae8 op=0x34 02 00 11 01 OR64: s17 = s2 | s0 q1=0x126b02b8 */
    S[17] = S[2] | S[0];

L_0120:
    /* +0x01b00 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_0121:
    /* +0x01b18 op=0x85 1e 04 b0 01 ADD64_IMM16: s4 = s30 +0x1b0 */
    S[4] = S[30] + 0x1b0;

L_0122:
    /* +0x01b30 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_0123:
    /* +0x01b48 op=0x58 1e 10 20 00 LD64: s16 = *(uint64_t *)(s30 +0x20) */
    S[16] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_0124:
    /* +0x01b60 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 q1=0xc8 */
    S[4] = S[16] | S[0];

L_0125:
    /* +0x01b78 op=0x5e 1a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1a] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1a, (void *)(uintptr_t)0x125fd3c0);

L_0126:
    /* +0x01b90 op=0x18 00 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) q1=0x12660180 */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_0127:
    /* +0x01ba8 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_0128:
    /* +0x01bc0 op=0xa7 01 00 05 00 BR_NE64: if (s1 != s0) goto record +302 q1=0x480000000d */
    if (S[1] != S[0]) goto L_012e;

L_0129:
    /* +0x01bd8 op=0x58 1e 04 10 00 LD64: s4 = *(uint64_t *)(s30 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_012a:
    /* +0x01bf0 op=0x5e 1a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1a] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1a, (void *)(uintptr_t)0x125fd3c0);

L_012b:
    /* +0x01c08 op=0x18 11 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) q1=0x126b0338 */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_012c:
    /* +0x01c20 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 q1=0x12627f60 */
    S[1] = S[1] & 0x1;

L_012d:
    /* +0x01c38 op=0xae 01 00 02 00 BR_EQ64: if (s1 == s0) goto record +304 */
    if (S[1] == S[0]) goto L_0130;

L_012e:
    /* +0x01c50 op=0x25 1e 11 e0 03 ST64: *(s30 +0x3e0) = s17 q1=0x4900000005 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3e0) = S[17];

L_012f:
    /* +0x01c68 op=0x5f 2c 00 00 00 ADD_PC_IMM32: goto record +348 ; vm_pc = current_pc + 1 + 44 */
    goto L_015c;

L_0130:
    /* +0x01c80 op=0x58 1e 13 10 00 LD64: s19 = *(uint64_t *)(s30 +0x10) q1=0x2cc */
    S[19] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_0131:
    /* +0x01c98 op=0x85 1e 11 98 01 ADD64_IMM16: s17 = s30 +0x198 q1=0x126b0378 */
    S[17] = S[30] + 0x198;

L_0132:
    /* +0x01cb0 op=0x85 00 06 00 00 ADD64_IMM16: s6 = s0 +0x0 q1=0x125d72c8 */
    S[6] = S[0] + 0x0;

L_0133:
    /* +0x01cc8 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_0134:
    /* +0x01ce0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x4a00000001 */
    S[4] = S[17] | S[0];

L_0135:
    /* +0x01cf8 op=0x58 13 01 10 00 LD64: s1 = *(uint64_t *)(s19 +0x10) */
    S[1] = *(uint64_t *)((uint8_t *)S[19] + 0x10);

L_0136:
    /* +0x01d10 op=0x25 1e 01 e0 03 ST64: *(s30 +0x3e0) = s1 q1=0x2a0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3e0) = S[1];

L_0137:
    /* +0x01d28 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x125fd3c0);

L_0138:
    /* +0x01d40 op=0x58 1e 05 98 01 LD64: s5 = *(uint64_t *)(s30 +0x198) q1=0x12627f80 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x198);

L_0139:
    /* +0x01d58 op=0x85 1e 04 c8 01 ADD64_IMM16: s4 = s30 +0x1c8 */
    S[4] = S[30] + 0x1c8;

L_013a:
    /* +0x01d70 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_013b:
    /* +0x01d88 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_013c:
    /* +0x01da0 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_013d:
    /* +0x01db8 op=0x58 1e 01 d8 01 LD64: s1 = *(uint64_t *)(s30 +0x1d8) q1=0x126b03f8 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x1d8);

L_013e:
    /* +0x01dd0 op=0x85 1e 10 80 01 ADD64_IMM16: s16 = s30 +0x180 q1=0x126601c0 */
    S[16] = S[30] + 0x180;

L_013f:
    /* +0x01de8 op=0x58 1e 05 00 00 LD64: s5 = *(uint64_t *)(s30 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x0);

L_0140:
    /* +0x01e00 op=0x58 1e 06 08 00 LD64: s6 = *(uint64_t *)(s30 +0x8) q1=0x4c0000000c */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_0141:
    /* +0x01e18 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0142:
    /* +0x01e30 op=0x25 1e 01 c8 03 ST64: *(s30 +0x3c8) = s1 q1=0x18c */
    *(uint64_t *)((uint8_t *)S[30] + 0x3c8) = S[1];

L_0143:
    /* +0x01e48 op=0x52 1e 01 d4 01 LD32S: s1 = *(int32_t *)(s30 +0x1d4) q1=0x126b0438 */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x1d4);

L_0144:
    /* +0x01e60 op=0x25 1e 01 c0 03 ST64: *(s30 +0x3c0) = s1 q1=0x125d72d8 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3c0) = S[1];

L_0145:
    /* +0x01e78 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_0146:
    /* +0x01e90 op=0x85 1e 11 98 01 ADD64_IMM16: s17 = s30 +0x198 q1=0x4d00000001 */
    S[17] = S[30] + 0x198;

L_0147:
    /* +0x01ea8 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_0148:
    /* +0x01ec0 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 q1=0x160 */
    S[6] = S[19] | S[0];

L_0149:
    /* +0x01ed8 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 q1=0x126b0478 */
    S[4] = S[17] | S[0];

L_014a:
    /* +0x01ef0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_014b:
    /* +0x01f08 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_014c:
    /* +0x01f20 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_014d:
    /* +0x01f38 op=0x85 1e 10 80 01 ADD64_IMM16: s16 = s30 +0x180 */
    S[16] = S[30] + 0x180;

L_014e:
    /* +0x01f50 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 q1=0xc8 */
    S[5] = S[17] | S[0];

L_014f:
    /* +0x01f68 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 q1=0x126b04b8 */
    S[4] = S[16] | S[0];

L_0150:
    /* +0x01f80 op=0x5e 6d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6d, (void *)(uintptr_t)0x125fd3c0);

L_0151:
    /* +0x01f98 op=0x85 1e 04 b0 01 ADD64_IMM16: s4 = s30 +0x1b0 */
    S[4] = S[30] + 0x1b0;

L_0152:
    /* +0x01fb0 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 q1=0x4f0000000d */
    S[5] = S[16] | S[0];

L_0153:
    /* +0x01fc8 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_0154:
    /* +0x01fe0 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 q1=0x124 */
    S[4] = S[16] | S[0];

L_0155:
    /* +0x01ff8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0156:
    /* +0x02010 op=0x58 1e 01 c0 01 LD64: s1 = *(uint64_t *)(s30 +0x1c0) q1=0x12627fa0 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x1c0);

L_0157:
    /* +0x02028 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0158:
    /* +0x02040 op=0x25 1e 01 d8 03 ST64: *(s30 +0x3d8) = s1 q1=0x5000000005 */
    *(uint64_t *)((uint8_t *)S[30] + 0x3d8) = S[1];

L_0159:
    /* +0x02058 op=0x52 1e 01 bc 01 LD32S: s1 = *(int32_t *)(s30 +0x1bc) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x1bc);

L_015a:
    /* +0x02070 op=0x25 1e 01 d0 03 ST64: *(s30 +0x3d0) = s1 q1=0x2cc */
    *(uint64_t *)((uint8_t *)S[30] + 0x3d0) = S[1];

L_015b:
    /* +0x02088 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_015c:
    /* +0x020a0 op=0x85 1e 10 10 03 ADD64_IMM16: s16 = s30 +0x310 q1=0x125d72f8 */
    S[16] = S[30] + 0x310;

L_015d:
    /* +0x020b8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_015e:
    /* +0x020d0 op=0x5e 1d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1d, (void *)(uintptr_t)0x125fd3c0);

L_015f:
    /* +0x020e8 op=0x85 00 15 00 00 ADD64_IMM16: s21 = s0 +0x0 */
    S[21] = S[0] + 0x0;

L_0160:
    /* +0x02100 op=0x34 02 00 06 01 OR64: s6 = s2 | s0 q1=0x2a0 */
    S[6] = S[2] | S[0];

L_0161:
    /* +0x02118 op=0x85 1e 04 98 01 ADD64_IMM16: s4 = s30 +0x198 q1=0x126b0578 */
    S[4] = S[30] + 0x198;

L_0162:
    /* +0x02130 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 q1=0x12627fc0 */
    S[5] = S[21] | S[0];

L_0163:
    /* +0x02148 op=0x5e 1e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1e] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1e, (void *)(uintptr_t)0x125fd3c0);

L_0164:
    /* +0x02160 op=0x58 1e 05 a8 01 LD64: s5 = *(uint64_t *)(s30 +0x1a8) q1=0x5200000005 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x1a8);

L_0165:
    /* +0x02178 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0166:
    /* +0x02190 op=0x5e 1f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1f] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1f, (void *)(uintptr_t)0x125fd3c0);

L_0167:
    /* +0x021a8 op=0x53 01 01 4f 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x4f q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x4f;

L_0168:
    /* +0x021c0 op=0x59 01 02 08 00 LD8U: s2 = *(uint8_t *)(s1 +0x8) q1=0x12660240 */
    S[2] = *(uint8_t *)((uint8_t *)S[1] + 0x8);

L_0169:
    /* +0x021d8 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_016a:
    /* +0x021f0 op=0x26 1e 02 78 01 ST8: *(s30 +0x178) = (uint8_t)s2 q1=0x530000000c */
    *(uint8_t *)((uint8_t *)S[30] + 0x178) = (uint8_t)S[2];

L_016b:
    /* +0x02208 op=0x25 1e 01 70 01 ST64: *(s30 +0x170) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x170) = S[1];

L_016c:
    /* +0x02220 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd3c0);

L_016d:
    /* +0x02238 op=0x85 1e 17 08 01 ADD64_IMM16: s23 = s30 +0x108 q1=0x126b05f8 */
    S[23] = S[30] + 0x108;

L_016e:
    /* +0x02250 op=0x18 11 02 10 00 SHL32_IMM: s16 = (int32_t)(s2 << 0) q1=0x125d7308 */
    S[16] = (int32_t)((uint32_t)S[2] << 0);

L_016f:
    /* +0x02268 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0170:
    /* +0x02280 op=0x0e 00 10 01 10 LSR32_IMM: s1 = sign_extend_32((uint32_t)s16 >> 16) q1=0x5400000001 */
    S[1] = (int32_t)((uint32_t)S[16] >> 16);

L_0171:
    /* +0x02298 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0172:
    /* +0x022b0 op=0x25 1e 01 18 00 ST64: *(s30 +0x18) = s1 q1=0x160 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[1];

L_0173:
    /* +0x022c8 op=0x19 1e 01 6c 01 ST16: *(s30 +0x16c) = (uint16_t)s1 q1=0x126b0638 */
    *(uint16_t *)((uint8_t *)S[30] + 0x16c) = (uint16_t)S[1];

L_0174:
    /* +0x022e0 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd3c0);

L_0175:
    /* +0x022f8 op=0x85 1e 04 70 01 ADD64_IMM16: s4 = s30 +0x170 q1=0x125d7320 */
    S[4] = S[30] + 0x170;

L_0176:
    /* +0x02310 op=0x85 00 05 09 00 ADD64_IMM16: s5 = s0 +0x9 q1=0x550000000e */
    S[5] = S[0] + 0x9;

L_0177:
    /* +0x02328 op=0x58 1e 13 08 01 LD64: s19 = *(uint64_t *)(s30 +0x108) */
    S[19] = *(uint64_t *)((uint8_t *)S[30] + 0x108);

L_0178:
    /* +0x02340 op=0x5e 20 00 00 00 CALL_CF_INDEX: call native_binding[index=0x20] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x20, (void *)(uintptr_t)0x125fd3c0);

L_0179:
    /* +0x02358 op=0x85 1e 14 50 01 ADD64_IMM16: s20 = s30 +0x150 q1=0x126b0678 */
    S[20] = S[30] + 0x150;

L_017a:
    /* +0x02370 op=0x34 02 00 05 01 OR64: s5 = s2 | s0 q1=0x12627fe0 */
    S[5] = S[2] | S[0];

L_017b:
    /* +0x02388 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_017c:
    /* +0x023a0 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x125fd3c0);

L_017d:
    /* +0x023b8 op=0x85 1e 11 20 01 ADD64_IMM16: s17 = s30 +0x120 */
    S[17] = S[30] + 0x120;

L_017e:
    /* +0x023d0 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 q1=0x378 */
    S[5] = S[19] | S[0];

L_017f:
    /* +0x023e8 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 q1=0x126b06b8 */
    S[6] = S[20] | S[0];

L_0180:
    /* +0x02400 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x1267a000 */
    S[4] = S[17] | S[0];

L_0181:
    /* +0x02418 op=0x5e 21 00 00 00 CALL_CF_INDEX: call native_binding[index=0x21] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x21, (void *)(uintptr_t)0x125fd3c0);

L_0182:
    /* +0x02430 op=0x85 1e 13 38 01 ADD64_IMM16: s19 = s30 +0x138 q1=0x5700000005 */
    S[19] = S[30] + 0x138;

L_0183:
    /* +0x02448 op=0x58 1e 05 20 01 LD64: s5 = *(uint64_t *)(s30 +0x120) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x120);

L_0184:
    /* +0x02460 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x88 */
    S[4] = S[19] | S[0];

L_0185:
    /* +0x02478 op=0x5e 22 00 00 00 CALL_CF_INDEX: call native_binding[index=0x22] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x22, (void *)(uintptr_t)0x125fd3c0);

L_0186:
    /* +0x02490 op=0x85 1e 16 80 01 ADD64_IMM16: s22 = s30 +0x180 q1=0x1267a020 */
    S[22] = S[30] + 0x180;

L_0187:
    /* +0x024a8 op=0x58 1e 05 38 01 LD64: s5 = *(uint64_t *)(s30 +0x138) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x138);

L_0188:
    /* +0x024c0 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 q1=0x5800000011 */
    S[4] = S[22] | S[0];

L_0189:
    /* +0x024d8 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_018a:
    /* +0x024f0 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x378 */
    S[4] = S[19] | S[0];

L_018b:
    /* +0x02508 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_018c:
    /* +0x02520 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x1267a040 */
    S[4] = S[17] | S[0];

L_018d:
    /* +0x02538 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_018e:
    /* +0x02550 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 q1=0x5900000005 */
    S[4] = S[20] | S[0];

L_018f:
    /* +0x02568 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0190:
    /* +0x02580 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 q1=0x88 */
    S[4] = S[23] | S[0];

L_0191:
    /* +0x02598 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd3c0);

L_0192:
    /* +0x025b0 op=0x85 1e 11 38 01 ADD64_IMM16: s17 = s30 +0x138 q1=0x1267a060 */
    S[17] = S[30] + 0x138;

L_0193:
    /* +0x025c8 op=0x85 00 13 10 00 ADD64_IMM16: s19 = s0 +0x10 */
    S[19] = S[0] + 0x10;

L_0194:
    /* +0x025e0 op=0x58 1e 05 90 01 LD64: s5 = *(uint64_t *)(s30 +0x190) q1=0x5a00000011 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x190);

L_0195:
    /* +0x025f8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0196:
    /* +0x02610 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 q1=0x378 */
    S[6] = S[19] | S[0];

L_0197:
    /* +0x02628 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_0198:
    /* +0x02640 op=0x85 1e 14 20 01 ADD64_IMM16: s20 = s30 +0x120 q1=0x1267a080 */
    S[20] = S[30] + 0x120;

L_0199:
    /* +0x02658 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_019a:
    /* +0x02670 op=0x34 15 00 06 00 OR64: s6 = s21 | s0 q1=0x5b00000005 */
    S[6] = S[21] | S[0];

L_019b:
    /* +0x02688 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_019c:
    /* +0x026a0 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x125fd3c0);

L_019d:
    /* +0x026b8 op=0x58 1e 05 20 01 LD64: s5 = *(uint64_t *)(s30 +0x120) q1=0x126b07f8 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x120);

L_019e:
    /* +0x026d0 op=0x85 1e 04 50 01 ADD64_IMM16: s4 = s30 +0x150 q1=0x1267a0a0 */
    S[4] = S[30] + 0x150;

L_019f:
    /* +0x026e8 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_01a0:
    /* +0x02700 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 q1=0x5c00000011 */
    S[4] = S[20] | S[0];

L_01a1:
    /* +0x02718 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_01a2:
    /* +0x02730 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 q1=0x378 */
    S[4] = S[17] | S[0];

L_01a3:
    /* +0x02748 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01a4:
    /* +0x02760 op=0x58 1e 01 90 01 LD64: s1 = *(uint64_t *)(s30 +0x190) q1=0x1267a0c0 */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x190);

L_01a5:
    /* +0x02778 op=0x85 1e 11 20 01 ADD64_IMM16: s17 = s30 +0x120 */
    S[17] = S[30] + 0x120;

L_01a6:
    /* +0x02790 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 q1=0x5d00000005 */
    S[6] = S[19] | S[0];

L_01a7:
    /* +0x027a8 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_01a8:
    /* +0x027c0 op=0x85 01 05 10 00 ADD64_IMM16: s5 = s1 +0x10 q1=0x88 */
    S[5] = S[1] + 0x10;

L_01a9:
    /* +0x027d8 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_01aa:
    /* +0x027f0 op=0x85 1e 13 08 01 ADD64_IMM16: s19 = s30 +0x108 q1=0x1267a0e0 */
    S[19] = S[30] + 0x108;

L_01ab:
    /* +0x02808 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_01ac:
    /* +0x02820 op=0x34 15 00 06 00 OR64: s6 = s21 | s0 q1=0x5e00000011 */
    S[6] = S[21] | S[0];

L_01ad:
    /* +0x02838 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_01ae:
    /* +0x02850 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x125fd3c0);

L_01af:
    /* +0x02868 op=0x58 1e 05 08 01 LD64: s5 = *(uint64_t *)(s30 +0x108) q1=0x126b08b8 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x108);

L_01b0:
    /* +0x02880 op=0x85 1e 04 38 01 ADD64_IMM16: s4 = s30 +0x138 q1=0x1267a100 */
    S[4] = S[30] + 0x138;

L_01b1:
    /* +0x02898 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_01b2:
    /* +0x028b0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x5f00000005 */
    S[4] = S[19] | S[0];

L_01b3:
    /* +0x028c8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_01b4:
    /* +0x028e0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x88 */
    S[4] = S[17] | S[0];

L_01b5:
    /* +0x028f8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01b6:
    /* +0x02910 op=0x85 1e 11 d8 00 ADD64_IMM16: s17 = s30 +0xd8 q1=0x1267a120 */
    S[17] = S[30] + 0xd8;

L_01b7:
    /* +0x02928 op=0x85 1e 05 20 01 ADD64_IMM16: s5 = s30 +0x120 */
    S[5] = S[30] + 0x120;

L_01b8:
    /* +0x02940 op=0x85 00 06 04 00 ADD64_IMM16: s6 = s0 +0x4 q1=0x6000000011 */
    S[6] = S[0] + 0x4;

L_01b9:
    /* +0x02958 op=0x25 1e 10 20 00 ST64: *(s30 +0x20) = s16 */
    *(uint64_t *)((uint8_t *)S[30] + 0x20) = S[16];

L_01ba:
    /* +0x02970 op=0x08 1e 10 20 01 ST32: *(s30 +0x120) = (uint32_t)s16 q1=0x378 */
    *(uint32_t *)((uint8_t *)S[30] + 0x120) = (uint32_t)S[16];

L_01bb:
    /* +0x02988 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 q1=0x126b0938 */
    S[4] = S[17] | S[0];

L_01bc:
    /* +0x029a0 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_01bd:
    /* +0x029b8 op=0x85 1e 13 f0 00 ADD64_IMM16: s19 = s30 +0xf0 */
    S[19] = S[30] + 0xf0;

L_01be:
    /* +0x029d0 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 q1=0x6100000005 */
    S[5] = S[22] | S[0];

L_01bf:
    /* +0x029e8 op=0x34 11 00 06 01 OR64: s6 = s17 | s0 */
    S[6] = S[17] | S[0];

L_01c0:
    /* +0x02a00 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x88 */
    S[4] = S[19] | S[0];

L_01c1:
    /* +0x02a18 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_01c2:
    /* +0x02a30 op=0x85 1e 14 08 01 ADD64_IMM16: s20 = s30 +0x108 q1=0x125d7338 */
    S[20] = S[30] + 0x108;

L_01c3:
    /* +0x02a48 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_01c4:
    /* +0x02a60 op=0x34 16 00 06 01 OR64: s6 = s22 | s0 q1=0x6200000001 */
    S[6] = S[22] | S[0];

L_01c5:
    /* +0x02a78 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_01c6:
    /* +0x02a90 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_01c7:
    /* +0x02aa8 op=0x85 1e 04 20 01 ADD64_IMM16: s4 = s30 +0x120 q1=0x126b09b8 */
    S[4] = S[30] + 0x120;

L_01c8:
    /* +0x02ac0 op=0x34 14 00 05 01 OR64: s5 = s20 | s0 q1=0x1267a160 */
    S[5] = S[20] | S[0];

L_01c9:
    /* +0x02ad8 op=0x5e 6d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6d, (void *)(uintptr_t)0x125fd3c0);

L_01ca:
    /* +0x02af0 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 q1=0x6300000005 */
    S[4] = S[20] | S[0];

L_01cb:
    /* +0x02b08 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01cc:
    /* +0x02b20 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x12e4 */
    S[4] = S[19] | S[0];

L_01cd:
    /* +0x02b38 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01ce:
    /* +0x02b50 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x125d7348 */
    S[4] = S[17] | S[0];

L_01cf:
    /* +0x02b68 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01d0:
    /* +0x02b80 op=0x52 1e 05 8c 01 LD32S: s5 = *(int32_t *)(s30 +0x18c) q1=0x6400000001 */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x18c);

L_01d1:
    /* +0x02b98 op=0x58 1e 04 90 01 LD64: s4 = *(uint64_t *)(s30 +0x190) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x190);

L_01d2:
    /* +0x02bb0 op=0x5e 69 00 00 00 CALL_CF_INDEX: call native_binding[index=0x69] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x69, (void *)(uintptr_t)0x125fd3c0);

L_01d3:
    /* +0x02bc8 op=0x85 1e 04 08 01 ADD64_IMM16: s4 = s30 +0x108 q1=0x126b0a38 */
    S[4] = S[30] + 0x108;

L_01d4:
    /* +0x02be0 op=0x26 1e 02 d4 00 ST8: *(s30 +0xd4) = (uint8_t)s2 q1=0x1267a180 */
    *(uint8_t *)((uint8_t *)S[30] + 0xd4) = (uint8_t)S[2];

L_01d5:
    /* +0x02bf8 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_01d6:
    /* +0x02c10 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 q1=0x6500000005 */
    S[4] = S[18] | S[0];

L_01d7:
    /* +0x02c28 op=0x5e 25 00 00 00 CALL_CF_INDEX: call native_binding[index=0x25] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x25, (void *)(uintptr_t)0x125fd3c0);

L_01d8:
    /* +0x02c40 op=0x52 02 01 00 00 LD32S: s1 = *(int32_t *)(s2 +0x0) q1=0x12d4 */
    S[1] = *(int32_t *)((uint8_t *)S[2] + 0x0);

L_01d9:
    /* +0x02c58 op=0xb5 00 02 01 00 ADD32_IMM16: s2 = int32(s0 +0x1) q1=0x126b0a78 */
    S[2] = (int32_t)((uint32_t)S[0] + 0x1);

L_01da:
    /* +0x02c70 op=0xa7 01 02 1a 00 BR_NE64: if (s1 != s2) goto record +501 q1=0x125d7358 */
    if (S[1] != S[2]) goto L_01f5;

L_01db:
    /* +0x02c88 op=0x85 1e 11 f0 00 ADD64_IMM16: s17 = s30 +0xf0 */
    S[17] = S[30] + 0xf0;

L_01dc:
    /* +0x02ca0 op=0x58 1e 06 38 00 LD64: s6 = *(uint64_t *)(s30 +0x38) q1=0x6600000001 */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_01dd:
    /* +0x02cb8 op=0x85 1e 05 98 01 ADD64_IMM16: s5 = s30 +0x198 */
    S[5] = S[30] + 0x198;

L_01de:
    /* +0x02cd0 op=0x25 1e 00 e0 00 ST64: *(s30 +0xe0) = s0 q1=0xfcc */
    *(uint64_t *)((uint8_t *)S[30] + 0xe0) = S[0];

L_01df:
    /* +0x02ce8 op=0x25 1e 00 d8 00 ST64: *(s30 +0xd8) = s0 q1=0x126b0ab8 */
    *(uint64_t *)((uint8_t *)S[30] + 0xd8) = S[0];

L_01e0:
    /* +0x02d00 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 q1=0x1267a1a0 */
    S[4] = S[17] | S[0];

L_01e1:
    /* +0x02d18 op=0x5e 26 00 00 00 CALL_CF_INDEX: call native_binding[index=0x26] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x26, (void *)(uintptr_t)0x125fd3c0);

L_01e2:
    /* +0x02d30 op=0x85 1e 13 d8 00 ADD64_IMM16: s19 = s30 +0xd8 q1=0x6700000005 */
    S[19] = S[30] + 0xd8;

L_01e3:
    /* +0x02d48 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_01e4:
    /* +0x02d60 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x12d0 */
    S[4] = S[19] | S[0];

L_01e5:
    /* +0x02d78 op=0x5e 27 00 00 00 CALL_CF_INDEX: call native_binding[index=0x27] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x27, (void *)(uintptr_t)0x125fd3c0);

L_01e6:
    /* +0x02d90 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x125d7368 */
    S[4] = S[17] | S[0];

L_01e7:
    /* +0x02da8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_01e8:
    /* +0x02dc0 op=0x85 1e 11 f0 00 ADD64_IMM16: s17 = s30 +0xf0 q1=0x6800000001 */
    S[17] = S[30] + 0xf0;

L_01e9:
    /* +0x02dd8 op=0x58 1e 06 d8 00 LD64: s6 = *(uint64_t *)(s30 +0xd8) */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0xd8);

L_01ea:
    /* +0x02df0 op=0x58 1e 05 40 00 LD64: s5 = *(uint64_t *)(s30 +0x40) q1=0xff0 */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_01eb:
    /* +0x02e08 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x126b0b38 */
    S[4] = S[17] | S[0];

L_01ec:
    /* +0x02e20 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_01ed:
    /* +0x02e38 op=0x85 1e 04 08 01 ADD64_IMM16: s4 = s30 +0x108 */
    S[4] = S[30] + 0x108;

L_01ee:
    /* +0x02e50 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 q1=0x6900000005 */
    S[5] = S[17] | S[0];

L_01ef:
    /* +0x02e68 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_01f0:
    /* +0x02e80 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 q1=0x12e4 */
    S[4] = S[17] | S[0];

L_01f1:
    /* +0x02e98 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_01f2:
    /* +0x02eb0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 q1=0x125d7378 */
    S[4] = S[19] | S[0];

L_01f3:
    /* +0x02ec8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_01f4:
    /* +0x02ee0 op=0x5f 17 00 00 00 ADD_PC_IMM32: goto record +524 ; vm_pc = current_pc + 1 + 23 q1=0x6a00000001 */
    goto L_020c;

L_01f5:
    /* +0x02ef8 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_01f6:
    /* +0x02f10 op=0x5e 25 00 00 00 CALL_CF_INDEX: call native_binding[index=0x25] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x25, (void *)(uintptr_t)0x125fd3c0);

L_01f7:
    /* +0x02f28 op=0x52 02 01 00 00 LD32S: s1 = *(int32_t *)(s2 +0x0) q1=0x126b0bb8 */
    S[1] = *(int32_t *)((uint8_t *)S[2] + 0x0);

L_01f8:
    /* +0x02f40 op=0xa7 01 00 13 00 BR_NE64: if (s1 != s0) goto record +524 q1=0x1267a1e0 */
    if (S[1] != S[0]) goto L_020c;

L_01f9:
    /* +0x02f58 op=0x85 1e 11 f0 00 ADD64_IMM16: s17 = s30 +0xf0 */
    S[17] = S[30] + 0xf0;

L_01fa:
    /* +0x02f70 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x6b00000005 */
    S[4] = S[17] | S[0];

L_01fb:
    /* +0x02f88 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_01fc:
    /* +0x02fa0 op=0x85 1e 04 98 01 ADD64_IMM16: s4 = s30 +0x198 q1=0x12e8 */
    S[4] = S[30] + 0x198;

L_01fd:
    /* +0x02fb8 op=0x85 1e 06 20 01 ADD64_IMM16: s6 = s30 +0x120 q1=0x126b0bf8 */
    S[6] = S[30] + 0x120;

L_01fe:
    /* +0x02fd0 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 q1=0x125d7388 */
    S[5] = S[17] | S[0];

L_01ff:
    /* +0x02fe8 op=0x5e 28 00 00 00 CALL_CF_INDEX: call native_binding[index=0x28] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x28, (void *)(uintptr_t)0x125fd3c0);

L_0200:
    /* +0x03000 op=0x85 1e 13 d8 00 ADD64_IMM16: s19 = s30 +0xd8 q1=0x6c00000001 */
    S[19] = S[30] + 0xd8;

L_0201:
    /* +0x03018 op=0x58 1e 05 40 00 LD64: s5 = *(uint64_t *)(s30 +0x40) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_0202:
    /* +0x03030 op=0x34 11 00 06 01 OR64: s6 = s17 | s0 q1=0xfd4 */
    S[6] = S[17] | S[0];

L_0203:
    /* +0x03048 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 q1=0x126b0c38 */
    S[4] = S[19] | S[0];

L_0204:
    /* +0x03060 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_0205:
    /* +0x03078 op=0x85 1e 04 08 01 ADD64_IMM16: s4 = s30 +0x108 */
    S[4] = S[30] + 0x108;

L_0206:
    /* +0x03090 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0207:
    /* +0x030a8 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table runtime: CF10 copyMemBlockData q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x125fd3c0);

L_0208:
    /* +0x030c0 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0209:
    /* +0x030d8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_020a:
    /* +0x030f0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_020b:
    /* +0x03108 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_020c:
    /* +0x03120 op=0x85 1e 04 6c 01 ADD64_IMM16: s4 = s30 +0x16c */
    S[4] = S[30] + 0x16c;

L_020d:
    /* +0x03138 op=0x85 00 05 02 00 ADD64_IMM16: s5 = s0 +0x2 */
    S[5] = S[0] + 0x2;

L_020e:
    /* +0x03150 op=0x5e 69 00 00 00 CALL_CF_INDEX: call native_binding[index=0x69] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x69, (void *)(uintptr_t)0x125fd3c0);

L_020f:
    /* +0x03168 op=0x18 11 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_0210:
    /* +0x03180 op=0x52 1e 06 14 01 LD32S: s6 = *(int32_t *)(s30 +0x114) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x114);

L_0211:
    /* +0x03198 op=0x85 1e 04 f0 00 ADD64_IMM16: s4 = s30 +0xf0 */
    S[4] = S[30] + 0xf0;

L_0212:
    /* +0x031b0 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0213:
    /* +0x031c8 op=0x00 01 01 01 03 REV16_32: s1 = sign_extend_32(rev16((uint32_t)s1)) */
    S[1] = (int32_t)rev16_32((uint32_t)S[1]);

L_0214:
    /* +0x031e0 op=0x2e 12 01 01 10 ROR32_IMM: s1 = ror32((uint32_t)s1, 16) */
    S[1] = ror32((uint32_t)S[1], 16);

L_0215:
    /* +0x031f8 op=0x08 1e 01 d0 00 ST32: *(s30 +0xd0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xd0) = (uint32_t)S[1];

L_0216:
    /* +0x03210 op=0x5e 1e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1e] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1e, (void *)(uintptr_t)0x125fd3c0);

L_0217:
    /* +0x03228 op=0x52 1e 01 14 01 LD32S: s1 = *(int32_t *)(s30 +0x114) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x114);

L_0218:
    /* +0x03240 op=0x85 1e 04 d0 00 ADD64_IMM16: s4 = s30 +0xd0 */
    S[4] = S[30] + 0xd0;

L_0219:
    /* +0x03258 op=0x15 01 02 01 00 CMP_LT_IMM64S: s2 = ((int64_t)s1 < 1) ? 1 : 0 */
    S[2] = ((int64_t)S[1] < 0x1) ? 1 : 0;

L_021a:
    /* +0x03270 op=0xb5 01 03 ff ff ADD32_IMM16: s3 = int32(s1 -0x1) */
    S[3] = (int32_t)((uint32_t)S[1] + (-0x1));

L_021b:
    /* +0x03288 op=0x1f 01 02 02 00 CMOVZ64: s2 = (s2 == 0) ? s1 : 0 */
    S[2] = (S[2] == 0) ? S[1] : 0;

L_021c:
    /* +0x032a0 op=0x6d 00 02 02 00 SHL64_IMM32PLUS: s2 = s2 << (0 + 32) */
    S[2] = S[2] << (0 + 32);

L_021d:
    /* +0x032b8 op=0x67 00 02 02 00 LSR64_IMM32PLUS: s2 = (uint64_t)s2 >> (0 + 32) */
    S[2] = (uint64_t)S[2] >> (0 + 32);

L_021e:
    /* +0x032d0 op=0xae 02 15 0e 00 BR_EQ64: if (s2 == s21) goto record +557 */
    if (S[2] == S[21]) goto L_022d;

L_021f:
    /* +0x032e8 op=0x58 1e 05 18 01 LD64: s5 = *(uint64_t *)(s30 +0x118) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x118);

L_0220:
    /* +0x03300 op=0x18 00 03 01 00 SHL32_IMM: s1 = (int32_t)(s3 << 0) */
    S[1] = (int32_t)((uint32_t)S[3] << 0);

L_0221:
    /* +0x03318 op=0xb5 03 03 ff ff ADD32_IMM16: s3 = int32(s3 -0x1) */
    S[3] = (int32_t)((uint32_t)S[3] + (-0x1));

L_0222:
    /* +0x03330 op=0x84 05 01 01 00 ADD64: s1 = s5 + s1 */
    S[1] = S[5] + S[1];

L_0223:
    /* +0x03348 op=0xb2 15 05 03 00 AND64_IMM16: s5 = s21 & 0x3 */
    S[5] = S[21] & 0x3;

L_0224:
    /* +0x03360 op=0x34 04 05 05 01 OR64: s5 = s4 | s5 */
    S[5] = S[4] | S[5];

L_0225:
    /* +0x03378 op=0x59 01 01 00 00 LD8U: s1 = *(uint8_t *)(s1 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0226:
    /* +0x03390 op=0x59 05 05 00 00 LD8U: s5 = *(uint8_t *)(s5 +0x0) */
    S[5] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0227:
    /* +0x033a8 op=0x02 05 01 01 01 XOR64: s1 = s1 ^ s5 */
    S[1] = S[1] ^ S[5];

L_0228:
    /* +0x033c0 op=0x58 1e 05 00 01 LD64: s5 = *(uint64_t *)(s30 +0x100) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x100);

L_0229:
    /* +0x033d8 op=0x84 05 15 05 00 ADD64: s5 = s5 + s21 */
    S[5] = S[5] + S[21];

L_022a:
    /* +0x033f0 op=0x85 15 15 01 00 ADD64_IMM16: s21 = s21 +0x1 */
    S[21] = S[21] + 0x1;

L_022b:
    /* +0x03408 op=0x26 05 01 00 00 ST8: *(s5 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[5] + 0x0) = (uint8_t)S[1];

L_022c:
    /* +0x03420 op=0xa7 02 15 f2 ff BR_NE64: if (s2 != s21) goto record +543 */
    if (S[2] != S[21]) goto L_021f;

L_022d:
    /* +0x03438 op=0x58 1e 01 08 03 LD64: s1 = *(uint64_t *)(s30 +0x308) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x308);

L_022e:
    /* +0x03450 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_022f:
    /* +0x03468 op=0x59 01 10 00 00 LD8U: s16 = *(uint8_t *)(s1 +0x0) */
    S[16] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0230:
    /* +0x03480 op=0x58 1e 01 f0 02 LD64: s1 = *(uint64_t *)(s30 +0x2f0) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x2f0);

L_0231:
    /* +0x03498 op=0x59 01 11 00 00 LD8U: s17 = *(uint8_t *)(s1 +0x0) */
    S[17] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_0232:
    /* +0x034b0 op=0x5e 25 00 00 00 CALL_CF_INDEX: call native_binding[index=0x25] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x25, (void *)(uintptr_t)0x125fd3c0);

L_0233:
    /* +0x034c8 op=0x52 02 01 00 00 LD32S: s1 = *(int32_t *)(s2 +0x0) */
    S[1] = *(int32_t *)((uint8_t *)S[2] + 0x0);

L_0234:
    /* +0x034e0 op=0xb2 11 02 3f 00 AND64_IMM16: s2 = s17 & 0x3f */
    S[2] = S[17] & 0x3f;

L_0235:
    /* +0x034f8 op=0xb2 10 03 3f 00 AND64_IMM16: s3 = s16 & 0x3f */
    S[3] = S[16] & 0x3f;

L_0236:
    /* +0x03510 op=0x85 00 04 03 00 ADD64_IMM16: s4 = s0 +0x3 */
    S[4] = S[0] + 0x3;

L_0237:
    /* +0x03528 op=0x85 00 11 01 00 ADD64_IMM16: s17 = s0 +0x1 */
    S[17] = S[0] + 0x1;

L_0238:
    /* +0x03540 op=0x85 1e 15 80 00 ADD64_IMM16: s21 = s30 +0x80 */
    S[21] = S[30] + 0x80;

L_0239:
    /* +0x03558 op=0x85 1e 13 d4 00 ADD64_IMM16: s19 = s30 +0xd4 */
    S[19] = S[30] + 0xd4;

L_023a:
    /* +0x03570 op=0x6d 00 02 02 08 SHL64_IMM32PLUS: s2 = s2 << (8 + 32) */
    S[2] = S[2] << (8 + 32);

L_023b:
    /* +0x03588 op=0x6d 00 03 03 0e SHL64_IMM32PLUS: s3 = s3 << (14 + 32) */
    S[3] = S[3] << (14 + 32);

L_023c:
    /* +0x035a0 op=0x6d 00 04 10 1b SHL64_IMM32PLUS: s16 = s4 << (27 + 32) */
    S[16] = S[4] << (27 + 32);

L_023d:
    /* +0x035b8 op=0x6d 00 11 04 01 SHL64_IMM32PLUS: s4 = s17 << (1 + 32) */
    S[4] = S[17] << (1 + 32);

L_023e:
    /* +0x035d0 op=0x01 01 01 01 00 XOR_IMM16: s1 = s1 ^ 0x1 */
    S[1] = S[1] ^ 0x1;

L_023f:
    /* +0x035e8 op=0x34 03 02 02 00 OR64: s2 = s3 | s2 */
    S[2] = S[3] | S[2];

L_0240:
    /* +0x03600 op=0x6d 00 11 03 00 SHL64_IMM32PLUS: s3 = s17 << (0 + 32) */
    S[3] = S[17] << (0 + 32);

L_0241:
    /* +0x03618 op=0x18 00 01 01 00 SHL32_IMM: s1 = (int32_t)(s1 << 0) */
    S[1] = (int32_t)((uint32_t)S[1] << 0);

L_0242:
    /* +0x03630 op=0x85 03 12 ff ff ADD64_IMM16: s18 = s3 -0x1 */
    S[18] = S[3] + (-0x1);

L_0243:
    /* +0x03648 op=0x1e 03 01 03 11 CMOVNZ64: s3 = (s1 != 0) ? s3 : 0 */
    S[3] = (S[1] != 0) ? S[3] : 0;

L_0244:
    /* +0x03660 op=0x1f 04 01 01 00 CMOVZ64: s1 = (s1 == 0) ? s4 : 0 */
    S[1] = (S[1] == 0) ? S[4] : 0;

L_0245:
    /* +0x03678 op=0x34 01 03 01 01 OR64: s1 = s1 | s3 */
    S[1] = S[1] | S[3];

L_0246:
    /* +0x03690 op=0x34 02 01 14 00 OR64: s20 = s2 | s1 */
    S[20] = S[2] | S[1];

L_0247:
    /* +0x036a8 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd3c0);

L_0248:
    /* +0x036c0 op=0xb3 02 12 01 00 AND64: s1 = s2 & s18 */
    S[1] = S[2] & S[18];

L_0249:
    /* +0x036d8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_024a:
    /* +0x036f0 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_024b:
    /* +0x03708 op=0x34 11 00 06 01 OR64: s6 = s17 | s0 */
    S[6] = S[17] | S[0];

L_024c:
    /* +0x03720 op=0x34 14 01 01 00 OR64: s1 = s20 | s1 */
    S[1] = S[20] | S[1];

L_024d:
    /* +0x03738 op=0x34 01 10 01 01 OR64: s1 = s1 | s16 */
    S[1] = S[1] | S[16];

L_024e:
    /* +0x03750 op=0x25 1e 01 c8 00 ST64: *(s30 +0xc8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0xc8) = S[1];

L_024f:
    /* +0x03768 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_0250:
    /* +0x03780 op=0x85 1e 16 68 00 ADD64_IMM16: s22 = s30 +0x68 */
    S[22] = S[30] + 0x68;

L_0251:
    /* +0x03798 op=0x85 1e 05 c8 00 ADD64_IMM16: s5 = s30 +0xc8 */
    S[5] = S[30] + 0xc8;

L_0252:
    /* +0x037b0 op=0x85 00 06 08 00 ADD64_IMM16: s6 = s0 +0x8 */
    S[6] = S[0] + 0x8;

L_0253:
    /* +0x037c8 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_0254:
    /* +0x037e0 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_0255:
    /* +0x037f8 op=0x85 1e 17 98 00 ADD64_IMM16: s23 = s30 +0x98 */
    S[23] = S[30] + 0x98;

L_0256:
    /* +0x03810 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0257:
    /* +0x03828 op=0x34 16 00 06 01 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_0258:
    /* +0x03840 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0259:
    /* +0x03858 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_025a:
    /* +0x03870 op=0x85 1e 10 b0 00 ADD64_IMM16: s16 = s30 +0xb0 */
    S[16] = S[30] + 0xb0;

L_025b:
    /* +0x03888 op=0x85 1e 06 f0 00 ADD64_IMM16: s6 = s30 +0xf0 */
    S[6] = S[30] + 0xf0;

L_025c:
    /* +0x038a0 op=0x34 17 00 05 00 OR64: s5 = s23 | s0 */
    S[5] = S[23] | S[0];

L_025d:
    /* +0x038b8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_025e:
    /* +0x038d0 op=0x25 1e 06 40 00 ST64: *(s30 +0x40) = s6 */
    *(uint64_t *)((uint8_t *)S[30] + 0x40) = S[6];

L_025f:
    /* +0x038e8 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_0260:
    /* +0x03900 op=0x85 1e 14 50 00 ADD64_IMM16: s20 = s30 +0x50 */
    S[20] = S[30] + 0x50;

L_0261:
    /* +0x03918 op=0x58 1e 05 18 00 LD64: s5 = *(uint64_t *)(s30 +0x18) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_0262:
    /* +0x03930 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0263:
    /* +0x03948 op=0x5e 29 00 00 00 CALL_CF_INDEX: call native_binding[index=0x29] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x29, (void *)(uintptr_t)0x125fd3c0);

L_0264:
    /* +0x03960 op=0x85 1e 11 d8 00 ADD64_IMM16: s17 = s30 +0xd8 */
    S[17] = S[30] + 0xd8;

L_0265:
    /* +0x03978 op=0x34 10 00 05 00 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_0266:
    /* +0x03990 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_0267:
    /* +0x039a8 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0268:
    /* +0x039c0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_0269:
    /* +0x039d8 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_026a:
    /* +0x039f0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_026b:
    /* +0x03a08 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_026c:
    /* +0x03a20 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_026d:
    /* +0x03a38 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_026e:
    /* +0x03a50 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_026f:
    /* +0x03a68 op=0x34 16 00 04 00 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_0270:
    /* +0x03a80 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0271:
    /* +0x03a98 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0272:
    /* +0x03ab0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0273:
    /* +0x03ac8 op=0x85 1e 10 98 00 ADD64_IMM16: s16 = s30 +0x98 */
    S[16] = S[30] + 0x98;

L_0274:
    /* +0x03ae0 op=0x85 1e 15 50 01 ADD64_IMM16: s21 = s30 +0x150 */
    S[21] = S[30] + 0x150;

L_0275:
    /* +0x03af8 op=0x85 1e 16 38 01 ADD64_IMM16: s22 = s30 +0x138 */
    S[22] = S[30] + 0x138;

L_0276:
    /* +0x03b10 op=0xb5 00 01 01 00 ADD32_IMM16: s1 = int32(s0 +0x1) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x1);

L_0277:
    /* +0x03b28 op=0x85 1e 08 80 00 ADD64_IMM16: s8 = s30 +0x80 */
    S[8] = S[30] + 0x80;

L_0278:
    /* +0x03b40 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0279:
    /* +0x03b58 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_027a:
    /* +0x03b70 op=0x34 15 00 06 01 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_027b:
    /* +0x03b88 op=0x34 16 00 07 01 OR64: s7 = s22 | s0 */
    S[7] = S[22] | S[0];

L_027c:
    /* +0x03ba0 op=0x08 1e 01 80 00 ST32: *(s30 +0x80) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x80) = (uint32_t)S[1];

L_027d:
    /* +0x03bb8 op=0x5e 2a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2a] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2a, (void *)(uintptr_t)0x125fd3c0);

L_027e:
    /* +0x03bd0 op=0x85 1e 17 b0 00 ADD64_IMM16: s23 = s30 +0xb0 */
    S[23] = S[30] + 0xb0;

L_027f:
    /* +0x03be8 op=0x58 1e 05 98 00 LD64: s5 = *(uint64_t *)(s30 +0x98) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x98);

L_0280:
    /* +0x03c00 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0281:
    /* +0x03c18 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_0282:
    /* +0x03c30 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0283:
    /* +0x03c48 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0284:
    /* +0x03c60 op=0x85 1e 14 68 00 ADD64_IMM16: s20 = s30 +0x68 */
    S[20] = S[30] + 0x68;

L_0285:
    /* +0x03c78 op=0x58 1e 05 20 00 LD64: s5 = *(uint64_t *)(s30 +0x20) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_0286:
    /* +0x03c90 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0287:
    /* +0x03ca8 op=0x5e 29 00 00 00 CALL_CF_INDEX: call native_binding[index=0x29] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x29, (void *)(uintptr_t)0x125fd3c0);

L_0288:
    /* +0x03cc0 op=0x85 1e 12 80 00 ADD64_IMM16: s18 = s30 +0x80 */
    S[18] = S[30] + 0x80;

L_0289:
    /* +0x03cd8 op=0x34 14 00 05 01 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_028a:
    /* +0x03cf0 op=0x34 17 00 06 00 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_028b:
    /* +0x03d08 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_028c:
    /* +0x03d20 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_028d:
    /* +0x03d38 op=0x85 1e 13 50 00 ADD64_IMM16: s19 = s30 +0x50 */
    S[19] = S[30] + 0x50;

L_028e:
    /* +0x03d50 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_028f:
    /* +0x03d68 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0290:
    /* +0x03d80 op=0x5e 2b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2b] via q1 table runtime: CF44 base64Encode q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2b, (void *)(uintptr_t)0x125fd3c0);

L_0291:
    /* +0x03d98 op=0x85 1e 10 98 00 ADD64_IMM16: s16 = s30 +0x98 */
    S[16] = S[30] + 0x98;

L_0292:
    /* +0x03db0 op=0x58 1e 05 50 00 LD64: s5 = *(uint64_t *)(s30 +0x50) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x50);

L_0293:
    /* +0x03dc8 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0294:
    /* +0x03de0 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_0295:
    /* +0x03df8 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0296:
    /* +0x03e10 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0297:
    /* +0x03e28 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0298:
    /* +0x03e40 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0299:
    /* +0x03e58 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_029a:
    /* +0x03e70 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_029b:
    /* +0x03e88 op=0x58 1e 03 48 00 LD64: s3 = *(uint64_t *)(s30 +0x48) */
    S[3] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_029c:
    /* +0x03ea0 op=0x54 02 01 b5 05 CONST_HI16: s1 = sign_extend_32(0x5b5 << 16) */
    S[1] = (int32_t)(0x5b5 << 16);

L_029d:
    /* +0x03eb8 op=0x85 00 13 03 00 ADD64_IMM16: s19 = s0 +0x3 */
    S[19] = S[0] + 0x3;

L_029e:
    /* +0x03ed0 op=0x85 1e 04 50 00 ADD64_IMM16: s4 = s30 +0x50 */
    S[4] = S[30] + 0x50;

L_029f:
    /* +0x03ee8 op=0x85 01 01 a9 86 ADD64_IMM16: s1 = s1 -0x7957 */
    S[1] = S[1] + (-0x7957);

L_02a0:
    /* +0x03f00 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_02a1:
    /* +0x03f18 op=0x59 03 02 5e 01 LD8U: s2 = *(uint8_t *)(s3 +0x15e) */
    S[2] = *(uint8_t *)((uint8_t *)S[3] + 0x15e);

L_02a2:
    /* +0x03f30 op=0x6e 12 01 01 11 SHL64_IMM: s1 = s1 << 17 */
    S[1] = S[1] << 17;

L_02a3:
    /* +0x03f48 op=0x85 01 01 5d 79 ADD64_IMM16: s1 = s1 +0x795d */
    S[1] = S[1] + 0x795d;

L_02a4:
    /* +0x03f60 op=0x26 1e 02 6a 00 ST8: *(s30 +0x6a) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[30] + 0x6a) = (uint8_t)S[2];

L_02a5:
    /* +0x03f78 op=0x6e 02 01 01 14 SHL64_IMM: s1 = s1 << 20 */
    S[1] = S[1] << 20;

L_02a6:
    /* +0x03f90 op=0x55 03 02 5c 01 LD16U: s2 = *(uint16_t *)(s3 +0x15c) */
    S[2] = *(uint16_t *)((uint8_t *)S[3] + 0x15c);

L_02a7:
    /* +0x03fa8 op=0x85 01 01 ed 0d ADD64_IMM16: s1 = s1 +0xded */
    S[1] = S[1] + 0xded;

L_02a8:
    /* +0x03fc0 op=0x19 1e 02 68 00 ST16: *(s30 +0x68) = (uint16_t)s2 */
    *(uint16_t *)((uint8_t *)S[30] + 0x68) = (uint16_t)S[2];

L_02a9:
    /* +0x03fd8 op=0x59 03 02 f8 00 LD8U: s2 = *(uint8_t *)(s3 +0xf8) */
    S[2] = *(uint8_t *)((uint8_t *)S[3] + 0xf8);

L_02aa:
    /* +0x03ff0 op=0x26 1e 02 52 00 ST8: *(s30 +0x52) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[30] + 0x52) = (uint8_t)S[2];

L_02ab:
    /* +0x04008 op=0x55 03 02 f6 00 LD16U: s2 = *(uint16_t *)(s3 +0xf6) */
    S[2] = *(uint16_t *)((uint8_t *)S[3] + 0xf6);

L_02ac:
    /* +0x04020 op=0x25 1e 01 80 00 ST64: *(s30 +0x80) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x80) = S[1];

L_02ad:
    /* +0x04038 op=0x19 1e 02 50 00 ST16: *(s30 +0x50) = (uint16_t)s2 */
    *(uint16_t *)((uint8_t *)S[30] + 0x50) = (uint16_t)S[2];

L_02ae:
    /* +0x04050 op=0x5e 2c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2c, (void *)(uintptr_t)0x125fd3c0);

L_02af:
    /* +0x04068 op=0x85 1e 04 80 00 ADD64_IMM16: s4 = s30 +0x80 */
    S[4] = S[30] + 0x80;

L_02b0:
    /* +0x04080 op=0x85 00 05 08 00 ADD64_IMM16: s5 = s0 +0x8 */
    S[5] = S[0] + 0x8;

L_02b1:
    /* +0x04098 op=0x34 02 00 12 01 OR64: s18 = s2 | s0 */
    S[18] = S[2] | S[0];

L_02b2:
    /* +0x040b0 op=0x5e 2d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2d] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2d, (void *)(uintptr_t)0x125fd3c0);

L_02b3:
    /* +0x040c8 op=0x58 1e 04 28 00 LD64: s4 = *(uint64_t *)(s30 +0x28) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x28);

L_02b4:
    /* +0x040e0 op=0x34 02 00 06 01 OR64: s6 = s2 | s0 */
    S[6] = S[2] | S[0];

L_02b5:
    /* +0x040f8 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_02b6:
    /* +0x04110 op=0x5e 2e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2e] via q1 table runtime: CF98 formatAllocString q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2e, (void *)(uintptr_t)0x125fd3c0);

L_02b7:
    /* +0x04128 op=0x85 1e 04 68 00 ADD64_IMM16: s4 = s30 +0x68 */
    S[4] = S[30] + 0x68;

L_02b8:
    /* +0x04140 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_02b9:
    /* +0x04158 op=0x5e 2f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2f] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2f, (void *)(uintptr_t)0x125fd3c0);

L_02ba:
    /* +0x04170 op=0x58 1e 06 a8 00 LD64: s6 = *(uint64_t *)(s30 +0xa8) */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0xa8);

L_02bb:
    /* +0x04188 op=0x58 1e 04 30 00 LD64: s4 = *(uint64_t *)(s30 +0x30) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x30);

L_02bc:
    /* +0x041a0 op=0x34 02 00 05 01 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_02bd:
    /* +0x041b8 op=0x5e 2e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2e] via q1 table runtime: CF98 formatAllocString q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2e, (void *)(uintptr_t)0x125fd3c0);

L_02be:
    /* +0x041d0 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_02bf:
    /* +0x041e8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02c0:
    /* +0x04200 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_02c1:
    /* +0x04218 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02c2:
    /* +0x04230 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_02c3:
    /* +0x04248 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02c4:
    /* +0x04260 op=0x58 1e 04 40 00 LD64: s4 = *(uint64_t *)(s30 +0x40) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x40);

L_02c5:
    /* +0x04278 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02c6:
    /* +0x04290 op=0x85 1e 04 08 01 ADD64_IMM16: s4 = s30 +0x108 */
    S[4] = S[30] + 0x108;

L_02c7:
    /* +0x042a8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02c8:
    /* +0x042c0 op=0x85 1e 04 20 01 ADD64_IMM16: s4 = s30 +0x120 */
    S[4] = S[30] + 0x120;

L_02c9:
    /* +0x042d8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02ca:
    /* +0x042f0 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_02cb:
    /* +0x04308 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02cc:
    /* +0x04320 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_02cd:
    /* +0x04338 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02ce:
    /* +0x04350 op=0x85 1e 04 80 01 ADD64_IMM16: s4 = s30 +0x180 */
    S[4] = S[30] + 0x180;

L_02cf:
    /* +0x04368 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02d0:
    /* +0x04380 op=0x85 1e 04 98 01 ADD64_IMM16: s4 = s30 +0x198 */
    S[4] = S[30] + 0x198;

L_02d1:
    /* +0x04398 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02d2:
    /* +0x043b0 op=0x85 1e 04 b0 01 ADD64_IMM16: s4 = s30 +0x1b0 */
    S[4] = S[30] + 0x1b0;

L_02d3:
    /* +0x043c8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02d4:
    /* +0x043e0 op=0x85 1e 04 c8 01 ADD64_IMM16: s4 = s30 +0x1c8 */
    S[4] = S[30] + 0x1c8;

L_02d5:
    /* +0x043f8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02d6:
    /* +0x04410 op=0x85 1e 04 10 02 ADD64_IMM16: s4 = s30 +0x210 */
    S[4] = S[30] + 0x210;

L_02d7:
    /* +0x04428 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02d8:
    /* +0x04440 op=0x85 1e 04 20 02 ADD64_IMM16: s4 = s30 +0x220 */
    S[4] = S[30] + 0x220;

L_02d9:
    /* +0x04458 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02da:
    /* +0x04470 op=0x85 1e 04 60 02 ADD64_IMM16: s4 = s30 +0x260 */
    S[4] = S[30] + 0x260;

L_02db:
    /* +0x04488 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02dc:
    /* +0x044a0 op=0x85 1e 04 78 02 ADD64_IMM16: s4 = s30 +0x278 */
    S[4] = S[30] + 0x278;

L_02dd:
    /* +0x044b8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02de:
    /* +0x044d0 op=0x85 1e 04 88 02 ADD64_IMM16: s4 = s30 +0x288 */
    S[4] = S[30] + 0x288;

L_02df:
    /* +0x044e8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02e0:
    /* +0x04500 op=0x85 1e 04 98 02 ADD64_IMM16: s4 = s30 +0x298 */
    S[4] = S[30] + 0x298;

L_02e1:
    /* +0x04518 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02e2:
    /* +0x04530 op=0x85 1e 04 b8 02 ADD64_IMM16: s4 = s30 +0x2b8 */
    S[4] = S[30] + 0x2b8;

L_02e3:
    /* +0x04548 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_02e4:
    /* +0x04560 op=0x85 1e 04 c8 02 ADD64_IMM16: s4 = s30 +0x2c8 */
    S[4] = S[30] + 0x2c8;

L_02e5:
    /* +0x04578 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02e6:
    /* +0x04590 op=0x85 1e 04 e0 02 ADD64_IMM16: s4 = s30 +0x2e0 */
    S[4] = S[30] + 0x2e0;

L_02e7:
    /* +0x045a8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02e8:
    /* +0x045c0 op=0x85 1e 04 f8 02 ADD64_IMM16: s4 = s30 +0x2f8 */
    S[4] = S[30] + 0x2f8;

L_02e9:
    /* +0x045d8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_02ea:
    /* +0x045f0 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_02eb:
    /* +0x04608 op=0x58 1d 10 f0 03 LD64: s16 = *(uint64_t *)(s29 +0x3f0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x3f0);

L_02ec:
    /* +0x04620 op=0x58 1d 11 f8 03 LD64: s17 = *(uint64_t *)(s29 +0x3f8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x3f8);

L_02ed:
    /* +0x04638 op=0x58 1d 12 00 04 LD64: s18 = *(uint64_t *)(s29 +0x400) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x400);

L_02ee:
    /* +0x04650 op=0x58 1d 13 08 04 LD64: s19 = *(uint64_t *)(s29 +0x408) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x408);

L_02ef:
    /* +0x04668 op=0x58 1d 14 10 04 LD64: s20 = *(uint64_t *)(s29 +0x410) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x410);

L_02f0:
    /* +0x04680 op=0x58 1d 15 18 04 LD64: s21 = *(uint64_t *)(s29 +0x418) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x418);

L_02f1:
    /* +0x04698 op=0x58 1d 16 20 04 LD64: s22 = *(uint64_t *)(s29 +0x420) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x420);

L_02f2:
    /* +0x046b0 op=0x58 1d 17 28 04 LD64: s23 = *(uint64_t *)(s29 +0x428) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x428);

L_02f3:
    /* +0x046c8 op=0x58 1d 1e 30 04 LD64: s30 = *(uint64_t *)(s29 +0x430) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x430);

L_02f4:
    /* +0x046e0 op=0x58 1d 1f 38 04 LD64: s31 = *(uint64_t *)(s29 +0x438) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x438);

L_02f5:
    /* +0x046f8 op=0x85 1d 1d 40 04 ADD64_IMM16: s29 = s29 +0x440 */
    S[29] = S[29] + 0x440;

L_02f6:
    /* +0x04710 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

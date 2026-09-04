/*
 * Auto-generated linear C-like lift for 350.101 managed program F14.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_missing_20260904/350101_F14_0x46c800_0x3078.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F14_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d b0 fd ADD64_IMM16: s29 = s29 -0x250 */
    S[29] = S[29] + (-0x250);

L_0001:
    /* +0x00018 op=0x25 1d 1f 48 02 ST64: *(s29 +0x248) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x248) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 40 02 ST64: *(s29 +0x240) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x240) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 38 02 ST64: *(s29 +0x238) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x238) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 30 02 ST64: *(s29 +0x230) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x230) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 28 02 ST64: *(s29 +0x228) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x228) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 20 02 ST64: *(s29 +0x220) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x220) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 18 02 ST64: *(s29 +0x218) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x218) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 10 02 ST64: *(s29 +0x210) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x210) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 08 02 ST64: *(s29 +0x208) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x208) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 00 02 ST64: *(s29 +0x200) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x200) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x53 04 02 79 00 LD_POOL_PTR: s2 = *(uint64_t *)q1 + 0x79 q1=0x1235f648 */
    S[2] = *(uint64_t *)(uintptr_t)0x1235f648 + 0x79;

L_000d:
    /* +0x00138 op=0x53 04 01 08 03 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x308 q1=0x1235f648 */
    S[1] = *(uint64_t *)(uintptr_t)0x1235f648 + 0x308;

L_000e:
    /* +0x00150 op=0x53 01 05 85 00 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x85 q1=0x1235f648 */
    S[5] = *(uint64_t *)(uintptr_t)0x1235f648 + 0x85;

L_000f:
    /* +0x00168 op=0x85 1e 17 68 01 ADD64_IMM16: s23 = s30 +0x168 */
    S[23] = S[30] + 0x168;

L_0010:
    /* +0x00180 op=0xb5 00 06 80 00 ADD32_IMM16: s6 = int32(s0 +0x80) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x80);

L_0011:
    /* +0x00198 op=0x59 02 03 02 00 LD8U: s3 = *(uint8_t *)(s2 +0x2) */
    S[3] = *(uint8_t *)((uint8_t *)S[2] + 0x2);

L_0012:
    /* +0x001b0 op=0x55 02 02 00 00 LD16U: s2 = *(uint16_t *)(s2 +0x0) */
    S[2] = *(uint16_t *)((uint8_t *)S[2] + 0x0);

L_0013:
    /* +0x001c8 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0014:
    /* +0x001e0 op=0x26 1e 03 fe 01 ST8: *(s30 +0x1fe) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[30] + 0x1fe) = (uint8_t)S[3];

L_0015:
    /* +0x001f8 op=0x19 1e 02 fc 01 ST16: *(s30 +0x1fc) = (uint16_t)s2 */
    *(uint16_t *)((uint8_t *)S[30] + 0x1fc) = (uint16_t)S[2];

L_0016:
    /* +0x00210 op=0x53 04 03 7c 00 LD_POOL_PTR: s3 = *(uint64_t *)q1 + 0x7c q1=0x1235f648 */
    S[3] = *(uint64_t *)(uintptr_t)0x1235f648 + 0x7c;

L_0017:
    /* +0x00228 op=0x55 01 02 5c 01 LD16U: s2 = *(uint16_t *)(s1 +0x15c) */
    S[2] = *(uint16_t *)((uint8_t *)S[1] + 0x15c);

L_0018:
    /* +0x00240 op=0x59 01 01 5e 01 LD8U: s1 = *(uint8_t *)(s1 +0x15e) */
    S[1] = *(uint8_t *)((uint8_t *)S[1] + 0x15e);

L_0019:
    /* +0x00258 op=0x26 1e 01 fa 01 ST8: *(s30 +0x1fa) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x1fa) = (uint8_t)S[1];

L_001a:
    /* +0x00270 op=0x58 03 01 00 00 LD64: s1 = *(uint64_t *)(s3 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[3] + 0x0);

L_001b:
    /* +0x00288 op=0x19 1e 02 f8 01 ST16: *(s30 +0x1f8) = (uint16_t)s2 */
    *(uint16_t *)((uint8_t *)S[30] + 0x1f8) = (uint16_t)S[2];

L_001c:
    /* +0x002a0 op=0x59 03 02 08 00 LD8U: s2 = *(uint8_t *)(s3 +0x8) */
    S[2] = *(uint8_t *)((uint8_t *)S[3] + 0x8);

L_001d:
    /* +0x002b8 op=0x53 04 03 90 00 LD_POOL_PTR: s3 = *(uint64_t *)q1 + 0x90 q1=0x1235f648 */
    S[3] = *(uint64_t *)(uintptr_t)0x1235f648 + 0x90;

L_001e:
    /* +0x002d0 op=0x25 1e 01 e8 01 ST64: *(s30 +0x1e8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1e8) = S[1];

L_001f:
    /* +0x002e8 op=0x52 05 01 07 00 LD32S: s1 = *(int32_t *)(s5 +0x7) */
    S[1] = *(int32_t *)((uint8_t *)S[5] + 0x7);

L_0020:
    /* +0x00300 op=0x26 1e 02 f0 01 ST8: *(s30 +0x1f0) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[30] + 0x1f0) = (uint8_t)S[2];

L_0021:
    /* +0x00318 op=0x08 1e 01 df 01 ST32: *(s30 +0x1df) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1df) = (uint32_t)S[1];

L_0022:
    /* +0x00330 op=0x58 05 01 00 00 LD64: s1 = *(uint64_t *)(s5 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[5] + 0x0);

L_0023:
    /* +0x00348 op=0x25 1e 01 d8 01 ST64: *(s30 +0x1d8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1d8) = S[1];

L_0024:
    /* +0x00360 op=0x59 03 01 08 00 LD8U: s1 = *(uint8_t *)(s3 +0x8) */
    S[1] = *(uint8_t *)((uint8_t *)S[3] + 0x8);

L_0025:
    /* +0x00378 op=0x26 1e 01 d0 01 ST8: *(s30 +0x1d0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x1d0) = (uint8_t)S[1];

L_0026:
    /* +0x00390 op=0x58 03 01 00 00 LD64: s1 = *(uint64_t *)(s3 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[3] + 0x0);

L_0027:
    /* +0x003a8 op=0x25 1e 01 c8 01 ST64: *(s30 +0x1c8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1c8) = S[1];

L_0028:
    /* +0x003c0 op=0x58 04 01 28 00 LD64: s1 = *(uint64_t *)(s4 +0x28) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x28);

L_0029:
    /* +0x003d8 op=0x58 04 15 10 00 LD64: s21 = *(uint64_t *)(s4 +0x10) */
    S[21] = *(uint64_t *)((uint8_t *)S[4] + 0x10);

L_002a:
    /* +0x003f0 op=0x58 04 14 18 00 LD64: s20 = *(uint64_t *)(s4 +0x18) */
    S[20] = *(uint64_t *)((uint8_t *)S[4] + 0x18);

L_002b:
    /* +0x00408 op=0x58 04 12 20 00 LD64: s18 = *(uint64_t *)(s4 +0x20) */
    S[18] = *(uint64_t *)((uint8_t *)S[4] + 0x20);

L_002c:
    /* +0x00420 op=0x58 04 16 08 00 LD64: s22 = *(uint64_t *)(s4 +0x8) */
    S[22] = *(uint64_t *)((uint8_t *)S[4] + 0x8);

L_002d:
    /* +0x00438 op=0x25 1e 01 08 00 ST64: *(s30 +0x8) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[1];

L_002e:
    /* +0x00450 op=0x58 04 01 30 00 LD64: s1 = *(uint64_t *)(s4 +0x30) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x30);

L_002f:
    /* +0x00468 op=0x25 1e 01 10 00 ST64: *(s30 +0x10) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x10) = S[1];

L_0030:
    /* +0x00480 op=0x58 04 01 38 00 LD64: s1 = *(uint64_t *)(s4 +0x38) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x38);

L_0031:
    /* +0x00498 op=0x25 1e 01 18 00 ST64: *(s30 +0x18) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[1];

L_0032:
    /* +0x004b0 op=0x58 04 01 00 00 LD64: s1 = *(uint64_t *)(s4 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_0033:
    /* +0x004c8 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0034:
    /* +0x004e0 op=0x26 1e 06 c4 01 ST8: *(s30 +0x1c4) = (uint8_t)s6 */
    *(uint8_t *)((uint8_t *)S[30] + 0x1c4) = (uint8_t)S[6];

L_0035:
    /* +0x004f8 op=0x85 01 13 a0 00 ADD64_IMM16: s19 = s1 +0xa0 */
    S[19] = S[1] + 0xa0;

L_0036:
    /* +0x00510 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0037:
    /* +0x00528 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x1235f600);

L_0038:
    /* +0x00540 op=0x58 1e 05 68 01 LD64: s5 = *(uint64_t *)(s30 +0x168) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x168);

L_0039:
    /* +0x00558 op=0x85 1e 04 b0 01 ADD64_IMM16: s4 = s30 +0x1b0 */
    S[4] = S[30] + 0x1b0;

L_003a:
    /* +0x00570 op=0x5e 12 00 00 00 CALL_CF_INDEX: call native_binding[index=0x12] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x12, (void *)(uintptr_t)0x1235f600);

L_003b:
    /* +0x00588 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_003c:
    /* +0x005a0 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x1235f600);

L_003d:
    /* +0x005b8 op=0x34 16 00 04 00 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_003e:
    /* +0x005d0 op=0x25 1e 00 a8 01 ST64: *(s30 +0x1a8) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1a8) = S[0];

L_003f:
    /* +0x005e8 op=0x25 1e 00 a0 01 ST64: *(s30 +0x1a0) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1a0) = S[0];

L_0040:
    /* +0x00600 op=0x5e 1a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1a] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1a, (void *)(uintptr_t)0x1235f600);

L_0041:
    /* +0x00618 op=0x18 11 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_0042:
    /* +0x00630 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_0043:
    /* +0x00648 op=0xae 01 00 12 00 BR_EQ64: if (s1 == s0) goto record +86 */
    if (S[1] == S[0]) goto L_0056;

L_0044:
    /* +0x00660 op=0x85 00 04 18 00 ADD64_IMM16: s4 = s0 +0x18 */
    S[4] = S[0] + 0x18;

L_0045:
    /* +0x00678 op=0x5e 47 00 00 00 CALL_CF_INDEX: call native_binding[index=0x47] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x47, (void *)(uintptr_t)0x1235f600);

L_0046:
    /* +0x00690 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_0047:
    /* +0x006a8 op=0x85 00 06 10 00 ADD64_IMM16: s6 = s0 +0x10 */
    S[6] = S[0] + 0x10;

L_0048:
    /* +0x006c0 op=0x34 02 00 04 00 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_0049:
    /* +0x006d8 op=0x34 02 00 16 01 OR64: s22 = s2 | s0 */
    S[22] = S[2] | S[0];

L_004a:
    /* +0x006f0 op=0x5e 1e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1e, (void *)(uintptr_t)0x1235f600);

L_004b:
    /* +0x00708 op=0x85 1e 04 a0 01 ADD64_IMM16: s4 = s30 +0x1a0 */
    S[4] = S[30] + 0x1a0;

L_004c:
    /* +0x00720 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_004d:
    /* +0x00738 op=0x5e 5e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x5e, (void *)(uintptr_t)0x1235f600);

L_004e:
    /* +0x00750 op=0x58 1e 03 a0 01 LD64: s3 = *(uint64_t *)(s30 +0x1a0) */
    S[3] = *(uint64_t *)((uint8_t *)S[30] + 0x1a0);

L_004f:
    /* +0x00768 op=0xb5 00 02 45 00 ADD32_IMM16: s2 = int32(s0 +0x45) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x45);

L_0050:
    /* +0x00780 op=0xb5 00 01 3f 00 ADD32_IMM16: s1 = int32(s0 +0x3f) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x3f);

L_0051:
    /* +0x00798 op=0x58 03 04 10 00 LD64: s4 = *(uint64_t *)(s3 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_0052:
    /* +0x007b0 op=0x26 04 02 0e 00 ST8: *(s4 +0xe) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xe) = (uint8_t)S[2];

L_0053:
    /* +0x007c8 op=0x58 03 02 10 00 LD64: s2 = *(uint64_t *)(s3 +0x10) */
    S[2] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_0054:
    /* +0x007e0 op=0x26 02 01 0f 00 ST8: *(s2 +0xf) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[2] + 0xf) = (uint8_t)S[1];

L_0055:
    /* +0x007f8 op=0x5f 0a 00 00 00 ADD_PC_IMM32: goto record +96 ; vm_pc = current_pc + 1 + 10 */
    goto L_0060;

L_0056:
    /* +0x00810 op=0x85 1e 17 68 01 ADD64_IMM16: s23 = s30 +0x168 */
    S[23] = S[30] + 0x168;

L_0057:
    /* +0x00828 op=0x85 00 06 00 00 ADD64_IMM16: s6 = s0 +0x0 */
    S[6] = S[0] + 0x0;

L_0058:
    /* +0x00840 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0059:
    /* +0x00858 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_005a:
    /* +0x00870 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x1235f600);

L_005b:
    /* +0x00888 op=0x85 1e 04 a0 01 ADD64_IMM16: s4 = s30 +0x1a0 */
    S[4] = S[30] + 0x1a0;

L_005c:
    /* +0x008a0 op=0x34 17 00 05 01 OR64: s5 = s23 | s0 */
    S[5] = S[23] | S[0];

L_005d:
    /* +0x008b8 op=0x5e 27 00 00 00 CALL_CF_INDEX: call native_binding[index=0x27] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x27, (void *)(uintptr_t)0x1235f600);

L_005e:
    /* +0x008d0 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_005f:
    /* +0x008e8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_0060:
    /* +0x00900 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0061:
    /* +0x00918 op=0x25 1e 00 98 01 ST64: *(s30 +0x198) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x198) = S[0];

L_0062:
    /* +0x00930 op=0x25 1e 00 90 01 ST64: *(s30 +0x190) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x190) = S[0];

L_0063:
    /* +0x00948 op=0x5e 1a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1a] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1a, (void *)(uintptr_t)0x1235f600);

L_0064:
    /* +0x00960 op=0x18 00 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_0065:
    /* +0x00978 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_0066:
    /* +0x00990 op=0xae 01 00 12 00 BR_EQ64: if (s1 == s0) goto record +121 */
    if (S[1] == S[0]) goto L_0079;

L_0067:
    /* +0x009a8 op=0x85 00 04 18 00 ADD64_IMM16: s4 = s0 +0x18 */
    S[4] = S[0] + 0x18;

L_0068:
    /* +0x009c0 op=0x5e 47 00 00 00 CALL_CF_INDEX: call native_binding[index=0x47] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x47, (void *)(uintptr_t)0x1235f600);

L_0069:
    /* +0x009d8 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_006a:
    /* +0x009f0 op=0x85 00 06 10 00 ADD64_IMM16: s6 = s0 +0x10 */
    S[6] = S[0] + 0x10;

L_006b:
    /* +0x00a08 op=0x34 02 00 04 01 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_006c:
    /* +0x00a20 op=0x34 02 00 15 01 OR64: s21 = s2 | s0 */
    S[21] = S[2] | S[0];

L_006d:
    /* +0x00a38 op=0x5e 1e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1e, (void *)(uintptr_t)0x1235f600);

L_006e:
    /* +0x00a50 op=0x85 1e 04 90 01 ADD64_IMM16: s4 = s30 +0x190 */
    S[4] = S[30] + 0x190;

L_006f:
    /* +0x00a68 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0070:
    /* +0x00a80 op=0x5e 5e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x5e, (void *)(uintptr_t)0x1235f600);

L_0071:
    /* +0x00a98 op=0x58 1e 03 90 01 LD64: s3 = *(uint64_t *)(s30 +0x190) */
    S[3] = *(uint64_t *)((uint8_t *)S[30] + 0x190);

L_0072:
    /* +0x00ab0 op=0xb5 00 02 45 00 ADD32_IMM16: s2 = int32(s0 +0x45) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x45);

L_0073:
    /* +0x00ac8 op=0xb5 00 01 3f 00 ADD32_IMM16: s1 = int32(s0 +0x3f) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x3f);

L_0074:
    /* +0x00ae0 op=0x58 03 04 10 00 LD64: s4 = *(uint64_t *)(s3 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_0075:
    /* +0x00af8 op=0x26 04 02 0e 00 ST8: *(s4 +0xe) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xe) = (uint8_t)S[2];

L_0076:
    /* +0x00b10 op=0x58 03 02 10 00 LD64: s2 = *(uint64_t *)(s3 +0x10) */
    S[2] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_0077:
    /* +0x00b28 op=0x26 02 01 0f 00 ST8: *(s2 +0xf) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[2] + 0xf) = (uint8_t)S[1];

L_0078:
    /* +0x00b40 op=0x5f 37 00 00 00 ADD_PC_IMM32: goto record +176 ; vm_pc = current_pc + 1 + 55 */
    goto L_00b0;

L_0079:
    /* +0x00b58 op=0x85 00 04 18 00 ADD64_IMM16: s4 = s0 +0x18 */
    S[4] = S[0] + 0x18;

L_007a:
    /* +0x00b70 op=0x5e 47 00 00 00 CALL_CF_INDEX: call native_binding[index=0x47] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x47, (void *)(uintptr_t)0x1235f600);

L_007b:
    /* +0x00b88 op=0x34 02 00 04 01 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_007c:
    /* +0x00ba0 op=0x34 02 00 16 00 OR64: s22 = s2 | s0 */
    S[22] = S[2] | S[0];

L_007d:
    /* +0x00bb8 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x1235f600);

L_007e:
    /* +0x00bd0 op=0x85 1e 04 68 01 ADD64_IMM16: s4 = s30 +0x168 */
    S[4] = S[30] + 0x168;

L_007f:
    /* +0x00be8 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0080:
    /* +0x00c00 op=0x5e 48 00 00 00 CALL_CF_INDEX: call native_binding[index=0x48] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x48, (void *)(uintptr_t)0x1235f600);

L_0081:
    /* +0x00c18 op=0x58 1e 04 68 01 LD64: s4 = *(uint64_t *)(s30 +0x168) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x168);

L_0082:
    /* +0x00c30 op=0x85 00 05 10 00 ADD64_IMM16: s5 = s0 +0x10 */
    S[5] = S[0] + 0x10;

L_0083:
    /* +0x00c48 op=0x5e 5f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5f] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x5f, (void *)(uintptr_t)0x1235f600);

L_0084:
    /* +0x00c60 op=0xb5 00 10 00 00 ADD32_IMM16: s16 = int32(s0 +0x0) */
    S[16] = (int32_t)((uint32_t)S[0] + 0x0);

L_0085:
    /* +0x00c78 op=0x85 00 11 00 00 ADD64_IMM16: s17 = s0 +0x0 */
    S[17] = S[0] + 0x0;

L_0086:
    /* +0x00c90 op=0x34 10 00 02 01 OR64: s2 = s16 | s0 */
    S[2] = S[16] | S[0];

L_0087:
    /* +0x00ca8 op=0x14 11 01 20 00 CMP_LO_IMM64: s1 = ((uint64_t)s17 < (uint64_t)32) ? 1 : 0 */
    S[1] = ((uint64_t)S[17] < (uint64_t)0x20) ? 1 : 0;

L_0088:
    /* +0x00cc0 op=0xae 01 00 1b 00 BR_EQ64: if (s1 == s0) goto record +164 */
    if (S[1] == S[0]) goto L_00a4;

L_0089:
    /* +0x00cd8 op=0x52 15 01 0c 00 LD32S: s1 = *(int32_t *)(s21 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[21] + 0xc);

L_008a:
    /* +0x00cf0 op=0x16 11 01 01 00 CMP_LT64S: s1 = ((int64_t)s17 < (int64_t)s1) ? 1 : 0 */
    S[1] = ((int64_t)S[17] < (int64_t)S[1]) ? 1 : 0;

L_008b:
    /* +0x00d08 op=0xae 01 00 18 00 BR_EQ64: if (s1 == s0) goto record +164 */
    if (S[1] == S[0]) goto L_00a4;

L_008c:
    /* +0x00d20 op=0x58 15 01 10 00 LD64: s1 = *(uint64_t *)(s21 +0x10) */
    S[1] = *(uint64_t *)((uint8_t *)S[21] + 0x10);

L_008d:
    /* +0x00d38 op=0x84 01 11 01 14 ADD64: s1 = s1 + s17 */
    S[1] = S[1] + S[17];

L_008e:
    /* +0x00d50 op=0x59 01 04 00 00 LD8U: s4 = *(uint8_t *)(s1 +0x0) */
    S[4] = *(uint8_t *)((uint8_t *)S[1] + 0x0);

L_008f:
    /* +0x00d68 op=0xb5 04 03 d0 ff ADD32_IMM16: s3 = int32(s4 -0x30) */
    S[3] = (int32_t)((uint32_t)S[4] + (-0x30));

L_0090:
    /* +0x00d80 op=0xb2 03 01 ff 00 AND64_IMM16: s1 = s3 & 0xff */
    S[1] = S[3] & 0xff;

L_0091:
    /* +0x00d98 op=0x14 01 01 0a 00 CMP_LO_IMM64: s1 = ((uint64_t)s1 < (uint64_t)10) ? 1 : 0 */
    S[1] = ((uint64_t)S[1] < (uint64_t)0xa) ? 1 : 0;

L_0092:
    /* +0x00db0 op=0xa7 01 00 07 00 BR_NE64: if (s1 != s0) goto record +154 */
    if (S[1] != S[0]) goto L_009a;

L_0093:
    /* +0x00dc8 op=0xb5 04 03 9f ff ADD32_IMM16: s3 = int32(s4 -0x61) */
    S[3] = (int32_t)((uint32_t)S[4] + (-0x61));

L_0094:
    /* +0x00de0 op=0xb5 04 01 a9 ff ADD32_IMM16: s1 = int32(s4 -0x57) */
    S[1] = (int32_t)((uint32_t)S[4] + (-0x57));

L_0095:
    /* +0x00df8 op=0xb2 03 03 ff 00 AND64_IMM16: s3 = s3 & 0xff */
    S[3] = S[3] & 0xff;

L_0096:
    /* +0x00e10 op=0x14 03 03 06 00 CMP_LO_IMM64: s3 = ((uint64_t)s3 < (uint64_t)6) ? 1 : 0 */
    S[3] = ((uint64_t)S[3] < (uint64_t)0x6) ? 1 : 0;

L_0097:
    /* +0x00e28 op=0x1e 01 03 01 11 CMOVNZ64: s1 = (s3 != 0) ? s1 : 0 */
    S[1] = (S[3] != 0) ? S[1] : 0;

L_0098:
    /* +0x00e40 op=0x1f 00 03 03 00 CMOVZ64: s3 = (s3 == 0) ? s0 : 0 */
    S[3] = (S[3] == 0) ? S[0] : 0;

L_0099:
    /* +0x00e58 op=0x34 03 01 03 01 OR64: s3 = s3 | s1 */
    S[3] = S[3] | S[1];

L_009a:
    /* +0x00e70 op=0xb2 11 01 01 00 AND64_IMM16: s1 = s17 & 0x1 */
    S[1] = S[17] & 0x1;

L_009b:
    /* +0x00e88 op=0xa7 01 00 02 00 BR_NE64: if (s1 != s0) goto record +158 */
    if (S[1] != S[0]) goto L_009e;

L_009c:
    /* +0x00ea0 op=0x18 11 03 02 04 SHL32_IMM: s2 = (int32_t)(s3 << 4) */
    S[2] = (int32_t)((uint32_t)S[3] << 4);

L_009d:
    /* +0x00eb8 op=0x5f 04 00 00 00 ADD_PC_IMM32: goto record +162 ; vm_pc = current_pc + 1 + 4 */
    goto L_00a2;

L_009e:
    /* +0x00ed0 op=0x58 1e 04 68 01 LD64: s4 = *(uint64_t *)(s30 +0x168) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x168);

L_009f:
    /* +0x00ee8 op=0xb4 03 02 05 00 ADD32: s5 = int32(s3 + s2) */
    S[5] = (int32_t)((uint32_t)S[3] + (uint32_t)S[2]);

L_00a0:
    /* +0x00f00 op=0x5e 60 00 00 00 CALL_CF_INDEX: call native_binding[index=0x60] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x60, (void *)(uintptr_t)0x1235f600);

L_00a1:
    /* +0x00f18 op=0x34 10 00 02 00 OR64: s2 = s16 | s0 */
    S[2] = S[16] | S[0];

L_00a2:
    /* +0x00f30 op=0x85 11 11 01 00 ADD64_IMM16: s17 = s17 +0x1 */
    S[17] = S[17] + 0x1;

L_00a3:
    /* +0x00f48 op=0x5f e3 ff ff ff ADD_PC_IMM32: goto record +135 ; vm_pc = current_pc + 1 + -29 */
    goto L_0087;

L_00a4:
    /* +0x00f60 op=0x85 1e 15 50 01 ADD64_IMM16: s21 = s30 +0x150 */
    S[21] = S[30] + 0x150;

L_00a5:
    /* +0x00f78 op=0x58 1e 05 68 01 LD64: s5 = *(uint64_t *)(s30 +0x168) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x168);

L_00a6:
    /* +0x00f90 op=0x85 00 06 00 00 ADD64_IMM16: s6 = s0 +0x0 */
    S[6] = S[0] + 0x0;

L_00a7:
    /* +0x00fa8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00a8:
    /* +0x00fc0 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x1235f600);

L_00a9:
    /* +0x00fd8 op=0x85 1e 04 90 01 ADD64_IMM16: s4 = s30 +0x190 */
    S[4] = S[30] + 0x190;

L_00aa:
    /* +0x00ff0 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_00ab:
    /* +0x01008 op=0x5e 27 00 00 00 CALL_CF_INDEX: call native_binding[index=0x27] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x27, (void *)(uintptr_t)0x1235f600);

L_00ac:
    /* +0x01020 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00ad:
    /* +0x01038 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_00ae:
    /* +0x01050 op=0x85 1e 04 68 01 ADD64_IMM16: s4 = s30 +0x168 */
    S[4] = S[30] + 0x168;

L_00af:
    /* +0x01068 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_00b0:
    /* +0x01080 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_00b1:
    /* +0x01098 op=0x25 1e 00 88 01 ST64: *(s30 +0x188) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x188) = S[0];

L_00b2:
    /* +0x010b0 op=0x25 1e 00 80 01 ST64: *(s30 +0x180) = s0 */
    *(uint64_t *)((uint8_t *)S[30] + 0x180) = S[0];

L_00b3:
    /* +0x010c8 op=0x5e 1a 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1a] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1a, (void *)(uintptr_t)0x1235f600);

L_00b4:
    /* +0x010e0 op=0x18 11 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_00b5:
    /* +0x010f8 op=0xb2 01 01 01 00 AND64_IMM16: s1 = s1 & 0x1 */
    S[1] = S[1] & 0x1;

L_00b6:
    /* +0x01110 op=0xae 01 00 12 00 BR_EQ64: if (s1 == s0) goto record +201 */
    if (S[1] == S[0]) goto L_00c9;

L_00b7:
    /* +0x01128 op=0x85 00 04 18 00 ADD64_IMM16: s4 = s0 +0x18 */
    S[4] = S[0] + 0x18;

L_00b8:
    /* +0x01140 op=0x5e 47 00 00 00 CALL_CF_INDEX: call native_binding[index=0x47] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x47, (void *)(uintptr_t)0x1235f600);

L_00b9:
    /* +0x01158 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_00ba:
    /* +0x01170 op=0x85 00 06 10 00 ADD64_IMM16: s6 = s0 +0x10 */
    S[6] = S[0] + 0x10;

L_00bb:
    /* +0x01188 op=0x34 02 00 04 00 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_00bc:
    /* +0x011a0 op=0x34 02 00 14 01 OR64: s20 = s2 | s0 */
    S[20] = S[2] | S[0];

L_00bd:
    /* +0x011b8 op=0x5e 1e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1e, (void *)(uintptr_t)0x1235f600);

L_00be:
    /* +0x011d0 op=0x85 1e 04 80 01 ADD64_IMM16: s4 = s30 +0x180 */
    S[4] = S[30] + 0x180;

L_00bf:
    /* +0x011e8 op=0x34 14 00 05 00 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_00c0:
    /* +0x01200 op=0x5e 5e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5e] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x5e, (void *)(uintptr_t)0x1235f600);

L_00c1:
    /* +0x01218 op=0x58 1e 03 80 01 LD64: s3 = *(uint64_t *)(s30 +0x180) */
    S[3] = *(uint64_t *)((uint8_t *)S[30] + 0x180);

L_00c2:
    /* +0x01230 op=0xb5 00 02 45 00 ADD32_IMM16: s2 = int32(s0 +0x45) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x45);

L_00c3:
    /* +0x01248 op=0xb5 00 01 3f 00 ADD32_IMM16: s1 = int32(s0 +0x3f) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x3f);

L_00c4:
    /* +0x01260 op=0x58 03 04 10 00 LD64: s4 = *(uint64_t *)(s3 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_00c5:
    /* +0x01278 op=0x26 04 02 0e 00 ST8: *(s4 +0xe) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[4] + 0xe) = (uint8_t)S[2];

L_00c6:
    /* +0x01290 op=0x58 03 02 10 00 LD64: s2 = *(uint64_t *)(s3 +0x10) */
    S[2] = *(uint64_t *)((uint8_t *)S[3] + 0x10);

L_00c7:
    /* +0x012a8 op=0x26 02 01 0f 00 ST8: *(s2 +0xf) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[2] + 0xf) = (uint8_t)S[1];

L_00c8:
    /* +0x012c0 op=0x5f 0a 00 00 00 ADD_PC_IMM32: goto record +211 ; vm_pc = current_pc + 1 + 10 */
    goto L_00d3;

L_00c9:
    /* +0x012d8 op=0x85 1e 15 68 01 ADD64_IMM16: s21 = s30 +0x168 */
    S[21] = S[30] + 0x168;

L_00ca:
    /* +0x012f0 op=0x85 00 06 00 00 ADD64_IMM16: s6 = s0 +0x0 */
    S[6] = S[0] + 0x0;

L_00cb:
    /* +0x01308 op=0x34 14 00 05 01 OR64: s5 = s20 | s0 */
    S[5] = S[20] | S[0];

L_00cc:
    /* +0x01320 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00cd:
    /* +0x01338 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x1235f600);

L_00ce:
    /* +0x01350 op=0x85 1e 04 80 01 ADD64_IMM16: s4 = s30 +0x180 */
    S[4] = S[30] + 0x180;

L_00cf:
    /* +0x01368 op=0x34 15 00 05 00 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_00d0:
    /* +0x01380 op=0x5e 27 00 00 00 CALL_CF_INDEX: call native_binding[index=0x27] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x27, (void *)(uintptr_t)0x1235f600);

L_00d1:
    /* +0x01398 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00d2:
    /* +0x013b0 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_00d3:
    /* +0x013c8 op=0x85 1e 14 00 01 ADD64_IMM16: s20 = s30 +0x100 */
    S[20] = S[30] + 0x100;

L_00d4:
    /* +0x013e0 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_00d5:
    /* +0x013f8 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_00d6:
    /* +0x01410 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x1235f600);

L_00d7:
    /* +0x01428 op=0x58 1e 15 00 01 LD64: s21 = *(uint64_t *)(s30 +0x100) */
    S[21] = *(uint64_t *)((uint8_t *)S[30] + 0x100);

L_00d8:
    /* +0x01440 op=0x85 1e 04 c8 01 ADD64_IMM16: s4 = s30 +0x1c8 */
    S[4] = S[30] + 0x1c8;

L_00d9:
    /* +0x01458 op=0x85 00 05 09 00 ADD64_IMM16: s5 = s0 +0x9 */
    S[5] = S[0] + 0x9;

L_00da:
    /* +0x01470 op=0x5e 2c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x2c, (void *)(uintptr_t)0x1235f600);

L_00db:
    /* +0x01488 op=0x85 1e 16 50 01 ADD64_IMM16: s22 = s30 +0x150 */
    S[22] = S[30] + 0x150;

L_00dc:
    /* +0x014a0 op=0x34 02 00 05 01 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_00dd:
    /* +0x014b8 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_00de:
    /* +0x014d0 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x1235f600);

L_00df:
    /* +0x014e8 op=0x85 1e 17 20 01 ADD64_IMM16: s23 = s30 +0x120 */
    S[23] = S[30] + 0x120;

L_00e0:
    /* +0x01500 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_00e1:
    /* +0x01518 op=0x34 16 00 06 01 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_00e2:
    /* +0x01530 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_00e3:
    /* +0x01548 op=0x5e 21 00 00 00 CALL_CF_INDEX: call native_binding[index=0x21] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x21, (void *)(uintptr_t)0x1235f600);

L_00e4:
    /* +0x01560 op=0x85 1e 15 38 01 ADD64_IMM16: s21 = s30 +0x138 */
    S[21] = S[30] + 0x138;

L_00e5:
    /* +0x01578 op=0x58 1e 05 20 01 LD64: s5 = *(uint64_t *)(s30 +0x120) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x120);

L_00e6:
    /* +0x01590 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00e7:
    /* +0x015a8 op=0x5e 22 00 00 00 CALL_CF_INDEX: call native_binding[index=0x22] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x22, (void *)(uintptr_t)0x1235f600);

L_00e8:
    /* +0x015c0 op=0x58 1e 05 38 01 LD64: s5 = *(uint64_t *)(s30 +0x138) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x138);

L_00e9:
    /* +0x015d8 op=0x85 1e 04 68 01 ADD64_IMM16: s4 = s30 +0x168 */
    S[4] = S[30] + 0x168;

L_00ea:
    /* +0x015f0 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x1235f600);

L_00eb:
    /* +0x01608 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00ec:
    /* +0x01620 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_00ed:
    /* +0x01638 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_00ee:
    /* +0x01650 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_00ef:
    /* +0x01668 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_00f0:
    /* +0x01680 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_00f1:
    /* +0x01698 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_00f2:
    /* +0x016b0 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x1235f600);

L_00f3:
    /* +0x016c8 op=0x85 1e 15 e0 00 ADD64_IMM16: s21 = s30 +0xe0 */
    S[21] = S[30] + 0xe0;

L_00f4:
    /* +0x016e0 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_00f5:
    /* +0x016f8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_00f6:
    /* +0x01710 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x1235f600);

L_00f7:
    /* +0x01728 op=0x85 1e 04 d8 01 ADD64_IMM16: s4 = s30 +0x1d8 */
    S[4] = S[30] + 0x1d8;

L_00f8:
    /* +0x01740 op=0x85 00 05 0b 00 ADD64_IMM16: s5 = s0 +0xb */
    S[5] = S[0] + 0xb;

L_00f9:
    /* +0x01758 op=0x58 1e 13 e0 00 LD64: s19 = *(uint64_t *)(s30 +0xe0) */
    S[19] = *(uint64_t *)((uint8_t *)S[30] + 0xe0);

L_00fa:
    /* +0x01770 op=0x5e 2d 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2d] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x2d, (void *)(uintptr_t)0x1235f600);

L_00fb:
    /* +0x01788 op=0x85 1e 16 38 01 ADD64_IMM16: s22 = s30 +0x138 */
    S[22] = S[30] + 0x138;

L_00fc:
    /* +0x017a0 op=0x34 02 00 05 00 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_00fd:
    /* +0x017b8 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_00fe:
    /* +0x017d0 op=0x5e 08 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x8, (void *)(uintptr_t)0x1235f600);

L_00ff:
    /* +0x017e8 op=0x85 1e 17 00 01 ADD64_IMM16: s23 = s30 +0x100 */
    S[23] = S[30] + 0x100;

L_0100:
    /* +0x01800 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0101:
    /* +0x01818 op=0x34 16 00 06 00 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_0102:
    /* +0x01830 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0103:
    /* +0x01848 op=0x5e 21 00 00 00 CALL_CF_INDEX: call native_binding[index=0x21] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x21, (void *)(uintptr_t)0x1235f600);

L_0104:
    /* +0x01860 op=0x85 1e 13 20 01 ADD64_IMM16: s19 = s30 +0x120 */
    S[19] = S[30] + 0x120;

L_0105:
    /* +0x01878 op=0x58 1e 05 00 01 LD64: s5 = *(uint64_t *)(s30 +0x100) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x100);

L_0106:
    /* +0x01890 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0107:
    /* +0x018a8 op=0x5e 22 00 00 00 CALL_CF_INDEX: call native_binding[index=0x22] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x22, (void *)(uintptr_t)0x1235f600);

L_0108:
    /* +0x018c0 op=0x85 1e 14 50 01 ADD64_IMM16: s20 = s30 +0x150 */
    S[20] = S[30] + 0x150;

L_0109:
    /* +0x018d8 op=0x58 1e 05 20 01 LD64: s5 = *(uint64_t *)(s30 +0x120) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x120);

L_010a:
    /* +0x018f0 op=0x34 14 00 04 00 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_010b:
    /* +0x01908 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x1235f600);

L_010c:
    /* +0x01920 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_010d:
    /* +0x01938 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_010e:
    /* +0x01950 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_010f:
    /* +0x01968 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_0110:
    /* +0x01980 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_0111:
    /* +0x01998 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0112:
    /* +0x019b0 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0113:
    /* +0x019c8 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x1235f600);

L_0114:
    /* +0x019e0 op=0x85 1e 17 38 01 ADD64_IMM16: s23 = s30 +0x138 */
    S[23] = S[30] + 0x138;

L_0115:
    /* +0x019f8 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0116:
    /* +0x01a10 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x1235f600);

L_0117:
    /* +0x01a28 op=0x85 1e 13 20 01 ADD64_IMM16: s19 = s30 +0x120 */
    S[19] = S[30] + 0x120;

L_0118:
    /* +0x01a40 op=0x85 00 15 0e 00 ADD64_IMM16: s21 = s0 +0xe */
    S[21] = S[0] + 0xe;

L_0119:
    /* +0x01a58 op=0x85 00 16 02 00 ADD64_IMM16: s22 = s0 +0x2 */
    S[22] = S[0] + 0x2;

L_011a:
    /* +0x01a70 op=0x58 1e 05 a0 01 LD64: s5 = *(uint64_t *)(s30 +0x1a0) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x1a0);

L_011b:
    /* +0x01a88 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_011c:
    /* +0x01aa0 op=0x34 15 00 06 01 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_011d:
    /* +0x01ab8 op=0x34 16 00 07 01 OR64: s7 = s22 | s0 */
    S[7] = S[22] | S[0];

L_011e:
    /* +0x01ad0 op=0x5e 53 00 00 00 CALL_CF_INDEX: call native_binding[index=0x53] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x53, (void *)(uintptr_t)0x1235f600);

L_011f:
    /* +0x01ae8 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0120:
    /* +0x01b00 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0121:
    /* +0x01b18 op=0x5e 33 00 00 00 CALL_CF_INDEX: call native_binding[index=0x33] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x33, (void *)(uintptr_t)0x1235f600);

L_0122:
    /* +0x01b30 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0123:
    /* +0x01b48 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0124:
    /* +0x01b60 op=0x85 1e 13 20 01 ADD64_IMM16: s19 = s30 +0x120 */
    S[19] = S[30] + 0x120;

L_0125:
    /* +0x01b78 op=0x58 1e 05 90 01 LD64: s5 = *(uint64_t *)(s30 +0x190) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x190);

L_0126:
    /* +0x01b90 op=0x34 15 00 06 01 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_0127:
    /* +0x01ba8 op=0x34 16 00 07 01 OR64: s7 = s22 | s0 */
    S[7] = S[22] | S[0];

L_0128:
    /* +0x01bc0 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0129:
    /* +0x01bd8 op=0x5e 53 00 00 00 CALL_CF_INDEX: call native_binding[index=0x53] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x53, (void *)(uintptr_t)0x1235f600);

L_012a:
    /* +0x01bf0 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_012b:
    /* +0x01c08 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_012c:
    /* +0x01c20 op=0x5e 33 00 00 00 CALL_CF_INDEX: call native_binding[index=0x33] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x33, (void *)(uintptr_t)0x1235f600);

L_012d:
    /* +0x01c38 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_012e:
    /* +0x01c50 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_012f:
    /* +0x01c68 op=0x85 1e 13 20 01 ADD64_IMM16: s19 = s30 +0x120 */
    S[19] = S[30] + 0x120;

L_0130:
    /* +0x01c80 op=0x58 1e 05 80 01 LD64: s5 = *(uint64_t *)(s30 +0x180) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x180);

L_0131:
    /* +0x01c98 op=0x34 15 00 06 01 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_0132:
    /* +0x01cb0 op=0x34 16 00 07 01 OR64: s7 = s22 | s0 */
    S[7] = S[22] | S[0];

L_0133:
    /* +0x01cc8 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0134:
    /* +0x01ce0 op=0x5e 53 00 00 00 CALL_CF_INDEX: call native_binding[index=0x53] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x53, (void *)(uintptr_t)0x1235f600);

L_0135:
    /* +0x01cf8 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0136:
    /* +0x01d10 op=0x34 13 00 05 00 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0137:
    /* +0x01d28 op=0x5e 33 00 00 00 CALL_CF_INDEX: call native_binding[index=0x33] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x33, (void *)(uintptr_t)0x1235f600);

L_0138:
    /* +0x01d40 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0139:
    /* +0x01d58 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_013a:
    /* +0x01d70 op=0x85 1e 15 20 01 ADD64_IMM16: s21 = s30 +0x120 */
    S[21] = S[30] + 0x120;

L_013b:
    /* +0x01d88 op=0x85 1e 05 c4 01 ADD64_IMM16: s5 = s30 +0x1c4 */
    S[5] = S[30] + 0x1c4;

L_013c:
    /* +0x01da0 op=0x85 00 06 01 00 ADD64_IMM16: s6 = s0 +0x1 */
    S[6] = S[0] + 0x1;

L_013d:
    /* +0x01db8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_013e:
    /* +0x01dd0 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x1235f600);

L_013f:
    /* +0x01de8 op=0x58 1e 01 b0 01 LD64: s1 = *(uint64_t *)(s30 +0x1b0) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x1b0);

L_0140:
    /* +0x01e00 op=0x85 00 13 00 00 ADD64_IMM16: s19 = s0 +0x0 */
    S[19] = S[0] + 0x0;

L_0141:
    /* +0x01e18 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0142:
    /* +0x01e30 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 */
    S[6] = S[19] | S[0];

L_0143:
    /* +0x01e48 op=0x58 01 04 10 00 LD64: s4 = *(uint64_t *)(s1 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[1] + 0x10);

L_0144:
    /* +0x01e60 op=0x5e 61 00 00 00 CALL_CF_INDEX: call native_binding[index=0x61] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x61, (void *)(uintptr_t)0x1235f600);

L_0145:
    /* +0x01e78 op=0x85 1e 16 00 01 ADD64_IMM16: s22 = s30 +0x100 */
    S[22] = S[30] + 0x100;

L_0146:
    /* +0x01e90 op=0x85 00 10 04 00 ADD64_IMM16: s16 = s0 +0x4 */
    S[16] = S[0] + 0x4;

L_0147:
    /* +0x01ea8 op=0x85 1e 05 1c 01 ADD64_IMM16: s5 = s30 +0x11c */
    S[5] = S[30] + 0x11c;

L_0148:
    /* +0x01ec0 op=0x08 1e 02 1c 01 ST32: *(s30 +0x11c) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x11c) = (uint32_t)S[2];

L_0149:
    /* +0x01ed8 op=0x34 16 00 04 00 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_014a:
    /* +0x01ef0 op=0x34 10 00 06 01 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_014b:
    /* +0x01f08 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x1235f600);

L_014c:
    /* +0x01f20 op=0x85 1e 11 c8 00 ADD64_IMM16: s17 = s30 +0xc8 */
    S[17] = S[30] + 0xc8;

L_014d:
    /* +0x01f38 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_014e:
    /* +0x01f50 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_014f:
    /* +0x01f68 op=0x34 17 00 06 01 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_0150:
    /* +0x01f80 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0151:
    /* +0x01f98 op=0x08 1e 01 fc 00 ST32: *(s30 +0xfc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xfc) = (uint32_t)S[1];

L_0152:
    /* +0x01fb0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_0153:
    /* +0x01fc8 op=0x85 1e 17 b0 00 ADD64_IMM16: s23 = s30 +0xb0 */
    S[23] = S[30] + 0xb0;

L_0154:
    /* +0x01fe0 op=0x85 1e 05 fc 00 ADD64_IMM16: s5 = s30 +0xfc */
    S[5] = S[30] + 0xfc;

L_0155:
    /* +0x01ff8 op=0x34 10 00 06 01 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_0156:
    /* +0x02010 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0157:
    /* +0x02028 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x1235f600);

L_0158:
    /* +0x02040 op=0x85 1e 12 e0 00 ADD64_IMM16: s18 = s30 +0xe0 */
    S[18] = S[30] + 0xe0;

L_0159:
    /* +0x02058 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_015a:
    /* +0x02070 op=0x34 17 00 06 01 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_015b:
    /* +0x02088 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_015c:
    /* +0x020a0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_015d:
    /* +0x020b8 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_015e:
    /* +0x020d0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_015f:
    /* +0x020e8 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0160:
    /* +0x02100 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0161:
    /* +0x02118 op=0x85 1e 10 b0 00 ADD64_IMM16: s16 = s30 +0xb0 */
    S[16] = S[30] + 0xb0;

L_0162:
    /* +0x02130 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0163:
    /* +0x02148 op=0x34 16 00 06 01 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_0164:
    /* +0x02160 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0165:
    /* +0x02178 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_0166:
    /* +0x02190 op=0x85 1e 11 c8 00 ADD64_IMM16: s17 = s30 +0xc8 */
    S[17] = S[30] + 0xc8;

L_0167:
    /* +0x021a8 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_0168:
    /* +0x021c0 op=0x34 14 00 06 00 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_0169:
    /* +0x021d8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_016a:
    /* +0x021f0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_016b:
    /* +0x02208 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_016c:
    /* +0x02220 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_016d:
    /* +0x02238 op=0x85 1e 10 98 00 ADD64_IMM16: s16 = s30 +0x98 */
    S[16] = S[30] + 0x98;

L_016e:
    /* +0x02250 op=0x34 12 00 05 01 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_016f:
    /* +0x02268 op=0x34 11 00 06 01 OR64: s6 = s17 | s0 */
    S[6] = S[17] | S[0];

L_0170:
    /* +0x02280 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0171:
    /* +0x02298 op=0x5e 62 00 00 00 CALL_CF_INDEX: call native_binding[index=0x62] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x62, (void *)(uintptr_t)0x1235f600);

L_0172:
    /* +0x022b0 op=0x85 1e 11 b0 00 ADD64_IMM16: s17 = s30 +0xb0 */
    S[17] = S[30] + 0xb0;

L_0173:
    /* +0x022c8 op=0x58 1e 05 98 00 LD64: s5 = *(uint64_t *)(s30 +0x98) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x98);

L_0174:
    /* +0x022e0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0175:
    /* +0x022f8 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x1235f600);

L_0176:
    /* +0x02310 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0177:
    /* +0x02328 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_0178:
    /* +0x02340 op=0x85 1e 10 80 00 ADD64_IMM16: s16 = s30 +0x80 */
    S[16] = S[30] + 0x80;

L_0179:
    /* +0x02358 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_017a:
    /* +0x02370 op=0x34 16 00 06 01 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_017b:
    /* +0x02388 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_017c:
    /* +0x023a0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_017d:
    /* +0x023b8 op=0x85 1e 04 98 00 ADD64_IMM16: s4 = s30 +0x98 */
    S[4] = S[30] + 0x98;

L_017e:
    /* +0x023d0 op=0x34 10 00 05 00 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_017f:
    /* +0x023e8 op=0x34 11 00 06 00 OR64: s6 = s17 | s0 */
    S[6] = S[17] | S[0];

L_0180:
    /* +0x02400 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_0181:
    /* +0x02418 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0182:
    /* +0x02430 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0183:
    /* +0x02448 op=0x85 1e 10 60 00 ADD64_IMM16: s16 = s30 +0x60 */
    S[16] = S[30] + 0x60;

L_0184:
    /* +0x02460 op=0x52 1e 14 a4 00 LD32S: s20 = *(int32_t *)(s30 +0xa4) */
    S[20] = *(int32_t *)((uint8_t *)S[30] + 0xa4);

L_0185:
    /* +0x02478 op=0x34 15 00 05 00 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0186:
    /* +0x02490 op=0x34 16 00 06 00 OR64: s6 = s22 | s0 */
    S[6] = S[22] | S[0];

L_0187:
    /* +0x024a8 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0188:
    /* +0x024c0 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_0189:
    /* +0x024d8 op=0x85 1e 11 80 00 ADD64_IMM16: s17 = s30 +0x80 */
    S[17] = S[30] + 0x80;

L_018a:
    /* +0x024f0 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_018b:
    /* +0x02508 op=0x34 12 00 06 01 OR64: s6 = s18 | s0 */
    S[6] = S[18] | S[0];

L_018c:
    /* +0x02520 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_018d:
    /* +0x02538 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_018e:
    /* +0x02550 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_018f:
    /* +0x02568 op=0x5e 63 00 00 00 CALL_CF_INDEX: call native_binding[index=0x63] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x63, (void *)(uintptr_t)0x1235f600);

L_0190:
    /* +0x02580 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0191:
    /* +0x02598 op=0x34 02 00 12 01 OR64: s18 = s2 | s0 */
    S[18] = S[2] | S[0];

L_0192:
    /* +0x025b0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0193:
    /* +0x025c8 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0194:
    /* +0x025e0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_0195:
    /* +0x025f8 op=0x85 1e 10 80 00 ADD64_IMM16: s16 = s30 +0x80 */
    S[16] = S[30] + 0x80;

L_0196:
    /* +0x02610 op=0x26 1e 12 7c 00 ST8: *(s30 +0x7c) = (uint8_t)s18 */
    *(uint8_t *)((uint8_t *)S[30] + 0x7c) = (uint8_t)S[18];

L_0197:
    /* +0x02628 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0198:
    /* +0x02640 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x1235f600);

L_0199:
    /* +0x02658 op=0x52 1e 05 a4 00 LD32S: s5 = *(int32_t *)(s30 +0xa4) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0xa4);

L_019a:
    /* +0x02670 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_019b:
    /* +0x02688 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 */
    S[6] = S[19] | S[0];

L_019c:
    /* +0x026a0 op=0x5e 00 00 00 00 CALL_CF_INDEX: call native_binding[index=0x0] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x0, (void *)(uintptr_t)0x1235f600);

L_019d:
    /* +0x026b8 op=0x15 14 01 01 00 CMP_LT_IMM64S: s1 = ((int64_t)s20 < 1) ? 1 : 0 */
    S[1] = ((int64_t)S[20] < 0x1) ? 1 : 0;

L_019e:
    /* +0x026d0 op=0x1f 14 01 01 00 CMOVZ64: s1 = (s1 == 0) ? s20 : 0 */
    S[1] = (S[1] == 0) ? S[20] : 0;

L_019f:
    /* +0x026e8 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) */
    S[1] = S[1] << (0 + 32);

L_01a0:
    /* +0x02700 op=0x67 00 01 02 00 LSR64_IMM32PLUS: s2 = (uint64_t)s1 >> (0 + 32) */
    S[2] = (uint64_t)S[1] >> (0 + 32);

L_01a1:
    /* +0x02718 op=0xae 02 13 0a 00 BR_EQ64: if (s2 == s19) goto record +428 */
    if (S[2] == S[19]) goto L_01ac;

L_01a2:
    /* +0x02730 op=0x58 1e 03 a8 00 LD64: s3 = *(uint64_t *)(s30 +0xa8) */
    S[3] = *(uint64_t *)((uint8_t *)S[30] + 0xa8);

L_01a3:
    /* +0x02748 op=0x58 1e 01 90 00 LD64: s1 = *(uint64_t *)(s30 +0x90) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x90);

L_01a4:
    /* +0x02760 op=0x59 1e 04 7c 00 LD8U: s4 = *(uint8_t *)(s30 +0x7c) */
    S[4] = *(uint8_t *)((uint8_t *)S[30] + 0x7c);

L_01a5:
    /* +0x02778 op=0x84 03 13 03 04 ADD64: s3 = s3 + s19 */
    S[3] = S[3] + S[19];

L_01a6:
    /* +0x02790 op=0x84 01 13 01 04 ADD64: s1 = s1 + s19 */
    S[1] = S[1] + S[19];

L_01a7:
    /* +0x027a8 op=0x85 13 13 01 00 ADD64_IMM16: s19 = s19 +0x1 */
    S[19] = S[19] + 0x1;

L_01a8:
    /* +0x027c0 op=0x59 03 03 00 00 LD8U: s3 = *(uint8_t *)(s3 +0x0) */
    S[3] = *(uint8_t *)((uint8_t *)S[3] + 0x0);

L_01a9:
    /* +0x027d8 op=0x02 04 03 03 00 XOR64: s3 = s3 ^ s4 */
    S[3] = S[3] ^ S[4];

L_01aa:
    /* +0x027f0 op=0x26 01 03 00 00 ST8: *(s1 +0x0) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[3];

L_01ab:
    /* +0x02808 op=0xa7 02 13 f6 ff BR_NE64: if (s2 != s19) goto record +418 */
    if (S[2] != S[19]) goto L_01a2;

L_01ac:
    /* +0x02820 op=0x85 1e 12 60 00 ADD64_IMM16: s18 = s30 +0x60 */
    S[18] = S[30] + 0x60;

L_01ad:
    /* +0x02838 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_01ae:
    /* +0x02850 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x1235f600);

L_01af:
    /* +0x02868 op=0x85 1e 13 48 00 ADD64_IMM16: s19 = s30 +0x48 */
    S[19] = S[30] + 0x48;

L_01b0:
    /* +0x02880 op=0x85 1e 05 7c 00 ADD64_IMM16: s5 = s30 +0x7c */
    S[5] = S[30] + 0x7c;

L_01b1:
    /* +0x02898 op=0x85 00 06 01 00 ADD64_IMM16: s6 = s0 +0x1 */
    S[6] = S[0] + 0x1;

L_01b2:
    /* +0x028b0 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_01b3:
    /* +0x028c8 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x1235f600);

L_01b4:
    /* +0x028e0 op=0x85 1e 10 20 00 ADD64_IMM16: s16 = s30 +0x20 */
    S[16] = S[30] + 0x20;

L_01b5:
    /* +0x028f8 op=0x85 1e 14 80 00 ADD64_IMM16: s20 = s30 +0x80 */
    S[20] = S[30] + 0x80;

L_01b6:
    /* +0x02910 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_01b7:
    /* +0x02928 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_01b8:
    /* +0x02940 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_01b9:
    /* +0x02958 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x1235f600);

L_01ba:
    /* +0x02970 op=0x85 1e 11 38 00 ADD64_IMM16: s17 = s30 +0x38 */
    S[17] = S[30] + 0x38;

L_01bb:
    /* +0x02988 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_01bc:
    /* +0x029a0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_01bd:
    /* +0x029b8 op=0x5e 2b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2b] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x2b, (void *)(uintptr_t)0x1235f600);

L_01be:
    /* +0x029d0 op=0x58 1e 05 38 00 LD64: s5 = *(uint64_t *)(s30 +0x38) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_01bf:
    /* +0x029e8 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_01c0:
    /* +0x02a00 op=0x5e 06 00 00 00 CALL_CF_INDEX: call native_binding[index=0x6] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x6, (void *)(uintptr_t)0x1235f600);

L_01c1:
    /* +0x02a18 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_01c2:
    /* +0x02a30 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_01c3:
    /* +0x02a48 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_01c4:
    /* +0x02a60 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01c5:
    /* +0x02a78 op=0x85 00 10 03 00 ADD64_IMM16: s16 = s0 +0x3 */
    S[16] = S[0] + 0x3;

L_01c6:
    /* +0x02a90 op=0x85 1e 04 f8 01 ADD64_IMM16: s4 = s30 +0x1f8 */
    S[4] = S[30] + 0x1f8;

L_01c7:
    /* +0x02aa8 op=0x34 10 00 05 00 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_01c8:
    /* +0x02ac0 op=0x5e 2f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2f] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x2f, (void *)(uintptr_t)0x1235f600);

L_01c9:
    /* +0x02ad8 op=0x85 1e 04 e8 01 ADD64_IMM16: s4 = s30 +0x1e8 */
    S[4] = S[30] + 0x1e8;

L_01ca:
    /* +0x02af0 op=0x85 00 05 09 00 ADD64_IMM16: s5 = s0 +0x9 */
    S[5] = S[0] + 0x9;

L_01cb:
    /* +0x02b08 op=0x34 02 00 11 01 OR64: s17 = s2 | s0 */
    S[17] = S[2] | S[0];

L_01cc:
    /* +0x02b20 op=0x5e 19 00 00 00 CALL_CF_INDEX: call native_binding[index=0x19] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x19, (void *)(uintptr_t)0x1235f600);

L_01cd:
    /* +0x02b38 op=0x58 1e 04 10 00 LD64: s4 = *(uint64_t *)(s30 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_01ce:
    /* +0x02b50 op=0x34 02 00 06 00 OR64: s6 = s2 | s0 */
    S[6] = S[2] | S[0];

L_01cf:
    /* +0x02b68 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_01d0:
    /* +0x02b80 op=0x5e 64 00 00 00 CALL_CF_INDEX: call native_binding[index=0x64] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x64, (void *)(uintptr_t)0x1235f600);

L_01d1:
    /* +0x02b98 op=0x85 1e 04 fc 01 ADD64_IMM16: s4 = s30 +0x1fc */
    S[4] = S[30] + 0x1fc;

L_01d2:
    /* +0x02bb0 op=0x34 10 00 05 00 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_01d3:
    /* +0x02bc8 op=0x5e 20 00 00 00 CALL_CF_INDEX: call native_binding[index=0x20] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x20, (void *)(uintptr_t)0x1235f600);

L_01d4:
    /* +0x02be0 op=0x58 1e 06 70 00 LD64: s6 = *(uint64_t *)(s30 +0x70) */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0x70);

L_01d5:
    /* +0x02bf8 op=0x58 1e 04 18 00 LD64: s4 = *(uint64_t *)(s30 +0x18) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_01d6:
    /* +0x02c10 op=0x34 02 00 05 00 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_01d7:
    /* +0x02c28 op=0x5e 64 00 00 00 CALL_CF_INDEX: call native_binding[index=0x64] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x64, (void *)(uintptr_t)0x1235f600);

L_01d8:
    /* +0x02c40 op=0x34 13 00 04 01 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_01d9:
    /* +0x02c58 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01da:
    /* +0x02c70 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_01db:
    /* +0x02c88 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01dc:
    /* +0x02ca0 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_01dd:
    /* +0x02cb8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01de:
    /* +0x02cd0 op=0x85 1e 04 98 00 ADD64_IMM16: s4 = s30 +0x98 */
    S[4] = S[30] + 0x98;

L_01df:
    /* +0x02ce8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01e0:
    /* +0x02d00 op=0x85 1e 04 b0 00 ADD64_IMM16: s4 = s30 +0xb0 */
    S[4] = S[30] + 0xb0;

L_01e1:
    /* +0x02d18 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01e2:
    /* +0x02d30 op=0x85 1e 04 c8 00 ADD64_IMM16: s4 = s30 +0xc8 */
    S[4] = S[30] + 0xc8;

L_01e3:
    /* +0x02d48 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01e4:
    /* +0x02d60 op=0x85 1e 04 e0 00 ADD64_IMM16: s4 = s30 +0xe0 */
    S[4] = S[30] + 0xe0;

L_01e5:
    /* +0x02d78 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01e6:
    /* +0x02d90 op=0x85 1e 04 00 01 ADD64_IMM16: s4 = s30 +0x100 */
    S[4] = S[30] + 0x100;

L_01e7:
    /* +0x02da8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01e8:
    /* +0x02dc0 op=0x85 1e 04 20 01 ADD64_IMM16: s4 = s30 +0x120 */
    S[4] = S[30] + 0x120;

L_01e9:
    /* +0x02dd8 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01ea:
    /* +0x02df0 op=0x85 1e 04 38 01 ADD64_IMM16: s4 = s30 +0x138 */
    S[4] = S[30] + 0x138;

L_01eb:
    /* +0x02e08 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01ec:
    /* +0x02e20 op=0x85 1e 04 50 01 ADD64_IMM16: s4 = s30 +0x150 */
    S[4] = S[30] + 0x150;

L_01ed:
    /* +0x02e38 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01ee:
    /* +0x02e50 op=0x85 1e 04 68 01 ADD64_IMM16: s4 = s30 +0x168 */
    S[4] = S[30] + 0x168;

L_01ef:
    /* +0x02e68 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x1235f600);

L_01f0:
    /* +0x02e80 op=0x85 1e 04 80 01 ADD64_IMM16: s4 = s30 +0x180 */
    S[4] = S[30] + 0x180;

L_01f1:
    /* +0x02e98 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_01f2:
    /* +0x02eb0 op=0x85 1e 04 90 01 ADD64_IMM16: s4 = s30 +0x190 */
    S[4] = S[30] + 0x190;

L_01f3:
    /* +0x02ec8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_01f4:
    /* +0x02ee0 op=0x85 1e 04 a0 01 ADD64_IMM16: s4 = s30 +0x1a0 */
    S[4] = S[30] + 0x1a0;

L_01f5:
    /* +0x02ef8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_01f6:
    /* +0x02f10 op=0x85 1e 04 b0 01 ADD64_IMM16: s4 = s30 +0x1b0 */
    S[4] = S[30] + 0x1b0;

L_01f7:
    /* +0x02f28 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x1235f600 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x1235f600);

L_01f8:
    /* +0x02f40 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_01f9:
    /* +0x02f58 op=0x58 1d 10 00 02 LD64: s16 = *(uint64_t *)(s29 +0x200) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x200);

L_01fa:
    /* +0x02f70 op=0x58 1d 11 08 02 LD64: s17 = *(uint64_t *)(s29 +0x208) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x208);

L_01fb:
    /* +0x02f88 op=0x58 1d 12 10 02 LD64: s18 = *(uint64_t *)(s29 +0x210) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x210);

L_01fc:
    /* +0x02fa0 op=0x58 1d 13 18 02 LD64: s19 = *(uint64_t *)(s29 +0x218) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x218);

L_01fd:
    /* +0x02fb8 op=0x58 1d 14 20 02 LD64: s20 = *(uint64_t *)(s29 +0x220) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x220);

L_01fe:
    /* +0x02fd0 op=0x58 1d 15 28 02 LD64: s21 = *(uint64_t *)(s29 +0x228) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x228);

L_01ff:
    /* +0x02fe8 op=0x58 1d 16 30 02 LD64: s22 = *(uint64_t *)(s29 +0x230) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x230);

L_0200:
    /* +0x03000 op=0x58 1d 17 38 02 LD64: s23 = *(uint64_t *)(s29 +0x238) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x238);

L_0201:
    /* +0x03018 op=0x58 1d 1e 40 02 LD64: s30 = *(uint64_t *)(s29 +0x240) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x240);

L_0202:
    /* +0x03030 op=0x58 1d 1f 48 02 LD64: s31 = *(uint64_t *)(s29 +0x248) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x248);

L_0203:
    /* +0x03048 op=0x85 1d 1d 50 02 ADD64_IMM16: s29 = s29 +0x250 */
    S[29] = S[29] + 0x250;

L_0204:
    /* +0x03060 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

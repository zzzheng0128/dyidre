/*
 * Auto-generated linear C-like lift for 350.101 managed program F23.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F23_0x5ca000_0xfc0.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F23_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d 70 ff ADD64_IMM16: s29 = s29 -0x90 */
    S[29] = S[29] + (-0x90);

L_0001:
    /* +0x00018 op=0x25 1d 1f 88 00 ST64: *(s29 +0x88) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x88) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 80 00 ST64: *(s29 +0x80) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x80) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 78 00 ST64: *(s29 +0x78) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x78) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 70 00 ST64: *(s29 +0x70) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x70) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 68 00 ST64: *(s29 +0x68) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x68) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 60 00 ST64: *(s29 +0x60) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x60) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 58 00 ST64: *(s29 +0x58) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x58) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 50 00 ST64: *(s29 +0x50) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x50) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 48 00 ST64: *(s29 +0x48) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x48) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 40 00 ST64: *(s29 +0x40) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x40) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x53 01 01 48 0c LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0xc48 q1=0x125fd3a8 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc48;

L_000d:
    /* +0x00138 op=0x34 04 00 10 01 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_000e:
    /* +0x00150 op=0x53 03 04 18 0c LD_POOL_PTR: s4 = *(uint64_t *)q1 + 0xc18 q1=0x125fd3a8 */
    S[4] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc18;

L_000f:
    /* +0x00168 op=0x53 04 02 38 0c LD_POOL_PTR: s2 = *(uint64_t *)q1 + 0xc38 q1=0x125fd3a8 */
    S[2] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc38;

L_0010:
    /* +0x00180 op=0x53 01 03 28 0c LD_POOL_PTR: s3 = *(uint64_t *)q1 + 0xc28 q1=0x125fd3a8 */
    S[3] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc28;

L_0011:
    /* +0x00198 op=0x53 03 05 08 0c LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0xc08 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc08;

L_0012:
    /* +0x001b0 op=0x53 04 06 f8 0b LD_POOL_PTR: s6 = *(uint64_t *)q1 + 0xbf8 q1=0x125fd3a8 */
    S[6] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xbf8;

L_0013:
    /* +0x001c8 op=0x53 01 07 e8 0b LD_POOL_PTR: s7 = *(uint64_t *)q1 + 0xbe8 q1=0x125fd3a8 */
    S[7] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xbe8;

L_0014:
    /* +0x001e0 op=0x53 04 08 d8 0b LD_POOL_PTR: s8 = *(uint64_t *)q1 + 0xbd8 q1=0x125fd3a8 */
    S[8] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xbd8;

L_0015:
    /* +0x001f8 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0016:
    /* +0x00210 op=0x58 04 04 00 00 LD64: s4 = *(uint64_t *)(s4 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_0017:
    /* +0x00228 op=0x58 05 13 00 00 LD64: s19 = *(uint64_t *)(s5 +0x0) */
    S[19] = *(uint64_t *)((uint8_t *)S[5] + 0x0);

L_0018:
    /* +0x00240 op=0x58 03 03 00 00 LD64: s3 = *(uint64_t *)(s3 +0x0) */
    S[3] = *(uint64_t *)((uint8_t *)S[3] + 0x0);

L_0019:
    /* +0x00258 op=0x58 02 02 00 00 LD64: s2 = *(uint64_t *)(s2 +0x0) */
    S[2] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_001a:
    /* +0x00270 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_001b:
    /* +0x00288 op=0x58 06 14 00 00 LD64: s20 = *(uint64_t *)(s6 +0x0) */
    S[20] = *(uint64_t *)((uint8_t *)S[6] + 0x0);

L_001c:
    /* +0x002a0 op=0x58 08 16 00 00 LD64: s22 = *(uint64_t *)(s8 +0x0) */
    S[22] = *(uint64_t *)((uint8_t *)S[8] + 0x0);

L_001d:
    /* +0x002b8 op=0x58 07 15 00 00 LD64: s21 = *(uint64_t *)(s7 +0x0) */
    S[21] = *(uint64_t *)((uint8_t *)S[7] + 0x0);

L_001e:
    /* +0x002d0 op=0x34 05 00 06 00 OR64: s6 = s5 | s0 */
    S[6] = S[5] | S[0];

L_001f:
    /* +0x002e8 op=0x25 1e 01 20 00 ST64: *(s30 +0x20) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x20) = S[1];

L_0020:
    /* +0x00300 op=0x53 04 01 58 0c LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0xc58 q1=0x125fd3a8 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc58;

L_0021:
    /* +0x00318 op=0x25 1e 04 08 00 ST64: *(s30 +0x8) = s4 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[4];

L_0022:
    /* +0x00330 op=0x25 1e 03 10 00 ST64: *(s30 +0x10) = s3 */
    *(uint64_t *)((uint8_t *)S[30] + 0x10) = S[3];

L_0023:
    /* +0x00348 op=0x25 1e 02 18 00 ST64: *(s30 +0x18) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[2];

L_0024:
    /* +0x00360 op=0x58 01 17 00 00 LD64: s23 = *(uint64_t *)(s1 +0x0) */
    S[23] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0025:
    /* +0x00378 op=0x53 01 01 78 0c LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0xc78 q1=0x125fd3a8 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc78;

L_0026:
    /* +0x00390 op=0x58 01 12 00 00 LD64: s18 = *(uint64_t *)(s1 +0x0) */
    S[18] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0027:
    /* +0x003a8 op=0x53 04 01 68 0c LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0xc68 q1=0x125fd3a8 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0xc68;

L_0028:
    /* +0x003c0 op=0x58 01 11 00 00 LD64: s17 = *(uint64_t *)(s1 +0x0) */
    S[17] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0029:
    /* +0x003d8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_002a:
    /* +0x003f0 op=0x5e 0f 00 00 00 CALL_CF_INDEX: call native_binding[index=0xf] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xf, (void *)(uintptr_t)0x125fd360);

L_002b:
    /* +0x00408 op=0xb2 02 01 01 00 AND64_IMM16: s1 = s2 & 0x1 */
    S[1] = S[2] & 0x1;

L_002c:
    /* +0x00420 op=0xae 01 00 6c 00 BR_EQ64: if (s1 == s0) goto record +153 */
    if (S[1] == S[0]) goto L_0099;

L_002d:
    /* +0x00438 op=0x58 16 01 00 00 LD64: s1 = *(uint64_t *)(s22 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[22] + 0x0);

L_002e:
    /* +0x00450 op=0xa7 01 00 48 00 BR_NE64: if (s1 != s0) goto record +119 */
    if (S[1] != S[0]) goto L_0077;

L_002f:
    /* +0x00468 op=0x58 17 01 00 00 LD64: s1 = *(uint64_t *)(s23 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_0030:
    /* +0x00480 op=0x85 12 02 10 00 ADD64_IMM16: s2 = s18 +0x10 */
    S[2] = S[18] + 0x10;

L_0031:
    /* +0x00498 op=0x85 01 04 08 00 ADD64_IMM16: s4 = s1 +0x8 */
    S[4] = S[1] + 0x8;

L_0032:
    /* +0x004b0 op=0x25 1e 01 30 00 ST64: *(s30 +0x30) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x30) = S[1];

L_0033:
    /* +0x004c8 op=0x25 1e 02 28 00 ST64: *(s30 +0x28) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x28) = S[2];

L_0034:
    /* +0x004e0 op=0x5e 10 00 00 00 CALL_CF_INDEX: call native_binding[index=0x10] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x10, (void *)(uintptr_t)0x125fd360);

L_0035:
    /* +0x004f8 op=0x08 1e 02 38 00 ST32: *(s30 +0x38) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x38) = (uint32_t)S[2];

L_0036:
    /* +0x00510 op=0x58 16 01 00 00 LD64: s1 = *(uint64_t *)(s22 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[22] + 0x0);

L_0037:
    /* +0x00528 op=0xa7 01 00 3d 00 BR_NE64: if (s1 != s0) goto record +117 */
    if (S[1] != S[0]) goto L_0075;

L_0038:
    /* +0x00540 op=0x85 00 12 00 08 ADD64_IMM16: s18 = s0 +0x800 */
    S[18] = S[0] + 0x800;

L_0039:
    /* +0x00558 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_003a:
    /* +0x00570 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_003b:
    /* +0x00588 op=0x34 02 00 04 00 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_003c:
    /* +0x005a0 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_003d:
    /* +0x005b8 op=0x34 12 00 06 01 OR64: s6 = s18 | s0 */
    S[6] = S[18] | S[0];

L_003e:
    /* +0x005d0 op=0x25 1e 02 00 00 ST64: *(s30 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x0) = S[2];

L_003f:
    /* +0x005e8 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd360);

L_0040:
    /* +0x00600 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0041:
    /* +0x00618 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_0042:
    /* +0x00630 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0043:
    /* +0x00648 op=0x25 15 02 00 00 ST64: *(s21 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[21] + 0x0) = S[2];

L_0044:
    /* +0x00660 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_0045:
    /* +0x00678 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0046:
    /* +0x00690 op=0x25 14 02 00 00 ST64: *(s20 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[20] + 0x0) = S[2];

L_0047:
    /* +0x006a8 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_0048:
    /* +0x006c0 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0049:
    /* +0x006d8 op=0x25 13 02 00 00 ST64: *(s19 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[19] + 0x0) = S[2];

L_004a:
    /* +0x006f0 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_004b:
    /* +0x00708 op=0x58 1e 17 08 00 LD64: s23 = *(uint64_t *)(s30 +0x8) */
    S[23] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_004c:
    /* +0x00720 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_004d:
    /* +0x00738 op=0x25 17 02 00 00 ST64: *(s23 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[23] + 0x0) = S[2];

L_004e:
    /* +0x00750 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_004f:
    /* +0x00768 op=0x58 1e 11 10 00 LD64: s17 = *(uint64_t *)(s30 +0x10) */
    S[17] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_0050:
    /* +0x00780 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0051:
    /* +0x00798 op=0x25 11 02 00 00 ST64: *(s17 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[17] + 0x0) = S[2];

L_0052:
    /* +0x007b0 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_0053:
    /* +0x007c8 op=0x58 1e 01 18 00 LD64: s1 = *(uint64_t *)(s30 +0x18) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_0054:
    /* +0x007e0 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0055:
    /* +0x007f8 op=0x25 01 02 00 00 ST64: *(s1 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[1] + 0x0) = S[2];

L_0056:
    /* +0x00810 op=0x5e 11 00 00 00 CALL_CF_INDEX: call native_binding[index=0x11] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x11, (void *)(uintptr_t)0x125fd360);

L_0057:
    /* +0x00828 op=0x58 1e 12 00 00 LD64: s18 = *(uint64_t *)(s30 +0x0) */
    S[18] = *(uint64_t *)((uint8_t *)S[30] + 0x0);

L_0058:
    /* +0x00840 op=0x58 1e 01 20 00 LD64: s1 = *(uint64_t *)(s30 +0x20) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_0059:
    /* +0x00858 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_005a:
    /* +0x00870 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_005b:
    /* +0x00888 op=0x25 01 02 00 00 ST64: *(s1 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[1] + 0x0) = S[2];

L_005c:
    /* +0x008a0 op=0x5e 56 00 00 00 CALL_CF_INDEX: call native_binding[index=0x56] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x56, (void *)(uintptr_t)0x125fd360);

L_005d:
    /* +0x008b8 op=0x58 15 05 00 00 LD64: s5 = *(uint64_t *)(s21 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[21] + 0x0);

L_005e:
    /* +0x008d0 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_005f:
    /* +0x008e8 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0060:
    /* +0x00900 op=0x58 14 05 00 00 LD64: s5 = *(uint64_t *)(s20 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[20] + 0x0);

L_0061:
    /* +0x00918 op=0x58 15 04 00 00 LD64: s4 = *(uint64_t *)(s21 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[21] + 0x0);

L_0062:
    /* +0x00930 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0063:
    /* +0x00948 op=0x58 13 05 00 00 LD64: s5 = *(uint64_t *)(s19 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[19] + 0x0);

L_0064:
    /* +0x00960 op=0x58 14 04 00 00 LD64: s4 = *(uint64_t *)(s20 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[20] + 0x0);

L_0065:
    /* +0x00978 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0066:
    /* +0x00990 op=0x58 17 05 00 00 LD64: s5 = *(uint64_t *)(s23 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_0067:
    /* +0x009a8 op=0x58 13 04 00 00 LD64: s4 = *(uint64_t *)(s19 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[19] + 0x0);

L_0068:
    /* +0x009c0 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0069:
    /* +0x009d8 op=0x58 11 05 00 00 LD64: s5 = *(uint64_t *)(s17 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[17] + 0x0);

L_006a:
    /* +0x009f0 op=0x58 17 04 00 00 LD64: s4 = *(uint64_t *)(s23 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_006b:
    /* +0x00a08 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_006c:
    /* +0x00a20 op=0x58 1e 17 18 00 LD64: s23 = *(uint64_t *)(s30 +0x18) */
    S[23] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_006d:
    /* +0x00a38 op=0x58 11 04 00 00 LD64: s4 = *(uint64_t *)(s17 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[17] + 0x0);

L_006e:
    /* +0x00a50 op=0x58 17 05 00 00 LD64: s5 = *(uint64_t *)(s23 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_006f:
    /* +0x00a68 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0070:
    /* +0x00a80 op=0x58 1e 01 20 00 LD64: s1 = *(uint64_t *)(s30 +0x20) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_0071:
    /* +0x00a98 op=0x58 17 04 00 00 LD64: s4 = *(uint64_t *)(s23 +0x0) */
    S[4] = *(uint64_t *)((uint8_t *)S[23] + 0x0);

L_0072:
    /* +0x00ab0 op=0x58 01 05 00 00 LD64: s5 = *(uint64_t *)(s1 +0x0) */
    S[5] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0073:
    /* +0x00ac8 op=0x5e 57 00 00 00 CALL_CF_INDEX: call native_binding[index=0x57] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x57, (void *)(uintptr_t)0x125fd360);

L_0074:
    /* +0x00ae0 op=0x25 16 12 00 00 ST64: *(s22 +0x0) = s18 */
    *(uint64_t *)((uint8_t *)S[22] + 0x0) = S[18];

L_0075:
    /* +0x00af8 op=0x85 1e 04 28 00 ADD64_IMM16: s4 = s30 +0x28 */
    S[4] = S[30] + 0x28;

L_0076:
    /* +0x00b10 op=0x5e 12 00 00 00 CALL_CF_INDEX: call native_binding[index=0x12] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x12, (void *)(uintptr_t)0x125fd360);

L_0077:
    /* +0x00b28 op=0xae 10 00 14 00 BR_EQ64: if (s16 == s0) goto record +140 */
    if (S[16] == S[0]) goto L_008c;

L_0078:
    /* +0x00b40 op=0x58 16 01 00 00 LD64: s1 = *(uint64_t *)(s22 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[22] + 0x0);

L_0079:
    /* +0x00b58 op=0x25 10 01 a8 00 ST64: *(s16 +0xa8) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xa8) = S[1];

L_007a:
    /* +0x00b70 op=0x58 15 01 00 00 LD64: s1 = *(uint64_t *)(s21 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[21] + 0x0);

L_007b:
    /* +0x00b88 op=0x25 10 01 b0 00 ST64: *(s16 +0xb0) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xb0) = S[1];

L_007c:
    /* +0x00ba0 op=0x58 14 01 00 00 LD64: s1 = *(uint64_t *)(s20 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[20] + 0x0);

L_007d:
    /* +0x00bb8 op=0x25 10 01 b8 00 ST64: *(s16 +0xb8) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xb8) = S[1];

L_007e:
    /* +0x00bd0 op=0x58 13 01 00 00 LD64: s1 = *(uint64_t *)(s19 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[19] + 0x0);

L_007f:
    /* +0x00be8 op=0x25 10 01 c0 00 ST64: *(s16 +0xc0) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xc0) = S[1];

L_0080:
    /* +0x00c00 op=0x58 1e 01 08 00 LD64: s1 = *(uint64_t *)(s30 +0x8) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_0081:
    /* +0x00c18 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0082:
    /* +0x00c30 op=0x25 10 01 c8 00 ST64: *(s16 +0xc8) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xc8) = S[1];

L_0083:
    /* +0x00c48 op=0x58 1e 01 10 00 LD64: s1 = *(uint64_t *)(s30 +0x10) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_0084:
    /* +0x00c60 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0085:
    /* +0x00c78 op=0x25 10 01 d0 00 ST64: *(s16 +0xd0) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xd0) = S[1];

L_0086:
    /* +0x00c90 op=0x58 1e 01 18 00 LD64: s1 = *(uint64_t *)(s30 +0x18) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_0087:
    /* +0x00ca8 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0088:
    /* +0x00cc0 op=0x25 10 01 d8 00 ST64: *(s16 +0xd8) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xd8) = S[1];

L_0089:
    /* +0x00cd8 op=0x58 1e 01 20 00 LD64: s1 = *(uint64_t *)(s30 +0x20) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x20);

L_008a:
    /* +0x00cf0 op=0x58 01 01 00 00 LD64: s1 = *(uint64_t *)(s1 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_008b:
    /* +0x00d08 op=0x25 10 01 e0 00 ST64: *(s16 +0xe0) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0xe0) = S[1];

L_008c:
    /* +0x00d20 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_008d:
    /* +0x00d38 op=0x58 1d 10 40 00 LD64: s16 = *(uint64_t *)(s29 +0x40) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x40);

L_008e:
    /* +0x00d50 op=0x58 1d 11 48 00 LD64: s17 = *(uint64_t *)(s29 +0x48) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x48);

L_008f:
    /* +0x00d68 op=0x58 1d 12 50 00 LD64: s18 = *(uint64_t *)(s29 +0x50) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x50);

L_0090:
    /* +0x00d80 op=0x58 1d 13 58 00 LD64: s19 = *(uint64_t *)(s29 +0x58) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x58);

L_0091:
    /* +0x00d98 op=0x58 1d 14 60 00 LD64: s20 = *(uint64_t *)(s29 +0x60) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x60);

L_0092:
    /* +0x00db0 op=0x58 1d 15 68 00 LD64: s21 = *(uint64_t *)(s29 +0x68) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x68);

L_0093:
    /* +0x00dc8 op=0x58 1d 16 70 00 LD64: s22 = *(uint64_t *)(s29 +0x70) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x70);

L_0094:
    /* +0x00de0 op=0x58 1d 17 78 00 LD64: s23 = *(uint64_t *)(s29 +0x78) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x78);

L_0095:
    /* +0x00df8 op=0x58 1d 1e 80 00 LD64: s30 = *(uint64_t *)(s29 +0x80) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x80);

L_0096:
    /* +0x00e10 op=0x58 1d 1f 88 00 LD64: s31 = *(uint64_t *)(s29 +0x88) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x88);

L_0097:
    /* +0x00e28 op=0x85 1d 1d 90 00 ADD64_IMM16: s29 = s29 +0x90 */
    S[29] = S[29] + 0x90;

L_0098:
    /* +0x00e40 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

L_0099:
    /* +0x00e58 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_009a:
    /* +0x00e70 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd360);

L_009b:
    /* +0x00e88 op=0x18 10 02 01 00 SHL32_IMM: s1 = (int32_t)(s2 << 0) */
    S[1] = (int32_t)((uint32_t)S[2] << 0);

L_009c:
    /* +0x00ea0 op=0xae 01 00 90 ff BR_EQ64: if (s1 == s0) goto record +45 */
    if (S[1] == S[0]) goto L_002d;

L_009d:
    /* +0x00eb8 op=0x85 00 04 30 00 ADD64_IMM16: s4 = s0 +0x30 */
    S[4] = S[0] + 0x30;

L_009e:
    /* +0x00ed0 op=0x5e 14 00 00 00 CALL_CF_INDEX: call native_binding[index=0x14] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x14, (void *)(uintptr_t)0x125fd360);

L_009f:
    /* +0x00ee8 op=0x34 02 00 04 01 OR64: s4 = s2 | s0 */
    S[4] = S[2] | S[0];

L_00a0:
    /* +0x00f00 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_00a1:
    /* +0x00f18 op=0x25 1e 02 00 00 ST64: *(s30 +0x0) = s2 */
    *(uint64_t *)((uint8_t *)S[30] + 0x0) = S[2];

L_00a2:
    /* +0x00f30 op=0x5e 15 00 00 00 CALL_CF_INDEX: call native_binding[index=0x15] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x15, (void *)(uintptr_t)0x125fd360);

L_00a3:
    /* +0x00f48 op=0x58 1e 01 00 00 LD64: s1 = *(uint64_t *)(s30 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[30] + 0x0);

L_00a4:
    /* +0x00f60 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_00a5:
    /* +0x00f78 op=0x25 17 01 00 00 ST64: *(s23 +0x0) = s1 */
    *(uint64_t *)((uint8_t *)S[23] + 0x0) = S[1];

L_00a6:
    /* +0x00f90 op=0x5e 16 00 00 00 CALL_CF_INDEX: call native_binding[index=0x16] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x16, (void *)(uintptr_t)0x125fd360);

L_00a7:
    /* +0x00fa8 op=0x5f 85 ff ff ff ADD_PC_IMM32: goto record +45 ; vm_pc = current_pc + 1 + -123 */
    goto L_002d;

}

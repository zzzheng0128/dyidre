/*
 * Auto-generated linear C-like lift for 350.101 managed program F73.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_thirdhop_bodies_20260905/350101_F73_0x7de000_0x7158.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F73_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d d0 fc ADD64_IMM16: s29 = s29 -0x330 */
    S[29] = S[29] + (-0x330);

L_0001:
    /* +0x00018 op=0x25 1d 1f 28 03 ST64: *(s29 +0x328) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x328) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 20 03 ST64: *(s29 +0x320) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x320) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 18 03 ST64: *(s29 +0x318) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x318) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 10 03 ST64: *(s29 +0x310) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x310) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 08 03 ST64: *(s29 +0x308) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0x308) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 00 03 ST64: *(s29 +0x300) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x300) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 f8 02 ST64: *(s29 +0x2f8) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x2f8) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 f0 02 ST64: *(s29 +0x2f0) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x2f0) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 e8 02 ST64: *(s29 +0x2e8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x2e8) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 e0 02 ST64: *(s29 +0x2e0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x2e0) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x59 05 01 3f 00 LD8U: s1 = *(uint8_t *)(s5 +0x3f) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3f);

L_000d:
    /* +0x00138 op=0x85 1e 11 a0 02 ADD64_IMM16: s17 = s30 +0x2a0 */
    S[17] = S[30] + 0x2a0;

L_000e:
    /* +0x00150 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_000f:
    /* +0x00168 op=0x34 04 00 10 01 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_0010:
    /* +0x00180 op=0x52 04 17 14 00 LD32S: s23 = *(int32_t *)(s4 +0x14) */
    S[23] = *(int32_t *)((uint8_t *)S[4] + 0x14);

L_0011:
    /* +0x00198 op=0x52 04 15 10 00 LD32S: s21 = *(int32_t *)(s4 +0x10) */
    S[21] = *(int32_t *)((uint8_t *)S[4] + 0x10);

L_0012:
    /* +0x001b0 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_0013:
    /* +0x001c8 op=0x08 1e 01 a0 01 ST32: *(s30 +0x1a0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a0) = (uint32_t)S[1];

L_0014:
    /* +0x001e0 op=0x59 05 01 3e 00 LD8U: s1 = *(uint8_t *)(s5 +0x3e) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3e);

L_0015:
    /* +0x001f8 op=0x08 1e 01 3c 01 ST32: *(s30 +0x13c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x13c) = (uint32_t)S[1];

L_0016:
    /* +0x00210 op=0x59 05 01 3d 00 LD8U: s1 = *(uint8_t *)(s5 +0x3d) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3d);

L_0017:
    /* +0x00228 op=0x08 1e 01 e0 00 ST32: *(s30 +0xe0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xe0) = (uint32_t)S[1];

L_0018:
    /* +0x00240 op=0x59 05 01 3c 00 LD8U: s1 = *(uint8_t *)(s5 +0x3c) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3c);

L_0019:
    /* +0x00258 op=0x08 1e 01 14 01 ST32: *(s30 +0x114) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x114) = (uint32_t)S[1];

L_001a:
    /* +0x00270 op=0x59 05 01 3b 00 LD8U: s1 = *(uint8_t *)(s5 +0x3b) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3b);

L_001b:
    /* +0x00288 op=0x08 1e 01 90 01 ST32: *(s30 +0x190) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x190) = (uint32_t)S[1];

L_001c:
    /* +0x002a0 op=0x59 05 01 3a 00 LD8U: s1 = *(uint8_t *)(s5 +0x3a) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3a);

L_001d:
    /* +0x002b8 op=0x08 1e 01 5c 01 ST32: *(s30 +0x15c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x15c) = (uint32_t)S[1];

L_001e:
    /* +0x002d0 op=0x59 05 01 39 00 LD8U: s1 = *(uint8_t *)(s5 +0x39) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x39);

L_001f:
    /* +0x002e8 op=0x08 1e 01 e4 00 ST32: *(s30 +0xe4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xe4) = (uint32_t)S[1];

L_0020:
    /* +0x00300 op=0x59 05 01 38 00 LD8U: s1 = *(uint8_t *)(s5 +0x38) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x38);

L_0021:
    /* +0x00318 op=0x08 1e 01 20 00 ST32: *(s30 +0x20) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x20) = (uint32_t)S[1];

L_0022:
    /* +0x00330 op=0x59 05 01 37 00 LD8U: s1 = *(uint8_t *)(s5 +0x37) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x37);

L_0023:
    /* +0x00348 op=0x08 1e 01 b4 01 ST32: *(s30 +0x1b4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1b4) = (uint32_t)S[1];

L_0024:
    /* +0x00360 op=0x59 05 01 36 00 LD8U: s1 = *(uint8_t *)(s5 +0x36) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x36);

L_0025:
    /* +0x00378 op=0x08 1e 01 54 01 ST32: *(s30 +0x154) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x154) = (uint32_t)S[1];

L_0026:
    /* +0x00390 op=0x59 05 01 35 00 LD8U: s1 = *(uint8_t *)(s5 +0x35) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x35);

L_0027:
    /* +0x003a8 op=0x08 1e 01 e8 00 ST32: *(s30 +0xe8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xe8) = (uint32_t)S[1];

L_0028:
    /* +0x003c0 op=0x59 05 01 34 00 LD8U: s1 = *(uint8_t *)(s5 +0x34) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x34);

L_0029:
    /* +0x003d8 op=0x08 1e 01 28 01 ST32: *(s30 +0x128) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x128) = (uint32_t)S[1];

L_002a:
    /* +0x003f0 op=0x59 05 01 33 00 LD8U: s1 = *(uint8_t *)(s5 +0x33) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x33);

L_002b:
    /* +0x00408 op=0x08 1e 01 68 01 ST32: *(s30 +0x168) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x168) = (uint32_t)S[1];

L_002c:
    /* +0x00420 op=0x59 05 01 32 00 LD8U: s1 = *(uint8_t *)(s5 +0x32) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x32);

L_002d:
    /* +0x00438 op=0x08 1e 01 d4 00 ST32: *(s30 +0xd4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xd4) = (uint32_t)S[1];

L_002e:
    /* +0x00450 op=0x59 05 01 31 00 LD8U: s1 = *(uint8_t *)(s5 +0x31) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x31);

L_002f:
    /* +0x00468 op=0x08 1e 01 b8 00 ST32: *(s30 +0xb8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xb8) = (uint32_t)S[1];

L_0030:
    /* +0x00480 op=0x59 05 01 30 00 LD8U: s1 = *(uint8_t *)(s5 +0x30) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x30);

L_0031:
    /* +0x00498 op=0x08 1e 01 ec 00 ST32: *(s30 +0xec) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xec) = (uint32_t)S[1];

L_0032:
    /* +0x004b0 op=0x59 05 01 2f 00 LD8U: s1 = *(uint8_t *)(s5 +0x2f) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2f);

L_0033:
    /* +0x004c8 op=0x08 1e 01 34 01 ST32: *(s30 +0x134) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x134) = (uint32_t)S[1];

L_0034:
    /* +0x004e0 op=0x59 05 01 2e 00 LD8U: s1 = *(uint8_t *)(s5 +0x2e) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2e);

L_0035:
    /* +0x004f8 op=0x08 1e 01 f0 00 ST32: *(s30 +0xf0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xf0) = (uint32_t)S[1];

L_0036:
    /* +0x00510 op=0x59 05 01 2d 00 LD8U: s1 = *(uint8_t *)(s5 +0x2d) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2d);

L_0037:
    /* +0x00528 op=0x08 1e 01 a8 00 ST32: *(s30 +0xa8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xa8) = (uint32_t)S[1];

L_0038:
    /* +0x00540 op=0x59 05 01 2c 00 LD8U: s1 = *(uint8_t *)(s5 +0x2c) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2c);

L_0039:
    /* +0x00558 op=0x08 1e 01 c0 00 ST32: *(s30 +0xc0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xc0) = (uint32_t)S[1];

L_003a:
    /* +0x00570 op=0x59 05 01 2b 00 LD8U: s1 = *(uint8_t *)(s5 +0x2b) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2b);

L_003b:
    /* +0x00588 op=0x08 1e 01 a8 01 ST32: *(s30 +0x1a8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a8) = (uint32_t)S[1];

L_003c:
    /* +0x005a0 op=0x59 05 01 2a 00 LD8U: s1 = *(uint8_t *)(s5 +0x2a) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2a);

L_003d:
    /* +0x005b8 op=0x08 1e 01 6c 01 ST32: *(s30 +0x16c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x16c) = (uint32_t)S[1];

L_003e:
    /* +0x005d0 op=0x59 05 01 29 00 LD8U: s1 = *(uint8_t *)(s5 +0x29) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x29);

L_003f:
    /* +0x005e8 op=0x08 1e 01 00 01 ST32: *(s30 +0x100) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x100) = (uint32_t)S[1];

L_0040:
    /* +0x00600 op=0x59 05 01 28 00 LD8U: s1 = *(uint8_t *)(s5 +0x28) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x28);

L_0041:
    /* +0x00618 op=0x08 1e 01 38 01 ST32: *(s30 +0x138) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x138) = (uint32_t)S[1];

L_0042:
    /* +0x00630 op=0x59 05 01 27 00 LD8U: s1 = *(uint8_t *)(s5 +0x27) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x27);

L_0043:
    /* +0x00648 op=0x08 1e 01 7c 01 ST32: *(s30 +0x17c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x17c) = (uint32_t)S[1];

L_0044:
    /* +0x00660 op=0x59 05 01 26 00 LD8U: s1 = *(uint8_t *)(s5 +0x26) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x26);

L_0045:
    /* +0x00678 op=0x08 1e 01 40 01 ST32: *(s30 +0x140) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x140) = (uint32_t)S[1];

L_0046:
    /* +0x00690 op=0x59 05 01 25 00 LD8U: s1 = *(uint8_t *)(s5 +0x25) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x25);

L_0047:
    /* +0x006a8 op=0x08 1e 01 a0 00 ST32: *(s30 +0xa0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xa0) = (uint32_t)S[1];

L_0048:
    /* +0x006c0 op=0x59 05 01 24 00 LD8U: s1 = *(uint8_t *)(s5 +0x24) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x24);

L_0049:
    /* +0x006d8 op=0x08 1e 01 d8 00 ST32: *(s30 +0xd8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xd8) = (uint32_t)S[1];

L_004a:
    /* +0x006f0 op=0x59 05 01 23 00 LD8U: s1 = *(uint8_t *)(s5 +0x23) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x23);

L_004b:
    /* +0x00708 op=0x08 1e 01 a4 01 ST32: *(s30 +0x1a4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a4) = (uint32_t)S[1];

L_004c:
    /* +0x00720 op=0x59 05 01 22 00 LD8U: s1 = *(uint8_t *)(s5 +0x22) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x22);

L_004d:
    /* +0x00738 op=0x08 1e 01 50 01 ST32: *(s30 +0x150) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x150) = (uint32_t)S[1];

L_004e:
    /* +0x00750 op=0x59 05 01 21 00 LD8U: s1 = *(uint8_t *)(s5 +0x21) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x21);

L_004f:
    /* +0x00768 op=0x08 1e 01 c4 00 ST32: *(s30 +0xc4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xc4) = (uint32_t)S[1];

L_0050:
    /* +0x00780 op=0x59 05 01 20 00 LD8U: s1 = *(uint8_t *)(s5 +0x20) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x20);

L_0051:
    /* +0x00798 op=0x08 1e 01 04 01 ST32: *(s30 +0x104) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x104) = (uint32_t)S[1];

L_0052:
    /* +0x007b0 op=0x59 05 01 1f 00 LD8U: s1 = *(uint8_t *)(s5 +0x1f) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1f);

L_0053:
    /* +0x007c8 op=0x08 1e 01 b0 00 ST32: *(s30 +0xb0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xb0) = (uint32_t)S[1];

L_0054:
    /* +0x007e0 op=0x59 05 01 1e 00 LD8U: s1 = *(uint8_t *)(s5 +0x1e) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1e);

L_0055:
    /* +0x007f8 op=0x08 1e 01 7c 00 ST32: *(s30 +0x7c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x7c) = (uint32_t)S[1];

L_0056:
    /* +0x00810 op=0x59 05 01 1d 00 LD8U: s1 = *(uint8_t *)(s5 +0x1d) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1d);

L_0057:
    /* +0x00828 op=0x08 1e 01 70 00 ST32: *(s30 +0x70) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x70) = (uint32_t)S[1];

L_0058:
    /* +0x00840 op=0x59 05 01 1c 00 LD8U: s1 = *(uint8_t *)(s5 +0x1c) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1c);

L_0059:
    /* +0x00858 op=0x08 1e 01 74 00 ST32: *(s30 +0x74) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x74) = (uint32_t)S[1];

L_005a:
    /* +0x00870 op=0x59 05 01 1b 00 LD8U: s1 = *(uint8_t *)(s5 +0x1b) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1b);

L_005b:
    /* +0x00888 op=0x08 1e 01 60 01 ST32: *(s30 +0x160) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x160) = (uint32_t)S[1];

L_005c:
    /* +0x008a0 op=0x59 05 01 1a 00 LD8U: s1 = *(uint8_t *)(s5 +0x1a) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1a);

L_005d:
    /* +0x008b8 op=0x08 1e 01 08 01 ST32: *(s30 +0x108) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x108) = (uint32_t)S[1];

L_005e:
    /* +0x008d0 op=0x59 05 01 19 00 LD8U: s1 = *(uint8_t *)(s5 +0x19) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x19);

L_005f:
    /* +0x008e8 op=0x08 1e 01 98 00 ST32: *(s30 +0x98) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x98) = (uint32_t)S[1];

L_0060:
    /* +0x00900 op=0x59 05 01 18 00 LD8U: s1 = *(uint8_t *)(s5 +0x18) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x18);

L_0061:
    /* +0x00918 op=0x08 1e 01 c8 00 ST32: *(s30 +0xc8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xc8) = (uint32_t)S[1];

L_0062:
    /* +0x00930 op=0x59 05 01 17 00 LD8U: s1 = *(uint8_t *)(s5 +0x17) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x17);

L_0063:
    /* +0x00948 op=0x08 1e 01 fc 00 ST32: *(s30 +0xfc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xfc) = (uint32_t)S[1];

L_0064:
    /* +0x00960 op=0x59 05 01 16 00 LD8U: s1 = *(uint8_t *)(s5 +0x16) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x16);

L_0065:
    /* +0x00978 op=0x08 1e 01 9c 00 ST32: *(s30 +0x9c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x9c) = (uint32_t)S[1];

L_0066:
    /* +0x00990 op=0x59 05 01 15 00 LD8U: s1 = *(uint8_t *)(s5 +0x15) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x15);

L_0067:
    /* +0x009a8 op=0x08 1e 01 64 00 ST32: *(s30 +0x64) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x64) = (uint32_t)S[1];

L_0068:
    /* +0x009c0 op=0x59 05 01 14 00 LD8U: s1 = *(uint8_t *)(s5 +0x14) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x14);

L_0069:
    /* +0x009d8 op=0x08 1e 01 78 00 ST32: *(s30 +0x78) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x78) = (uint32_t)S[1];

L_006a:
    /* +0x009f0 op=0x59 05 01 13 00 LD8U: s1 = *(uint8_t *)(s5 +0x13) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x13);

L_006b:
    /* +0x00a08 op=0x08 1e 01 74 01 ST32: *(s30 +0x174) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x174) = (uint32_t)S[1];

L_006c:
    /* +0x00a20 op=0x59 05 01 12 00 LD8U: s1 = *(uint8_t *)(s5 +0x12) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x12);

L_006d:
    /* +0x00a38 op=0x08 1e 01 44 01 ST32: *(s30 +0x144) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x144) = (uint32_t)S[1];

L_006e:
    /* +0x00a50 op=0x59 05 01 11 00 LD8U: s1 = *(uint8_t *)(s5 +0x11) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x11);

L_006f:
    /* +0x00a68 op=0x08 1e 01 8c 00 ST32: *(s30 +0x8c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x8c) = (uint32_t)S[1];

L_0070:
    /* +0x00a80 op=0x59 05 01 10 00 LD8U: s1 = *(uint8_t *)(s5 +0x10) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x10);

L_0071:
    /* +0x00a98 op=0x08 1e 01 d0 00 ST32: *(s30 +0xd0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xd0) = (uint32_t)S[1];

L_0072:
    /* +0x00ab0 op=0x59 05 01 0f 00 LD8U: s1 = *(uint8_t *)(s5 +0xf) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xf);

L_0073:
    /* +0x00ac8 op=0x08 1e 01 24 01 ST32: *(s30 +0x124) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x124) = (uint32_t)S[1];

L_0074:
    /* +0x00ae0 op=0x59 05 01 0e 00 LD8U: s1 = *(uint8_t *)(s5 +0xe) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xe);

L_0075:
    /* +0x00af8 op=0x08 1e 01 f8 00 ST32: *(s30 +0xf8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xf8) = (uint32_t)S[1];

L_0076:
    /* +0x00b10 op=0x59 05 01 0d 00 LD8U: s1 = *(uint8_t *)(s5 +0xd) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xd);

L_0077:
    /* +0x00b28 op=0x08 1e 01 60 00 ST32: *(s30 +0x60) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x60) = (uint32_t)S[1];

L_0078:
    /* +0x00b40 op=0x59 05 01 0c 00 LD8U: s1 = *(uint8_t *)(s5 +0xc) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xc);

L_0079:
    /* +0x00b58 op=0x08 1e 01 84 00 ST32: *(s30 +0x84) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x84) = (uint32_t)S[1];

L_007a:
    /* +0x00b70 op=0x59 05 01 0b 00 LD8U: s1 = *(uint8_t *)(s5 +0xb) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xb);

L_007b:
    /* +0x00b88 op=0x08 1e 01 58 01 ST32: *(s30 +0x158) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x158) = (uint32_t)S[1];

L_007c:
    /* +0x00ba0 op=0x59 05 01 0a 00 LD8U: s1 = *(uint8_t *)(s5 +0xa) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0xa);

L_007d:
    /* +0x00bb8 op=0x08 1e 01 1c 01 ST32: *(s30 +0x11c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x11c) = (uint32_t)S[1];

L_007e:
    /* +0x00bd0 op=0x59 05 01 09 00 LD8U: s1 = *(uint8_t *)(s5 +0x9) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x9);

L_007f:
    /* +0x00be8 op=0x08 1e 01 bc 00 ST32: *(s30 +0xbc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xbc) = (uint32_t)S[1];

L_0080:
    /* +0x00c00 op=0x59 05 01 08 00 LD8U: s1 = *(uint8_t *)(s5 +0x8) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x8);

L_0081:
    /* +0x00c18 op=0x08 1e 01 f4 00 ST32: *(s30 +0xf4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xf4) = (uint32_t)S[1];

L_0082:
    /* +0x00c30 op=0x59 05 01 07 00 LD8U: s1 = *(uint8_t *)(s5 +0x7) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x7);

L_0083:
    /* +0x00c48 op=0x08 1e 01 2c 01 ST32: *(s30 +0x12c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x12c) = (uint32_t)S[1];

L_0084:
    /* +0x00c60 op=0x59 05 01 06 00 LD8U: s1 = *(uint8_t *)(s5 +0x6) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x6);

L_0085:
    /* +0x00c78 op=0x08 1e 01 b4 00 ST32: *(s30 +0xb4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xb4) = (uint32_t)S[1];

L_0086:
    /* +0x00c90 op=0x59 05 01 05 00 LD8U: s1 = *(uint8_t *)(s5 +0x5) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x5);

L_0087:
    /* +0x00ca8 op=0x08 1e 01 5c 00 ST32: *(s30 +0x5c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x5c) = (uint32_t)S[1];

L_0088:
    /* +0x00cc0 op=0x59 05 01 04 00 LD8U: s1 = *(uint8_t *)(s5 +0x4) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x4);

L_0089:
    /* +0x00cd8 op=0x08 1e 01 94 00 ST32: *(s30 +0x94) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x94) = (uint32_t)S[1];

L_008a:
    /* +0x00cf0 op=0x59 05 01 03 00 LD8U: s1 = *(uint8_t *)(s5 +0x3) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x3);

L_008b:
    /* +0x00d08 op=0x08 1e 01 10 01 ST32: *(s30 +0x110) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x110) = (uint32_t)S[1];

L_008c:
    /* +0x00d20 op=0x59 05 01 02 00 LD8U: s1 = *(uint8_t *)(s5 +0x2) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x2);

L_008d:
    /* +0x00d38 op=0x08 1e 01 dc 00 ST32: *(s30 +0xdc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xdc) = (uint32_t)S[1];

L_008e:
    /* +0x00d50 op=0x59 05 01 01 00 LD8U: s1 = *(uint8_t *)(s5 +0x1) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x1);

L_008f:
    /* +0x00d68 op=0x08 1e 01 68 00 ST32: *(s30 +0x68) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x68) = (uint32_t)S[1];

L_0090:
    /* +0x00d80 op=0x59 05 01 00 00 LD8U: s1 = *(uint8_t *)(s5 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0091:
    /* +0x00d98 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_0092:
    /* +0x00db0 op=0x08 1e 01 90 00 ST32: *(s30 +0x90) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x90) = (uint32_t)S[1];

L_0093:
    /* +0x00dc8 op=0x52 04 01 0c 00 LD32S: s1 = *(int32_t *)(s4 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0xc);

L_0094:
    /* +0x00de0 op=0x08 1e 01 d8 01 ST32: *(s30 +0x1d8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1d8) = (uint32_t)S[1];

L_0095:
    /* +0x00df8 op=0x52 04 01 08 00 LD32S: s1 = *(int32_t *)(s4 +0x8) */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0x8);

L_0096:
    /* +0x00e10 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0097:
    /* +0x00e28 op=0x08 1e 01 dc 01 ST32: *(s30 +0x1dc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1dc) = (uint32_t)S[1];

L_0098:
    /* +0x00e40 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0099:
    /* +0x00e58 op=0x52 10 14 58 00 LD32S: s20 = *(int32_t *)(s16 +0x58) */
    S[20] = *(int32_t *)((uint8_t *)S[16] + 0x58);

L_009a:
    /* +0x00e70 op=0x25 1e 10 d0 01 ST64: *(s30 +0x1d0) = s16 */
    *(uint64_t *)((uint8_t *)S[30] + 0x1d0) = S[16];

L_009b:
    /* +0x00e88 op=0xb5 00 10 20 00 ADD32_IMM16: s16 = int32(s0 +0x20) */
    S[16] = (int32_t)((uint32_t)S[0] + 0x20);

L_009c:
    /* +0x00ea0 op=0x85 00 16 10 00 ADD64_IMM16: s22 = s0 +0x10 */
    S[22] = S[0] + 0x10;

L_009d:
    /* +0x00eb8 op=0x53 04 05 90 08 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x890 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x890;

L_009e:
    /* +0x00ed0 op=0xb5 00 06 00 00 ADD32_IMM16: s6 = int32(s0 +0x0) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x0);

L_009f:
    /* +0x00ee8 op=0xb5 14 01 13 00 ADD32_IMM16: s1 = int32(s20 +0x13) */
    S[1] = (int32_t)((uint32_t)S[20] + 0x13);

L_00a0:
    /* +0x00f00 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_00a1:
    /* +0x00f18 op=0xb5 00 01 e0 ff ADD32_IMM16: s1 = int32(s0 -0x20) */
    S[1] = (int32_t)((uint32_t)S[0] + (-0x20));

L_00a2:
    /* +0x00f30 op=0x34 01 00 13 01 OR64: s19 = s1 | s0 */
    S[19] = S[1] | S[0];

L_00a3:
    /* +0x00f48 op=0x34 02 01 03 01 OR64: s3 = s2 | s1 */
    S[3] = S[2] | S[1];

L_00a4:
    /* +0x00f60 op=0x09 10 02 04 04 SUB32: s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[16] - (uint32_t)S[2]);

L_00a5:
    /* +0x00f78 op=0xae 12 16 1b 00 BR_EQ64: if (s18 == s22) goto record +193 */
    if (S[18] == S[22]) goto L_00c1;

L_00a6:
    /* +0x00f90 op=0x6e 12 12 07 02 SHL64_IMM: s7 = s18 << 2 */
    S[7] = S[18] << 2;

L_00a7:
    /* +0x00fa8 op=0x34 03 00 0a 01 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_00a8:
    /* +0x00fc0 op=0x34 06 00 09 01 OR64: s9 = s6 | s0 */
    S[9] = S[6] | S[0];

L_00a9:
    /* +0x00fd8 op=0x84 05 07 01 14 ADD64: s1 = s5 + s7 */
    S[1] = S[5] + S[7];

L_00aa:
    /* +0x00ff0 op=0x52 01 08 00 00 LD32S: s8 = *(int32_t *)(s1 +0x0) */
    S[8] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_00ab:
    /* +0x01008 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +176 */
    if (S[10] == S[0]) goto L_00b0;

L_00ac:
    /* +0x01020 op=0x18 10 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_00ad:
    /* +0x01038 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_00ae:
    /* +0x01050 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_00af:
    /* +0x01068 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +172 */
    if (S[10] != S[0]) goto L_00ac;

L_00b0:
    /* +0x01080 op=0x34 03 00 0b 01 OR64: s11 = s3 | s0 */
    S[11] = S[3] | S[0];

L_00b1:
    /* +0x01098 op=0x34 06 00 0a 01 OR64: s10 = s6 | s0 */
    S[10] = S[6] | S[0];

L_00b2:
    /* +0x010b0 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +183 */
    if (S[11] == S[0]) goto L_00b7;

L_00b3:
    /* +0x010c8 op=0x18 10 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_00b4:
    /* +0x010e0 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_00b5:
    /* +0x010f8 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_00b6:
    /* +0x01110 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +179 */
    if (S[11] != S[0]) goto L_00b3;

L_00b7:
    /* +0x01128 op=0x0d 02 08 01 00 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[8] >> (S[1] & 31));

L_00b8:
    /* +0x01140 op=0x17 04 08 08 07 SHL32_VAR: s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31)) */
    S[8] = (int32_t)((uint32_t)S[8] << ((uint32_t)S[4] & 31));

L_00b9:
    /* +0x01158 op=0x84 11 07 07 00 ADD64: s7 = s17 + s7 */
    S[7] = S[17] + S[7];

L_00ba:
    /* +0x01170 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_00bb:
    /* +0x01188 op=0xb3 09 01 01 00 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_00bc:
    /* +0x011a0 op=0x36 0a 00 09 01 NOR64: s9 = ~(s10 | s0) */
    S[9] = ~(S[10] | S[0]);

L_00bd:
    /* +0x011b8 op=0xb3 08 09 08 00 AND64: s8 = s8 & s9 */
    S[8] = S[8] & S[9];

L_00be:
    /* +0x011d0 op=0x34 08 01 01 01 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_00bf:
    /* +0x011e8 op=0x08 07 01 00 00 ST32: *(s7 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[7] + 0x0) = (uint32_t)S[1];

L_00c0:
    /* +0x01200 op=0xa7 12 16 e5 ff BR_NE64: if (s18 != s22) goto record +166 */
    if (S[18] != S[22]) goto L_00a6;

L_00c1:
    /* +0x01218 op=0x52 1e 01 dc 02 LD32S: s1 = *(int32_t *)(s30 +0x2dc) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2dc);

L_00c2:
    /* +0x01230 op=0x85 1e 11 60 02 ADD64_IMM16: s17 = s30 +0x260 */
    S[17] = S[30] + 0x260;

L_00c3:
    /* +0x01248 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_00c4:
    /* +0x01260 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_00c5:
    /* +0x01278 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_00c6:
    /* +0x01290 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_00c7:
    /* +0x012a8 op=0x08 1e 01 b8 01 ST32: *(s30 +0x1b8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1b8) = (uint32_t)S[1];

L_00c8:
    /* +0x012c0 op=0x52 1e 01 d8 02 LD32S: s1 = *(int32_t *)(s30 +0x2d8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2d8);

L_00c9:
    /* +0x012d8 op=0x08 1e 01 ac 01 ST32: *(s30 +0x1ac) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1ac) = (uint32_t)S[1];

L_00ca:
    /* +0x012f0 op=0x52 1e 01 d4 02 LD32S: s1 = *(int32_t *)(s30 +0x2d4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2d4);

L_00cb:
    /* +0x01308 op=0x08 1e 01 80 00 ST32: *(s30 +0x80) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x80) = (uint32_t)S[1];

L_00cc:
    /* +0x01320 op=0x52 1e 01 d0 02 LD32S: s1 = *(int32_t *)(s30 +0x2d0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2d0);

L_00cd:
    /* +0x01338 op=0x08 1e 01 cc 00 ST32: *(s30 +0xcc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xcc) = (uint32_t)S[1];

L_00ce:
    /* +0x01350 op=0x52 1e 01 cc 02 LD32S: s1 = *(int32_t *)(s30 +0x2cc) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2cc);

L_00cf:
    /* +0x01368 op=0x08 1e 01 ac 00 ST32: *(s30 +0xac) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xac) = (uint32_t)S[1];

L_00d0:
    /* +0x01380 op=0x52 1e 01 c8 02 LD32S: s1 = *(int32_t *)(s30 +0x2c8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2c8);

L_00d1:
    /* +0x01398 op=0x08 1e 01 78 01 ST32: *(s30 +0x178) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x178) = (uint32_t)S[1];

L_00d2:
    /* +0x013b0 op=0x52 1e 01 c4 02 LD32S: s1 = *(int32_t *)(s30 +0x2c4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2c4);

L_00d3:
    /* +0x013c8 op=0x08 1e 01 64 01 ST32: *(s30 +0x164) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x164) = (uint32_t)S[1];

L_00d4:
    /* +0x013e0 op=0x52 1e 01 c0 02 LD32S: s1 = *(int32_t *)(s30 +0x2c0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2c0);

L_00d5:
    /* +0x013f8 op=0x08 1e 01 4c 01 ST32: *(s30 +0x14c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x14c) = (uint32_t)S[1];

L_00d6:
    /* +0x01410 op=0x52 1e 01 bc 02 LD32S: s1 = *(int32_t *)(s30 +0x2bc) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2bc);

L_00d7:
    /* +0x01428 op=0x08 1e 01 88 00 ST32: *(s30 +0x88) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x88) = (uint32_t)S[1];

L_00d8:
    /* +0x01440 op=0x52 1e 01 b8 02 LD32S: s1 = *(int32_t *)(s30 +0x2b8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2b8);

L_00d9:
    /* +0x01458 op=0x08 1e 01 6c 00 ST32: *(s30 +0x6c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x6c) = (uint32_t)S[1];

L_00da:
    /* +0x01470 op=0x52 1e 01 b4 02 LD32S: s1 = *(int32_t *)(s30 +0x2b4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2b4);

L_00db:
    /* +0x01488 op=0x08 1e 01 0c 01 ST32: *(s30 +0x10c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x10c) = (uint32_t)S[1];

L_00dc:
    /* +0x014a0 op=0x52 1e 01 b0 02 LD32S: s1 = *(int32_t *)(s30 +0x2b0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2b0);

L_00dd:
    /* +0x014b8 op=0x08 1e 01 a4 00 ST32: *(s30 +0xa4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xa4) = (uint32_t)S[1];

L_00de:
    /* +0x014d0 op=0x52 1e 01 ac 02 LD32S: s1 = *(int32_t *)(s30 +0x2ac) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2ac);

L_00df:
    /* +0x014e8 op=0x08 1e 01 58 00 ST32: *(s30 +0x58) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x58) = (uint32_t)S[1];

L_00e0:
    /* +0x01500 op=0x52 1e 01 a8 02 LD32S: s1 = *(int32_t *)(s30 +0x2a8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2a8);

L_00e1:
    /* +0x01518 op=0x08 1e 01 4c 00 ST32: *(s30 +0x4c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x4c) = (uint32_t)S[1];

L_00e2:
    /* +0x01530 op=0x52 1e 01 a4 02 LD32S: s1 = *(int32_t *)(s30 +0x2a4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2a4);

L_00e3:
    /* +0x01548 op=0x08 1e 01 50 00 ST32: *(s30 +0x50) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x50) = (uint32_t)S[1];

L_00e4:
    /* +0x01560 op=0x52 1e 01 a0 02 LD32S: s1 = *(int32_t *)(s30 +0x2a0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x2a0);

L_00e5:
    /* +0x01578 op=0x08 1e 01 44 00 ST32: *(s30 +0x44) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x44) = (uint32_t)S[1];

L_00e6:
    /* +0x01590 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_00e7:
    /* +0x015a8 op=0xb5 14 01 14 00 ADD32_IMM16: s1 = int32(s20 +0x14) */
    S[1] = (int32_t)((uint32_t)S[20] + 0x14);

L_00e8:
    /* +0x015c0 op=0x53 01 05 d0 08 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x8d0 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x8d0;

L_00e9:
    /* +0x015d8 op=0xb5 00 06 00 00 ADD32_IMM16: s6 = int32(s0 +0x0) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x0);

L_00ea:
    /* +0x015f0 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_00eb:
    /* +0x01608 op=0x34 02 13 03 01 OR64: s3 = s2 | s19 */
    S[3] = S[2] | S[19];

L_00ec:
    /* +0x01620 op=0x09 10 02 04 04 SUB32: s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[16] - (uint32_t)S[2]);

L_00ed:
    /* +0x01638 op=0xae 12 16 1b 00 BR_EQ64: if (s18 == s22) goto record +265 */
    if (S[18] == S[22]) goto L_0109;

L_00ee:
    /* +0x01650 op=0x6e 00 12 07 02 SHL64_IMM: s7 = s18 << 2 */
    S[7] = S[18] << 2;

L_00ef:
    /* +0x01668 op=0x34 03 00 0a 00 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_00f0:
    /* +0x01680 op=0x34 06 00 09 01 OR64: s9 = s6 | s0 */
    S[9] = S[6] | S[0];

L_00f1:
    /* +0x01698 op=0x84 05 07 01 04 ADD64: s1 = s5 + s7 */
    S[1] = S[5] + S[7];

L_00f2:
    /* +0x016b0 op=0x52 01 08 00 00 LD32S: s8 = *(int32_t *)(s1 +0x0) */
    S[8] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_00f3:
    /* +0x016c8 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +248 */
    if (S[10] == S[0]) goto L_00f8;

L_00f4:
    /* +0x016e0 op=0x18 00 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_00f5:
    /* +0x016f8 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_00f6:
    /* +0x01710 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_00f7:
    /* +0x01728 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +244 */
    if (S[10] != S[0]) goto L_00f4;

L_00f8:
    /* +0x01740 op=0x34 03 00 0b 01 OR64: s11 = s3 | s0 */
    S[11] = S[3] | S[0];

L_00f9:
    /* +0x01758 op=0x34 06 00 0a 00 OR64: s10 = s6 | s0 */
    S[10] = S[6] | S[0];

L_00fa:
    /* +0x01770 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +255 */
    if (S[11] == S[0]) goto L_00ff;

L_00fb:
    /* +0x01788 op=0x18 00 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_00fc:
    /* +0x017a0 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_00fd:
    /* +0x017b8 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_00fe:
    /* +0x017d0 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +251 */
    if (S[11] != S[0]) goto L_00fb;

L_00ff:
    /* +0x017e8 op=0x0d 02 08 01 00 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[8] >> (S[1] & 31));

L_0100:
    /* +0x01800 op=0x17 04 08 08 00 SHL32_VAR: s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31)) */
    S[8] = (int32_t)((uint32_t)S[8] << ((uint32_t)S[4] & 31));

L_0101:
    /* +0x01818 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_0102:
    /* +0x01830 op=0x84 11 07 07 14 ADD64: s7 = s17 + s7 */
    S[7] = S[17] + S[7];

L_0103:
    /* +0x01848 op=0xb3 09 01 01 00 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_0104:
    /* +0x01860 op=0x36 0a 00 09 00 NOR64: s9 = ~(s10 | s0) */
    S[9] = ~(S[10] | S[0]);

L_0105:
    /* +0x01878 op=0xb3 08 09 08 00 AND64: s8 = s8 & s9 */
    S[8] = S[8] & S[9];

L_0106:
    /* +0x01890 op=0x34 08 01 01 01 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_0107:
    /* +0x018a8 op=0x08 07 01 00 00 ST32: *(s7 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[7] + 0x0) = (uint32_t)S[1];

L_0108:
    /* +0x018c0 op=0xa7 12 16 e5 ff BR_NE64: if (s18 != s22) goto record +238 */
    if (S[18] != S[22]) goto L_00ee;

L_0109:
    /* +0x018d8 op=0x52 1e 01 9c 02 LD32S: s1 = *(int32_t *)(s30 +0x29c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x29c);

L_010a:
    /* +0x018f0 op=0x85 1e 11 20 02 ADD64_IMM16: s17 = s30 +0x220 */
    S[17] = S[30] + 0x220;

L_010b:
    /* +0x01908 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_010c:
    /* +0x01920 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_010d:
    /* +0x01938 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_010e:
    /* +0x01950 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_010f:
    /* +0x01968 op=0x08 1e 01 28 00 ST32: *(s30 +0x28) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x28) = (uint32_t)S[1];

L_0110:
    /* +0x01980 op=0x52 1e 01 98 02 LD32S: s1 = *(int32_t *)(s30 +0x298) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x298);

L_0111:
    /* +0x01998 op=0x08 1e 01 38 00 ST32: *(s30 +0x38) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x38) = (uint32_t)S[1];

L_0112:
    /* +0x019b0 op=0x52 1e 01 94 02 LD32S: s1 = *(int32_t *)(s30 +0x294) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x294);

L_0113:
    /* +0x019c8 op=0x08 1e 01 30 00 ST32: *(s30 +0x30) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x30) = (uint32_t)S[1];

L_0114:
    /* +0x019e0 op=0x52 1e 01 90 02 LD32S: s1 = *(int32_t *)(s30 +0x290) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x290);

L_0115:
    /* +0x019f8 op=0x08 1e 01 c4 01 ST32: *(s30 +0x1c4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1c4) = (uint32_t)S[1];

L_0116:
    /* +0x01a10 op=0x52 1e 01 8c 02 LD32S: s1 = *(int32_t *)(s30 +0x28c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x28c);

L_0117:
    /* +0x01a28 op=0x08 1e 01 bc 01 ST32: *(s30 +0x1bc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1bc) = (uint32_t)S[1];

L_0118:
    /* +0x01a40 op=0x52 1e 01 88 02 LD32S: s1 = *(int32_t *)(s30 +0x288) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x288);

L_0119:
    /* +0x01a58 op=0x08 1e 01 3c 00 ST32: *(s30 +0x3c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x3c) = (uint32_t)S[1];

L_011a:
    /* +0x01a70 op=0x52 1e 01 84 02 LD32S: s1 = *(int32_t *)(s30 +0x284) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x284);

L_011b:
    /* +0x01a88 op=0x08 1e 01 b0 01 ST32: *(s30 +0x1b0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1b0) = (uint32_t)S[1];

L_011c:
    /* +0x01aa0 op=0x52 1e 01 80 02 LD32S: s1 = *(int32_t *)(s30 +0x280) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x280);

L_011d:
    /* +0x01ab8 op=0x08 1e 01 24 00 ST32: *(s30 +0x24) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x24) = (uint32_t)S[1];

L_011e:
    /* +0x01ad0 op=0x52 1e 01 7c 02 LD32S: s1 = *(int32_t *)(s30 +0x27c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x27c);

L_011f:
    /* +0x01ae8 op=0x08 1e 01 2c 00 ST32: *(s30 +0x2c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x2c) = (uint32_t)S[1];

L_0120:
    /* +0x01b00 op=0x52 1e 01 78 02 LD32S: s1 = *(int32_t *)(s30 +0x278) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x278);

L_0121:
    /* +0x01b18 op=0x08 1e 01 84 01 ST32: *(s30 +0x184) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x184) = (uint32_t)S[1];

L_0122:
    /* +0x01b30 op=0x52 1e 01 74 02 LD32S: s1 = *(int32_t *)(s30 +0x274) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x274);

L_0123:
    /* +0x01b48 op=0x08 1e 01 34 00 ST32: *(s30 +0x34) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x34) = (uint32_t)S[1];

L_0124:
    /* +0x01b60 op=0x52 1e 01 70 02 LD32S: s1 = *(int32_t *)(s30 +0x270) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x270);

L_0125:
    /* +0x01b78 op=0x08 1e 01 70 01 ST32: *(s30 +0x170) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x170) = (uint32_t)S[1];

L_0126:
    /* +0x01b90 op=0x52 1e 01 6c 02 LD32S: s1 = *(int32_t *)(s30 +0x26c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x26c);

L_0127:
    /* +0x01ba8 op=0x08 1e 01 48 01 ST32: *(s30 +0x148) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x148) = (uint32_t)S[1];

L_0128:
    /* +0x01bc0 op=0x52 1e 01 68 02 LD32S: s1 = *(int32_t *)(s30 +0x268) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x268);

L_0129:
    /* +0x01bd8 op=0x08 1e 01 18 01 ST32: *(s30 +0x118) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x118) = (uint32_t)S[1];

L_012a:
    /* +0x01bf0 op=0x52 1e 01 64 02 LD32S: s1 = *(int32_t *)(s30 +0x264) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x264);

L_012b:
    /* +0x01c08 op=0x08 1e 01 20 01 ST32: *(s30 +0x120) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x120) = (uint32_t)S[1];

L_012c:
    /* +0x01c20 op=0x52 1e 01 60 02 LD32S: s1 = *(int32_t *)(s30 +0x260) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x260);

L_012d:
    /* +0x01c38 op=0x08 1e 01 30 01 ST32: *(s30 +0x130) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x130) = (uint32_t)S[1];

L_012e:
    /* +0x01c50 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_012f:
    /* +0x01c68 op=0xb5 14 01 15 00 ADD32_IMM16: s1 = int32(s20 +0x15) */
    S[1] = (int32_t)((uint32_t)S[20] + 0x15);

L_0130:
    /* +0x01c80 op=0x53 03 05 10 09 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x910 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x910;

L_0131:
    /* +0x01c98 op=0xb5 00 06 00 00 ADD32_IMM16: s6 = int32(s0 +0x0) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x0);

L_0132:
    /* +0x01cb0 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_0133:
    /* +0x01cc8 op=0x34 02 13 03 00 OR64: s3 = s2 | s19 */
    S[3] = S[2] | S[19];

L_0134:
    /* +0x01ce0 op=0x09 10 02 04 00 SUB32: s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[16] - (uint32_t)S[2]);

L_0135:
    /* +0x01cf8 op=0xae 12 16 1b 00 BR_EQ64: if (s18 == s22) goto record +337 */
    if (S[18] == S[22]) goto L_0151;

L_0136:
    /* +0x01d10 op=0x6e 12 12 07 02 SHL64_IMM: s7 = s18 << 2 */
    S[7] = S[18] << 2;

L_0137:
    /* +0x01d28 op=0x34 03 00 0a 00 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_0138:
    /* +0x01d40 op=0x34 06 00 09 01 OR64: s9 = s6 | s0 */
    S[9] = S[6] | S[0];

L_0139:
    /* +0x01d58 op=0x84 05 07 01 04 ADD64: s1 = s5 + s7 */
    S[1] = S[5] + S[7];

L_013a:
    /* +0x01d70 op=0x52 01 08 00 00 LD32S: s8 = *(int32_t *)(s1 +0x0) */
    S[8] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_013b:
    /* +0x01d88 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +320 */
    if (S[10] == S[0]) goto L_0140;

L_013c:
    /* +0x01da0 op=0x18 10 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_013d:
    /* +0x01db8 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_013e:
    /* +0x01dd0 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_013f:
    /* +0x01de8 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +316 */
    if (S[10] != S[0]) goto L_013c;

L_0140:
    /* +0x01e00 op=0x34 03 00 0b 01 OR64: s11 = s3 | s0 */
    S[11] = S[3] | S[0];

L_0141:
    /* +0x01e18 op=0x34 06 00 0a 01 OR64: s10 = s6 | s0 */
    S[10] = S[6] | S[0];

L_0142:
    /* +0x01e30 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +327 */
    if (S[11] == S[0]) goto L_0147;

L_0143:
    /* +0x01e48 op=0x18 00 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_0144:
    /* +0x01e60 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_0145:
    /* +0x01e78 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_0146:
    /* +0x01e90 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +323 */
    if (S[11] != S[0]) goto L_0143;

L_0147:
    /* +0x01ea8 op=0x0d 02 08 01 01 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[8] >> (S[1] & 31));

L_0148:
    /* +0x01ec0 op=0x17 04 08 08 00 SHL32_VAR: s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31)) */
    S[8] = (int32_t)((uint32_t)S[8] << ((uint32_t)S[4] & 31));

L_0149:
    /* +0x01ed8 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_014a:
    /* +0x01ef0 op=0x84 11 07 07 04 ADD64: s7 = s17 + s7 */
    S[7] = S[17] + S[7];

L_014b:
    /* +0x01f08 op=0xb3 09 01 01 01 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_014c:
    /* +0x01f20 op=0x36 0a 00 09 01 NOR64: s9 = ~(s10 | s0) */
    S[9] = ~(S[10] | S[0]);

L_014d:
    /* +0x01f38 op=0xb3 08 09 08 01 AND64: s8 = s8 & s9 */
    S[8] = S[8] & S[9];

L_014e:
    /* +0x01f50 op=0x34 08 01 01 00 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_014f:
    /* +0x01f68 op=0x08 07 01 00 00 ST32: *(s7 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[7] + 0x0) = (uint32_t)S[1];

L_0150:
    /* +0x01f80 op=0xa7 12 16 e5 ff BR_NE64: if (s18 != s22) goto record +310 */
    if (S[18] != S[22]) goto L_0136;

L_0151:
    /* +0x01f98 op=0x52 1e 01 5c 02 LD32S: s1 = *(int32_t *)(s30 +0x25c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x25c);

L_0152:
    /* +0x01fb0 op=0x85 1e 11 e0 01 ADD64_IMM16: s17 = s30 +0x1e0 */
    S[17] = S[30] + 0x1e0;

L_0153:
    /* +0x01fc8 op=0x85 00 12 00 00 ADD64_IMM16: s18 = s0 +0x0 */
    S[18] = S[0] + 0x0;

L_0154:
    /* +0x01fe0 op=0x85 00 06 40 00 ADD64_IMM16: s6 = s0 +0x40 */
    S[6] = S[0] + 0x40;

L_0155:
    /* +0x01ff8 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0156:
    /* +0x02010 op=0x34 12 00 05 00 OR64: s5 = s18 | s0 */
    S[5] = S[18] | S[0];

L_0157:
    /* +0x02028 op=0x08 1e 01 1c 00 ST32: *(s30 +0x1c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1c) = (uint32_t)S[1];

L_0158:
    /* +0x02040 op=0x52 1e 01 58 02 LD32S: s1 = *(int32_t *)(s30 +0x258) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x258);

L_0159:
    /* +0x02058 op=0x08 1e 01 cc 01 ST32: *(s30 +0x1cc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1cc) = (uint32_t)S[1];

L_015a:
    /* +0x02070 op=0x52 1e 01 54 02 LD32S: s1 = *(int32_t *)(s30 +0x254) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x254);

L_015b:
    /* +0x02088 op=0x08 1e 01 18 00 ST32: *(s30 +0x18) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x18) = (uint32_t)S[1];

L_015c:
    /* +0x020a0 op=0x52 1e 01 50 02 LD32S: s1 = *(int32_t *)(s30 +0x250) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x250);

L_015d:
    /* +0x020b8 op=0x08 1e 01 14 00 ST32: *(s30 +0x14) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x14) = (uint32_t)S[1];

L_015e:
    /* +0x020d0 op=0x52 1e 01 4c 02 LD32S: s1 = *(int32_t *)(s30 +0x24c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x24c);

L_015f:
    /* +0x020e8 op=0x08 1e 01 c8 01 ST32: *(s30 +0x1c8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1c8) = (uint32_t)S[1];

L_0160:
    /* +0x02100 op=0x52 1e 01 48 02 LD32S: s1 = *(int32_t *)(s30 +0x248) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x248);

L_0161:
    /* +0x02118 op=0x08 1e 01 0c 00 ST32: *(s30 +0xc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xc) = (uint32_t)S[1];

L_0162:
    /* +0x02130 op=0x52 1e 01 44 02 LD32S: s1 = *(int32_t *)(s30 +0x244) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x244);

L_0163:
    /* +0x02148 op=0x08 1e 01 40 00 ST32: *(s30 +0x40) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x40) = (uint32_t)S[1];

L_0164:
    /* +0x02160 op=0x52 1e 01 40 02 LD32S: s1 = *(int32_t *)(s30 +0x240) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x240);

L_0165:
    /* +0x02178 op=0x08 1e 01 48 00 ST32: *(s30 +0x48) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x48) = (uint32_t)S[1];

L_0166:
    /* +0x02190 op=0x52 1e 01 3c 02 LD32S: s1 = *(int32_t *)(s30 +0x23c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x23c);

L_0167:
    /* +0x021a8 op=0x08 1e 01 08 00 ST32: *(s30 +0x8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x8) = (uint32_t)S[1];

L_0168:
    /* +0x021c0 op=0x52 1e 01 38 02 LD32S: s1 = *(int32_t *)(s30 +0x238) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x238);

L_0169:
    /* +0x021d8 op=0x08 1e 01 10 00 ST32: *(s30 +0x10) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x10) = (uint32_t)S[1];

L_016a:
    /* +0x021f0 op=0x52 1e 01 34 02 LD32S: s1 = *(int32_t *)(s30 +0x234) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x234);

L_016b:
    /* +0x02208 op=0x08 1e 01 8c 01 ST32: *(s30 +0x18c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x18c) = (uint32_t)S[1];

L_016c:
    /* +0x02220 op=0x52 1e 01 30 02 LD32S: s1 = *(int32_t *)(s30 +0x230) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x230);

L_016d:
    /* +0x02238 op=0x08 1e 01 54 00 ST32: *(s30 +0x54) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x54) = (uint32_t)S[1];

L_016e:
    /* +0x02250 op=0x52 1e 01 2c 02 LD32S: s1 = *(int32_t *)(s30 +0x22c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x22c);

L_016f:
    /* +0x02268 op=0x08 1e 01 80 01 ST32: *(s30 +0x180) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x180) = (uint32_t)S[1];

L_0170:
    /* +0x02280 op=0x52 1e 01 28 02 LD32S: s1 = *(int32_t *)(s30 +0x228) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x228);

L_0171:
    /* +0x02298 op=0x08 1e 01 94 01 ST32: *(s30 +0x194) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x194) = (uint32_t)S[1];

L_0172:
    /* +0x022b0 op=0x52 1e 01 24 02 LD32S: s1 = *(int32_t *)(s30 +0x224) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x224);

L_0173:
    /* +0x022c8 op=0x08 1e 01 98 01 ST32: *(s30 +0x198) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x198) = (uint32_t)S[1];

L_0174:
    /* +0x022e0 op=0x52 1e 01 20 02 LD32S: s1 = *(int32_t *)(s30 +0x220) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x220);

L_0175:
    /* +0x022f8 op=0x08 1e 01 9c 01 ST32: *(s30 +0x19c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x19c) = (uint32_t)S[1];

L_0176:
    /* +0x02310 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0177:
    /* +0x02328 op=0xb5 14 01 16 00 ADD32_IMM16: s1 = int32(s20 +0x16) */
    S[1] = (int32_t)((uint32_t)S[20] + 0x16);

L_0178:
    /* +0x02340 op=0x53 03 05 50 09 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x950 q1=0x125fd3a8 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd3a8 + 0x950;

L_0179:
    /* +0x02358 op=0xb5 00 06 00 00 ADD32_IMM16: s6 = int32(s0 +0x0) */
    S[6] = (int32_t)((uint32_t)S[0] + 0x0);

L_017a:
    /* +0x02370 op=0xb2 01 02 1f 00 AND64_IMM16: s2 = s1 & 0x1f */
    S[2] = S[1] & 0x1f;

L_017b:
    /* +0x02388 op=0x34 02 13 03 01 OR64: s3 = s2 | s19 */
    S[3] = S[2] | S[19];

L_017c:
    /* +0x023a0 op=0x09 10 02 04 14 SUB32: s4 = sign_extend_32((uint32_t)s16 - (uint32_t)s2) */
    S[4] = (int32_t)((uint32_t)S[16] - (uint32_t)S[2]);

L_017d:
    /* +0x023b8 op=0xae 12 16 1b 00 BR_EQ64: if (s18 == s22) goto record +409 */
    if (S[18] == S[22]) goto L_0199;

L_017e:
    /* +0x023d0 op=0x6e 00 12 07 02 SHL64_IMM: s7 = s18 << 2 */
    S[7] = S[18] << 2;

L_017f:
    /* +0x023e8 op=0x34 03 00 0a 01 OR64: s10 = s3 | s0 */
    S[10] = S[3] | S[0];

L_0180:
    /* +0x02400 op=0x34 06 00 09 01 OR64: s9 = s6 | s0 */
    S[9] = S[6] | S[0];

L_0181:
    /* +0x02418 op=0x84 05 07 01 14 ADD64: s1 = s5 + s7 */
    S[1] = S[5] + S[7];

L_0182:
    /* +0x02430 op=0x52 01 08 00 00 LD32S: s8 = *(int32_t *)(s1 +0x0) */
    S[8] = *(int32_t *)((uint8_t *)S[1] + 0x0);

L_0183:
    /* +0x02448 op=0xae 0a 00 04 00 BR_EQ64: if (s10 == s0) goto record +392 */
    if (S[10] == S[0]) goto L_0188;

L_0184:
    /* +0x02460 op=0x18 11 09 01 01 SHL32_IMM: s1 = (int32_t)(s9 << 1) */
    S[1] = (int32_t)((uint32_t)S[9] << 1);

L_0185:
    /* +0x02478 op=0xb5 0a 0a 01 00 ADD32_IMM16: s10 = int32(s10 +0x1) */
    S[10] = (int32_t)((uint32_t)S[10] + 0x1);

L_0186:
    /* +0x02490 op=0x33 01 09 01 00 OR_IMM16: s9 = s1 | 0x1 */
    S[9] = S[1] | 0x1;

L_0187:
    /* +0x024a8 op=0xa7 0a 00 fc ff BR_NE64: if (s10 != s0) goto record +388 */
    if (S[10] != S[0]) goto L_0184;

L_0188:
    /* +0x024c0 op=0x34 03 00 0b 01 OR64: s11 = s3 | s0 */
    S[11] = S[3] | S[0];

L_0189:
    /* +0x024d8 op=0x34 06 00 0a 01 OR64: s10 = s6 | s0 */
    S[10] = S[6] | S[0];

L_018a:
    /* +0x024f0 op=0xae 0b 00 04 00 BR_EQ64: if (s11 == s0) goto record +399 */
    if (S[11] == S[0]) goto L_018f;

L_018b:
    /* +0x02508 op=0x18 00 0a 01 01 SHL32_IMM: s1 = (int32_t)(s10 << 1) */
    S[1] = (int32_t)((uint32_t)S[10] << 1);

L_018c:
    /* +0x02520 op=0xb5 0b 0b 01 00 ADD32_IMM16: s11 = int32(s11 +0x1) */
    S[11] = (int32_t)((uint32_t)S[11] + 0x1);

L_018d:
    /* +0x02538 op=0x33 01 0a 01 00 OR_IMM16: s10 = s1 | 0x1 */
    S[10] = S[1] | 0x1;

L_018e:
    /* +0x02550 op=0xa7 0b 00 fc ff BR_NE64: if (s11 != s0) goto record +395 */
    if (S[11] != S[0]) goto L_018b;

L_018f:
    /* +0x02568 op=0x0d 02 08 01 01 BYTE_FROM_U32_SHIFT: s2 = (uint8_t)((uint32_t)s8 >> (s1 & 31)) */
    S[2] = (uint8_t)((uint32_t)S[8] >> (S[1] & 31));

L_0190:
    /* +0x02580 op=0x17 04 08 08 07 SHL32_VAR: s8 = (int32_t)((uint32_t)s8 << ((uint32_t)s4 & 31)) */
    S[8] = (int32_t)((uint32_t)S[8] << ((uint32_t)S[4] & 31));

L_0191:
    /* +0x02598 op=0x85 12 12 01 00 ADD64_IMM16: s18 = s18 +0x1 */
    S[18] = S[18] + 0x1;

L_0192:
    /* +0x025b0 op=0x84 11 07 07 04 ADD64: s7 = s17 + s7 */
    S[7] = S[17] + S[7];

L_0193:
    /* +0x025c8 op=0xb3 09 01 01 00 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_0194:
    /* +0x025e0 op=0x36 0a 00 09 00 NOR64: s9 = ~(s10 | s0) */
    S[9] = ~(S[10] | S[0]);

L_0195:
    /* +0x025f8 op=0xb3 08 09 08 01 AND64: s8 = s8 & s9 */
    S[8] = S[8] & S[9];

L_0196:
    /* +0x02610 op=0x34 08 01 01 00 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_0197:
    /* +0x02628 op=0x08 07 01 00 00 ST32: *(s7 +0x0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[7] + 0x0) = (uint32_t)S[1];

L_0198:
    /* +0x02640 op=0xa7 12 16 e5 ff BR_NE64: if (s18 != s22) goto record +382 */
    if (S[18] != S[22]) goto L_017e;

L_0199:
    /* +0x02658 op=0x52 1e 01 70 00 LD32S: s1 = *(int32_t *)(s30 +0x70) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x70);

L_019a:
    /* +0x02670 op=0x52 1e 04 7c 00 LD32S: s4 = *(int32_t *)(s30 +0x7c) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x7c);

L_019b:
    /* +0x02688 op=0x52 1e 02 74 00 LD32S: s2 = *(int32_t *)(s30 +0x74) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x74);

L_019c:
    /* +0x026a0 op=0x52 1e 03 64 00 LD32S: s3 = *(int32_t *)(s30 +0x64) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x64);

L_019d:
    /* +0x026b8 op=0x52 1e 05 e0 00 LD32S: s5 = *(int32_t *)(s30 +0xe0) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0xe0);

L_019e:
    /* +0x026d0 op=0x52 1e 06 b8 00 LD32S: s6 = *(int32_t *)(s30 +0xb8) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0xb8);

L_019f:
    /* +0x026e8 op=0x34 15 00 14 01 OR64: s20 = s21 | s0 */
    S[20] = S[21] | S[0];

L_01a0:
    /* +0x02700 op=0x02 17 15 11 01 XOR64: s17 = s21 ^ s23 */
    S[17] = S[21] ^ S[23];

L_01a1:
    /* +0x02718 op=0x08 1e 17 c0 01 ST32: *(s30 +0x1c0) = (uint32_t)s23 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1c0) = (uint32_t)S[23];

L_01a2:
    /* +0x02730 op=0x18 00 01 01 08 SHL32_IMM: s1 = (int32_t)(s1 << 8) */
    S[1] = (int32_t)((uint32_t)S[1] << 8);

L_01a3:
    /* +0x02748 op=0x18 11 04 04 10 SHL32_IMM: s4 = (int32_t)(s4 << 16) */
    S[4] = (int32_t)((uint32_t)S[4] << 16);

L_01a4:
    /* +0x02760 op=0x18 10 03 03 08 SHL32_IMM: s3 = (int32_t)(s3 << 8) */
    S[3] = (int32_t)((uint32_t)S[3] << 8);

L_01a5:
    /* +0x02778 op=0x18 10 05 05 08 SHL32_IMM: s5 = (int32_t)(s5 << 8) */
    S[5] = (int32_t)((uint32_t)S[5] << 8);

L_01a6:
    /* +0x02790 op=0x18 00 06 06 08 SHL32_IMM: s6 = (int32_t)(s6 << 8) */
    S[6] = (int32_t)((uint32_t)S[6] << 8);

L_01a7:
    /* +0x027a8 op=0x34 01 02 01 01 OR64: s1 = s1 | s2 */
    S[1] = S[1] | S[2];

L_01a8:
    /* +0x027c0 op=0x52 1e 02 a8 00 LD32S: s2 = *(int32_t *)(s30 +0xa8) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0xa8);

L_01a9:
    /* +0x027d8 op=0x34 01 04 16 00 OR64: s22 = s1 | s4 */
    S[22] = S[1] | S[4];

L_01aa:
    /* +0x027f0 op=0x52 1e 01 a0 00 LD32S: s1 = *(int32_t *)(s30 +0xa0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xa0);

L_01ab:
    /* +0x02808 op=0x18 00 02 02 08 SHL32_IMM: s2 = (int32_t)(s2 << 8) */
    S[2] = (int32_t)((uint32_t)S[2] << 8);

L_01ac:
    /* +0x02820 op=0x18 10 01 04 08 SHL32_IMM: s4 = (int32_t)(s1 << 8) */
    S[4] = (int32_t)((uint32_t)S[1] << 8);

L_01ad:
    /* +0x02838 op=0x52 1e 01 60 00 LD32S: s1 = *(int32_t *)(s30 +0x60) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x60);

L_01ae:
    /* +0x02850 op=0x18 11 01 07 08 SHL32_IMM: s7 = (int32_t)(s1 << 8) */
    S[7] = (int32_t)((uint32_t)S[1] << 8);

L_01af:
    /* +0x02868 op=0x52 1e 01 e4 00 LD32S: s1 = *(int32_t *)(s30 +0xe4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xe4);

L_01b0:
    /* +0x02880 op=0x18 11 01 08 08 SHL32_IMM: s8 = (int32_t)(s1 << 8) */
    S[8] = (int32_t)((uint32_t)S[1] << 8);

L_01b1:
    /* +0x02898 op=0x52 1e 01 78 00 LD32S: s1 = *(int32_t *)(s30 +0x78) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x78);

L_01b2:
    /* +0x028b0 op=0x34 03 01 03 01 OR64: s3 = s3 | s1 */
    S[3] = S[3] | S[1];

L_01b3:
    /* +0x028c8 op=0x52 1e 01 c0 00 LD32S: s1 = *(int32_t *)(s30 +0xc0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xc0);

L_01b4:
    /* +0x028e0 op=0x34 02 01 1f 01 OR64: s31 = s2 | s1 */
    S[31] = S[2] | S[1];

L_01b5:
    /* +0x028f8 op=0x52 1e 01 d4 00 LD32S: s1 = *(int32_t *)(s30 +0xd4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xd4);

L_01b6:
    /* +0x02910 op=0x18 10 01 09 10 SHL32_IMM: s9 = (int32_t)(s1 << 16) */
    S[9] = (int32_t)((uint32_t)S[1] << 16);

L_01b7:
    /* +0x02928 op=0x52 1e 01 e8 00 LD32S: s1 = *(int32_t *)(s30 +0xe8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xe8);

L_01b8:
    /* +0x02940 op=0x18 11 01 0a 08 SHL32_IMM: s10 = (int32_t)(s1 << 8) */
    S[10] = (int32_t)((uint32_t)S[1] << 8);

L_01b9:
    /* +0x02958 op=0x52 1e 01 5c 00 LD32S: s1 = *(int32_t *)(s30 +0x5c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x5c);

L_01ba:
    /* +0x02970 op=0x18 11 01 0b 08 SHL32_IMM: s11 = (int32_t)(s1 << 8) */
    S[11] = (int32_t)((uint32_t)S[1] << 8);

L_01bb:
    /* +0x02988 op=0x52 1e 01 98 00 LD32S: s1 = *(int32_t *)(s30 +0x98) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x98);

L_01bc:
    /* +0x029a0 op=0x18 10 01 0c 08 SHL32_IMM: s12 = (int32_t)(s1 << 8) */
    S[12] = (int32_t)((uint32_t)S[1] << 8);

L_01bd:
    /* +0x029b8 op=0x52 1e 01 b0 00 LD32S: s1 = *(int32_t *)(s30 +0xb0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xb0);

L_01be:
    /* +0x029d0 op=0x18 11 01 0d 18 SHL32_IMM: s13 = (int32_t)(s1 << 24) */
    S[13] = (int32_t)((uint32_t)S[1] << 24);

L_01bf:
    /* +0x029e8 op=0x52 1e 01 14 01 LD32S: s1 = *(int32_t *)(s30 +0x114) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x114);

L_01c0:
    /* +0x02a00 op=0x34 05 01 05 01 OR64: s5 = s5 | s1 */
    S[5] = S[5] | S[1];

L_01c1:
    /* +0x02a18 op=0x52 1e 01 ec 00 LD32S: s1 = *(int32_t *)(s30 +0xec) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xec);

L_01c2:
    /* +0x02a30 op=0x34 06 01 06 01 OR64: s6 = s6 | s1 */
    S[6] = S[6] | S[1];

L_01c3:
    /* +0x02a48 op=0x52 1e 01 9c 00 LD32S: s1 = *(int32_t *)(s30 +0x9c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x9c);

L_01c4:
    /* +0x02a60 op=0x34 06 09 06 00 OR64: s6 = s6 | s9 */
    S[6] = S[6] | S[9];

L_01c5:
    /* +0x02a78 op=0x18 00 01 0e 10 SHL32_IMM: s14 = (int32_t)(s1 << 16) */
    S[14] = (int32_t)((uint32_t)S[1] << 16);

L_01c6:
    /* +0x02a90 op=0x52 1e 01 f0 00 LD32S: s1 = *(int32_t *)(s30 +0xf0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xf0);

L_01c7:
    /* +0x02aa8 op=0x34 03 0e 03 00 OR64: s3 = s3 | s14 */
    S[3] = S[3] | S[14];

L_01c8:
    /* +0x02ac0 op=0x18 11 01 0f 10 SHL32_IMM: s15 = (int32_t)(s1 << 16) */
    S[15] = (int32_t)((uint32_t)S[1] << 16);

L_01c9:
    /* +0x02ad8 op=0x52 1e 01 8c 00 LD32S: s1 = *(int32_t *)(s30 +0x8c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x8c);

L_01ca:
    /* +0x02af0 op=0x18 10 01 18 08 SHL32_IMM: s24 = (int32_t)(s1 << 8) */
    S[24] = (int32_t)((uint32_t)S[1] << 8);

L_01cb:
    /* +0x02b08 op=0x52 1e 01 c4 00 LD32S: s1 = *(int32_t *)(s30 +0xc4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xc4);

L_01cc:
    /* +0x02b20 op=0x18 10 01 19 08 SHL32_IMM: s25 = (int32_t)(s1 << 8) */
    S[25] = (int32_t)((uint32_t)S[1] << 8);

L_01cd:
    /* +0x02b38 op=0x52 1e 01 68 00 LD32S: s1 = *(int32_t *)(s30 +0x68) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x68);

L_01ce:
    /* +0x02b50 op=0x18 00 01 10 08 SHL32_IMM: s16 = (int32_t)(s1 << 8) */
    S[16] = (int32_t)((uint32_t)S[1] << 8);

L_01cf:
    /* +0x02b68 op=0x52 1e 01 20 00 LD32S: s1 = *(int32_t *)(s30 +0x20) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x20);

L_01d0:
    /* +0x02b80 op=0x34 08 01 01 00 OR64: s1 = s8 | s1 */
    S[1] = S[8] | S[1];

L_01d1:
    /* +0x02b98 op=0x08 1e 01 f0 00 ST32: *(s30 +0xf0) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0xf0) = (uint32_t)S[1];

L_01d2:
    /* +0x02bb0 op=0x52 1e 01 84 00 LD32S: s1 = *(int32_t *)(s30 +0x84) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x84);

L_01d3:
    /* +0x02bc8 op=0x34 07 01 13 01 OR64: s19 = s7 | s1 */
    S[19] = S[7] | S[1];

L_01d4:
    /* +0x02be0 op=0x52 1e 01 d8 00 LD32S: s1 = *(int32_t *)(s30 +0xd8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xd8);

L_01d5:
    /* +0x02bf8 op=0x34 17 00 07 01 OR64: s7 = s23 | s0 */
    S[7] = S[23] | S[0];

L_01d6:
    /* +0x02c10 op=0x34 04 01 08 00 OR64: s8 = s4 | s1 */
    S[8] = S[4] | S[1];

L_01d7:
    /* +0x02c28 op=0x52 1e 04 3c 01 LD32S: s4 = *(int32_t *)(s30 +0x13c) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x13c);

L_01d8:
    /* +0x02c40 op=0x52 1e 01 d8 01 LD32S: s1 = *(int32_t *)(s30 +0x1d8) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x1d8);

L_01d9:
    /* +0x02c58 op=0x18 11 04 12 10 SHL32_IMM: s18 = (int32_t)(s4 << 16) */
    S[18] = (int32_t)((uint32_t)S[4] << 16);

L_01da:
    /* +0x02c70 op=0x52 1e 04 00 01 LD32S: s4 = *(int32_t *)(s30 +0x100) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x100);

L_01db:
    /* +0x02c88 op=0xb3 11 01 11 00 AND64: s17 = s17 & s1 */
    S[17] = S[17] & S[1];

L_01dc:
    /* +0x02ca0 op=0x34 16 0d 01 01 OR64: s1 = s22 | s13 */
    S[1] = S[22] | S[13];

L_01dd:
    /* +0x02cb8 op=0x34 05 12 02 01 OR64: s2 = s5 | s18 */
    S[2] = S[5] | S[18];

L_01de:
    /* +0x02cd0 op=0x02 11 17 0e 01 XOR64: s14 = s23 ^ s17 */
    S[14] = S[23] ^ S[17];

L_01df:
    /* +0x02ce8 op=0x08 1e 01 14 01 ST32: *(s30 +0x114) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x114) = (uint32_t)S[1];

L_01e0:
    /* +0x02d00 op=0x18 11 04 15 08 SHL32_IMM: s21 = (int32_t)(s4 << 8) */
    S[21] = (int32_t)((uint32_t)S[4] << 8);

L_01e1:
    /* +0x02d18 op=0x52 1e 04 c8 00 LD32S: s4 = *(int32_t *)(s30 +0xc8) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0xc8);

L_01e2:
    /* +0x02d30 op=0x34 0c 04 0d 01 OR64: s13 = s12 | s4 */
    S[13] = S[12] | S[4];

L_01e3:
    /* +0x02d48 op=0x52 1e 04 94 00 LD32S: s4 = *(int32_t *)(s30 +0x94) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x94);

L_01e4:
    /* +0x02d60 op=0x34 1f 0f 0c 00 OR64: s12 = s31 | s15 */
    S[12] = S[31] | S[15];

L_01e5:
    /* +0x02d78 op=0x34 0b 04 0b 01 OR64: s11 = s11 | s4 */
    S[11] = S[11] | S[4];

L_01e6:
    /* +0x02d90 op=0x52 1e 04 28 01 LD32S: s4 = *(int32_t *)(s30 +0x128) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x128);

L_01e7:
    /* +0x02da8 op=0x08 1e 02 28 01 ST32: *(s30 +0x128) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x128) = (uint32_t)S[2];

L_01e8:
    /* +0x02dc0 op=0x34 0a 04 0a 00 OR64: s10 = s10 | s4 */
    S[10] = S[10] | S[4];

L_01e9:
    /* +0x02dd8 op=0x52 1e 04 90 00 LD32S: s4 = *(int32_t *)(s30 +0x90) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x90);

L_01ea:
    /* +0x02df0 op=0x34 10 04 09 01 OR64: s9 = s16 | s4 */
    S[9] = S[16] | S[4];

L_01eb:
    /* +0x02e08 op=0x52 1e 04 04 01 LD32S: s4 = *(int32_t *)(s30 +0x104) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x104);

L_01ec:
    /* +0x02e20 op=0x34 19 04 05 01 OR64: s5 = s25 | s4 */
    S[5] = S[25] | S[4];

L_01ed:
    /* +0x02e38 op=0x52 1e 04 d0 00 LD32S: s4 = *(int32_t *)(s30 +0xd0) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0xd0);

L_01ee:
    /* +0x02e50 op=0x34 18 04 0f 01 OR64: s15 = s24 | s4 */
    S[15] = S[24] | S[4];

L_01ef:
    /* +0x02e68 op=0x52 1e 04 34 01 LD32S: s4 = *(int32_t *)(s30 +0x134) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x134);

L_01f0:
    /* +0x02e80 op=0x18 11 04 18 18 SHL32_IMM: s24 = (int32_t)(s4 << 24) */
    S[24] = (int32_t)((uint32_t)S[4] << 24);

L_01f1:
    /* +0x02e98 op=0x52 1e 04 b4 00 LD32S: s4 = *(int32_t *)(s30 +0xb4) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0xb4);

L_01f2:
    /* +0x02eb0 op=0x18 11 04 19 10 SHL32_IMM: s25 = (int32_t)(s4 << 16) */
    S[25] = (int32_t)((uint32_t)S[4] << 16);

L_01f3:
    /* +0x02ec8 op=0x52 1e 04 bc 00 LD32S: s4 = *(int32_t *)(s30 +0xbc) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0xbc);

L_01f4:
    /* +0x02ee0 op=0x34 0b 19 0b 01 OR64: s11 = s11 | s25 */
    S[11] = S[11] | S[25];

L_01f5:
    /* +0x02ef8 op=0x34 14 00 19 01 OR64: s25 = s20 | s0 */
    S[25] = S[20] | S[0];

L_01f6:
    /* +0x02f10 op=0x18 11 04 10 08 SHL32_IMM: s16 = (int32_t)(s4 << 8) */
    S[16] = (int32_t)((uint32_t)S[4] << 8);

L_01f7:
    /* +0x02f28 op=0x52 1e 04 08 01 LD32S: s4 = *(int32_t *)(s30 +0x108) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x108);

L_01f8:
    /* +0x02f40 op=0x08 1e 19 88 01 ST32: *(s30 +0x188) = (uint32_t)s25 */
    *(uint32_t *)((uint8_t *)S[30] + 0x188) = (uint32_t)S[25];

L_01f9:
    /* +0x02f58 op=0x18 00 04 11 10 SHL32_IMM: s17 = (int32_t)(s4 << 16) */
    S[17] = (int32_t)((uint32_t)S[4] << 16);

L_01fa:
    /* +0x02f70 op=0x52 1e 04 fc 00 LD32S: s4 = *(int32_t *)(s30 +0xfc) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0xfc);

L_01fb:
    /* +0x02f88 op=0x34 0d 11 02 01 OR64: s2 = s13 | s17 */
    S[2] = S[13] | S[17];

L_01fc:
    /* +0x02fa0 op=0x18 11 04 12 18 SHL32_IMM: s18 = (int32_t)(s4 << 24) */
    S[18] = (int32_t)((uint32_t)S[4] << 24);

L_01fd:
    /* +0x02fb8 op=0x52 1e 04 54 01 LD32S: s4 = *(int32_t *)(s30 +0x154) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x154);

L_01fe:
    /* +0x02fd0 op=0x18 00 04 16 10 SHL32_IMM: s22 = (int32_t)(s4 << 16) */
    S[22] = (int32_t)((uint32_t)S[4] << 16);

L_01ff:
    /* +0x02fe8 op=0x52 1e 04 5c 01 LD32S: s4 = *(int32_t *)(s30 +0x15c) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x15c);

L_0200:
    /* +0x03000 op=0x34 0a 16 0a 01 OR64: s10 = s10 | s22 */
    S[10] = S[10] | S[22];

L_0201:
    /* +0x03018 op=0x18 00 04 17 10 SHL32_IMM: s23 = (int32_t)(s4 << 16) */
    S[23] = (int32_t)((uint32_t)S[4] << 16);

L_0202:
    /* +0x03030 op=0x52 1e 04 38 01 LD32S: s4 = *(int32_t *)(s30 +0x138) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x138);

L_0203:
    /* +0x03048 op=0x34 15 04 04 01 OR64: s4 = s21 | s4 */
    S[4] = S[21] | S[4];

L_0204:
    /* +0x03060 op=0x52 1e 15 dc 01 LD32S: s21 = *(int32_t *)(s30 +0x1dc) */
    S[21] = *(int32_t *)((uint8_t *)S[30] + 0x1dc);

L_0205:
    /* +0x03078 op=0xb4 15 01 1f 00 ADD32: s31 = int32(s21 + s1) */
    S[31] = (int32_t)((uint32_t)S[21] + (uint32_t)S[1]);

L_0206:
    /* +0x03090 op=0xb4 1f 0e 01 02 ADD32: s1 = int32(s31 + s14) */
    S[1] = (int32_t)((uint32_t)S[31] + (uint32_t)S[14]);

L_0207:
    /* +0x030a8 op=0x52 1e 0e 40 01 LD32S: s14 = *(int32_t *)(s30 +0x140) */
    S[14] = *(int32_t *)((uint8_t *)S[30] + 0x140);

L_0208:
    /* +0x030c0 op=0x08 1e 01 5c 01 ST32: *(s30 +0x15c) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x15c) = (uint32_t)S[1];

L_0209:
    /* +0x030d8 op=0x18 11 0e 1f 10 SHL32_IMM: s31 = (int32_t)(s14 << 16) */
    S[31] = (int32_t)((uint32_t)S[14] << 16);

L_020a:
    /* +0x030f0 op=0x34 08 1f 01 01 OR64: s1 = s8 | s31 */
    S[1] = S[8] | S[31];

L_020b:
    /* +0x03108 op=0x52 1e 08 f8 00 LD32S: s8 = *(int32_t *)(s30 +0xf8) */
    S[8] = *(int32_t *)((uint8_t *)S[30] + 0xf8);

L_020c:
    /* +0x03120 op=0x08 1e 01 54 01 ST32: *(s30 +0x154) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x154) = (uint32_t)S[1];

L_020d:
    /* +0x03138 op=0x52 1e 01 f0 00 LD32S: s1 = *(int32_t *)(s30 +0xf0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xf0);

L_020e:
    /* +0x03150 op=0x18 10 08 1f 10 SHL32_IMM: s31 = (int32_t)(s8 << 16) */
    S[31] = (int32_t)((uint32_t)S[8] << 16);

L_020f:
    /* +0x03168 op=0x34 13 1f 0e 01 OR64: s14 = s19 | s31 */
    S[14] = S[19] | S[31];

L_0210:
    /* +0x03180 op=0x34 01 17 13 01 OR64: s19 = s1 | s23 */
    S[19] = S[1] | S[23];

L_0211:
    /* +0x03198 op=0x52 1e 01 f4 00 LD32S: s1 = *(int32_t *)(s30 +0xf4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xf4);

L_0212:
    /* +0x031b0 op=0x34 10 01 15 01 OR64: s21 = s16 | s1 */
    S[21] = S[16] | S[1];

L_0213:
    /* +0x031c8 op=0x52 1e 01 68 01 LD32S: s1 = *(int32_t *)(s30 +0x168) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x168);

L_0214:
    /* +0x031e0 op=0x34 03 12 10 01 OR64: s16 = s3 | s18 */
    S[16] = S[3] | S[18];

L_0215:
    /* +0x031f8 op=0x34 0c 18 03 00 OR64: s3 = s12 | s24 */
    S[3] = S[12] | S[24];

L_0216:
    /* +0x03210 op=0x08 1e 10 3c 01 ST32: *(s30 +0x13c) = (uint32_t)s16 */
    *(uint32_t *)((uint8_t *)S[30] + 0x13c) = (uint32_t)S[16];

L_0217:
    /* +0x03228 op=0x18 11 01 17 18 SHL32_IMM: s23 = (int32_t)(s1 << 24) */
    S[23] = (int32_t)((uint32_t)S[1] << 24);

L_0218:
    /* +0x03240 op=0x52 1e 01 dc 00 LD32S: s1 = *(int32_t *)(s30 +0xdc) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xdc);

L_0219:
    /* +0x03258 op=0x34 06 17 12 01 OR64: s18 = s6 | s23 */
    S[18] = S[6] | S[23];

L_021a:
    /* +0x03270 op=0x18 11 01 1f 10 SHL32_IMM: s31 = (int32_t)(s1 << 16) */
    S[31] = (int32_t)((uint32_t)S[1] << 16);

L_021b:
    /* +0x03288 op=0x52 1e 01 50 01 LD32S: s1 = *(int32_t *)(s30 +0x150) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x150);

L_021c:
    /* +0x032a0 op=0x34 09 1f 09 01 OR64: s9 = s9 | s31 */
    S[9] = S[9] | S[31];

L_021d:
    /* +0x032b8 op=0x18 10 01 0c 10 SHL32_IMM: s12 = (int32_t)(s1 << 16) */
    S[12] = (int32_t)((uint32_t)S[1] << 16);

L_021e:
    /* +0x032d0 op=0x52 1e 01 6c 01 LD32S: s1 = *(int32_t *)(s30 +0x16c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x16c);

L_021f:
    /* +0x032e8 op=0x34 05 0c 0c 00 OR64: s12 = s5 | s12 */
    S[12] = S[5] | S[12];

L_0220:
    /* +0x03300 op=0x18 00 01 18 10 SHL32_IMM: s24 = (int32_t)(s1 << 16) */
    S[24] = (int32_t)((uint32_t)S[1] << 16);

L_0221:
    /* +0x03318 op=0x52 1e 01 24 01 LD32S: s1 = *(int32_t *)(s30 +0x124) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x124);

L_0222:
    /* +0x03330 op=0x34 04 18 18 01 OR64: s24 = s4 | s24 */
    S[24] = S[4] | S[24];

L_0223:
    /* +0x03348 op=0x52 1e 04 44 00 LD32S: s4 = *(int32_t *)(s30 +0x44) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x44);

L_0224:
    /* +0x03360 op=0x18 11 01 06 18 SHL32_IMM: s6 = (int32_t)(s1 << 24) */
    S[6] = (int32_t)((uint32_t)S[1] << 24);

L_0225:
    /* +0x03378 op=0x52 1e 01 90 01 LD32S: s1 = *(int32_t *)(s30 +0x190) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x190);

L_0226:
    /* +0x03390 op=0x18 10 01 11 18 SHL32_IMM: s17 = (int32_t)(s1 << 24) */
    S[17] = (int32_t)((uint32_t)S[1] << 24);

L_0227:
    /* +0x033a8 op=0x52 1e 01 10 01 LD32S: s1 = *(int32_t *)(s30 +0x110) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x110);

L_0228:
    /* +0x033c0 op=0x34 13 11 13 00 OR64: s19 = s19 | s17 */
    S[19] = S[19] | S[17];

L_0229:
    /* +0x033d8 op=0x18 11 01 16 18 SHL32_IMM: s22 = (int32_t)(s1 << 24) */
    S[22] = (int32_t)((uint32_t)S[1] << 24);

L_022a:
    /* +0x033f0 op=0x52 1e 01 1c 01 LD32S: s1 = *(int32_t *)(s30 +0x11c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x11c);

L_022b:
    /* +0x03408 op=0x34 09 16 16 00 OR64: s22 = s9 | s22 */
    S[22] = S[9] | S[22];

L_022c:
    /* +0x03420 op=0x18 11 01 17 10 SHL32_IMM: s23 = (int32_t)(s1 << 16) */
    S[23] = (int32_t)((uint32_t)S[1] << 16);

L_022d:
    /* +0x03438 op=0x52 1e 01 a0 01 LD32S: s1 = *(int32_t *)(s30 +0x1a0) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x1a0);

L_022e:
    /* +0x03450 op=0x34 15 17 15 00 OR64: s21 = s21 | s23 */
    S[21] = S[21] | S[23];

L_022f:
    /* +0x03468 op=0x18 00 01 1f 18 SHL32_IMM: s31 = (int32_t)(s1 << 24) */
    S[31] = (int32_t)((uint32_t)S[1] << 24);

L_0230:
    /* +0x03480 op=0x52 1e 01 44 01 LD32S: s1 = *(int32_t *)(s30 +0x144) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x144);

L_0231:
    /* +0x03498 op=0x18 11 01 01 10 SHL32_IMM: s1 = (int32_t)(s1 << 16) */
    S[1] = (int32_t)((uint32_t)S[1] << 16);

L_0232:
    /* +0x034b0 op=0x34 0f 01 0f 01 OR64: s15 = s15 | s1 */
    S[15] = S[15] | S[1];

L_0233:
    /* +0x034c8 op=0x52 1e 01 28 01 LD32S: s1 = *(int32_t *)(s30 +0x128) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x128);

L_0234:
    /* +0x034e0 op=0x34 01 1f 0d 01 OR64: s13 = s1 | s31 */
    S[13] = S[1] | S[31];

L_0235:
    /* +0x034f8 op=0x52 1e 01 7c 01 LD32S: s1 = *(int32_t *)(s30 +0x17c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x17c);

L_0236:
    /* +0x03510 op=0x18 00 01 05 18 SHL32_IMM: s5 = (int32_t)(s1 << 24) */
    S[5] = (int32_t)((uint32_t)S[1] << 24);

L_0237:
    /* +0x03528 op=0x52 1e 01 60 01 LD32S: s1 = *(int32_t *)(s30 +0x160) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x160);

L_0238:
    /* +0x03540 op=0x18 10 01 08 18 SHL32_IMM: s8 = (int32_t)(s1 << 24) */
    S[8] = (int32_t)((uint32_t)S[1] << 24);

L_0239:
    /* +0x03558 op=0x52 1e 01 2c 01 LD32S: s1 = *(int32_t *)(s30 +0x12c) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x12c);

L_023a:
    /* +0x03570 op=0x34 02 08 02 01 OR64: s2 = s2 | s8 */
    S[2] = S[2] | S[8];

L_023b:
    /* +0x03588 op=0x52 1e 08 4c 00 LD32S: s8 = *(int32_t *)(s30 +0x4c) */
    S[8] = *(int32_t *)((uint8_t *)S[30] + 0x4c);

L_023c:
    /* +0x035a0 op=0x18 11 01 1f 18 SHL32_IMM: s31 = (int32_t)(s1 << 24) */
    S[31] = (int32_t)((uint32_t)S[1] << 24);

L_023d:
    /* +0x035b8 op=0x34 0e 06 01 00 OR64: s1 = s14 | s6 */
    S[1] = S[14] | S[6];

L_023e:
    /* +0x035d0 op=0x52 1e 06 5c 01 LD32S: s6 = *(int32_t *)(s30 +0x15c) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x15c);

L_023f:
    /* +0x035e8 op=0xb4 06 04 06 00 ADD32: s6 = int32(s6 + s4) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[4]);

L_0240:
    /* +0x03600 op=0x52 1e 04 54 01 LD32S: s4 = *(int32_t *)(s30 +0x154) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x154);

L_0241:
    /* +0x03618 op=0x34 04 05 04 01 OR64: s4 = s4 | s5 */
    S[4] = S[4] | S[5];

L_0242:
    /* +0x03630 op=0xb4 14 03 05 02 ADD32: s5 = int32(s20 + s3) */
    S[5] = (int32_t)((uint32_t)S[20] + (uint32_t)S[3]);

L_0243:
    /* +0x03648 op=0x52 1e 14 1c 00 LD32S: s20 = *(int32_t *)(s30 +0x1c) */
    S[20] = *(int32_t *)((uint8_t *)S[30] + 0x1c);

L_0244:
    /* +0x03660 op=0xb4 05 08 17 12 ADD32: s23 = int32(s5 + s8) */
    S[23] = (int32_t)((uint32_t)S[5] + (uint32_t)S[8]);

L_0245:
    /* +0x03678 op=0xb4 07 10 05 12 ADD32: s5 = int32(s7 + s16) */
    S[5] = (int32_t)((uint32_t)S[7] + (uint32_t)S[16]);

L_0246:
    /* +0x03690 op=0x52 1e 07 50 00 LD32S: s7 = *(int32_t *)(s30 +0x50) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x50);

L_0247:
    /* +0x036a8 op=0x34 0b 1f 08 01 OR64: s8 = s11 | s31 */
    S[8] = S[11] | S[31];

L_0248:
    /* +0x036c0 op=0x52 1e 0b 58 00 LD32S: s11 = *(int32_t *)(s30 +0x58) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x58);

L_0249:
    /* +0x036d8 op=0x52 1e 1f 1c 02 LD32S: s31 = *(int32_t *)(s30 +0x21c) */
    S[31] = *(int32_t *)((uint8_t *)S[30] + 0x21c);

L_024a:
    /* +0x036f0 op=0xb4 14 04 14 12 ADD32: s20 = int32(s20 + s4) */
    S[20] = (int32_t)((uint32_t)S[20] + (uint32_t)S[4]);

L_024b:
    /* +0x03708 op=0xb4 05 07 11 02 ADD32: s17 = int32(s5 + s7) */
    S[17] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_024c:
    /* +0x03720 op=0x52 1e 07 58 01 LD32S: s7 = *(int32_t *)(s30 +0x158) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x158);

L_024d:
    /* +0x03738 op=0x52 1e 05 d8 01 LD32S: s5 = *(int32_t *)(s30 +0x1d8) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x1d8);

L_024e:
    /* +0x03750 op=0x08 1e 14 68 01 ST32: *(s30 +0x168) = (uint32_t)s20 */
    *(uint32_t *)((uint8_t *)S[30] + 0x168) = (uint32_t)S[20];

L_024f:
    /* +0x03768 op=0x18 11 07 09 18 SHL32_IMM: s9 = (int32_t)(s7 << 24) */
    S[9] = (int32_t)((uint32_t)S[7] << 24);

L_0250:
    /* +0x03780 op=0x52 1e 07 a8 01 LD32S: s7 = *(int32_t *)(s30 +0x1a8) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1a8);

L_0251:
    /* +0x03798 op=0x34 05 00 14 01 OR64: s20 = s5 | s0 */
    S[20] = S[5] | S[0];

L_0252:
    /* +0x037b0 op=0x18 10 07 10 18 SHL32_IMM: s16 = (int32_t)(s7 << 24) */
    S[16] = (int32_t)((uint32_t)S[7] << 24);

L_0253:
    /* +0x037c8 op=0x52 1e 07 74 01 LD32S: s7 = *(int32_t *)(s30 +0x174) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x174);

L_0254:
    /* +0x037e0 op=0x34 18 10 10 00 OR64: s16 = s24 | s16 */
    S[16] = S[24] | S[16];

L_0255:
    /* +0x037f8 op=0x34 15 09 18 00 OR64: s24 = s21 | s9 */
    S[24] = S[21] | S[9];

L_0256:
    /* +0x03810 op=0x52 1e 09 28 00 LD32S: s9 = *(int32_t *)(s30 +0x28) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x28);

L_0257:
    /* +0x03828 op=0x18 11 07 0e 18 SHL32_IMM: s14 = (int32_t)(s7 << 24) */
    S[14] = (int32_t)((uint32_t)S[7] << 24);

L_0258:
    /* +0x03840 op=0xb4 05 12 07 00 ADD32: s7 = int32(s5 + s18) */
    S[7] = (int32_t)((uint32_t)S[5] + (uint32_t)S[18]);

L_0259:
    /* +0x03858 op=0xb4 09 03 09 02 ADD32: s9 = int32(s9 + s3) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[3]);

L_025a:
    /* +0x03870 op=0x34 0f 0e 0e 01 OR64: s14 = s15 | s14 */
    S[14] = S[15] | S[14];

L_025b:
    /* +0x03888 op=0xb4 07 0b 07 12 ADD32: s7 = int32(s7 + s11) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[11]);

L_025c:
    /* +0x038a0 op=0x52 1e 0b b4 01 LD32S: s11 = *(int32_t *)(s30 +0x1b4) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x1b4);

L_025d:
    /* +0x038b8 op=0x08 1e 09 44 01 ST32: *(s30 +0x144) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x144) = (uint32_t)S[9];

L_025e:
    /* +0x038d0 op=0x52 1e 09 08 00 LD32S: s9 = *(int32_t *)(s30 +0x8) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x8);

L_025f:
    /* +0x038e8 op=0x18 10 0b 0b 18 SHL32_IMM: s11 = (int32_t)(s11 << 24) */
    S[11] = (int32_t)((uint32_t)S[11] << 24);

L_0260:
    /* +0x03900 op=0xb4 09 03 09 02 ADD32: s9 = int32(s9 + s3) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[3]);

L_0261:
    /* +0x03918 op=0x34 0a 0b 0b 01 OR64: s11 = s10 | s11 */
    S[11] = S[10] | S[11];

L_0262:
    /* +0x03930 op=0x52 1e 0a a4 01 LD32S: s10 = *(int32_t *)(s30 +0x1a4) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x1a4);

L_0263:
    /* +0x03948 op=0x08 1e 09 54 01 ST32: *(s30 +0x154) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x154) = (uint32_t)S[9];

L_0264:
    /* +0x03960 op=0x52 1e 09 f0 01 LD32S: s9 = *(int32_t *)(s30 +0x1f0) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x1f0);

L_0265:
    /* +0x03978 op=0x18 11 0a 0a 18 SHL32_IMM: s10 = (int32_t)(s10 << 24) */
    S[10] = (int32_t)((uint32_t)S[10] << 24);

L_0266:
    /* +0x03990 op=0xb4 09 03 03 02 ADD32: s3 = int32(s9 + s3) */
    S[3] = (int32_t)((uint32_t)S[9] + (uint32_t)S[3]);

L_0267:
    /* +0x039a8 op=0x34 0c 0a 0c 01 OR64: s12 = s12 | s10 */
    S[12] = S[12] | S[10];

L_0268:
    /* +0x039c0 op=0x52 1e 09 30 00 LD32S: s9 = *(int32_t *)(s30 +0x30) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x30);

L_0269:
    /* +0x039d8 op=0x08 1e 03 6c 01 ST32: *(s30 +0x16c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x16c) = (uint32_t)S[3];

L_026a:
    /* +0x039f0 op=0x52 1e 03 6c 00 LD32S: s3 = *(int32_t *)(s30 +0x6c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x6c);

L_026b:
    /* +0x03a08 op=0xb4 03 0d 0f 02 ADD32: s15 = int32(s3 + s13) */
    S[15] = (int32_t)((uint32_t)S[3] + (uint32_t)S[13]);

L_026c:
    /* +0x03a20 op=0x52 1e 03 24 00 LD32S: s3 = *(int32_t *)(s30 +0x24) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x24);

L_026d:
    /* +0x03a38 op=0xb4 03 0d 03 02 ADD32: s3 = int32(s3 + s13) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[13]);

L_026e:
    /* +0x03a50 op=0x08 1e 03 38 01 ST32: *(s30 +0x138) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x138) = (uint32_t)S[3];

L_026f:
    /* +0x03a68 op=0x52 1e 03 f4 01 LD32S: s3 = *(int32_t *)(s30 +0x1f4) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x1f4);

L_0270:
    /* +0x03a80 op=0xb4 03 0d 03 02 ADD32: s3 = int32(s3 + s13) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[13]);

L_0271:
    /* +0x03a98 op=0x08 1e 03 74 01 ST32: *(s30 +0x174) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x174) = (uint32_t)S[3];

L_0272:
    /* +0x03ab0 op=0x52 1e 03 80 00 LD32S: s3 = *(int32_t *)(s30 +0x80) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x80);

L_0273:
    /* +0x03ac8 op=0xb4 03 16 0a 02 ADD32: s10 = int32(s3 + s22) */
    S[10] = (int32_t)((uint32_t)S[3] + (uint32_t)S[22]);

L_0274:
    /* +0x03ae0 op=0x52 1e 03 2c 00 LD32S: s3 = *(int32_t *)(s30 +0x2c) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x2c);

L_0275:
    /* +0x03af8 op=0xb4 03 16 0d 12 ADD32: s13 = int32(s3 + s22) */
    S[13] = (int32_t)((uint32_t)S[3] + (uint32_t)S[22]);

L_0276:
    /* +0x03b10 op=0x52 1e 03 0c 00 LD32S: s3 = *(int32_t *)(s30 +0xc) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0xc);

L_0277:
    /* +0x03b28 op=0xb4 03 16 03 02 ADD32: s3 = int32(s3 + s22) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[22]);

L_0278:
    /* +0x03b40 op=0x08 1e 03 58 01 ST32: *(s30 +0x158) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x158) = (uint32_t)S[3];

L_0279:
    /* +0x03b58 op=0x52 1e 03 fc 01 LD32S: s3 = *(int32_t *)(s30 +0x1fc) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x1fc);

L_027a:
    /* +0x03b70 op=0xb4 03 16 03 00 ADD32: s3 = int32(s3 + s22) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[22]);

L_027b:
    /* +0x03b88 op=0x08 1e 03 7c 01 ST32: *(s30 +0x17c) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x17c) = (uint32_t)S[3];

L_027c:
    /* +0x03ba0 op=0x52 1e 03 00 02 LD32S: s3 = *(int32_t *)(s30 +0x200) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x200);

L_027d:
    /* +0x03bb8 op=0xb4 03 16 03 00 ADD32: s3 = int32(s3 + s22) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[22]);

L_027e:
    /* +0x03bd0 op=0xb4 09 13 16 12 ADD32: s22 = int32(s9 + s19) */
    S[22] = (int32_t)((uint32_t)S[9] + (uint32_t)S[19]);

L_027f:
    /* +0x03be8 op=0x52 1e 09 10 00 LD32S: s9 = *(int32_t *)(s30 +0x10) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x10);

L_0280:
    /* +0x03c00 op=0x08 1e 03 90 01 ST32: *(s30 +0x190) = (uint32_t)s3 */
    *(uint32_t *)((uint8_t *)S[30] + 0x190) = (uint32_t)S[3];

L_0281:
    /* +0x03c18 op=0x52 1e 03 88 00 LD32S: s3 = *(int32_t *)(s30 +0x88) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x88);

L_0282:
    /* +0x03c30 op=0xb4 09 13 09 00 ADD32: s9 = int32(s9 + s19) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[19]);

L_0283:
    /* +0x03c48 op=0x08 1e 09 50 01 ST32: *(s30 +0x150) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x150) = (uint32_t)S[9];

L_0284:
    /* +0x03c60 op=0x52 1e 09 08 02 LD32S: s9 = *(int32_t *)(s30 +0x208) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x208);

L_0285:
    /* +0x03c78 op=0xb4 03 13 03 12 ADD32: s3 = int32(s3 + s19) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[19]);

L_0286:
    /* +0x03c90 op=0xb4 09 13 09 00 ADD32: s9 = int32(s9 + s19) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[19]);

L_0287:
    /* +0x03ca8 op=0x52 1e 13 38 00 LD32S: s19 = *(int32_t *)(s30 +0x38) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x38);

L_0288:
    /* +0x03cc0 op=0x08 1e 09 a0 01 ST32: *(s30 +0x1a0) = (uint32_t)s9 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a0) = (uint32_t)S[9];

L_0289:
    /* +0x03cd8 op=0x52 1e 09 ac 00 LD32S: s9 = *(int32_t *)(s30 +0xac) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0xac);

L_028a:
    /* +0x03cf0 op=0xb4 13 01 13 12 ADD32: s19 = int32(s19 + s1) */
    S[19] = (int32_t)((uint32_t)S[19] + (uint32_t)S[1]);

L_028b:
    /* +0x03d08 op=0x08 1e 13 40 01 ST32: *(s30 +0x140) = (uint32_t)s19 */
    *(uint32_t *)((uint8_t *)S[30] + 0x140) = (uint32_t)S[19];

L_028c:
    /* +0x03d20 op=0x52 1e 13 14 00 LD32S: s19 = *(int32_t *)(s30 +0x14) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x14);

L_028d:
    /* +0x03d38 op=0xb4 09 01 09 02 ADD32: s9 = int32(s9 + s1) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[1]);

L_028e:
    /* +0x03d50 op=0xb4 13 01 13 12 ADD32: s19 = int32(s19 + s1) */
    S[19] = (int32_t)((uint32_t)S[19] + (uint32_t)S[1]);

L_028f:
    /* +0x03d68 op=0x08 1e 13 5c 01 ST32: *(s30 +0x15c) = (uint32_t)s19 */
    *(uint32_t *)((uint8_t *)S[30] + 0x15c) = (uint32_t)S[19];

L_0290:
    /* +0x03d80 op=0x52 1e 13 10 02 LD32S: s19 = *(int32_t *)(s30 +0x210) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x210);

L_0291:
    /* +0x03d98 op=0xb4 13 01 01 12 ADD32: s1 = int32(s19 + s1) */
    S[1] = (int32_t)((uint32_t)S[19] + (uint32_t)S[1]);

L_0292:
    /* +0x03db0 op=0x52 1e 13 34 00 LD32S: s19 = *(int32_t *)(s30 +0x34) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x34);

L_0293:
    /* +0x03dc8 op=0x08 1e 01 a4 01 ST32: *(s30 +0x1a4) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a4) = (uint32_t)S[1];

L_0294:
    /* +0x03de0 op=0x52 1e 01 a4 00 LD32S: s1 = *(int32_t *)(s30 +0xa4) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0xa4);

L_0295:
    /* +0x03df8 op=0xb4 13 02 15 12 ADD32: s21 = int32(s19 + s2) */
    S[21] = (int32_t)((uint32_t)S[19] + (uint32_t)S[2]);

L_0296:
    /* +0x03e10 op=0x52 1e 13 18 00 LD32S: s19 = *(int32_t *)(s30 +0x18) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x18);

L_0297:
    /* +0x03e28 op=0xb4 01 02 01 02 ADD32: s1 = int32(s1 + s2) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[2]);

L_0298:
    /* +0x03e40 op=0xb4 13 02 13 00 ADD32: s19 = int32(s19 + s2) */
    S[19] = (int32_t)((uint32_t)S[19] + (uint32_t)S[2]);

L_0299:
    /* +0x03e58 op=0x08 1e 13 60 01 ST32: *(s30 +0x160) = (uint32_t)s19 */
    *(uint32_t *)((uint8_t *)S[30] + 0x160) = (uint32_t)S[19];

L_029a:
    /* +0x03e70 op=0x52 1e 13 18 02 LD32S: s19 = *(int32_t *)(s30 +0x218) */
    S[19] = *(int32_t *)((uint8_t *)S[30] + 0x218);

L_029b:
    /* +0x03e88 op=0xb4 13 02 02 00 ADD32: s2 = int32(s19 + s2) */
    S[2] = (int32_t)((uint32_t)S[19] + (uint32_t)S[2]);

L_029c:
    /* +0x03ea0 op=0x08 1e 02 a8 01 ST32: *(s30 +0x1a8) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1a8) = (uint32_t)S[2];

L_029d:
    /* +0x03eb8 op=0x52 1e 02 cc 00 LD32S: s2 = *(int32_t *)(s30 +0xcc) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0xcc);

L_029e:
    /* +0x03ed0 op=0xb4 02 04 13 00 ADD32: s19 = int32(s2 + s4) */
    S[19] = (int32_t)((uint32_t)S[2] + (uint32_t)S[4]);

L_029f:
    /* +0x03ee8 op=0x52 1e 02 3c 00 LD32S: s2 = *(int32_t *)(s30 +0x3c) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x3c);

L_02a0:
    /* +0x03f00 op=0xb4 02 04 02 00 ADD32: s2 = int32(s2 + s4) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[4]);

L_02a1:
    /* +0x03f18 op=0xb4 1f 04 04 02 ADD32: s4 = int32(s31 + s4) */
    S[4] = (int32_t)((uint32_t)S[31] + (uint32_t)S[4]);

L_02a2:
    /* +0x03f30 op=0x34 14 00 1f 01 OR64: s31 = s20 | s0 */
    S[31] = S[20] | S[0];

L_02a3:
    /* +0x03f48 op=0x08 1e 04 b4 01 ST32: *(s30 +0x1b4) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x1b4) = (uint32_t)S[4];

L_02a4:
    /* +0x03f60 op=0x2e 01 06 04 19 ROR32_IMM: s4 = ror32((uint32_t)s6, 25) */
    S[4] = ror32((uint32_t)S[6], 25);

L_02a5:
    /* +0x03f78 op=0x02 19 05 06 01 XOR64: s6 = s5 ^ s25 */
    S[6] = S[5] ^ S[25];

L_02a6:
    /* +0x03f90 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_02a7:
    /* +0x03fa8 op=0xb3 04 06 06 01 AND64: s6 = s4 & s6 */
    S[6] = S[4] & S[6];

L_02a8:
    /* +0x03fc0 op=0xb4 01 04 01 00 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_02a9:
    /* +0x03fd8 op=0x02 06 19 06 00 XOR64: s6 = s25 ^ s6 */
    S[6] = S[25] ^ S[6];

L_02aa:
    /* +0x03ff0 op=0xb4 11 06 05 00 ADD32: s5 = int32(s17 + s6) */
    S[5] = (int32_t)((uint32_t)S[17] + (uint32_t)S[6]);

L_02ab:
    /* +0x04008 op=0x02 04 14 06 00 XOR64: s6 = s20 ^ s4 */
    S[6] = S[20] ^ S[4];

L_02ac:
    /* +0x04020 op=0x2e 12 05 05 14 ROR32_IMM: s5 = ror32((uint32_t)s5, 20) */
    S[5] = ror32((uint32_t)S[5], 20);

L_02ad:
    /* +0x04038 op=0xb4 05 04 05 00 ADD32: s5 = int32(s5 + s4) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[4]);

L_02ae:
    /* +0x04050 op=0xb3 05 06 06 00 AND64: s6 = s5 & s6 */
    S[6] = S[5] & S[6];

L_02af:
    /* +0x04068 op=0x02 06 14 06 01 XOR64: s6 = s20 ^ s6 */
    S[6] = S[20] ^ S[6];

L_02b0:
    /* +0x04080 op=0xb4 17 06 06 00 ADD32: s6 = int32(s23 + s6) */
    S[6] = (int32_t)((uint32_t)S[23] + (uint32_t)S[6]);

L_02b1:
    /* +0x04098 op=0x02 05 04 17 01 XOR64: s23 = s4 ^ s5 */
    S[23] = S[4] ^ S[5];

L_02b2:
    /* +0x040b0 op=0x2e 01 06 06 0f ROR32_IMM: s6 = ror32((uint32_t)s6, 15) */
    S[6] = ror32((uint32_t)S[6], 15);

L_02b3:
    /* +0x040c8 op=0xb4 06 05 06 02 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_02b4:
    /* +0x040e0 op=0xb3 06 17 17 01 AND64: s23 = s6 & s23 */
    S[23] = S[6] & S[23];

L_02b5:
    /* +0x040f8 op=0x02 17 04 04 01 XOR64: s4 = s4 ^ s23 */
    S[4] = S[4] ^ S[23];

L_02b6:
    /* +0x04110 op=0x02 06 05 17 00 XOR64: s23 = s5 ^ s6 */
    S[23] = S[5] ^ S[6];

L_02b7:
    /* +0x04128 op=0xb4 07 04 04 12 ADD32: s4 = int32(s7 + s4) */
    S[4] = (int32_t)((uint32_t)S[7] + (uint32_t)S[4]);

L_02b8:
    /* +0x04140 op=0x52 1e 07 0c 01 LD32S: s7 = *(int32_t *)(s30 +0x10c) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x10c);

L_02b9:
    /* +0x04158 op=0x2e 12 04 04 0a ROR32_IMM: s4 = ror32((uint32_t)s4, 10) */
    S[4] = ror32((uint32_t)S[4], 10);

L_02ba:
    /* +0x04170 op=0xb4 04 06 04 12 ADD32: s4 = int32(s4 + s6) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_02bb:
    /* +0x04188 op=0xb4 07 08 07 12 ADD32: s7 = int32(s7 + s8) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[8]);

L_02bc:
    /* +0x041a0 op=0xb3 04 17 17 01 AND64: s23 = s4 & s23 */
    S[23] = S[4] & S[23];

L_02bd:
    /* +0x041b8 op=0xb4 07 05 07 02 ADD32: s7 = int32(s7 + s5) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[5]);

L_02be:
    /* +0x041d0 op=0xb4 03 04 03 02 ADD32: s3 = int32(s3 + s4) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[4]);

L_02bf:
    /* +0x041e8 op=0x02 17 05 05 01 XOR64: s5 = s5 ^ s23 */
    S[5] = S[5] ^ S[23];

L_02c0:
    /* +0x04200 op=0xb4 01 05 01 00 ADD32: s1 = int32(s1 + s5) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[5]);

L_02c1:
    /* +0x04218 op=0xb4 0f 06 05 12 ADD32: s5 = int32(s15 + s6) */
    S[5] = (int32_t)((uint32_t)S[15] + (uint32_t)S[6]);

L_02c2:
    /* +0x04230 op=0x02 04 06 0f 01 XOR64: s15 = s6 ^ s4 */
    S[15] = S[6] ^ S[4];

L_02c3:
    /* +0x04248 op=0x2e 12 01 01 19 ROR32_IMM: s1 = ror32((uint32_t)s1, 25) */
    S[1] = ror32((uint32_t)S[1], 25);

L_02c4:
    /* +0x04260 op=0xb4 01 04 01 00 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_02c5:
    /* +0x04278 op=0xb3 01 0f 0f 01 AND64: s15 = s1 & s15 */
    S[15] = S[1] & S[15];

L_02c6:
    /* +0x04290 op=0x02 0f 06 06 00 XOR64: s6 = s6 ^ s15 */
    S[6] = S[6] ^ S[15];

L_02c7:
    /* +0x042a8 op=0x52 1e 0f 48 01 LD32S: s15 = *(int32_t *)(s30 +0x148) */
    S[15] = *(int32_t *)((uint8_t *)S[30] + 0x148);

L_02c8:
    /* +0x042c0 op=0xb4 07 06 06 12 ADD32: s6 = int32(s7 + s6) */
    S[6] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_02c9:
    /* +0x042d8 op=0x02 01 04 07 01 XOR64: s7 = s4 ^ s1 */
    S[7] = S[4] ^ S[1];

L_02ca:
    /* +0x042f0 op=0x2e 12 06 06 14 ROR32_IMM: s6 = ror32((uint32_t)s6, 20) */
    S[6] = ror32((uint32_t)S[6], 20);

L_02cb:
    /* +0x04308 op=0xb4 06 01 06 00 ADD32: s6 = int32(s6 + s1) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[1]);

L_02cc:
    /* +0x04320 op=0xb3 06 07 07 01 AND64: s7 = s6 & s7 */
    S[7] = S[6] & S[7];

L_02cd:
    /* +0x04338 op=0x02 07 04 04 01 XOR64: s4 = s4 ^ s7 */
    S[4] = S[4] ^ S[7];

L_02ce:
    /* +0x04350 op=0x02 06 01 07 00 XOR64: s7 = s1 ^ s6 */
    S[7] = S[1] ^ S[6];

L_02cf:
    /* +0x04368 op=0xb4 05 04 04 00 ADD32: s4 = int32(s5 + s4) */
    S[4] = (int32_t)((uint32_t)S[5] + (uint32_t)S[4]);

L_02d0:
    /* +0x04380 op=0x52 1e 05 4c 01 LD32S: s5 = *(int32_t *)(s30 +0x14c) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x14c);

L_02d1:
    /* +0x04398 op=0x2e 10 04 04 0f ROR32_IMM: s4 = ror32((uint32_t)s4, 15) */
    S[4] = ror32((uint32_t)S[4], 15);

L_02d2:
    /* +0x043b0 op=0xb4 04 06 04 12 ADD32: s4 = int32(s4 + s6) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_02d3:
    /* +0x043c8 op=0xb4 05 0b 05 02 ADD32: s5 = int32(s5 + s11) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[11]);

L_02d4:
    /* +0x043e0 op=0xb3 04 07 07 01 AND64: s7 = s4 & s7 */
    S[7] = S[4] & S[7];

L_02d5:
    /* +0x043f8 op=0xb4 05 01 05 02 ADD32: s5 = int32(s5 + s1) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_02d6:
    /* +0x04410 op=0x02 07 01 01 00 XOR64: s1 = s1 ^ s7 */
    S[1] = S[1] ^ S[7];

L_02d7:
    /* +0x04428 op=0x02 04 06 07 01 XOR64: s7 = s6 ^ s4 */
    S[7] = S[6] ^ S[4];

L_02d8:
    /* +0x04440 op=0xb4 03 01 01 02 ADD32: s1 = int32(s3 + s1) */
    S[1] = (int32_t)((uint32_t)S[3] + (uint32_t)S[1]);

L_02d9:
    /* +0x04458 op=0x52 1e 03 64 01 LD32S: s3 = *(int32_t *)(s30 +0x164) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x164);

L_02da:
    /* +0x04470 op=0x2e 10 01 01 0a ROR32_IMM: s1 = ror32((uint32_t)s1, 10) */
    S[1] = ror32((uint32_t)S[1], 10);

L_02db:
    /* +0x04488 op=0xb4 01 04 01 12 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_02dc:
    /* +0x044a0 op=0xb4 03 0c 03 02 ADD32: s3 = int32(s3 + s12) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[12]);

L_02dd:
    /* +0x044b8 op=0xb3 01 07 07 01 AND64: s7 = s1 & s7 */
    S[7] = S[1] & S[7];

L_02de:
    /* +0x044d0 op=0xb4 03 06 03 02 ADD32: s3 = int32(s3 + s6) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[6]);

L_02df:
    /* +0x044e8 op=0x02 07 06 06 01 XOR64: s6 = s6 ^ s7 */
    S[6] = S[6] ^ S[7];

L_02e0:
    /* +0x04500 op=0x02 01 04 07 01 XOR64: s7 = s4 ^ s1 */
    S[7] = S[4] ^ S[1];

L_02e1:
    /* +0x04518 op=0xb4 05 06 05 00 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_02e2:
    /* +0x04530 op=0x52 1e 06 78 01 LD32S: s6 = *(int32_t *)(s30 +0x178) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x178);

L_02e3:
    /* +0x04548 op=0x2e 01 05 05 19 ROR32_IMM: s5 = ror32((uint32_t)s5, 25) */
    S[5] = ror32((uint32_t)S[5], 25);

L_02e4:
    /* +0x04560 op=0xb4 05 01 05 02 ADD32: s5 = int32(s5 + s1) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_02e5:
    /* +0x04578 op=0xb4 06 0e 06 00 ADD32: s6 = int32(s6 + s14) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[14]);

L_02e6:
    /* +0x04590 op=0xb3 05 07 07 00 AND64: s7 = s5 & s7 */
    S[7] = S[5] & S[7];

L_02e7:
    /* +0x045a8 op=0xb4 06 04 06 02 ADD32: s6 = int32(s6 + s4) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[4]);

L_02e8:
    /* +0x045c0 op=0x02 07 04 04 00 XOR64: s4 = s4 ^ s7 */
    S[4] = S[4] ^ S[7];

L_02e9:
    /* +0x045d8 op=0x02 05 01 07 00 XOR64: s7 = s1 ^ s5 */
    S[7] = S[1] ^ S[5];

L_02ea:
    /* +0x045f0 op=0xb4 03 04 03 02 ADD32: s3 = int32(s3 + s4) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[4]);

L_02eb:
    /* +0x04608 op=0xb4 09 01 04 02 ADD32: s4 = int32(s9 + s1) */
    S[4] = (int32_t)((uint32_t)S[9] + (uint32_t)S[1]);

L_02ec:
    /* +0x04620 op=0x2e 10 03 03 14 ROR32_IMM: s3 = ror32((uint32_t)s3, 20) */
    S[3] = ror32((uint32_t)S[3], 20);

L_02ed:
    /* +0x04638 op=0xb4 03 05 03 00 ADD32: s3 = int32(s3 + s5) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_02ee:
    /* +0x04650 op=0xb3 03 07 07 01 AND64: s7 = s3 & s7 */
    S[7] = S[3] & S[7];

L_02ef:
    /* +0x04668 op=0x02 07 01 01 01 XOR64: s1 = s1 ^ s7 */
    S[1] = S[1] ^ S[7];

L_02f0:
    /* +0x04680 op=0x02 03 05 07 00 XOR64: s7 = s5 ^ s3 */
    S[7] = S[5] ^ S[3];

L_02f1:
    /* +0x04698 op=0xb4 06 01 01 00 ADD32: s1 = int32(s6 + s1) */
    S[1] = (int32_t)((uint32_t)S[6] + (uint32_t)S[1]);

L_02f2:
    /* +0x046b0 op=0xb4 13 05 06 02 ADD32: s6 = int32(s19 + s5) */
    S[6] = (int32_t)((uint32_t)S[19] + (uint32_t)S[5]);

L_02f3:
    /* +0x046c8 op=0x2e 01 01 01 0f ROR32_IMM: s1 = ror32((uint32_t)s1, 15) */
    S[1] = ror32((uint32_t)S[1], 15);

L_02f4:
    /* +0x046e0 op=0xb4 01 03 01 02 ADD32: s1 = int32(s1 + s3) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[3]);

L_02f5:
    /* +0x046f8 op=0xb3 01 07 07 01 AND64: s7 = s1 & s7 */
    S[7] = S[1] & S[7];

L_02f6:
    /* +0x04710 op=0x02 07 05 05 01 XOR64: s5 = s5 ^ s7 */
    S[5] = S[5] ^ S[7];

L_02f7:
    /* +0x04728 op=0x02 01 03 07 01 XOR64: s7 = s3 ^ s1 */
    S[7] = S[3] ^ S[1];

L_02f8:
    /* +0x04740 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_02f9:
    /* +0x04758 op=0xb4 0a 03 05 02 ADD32: s5 = int32(s10 + s3) */
    S[5] = (int32_t)((uint32_t)S[10] + (uint32_t)S[3]);

L_02fa:
    /* +0x04770 op=0x52 1e 0a 20 01 LD32S: s10 = *(int32_t *)(s30 +0x120) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x120);

L_02fb:
    /* +0x04788 op=0x2e 01 04 04 0a ROR32_IMM: s4 = ror32((uint32_t)s4, 10) */
    S[4] = ror32((uint32_t)S[4], 10);

L_02fc:
    /* +0x047a0 op=0xb4 04 01 04 02 ADD32: s4 = int32(s4 + s1) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[1]);

L_02fd:
    /* +0x047b8 op=0xb3 04 07 07 01 AND64: s7 = s4 & s7 */
    S[7] = S[4] & S[7];

L_02fe:
    /* +0x047d0 op=0x02 07 03 03 01 XOR64: s3 = s3 ^ s7 */
    S[3] = S[3] ^ S[7];

L_02ff:
    /* +0x047e8 op=0x02 04 01 07 01 XOR64: s7 = s1 ^ s4 */
    S[7] = S[1] ^ S[4];

L_0300:
    /* +0x04800 op=0xb4 06 03 03 12 ADD32: s3 = int32(s6 + s3) */
    S[3] = (int32_t)((uint32_t)S[6] + (uint32_t)S[3]);

L_0301:
    /* +0x04818 op=0x52 1e 06 ac 01 LD32S: s6 = *(int32_t *)(s30 +0x1ac) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x1ac);

L_0302:
    /* +0x04830 op=0x2e 01 03 03 19 ROR32_IMM: s3 = ror32((uint32_t)s3, 25) */
    S[3] = ror32((uint32_t)S[3], 25);

L_0303:
    /* +0x04848 op=0xb4 03 04 03 12 ADD32: s3 = int32(s3 + s4) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[4]);

L_0304:
    /* +0x04860 op=0xb4 06 10 06 00 ADD32: s6 = int32(s6 + s16) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[16]);

L_0305:
    /* +0x04878 op=0xb3 03 07 07 00 AND64: s7 = s3 & s7 */
    S[7] = S[3] & S[7];

L_0306:
    /* +0x04890 op=0xb4 06 01 06 02 ADD32: s6 = int32(s6 + s1) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[1]);

L_0307:
    /* +0x048a8 op=0x02 07 01 01 01 XOR64: s1 = s1 ^ s7 */
    S[1] = S[1] ^ S[7];

L_0308:
    /* +0x048c0 op=0xb4 05 01 01 02 ADD32: s1 = int32(s5 + s1) */
    S[1] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0309:
    /* +0x048d8 op=0x52 1e 05 b8 01 LD32S: s5 = *(int32_t *)(s30 +0x1b8) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x1b8);

L_030a:
    /* +0x048f0 op=0x2e 01 01 01 14 ROR32_IMM: s1 = ror32((uint32_t)s1, 20) */
    S[1] = ror32((uint32_t)S[1], 20);

L_030b:
    /* +0x04908 op=0xb4 01 03 07 12 ADD32: s7 = int32(s1 + s3) */
    S[7] = (int32_t)((uint32_t)S[1] + (uint32_t)S[3]);

L_030c:
    /* +0x04920 op=0x02 03 04 01 01 XOR64: s1 = s4 ^ s3 */
    S[1] = S[4] ^ S[3];

L_030d:
    /* +0x04938 op=0xb4 05 18 05 12 ADD32: s5 = int32(s5 + s24) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[24]);

L_030e:
    /* +0x04950 op=0xb3 07 01 01 01 AND64: s1 = s7 & s1 */
    S[1] = S[7] & S[1];

L_030f:
    /* +0x04968 op=0xb4 05 04 05 02 ADD32: s5 = int32(s5 + s4) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[4]);

L_0310:
    /* +0x04980 op=0x02 01 04 01 01 XOR64: s1 = s4 ^ s1 */
    S[1] = S[4] ^ S[1];

L_0311:
    /* +0x04998 op=0x52 1e 04 40 00 LD32S: s4 = *(int32_t *)(s30 +0x40) */
    S[4] = *(int32_t *)((uint8_t *)S[30] + 0x40);

L_0312:
    /* +0x049b0 op=0xb4 06 01 01 12 ADD32: s1 = int32(s6 + s1) */
    S[1] = (int32_t)((uint32_t)S[6] + (uint32_t)S[1]);

L_0313:
    /* +0x049c8 op=0x52 1e 06 14 01 LD32S: s6 = *(int32_t *)(s30 +0x114) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x114);

L_0314:
    /* +0x049e0 op=0x2e 10 01 01 0f ROR32_IMM: s1 = ror32((uint32_t)s1, 15) */
    S[1] = ror32((uint32_t)S[1], 15);

L_0315:
    /* +0x049f8 op=0xb4 01 07 09 00 ADD32: s9 = int32(s1 + s7) */
    S[9] = (int32_t)((uint32_t)S[1] + (uint32_t)S[7]);

L_0316:
    /* +0x04a10 op=0x02 07 03 01 01 XOR64: s1 = s3 ^ s7 */
    S[1] = S[3] ^ S[7];

L_0317:
    /* +0x04a28 op=0xb4 04 06 04 02 ADD32: s4 = int32(s4 + s6) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_0318:
    /* +0x04a40 op=0xb4 03 06 06 02 ADD32: s6 = int32(s3 + s6) */
    S[6] = (int32_t)((uint32_t)S[3] + (uint32_t)S[6]);

L_0319:
    /* +0x04a58 op=0xb3 09 01 01 01 AND64: s1 = s9 & s1 */
    S[1] = S[9] & S[1];

L_031a:
    /* +0x04a70 op=0x02 01 03 01 01 XOR64: s1 = s3 ^ s1 */
    S[1] = S[3] ^ S[1];

L_031b:
    /* +0x04a88 op=0xb4 05 01 03 12 ADD32: s3 = int32(s5 + s1) */
    S[3] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_031c:
    /* +0x04aa0 op=0x52 1e 01 48 00 LD32S: s1 = *(int32_t *)(s30 +0x48) */
    S[1] = *(int32_t *)((uint8_t *)S[30] + 0x48);

L_031d:
    /* +0x04ab8 op=0x52 1e 05 f8 01 LD32S: s5 = *(int32_t *)(s30 +0x1f8) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x1f8);

L_031e:
    /* +0x04ad0 op=0x2e 12 03 03 0a ROR32_IMM: s3 = ror32((uint32_t)s3, 10) */
    S[3] = ror32((uint32_t)S[3], 10);

L_031f:
    /* +0x04ae8 op=0xb4 05 08 14 12 ADD32: s20 = int32(s5 + s8) */
    S[20] = (int32_t)((uint32_t)S[5] + (uint32_t)S[8]);

L_0320:
    /* +0x04b00 op=0xb4 01 08 01 02 ADD32: s1 = int32(s1 + s8) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[8]);

L_0321:
    /* +0x04b18 op=0xb4 09 08 05 00 ADD32: s5 = int32(s9 + s8) */
    S[5] = (int32_t)((uint32_t)S[9] + (uint32_t)S[8]);

L_0322:
    /* +0x04b30 op=0x52 1e 08 18 01 LD32S: s8 = *(int32_t *)(s30 +0x118) */
    S[8] = *(int32_t *)((uint8_t *)S[30] + 0x118);

L_0323:
    /* +0x04b48 op=0xb4 03 09 03 12 ADD32: s3 = int32(s3 + s9) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[9]);

L_0324:
    /* +0x04b60 op=0xb4 05 08 05 02 ADD32: s5 = int32(s5 + s8) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[8]);

L_0325:
    /* +0x04b78 op=0xb4 07 0e 08 02 ADD32: s8 = int32(s7 + s14) */
    S[8] = (int32_t)((uint32_t)S[7] + (uint32_t)S[14]);

L_0326:
    /* +0x04b90 op=0xb4 08 0a 0a 12 ADD32: s10 = int32(s8 + s10) */
    S[10] = (int32_t)((uint32_t)S[8] + (uint32_t)S[10]);

L_0327:
    /* +0x04ba8 op=0x02 03 09 08 01 XOR64: s8 = s9 ^ s3 */
    S[8] = S[9] ^ S[3];

L_0328:
    /* +0x04bc0 op=0xb3 08 07 07 01 AND64: s7 = s8 & s7 */
    S[7] = S[8] & S[7];

L_0329:
    /* +0x04bd8 op=0x02 07 09 07 01 XOR64: s7 = s9 ^ s7 */
    S[7] = S[9] ^ S[7];

L_032a:
    /* +0x04bf0 op=0xb4 06 07 06 00 ADD32: s6 = int32(s6 + s7) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[7]);

L_032b:
    /* +0x04c08 op=0x52 1e 07 30 01 LD32S: s7 = *(int32_t *)(s30 +0x130) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x130);

L_032c:
    /* +0x04c20 op=0xb4 06 07 06 12 ADD32: s6 = int32(s6 + s7) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[7]);

L_032d:
    /* +0x04c38 op=0x52 1e 07 54 00 LD32S: s7 = *(int32_t *)(s30 +0x54) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x54);

L_032e:
    /* +0x04c50 op=0x2e 10 06 06 1b ROR32_IMM: s6 = ror32((uint32_t)s6, 27) */
    S[6] = ror32((uint32_t)S[6], 27);

L_032f:
    /* +0x04c68 op=0xb4 07 10 13 00 ADD32: s19 = int32(s7 + s16) */
    S[19] = (int32_t)((uint32_t)S[7] + (uint32_t)S[16]);

L_0330:
    /* +0x04c80 op=0x52 1e 07 14 02 LD32S: s7 = *(int32_t *)(s30 +0x214) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x214);

L_0331:
    /* +0x04c98 op=0xb4 06 03 06 12 ADD32: s6 = int32(s6 + s3) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[3]);

L_0332:
    /* +0x04cb0 op=0xb4 07 10 08 00 ADD32: s8 = int32(s7 + s16) */
    S[8] = (int32_t)((uint32_t)S[7] + (uint32_t)S[16]);

L_0333:
    /* +0x04cc8 op=0xb4 03 10 07 12 ADD32: s7 = int32(s3 + s16) */
    S[7] = (int32_t)((uint32_t)S[3] + (uint32_t)S[16]);

L_0334:
    /* +0x04ce0 op=0x52 1e 10 94 01 LD32S: s16 = *(int32_t *)(s30 +0x194) */
    S[16] = *(int32_t *)((uint8_t *)S[30] + 0x194);

L_0335:
    /* +0x04cf8 op=0xb4 07 0f 07 02 ADD32: s7 = int32(s7 + s15) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[15]);

L_0336:
    /* +0x04d10 op=0x02 06 03 0f 00 XOR64: s15 = s3 ^ s6 */
    S[15] = S[3] ^ S[6];

L_0337:
    /* +0x04d28 op=0xb3 0f 09 09 01 AND64: s9 = s15 & s9 */
    S[9] = S[15] & S[9];

L_0338:
    /* +0x04d40 op=0x02 09 03 09 01 XOR64: s9 = s3 ^ s9 */
    S[9] = S[3] ^ S[9];

L_0339:
    /* +0x04d58 op=0xb4 0a 09 09 02 ADD32: s9 = int32(s10 + s9) */
    S[9] = (int32_t)((uint32_t)S[10] + (uint32_t)S[9]);

L_033a:
    /* +0x04d70 op=0x2e 12 09 09 17 ROR32_IMM: s9 = ror32((uint32_t)s9, 23) */
    S[9] = ror32((uint32_t)S[9], 23);

L_033b:
    /* +0x04d88 op=0xb4 09 06 09 02 ADD32: s9 = int32(s9 + s6) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[6]);

L_033c:
    /* +0x04da0 op=0x02 09 06 0a 00 XOR64: s10 = s6 ^ s9 */
    S[10] = S[6] ^ S[9];

L_033d:
    /* +0x04db8 op=0xb3 0a 03 03 01 AND64: s3 = s10 & s3 */
    S[3] = S[10] & S[3];

L_033e:
    /* +0x04dd0 op=0x02 03 06 03 00 XOR64: s3 = s6 ^ s3 */
    S[3] = S[6] ^ S[3];

L_033f:
    /* +0x04de8 op=0xb4 05 03 03 12 ADD32: s3 = int32(s5 + s3) */
    S[3] = (int32_t)((uint32_t)S[5] + (uint32_t)S[3]);

L_0340:
    /* +0x04e00 op=0x52 1e 05 70 01 LD32S: s5 = *(int32_t *)(s30 +0x170) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x170);

L_0341:
    /* +0x04e18 op=0x2e 12 03 03 12 ROR32_IMM: s3 = ror32((uint32_t)s3, 18) */
    S[3] = ror32((uint32_t)S[3], 18);

L_0342:
    /* +0x04e30 op=0xb4 03 09 03 02 ADD32: s3 = int32(s3 + s9) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[9]);

L_0343:
    /* +0x04e48 op=0xb4 05 12 05 00 ADD32: s5 = int32(s5 + s18) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[18]);

L_0344:
    /* +0x04e60 op=0x02 03 09 0a 00 XOR64: s10 = s9 ^ s3 */
    S[10] = S[9] ^ S[3];

L_0345:
    /* +0x04e78 op=0xb4 05 06 05 02 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_0346:
    /* +0x04e90 op=0xb3 0a 06 06 01 AND64: s6 = s10 & s6 */
    S[6] = S[10] & S[6];

L_0347:
    /* +0x04ea8 op=0x02 06 09 06 01 XOR64: s6 = s9 ^ s6 */
    S[6] = S[9] ^ S[6];

L_0348:
    /* +0x04ec0 op=0xb4 07 06 06 12 ADD32: s6 = int32(s7 + s6) */
    S[6] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_0349:
    /* +0x04ed8 op=0xb4 15 09 07 02 ADD32: s7 = int32(s21 + s9) */
    S[7] = (int32_t)((uint32_t)S[21] + (uint32_t)S[9]);

L_034a:
    /* +0x04ef0 op=0x2e 01 06 06 0c ROR32_IMM: s6 = ror32((uint32_t)s6, 12) */
    S[6] = ror32((uint32_t)S[6], 12);

L_034b:
    /* +0x04f08 op=0xb4 06 03 06 02 ADD32: s6 = int32(s6 + s3) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[3]);

L_034c:
    /* +0x04f20 op=0x02 06 03 0a 00 XOR64: s10 = s3 ^ s6 */
    S[10] = S[3] ^ S[6];

L_034d:
    /* +0x04f38 op=0xb3 0a 09 09 00 AND64: s9 = s10 & s9 */
    S[9] = S[10] & S[9];

L_034e:
    /* +0x04f50 op=0x02 09 03 09 01 XOR64: s9 = s3 ^ s9 */
    S[9] = S[3] ^ S[9];

L_034f:
    /* +0x04f68 op=0xb4 05 09 05 12 ADD32: s5 = int32(s5 + s9) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[9]);

L_0350:
    /* +0x04f80 op=0x52 1e 09 84 01 LD32S: s9 = *(int32_t *)(s30 +0x184) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x184);

L_0351:
    /* +0x04f98 op=0x2e 12 05 05 1b ROR32_IMM: s5 = ror32((uint32_t)s5, 27) */
    S[5] = ror32((uint32_t)S[5], 27);

L_0352:
    /* +0x04fb0 op=0xb4 05 06 05 02 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_0353:
    /* +0x04fc8 op=0xb4 09 18 09 12 ADD32: s9 = int32(s9 + s24) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[24]);

L_0354:
    /* +0x04fe0 op=0x02 05 06 0a 01 XOR64: s10 = s6 ^ s5 */
    S[10] = S[6] ^ S[5];

L_0355:
    /* +0x04ff8 op=0xb4 09 03 09 12 ADD32: s9 = int32(s9 + s3) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[3]);

L_0356:
    /* +0x05010 op=0xb3 0a 03 03 01 AND64: s3 = s10 & s3 */
    S[3] = S[10] & S[3];

L_0357:
    /* +0x05028 op=0x02 03 06 03 01 XOR64: s3 = s6 ^ s3 */
    S[3] = S[6] ^ S[3];

L_0358:
    /* +0x05040 op=0xb4 07 03 03 12 ADD32: s3 = int32(s7 + s3) */
    S[3] = (int32_t)((uint32_t)S[7] + (uint32_t)S[3]);

L_0359:
    /* +0x05058 op=0xb4 0d 06 07 02 ADD32: s7 = int32(s13 + s6) */
    S[7] = (int32_t)((uint32_t)S[13] + (uint32_t)S[6]);

L_035a:
    /* +0x05070 op=0x52 1e 0d 3c 01 LD32S: s13 = *(int32_t *)(s30 +0x13c) */
    S[13] = *(int32_t *)((uint8_t *)S[30] + 0x13c);

L_035b:
    /* +0x05088 op=0x2e 01 03 03 17 ROR32_IMM: s3 = ror32((uint32_t)s3, 23) */
    S[3] = ror32((uint32_t)S[3], 23);

L_035c:
    /* +0x050a0 op=0xb4 03 05 03 12 ADD32: s3 = int32(s3 + s5) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_035d:
    /* +0x050b8 op=0x02 03 05 0a 01 XOR64: s10 = s5 ^ s3 */
    S[10] = S[5] ^ S[3];

L_035e:
    /* +0x050d0 op=0xb3 0a 06 06 01 AND64: s6 = s10 & s6 */
    S[6] = S[10] & S[6];

L_035f:
    /* +0x050e8 op=0x02 06 05 06 01 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_0360:
    /* +0x05100 op=0xb4 09 06 06 02 ADD32: s6 = int32(s9 + s6) */
    S[6] = (int32_t)((uint32_t)S[9] + (uint32_t)S[6]);

L_0361:
    /* +0x05118 op=0x52 1e 09 38 01 LD32S: s9 = *(int32_t *)(s30 +0x138) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x138);

L_0362:
    /* +0x05130 op=0x2e 12 06 06 12 ROR32_IMM: s6 = ror32((uint32_t)s6, 18) */
    S[6] = ror32((uint32_t)S[6], 18);

L_0363:
    /* +0x05148 op=0xb4 06 03 06 12 ADD32: s6 = int32(s6 + s3) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[3]);

L_0364:
    /* +0x05160 op=0xb4 09 05 09 00 ADD32: s9 = int32(s9 + s5) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[5]);

L_0365:
    /* +0x05178 op=0x02 06 03 0a 01 XOR64: s10 = s3 ^ s6 */
    S[10] = S[3] ^ S[6];

L_0366:
    /* +0x05190 op=0xb4 02 06 02 12 ADD32: s2 = int32(s2 + s6) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[6]);

L_0367:
    /* +0x051a8 op=0xb3 0a 05 05 01 AND64: s5 = s10 & s5 */
    S[5] = S[10] & S[5];

L_0368:
    /* +0x051c0 op=0x02 05 03 05 01 XOR64: s5 = s3 ^ s5 */
    S[5] = S[3] ^ S[5];

L_0369:
    /* +0x051d8 op=0xb4 07 05 05 00 ADD32: s5 = int32(s7 + s5) */
    S[5] = (int32_t)((uint32_t)S[7] + (uint32_t)S[5]);

L_036a:
    /* +0x051f0 op=0x52 1e 07 b0 01 LD32S: s7 = *(int32_t *)(s30 +0x1b0) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1b0);

L_036b:
    /* +0x05208 op=0x2e 10 05 05 0c ROR32_IMM: s5 = ror32((uint32_t)s5, 12) */
    S[5] = ror32((uint32_t)S[5], 12);

L_036c:
    /* +0x05220 op=0xb4 05 06 05 00 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_036d:
    /* +0x05238 op=0xb4 07 0d 07 02 ADD32: s7 = int32(s7 + s13) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[13]);

L_036e:
    /* +0x05250 op=0x02 05 06 0a 00 XOR64: s10 = s6 ^ s5 */
    S[10] = S[6] ^ S[5];

L_036f:
    /* +0x05268 op=0xb4 07 03 07 12 ADD32: s7 = int32(s7 + s3) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[3]);

L_0370:
    /* +0x05280 op=0xb3 0a 03 03 00 AND64: s3 = s10 & s3 */
    S[3] = S[10] & S[3];

L_0371:
    /* +0x05298 op=0x02 03 06 03 01 XOR64: s3 = s6 ^ s3 */
    S[3] = S[6] ^ S[3];

L_0372:
    /* +0x052b0 op=0xb4 09 03 03 02 ADD32: s3 = int32(s9 + s3) */
    S[3] = (int32_t)((uint32_t)S[9] + (uint32_t)S[3]);

L_0373:
    /* +0x052c8 op=0x2e 01 03 03 1b ROR32_IMM: s3 = ror32((uint32_t)s3, 27) */
    S[3] = ror32((uint32_t)S[3], 27);

L_0374:
    /* +0x052e0 op=0xb4 03 05 03 12 ADD32: s3 = int32(s3 + s5) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_0375:
    /* +0x052f8 op=0x02 03 05 09 01 XOR64: s9 = s5 ^ s3 */
    S[9] = S[5] ^ S[3];

L_0376:
    /* +0x05310 op=0xb3 09 06 06 01 AND64: s6 = s9 & s6 */
    S[6] = S[9] & S[6];

L_0377:
    /* +0x05328 op=0x02 06 05 06 01 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_0378:
    /* +0x05340 op=0xb4 07 06 06 12 ADD32: s6 = int32(s7 + s6) */
    S[6] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_0379:
    /* +0x05358 op=0x52 1e 07 bc 01 LD32S: s7 = *(int32_t *)(s30 +0x1bc) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1bc);

L_037a:
    /* +0x05370 op=0x2e 10 06 06 17 ROR32_IMM: s6 = ror32((uint32_t)s6, 23) */
    S[6] = ror32((uint32_t)S[6], 23);

L_037b:
    /* +0x05388 op=0xb4 06 03 06 00 ADD32: s6 = int32(s6 + s3) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[3]);

L_037c:
    /* +0x053a0 op=0xb4 07 0b 07 12 ADD32: s7 = int32(s7 + s11) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[11]);

L_037d:
    /* +0x053b8 op=0x02 06 03 09 01 XOR64: s9 = s3 ^ s6 */
    S[9] = S[3] ^ S[6];

L_037e:
    /* +0x053d0 op=0xb4 07 05 07 02 ADD32: s7 = int32(s7 + s5) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[5]);

L_037f:
    /* +0x053e8 op=0xb3 09 05 05 01 AND64: s5 = s9 & s5 */
    S[5] = S[9] & S[5];

L_0380:
    /* +0x05400 op=0x02 05 03 05 00 XOR64: s5 = s3 ^ s5 */
    S[5] = S[3] ^ S[5];

L_0381:
    /* +0x05418 op=0xb4 02 05 02 12 ADD32: s2 = int32(s2 + s5) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[5]);

L_0382:
    /* +0x05430 op=0x52 1e 05 c4 01 LD32S: s5 = *(int32_t *)(s30 +0x1c4) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x1c4);

L_0383:
    /* +0x05448 op=0x2e 10 02 02 12 ROR32_IMM: s2 = ror32((uint32_t)s2, 18) */
    S[2] = ror32((uint32_t)S[2], 18);

L_0384:
    /* +0x05460 op=0xb4 02 06 02 02 ADD32: s2 = int32(s2 + s6) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[6]);

L_0385:
    /* +0x05478 op=0xb4 05 0c 05 12 ADD32: s5 = int32(s5 + s12) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[12]);

L_0386:
    /* +0x05490 op=0x02 02 06 09 01 XOR64: s9 = s6 ^ s2 */
    S[9] = S[6] ^ S[2];

L_0387:
    /* +0x054a8 op=0xb4 05 03 05 12 ADD32: s5 = int32(s5 + s3) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[3]);

L_0388:
    /* +0x054c0 op=0xb3 09 03 03 00 AND64: s3 = s9 & s3 */
    S[3] = S[9] & S[3];

L_0389:
    /* +0x054d8 op=0x02 03 06 03 00 XOR64: s3 = s6 ^ s3 */
    S[3] = S[6] ^ S[3];

L_038a:
    /* +0x054f0 op=0xb4 07 03 03 00 ADD32: s3 = int32(s7 + s3) */
    S[3] = (int32_t)((uint32_t)S[7] + (uint32_t)S[3]);

L_038b:
    /* +0x05508 op=0xb4 16 06 07 00 ADD32: s7 = int32(s22 + s6) */
    S[7] = (int32_t)((uint32_t)S[22] + (uint32_t)S[6]);

L_038c:
    /* +0x05520 op=0x2e 01 03 03 0c ROR32_IMM: s3 = ror32((uint32_t)s3, 12) */
    S[3] = ror32((uint32_t)S[3], 12);

L_038d:
    /* +0x05538 op=0xb4 03 02 03 02 ADD32: s3 = int32(s3 + s2) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[2]);

L_038e:
    /* +0x05550 op=0x02 03 02 09 00 XOR64: s9 = s2 ^ s3 */
    S[9] = S[2] ^ S[3];

L_038f:
    /* +0x05568 op=0xb3 09 06 06 01 AND64: s6 = s9 & s6 */
    S[6] = S[9] & S[6];

L_0390:
    /* +0x05580 op=0x02 06 02 06 01 XOR64: s6 = s2 ^ s6 */
    S[6] = S[2] ^ S[6];

L_0391:
    /* +0x05598 op=0xb4 05 06 05 00 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_0392:
    /* +0x055b0 op=0x52 1e 06 40 01 LD32S: s6 = *(int32_t *)(s30 +0x140) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x140);

L_0393:
    /* +0x055c8 op=0x2e 10 05 05 1b ROR32_IMM: s5 = ror32((uint32_t)s5, 27) */
    S[5] = ror32((uint32_t)S[5], 27);

L_0394:
    /* +0x055e0 op=0xb4 05 03 05 12 ADD32: s5 = int32(s5 + s3) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[3]);

L_0395:
    /* +0x055f8 op=0xb4 06 02 06 00 ADD32: s6 = int32(s6 + s2) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[2]);

L_0396:
    /* +0x05610 op=0x02 05 03 09 01 XOR64: s9 = s3 ^ s5 */
    S[9] = S[3] ^ S[5];

L_0397:
    /* +0x05628 op=0xb3 09 02 02 01 AND64: s2 = s9 & s2 */
    S[2] = S[9] & S[2];

L_0398:
    /* +0x05640 op=0x02 02 03 02 00 XOR64: s2 = s3 ^ s2 */
    S[2] = S[3] ^ S[2];

L_0399:
    /* +0x05658 op=0xb4 07 02 02 00 ADD32: s2 = int32(s7 + s2) */
    S[2] = (int32_t)((uint32_t)S[7] + (uint32_t)S[2]);

L_039a:
    /* +0x05670 op=0x52 1e 07 44 01 LD32S: s7 = *(int32_t *)(s30 +0x144) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x144);

L_039b:
    /* +0x05688 op=0x2e 10 02 02 17 ROR32_IMM: s2 = ror32((uint32_t)s2, 23) */
    S[2] = ror32((uint32_t)S[2], 23);

L_039c:
    /* +0x056a0 op=0xb4 02 05 09 02 ADD32: s9 = int32(s2 + s5) */
    S[9] = (int32_t)((uint32_t)S[2] + (uint32_t)S[5]);

L_039d:
    /* +0x056b8 op=0xb4 07 03 07 02 ADD32: s7 = int32(s7 + s3) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[3]);

L_039e:
    /* +0x056d0 op=0x02 09 05 02 01 XOR64: s2 = s5 ^ s9 */
    S[2] = S[5] ^ S[9];

L_039f:
    /* +0x056e8 op=0xb3 02 03 02 00 AND64: s2 = s2 & s3 */
    S[2] = S[2] & S[3];

L_03a0:
    /* +0x05700 op=0x52 1e 03 04 02 LD32S: s3 = *(int32_t *)(s30 +0x204) */
    S[3] = *(int32_t *)((uint8_t *)S[30] + 0x204);

L_03a1:
    /* +0x05718 op=0x02 02 05 02 00 XOR64: s2 = s5 ^ s2 */
    S[2] = S[5] ^ S[2];

L_03a2:
    /* +0x05730 op=0xb4 06 02 02 00 ADD32: s2 = int32(s6 + s2) */
    S[2] = (int32_t)((uint32_t)S[6] + (uint32_t)S[2]);

L_03a3:
    /* +0x05748 op=0xb4 03 0d 03 00 ADD32: s3 = int32(s3 + s13) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[13]);

L_03a4:
    /* +0x05760 op=0x2e 12 02 02 12 ROR32_IMM: s2 = ror32((uint32_t)s2, 18) */
    S[2] = ror32((uint32_t)S[2], 18);

L_03a5:
    /* +0x05778 op=0xb4 02 09 06 00 ADD32: s6 = int32(s2 + s9) */
    S[6] = (int32_t)((uint32_t)S[2] + (uint32_t)S[9]);

L_03a6:
    /* +0x05790 op=0x02 06 09 0a 01 XOR64: s10 = s9 ^ s6 */
    S[10] = S[9] ^ S[6];

L_03a7:
    /* +0x057a8 op=0xb4 06 12 19 00 ADD32: s25 = int32(s6 + s18) */
    S[25] = (int32_t)((uint32_t)S[6] + (uint32_t)S[18]);

L_03a8:
    /* +0x057c0 op=0xb3 0a 05 02 01 AND64: s2 = s10 & s5 */
    S[2] = S[10] & S[5];

L_03a9:
    /* +0x057d8 op=0xb4 05 0b 05 00 ADD32: s5 = int32(s5 + s11) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[11]);

L_03aa:
    /* +0x057f0 op=0xb4 19 10 19 12 ADD32: s25 = int32(s25 + s16) */
    S[25] = (int32_t)((uint32_t)S[25] + (uint32_t)S[16]);

L_03ab:
    /* +0x05808 op=0x52 1e 10 98 01 LD32S: s16 = *(int32_t *)(s30 +0x198) */
    S[16] = *(int32_t *)((uint8_t *)S[30] + 0x198);

L_03ac:
    /* +0x05820 op=0x02 02 09 02 01 XOR64: s2 = s9 ^ s2 */
    S[2] = S[9] ^ S[2];

L_03ad:
    /* +0x05838 op=0xb4 09 0e 09 02 ADD32: s9 = int32(s9 + s14) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[14]);

L_03ae:
    /* +0x05850 op=0xb4 07 02 02 12 ADD32: s2 = int32(s7 + s2) */
    S[2] = (int32_t)((uint32_t)S[7] + (uint32_t)S[2]);

L_03af:
    /* +0x05868 op=0xb4 09 10 09 12 ADD32: s9 = int32(s9 + s16) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[16]);

L_03b0:
    /* +0x05880 op=0x2e 01 02 02 0c ROR32_IMM: s2 = ror32((uint32_t)s2, 12) */
    S[2] = ror32((uint32_t)S[2], 12);

L_03b1:
    /* +0x05898 op=0xb4 02 06 07 02 ADD32: s7 = int32(s2 + s6) */
    S[7] = (int32_t)((uint32_t)S[2] + (uint32_t)S[6]);

L_03b2:
    /* +0x058b0 op=0x02 0a 07 0a 01 XOR64: s10 = s7 ^ s10 */
    S[10] = S[7] ^ S[10];

L_03b3:
    /* +0x058c8 op=0x02 07 06 06 01 XOR64: s6 = s6 ^ s7 */
    S[6] = S[6] ^ S[7];

L_03b4:
    /* +0x058e0 op=0xb4 07 0d 02 02 ADD32: s2 = int32(s7 + s13) */
    S[2] = (int32_t)((uint32_t)S[7] + (uint32_t)S[13]);

L_03b5:
    /* +0x058f8 op=0x52 1e 0d 80 01 LD32S: s13 = *(int32_t *)(s30 +0x180) */
    S[13] = *(int32_t *)((uint8_t *)S[30] + 0x180);

L_03b6:
    /* +0x05910 op=0xb4 05 0a 05 12 ADD32: s5 = int32(s5 + s10) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[10]);

L_03b7:
    /* +0x05928 op=0x52 1e 0a 9c 01 LD32S: s10 = *(int32_t *)(s30 +0x19c) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x19c);

L_03b8:
    /* +0x05940 op=0xb4 02 0d 0d 02 ADD32: s13 = int32(s2 + s13) */
    S[13] = (int32_t)((uint32_t)S[2] + (uint32_t)S[13]);

L_03b9:
    /* +0x05958 op=0x52 1e 02 8c 01 LD32S: s2 = *(int32_t *)(s30 +0x18c) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x18c);

L_03ba:
    /* +0x05970 op=0xb4 05 0a 05 00 ADD32: s5 = int32(s5 + s10) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[10]);

L_03bb:
    /* +0x05988 op=0x2e 10 05 05 1c ROR32_IMM: s5 = ror32((uint32_t)s5, 28) */
    S[5] = ror32((uint32_t)S[5], 28);

L_03bc:
    /* +0x059a0 op=0xb4 02 12 0f 12 ADD32: s15 = int32(s2 + s18) */
    S[15] = (int32_t)((uint32_t)S[2] + (uint32_t)S[18]);

L_03bd:
    /* +0x059b8 op=0x52 1e 02 0c 02 LD32S: s2 = *(int32_t *)(s30 +0x20c) */
    S[2] = *(int32_t *)((uint8_t *)S[30] + 0x20c);

L_03be:
    /* +0x059d0 op=0xb4 05 07 05 12 ADD32: s5 = int32(s5 + s7) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_03bf:
    /* +0x059e8 op=0x02 06 05 06 01 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_03c0:
    /* +0x05a00 op=0x02 05 07 07 01 XOR64: s7 = s7 ^ s5 */
    S[7] = S[7] ^ S[5];

L_03c1:
    /* +0x05a18 op=0xb4 02 12 02 12 ADD32: s2 = int32(s2 + s18) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[18]);

L_03c2:
    /* +0x05a30 op=0xb4 09 06 06 12 ADD32: s6 = int32(s9 + s6) */
    S[6] = (int32_t)((uint32_t)S[9] + (uint32_t)S[6]);

L_03c3:
    /* +0x05a48 op=0xb4 13 05 09 02 ADD32: s9 = int32(s19 + s5) */
    S[9] = (int32_t)((uint32_t)S[19] + (uint32_t)S[5]);

L_03c4:
    /* +0x05a60 op=0x2e 01 06 06 15 ROR32_IMM: s6 = ror32((uint32_t)s6, 21) */
    S[6] = ror32((uint32_t)S[6], 21);

L_03c5:
    /* +0x05a78 op=0xb4 06 05 06 00 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_03c6:
    /* +0x05a90 op=0x02 07 06 07 01 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_03c7:
    /* +0x05aa8 op=0x02 06 05 05 00 XOR64: s5 = s5 ^ s6 */
    S[5] = S[5] ^ S[6];

L_03c8:
    /* +0x05ac0 op=0xb4 0f 06 0a 12 ADD32: s10 = int32(s15 + s6) */
    S[10] = (int32_t)((uint32_t)S[15] + (uint32_t)S[6]);

L_03c9:
    /* +0x05ad8 op=0xb4 19 07 07 00 ADD32: s7 = int32(s25 + s7) */
    S[7] = (int32_t)((uint32_t)S[25] + (uint32_t)S[7]);

L_03ca:
    /* +0x05af0 op=0x2e 12 07 07 10 ROR32_IMM: s7 = ror32((uint32_t)s7, 16) */
    S[7] = ror32((uint32_t)S[7], 16);

L_03cb:
    /* +0x05b08 op=0xb4 07 06 07 12 ADD32: s7 = int32(s7 + s6) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_03cc:
    /* +0x05b20 op=0x02 05 07 05 01 XOR64: s5 = s7 ^ s5 */
    S[5] = S[7] ^ S[5];

L_03cd:
    /* +0x05b38 op=0x02 07 06 06 01 XOR64: s6 = s6 ^ s7 */
    S[6] = S[6] ^ S[7];

L_03ce:
    /* +0x05b50 op=0xb4 0d 05 05 12 ADD32: s5 = int32(s13 + s5) */
    S[5] = (int32_t)((uint32_t)S[13] + (uint32_t)S[5]);

L_03cf:
    /* +0x05b68 op=0x2e 01 05 05 09 ROR32_IMM: s5 = ror32((uint32_t)s5, 9) */
    S[5] = ror32((uint32_t)S[5], 9);

L_03d0:
    /* +0x05b80 op=0xb4 05 07 05 00 ADD32: s5 = int32(s5 + s7) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_03d1:
    /* +0x05b98 op=0x02 06 05 06 01 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_03d2:
    /* +0x05bb0 op=0xb4 09 06 06 02 ADD32: s6 = int32(s9 + s6) */
    S[6] = (int32_t)((uint32_t)S[9] + (uint32_t)S[6]);

L_03d3:
    /* +0x05bc8 op=0x52 1e 09 50 01 LD32S: s9 = *(int32_t *)(s30 +0x150) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x150);

L_03d4:
    /* +0x05be0 op=0x2e 01 06 06 1c ROR32_IMM: s6 = ror32((uint32_t)s6, 28) */
    S[6] = ror32((uint32_t)S[6], 28);

L_03d5:
    /* +0x05bf8 op=0xb4 09 07 09 12 ADD32: s9 = int32(s9 + s7) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[7]);

L_03d6:
    /* +0x05c10 op=0xb4 06 05 06 00 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_03d7:
    /* +0x05c28 op=0x02 05 07 07 01 XOR64: s7 = s7 ^ s5 */
    S[7] = S[7] ^ S[5];

L_03d8:
    /* +0x05c40 op=0x02 07 06 07 00 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_03d9:
    /* +0x05c58 op=0xb4 01 06 01 02 ADD32: s1 = int32(s1 + s6) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_03da:
    /* +0x05c70 op=0xb4 0a 07 07 02 ADD32: s7 = int32(s10 + s7) */
    S[7] = (int32_t)((uint32_t)S[10] + (uint32_t)S[7]);

L_03db:
    /* +0x05c88 op=0x52 1e 0a 54 01 LD32S: s10 = *(int32_t *)(s30 +0x154) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x154);

L_03dc:
    /* +0x05ca0 op=0x2e 12 07 07 15 ROR32_IMM: s7 = ror32((uint32_t)s7, 21) */
    S[7] = ror32((uint32_t)S[7], 21);

L_03dd:
    /* +0x05cb8 op=0xb4 0a 05 0a 00 ADD32: s10 = int32(s10 + s5) */
    S[10] = (int32_t)((uint32_t)S[10] + (uint32_t)S[5]);

L_03de:
    /* +0x05cd0 op=0xb4 07 06 07 00 ADD32: s7 = int32(s7 + s6) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_03df:
    /* +0x05ce8 op=0x02 06 05 05 01 XOR64: s5 = s5 ^ s6 */
    S[5] = S[5] ^ S[6];

L_03e0:
    /* +0x05d00 op=0x02 05 07 05 01 XOR64: s5 = s7 ^ s5 */
    S[5] = S[7] ^ S[5];

L_03e1:
    /* +0x05d18 op=0x02 07 06 06 01 XOR64: s6 = s6 ^ s7 */
    S[6] = S[6] ^ S[7];

L_03e2:
    /* +0x05d30 op=0xb4 04 07 04 12 ADD32: s4 = int32(s4 + s7) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[7]);

L_03e3:
    /* +0x05d48 op=0xb4 09 05 05 12 ADD32: s5 = int32(s9 + s5) */
    S[5] = (int32_t)((uint32_t)S[9] + (uint32_t)S[5]);

L_03e4:
    /* +0x05d60 op=0x52 1e 09 5c 01 LD32S: s9 = *(int32_t *)(s30 +0x15c) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x15c);

L_03e5:
    /* +0x05d78 op=0x2e 10 05 05 10 ROR32_IMM: s5 = ror32((uint32_t)s5, 16) */
    S[5] = ror32((uint32_t)S[5], 16);

L_03e6:
    /* +0x05d90 op=0xb4 05 07 05 12 ADD32: s5 = int32(s5 + s7) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_03e7:
    /* +0x05da8 op=0x02 06 05 06 00 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_03e8:
    /* +0x05dc0 op=0x02 05 07 07 01 XOR64: s7 = s7 ^ s5 */
    S[7] = S[7] ^ S[5];

L_03e9:
    /* +0x05dd8 op=0xb4 0a 06 06 00 ADD32: s6 = int32(s10 + s6) */
    S[6] = (int32_t)((uint32_t)S[10] + (uint32_t)S[6]);

L_03ea:
    /* +0x05df0 op=0x52 1e 0a 68 01 LD32S: s10 = *(int32_t *)(s30 +0x168) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x168);

L_03eb:
    /* +0x05e08 op=0x2e 12 06 06 09 ROR32_IMM: s6 = ror32((uint32_t)s6, 9) */
    S[6] = ror32((uint32_t)S[6], 9);

L_03ec:
    /* +0x05e20 op=0xb4 06 05 06 00 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_03ed:
    /* +0x05e38 op=0x02 07 06 07 00 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_03ee:
    /* +0x05e50 op=0xb4 01 07 01 00 ADD32: s1 = int32(s1 + s7) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[7]);

L_03ef:
    /* +0x05e68 op=0x52 1e 07 58 01 LD32S: s7 = *(int32_t *)(s30 +0x158) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x158);

L_03f0:
    /* +0x05e80 op=0x2e 12 01 01 1c ROR32_IMM: s1 = ror32((uint32_t)s1, 28) */
    S[1] = ror32((uint32_t)S[1], 28);

L_03f1:
    /* +0x05e98 op=0xb4 07 05 07 02 ADD32: s7 = int32(s7 + s5) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[5]);

L_03f2:
    /* +0x05eb0 op=0xb4 01 06 01 12 ADD32: s1 = int32(s1 + s6) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_03f3:
    /* +0x05ec8 op=0x02 06 05 05 01 XOR64: s5 = s5 ^ s6 */
    S[5] = S[5] ^ S[6];

L_03f4:
    /* +0x05ee0 op=0x02 05 01 05 01 XOR64: s5 = s1 ^ s5 */
    S[5] = S[1] ^ S[5];

L_03f5:
    /* +0x05ef8 op=0xb4 09 01 09 12 ADD32: s9 = int32(s9 + s1) */
    S[9] = (int32_t)((uint32_t)S[9] + (uint32_t)S[1]);

L_03f6:
    /* +0x05f10 op=0xb4 04 05 04 00 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_03f7:
    /* +0x05f28 op=0x52 1e 05 c8 01 LD32S: s5 = *(int32_t *)(s30 +0x1c8) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x1c8);

L_03f8:
    /* +0x05f40 op=0x2e 10 04 04 15 ROR32_IMM: s4 = ror32((uint32_t)s4, 21) */
    S[4] = ror32((uint32_t)S[4], 21);

L_03f9:
    /* +0x05f58 op=0xb4 05 0c 05 12 ADD32: s5 = int32(s5 + s12) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[12]);

L_03fa:
    /* +0x05f70 op=0xb4 04 01 04 12 ADD32: s4 = int32(s4 + s1) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[1]);

L_03fb:
    /* +0x05f88 op=0xb4 05 06 05 12 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_03fc:
    /* +0x05fa0 op=0x02 01 06 06 00 XOR64: s6 = s6 ^ s1 */
    S[6] = S[6] ^ S[1];

L_03fd:
    /* +0x05fb8 op=0x02 04 01 01 00 XOR64: s1 = s1 ^ s4 */
    S[1] = S[1] ^ S[4];

L_03fe:
    /* +0x05fd0 op=0x02 06 04 06 00 XOR64: s6 = s4 ^ s6 */
    S[6] = S[4] ^ S[6];

L_03ff:
    /* +0x05fe8 op=0xb4 07 06 06 12 ADD32: s6 = int32(s7 + s6) */
    S[6] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_0400:
    /* +0x06000 op=0x52 1e 07 cc 01 LD32S: s7 = *(int32_t *)(s30 +0x1cc) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1cc);

L_0401:
    /* +0x06018 op=0x2e 01 06 06 10 ROR32_IMM: s6 = ror32((uint32_t)s6, 16) */
    S[6] = ror32((uint32_t)S[6], 16);

L_0402:
    /* +0x06030 op=0xb4 06 04 06 00 ADD32: s6 = int32(s6 + s4) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[4]);

L_0403:
    /* +0x06048 op=0xb4 07 18 07 12 ADD32: s7 = int32(s7 + s24) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[24]);

L_0404:
    /* +0x06060 op=0x02 01 06 01 01 XOR64: s1 = s6 ^ s1 */
    S[1] = S[6] ^ S[1];

L_0405:
    /* +0x06078 op=0xb4 07 06 07 02 ADD32: s7 = int32(s7 + s6) */
    S[7] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_0406:
    /* +0x06090 op=0xb4 05 01 01 00 ADD32: s1 = int32(s5 + s1) */
    S[1] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0407:
    /* +0x060a8 op=0x52 1e 05 60 01 LD32S: s5 = *(int32_t *)(s30 +0x160) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x160);

L_0408:
    /* +0x060c0 op=0x2e 01 01 01 09 ROR32_IMM: s1 = ror32((uint32_t)s1, 9) */
    S[1] = ror32((uint32_t)S[1], 9);

L_0409:
    /* +0x060d8 op=0xb4 05 04 05 12 ADD32: s5 = int32(s5 + s4) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[4]);

L_040a:
    /* +0x060f0 op=0xb4 01 06 01 12 ADD32: s1 = int32(s1 + s6) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_040b:
    /* +0x06108 op=0x02 06 04 04 01 XOR64: s4 = s4 ^ s6 */
    S[4] = S[4] ^ S[6];

L_040c:
    /* +0x06120 op=0x02 04 01 04 01 XOR64: s4 = s1 ^ s4 */
    S[4] = S[1] ^ S[4];

L_040d:
    /* +0x06138 op=0x02 01 06 06 01 XOR64: s6 = s6 ^ s1 */
    S[6] = S[6] ^ S[1];

L_040e:
    /* +0x06150 op=0xb4 09 04 04 12 ADD32: s4 = int32(s9 + s4) */
    S[4] = (int32_t)((uint32_t)S[9] + (uint32_t)S[4]);

L_040f:
    /* +0x06168 op=0x52 1e 09 ec 01 LD32S: s9 = *(int32_t *)(s30 +0x1ec) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x1ec);

L_0410:
    /* +0x06180 op=0x2e 01 04 04 1c ROR32_IMM: s4 = ror32((uint32_t)s4, 28) */
    S[4] = ror32((uint32_t)S[4], 28);

L_0411:
    /* +0x06198 op=0xb4 04 01 04 12 ADD32: s4 = int32(s4 + s1) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[1]);

L_0412:
    /* +0x061b0 op=0x02 06 04 06 01 XOR64: s6 = s4 ^ s6 */
    S[6] = S[4] ^ S[6];

L_0413:
    /* +0x061c8 op=0xb4 05 06 05 00 ADD32: s5 = int32(s5 + s6) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[6]);

L_0414:
    /* +0x061e0 op=0x02 04 01 06 01 XOR64: s6 = s1 ^ s4 */
    S[6] = S[1] ^ S[4];

L_0415:
    /* +0x061f8 op=0xb4 0a 01 01 00 ADD32: s1 = int32(s10 + s1) */
    S[1] = (int32_t)((uint32_t)S[10] + (uint32_t)S[1]);

L_0416:
    /* +0x06210 op=0x2e 12 05 05 15 ROR32_IMM: s5 = ror32((uint32_t)s5, 21) */
    S[5] = ror32((uint32_t)S[5], 21);

L_0417:
    /* +0x06228 op=0xb4 05 04 05 00 ADD32: s5 = int32(s5 + s4) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[4]);

L_0418:
    /* +0x06240 op=0x02 06 05 06 01 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_0419:
    /* +0x06258 op=0x36 05 00 0a 01 NOR64: s10 = ~(s5 | s0) */
    S[10] = ~(S[5] | S[0]);

L_041a:
    /* +0x06270 op=0xb4 07 06 06 00 ADD32: s6 = int32(s7 + s6) */
    S[6] = (int32_t)((uint32_t)S[7] + (uint32_t)S[6]);

L_041b:
    /* +0x06288 op=0x02 05 04 07 00 XOR64: s7 = s4 ^ s5 */
    S[7] = S[4] ^ S[5];

L_041c:
    /* +0x062a0 op=0xb4 04 0b 04 02 ADD32: s4 = int32(s4 + s11) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[11]);

L_041d:
    /* +0x062b8 op=0x52 1e 0b e0 01 LD32S: s11 = *(int32_t *)(s30 +0x1e0) */
    S[11] = *(int32_t *)((uint8_t *)S[30] + 0x1e0);

L_041e:
    /* +0x062d0 op=0x2e 10 06 06 10 ROR32_IMM: s6 = ror32((uint32_t)s6, 16) */
    S[6] = ror32((uint32_t)S[6], 16);

L_041f:
    /* +0x062e8 op=0xb4 06 05 06 00 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_0420:
    /* +0x06300 op=0xb4 05 0c 05 02 ADD32: s5 = int32(s5 + s12) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[12]);

L_0421:
    /* +0x06318 op=0x52 1e 0c e8 01 LD32S: s12 = *(int32_t *)(s30 +0x1e8) */
    S[12] = *(int32_t *)((uint8_t *)S[30] + 0x1e8);

L_0422:
    /* +0x06330 op=0x02 07 06 07 00 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_0423:
    /* +0x06348 op=0xb4 01 07 01 12 ADD32: s1 = int32(s1 + s7) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[7]);

L_0424:
    /* +0x06360 op=0x52 1e 07 e4 01 LD32S: s7 = *(int32_t *)(s30 +0x1e4) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1e4);

L_0425:
    /* +0x06378 op=0x2e 12 01 01 09 ROR32_IMM: s1 = ror32((uint32_t)s1, 9) */
    S[1] = ror32((uint32_t)S[1], 9);

L_0426:
    /* +0x06390 op=0xb4 01 06 01 00 ADD32: s1 = int32(s1 + s6) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_0427:
    /* +0x063a8 op=0xb4 05 07 05 00 ADD32: s5 = int32(s5 + s7) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_0428:
    /* +0x063c0 op=0x34 01 0a 07 00 OR64: s7 = s1 | s10 */
    S[7] = S[1] | S[10];

L_0429:
    /* +0x063d8 op=0xb4 01 0e 0a 12 ADD32: s10 = int32(s1 + s14) */
    S[10] = (int32_t)((uint32_t)S[1] + (uint32_t)S[14]);

L_042a:
    /* +0x063f0 op=0x02 07 06 07 00 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_042b:
    /* +0x06408 op=0xb4 0a 09 09 02 ADD32: s9 = int32(s10 + s9) */
    S[9] = (int32_t)((uint32_t)S[10] + (uint32_t)S[9]);

L_042c:
    /* +0x06420 op=0x52 1e 0a 6c 01 LD32S: s10 = *(int32_t *)(s30 +0x16c) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x16c);

L_042d:
    /* +0x06438 op=0xb4 04 07 04 12 ADD32: s4 = int32(s4 + s7) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[7]);

L_042e:
    /* +0x06450 op=0x36 01 00 07 01 NOR64: s7 = ~(s1 | s0) */
    S[7] = ~(S[1] | S[0]);

L_042f:
    /* +0x06468 op=0xb4 04 0b 04 02 ADD32: s4 = int32(s4 + s11) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[11]);

L_0430:
    /* +0x06480 op=0x36 06 00 0b 00 NOR64: s11 = ~(s6 | s0) */
    S[11] = ~(S[6] | S[0]);

L_0431:
    /* +0x06498 op=0xb4 06 18 06 00 ADD32: s6 = int32(s6 + s24) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[24]);

L_0432:
    /* +0x064b0 op=0x2e 12 04 04 1a ROR32_IMM: s4 = ror32((uint32_t)s4, 26) */
    S[4] = ror32((uint32_t)S[4], 26);

L_0433:
    /* +0x064c8 op=0xb4 06 0c 06 02 ADD32: s6 = int32(s6 + s12) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[12]);

L_0434:
    /* +0x064e0 op=0xb4 04 01 04 02 ADD32: s4 = int32(s4 + s1) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[1]);

L_0435:
    /* +0x064f8 op=0x34 04 0b 0b 01 OR64: s11 = s4 | s11 */
    S[11] = S[4] | S[11];

L_0436:
    /* +0x06510 op=0x02 0b 01 01 01 XOR64: s1 = s1 ^ s11 */
    S[1] = S[1] ^ S[11];

L_0437:
    /* +0x06528 op=0xb4 05 01 01 00 ADD32: s1 = int32(s5 + s1) */
    S[1] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0438:
    /* +0x06540 op=0x2e 12 01 01 16 ROR32_IMM: s1 = ror32((uint32_t)s1, 22) */
    S[1] = ror32((uint32_t)S[1], 22);

L_0439:
    /* +0x06558 op=0xb4 01 04 01 00 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_043a:
    /* +0x06570 op=0x34 01 07 05 01 OR64: s5 = s1 | s7 */
    S[5] = S[1] | S[7];

L_043b:
    /* +0x06588 op=0x36 04 00 07 00 NOR64: s7 = ~(s4 | s0) */
    S[7] = ~(S[4] | S[0]);

L_043c:
    /* +0x065a0 op=0x02 05 04 05 01 XOR64: s5 = s4 ^ s5 */
    S[5] = S[4] ^ S[5];

L_043d:
    /* +0x065b8 op=0xb4 0a 04 04 00 ADD32: s4 = int32(s10 + s4) */
    S[4] = (int32_t)((uint32_t)S[10] + (uint32_t)S[4]);

L_043e:
    /* +0x065d0 op=0x52 1e 0a 74 01 LD32S: s10 = *(int32_t *)(s30 +0x174) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x174);

L_043f:
    /* +0x065e8 op=0xb4 06 05 05 02 ADD32: s5 = int32(s6 + s5) */
    S[5] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_0440:
    /* +0x06600 op=0x2e 10 05 05 11 ROR32_IMM: s5 = ror32((uint32_t)s5, 17) */
    S[5] = ror32((uint32_t)S[5], 17);

L_0441:
    /* +0x06618 op=0xb4 05 01 05 00 ADD32: s5 = int32(s5 + s1) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0442:
    /* +0x06630 op=0x34 05 07 06 01 OR64: s6 = s5 | s7 */
    S[6] = S[5] | S[7];

L_0443:
    /* +0x06648 op=0x36 01 00 07 00 NOR64: s7 = ~(s1 | s0) */
    S[7] = ~(S[1] | S[0]);

L_0444:
    /* +0x06660 op=0x02 06 01 06 01 XOR64: s6 = s1 ^ s6 */
    S[6] = S[1] ^ S[6];

L_0445:
    /* +0x06678 op=0xb4 0a 01 01 00 ADD32: s1 = int32(s10 + s1) */
    S[1] = (int32_t)((uint32_t)S[10] + (uint32_t)S[1]);

L_0446:
    /* +0x06690 op=0x52 1e 0a 7c 01 LD32S: s10 = *(int32_t *)(s30 +0x17c) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x17c);

L_0447:
    /* +0x066a8 op=0xb4 09 06 06 00 ADD32: s6 = int32(s9 + s6) */
    S[6] = (int32_t)((uint32_t)S[9] + (uint32_t)S[6]);

L_0448:
    /* +0x066c0 op=0x36 05 00 09 00 NOR64: s9 = ~(s5 | s0) */
    S[9] = ~(S[5] | S[0]);

L_0449:
    /* +0x066d8 op=0x2e 01 06 06 0b ROR32_IMM: s6 = ror32((uint32_t)s6, 11) */
    S[6] = ror32((uint32_t)S[6], 11);

L_044a:
    /* +0x066f0 op=0xb4 06 05 06 02 ADD32: s6 = int32(s6 + s5) */
    S[6] = (int32_t)((uint32_t)S[6] + (uint32_t)S[5]);

L_044b:
    /* +0x06708 op=0x34 06 07 07 01 OR64: s7 = s6 | s7 */
    S[7] = S[6] | S[7];

L_044c:
    /* +0x06720 op=0x02 07 05 07 01 XOR64: s7 = s5 ^ s7 */
    S[7] = S[5] ^ S[7];

L_044d:
    /* +0x06738 op=0xb4 14 05 05 12 ADD32: s5 = int32(s20 + s5) */
    S[5] = (int32_t)((uint32_t)S[20] + (uint32_t)S[5]);

L_044e:
    /* +0x06750 op=0xb4 04 07 04 12 ADD32: s4 = int32(s4 + s7) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[7]);

L_044f:
    /* +0x06768 op=0x2e 01 04 04 1a ROR32_IMM: s4 = ror32((uint32_t)s4, 26) */
    S[4] = ror32((uint32_t)S[4], 26);

L_0450:
    /* +0x06780 op=0xb4 04 06 04 02 ADD32: s4 = int32(s4 + s6) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_0451:
    /* +0x06798 op=0x34 04 09 07 01 OR64: s7 = s4 | s9 */
    S[7] = S[4] | S[9];

L_0452:
    /* +0x067b0 op=0x36 06 00 09 01 NOR64: s9 = ~(s6 | s0) */
    S[9] = ~(S[6] | S[0]);

L_0453:
    /* +0x067c8 op=0x02 07 06 07 01 XOR64: s7 = s6 ^ s7 */
    S[7] = S[6] ^ S[7];

L_0454:
    /* +0x067e0 op=0xb4 0a 06 06 12 ADD32: s6 = int32(s10 + s6) */
    S[6] = (int32_t)((uint32_t)S[10] + (uint32_t)S[6]);

L_0455:
    /* +0x067f8 op=0x52 1e 0a 90 01 LD32S: s10 = *(int32_t *)(s30 +0x190) */
    S[10] = *(int32_t *)((uint8_t *)S[30] + 0x190);

L_0456:
    /* +0x06810 op=0xb4 01 07 01 02 ADD32: s1 = int32(s1 + s7) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[7]);

L_0457:
    /* +0x06828 op=0x2e 01 01 01 16 ROR32_IMM: s1 = ror32((uint32_t)s1, 22) */
    S[1] = ror32((uint32_t)S[1], 22);

L_0458:
    /* +0x06840 op=0xb4 01 04 01 00 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_0459:
    /* +0x06858 op=0x34 01 09 07 01 OR64: s7 = s1 | s9 */
    S[7] = S[1] | S[9];

L_045a:
    /* +0x06870 op=0x36 04 00 09 01 NOR64: s9 = ~(s4 | s0) */
    S[9] = ~(S[4] | S[0]);

L_045b:
    /* +0x06888 op=0x02 07 04 07 01 XOR64: s7 = s4 ^ s7 */
    S[7] = S[4] ^ S[7];

L_045c:
    /* +0x068a0 op=0xb4 0a 04 04 12 ADD32: s4 = int32(s10 + s4) */
    S[4] = (int32_t)((uint32_t)S[10] + (uint32_t)S[4]);

L_045d:
    /* +0x068b8 op=0xb4 05 07 05 02 ADD32: s5 = int32(s5 + s7) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[7]);

L_045e:
    /* +0x068d0 op=0x2e 10 05 05 11 ROR32_IMM: s5 = ror32((uint32_t)s5, 17) */
    S[5] = ror32((uint32_t)S[5], 17);

L_045f:
    /* +0x068e8 op=0xb4 05 01 05 12 ADD32: s5 = int32(s5 + s1) */
    S[5] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_0460:
    /* +0x06900 op=0x34 05 09 07 01 OR64: s7 = s5 | s9 */
    S[7] = S[5] | S[9];

L_0461:
    /* +0x06918 op=0x36 01 00 09 00 NOR64: s9 = ~(s1 | s0) */
    S[9] = ~(S[1] | S[0]);

L_0462:
    /* +0x06930 op=0x02 07 01 07 01 XOR64: s7 = s1 ^ s7 */
    S[7] = S[1] ^ S[7];

L_0463:
    /* +0x06948 op=0xb4 03 01 01 12 ADD32: s1 = int32(s3 + s1) */
    S[1] = (int32_t)((uint32_t)S[3] + (uint32_t)S[1]);

L_0464:
    /* +0x06960 op=0xb4 06 07 03 12 ADD32: s3 = int32(s6 + s7) */
    S[3] = (int32_t)((uint32_t)S[6] + (uint32_t)S[7]);

L_0465:
    /* +0x06978 op=0x36 05 00 07 01 NOR64: s7 = ~(s5 | s0) */
    S[7] = ~(S[5] | S[0]);

L_0466:
    /* +0x06990 op=0x2e 10 03 03 0b ROR32_IMM: s3 = ror32((uint32_t)s3, 11) */
    S[3] = ror32((uint32_t)S[3], 11);

L_0467:
    /* +0x069a8 op=0xb4 03 05 03 00 ADD32: s3 = int32(s3 + s5) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_0468:
    /* +0x069c0 op=0x34 03 09 06 01 OR64: s6 = s3 | s9 */
    S[6] = S[3] | S[9];

L_0469:
    /* +0x069d8 op=0x52 1e 09 a0 01 LD32S: s9 = *(int32_t *)(s30 +0x1a0) */
    S[9] = *(int32_t *)((uint8_t *)S[30] + 0x1a0);

L_046a:
    /* +0x069f0 op=0xb4 02 03 02 00 ADD32: s2 = int32(s2 + s3) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[3]);

L_046b:
    /* +0x06a08 op=0x02 06 05 06 00 XOR64: s6 = s5 ^ s6 */
    S[6] = S[5] ^ S[6];

L_046c:
    /* +0x06a20 op=0xb4 04 06 04 12 ADD32: s4 = int32(s4 + s6) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_046d:
    /* +0x06a38 op=0xb4 09 05 05 02 ADD32: s5 = int32(s9 + s5) */
    S[5] = (int32_t)((uint32_t)S[9] + (uint32_t)S[5]);

L_046e:
    /* +0x06a50 op=0x2e 10 04 04 1a ROR32_IMM: s4 = ror32((uint32_t)s4, 26) */
    S[4] = ror32((uint32_t)S[4], 26);

L_046f:
    /* +0x06a68 op=0xb4 04 03 04 00 ADD32: s4 = int32(s4 + s3) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[3]);

L_0470:
    /* +0x06a80 op=0x34 04 07 06 01 OR64: s6 = s4 | s7 */
    S[6] = S[4] | S[7];

L_0471:
    /* +0x06a98 op=0x36 03 00 07 00 NOR64: s7 = ~(s3 | s0) */
    S[7] = ~(S[3] | S[0]);

L_0472:
    /* +0x06ab0 op=0x02 06 03 06 01 XOR64: s6 = s3 ^ s6 */
    S[6] = S[3] ^ S[6];

L_0473:
    /* +0x06ac8 op=0xb4 01 06 01 12 ADD32: s1 = int32(s1 + s6) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_0474:
    /* +0x06ae0 op=0x36 04 00 06 01 NOR64: s6 = ~(s4 | s0) */
    S[6] = ~(S[4] | S[0]);

L_0475:
    /* +0x06af8 op=0x2e 12 01 01 16 ROR32_IMM: s1 = ror32((uint32_t)s1, 22) */
    S[1] = ror32((uint32_t)S[1], 22);

L_0476:
    /* +0x06b10 op=0xb4 01 04 01 00 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_0477:
    /* +0x06b28 op=0x34 01 07 03 00 OR64: s3 = s1 | s7 */
    S[3] = S[1] | S[7];

L_0478:
    /* +0x06b40 op=0x52 1e 07 a4 01 LD32S: s7 = *(int32_t *)(s30 +0x1a4) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1a4);

L_0479:
    /* +0x06b58 op=0x02 03 04 03 00 XOR64: s3 = s4 ^ s3 */
    S[3] = S[4] ^ S[3];

L_047a:
    /* +0x06b70 op=0xb4 05 03 03 12 ADD32: s3 = int32(s5 + s3) */
    S[3] = (int32_t)((uint32_t)S[5] + (uint32_t)S[3]);

L_047b:
    /* +0x06b88 op=0xb4 07 04 04 00 ADD32: s4 = int32(s7 + s4) */
    S[4] = (int32_t)((uint32_t)S[7] + (uint32_t)S[4]);

L_047c:
    /* +0x06ba0 op=0x52 1e 07 a8 01 LD32S: s7 = *(int32_t *)(s30 +0x1a8) */
    S[7] = *(int32_t *)((uint8_t *)S[30] + 0x1a8);

L_047d:
    /* +0x06bb8 op=0x2e 10 03 03 11 ROR32_IMM: s3 = ror32((uint32_t)s3, 17) */
    S[3] = ror32((uint32_t)S[3], 17);

L_047e:
    /* +0x06bd0 op=0xb4 03 01 03 02 ADD32: s3 = int32(s3 + s1) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[1]);

L_047f:
    /* +0x06be8 op=0x34 03 06 05 01 OR64: s5 = s3 | s6 */
    S[5] = S[3] | S[6];

L_0480:
    /* +0x06c00 op=0x36 01 00 06 01 NOR64: s6 = ~(s1 | s0) */
    S[6] = ~(S[1] | S[0]);

L_0481:
    /* +0x06c18 op=0x02 05 01 05 01 XOR64: s5 = s1 ^ s5 */
    S[5] = S[1] ^ S[5];

L_0482:
    /* +0x06c30 op=0xb4 08 01 01 12 ADD32: s1 = int32(s8 + s1) */
    S[1] = (int32_t)((uint32_t)S[8] + (uint32_t)S[1]);

L_0483:
    /* +0x06c48 op=0x58 1e 08 d0 01 LD64: s8 = *(uint64_t *)(s30 +0x1d0) */
    S[8] = *(uint64_t *)((uint8_t *)S[30] + 0x1d0);

L_0484:
    /* +0x06c60 op=0xb4 02 05 02 12 ADD32: s2 = int32(s2 + s5) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[5]);

L_0485:
    /* +0x06c78 op=0x2e 12 02 02 0b ROR32_IMM: s2 = ror32((uint32_t)s2, 11) */
    S[2] = ror32((uint32_t)S[2], 11);

L_0486:
    /* +0x06c90 op=0xb4 02 03 02 02 ADD32: s2 = int32(s2 + s3) */
    S[2] = (int32_t)((uint32_t)S[2] + (uint32_t)S[3]);

L_0487:
    /* +0x06ca8 op=0x34 02 06 05 01 OR64: s5 = s2 | s6 */
    S[5] = S[2] | S[6];

L_0488:
    /* +0x06cc0 op=0x36 03 00 06 01 NOR64: s6 = ~(s3 | s0) */
    S[6] = ~(S[3] | S[0]);

L_0489:
    /* +0x06cd8 op=0x02 05 03 05 01 XOR64: s5 = s3 ^ s5 */
    S[5] = S[3] ^ S[5];

L_048a:
    /* +0x06cf0 op=0xb4 07 03 03 12 ADD32: s3 = int32(s7 + s3) */
    S[3] = (int32_t)((uint32_t)S[7] + (uint32_t)S[3]);

L_048b:
    /* +0x06d08 op=0x36 02 00 07 01 NOR64: s7 = ~(s2 | s0) */
    S[7] = ~(S[2] | S[0]);

L_048c:
    /* +0x06d20 op=0xb4 04 05 04 12 ADD32: s4 = int32(s4 + s5) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[5]);

L_048d:
    /* +0x06d38 op=0x2e 10 04 04 1a ROR32_IMM: s4 = ror32((uint32_t)s4, 26) */
    S[4] = ror32((uint32_t)S[4], 26);

L_048e:
    /* +0x06d50 op=0xb4 04 02 04 00 ADD32: s4 = int32(s4 + s2) */
    S[4] = (int32_t)((uint32_t)S[4] + (uint32_t)S[2]);

L_048f:
    /* +0x06d68 op=0x34 04 06 05 01 OR64: s5 = s4 | s6 */
    S[5] = S[4] | S[6];

L_0490:
    /* +0x06d80 op=0x52 1e 06 dc 01 LD32S: s6 = *(int32_t *)(s30 +0x1dc) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x1dc);

L_0491:
    /* +0x06d98 op=0x02 05 02 05 01 XOR64: s5 = s2 ^ s5 */
    S[5] = S[2] ^ S[5];

L_0492:
    /* +0x06db0 op=0xb4 01 05 01 00 ADD32: s1 = int32(s1 + s5) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[5]);

L_0493:
    /* +0x06dc8 op=0xb4 04 06 06 12 ADD32: s6 = int32(s4 + s6) */
    S[6] = (int32_t)((uint32_t)S[4] + (uint32_t)S[6]);

L_0494:
    /* +0x06de0 op=0x2e 10 01 01 16 ROR32_IMM: s1 = ror32((uint32_t)s1, 22) */
    S[1] = ror32((uint32_t)S[1], 22);

L_0495:
    /* +0x06df8 op=0x08 08 06 08 00 ST32: *(s8 +0x8) = (uint32_t)s6 */
    *(uint32_t *)((uint8_t *)S[8] + 0x8) = (uint32_t)S[6];

L_0496:
    /* +0x06e10 op=0x52 1e 06 b4 01 LD32S: s6 = *(int32_t *)(s30 +0x1b4) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x1b4);

L_0497:
    /* +0x06e28 op=0xb4 01 04 01 12 ADD32: s1 = int32(s1 + s4) */
    S[1] = (int32_t)((uint32_t)S[1] + (uint32_t)S[4]);

L_0498:
    /* +0x06e40 op=0x34 01 07 05 00 OR64: s5 = s1 | s7 */
    S[5] = S[1] | S[7];

L_0499:
    /* +0x06e58 op=0xb4 06 02 02 02 ADD32: s2 = int32(s6 + s2) */
    S[2] = (int32_t)((uint32_t)S[6] + (uint32_t)S[2]);

L_049a:
    /* +0x06e70 op=0x52 1e 06 c0 01 LD32S: s6 = *(int32_t *)(s30 +0x1c0) */
    S[6] = *(int32_t *)((uint8_t *)S[30] + 0x1c0);

L_049b:
    /* +0x06e88 op=0x02 05 04 05 01 XOR64: s5 = s4 ^ s5 */
    S[5] = S[4] ^ S[5];

L_049c:
    /* +0x06ea0 op=0x36 04 00 04 01 NOR64: s4 = ~(s4 | s0) */
    S[4] = ~(S[4] | S[0]);

L_049d:
    /* +0x06eb8 op=0xb4 03 05 03 02 ADD32: s3 = int32(s3 + s5) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_049e:
    /* +0x06ed0 op=0x52 1e 05 88 01 LD32S: s5 = *(int32_t *)(s30 +0x188) */
    S[5] = *(int32_t *)((uint8_t *)S[30] + 0x188);

L_049f:
    /* +0x06ee8 op=0xb4 01 06 06 02 ADD32: s6 = int32(s1 + s6) */
    S[6] = (int32_t)((uint32_t)S[1] + (uint32_t)S[6]);

L_04a0:
    /* +0x06f00 op=0x2e 01 03 03 11 ROR32_IMM: s3 = ror32((uint32_t)s3, 17) */
    S[3] = ror32((uint32_t)S[3], 17);

L_04a1:
    /* +0x06f18 op=0x08 08 06 14 00 ST32: *(s8 +0x14) = (uint32_t)s6 */
    *(uint32_t *)((uint8_t *)S[8] + 0x14) = (uint32_t)S[6];

L_04a2:
    /* +0x06f30 op=0xb4 03 01 03 00 ADD32: s3 = int32(s3 + s1) */
    S[3] = (int32_t)((uint32_t)S[3] + (uint32_t)S[1]);

L_04a3:
    /* +0x06f48 op=0xb4 03 05 05 02 ADD32: s5 = int32(s3 + s5) */
    S[5] = (int32_t)((uint32_t)S[3] + (uint32_t)S[5]);

L_04a4:
    /* +0x06f60 op=0x08 08 05 10 00 ST32: *(s8 +0x10) = (uint32_t)s5 */
    *(uint32_t *)((uint8_t *)S[8] + 0x10) = (uint32_t)S[5];

L_04a5:
    /* +0x06f78 op=0xb4 03 1f 05 12 ADD32: s5 = int32(s3 + s31) */
    S[5] = (int32_t)((uint32_t)S[3] + (uint32_t)S[31]);

L_04a6:
    /* +0x06f90 op=0x34 03 04 03 01 OR64: s3 = s3 | s4 */
    S[3] = S[3] | S[4];

L_04a7:
    /* +0x06fa8 op=0x02 03 01 01 00 XOR64: s1 = s1 ^ s3 */
    S[1] = S[1] ^ S[3];

L_04a8:
    /* +0x06fc0 op=0xb4 02 01 01 12 ADD32: s1 = int32(s2 + s1) */
    S[1] = (int32_t)((uint32_t)S[2] + (uint32_t)S[1]);

L_04a9:
    /* +0x06fd8 op=0x2e 12 01 01 0b ROR32_IMM: s1 = ror32((uint32_t)s1, 11) */
    S[1] = ror32((uint32_t)S[1], 11);

L_04aa:
    /* +0x06ff0 op=0xb4 05 01 01 00 ADD32: s1 = int32(s5 + s1) */
    S[1] = (int32_t)((uint32_t)S[5] + (uint32_t)S[1]);

L_04ab:
    /* +0x07008 op=0x08 08 01 0c 00 ST32: *(s8 +0xc) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[8] + 0xc) = (uint32_t)S[1];

L_04ac:
    /* +0x07020 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_04ad:
    /* +0x07038 op=0x58 1d 10 e0 02 LD64: s16 = *(uint64_t *)(s29 +0x2e0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x2e0);

L_04ae:
    /* +0x07050 op=0x58 1d 11 e8 02 LD64: s17 = *(uint64_t *)(s29 +0x2e8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x2e8);

L_04af:
    /* +0x07068 op=0x58 1d 12 f0 02 LD64: s18 = *(uint64_t *)(s29 +0x2f0) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x2f0);

L_04b0:
    /* +0x07080 op=0x58 1d 13 f8 02 LD64: s19 = *(uint64_t *)(s29 +0x2f8) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x2f8);

L_04b1:
    /* +0x07098 op=0x58 1d 14 00 03 LD64: s20 = *(uint64_t *)(s29 +0x300) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x300);

L_04b2:
    /* +0x070b0 op=0x58 1d 15 08 03 LD64: s21 = *(uint64_t *)(s29 +0x308) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x308);

L_04b3:
    /* +0x070c8 op=0x58 1d 16 10 03 LD64: s22 = *(uint64_t *)(s29 +0x310) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x310);

L_04b4:
    /* +0x070e0 op=0x58 1d 17 18 03 LD64: s23 = *(uint64_t *)(s29 +0x318) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x318);

L_04b5:
    /* +0x070f8 op=0x58 1d 1e 20 03 LD64: s30 = *(uint64_t *)(s29 +0x320) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x320);

L_04b6:
    /* +0x07110 op=0x58 1d 1f 28 03 LD64: s31 = *(uint64_t *)(s29 +0x328) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x328);

L_04b7:
    /* +0x07128 op=0x85 1d 1d 30 03 ADD64_IMM16: s29 = s29 +0x330 */
    S[29] = S[29] + 0x330;

L_04b8:
    /* +0x07140 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

/*
 * Auto-generated linear C-like lift for 350.101 managed program F13.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_20260831_023336/350101_F13_0x5d2000_0xe70.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F13_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d e0 fe ADD64_IMM16: s29 = s29 -0x120 */
    S[29] = S[29] + (-0x120);

L_0001:
    /* +0x00018 op=0x25 1d 1f 18 01 ST64: *(s29 +0x118) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x118) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 10 01 ST64: *(s29 +0x110) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x110) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 17 08 01 ST64: *(s29 +0x108) = s23 */
    *(uint64_t *)((uint8_t *)S[29] + 0x108) = S[23];

L_0004:
    /* +0x00060 op=0x25 1d 16 00 01 ST64: *(s29 +0x100) = s22 */
    *(uint64_t *)((uint8_t *)S[29] + 0x100) = S[22];

L_0005:
    /* +0x00078 op=0x25 1d 15 f8 00 ST64: *(s29 +0xf8) = s21 */
    *(uint64_t *)((uint8_t *)S[29] + 0xf8) = S[21];

L_0006:
    /* +0x00090 op=0x25 1d 14 f0 00 ST64: *(s29 +0xf0) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0xf0) = S[20];

L_0007:
    /* +0x000a8 op=0x25 1d 13 e8 00 ST64: *(s29 +0xe8) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0xe8) = S[19];

L_0008:
    /* +0x000c0 op=0x25 1d 12 e0 00 ST64: *(s29 +0xe0) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0xe0) = S[18];

L_0009:
    /* +0x000d8 op=0x25 1d 11 d8 00 ST64: *(s29 +0xd8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0xd8) = S[17];

L_000a:
    /* +0x000f0 op=0x25 1d 10 d0 00 ST64: *(s29 +0xd0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0xd0) = S[16];

L_000b:
    /* +0x00108 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000c:
    /* +0x00120 op=0x58 04 01 28 00 LD64: s1 = *(uint64_t *)(s4 +0x28) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x28);

L_000d:
    /* +0x00138 op=0x58 04 14 08 00 LD64: s20 = *(uint64_t *)(s4 +0x8) */
    S[20] = *(uint64_t *)((uint8_t *)S[4] + 0x8);

L_000e:
    /* +0x00150 op=0x58 04 15 00 00 LD64: s21 = *(uint64_t *)(s4 +0x0) */
    S[21] = *(uint64_t *)((uint8_t *)S[4] + 0x0);

L_000f:
    /* +0x00168 op=0x58 04 11 18 00 LD64: s17 = *(uint64_t *)(s4 +0x18) */
    S[17] = *(uint64_t *)((uint8_t *)S[4] + 0x18);

L_0010:
    /* +0x00180 op=0x58 04 10 10 00 LD64: s16 = *(uint64_t *)(s4 +0x10) */
    S[16] = *(uint64_t *)((uint8_t *)S[4] + 0x10);

L_0011:
    /* +0x00198 op=0x25 1e 01 18 00 ST64: *(s30 +0x18) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x18) = S[1];

L_0012:
    /* +0x001b0 op=0x58 04 01 20 00 LD64: s1 = *(uint64_t *)(s4 +0x20) */
    S[1] = *(uint64_t *)((uint8_t *)S[4] + 0x20);

L_0013:
    /* +0x001c8 op=0x25 1e 01 10 00 ST64: *(s30 +0x10) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x10) = S[1];

L_0014:
    /* +0x001e0 op=0x53 03 01 08 03 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x308 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x308;

L_0015:
    /* +0x001f8 op=0x58 01 13 00 00 LD64: s19 = *(uint64_t *)(s1 +0x0) */
    S[19] = *(uint64_t *)((uint8_t *)S[1] + 0x0);

L_0016:
    /* +0x00210 op=0x5e 0d 00 00 00 CALL_CF_INDEX: call native_binding[index=0xd] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xd, (void *)(uintptr_t)0x125fd3c0);

L_0017:
    /* +0x00228 op=0x85 1e 12 98 00 ADD64_IMM16: s18 = s30 +0x98 */
    S[18] = S[30] + 0x98;

L_0018:
    /* +0x00240 op=0x34 10 00 05 01 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_0019:
    /* +0x00258 op=0x08 1e 02 cc 00 ST32: *(s30 +0xcc) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[30] + 0xcc) = (uint32_t)S[2];

L_001a:
    /* +0x00270 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_001b:
    /* +0x00288 op=0x5e 09 00 00 00 CALL_CF_INDEX: call native_binding[index=0x9] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x9, (void *)(uintptr_t)0x125fd3c0);

L_001c:
    /* +0x002a0 op=0x58 1e 05 98 00 LD64: s5 = *(uint64_t *)(s30 +0x98) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x98);

L_001d:
    /* +0x002b8 op=0x85 1e 04 b0 00 ADD64_IMM16: s4 = s30 +0xb0 */
    S[4] = S[30] + 0xb0;

L_001e:
    /* +0x002d0 op=0x25 1e 04 08 00 ST64: *(s30 +0x8) = s4 */
    *(uint64_t *)((uint8_t *)S[30] + 0x8) = S[4];

L_001f:
    /* +0x002e8 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_0020:
    /* +0x00300 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0021:
    /* +0x00318 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0022:
    /* +0x00330 op=0x85 1e 12 98 00 ADD64_IMM16: s18 = s30 +0x98 */
    S[18] = S[30] + 0x98;

L_0023:
    /* +0x00348 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0024:
    /* +0x00360 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_0025:
    /* +0x00378 op=0x58 11 07 10 00 LD64: s7 = *(uint64_t *)(s17 +0x10) */
    S[7] = *(uint64_t *)((uint8_t *)S[17] + 0x10);

L_0026:
    /* +0x00390 op=0x58 1e 08 c0 00 LD64: s8 = *(uint64_t *)(s30 +0xc0) */
    S[8] = *(uint64_t *)((uint8_t *)S[30] + 0xc0);

L_0027:
    /* +0x003a8 op=0x85 13 05 ec 00 ADD64_IMM16: s5 = s19 +0xec */
    S[5] = S[19] + 0xec;

L_0028:
    /* +0x003c0 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0029:
    /* +0x003d8 op=0x34 15 00 06 00 OR64: s6 = s21 | s0 */
    S[6] = S[21] | S[0];

L_002a:
    /* +0x003f0 op=0x34 13 00 10 00 OR64: s16 = s19 | s0 */
    S[16] = S[19] | S[0];

L_002b:
    /* +0x00408 op=0x5e 31 00 00 00 CALL_CF_INDEX: call native_binding[index=0x31] via q1 table runtime: CF100 format/crypto glue q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x31, (void *)(uintptr_t)0x125fd3c0);

L_002c:
    /* +0x00420 op=0x85 1e 15 50 00 ADD64_IMM16: s21 = s30 +0x50 */
    S[21] = S[30] + 0x50;

L_002d:
    /* +0x00438 op=0x85 1e 16 cc 00 ADD64_IMM16: s22 = s30 +0xcc */
    S[22] = S[30] + 0xcc;

L_002e:
    /* +0x00450 op=0x85 00 17 04 00 ADD64_IMM16: s23 = s0 +0x4 */
    S[23] = S[0] + 0x4;

L_002f:
    /* +0x00468 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0030:
    /* +0x00480 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0031:
    /* +0x00498 op=0x34 17 00 06 01 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_0032:
    /* +0x004b0 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_0033:
    /* +0x004c8 op=0x85 1e 11 68 00 ADD64_IMM16: s17 = s30 +0x68 */
    S[17] = S[30] + 0x68;

L_0034:
    /* +0x004e0 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0035:
    /* +0x004f8 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_0036:
    /* +0x00510 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0037:
    /* +0x00528 op=0x5e 1c 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1c] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1c, (void *)(uintptr_t)0x125fd3c0);

L_0038:
    /* +0x00540 op=0x85 1e 13 38 00 ADD64_IMM16: s19 = s30 +0x38 */
    S[19] = S[30] + 0x38;

L_0039:
    /* +0x00558 op=0x85 00 06 01 00 ADD64_IMM16: s6 = s0 +0x1 */
    S[6] = S[0] + 0x1;

L_003a:
    /* +0x00570 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_003b:
    /* +0x00588 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_003c:
    /* +0x005a0 op=0x5e 1b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x1b] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x1b, (void *)(uintptr_t)0x125fd3c0);

L_003d:
    /* +0x005b8 op=0x85 1e 14 80 00 ADD64_IMM16: s20 = s30 +0x80 */
    S[20] = S[30] + 0x80;

L_003e:
    /* +0x005d0 op=0x58 1e 05 38 00 LD64: s5 = *(uint64_t *)(s30 +0x38) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x38);

L_003f:
    /* +0x005e8 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0040:
    /* +0x00600 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_0041:
    /* +0x00618 op=0x34 13 00 04 00 OR64: s4 = s19 | s0 */
    S[4] = S[19] | S[0];

L_0042:
    /* +0x00630 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0043:
    /* +0x00648 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0044:
    /* +0x00660 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0045:
    /* +0x00678 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0046:
    /* +0x00690 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0047:
    /* +0x006a8 op=0x85 1e 15 68 00 ADD64_IMM16: s21 = s30 +0x68 */
    S[21] = S[30] + 0x68;

L_0048:
    /* +0x006c0 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0049:
    /* +0x006d8 op=0x34 17 00 06 01 OR64: s6 = s23 | s0 */
    S[6] = S[23] | S[0];

L_004a:
    /* +0x006f0 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_004b:
    /* +0x00708 op=0x5e 24 00 00 00 CALL_CF_INDEX: call native_binding[index=0x24] via q1 table runtime: CF38 initMemBlockBySrc q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x24, (void *)(uintptr_t)0x125fd3c0);

L_004c:
    /* +0x00720 op=0x85 1e 16 50 00 ADD64_IMM16: s22 = s30 +0x50 */
    S[22] = S[30] + 0x50;

L_004d:
    /* +0x00738 op=0x34 16 00 04 01 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_004e:
    /* +0x00750 op=0x5e 04 00 00 00 CALL_CF_INDEX: call native_binding[index=0x4] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x4, (void *)(uintptr_t)0x125fd3c0);

L_004f:
    /* +0x00768 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0050:
    /* +0x00780 op=0x34 16 00 05 00 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0051:
    /* +0x00798 op=0x34 14 00 06 01 OR64: s6 = s20 | s0 */
    S[6] = S[20] | S[0];

L_0052:
    /* +0x007b0 op=0x5e 32 00 00 00 CALL_CF_INDEX: call native_binding[index=0x32] via q1 table runtime: CF48 short flattened transform q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x32, (void *)(uintptr_t)0x125fd3c0);

L_0053:
    /* +0x007c8 op=0x34 15 00 04 01 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0054:
    /* +0x007e0 op=0x34 16 00 05 01 OR64: s5 = s22 | s0 */
    S[5] = S[22] | S[0];

L_0055:
    /* +0x007f8 op=0x5e 33 00 00 00 CALL_CF_INDEX: call native_binding[index=0x33] via q1 table runtime: CF49 concat transformed short block q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x33, (void *)(uintptr_t)0x125fd3c0);

L_0056:
    /* +0x00810 op=0x85 1e 11 28 00 ADD64_IMM16: s17 = s30 +0x28 */
    S[17] = S[30] + 0x28;

L_0057:
    /* +0x00828 op=0x34 15 00 05 01 OR64: s5 = s21 | s0 */
    S[5] = S[21] | S[0];

L_0058:
    /* +0x00840 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0059:
    /* +0x00858 op=0x5e 2b 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2b] via q1 table runtime: CF44 base64Encode q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2b, (void *)(uintptr_t)0x125fd3c0);

L_005a:
    /* +0x00870 op=0x85 1e 17 38 00 ADD64_IMM16: s23 = s30 +0x38 */
    S[23] = S[30] + 0x38;

L_005b:
    /* +0x00888 op=0x58 1e 05 28 00 LD64: s5 = *(uint64_t *)(s30 +0x28) */
    S[5] = *(uint64_t *)((uint8_t *)S[30] + 0x28);

L_005c:
    /* +0x008a0 op=0x34 17 00 04 01 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_005d:
    /* +0x008b8 op=0x5e 23 00 00 00 CALL_CF_INDEX: call native_binding[index=0x23] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x23, (void *)(uintptr_t)0x125fd3c0);

L_005e:
    /* +0x008d0 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_005f:
    /* +0x008e8 op=0x5e 0c 00 00 00 CALL_CF_INDEX: call native_binding[index=0xc] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0xc, (void *)(uintptr_t)0x125fd3c0);

L_0060:
    /* +0x00900 op=0x53 04 01 79 00 LD_POOL_PTR: s1 = *(uint64_t *)q1 + 0x79 q1=0x125fd408 */
    S[1] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x79;

L_0061:
    /* +0x00918 op=0x53 03 02 6d 00 LD_POOL_PTR: s2 = *(uint64_t *)q1 + 0x6d q1=0x125fd408 */
    S[2] = *(uint64_t *)(uintptr_t)0x125fd408 + 0x6d;

L_0062:
    /* +0x00930 op=0x85 00 11 03 00 ADD64_IMM16: s17 = s0 +0x3 */
    S[17] = S[0] + 0x3;

L_0063:
    /* +0x00948 op=0x85 1e 04 20 00 ADD64_IMM16: s4 = s30 +0x20 */
    S[4] = S[30] + 0x20;

L_0064:
    /* +0x00960 op=0x59 01 03 02 00 LD8U: s3 = *(uint8_t *)(s1 +0x2) */
    S[3] = *(uint8_t *)((uint8_t *)S[1] + 0x2);

L_0065:
    /* +0x00978 op=0x55 01 01 00 00 LD16U: s1 = *(uint16_t *)(s1 +0x0) */
    S[1] = *(uint16_t *)((uint8_t *)S[1] + 0x0);

L_0066:
    /* +0x00990 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0067:
    /* +0x009a8 op=0x26 1e 03 26 00 ST8: *(s30 +0x26) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[30] + 0x26) = (uint8_t)S[3];

L_0068:
    /* +0x009c0 op=0x19 1e 01 24 00 ST16: *(s30 +0x24) = (uint16_t)s1 */
    *(uint16_t *)((uint8_t *)S[30] + 0x24) = (uint16_t)S[1];

L_0069:
    /* +0x009d8 op=0x59 10 01 5e 01 LD8U: s1 = *(uint8_t *)(s16 +0x15e) */
    S[1] = *(uint8_t *)((uint8_t *)S[16] + 0x15e);

L_006a:
    /* +0x009f0 op=0x26 1e 01 22 00 ST8: *(s30 +0x22) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[30] + 0x22) = (uint8_t)S[1];

L_006b:
    /* +0x00a08 op=0x55 10 01 5c 01 LD16U: s1 = *(uint16_t *)(s16 +0x15c) */
    S[1] = *(uint16_t *)((uint8_t *)S[16] + 0x15c);

L_006c:
    /* +0x00a20 op=0x19 1e 01 20 00 ST16: *(s30 +0x20) = (uint16_t)s1 */
    *(uint16_t *)((uint8_t *)S[30] + 0x20) = (uint16_t)S[1];

L_006d:
    /* +0x00a38 op=0x58 02 01 00 00 LD64: s1 = *(uint64_t *)(s2 +0x0) */
    S[1] = *(uint64_t *)((uint8_t *)S[2] + 0x0);

L_006e:
    /* +0x00a50 op=0x59 02 02 08 00 LD8U: s2 = *(uint8_t *)(s2 +0x8) */
    S[2] = *(uint8_t *)((uint8_t *)S[2] + 0x8);

L_006f:
    /* +0x00a68 op=0x26 1e 02 30 00 ST8: *(s30 +0x30) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[30] + 0x30) = (uint8_t)S[2];

L_0070:
    /* +0x00a80 op=0x25 1e 01 28 00 ST64: *(s30 +0x28) = s1 */
    *(uint64_t *)((uint8_t *)S[30] + 0x28) = S[1];

L_0071:
    /* +0x00a98 op=0x5e 2f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2f] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2f, (void *)(uintptr_t)0x125fd3c0);

L_0072:
    /* +0x00ab0 op=0x85 1e 04 28 00 ADD64_IMM16: s4 = s30 +0x28 */
    S[4] = S[30] + 0x28;

L_0073:
    /* +0x00ac8 op=0x85 00 05 09 00 ADD64_IMM16: s5 = s0 +0x9 */
    S[5] = S[0] + 0x9;

L_0074:
    /* +0x00ae0 op=0x34 02 00 13 00 OR64: s19 = s2 | s0 */
    S[19] = S[2] | S[0];

L_0075:
    /* +0x00af8 op=0x5e 19 00 00 00 CALL_CF_INDEX: call native_binding[index=0x19] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x19, (void *)(uintptr_t)0x125fd3c0);

L_0076:
    /* +0x00b10 op=0x58 1e 04 10 00 LD64: s4 = *(uint64_t *)(s30 +0x10) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x10);

L_0077:
    /* +0x00b28 op=0x34 02 00 06 00 OR64: s6 = s2 | s0 */
    S[6] = S[2] | S[0];

L_0078:
    /* +0x00b40 op=0x34 13 00 05 01 OR64: s5 = s19 | s0 */
    S[5] = S[19] | S[0];

L_0079:
    /* +0x00b58 op=0x5e 2e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2e] via q1 table runtime: CF98 formatAllocString q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2e, (void *)(uintptr_t)0x125fd3c0);

L_007a:
    /* +0x00b70 op=0x85 1e 04 24 00 ADD64_IMM16: s4 = s30 +0x24 */
    S[4] = S[30] + 0x24;

L_007b:
    /* +0x00b88 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_007c:
    /* +0x00ba0 op=0x5e 20 00 00 00 CALL_CF_INDEX: call native_binding[index=0x20] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x20, (void *)(uintptr_t)0x125fd3c0);

L_007d:
    /* +0x00bb8 op=0x58 1e 06 48 00 LD64: s6 = *(uint64_t *)(s30 +0x48) */
    S[6] = *(uint64_t *)((uint8_t *)S[30] + 0x48);

L_007e:
    /* +0x00bd0 op=0x58 1e 04 18 00 LD64: s4 = *(uint64_t *)(s30 +0x18) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x18);

L_007f:
    /* +0x00be8 op=0x34 02 00 05 01 OR64: s5 = s2 | s0 */
    S[5] = S[2] | S[0];

L_0080:
    /* +0x00c00 op=0x5e 2e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x2e] via q1 table runtime: CF98 formatAllocString q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x2e, (void *)(uintptr_t)0x125fd3c0);

L_0081:
    /* +0x00c18 op=0x34 17 00 04 00 OR64: s4 = s23 | s0 */
    S[4] = S[23] | S[0];

L_0082:
    /* +0x00c30 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0083:
    /* +0x00c48 op=0x34 16 00 04 00 OR64: s4 = s22 | s0 */
    S[4] = S[22] | S[0];

L_0084:
    /* +0x00c60 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0085:
    /* +0x00c78 op=0x34 15 00 04 00 OR64: s4 = s21 | s0 */
    S[4] = S[21] | S[0];

L_0086:
    /* +0x00c90 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0087:
    /* +0x00ca8 op=0x34 14 00 04 01 OR64: s4 = s20 | s0 */
    S[4] = S[20] | S[0];

L_0088:
    /* +0x00cc0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_0089:
    /* +0x00cd8 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_008a:
    /* +0x00cf0 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_008b:
    /* +0x00d08 op=0x58 1e 04 08 00 LD64: s4 = *(uint64_t *)(s30 +0x8) */
    S[4] = *(uint64_t *)((uint8_t *)S[30] + 0x8);

L_008c:
    /* +0x00d20 op=0x5e 07 00 00 00 CALL_CF_INDEX: call native_binding[index=0x7] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x7, (void *)(uintptr_t)0x125fd3c0);

L_008d:
    /* +0x00d38 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_008e:
    /* +0x00d50 op=0x58 1d 10 d0 00 LD64: s16 = *(uint64_t *)(s29 +0xd0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0xd0);

L_008f:
    /* +0x00d68 op=0x58 1d 11 d8 00 LD64: s17 = *(uint64_t *)(s29 +0xd8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0xd8);

L_0090:
    /* +0x00d80 op=0x58 1d 12 e0 00 LD64: s18 = *(uint64_t *)(s29 +0xe0) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0xe0);

L_0091:
    /* +0x00d98 op=0x58 1d 13 e8 00 LD64: s19 = *(uint64_t *)(s29 +0xe8) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0xe8);

L_0092:
    /* +0x00db0 op=0x58 1d 14 f0 00 LD64: s20 = *(uint64_t *)(s29 +0xf0) */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0xf0);

L_0093:
    /* +0x00dc8 op=0x58 1d 15 f8 00 LD64: s21 = *(uint64_t *)(s29 +0xf8) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0xf8);

L_0094:
    /* +0x00de0 op=0x58 1d 16 00 01 LD64: s22 = *(uint64_t *)(s29 +0x100) */
    S[22] = *(uint64_t *)((uint8_t *)S[29] + 0x100);

L_0095:
    /* +0x00df8 op=0x58 1d 17 08 01 LD64: s23 = *(uint64_t *)(s29 +0x108) */
    S[23] = *(uint64_t *)((uint8_t *)S[29] + 0x108);

L_0096:
    /* +0x00e10 op=0x58 1d 1e 10 01 LD64: s30 = *(uint64_t *)(s29 +0x110) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x110);

L_0097:
    /* +0x00e28 op=0x58 1d 1f 18 01 LD64: s31 = *(uint64_t *)(s29 +0x118) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x118);

L_0098:
    /* +0x00e40 op=0x85 1d 1d 20 01 ADD64_IMM16: s29 = s29 +0x120 */
    S[29] = S[29] + 0x120;

L_0099:
    /* +0x00e58 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

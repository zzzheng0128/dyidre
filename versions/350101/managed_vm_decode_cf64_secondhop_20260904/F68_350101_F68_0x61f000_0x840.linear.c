/*
 * Auto-generated linear C-like lift for 350.101 managed program F68.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_secondhop_bodies_20260904/350101_F68_0x61f000_0x840.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F68_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d e0 ff ADD64_IMM16: s29 = s29 -0x20 */
    S[29] = S[29] + (-0x20);

L_0001:
    /* +0x00018 op=0x25 1d 1f 18 00 ST64: *(s29 +0x18) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 10 00 ST64: *(s29 +0x10) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 11 08 00 ST64: *(s29 +0x8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[17];

L_0004:
    /* +0x00060 op=0x25 1d 10 00 00 ST64: *(s29 +0x0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[16];

L_0005:
    /* +0x00078 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0006:
    /* +0x00090 op=0x52 04 03 60 00 LD32S: s3 = *(int32_t *)(s4 +0x60) */
    S[3] = *(int32_t *)((uint8_t *)S[4] + 0x60);

L_0007:
    /* +0x000a8 op=0xb5 00 02 80 00 ADD32_IMM16: s2 = int32(s0 +0x80) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x80);

L_0008:
    /* +0x000c0 op=0x34 04 00 10 00 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_0009:
    /* +0x000d8 op=0x6d 00 03 01 00 SHL64_IMM32PLUS: s1 = s3 << (0 + 32) */
    S[1] = S[3] << (0 + 32);

L_000a:
    /* +0x000f0 op=0x67 00 01 01 00 LSR64_IMM32PLUS: s1 = (uint64_t)s1 >> (0 + 32) */
    S[1] = (uint64_t)S[1] >> (0 + 32);

L_000b:
    /* +0x00108 op=0x84 04 01 01 00 ADD64: s1 = s4 + s1 */
    S[1] = S[4] + S[1];

L_000c:
    /* +0x00120 op=0x26 01 02 00 00 ST8: *(s1 +0x0) = (uint8_t)s2 */
    *(uint8_t *)((uint8_t *)S[1] + 0x0) = (uint8_t)S[2];

L_000d:
    /* +0x00138 op=0xb5 03 02 01 00 ADD32_IMM16: s2 = int32(s3 +0x1) */
    S[2] = (int32_t)((uint32_t)S[3] + 0x1);

L_000e:
    /* +0x00150 op=0x14 02 01 21 00 CMP_LO_IMM64: s1 = ((uint64_t)s2 < (uint64_t)33) ? 1 : 0 */
    S[1] = ((uint64_t)S[2] < (uint64_t)0x21) ? 1 : 0;

L_000f:
    /* +0x00168 op=0xa7 01 00 0c 00 BR_NE64: if (s1 != s0) goto record +28 */
    if (S[1] != S[0]) goto L_001c;

L_0010:
    /* +0x00180 op=0x6d 00 02 01 00 SHL64_IMM32PLUS: s1 = s2 << (0 + 32) */
    S[1] = S[2] << (0 + 32);

L_0011:
    /* +0x00198 op=0x85 00 05 00 00 ADD64_IMM16: s5 = s0 +0x0 */
    S[5] = S[0] + 0x0;

L_0012:
    /* +0x001b0 op=0x67 00 01 01 00 LSR64_IMM32PLUS: s1 = (uint64_t)s1 >> (0 + 32) */
    S[1] = (uint64_t)S[1] >> (0 + 32);

L_0013:
    /* +0x001c8 op=0x84 10 01 04 04 ADD64: s4 = s16 + s1 */
    S[4] = S[16] + S[1];

L_0014:
    /* +0x001e0 op=0xb5 00 01 3f 00 ADD32_IMM16: s1 = int32(s0 +0x3f) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x3f);

L_0015:
    /* +0x001f8 op=0x09 01 03 01 00 SUB32: s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s3) */
    S[1] = (int32_t)((uint32_t)S[1] - (uint32_t)S[3]);

L_0016:
    /* +0x00210 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) */
    S[1] = S[1] << (0 + 32);

L_0017:
    /* +0x00228 op=0x67 00 01 06 00 LSR64_IMM32PLUS: s6 = (uint64_t)s1 >> (0 + 32) */
    S[6] = (uint64_t)S[1] >> (0 + 32);

L_0018:
    /* +0x00240 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0019:
    /* +0x00258 op=0x34 10 00 04 00 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_001a:
    /* +0x00270 op=0x5e 68 00 00 00 CALL_CF_INDEX: call native_binding[index=0x68] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x68, (void *)(uintptr_t)0x125fd360);

L_001b:
    /* +0x00288 op=0xb5 00 02 00 00 ADD32_IMM16: s2 = int32(s0 +0x0) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x0);

L_001c:
    /* +0x002a0 op=0x6d 00 02 01 00 SHL64_IMM32PLUS: s1 = s2 << (0 + 32) */
    S[1] = S[2] << (0 + 32);

L_001d:
    /* +0x002b8 op=0x85 00 11 00 00 ADD64_IMM16: s17 = s0 +0x0 */
    S[17] = S[0] + 0x0;

L_001e:
    /* +0x002d0 op=0x67 00 01 01 00 LSR64_IMM32PLUS: s1 = (uint64_t)s1 >> (0 + 32) */
    S[1] = (uint64_t)S[1] >> (0 + 32);

L_001f:
    /* +0x002e8 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0020:
    /* +0x00300 op=0x84 10 01 04 04 ADD64: s4 = s16 + s1 */
    S[4] = S[16] + S[1];

L_0021:
    /* +0x00318 op=0xb5 00 01 20 00 ADD32_IMM16: s1 = int32(s0 +0x20) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x20);

L_0022:
    /* +0x00330 op=0x09 01 02 01 14 SUB32: s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s2) */
    S[1] = (int32_t)((uint32_t)S[1] - (uint32_t)S[2]);

L_0023:
    /* +0x00348 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) */
    S[1] = S[1] << (0 + 32);

L_0024:
    /* +0x00360 op=0x67 00 01 06 00 LSR64_IMM32PLUS: s6 = (uint64_t)s1 >> (0 + 32) */
    S[6] = (uint64_t)S[1] >> (0 + 32);

L_0025:
    /* +0x00378 op=0x5e 0b 00 00 00 CALL_CF_INDEX: call native_binding[index=0xb] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xb, (void *)(uintptr_t)0x125fd360);

L_0026:
    /* +0x00390 op=0x52 10 02 60 00 LD32S: s2 = *(int32_t *)(s16 +0x60) */
    S[2] = *(int32_t *)((uint8_t *)S[16] + 0x60);

L_0027:
    /* +0x003a8 op=0x58 10 01 58 00 LD64: s1 = *(uint64_t *)(s16 +0x58) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x58);

L_0028:
    /* +0x003c0 op=0x18 11 02 02 03 SHL32_IMM: s2 = (int32_t)(s2 << 3) */
    S[2] = (int32_t)((uint32_t)S[2] << 3);

L_0029:
    /* +0x003d8 op=0x6d 00 02 02 00 SHL64_IMM32PLUS: s2 = s2 << (0 + 32) */
    S[2] = S[2] << (0 + 32);

L_002a:
    /* +0x003f0 op=0x67 00 02 02 00 LSR64_IMM32PLUS: s2 = (uint64_t)s2 >> (0 + 32) */
    S[2] = (uint64_t)S[2] >> (0 + 32);

L_002b:
    /* +0x00408 op=0x84 01 02 02 00 ADD64: s2 = s1 + s2 */
    S[2] = S[1] + S[2];

L_002c:
    /* +0x00420 op=0x13 02 01 01 00 CMP_LO64: s1 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0 */
    S[1] = ((uint64_t)S[2] < (uint64_t)S[1]) ? 1 : 0;

L_002d:
    /* +0x00438 op=0x25 10 02 58 00 ST64: *(s16 +0x58) = s2 */
    *(uint64_t *)((uint8_t *)S[16] + 0x58) = S[2];

L_002e:
    /* +0x00450 op=0xae 01 00 0b 00 BR_EQ64: if (s1 == s0) goto record +58 */
    if (S[1] == S[0]) goto L_003a;

L_002f:
    /* +0x00468 op=0x58 10 01 50 00 LD64: s1 = *(uint64_t *)(s16 +0x50) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x50);

L_0030:
    /* +0x00480 op=0x85 01 01 01 00 ADD64_IMM16: s1 = s1 +0x1 */
    S[1] = S[1] + 0x1;

L_0031:
    /* +0x00498 op=0x25 10 01 50 00 ST64: *(s16 +0x50) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0x50) = S[1];

L_0032:
    /* +0x004b0 op=0xa7 01 00 07 00 BR_NE64: if (s1 != s0) goto record +58 */
    if (S[1] != S[0]) goto L_003a;

L_0033:
    /* +0x004c8 op=0x58 10 01 48 00 LD64: s1 = *(uint64_t *)(s16 +0x48) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x48);

L_0034:
    /* +0x004e0 op=0x85 01 01 01 00 ADD64_IMM16: s1 = s1 +0x1 */
    S[1] = S[1] + 0x1;

L_0035:
    /* +0x004f8 op=0x25 10 01 48 00 ST64: *(s16 +0x48) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0x48) = S[1];

L_0036:
    /* +0x00510 op=0xa7 01 00 03 00 BR_NE64: if (s1 != s0) goto record +58 */
    if (S[1] != S[0]) goto L_003a;

L_0037:
    /* +0x00528 op=0x58 10 01 40 00 LD64: s1 = *(uint64_t *)(s16 +0x40) */
    S[1] = *(uint64_t *)((uint8_t *)S[16] + 0x40);

L_0038:
    /* +0x00540 op=0x85 01 01 01 00 ADD64_IMM16: s1 = s1 +0x1 */
    S[1] = S[1] + 0x1;

L_0039:
    /* +0x00558 op=0x25 10 01 40 00 ST64: *(s16 +0x40) = s1 */
    *(uint64_t *)((uint8_t *)S[16] + 0x40) = S[1];

L_003a:
    /* +0x00570 op=0x85 00 02 20 00 ADD64_IMM16: s2 = s0 +0x20 */
    S[2] = S[0] + 0x20;

L_003b:
    /* +0x00588 op=0xae 11 02 13 00 BR_EQ64: if (s17 == s2) goto record +79 */
    if (S[17] == S[2]) goto L_004f;

L_003c:
    /* +0x005a0 op=0x84 10 11 01 04 ADD64: s1 = s16 + s17 */
    S[1] = S[16] + S[17];

L_003d:
    /* +0x005b8 op=0x85 11 11 08 00 ADD64_IMM16: s17 = s17 +0x8 */
    S[17] = S[17] + 0x8;

L_003e:
    /* +0x005d0 op=0x58 01 03 40 00 LD64: s3 = *(uint64_t *)(s1 +0x40) */
    S[3] = *(uint64_t *)((uint8_t *)S[1] + 0x40);

L_003f:
    /* +0x005e8 op=0x67 00 03 04 00 LSR64_IMM32PLUS: s4 = (uint64_t)s3 >> (0 + 32) */
    S[4] = (uint64_t)S[3] >> (0 + 32);

L_0040:
    /* +0x00600 op=0x26 01 04 23 00 ST8: *(s1 +0x23) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x23) = (uint8_t)S[4];

L_0041:
    /* +0x00618 op=0x67 00 03 04 08 LSR64_IMM32PLUS: s4 = (uint64_t)s3 >> (8 + 32) */
    S[4] = (uint64_t)S[3] >> (8 + 32);

L_0042:
    /* +0x00630 op=0x26 01 04 22 00 ST8: *(s1 +0x22) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x22) = (uint8_t)S[4];

L_0043:
    /* +0x00648 op=0x67 00 03 04 10 LSR64_IMM32PLUS: s4 = (uint64_t)s3 >> (16 + 32) */
    S[4] = (uint64_t)S[3] >> (16 + 32);

L_0044:
    /* +0x00660 op=0x26 01 04 21 00 ST8: *(s1 +0x21) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x21) = (uint8_t)S[4];

L_0045:
    /* +0x00678 op=0x67 00 03 04 18 LSR64_IMM32PLUS: s4 = (uint64_t)s3 >> (24 + 32) */
    S[4] = (uint64_t)S[3] >> (24 + 32);

L_0046:
    /* +0x00690 op=0x26 01 04 20 00 ST8: *(s1 +0x20) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x20) = (uint8_t)S[4];

L_0047:
    /* +0x006a8 op=0x68 13 03 04 08 LSR64_IMM: s4 = (uint64_t)s3 >> 8 */
    S[4] = (uint64_t)S[3] >> 8;

L_0048:
    /* +0x006c0 op=0x26 01 03 27 00 ST8: *(s1 +0x27) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[1] + 0x27) = (uint8_t)S[3];

L_0049:
    /* +0x006d8 op=0x26 01 04 26 00 ST8: *(s1 +0x26) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x26) = (uint8_t)S[4];

L_004a:
    /* +0x006f0 op=0x68 00 03 04 10 LSR64_IMM: s4 = (uint64_t)s3 >> 16 */
    S[4] = (uint64_t)S[3] >> 16;

L_004b:
    /* +0x00708 op=0x68 03 03 03 18 LSR64_IMM: s3 = (uint64_t)s3 >> 24 */
    S[3] = (uint64_t)S[3] >> 24;

L_004c:
    /* +0x00720 op=0x26 01 04 25 00 ST8: *(s1 +0x25) = (uint8_t)s4 */
    *(uint8_t *)((uint8_t *)S[1] + 0x25) = (uint8_t)S[4];

L_004d:
    /* +0x00738 op=0x26 01 03 24 00 ST8: *(s1 +0x24) = (uint8_t)s3 */
    *(uint8_t *)((uint8_t *)S[1] + 0x24) = (uint8_t)S[3];

L_004e:
    /* +0x00750 op=0xa7 11 02 ed ff BR_NE64: if (s17 != s2) goto record +60 */
    if (S[17] != S[2]) goto L_003c;

L_004f:
    /* +0x00768 op=0x34 10 00 04 01 OR64: s4 = s16 | s0 */
    S[4] = S[16] | S[0];

L_0050:
    /* +0x00780 op=0x5e 68 00 00 00 CALL_CF_INDEX: call native_binding[index=0x68] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0x68, (void *)(uintptr_t)0x125fd360);

L_0051:
    /* +0x00798 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0052:
    /* +0x007b0 op=0x58 1d 10 00 00 LD64: s16 = *(uint64_t *)(s29 +0x0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_0053:
    /* +0x007c8 op=0x58 1d 11 08 00 LD64: s17 = *(uint64_t *)(s29 +0x8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0054:
    /* +0x007e0 op=0x58 1d 1e 10 00 LD64: s30 = *(uint64_t *)(s29 +0x10) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0055:
    /* +0x007f8 op=0x58 1d 1f 18 00 LD64: s31 = *(uint64_t *)(s29 +0x18) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_0056:
    /* +0x00810 op=0x85 1d 1d 20 00 ADD64_IMM16: s29 = s29 +0x20 */
    S[29] = S[29] + 0x20;

L_0057:
    /* +0x00828 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

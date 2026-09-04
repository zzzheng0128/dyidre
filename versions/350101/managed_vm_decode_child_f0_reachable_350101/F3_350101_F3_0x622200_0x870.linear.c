/*
 * Auto-generated linear C-like lift for 350.101 managed program F3.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F3_0x622200_0x870.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F3_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d d0 ff ADD64_IMM16: s29 = s29 -0x30 */
    S[29] = S[29] + (-0x30);

L_0001:
    /* +0x00018 op=0x25 1d 1f 28 00 ST64: *(s29 +0x28) = s31 q1=0x314604 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 20 00 ST64: *(s29 +0x20) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 11 18 00 ST64: *(s29 +0x18) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[17];

L_0004:
    /* +0x00060 op=0x25 1d 10 10 00 ST64: *(s29 +0x10) = s16 q1=0x69 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[16];

L_0005:
    /* +0x00078 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0006:
    /* +0x00090 op=0x52 04 01 00 00 LD32S: s1 = *(int32_t *)(s4 +0x0) q1=0x344604 */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_0007:
    /* +0x000a8 op=0x34 04 00 11 00 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_0008:
    /* +0x000c0 op=0xb5 00 04 7c 00 ADD32_IMM16: s4 = int32(s0 +0x7c) */
    S[4] = (int32_t)((uint32_t)S[0] + 0x7c);

L_0009:
    /* +0x000d8 op=0x34 05 00 10 01 OR64: s16 = s5 | s0 q1=0x6c */
    S[16] = S[5] | S[0];

L_000a:
    /* +0x000f0 op=0x53 03 05 21 00 LD_POOL_PTR: s5 = *(uint64_t *)q1 + 0x21 q1=0x125fd468 */
    S[5] = *(uint64_t *)(uintptr_t)0x125fd468 + 0x21;

L_000b:
    /* +0x00108 op=0xb2 01 02 3f 00 AND64_IMM16: s2 = s1 & 0x3f q1=0x374604 */
    S[2] = S[1] & 0x3f;

L_000c:
    /* +0x00120 op=0x18 00 01 01 03 SHL32_IMM: s1 = (int32_t)(s1 << 3) */
    S[1] = (int32_t)((uint32_t)S[1] << 3);

L_000d:
    /* +0x00138 op=0x14 02 03 3c 00 CMP_LO_IMM64: s3 = ((uint64_t)s2 < (uint64_t)60) ? 1 : 0 */
    S[3] = ((uint64_t)S[2] < (uint64_t)0x3c) ? 1 : 0;

L_000e:
    /* +0x00150 op=0x08 1e 01 08 00 ST32: *(s30 +0x8) = (uint32_t)s1 q1=0x690000006f */
    *(uint32_t *)((uint8_t *)S[30] + 0x8) = (uint32_t)S[1];

L_000f:
    /* +0x00168 op=0x1f 04 03 01 00 CMOVZ64: s1 = (s3 == 0) ? s4 : 0 */
    S[1] = (S[3] == 0) ? S[4] : 0;

L_0010:
    /* +0x00180 op=0xb5 00 04 3c 00 ADD32_IMM16: s4 = int32(s0 +0x3c) q1=0x30314606 */
    S[4] = (int32_t)((uint32_t)S[0] + 0x3c);

L_0011:
    /* +0x00198 op=0x1e 04 03 03 00 CMOVNZ64: s3 = (s3 != 0) ? s4 : 0 */
    S[3] = (S[3] != 0) ? S[4] : 0;

L_0012:
    /* +0x001b0 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0013:
    /* +0x001c8 op=0x34 03 01 01 01 OR64: s1 = s3 | s1 q1=0x72 */
    S[1] = S[3] | S[1];

L_0014:
    /* +0x001e0 op=0x09 01 02 01 14 SUB32: s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s2) */
    S[1] = (int32_t)((uint32_t)S[1] - (uint32_t)S[2]);

L_0015:
    /* +0x001f8 op=0x6d 00 01 01 00 SHL64_IMM32PLUS: s1 = s1 << (0 + 32) q1=0x38314606 */
    S[1] = S[1] << (0 + 32);

L_0016:
    /* +0x00210 op=0x67 00 01 06 00 LSR64_IMM32PLUS: s6 = (uint64_t)s1 >> (0 + 32) */
    S[6] = (uint64_t)S[1] >> (0 + 32);

L_0017:
    /* +0x00228 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd420);

L_0018:
    /* +0x00240 op=0x85 1e 05 08 00 ADD64_IMM16: s5 = s30 +0x8 q1=0x75 */
    S[5] = S[30] + 0x8;

L_0019:
    /* +0x00258 op=0x85 00 06 04 00 ADD64_IMM16: s6 = s0 +0x4 */
    S[6] = S[0] + 0x4;

L_001a:
    /* +0x00270 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 q1=0x39314606 */
    S[4] = S[17] | S[0];

L_001b:
    /* +0x00288 op=0x5e 13 00 00 00 CALL_CF_INDEX: call native_binding[index=0x13] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x13, (void *)(uintptr_t)0x125fd420);

L_001c:
    /* +0x002a0 op=0x54 05 02 9b e1 CONST_HI16: s2 = sign_extend_32(0xe19b << 16) */
    S[2] = (int32_t)(0xe19b << 16);

L_001d:
    /* +0x002b8 op=0x52 11 05 10 00 LD32S: s5 = *(int32_t *)(s17 +0x10) q1=0x78 */
    S[5] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_001e:
    /* +0x002d0 op=0x54 02 01 d1 71 CONST_HI16: s1 = sign_extend_32(0x71d1 << 16) */
    S[1] = (int32_t)(0x71d1 << 16);

L_001f:
    /* +0x002e8 op=0x54 05 03 59 e8 CONST_HI16: s3 = sign_extend_32(0xe859 << 16) q1=0x35314606 */
    S[3] = (int32_t)(0xe859 << 16);

L_0020:
    /* +0x00300 op=0x54 00 04 be 19 CONST_HI16: s4 = sign_extend_32(0x19be << 16) */
    S[4] = (int32_t)(0x19be << 16);

L_0021:
    /* +0x00318 op=0x33 02 02 6e 32 OR_IMM16: s2 = s2 | 0x326e */
    S[2] = S[2] | 0x326e;

L_0022:
    /* +0x00330 op=0x33 01 01 d4 d7 OR_IMM16: s1 = s1 | 0xd7d4 q1=0x7b */
    S[1] = S[1] | 0xd7d4;

L_0023:
    /* +0x00348 op=0x33 03 03 b4 86 OR_IMM16: s3 = s3 | 0x86b4 */
    S[3] = S[3] | 0x86b4;

L_0024:
    /* +0x00360 op=0x33 04 04 66 48 OR_IMM16: s4 = s4 | 0x4866 q1=0x32324606 */
    S[4] = S[4] | 0x4866;

L_0025:
    /* +0x00378 op=0x02 05 02 02 01 XOR64: s2 = s2 ^ s5 */
    S[2] = S[2] ^ S[5];

L_0026:
    /* +0x00390 op=0x52 11 05 14 00 LD32S: s5 = *(int32_t *)(s17 +0x14) */
    S[5] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_0027:
    /* +0x003a8 op=0x08 11 02 10 00 ST32: *(s17 +0x10) = (uint32_t)s2 q1=0x7e */
    *(uint32_t *)((uint8_t *)S[17] + 0x10) = (uint32_t)S[2];

L_0028:
    /* +0x003c0 op=0x02 05 01 01 00 XOR64: s1 = s1 ^ s5 */
    S[1] = S[1] ^ S[5];

L_0029:
    /* +0x003d8 op=0x08 11 01 14 00 ST32: *(s17 +0x14) = (uint32_t)s1 q1=0x32334606 */
    *(uint32_t *)((uint8_t *)S[17] + 0x14) = (uint32_t)S[1];

L_002a:
    /* +0x003f0 op=0x52 11 01 0c 00 LD32S: s1 = *(int32_t *)(s17 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_002b:
    /* +0x00408 op=0x02 01 03 01 01 XOR64: s1 = s3 ^ s1 */
    S[1] = S[3] ^ S[1];

L_002c:
    /* +0x00420 op=0x08 11 01 0c 00 ST32: *(s17 +0xc) = (uint32_t)s1 q1=0x6e00000081 */
    *(uint32_t *)((uint8_t *)S[17] + 0xc) = (uint32_t)S[1];

L_002d:
    /* +0x00438 op=0x52 11 01 08 00 LD32S: s1 = *(int32_t *)(s17 +0x8) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x8);

L_002e:
    /* +0x00450 op=0x02 01 04 01 01 XOR64: s1 = s4 ^ s1 q1=0x37344606 */
    S[1] = S[4] ^ S[1];

L_002f:
    /* +0x00468 op=0x08 11 01 08 00 ST32: *(s17 +0x8) = (uint32_t)s1 */
    *(uint32_t *)((uint8_t *)S[17] + 0x8) = (uint32_t)S[1];

L_0030:
    /* +0x00480 op=0x26 10 01 00 00 ST8: *(s16 +0x0) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x0) = (uint8_t)S[1];

L_0031:
    /* +0x00498 op=0x52 11 01 08 00 LD32S: s1 = *(int32_t *)(s17 +0x8) q1=0x84 */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x8);

L_0032:
    /* +0x004b0 op=0x0e 00 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_0033:
    /* +0x004c8 op=0x26 10 01 01 00 ST8: *(s16 +0x1) = (uint8_t)s1 q1=0x35324606 */
    *(uint8_t *)((uint8_t *)S[16] + 0x1) = (uint8_t)S[1];

L_0034:
    /* +0x004e0 op=0x55 11 01 0a 00 LD16U: s1 = *(uint16_t *)(s17 +0xa) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0xa);

L_0035:
    /* +0x004f8 op=0x26 10 01 02 00 ST8: *(s16 +0x2) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x2) = (uint8_t)S[1];

L_0036:
    /* +0x00510 op=0x59 11 01 0b 00 LD8U: s1 = *(uint8_t *)(s17 +0xb) q1=0x87 */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0xb);

L_0037:
    /* +0x00528 op=0x26 10 01 03 00 ST8: *(s16 +0x3) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x3) = (uint8_t)S[1];

L_0038:
    /* +0x00540 op=0x52 11 01 0c 00 LD32S: s1 = *(int32_t *)(s17 +0xc) q1=0x38324606 */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_0039:
    /* +0x00558 op=0x26 10 01 04 00 ST8: *(s16 +0x4) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x4) = (uint8_t)S[1];

L_003a:
    /* +0x00570 op=0x52 11 01 0c 00 LD32S: s1 = *(int32_t *)(s17 +0xc) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0xc);

L_003b:
    /* +0x00588 op=0x0e 0b 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) q1=0x8a */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_003c:
    /* +0x005a0 op=0x26 10 01 05 00 ST8: *(s16 +0x5) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x5) = (uint8_t)S[1];

L_003d:
    /* +0x005b8 op=0x55 11 01 0e 00 LD16U: s1 = *(uint16_t *)(s17 +0xe) q1=0x33334606 */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0xe);

L_003e:
    /* +0x005d0 op=0x26 10 01 06 00 ST8: *(s16 +0x6) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x6) = (uint8_t)S[1];

L_003f:
    /* +0x005e8 op=0x59 11 01 0f 00 LD8U: s1 = *(uint8_t *)(s17 +0xf) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0xf);

L_0040:
    /* +0x00600 op=0x26 10 01 07 00 ST8: *(s16 +0x7) = (uint8_t)s1 q1=0x8d */
    *(uint8_t *)((uint8_t *)S[16] + 0x7) = (uint8_t)S[1];

L_0041:
    /* +0x00618 op=0x52 11 01 10 00 LD32S: s1 = *(int32_t *)(s17 +0x10) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_0042:
    /* +0x00630 op=0x26 10 01 08 00 ST8: *(s16 +0x8) = (uint8_t)s1 q1=0x36334606 */
    *(uint8_t *)((uint8_t *)S[16] + 0x8) = (uint8_t)S[1];

L_0043:
    /* +0x00648 op=0x52 11 01 10 00 LD32S: s1 = *(int32_t *)(s17 +0x10) */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x10);

L_0044:
    /* +0x00660 op=0x0e 0d 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_0045:
    /* +0x00678 op=0x26 10 01 09 00 ST8: *(s16 +0x9) = (uint8_t)s1 q1=0x90 */
    *(uint8_t *)((uint8_t *)S[16] + 0x9) = (uint8_t)S[1];

L_0046:
    /* +0x00690 op=0x55 11 01 12 00 LD16U: s1 = *(uint16_t *)(s17 +0x12) */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0x12);

L_0047:
    /* +0x006a8 op=0x26 10 01 0a 00 ST8: *(s16 +0xa) = (uint8_t)s1 q1=0x31344606 */
    *(uint8_t *)((uint8_t *)S[16] + 0xa) = (uint8_t)S[1];

L_0048:
    /* +0x006c0 op=0x59 11 01 13 00 LD8U: s1 = *(uint8_t *)(s17 +0x13) */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0x13);

L_0049:
    /* +0x006d8 op=0x26 10 01 0b 00 ST8: *(s16 +0xb) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xb) = (uint8_t)S[1];

L_004a:
    /* +0x006f0 op=0x52 11 01 14 00 LD32S: s1 = *(int32_t *)(s17 +0x14) q1=0x7300000093 */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_004b:
    /* +0x00708 op=0x26 10 01 0c 00 ST8: *(s16 +0xc) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xc) = (uint8_t)S[1];

L_004c:
    /* +0x00720 op=0x52 11 01 14 00 LD32S: s1 = *(int32_t *)(s17 +0x14) q1=0x34344606 */
    S[1] = *(int32_t *)((uint8_t *)S[17] + 0x14);

L_004d:
    /* +0x00738 op=0x0e 0b 01 01 08 LSR32_IMM: s1 = sign_extend_32((uint32_t)s1 >> 8) */
    S[1] = (int32_t)((uint32_t)S[1] >> 8);

L_004e:
    /* +0x00750 op=0x26 10 01 0d 00 ST8: *(s16 +0xd) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xd) = (uint8_t)S[1];

L_004f:
    /* +0x00768 op=0x55 11 01 16 00 LD16U: s1 = *(uint16_t *)(s17 +0x16) q1=0x96 */
    S[1] = *(uint16_t *)((uint8_t *)S[17] + 0x16);

L_0050:
    /* +0x00780 op=0x26 10 01 0e 00 ST8: *(s16 +0xe) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xe) = (uint8_t)S[1];

L_0051:
    /* +0x00798 op=0x59 11 01 17 00 LD8U: s1 = *(uint8_t *)(s17 +0x17) q1=0x39344606 */
    S[1] = *(uint8_t *)((uint8_t *)S[17] + 0x17);

L_0052:
    /* +0x007b0 op=0x26 10 01 0f 00 ST8: *(s16 +0xf) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0xf) = (uint8_t)S[1];

L_0053:
    /* +0x007c8 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0054:
    /* +0x007e0 op=0x58 1d 10 10 00 LD64: s16 = *(uint64_t *)(s29 +0x10) q1=0x99 */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0055:
    /* +0x007f8 op=0x58 1d 11 18 00 LD64: s17 = *(uint64_t *)(s29 +0x18) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_0056:
    /* +0x00810 op=0x58 1d 1e 20 00 LD64: s30 = *(uint64_t *)(s29 +0x20) q1=0x32354606 */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_0057:
    /* +0x00828 op=0x58 1d 1f 28 00 LD64: s31 = *(uint64_t *)(s29 +0x28) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_0058:
    /* +0x00840 op=0x85 1d 1d 30 00 ADD64_IMM16: s29 = s29 +0x30 */
    S[29] = S[29] + 0x30;

L_0059:
    /* +0x00858 op=0x5b 1f 00 00 00 RET: return/leave with s31 q1=0x9c */
    return; /* RET s31 */

}

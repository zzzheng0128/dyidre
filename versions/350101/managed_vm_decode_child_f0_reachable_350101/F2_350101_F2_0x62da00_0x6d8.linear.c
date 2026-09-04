/*
 * Auto-generated linear C-like lift for 350.101 managed program F2.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_child_f0_reachable_20260904/350101_F2_0x62da00_0x6d8.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F2_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d c0 ff ADD64_IMM16: s29 = s29 -0x40 */
    S[29] = S[29] + (-0x40);

L_0001:
    /* +0x00018 op=0x25 1d 1f 38 00 ST64: *(s29 +0x38) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x38) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 30 00 ST64: *(s29 +0x30) = s30 q1=0x324604 */
    *(uint64_t *)((uint8_t *)S[29] + 0x30) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 15 28 00 ST64: *(s29 +0x28) = s21 q1=0x6900000000 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[21];

L_0004:
    /* +0x00060 op=0x25 1d 14 20 00 ST64: *(s29 +0x20) = s20 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[20];

L_0005:
    /* +0x00078 op=0x25 1d 13 18 00 ST64: *(s29 +0x18) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[19];

L_0006:
    /* +0x00090 op=0x25 1d 12 10 00 ST64: *(s29 +0x10) = s18 q1=0x354604 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[18];

L_0007:
    /* +0x000a8 op=0x25 1d 11 08 00 ST64: *(s29 +0x8) = s17 q1=0x6c00000000 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[17];

L_0008:
    /* +0x000c0 op=0x25 1d 10 00 00 ST64: *(s29 +0x0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[16];

L_0009:
    /* +0x000d8 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_000a:
    /* +0x000f0 op=0xae 06 00 33 00 BR_EQ64: if (s6 == s0) goto record +62 q1=0x384604 */
    if (S[6] == S[0]) goto L_003e;

L_000b:
    /* +0x00108 op=0x34 06 00 10 01 OR64: s16 = s6 | s0 q1=0x6f00000000 */
    S[16] = S[6] | S[0];

L_000c:
    /* +0x00120 op=0x52 04 01 00 00 LD32S: s1 = *(int32_t *)(s4 +0x0) */
    S[1] = *(int32_t *)((uint8_t *)S[4] + 0x0);

L_000d:
    /* +0x00138 op=0x34 04 00 12 01 OR64: s18 = s4 | s0 */
    S[18] = S[4] | S[0];

L_000e:
    /* +0x00150 op=0x34 05 00 11 01 OR64: s17 = s5 | s0 q1=0x31314606 */
    S[17] = S[5] | S[0];

L_000f:
    /* +0x00168 op=0x18 10 10 02 00 SHL32_IMM: s2 = (int32_t)(s16 << 0) q1=0x7200000000 */
    S[2] = (int32_t)((uint32_t)S[16] << 0);

L_0010:
    /* +0x00180 op=0xb4 01 02 02 12 ADD32: s2 = int32(s1 + s2) */
    S[2] = (int32_t)((uint32_t)S[1] + (uint32_t)S[2]);

L_0011:
    /* +0x00198 op=0x08 04 02 00 00 ST32: *(s4 +0x0) = (uint32_t)s2 */
    *(uint32_t *)((uint8_t *)S[4] + 0x0) = (uint32_t)S[2];

L_0012:
    /* +0x001b0 op=0x13 02 01 04 0f CMP_LO64: s4 = ((uint64_t)s2 < (uint64_t)s1) ? 1 : 0 q1=0x30324606 */
    S[4] = ((uint64_t)S[2] < (uint64_t)S[1]) ? 1 : 0;

L_0013:
    /* +0x001c8 op=0xb2 01 02 3f 00 AND64_IMM16: s2 = s1 & 0x3f q1=0x7500000000 */
    S[2] = S[1] & 0x3f;

L_0014:
    /* +0x001e0 op=0xb5 00 01 40 00 ADD32_IMM16: s1 = int32(s0 +0x40) */
    S[1] = (int32_t)((uint32_t)S[0] + 0x40);

L_0015:
    /* +0x001f8 op=0x09 01 02 01 04 SUB32: s1 = sign_extend_32((uint32_t)s1 - (uint32_t)s2) */
    S[1] = (int32_t)((uint32_t)S[1] - (uint32_t)S[2]);

L_0016:
    /* +0x00210 op=0x6d 00 01 03 00 SHL64_IMM32PLUS: s3 = s1 << (0 + 32) q1=0x33314606 */
    S[3] = S[1] << (0 + 32);

L_0017:
    /* +0x00228 op=0xae 04 00 03 00 BR_EQ64: if (s4 == s0) goto record +27 q1=0x7800000000 */
    if (S[4] == S[0]) goto L_001b;

L_0018:
    /* +0x00240 op=0x52 12 01 04 00 LD32S: s1 = *(int32_t *)(s18 +0x4) */
    S[1] = *(int32_t *)((uint8_t *)S[18] + 0x4);

L_0019:
    /* +0x00258 op=0xb5 01 01 01 00 ADD32_IMM16: s1 = int32(s1 +0x1) */
    S[1] = (int32_t)((uint32_t)S[1] + 0x1);

L_001a:
    /* +0x00270 op=0x08 12 01 04 00 ST32: *(s18 +0x4) = (uint32_t)s1 q1=0x36314606 */
    *(uint32_t *)((uint8_t *)S[18] + 0x4) = (uint32_t)S[1];

L_001b:
    /* +0x00288 op=0xb5 00 15 00 00 ADD32_IMM16: s21 = int32(s0 +0x0) q1=0x7b00000000 */
    S[21] = (int32_t)((uint32_t)S[0] + 0x0);

L_001c:
    /* +0x002a0 op=0xae 02 00 17 00 BR_EQ64: if (s2 == s0) goto record +52 */
    if (S[2] == S[0]) goto L_0034;

L_001d:
    /* +0x002b8 op=0x67 00 03 13 00 LSR64_IMM32PLUS: s19 = (uint64_t)s3 >> (0 + 32) */
    S[19] = (uint64_t)S[3] >> (0 + 32);

L_001e:
    /* +0x002d0 op=0x13 10 13 01 0f CMP_LO64: s1 = ((uint64_t)s16 < (uint64_t)s19) ? 1 : 0 q1=0x33324606 */
    S[1] = ((uint64_t)S[16] < (uint64_t)S[19]) ? 1 : 0;

L_001f:
    /* +0x002e8 op=0xae 01 00 02 00 BR_EQ64: if (s1 == s0) goto record +34 q1=0x7e00000000 */
    if (S[1] == S[0]) goto L_0022;

L_0020:
    /* +0x00300 op=0x34 02 00 15 00 OR64: s21 = s2 | s0 */
    S[21] = S[2] | S[0];

L_0021:
    /* +0x00318 op=0x5f 12 00 00 00 ADD_PC_IMM32: goto record +52 ; vm_pc = current_pc + 1 + 18 */
    goto L_0034;

L_0022:
    /* +0x00330 op=0x6d 00 02 01 00 SHL64_IMM32PLUS: s1 = s2 << (0 + 32) q1=0x39334606 */
    S[1] = S[2] << (0 + 32);

L_0023:
    /* +0x00348 op=0x85 12 14 18 00 ADD64_IMM16: s20 = s18 +0x18 q1=0x8100000000 */
    S[20] = S[18] + 0x18;

L_0024:
    /* +0x00360 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0025:
    /* +0x00378 op=0x34 13 00 06 01 OR64: s6 = s19 | s0 */
    S[6] = S[19] | S[0];

L_0026:
    /* +0x00390 op=0x67 00 01 01 00 LSR64_IMM32PLUS: s1 = (uint64_t)s1 >> (0 + 32) q1=0x38344606 */
    S[1] = (uint64_t)S[1] >> (0 + 32);

L_0027:
    /* +0x003a8 op=0x84 14 01 04 14 ADD64: s4 = s20 + s1 q1=0x8400000000 */
    S[4] = S[20] + S[1];

L_0028:
    /* +0x003c0 op=0x5e 05 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x5, (void *)(uintptr_t)0x125fd420);

L_0029:
    /* +0x003d8 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_002a:
    /* +0x003f0 op=0x34 14 00 05 01 OR64: s5 = s20 | s0 q1=0x36324606 */
    S[5] = S[20] | S[0];

L_002b:
    /* +0x00408 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd420);

L_002c:
    /* +0x00420 op=0x64 10 13 10 12 SUB64: s16 = s16 - s19 */
    S[16] = S[16] - S[19];

L_002d:
    /* +0x00438 op=0x84 11 13 11 00 ADD64: s17 = s17 + s19 */
    S[17] = S[17] + S[19];

L_002e:
    /* +0x00450 op=0x5f 05 00 00 00 ADD_PC_IMM32: goto record +52 ; vm_pc = current_pc + 1 + 5 q1=0x39324606 */
    goto L_0034;

L_002f:
    /* +0x00468 op=0x34 12 00 04 00 OR64: s4 = s18 | s0 q1=0x8a00000000 */
    S[4] = S[18] | S[0];

L_0030:
    /* +0x00480 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0031:
    /* +0x00498 op=0x5e 17 00 00 00 CALL_CF_INDEX: call native_binding[index=0x17] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x17, (void *)(uintptr_t)0x125fd420);

L_0032:
    /* +0x004b0 op=0x85 10 10 c0 ff ADD64_IMM16: s16 = s16 -0x40 q1=0x34334606 */
    S[16] = S[16] + (-0x40);

L_0033:
    /* +0x004c8 op=0x85 11 11 40 00 ADD64_IMM16: s17 = s17 +0x40 q1=0x8d00000000 */
    S[17] = S[17] + 0x40;

L_0034:
    /* +0x004e0 op=0x14 10 01 40 00 CMP_LO_IMM64: s1 = ((uint64_t)s16 < (uint64_t)64) ? 1 : 0 */
    S[1] = ((uint64_t)S[16] < (uint64_t)0x40) ? 1 : 0;

L_0035:
    /* +0x004f8 op=0xae 01 00 f9 ff BR_EQ64: if (s1 == s0) goto record +47 */
    if (S[1] == S[0]) goto L_002f;

L_0036:
    /* +0x00510 op=0xae 10 00 07 00 BR_EQ64: if (s16 == s0) goto record +62 q1=0x37334606 */
    if (S[16] == S[0]) goto L_003e;

L_0037:
    /* +0x00528 op=0x6d 00 15 01 00 SHL64_IMM32PLUS: s1 = s21 << (0 + 32) q1=0x9000000000 */
    S[1] = S[21] << (0 + 32);

L_0038:
    /* +0x00540 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0039:
    /* +0x00558 op=0x34 10 00 06 01 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_003a:
    /* +0x00570 op=0x67 00 01 01 00 LSR64_IMM32PLUS: s1 = (uint64_t)s1 >> (0 + 32) q1=0x32344606 */
    S[1] = (uint64_t)S[1] >> (0 + 32);

L_003b:
    /* +0x00588 op=0x84 12 01 01 04 ADD64: s1 = s18 + s1 q1=0x9300000000 */
    S[1] = S[18] + S[1];

L_003c:
    /* +0x005a0 op=0x85 01 04 18 00 ADD64_IMM16: s4 = s1 +0x18 */
    S[4] = S[1] + 0x18;

L_003d:
    /* +0x005b8 op=0x5e 05 00 00 00 CALL_CF_INDEX: call native_binding[index=0x5] via q1 table q1=0x125fd420 */
    CALL_CF_INDEX(frame, 0x5, (void *)(uintptr_t)0x125fd420);

L_003e:
    /* +0x005d0 op=0x34 1e 00 1d 00 OR64: s29 = s30 | s0 q1=0x35344606 */
    S[29] = S[30] | S[0];

L_003f:
    /* +0x005e8 op=0x58 1d 10 00 00 LD64: s16 = *(uint64_t *)(s29 +0x0) q1=0x9600000000 */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_0040:
    /* +0x00600 op=0x58 1d 11 08 00 LD64: s17 = *(uint64_t *)(s29 +0x8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0041:
    /* +0x00618 op=0x58 1d 12 10 00 LD64: s18 = *(uint64_t *)(s29 +0x10) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0042:
    /* +0x00630 op=0x58 1d 13 18 00 LD64: s19 = *(uint64_t *)(s29 +0x18) q1=0x30354606 */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_0043:
    /* +0x00648 op=0x58 1d 14 20 00 LD64: s20 = *(uint64_t *)(s29 +0x20) q1=0x9900000000 */
    S[20] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_0044:
    /* +0x00660 op=0x58 1d 15 28 00 LD64: s21 = *(uint64_t *)(s29 +0x28) */
    S[21] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_0045:
    /* +0x00678 op=0x58 1d 1e 30 00 LD64: s30 = *(uint64_t *)(s29 +0x30) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x30);

L_0046:
    /* +0x00690 op=0x58 1d 1f 38 00 LD64: s31 = *(uint64_t *)(s29 +0x38) q1=0x33354606 */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x38);

L_0047:
    /* +0x006a8 op=0x85 1d 1d 40 00 ADD64_IMM16: s29 = s29 +0x40 q1=0x9c00000000 */
    S[29] = S[29] + 0x40;

L_0048:
    /* +0x006c0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

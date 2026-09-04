/*
 * Auto-generated linear C-like lift for 350.101 managed program F20.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/target/managed_program_dumps_350101_cf64_f1_reachable_20260904/350101_F20_0x60a800_0x438.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F20_350_linear_lift(ManagedFrame350 *frame)
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
    /* +0x00048 op=0x25 1d 10 08 00 ST64: *(s29 +0x8) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[16];

L_0004:
    /* +0x00060 op=0x34 1d 00 1e 00 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0005:
    /* +0x00078 op=0x34 04 00 10 01 OR64: s16 = s4 | s0 */
    S[16] = S[4] | S[0];

L_0006:
    /* +0x00090 op=0x54 02 01 22 20 CONST_HI16: s1 = sign_extend_32(0x2022 << 16) */
    S[1] = (int32_t)(0x2022 << 16);

L_0007:
    /* +0x000a8 op=0xb5 00 02 00 00 ADD32_IMM16: s2 = int32(s0 +0x0) */
    S[2] = (int32_t)((uint32_t)S[0] + 0x0);

L_0008:
    /* +0x000c0 op=0xb5 00 03 08 00 ADD32_IMM16: s3 = int32(s0 +0x8) */
    S[3] = (int32_t)((uint32_t)S[0] + 0x8);

L_0009:
    /* +0x000d8 op=0x33 01 04 20 04 OR_IMM16: s4 = s1 | 0x420 */
    S[4] = S[1] | 0x420;

L_000a:
    /* +0x000f0 op=0x34 10 00 05 00 OR64: s5 = s16 | s0 */
    S[5] = S[16] | S[0];

L_000b:
    /* +0x00108 op=0xae 02 03 13 00 BR_EQ64: if (s2 == s3) goto record +31 */
    if (S[2] == S[3]) goto L_001f;

L_000c:
    /* +0x00120 op=0xb2 02 01 01 00 AND64_IMM16: s1 = s2 & 0x1 */
    S[1] = S[2] & 0x1;

L_000d:
    /* +0x00138 op=0xa7 01 00 07 00 BR_NE64: if (s1 != s0) goto record +21 */
    if (S[1] != S[0]) goto L_0015;

L_000e:
    /* +0x00150 op=0x18 11 04 01 07 SHL32_IMM: s1 = (int32_t)(s4 << 7) */
    S[1] = (int32_t)((uint32_t)S[4] << 7);

L_000f:
    /* +0x00168 op=0x02 01 04 01 01 XOR64: s1 = s4 ^ s1 */
    S[1] = S[4] ^ S[1];

L_0010:
    /* +0x00180 op=0x0e 00 04 04 03 LSR32_IMM: s4 = sign_extend_32((uint32_t)s4 >> 3) */
    S[4] = (int32_t)((uint32_t)S[4] >> 3);

L_0011:
    /* +0x00198 op=0x02 01 04 01 01 XOR64: s1 = s4 ^ s1 */
    S[1] = S[4] ^ S[1];

L_0012:
    /* +0x001b0 op=0x59 05 04 00 00 LD8U: s4 = *(uint8_t *)(s5 +0x0) */
    S[4] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0013:
    /* +0x001c8 op=0x02 01 04 04 01 XOR64: s4 = s4 ^ s1 */
    S[4] = S[4] ^ S[1];

L_0014:
    /* +0x001e0 op=0x5f 07 00 00 00 ADD_PC_IMM32: goto record +28 ; vm_pc = current_pc + 1 + 7 */
    goto L_001c;

L_0015:
    /* +0x001f8 op=0x59 05 01 00 00 LD8U: s1 = *(uint8_t *)(s5 +0x0) */
    S[1] = *(uint8_t *)((uint8_t *)S[5] + 0x0);

L_0016:
    /* +0x00210 op=0x18 00 04 06 0b SHL32_IMM: s6 = (int32_t)(s4 << 11) */
    S[6] = (int32_t)((uint32_t)S[4] << 11);

L_0017:
    /* +0x00228 op=0x34 06 01 01 01 OR64: s1 = s6 | s1 */
    S[1] = S[6] | S[1];

L_0018:
    /* +0x00240 op=0x0e 00 04 06 05 LSR32_IMM: s6 = sign_extend_32((uint32_t)s4 >> 5) */
    S[6] = (int32_t)((uint32_t)S[4] >> 5);

L_0019:
    /* +0x00258 op=0x02 04 06 04 00 XOR64: s4 = s6 ^ s4 */
    S[4] = S[6] ^ S[4];

L_001a:
    /* +0x00270 op=0x02 04 01 01 00 XOR64: s1 = s1 ^ s4 */
    S[1] = S[1] ^ S[4];

L_001b:
    /* +0x00288 op=0x36 01 00 04 00 NOR64: s4 = ~(s1 | s0) */
    S[4] = ~(S[1] | S[0]);

L_001c:
    /* +0x002a0 op=0xb5 02 02 01 00 ADD32_IMM16: s2 = int32(s2 +0x1) */
    S[2] = (int32_t)((uint32_t)S[2] + 0x1);

L_001d:
    /* +0x002b8 op=0x85 05 05 01 00 ADD64_IMM16: s5 = s5 +0x1 */
    S[5] = S[5] + 0x1;

L_001e:
    /* +0x002d0 op=0xa7 02 03 ed ff BR_NE64: if (s2 != s3) goto record +12 */
    if (S[2] != S[3]) goto L_000c;

L_001f:
    /* +0x002e8 op=0x08 1e 04 04 00 ST32: *(s30 +0x4) = (uint32_t)s4 */
    *(uint32_t *)((uint8_t *)S[30] + 0x4) = (uint32_t)S[4];

L_0020:
    /* +0x00300 op=0x85 10 04 10 00 ADD64_IMM16: s4 = s16 +0x10 */
    S[4] = S[16] + 0x10;

L_0021:
    /* +0x00318 op=0x85 1e 05 04 00 ADD64_IMM16: s5 = s30 +0x4 */
    S[5] = S[30] + 0x4;

L_0022:
    /* +0x00330 op=0x85 00 06 04 00 ADD64_IMM16: s6 = s0 +0x4 */
    S[6] = S[0] + 0x4;

L_0023:
    /* +0x00348 op=0x5e 0e 00 00 00 CALL_CF_INDEX: call native_binding[index=0xe] via q1 table q1=0x125fd360 */
    CALL_CF_INDEX(frame, 0xe, (void *)(uintptr_t)0x125fd360);

L_0024:
    /* +0x00360 op=0x59 10 01 10 00 LD8U: s1 = *(uint8_t *)(s16 +0x10) */
    S[1] = *(uint8_t *)((uint8_t *)S[16] + 0x10);

L_0025:
    /* +0x00378 op=0xb2 01 01 fb 00 AND64_IMM16: s1 = s1 & 0xfb */
    S[1] = S[1] & 0xfb;

L_0026:
    /* +0x00390 op=0x26 10 01 10 00 ST8: *(s16 +0x10) = (uint8_t)s1 */
    *(uint8_t *)((uint8_t *)S[16] + 0x10) = (uint8_t)S[1];

L_0027:
    /* +0x003a8 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0028:
    /* +0x003c0 op=0x58 1d 10 08 00 LD64: s16 = *(uint64_t *)(s29 +0x8) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0029:
    /* +0x003d8 op=0x58 1d 1e 10 00 LD64: s30 = *(uint64_t *)(s29 +0x10) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_002a:
    /* +0x003f0 op=0x58 1d 1f 18 00 LD64: s31 = *(uint64_t *)(s29 +0x18) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_002b:
    /* +0x00408 op=0x85 1d 1d 20 00 ADD64_IMM16: s29 = s29 +0x20 */
    S[29] = S[29] + 0x20;

L_002c:
    /* +0x00420 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

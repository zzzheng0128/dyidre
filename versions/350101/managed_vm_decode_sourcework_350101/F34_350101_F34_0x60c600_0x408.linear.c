/*
 * Auto-generated linear C-like lift for 350.101 managed program F34.
 * Source: /Users/freeman/project/douyin/unidbg/unidbg-android/unidbg-android/target/managed_program_f32_family_350101_20260831_045757/350101_F34_0x60c600_0x408.bin
 * This is a mechanical lift, not cleaned structured C.
 */
#include <stdint.h>

void managed_F34_350_linear_lift(ManagedFrame350 *frame)
{
    uint64_t *S = frame->buf->slots.slot;
    float *F = (float *)((uint8_t *)frame->buf + 0x8200);
    double *D = (double *)((uint8_t *)frame->buf + 0x8280);

L_0000:
    /* +0x00000 op=0x85 1d 1d d0 ff ADD64_IMM16: s29 = s29 -0x30 */
    S[29] = S[29] + (-0x30);

L_0001:
    /* +0x00018 op=0x25 1d 1f 28 00 ST64: *(s29 +0x28) = s31 */
    *(uint64_t *)((uint8_t *)S[29] + 0x28) = S[31];

L_0002:
    /* +0x00030 op=0x25 1d 1e 20 00 ST64: *(s29 +0x20) = s30 */
    *(uint64_t *)((uint8_t *)S[29] + 0x20) = S[30];

L_0003:
    /* +0x00048 op=0x25 1d 13 18 00 ST64: *(s29 +0x18) = s19 */
    *(uint64_t *)((uint8_t *)S[29] + 0x18) = S[19];

L_0004:
    /* +0x00060 op=0x25 1d 12 10 00 ST64: *(s29 +0x10) = s18 */
    *(uint64_t *)((uint8_t *)S[29] + 0x10) = S[18];

L_0005:
    /* +0x00078 op=0x25 1d 11 08 00 ST64: *(s29 +0x8) = s17 */
    *(uint64_t *)((uint8_t *)S[29] + 0x8) = S[17];

L_0006:
    /* +0x00090 op=0x25 1d 10 00 00 ST64: *(s29 +0x0) = s16 */
    *(uint64_t *)((uint8_t *)S[29] + 0x0) = S[16];

L_0007:
    /* +0x000a8 op=0x34 1d 00 1e 01 OR64: s30 = s29 | s0 */
    S[30] = S[29] | S[0];

L_0008:
    /* +0x000c0 op=0x34 05 00 10 01 OR64: s16 = s5 | s0 */
    S[16] = S[5] | S[0];

L_0009:
    /* +0x000d8 op=0x34 04 00 11 00 OR64: s17 = s4 | s0 */
    S[17] = S[4] | S[0];

L_000a:
    /* +0x000f0 op=0x85 00 04 00 00 ADD64_IMM16: s4 = s0 +0x0 */
    S[4] = S[0] + 0x0;

L_000b:
    /* +0x00108 op=0x34 11 00 05 01 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_000c:
    /* +0x00120 op=0x34 10 00 06 00 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_000d:
    /* +0x00138 op=0x5e 8e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8e] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8e, (void *)(uintptr_t)0x125fd3c0);

L_000e:
    /* +0x00150 op=0xb5 00 12 01 00 ADD32_IMM16: s18 = int32(s0 +0x1) */
    S[18] = (int32_t)((uint32_t)S[0] + 0x1);

L_000f:
    /* +0x00168 op=0xb5 00 13 02 00 ADD32_IMM16: s19 = int32(s0 +0x2) */
    S[19] = (int32_t)((uint32_t)S[0] + 0x2);

L_0010:
    /* +0x00180 op=0x34 11 00 04 01 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0011:
    /* +0x00198 op=0x5e 8f 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8f] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8f, (void *)(uintptr_t)0x125fd3c0);

L_0012:
    /* +0x001b0 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0013:
    /* +0x001c8 op=0x5e 90 00 00 00 CALL_CF_INDEX: call native_binding[index=0x90] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x90, (void *)(uintptr_t)0x125fd3c0);

L_0014:
    /* +0x001e0 op=0xb2 12 01 ff 00 AND64_IMM16: s1 = s18 & 0xff */
    S[1] = S[18] & 0xff;

L_0015:
    /* +0x001f8 op=0xae 01 13 08 00 BR_EQ64: if (s1 == s19) goto record +30 */
    if (S[1] == S[19]) goto L_001e;

L_0016:
    /* +0x00210 op=0x34 11 00 04 00 OR64: s4 = s17 | s0 */
    S[4] = S[17] | S[0];

L_0017:
    /* +0x00228 op=0x5e 91 00 00 00 CALL_CF_INDEX: call native_binding[index=0x91] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x91, (void *)(uintptr_t)0x125fd3c0);

L_0018:
    /* +0x00240 op=0x34 12 00 04 01 OR64: s4 = s18 | s0 */
    S[4] = S[18] | S[0];

L_0019:
    /* +0x00258 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_001a:
    /* +0x00270 op=0x34 10 00 06 01 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_001b:
    /* +0x00288 op=0x5e 8e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8e] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8e, (void *)(uintptr_t)0x125fd3c0);

L_001c:
    /* +0x002a0 op=0xb5 12 12 01 00 ADD32_IMM16: s18 = int32(s18 +0x1) */
    S[18] = (int32_t)((uint32_t)S[18] + 0x1);

L_001d:
    /* +0x002b8 op=0x5f f2 ff ff ff ADD_PC_IMM32: goto record +16 ; vm_pc = current_pc + 1 + -14 */
    goto L_0010;

L_001e:
    /* +0x002d0 op=0x85 00 04 02 00 ADD64_IMM16: s4 = s0 +0x2 */
    S[4] = S[0] + 0x2;

L_001f:
    /* +0x002e8 op=0x34 11 00 05 00 OR64: s5 = s17 | s0 */
    S[5] = S[17] | S[0];

L_0020:
    /* +0x00300 op=0x34 10 00 06 01 OR64: s6 = s16 | s0 */
    S[6] = S[16] | S[0];

L_0021:
    /* +0x00318 op=0x5e 8e 00 00 00 CALL_CF_INDEX: call native_binding[index=0x8e] via q1 table q1=0x125fd3c0 */
    CALL_CF_INDEX(frame, 0x8e, (void *)(uintptr_t)0x125fd3c0);

L_0022:
    /* +0x00330 op=0x34 1e 00 1d 01 OR64: s29 = s30 | s0 */
    S[29] = S[30] | S[0];

L_0023:
    /* +0x00348 op=0x58 1d 10 00 00 LD64: s16 = *(uint64_t *)(s29 +0x0) */
    S[16] = *(uint64_t *)((uint8_t *)S[29] + 0x0);

L_0024:
    /* +0x00360 op=0x58 1d 11 08 00 LD64: s17 = *(uint64_t *)(s29 +0x8) */
    S[17] = *(uint64_t *)((uint8_t *)S[29] + 0x8);

L_0025:
    /* +0x00378 op=0x58 1d 12 10 00 LD64: s18 = *(uint64_t *)(s29 +0x10) */
    S[18] = *(uint64_t *)((uint8_t *)S[29] + 0x10);

L_0026:
    /* +0x00390 op=0x58 1d 13 18 00 LD64: s19 = *(uint64_t *)(s29 +0x18) */
    S[19] = *(uint64_t *)((uint8_t *)S[29] + 0x18);

L_0027:
    /* +0x003a8 op=0x58 1d 1e 20 00 LD64: s30 = *(uint64_t *)(s29 +0x20) */
    S[30] = *(uint64_t *)((uint8_t *)S[29] + 0x20);

L_0028:
    /* +0x003c0 op=0x58 1d 1f 28 00 LD64: s31 = *(uint64_t *)(s29 +0x28) */
    S[31] = *(uint64_t *)((uint8_t *)S[29] + 0x28);

L_0029:
    /* +0x003d8 op=0x85 1d 1d 30 00 ADD64_IMM16: s29 = s29 +0x30 */
    S[29] = S[29] + 0x30;

L_002a:
    /* +0x003f0 op=0x5b 1f 00 00 00 RET: return/leave with s31 */
    return; /* RET s31 */

}

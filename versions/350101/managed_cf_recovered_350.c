/*
 * 350.101 managed VM / CF helper reconstruction.
 *
 * Status:
 *   Evidence-backed pseudo-C.  This is not meant to compile directly; it is a
 *   readable lift of the managed VM helpers that participate in X-* header
 *   generation.
 *
 * Why this file exists:
 *   IDA sees the managed bytecode VM as a dispatcher plus many tiny native
 *   callbacks (CFxx).  The real business logic is split across:
 *
 *     managed bytecode F5/F7/F8/F13
 *       -> slot writes/reads
 *       -> native CF helpers
 *       -> MEM_BLOCK/base64/format/digest/json primitives
 *
 *   So the practical "de-VM" form is not one giant decompiled C function yet.
 *   It is a semantic lift of the high-value bytecode primitives and their
 *   proven runtime data flow.
 *
 * Primary evidence:
 *   - unidbg/unidbg-android/target/sign6_350101_cfargs_20260830_235936.log
 *   - unidbg/unidbg-android/target/sign6_350101_cfpost_20260831_000758.log
 *   - unidbg/unidbg-android/target/sign6_350101_cf48_cf49_20260831_005155.log
 *   - IDA decompilation of 0x1547C0/0x1547D4/0x16F998/0x16D520/0x16D5A0/
 *     0x16D680/0x16F660/0x16F6B0/0x170128/0x1701D8/0x16FD64
 *   - unidbg CF61 raw vectors from
 *     sign6_350101_cf61_raw_20260831_063733.log
 *   - standalone SM3 oracle:
 *     cf61_sm3_recovered_350101.c => failures=0
 *   - F5/X-Argus tail ladder:
 *     sign6_350101_f5_tailcf_20260831_065857.log
 *     f5_x_argus_pack_lift_350101.md
 */

#include "metasec_structs_350_all.h"

/* ------------------------------------------------------------------------- */
/* Managed VM slot model                                                      */
/* ------------------------------------------------------------------------- */

uint64_t managedFrameGetSlot_350_recovered(ManagedFrame350 *frame, int slot)
{
    /*
     * Real function: 0x1547C0 managedFrameGetSlot_350.
     *
     * 【中文】普通 qword slot 读取：
     *   frame->buf + 0x8100 + slot * 8
     *
     * Slot convention on the sign module:
     *   slot2  = native helper return value
     *   slot4+ = native helper arguments
     */
    return frame->buf->slots.slot[slot];
}

ManagedFrame350 *managedFrameSetSlot_350_recovered(ManagedFrame350 *frame,
                                                   int slot,
                                                   uint64_t value)
{
    /*
     * Real function: 0x1547D4 managedFrameSetSlot_350.
     *
     * 【中文】普通 qword slot 写入。CF wrapper 通常把结果写回 slot2，
     * managed bytecode 后续再消费 slot2。
     */
    frame->buf->slots.slot[slot] = value;
    return frame;
}

double managedFrameGetSlotDouble_350_recovered(ManagedFrame350 *frame, int slot)
{
    /*
     * Real function: 0x154784 managedFrameGetSlotDouble_350.
     *
     * 【中文】CF79 的坑点：数字不是从普通 qword slot2 读出来的。
     * slot<=7 时 double 在 frame->buf + 0x82e0 + slot*8；
     * slot>7 时走 value_stack_top - 0x40 + slot*8。
     */
    if (slot <= 7) {
        return frame->buf->slots.double_view.inline_double_slot_0_7[slot];
    }
    return *(double *)((char *)frame->buf->slots.view.value_stack_top + slot * 8 - 0x40);
}

/* ------------------------------------------------------------------------- */
/* Core MEM_BLOCK/native CF primitives                                        */
/* ------------------------------------------------------------------------- */

uint64_t cf07_memCopy_slot4_slot5_len6_ret2_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16EC90.
     *
     * 【中文】原始内存拷贝原语：F8/X-Medusa 大量使用它拼长二进制包。
     */
    char *dst = (char *)managedFrameGetSlot_350(frame, 4);
    char *src = (char *)managedFrameGetSlot_350(frame, 5);
    uint64_t len = managedFrameGetSlot_350(frame, 6);
    char *ret = memCopy2(dst, src, len);
    managedFrameSetSlot_350(frame, 2, (uint64_t)ret);
    return (uint64_t)ret;
}

uint64_t cf10_copyMemBlockData_slot4_slot5_ret2_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16ED54.
     *
     * 【中文】MEM_BLOCK 内容复制。Argus/Medusa 里负责把 digest、中间块
     * 搬到新的 MEM_BLOCK。
     */
    MEM_BLOCK *dst = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *src = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    uint64_t ret = copyMemBlockData(dst, src);
    managedFrameSetSlot_350(frame, 2, ret);
    return ret;
}

void cf38_initMemBlockBySrc_slot4_src5_len6_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16F374.
     *
     * 【中文】把一段 raw buffer 包装成 MEM_BLOCK。短头里用于复制 4 字节
     * prefix；Argus/Medusa 里用于截取 digest/seed/stub 片段。
     */
    MEM_BLOCK *dst = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    const void *src = (const void *)managedFrameGetSlot_350(frame, 5);
    uint64_t len = managedFrameGetSlot_350(frame, 6);
    initMemBlockBySrc(dst, src, len);
}

void cf44_base64Encode_mem5_toRef4_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16F544.
     *
     * 【中文】base64 出口：
     *   F5/X-Argus   输入约 0xC2 字节，输出 0x104/0x108 class
     *   F7/X-Ladon   输入 0x24 字节，输出 0x30
     *   F8/X-Medusa  输入约 0x2C4/0x2C8 字节，输出 0x3B0+ class
     *   F13/X-Helios 输入 0x24 字节，输出 0x30
     */
    REF_MEM_BLOCK *out_ref = (REF_MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *input = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    doBase64Encode(input, out_ref);
}

uint64_t cf98_formatAllocString_slot4_fmt5_ret2_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x170128.
     *
     * 【中文】managed 程序的 key/value 写回口。当前重点路径里 fmt="%s"：
     *   F5  写回 "X-Argus"   和生成值
     *   F7  写回 "X-Ladon"   和生成值
     *   F8  写回 "X-Medusa"  和生成值
     *   F13 写回 "X-Helios"  和生成值
     */
    char **out = (char **)managedFrameGetSlot_350(frame, 4);
    const char *fmt = (const char *)managedFrameGetSlot_350(frame, 5);
    uint32_t ret = formatAllocString_350(out, fmt);
    managedFrameSetSlot_350(frame, 2, ret);
    return ret;
}

MEM_BLOCK *cf100_formatStringToMemBlock_slot4_fmt5_args6_8_350_recovered(
    ManagedFrame350 *frame)
{
    /*
     * Real function: 0x1701D8.
     *
     * 【中文】短头明文构造。F7/F13 中 fmt="%u-%s-%s"；
     * focused run 观测输出：
     *   "1788108717-1588093228-1128"
     */
    MEM_BLOCK *dst = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    const char *fmt = (const char *)managedFrameGetSlot_350(frame, 5);
    uint32_t a0 = (uint32_t)managedFrameGetSlot_350(frame, 6);
    uint64_t a1 = managedFrameGetSlot_350(frame, 7);
    uint64_t a2 = managedFrameGetSlot_350(frame, 8);
    return formatStringToMemBlock5_350(dst, fmt, a0, a1, a2);
}

bool cf79_jsonAddNumber_slot4_key5_valSlot2_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16FD64.
     *
     * 【中文】F8/X-Medusa 的 JSON 数字字段写入：
     *   cmr, cmr2, un_h, vpn, kd, fkd, pd, do
     *
     * 注意 value 是 double slot2，不是普通 qword slot2。
     */
    void *json = (void *)managedFrameGetSlot_350(frame, 4);
    const char *key = (const char *)managedFrameGetSlot_350(frame, 5);
    double value = managedFrameGetSlotDouble_350(frame, 2);
    bool ok = cJSON_AddNumberToObject_double(json, key, value);
    managedFrameSetSlot_350(frame, 2, ok);
    return ok;
}

void cf42_makeU16MemBlockLE_slot4_out_slot5_low16_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Wrapper:       0x16F48C
     * Inner helper:  0x16CC84
     *
     * Wrapper ABI:
     *   slot4 -> X8 hidden out MEM_BLOCK*
     *   slot5 -> W0 integer/selector
     *
     * Inner proof:
     *   16CCA8: strh w0, [sp,#4]
     *   16CCAC: mov  x0, x8
     *   16CCB0: bl   0x10B488/initMemBlockBySrc(out, &stack_u16, 2)
     *
     * 【中文】CF42 已经不是黑盒变换：它只是把 slot5 的低 16 位按
     * little-endian 写成一个 2 字节 MEM_BLOCK。F5 当前样本里：
     *   slot5=0x6f80     -> 80 6f
     *   slot5=0x6f80e11b -> 1b e1
     */
    MEM_BLOCK *out = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    uint16_t le16 = (uint16_t)managedFrameGetSlot_350(frame, 5);
    initMemBlockBySrc(out, &le16, 2);
}

void cf41_argusTailSimon128256_slot4_input_slot5_out_slot6_key_350_shape(
    ManagedFrame350 *frame)
{
    /*
     * Wrapper:      0x16F43C
     * Inner helper: 0x16CB88 -> 0x16E538
     *
     * Static shape:
     *   slot4 = input MEM_BLOCK
     *   slot5 = output MEM_BLOCK
     *   slot6 = key/material MEM_BLOCK
     *
     * 0x16CB88 clones slot6, pads it to 32 bytes when shorter, then calls
     * 0x16E538(input.body, input.len, &tmp_out, &tmp_len, padded_key32).
     * 0x16E538 builds a 0x240-byte SIMON schedule/work area, uses 0x16E678
     * as the SIMON128/256 key scheduler, PKCS#7-pads input to 16-byte
     * alignment, and calls managed F16 wrapper 0x1717F4 for every block.
     *
     * F16 decoded round:
     *   R' = L ^ ((ROL64(R,1) & ROL64(R,8)) ^ ROL64(R,2)) ^ K[i]
     *   L' = R
     *
     * 【中文】CF41 是 Argus 尾包的 SIMON128/256 层：slot6 补到 32 字节，
     * 0x16E678 展开 72 个 64-bit round key，输入 PKCS#7 补齐后每 16 字节
     * 进入 F16。runtime oracle 已验证 failures=0。
     */
    MEM_BLOCK *input = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *out = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    MEM_BLOCK *key_material = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 6);

    MEM_BLOCK key32 = cloneAndPadTo32(key_material);
    unsigned char *tmp_out = NULL;
    unsigned int tmp_len = 0;
    cf41_simon128_256_pkcs7_encrypt_16E538(input->body.mem,
                                           input->body.src_len,
                                           &tmp_out,
                                           &tmp_len,
                                           key32.body.mem);
    initMemBlockBySrc(out, tmp_out, tmp_len);
    free(tmp_out);
    freeMemBlock(&key32);
}

void cf43_argusTailAesModePkcs7Transform_slot4_out_slot5_body_slot6_key16_350_shape(
    ManagedFrame350 *frame)
{
    /*
     * Wrapper:      0x16F4C4
     * Inner helper: 0x11BF94
     *
     * Wrapper ABI:
     *   slot4 -> X8 hidden out
     *   slot5 -> X0 body MEM_BLOCK       (current F5: len 0xb3)
     *   slot6 -> X1 key/material block   (inner checks cloned len == 0x10)
     *   slot7 -> X2 side material
     *   slot8 -> X3 mode descriptor
     *
     * Inner shape:
     *   0x11C6C4 clone slot6 and require len 0x10
     *   0x11C750 initialize AES/mode context via 0x11CAE0
     *   0x11C770 compute aligned=((len+0x10)/0x10)<<4
     *   0x11C7C4 compute PKCS#7-style pad byte
     *   0x11CA30 fill pad bytes
     *   0x11C8D4 call 0x11CBB4(mode, ctx, padded_in, out, aligned_len)
     *   0x11C8D8 post-return point: focused probe shows output buffer after
     *            mode process equals the next CF30 slot6/outC0.
     *
     * AES/mode evidence:
     *   0x10569C = AES key schedule, len 16/24/32 branches
     *   0x105AF0 = AES encrypt block
     *   0x105E54 = AES decrypt block
     *   0x11CAE0 = mode init dispatcher
     *   0x11CBB4 = mode process dispatcher
     *   current F5 modeDesc[0].type == 1:
     *      init    -> 0x106230
     *      process -> 0x1062A8 (AES-128-CBC)
     *
     * 【中文】CF43 是 F5/X-Argus 尾包 `0xb3 -> 0xc0` 的块加密/模式层。
     * 现在已确认当前样本 mode type=1，走 0x106230 init + 0x1062A8
     * AES-128-CBC；OpenSSL 和 cf43_aes128_cbc_recovered_350101.c 均验证。
     * 0x11CBB4 的 x2/x3 相同，所以是原地处理。
     * 0x11C8D8 返回点 dump 的 saved_x2_after 等于后续 CF30 slot6/outC0。
     */
    MEM_BLOCK *out = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *body_b3 = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    MEM_BLOCK *key16 = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 6);
    MEM_BLOCK *side = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 7);
    void *mode_desc = (void *)managedFrameGetSlot_350(frame, 8);

    size_t padded_len = roundUp16(body_b3->body.src_len + 0x10);
    uint8_t *padded = malloc(padded_len);
    memcpy(padded, body_b3->body.mem, body_b3->body.src_len);
    memset(padded + body_b3->body.src_len,
           (int)(padded_len - body_b3->body.src_len),
           padded_len - body_b3->body.src_len);

    MetaSecAesModeCtx350 mode_ctx;
    cf43_modeInit_11CAE0(mode_desc, &mode_ctx, key16, side);       /* type 1 -> 0x106230 AES-CBC init */
    cf43_modeProcess_11CBB4(mode_desc, &mode_ctx, padded, padded, padded_len); /* type 1 -> 0x1062A8 AES-CBC encrypt */
    initMemBlockBySrc(out, padded, padded_len);
    free(padded);
}

/* ------------------------------------------------------------------------- */
/* CF61: SM3 one-shot                                                         */
/* ------------------------------------------------------------------------- */

int sm3OneShot_F15InitUpdateFinal_350_recovered(const void *input,
                                                uint32_t input_len,
                                                uint8_t out_digest32[32])
{
    /*
     * Real function: 0x16D520.
     *
     * 【中文】CF61 的下层形态已经确认是 SM3：
     *   1. managed F15 初始化 state，并写入标准 SM3 IV
     *   2. 64 字节分组 update
     *   3. 0x80 padding + bit length final
     *   4. 输出 32 字节大端 digest
     *
     * 0x16D86C 的压缩体仍然是 flatten 微块，但 runtime raw vector
     * 5/5 与标准 SM3 完全一致，所以语义上可以命名为 SM3 compress。
     */
    MetaSecDigest32State350 state;
    managedSignDigestStateInitF15_350(&state);
    sm3Update_64byteBlocks_350(&state, input, input_len);
    sm3Final_padLenEmit32_350(&state, out_digest32);
    return 0;
}

int sm3Update_64byteBlocks_350_recovered(MetaSecDigest32State350 *state,
                                         const void *input,
                                         uint32_t input_len)
{
    /*
     * Real function: 0x16D5A0.
     *
     * 【中文】SM3 update：
     *   state+0/+4  = 64-bit byte counter
     *   state+0x28  = 64-byte tail buffer
     *   每满 64 字节调用 flattened compress
     */
    if (input_len == 0) {
        return -1;
    }

    const uint8_t *p = (const uint8_t *)input;
    uint32_t tail_len = state->byte_count_lo & 0x3f;
    uint32_t old_lo = state->byte_count_lo;

    state->byte_count_lo += input_len;
    if (state->byte_count_lo < old_lo) {
        state->byte_count_hi++;
    }

    if (tail_len != 0) {
        uint32_t need = 64 - tail_len;
        if (need <= input_len) {
            memCopy2((char *)&state->block_tail[tail_len], (char *)p, need);
            sm3Compress_flattenedBlocks_350(state, state->block_tail);
            p += need;
            input_len -= need;
            tail_len = 0;
        }
    }

    while (input_len >= 64) {
        sm3Compress_flattenedBlocks_350(state, p);
        p += 64;
        input_len -= 64;
    }

    if (input_len != 0) {
        memCopy2((char *)&state->block_tail[tail_len], (char *)p, input_len);
    }
    return 0;
}

int sm3Final_padLenEmit32_350_recovered(MetaSecDigest32State350 *state,
                                        uint8_t out_digest32[32])
{
    /*
     * Real function: 0x16D680.
     *
     * 【中文】SM3 final：
     *   - 余数 < 56：补到 56
     *   - 余数 >=56：补到 120
     *   - 追加 8 字节大端 bit length
     *   - state_words[0..7] 大端输出
     */
    uint64_t bytes = ((uint64_t)state->byte_count_hi << 32) | state->byte_count_lo;
    uint32_t rem = state->byte_count_lo & 0x3f;
    uint32_t pad_target = rem >= 56 ? 120 : 56;
    uint64_t bits = bytes << 3;
    uint8_t be_len[8];

    for (int i = 0; i < 8; i++) {
        be_len[i] = (uint8_t)(bits >> (56 - i * 8));
    }

    sm3Update_64byteBlocks_350(state, sm3_pad80_zeros_350, pad_target - rem);
    sm3Update_64byteBlocks_350(state, be_len, 8);

    for (int i = 0; i < 8; i++) {
        uint32_t w = state->state_words[i];
        out_digest32[i * 4 + 0] = (uint8_t)(w >> 24);
        out_digest32[i * 4 + 1] = (uint8_t)(w >> 16);
        out_digest32[i * 4 + 2] = (uint8_t)(w >> 8);
        out_digest32[i * 4 + 3] = (uint8_t)w;
    }
    return 0;
}

uint64_t cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350_recovered(ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16F998.
     *
     * 【中文】CF61 wrapper 只做 slot 适配，真正算法是 SM3 one-shot：
     *   slot4 = input pointer
     *   slot5 = input length
     *   slot6 = output digest32 pointer/state sink
     *   slot2 = return code, observed 0
     *
     * Runtime hits:
     *   F5/X-Argus  : query len 0x2c0, x-ss-stub len 0x10, pack len 0x44
     *   F8/X-Medusa : query len 0x2c0, pack len 0x44
     */
    const void *input = (const void *)managedFrameGetSlot_350(frame, 4);
    uint32_t input_len = (uint32_t)managedFrameGetSlot_350(frame, 5);
    uint8_t *out = (uint8_t *)managedFrameGetSlot_350(frame, 6);
    uint64_t ret = sm3OneShot_F15InitUpdateFinal_350(input, input_len, out);
    managedFrameSetSlot_350(frame, 2, ret);
    return ret;
}

/* ------------------------------------------------------------------------- */
/* F5/X-Argus tail binary-pack shape                                          */
/* ------------------------------------------------------------------------- */

void build_x_argus_tail_pack_F5_350_shape_recovered(MetaSecManagedCallArg350 *pack)
{
    /*
     * This is not a single native function. It is the evidence-backed shape of
     * the F5 managed bytecode tail around records 0x01c1..0x02bd.
     *
     * Durable proof:
     *   dyidre/versions/350101/f5_x_argus_pack_lift_350101.md
     *
     * 【中文】这段是 X-Argus 最后一段二进制封包逻辑。关键不是某个 heap
     * 地址，而是 MEM_BLOCK 长度链：
     *
     *   0x20 + 0x04 -> 0x24
     *   0x24 + 0x20 -> 0x44
     *   SM3(0x44) -> 0x20
     *   0x08 + 0xa0 -> 0xa8
     *   0x01 + 0x08 -> 0x09
     *   0x09 + 0xa8 -> 0xb1
     *   0xb1 + 0x02 -> 0xb3
     *   0x02 + 0xc0 -> 0xc2
     *   base64(0xc2) -> X-Argus
     *
     * Focused run mechanically verifies every CF30 concat:
     *   slot4 == slot5 || slot6
     * and verifies:
     *   base64(final 0xc2 pack) == final X-Argus
     *
     * CF42/CF43 note:
     *   These are native binding helpers (`0x16F48C`, `0x16F4C4`), not managed
     *   programs F42/F43.
     *
     *   CF42 is exact now: it emits low16(slot5) as a 2-byte little-endian
     *   MEM_BLOCK.
     *
     *   CF43 current F5 path is exact at the boundary: modeDesc[0].type=1,
     *   bodyB3 is PKCS#7 padded to 0xc0, then AES-128-CBC encrypts in place.
     *   0x11C8D8 saved_x2_after equals the final outC0.
     */

    MEM_BLOCK digest32_or_material_a;  /* hit12 slot5, len 0x20 */
    MEM_BLOCK dyn4;                    /* hit12 slot6, len 0x04 */
    MEM_BLOCK pack24;                  /* hit12 slot4, len 0x24; storage later reused as CF41 out */
    MEM_BLOCK pack44;                  /* hit13 slot4, len 0x44 */
    uint8_t sm3_44[0x20];              /* hit14/15 */
    MEM_BLOCK argusPlain92;             /* hit16 CF41 slot4 input, len 0x92 */
    MEM_BLOCK key32_material;           /* hit16 CF41 slot6 key/material, len 0x20 */

    MEM_BLOCK const8_or_count;         /* hit17 slot5, len 0x08 */
    MEM_BLOCK transformA0;             /* hit17 slot6, len 0xa0 */
    MEM_BLOCK tailA8;                  /* hit17 slot4, len 0xa8 */

    MEM_BLOCK prefix1;                 /* hit21 slot5, len 0x01 */
    MEM_BLOCK prefix8;                 /* hit21 slot6, len 0x08 */
    MEM_BLOCK prefix9;                 /* hit21 slot4, len 0x09 */
    MEM_BLOCK bodyB1;                  /* hit22 slot4, len 0xb1 */

    MEM_BLOCK suffix2;                 /* hit23/24, current run bytes: 80 6f */
    MEM_BLOCK bodyB3;                  /* hit24 slot4, len 0xb3 */
    MEM_BLOCK key16;                   /* hit25 slot6, CF43 requires len 0x10 */
    MEM_BLOCK side10;                  /* hit27 slot7, len 0x10 */
    void *modeDesc;                    /* hit25 slot8, CF43 mode descriptor */
    MEM_BLOCK outC0;                   /* hit27 slot6, len 0xc0 */
    MEM_BLOCK prefix2;                 /* hit26/27, current run bytes: 1b e1 */
    MEM_BLOCK argusC2;                 /* hit27/28 final CF44 input, len 0xc2 */
    REF_MEM_BLOCK b64_ref;             /* hit28 output */

    pack24 = concatMemBlock2(&digest32_or_material_a, &dyn4);
    pack44 = concatMemBlock2(&pack24, &digest32_or_material_a);
    sm3OneShot_F15InitUpdateFinal_350(pack44.body.mem, pack44.body.src_len, sm3_44);

    transformA0 = CF41_argusTailSimon128256(&argusPlain92, &key32_material);

    tailA8 = concatMemBlock2(&const8_or_count, &transformA0);
    copyMemBlockData(&pack44, &tailA8);   /* hit18 copies the 0xa8 tail forward */

    prefix9 = concatMemBlock2(&prefix1, &prefix8);
    bodyB1 = concatMemBlock2(&prefix9, &tailA8);

    suffix2 = makeU16MemBlockLE(0x6f80);
    bodyB3 = concatMemBlock2(&bodyB1, &suffix2);

    outC0 = CF43_argusTailAes128CbcPkcs7Encrypt(&bodyB3, &key16, &side10, modeDesc);
    prefix2 = makeU16MemBlockLE(0x6f80e11b);
    argusC2 = concatMemBlock2(&prefix2, &outC0);

    doBase64Encode(&argusC2, &b64_ref);
    formatAllocString_350(pack->out_key, "%s");    /* "X-Argus" */
    formatAllocString_350(pack->out_value, "%s");  /* base64 string */
}

/* ------------------------------------------------------------------------- */
/* CF48/CF49: short header transform and pack                                 */
/* ------------------------------------------------------------------------- */

uint64_t shortHeaderTransform32_flattened_CF48_350_recovered(
    MEM_BLOCK *formatted_text,
    MEM_BLOCK *out_transform32,
    MEM_BLOCK *key_material32)
{
    /*
     * Real function: 0x16CCD8.
     *
     * 【中文】这里是短头变换核心，但函数本体被 BR X8 + 0x29F420 共享跳表
     * 扁平化。现在已确认到比“黑盒 transform”更细的一层：
     *
     *   formatted_text len 0x1a  ->  "1788108717-1588093228-1128"
     *   key_material32 len 0x20  ->  ASCII hex-like material
     *   out_transform32 len 0x20 ->  binary result
     *
     * 正常非空 slot4 入口 index=0x58；slot4 为空走 fallback index=0x54。
     * index 0x58 进入 0x16CD2C，先 clone/pad key_material32 到 32 字节，
     * 再调用 0x16E794(text.mem, text.len, &out_ptr, &out_len, key32.mem)。
     *
     * 0x16E794 内部会调用 0x16E8FC(key32, schedule)。0x16E8FC 是一个
     * 64-bit ARX-like schedule/mixer：
     *
     *   state[0..3] = four qwords from key32;
     *   emit state[0];
     *   for i in 0..0x21:
     *       nb = ror64(state[1], 8) + state[0];
     *       nb ^= i;
     *       na = nb ^ ror64(state[0], 61);
     *       state = { na, state[2], state[3], nb };
     *       emit state[0];
     *
     * schedule 之后由 0x17184C 调 managed F17（global 0x2C5958，
     * code body 0x8721C0）逐 16-byte block 变换。F17 是 34 轮：
     *
     *   x = (ror64(x, 8) + y) ^ schedule[i];
     *   y = rol64(y, 3) ^ x;
     *
     * 详细记录见:
     *   dyidre/versions/350101/cf48_short_transform_lift_350101.md
     *   dyidre/versions/350101/cf48_f17_recovered_350101.c
     */
    return flattened_dispatch_16b8_16e4_350(0x58, formatted_text, out_transform32,
                                            key_material32);
}

uint64_t cf48_shortHeaderTransform32_slot4_text_slot5_out_slot6_key_350_recovered(
    ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16F660.
     *
     * 【中文】F7/F13 短头路径：
     *   slot4 = CF100 产生的明文 MEM_BLOCK
     *   slot5 = 先是 4-byte prefix/scratch，返回后被重写成 32-byte transform
     *   slot6 = 32-byte ASCII key/material
     */
    MEM_BLOCK *text = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *out_transform32 = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    MEM_BLOCK *key_material32 = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 6);
    return shortHeaderTransform32_flattened_CF48_350(text, out_transform32,
                                                     key_material32);
}

MEM_BLOCK *cf49_buildShortHeaderPack36_slot4_prefix_slot5_xform_ret2_350_recovered(
    ManagedFrame350 *frame)
{
    /*
     * Real function: 0x16F6B0.
     *
     * 【中文】把 4-byte prefix 和 CF48 的 32-byte result 拼成 0x24 binary pack。
     * 这个 pack 立刻被 CF44 base64，得到 48 字符 X-Ladon/X-Helios。
     */
    MEM_BLOCK *prefix4_dst = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 4);
    MEM_BLOCK *transform32 = (MEM_BLOCK *)managedFrameGetSlot_350(frame, 5);
    MEM_BLOCK *pack36 = (MEM_BLOCK *)catMemBlock2(prefix4_dst, transform32);
    managedFrameSetSlot_350(frame, 2, (uint64_t)pack36);
    return pack36;
}

void build_short_header_value_F7_or_F13_shape_350_recovered(
    ManagedFrame350 *frame,
    MetaSecManagedShortCallArg350 *pack)
{
    /*
     * This is not one native function.  It is the lifted bytecode shape of:
     *
     *   F7  -> X-Ladon
     *   F13 -> X-Helios
     *
     * 【中文】这是 managed bytecode 的语义 lift：
     *   CF100 -> CF38 -> CF38 -> CF48 -> CF49 -> CF44 -> CF98 -> CF98
     */
    MEM_BLOCK text;          /* "seed-appid-sdkver" */
    MEM_BLOCK prefix4;       /* 4-byte prefix from bytecode material */
    MEM_BLOCK transform32;   /* rewritten by CF48 */
    REF_MEM_BLOCK b64_ref;   /* output of CF44 */

    formatStringToMemBlock5_350(&text, "%u-%s-%s",
                                (uint32_t)pack->seed_or_handle,
                                pack->stack_memblock->body.mem,
                                pack->derived_block->body.mem);

    initMemBlockBySrc(&prefix4, pseudo_bytecode_prefix4_ptr(), 4);
    initMemBlockBySrc(&transform32, pseudo_bytecode_prefix4_ptr(), 4);

    /*
     * CF48 runtime examples:
     *
     * X-Ladon:
     *   text    = "1788108717-1588093228-1128"
     *   key32   = "b5b49dcffaa587dccaa36fec8005a08c"
     *   out32   = 7a bd 4b db 12 ba 2b 22 82 a8 ef fd 65 ea 43 27
     *             0d 9c f5 e5 de be c2 51 0c 62 ca 70 17 a4 31 fe
     *   pack36  = 7c c8 a0 10 || out32
     *   base64  = "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+"
     *
     * X-Helios:
     *   key32   = "c4aebafaa687f565cdec6d5eb75c95de"
     *   out32   = 74 f5 5f 3e 23 d3 c8 57 0d 15 df e5 d4 a2 fd c0
     *             65 c7 e3 ce c2 68 67 54 5a 79 24 ef 16 a3 6a f9
     *   pack36  = 30 e4 7f 2c || out32
     *   base64  = "MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5"
     */
    shortHeaderTransform32_flattened_CF48_350(&text, &transform32,
                                              pseudo_short_header_key32());
    MEM_BLOCK *pack36 = (MEM_BLOCK *)catMemBlock2(&prefix4, &transform32);
    doBase64Encode(pack36, &b64_ref);

    formatAllocString_350(pack->out_key, "%s");
    formatAllocString_350(pack->out_value, "%s");
}

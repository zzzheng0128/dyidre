/*
 * 350.101 header-level algorithm lift.
 *
 * This is the layer above the CF/F primitive oracles:
 *
 *   X-Ladon / X-Helios:
 *     CF100("%u-%s-%s") -> CF48/F17 -> CF49 -> CF44(base64)
 *
 *   X-Argus:
 *     XArgusStruct protobuf wire builder:
 *       MetaSecXArgusStruct350 fields -> 0x92 plaintext
 *       -> CF41(SIMON128/256 + PKCS#7) -> 0xa0 encrypted work block
 *     recovered tail path:
 *       reverse_xor(08||CF41out, mask4) -> bodyB3 tail
 *       -> CF43(AES-128-CBC + PKCS#7) -> CF42 prefix2 -> CF44(base64)
 *
 *   X-Medusa:
 *     final pack combiner:
 *       mini20 || const2 || zero1 || one1 || marker1 || subpack -> CF44(base64)
 *     The mini/F12/source-work mutations live in their own recovered modules.
 *
 *   X-Gorgon:
 *     url_digest4 || x_ss_stub[0..4] || zero4 || gorgon_word_le || seed_be
 *       -> 0x16CEA0 short-code/pointer-mixed RC4-like transform
 *       -> hex(raw26)
 *
 *   X-Khronos:
 *     snprintf("%u", seed)
 *
 *   X-Soter:
 *     current empty/default pack: 00 01 00 02 || zero86 -> CF44(base64)
 *
 * Not claimed here:
 *   - complete runtime discovery of url_digest4 before X-Gorgon;
 *   - complete non-empty X-Soter environment fields;
 *   - full F8 environment collection before the final Medusa pack.
 */

#include "metasec_350101_recovered_c.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int append_bytes_350101(uint8_t *out,
                               size_t out_cap,
                               size_t *off,
                               const void *src,
                               size_t src_len)
{
    if (*off > out_cap || src_len > out_cap - *off) {
        return 0;
    }
    memcpy(out + *off, src, src_len);
    *off += src_len;
    return 1;
}

static int append_varint_350101(uint8_t *out,
                                size_t out_cap,
                                size_t *off,
                                uint64_t value)
{
    do {
        uint8_t byte = (uint8_t)(value & 0x7f);
        value >>= 7;
        if (value != 0) {
            byte |= 0x80;
        }
        if (!append_bytes_350101(out, out_cap, off, &byte, 1)) {
            return 0;
        }
    } while (value != 0);
    return 1;
}

static int append_proto_key_350101(uint8_t *out,
                                   size_t out_cap,
                                   size_t *off,
                                   uint32_t field,
                                   uint32_t wire_type)
{
    return append_varint_350101(out, out_cap, off,
                                ((uint64_t)field << 3) | wire_type);
}

static int append_proto_varint_350101(uint8_t *out,
                                      size_t out_cap,
                                      size_t *off,
                                      uint32_t field,
                                      uint64_t value)
{
    return append_proto_key_350101(out, out_cap, off, field, 0) &&
           append_varint_350101(out, out_cap, off, value);
}

static int append_proto_bytes_350101(uint8_t *out,
                                     size_t out_cap,
                                     size_t *off,
                                     uint32_t field,
                                     const uint8_t *src,
                                     size_t src_len)
{
    return append_proto_key_350101(out, out_cap, off, field, 2) &&
           append_varint_350101(out, out_cap, off, src_len) &&
           append_bytes_350101(out, out_cap, off, src, src_len);
}

static int append_proto_string_350101(uint8_t *out,
                                      size_t out_cap,
                                      size_t *off,
                                      uint32_t field,
                                      const char *value)
{
    return value == NULL ||
           append_proto_bytes_350101(out, out_cap, off, field,
                                     (const uint8_t *)value, strlen(value));
}

static void put_u16le_350101(uint8_t out[2], uint16_t value)
{
    out[0] = (uint8_t)value;
    out[1] = (uint8_t)(value >> 8);
}

static void put_u32le_350101(uint8_t out[4], uint32_t value)
{
    out[0] = (uint8_t)value;
    out[1] = (uint8_t)(value >> 8);
    out[2] = (uint8_t)(value >> 16);
    out[3] = (uint8_t)(value >> 24);
}

static void put_u32be_350101(uint8_t out[4], uint32_t value)
{
    out[0] = (uint8_t)(value >> 24);
    out[1] = (uint8_t)(value >> 16);
    out[2] = (uint8_t)(value >> 8);
    out[3] = (uint8_t)value;
}

static uint32_t ror32_350101(uint32_t value, unsigned shift)
{
    shift &= 31;
    return (value >> shift) | (value << ((32 - shift) & 31));
}

static uint32_t rev16_32_350101(uint32_t value)
{
    return ((value & 0x00ff00ffU) << 8) |
           ((value & 0xff00ff00U) >> 8);
}

static uint8_t reverse_bits8_350101(uint8_t value)
{
    value = (uint8_t)(((value & 0x55u) << 1) | ((value >> 1) & 0x55u));
    value = (uint8_t)(((value & 0x33u) << 2) | ((value >> 2) & 0x33u));
    return (uint8_t)((value << 4) | (value >> 4));
}

static size_t bytes_to_lower_hex_350101(const uint8_t *src,
                                        size_t src_len,
                                        char *out,
                                        size_t out_cap)
{
    static const char kHex[] = "0123456789abcdef";
    if (out_cap < src_len * 2 + 1) {
        return 0;
    }
    for (size_t i = 0; i < src_len; i++) {
        out[i * 2] = kHex[src[i] >> 4];
        out[i * 2 + 1] = kHex[src[i] & 0x0f];
    }
    out[src_len * 2] = '\0';
    return src_len * 2;
}

void metasec_build_x_gorgon_material20_350101(uint8_t out20[20],
                                              const uint8_t url_digest4[4],
                                              const uint8_t x_ss_stub16[16],
                                              uint32_t gorgon_word,
                                              uint32_t seed)
{
    memcpy(out20, url_digest4, 4);
    memcpy(out20 + 4, x_ss_stub16, 4);
    memset(out20 + 8, 0, 4);
    put_u32le_350101(out20 + 12, gorgon_word);
    put_u32be_350101(out20 + 16, seed);
}

size_t metasec_build_x_gorgon_raw_350101(uint8_t out26[26],
                                         const uint8_t material20[20],
                                         uint16_t short_code,
                                         uint16_t raw_body_addr_low16)
{
    uint8_t sbox[256];
    uint8_t key8[8];
    uint8_t i8 = 0;
    uint8_t j8 = 0;

    memset(out26, 0, 26);

    /*
     * 0x16D1DC + surrounding stack setup.
     *
     * raw_body_addr_low16 is the low 16 bits of the temporary raw MEM_BLOCK
     * body address. 350.101 mixes it into both the visible header bytes and
     * the KSA key, so deterministic tests must pass the observed low16.
     */
    out26[0] = 0x84;
    key8[0] = 0x4a;
    key8[1] = (uint8_t)short_code;
    key8[2] = 0x16;
    key8[3] = (uint8_t)(raw_body_addr_low16 >> 8);
    key8[4] = 0x47;
    key8[5] = 0x6c;
    key8[6] = (uint8_t)(short_code >> 8);
    key8[7] = (uint8_t)raw_body_addr_low16;

    for (int i = 0; i < 256; i++) {
        sbox[i] = (uint8_t)i;
    }

    /*
     * RC4-like KSA from 0x16CFE0..0x16D070.
     *
     * Note the non-standard "swap": both S[i] and S[j] are assigned S[j].
     * This is not a typo; it mirrors the emitted AArch64 exactly.
     */
    for (int i = 0; i < 256; i++) {
        if (i == 203) {
            out26[3] = (uint8_t)(raw_body_addr_low16 >> 8);
        }
        j8 = (uint8_t)(j8 + sbox[i] + key8[i & 7]);
        uint8_t sj = sbox[j8];
        sbox[i] = sj;
        if (i == 224) {
            out26[4] = (uint8_t)short_code;
            out26[5] = (uint8_t)(short_code >> 8);
        }
        sbox[j8] = sj;
    }

    memcpy(out26 + 6, material20, 20);

    /*
     * PRGA-like stream xor from 0x16D078..0x16D10C.
     * It repeats the same non-standard S[j] duplication.
     */
    i8 = 0;
    j8 = 0;
    for (int k = 0; k < 20; k++) {
        i8 = (uint8_t)(i8 + 1);
        j8 = (uint8_t)(j8 + sbox[i8]);
        uint8_t sj = sbox[j8];
        sbox[i8] = sj;
        sbox[j8] = sj;
        out26[6 + k] ^= sbox[(uint8_t)(sbox[i8] + sj)];
    }

    /*
     * Final byte mixer from 0x16D110..0x16D190:
     * nibble swap, xor next byte (last byte xors the already-finalized first
     * byte), bit-reverse, then len ^ ~byte.
     */
    for (int k = 0; k < 20; k++) {
        uint8_t b = out26[6 + k];
        b = (uint8_t)((b >> 4) | (b << 4));
        if (k + 1 < 20) {
            b ^= out26[6 + k + 1];
            if (k == 0) {
                out26[2] = (uint8_t)raw_body_addr_low16;
            }
        } else {
            b ^= out26[6];
        }
        b = reverse_bits8_350101(b);
        out26[6 + k] = (uint8_t)(20u ^ (uint8_t)~b);
    }

    out26[1] = 4;
    return 26;
}

size_t metasec_build_x_gorgon_value_350101(char *out_hex,
                                           size_t out_cap,
                                           const uint8_t url_digest4[4],
                                           const uint8_t x_ss_stub16[16],
                                           uint32_t gorgon_word,
                                           uint32_t seed,
                                           uint16_t short_code,
                                           uint16_t raw_body_addr_low16)
{
    uint8_t material20[20];
    uint8_t raw26[26];
    metasec_build_x_gorgon_material20_350101(
        material20, url_digest4, x_ss_stub16, gorgon_word, seed);
    metasec_build_x_gorgon_raw_350101(
        raw26, material20, short_code, raw_body_addr_low16);
    return bytes_to_lower_hex_350101(raw26, sizeof(raw26), out_hex, out_cap);
}

size_t metasec_build_x_khronos_value_350101(char *out,
                                            size_t out_cap,
                                            uint32_t seed)
{
    int n = snprintf(out, out_cap, "%u", seed);
    if (n < 0 || (size_t)n >= out_cap) {
        return 0;
    }
    return (size_t)n;
}

size_t metasec_build_x_soter_value_from_pack_350101(char *out_b64,
                                                    size_t out_cap,
                                                    const uint8_t *pack,
                                                    size_t pack_len)
{
    return cf44_base64_encode_350101(pack, pack_len, out_b64, out_cap);
}

size_t metasec_build_x_soter_empty_value_350101(char *out_b64,
                                                size_t out_cap)
{
    uint8_t pack90[90];
    memset(pack90, 0, sizeof(pack90));
    pack90[1] = 1;
    pack90[3] = 2;
    return metasec_build_x_soter_value_from_pack_350101(
        out_b64, out_cap, pack90, sizeof(pack90));
}

size_t metasec_build_x_argus_algorithm_seq_plain_350101(
    uint8_t *out,
    size_t out_cap,
    const MetaSecXArgusAlgorithmSeq350 *seq)
{
    size_t off = 0;

    if (seq == NULL) {
        return 0;
    }

    /*
     * Runtime bytes use normal protobuf varint values here. Although the
     * public proto file labels these as sint32, the observed wire bytes are
     * raw varints: value 2 is encoded as 0x02, not zig-zag 0x04.
     */
    if ((seq->has_k1_algo_seq &&
         !append_proto_varint_350101(out, out_cap, &off, 1, seq->k1_algo_seq)) ||
        (seq->has_k2_report_seq &&
         !append_proto_varint_350101(out, out_cap, &off, 2, seq->k2_report_seq)) ||
        (seq->has_k3_setting_seq &&
         !append_proto_varint_350101(out, out_cap, &off, 3, seq->k3_setting_seq)) ||
        (seq->has_k4_error_seq &&
         !append_proto_varint_350101(out, out_cap, &off, 4, seq->k4_error_seq)) ||
        (seq->has_k5_last_report_id &&
         !append_proto_varint_350101(out, out_cap, &off, 5, seq->k5_last_report_id))) {
        return 0;
    }

    return off;
}

size_t metasec_build_x_argus_plain_350101(
    uint8_t *out,
    size_t out_cap,
    const MetaSecXArgusStruct350 *msg)
{
    uint8_t seq_buf[64];
    size_t seq_len = 0;
    size_t off = 0;

    if (msg == NULL) {
        return 0;
    }

    if ((msg->has_k1_sdk_date &&
         !append_proto_varint_350101(out, out_cap, &off, 1, msg->k1_sdk_date)) ||
        (msg->has_k2_type &&
         !append_proto_varint_350101(out, out_cap, &off, 2, msg->k2_type)) ||
        (msg->has_k3_random_value &&
         !append_proto_varint_350101(out, out_cap, &off, 3, msg->k3_random_value)) ||
        !append_proto_string_350101(out, out_cap, &off, 4, msg->k4_aid) ||
        !append_proto_string_350101(out, out_cap, &off, 5, msg->k5_device_id) ||
        !append_proto_string_350101(out, out_cap, &off, 6, msg->k6_version_string) ||
        !append_proto_string_350101(out, out_cap, &off, 7, msg->k7_app_version_name) ||
        !append_proto_string_350101(out, out_cap, &off, 8, msg->k8_sdk_version_name) ||
        (msg->has_k9_sdk_version_code &&
         !append_proto_varint_350101(out, out_cap, &off, 9, msg->k9_sdk_version_code)) ||
        (msg->k10_proto_header.data != NULL &&
         !append_proto_bytes_350101(out, out_cap, &off, 10,
                                    msg->k10_proto_header.data,
                                    msg->k10_proto_header.len)) ||
        !append_proto_string_350101(out, out_cap, &off, 11, msg->k11_platform) ||
        (msg->has_k12_khronos &&
         !append_proto_varint_350101(out, out_cap, &off, 12, msg->k12_khronos)) ||
        (msg->k13_xssstub_sm3.data != NULL &&
         !append_proto_bytes_350101(out, out_cap, &off, 13,
                                    msg->k13_xssstub_sm3.data,
                                    msg->k13_xssstub_sm3.len)) ||
        (msg->k14_url_sm3.data != NULL &&
         !append_proto_bytes_350101(out, out_cap, &off, 14,
                                    msg->k14_url_sm3.data,
                                    msg->k14_url_sm3.len))) {
        return 0;
    }

    if (msg->has_k15_algorithm_seq) {
        seq_len = metasec_build_x_argus_algorithm_seq_plain_350101(
            seq_buf, sizeof(seq_buf), &msg->k15_algorithm_seq);
        if (seq_len == 0 ||
            !append_proto_bytes_350101(out, out_cap, &off, 15,
                                       seq_buf, seq_len)) {
            return 0;
        }
    }

    if (!append_proto_string_350101(out, out_cap, &off, 16, msg->k16_ms_token) ||
        (msg->has_k17_khronos &&
         !append_proto_varint_350101(out, out_cap, &off, 17, msg->k17_khronos)) ||
        (msg->k18.data != NULL &&
         !append_proto_bytes_350101(out, out_cap, &off, 18,
                                    msg->k18.data, msg->k18.len)) ||
        (msg->k19.data != NULL &&
         !append_proto_bytes_350101(out, out_cap, &off, 19,
                                    msg->k19.data, msg->k19.len)) ||
        !append_proto_string_350101(out, out_cap, &off, 20, msg->k20_pskVersion) ||
        (msg->has_k21_callType &&
         !append_proto_varint_350101(out, out_cap, &off, 21, msg->k21_callType))) {
        return 0;
    }

    return off;
}

size_t metasec_build_short_header_value_350101(char *out_b64,
                                               size_t out_cap,
                                               const char *formatted_text,
                                               const uint8_t key32_ascii[32],
                                               const uint8_t prefix4[4])
{
    uint8_t transform32[32];
    uint8_t pack36[36];
    size_t text_len = strlen(formatted_text);
    size_t transform_len = cf48_transform_text_key32_350101(
        (const uint8_t *)formatted_text,
        text_len,
        key32_ascii,
        transform32,
        sizeof(transform32));
    if (transform_len != sizeof(transform32)) {
        return 0;
    }

    cf49_pack_prefix4_transform32_350101(prefix4, transform32, pack36);
    return cf44_base64_encode_350101(pack36, sizeof(pack36), out_b64, out_cap);
}

static size_t build_seed_short_header_350101(char *out_b64,
                                             size_t out_cap,
                                             uint32_t seed,
                                             const char *stack_memblock,
                                             const char *derived_block,
                                             const uint8_t key32_ascii[32],
                                             const uint8_t prefix4[4])
{
    char formatted_text[128];
    int n = snprintf(formatted_text, sizeof(formatted_text),
                     "%u-%s-%s", seed, stack_memblock, derived_block);
    if (n < 0 || (size_t)n >= sizeof(formatted_text)) {
        return 0;
    }
    return metasec_build_short_header_value_350101(
        out_b64, out_cap, formatted_text, key32_ascii, prefix4);
}

size_t metasec_build_x_ladon_value_350101(char *out_b64,
                                          size_t out_cap,
                                          uint32_t seed,
                                          const char *stack_memblock,
                                          const char *derived_block,
                                          const uint8_t key32_ascii[32],
                                          const uint8_t prefix4[4])
{
    return build_seed_short_header_350101(out_b64, out_cap, seed,
                                          stack_memblock, derived_block,
                                          key32_ascii, prefix4);
}

size_t metasec_build_x_helios_value_350101(char *out_b64,
                                           size_t out_cap,
                                           uint32_t seed,
                                           const char *stack_memblock,
                                           const char *derived_block,
                                           const uint8_t key32_ascii[32],
                                           const uint8_t prefix4[4])
{
    return build_seed_short_header_350101(out_b64, out_cap, seed,
                                          stack_memblock, derived_block,
                                          key32_ascii, prefix4);
}

size_t metasec_build_x_argus_tail_value_350101(char *out_b64,
                                               size_t out_cap,
                                               const uint8_t *body_b3,
                                               size_t body_b3_len,
                                               const uint8_t key16[16],
                                               const uint8_t iv16[16],
                                               uint16_t final_prefix2_le)
{
    uint8_t out_cbc[0x400];
    uint8_t final_pack[0x402];
    uint8_t prefix2[2];
    size_t final_len = 0;

    size_t cbc_len = metasec_cf43_aes128_cbc_pkcs7_encrypt_350101(
        out_cbc, sizeof(out_cbc), body_b3, body_b3_len, key16, iv16);
    if (cbc_len == 0) {
        return 0;
    }

    put_u16le_350101(prefix2, final_prefix2_le);
    if (!append_bytes_350101(final_pack, sizeof(final_pack), &final_len,
                             prefix2, sizeof(prefix2)) ||
        !append_bytes_350101(final_pack, sizeof(final_pack), &final_len,
                             out_cbc, cbc_len)) {
        return 0;
    }

    return cf44_base64_encode_350101(final_pack, final_len, out_b64, out_cap);
}

void metasec_x_argus_mask_from_seed_350101(uint8_t out4[4], uint32_t seed)
{
    /*
     * F5 records 0x020c..0x0215:
     *   CF69(..., 2) -> W2
     *   REV16 W2; ROR #16; store as the 4-byte xor mask.
     *
     * Current 350.101 vector: seed 0xfffc4ffa -> mask bytes ff fc 4f fa.
     */
    put_u32le_350101(out4, ror32_350101(rev16_32_350101(seed), 16));
}

size_t metasec_x_argus_reverse_xor_tail_350101(uint8_t *out,
                                               size_t out_cap,
                                               const uint8_t *src,
                                               size_t src_len,
                                               const uint8_t mask4[4])
{
    if (out == NULL || src == NULL || mask4 == NULL || src_len > out_cap) {
        return 0;
    }

    /*
     * F5 records 0x021f..0x022c:
     *   for i in 0..len-1:
     *       dst[i] = src[len - 1 - i] ^ mask[i & 3]
     *
     * This is the missing work-area rewrite between:
     *   tailA8 = 08 00 00 00 00 00 00 00 || CF41out
     * and the AES bodyB3 tail used by CF43.
     */
    for (size_t i = 0; i < src_len; i++) {
        out[i] = (uint8_t)(src[src_len - 1 - i] ^ mask4[i & 3]);
    }
    return src_len;
}

size_t metasec_build_x_argus_value_from_plain_350101(char *out_b64,
                                                     size_t out_cap,
                                                     const uint8_t prefix9[9],
                                                     const uint8_t tail_le64[8],
                                                     const uint8_t *argus_plain,
                                                     size_t argus_plain_len,
                                                     const uint8_t simon_key32[32],
                                                     const uint8_t tail_mask4[4],
                                                     uint16_t suffix2_le,
                                                     const uint8_t aes_key16[16],
                                                     const uint8_t aes_iv16[16],
                                                     uint16_t final_prefix2_le)
{
    uint8_t simon_a0[0x300];
    uint8_t tail_a8[0x400];
    uint8_t mutated_tail[0x400];
    uint8_t body_b3[0x500];
    uint8_t suffix2[2];
    size_t tail_len = 0;
    size_t body_len = 0;

    size_t simon_len = metasec_cf41_simon128_256_pkcs7_encrypt_350101(
        argus_plain, argus_plain_len, simon_key32, simon_a0, sizeof(simon_a0));
    if (simon_len == 0) {
        return 0;
    }

    if (!append_bytes_350101(tail_a8, sizeof(tail_a8), &tail_len,
                             tail_le64, 8) ||
        !append_bytes_350101(tail_a8, sizeof(tail_a8), &tail_len,
                             simon_a0, simon_len)) {
        return 0;
    }

    if (metasec_x_argus_reverse_xor_tail_350101(
            mutated_tail, sizeof(mutated_tail), tail_a8, tail_len,
            tail_mask4) != tail_len) {
        return 0;
    }

    put_u16le_350101(suffix2, suffix2_le);
    if (!append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             prefix9, 9) ||
        !append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             mutated_tail, tail_len) ||
        !append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             suffix2, sizeof(suffix2))) {
        return 0;
    }

    return metasec_build_x_argus_tail_value_350101(
        out_b64, out_cap, body_b3, body_len,
        aes_key16, aes_iv16, final_prefix2_le);
}

size_t metasec_build_x_argus_tail_from_plain_350101(char *out_b64,
                                                    size_t out_cap,
                                                    const uint8_t prefix9[9],
                                                    const uint8_t tail_le64[8],
                                                    const uint8_t *argus_plain,
                                                    size_t argus_plain_len,
                                                    const uint8_t simon_key32[32],
                                                    uint16_t suffix2_le,
                                                    const uint8_t aes_key16[16],
                                                    const uint8_t aes_iv16[16],
                                                    uint16_t final_prefix2_le)
{
    uint8_t simon_a0[0x300];
    uint8_t body_b3[0x400];
    uint8_t suffix2[2];
    size_t body_len = 0;

    size_t simon_len = metasec_cf41_simon128_256_pkcs7_encrypt_350101(
        argus_plain, argus_plain_len, simon_key32, simon_a0, sizeof(simon_a0));
    if (simon_len == 0) {
        return 0;
    }

    put_u16le_350101(suffix2, suffix2_le);
    if (!append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             prefix9, 9) ||
        !append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             tail_le64, 8) ||
        !append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             simon_a0, simon_len) ||
        !append_bytes_350101(body_b3, sizeof(body_b3), &body_len,
                             suffix2, sizeof(suffix2))) {
        return 0;
    }

    return metasec_build_x_argus_tail_value_350101(
        out_b64, out_cap, body_b3, body_len, aes_key16, aes_iv16, final_prefix2_le);
}

size_t metasec_build_x_medusa_pack_350101(uint8_t *out_pack,
                                          size_t out_cap,
                                          const uint8_t mini20[0x14],
                                          const uint8_t const2[2],
                                          uint8_t zero1,
                                          uint8_t one1,
                                          uint8_t marker1,
                                          const uint8_t *subpack,
                                          size_t subpack_len)
{
    size_t off = 0;
    if (!append_bytes_350101(out_pack, out_cap, &off, mini20, 0x14) ||
        !append_bytes_350101(out_pack, out_cap, &off, const2, 2) ||
        !append_bytes_350101(out_pack, out_cap, &off, &zero1, 1) ||
        !append_bytes_350101(out_pack, out_cap, &off, &one1, 1) ||
        !append_bytes_350101(out_pack, out_cap, &off, &marker1, 1) ||
        !append_bytes_350101(out_pack, out_cap, &off, subpack, subpack_len)) {
        return 0;
    }
    return off;
}

size_t metasec_build_x_medusa_value_from_pack_350101(char *out_b64,
                                                     size_t out_cap,
                                                     const uint8_t *pack,
                                                     size_t pack_len)
{
    return cf44_base64_encode_350101(pack, pack_len, out_b64, out_cap);
}

#ifndef METASEC_350101_NO_MAIN
static int check_string_350101(const char *name, const char *got, const char *expect)
{
    int ok = strcmp(got, expect) == 0;
    printf("%s match=%s len=0x%zx\n", name, ok ? "true" : "false", strlen(got));
    if (!ok) {
        printf("  got=%s\n  exp=%s\n", got, expect);
    }
    return ok ? 0 : 1;
}

static int hexval_350101(int c)
{
    if ('0' <= c && c <= '9') return c - '0';
    if ('a' <= c && c <= 'f') return c - 'a' + 10;
    if ('A' <= c && c <= 'F') return c - 'A' + 10;
    return -1;
}

static size_t from_hex_350101(const char *hex, uint8_t *out, size_t cap)
{
    size_t n = 0;
    int hi = -1;
    for (; *hex; hex++) {
        int v = hexval_350101((unsigned char)*hex);
        if (v < 0) {
            continue;
        }
        if (hi < 0) {
            hi = v;
            continue;
        }
        if (n >= cap) {
            return 0;
        }
        out[n++] = (uint8_t)((hi << 4) | v);
        hi = -1;
    }
    return hi < 0 ? n : 0;
}

static void print_hex_350101(const uint8_t *p, size_t n)
{
    for (size_t i = 0; i < n; i++) {
        printf("%02x", p[i]);
    }
}

static int check_bytes_350101(const char *name,
                              const uint8_t *got,
                              size_t got_len,
                              const uint8_t *expect,
                              size_t expect_len)
{
    int ok = got_len == expect_len &&
             (got_len == 0 || memcmp(got, expect, got_len) == 0);
    printf("%s match=%s len=0x%zx\n", name, ok ? "true" : "false", got_len);
    if (!ok) {
        printf("  got=");
        print_hex_350101(got, got_len);
        printf("\n  exp=");
        print_hex_350101(expect, expect_len);
        printf("\n");
    }
    return ok ? 0 : 1;
}

static size_t read_fixture_350101(const char *path, uint8_t *out, size_t cap)
{
    FILE *fp = fopen(path, "rb");
    if (fp == NULL) {
        return 0;
    }
    size_t n = fread(out, 1, cap, fp);
    int extra = fgetc(fp);
    fclose(fp);
    return extra == EOF ? n : 0;
}

int main(void)
{
    int failures = 0;
    char out[1200];

    static const uint8_t gorgon_url_digest4[4] = {0xec, 0x8a, 0x33, 0xe2};
    static const uint8_t gorgon_xss_stub16[16] = {
        0xfd, 0xf6, 0x0e, 0x82, 0xc1, 0x60, 0x76, 0x06,
        0xe7, 0x38, 0x6b, 0xa8, 0x8d, 0x06, 0xb4, 0xca,
    };
    metasec_build_x_gorgon_value_350101(out, sizeof(out),
                                        gorgon_url_digest4,
                                        gorgon_xss_stub16,
                                        0x04090500U,
                                        0x6a945360U,
                                        0x0008,
                                        0xc6e0);
    failures += check_string_350101(
        "X-Gorgon",
        out,
        "8404e0c60800b1144e023be9a08ef1ebebe5a6df25f723bef357");

    metasec_build_x_khronos_value_350101(out, sizeof(out), 0x6a945360U);
    failures += check_string_350101("X-Khronos", out, "1788105568");

    static const uint8_t ladon_key32[32] = "b5b49dcffaa587dccaa36fec8005a08c";
    static const uint8_t ladon_prefix4[4] = {0x7c, 0xc8, 0xa0, 0x10};
    metasec_build_x_ladon_value_350101(out, sizeof(out),
                                       1788108717U,
                                       "1588093228",
                                       "1128",
                                       ladon_key32,
                                       ladon_prefix4);
    failures += check_string_350101(
        "X-Ladon",
        out,
        "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+");

    static const uint8_t helios_key32[32] = "c4aebafaa687f565cdec6d5eb75c95de";
    static const uint8_t helios_prefix4[4] = {0x30, 0xe4, 0x7f, 0x2c};
    metasec_build_x_helios_value_350101(out, sizeof(out),
                                        1788108717U,
                                        "1588093228",
                                        "1128",
                                        helios_key32,
                                        helios_prefix4);
    failures += check_string_350101(
        "X-Helios",
        out,
        "MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5");

    static const char *argus_plain_hex =
        "08d2a4808204100218badcdea4062204313132382a0f333937333635363038323033343030320a313538383039333232"
        "383a0633352e312e3042147630342e30392e30352d6d6c2d616e64726f6964488094c8405208080000000000000060ae"
        "eea5a90d6a06cf03476f3b9672061f08578a515b7a0a080210bee15418bee1548801aeeea5a90da201046e6f6e65a801"
        "e205";
    static const char *argus_cf41_hex =
        "a63401c328e9e78209512f5cb612179abb71e1f08671630ca5619d4bf9b73c9920a322acee296319e43160ad3f316b3d"
        "2960af727fef5f4beed8834c11307f69b976de34d20913f1d2a77ee2831d350446dc643f6ec3065618310a4b1bdcb257"
        "b815ed8617c2a487cf74dcfc875cafd3b751daeee4deb3540068b0fcfe8427464926bf3e1e21f16452cb9e2934bac3ca"
        "6a038315aaab923ecfcdcb18d3741af8";
    static const uint8_t argus_proto_header[8] = {
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    };
    static const uint8_t argus_xssstub_sm3_6[6] = {
        0xcf, 0x03, 0x47, 0x6f, 0x3b, 0x96,
    };
    static const uint8_t argus_url_sm3_6[6] = {
        0x1f, 0x08, 0x57, 0x8a, 0x51, 0x5b,
    };
    static const uint8_t argus_simon_key32[32] = {
        0x4c, 0x6d, 0xce, 0x74, 0x7a, 0x11, 0x3c, 0xfa,
        0x83, 0x41, 0xda, 0x76, 0xa2, 0xfc, 0xe9, 0xbb,
        0x98, 0xd4, 0x7f, 0xc0, 0x25, 0x5c, 0x80, 0x21,
        0x29, 0x2a, 0x55, 0xf9, 0x11, 0xf9, 0x98, 0x4f,
    };
    MetaSecXArgusStruct350 argus_msg = {0};
    uint8_t argus_plain[0x100];
    uint8_t argus_plain_expect[0x100];
    uint8_t argus_cf41[0x120];
    uint8_t argus_cf41_expect[0x120];

    argus_msg.has_k1_sdk_date = 1;
    argus_msg.k1_sdk_date = 0x40401252ULL;
    argus_msg.has_k2_type = 1;
    argus_msg.k2_type = 2;
    argus_msg.has_k3_random_value = 1;
    argus_msg.k3_random_value = 0x6497ae3aULL;
    argus_msg.k4_aid = "1128";
    argus_msg.k5_device_id = "397365608203400";
    argus_msg.k6_version_string = "1588093228";
    argus_msg.k7_app_version_name = "35.1.0";
    argus_msg.k8_sdk_version_name = "v04.09.05-ml-android";
    argus_msg.has_k9_sdk_version_code = 1;
    argus_msg.k9_sdk_version_code = 0x08120a00ULL;
    argus_msg.k10_proto_header.data = argus_proto_header;
    argus_msg.k10_proto_header.len = sizeof(argus_proto_header);
    argus_msg.has_k12_khronos = 1;
    argus_msg.k12_khronos = 0xd529772eULL;
    argus_msg.k13_xssstub_sm3.data = argus_xssstub_sm3_6;
    argus_msg.k13_xssstub_sm3.len = sizeof(argus_xssstub_sm3_6);
    argus_msg.k14_url_sm3.data = argus_url_sm3_6;
    argus_msg.k14_url_sm3.len = sizeof(argus_url_sm3_6);
    argus_msg.has_k15_algorithm_seq = 1;
    argus_msg.k15_algorithm_seq.has_k1_algo_seq = 1;
    argus_msg.k15_algorithm_seq.k1_algo_seq = 2;
    argus_msg.k15_algorithm_seq.has_k2_report_seq = 1;
    argus_msg.k15_algorithm_seq.k2_report_seq = 0x1530be;
    argus_msg.k15_algorithm_seq.has_k3_setting_seq = 1;
    argus_msg.k15_algorithm_seq.k3_setting_seq = 0x1530be;
    argus_msg.has_k17_khronos = 1;
    argus_msg.k17_khronos = 0xd529772eULL;
    argus_msg.k20_pskVersion = "none";
    argus_msg.has_k21_callType = 1;
    argus_msg.k21_callType = 0x2e2;

    size_t argus_plain_len = metasec_build_x_argus_plain_350101(
        argus_plain, sizeof(argus_plain), &argus_msg);
    size_t argus_plain_expect_len = from_hex_350101(
        argus_plain_hex, argus_plain_expect, sizeof(argus_plain_expect));
    failures += check_bytes_350101("X-Argus protobuf plain",
                                   argus_plain, argus_plain_len,
                                   argus_plain_expect,
                                   argus_plain_expect_len);

    size_t argus_cf41_len = metasec_cf41_simon128_256_pkcs7_encrypt_350101(
        argus_plain, argus_plain_len, argus_simon_key32,
        argus_cf41, sizeof(argus_cf41));
    size_t argus_cf41_expect_len = from_hex_350101(
        argus_cf41_hex, argus_cf41_expect, sizeof(argus_cf41_expect));
    failures += check_bytes_350101("X-Argus CF41 SIMON",
                                   argus_cf41, argus_cf41_len,
                                   argus_cf41_expect,
                                   argus_cf41_expect_len);

    static const uint8_t argus_body_b3[] = {
        0x35, 0x79, 0xfb, 0xe6, 0x79, 0x01, 0xcf, 0x07, 0x18, 0x07, 0xe6, 0x3b, 0x29, 0xe7, 0x37, 0x82,
        0x35, 0xc1, 0x6e, 0xe4, 0x50, 0xea, 0x7f, 0x4c, 0x90, 0x35, 0x3f, 0xf5, 0xce, 0xd6, 0x62, 0x84,
        0xa8, 0x9b, 0x0d, 0x6e, 0xe4, 0xc1, 0x43, 0x69, 0xb3, 0xb9, 0xdb, 0xcb, 0x04, 0x03, 0x4c, 0x27,
        0xfa, 0xab, 0x4f, 0x91, 0x1e, 0x11, 0x26, 0x1e, 0x4d, 0x2c, 0x53, 0x13, 0x7d, 0x03, 0x20, 0x3b,
        0x35, 0x78, 0x58, 0x8d, 0xed, 0x79, 0x11, 0x5a, 0x42, 0xa8, 0x4e, 0x93, 0xe1, 0xb4, 0xf6, 0x7e,
        0xe2, 0xa9, 0xfa, 0x8c, 0x94, 0xc0, 0x98, 0x93, 0xbc, 0xfb, 0xc9, 0x52, 0x79, 0x1d, 0x82, 0xe8,
        0x28, 0x0e, 0xef, 0x46, 0x28, 0xcb, 0x22, 0x39, 0x43, 0x96, 0x83, 0x7f, 0xeb, 0xb3, 0x7f, 0x97,
        0x14, 0xb4, 0xa3, 0xa0, 0x85, 0x8d, 0x53, 0x2f, 0xd3, 0xc2, 0x97, 0x7e, 0xc5, 0x52, 0x9c, 0x7e,
        0x1e, 0xe6, 0x9f, 0x66, 0x14, 0x53, 0xde, 0xec, 0xda, 0x66, 0xc0, 0xf8, 0x03, 0xb4, 0x61, 0x2e,
        0x5f, 0xf3, 0x9f, 0x3e, 0x7c, 0x0f, 0x1d, 0x3e, 0x41, 0x65, 0xeb, 0x5d, 0x4c, 0xa3, 0xd3, 0x1e,
        0xf3, 0x7d, 0x1b, 0xa6, 0xd2, 0x3c, 0xfd, 0x7b, 0x5c, 0xff, 0xfc, 0x4f, 0xfa, 0xff, 0xfc, 0x4f,
        0xf2, 0x76, 0x70,
    };
    static const uint8_t argus_key16[16] = {
        0xf1, 0x59, 0x33, 0x76, 0x76, 0x6e, 0xa9, 0x8d,
        0x34, 0xf3, 0x1b, 0x05, 0x7a, 0x9d, 0x5b, 0xe4,
    };
    static const uint8_t argus_iv16[16] = {
        0x1f, 0xe1, 0x09, 0xa4, 0x12, 0x52, 0x83, 0xf4,
        0x18, 0xde, 0x9e, 0x05, 0x1a, 0x96, 0x9e, 0x12,
    };
    static const uint8_t argus_prefix9[9] = {
        0x35, 0x79, 0xfb, 0xe6, 0x79, 0x01, 0xcf, 0x07, 0x18,
    };
    static const uint8_t argus_tail_le64[8] = {
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    };
    static const uint8_t argus_tail_mask4[4] = {
        0xff, 0xfc, 0x4f, 0xfa,
    };
    static const char *argus_expect_b64 =
        "gTT7GEZDiKGCOJ/eSc0fdJQ9vhJ00b7LgJU9YQy31ilbDssF8svj6Msu7srj1BHSp2AkcITL0TDtLHvjBKn9E/i13NvQ9HIlOAyWhqrxQ8jy3/EOm0vWFnsRE+1SHOLIin1P9rEawJppGnVcZzywuGU/ycZvrQ5E2Qh7qGh8SU83eypVdcvinD4JvlWqdcsOTu6wNJpAYQEpfgbDa4J4hw+sAuaJYR7Mh8c6e6yn7xdDO42q2e1xCTGKad6IitQeJQg=";
    uint8_t argus_tail_a8[0x108];
    uint8_t argus_mutated_a8[0x108];
    uint8_t argus_mask_from_seed[4];
    size_t argus_tail_a8_len = 0;

    metasec_x_argus_mask_from_seed_350101(argus_mask_from_seed, 0xfffc4ffaU);
    failures += check_bytes_350101("X-Argus reverse-xor mask",
                                   argus_mask_from_seed,
                                   sizeof(argus_mask_from_seed),
                                   argus_tail_mask4,
                                   sizeof(argus_tail_mask4));

    if (!append_bytes_350101(argus_tail_a8, sizeof(argus_tail_a8),
                             &argus_tail_a8_len,
                             argus_tail_le64, sizeof(argus_tail_le64)) ||
        !append_bytes_350101(argus_tail_a8, sizeof(argus_tail_a8),
                             &argus_tail_a8_len,
                             argus_cf41, argus_cf41_len)) {
        failures++;
    } else {
        size_t mutated_len = metasec_x_argus_reverse_xor_tail_350101(
            argus_mutated_a8, sizeof(argus_mutated_a8),
            argus_tail_a8, argus_tail_a8_len,
            argus_tail_mask4);
        failures += check_bytes_350101("X-Argus mutated tailA8",
                                       argus_mutated_a8,
                                       mutated_len,
                                       argus_body_b3 + sizeof(argus_prefix9),
                                       sizeof(argus_body_b3) -
                                           sizeof(argus_prefix9) - 2);
    }

    metasec_build_x_argus_value_from_plain_350101(
        out, sizeof(out),
        argus_prefix9,
        argus_tail_le64,
        argus_plain,
        argus_plain_len,
        argus_simon_key32,
        argus_tail_mask4,
        0x7076,
        argus_key16,
        argus_iv16,
        0x3481);
    failures += check_string_350101("X-Argus full-from-plain",
                                    out,
                                    argus_expect_b64);

    metasec_build_x_argus_tail_value_350101(out, sizeof(out),
                                            argus_body_b3,
                                            sizeof(argus_body_b3),
                                            argus_key16,
                                            argus_iv16,
                                            0x3481);
    failures += check_string_350101(
        "X-Argus tail",
        out,
        argus_expect_b64);

    uint8_t medusa_pack[0x400];
    size_t medusa_len = read_fixture_350101(
        "dyidre/versions/350101/x_medusa_pack_350101_cf44_input.bin",
        medusa_pack,
        sizeof(medusa_pack));
    if (medusa_len == 0) {
        printf("X-Medusa fixture missing; run from project root\n");
        failures++;
    } else {
        metasec_build_x_medusa_value_from_pack_350101(out, sizeof(out),
                                                      medusa_pack, medusa_len);
        failures += check_string_350101(
            "X-Medusa final-pack",
            out,
            "oYSUaonP26Dt8ZkpmzE6RobpWDy+rgAB+jVG6Do0gcoGGBHttwm9mAXwjgu/gcIkREW/AXb4Si+49fsNv2y8MSU4/QEX0G44PfC0EuaoJAZrwF2ZHtlUgBMPWmMC4P0cpGNgYTLyxX/qooRkMEKkU/IcPINVFwvyucNkWkiC/m2pjzLIwHfgVB2P+6fxxf8R4O+aXyCVwCvAVpWd8xAvYPMdlT0r61g5m18Jg5lSpmzhXi6gmDrO4H3kTFxO6Y4h2y7uZzYC8FJ9l7k6XD3KKDqN/YNrtEJnutCFHDW4++6lAx60juTyxZJREXcSI3eiGNQnjffmxS/4dUiJXM7alvsjvG+9yPnZboKcz8Pw5QK1u1rWccZdjhji8oIwWugPO12pJ6SfdcI0fsMzKveI1YnkQtrHHoYe5cLl3Nz06EI8wi3im82NxAOoaKgsLi/9vYkrBxnruzda/Ka41lns3TtyETM6PNMDDShgZfyC+Q/k4CPKa4LD+3lCyuVdVSdlIpP6jnE42Ale3HvpcQJdcTldf+3nKILRdZQzigUIZSPCX8MXSNFOTF1eJ3jamMaAqsCIjxJSJQFMLsW+jOkKaroLLZ3ymuXxCT7uKBBGMh83pvVQWa7uoKsRWACObUNDcpuGtV9SlT1AAG+dPtTdy5OVqUMKEITKA951VlgMXyD4BRcWhYj0fhlvq7Nb0v3ccknNxTREHHDGCqpsARVC4UCjFCrlEf+PiridjH5xYdO3izJJN0x6rMaMmtt/3g0+KJPc0OZhJMdCH76oWW/fAxJJKuW5vwq+og/OCyQ31oM/kLHwuFmNB5ip4afTGtxIb3N4RMGZVUCeavUp22S4K+qO4jayYTY4/COxTDMTVJV56cfTt7HCRbs+DlNno4+OVx3GHOyIkBrVTs+0tP+GKqRup48UMA1mzMRuBjqK//y32f/8t9FpTA==");
    }

    metasec_build_x_soter_empty_value_350101(out, sizeof(out));
    failures += check_string_350101(
        "X-Soter empty-pack",
        out,
        "AAEAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

    printf("x-header algorithm failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

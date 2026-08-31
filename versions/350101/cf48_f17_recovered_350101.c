/*
 * 350.101 libmetasec_ml.so
 *
 * CF48 short-header transform recovered shape.
 *
 * Evidence:
 *   - CF48 wrapper:            0x16F660
 *   - flattened helper:        0x16CCD8
 *   - lower text transform:    0x16E794
 *   - key schedule:            0x16E8FC
 *   - managed block program:   F17, global 0x2C5958, code body 0x8721C0
 *
 * Placement in request signing:
 *   F7  / X-Ladon  : CF100 -> CF38 -> CF38 -> CF48 -> CF49 -> CF44 -> CF98
 *   F13 / X-Helios : CF100 -> CF38 -> CF38 -> CF48 -> CF49 -> CF44 -> CF98
 *
 * Validation:
 *   text="1788108717-1588093228-1128"
 *   F7  key="b5b49dcffaa587dccaa36fec8005a08c" -> observed out32 exact match
 *   F13 key="c4aebafaa687f565cdec6d5eb75c95de" -> observed out32 exact match
 *
 * 注意：
 *   这份已经覆盖 CF48 的核心加密/变换；还没有替代原来的 MEM_BLOCK
 *   malloc/free/错误码路径。
 */

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>

static inline uint64_t ror64_350(uint64_t v, unsigned n)
{
    n &= 63;
    return (v >> n) | (v << ((64 - n) & 63));
}

static inline uint64_t rol64_350(uint64_t v, unsigned n)
{
    n &= 63;
    return (v << n) | (v >> ((64 - n) & 63));
}

static inline uint64_t load64_le_350(const void *p)
{
    uint64_t v;
    memcpy(&v, p, sizeof(v));
    return v;
}

static inline void store64_le_350(void *p, uint64_t v)
{
    memcpy(p, &v, sizeof(v));
}

/*
 * 0x1719B0:
 *   rounded = ((text_len + 0x10) / 0x10) << 4
 *   pad_len = rounded - text_len
 *
 * 0x16E81C..0x16E828:
 *   fill byte = pad_len & 0xff
 *   fill size = pad_len
 *
 * 所以这里是 PKCS#7-like padding；不是 zero padding。
 */
size_t cf48_padded_len_350101(size_t text_len)
{
    return ((text_len + 0x10) / 0x10) << 4;
}

void cf48_make_padded_text_350101(const uint8_t *text,
                                  size_t text_len,
                                  uint8_t *padded)
{
    size_t padded_len = cf48_padded_len_350101(text_len);
    size_t pad_len = padded_len - text_len;

    memcpy(padded, text, text_len);
    memset(padded + text_len, (int)(pad_len & 0xff), pad_len);
}

/*
 * 0x16E8FC(key32, schedule)
 *
 * key32:
 *   32 bytes, copied as four little-endian qwords.
 *
 * schedule:
 *   native allocates a larger local buffer, but this helper emits 35 qwords
 *   according to the observed assembly shape:
 *     schedule[0] = state[0]
 *     for i=0..33 emit one more qword
 *
 * F17 当前只消费 34 qwords（offset 0..0x108），最后一个 qword 暂按冗余/
 * 相邻变体备用处理，不把它硬塞进 F17。
 */
void cf48_seed_schedule_16E8FC_350101(const uint8_t key32[32],
                                      uint64_t schedule35[35])
{
    uint64_t state[4];
    state[0] = load64_le_350(key32 + 0x00);
    state[1] = load64_le_350(key32 + 0x08);
    state[2] = load64_le_350(key32 + 0x10);
    state[3] = load64_le_350(key32 + 0x18);

    schedule35[0] = state[0];

    for (uint64_t i = 0; i < 0x22; i++) {
        uint64_t a = state[0];
        uint64_t b = state[1];

        uint64_t nb = ror64_350(b, 8) + a;
        nb ^= i;

        uint64_t na = nb ^ ror64_350(a, 61); /* ror64(a,61) == rol64(a,3) */

        state[0] = na;
        state[1] = state[2];
        state[2] = state[3];
        state[3] = nb;

        schedule35[i + 1] = state[0];
    }
}

/*
 * Managed F17 body at 0x8721C0.
 *
 * Runtime slots from 0x17184C:
 *   slot4 = schedule pointer
 *   slot5 = input block pointer,  16 bytes
 *   slot6 = output block pointer, 16 bytes
 *
 * Cleaned bytecode:
 *   x = *(in + 8)
 *   y = *(in + 0)
 *   for off = 0; off != 0x110; off += 8:
 *       x = (ror64(x, 8) + y) ^ *(uint64_t *)(schedule + off)
 *       y = rol64(y, 3) ^ x
 *   *(out + 8) = x
 *   *(out + 0) = y
 *
 * 其中 bytecode 的 op72 写法是 rol64(value, 32 - imm)，F17 里 imm=29，
 * 等价 rol64(value, 3)。
 */
void cf48_f17_encrypt_block_350101(const uint64_t schedule34[34],
                                   const uint8_t in16[16],
                                   uint8_t out16[16])
{
    uint64_t y = load64_le_350(in16 + 0x00);
    uint64_t x = load64_le_350(in16 + 0x08);

    for (size_t round = 0; round < 34; round++) {
        x = (ror64_350(x, 8) + y) ^ schedule34[round];
        y = rol64_350(y, 3) ^ x;
    }

    store64_le_350(out16 + 0x08, x);
    store64_le_350(out16 + 0x00, y);
}

/*
 * 0x16E794(text, text_len, out_ptr, out_len, key32) 的核心形状。
 *
 * Native wrapper 会先：
 *   1. key32 clone/pad 到 0x20;
 *   2. text clone；
 *   3. 计算 round16(text_len + 0x10) - text_len 的 PKCS#7-like padding；
 *   4. 逐 16-byte block 调 0x17184C -> managed F17；
 *   5. 把结果写回 out_ptr/out_len，再由 CF48 填到 MEM_BLOCK out_transform32。
 *
 * 这里展示已经与 F7/F13 真机样本对齐的主体；完整复刻时只需要外层补
 * MEM_BLOCK 管理和 out_ptr/out_len 写回。
 */
void cf48_transform_blocks_with_f17_350101(const uint8_t key32[32],
                                           const uint8_t *padded_text,
                                           size_t padded_len,
                                           uint8_t *out)
{
    uint64_t schedule35[35];
    cf48_seed_schedule_16E8FC_350101(key32, schedule35);

    for (size_t off = 0; off < padded_len; off += 16) {
        cf48_f17_encrypt_block_350101(schedule35, padded_text + off, out + off);
    }
}

size_t cf48_transform_text_key32_350101(const uint8_t *text,
                                        size_t text_len,
                                        const uint8_t key32[32],
                                        uint8_t *out,
                                        size_t out_cap)
{
    size_t padded_len = cf48_padded_len_350101(text_len);
    if (out_cap < padded_len) {
        return 0;
    }

    uint8_t padded[0x100];
    if (padded_len > sizeof(padded)) {
        /*
         * 当前 F7/F13 runtime 样本 text_len=0x1a，padded_len=0x20。
         * 这里保守限制成 0x100，避免 oracle 里引入 malloc 路径。
         */
        return 0;
    }

    cf48_make_padded_text_350101(text, text_len, padded);
    cf48_transform_blocks_with_f17_350101(key32, padded, padded_len, out);
    return padded_len;
}

void cf49_pack_prefix4_transform32_350101(const uint8_t prefix4[4],
                                          const uint8_t transform32[32],
                                          uint8_t pack36[36])
{
    /*
     * 0x16F6B0 CF49:
     *   slot4 = 4-byte prefix MEM_BLOCK
     *   slot5 = CF48 32-byte transform MEM_BLOCK
     *   ret2  = cat(slot4, slot5), len=0x24
     *
     * 【中文】CF49 没有再加密；就是 prefix4 || transform32。
     */
    memcpy(pack36, prefix4, 4);
    memcpy(pack36 + 4, transform32, 32);
}

size_t cf44_base64_encode_350101(const uint8_t *src,
                                 size_t src_len,
                                 char *dst,
                                 size_t dst_cap)
{
    /*
     * 0x16F544 CF44 wraps the library base64 helper.  The alphabet here is
     * the standard MIME/base64 alphabet with '=' padding, matching the
     * observed X-Ladon/X-Helios output.
     *
     * 【中文】CF44 是标准 base64；0x24 输入固定输出 0x30 字符。
     */
    static const char tab[] =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    size_t out_len = ((src_len + 2) / 3) * 4;
    if (dst_cap <= out_len) {
        return 0;
    }

    size_t oi = 0;
    for (size_t i = 0; i < src_len; i += 3) {
        uint32_t a = src[i];
        uint32_t b = (i + 1 < src_len) ? src[i + 1] : 0;
        uint32_t c = (i + 2 < src_len) ? src[i + 2] : 0;
        uint32_t triple = (a << 16) | (b << 8) | c;

        dst[oi++] = tab[(triple >> 18) & 0x3f];
        dst[oi++] = tab[(triple >> 12) & 0x3f];
        dst[oi++] = (i + 1 < src_len) ? tab[(triple >> 6) & 0x3f] : '=';
        dst[oi++] = (i + 2 < src_len) ? tab[triple & 0x3f] : '=';
    }
    dst[oi] = '\0';
    return out_len;
}

static void print_hex_350101(const uint8_t *data, size_t len)
{
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
}

static int check_short_header_case_350101(const char *name,
                                          const char *text,
                                          const char *key32_ascii,
                                          const uint8_t prefix4[4],
                                          const uint8_t expect_out32[32],
                                          const char *expect_b64)
{
    uint8_t out[0x100];
    uint8_t pack36[36];
    char b64[64];
    size_t out_len = cf48_transform_text_key32_350101(
        (const uint8_t *)text, strlen(text),
        (const uint8_t *)key32_ascii, out, sizeof(out));

    int ok_len = (out_len == 0x20);
    int ok_out = ok_len && memcmp(out, expect_out32, 32) == 0;

    cf49_pack_prefix4_transform32_350101(prefix4, out, pack36);
    size_t b64_len = cf44_base64_encode_350101(pack36, sizeof(pack36),
                                               b64, sizeof(b64));
    int ok_b64 = (b64_len == 0x30) && strcmp(b64, expect_b64) == 0;

    printf("%s text_len=0x%zx padded_len=0x%zx out32=",
           name, strlen(text), out_len);
    print_hex_350101(out, 32);
    printf(" out_match=%s b64=%s b64_match=%s\n",
           ok_out ? "true" : "false",
           b64,
           ok_b64 ? "true" : "false");

    return (ok_len && ok_out && ok_b64) ? 0 : 1;
}

#ifndef METASEC_350101_NO_MAIN
int main(void)
{
    const char *text = "1788108717-1588093228-1128";

    const uint8_t ladon_prefix4[4] = {0x7c, 0xc8, 0xa0, 0x10};
    const uint8_t ladon_out32[32] = {
        0x7a, 0xbd, 0x4b, 0xdb, 0x12, 0xba, 0x2b, 0x22,
        0x82, 0xa8, 0xef, 0xfd, 0x65, 0xea, 0x43, 0x27,
        0x0d, 0x9c, 0xf5, 0xe5, 0xde, 0xbe, 0xc2, 0x51,
        0x0c, 0x62, 0xca, 0x70, 0x17, 0xa4, 0x31, 0xfe,
    };

    const uint8_t helios_prefix4[4] = {0x30, 0xe4, 0x7f, 0x2c};
    const uint8_t helios_out32[32] = {
        0x74, 0xf5, 0x5f, 0x3e, 0x23, 0xd3, 0xc8, 0x57,
        0x0d, 0x15, 0xdf, 0xe5, 0xd4, 0xa2, 0xfd, 0xc0,
        0x65, 0xc7, 0xe3, 0xce, 0xc2, 0x68, 0x67, 0x54,
        0x5a, 0x79, 0x24, 0xef, 0x16, 0xa3, 0x6a, 0xf9,
    };

    int failures = 0;
    failures += check_short_header_case_350101(
        "F7/X-Ladon",
        text,
        "b5b49dcffaa587dccaa36fec8005a08c",
        ladon_prefix4,
        ladon_out32,
        "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+");

    failures += check_short_header_case_350101(
        "F13/X-Helios",
        text,
        "c4aebafaa687f565cdec6d5eb75c95de",
        helios_prefix4,
        helios_out32,
        "MOR/LHT1Xz4j08hXDRXf5dSi/cBlx+POwmhnVFp5JO8Wo2r5");

    printf("failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

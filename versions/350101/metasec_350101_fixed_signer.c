/*
 * 350.101 deterministic fixed-environment signer.
 *
 * Goal:
 *   s1(url) + s2(raw request headers) -> the same X-* values emitted by the
 *   deterministic unidbg baseline.
 *
 * Dynamic input kept from s1/s2:
 *   - query string MD5[:4] for X-Gorgon
 *   - query string SM3[:6] for X-Argus
 *   - x-ss-stub hex bytes from s2, plus SM3[:6] for X-Argus
 *   - aid/device_id/version_name from s1 query
 *
 * Fixed runtime state:
 *   - time/random/pid/urandom-derived fields captured in
 *     deterministic_replay_350101.md
 *   - F8/X-Medusa raw pack is embedded as the deterministic fixed-env pack;
 *     final value is still produced by the recovered CF44/base64 function.
 */

#include "metasec_350101_recovered_c.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

enum {
    METASEC_350101_FIXED_SEC = 1788136882U,
    METASEC_350101_ARGUS_KHRONOS = 0xd5299b64U,
};

static int copy_cstr_350101(char *dst, size_t cap, const char *src)
{
    size_t n;
    if (dst == NULL || cap == 0 || src == NULL) {
        return 0;
    }
    n = strlen(src);
    if (n >= cap) {
        return 0;
    }
    memcpy(dst, src, n + 1);
    return 1;
}

static int copy_span_350101(char *dst, size_t cap, const char *src, size_t len)
{
    if (dst == NULL || cap == 0 || src == NULL || len >= cap) {
        return 0;
    }
    memcpy(dst, src, len);
    dst[len] = '\0';
    return 1;
}

static char ascii_lower_350101(char c)
{
    return (c >= 'A' && c <= 'Z') ? (char)(c + ('a' - 'A')) : c;
}

static int span_eq_ci_350101(const char *s, size_t s_len, const char *lit)
{
    size_t i;
    size_t lit_len = strlen(lit);
    if (s_len != lit_len) {
        return 0;
    }
    for (i = 0; i < s_len; i++) {
        if (ascii_lower_350101(s[i]) != ascii_lower_350101(lit[i])) {
            return 0;
        }
    }
    return 1;
}

static int hexval_350101(int c)
{
    if ('0' <= c && c <= '9') return c - '0';
    if ('a' <= c && c <= 'f') return c - 'a' + 10;
    if ('A' <= c && c <= 'F') return c - 'A' + 10;
    return -1;
}

static size_t hex_to_bytes_350101(const char *hex, uint8_t *out, size_t cap)
{
    size_t n = 0;
    int hi = -1;

    if (hex == NULL || out == NULL) {
        return 0;
    }

    for (; *hex != '\0'; hex++) {
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

static int extract_query_span_350101(const char *s1,
                                     const char **query,
                                     size_t *query_len)
{
    const char *q;
    const char *end;
    if (s1 == NULL || query == NULL || query_len == NULL) {
        return 0;
    }

    q = strchr(s1, '?');
    *query = q != NULL ? q + 1 : s1;
    end = strchr(*query, '#');
    *query_len = end != NULL ? (size_t)(end - *query) : strlen(*query);
    return 1;
}

static int query_param_350101(const char *query,
                              size_t query_len,
                              const char *key,
                              char *out,
                              size_t out_cap)
{
    size_t key_len;
    size_t pos = 0;

    if (query == NULL || key == NULL || out == NULL || out_cap == 0) {
        return 0;
    }

    key_len = strlen(key);
    while (pos <= query_len) {
        size_t part_start = pos;
        size_t part_len;
        const char *part;
        const char *value;
        size_t value_len;

        while (pos < query_len && query[pos] != '&') {
            pos++;
        }
        part_len = pos - part_start;
        part = query + part_start;

        if (part_len > key_len && memcmp(part, key, key_len) == 0 &&
            part[key_len] == '=') {
            value = part + key_len + 1;
            value_len = part_len - key_len - 1;
            return copy_span_350101(out, out_cap, value, value_len);
        }

        if (pos == query_len) {
            break;
        }
        pos++;
    }

    out[0] = '\0';
    return 0;
}

static const char *skip_eol_350101(const char *p)
{
    if (p[0] == '\r' && p[1] == '\n') {
        return p + 2;
    }
    if (p[0] == '\n') {
        return p + 1;
    }
    if (p[0] == '\r') {
        return p + 1;
    }
    return p;
}

static int extract_header_line_value_350101(const char *s2,
                                            const char *key,
                                            char *out,
                                            size_t out_cap)
{
    const char *p = s2;
    size_t key_len;

    if (s2 == NULL || key == NULL || out == NULL || out_cap == 0) {
        return 0;
    }
    key_len = strlen(key);

    while (*p != '\0') {
        const char *line = p;
        const char *line_end;
        size_t line_len;
        const char *next;

        while (*p != '\0' && *p != '\r' && *p != '\n') {
            p++;
        }
        line_end = p;
        line_len = (size_t)(line_end - line);
        next = skip_eol_350101(p);

        if (line_len > key_len &&
            span_eq_ci_350101(line, key_len, key) &&
            line[key_len] == ':') {
            const char *v = line + key_len + 1;
            while (*v == ' ' || *v == '\t') {
                v++;
            }
            return copy_span_350101(out, out_cap, v, (size_t)(line_end - v));
        }

        if (line_len == key_len &&
            span_eq_ci_350101(line, key_len, key)) {
            const char *v = next;
            const char *v_end;
            while (*v == ' ' || *v == '\t') {
                v++;
            }
            v_end = v;
            while (*v_end != '\0' && *v_end != '\r' && *v_end != '\n') {
                v_end++;
            }
            while (v_end > v &&
                   (v_end[-1] == ' ' || v_end[-1] == '\t')) {
                v_end--;
            }
            return copy_span_350101(out, out_cap, v, (size_t)(v_end - v));
        }

        p = next;
    }

    out[0] = '\0';
    return 0;
}

typedef struct Md5Ctx350101 {
    uint32_t h[4];
    uint64_t total_len;
    uint8_t buf[64];
    size_t buf_len;
} Md5Ctx350101;

static uint32_t load32le_350101(const uint8_t p[4])
{
    return ((uint32_t)p[0]) |
           ((uint32_t)p[1] << 8) |
           ((uint32_t)p[2] << 16) |
           ((uint32_t)p[3] << 24);
}

static void store32le_350101(uint8_t p[4], uint32_t v)
{
    p[0] = (uint8_t)v;
    p[1] = (uint8_t)(v >> 8);
    p[2] = (uint8_t)(v >> 16);
    p[3] = (uint8_t)(v >> 24);
}

static uint32_t rol32_350101(uint32_t v, uint32_t s)
{
    return (v << s) | (v >> (32U - s));
}

static void md5_transform_350101(uint32_t h[4], const uint8_t block[64])
{
    static const uint32_t k[64] = {
        0xd76aa478U, 0xe8c7b756U, 0x242070dbU, 0xc1bdceeeU,
        0xf57c0fafU, 0x4787c62aU, 0xa8304613U, 0xfd469501U,
        0x698098d8U, 0x8b44f7afU, 0xffff5bb1U, 0x895cd7beU,
        0x6b901122U, 0xfd987193U, 0xa679438eU, 0x49b40821U,
        0xf61e2562U, 0xc040b340U, 0x265e5a51U, 0xe9b6c7aaU,
        0xd62f105dU, 0x02441453U, 0xd8a1e681U, 0xe7d3fbc8U,
        0x21e1cde6U, 0xc33707d6U, 0xf4d50d87U, 0x455a14edU,
        0xa9e3e905U, 0xfcefa3f8U, 0x676f02d9U, 0x8d2a4c8aU,
        0xfffa3942U, 0x8771f681U, 0x6d9d6122U, 0xfde5380cU,
        0xa4beea44U, 0x4bdecfa9U, 0xf6bb4b60U, 0xbebfbc70U,
        0x289b7ec6U, 0xeaa127faU, 0xd4ef3085U, 0x04881d05U,
        0xd9d4d039U, 0xe6db99e5U, 0x1fa27cf8U, 0xc4ac5665U,
        0xf4292244U, 0x432aff97U, 0xab9423a7U, 0xfc93a039U,
        0x655b59c3U, 0x8f0ccc92U, 0xffeff47dU, 0x85845dd1U,
        0x6fa87e4fU, 0xfe2ce6e0U, 0xa3014314U, 0x4e0811a1U,
        0xf7537e82U, 0xbd3af235U, 0x2ad7d2bbU, 0xeb86d391U,
    };
    static const uint32_t s[64] = {
        7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
        5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
        4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
        6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21,
    };
    uint32_t w[16];
    uint32_t a = h[0], b = h[1], c = h[2], d = h[3];

    for (uint32_t i = 0; i < 16; i++) {
        w[i] = load32le_350101(block + i * 4);
    }

    for (uint32_t i = 0; i < 64; i++) {
        uint32_t f;
        uint32_t g;
        if (i < 16) {
            f = (b & c) | ((~b) & d);
            g = i;
        } else if (i < 32) {
            f = (d & b) | ((~d) & c);
            g = (5 * i + 1) & 15;
        } else if (i < 48) {
            f = b ^ c ^ d;
            g = (3 * i + 5) & 15;
        } else {
            f = c ^ (b | (~d));
            g = (7 * i) & 15;
        }
        f = f + a + k[i] + w[g];
        a = d;
        d = c;
        c = b;
        b = b + rol32_350101(f, s[i]);
    }

    h[0] += a;
    h[1] += b;
    h[2] += c;
    h[3] += d;
}

static void md5_init_350101(Md5Ctx350101 *ctx)
{
    ctx->h[0] = 0x67452301U;
    ctx->h[1] = 0xefcdab89U;
    ctx->h[2] = 0x98badcfeU;
    ctx->h[3] = 0x10325476U;
    ctx->total_len = 0;
    ctx->buf_len = 0;
}

static void md5_update_350101(Md5Ctx350101 *ctx, const void *data, size_t len)
{
    const uint8_t *p = (const uint8_t *)data;
    ctx->total_len += len;

    while (len > 0) {
        size_t take = sizeof(ctx->buf) - ctx->buf_len;
        if (take > len) {
            take = len;
        }
        memcpy(ctx->buf + ctx->buf_len, p, take);
        ctx->buf_len += take;
        p += take;
        len -= take;

        if (ctx->buf_len == sizeof(ctx->buf)) {
            md5_transform_350101(ctx->h, ctx->buf);
            ctx->buf_len = 0;
        }
    }
}

static void md5_final_350101(Md5Ctx350101 *ctx, uint8_t out[16])
{
    uint64_t bit_len = ctx->total_len * 8U;
    uint8_t len_le[8];
    size_t i;

    ctx->buf[ctx->buf_len++] = 0x80;
    if (ctx->buf_len > 56) {
        while (ctx->buf_len < 64) {
            ctx->buf[ctx->buf_len++] = 0;
        }
        md5_transform_350101(ctx->h, ctx->buf);
        ctx->buf_len = 0;
    }
    while (ctx->buf_len < 56) {
        ctx->buf[ctx->buf_len++] = 0;
    }
    for (i = 0; i < 8; i++) {
        len_le[i] = (uint8_t)(bit_len >> (i * 8));
    }
    memcpy(ctx->buf + 56, len_le, sizeof(len_le));
    md5_transform_350101(ctx->h, ctx->buf);

    for (i = 0; i < 4; i++) {
        store32le_350101(out + i * 4, ctx->h[i]);
    }
}

static void md5_oneshot_350101(const void *data, size_t len, uint8_t out[16])
{
    Md5Ctx350101 ctx;
    md5_init_350101(&ctx);
    md5_update_350101(&ctx, data, len);
    md5_final_350101(&ctx, out);
}

static int build_x_gorgon_350101(const char *query,
                                 size_t query_len,
                                 const uint8_t x_ss_stub16[16],
                                 char *out,
                                 size_t out_cap)
{
    uint8_t md5[16];
    md5_oneshot_350101(query, query_len, md5);

    return metasec_build_x_gorgon_value_350101(
               out, out_cap,
               md5,
               x_ss_stub16,
               0x04090500U,
               METASEC_350101_FIXED_SEC,
               0x0008,
               0x76a0) != 0;
}

static int build_x_argus_350101(const char *query,
                                size_t query_len,
                                const uint8_t x_ss_stub16[16],
                                const char *aid,
                                const char *device_id,
                                const char *version_name,
                                char *out,
                                size_t out_cap)
{
    static const uint8_t proto_header[8] = {
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    };
    static const uint8_t simon_key32[32] = {
        0x8f, 0x7a, 0x33, 0xb4, 0x87, 0xdd, 0x1e, 0xe7,
        0x82, 0xff, 0xac, 0x6a, 0xb6, 0x2b, 0xe2, 0xd2,
        0x86, 0xec, 0xd0, 0xc8, 0x73, 0x71, 0x67, 0x4b,
        0xc7, 0xcf, 0xcc, 0x06, 0x5b, 0xef, 0x8a, 0x7a,
    };
    static const uint8_t prefix9[9] = {
        0x35, 0xb9, 0x4e, 0x32, 0x39, 0x01, 0xcf, 0x07, 0x18,
    };
    static const uint8_t tail_le64[8] = {
        0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    };
    static const uint8_t tail_mask4[4] = {
        0xff, 0xfd, 0xd7, 0xa5,
    };
    static const uint8_t aes_key16[16] = {
        0xf1, 0x59, 0x33, 0x76, 0x76, 0x6e, 0xa9, 0x8d,
        0x34, 0xf3, 0x1b, 0x05, 0x7a, 0x9d, 0x5b, 0xe4,
    };
    static const uint8_t aes_iv16[16] = {
        0x1f, 0xe1, 0x09, 0xa4, 0x12, 0x52, 0x83, 0xf4,
        0x18, 0xde, 0x9e, 0x05, 0x1a, 0x96, 0x9e, 0x12,
    };

    uint8_t xss_sm3[32];
    uint8_t query_sm3[32];
    uint8_t plain[0x120];
    size_t plain_len;
    MetaSecXArgusStruct350 msg;

    if (metasec_cf61_sm3_oneshot_350(x_ss_stub16, 16, xss_sm3) != 0 ||
        metasec_cf61_sm3_oneshot_350(query, (uint32_t)query_len, query_sm3) != 0) {
        return 0;
    }

    memset(&msg, 0, sizeof(msg));
    msg.has_k1_sdk_date = 1;
    msg.k1_sdk_date = 0x40401252ULL;
    msg.has_k2_type = 1;
    msg.k2_type = 2;
    msg.has_k3_random_value = 1;
    msg.k3_random_value = 0x03680206ULL;
    msg.k4_aid = aid;
    msg.k5_device_id = device_id;
    msg.k6_version_string = "1588093228";
    msg.k7_app_version_name = version_name;
    msg.k8_sdk_version_name = "v04.09.05-ml-android";
    msg.has_k9_sdk_version_code = 1;
    msg.k9_sdk_version_code = 0x08120a00ULL;
    msg.k10_proto_header.data = proto_header;
    msg.k10_proto_header.len = sizeof(proto_header);
    msg.has_k12_khronos = 1;
    msg.k12_khronos = METASEC_350101_ARGUS_KHRONOS;
    msg.k13_xssstub_sm3.data = xss_sm3;
    msg.k13_xssstub_sm3.len = 6;
    msg.k14_url_sm3.data = query_sm3;
    msg.k14_url_sm3.len = 6;
    msg.has_k15_algorithm_seq = 1;
    msg.k15_algorithm_seq.has_k1_algo_seq = 1;
    msg.k15_algorithm_seq.k1_algo_seq = 2;
    msg.k15_algorithm_seq.has_k2_report_seq = 1;
    msg.k15_algorithm_seq.k2_report_seq = 0x1530be;
    msg.k15_algorithm_seq.has_k3_setting_seq = 1;
    msg.k15_algorithm_seq.k3_setting_seq = 0x1530be;
    msg.has_k17_khronos = 1;
    msg.k17_khronos = METASEC_350101_ARGUS_KHRONOS;
    msg.k20_pskVersion = "none";
    msg.has_k21_callType = 1;
    msg.k21_callType = 0x2e2;

    plain_len = metasec_build_x_argus_plain_350101(
        plain, sizeof(plain), &msg);
    if (plain_len == 0) {
        return 0;
    }

    return metasec_build_x_argus_value_from_plain_350101(
               out, out_cap,
               prefix9,
               tail_le64,
               plain,
               plain_len,
               simon_key32,
               tail_mask4,
               0x1d45,
               aes_key16,
               aes_iv16,
               0x8880) != 0;
}

static int build_x_ladon_350101(const char *aid, char *out, size_t out_cap)
{
    static const uint8_t key32[32] = "3d7bd3017d7fa2125facd70112519853";
    static const uint8_t prefix4[4] = {
        0xfe, 0x12, 0x7e, 0x0a,
    };
    return metasec_build_x_ladon_value_350101(
               out, out_cap,
               METASEC_350101_FIXED_SEC,
               "1588093228",
               aid,
               key32,
               prefix4) != 0;
}

static int build_x_helios_350101(const char *aid, char *out, size_t out_cap)
{
    static const uint8_t key32[32] = "aa5b88836c84dba78db6e0970ce33a85";
    static const uint8_t prefix4[4] = {
        0x0a, 0x61, 0x24, 0x2a,
    };
    return metasec_build_x_helios_value_350101(
               out, out_cap,
               METASEC_350101_FIXED_SEC,
               "1588093228",
               aid,
               key32,
               prefix4) != 0;
}

static int build_x_medusa_350101(char *out, size_t out_cap)
{
    static const char raw_hex[] =
        "b7cd946a9f86dba0fbb899298d783a4690a0583cacac0001aa75751d206a81d4075806003878cdddd04de8cf5a14d5bc7a3409554761e1286ebd48c6bb4649a9dfc3fd63db3b19bb9acec8412bd3146f9c0ac1de89d2f3dbfd4987eefdce935073bb1b6937ee404c401256420edd82f6d6ec9244d55cfcabf6820e6e9f16f42a9f0323a1ef219760a3e65d9e0f6339b7c229fd9f1c869a59c529bf83c267619c29a075681086d76a89f3c104a788a215f847723035f1f7c0397e233053a5076f8d8a3b90272728a2f133c4457b89a57ca8bae84d29c746d30a13444346b7bc48d757d38445e3a40ec9c51a9a683c54cbd11bf1cec500096ba0486774a58fae9e4e3f5955d0c071af9f0a1ad0d6f25adc7ce66630eee0919e93f935d1b3cd8b3624e07c2dce489e2b383f9605a10b2f7f113382f50826dc21806e9dd759561535ac6bc4e5d4833f30c93d945a370c9763cb709719c1c4013f085c9904e8f9b709de7cdcd254651a0aad5d79743a72cd28d64d1919848f20b79ae0fc470044b7ec4d1acbaa172cd37f88b1f15431d481f79b9a0d762cabf665543e54bef72ccc3b152fce478e9d31da4d835ff51cd4f65c464d2fc29c662798b5cb65306c39408927e53e9627caead4a9a802718a0aaa23bdedbedc18cdda39510e08c12e918c82c29443f81d4e2aee4d0e29dd62a2fcf70a26371af05acac67f5a9f81414a4c20fd048e61db1c111789a871bf9d50bf95d173dcd6b40d6d4912a846c0cbc355e5103e3de732f5667c931b0999f5df79fe6f229406a5f9feb575e3765e8b9c9a52e6540c95c835711c2c298620b99855a8c703e41791fb2e2060a75604b88cc428608e218faa910533e1076f1faf81ab5a8b14353575c47e67febc213549d298f4048ff8bb4c600afac20404a6cfe9d53dab2c81c82e10fb35bf8c1fe74820d2635feb30b9a50c9b72151aba1bc11044e0e084fcd24a9b0e952a00e8fa2f39fffa2f39f7ba79";
    uint8_t raw[0x300];
    size_t raw_len = hex_to_bytes_350101(raw_hex, raw, sizeof(raw));

    if (raw_len != 709) {
        return 0;
    }
    return metasec_build_x_medusa_value_from_pack_350101(
               out, out_cap, raw, raw_len) != 0;
}

int metasec_build_headers_from_s1_s2_fixed_350101(const char *s1,
                                                  const char *s2,
                                                  MetaSecHeaders350 *out)
{
    const char *query;
    size_t query_len;
    char xss_hex[80];
    uint8_t x_ss_stub16[16];
    char aid[32];
    char device_id[64];
    char version_name[32];

    if (out == NULL) {
        return -1;
    }
    memset(out, 0, sizeof(*out));

    if (!extract_query_span_350101(s1, &query, &query_len) ||
        !extract_header_line_value_350101(s2, "x-ss-stub",
                                          xss_hex, sizeof(xss_hex)) ||
        hex_to_bytes_350101(xss_hex, x_ss_stub16, sizeof(x_ss_stub16)) !=
            sizeof(x_ss_stub16)) {
        return -1;
    }

    if (!query_param_350101(query, query_len, "aid", aid, sizeof(aid))) {
        copy_cstr_350101(aid, sizeof(aid), "1128");
    }
    if (!query_param_350101(query, query_len, "device_id",
                            device_id, sizeof(device_id))) {
        copy_cstr_350101(device_id, sizeof(device_id), "");
    }
    if (!query_param_350101(query, query_len, "version_name",
                            version_name, sizeof(version_name))) {
        copy_cstr_350101(version_name, sizeof(version_name), "35.1.0");
    }

    if (!build_x_argus_350101(query, query_len, x_ss_stub16,
                              aid, device_id, version_name,
                              out->x_argus, sizeof(out->x_argus)) ||
        !build_x_gorgon_350101(query, query_len, x_ss_stub16,
                               out->x_gorgon, sizeof(out->x_gorgon)) ||
        !build_x_helios_350101(aid, out->x_helios, sizeof(out->x_helios)) ||
        metasec_build_x_khronos_value_350101(
            out->x_khronos, sizeof(out->x_khronos),
            METASEC_350101_FIXED_SEC) == 0 ||
        !build_x_ladon_350101(aid, out->x_ladon, sizeof(out->x_ladon)) ||
        !build_x_medusa_350101(out->x_medusa, sizeof(out->x_medusa)) ||
        metasec_build_x_soter_empty_value_350101(
            out->x_soter, sizeof(out->x_soter)) == 0) {
        memset(out, 0, sizeof(*out));
        return -1;
    }

    return 0;
}

size_t metasec_build_http_reqsign_text_fixed_350101(const char *s1,
                                                    const char *s2,
                                                    char *out,
                                                    size_t out_cap)
{
    MetaSecHeaders350 h;
    int n;
    if (out == NULL || out_cap == 0 ||
        metasec_build_headers_from_s1_s2_fixed_350101(s1, s2, &h) != 0) {
        return 0;
    }

    n = snprintf(out, out_cap,
                 "X-Argus\r\n%s\r\n"
                 "X-Gorgon\r\n%s\r\n"
                 "X-Helios\r\n%s\r\n"
                 "X-Khronos\r\n%s\r\n"
                 "X-Ladon\r\n%s\r\n"
                 "X-Medusa\r\n%s\r\n"
                 "X-Soter\r\n%s\r\n",
                 h.x_argus,
                 h.x_gorgon,
                 h.x_helios,
                 h.x_khronos,
                 h.x_ladon,
                 h.x_medusa,
                 h.x_soter);
    if (n < 0 || (size_t)n >= out_cap) {
        out[0] = '\0';
        return 0;
    }
    return (size_t)n;
}

#ifndef METASEC_350101_NO_MAIN
static int check_string_350101(const char *name, const char *got, const char *expect)
{
    int ok = got != NULL && expect != NULL && strcmp(got, expect) == 0;
    printf("%s match=%s len=0x%zx\n", name, ok ? "true" : "false",
           got != NULL ? strlen(got) : 0);
    if (!ok) {
        printf("  got=%s\n  exp=%s\n", got != NULL ? got : "(null)", expect);
    }
    return ok ? 0 : 1;
}

int main(void)
{
    static const char s1[] =
        "https://api5-normal-m-hj.amemv.com/privacy/setting/change?iid=3247301440846819&device_id=397365608203400&ac=wifi&channel=vivo_1128_64&aid=1128&app_name=aweme&version_code=350100&version_name=35.1.0&device_platform=android&os=android&ssmix=a&device_type=Pixel+5&device_brand=google&language=zh&os_api=30&os_version=11&manifest_version_code=350101&resolution=1080*2135&dpi=440&update_version_code=35109900&_rticket=1769247175853&package=com.ss.android.ugc.aweme&first_launch_timestamp=1769245978&last_deeplink_update_version_code=0&cpu_support64=true&host_abi=arm64-v8a&is_guest_mode=0&app_type=normal&minor_status=0&appTheme=light&is_preinstall=0&need_personal_recommend=1&is_android_pad=0&is_android_fold=0&ts=1769247174&cdid=1a506faa-3555-49d0-9f25-44f7968645c1";
    static const char s2[] =
        "x-ss-stub\r\n"
        "FDF60E82C1607606E7386BA88D06B4CA\r\n";
    static const char expect_argus[] =
        "gIg4OPu+fDHyJFBL+tgcdzrilcMdNJN9AUlg0kLoL08YXGkNOS3J7Xy2mteu88qUZPA15KQjQPPxauzBaPAQ3U/6dPVja1qHCWL9mvL1G9V7qqjzH3JnZ57Qj9g3U673LGkk4kB+iCUBIB7TeByhNz92jfbl4i1uwK6yInVGtfLAMqoZkhq27SnDWjVnbY/Xt/mljDMWBmSr9ujeM2x0tG+1lAuIpLLkLhlaBxVIoKwAjTJU3aAlFiMQKQJRZtTMFIo=";
    static const char expect_gorgon[] =
        "8404a0760800c59a3e796fca0c3941ef51f3bb7e71993d7d6e6a";
    static const char expect_helios[] =
        "CmEkKl/keEnDw5US+ehQr8rpMEeOBpoqjJ3PGsWqhENGslC/";
    static const char expect_khronos[] =
        "1788136882";
    static const char expect_ladon[] =
        "/hJ+ChFIoxjTKVPcg5bj5OFP3hx14whKj3/RgYAkiArUsNHF";
    static const char expect_medusa[] =
        "t82Uap+G26D7uJkpjXg6RpCgWDysrAABqnV1HSBqgdQHWAYAOHjN3dBN6M9aFNW8ejQJVUdh4ShuvUjGu0ZJqd/D/WPbOxm7ms7IQSvTFG+cCsHeidLz2/1Jh+79zpNQc7sbaTfuQExAElZCDt2C9tbskkTVXPyr9oIObp8W9CqfAyOh7yGXYKPmXZ4PYzm3win9nxyGmlnFKb+DwmdhnCmgdWgQhtdqifPBBKeIohX4R3IwNfH3wDl+IzBTpQdvjYo7kCcnKKLxM8RFe4mlfKi66E0px0bTChNEQ0a3vEjXV9OEReOkDsnFGppoPFTL0RvxzsUACWugSGd0pY+unk4/WVXQwHGvnwoa0NbyWtx85mYw7uCRnpP5NdGzzYs2JOB8Lc5Inis4P5YFoQsvfxEzgvUIJtwhgG6d11lWFTWsa8Tl1IM/MMk9lFo3DJdjy3CXGcHEAT8IXJkE6Pm3Cd583NJUZRoKrV15dDpyzSjWTRkZhI8gt5rg/EcARLfsTRrLqhcs03+IsfFUMdSB95uaDXYsq/ZlVD5UvvcszDsVL85Hjp0x2k2DX/Uc1PZcRk0vwpxmJ5i1y2UwbDlAiSflPpYnyurUqagCcYoKqiO97b7cGM3aOVEOCMEukYyCwpRD+B1OKu5NDindYqL89womNxrwWsrGf1qfgUFKTCD9BI5h2xwRF4mocb+dUL+V0XPc1rQNbUkSqEbAy8NV5RA+Pecy9WZ8kxsJmfXfef5vIpQGpfn+tXXjdl6LnJpS5lQMlcg1cRwsKYYguZhVqMcD5BeR+y4gYKdWBLiMxChgjiGPqpEFM+EHbx+vgataixQ1NXXEfmf+vCE1SdKY9ASP+LtMYAr6wgQEps/p1T2rLIHILhD7Nb+MH+dIINJjX+swuaUMm3IVGrobwRBE4OCE/NJKmw6VKgDo+i85//ovOfe6eQ==";
    static const char expect_soter[] =
        "AAEAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

    MetaSecHeaders350 h;
    char text[0x1000];
    int failures = 0;

    if (metasec_build_headers_from_s1_s2_fixed_350101(s1, s2, &h) != 0) {
        printf("fixed signer failed to build headers\n");
        return 1;
    }

    failures += check_string_350101("X-Argus", h.x_argus, expect_argus);
    failures += check_string_350101("X-Gorgon", h.x_gorgon, expect_gorgon);
    failures += check_string_350101("X-Helios", h.x_helios, expect_helios);
    failures += check_string_350101("X-Khronos", h.x_khronos, expect_khronos);
    failures += check_string_350101("X-Ladon", h.x_ladon, expect_ladon);
    failures += check_string_350101("X-Medusa", h.x_medusa, expect_medusa);
    failures += check_string_350101("X-Soter", h.x_soter, expect_soter);

    if (metasec_build_http_reqsign_text_fixed_350101(
            s1, s2, text, sizeof(text)) == 0) {
        printf("fixed reqsign text build failed\n");
        failures++;
    } else {
        printf("http_reqsign text len=0x%zx\n", strlen(text));
    }

    printf("fixed s1/s2 signer failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

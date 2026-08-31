/*
 * 350.101 MetaSec recovered-C linked smoke suite.
 *
 * This file does not try to fake a full online signer. It verifies that the
 * independently recovered C modules can be compiled together and still match
 * byte-exact vectors for the core building blocks observed in F5/F7/F8/F13.
 */

#include "metasec_350101_recovered_c.h"

#include <stdio.h>
#include <string.h>

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
        if (v < 0) continue;
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
                              const uint8_t *want,
                              size_t n)
{
    if (memcmp(got, want, n) == 0) {
        printf("[ok] %s len=0x%zx\n", name, n);
        return 0;
    }

    printf("[!!] %s mismatch len=0x%zx\n  got=", name, n);
    print_hex_350101(got, n);
    printf("\n  exp=");
    print_hex_350101(want, n);
    printf("\n");
    return 1;
}

static int test_cf61_sm3_350101(void)
{
    static const uint8_t expect[32] = {
        0x66,0xc7,0xf0,0xf4,0x62,0xee,0xed,0xd9,
        0xd1,0xf2,0xd4,0x6b,0xdc,0x10,0xe4,0xe2,
        0x41,0x67,0xc4,0x87,0x5c,0xf2,0xf7,0xa2,
        0x29,0x7d,0xa0,0x2b,0x8f,0x4b,0xa8,0xe0,
    };
    uint8_t got[32];
    metasec_cf61_sm3_oneshot_350("abc", 3, got);
    return check_bytes_350101("CF61/SM3 abc", got, expect, sizeof(expect));
}

static int test_cf48_short_header_350101(void)
{
    const char *text = "1788108717-1588093228-1128";
    const uint8_t key32[32] = "b5b49dcffaa587dccaa36fec8005a08c";
    const uint8_t prefix4[4] = {0x7c, 0xc8, 0xa0, 0x10};
    const char *expect_b64 = "fMigEHq9S9sSuisigqjv/WXqQycNnPXl3r7CUQxiynAXpDH+";
    uint8_t out32[32];
    uint8_t pack36[36];
    char b64[64];

    int failures = 0;
    size_t out_len = cf48_transform_text_key32_350101(
        (const uint8_t *)text, strlen(text), key32, out32, sizeof(out32));
    if (out_len != sizeof(out32)) {
        printf("[!!] CF48 out_len got=0x%zx expect=0x20\n", out_len);
        failures++;
    }

    cf49_pack_prefix4_transform32_350101(prefix4, out32, pack36);
    size_t b64_len = cf44_base64_encode_350101(pack36, sizeof(pack36),
                                               b64, sizeof(b64));
    if (b64_len != strlen(expect_b64) || strcmp(b64, expect_b64) != 0) {
        printf("[!!] CF48/CF49/CF44 b64 got=%s expect=%s\n", b64, expect_b64);
        failures++;
    } else {
        printf("[ok] CF48/CF49/CF44 F7 short-header b64 len=0x%zx\n", b64_len);
    }
    return failures;
}

static int test_cf41_simon_350101(void)
{
    static const char *input_hex =
        "08d2a4808204100218badcdea4062204313132382a0f333937333635363038323033343030320a313538383039333232"
        "383a0633352e312e3042147630342e30392e30352d6d6c2d616e64726f6964488094c8405208080000000000000060ae"
        "eea5a90d6a06cf03476f3b9672061f08578a515b7a0a080210bee15418bee1548801aeeea5a90da201046e6f6e65a801"
        "e205";
    static const char *key_hex =
        "4c6dce747a113cfa8341da76a2fce9bb98d47fc0255c8021292a55f911f9984f";
    static const char *expect_hex =
        "a63401c328e9e78209512f5cb612179abb71e1f08671630ca5619d4bf9b73c9920a322acee296319e43160ad3f316b3d"
        "2960af727fef5f4beed8834c11307f69b976de34d20913f1d2a77ee2831d350446dc643f6ec3065618310a4b1bdcb257"
        "b815ed8617c2a487cf74dcfc875cafd3b751daeee4deb3540068b0fcfe8427464926bf3e1e21f16452cb9e2934bac3ca"
        "6a038315aaab923ecfcdcb18d3741af8";
    uint8_t input[0x200];
    uint8_t key[0x20];
    uint8_t expect[0x200];
    uint8_t got[0x200];

    size_t input_len = from_hex_350101(input_hex, input, sizeof(input));
    size_t key_len = from_hex_350101(key_hex, key, sizeof(key));
    size_t expect_len = from_hex_350101(expect_hex, expect, sizeof(expect));
    size_t got_len = metasec_cf41_simon128_256_pkcs7_encrypt_350101(
        input, input_len, key, got, sizeof(got));

    int failures = 0;
    if (input_len != 0x92 || key_len != 0x20 || got_len != 0xa0 || expect_len != 0xa0) {
        printf("[!!] CF41 bad lengths input=0x%zx key=0x%zx got=0x%zx expect=0x%zx\n",
               input_len, key_len, got_len, expect_len);
        failures++;
    }
    failures += check_bytes_350101("CF41/SIMON128-256 pkcs7 vector", got, expect, expect_len);
    return failures;
}

static int test_cf43_aes_cbc_350101(void)
{
    static const uint8_t expect_empty_pad_zero_key_iv[16] = {
        0x01,0x43,0xdb,0x63,0xee,0x66,0xb0,0xcd,
        0xff,0x9f,0x69,0x91,0x76,0x80,0x15,0x1e,
    };
    uint8_t key[16] = {0};
    uint8_t iv[16] = {0};
    uint8_t got[16];
    size_t got_len = metasec_cf43_aes128_cbc_pkcs7_encrypt_350101(
        got, sizeof(got), (const uint8_t *)"", 0, key, iv);
    if (got_len != sizeof(got)) {
        printf("[!!] CF43 AES-CBC empty-body padded len got=0x%zx expect=0x10\n", got_len);
        return 1;
    }
    return check_bytes_350101("CF43/AES-128-CBC zero-key pkcs7(empty)",
                              got, expect_empty_pad_zero_key_iv,
                              sizeof(expect_empty_pad_zero_key_iv));
}

static int test_f8_mini_xor_350101(void)
{
    static const uint8_t pre[0x14] = {
        0x05, 0x00, 0x00, 0x00, 0x2d, 0x4b, 0x4f, 0xca,
        0x49, 0x75, 0x0d, 0x43, 0x3f, 0xb5, 0xae, 0x2c,
        0x22, 0x6d, 0xcc, 0x56,
    };
    static const uint8_t expect[0x14] = {
        0xa1, 0x84, 0x94, 0x6a, 0x89, 0xcf, 0xdb, 0xa0,
        0xed, 0xf1, 0x99, 0x29, 0x9b, 0x31, 0x3a, 0x46,
        0x86, 0xe9, 0x58, 0x3c,
    };
    uint8_t got[0x14];
    memcpy(got, pre, sizeof(got));
    medusa_f8_mutate_mini_xor_u32_350101(got, 0x6a9484a4U);
    return check_bytes_350101("F8/X-Medusa mini xor", got, expect, sizeof(expect));
}

static int test_f12_bitpack_350101(void)
{
    uint64_t qword = 0x07db01283d8ddf35ULL;
    uint8_t src = 0xb1;
    uint32_t produced = medusa_f12_mutate_sub_prefix_350(
        (uint8_t *)(void *)&qword, 8, &src, 1);
    if (produced != 1) {
        printf("[!!] F12 bitpack produced=%u expect=1\n", produced);
        return 1;
    }
    static const uint64_t expect = 0x07db81282d85ff35ULL;
    return check_bytes_350101("F12/X-Medusa subpack first qword",
                              (const uint8_t *)&qword,
                              (const uint8_t *)&expect,
                              sizeof(expect));
}

int main(void)
{
    int failures = 0;
    failures += test_cf61_sm3_350101();
    failures += test_cf48_short_header_350101();
    failures += test_cf41_simon_350101();
    failures += test_cf43_aes_cbc_350101();
    failures += test_f8_mini_xor_350101();
    failures += test_f12_bitpack_350101();
    failures += metasec_350101_source_work_vector_selfcheck();

    printf("[summary] metasec 350.101 recovered-C suite failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}

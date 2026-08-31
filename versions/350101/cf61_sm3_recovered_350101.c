/*
 * 350.101 CF61 / SM3 recovered implementation.
 *
 * Evidence:
 *   - F15 managed program writes the standard SM3 IV into state+0x08.
 *   - Native 0x16D520 performs init -> update -> final.
 *   - Native 0x16D5A0 is a 64-byte block update with byte counter at +0/+4.
 *   - Native 0x16D680 emits 8 state words as big-endian 32-byte digest.
 *   - 5/5 unidbg CF61 raw input/output vectors match standard SM3.
 *
 * Important naming:
 *   IDA-visible 0x16D86C is the flattened SM3 compression function.  It is not
 *   a custom hash once F15's IV and runtime vectors are checked.
 *
 * Build:
 *   clang -std=c11 -Wall -Wextra -Werror cf61_sm3_recovered_350101.c -o /tmp/cf61_sm3
 */

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef struct MetaSecSm3State350 {
    uint32_t byte_count_lo;       /* +0x00 */
    uint32_t byte_count_hi;       /* +0x04 */
    uint32_t h[8];                /* +0x08, SM3 chaining state */
    uint8_t tail[64];             /* +0x28 */
} MetaSecSm3State350;

static uint32_t rotl32(uint32_t x, unsigned n)
{
    n &= 31;
    return (x << n) | (x >> ((32 - n) & 31));
}

static uint32_t sm3_p0(uint32_t x)
{
    return x ^ rotl32(x, 9) ^ rotl32(x, 17);
}

static uint32_t sm3_p1(uint32_t x)
{
    return x ^ rotl32(x, 15) ^ rotl32(x, 23);
}

static uint32_t sm3_ff(uint32_t x, uint32_t y, uint32_t z, unsigned j)
{
    return j <= 15 ? (x ^ y ^ z) : ((x & y) | (x & z) | (y & z));
}

static uint32_t sm3_gg(uint32_t x, uint32_t y, uint32_t z, unsigned j)
{
    return j <= 15 ? (x ^ y ^ z) : ((x & y) | (~x & z));
}

static uint32_t load_be32(const uint8_t *p)
{
    return ((uint32_t)p[0] << 24) |
           ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8) |
           (uint32_t)p[3];
}

static void store_be32(uint8_t *p, uint32_t v)
{
    p[0] = (uint8_t)(v >> 24);
    p[1] = (uint8_t)(v >> 16);
    p[2] = (uint8_t)(v >> 8);
    p[3] = (uint8_t)v;
}

void metasec_cf61_sm3_init_350(MetaSecSm3State350 *state)
{
    memset(state, 0, sizeof(*state));

    /*
     * These exact words are written by managed F15:
     *   dyidre/versions/350101/managed_vm_decode/
     *     F15_350101_F15_0x606200_0x2a0.linear.c
     */
    state->h[0] = 0x7380166fU;
    state->h[1] = 0x4914b2b9U;
    state->h[2] = 0x172442d7U;
    state->h[3] = 0xda8a0600U;
    state->h[4] = 0xa96f30bcU;
    state->h[5] = 0x163138aaU;
    state->h[6] = 0xe38dee4dU;
    state->h[7] = 0xb0fb0e4eU;
}

void metasec_cf61_sm3_compress_350(MetaSecSm3State350 *state,
                                   const uint8_t block[64])
{
    uint32_t w[68];
    uint32_t wp[64];

    for (unsigned j = 0; j < 16; j++) {
        w[j] = load_be32(block + j * 4);
    }
    for (unsigned j = 16; j < 68; j++) {
        w[j] = sm3_p1(w[j - 16] ^ w[j - 9] ^ rotl32(w[j - 3], 15)) ^
               rotl32(w[j - 13], 7) ^
               w[j - 6];
    }
    for (unsigned j = 0; j < 64; j++) {
        wp[j] = w[j] ^ w[j + 4];
    }

    uint32_t a = state->h[0];
    uint32_t b = state->h[1];
    uint32_t c = state->h[2];
    uint32_t d = state->h[3];
    uint32_t e = state->h[4];
    uint32_t f = state->h[5];
    uint32_t g = state->h[6];
    uint32_t h = state->h[7];

    for (unsigned j = 0; j < 64; j++) {
        const uint32_t tj = j <= 15 ? 0x79cc4519U : 0x7a879d8aU;
        const uint32_t ss1 = rotl32(rotl32(a, 12) + e + rotl32(tj, j), 7);
        const uint32_t ss2 = ss1 ^ rotl32(a, 12);
        const uint32_t tt1 = sm3_ff(a, b, c, j) + d + ss2 + wp[j];
        const uint32_t tt2 = sm3_gg(e, f, g, j) + h + ss1 + w[j];

        d = c;
        c = rotl32(b, 9);
        b = a;
        a = tt1;
        h = g;
        g = rotl32(f, 19);
        f = e;
        e = sm3_p0(tt2);
    }

    state->h[0] ^= a;
    state->h[1] ^= b;
    state->h[2] ^= c;
    state->h[3] ^= d;
    state->h[4] ^= e;
    state->h[5] ^= f;
    state->h[6] ^= g;
    state->h[7] ^= h;
}

int metasec_cf61_sm3_update_350(MetaSecSm3State350 *state,
                                const void *input,
                                uint32_t input_len)
{
    /*
     * Mirrors native 0x16D5A0:
     *   - returns -1 when input_len == 0
     *   - byte counter is still +0/+4
     *   - compresses every full 64-byte block
     */
    if (input_len == 0) {
        return -1;
    }

    const uint8_t *p = (const uint8_t *)input;
    uint32_t tail_len = state->byte_count_lo & 0x3fU;
    uint32_t old_lo = state->byte_count_lo;

    state->byte_count_lo += input_len;
    if (state->byte_count_lo < old_lo) {
        state->byte_count_hi++;
    }

    if (tail_len != 0) {
        uint32_t need = 64U - tail_len;
        if (need <= input_len) {
            memcpy(state->tail + tail_len, p, need);
            metasec_cf61_sm3_compress_350(state, state->tail);
            p += need;
            input_len -= need;
            tail_len = 0;
        }
    }

    while (input_len >= 64) {
        metasec_cf61_sm3_compress_350(state, p);
        p += 64;
        input_len -= 64;
    }

    if (input_len != 0) {
        memcpy(state->tail + tail_len, p, input_len);
    }
    return 0;
}

int metasec_cf61_sm3_final_350(MetaSecSm3State350 *state,
                               uint8_t out_digest32[32])
{
    static const uint8_t pad[64] = { 0x80 };
    uint8_t be_len[8];
    uint64_t bytes = ((uint64_t)state->byte_count_hi << 32) |
                     (uint64_t)state->byte_count_lo;
    uint64_t bits = bytes << 3;
    uint32_t rem = state->byte_count_lo & 0x3fU;
    uint32_t pad_target = rem >= 56 ? 120U : 56U;

    for (unsigned i = 0; i < 8; i++) {
        be_len[i] = (uint8_t)(bits >> (56 - i * 8));
    }

    (void)metasec_cf61_sm3_update_350(state, pad, pad_target - rem);
    (void)metasec_cf61_sm3_update_350(state, be_len, 8);

    for (unsigned i = 0; i < 8; i++) {
        store_be32(out_digest32 + i * 4, state->h[i]);
    }
    return 0;
}

int metasec_cf61_sm3_oneshot_350(const void *input,
                                 uint32_t input_len,
                                 uint8_t out_digest32[32])
{
    MetaSecSm3State350 state;
    metasec_cf61_sm3_init_350(&state);
    (void)metasec_cf61_sm3_update_350(&state, input, input_len);
    return metasec_cf61_sm3_final_350(&state, out_digest32);
}

static bool eq32(const uint8_t a[32], const uint8_t b[32])
{
    uint8_t diff = 0;
    for (unsigned i = 0; i < 32; i++) {
        diff |= (uint8_t)(a[i] ^ b[i]);
    }
    return diff == 0;
}

static int check_vector(const char *name,
                        const uint8_t *input,
                        uint32_t input_len,
                        const uint8_t expected[32])
{
    uint8_t got[32];
    metasec_cf61_sm3_oneshot_350(input, input_len, got);
    bool ok = eq32(got, expected);
    printf("%s len=0x%x match=%s\n", name, input_len, ok ? "true" : "false");
    if (!ok) {
        printf("  got=");
        for (unsigned i = 0; i < 32; i++) printf("%02x", got[i]);
        printf("\n  exp=");
        for (unsigned i = 0; i < 32; i++) printf("%02x", expected[i]);
        printf("\n");
    }
    return ok ? 0 : 1;
}

#ifndef METASEC_350101_NO_MAIN
int main(void)
{
    static const uint8_t query[] =
        "iid=3247301440846819&device_id=397365608203400&ac=wifi&channel=vivo_1128_64&aid=1128&app_name=aweme&version_code=350100&version_name=35.1.0&device_platform=android&os=android&ssmix=a&device_type=Pixel+5&device_brand=google&language=zh&os_api=30&os_version=11&manifest_version_code=350101&resolution=1080*2135&dpi=440&update_version_code=35109900&_rticket=1769247175853&package=com.ss.android.ugc.aweme&first_launch_timestamp=1769245978&last_deeplink_update_version_code=0&cpu_support64=true&host_abi=arm64-v8a&is_guest_mode=0&app_type=normal&minor_status=0&appTheme=light&is_preinstall=0&need_personal_recommend=1&is_android_pad=0&is_android_fold=0&ts=1769247174&cdid=1a506faa-3555-49d0-9f25-44f7968645c1";
    static const uint8_t query_digest[32] = {
        0x1f,0x08,0x57,0x8a,0x51,0x5b,0x19,0xdc,
        0x24,0x8e,0x2c,0xef,0xe5,0xb5,0x38,0xa0,
        0x5a,0xfc,0x82,0x68,0x96,0x6f,0x1e,0x67,
        0x21,0x05,0x66,0xae,0x85,0xfb,0xe9,0x6c,
    };

    static const uint8_t x_ss_stub[0x10] = {
        0xfd,0xf6,0x0e,0x82,0xc1,0x60,0x76,0x06,
        0xe7,0x38,0x6b,0xa8,0x8d,0x06,0xb4,0xca,
    };
    static const uint8_t x_ss_stub_digest[32] = {
        0xcf,0x03,0x47,0x6f,0x3b,0x96,0x99,0xc7,
        0xeb,0x82,0x60,0x36,0x06,0x98,0x45,0x1d,
        0x90,0x16,0xdf,0x92,0x8d,0xf1,0x21,0x4e,
        0x8f,0xa0,0x1d,0x93,0x66,0x0c,0xeb,0x4d,
    };

    static const uint8_t pack44_f5[0x44] = {
        0x8e,0xbd,0xfa,0x38,0x06,0xec,0xc5,0xce,
        0xe7,0x94,0x23,0xe6,0x02,0x9e,0xd8,0x25,
        0x40,0xbc,0x22,0x18,0xbb,0x7e,0xae,0xf7,
        0x1c,0xb6,0x91,0xf7,0xaa,0x8a,0xa2,0xf5,
        0x80,0x1b,0xde,0x08,
        0x8e,0xbd,0xfa,0x38,0x06,0xec,0xc5,0xce,
        0xe7,0x94,0x23,0xe6,0x02,0x9e,0xd8,0x25,
        0x40,0xbc,0x22,0x18,0xbb,0x7e,0xae,0xf7,
        0x1c,0xb6,0x91,0xf7,0xaa,0x8a,0xa2,0xf5,
    };
    static const uint8_t pack44_f5_digest[32] = {
        0xf9,0x03,0x63,0x0a,0x5d,0x9a,0x2e,0x18,
        0x61,0x60,0x58,0x79,0x68,0x1a,0xc6,0x84,
        0x64,0x80,0x29,0x4b,0x84,0x30,0xd2,0xf7,
        0x19,0xd3,0x4f,0x61,0x43,0x97,0xe7,0x53,
    };

    static const uint8_t pack44_f8[0x44] = {
        0x8e,0xbd,0xfa,0x38,0x06,0xec,0xc5,0xce,
        0xe7,0x94,0x23,0xe6,0x02,0x9e,0xd8,0x25,
        0x40,0xbc,0x22,0x18,0xbb,0x7e,0xae,0xf7,
        0x1c,0xb6,0x91,0xf7,0xaa,0x8a,0xa2,0xf5,
        0x35,0x3c,0xb5,0x32,
        0x8e,0xbd,0xfa,0x38,0x06,0xec,0xc5,0xce,
        0xe7,0x94,0x23,0xe6,0x02,0x9e,0xd8,0x25,
        0x40,0xbc,0x22,0x18,0xbb,0x7e,0xae,0xf7,
        0x1c,0xb6,0x91,0xf7,0xaa,0x8a,0xa2,0xf5,
    };
    static const uint8_t pack44_f8_digest[32] = {
        0x2f,0xa4,0xae,0x2e,0xdf,0xf5,0x47,0x0d,
        0xbe,0x0c,0x4f,0xe5,0xe0,0x21,0xb6,0x8f,
        0x1f,0xcd,0xdf,0xea,0xc0,0x5a,0x5a,0x52,
        0x4b,0xb0,0xb7,0x04,0xe1,0x02,0x32,0x51,
    };

    int failures = 0;
    failures += check_vector("query/F5+F8", query, (uint32_t)(sizeof(query) - 1), query_digest);
    failures += check_vector("x-ss-stub/F5", x_ss_stub, sizeof(x_ss_stub), x_ss_stub_digest);
    failures += check_vector("pack44/F5", pack44_f5, sizeof(pack44_f5), pack44_f5_digest);
    failures += check_vector("pack44/F8", pack44_f8, sizeof(pack44_f8), pack44_f8_digest);
    printf("failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

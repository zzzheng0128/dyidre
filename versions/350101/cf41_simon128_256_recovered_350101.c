/*
 * Douyin 350.101 libmetasec_ml.so CF41 recovery oracle.
 *
 * Evidence:
 *   - CF41 wrapper 0x16F43C:
 *       slot4 = input MEM_BLOCK
 *       slot5 = output MEM_BLOCK
 *       slot6 = key/material MEM_BLOCK
 *   - 0x16CB88 pads/clones slot6 to 32 bytes.
 *   - 0x16E538 builds a 0x240-byte schedule, PKCS#7-pads input to a
 *     16-byte boundary, then calls managed F16 at 0x1717F4 per block.
 *   - 0x16E678 expands 32-byte key material into 72 64-bit round keys.
 *   - F16 decoded bytecode implements the SIMON round:
 *       R' = L ^ ((ROL(R,1) & ROL(R,8)) ^ ROL(R,2)) ^ K[i]
 *       L' = R
 *
 * This standalone oracle uses the runtime vector from:
 *   unidbg/unidbg-android/target/sign6_350101_cf43mode_ret_20260831_072406.log
 *
 * Expected:
 *   input len 0x92 -> PKCS#7 padded len 0xa0
 *   key len 0x20
 *   output len 0xa0
 *   failures=0
 */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_LEN(x) (sizeof(x) / sizeof((x)[0]))

static uint64_t rotl64(uint64_t x, unsigned n) {
    n &= 63u;
    return n ? ((x << n) | (x >> (64u - n))) : x;
}

static uint64_t rotr64(uint64_t x, unsigned n) {
    n &= 63u;
    return n ? ((x >> n) | (x << (64u - n))) : x;
}

static uint64_t load64_le(const uint8_t *p) {
    uint64_t v = 0;
    for (unsigned i = 0; i < 8; i++) {
        v |= (uint64_t)p[i] << (i * 8);
    }
    return v;
}

static void store64_le(uint8_t *p, uint64_t v) {
    for (unsigned i = 0; i < 8; i++) {
        p[i] = (uint8_t)(v >> (i * 8));
    }
}

static int hexval(int c) {
    if ('0' <= c && c <= '9') return c - '0';
    if ('a' <= c && c <= 'f') return c - 'a' + 10;
    if ('A' <= c && c <= 'F') return c - 'A' + 10;
    return -1;
}

static size_t from_hex(const char *hex, uint8_t *out, size_t cap) {
    size_t n = 0;
    int hi = -1;
    for (; *hex; hex++) {
        int v = hexval((unsigned char)*hex);
        if (v < 0) continue;
        if (hi < 0) {
            hi = v;
        } else {
            if (n >= cap) {
                fprintf(stderr, "from_hex overflow\n");
                exit(2);
            }
            out[n++] = (uint8_t)((hi << 4) | v);
            hi = -1;
        }
    }
    if (hi >= 0) {
        fprintf(stderr, "from_hex odd nibble\n");
        exit(2);
    }
    return n;
}

static uint32_t fnv1a32(const uint8_t *p, size_t n) {
    uint32_t h = 0x811c9dc5u;
    for (size_t i = 0; i < n; i++) {
        h ^= p[i];
        h *= 0x01000193u;
    }
    return h;
}

static size_t pkcs7_pad16(const uint8_t *input, size_t input_len,
                          uint8_t *out, size_t out_cap) {
    size_t pad = 16u - (input_len & 15u);
    if (pad == 0) pad = 16;
    size_t total = input_len + pad;
    if (total > out_cap) {
        fprintf(stderr, "pad overflow\n");
        exit(2);
    }
    memcpy(out, input, input_len);
    memset(out + input_len, (int)pad, pad);
    return total;
}

static void cf41_simon128_256_expand_16e678(const uint8_t key32[32],
                                            uint64_t round_key[72]) {
    /*
     * 0x16E678:
     *   z constant: 0x3dc94c3a046d678b
     *   c|z_bit:   0xfffffffffffffffc | bit
     *   output:    72 little-endian u64 keys = 0x240 bytes
     *
     * This is the SIMON128/256 key schedule shape.
     */
    const uint64_t z = 0x3dc94c3a046d678bULL;
    uint64_t k[4] = {
        load64_le(key32 + 0x00),
        load64_le(key32 + 0x08),
        load64_le(key32 + 0x10),
        load64_le(key32 + 0x18),
    };

    round_key[0] = k[0];
    for (unsigned i = 0; i < 0x47; i++) {
        uint64_t bit = (z >> (i % 62u)) & 1u;
        uint64_t cz = 0xfffffffffffffffcULL | bit;
        uint64_t mix = k[1] ^ rotr64(k[3], 3);
        uint64_t next = k[0] ^ cz ^ mix ^ rotr64(mix, 1);

        k[0] = k[1];
        k[1] = k[2];
        k[2] = k[3];
        k[3] = next;
        round_key[i + 1] = k[0];
    }
}

static void cf41_simon128_256_encrypt_block_f16(const uint64_t round_key[72],
                                                const uint8_t in16[16],
                                                uint8_t out16[16]) {
    uint64_t l = load64_le(in16 + 0);
    uint64_t r = load64_le(in16 + 8);

    for (unsigned i = 0; i < 72; i++) {
        uint64_t f = (rotl64(r, 1) & rotl64(r, 8)) ^ rotl64(r, 2);
        uint64_t new_r = l ^ f ^ round_key[i];
        l = r;
        r = new_r;
    }

    store64_le(out16 + 0, l);
    store64_le(out16 + 8, r);
}

static size_t cf41_simon128_256_pkcs7_encrypt(const uint8_t *input,
                                               size_t input_len,
                                               const uint8_t key32[32],
                                               uint8_t *out,
                                               size_t out_cap) {
    uint64_t round_key[72];
    uint8_t padded[0x200];
    size_t padded_len = pkcs7_pad16(input, input_len, padded, sizeof(padded));
    if (padded_len > out_cap) {
        fprintf(stderr, "out overflow\n");
        exit(2);
    }

    cf41_simon128_256_expand_16e678(key32, round_key);
    for (size_t off = 0; off < padded_len; off += 16) {
        cf41_simon128_256_encrypt_block_f16(round_key, padded + off, out + off);
    }
    return padded_len;
}

size_t metasec_cf41_simon128_256_pkcs7_encrypt_350101(const uint8_t *input,
                                                       size_t input_len,
                                                       const uint8_t key32[32],
                                                       uint8_t *out,
                                                       size_t out_cap) {
    return cf41_simon128_256_pkcs7_encrypt(input, input_len, key32, out, out_cap);
}

#ifndef METASEC_350101_NO_MAIN
int main(void) {
    static const char *CF41_INPUT_HEX =
        "08d2a4808204100218badcdea4062204313132382a0f333937333635363038323033343030320a313538383039333232"
        "383a0633352e312e3042147630342e30392e30352d6d6c2d616e64726f6964488094c8405208080000000000000060ae"
        "eea5a90d6a06cf03476f3b9672061f08578a515b7a0a080210bee15418bee1548801aeeea5a90da201046e6f6e65a801"
        "e205";
    static const char *CF41_KEY_HEX =
        "4c6dce747a113cfa8341da76a2fce9bb98d47fc0255c8021292a55f911f9984f";
    static const char *CF41_EXPECT_HEX =
        "a63401c328e9e78209512f5cb612179abb71e1f08671630ca5619d4bf9b73c9920a322acee296319e43160ad3f316b3d"
        "2960af727fef5f4beed8834c11307f69b976de34d20913f1d2a77ee2831d350446dc643f6ec3065618310a4b1bdcb257"
        "b815ed8617c2a487cf74dcfc875cafd3b751daeee4deb3540068b0fcfe8427464926bf3e1e21f16452cb9e2934bac3ca"
        "6a038315aaab923ecfcdcb18d3741af8";

    uint8_t input[0x200];
    uint8_t key[0x20];
    uint8_t expected[0x200];
    uint8_t actual[0x200];

    size_t input_len = from_hex(CF41_INPUT_HEX, input, sizeof(input));
    size_t key_len = from_hex(CF41_KEY_HEX, key, sizeof(key));
    size_t expected_len = from_hex(CF41_EXPECT_HEX, expected, sizeof(expected));
    size_t actual_len = cf41_simon128_256_pkcs7_encrypt(input, input_len, key, actual, sizeof(actual));

    int failures = 0;
    if (key_len != 0x20) failures++;
    if (input_len != 0x92) failures++;
    if (actual_len != 0xa0 || expected_len != 0xa0) failures++;
    if (actual_len != expected_len || memcmp(actual, expected, expected_len) != 0) failures++;

    printf("input=0x%zx padded/out=0x%zx key=0x%zx expected=0x%zx\n",
           input_len, actual_len, key_len, expected_len);
    printf("actual_fnv=%08x expected_fnv=%08x match=%s\n",
           fnv1a32(actual, actual_len), fnv1a32(expected, expected_len),
           failures ? "false" : "true");
    printf("cf41 SIMON128/256 oracle failures=%d\n", failures);
    return failures ? 1 : 0;
}
#endif

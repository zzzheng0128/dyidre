/*
 * 350.101 MetaSec F8 / X-Medusa mini-work mutation.
 *
 * Evidence:
 *   - managed program: F8, interp0/body id 0x310000010d7
 *   - decoded records: 0x0cbc/0x0cc2/0x0cc7/0x0ccd
 *   - writer handler:  libmetasec_ml.so+0x157EE4, managed opcode ST8
 *   - watch log:       sign6_350101_f8_watch_interp_20260831_035639.log
 *   - raw pack report: x_medusa_pack_350101.md
 *
 * Bytecode shape:
 *
 *   s22 = *(uint64_t *)(state + 0x60);
 *   key32 = (uint32_t)s22;
 *
 *   for (off = 0; off < limit; off += 4) {
 *       mini[off+0] ^= (uint8_t)(key32 >> 0);
 *       mini[off+1] ^= (uint8_t)(key32 >> 8);
 *       mini[off+2] ^= (uint8_t)(key32 >> 16);
 *       mini[off+3] ^= (uint8_t)(key32 >> 24);
 *   }
 *
 * 【中文】这段不是 CF helper，而是 F8 managed bytecode 自己用 ST8 写回。
 * 20 字节 mini-work 被当成 5 个 little-endian u32 lane，每 lane XOR 同一个
 * 动态 key32。key32 会随请求/run 变化，但同一轮 mini 里固定。
 */

#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include <stdio.h>

void medusa_f8_mutate_mini_xor_u32_350101(uint8_t mini[0x14], uint32_t key32)
{
    uint8_t k0 = (uint8_t)(key32 >> 0);
    uint8_t k1 = (uint8_t)(key32 >> 8);
    uint8_t k2 = (uint8_t)(key32 >> 16);
    uint8_t k3 = (uint8_t)(key32 >> 24);

    for (size_t off = 0; off < 0x14; off += 4) {
        mini[off + 0] ^= k0;
        mini[off + 1] ^= k1;
        mini[off + 2] ^= k2;
        mini[off + 3] ^= k3;
    }
}

static void print_hex_350101(const uint8_t *data, size_t len)
{
    for (size_t i = 0; i < len; i++) {
        printf("%02x", data[i]);
    }
}

static int check_case(const char *name,
                      const uint8_t pre[0x14],
                      uint32_t key32,
                      const uint8_t expect[0x14])
{
    uint8_t got[0x14];
    memcpy(got, pre, sizeof(got));
    medusa_f8_mutate_mini_xor_u32_350101(got, key32);

    int ok = memcmp(got, expect, sizeof(got)) == 0;
    printf("%s key32=0x%08x got=", name, key32);
    print_hex_350101(got, sizeof(got));
    printf(" match=%s\n", ok ? "true" : "false");
    return ok ? 0 : 1;
}

#ifndef METASEC_350101_NO_MAIN
int main(void)
{
    const uint8_t pre[0x14] = {
        0x05, 0x00, 0x00, 0x00, 0x2d, 0x4b, 0x4f, 0xca,
        0x49, 0x75, 0x0d, 0x43, 0x3f, 0xb5, 0xae, 0x2c,
        0x22, 0x6d, 0xcc, 0x56,
    };
    const uint8_t expect_watch[0x14] = {
        0xfe, 0x8a, 0x94, 0x6a, 0xd6, 0xc1, 0xdb, 0xa0,
        0xb2, 0xff, 0x99, 0x29, 0xc4, 0x3f, 0x3a, 0x46,
        0xd9, 0xe7, 0x58, 0x3c,
    };
    const uint8_t expect_rawcf[0x14] = {
        0xa1, 0x84, 0x94, 0x6a, 0x89, 0xcf, 0xdb, 0xa0,
        0xed, 0xf1, 0x99, 0x29, 0x9b, 0x31, 0x3a, 0x46,
        0x86, 0xe9, 0x58, 0x3c,
    };

    int failures = 0;
    failures += check_case("watch/ST8", pre, 0x6a948afbU, expect_watch);
    failures += check_case("rawCF/final-pack", pre, 0x6a9484a4U, expect_rawcf);

    printf("failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

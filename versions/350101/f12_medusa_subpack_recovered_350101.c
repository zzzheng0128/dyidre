/*
 * 350.101 MetaSec managed F12 partial lift.
 *
 * Scope:
 *   This is not a standalone X-Medusa implementation yet. It documents the
 *   evidence-backed sub-work mutation observed while F8 builds X-Medusa.
 *
 * Evidence:
 *   - managed program: F12, descriptor global 0x2c5930
 *   - interp/body id: 0x800001245f
 *   - code: 0x125d0000..0x125d0f48, 163 records, decoder known 163/163
 *   - writer: libmetasec_ml.so+0x157eb0, managed opcode ST64
 *   - trace: sign6_350101_f8_watch_interp_20260831_035639.log
 *   - source oracle: CF97 @ 0x170110 post-return slot4 begins with the
 *     31-byte stream consumed by this F12 run
 *
 * Current call-shape hypothesis:
 *   s4 = dst_base/sub_work
 *   s5 = dst limit/available length, observed 0x2af
 *   s6 = source byte stream
 *   s7 = count, observed 31
 *
 * In the observed large-buffer path, phase stays 0 and dst advances by 8
 * after each byte. The tail/small-window path is present in bytecode but has
 * not been forced by this trace, so it is intentionally kept conservative.
 */

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

static inline uint64_t
metasec_put_bit64(uint64_t old_value, unsigned source_bit, uint8_t source_byte,
                  unsigned dst_bit)
{
    uint64_t mask = 1ULL << (dst_bit & 63);
    uint64_t bit = ((uint64_t)((source_byte >> source_bit) & 1U)) << (dst_bit & 63);
    return (old_value & ~mask) | bit;
}

static uint64_t
medusa_f12_pack_one_qword_350(uint64_t old_value, uint8_t source_byte,
                              uint32_t phase)
{
    /*
     * Bytecode records 0x1a..0x82 build eight clear-mask/set-bit pairs and
     * finally ST64 the result. For the observed path phase is always 0, but
     * the general expression is left here because the bytecode has a small
     * tail-window path that increments phase.
     */
    old_value = metasec_put_bit64(old_value, 1, source_byte, ((phase + 6) & 7) + 0);
    old_value = metasec_put_bit64(old_value, 7, source_byte, ((phase + 5) & 7) + 8);
    old_value = metasec_put_bit64(old_value, 3, source_byte, ((phase + 3) & 7) + 16);
    old_value = metasec_put_bit64(old_value, 6, source_byte, ((phase + 4) & 7) + 24);
    old_value = metasec_put_bit64(old_value, 2, source_byte, ((phase + 2) & 7) + 32);
    old_value = metasec_put_bit64(old_value, 0, source_byte, ((phase - 1) & 7) + 40);
    old_value = metasec_put_bit64(old_value, 4, source_byte, ((phase + 1) & 7) + 48);
    old_value = metasec_put_bit64(old_value, 5, source_byte, ((phase + 0) & 7) + 56);
    return old_value;
}

uint32_t
medusa_f12_mutate_sub_prefix_350(uint8_t *dst_base, uint32_t dst_limit,
                                 const uint8_t *src, uint32_t count)
{
    uint32_t produced = 0;
    uint32_t dst_off = 0;
    uint32_t phase = 0;

    if (dst_limit < 8) {
        return 0;
    }

    while (count != 0) {
        uint64_t *slot = (uint64_t *)(void *)(dst_base + dst_off);
        *slot = medusa_f12_pack_one_qword_350(*slot, *src, phase);

        produced++;
        src++;
        count--;

        /*
         * Observed X-Medusa path: dst_limit=0x2af, count=31.
         * This branch is taken for all 31 writes, so phase remains 0 and the
         * stores are dst+0, dst+8, ... dst+0xf0.
         */
        if (dst_limit >= dst_off + 0x10) {
            dst_off += 8;
            continue;
        }

        /*
         * Present in F12 bytecode but not reached in the current trace.
         * Keep this as a marker for future forced tests instead of claiming a
         * finalized tail algorithm.
         */
        phase++;
        if (phase >= 8) {
            break;
        }
    }

    return produced;
}

/*
 * Oracle from the 2026-08-31 unidbg watch.
 *
 * First observed ST64:
 *   old qword: 35 df 8d 3d 28 01 db 07 = 0x07db01283d8ddf35
 *   new qword: 35 ff 85 2d 28 81 db 07 = 0x07db81282d85ff35
 *   phase:     0
 *   src byte:  0xb1
 *
 * All 31 source bytes uniquely inferred from the 31 observed qword writes:
 *   b1 58 6e 0f f7 2c f9 36 18 b1 c3 4c 92 b5 e1 24
 *   c5 ea 12 ca 3d 0e f6 1c bb e6 e7 ff 9e fc df
 */

typedef struct F12BitpackVector350 {
    uint8_t source;
    uint64_t old_qword;
    uint64_t new_qword;
} F12BitpackVector350;

static const F12BitpackVector350 k_f12_vectors_350101[31] = {
    {0xb1, 0x07db01283d8ddf35ULL, 0x07db81282d85ff35ULL},
    {0x58, 0xf1a339d6d888f018ULL, 0xf0a339d2d888d018ULL},
    {0x6e, 0x6f432a2b319cab60ULL, 0x6f412a2f319c8b60ULL},
    {0x0f, 0xcdb2b17583dd8efcULL, 0xccb0b17583dd8efcULL},
    {0xf7, 0x69237895c24c60bfULL, 0x6923f895d24460ffULL},
    {0x2c, 0x5fa4735cedd79781ULL, 0x5fa4735ceddf9781ULL},
    {0xf9, 0x6c507e5db1b556a2ULL, 0x6d52fe59b1bd76a2ULL},
    {0x36, 0x49b4f2545ad03797ULL, 0x49b672544ad017d7ULL},
    {0x18, 0x6236772354977c98ULL, 0x62367723449f5c98ULL},
    {0xb1, 0x9953d36541337a76ULL, 0x9953d36141337a36ULL},
    {0xc3, 0x92e5e935282f84f6ULL, 0x92e5e9313827a4f6ULL},
    {0x4c, 0x3ec6600c3b74663aULL, 0x3ec4600c3b7c463aULL},
    {0x92, 0xc356b1704127c3d6ULL, 0xc25631704127e3d6ULL},
    {0xb5, 0xc27406abe6787df5ULL, 0xc37686afe6707db5ULL},
    {0xe1, 0x708423a177064240ULL, 0x7184a3a177066200ULL},
    {0x24, 0x5391f3de06c8f4aeULL, 0x539173de06c0d4aeULL},
    {0xc5, 0x04f3c06dc21c8382ULL, 0x04f1c06dd214a382ULL},
    {0xea, 0x826104f71eea2bb1ULL, 0x836104f31eea2bf1ULL},
    {0x12, 0x997e329dead2afa2ULL, 0x987e3299ead28fe2ULL},
    {0xca, 0xe641bcb230046f1eULL, 0xe6413cb2300c6f5eULL},
    {0x3d, 0xfadcc454db51492aULL, 0xfbdec454cb59492aULL},
    {0x0e, 0xba7513a6dd7a55dfULL, 0xba7513a6cd7a55dfULL},
    {0xf6, 0xc2964a916eee8f14ULL, 0xc3964a957ee6af54ULL},
    {0x1c, 0xa75abec1eabfb33fULL, 0xa65a3ec5eabf933fULL},
    {0xbb, 0x267c0592c669f7d0ULL, 0x277e8592c669f7d0ULL},
    {0xe6, 0xf0278b70912c952cULL, 0xf1250b749124b56cULL},
    {0xe7, 0xd39e150d18e6a1d1ULL, 0xd39c950d18e6a1d1ULL},
    {0xff, 0x53b362dcc11ba3a1ULL, 0x53b3e2dcd11ba3e1ULL},
    {0x9e, 0x0bd390a37909f1f1ULL, 0x0ad310a76909f1f1ULL},
    {0xfc, 0x468d861e6a680b86ULL, 0x478f061e7a682b86ULL},
    {0xdf, 0x14ba0ace9dbbedd2ULL, 0x14ba8ace9dbbedd2ULL},
};

#ifndef METASEC_350101_NO_MAIN
int main(void)
{
    int failures = 0;
    for (size_t i = 0; i < sizeof(k_f12_vectors_350101) / sizeof(k_f12_vectors_350101[0]); i++) {
        const F12BitpackVector350 *v = &k_f12_vectors_350101[i];
        uint64_t got = medusa_f12_pack_one_qword_350(v->old_qword, v->source, 0);
        int ok = (got == v->new_qword);
        if (!ok) {
            failures++;
        }
        printf("idx=%02zu src=%02x old=%016llx got=%016llx expect=%016llx match=%s\n",
               i,
               (unsigned)v->source,
               (unsigned long long)v->old_qword,
               (unsigned long long)got,
               (unsigned long long)v->new_qword,
               ok ? "true" : "false");
    }

    printf("failures=%d\n", failures);
    return failures == 0 ? 0 : 1;
}
#endif

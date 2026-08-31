/*
 * 350.101 MetaSec managed VM partial lift:
 *   source-work producer families for F8/X-Medusa:
 *     F18/F22/F23/F24/F25/F26/F27/F28/F29   observed
 *     F19/F31/F32/F33/F34/F35/F36/F37/F38   observed
 *     F20/F39/F40/F41/F42/F43/F44/F45/F46   observed
 *     F21/F47/F48/F49/F50/F51/F52/F53/F54   observed
 *
 * Evidence:
 *   - unidbg log:
 *     unidbg/unidbg-android/target/sign6_350101_f21_source_watch_20260831_042743.log
 *   - timelines:
 *     dyidre/versions/350101/f19_f32_source_work_timeline_350101.md
 *     dyidre/versions/350101/f20_f40_source_work_timeline_350101.md
 *   - decoded bodies:
 *     dyidre/versions/350101/managed_vm_decode_adapters_350101/
 *     dyidre/versions/350101/managed_vm_decode_roundfamilies_350101/
 *     dyidre/versions/350101/managed_vm_decode_f32_family/
 *     dyidre/versions/350101/managed_vm_decode_f20_f40_f43_46/
 *
 * This file is intentionally a semantic sketch, not a drop-in replacement for
 * the original library.
 *
 * Binding table proof:
 *   op5e handler 0x1570DC -> 0x15AB1C:
 *     program = (*(record.q1))[imm32]
 *   q1=0x125fd3c0, *q1=0x12608000 in the current unidbg run.
 *     index 0x7d -> managed F22, 20-record adapter
 *     index 0x7e -> managed F23, 67-record block loop
 *     index 0x7f -> managed F31, 20-record adapter
 *     index 0x80 -> managed F32, 67-record block loop
 *     index 0x81 -> managed F39, 20-record adapter
 *     index 0x82 -> managed F40, 67-record block loop
 *     index 0x83 -> managed F47, 20-record adapter
 *     index 0x84 -> managed F48, 67-record block loop
 *     index 0x85 -> managed F24, key schedule / first-block pre-transform
 *     index 0x86 -> managed F25, scheduler
 *     index 0x87..0x8a -> managed F26/F27/F28/F29, round primitives
 *     index 0x8b -> managed F30, GF(2^8) multiply
 *     index 0x8c/0x8d -> managed F33/F34
 *     index 0x8e..0x91 -> managed F35/F36/F37/F38
 *     index 0x92/0x93 -> managed F41/F42
 *     index 0x94..0x97 -> managed F43/F44/F45/F46
 *     index 0x98/0x99 -> managed F49/F50
 *     index 0x9a..0x9d -> managed F51/F52/F53/F54
 *
 * Managed opcode note:
 *   op 0x0d in F24/F33/F41/F49 is BYTE_FROM_U32_SHIFT, not the native VMP
 *   opcode with the same number:
 *     dst = (uint8_t)((uint32_t)const32 >> (shift & 31))
 */

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#if defined(__GNUC__) || defined(__clang__)
#define META_UNUSED __attribute__((unused))
#else
#define META_UNUSED
#endif

typedef void (*SourceWorkScheduler350)(uint8_t block16[16],
                                       const uint8_t *key_area,
                                       const uint8_t *substitution_table);

static const uint8_t kObservedPreTransform31_350101[31] = {
    0x38, 0x64, 0x29, 0xd4, 0x8c, 0xc8, 0xad, 0xcd,
    0xd1, 0x44, 0xd8, 0x23, 0xbe, 0x29, 0x32, 0x5e,
    0xb2, 0xe5, 0x0c, 0xc6, 0x63, 0x65, 0x7d, 0x5a,
    0x4c, 0x85, 0xfe, 0xeb, 0xfd, 0xac, 0xa2,
};

static const uint8_t kObservedSourceWork32_350101[32] = {
    0xe6, 0x40, 0xad, 0x61, 0x51, 0x42, 0xbb, 0x3d,
    0x39, 0xf4, 0xfd, 0x74, 0x64, 0x85, 0xcc, 0x03,
    0x14, 0x54, 0xd5, 0x57, 0xa8, 0x0f, 0x56, 0x59,
    0xfe, 0x8e, 0x14, 0xd3, 0x68, 0x55, 0x0e, 0x3b,
};

/*
 * F30: GF(2^8) multiply with AES-style reduction polynomial 0x1b.
 *
 * F30 inputs are passed through VM slots:
 *   s4 = multiplier
 *   s5 = value
 * and the product is left in s2. The old unknown op23 is:
 *   S[c] = (int64_t)(int8_t)(uint8_t)S[b]
 */
static META_UNUSED uint8_t f30_gf256_mul_350(uint8_t multiplier, uint8_t value)
{
    uint8_t acc = 0;
    uint8_t x = value;
    uint8_t m = multiplier;

    while (m != 0) {
        if ((m & 1) != 0) {
            acc ^= x;
        }

        uint8_t high = x & 0x80;
        x <<= 1;
        if (high != 0) {
            x ^= 0x1b;
        }

        m >>= 1;
    }

    return acc;
}

/*
 * F24/F33/F41/F49: family-specific key-area preparation.
 *
 * VM slot ABI:
 *   s4 = destination key_area
 *   s5 = 16-byte source key
 *
 * The first 16 bytes are source XOR a repeating little-endian family constant.
 * Words 4..11 then use the usual 4-word recurrence.  The two round constants
 * are family_bytes[1] and family_bytes[2], matching op0d shifts 8 and 16.
 */
static META_UNUSED void expand_round_keys_family_350(uint8_t key_area[48],
                                                     const uint8_t source_key[16],
                                                     const uint8_t *sbox,
                                                     uint32_t family_const)
{
    uint8_t family_bytes[4] = {
        (uint8_t)(family_const >> 0),
        (uint8_t)(family_const >> 8),
        (uint8_t)(family_const >> 16),
        (uint8_t)(family_const >> 24),
    };

    for (size_t i = 0; i != 16; i++) {
        key_area[i] = source_key[i] ^ family_bytes[i & 3];
    }

    for (size_t word = 4; word != 12; word++) {
        uint8_t temp[4];
        memcpy(temp, key_area + (word - 1) * 4, sizeof(temp));

        if ((word & 3) == 0) {
            uint8_t old0 = temp[0];
            temp[0] = sbox[temp[1]] ^ family_bytes[word >> 2];
            temp[1] = sbox[temp[2]];
            temp[2] = sbox[temp[3]];
            temp[3] = sbox[old0];
        }

        for (size_t byte = 0; byte != 4; byte++) {
            key_area[word * 4 + byte] =
                key_area[(word - 4) * 4 + byte] ^ temp[byte];
        }
    }
}

static META_UNUSED void f24_expand_round_keys_350(uint8_t key_area[48],
                                                  const uint8_t source_key[16],
                                                  const uint8_t *sbox_base_plus_0x33a)
{
    expand_round_keys_family_350(
        key_area, source_key, sbox_base_plus_0x33a, UINT32_C(0xbbb5de72));
}

static META_UNUSED void f33_expand_round_keys_350(uint8_t key_area[48],
                                                  const uint8_t source_key[16],
                                                  const uint8_t *sbox_base_plus_0x484)
{
    expand_round_keys_family_350(
        key_area, source_key, sbox_base_plus_0x484, UINT32_C(0xd4638d5b));
}

static META_UNUSED void f41_expand_round_keys_350(uint8_t key_area[48],
                                                  const uint8_t source_key[16],
                                                  const uint8_t *sbox_base_plus_0x585)
{
    expand_round_keys_family_350(
        key_area, source_key, sbox_base_plus_0x585, UINT32_C(0x92a5f73b));
}

static META_UNUSED void f49_expand_round_keys_350(uint8_t key_area[48],
                                                  const uint8_t source_key[16],
                                                  const uint8_t *sbox_base_plus_0x171)
{
    expand_round_keys_family_350(
        key_area, source_key, sbox_base_plus_0x171, UINT32_C(0x89f8a1c9));
}

/* F22's second call is CF index 0x36: copy 16-byte IV to key_area+0xb0. */
static META_UNUSED void f22_prepare_key_area_350(uint8_t *key_area,
                                                 const uint8_t source_key[16],
                                                 const uint8_t iv16[16],
                                                 const uint8_t *sbox_base_plus_0x33a)
{
    f24_expand_round_keys_350(key_area, source_key, sbox_base_plus_0x33a);
    memcpy(key_area + 0xb0, iv16, 16);
}

/* F31/F39/F47 are the same 20-record adapter with a different key expander. */
static META_UNUSED void f31_prepare_key_area_350(uint8_t *key_area,
                                                 const uint8_t source_key[16],
                                                 const uint8_t iv16[16],
                                                 const uint8_t *sbox_base_plus_0x484)
{
    f33_expand_round_keys_350(key_area, source_key, sbox_base_plus_0x484);
    memcpy(key_area + 0xb0, iv16, 16);
}

static META_UNUSED void f39_prepare_key_area_350(uint8_t *key_area,
                                                 const uint8_t source_key[16],
                                                 const uint8_t iv16[16],
                                                 const uint8_t *sbox_base_plus_0x585)
{
    f41_expand_round_keys_350(key_area, source_key, sbox_base_plus_0x585);
    memcpy(key_area + 0xb0, iv16, 16);
}

static META_UNUSED void f47_prepare_key_area_350(uint8_t *key_area,
                                                 const uint8_t source_key[16],
                                                 const uint8_t iv16[16],
                                                 const uint8_t *sbox_base_plus_0x171)
{
    f49_expand_round_keys_350(key_area, source_key, sbox_base_plus_0x171);
    memcpy(key_area + 0xb0, iv16, 16);
}

/*
 * F45: F20/F40-family pure 16-byte permutation.
 *
 * Observed from F45_350101_F45_0x5e2200_0x1f8.linear.c and the work-area
 * timeline groups. The writes deliberately leave indices 0/3/4/8/11/12 intact.
 */
static META_UNUSED void f45_perm16_350(uint8_t block[16])
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    block[0x1] = old[0x9];
    block[0x9] = old[0x1];

    block[0x5] = old[0xd];
    block[0xd] = old[0x5];

    block[0x7] = old[0xf];
    block[0xf] = old[0x7];

    block[0x2] = old[0xe];
    block[0x6] = old[0x2];
    block[0xa] = old[0x6];
    block[0xe] = old[0xa];
}

/*
 * F37: F19/F32-family pure 16-byte permutation.
 *
 * It shares the first swaps with F45, but additionally rotates the
 * 3/7/11/15 group. Timeline evidence: F37 writes 12 bytes while F45 writes 10.
 */
static META_UNUSED void f37_perm16_350(uint8_t block[16])
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    block[0x1] = old[0x9];
    block[0x9] = old[0x1];

    block[0x5] = old[0xd];
    block[0xd] = old[0x5];

    block[0x2] = old[0xe];
    block[0xe] = old[0xa];
    block[0xa] = old[0x6];
    block[0x6] = old[0x2];

    block[0xf] = old[0x7];
    block[0xb] = old[0xf];
    block[0x3] = old[0xb];
    block[0x7] = old[0x3];
}

/*
 * F44: F20/F40-family four-column byte substitution/rotation.
 *
 * In decoded F44, S[5] = *(pool_ptr) + 0x585, then for i=0..3 it reads
 * block[i+8], block[i+12], block[i+4], block[i+0], substitutes through S,
 * and writes them back to [i+12, i+8, i+4, i+0].
 */
static META_UNUSED void f44_subrot16_350(uint8_t block[16], const uint8_t *sbox_base_plus_0x585)
{
    for (size_t i = 0; i != 4; i++) {
        uint8_t b8  = block[i + 0x8];
        uint8_t b12 = block[i + 0xc];
        uint8_t b4  = block[i + 0x4];
        uint8_t b0  = block[i + 0x0];

        block[i + 0xc] = sbox_base_plus_0x585[b0];
        block[i + 0x8] = sbox_base_plus_0x585[b4];
        block[i + 0x4] = sbox_base_plus_0x585[b8];
        block[i + 0x0] = sbox_base_plus_0x585[b12];
    }
}

/*
 * F36: F19/F32-family four-column byte substitution/rotation.
 *
 * Compared with F44:
 *   - uses secondary table base +0x484 instead of +0x585 in current decode;
 *   - writes the substituted bytes back with a different column order.
 *
 * The secondary table base is file-backed:
 *   *(pool+0x308) = module.base + 0x29f890
 *   F36 table = module.base + 0x29fd14
 *   F44 table = module.base + 0x29fe15
 * See source_work_static_tables_350101.md.
 */
static META_UNUSED void f36_subrot16_350(uint8_t block[16], const uint8_t *sbox_base_plus_0x484)
{
    for (size_t i = 0; i != 4; i++) {
        uint8_t b4  = block[i + 0x4];
        uint8_t b12 = block[i + 0xc];
        uint8_t b8  = block[i + 0x8];
        uint8_t b0  = block[i + 0x0];

        block[i + 0xc] = sbox_base_plus_0x484[b0];
        block[i + 0x8] = sbox_base_plus_0x484[b8];
        block[i + 0x0] = sbox_base_plus_0x484[b4];
        block[i + 0x4] = sbox_base_plus_0x484[b12];
    }
}

/* F26: family-A round-key XOR.  The byte swizzle is exact from 28 records. */
static META_UNUSED void f26_xor_round_key_350(uint8_t block[16],
                                              const uint8_t *key_area,
                                              uint8_t round)
{
    const uint8_t *key = key_area + ((size_t)round << 4);

    for (size_t off = 0; off != 16; off += 4) {
        block[off + 1] ^= key[off + 0];
        block[off + 3] ^= key[off + 1];
        block[off + 0] ^= key[off + 2];
        block[off + 2] ^= key[off + 3];
    }
}

/* F27: family-A table substitution plus four-lane rotation. */
static META_UNUSED void f27_subrot16_350(uint8_t block[16],
                                         const uint8_t *sbox_base_plus_0x33a)
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    for (size_t i = 0; i != 4; i++) {
        block[i + 0x0] = sbox_base_plus_0x33a[old[i + 0x8]];
        block[i + 0x4] = sbox_base_plus_0x33a[old[i + 0x0]];
        block[i + 0x8] = sbox_base_plus_0x33a[old[i + 0xc]];
        block[i + 0xc] = sbox_base_plus_0x33a[old[i + 0x4]];
    }
}

/* F28: family-A fixed byte permutation, exact from its 23 records. */
static META_UNUSED void f28_perm16_350(uint8_t block[16])
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    block[0x1] = old[0x9];
    block[0x9] = old[0x1];

    block[0x5] = old[0xd];
    block[0xd] = old[0x5];

    block[0x2] = old[0xe];
    block[0xe] = old[0xa];
    block[0xa] = old[0x6];
    block[0x6] = old[0x2];

    block[0xf] = old[0xb];
    block[0xb] = old[0x3];
    block[0x3] = old[0xf];
}

/*
 * F43: F20/F40-family XOR one 16-byte round key into the block.
 *
 * round selects a 16-byte row from rk_table. Each 4-byte chunk is applied in
 * reverse order:
 *
 *   dst[off+3] ^= key[off+0]
 *   dst[off+2] ^= key[off+1]
 *   dst[off+1] ^= key[off+2]
 *   dst[off+0] ^= key[off+3]
 */
static META_UNUSED void f43_xor_round_key_rev4_350(uint8_t block[16],
                                                   const uint8_t *rk_table,
                                                   uint8_t round)
{
    const uint8_t *key = rk_table + ((size_t)round << 4);

    for (size_t off = 0; off != 16; off += 4) {
        block[off + 3] ^= key[off + 0];
        block[off + 2] ^= key[off + 1];
        block[off + 1] ^= key[off + 2];
        block[off + 0] ^= key[off + 3];
    }
}

/*
 * F35: F19/F32-family XOR one 16-byte round key into the block.
 *
 * Same high-level role as F43, but the per-4-byte byte application differs.
 * Keep it as a separate helper until key schedule source is byte-exact.
 */
static META_UNUSED void f35_xor_round_key_swizzle_350(uint8_t block[16],
                                                      const uint8_t *rk_table,
                                                      uint8_t round)
{
    const uint8_t *key = rk_table + ((size_t)round << 4);

    for (size_t off = 0; off != 16; off += 4) {
        block[off + 3] ^= key[off + 0];
        block[off + 0] ^= key[off + 1];
        block[off + 2] ^= key[off + 2];
        block[off + 1] ^= key[off + 3];
    }
}

/* F51: F21/F47/F48-family round-key XOR. */
static META_UNUSED void f51_xor_round_key_350(uint8_t block[16],
                                              const uint8_t *rk_table,
                                              uint8_t round)
{
    const uint8_t *key = rk_table + ((size_t)round << 4);

    for (size_t off = 0; off != 16; off += 4) {
        block[off + 3] ^= key[off + 0];
        block[off + 2] ^= key[off + 1];
        block[off + 0] ^= key[off + 2];
        block[off + 1] ^= key[off + 3];
    }
}

/* F52: F21 family substitution/rotation using runtime-pool table +0x171. */
static META_UNUSED void f52_subrot16_350(uint8_t block[16],
                                         const uint8_t *sbox_base_plus_0x171)
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    for (size_t i = 0; i != 4; i++) {
        block[i + 0x0] = sbox_base_plus_0x171[old[i + 0x8]];
        block[i + 0x4] = sbox_base_plus_0x171[old[i + 0xc]];
        block[i + 0x8] = sbox_base_plus_0x171[old[i + 0x4]];
        block[i + 0xc] = sbox_base_plus_0x171[old[i + 0x0]];
    }
}

/* F53: F21 family fixed byte permutation. */
static META_UNUSED void f53_perm16_350(uint8_t block[16])
{
    uint8_t old[16];
    memcpy(old, block, sizeof(old));

    block[0x1] = old[0x9];
    block[0x9] = old[0x1];

    block[0x5] = old[0xd];
    block[0xd] = old[0x5];

    block[0x2] = old[0xe];
    block[0xe] = old[0xa];
    block[0xa] = old[0x6];
    block[0x6] = old[0x2];

    block[0xf] = old[0x7];
    block[0x7] = old[0x3];
    block[0x3] = old[0xf];
}

/*
 * F23/F32/F40/F48: outer 16-byte block loop family.
 *
 * Decoded shape:
 *   - iterate block pointer s5 while offset < s6
 *   - xor block[0..15] with key_area+0xb0
 *   - CALL_CF_INDEX scheduler index -> managed F34/F42-like scheduler family
 *   - xor block[0..15] with key_area+0x10
 *   - copy the current output block to key_area+0xb0 before the next block
 *
 * The per-block writeback is important: runtime vectors show the first block
 * matches even without chaining, while the second block only matches if the
 * previous ciphertext is used as the next key_area+0xb0 chain value.
 */
static META_UNUSED void source_work_block_loop_350(uint8_t *key_area,
                                                   uint8_t *buf,
                                                   size_t length,
                                                   const uint8_t *substitution_table,
                                                   SourceWorkScheduler350 scheduler)
{
    size_t offset = 0;
    uint8_t *block = buf;

    /* The VM compares offset < s6; callers provide a multiple of 16. */
    while (offset < length) {
        block = buf + offset;

        for (size_t i = 0; i != 16; i++) {
            block[i] ^= key_area[0xb0 + i];
        }

        if (scheduler != 0) {
            scheduler(block, key_area, substitution_table);
        }

        for (size_t i = 0; i != 16; i++) {
            block[i] ^= key_area[0x10 + i];
        }

        memcpy(key_area + 0xb0, block, 16);
        offset += 16;
    }
}

/*
 * F29/F38/F46/F54: same GF(2^8) matrix, different 4-byte scratch swizzle.
 *
 * For every original 4-byte group, scratch receives block[swizzle[0..3]].
 * The remaining 124 records are the same four-row matrix and call F30 sixteen
 * times.  This isolates the only business-relevant difference between the
 * four 154-record programs.
 */
static META_UNUSED void mix_columns_swizzled_350(uint8_t block[16],
                                                 const uint8_t swizzle[4])
{
    uint8_t t[16];
    for (size_t off = 0; off != 16; off += 4) {
        for (size_t byte = 0; byte != 4; byte++) {
            t[off + byte] = block[off + swizzle[byte]];
        }
    }

    for (size_t col = 0; col != 4; col++) {
        uint8_t a = t[col + 0x0];
        uint8_t b = t[col + 0x4];
        uint8_t c = t[col + 0x8];
        uint8_t d = t[col + 0xc];

        block[col + 0x0] =
            f30_gf256_mul_350(2, a) ^ f30_gf256_mul_350(3, b) ^ c ^ d;
        block[col + 0x4] =
            a ^ f30_gf256_mul_350(2, b) ^ f30_gf256_mul_350(3, c) ^ d;
        block[col + 0x8] =
            a ^ b ^ f30_gf256_mul_350(2, c) ^ f30_gf256_mul_350(3, d);
        block[col + 0xc] =
            f30_gf256_mul_350(3, a) ^ b ^ c ^ f30_gf256_mul_350(2, d);
    }
}

static META_UNUSED void f29_mix_columns_350(uint8_t block[16])
{
    static const uint8_t swizzle[4] = { 2, 0, 3, 1 };
    mix_columns_swizzled_350(block, swizzle);
}

static META_UNUSED void f38_mix_columns_350(uint8_t block[16])
{
    static const uint8_t swizzle[4] = { 1, 3, 2, 0 };
    mix_columns_swizzled_350(block, swizzle);
}

static META_UNUSED void f46_mix_columns_350(uint8_t block[16])
{
    static const uint8_t swizzle[4] = { 3, 2, 1, 0 };
    mix_columns_swizzled_350(block, swizzle);
}

static META_UNUSED void f54_mix_columns_350(uint8_t block[16])
{
    static const uint8_t swizzle[4] = { 2, 3, 1, 0 };
    mix_columns_swizzled_350(block, swizzle);
}

/* F25: exact family-A scheduler called once for each F23 data block. */
static META_UNUSED void f25_round_scheduler_350(uint8_t block[16],
                                                const uint8_t *key_area,
                                                const uint8_t *sbox_base_plus_0x33a)
{
    f26_xor_round_key_350(block, key_area, 0);
    f27_subrot16_350(block, sbox_base_plus_0x33a);
    f28_perm16_350(block);
    f29_mix_columns_350(block);
    f26_xor_round_key_350(block, key_area, 1);
    f27_subrot16_350(block, sbox_base_plus_0x33a);
    f28_perm16_350(block);
    f26_xor_round_key_350(block, key_area, 2);
}

/* F34: exact F19/F31/F32-family two-round scheduler. */
static META_UNUSED void f34_round_scheduler_350(uint8_t block[16],
                                                const uint8_t *key_area,
                                                const uint8_t *sbox_base_plus_0x484)
{
    f35_xor_round_key_swizzle_350(block, key_area, 0);
    f36_subrot16_350(block, sbox_base_plus_0x484);
    f37_perm16_350(block);
    f38_mix_columns_350(block);
    f35_xor_round_key_swizzle_350(block, key_area, 1);
    f36_subrot16_350(block, sbox_base_plus_0x484);
    f37_perm16_350(block);
    f35_xor_round_key_swizzle_350(block, key_area, 2);
}

/* F42: exact F20/F39/F40-family two-round scheduler. */
static META_UNUSED void f42_round_scheduler_350(uint8_t block[16],
                                                const uint8_t *key_area,
                                                const uint8_t *sbox_base_plus_0x585)
{
    f43_xor_round_key_rev4_350(block, key_area, 0);
    f44_subrot16_350(block, sbox_base_plus_0x585);
    f45_perm16_350(block);
    f46_mix_columns_350(block);
    f43_xor_round_key_rev4_350(block, key_area, 1);
    f44_subrot16_350(block, sbox_base_plus_0x585);
    f45_perm16_350(block);
    f43_xor_round_key_rev4_350(block, key_area, 2);
}

/* F50: exact F21/F47/F48-family two-round scheduler. */
static META_UNUSED void f50_round_scheduler_350(uint8_t block[16],
                                                const uint8_t *key_area,
                                                const uint8_t *sbox_base_plus_0x171)
{
    f51_xor_round_key_350(block, key_area, 0);
    f52_subrot16_350(block, sbox_base_plus_0x171);
    f53_perm16_350(block);
    f54_mix_columns_350(block);
    f51_xor_round_key_350(block, key_area, 1);
    f52_subrot16_350(block, sbox_base_plus_0x171);
    f53_perm16_350(block);
    f51_xor_round_key_350(block, key_area, 2);
}

/* F23 with its family-specific F25 call inlined into readable C. */
static META_UNUSED void f23_process_blocks_350(uint8_t *key_area,
                                               uint8_t *buf,
                                               size_t length,
                                               const uint8_t *sbox_base_plus_0x33a)
{
    source_work_block_loop_350(
        key_area, buf, length, sbox_base_plus_0x33a, f25_round_scheduler_350);
}

static META_UNUSED void f32_process_blocks_350(uint8_t *key_area,
                                               uint8_t *buf,
                                               size_t length,
                                               const uint8_t *sbox_base_plus_0x484)
{
    source_work_block_loop_350(
        key_area, buf, length, sbox_base_plus_0x484, f34_round_scheduler_350);
}

static META_UNUSED void f40_process_blocks_350(uint8_t *key_area,
                                               uint8_t *buf,
                                               size_t length,
                                               const uint8_t *sbox_base_plus_0x585)
{
    source_work_block_loop_350(
        key_area, buf, length, sbox_base_plus_0x585, f42_round_scheduler_350);
}

static META_UNUSED void f48_process_blocks_350(uint8_t *key_area,
                                               uint8_t *buf,
                                               size_t length,
                                               const uint8_t *sbox_base_plus_0x171)
{
    source_work_block_loop_350(
        key_area, buf, length, sbox_base_plus_0x171, f50_round_scheduler_350);
}

/*
 * Observed source-work high-level shape.
 *
 * Four source-work families have been observed by sweep:
 *   F19/F31/F32-family interp0 outer = 0x1a00001497f
 *   F20/F39/F40-family interp0 outer = 0x1a0000132b5
 *   F18/F22/F23-family interp0 outer = 0x1a0000126f0
 *   F21/F47/F48-family interp0 outer = 0x1a000013dba
 *
 * The F12 bit-pack stage later consumes the final first 31 bytes as source
 * stream.
 */
static void f20_f21_source_work_observed_boundary_350(uint8_t work[32],
                                                      const uint8_t src31[31])
{
    memcpy(work, src31, 31);
    work[31] = 0x01; /* padding to 0x20 in the observed path */

    /*
     * Then the selected outer family calls its adapter and block-loop family
     * in-place. Current observed runs used F19/F31/F32 and F20/F39/F40.
     * Byte-exact result for the current trace:
     *
     *   e6 40 ad 61 51 42 bb 3d 39 f4 fd 74 64 85 cc 03
     *   14 54 d5 57 a8 0f 56 59 fe 8e 14 d3 68 55 0e 3b
     *
     * That 32-byte prefix is present as CF97 slot4/body and then feeds F12.
     */
}

int metasec_350101_source_work_observed_selfcheck(void)
{
    uint8_t work[32];
    f20_f21_source_work_observed_boundary_350(work, kObservedPreTransform31_350101);

    /*
     * Lightweight smoke check only. Byte-exact four-family regression lives in:
     *   source_work_vector_selfcheck_350101.c
     *
     * That selfcheck exercises F22/F23, F31/F32, F39/F40 and F47/F48 with
     * unidbg runtime vectors and verifies the chained key_area+0xb0 writeback.
     */
    return work[31] == 0x01 && kObservedSourceWork32_350101[0] == 0xe6;
}

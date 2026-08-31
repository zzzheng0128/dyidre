/*
 * Public C surface for the 350.101 MetaSec recovery baseline.
 *
 * These APIs are intentionally narrow: they expose only pieces that have
 * byte-exact runtime vectors or deterministic self-checks. The outer
 * buildSignedHttpHeadersInner_350 wrapper still depends on app/JNI/TreeMap
 * runtime state and remains documented as pseudo-C.
 */

#ifndef METASEC_350101_RECOVERED_C_H
#define METASEC_350101_RECOVERED_C_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct MetaSecSm3State350 {
    uint32_t h[8];
    uint64_t total_len;
    uint8_t buffer[64];
    uint32_t buffer_len;
} MetaSecSm3State350;

typedef struct MetaSecBytes350 {
    const uint8_t *data;
    size_t len;
} MetaSecBytes350;

typedef struct MetaSecXArgusAlgorithmSeq350 {
    int has_k1_algo_seq;
    uint64_t k1_algo_seq;
    int has_k2_report_seq;
    uint64_t k2_report_seq;
    int has_k3_setting_seq;
    uint64_t k3_setting_seq;
    int has_k4_error_seq;
    uint64_t k4_error_seq;
    int has_k5_last_report_id;
    uint64_t k5_last_report_id;
} MetaSecXArgusAlgorithmSeq350;

typedef struct MetaSecXArgusStruct350 {
    int has_k1_sdk_date;
    uint64_t k1_sdk_date;
    int has_k2_type;
    uint64_t k2_type;
    int has_k3_random_value;
    uint64_t k3_random_value;
    const char *k4_aid;
    const char *k5_device_id;
    const char *k6_version_string;
    const char *k7_app_version_name;
    const char *k8_sdk_version_name;
    int has_k9_sdk_version_code;
    uint64_t k9_sdk_version_code;
    MetaSecBytes350 k10_proto_header;
    const char *k11_platform;
    int has_k12_khronos;
    uint64_t k12_khronos;
    MetaSecBytes350 k13_xssstub_sm3;
    MetaSecBytes350 k14_url_sm3;
    int has_k15_algorithm_seq;
    MetaSecXArgusAlgorithmSeq350 k15_algorithm_seq;
    const char *k16_ms_token;
    int has_k17_khronos;
    uint64_t k17_khronos;
    MetaSecBytes350 k18;
    MetaSecBytes350 k19;
    const char *k20_pskVersion;
    int has_k21_callType;
    uint64_t k21_callType;
} MetaSecXArgusStruct350;

void metasec_cf61_sm3_init_350(MetaSecSm3State350 *state);
void metasec_cf61_sm3_compress_350(MetaSecSm3State350 *state,
                                   const uint8_t block[64]);
int metasec_cf61_sm3_update_350(MetaSecSm3State350 *state,
                                const void *input,
                                uint32_t input_len);
int metasec_cf61_sm3_final_350(MetaSecSm3State350 *state, uint8_t out[32]);
int metasec_cf61_sm3_oneshot_350(const void *input,
                                 uint32_t input_len,
                                 uint8_t out[32]);

size_t cf48_padded_len_350101(size_t text_len);
void cf48_make_padded_text_350101(const uint8_t *text,
                                  size_t text_len,
                                  uint8_t *out,
                                  size_t out_len);
void cf48_seed_schedule_16E8FC_350101(const uint8_t key32[32],
                                      uint64_t schedule34[34]);
void cf48_f17_encrypt_block_350101(const uint64_t schedule34[34],
                                   const uint8_t in16[16],
                                   uint8_t out16[16]);
void cf48_transform_blocks_with_f17_350101(const uint8_t key32[32],
                                           const uint8_t *padded,
                                           size_t padded_len,
                                           uint8_t *out);
size_t cf48_transform_text_key32_350101(const uint8_t *text,
                                        size_t text_len,
                                        const uint8_t key32[32],
                                        uint8_t *out,
                                        size_t out_cap);
void cf49_pack_prefix4_transform32_350101(const uint8_t prefix4[4],
                                          const uint8_t transform32[32],
                                          uint8_t out36[36]);
size_t cf44_base64_encode_350101(const uint8_t *src,
                                 size_t src_len,
                                 char *out,
                                 size_t out_cap);

size_t metasec_cf41_simon128_256_pkcs7_encrypt_350101(const uint8_t *input,
                                                       size_t input_len,
                                                       const uint8_t key32[32],
                                                       uint8_t *out,
                                                       size_t out_cap);

size_t metasec_cf43_aes128_cbc_pkcs7_encrypt_350101(uint8_t *out,
                                                     size_t out_cap,
                                                     const uint8_t *body,
                                                     size_t body_len,
                                                     const uint8_t key[16],
                                                     const uint8_t iv[16]);

void medusa_f8_mutate_mini_xor_u32_350101(uint8_t mini[0x14], uint32_t key32);
uint32_t medusa_f12_mutate_sub_prefix_350(uint8_t *dst_base,
                                          uint32_t dst_limit,
                                          const uint8_t *src,
                                          uint32_t count);

int metasec_350101_source_work_observed_selfcheck(void);
int metasec_350101_source_work_vector_selfcheck(void);

void metasec_build_x_gorgon_material20_350101(uint8_t out20[20],
                                              const uint8_t url_digest4[4],
                                              const uint8_t x_ss_stub16[16],
                                              uint32_t gorgon_word,
                                              uint32_t seed);
size_t metasec_build_x_gorgon_raw_350101(uint8_t out26[26],
                                         const uint8_t material20[20],
                                         uint16_t short_code,
                                         uint16_t raw_body_addr_low16);
size_t metasec_build_x_gorgon_value_350101(char *out_hex,
                                           size_t out_cap,
                                           const uint8_t url_digest4[4],
                                           const uint8_t x_ss_stub16[16],
                                           uint32_t gorgon_word,
                                           uint32_t seed,
                                           uint16_t short_code,
                                           uint16_t raw_body_addr_low16);
size_t metasec_build_x_khronos_value_350101(char *out,
                                            size_t out_cap,
                                            uint32_t seed);
size_t metasec_build_short_header_value_350101(char *out_b64,
                                               size_t out_cap,
                                               const char *formatted_text,
                                               const uint8_t key32_ascii[32],
                                               const uint8_t prefix4[4]);
size_t metasec_build_x_ladon_value_350101(char *out_b64,
                                          size_t out_cap,
                                          uint32_t seed,
                                          const char *stack_memblock,
                                          const char *derived_block,
                                          const uint8_t key32_ascii[32],
                                          const uint8_t prefix4[4]);
size_t metasec_build_x_helios_value_350101(char *out_b64,
                                           size_t out_cap,
                                           uint32_t seed,
                                           const char *stack_memblock,
                                           const char *derived_block,
                                           const uint8_t key32_ascii[32],
                                           const uint8_t prefix4[4]);
size_t metasec_build_x_argus_tail_value_350101(char *out_b64,
                                               size_t out_cap,
                                               const uint8_t *body_b3,
                                               size_t body_b3_len,
                                               const uint8_t key16[16],
                                               const uint8_t iv16[16],
                                               uint16_t final_prefix2_le);
void metasec_x_argus_mask_from_seed_350101(uint8_t out4[4], uint32_t seed);
size_t metasec_x_argus_reverse_xor_tail_350101(uint8_t *out,
                                               size_t out_cap,
                                               const uint8_t *src,
                                               size_t src_len,
                                               const uint8_t mask4[4]);
size_t metasec_build_x_argus_algorithm_seq_plain_350101(
    uint8_t *out,
    size_t out_cap,
    const MetaSecXArgusAlgorithmSeq350 *seq);
size_t metasec_build_x_argus_plain_350101(
    uint8_t *out,
    size_t out_cap,
    const MetaSecXArgusStruct350 *msg);
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
                                                     uint16_t final_prefix2_le);
/*
 * Diagnostic scaffold only: F5 mutates the 08||CF41out work area before the
 * final AES bodyB3. For byte-exact final X-Argus, call
 * metasec_build_x_argus_value_from_plain_350101() when tail_mask4 is known,
 * or metasec_build_x_argus_tail_value_350101() with observed/mutated bodyB3.
 */
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
                                                    uint16_t final_prefix2_le);
size_t metasec_build_x_medusa_pack_350101(uint8_t *out_pack,
                                          size_t out_cap,
                                          const uint8_t mini20[0x14],
                                          const uint8_t const2[2],
                                          uint8_t zero1,
                                          uint8_t one1,
                                          uint8_t marker1,
                                          const uint8_t *subpack,
                                          size_t subpack_len);
size_t metasec_build_x_medusa_value_from_pack_350101(char *out_b64,
                                                     size_t out_cap,
                                                     const uint8_t *pack,
                                                     size_t pack_len);
size_t metasec_build_x_soter_value_from_pack_350101(char *out_b64,
                                                    size_t out_cap,
                                                    const uint8_t *pack,
                                                    size_t pack_len);
size_t metasec_build_x_soter_empty_value_350101(char *out_b64,
                                                size_t out_cap);

typedef struct MetaSecHeaders350 {
    char x_argus[0x180];
    char x_gorgon[0x40];
    char x_helios[0x40];
    char x_khronos[0x20];
    char x_ladon[0x40];
    char x_medusa[0x400];
    char x_soter[0x100];
} MetaSecHeaders350;

int metasec_build_headers_from_s1_s2_fixed_350101(const char *s1,
                                                  const char *s2,
                                                  MetaSecHeaders350 *out);
size_t metasec_build_http_reqsign_text_fixed_350101(const char *s1,
                                                    const char *s2,
                                                    char *out,
                                                    size_t out_cap);

#ifdef __cplusplus
}
#endif

#endif /* METASEC_350101_RECOVERED_C_H */

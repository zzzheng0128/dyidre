#include <stdint.h>

typedef struct MetaSec_x0_350 {
    void *   ops_or_vtable; /* +0x000 */ // ascii=".c..p....d..p....0..p...d0..p...x...p.......p...p...p.......p..."
    void *   ptr_008; /* +0x008 */ // R size=8 count=2 | libmetasec_ml.so+0x14a004 (1); libmetasec_ml.so+0x14a0c0 (1) | ascii="P...p....h..p....h..p....h..p....H4Gs....p4Gs.........U........."
    void *   msdata_node; /* +0x010 */ // ascii=".................q...............msf3_...........q.............."
    void *   ptr_018; /* +0x018 */ // ascii="x...p.....5.s....\t+Gt....Q4Gs.....+Gt...@.5.s...p.+Gt...`.5.s.."
    void *   ptr_020; /* +0x020 */ // ascii="....k.................[..........................A....Y........."
    void *   ptr_028; /* +0x028 */ // ascii="x...p..........................................................."
    void *   ptr_030; /* +0x030 */ // ascii="X...p...P.(.t....2/Gs.....(Gt...p.(Gt..................C........"
    void *   ptr_038; /* +0x038 */ // ascii="....... .S....>.................p.+Gt.....+Gt....A.............."
    uint8_t pad_040[0x1a0];
    uint64_t field_1e0; /* +0x1e0 */ // R size=8 count=1 | libmetasec_ml.so+0x14a0ec (1)
    uint8_t pad_1e8[0x58];
    uint64_t field_240; /* +0x240 */ // RW size=8 count=2 | libmetasec_ml.so+0x47930 (1); libmetasec_ml.so+0x47c78 (1)
    uint64_t field_248; /* +0x248 */ // W size=8 count=2 | libmetasec_ml.so+0x4ac04 (1); libmetasec_ml.so+0x47c84 (1)
    uint8_t pad_250[0x8];
    uint64_t field_258; /* +0x258 */ // R size=8 count=1 | libmetasec_ml.so+0x74028 (1)
    uint8_t  flag_260; /* +0x260 */ // RW size=1 count=3 | libmetasec_ml.so+0x7480c (1); libmetasec_ml.so+0x74020 (1)
    uint8_t pad_261[0x15f];
    uint8_t env_tlv_scratch_3c0[0xa0]; /* +0x3c0..+0x45f: zeroed, then TLV/plain env fields; later reused for X-Soter/report text */
    uint8_t transform_out_460[0xa0]; /* +0x460..+0x4ff: bytewise output written by libmetasec_ml.so+0x138560 in current trace */
} MetaSec_x0_350; // observed >= 0x500

#pragma once
#include <stdint.h>

/*
 * Evidence-driven draft for Douyin 35.1.0 libmetasec_ml.so, inner entry 0x149ca8.
 *
 * This is intentionally not a final SDK struct. It captures what is already
 * backed by runtime entry dumps + unidbg read/write trace + static disassembly.
 *
 * Main evidence:
 *   - x0 at 0x149ca8 is the top-level native context.
 *   - [x0+0x8] is read at 0x14a004/0x14a0c0 and passed into sub_1261b0(..., 2).
 *   - sub_1261b0 returns an object whose address equals x0+0x1e0 in the trace.
 *   - x0+0x1e0 is read as a vtable/ops pointer at 0x14a0ec.
 *   - x0+0x240/+0x248 are accessed by 0x47908/0x47c1c/0x4abd4 as a ref-counted pair.
 *   - x0+0x258 is used as a lock-holder pointer by 0x74028.
 *   - x0+0x260 is a reentry/busy flag toggled by 0x74020/0x7419c and checked at 0x7480c.
 *   - x0+0x3c0..+0x4ff is a reused scratch/output buffer; see x0_tail_timeline.md.
 */

typedef struct MetaSecSharedRef350 {
    void    *obj;       /* +0x00: assigned/released via vtable destructor */
    int32_t *refcnt;    /* +0x08: malloc(4), initialized to 1, decremented on release */
} MetaSecSharedRef350;

typedef struct MetaSecNode350 MetaSecNode350;

typedef struct MetaSecRegistryEntry350 {
    /*
     * Evidence from 0x1261b0/getCookieBodyFun:
     *
     *   v8 = iterator.value()
     *   if (**(int32_t **)v8 == type)
     *       return *(void **)(v8 + 8)
     *
     * So the tree/list item payload is at least this 16-byte pair.
     */
    int32_t *type_ptr;  /* +0x00: dereferenced then compared with requested type */
    void    *payload;   /* +0x08: object returned for matched type */
} MetaSecRegistryEntry350;

/*
 * IDA already has this struct from the 334-aligned type work:
 *
 *   typedef struct COOKIE_RISK_ITEMS {
 *       TREE_MAP risk_items;   // +0x00
 *       FUN_MUTEX *fun_mutex;  // +0x28
 *   } COOKIE_RISK_ITEMS;
 *
 * MetaSecCtx350::registry should use COOKIE_RISK_ITEMS * inside IDA.
 * Outside IDA, keep the forward declaration below if this header is viewed
 * standalone.
 */
typedef struct COOKIE_RISK_ITEMS COOKIE_RISK_ITEMS;
typedef struct MEM_BLOCK MEM_BLOCK;
typedef struct JSON_LIST JSON_LIST;
typedef struct TREE_MAP TREE_MAP;

typedef struct REF_MEM_BLOCK {
    MEM_BLOCK *mem;
    int32_t *ref_count_ptr;
} REF_MEM_BLOCK;

typedef struct REF_JSON_LIST {
    JSON_LIST *json_list;
    int32_t *ref_count_ptr;
} REF_JSON_LIST;

typedef struct REF_TREE_MAP {
    TREE_MAP *tree;
    int32_t *ref_count_ptr;
} REF_TREE_MAP;

typedef struct MetaSecOp2Object350 {
    /*
     * Recovery note:
     * IDA already has a better canonical name/layout for this exact object:
     * COOKIE_RISK2, size 0x88. Keep this temporary name only as a readable
     * bridge for older notes; in IDA Local Types, MetaSecCtx350::op2 is promoted
     * to COOKIE_RISK2.
     */
    void *ops;                       /* +0x00: read at libmetasec_ml.so+0x14a0ec */
    uint8_t pad_008[0x58];
    MetaSecSharedRef350 current_ref; /* +0x60: top-level x0+0x240 / x0+0x248 */
    uint8_t pad_070[0x08];
    void *rwlock_holder;             /* +0x78: lock object; pthread_rwlock_rdlock(holder+8) */
    uint8_t busy;                    /* +0x80: reentry/busy flag */
    uint8_t pad_081[0x07];
} MetaSecOp2Object350;               /* observed at top-level x0+0x1e0 */

typedef struct MetaSecCtx350 {
    void *ops;                       /* +0x000: static ops/vtable table in libmetasec_ml.so r-- */
    COOKIE_RISK_ITEMS *registry;     /* +0x008: object registry; sub_1261b0(registry, type) */
    MetaSecNode350 *msdata_node;     /* +0x010: nested text contains ".msf3_" */
    MetaSecNode350 *node_018;        /* +0x018 */
    MetaSecNode350 *aid_node;        /* +0x020: nested content contains "1128"/"oid" in unidbg */
    MetaSecNode350 *node_028;        /* +0x028 */
    MetaSecNode350 *node_030;        /* +0x030 */
    MetaSecNode350 *node_038;        /* +0x038 */
    uint8_t pad_040[0x1a0];

    MetaSecOp2Object350 op2;         /* +0x1e0: COOKIE_RISK2 in IDA; registry key 2 */

    uint8_t pad_268[0x158];

    uint8_t env_tlv_scratch_3c0[0xa0];
                                      /* +0x3c0..+0x45f:
                                       * phase 1: TLV-ish env fields, aid/device/app/sdk info
                                       * phase 2: reused for "X-Soter\\r\\nAAAA..."
                                       */
    uint8_t transform_out_460[0xa0]; /* +0x460..+0x4ff: bytewise output copied by 0x138560 */
} MetaSecCtx350;

typedef struct MetaSecHttpInnerArgPack350 {
    /*
     * Inner 0x149ca8 args use sliding windows into one pointer array.
     * True device:
     *   x5 = base
     *   x3 = x5 + 0x10
     *   x2 = x5 + 0x20
     *   x1 = x5 + 0x30
     */
    REF_TREE_MAP tree_map;          /* +0x00: passed as X5 */
    REF_MEM_BLOCK x_ss_stub;        /* +0x10: passed as X3 */
    REF_MEM_BLOCK url;              /* +0x20: passed as X2 */
    REF_JSON_LIST json_list;        /* +0x30: passed as X1 */
} MetaSecHttpInnerArgPack350;       /* size 0x40 */

typedef MetaSecHttpInnerArgPack350 MetaSecArgWindow350; /* legacy alias */

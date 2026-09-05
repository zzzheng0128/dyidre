#pragma once
#include <stdint.h>

/*
 * Douyin 35.0/35.1 libmetasec_ml.so structure snapshot.
 *
 * Source of truth:
 *   - 350.101 true-device entry dump at buildSignedHttpHeadersInner_350 0x149ca8
 *   - unidbg read/write trace and full sequence comparison
 *   - unidbg managed CF argument/post-return trace for F5/F7/F8/F13 material flow
 *   - existing 334 IDA local types carried into the 350 IDB
 *   - static xrefs/decompilation around registry_find_type_350 and op2_fill_locked_350
 *
 * This file is intentionally an evidence snapshot, not a final vendor SDK ABI.
 * For IDA, prefer dyidre/skills/ida_apply_metasec_struct_evidence.py instead
 * of blindly importing this whole header, because many base types already exist
 * in the IDB and duplicate declarations may collide.
 */

/* ------------------------------------------------------------------------- */
/* Opaque / primitive helpers                                                 */
/* ------------------------------------------------------------------------- */

typedef struct TREE_MAP TREE_MAP;
typedef struct TREE_HEAD TREE_HEAD;
typedef struct TREE_ITEM TREE_ITEM;
typedef struct TREE_KV TREE_KV;
typedef struct TREE_MAP_VT TREE_MAP_VT;
typedef struct JSON_LIST JSON_LIST;
typedef struct ID_ITEM ID_ITEM;
typedef struct ID_ITEM_WRAP ID_ITEM_WRAP;
typedef struct ID_LIST ID_LIST;
typedef struct COOKIE_RISK_ITEMS COOKIE_RISK_ITEMS;
typedef struct COOKIE_RISK_ID COOKIE_RISK_ID;
typedef struct COOKIE_RISK2 COOKIE_RISK2;
typedef struct COOKIE_RISK_SUPER COOKIE_RISK_SUPER;
typedef struct COOKIE_RISK_HEAD COOKIE_RISK_HEAD;
typedef struct MetaSecNode350 MetaSecNode350;
typedef struct RISK_LIST_HEAD RISK_LIST_HEAD;
typedef struct RISK_LIST_VT RISK_LIST_VT;
typedef struct RISK_ITEM RISK_ITEM;
typedef struct DATA9_ITEM1 DATA9_ITEM1;
typedef struct DATA9_ITEM2 DATA9_ITEM2;
typedef struct DATA9_ITEM3 DATA9_ITEM3;
typedef struct DATA11_MS_DYN DATA11_MS_DYN;
typedef struct DATA11_BODY DATA11_BODY;
typedef struct JSON_ITEMS JSON_ITEMS;
typedef struct JSON_ITEM JSON_ITEM;
typedef struct CODE_WRAP CODE_WRAP;
typedef struct EN_PKG_SIG EN_PKG_SIG;
typedef union ManagedFrameSlots350 ManagedFrameSlots350;
typedef struct ManagedFrameBuffer350 ManagedFrameBuffer350;
typedef struct ManagedFrame350 ManagedFrame350;
typedef struct ManagedProgramBody350 ManagedProgramBody350;
typedef struct ManagedProgram350 ManagedProgram350;
typedef struct ManagedNativeBinding350 ManagedNativeBinding350;
typedef struct ManagedModule350 ManagedModule350;
typedef struct NativeVmpResultObject350 NativeVmpResultObject350;
typedef struct MetaSecMssdkMaterial350 MetaSecMssdkMaterial350;
typedef struct MetaSecMssdkAppInfo350 MetaSecMssdkAppInfo350;
typedef struct MetaSecMssdkKeyValue350 MetaSecMssdkKeyValue350;

typedef struct FUN_MUTEX {
    void *vtable;                    /* +0x00 */
    uint8_t pthread_mutex_storage[40];/* +0x08 pthread_mutex_t, IDA size 0x28 */
} FUN_MUTEX;                         /* size 0x30 */

typedef struct RW_LOCK {
    void *vtable;                    /* +0x00 */
    uint8_t pthread_rwlock_storage[56];/* +0x08 pthread_rwlock_t, IDA size 0x38 */
} RW_LOCK;                           /* size 0x40 */

/* ------------------------------------------------------------------------- */
/* Ref-counted pairs and memory blocks                                        */
/* ------------------------------------------------------------------------- */

typedef struct MEM_BLOCK_BODY {
    int32_t mem_len;                 /* +0x00 */
    int32_t src_len;                 /* +0x04 */
    char *mem;                       /* +0x08 */
} MEM_BLOCK_BODY;                    /* size 0x10 */

typedef struct MEM_BLOCK {
    void *vtable;                    /* +0x00 */
    MEM_BLOCK_BODY body;             /* +0x08 */
} MEM_BLOCK;                         /* size 0x18 */

typedef struct REF_OBJ {
    void *obj;                       /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_OBJ;                           /* size 0x10 */

typedef struct REF_MEM_BLOCK {
    MEM_BLOCK *mem;                  /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_MEM_BLOCK;                     /* size 0x10 */

typedef struct REF_JSON_LIST {
    JSON_LIST *json_list;            /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_JSON_LIST;                     /* size 0x10 */

typedef struct REF_TREE_MAP {
    TREE_MAP *tree_map;              /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_TREE_MAP;                      /* size 0x10 */

typedef struct REF_COOKIE_RISK_ITEMS {
    COOKIE_RISK_ITEMS *risk_items;   /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_COOKIE_RISK_ITEMS;             /* size 0x10 */

typedef struct REF_COOKIE_RISK_ID {
    COOKIE_RISK_ID *risk_id;         /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_COOKIE_RISK_ID;                /* size 0x10 */

typedef struct REF_ID_ITEM_WRAP {
    ID_ITEM_WRAP *wrap;              /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_ID_ITEM_WRAP;                  /* size 0x10 */

typedef struct REF_ID_LIST {
    ID_LIST *id_list;                /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_ID_LIST;                       /* size 0x10 */

typedef struct REF_RISK_LIST_HEAD {
    RISK_LIST_HEAD *head;            /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_RISK_LIST_HEAD;                /* size 0x10 */

typedef struct REF_DATA11_MS_DYN {
    DATA11_MS_DYN *ms_dyn;           /* +0x00 */
    int32_t *ref_count_ptr;          /* +0x08 */
} REF_DATA11_MS_DYN;                 /* size 0x10 */

typedef struct REF_DATA11_BODY {
    DATA11_BODY *d11_body;           /* +0x00 */
    int32_t *ref_count;              /* +0x08 */
} REF_DATA11_BODY;                   /* size 0x10 */

/* Historical temporary name used during 350 recovery. It is a generic shared
 * pair, but ctx+0x240 is now better explained as COOKIE_RISK2::msp_token.
 */
typedef REF_OBJ MetaSecSharedRef350;

typedef struct MEM_WRAP {
    REF_MEM_BLOCK str_ref;           /* +0x00 */
    RW_LOCK *rw_lock;                /* +0x10 */
    int32_t count;                   /* +0x18 */
} MEM_WRAP;                          /* size 0x1c */

typedef struct TREE_MAP_WRAP {
    void *vtable;                    /* +0x00 */
    uint8_t gap8[0x10];              /* +0x08 */
    FUN_MUTEX *fun_mutex;            /* +0x18 */
} TREE_MAP_WRAP;                     /* size 0x20 */

typedef struct VMEM_DATA {
    int64_t size;                    /* +0x00 */
    char *mem_ptr;                   /* +0x08 */
    char read_success;               /* +0x10 */
    uint8_t gap11[0x07];             /* +0x11 */
    int64_t cur_pos;                 /* +0x18 */
} VMEM_DATA;                         /* size 0x20 */

typedef struct VMEM_DATA_WRAP {
    int64_t vt;                      /* +0x00 */
    VMEM_DATA *vmem;                 /* +0x08 */
} VMEM_DATA_WRAP;                    /* size 0x10 */

/* ------------------------------------------------------------------------- */
/* Tree map / JSON-ish containers                                             */
/* ------------------------------------------------------------------------- */

struct TREE_KV {
    /*
     * Evidence from 0x11FBDC/newTreeKV_350 and 0x11FC30/treeMapPut_350:
     * a 0x10 heap object is allocated, then key/value are written at +0/+8.
     * TREE_ITEM::kv points here. 334's imported TREE_ITEM::item_value was too
     * generic for 350 HTTP header maps and hides the real key/value pair.
     */
    void *key;                       /* +0x00 */
    void *value;                     /* +0x08 */
};                                   /* size 0x10 */

struct TREE_ITEM {
    int32_t flag;                    /* +0x00 */
    int32_t flag_xxx;                /* +0x04 */
    TREE_ITEM *brother;              /* +0x08 */
    TREE_ITEM *pre;                  /* +0x10 */
    TREE_ITEM *after;                /* +0x18 */
    TREE_KV *kv;                     /* +0x20: key/value payload */
};                                   /* size 0x28 */

struct TREE_HEAD {
    TREE_ITEM *list_head;            /* +0x00 */
    int64_t count;                   /* +0x08 */
    int64_t fun_cmpInt;              /* +0x10 */
    int64_t fun_returnR1;            /* +0x18 */
    int64_t data;                    /* +0x20 */
};                                   /* size 0x28 */

struct TREE_MAP {
    TREE_MAP_VT *vt_12D6F0;          /* +0x00 */
    int64_t free_key;                /* +0x08: called when replacing an existing key */
    int64_t free_value;              /* +0x10: called when replacing an existing value */
    int64_t cmp;                     /* +0x18: key comparator */
    TREE_HEAD *tree_head_ptr;        /* +0x20 */
};                                   /* size 0x28 */

typedef struct TREE_VALUE_FLAG {
    void *vtable;                    /* +0x00 */
    int64_t objValue;                /* +0x08 */
    int32_t flag;                    /* +0x10 */
    int32_t field_14;                /* +0x14 */
} TREE_VALUE_FLAG;                   /* size 0x18 */

/* registry_find_type_350 iterates COOKIE_RISK_ITEMS::risk_items and expects
 * each tree payload to look at least like this.
 */
typedef struct MetaSecRegistryEntry350 {
    int32_t *type_ptr;               /* +0x00: **entry compared with W1 type */
    void *payload;                   /* +0x08: returned object */
} MetaSecRegistryEntry350;           /* observed minimum size 0x10 */

/* ------------------------------------------------------------------------- */
/* Risk linked-list containers                                                */
/* ------------------------------------------------------------------------- */

struct RISK_ITEM {
    RISK_ITEM *pre;                  /* +0x00 */
    RISK_ITEM *last;                 /* +0x08 */
    void *value;                     /* +0x10 */
};                                   /* size 0x18 */

typedef struct RISK_FUNS {
    int64_t free1;                   /* +0x00 */
    int64_t free2;                   /* +0x08 */
    int64_t cmp;                     /* +0x10 */
} RISK_FUNS;                         /* size 0x18 */

typedef struct RISK_LIST2 {
    int64_t cmp_fun;                 /* +0x00 */
    RISK_ITEM *list_head;            /* +0x08 */
} RISK_LIST2;                        /* size 0x10 */

struct RISK_LIST_VT {
    int64_t field_0;                 /* +0x00 */
    int64_t getItemValue;            /* +0x08 */
    int64_t field_10;                /* +0x10 */
    int64_t popPreItem;              /* +0x18 */
    int64_t field_20;                /* +0x20 */
    int64_t field_28;                /* +0x28 */
    int64_t field_30;                /* +0x30 */
    int64_t field_38;                /* +0x38 */
    int64_t field_40;                /* +0x40 */
    int64_t field_48;                /* +0x48 */
    int64_t field_50;                /* +0x50 */
    int64_t isEqRiskItem;            /* +0x58 */
};                                   /* size 0x60 */

struct RISK_LIST_HEAD {
    RISK_LIST_VT *vtable;            /* +0x00 */
    RISK_FUNS funs;                  /* +0x08 */
    RISK_LIST2 list2;                /* +0x20 */
};                                   /* size 0x30 */

/* ------------------------------------------------------------------------- */
/* Cookie/risk objects                                                        */
/* ------------------------------------------------------------------------- */

struct COOKIE_RISK_ITEMS {
    TREE_MAP risk_items;             /* +0x00 */
    FUN_MUTEX *fun_mutex;            /* +0x28 */
};                                   /* size 0x30 */

struct COOKIE_RISK_SUPER {
    void *vtable;                    /* +0x00 */
    REF_COOKIE_RISK_ITEMS risk_objs_ref;/* +0x08 */
    REF_JSON_LIST json_list;         /* +0x18 */
    FUN_MUTEX *fun_mutex;            /* +0x28 */
};                                   /* size 0x30 */

struct COOKIE_RISK_HEAD {
    void *vtable;                    /* +0x00 */
    REF_COOKIE_RISK_ITEMS risk_objs; /* +0x08 */
    REF_JSON_LIST th_info;           /* +0x18 */
    REF_JSON_LIST json_list;         /* +0x28 */
    REF_COOKIE_RISK_ID risk_id;      /* +0x38 */
    RW_LOCK rw_lock;                 /* +0x48 */
};                                   /* size 0x88 */

struct COOKIE_RISK_ID {
    int64_t vtable;                  /* +0x00 */
    ID_ITEM *id_item;                /* +0x08 */
    RW_LOCK *rw_lock;                /* +0x10 */
};                                   /* size 0x18 */

struct DATA11_MS_DYN {
    int64_t vt_12D750;               /* +0x00 */
    int32_t risk_type;               /* +0x08 */
    int32_t field_C;                 /* +0x0c */
    MEM_BLOCK ms_dyn_key;            /* +0x10 */
    REF_ID_ITEM_WRAP key2;           /* +0x28 */
    int32_t result_code_bak;         /* +0x38 */
    char only_crash;                 /* +0x3c */
    char field_3D;                   /* +0x3d */
    char field_3E;                   /* +0x3e */
    char field_3F;                   /* +0x3f */
    int16_t result_code;             /* +0x40 */
    char commited;                   /* +0x42 */
    char field_43;                   /* +0x43 */
    int32_t field_44;                /* +0x44 */
    MEM_BLOCK str;                   /* +0x48 */
};                                   /* size 0x60 */

struct DATA11_BODY {
    REF_JSON_LIST json_list;         /* +0x00 */
    REF_COOKIE_RISK_ITEMS risk_objs; /* +0x10 */
    int64_t commit_haku_count;       /* +0x20 */
    int32_t result_code;             /* +0x28 */
    int32_t field_2C;                /* +0x2c */
    RISK_LIST_HEAD risk_head;        /* +0x30 */
    FUN_MUTEX fun_mutex;             /* +0x60 */
    RW_LOCK rw_lock;                 /* +0x90 */
    char haku_done;                  /* +0xd0 */
    char need_try;                   /* +0xd1 */
    char field_D2;                   /* +0xd2 */
    char field_D3;                   /* +0xd3 */
    char field_D4;                   /* +0xd4 */
    char field_D5;                   /* +0xd5 */
    char field_D6;                   /* +0xd6 */
    char field_D7;                   /* +0xd7 */
};                                   /* size 0xd8 */

struct COOKIE_RISK2 {
    COOKIE_RISK_SUPER head;          /* +0x00 */
    REF_JSON_LIST json_list;         /* +0x30 */
    uint8_t gap40[0x20];             /* +0x40 */
    REF_MEM_BLOCK msp_token;         /* +0x60, top ctx+0x240/+0x248 */
    FUN_MUTEX *fun_mutext;           /* +0x70, original IDA spelling */
    RW_LOCK *rw_lock;                /* +0x78 */
    int64_t has_token;               /* +0x80, low byte also used as busy flag */
};                                   /* size 0x88 */

typedef struct COOKIE_HTTP {
    int64_t field_0;                 /* +0x00 */
    COOKIE_RISK_ITEMS *risk_item;    /* +0x08 */
    int64_t field_10;                /* +0x10 */
    int64_t field_18;                /* +0x18 */
    int64_t field_20;                /* +0x20 */
    int64_t field_28;                /* +0x28 */
} COOKIE_HTTP;                       /* size 0x30 */

typedef struct COOKIE_BODY {
    void *vtable;                    /* +0x00 */
    REF_JSON_LIST json_list;         /* +0x08 */
    REF_COOKIE_RISK_ITEMS risk_items_ref;/* +0x18 */
    uint8_t flags_028[0x08];         /* +0x28..+0x2f */
    uint8_t gap030[0x10];            /* +0x30 */
    FUN_MUTEX *fun_mutex_ptr1;       /* +0x40 */
    int64_t fun_mutex_ptr;           /* +0x48 */
    char *str_bdmsver;               /* +0x50 */
    REF_MEM_BLOCK d_json;            /* +0x58 */
} COOKIE_BODY;                       /* size 0x68 */

typedef struct COOKIE_CHECK {
    void *vtable;                    /* +0x00 */
    int32_t risk_type;               /* +0x08 */
    int32_t field_C;                 /* +0x0c */
    MEM_BLOCK enable_module;         /* +0x10 */
    REF_ID_ITEM_WRAP list;           /* +0x28 */
    int64_t cur_time_ms;             /* +0x38 */
    uint8_t flags_040[0x10];         /* +0x40..+0x4f */
} COOKIE_CHECK;                      /* size 0x50 */

typedef struct COOKIE_UPDATE_SETTINGS {
    void *vtable;                    /* +0x00 */
    TREE_MAP tree_entry1;            /* +0x08 */
    TREE_MAP tree_entry2;            /* +0x30 */
    TREE_MAP tree_entry3;            /* +0x58 */
    RW_LOCK rw_lock;                 /* +0x80 */
    MEM_BLOCK neptune;               /* +0xc0 */
} COOKIE_UPDATE_SETTINGS;            /* size 0xd8 */

/* Most COOKIE_RISK_DATA* objects are not on the current 0x149ca8 hot path.
 * Keep them as size shells unless field evidence is available. DATA4 is useful
 * because the old 334 database names anti-risk fields there.
 */
typedef struct COOKIE_RISK_DATA1 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
} COOKIE_RISK_DATA1;                 /* size 0x88 */

typedef struct COOKIE_RISK_DATA2 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    int64_t st_ctim_tv_sec;          /* +0x88 */
    int64_t inst2;                   /* +0x90 */
    REF_MEM_BLOCK version_code;      /* +0x98 */
    REF_MEM_BLOCK ss_version_name;   /* +0xa8 */
    REF_MEM_BLOCK field_B8;          /* +0xb8 */
    REF_MEM_BLOCK str_fltk;          /* +0xc8 */
} COOKIE_RISK_DATA2;                 /* size 0xd8 */

typedef struct COOKIE_RISK_DATA3 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    REF_MEM_BLOCK android_id1;       /* +0x88 */
    REF_MEM_BLOCK android_id2;       /* +0x98 */
} COOKIE_RISK_DATA3;                 /* size 0xa8 */

typedef struct COOKIE_RISK_DATA5 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    REF_RISK_LIST_HEAD czl_file_names;/* +0x88 */
    REF_RISK_LIST_HEAD czl_prop_names;/* +0x98 */
    FUN_MUTEX *fun_mutex;            /* +0xa8 */
    REF_MEM_BLOCK run_nb_s;          /* +0xb0 */
    int64_t run_nb_flag;             /* +0xc0 */
} COOKIE_RISK_DATA5;                 /* size 0xc8 */

typedef struct COOKIE_RISK_DATA6 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    uint8_t gap88[0x10];             /* +0x88 */
    int32_t elf_machine;             /* +0x98 */
    int32_t bnd_flag;                /* +0x9c */
} COOKIE_RISK_DATA6;                 /* size 0xa0 */

typedef struct COOKIE_RISK_DATA7 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    int32_t eth0_flag;               /* +0x88 */
    int32_t field_8C;                /* +0x8c */
} COOKIE_RISK_DATA7;                 /* size 0x90 */

typedef struct COOKIE_RISK_DATA8 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    int32_t int_FF;                  /* +0x88 */
    char flag;                       /* +0x8c */
    char field_8D;                   /* +0x8d */
    char field_8E;                   /* +0x8e */
    char field_8F;                   /* +0x8f */
    FUN_MUTEX *fun_mutex;            /* +0x90 */
} COOKIE_RISK_DATA8;                 /* size 0x98 */

typedef struct COOKIE_RISK_DATA9 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    int32_t app_flag;                /* +0x88 */
    int32_t field_8C;                /* +0x8c */
    DATA9_ITEM1 *item1;              /* +0x90 */
    DATA9_ITEM2 *item2;              /* +0x98 */
    DATA9_ITEM3 *item3;              /* +0xa0 */
} COOKIE_RISK_DATA9;                 /* size 0xa8 */

typedef struct COOKIE_RISK_DATA10 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    REF_ID_ITEM_WRAP field_88;       /* +0x88 */
} COOKIE_RISK_DATA10;                /* size 0x98 */

typedef struct COOKIE_RISK_DATA11 {
    COOKIE_RISK_HEAD head;           /* +0x00 */
    int64_t mss_cdn_down;            /* +0x88 */
    int64_t syn_process;             /* +0x90 */
    REF_MEM_BLOCK cdn_path;          /* +0x98 */
    REF_DATA11_MS_DYN ms_dyn;        /* +0xa8 */
    REF_DATA11_BODY ref_data11_body; /* +0xb8 */
} COOKIE_RISK_DATA11;                /* size 0xc8 */

typedef struct COOKIE_RISK_DATA4 {
    COOKIE_RISK_HEAD head;           /* +0x000 */
    int32_t has_su;                  /* +0x088 */
    int32_t lc_sg;                   /* +0x08c */
    FUN_MUTEX *fun_mutex1;           /* +0x090 */
    FUN_MUTEX *fun_mutex2;           /* +0x098 */
    FUN_MUTEX *fun_mutex3;           /* +0x0a0 */
    FUN_MUTEX *fun_mutex4;           /* +0x0a8 */
    FUN_MUTEX *fun_mutex5;           /* +0x0b0 */
    FUN_MUTEX *fun_mutex6;           /* +0x0b8 */
    FUN_MUTEX *fun_mutex7;           /* +0x0c0 */
    FUN_MUTEX *fun_mutex8;           /* +0x0c8 */
    REF_MEM_BLOCK sig_md5;           /* +0x0d0 */
    REF_MEM_BLOCK v2sign;            /* +0x0e0 */
    REF_MEM_BLOCK sg_all;            /* +0x0f0 */
    REF_MEM_BLOCK sig_sha1;          /* +0x100 */
    REF_MEM_BLOCK sha1;              /* +0x110 */
    REF_MEM_BLOCK su_files;          /* +0x120 */
    REF_MEM_BLOCK apk_path;          /* +0x130 */
    REF_MEM_BLOCK ak_sh;             /* +0x140 */
    REF_MEM_BLOCK ak_fl;             /* +0x150 */
    REF_MEM_BLOCK lp_xm;             /* +0x160 */
    REF_MEM_BLOCK field_170;         /* +0x170 */
    REF_MEM_BLOCK field_180;         /* +0x180 */
    REF_MEM_BLOCK field_190;         /* +0x190 */
    REF_MEM_BLOCK field_1A0;         /* +0x1a0 */
    REF_MEM_BLOCK ak_ph;             /* +0x1b0 */
    REF_MEM_BLOCK share_libs;        /* +0x1c0 */
    REF_MEM_BLOCK cso;               /* +0x1d0 */
    int32_t fake_fd_flag;            /* +0x1e0 */
    int32_t acc_enable;              /* +0x1e4 */
    int32_t field_1E8;               /* +0x1e8 */
    int32_t field_1EC;               /* +0x1ec */
    REF_MEM_BLOCK field_1F0;         /* +0x1f0 */
    REF_MEM_BLOCK tracer_dbg;        /* +0x200 */
    REF_MEM_BLOCK bdc;               /* +0x210 */
    REF_MEM_BLOCK fake_pkg_name;     /* +0x220 */
    REF_MEM_BLOCK xposed;            /* +0x230 */
    int32_t has_xp;                  /* +0x240 */
    int32_t has_substrate;           /* +0x244 */
    int32_t has_frida;               /* +0x248 */
    int32_t has_vapp;                /* +0x24c */
    int32_t has_vmos;                /* +0x250 */
    int32_t source_is_dex;           /* +0x254 */
    REF_MEM_BLOCK frida_msg;         /* +0x258 */
    REF_MEM_BLOCK xp_msg;            /* +0x268 */
    REF_MEM_BLOCK mg_msg;            /* +0x278 */
    char mask_auto_apk[2];           /* +0x288 */
    char mask_fake_uid[2];           /* +0x28a */
    char mask_debug[2];              /* +0x28c */
    char mask_smartisanos[2];        /* +0x28e */
    char field_290[2];               /* +0x290 */
    char field_292[2];               /* +0x292 */
    char mask_has_su[2];             /* +0x294 */
    char mask_xp_sub_frida_env[2];   /* +0x296 */
    int32_t mask_debug_app;          /* +0x298 */
    int32_t field_29C;               /* +0x29c */
} COOKIE_RISK_DATA4;                 /* size 0x2a0 */

/* ------------------------------------------------------------------------- */
/* JSON / ID list                                                             */
/* ------------------------------------------------------------------------- */

struct JSON_LIST {
    void *vtable;                    /* +0x000 */
    REF_MEM_BLOCK appid;             /* +0x008 */
    REF_TREE_MAP tree_map1;          /* +0x018 */
    REF_MEM_BLOCK channel;           /* +0x028 */
    REF_MEM_BLOCK did;               /* +0x038 */
    REF_MEM_BLOCK iid;               /* +0x048 */
    REF_MEM_BLOCK session_id;        /* +0x058 */
    int32_t http_client_type;        /* +0x068 */
    int32_t http_use_sg;             /* +0x06c */
    REF_MEM_BLOCK bddid;             /* +0x070 */
    REF_MEM_BLOCK sdkid;             /* +0x080 */
    REF_MEM_BLOCK subaid;            /* +0x090 */
    REF_MEM_BLOCK de_mssdk;          /* +0x0a0 */
    REF_MEM_BLOCK ver_help;          /* +0x0b0 */
    REF_TREE_MAP tree_map2;          /* +0x0c0 */
    int32_t cur_type;                /* +0x0d0 */
    int32_t field_D4;                /* +0x0d4 */
    REF_MEM_BLOCK did_bak;           /* +0x0d8 */
    uint32_t xm_do;                  /* +0x0e8 */
    int32_t field_EC;                /* +0x0ec */
    REF_ID_LIST id_list_ref;         /* +0x0f0 */
    RW_LOCK *rw_lock;                /* +0x100 */
};                                   /* size 0x108 */

typedef struct S_JSON_LIST {
    REF_MEM_BLOCK app_id;            /* +0x00 */
    REF_MEM_BLOCK str_3019;          /* +0x10 */
    REF_MEM_BLOCK did;               /* +0x20 */
    REF_MEM_BLOCK channel;           /* +0x30 */
    int32_t http_client_type;        /* +0x40 */
    int32_t http_use_sg;             /* +0x44 */
    int32_t has_sdkid;               /* +0x48 */
    int32_t field_4c;                /* +0x4c */
} S_JSON_LIST;                       /* size 0x50 */

struct ID_ITEM {
    ID_ITEM *next;                   /* +0x00 */
    ID_ITEM *pre;                    /* +0x08 */
    ID_ITEM *brother;                /* +0x10 */
    uint8_t value_type;              /* +0x18 */
    uint8_t flags_019[0x07];         /* +0x19..+0x1f */
    char *str_value;                 /* +0x20 */
    int32_t int_value;               /* +0x28 */
    int32_t field_2C;                /* +0x2c */
    double double_value;             /* +0x30 */
    char *key;                       /* +0x38 */
};                                   /* size 0x40 */

struct ID_ITEM_WRAP {
    void *vtable;                    /* +0x00 */
    ID_ITEM *list;                   /* +0x08 */
};                                   /* size 0x10 */

struct ID_LIST {
    void *vtable;                    /* +0x00 */
    REF_MEM_BLOCK list_key;          /* +0x08 */
    ID_ITEM *list;                   /* +0x18 */
    RW_LOCK *rw_lock;                /* +0x20 */
    int64_t flag;                    /* +0x28 */
};                                   /* size 0x30 */

typedef struct DATA9_ITEM1 {
    int64_t vt;                      /* +0x00 */
    REF_MEM_BLOCK str1;              /* +0x08 */
    REF_MEM_BLOCK str2;              /* +0x18 */
    REF_MEM_BLOCK str3;              /* +0x28 */
    REF_MEM_BLOCK bdms_cert;         /* +0x38 */
    REF_MEM_BLOCK public_key;        /* +0x48 */
    FUN_MUTEX *fun_mutex1;           /* +0x58 */
    FUN_MUTEX *fun_mutex2;           /* +0x60 */
    FUN_MUTEX *fun_mutex3;           /* +0x68 */
    FUN_MUTEX *fun_mutex4;           /* +0x70 */
} DATA9_ITEM1;                       /* size 0x78 */

typedef struct DATA9_ITEM2 {
    int64_t vt;                      /* +0x00 */
    char flag;                       /* +0x08 */
    uint8_t gap09[0x07];             /* +0x09 */
    REF_TREE_MAP ref_tree_map;       /* +0x10 */
    FUN_MUTEX *fun_mutex1;           /* +0x20 */
    FUN_MUTEX *fun_mutex2;           /* +0x28 */
} DATA9_ITEM2;                       /* size 0x30 */

typedef struct DATA9_ITEM3 {
    int64_t vt;                      /* +0x00 */
    uint8_t inited;                  /* +0x08 */
    uint8_t gap09[0x07];             /* +0x09 */
    int64_t sign_info;               /* +0x10 */
    FUN_MUTEX *fun_mutex;            /* +0x18 */
} DATA9_ITEM3;                       /* size 0x20 */

typedef struct JSON_ITEM {
    void *buf;                       /* +0x00 */
    void *buf_end;                   /* +0x08 */
    void *mem_end;                   /* +0x10 */
} JSON_ITEM;                         /* size 0x18 */

typedef struct JSON_ITEMS {
    int64_t field_0;                 /* +0x00 */
    int64_t field_8;                 /* +0x08 */
    int64_t field_10;                /* +0x10 */
} JSON_ITEMS;                        /* size 0x18 */

typedef struct CODE_WRAP {
    int64_t vt_276768;               /* +0x00 */
    int32_t *code;                   /* +0x08 */
} CODE_WRAP;                         /* size 0x10 */

typedef struct JSON_DATA {
    char *json;                      /* +0x00 */
    int64_t json_size;               /* +0x08 */
    JSON_ITEM item;                  /* +0x10 */
    JSON_ITEMS items;                /* +0x28 */
    CODE_WRAP code;                  /* +0x40 */
} JSON_DATA;                         /* size 0x50 */

typedef struct JSON_OBJ {
    int64_t vt_276990;               /* +0x00 */
    void *begin;                     /* +0x08 */
    void *end;                       /* +0x10 */
    void *cur;                       /* +0x18 */
    int32_t has_data;                /* +0x20 */
    int32_t field_24;                /* +0x24 */
} JSON_OBJ;                          /* size 0x28 */

typedef struct JSON_TMP {
    int32_t field_0;                 /* +0x00 */
    int32_t field_4;                 /* +0x04 */
    char *json_str;                  /* +0x08 */
    int64_t field_10;                /* +0x10 */
    int64_t field_18;                /* +0x18 */
    int64_t field_20;                /* +0x20 */
    int32_t field_28;                /* +0x28 */
    int32_t field_2C;                /* +0x2c */
    int64_t field_30;                /* +0x30 */
    int64_t field_38;                /* +0x38 */
    char *sub_json;                  /* +0x40 */
    int64_t field_48;                /* +0x48 */
} JSON_TMP;                          /* size 0x50 */

typedef struct EN_JSON_INFO {
    int64_t field_0;                 /* +0x00 */
    int32_t field_8;                 /* +0x08 */
    int32_t version;                 /* +0x0c */
    char *mssdk_str;                 /* +0x10 */
    char *lc_id;                     /* +0x18 */
    int64_t flag;                    /* +0x20 */
    char *appid;                     /* +0x28 */
    int64_t tag;                     /* +0x30 */
    int64_t field_38;                /* +0x38 */
    int64_t field_40;                /* +0x40 */
    int64_t sig_size;                /* +0x48 */
    EN_PKG_SIG **sig;                /* +0x50 */
    int64_t ase_en_keys_len;         /* +0x58, original IDA spelling */
    char *aes_en_keys;               /* +0x60 */
    int64_t field_68;                /* +0x68 */
} EN_JSON_INFO;                      /* size 0x70 */

/* ------------------------------------------------------------------------- */
/* 350.101 native VMP 0x1F7860 material/result objects                       */
/* ------------------------------------------------------------------------- */

struct NativeVmpResultObject350 {
    /*
     * Returned by nativeVmpBuildMssdkMaterial_350 / vmCode 0x1F7860.
     *
     * Runtime evidence from gumtrace_1f7860_slice.log:
     *   L328475: [result+0x00] = 0x7102e732c8
     *   L328364: [result+0x08] = 0x73b72d27c0
     *
     * Caller 0x12564C then reads [result+0x08] and treats it as the material
     * object containing the repeated key/value table at +0x58/+0x60.
     */
    void *vtable_26f2c8;             /* +0x00 */
    MetaSecMssdkMaterial350 *material;/* +0x08 */
};                                   /* observed size 0x10 */

struct MetaSecMssdkKeyValue350 {
    /*
     * Key/value entry stored inside MetaSecMssdkMaterial350::kv_items.
     *
     * Runtime evidence:
     *   L325672/L325770 common_key item:
     *     [item+0x18] = "common_key"
     *     [item+0x20] = "y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY="
     *   L326324/L326422 sign_key item:
     *     [item+0x18] = "sign_key"
     *     [item+0x20] = "jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU="
     */
    void *template_or_schema;         /* +0x00, copied from static template */
    uint64_t field_08;               /* +0x08 */
    uint64_t field_10;               /* +0x10 */
    char *key;                       /* +0x18 */
    char *value;                     /* +0x20 */
};                                   /* observed size 0x28 */

struct MetaSecMssdkAppInfo350 {
    /*
     * Nested app/package info serialized as field7:
     *   field1 = "com.ss.android.ugc.aweme"
     *   field2 = "AEA615AB910015038F73C47E45D21466"
     *
     * Runtime evidence:
     *   L325003: [app+0x18] = package string
     *   L324838/L325144: [app+0x20] count = 1
     *   L324897: [app+0x28] = pointer array
     *   L325117: array[0] = 32-byte ASCII material
     */
    void *template_or_schema;         /* +0x00, copied from static template */
    uint64_t field_08;               /* +0x08 */
    uint64_t field_10;               /* +0x10 */
    char *package_name;              /* +0x18 */
    uint64_t material_count;          /* +0x20 */
    char **material_values;           /* +0x28 */
    uint64_t field_30;               /* +0x30 */
};                                   /* observed size 0x38 */

struct MetaSecMssdkMaterial350 {
    /*
     * Object produced by the 0x1F7860 native VMP program.
     *
     * It serializes to the 0xdb-byte protobuf-like blob seen before free:
     *
     *   1: zigzag/shifted uint32 1077940808   // object stores 0x20200924
     *   2: "mssdk"
     *   3: "1588093228"
     *   4: 1
     *   5: "1128"
     *   6: zigzag/shifted uint32 3208950026   // object stores 0x5fa25885
     *   7: MetaSecMssdkAppInfo350
     *   8: repeated MetaSecMssdkKeyValue350 { common_key, sign_key }
     *
     * Runtime evidence:
     *   L322672 copies 0x70-byte static template into this object.
     *   L323635/L323726 write kv_count through +0x58.
     *   L323886 writes kv_items pointer through +0x60.
     */
    void *template_or_schema;         /* +0x00, copied from static template */
    uint64_t field_08;               /* +0x08 */
    uint64_t field_10;               /* +0x10 */
    uint32_t seed_id;                /* +0x18: serialized value = seed_id << 1 */
    uint32_t field_1c;               /* +0x1c */
    char *module_name;               /* +0x20: "mssdk" */
    char *app_id;                    /* +0x28: "1588093228" */
    uint32_t enabled;                /* +0x30: 1 */
    uint32_t field_34;               /* +0x34 */
    char *sdk_version;               /* +0x38: "1128" */
    uint32_t salt_id;                /* +0x40: serialized value = salt_id << 1 */
    uint32_t field_44;               /* +0x44 */
    uint64_t app_info_count;          /* +0x48: observed 1 */
    MetaSecMssdkAppInfo350 **app_infos;/* +0x50 */
    uint64_t kv_count;               /* +0x58: observed 2 */
    MetaSecMssdkKeyValue350 **kv_items;/* +0x60 */
    uint64_t field_68;               /* +0x68, template tail */
};                                   /* observed size 0x70 */

/* ------------------------------------------------------------------------- */
/* 350.101 top-level HTTP inner context                                       */
/* ------------------------------------------------------------------------- */

struct MetaSecNode350 {
    /*
     * Still opaque. Runtime nested dumps show:
     *   - ctx+0x10 chain contains ".msf3_"
     *   - ctx+0x20 chain contains "1128"/"oid"
     * Promote fields only when a stable allocation/write site is identified.
     */
    void *opaque0;
};

typedef struct MetaSecCtx350 {
    void *ops;                       /* +0x000: static ops/vtable in lib r-- */
    COOKIE_RISK_ITEMS *registry;     /* +0x008: passed to registry_find_type_350 */
    MetaSecNode350 *msdata_node;     /* +0x010: nested text contains ".msf3_" */
    MetaSecNode350 *node_018;        /* +0x018 */
    MetaSecNode350 *aid_node;        /* +0x020: nested text contains aid/oid info */
    MetaSecNode350 *node_028;        /* +0x028 */
    MetaSecNode350 *node_030;        /* +0x030 */
    MetaSecNode350 *node_038;        /* +0x038 */
    uint8_t pad_040[0x1a0];          /* +0x040 */
    COOKIE_RISK2 op2;                /* +0x1e0: registry key 2 payload */
    uint8_t pad_268[0x158];          /* +0x268 */
    uint8_t env_tlv_scratch_3c0[0xa0];/* +0x3c0: TLV/env scratch, reused */
    uint8_t transform_out_460[0xa0]; /* +0x460: transform output scratch */
} MetaSecCtx350;                     /* observed minimum size 0x500 */

typedef struct MetaSecHttpInnerArgPack350 {
    /*
     * Inner 0x149ca8 args use sliding windows into one pointer array.
     * True device:
     *   X5 = base
     *   X3 = X5 + 0x10
     *   X2 = X5 + 0x20
     *   X1 = X5 + 0x30
     */
    REF_TREE_MAP tree_map;          /* +0x00: passed as X5 */
    REF_MEM_BLOCK x_ss_stub;        /* +0x10: passed as X3 */
    REF_MEM_BLOCK url;              /* +0x20: passed as X2 */
    REF_JSON_LIST json_list;        /* +0x30: passed as X1 */
} MetaSecHttpInnerArgPack350;       /* size 0x40 */

typedef MetaSecHttpInnerArgPack350 MetaSecArgWindow350; /* legacy alias */

/* ------------------------------------------------------------------------- */
/* 350.101 managed bytecode/frame runtime                                     */
/* ------------------------------------------------------------------------- */

union ManagedFrameSlots350 {
    uint64_t slot[80];               /* +0x8100..+0x837f generic qword slot table */
    struct {
        uint64_t slot_00_28[29];     /* +0x8100 */
        void *value_stack_top;       /* +0x81e8: initialized to buf+0x8000; also double overflow base in 0x154784 */
        uint64_t slot_30;            /* +0x81f0 */
        int64_t exec_status;         /* +0x81f8: copied into frame->status */
        uint64_t slot_32_79[48];     /* +0x8200 */
    } view;
    struct {
        /*
         * 0x154784/managedFrameGetSlotDouble_350 does not use the generic
         * qword slot base for slot<=7. It reads D0 from:
         *   buf + 0x82e0 + slot*8
         * For slot>7, it reads from:
         *   *(buf + 0x81e8) + slot*8 - 0x40
         */
        uint8_t pad_to_inline_double[0x1e0];
        double inline_double_slot_0_7[8]; /* +0x82e0..+0x831f */
    } double_view;
};                                   /* size 0x280 */

struct ManagedFrameBuffer350 {
    /*
     * Acquired by 0x1545A8/managedFrameAcquire_350 from a TLS freelist.
     * The interpreter uses the first 0x8000 bytes as a value stack/scratch
     * area, then a 0x280-byte slot table at +0x8100.
     */
    uint8_t value_stack[0x8000];      /* +0x0000 */
    uint8_t gap_8000[0x100];         /* +0x8000 */
    ManagedFrameSlots350 slots;       /* +0x8100 */
};                                   /* size 0x8380 */

struct ManagedFrame350 {
    int32_t status;                  /* +0x00: written from buf->slots.view.exec_status */
    int32_t pad_04;                  /* +0x04 */
    void *interp_saved;              /* +0x08: temporary interpreter state */
    ManagedFrameBuffer350 *buf;      /* +0x10 */
};                                   /* size 0x18, usually stack-allocated */

struct ManagedProgramBody350 {
    uint32_t entry_or_flags;         /* +0x00: copied into interpreter local state */
    uint32_t stack_need;             /* +0x04: checked against frame value stack */
    uint8_t *code_begin;             /* +0x08: managed bytecode begin, 0x18-byte records */
    uint8_t *code_end;               /* +0x10: managed bytecode end */
    uint8_t *code_end_dup;           /* +0x18: equals code_end in F5/F7/F8/F13/F15 dumps */
    uint64_t name_sso_qword;         /* +0x20: SSO-ish "\x04F5\0nown" / "\x06F13\0own" */
    uint64_t zero_28;                /* +0x28 */
    uint64_t zero_30;                /* +0x30 */
};                                   /* size 0x38 when embedded in kind==1 program */

struct ManagedProgram350 {
    /*
     * 0x154468/managedProgramInvokeCore_350 dispatches by kind:
     *   kind == 1: run inline bytecode body at program+0x08
     *   kind == 2: if bytecode_body non-null, run it; else call native_entry_or_body(frame)
     *   kind == 3: call native_entry_or_body(frame)
     *   otherwise: treat *(program+0) as body pointer
     *
     * Runtime descriptor dumps prove kind==1 programs are 0x40-byte contiguous
     * records:
     *   program+0x00 kind=1
     *   program+0x08 ManagedProgramBody350 inline body
     *   program+0x40 next ManagedProgram350
     *
     * The old 334-imported model that always treated program+0x28 as a
     * bytecode_body pointer is wrong for 350 kind==1: at +0x28 lives the
     * embedded program name SSO qword, not a pointer.
     */
    int64_t kind;                    /* +0x00 */
    union {
        ManagedProgramBody350 inline_body; /* +0x08, kind==1 */
        struct {
            void *native_entry_or_body;    /* +0x08, kind==2/3 */
            void *field_10;                /* +0x10 */
            void *field_18;                /* +0x18 */
            void *field_20;                /* +0x20 */
            ManagedProgramBody350 *bytecode_body; /* +0x28, kind==2 only */
            uint64_t field_30;             /* +0x30 */
            uint64_t field_38;             /* +0x38 */
        } native_or_external;
    } u;                                  /* +0x08 */
};                                       /* observed kind==1 size 0x40 */

struct ManagedNativeBinding350 {
    /*
     * Stack arrays passed into 0x154328/managedModuleBuild_350.
     * Entries are 0x18 bytes: name/key object, native callback, and a small
     * flag byte. The first field may be a literal string such as "CF10" or a
     * small-string object in .rodata, so keep it as void* until each table is
     * decoded.
     */
    void *name_or_sso_key;           /* +0x00 */
    void *callback;                  /* +0x08 */
    uint8_t flags;                   /* +0x10 */
    uint8_t pad_11[0x07];            /* +0x11 */
};                                   /* size 0x18 */

struct ManagedModule350 {
    /*
     * Returned by 0x154328/managedModuleBuild_350 after XOR/decode/parse.
     * 0x154364/managedModuleFindProgram_350 reads *(module+0) as the program
     * pointer array, then uses an inline string->index map at module+0x20.
     */
    ManagedProgram350 **programs;    /* +0x00: indexed by F0/F1/... lookup */
    uint64_t field_08;               /* +0x08 */
    uint64_t field_10;               /* +0x10 */
    uint64_t field_18;               /* +0x18 */
    uint8_t program_index_map[1];    /* +0x20: inline hash/map blob */
};                                   /* observed minimum size 0x21 */

/* Slot convention recovered from 0x1547C0/0x1547D4 xrefs:
 *   slot2       dominant return value slot
 *   slot2/double value read by 0x154784 for CF79 JSON numbers
 *   slot4+      wrapper/native arguments
 *   slot19/20/27 rarer dispatcher-specific argument/state slots
 *   slot29      value_stack_top, initialized by managedFrameAcquire_350
 *   slot31      exec_status, copied into ManagedFrame350::status
 */

typedef struct MetaSecDigest32State350 {
    /*
     * CF61 / 0x16F998 adapter:
     *   slot4=input pointer, slot5=input length, slot6=output digest pointer.
     *
     * Lower native chain:
     *   0x16D520 sm3OneShot_F15InitUpdateFinal_350
     *   0x171794 managedSignDigestStateInitF15_350
     *   0x16D5A0 sm3Update_64byteBlocks_350
     *   0x16D680 sm3Final_padLenEmit32_350
     *   0x16D86C sm3Compress_flattenedBlocks_350
     *
     * Evidence:
     *   - update uses state+0/state+4 as a byte counter;
     *   - update buffers incomplete blocks at state+0x28;
     *   - final appends 0x80/zero padding plus 64-bit bit length;
     *   - final emits 8 32-bit words as a 32-byte big-endian digest.
     *
     * Crypto family is now evidence-backed SM3:
     *   - F15 writes the standard SM3 IV;
     *   - 5/5 raw CF61 input/output pairs match standard SM3;
     *   - standalone oracle:
     *     cf61_sm3_recovered_350101.c => failures=0.
     *
     * The compression body at 0x16D86C is still control-flow flattened through
     * shared table 0x29F420, but its semantic lift is standard SM3 compress.
     */
    uint32_t byte_count_lo;          /* +0x00 */
    uint32_t byte_count_hi;          /* +0x04 */
    uint32_t state_words[8];         /* +0x08: emitted as 32-byte big-endian digest */
    uint8_t block_tail[0x40];        /* +0x28: pending bytes before 64-byte compression */
} MetaSecDigest32State350;           /* observed size 0x68 */

/* ------------------------------------------------------------------------- */
/* Function-local argument packs on the 0x149CA8 HTTP/sign path               */
/* ------------------------------------------------------------------------- */

typedef struct MetaSecSignStage1Args350 {
    /*
     * 0x16D204/signStage1_makeStubPieces_350 reads this stack/heap pack.
     * The same pack shape is visible in the 0x149CA8 successful trace before
     * the final X-* header tree is emitted.
     */
    int64_t seed_or_handle;          /* +0x00 */
    MEM_BLOCK *x_ss_stub;            /* +0x08 */
    MEM_BLOCK *url_or_path;          /* +0x10 */
    uint16_t *short_code;            /* +0x18 */
    char **out_ptr;                  /* +0x20: shared with later stages */
    char **out_str;                  /* +0x28: written by stage 1 */
    int32_t mode;                    /* +0x30: mode==1 uses empty source path */
    int32_t pad_34;                  /* +0x34 */
} MetaSecSignStage1Args350;          /* observed size >= 0x38 */

typedef struct MetaSecSignStage2Args350 {
    /*
     * 0x16D454/signStage2_makeKeyPieces_350 decrypts/expands format strings
     * and writes both output char** fields.
     */
    uint32_t seed;                   /* +0x00 */
    uint32_t pad_04;                 /* +0x04 */
    char **out_ptr;                  /* +0x08 */
    char **out_str;                  /* +0x10 */
} MetaSecSignStage2Args350;          /* observed size >= 0x18 */

typedef struct MetaSecManagedCallArg350 {
    /*
     * Stack pack built by 0x149CA8 immediately before managed sign wrappers:
     *
     *   0x14A38C -> managedSignBuildA_350/F5 -> X-Argus
     *   0x14A4E0 -> managedSignBuildFinal_350/F8 -> X-Medusa/final material
     *
     * F5 puts this pointer into managed-frame slot4; F8 puts the same-layout
     * pointer into slot20. The managed program then reads this pack through
     * CF/native helpers, writes generated key/value C strings into
     * out_key/out_value, and the outer function copies those strings into
     * MEM_BLOCKs before treeMapPut.
     *
     * Evidence:
     *   - 0x14A358..0x14A388 and 0x14A4A0..0x14A4DC store these exact offsets.
     *   - 0x1715F8 forwards X19 through the slot4 thunk; 0x171698 uses the
     *     generic frame setter for slot20.
     *   - origin-aware treeMapPut probe maps F5/F7/F8 outputs to X-* headers.
     *   - managed CF post-return trace proves:
     *       F5/CF98 writes "X-Argus" and value len 0x104-class;
     *       F8/CF98 writes "X-Medusa" and value len 0x3b0/0x3b8-class.
     */
    int64_t seed_or_handle;          /* +0x00: var_248/sub_12D504 result */
    JSON_LIST *json_list;            /* +0x08: json_list->json_list */
    MEM_BLOCK *x_ss_stub;            /* +0x10: x_ss_stub->mem */
    MEM_BLOCK *url_or_path;          /* +0x18: &dst derived URL/query/path */
    MEM_BLOCK *aux_ref_mem;          /* +0x20: ref.mem, populated from env/op2 helper */
    MEM_BLOCK *token_or_env_block;   /* +0x28: &v283, op2/env MEM_BLOCK scratch */
    void *bd_client_key_item;        /* +0x30: queryTreeItem result for runtime key table */
    void *bd_client_key_value;       /* +0x38: paired query/value object used by F5/F8 */
    int32_t request_type;            /* +0x40: original type argument */
    int32_t pad_44;                  /* +0x44 */
    char **out_key;                  /* +0x48: &ptr, generated header key string */
    char **out_value;                /* +0x50: &s, generated header value string */
    int32_t metasec_mode;            /* +0x58: parsed x-metasec-mode */
    uint8_t final_flag;              /* +0x5c: only set before F8 path */
    uint8_t pad_5d[3];               /* +0x5d */
} MetaSecManagedCallArg350;          /* observed size >= 0x60 */

typedef struct MetaSecXArgusProtoWire92_350 {
    /*
     * Current observed CF41 plaintext payload. This is protobuf wire data,
     * not a fixed native C object: field sizes and offsets can vary with
     * optional values. Keep it as an opaque, sample-scoped byte view.
     */
    uint8_t wire[0x92];               /* observed length 0x92 */
} MetaSecXArgusProtoWire92_350;

typedef struct MetaSecXMedusaFinalPack2C8_350 {
    /*
     * Final decoded output-buffer layout observed before its outer encoding.
     * It is not the F8 call ABI, and the last array remains opaque because
     * its content is produced by managed/native work areas.
     */
    uint8_t mutated_mini[0x14];       /* +0x00 */
    uint8_t fixed_pair[0x02];         /* +0x14 */
    uint8_t zero_byte;                /* +0x16 */
    uint8_t one_byte;                 /* +0x17 */
    uint8_t marker_byte;              /* +0x18 */
    uint8_t mutated_subpack[0x2af];   /* +0x19 */
} MetaSecXMedusaFinalPack2C8_350;     /* observed size 0x2c8 */

typedef struct MetaSecArgusTailPack24_350 {
    /*
     * F5/X-Argus tail, focused log:
     *   sign6_350101_f5_tailcf_20260831_065857.log
     *
     * CF30 hit12 proves:
     *   slot4 == slot5 || slot6
     *   0x20 + 0x04 = 0x24
     *
     * 【中文】这是 X-Argus 尾部封包里进入 pack44 前的第一层小包。
     * 字段语义暂按来源命名，不把它硬猜成固定算法字段。
     */
    uint8_t digest_or_material20[0x20]; /* +0x00 */
    uint8_t dyn4[0x04];                 /* +0x20, current tail sample ends 1b e1 80 6f */
} MetaSecArgusTailPack24_350;           /* observed size 0x24 */

typedef struct MetaSecArgusTailPack44_350 {
    /*
     * CF30 hit13 proves:
     *   pack44 = pack24 || digest_or_material20
     *
     * This 0x44 buffer is then fed to CF61/SM3, and the first 0x20 bytes of the
     * result are snapshotted back into the F5 tail.
     */
    MetaSecArgusTailPack24_350 head24;  /* +0x00 */
    uint8_t digest_or_material20[0x20]; /* +0x24 */
} MetaSecArgusTailPack44_350;           /* observed size 0x44 */

typedef struct MetaSecArgusTailBodyB1_350 {
    /*
     * CF30 hit17/hit21/hit22 prove:
     *   tailA8  = const8 || transformA0
     *   prefix9 = prefix1 || prefix8
     *   bodyB1  = prefix9 || tailA8
     *
     * transformA0 is now resolved as CF41 SIMON128/256 + PKCS#7 output.
     */
    uint8_t prefix1;                    /* +0x00, current sample 0x35 */
    uint8_t prefix8[0x08];              /* +0x01 */
    uint8_t const8_or_count[0x08];       /* +0x09, current sample starts 08 00... */
    uint8_t transformA0[0xa0];           /* +0x11 */
} MetaSecArgusTailBodyB1_350;           /* observed size 0xb1 */

typedef struct MetaSecArgusTailBodyB3_350 {
    /*
     * CF42 + CF30 hit24 prove:
     *   bodyB3 = bodyB1 || suffix2
     *
     * CF42 is now peeled: it stores low16(slot5) as a 2-byte little-endian
     * MEM_BLOCK via 0x16CC84. Current sample slot5=0x6f80 -> 80 6f.
     */
    MetaSecArgusTailBodyB1_350 body_b1; /* +0x00 */
    uint8_t suffix2[0x02];              /* +0xb1 */
} MetaSecArgusTailBodyB3_350;           /* observed size 0xb3 */

typedef struct MetaSecSimon128256Schedule350 {
    /*
     * CF41 / 0x16E678 expands 32-byte key material into this 0x240-byte
     * schedule. 72 little-endian u64 round keys match SIMON128/256.
     */
    uint64_t round_key[72];             /* +0x000 */
} MetaSecSimon128256Schedule350;        /* size 0x240 */

typedef struct MetaSecArgusTailSimonPlain92_350 {
    /*
     * Current CF41 runtime vector input before PKCS#7 padding. This is
     * bytedance.reqsign.XArgusStruct in protobuf wire format, not a fixed
     * C struct:
     *
     *   f1  k1_sdk_date        varint 0x40401252
     *   f2  k2_type            varint 2
     *   f3  k3_random_value    varint dynamic
     *   f4  k4_aid             len "1128"
     *   f5  k5_device_id       len "397365608203400"
     *   f6  k6_version_string  len "1588093228"
     *   f7  k7_app_version_name len "35.1.0"
     *   f8  k8_sdk_version_name len "v04.09.05-ml-android"
     *   f9  k9_sdk_version_code varint 0x08120a00
     *   f10 k10_proto_header   len 08 00 00 00 00 00 00 00
     *   f12/f17 khronos        varint dynamic, same value in current samples
     *   f13 k13_xssstub_sm3    raw 6-byte material in current sample
     *   f14 k14_url_sm3        raw 6-byte material in current sample
     *   f15 k15_algorithm_seq  nested {algo=2, report=0x1530be, setting=0x1530be}
     *   f20 k20_pskVersion     len "none"
     *   f21 k21_callType       varint 0x2e2
     *
     * See cf41_plain92_proto_350101.md for the field table.
     */
    uint8_t xargus_struct_wire[0x92];   /* +0x00 */
} MetaSecArgusTailSimonPlain92_350;     /* observed size 0x92 */

typedef struct MetaSecArgusTailSimonOutA0_350 {
    /*
     * CF41 output:
     *   SIMON128/256(key32=slot6, input=slot4 PKCS#7 padded 0x92->0xa0)
     *
     * Runtime oracle:
     *   cf41_simon128_256_recovered_350101.c failures=0
     */
    uint8_t simon128_256_pkcs7_out[0xa0]; /* +0x00 */
} MetaSecArgusTailSimonOutA0_350;       /* observed size 0xa0 */

typedef struct MetaSecAesModeDesc350 {
    /*
     * First field is proven by 0x11CAE0/0x11CBB4:
     *
     *   x20 = x0;
     *   x8 = *(uint64_t *)x20;
     *   type = *(uint32_t *)x8;
     *
     * Current F5 CF43 slot8 raw dump starts with 01 00 00 00, so type=1.
     * Static dispatch maps type 1 to AES-CBC init/process.
     */
    uint32_t type;                      /* +0x00: 0 raw, 1 CBC, 2 CTR, 3 feedback */
    uint32_t flags_or_reserved;          /* +0x04 */
    uint64_t reserved_08;                /* +0x08 */
} MetaSecAesModeDesc350;

typedef struct MetaSecCf43ModeInitArgs350 {
    /*
     * Transient stack/slot argument package passed to 0x11CAE0.
     * For type 1, 0x11CB54 reads:
     *
     *   mode_desc = arg0[0];
     *   key_mb    = arg0[1];  // body pointer + len passed to 0x106230
     *   iv_mb     = arg0[2];  // body pointer passed as AES-CBC IV
     */
    MetaSecAesModeDesc350 *mode_desc;   /* +0x00 */
    MEM_BLOCK *key16;                   /* +0x08 */
    MEM_BLOCK *iv16_or_side;            /* +0x10 */
} MetaSecCf43ModeInitArgs350;

typedef struct MetaSecAesModeCtx350 {
    /*
     * 0x11CAE0 clears 0x210 bytes at the context pointer before dispatch.
     * 0x106230 first builds a temporary AES key schedule, then 0x1061FC copies
     * 0x1e8 bytes into this ctx and stores the IV at ctx+0x1e8.
     */
    uint8_t aes_round_context[0x1e8];    /* +0x000 */
    uint8_t cbc_chain_or_iv[0x10];       /* +0x1e8 */
    uint8_t mode_tail[0x18];             /* +0x1f8 */
} MetaSecAesModeCtx350;                 /* observed memset size 0x210 */

typedef struct MetaSecArgusFinalPackC2_350 {
    /*
     * CF43 + CF42 + CF30 hit27 prove:
     *   argusC2 = prefix2 || outC0
     *   base64(argusC2) == final X-Argus
     *
     * Current sample prefix2 is 1b e1, from CF42 low16(0x6f80e11b).
     * `outC0` is the CF43 AES mode output after the 0xb3 body is
     * PKCS#7-padded to 0xc0 and transformed with 16-byte material.
     * The focused CF43 return probe resolves ownership:
     *   0x11CBB4 processes x2/x3 in place, len=0xc0;
     *   0x11C8D8 saved_x2_after == next CF30 slot6/outC0;
     *   final CF44 input is prefix2 || outC0.
     * Current F5 modeDesc[0].type == 1 -> 0x106230 AES-CBC init +
     * 0x1062A8 AES-CBC process. OpenSSL and standalone C oracle both match.
     */
    uint8_t prefix2[0x02];              /* +0x00 */
    uint8_t outC0[0xc0];                /* +0x02 */
} MetaSecArgusFinalPackC2_350;          /* observed size 0xc2 */

typedef struct MetaSecManagedShortCallArg350 {
    /*
     * Shorter pack rebuilt by 0x14D2B8/prepareManagedSignPackTail_350 before:
     *
     *   0x14A3EC -> managedSignBuildB_350/F7 -> X-Ladon
     *   0x14A588 -> managedSignPostEmitF13_350/F13 -> X-Helios/Soter side path
     *
     * Only the first 0x30 bytes are freshly written here. Bytes after +0x30 may
     * contain stale data from the earlier F5/F8 pack and must not be read as
     * valid fields without runtime evidence.
     *
     * Current CF100 post-return evidence for F7/F13:
     *   "%u-%s-%s" -> "1788108717-1588093228-1128" in the
     *   sign6_350101_cf48_cf49_20260831_005155 run.
     */
    int64_t seed_or_handle;          /* +0x00: var_248/sub_12D504 result */
    MEM_BLOCK *derived_block;        /* +0x08: REF_MEM_BLOCK v281.mem / derived URL material */
    JSON_LIST *json_list;            /* +0x10: json_list->json_list */
    MEM_BLOCK *stack_memblock;       /* +0x18: &a2, stack MEM_BLOCK prepared from JSON/env */
    char **out_key;                  /* +0x20: &ptr */
    char **out_value;                /* +0x28: &s */
} MetaSecManagedShortCallArg350;     /* observed size 0x30 */

typedef struct MetaSecShortHeaderBinaryPack350 {
    /*
     * Runtime-only binary pack used by the short header programs:
     *
     *   F7  -> X-Ladon
     *   F13 -> X-Helios
     *
     * Evidence from CF48/CF49 focused run:
     *   - CF100 creates text like "1788108717-1588093228-1128".
     *   - CF48 reads that text plus a 32-byte ASCII hex-like key/material and
     *     rewrites slot5 into a 32-byte binary transform result.
     *   - CF49 prepends a 4-byte prefix copied by CF38 and returns this
     *     0x24-byte MEM_BLOCK.
     *   - CF44 base64 of this exact 0x24 bytes is the 48-char header value.
     *   - cf48_f17_recovered_350101.c reproduces F7/X-Ladon and F13/X-Helios
     *     byte-for-byte through CF48 -> CF49 -> CF44, current failures=0.
     */
    uint8_t prefix4[0x04];           /* +0x00: CF38-copied binary prefix */
    uint8_t transform32[0x20];       /* +0x04: CF48 output */
} MetaSecShortHeaderBinaryPack350;    /* observed size 0x24 */

typedef struct MetaSecShortHeaderScratch350 {
    /*
     * Function-local managed value-stack scratch used by F7/F13 short header
     * bytecode. This is not a stable external ABI; it is a naming aid for the
     * linear lift around records 0x2b..0x82.
     *
     * Evidence:
     *   F7  0x2b CF100, 0x32/0x4b CF38, 0x52 CF48, 0x55 CF49,
     *       0x59 CF44, 0x7b/0x82 CF98
     *   F13 0x2b CF100, 0x32/0x4b CF38, 0x52 CF48, 0x55 CF49,
     *       0x59 CF44, 0x79/0x80 CF98
     */
    uint8_t unknown_00[0x10];        /* +0x00 */
    char **out_key;                  /* +0x10: copied from short_arg+0x20 */
    char **out_value;                /* +0x18: copied from short_arg+0x28 */
    uint8_t key_material_a[0x04];     /* +0x20: F7/F13 late key material */
    uint8_t key_material_b[0x04];     /* +0x24: F7/F13 late key material */
    uint8_t b64_or_key_tmp[0x10];     /* +0x28: base64/key tmp ref area */
    uint8_t tmp_ref_38[0x18];         /* +0x38 */
    MEM_BLOCK transform32;            /* +0x50: CF48 output side */
    MEM_BLOCK prefix_or_pack36;        /* +0x68: CF49 output side; CF44 input */
    MEM_BLOCK tmp80;                  /* +0x80 */
    MEM_BLOCK formatted_text;         /* +0x98: CF100 "%u-%s-%s" output */
    uint8_t tmp_b0[0x1c];             /* +0xb0 */
    uint32_t len_or_seed_cc;          /* +0xcc */
} MetaSecShortHeaderScratch350;       /* observed frame-local size >= 0xd0 */

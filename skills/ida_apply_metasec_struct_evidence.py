"""
IDAPython helper: apply comments and evolving struct types from
metasec_struct_infer.py summary.json.

Usage inside IDA after opening the matching libmetasec_ml.so database:

  1. Edit SUMMARY_JSON/STRUCT_HEADER below if needed.
  2. File -> Script file... -> choose this script.

It adds repeatable comments at instruction addresses such as:

  [metasec:x0] +0x240 field_240 access=RW sizes=8 count=2

It applies reversible comments, imports the current draft structs into Local
Types, names important helper functions, and applies known-good function
prototypes so Hex-Rays starts showing fields such as ctx->registry,
ctx->op2.msp_token, dst->refcnt, op2->has_token, etc.
"""

from __future__ import annotations

import json
import re
from pathlib import Path

import ida_bytes
import ida_idaapi
import ida_auto
import ida_funcs
import ida_hexrays
import idaapi
import ida_kernwin
import ida_name
import ida_nalt
import ida_typeinf
import idc


SUMMARY_JSON = Path(
    "/Users/freeman/project/douyin/dyidre/versions/350101/summary.json"
)
STRUCT_HEADER = Path(
    "/Users/freeman/project/douyin/dyidre/versions/350101/metasec_ctx350_draft.h"
)
COMMENT_TAG_PREFIX = "[metasec:"
_CACHED_CFUNCS: dict[int, ida_hexrays.cfunc_t] = {}
IMPORTANT_FUNCTIONS = [
    # IDA currently misses this as a function in the 350 i64: sub_149C20 ends
    # exactly at 0x149ca8, then the real inner body continues to 0x14a77c.
    (0x149C20, 0x149CA8, "copyRefWithLock_350"),
    (0x149CA8, 0x14A77C, "buildSignedHttpHeadersInner_350"),
    (0x14DBF4, 0x14DDC8, "buildSignedHttpHeadersCallback_350"),
    (0x14E888, 0x14EAE4, "metasec350_http_dispatcher_alt_14e888"),
    (0x14EBB4, 0x14EE28, "metasec350_http_dispatcher_14ebb4"),
    (0x14EF30, 0x14F094, "parseCrlfPairsToTree_350"),
    (0x14F098, 0x14F220, "treeMapToCrlfString_350"),
    (0x14F22C, 0x14F390, "parseCrlfPairsToTree2_350"),
    (0x14F394, 0x14F51C, "treeMapToCrlfString2_350"),
    (0x14CEBC, 0x14D130, "initManagedHttpModule_350"),
    (0x14D130, 0x14D1D8, "managedHttpF0Wrapper_350"),
    (0x14D1D8, 0x14D264, "managedHttpF1Wrapper_350"),
    (0x14D264, 0x14D26C, "newMemBlock24_350"),
    (0x14D284, 0x14D290, "newMemBlock24_loadOutputMapX22_350"),
    (0x14D2B8, 0x14D2E0, "prepareManagedSignPackTail_350"),
    (0x14D2E8, 0x14D2F4, "copyOutValueStringToX28MemBlock_350"),
    (0x14D2F4, 0x14D300, "copyOutKeyStringToX27MemBlock_350"),
    (0x14D290, 0x14D2A0, "treeMapPut_X22_X27_X28_350"),
    (0x14D300, 0x14D310, "treeMapPut_X22_X23_X24_350"),
    (0x14D310, 0x14D31C, "httpThunkStackCanaryCheck_350"),
    (0x14D370, 0x14D388, "prepareManagedSignPackCommon_350"),
    (0x14D394, 0x14D3A4, "copyRuntimeHeaderKey2_saveItemX22_350"),
    (0x14D40C, 0x14D418, "queryInputTreeByRuntimeHeaderKey1_350"),
    (0x14D418, 0x14D424, "queryInputTreeByRuntimeHeaderKey2_350"),
    (0x14D424, 0x14D42C, "returnHeaderTreeViaX8_350"),
    (0x14D42C, 0x14D438, "copyPackFirstMemBlockToStackKey48_350"),
    (0x14D44C, 0x14D454, "copyStringToMemBlock_saveX24_350"),
    (0x14D454, 0x14D460, "transformStackMemBlock60ToPackC0_350"),
    (0x14D49C, 0x14D4A8, "copyStringToX27MemBlock_350"),
    (0x14D4B4, 0x14D4C0, "copyRuntimeHeaderKey1ToStack48_350"),
    (0x14D4C8, 0x14D4D4, "freeStackMemBlock48_saveX22_350"),
    (0x14D4D4, 0x14D4E0, "copyStackMemBlock48ToX28_350"),
    (0x14D4E0, 0x14D4EC, "base64PackC0ToStackMemBlock48_350"),
    (0x124DD4, 0x124E34, "nativeVmpBuildMssdkMaterial_350"),
    (0x129B24, 0x129B30, "nativeVmpMaterialBridgeThunk_350"),
    (0x120E00, 0x120E60, "treeMapPutDoubleValue_350"),
    (0x11FBDC, 0x11FC2C, "newTreeKV_350"),
    (0x11FC30, 0x11FD40, "treeMapPut_350"),
    (0x139AB0, 0x139B24, "formatAllocString_350"),
    (0x154328, 0x154364, "managedModuleBuild_350"),
    (0x154364, 0x154454, "managedModuleFindProgram_350"),
    (0x154454, 0x154468, "managedProgramInvoke_350"),
    (0x154468, 0x1544EC, "managedProgramInvokeCore_350"),
    (0x1545A8, 0x154648, "managedFrameAcquire_350"),
    (0x154648, 0x154780, "managedFrameRelease_350"),
    (0x1547C0, 0x1547D4, "managedFrameGetSlot_350"),
    (0x1547D4, 0x1547E8, "managedFrameSetSlot_350"),
    (0x15485C, 0x154C24, "managedStringIndexMapFind_350"),
    (0x1555A4, 0x158460, "managedBytecodeRun_350"),
    (0x158F48, 0x15910C, "managedModuleDecodeBuild_350"),
    (0x16CCD8, 0x16CE40, "shortHeaderTransform32_flattened_CF48_350"),
    (0x16D520, 0x16D5A0, "sm3OneShot_F15InitUpdateFinal_350"),
    (0x16D5A0, 0x16D680, "sm3Update_64byteBlocks_350"),
    (0x16D680, 0x16D86C, "sm3Final_padLenEmit32_350"),
    (0x16E794, 0x16E8FC, "cf48_transformTextWithF17Blocks_350"),
    (0x16E8FC, 0x16EA30, "cf48_seedScheduleARX_16E8FC_350"),
    (0x1261B0, 0x126298, "metasec350_registry_find_type"),
    (0x47908, 0x479C4, "metasec350_shared_ref_assign"),
    (0x47C1C, 0x47CC0, "metasec350_shared_ref_reset_assign"),
    (0x4ABD4, 0x4AC28, "metasec350_shared_ref_release"),
    (0x117EB8, 0x117F3C, "metasec350_varint_write_u32"),
    (0x16D204, 0x16D454, "signStage1_makeStubPieces_350"),
    (0x16D454, 0x16D58C, "signStage2_makeKeyPieces_350"),
    (0x16F660, 0x16F6B0, "cf48_shortHeaderTransform32_slot4_text_slot5_out_slot6_key_350"),
    (0x16F6B0, 0x16F6FC, "cf49_buildShortHeaderPack36_slot4_prefix_slot5_xform_ret2_350"),
    (0x16F998, 0x16F9F8, "cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350"),
    (0x1702B8, 0x17157C, "initManagedSignModuleLarge_350"),
    (0x171794, 0x1717F4, "managedSignDigestStateInitF15_350"),
    (0x1717F4, 0x17184C, "managedSignBlockWrapperF16_350"),
    (0x17184C, 0x1718A4, "managedSignBlockTransformF17_350"),
    (0x17157C, 0x1715F8, "managedSignBuildF4Flag_350"),
    (0x1715F8, 0x171648, "managedSignBuildA_350"),
    (0x171648, 0x171698, "managedSignBuildB_350"),
    (0x171698, 0x1716F4, "managedSignBuildFinal_350"),
    (0x1716F4, 0x171744, "managedSignPostEmitF13_350"),
    (0x1718DC, 0x1718E8, "managedThunkStackCanaryCheck_350"),
    (0x1718E8, 0x1718F8, "managedThunkSetSlot4FromX21_350"),
    (0x1718F8, 0x171908, "managedThunkSetSlot6FromX19_350"),
    (0x171908, 0x171918, "managedThunkSetSlot5FromX20_350"),
    (0x171918, 0x171920, "managedThunkAcquireFrameWithCanary_350"),
    (0x171920, 0x171930, "managedThunkSetSlot4FromX19_350"),
    (0x17196C, 0x171974, "managedThunkReleaseFrameFromX20_350"),
    (0x1719F0, 0x1719F8, "managedFrameGetReturnSlot2_350"),
]

IMPORTANT_NAMES = [
    # Do not force-add a huge function for exeVMInner_350.  In some databases
    # IDA already owns the boundaries; in others the handler tail is still
    # being repaired.  Naming/commenting is safe and reversible.
    (0x4CC10, "exeVMInner_350"),
    (0x12564C, "selectValueFromNativeVmpMaterial_350"),
    (0x16D86C, "sm3Compress_flattenedBlocks_350"),
    (0x16F43C, "cf41_argusTailSimon128256_slot4_input_slot5_out_slot6_key_350"),
    (0x16CB88, "cf41_argusTailSimon128256_inner_350"),
    (0x16E538, "cf41_simon128_256_pkcs7_encrypt_16E538_350"),
    (0x16E678, "cf41_simon128_256_expandKey_16E678_350"),
    (0x16F48C, "cf42_makeU16MemBlockLE_slot4_out_slot5_low16_350"),
    (0x16CC84, "makeU16MemBlockLE_16CC84_350"),
    (0x16F4C4, "cf43_argusTailAesModePkcs7Transform_slot4_out_slot5_body_slot6_key16_350"),
    (0x16FD64, "cf79_jsonAddNumber_slot4_json_slot5_key_slot2_double_350"),
    (0x11BF94, "cf43_argusTailAesModePkcs7Transform_inner_350"),
    (0x11CAE0, "cf43_modeInitDispatcher_350"),
    (0x11CBB4, "cf43_modeProcessDispatcher_350"),
    (0x11C8D8, "cf43_afterModeProcessWrapOutput_350"),
    (0x10569C, "aesSetEncryptKey_350"),
    (0x105AF0, "aesEncryptBlock_350"),
    (0x105E54, "aesDecryptBlock_350"),
    (0x106230, "aesCbcInit_350"),
    (0x1062A8, "aesCbcEncrypt_350"),
    (0x106458, "aesCtrInit_350"),
    (0x1064D0, "aesCtrProcess_350"),
    (0x10667C, "aesFeedbackInit_350"),
    (0x1066F4, "aesFeedbackProcess_350"),
    (0x157EB0, "managedOp_ST64_write_handler_350"),
    (0x157EE4, "managedOp_ST8_write_handler_350"),
    (0x1719B0, "roundUp16AndMakePaddingMemBlock_350"),
    (0x171A2C, "initMemBlockBySrc_key32_350"),
    (0x171A40, "initMemBlockBySrc_text_350"),
]

FORCE_SPLIT_FUNCTION_STARTS = {
    # Earlier script revisions created one coarse function 0x171794..0x1718DC.
    # It actually contains F15/F16/F17 wrappers plus shared tail thunks.
    0x171794,
    0x1717F4,
    0x17184C,
}

IDA_DECLS = r"""
typedef struct MetaSecSharedRef350 {
    void *obj;
    int *refcnt;
} MetaSecSharedRef350;

typedef struct MetaSecNode350 MetaSecNode350;

typedef struct TREE_KV {
    void *key;
    void *value;
} TREE_KV;

typedef struct VmParam64_350 {
    /*
     * exeVMInner_350 parameter/control block.
     * Observed wrapper stores code/data pointers and VM state here before the
     * BR X8 dispatch loop starts.  Keep as qwords until individual offsets are
     * promoted from VM traces.
     */
    unsigned __int64 qword_000[0x80];
} VmParam64_350;

typedef struct NativeVmpResultObject350 NativeVmpResultObject350;
typedef struct MetaSecMssdkMaterial350 MetaSecMssdkMaterial350;
typedef struct MetaSecMssdkAppInfo350 MetaSecMssdkAppInfo350;
typedef struct MetaSecMssdkKeyValue350 MetaSecMssdkKeyValue350;

typedef struct NativeVmpResultObject350 {
    void *vtable_26f2c8;                  /* +0x00 */
    MetaSecMssdkMaterial350 *material;    /* +0x08 */
} NativeVmpResultObject350;

typedef struct MetaSecMssdkKeyValue350 {
    void *template_or_schema;             /* +0x00 */
    unsigned __int64 field_08;            /* +0x08 */
    unsigned __int64 field_10;            /* +0x10 */
    const char *key;                      /* +0x18: common_key/sign_key */
    const char *value;                    /* +0x20: base64 material */
} MetaSecMssdkKeyValue350;

typedef struct MetaSecMssdkAppInfo350 {
    void *template_or_schema;             /* +0x00 */
    unsigned __int64 field_08;            /* +0x08 */
    unsigned __int64 field_10;            /* +0x10 */
    const char *package_name;             /* +0x18 */
    unsigned int material_count;          /* +0x20 */
    unsigned int pad_24;
    const char **material_values;         /* +0x28: observed AEA615... */
    unsigned __int64 field_30;            /* +0x30 */
} MetaSecMssdkAppInfo350;

typedef struct MetaSecMssdkMaterial350 {
    void *template_0;                     /* +0x00 */
    void *template_8;                     /* +0x08 */
    void *template_10;                    /* +0x10 */
    unsigned int seed_id;                 /* +0x18: 0x20200924 */
    unsigned int pad_1c;
    const char *module_name;              /* +0x20: "mssdk" */
    const char *app_id;                   /* +0x28: "1588093228" */
    unsigned int enabled;                 /* +0x30: 1 */
    unsigned int pad_34;
    const char *sdk_version;              /* +0x38: "1128" */
    unsigned int salt_id;                 /* +0x40: 0x5fa25885 */
    unsigned int pad_44;
    unsigned __int64 app_info_count;      /* +0x48: 1 */
    MetaSecMssdkAppInfo350 **app_infos;   /* +0x50 */
    unsigned __int64 kv_count;            /* +0x58: 2 */
    MetaSecMssdkKeyValue350 **kv_items;   /* +0x60 */
    unsigned __int64 tail;                /* +0x68 */
} MetaSecMssdkMaterial350;

typedef struct MetaSecSignStage1Args350 {
    __int64 seed_or_handle;
    MEM_BLOCK *x_ss_stub;
    MEM_BLOCK *url_or_path;
    unsigned short *short_code;
    char **out_ptr;
    char **out_str;
    int mode;
    int pad_34;
} MetaSecSignStage1Args350;

typedef struct MetaSecSignStage2Args350 {
    unsigned int seed;
    unsigned int pad_04;
    char **out_ptr;
    char **out_str;
} MetaSecSignStage2Args350;

typedef struct MetaSecManagedCallArg350 {
    __int64 seed_or_handle;
    JSON_LIST *json_list;
    MEM_BLOCK *x_ss_stub;
    MEM_BLOCK *url_or_path;
    MEM_BLOCK *aux_ref_mem;
    MEM_BLOCK *token_or_env_block;
    void *bd_client_key_item;
    void *bd_client_key_value;
    int request_type;
    int pad_44;
    char **out_key;
    char **out_value;
    int metasec_mode;
    unsigned char final_flag;
    unsigned char pad_5d[3];
} MetaSecManagedCallArg350;

typedef struct MetaSecXArgusProtoWire92_350 {
    unsigned char wire[0x92];
} MetaSecXArgusProtoWire92_350;

typedef struct MetaSecXMedusaFinalPack2C8_350 {
    unsigned char mutated_mini[0x14];
    unsigned char fixed_pair[0x02];
    unsigned char zero_byte;
    unsigned char one_byte;
    unsigned char marker_byte;
    unsigned char mutated_subpack[0x2af];
} MetaSecXMedusaFinalPack2C8_350;

typedef struct MetaSecArgusTailPack24_350 {
    unsigned char digest_or_material20[0x20];
    unsigned char dyn4[0x04];
} MetaSecArgusTailPack24_350;

typedef struct MetaSecArgusTailPack44_350 {
    MetaSecArgusTailPack24_350 head24;
    unsigned char digest_or_material20[0x20];
} MetaSecArgusTailPack44_350;

typedef struct MetaSecSimon128256Schedule350 {
    unsigned __int64 round_key[72];
} MetaSecSimon128256Schedule350;

typedef struct MetaSecArgusTailSimonPlain92_350 {
    unsigned char xargus_struct_wire[0x92];
} MetaSecArgusTailSimonPlain92_350;

typedef struct MetaSecArgusTailSimonOutA0_350 {
    unsigned char simon128_256_pkcs7_out[0xa0];
} MetaSecArgusTailSimonOutA0_350;

typedef struct MetaSecArgusTailBodyB1_350 {
    unsigned char prefix1;
    unsigned char prefix8[0x08];
    unsigned char const8_or_count[0x08];
    unsigned char transformA0[0xa0];
} MetaSecArgusTailBodyB1_350;

typedef struct MetaSecArgusTailBodyB3_350 {
    MetaSecArgusTailBodyB1_350 body_b1;
    unsigned char suffix2[0x02];
} MetaSecArgusTailBodyB3_350;

typedef struct MetaSecAesModeDesc350 {
    unsigned int type;
    unsigned int flags_or_reserved;
    unsigned __int64 reserved_08;
} MetaSecAesModeDesc350;

typedef struct MetaSecCf43ModeInitArgs350 {
    MetaSecAesModeDesc350 *mode_desc;
    MEM_BLOCK *key16;
    MEM_BLOCK *iv16_or_side;
} MetaSecCf43ModeInitArgs350;

typedef struct MetaSecAesModeCtx350 {
    unsigned char aes_round_context[0x1e8];
    unsigned char cbc_chain_or_iv[0x10];
    unsigned char mode_tail[0x18];
} MetaSecAesModeCtx350;

typedef struct MetaSecArgusFinalPackC2_350 {
    unsigned char prefix2[0x02];
    unsigned char outC0[0xc0];
} MetaSecArgusFinalPackC2_350;

typedef struct MetaSecManagedShortCallArg350 {
    __int64 seed_or_handle;
    MEM_BLOCK *derived_block;
    JSON_LIST *json_list;
    MEM_BLOCK *stack_memblock;
    char **out_key;
    char **out_value;
} MetaSecManagedShortCallArg350;

typedef struct MetaSecShortHeaderPack36_350 {
    unsigned char prefix4[4];
    unsigned char transform32[32];
} MetaSecShortHeaderPack36_350;

typedef union ManagedFrameSlots350 {
    unsigned __int64 slot[80];
    struct {
        unsigned __int64 slot_00_28[29];
        void *value_stack_top;
        unsigned __int64 slot_30;
        __int64 exec_status;
        unsigned __int64 slot_32_79[48];
    } view;
} ManagedFrameSlots350;

typedef struct ManagedFrameBuffer350 {
    unsigned char value_stack[0x8000];
    unsigned char gap_8000[0x100];
    ManagedFrameSlots350 slots;
} ManagedFrameBuffer350;

typedef struct ManagedFrame350 {
    int status;
    int pad_04;
    void *interp_saved;
    ManagedFrameBuffer350 *buf;
} ManagedFrame350;

typedef struct ManagedProgramBody350 {
    int entry_or_flags;
    int stack_need;
    void *code_begin;
    void *code_end;
} ManagedProgramBody350;

typedef struct ManagedProgram350 {
    __int64 kind;
    void *native_entry_or_body;
    void *field_10;
    void *field_18;
    void *field_20;
    ManagedProgramBody350 *bytecode_body;
} ManagedProgram350;

typedef struct ManagedNativeBinding350 {
    void *name_or_sso_key;
    void *callback;
    unsigned char flags;
    unsigned char pad_11[0x07];
} ManagedNativeBinding350;

typedef struct ManagedModule350 {
    ManagedProgram350 **programs;
    unsigned __int64 field_08;
    unsigned __int64 field_10;
    unsigned __int64 field_18;
    unsigned char program_index_map[1];
} ManagedModule350;

typedef struct MetaSecRegistryEntry350 {
    int *type_ptr;
    void *payload;
} MetaSecRegistryEntry350;

typedef struct MetaSecOp2Object350 {
    void *ops;
    unsigned char pad_008[0x58];
    MetaSecSharedRef350 current_ref;
    unsigned char pad_070[0x08];
    void *rwlock_holder;
    unsigned char busy;
    unsigned char pad_081[0x07];
} MetaSecOp2Object350;

typedef struct MetaSecCtx350 {
    void *ops;
    COOKIE_RISK_ITEMS *registry;
    MetaSecNode350 *msdata_node;
    MetaSecNode350 *node_018;
    MetaSecNode350 *aid_node;
    MetaSecNode350 *node_028;
    MetaSecNode350 *node_030;
    MetaSecNode350 *node_038;
    unsigned char pad_040[0x1a0];
    COOKIE_RISK2 op2;
    unsigned char pad_268[0x158];
    unsigned char env_tlv_scratch_3c0[0xa0];
    unsigned char transform_out_460[0xa0];
} MetaSecCtx350;

typedef struct MetaSecHttpInnerArgPack350 {
    REF_TREE_MAP tree_map;   /* +0x00: passed as X5 */
    REF_MEM_BLOCK x_ss_stub; /* +0x10: passed as X3 */
    REF_MEM_BLOCK url;       /* +0x20: passed as X2 */
    REF_JSON_LIST json_list; /* +0x30: passed as X1 */
} MetaSecHttpInnerArgPack350;

typedef MetaSecHttpInnerArgPack350 MetaSecArgWindow350; /* legacy alias */
"""

FUNCTION_TYPES = [
    (
        0x4CC10,
        "void __fastcall exeVMInner_350(unsigned int *vmCode, unsigned __int64 param_window, unsigned int *vmData1, unsigned int *vmData2, VmParam64_350 *vmParam)",
    ),
    (
        0x124DD4,
        "void __usercall nativeVmpBuildMssdkMaterial_350(REF_MEM_BLOCK *block_a@<X0>, REF_MEM_BLOCK *block_b@<X1>, void *extra_ref@<X2>, REF_OBJ *out_ref@<X8>)",
    ),
    (
        0x12564C,
        "int __fastcall selectValueFromNativeVmpMaterial_350(REF_MEM_BLOCK *dst, void *source_struct, MEM_BLOCK *selector_key, void *extra_ref)",
    ),
    (
        0x149CA8,
        "__int64 __fastcall buildSignedHttpHeadersInner_350(MetaSecCtx350 *ctx, REF_JSON_LIST *json_list, REF_MEM_BLOCK *url, REF_MEM_BLOCK *x_ss_stub, int type, REF_TREE_MAP *tree_map)",
    ),
    (
        0x14DBF4,
        "__int64 __fastcall buildSignedHttpHeadersCallback_350(const char *url, const char *headers_crlf)",
    ),
    (
        0x1261B0,
        "void *__fastcall registry_find_type_350(COOKIE_RISK_ITEMS *registry, int type)",
    ),
    (
        0x11FBDC,
        "TREE_KV *__fastcall newTreeKV_350(void *key, void *value)",
    ),
    (
        0x11FC30,
        "__int64 __fastcall treeMapPut_350(TREE_MAP *map, void *key, void *value)",
    ),
    (
        0x14EF30,
        "__int64 __fastcall parseCrlfPairsToTree_350(TREE_MAP **out_tree, const char *text)",
    ),
    (
        0x14F22C,
        "__int64 __fastcall parseCrlfPairsToTree2_350(TREE_MAP **out_tree, const char *text)",
    ),
    (
        0x14F098,
        "char *__fastcall treeMapToCrlfString_350(void *unused, TREE_MAP **tree)",
    ),
    (
        0x14F394,
        "char *__fastcall treeMapToCrlfString2_350(void *unused, TREE_MAP **tree)",
    ),
    (
        0x139AB0,
        "__int64 __fastcall formatAllocString_350(char **out, const char *fmt, ...)",
    ),
    (
        0x154328,
        "ManagedModule350 *__fastcall managedModuleBuild_350(void *encoded_blob, unsigned int encoded_size, void *scratch, unsigned int scratch_flags, ManagedNativeBinding350 *cf_table, unsigned int cf_count, ManagedNativeBinding350 *g_table, unsigned int g_count, void *decode_key)",
    ),
    (
        0x154364,
        "ManagedProgram350 *__fastcall managedModuleFindProgram_350(ManagedModule350 *module, const char *program_name)",
    ),
    (
        0x14CEBC,
        "ManagedProgram350 *__fastcall initManagedHttpModule_350(void)",
    ),
    (
        0x14D130,
        "__int64 __usercall managedHttpF0Wrapper_350@<X0>(unsigned __int64 arg1@<X0>, unsigned int type_or_flag@<W1>, unsigned __int64 scratch_or_arg0@<X8>)",
    ),
    (
        0x14D1D8,
        "__int64 __usercall managedHttpF1Wrapper_350@<X0>(unsigned int type_or_flag@<W0>, unsigned __int64 scratch_or_arg0@<X8>)",
    ),
    (
        0x14D264,
        "MEM_BLOCK *__fastcall newMemBlock24_350(void)",
    ),
    (
        0x14D284,
        "MEM_BLOCK *__fastcall newMemBlock24_loadOutputMapX22_350(void)",
    ),
    (
        0x14D2B8,
        "MetaSecManagedShortCallArg350 *__fastcall prepareManagedSignPackTail_350(void)",
    ),
    (
        0x14D2E8,
        "MEM_BLOCK *__fastcall copyOutValueStringToX28MemBlock_350(MEM_BLOCK *value_block)",
    ),
    (
        0x14D2F4,
        "MEM_BLOCK *__fastcall copyOutKeyStringToX27MemBlock_350(MEM_BLOCK *key_block)",
    ),
    (
        0x14D290,
        "TREE_KV *__usercall treeMapPut_X22_X27_X28_350@<X0>(TREE_MAP *map@<X22>, void *key@<X27>, void *value@<X28>)",
    ),
    (
        0x14D300,
        "TREE_KV *__usercall treeMapPut_X22_X23_X24_350@<X0>(TREE_MAP *map@<X22>, void *key@<X23>, void *value@<X24>)",
    ),
    (
        0x120E00,
        "TREE_KV *__fastcall treeMapPutDoubleValue_350(TREE_MAP *map, MEM_BLOCK *key, double value)",
    ),
    (
        0x1545A8,
        "ManagedFrame350 *__fastcall managedFrameAcquire_350(ManagedFrame350 *frame)",
    ),
    (
        0x154648,
        "void __fastcall managedFrameRelease_350(ManagedFrame350 *frame)",
    ),
    (
        0x1547C0,
        "unsigned __int64 __fastcall managedFrameGetSlot_350(ManagedFrame350 *frame, int slot)",
    ),
    (
        0x1547D4,
        "ManagedFrame350 *__fastcall managedFrameSetSlot_350(ManagedFrame350 *frame, int slot, unsigned __int64 value)",
    ),
    (
        0x154454,
        "void __fastcall managedProgramInvoke_350(ManagedProgram350 *program, ManagedFrame350 *frame)",
    ),
    (
        0x154468,
        "void __fastcall managedProgramInvokeCore_350(ManagedProgram350 *program, ManagedFrame350 *frame)",
    ),
    (
        0x1555A4,
        "void __fastcall managedBytecodeRun_350(ManagedProgramBody350 *body, ManagedFrame350 *frame)",
    ),
    (
        0x15485C,
        "void *__fastcall managedStringIndexMapFind_350(void *inline_map, void *sso_key, void *sentinel, void *out_key, void *scratch)",
    ),
    (
        0x158F48,
        "void __usercall managedModuleDecodeBuild_350(void *encoded_blob@<X0>, unsigned __int64 encoded_size@<X1>, void *scratch@<X2>, unsigned int scratch_flags@<W3>, ManagedNativeBinding350 *cf_table@<X4>, unsigned int cf_count@<W5>, ManagedNativeBinding350 *g_table@<X6>, unsigned int g_count@<W7>, ManagedModule350 **out_module@<X8>, void *decode_key)",
    ),
    (
        0x16D520,
        "int __fastcall sm3OneShot_F15InitUpdateFinal_350(const void *input, unsigned int input_len, unsigned char out_digest32[32])",
    ),
    (
        0x16D5A0,
        "int __fastcall sm3Update_64byteBlocks_350(void *sm3_state, const void *input, unsigned int input_len)",
    ),
    (
        0x16D680,
        "int __fastcall sm3Final_padLenEmit32_350(void *sm3_state, unsigned char out_digest32[32])",
    ),
    (
        0x16D86C,
        "void __fastcall sm3Compress_flattenedBlocks_350(void *sm3_state, const unsigned char block64[64])",
    ),
    (
        0x16F43C,
        "unsigned __int64 __fastcall cf41_argusTailSimon128256_slot4_input_slot5_out_slot6_key_350(ManagedFrame350 *frame)",
    ),
    (
        0x16CB88,
        "void __fastcall cf41_argusTailSimon128256_inner_350(MEM_BLOCK *input, MEM_BLOCK *out, MEM_BLOCK *key_material)",
    ),
    (
        0x16E538,
        "void __fastcall cf41_simon128_256_pkcs7_encrypt_16E538_350(const unsigned char *input, unsigned int input_len, unsigned char **out_ptr, unsigned int *out_len, const unsigned char key32[32])",
    ),
    (
        0x16E678,
        "void __fastcall cf41_simon128_256_expandKey_16E678_350(const unsigned char key32[32], unsigned char round_keys_72x8[0x240])",
    ),
    (
        0x16F48C,
        "unsigned __int64 __fastcall cf42_makeU16MemBlockLE_slot4_out_slot5_low16_350(ManagedFrame350 *frame)",
    ),
    (
        0x16CC84,
        "void __usercall makeU16MemBlockLE_16CC84_350(unsigned int value@<W0>, MEM_BLOCK *out@<X8>)",
    ),
    (
        0x16F4C4,
        "unsigned __int64 __fastcall cf43_argusTailAesModePkcs7Transform_slot4_out_slot5_body_slot6_key16_350(ManagedFrame350 *frame)",
    ),
    (
        0x16FD64,
        "unsigned __int64 __fastcall cf79_jsonAddNumber_slot4_json_slot5_key_slot2_double_350(ManagedFrame350 *frame)",
    ),
    (
        0x11BF94,
        "void __usercall cf43_argusTailAesModePkcs7Transform_inner_350(MEM_BLOCK *body@<X0>, MEM_BLOCK *key16@<X1>, MEM_BLOCK *iv_or_side@<X2>, void *mode_desc@<X3>, MEM_BLOCK *out@<X8>)",
    ),
    (
        0x11CAE0,
        "__int64 __fastcall cf43_modeInitDispatcher_350(void *mode_desc, void *mode_ctx)",
    ),
    (
        0x11CBB4,
        "__int64 __fastcall cf43_modeProcessDispatcher_350(void *mode_desc, void *mode_ctx, void *input, void *output, unsigned int len)",
    ),
    (
        0x106230,
        "void __fastcall aesCbcInit_350(void *ctx, const unsigned char *key, unsigned int key_len, const unsigned char *iv)",
    ),
    (
        0x10569C,
        "int __fastcall aesSetEncryptKey_350(void *ctx, const unsigned char *key, unsigned int key_len)",
    ),
    (
        0x105AF0,
        "void __fastcall aesEncryptBlock_350(const unsigned char input16[16], unsigned char output16[16], void *ctx)",
    ),
    (
        0x105E54,
        "void __fastcall aesDecryptBlock_350(const unsigned char input16[16], unsigned char output16[16], void *ctx)",
    ),
    (
        0x1062A8,
        "void __fastcall aesCbcEncrypt_350(void *ctx, const unsigned char *input, unsigned char *output, unsigned int len)",
    ),
    (
        0x106458,
        "void __fastcall aesCtrInit_350(void *ctx, const unsigned char *key, unsigned int key_len, const unsigned char *nonce_or_side)",
    ),
    (
        0x1064D0,
        "void __fastcall aesCtrProcess_350(void *ctx, const unsigned char *input, unsigned char *output, unsigned int len)",
    ),
    (
        0x10667C,
        "void __fastcall aesFeedbackInit_350(void *ctx, const unsigned char *key, unsigned int key_len, const unsigned char *side)",
    ),
    (
        0x1066F4,
        "void __fastcall aesFeedbackProcess_350(void *ctx, const unsigned char *input, unsigned char *output, unsigned int len)",
    ),
    (
        0x16CCD8,
        "unsigned __int64 __fastcall shortHeaderTransform32_flattened_CF48_350(MEM_BLOCK *formatted_text, MEM_BLOCK *out_transform32, MEM_BLOCK *key_material32)",
    ),
    (
        0x16E794,
        "unsigned __int64 __fastcall cf48_transformTextWithF17Blocks_350(const unsigned char *text, unsigned int text_len, unsigned char **out_ptr, unsigned int *out_len, const unsigned char key32[32])",
    ),
    (
        0x16E8FC,
        "void __fastcall cf48_seedScheduleARX_16E8FC_350(const unsigned char key32[32], unsigned __int64 schedule35[35])",
    ),
    (
        0x16F660,
        "unsigned __int64 __fastcall cf48_shortHeaderTransform32_slot4_text_slot5_out_slot6_key_350(ManagedFrame350 *frame)",
    ),
    (
        0x16F6B0,
        "unsigned __int64 __fastcall cf49_buildShortHeaderPack36_slot4_prefix_slot5_xform_ret2_350(ManagedFrame350 *frame)",
    ),
    (
        0x17184C,
        "void __fastcall managedSignBlockTransformF17_350(const unsigned __int64 schedule34[34], const unsigned char input16[16], unsigned char output16[16])",
    ),
    (
        0x47C1C,
        "MetaSecSharedRef350 *__fastcall setObjectAddRef_5(MetaSecSharedRef350 *dst, void *obj)",
    ),
    (
        0x4ABD4,
        "void __fastcall shared_ref_release_350(MetaSecSharedRef350 *ref)",
    ),
    (
        0x73FD8,
        "__int64 __fastcall op2_fill_locked_350(COOKIE_RISK2 *op2, REF_OBJ *out_ref)",
    ),
    (
        0x16D204,
        "__int64 __fastcall signStage1_makeStubPieces_350(MetaSecSignStage1Args350 *args)",
    ),
    (
        0x16D454,
        "__int64 __fastcall signStage2_makeKeyPieces_350(MetaSecSignStage2Args350 *args)",
    ),
    (
        0x16F998,
        "unsigned __int64 __fastcall cf61_sm3Digest_slot4_input_slot5_len_slot6_out32_350(ManagedFrame350 *frame)",
    ),
    (
        0x1702B8,
        "ManagedProgram350 *__fastcall initManagedSignModuleLarge_350(void)",
    ),
    (
        0x17157C,
        "__int64 __fastcall managedSignBuildF4Flag_350(unsigned __int8 flag)",
    ),
    (
        0x1715F8,
        "__int64 __fastcall managedSignBuildA_350(MetaSecManagedCallArg350 *arg_pack)",
    ),
    (
        0x171648,
        "__int64 __fastcall managedSignBuildB_350(MetaSecManagedShortCallArg350 *arg_pack)",
    ),
    (
        0x171698,
        "__int64 __fastcall managedSignBuildFinal_350(MetaSecManagedCallArg350 *arg_pack)",
    ),
    (
        0x1716F4,
        "__int64 __fastcall managedSignPostEmitF13_350(MetaSecManagedShortCallArg350 *arg_pack)",
    ),
    (
        0x1719F0,
        "unsigned __int64 __fastcall managedFrameGetReturnSlot2_350(ManagedFrame350 *frame)",
    ),
]

GLOBAL_TYPES = [
    (0x2C4D40, "g_managedModule_http_350", "ManagedModule350 *"),
    (0x2C4D48, "g_managedProg_http_F0_350", "ManagedProgram350 *"),
    (0x2C4D50, "g_managedProg_http_F1_350", "ManagedProgram350 *"),
    (0x2C58C8, "g_managedModule_sign_350", "ManagedModule350 *"),
]

for _managed_prog_idx in range(55):
    GLOBAL_TYPES.append(
        (
            0x2C58D0 + 8 * _managed_prog_idx,
            f"g_managedProg_sign_F{_managed_prog_idx}_350",
            "ManagedProgram350 *",
        )
    )

STATIC_COMMENTS = {
    0x4CC10: "[native-vmp350] exeVMInner_350: outer MetaSec native VM interpreter. X0=vmCode, X1=wrapper argument window, X2/X3=VM data pages, X4=VmParam64_350. Business meaning comes from the vmCode selected by the wrapper.\n【中文】外层 native VMP 解释器：X0 是 VM 程序入口/字节码地址，X1 是 wrapper 组好的参数窗口，X2/X3 是 VM 数据区，X4 是 VM 控制块；真正业务语义要看 wrapper 传进来的 vmCode。",
    0x124DD4: "[native-vmp350] nativeVmpBuildMssdkMaterial_350 wrapper. It builds a stack parameter window and calls exeVMInner_350 with vmCode=0x1F7860; result is returned through the caller out-ref.\n【中文】native VMP wrapper：把 out-ref、两个 MEM_BLOCK、extra ref 组进栈上参数窗口，然后以 vmCode=0x1F7860 调用 exeVMInner_350；VM 返回的是 ref-counted mssdk material 对象。",
    0x124E14: "[native-vmp350] vmCode selection for nativeVmpBuildMssdkMaterial_350: X0=base+0x1F7860, X1=SP parameter window, X2=0x26F2E0, X3=0x26F300, X4=VmParam64_350.\n【中文】这里确定 VM 程序号：X0 指向 base+0x1F7860，X1 指向当前栈参数窗口，X2/X3 是两块 VM 数据，X4 是 VmParam64_350；后面进入 exeVMInner_350。",
    0x124E30: "[native-vmp350] wrapper returns after exeVMInner_350; VM has populated the hidden out-ref with NativeVmpResultObject350 -> MetaSecMssdkMaterial350.\n【中文】VM 返回点：hidden out-ref 里已经写入 NativeVmpResultObject350，里面 +0x08 指向 MetaSecMssdkMaterial350。",
    0x12564C: "[native-vmp350] selectValueFromNativeVmpMaterial_350: calls nativeVmpBuildMssdkMaterial_350, opens the returned MetaSecMssdkMaterial350, iterates kv_items, compares selector key with item->key, and copies item->value into dst.\n【中文】VMP material 选择器：先调用 0x124DD4 构造 mssdk material，再遍历 material->kv_items；用传入 key 匹配 common_key/sign_key，命中后把 value 复制进输出 MEM_BLOCK。",
    0x1256AC: "[native-vmp350] return from nativeVmpBuildMssdkMaterial_350 inside selector. Runtime trace shows out-ref.obj -> NativeVmpResultObject350, result->material -> MetaSecMssdkMaterial350.\n【中文】selector 中从 0x124DD4 返回的位置：真机 trace 证明 out-ref.obj 指向 NativeVmpResultObject350，result->material 指向 0x70 字节的 MetaSecMssdkMaterial350。",
    0x129B24: "[native-vmp350] tiny bridge thunk that forwards into selectValueFromNativeVmpMaterial_350; seen on the 0x16F2DC -> 0x12564C -> 0x124DD4 -> 0x4CC10 call chain.\n【中文】很薄的桥接 thunk，最终转到 selectValueFromNativeVmpMaterial_350；在 0x16F2DC -> 0x12564C -> 0x124DD4 -> 0x4CC10 调用链上出现。",
    0x16F998: "[cf61-sm3] CF61 wrapper: slot4=input pointer, slot5=input length, slot6=out32; calls sm3OneShot_F15InitUpdateFinal_350 and writes slot2=0.\n【中文】CF61 的 managed slot 适配层：slot4 是输入指针，slot5 是长度，slot6 是 32 字节输出；下层已由 raw vector 证明是标准 SM3。",
    0x16D520: "[cf61-sm3] SM3 one-shot wrapper: F15 initializes standard SM3 IV, then update/final emits a 32-byte big-endian digest.\n【中文】SM3 一次性封装：先调用 F15 写入标准 SM3 IV，再 update 分组，最后 final 输出 32 字节大端摘要。",
    0x171794: "[cf61-sm3] Managed F15 digest-state initializer. Decoded F15 writes SM3 IV: 7380166f 4914b2b9 172442d7 da8a0600 a96f30bc 163138aa e38dee4d b0fb0e4e.\n【中文】F15 初始化摘要状态：decode 后可见写入标准 SM3 IV，这是 CF61 能命名为 SM3 的关键证据。",
    0x16D5A0: "[cf61-sm3] SM3 update: byte counter at state+0/+4, tail buffer at state+0x28, every 64-byte block calls sm3Compress_flattenedBlocks_350.\n【中文】SM3 update：state+0/+4 是字节计数，state+0x28 是 64 字节尾块缓存，每满一块调用 0x16D86C 压缩。",
    0x16D680: "[cf61-sm3] SM3 final: appends 0x80 padding, big-endian bit length, then emits eight state words as a 32-byte big-endian digest.\n【中文】SM3 final：补 0x80 和长度，最后把 8 个 state word 按大端输出为 32 字节。",
    0x16D86C: "[cf61-sm3] SM3 compression entry. The body is flattened through shared table 0x29F420, but 5/5 raw CF61 vectors match standard SM3.\n【中文】SM3 压缩入口：函数体被 0x29F420 共享跳表平坦化；虽然 IDA 只看到间接跳转，但 raw 输入输出 5/5 对上标准 SM3。",
    0x16F43C: "[cf41-argus-tail] CF41 wrapper: slot4=input XArgusStruct wire MEM_BLOCK, slot5=output MEM_BLOCK, slot6=key/material MEM_BLOCK; calls 0x16CB88 and implements Argus-tail SIMON128/256.\n【中文】CF41 slot 适配层：slot4 是 XArgusStruct protobuf 明文块，slot5 是输出块，slot6 是 key/material；下层会把 key 补到 32 字节，然后走 SIMON128/256 分组变换。",
    0x16CB88: "[cf41-argus-tail] Clones slot6 key/material, pads it to 32 bytes when shorter, then calls 0x16E538(input.body,input.len,&tmp_out,&tmp_len,key32).\n【中文】CF41 内层：先 clone slot6，不足 32 字节补零/补齐，再用输入 MEM_BLOCK 和 key32 调 0x16E538 生成 SIMON 输出。",
    0x16E538: "[cf41-argus-tail] SIMON128/256 encrypt wrapper. Builds 0x240 bytes of round keys, PKCS#7-pads input to 16-byte alignment, then invokes managed F16 wrapper 0x1717F4 per block.\n【中文】CF41 分组核心：创建 0x240 字节 round key，输入按 PKCS#7 补齐到 16 字节，然后每块调用 F16；runtime oracle 已验证输出完全一致。",
    0x16E678: "[cf41-argus-tail] SIMON128/256 key schedule. Constant z=0x3dc94c3a046d678b; emits 72 little-endian u64 round keys (0x240 bytes).\n【中文】CF41 key schedule：SIMON128/256 的 72 个 64-bit round key，z 常量为 0x3dc94c3a046d678b；和 F16 round 配合后 byte-exact 对上。",
    0x16F48C: "[cf42-argus-tail] CF42 wrapper: hidden out=slot4, value=slot5; calls 0x16CC84 to emit low16(value) as a 2-byte little-endian MEM_BLOCK.\n【中文】CF42 slot 适配层：slot4 通过 X8 作为输出，slot5 取低 16 位；输出就是 2 字节小端 MEM_BLOCK。",
    0x16CC84: "[cf42-argus-tail] Exact u16 pack helper: strh w0 to stack, then initMemBlockBySrc(out,&u16,2). F5 samples: 0x6f80 -> 80 6f; 0x6f80e11b -> 1b e1.\n【中文】精确还原：把 W0 低 16 位写到栈上，再包装为长度 2 的 MEM_BLOCK；不是复杂 transform。",
    0x16F4C4: "[cf43-argus-tail] CF43 wrapper: hidden out=slot4, body=slot5, 16-byte material=slot6, side=slot7, modeDesc=slot8; calls flattened 0x11BF94.\n【中文】CF43 slot 适配层：slot5 是 0xb3 body，slot6 是 16 字节材料，slot7/slot8 是 side/mode 描述；进入 0x11BF94 做尾部块变换。",
    0x16FD64: "[cf79-medusa-json] JSON number writer used in F8/X-Medusa phase. slot4 is the JSON/env receiver, slot5 is key cstr, slot2 must be read as managed double bits. Current keys: cmr, cmr2, un_h, vpn, kd, fkd, pd, do.\n【中文】Medusa 环境 JSON 数字写入点：slot4 是 JSON/env 对象，slot5 是 key 字符串，slot2 要按 managed double slot 读；这些字段不会以明文 u32/u64/double 直接出现在 final 0x2c8 包里。",
    0x11BF94: "[cf43-argus-tail] Flattened AES mode transform. It checks cloned slot6 length == 0x10, PKCS#7-pads current F5 body 0xb3 -> 0xc0, initializes mode via 0x11CAE0, processes via 0x11CBB4. Current sample modeDesc[0].type=1, verified as AES-128-CBC.\n【中文】CF43 内层：平坦化很重，但关键形状清楚——检查 16 字节材料，0xb3 按 PKCS#7 补到 0xc0，再走 AES mode init/process。当前样本 mode type=1，已用 OpenSSL/自写 oracle 验证为 AES-128-CBC。",
    0x11CAE0: "[cf43-argus-tail] Mode-init dispatcher. Reads modeDesc[0].type; current F5 type=1 reaches 0x106230 AES-CBC init.\n【中文】CF43 mode 初始化分发：读取 modeDesc[0].type；当前 F5 样本 type=1，落到 0x106230 AES-CBC 初始化。",
    0x11CBB4: "[cf43-argus-tail] Mode-process dispatcher. Reads modeDesc[0].type; current F5 type=1 reaches 0x1062A8 AES-CBC encrypt. Probe shows x2==x3, len=0xc0, so processing is in-place.\n【中文】CF43 mode 处理分发：读取 modeDesc[0].type；当前 F5 样本 type=1，落到 0x1062A8 AES-CBC 加密。探针显示 x2==x3 且 len=0xc0，是原地处理。",
    0x11C8D8: "[cf43-argus-tail] Return point after mode process inside 0x11BF94. saved_x2_after equals next CF30 slot6/outC0; final CF44 input is prefix2 || this buffer.\n【中文】CF43 mode_process 返回后的路标：这里 dump 到的 saved_x2_after 等于下一次 CF30 的 slot6/outC0，最终 CF44 输入就是 prefix2 拼上它。",
    0x10569C: "[cf43-argus-tail] AES key schedule. Static branches accept key lengths 16/24/32 and fill round-key context.\n【中文】AES key schedule：静态能看到 16/24/32 字节 key 长度分支和 round-key 填充。",
    0x105AF0: "[cf43-argus-tail] AES encrypt block using T-table/S-box style lookups.\n【中文】AES 单块加密：T-table/S-box 风格查表，供 CF43 mode process 调用。",
    0x105E54: "[cf43-argus-tail] AES decrypt block sibling of the encrypt path.\n【中文】AES 单块解密：与 encrypt path 配套的反向块处理。",
    0x106230: "[cf43-argus-tail] AES-CBC init helper reached by current mode type 1; copies key schedule and IV into ctx+0x1e8.\n【中文】AES-CBC 初始化 helper：当前 F5 的 mode type=1 会走这里，把 key schedule 和 IV/side 写入 ctx+0x1e8。",
    0x1062A8: "[cf43-argus-tail] AES-CBC encrypt/process helper reached by current mode type 1. It XORs plaintext with chain, encrypts, stores ciphertext, and updates chain.\n【中文】AES-CBC 加密 helper：当前 F5 的 mode type=1 会走这里；明文块先 xor 链值，再 AES 加密，输出密文并更新链值。",
    0x106458: "[cf43-argus-tail] AES-CTR init helper reached by mode type 2.\n【中文】AES-CTR 初始化 helper：mode type 2 分支会走这里。",
    0x1064D0: "[cf43-argus-tail] AES-CTR stream process helper reached by mode type 2; AES block output is XORed with input and supports partial blocks.\n【中文】AES-CTR 流处理 helper：mode type 2 分支使用 AES block 生成 keystream 再 xor 输入，支持非整块。",
    0x10667C: "[cf43-argus-tail] Feedback/stream init helper reached by mode type 3.\n【中文】反馈/流式模式初始化 helper：mode type 3 分支会走这里。",
    0x1066F4: "[cf43-argus-tail] Feedback/stream process helper reached by mode type 3.\n【中文】反馈/流式模式处理 helper：mode type 3 分支会走这里。",
    0x157EB0: "[managed-runtime] ST64 bytecode handler. In F8/X-Medusa this is the nested F12 writer: 31 qword bit-pack updates to sub-work prefix, all verified by f12_medusa_subpack_recovered_350101.c.\n【中文】managed VM 的 64-bit 写内存 handler；在 X-Medusa 路径里，嵌套 F12 用它写 31 个 qword，把 source byte stream bit-pack 到 sub-work 前 0xf8 字节。",
    0x157EE4: "[managed-runtime] ST8 bytecode handler. In F8/X-Medusa mini-work it executes records 0x0cbc/0x0cc2/0x0cc7/0x0ccd: five 4-byte lanes XOR dynamic key32 from state+0x60, verified by f8_medusa_mini_xor_recovered_350101.c.\n【中文】managed VM 的 8-bit 写内存 handler；在 F8 mini-work 中四个 record 循环 5 轮，把 20 字节按 4-byte lane XOR 同一个动态 key32。",
    0x16F660: "[cf48-short] CF48 wrapper: slot4=formatted text MEM_BLOCK, slot5=out/scratch MEM_BLOCK, slot6=32-byte key material; calls 0x16CCD8.\n【中文】CF48 slot 适配层：slot4 是 CF100 生成的明文，slot5 原先是 prefix/scratch、返回后变成 32 字节 transform，slot6 是 32 字节 ASCII key/material。",
    0x16CCD8: "[cf48-short] Flattened CF48 helper. Non-null slot4 chooses shared dispatch index 0x58, clones/pads key to 32 bytes, then calls 0x16E794(text, len, &out_ptr, &out_len, key32).\n【中文】CF48 下层 helper：slot4 非空走共享跳表 index=0x58；先把 key clone/pad 到 32 字节，再进入 0x16E794 做正文分组变换。",
    0x16CD90: "[cf48-short] Calls cf48_transformTextWithF17Blocks_350(text.mem, text.len, &out_ptr, &out_len, key32.mem).\n【中文】这里进入 CF48 真正的 text+key32 变换；返回后 out_ptr/out_len 会被复制回 slot5 的 MEM_BLOCK。",
    0x16CDE4: "[cf48-short] Rebuilds slot5 MEM_BLOCK with out_len capped/allocated around 0x20, then copies the transformed bytes and frees the temporary buffer.\n【中文】把 0x16E794 返回的 transform bytes 写回 slot5；当前短头样本 out_len=0x20。",
    0x16E794: "[cf48-short] Lower text transform: key32 -> ARX schedule, PKCS#7-like round16 padding, then per-16-byte block calls managed F17 wrapper at 0x17184C.\n【中文】CF48 核心变换：先用 key32 生成 64-bit schedule，再给明文做 16 字节对齐 padding，最后每 16 字节调用 F17 做 34 轮 ARX/Speck-like 变换。",
    0x16E808: "[cf48-short] Calls cf48_seedScheduleARX_16E8FC_350(key32, schedule). The schedule is not the final out32; it is round-key material for F17.\n【中文】生成 F17 round schedule；注意这里产物不是最终 out32，最终还要吃明文分组。",
    0x16E81C: "[cf48-short] Padding byte is pad_len&0xff and padding length is round16(text_len+0x10)-text_len, PKCS#7-like rather than zero padding.\n【中文】padding 字节等于 pad_len，长度也等于 pad_len；这是类 PKCS#7 padding，不是补零。",
    0x16E874: "[cf48-short] Per-block call to managedSignBlockTransformF17_350(schedule, output+off, input+off).\n【中文】逐 16-byte block 调 F17；slot4=schedule，slot5=input16，slot6=output16。",
    0x16E8FC: "[cf48-short] ARX schedule for CF48: copies four qwords from key32, emits state[0], then 34 rounds of nb=(ror64(s1,8)+s0)^i; na=nb^ror64(s0,61).\n【中文】CF48 key schedule：从 key32 拷 4 个 qword，然后 34 轮 64-bit 加/旋转/xor，生成 F17 用的 round keys。",
    0x16E9C8: "[cf48-short] Schedule round core: ror64(state[1],8) + state[0], xor loop counter, then xor ror64(state[0],61).\n【中文】schedule 核心一轮：右转、加法、轮数 xor、再 xor state[0] 右转 61。",
    0x16F6B0: "[cf49-short] CF49 wrapper: slot4=4-byte prefix, slot5=CF48 transform32; returns slot2=prefix4||transform32 (0x24 bytes).\n【中文】CF49 只做拼接：4 字节 prefix + 32 字节 CF48 transform = 0x24 binary pack，随后 CF44 base64 成 X-Ladon/X-Helios。",
    0x17184C: "[cf48-short] Managed F17 block-transform wrapper. It invokes g_managedProg_sign_F17_350 with slot4=schedule, slot5=input16, slot6=output16.\n【中文】F17 block transform 包装：真正的 34 轮逻辑在 managed bytecode F17 里；CF48 的 0x16E794 每个 16 字节块都会调用这里。",
    0x1719B0: "[cf48-short] Computes padded_len=((text_len+0x10)/0x10)<<4 and pad_len=padded_len-text_len before creating padding MEM_BLOCK.\n【中文】计算 CF48 明文 padding 长度；当前短头 text_len=0x1a，所以 padded_len=0x20、pad_len=6。",
    0x149C20: "[flow350] locked shared-ref copy helper: dst={obj,refcnt}=src and increments refcnt under lock.\n【中文】带锁拷贝 shared-ref：把 src 的 obj/refcnt 复制到 dst，并给 refcnt+1。成功出口用它把最终 TREE_MAP 返回给 hidden X8/out。",
    0x149CA8: "[flow350] buildSignedHttpHeadersInner_350: builds signed HTTP headers; old 334-aligned name was getHttpHeadVerify @ 0x15AB90.\n【中文】HTTP 签名头构建内层入口；旧名 getHttpHeadVerify 只当 334 对齐锚点。",
    0x14DBF4: "[flow350] buildSignedHttpHeadersCallback_350: public URL/header wrapper before inner signer.\n【中文】HTTP 签名外层入口：接 URL/header 字符串，整理后进入内层签名。",
    0x14DC74: "[flow350] wrapper input-shape test.\n【中文】外层入口先判断 url/header 是否已经是内部可直接解析的格式；结果决定走直调 dispatcher 还是先拼接 CRLF 文本。",
    0x14DCF8: "[flow350] direct dispatcher path.\n【中文】已是可解析输入时，直接走主 dispatcher：解析 header 文本并进入后续签名构建。",
    0x14DD20: "[flow350] plain input normalization begins.\n【中文】普通输入路径：计算 URL 和 headers 长度，准备拼接 headers + \"\\r\\nURL\\r\\n\" + url。",
    0x14DD48: "[flow350] inserts the internal URL marker.\n【中文】插入 URL 标记分隔符；这是把外部两个字符串转成内部 CRLF key/value 流的关键点。",
    0x14DD5C: "[flow350] normalized CRLF request text enters alternate dispatcher.\n【中文】把拼好的 CRLF 请求文本送入备用 dispatcher，最终返回签名后的 header 字符串。",
    0x149D50: "[flow350] allocates the output/intermediate TREE_MAPs.\n【中文】内层入口初始化两个 TREE_MAP：一个用于最终输出 X-* header，一个用于中间参数/临时 header。",
    0x149DB4: "[flow350] guard: json_list missing -> F1(-1).\n【中文】入参校验：json_list 为空走 F1 错误出口，错误码 -1。",
    0x149DC4: "[flow350] guard: url MEM_BLOCK/body missing -> F1(-5).\n【中文】入参校验：url MEM_BLOCK 或 url->body.mem 为空走 F1 错误出口，错误码 -5。",
    0x149DCC: "[flow350] guard: x-ss-stub missing -> F1(-6).\n【中文】入参校验：x-ss-stub 缺失走 F1 错误出口，错误码 -6。",
    0x149DE8: "[flow350] URL/business domain legality check.\n【中文】URL/业务域名合法性检查之一；两轮检查都不过会走 F1(-7)。",
    0x149E60: "[flow350] common error writer.\n【中文】统一错误出口：调用 managedHttpF1Wrapper_350，把错误码写入 hidden X8 输出。",
    0x149EB4: "[flow350] timer/sampling state.\n【中文】计时/节流逻辑入口：按全局计数 qword_27EDF8 决定是否采样当前毫秒时间和刷新 phone/env 状态。",
    0x149F78: "[flow350] extracts URL query/path pieces.\n【中文】从 URL 中找 '?' 和 '#'，后面会抽取 query/path 片段作为签名输入之一。",
    0x14A0CC: "[struct-recovery] registry lookup type=2 returns ctx+0x1e0 on true-device traces.\n【中文】从 ctx->registry 查 type=2 对象；真机 trace 证明返回的是 ctx+0x1e0，也就是 COOKIE_RISK2/op2。",
    0x14A128: "[flow350] reads x-metasec-mode from request TreeMap.\n【中文】从 header TreeMap 取 x-metasec-mode，转成整数后影响后续签名分支/mode。",
    0x14A164: "[flow350] creates a derived MEM_BLOCK from URL/query/env.\n【中文】根据 URL/query/env 生成中间 MEM_BLOCK；如果结果为空，后续会走 F1(-8)。",
    0x14A1AC: "[flow350] native sign stage1.\n【中文】签名 stage1：把 url、x-ss-stub、short_code、mode 等打包，生成第一组 stub/key 片段。",
    0x14A1C0: "[x-header350] origin writes X-Gorgon through treeMapPut_X22_X27_X28_350. Runtime evidence: key=X-Gorgon, value len=0x34.\n【中文】写 X-Gorgon：通过 treeMapPut_X22_X27_X28_350 这个 wrapper 写入输出 tree；unidbg origin-aware probe 证明 key/value。",
    0x14A1FC: "[flow350] native sign stage2.\n【中文】签名 stage2：继续扩展/变换 stage1 输出，准备 managed sign 的输入 key/material。",
    0x14A210: "[x-header350] origin writes X-Khronos through treeMapPut_X22_X27_X28_350. Runtime evidence: key=X-Khronos, value len=0x0A.\n【中文】写 X-Khronos：通过 treeMapPut_X22_X27_X28_350 写入，value 是 10 字节时间戳字符串。",
    0x14A2B0: "[x-header350] treeMapPut inserts X-Argus. True-device trace: X1 key MEM_BLOCK decodes to \"X-Argus\", X2 is the generated Argus value.\n【中文】插入 X-Argus：真机 trace 证明 x1 是 key=\"X-Argus\" 的 MEM_BLOCK，x2 是生成出来的 Argus 值。这里属于前段 native/stage2 后的快速 header 输出分支。",
    0x14A320: "[x-header350] treeMapPut inserts X-Ladon. True-device trace: X1 key MEM_BLOCK decodes to \"X-Ladon\", X2 is the generated Ladon value.\n【中文】插入 X-Ladon：真机 trace 证明 x1 是 key=\"X-Ladon\" 的 MEM_BLOCK，x2 是生成出来的 Ladon 值。",
    0x14A348: "[x-header350] managed-sign branch starts after the early direct Argus/Ladon branch is skipped.\n【中文】managed 签名分支入口：当前 unidbg 350.101 就走这里，后面通过 F5/F7/F8 生成 Argus/Ladon/Medusa。",
    0x14A358: "[x-header350] F5 pack begins: load json_list->json_list for MetaSecManagedCallArg350+0x08.\n【中文】F5 参数包开始：读取 json_list->json_list，稍后写入 MetaSecManagedCallArg350+0x08。",
    0x14A364: "[x-header350] F5 pack +0x30/+0x38: runtime header-key query result/pair, used by managed program side.\n【中文】F5 参数包 +0x30/+0x38：运行时 header-key 查询相关对象，供 managed 程序侧读取。",
    0x14A374: "[x-header350] F5 pack common fill: +0 seed, +8 json_list, +0x10 x-ss-stub MEM_BLOCK, +0x18 URL/query MEM_BLOCK.\n【中文】F5 参数包公共字段：+0 seed，+8 JSON_LIST，+0x10 x-ss-stub，+0x18 URL/query 派生 MEM_BLOCK。",
    0x14A378: "[x-header350] F5 pack +0x20/+0x28: aux ref MEM_BLOCK and op2/env token block.\n【中文】F5 参数包 +0x20/+0x28：辅助 ref MEM_BLOCK 与 op2/env token 相关 MEM_BLOCK。",
    0x14A380: "[x-header350] F5 pack +0x48/+0x50: output char** slots (&ptr/&s). F5 writes key/value strings here.\n【中文】F5 参数包 +0x48/+0x50：输出 char** 槽（&ptr/&s），F5 会把生成的 key/value 字符串写到这里。",
    0x14A388: "[x-header350] F5 pack +0x58 metasec_mode from parsed x-metasec-mode.\n【中文】F5 参数包 +0x58：来自 x-metasec-mode 的模式值。",
    0x14A38C: "[flow350] managed sign A.\n【中文】managed sign A 路径：把 json_list、mode、stage 输出等塞进 managed frame slot 后执行程序。",
    0x14A3A0: "[x-header350] origin writes X-Argus through treeMapPut_X22_X27_X28_350. Runtime evidence: key=X-Argus, value len=0x104.\n【中文】写 X-Argus：managed sign A/F5 后通过 wrapper 写入输出 tree；unidbg origin=0x14A3A0。",
    0x14A3EC: "[flow350] managed sign B.\n【中文】managed sign B 路径：第二段 managed 程序，继续产出后续 header/sign 材料。",
    0x14A400: "[x-header350] origin writes X-Ladon through treeMapPut_X22_X27_X28_350. Runtime evidence: key=X-Ladon, value len=0x30.\n【中文】写 X-Ladon：managed sign B/F7 后通过 wrapper 写入输出 tree；unidbg origin=0x14A400。",
    0x14A468: "[flow350] CRC/update-setting checkpoint.\n【中文】对中间 tree/参数做 CRC32，并写入 kPskID 对应设置项；这是签名状态/缓存更新点。",
    0x14A4A0: "[x-header350] F8/final pack begins: reload json_list before final managed builder.\n【中文】F8/final 参数包开始：最终 managed builder 前重新读取 json_list。",
    0x14A4B8: "[x-header350] F8 pack common fill mirrors F5: +0 seed, +8 json_list, +0x10 x-ss-stub, +0x18 URL/query MEM_BLOCK.\n【中文】F8 参数包公共字段和 F5 类似：+0 seed，+8 JSON_LIST，+0x10 x-ss-stub，+0x18 URL/query MEM_BLOCK。",
    0x14A4C0: "[x-header350] F8 pack +0x20/+0x28: aux ref MEM_BLOCK and op2/env token block.\n【中文】F8 参数包 +0x20/+0x28：辅助 ref 与 op2/env token 块。",
    0x14A4CC: "[x-header350] F8 pack +0x48/+0x50: output char** slots (&ptr/&s). F8 writes X-Medusa key/value here.\n【中文】F8 参数包 +0x48/+0x50：输出 char** 槽，F8 后面会产出 X-Medusa 的 key/value。",
    0x14A4D4: "[x-header350] F8 pack +0x58 metasec_mode.\n【中文】F8 参数包 +0x58：metasec mode。",
    0x14A4DC: "[x-header350] F8 pack +0x5c final_flag, copied from the low bit of the device/url state check.\n【中文】F8 参数包 +0x5c：final flag，来自前面 device/url 状态检查的低位结果。",
    0x14A4E0: "[x-header350] invokes managed sign F8 final builder. It prepares the main final key/value material consumed by the following treeMapPut.\n【中文】调用 managed sign F8 final：汇总 json_list、mode、stage A/B 结果，产出后面写入输出 tree 的主要 X-* key/value 材料。",
    0x14A53C: "[x-header350] direct treeMapPut inserts X-Medusa. Runtime evidence: key=X-Medusa, value len around 0x3B4/0x3B8; true-device copy length was ~0x3B1.\n【中文】直接写 X-Medusa：unidbg direct probe 已确认 key=X-Medusa，value 是最大的一段签名串，长度约 0x3B4/0x3B8。",
    0x14A588: "[x-header350] invokes managed sign F13 post-emission helper after F8. It updates/derives late output material before optional X-Soter insertion.\n【中文】F8 后调用 managed sign F13 后处理/发射 helper：继续更新或派生后段输出材料，随后才判断并插入可选 X-Soter。",
    0x14A5A8: "[x-header350] origin writes X-Helios through treeMapPut_X22_X23_X24_350. Runtime evidence: key=X-Helios, value len=0x30.\n【中文】写 X-Helios：F13 后处理附近通过 X22/X23/X24 wrapper 写入输出 tree；unidbg origin=0x14A5A8。",
    0x14A65C: "[x-header350] treeMapPut inserts X-Soter. True-device trace: X1 key MEM_BLOCK decodes to \"X-Soter\"; X2 copies bytes from v308.seed_or_handle+0x10 with len at +0x0c (~0x78 in current run).\n【中文】插入 X-Soter：真机 trace 证明 x1 是 key=\"X-Soter\"，x2 从 v308.seed_or_handle+0x10 拷贝，长度取 +0x0c；当前样本约 0x78 字节。",
    0x14A674: "[flow350] parse JSON/ID_ITEM for risk/check state.\n【中文】解析 JSON/ID_ITEM 结构，主要给后续风控检查/状态随机化使用。",
    0x14A6E8: "[flow350] starts COOKIE_CHECK random/risk flag update.\n【中文】启动 COOKIE_CHECK 随机/风控标记更新；不是直接生成 header，但会影响状态侧效果。",
    0x14A704: "[flow350] timing/report marker fd8d1a41...\n【中文】性能/埋点记录：用字符串 fd8d1a41... 记录本次 HTTP 签名耗时。",
    0x14A724: "[flow350] output tree non-empty check.\n【中文】检查输出 tree 是否已有 header；为空则走 F1(-4)，非空则通过 X8/output 返回。",
    0x14A730: "[x-header350] success path: output TREE_MAP now contains generated X-* headers and is copied to hidden X8/out via returnHeaderTreeViaX8_350.\n【中文】成功出口：输出 TREE_MAP 已包含本次生成的 X-* header，通过 returnHeaderTreeViaX8_350 复制到 hidden X8/out。",
    0x14A750: "[flow350] common cleanup path.\n【中文】统一清理路径：释放中间 MEM_BLOCK/REF/TREE_MAP，避免把临时签名材料泄漏到下一次调用。",
    0x14E888: "[flow350] alternate dispatcher: parses CRLF pairs, uses global qword_2C4DC8+0x20 object, virtual slot +0x28, type=369, serializes tree.\n【中文】备用 HTTP 调度：把 CRLF 键值解析成 TREE_MAP，走全局对象虚表槽 +0x28，type=369，最后把 tree 序列化回字符串。",
    0x14EBB4: "[flow350] dispatcher: parses CRLF pairs, uses global qword_2C4DE0+0x18 object, virtual slot +0x20, type=369, serializes tree.\n【中文】HTTP 调度主路径：CRLF 键值转 TREE_MAP，走全局对象虚表槽 +0x20，type=369，最后输出 header 字符串。",
    0x14EF30: "[struct-recovery] CRLF key/value text -> TREE_MAP. Pairs are inserted through treeMapPut_350.\n【中文】CRLF 字符串转 TREE_MAP：按 key/value 成对插入，插入点是 treeMapPut_350。",
    0x14F22C: "[struct-recovery] second copy of CRLF key/value text -> TREE_MAP. Same layout as 0x14EF30.\n【中文】第二份 CRLF 转 TREE_MAP 实现，逻辑/结构和 0x14EF30 一样。",
    0x14F354: "[flow350] raw CRLF header pair insert. Runtime evidence: cookie/x-ss-stub/x-tt-dt/user-agent etc. are inserted here before signing.\n【中文】原始请求 header 插入点：CRLF 文本拆成 key/value 后，cookie、x-ss-stub、x-tt-dt、user-agent 等在这里进入输入 tree。",
    0x14F098: "[struct-recovery] TREE_MAP -> key\\r\\nvalue\\r\\n string serializer.\n【中文】TREE_MAP 序列化：遍历 key/value，拼成 key\\r\\nvalue\\r\\n 字符串。",
    0x14F394: "[struct-recovery] second TREE_MAP -> key\\r\\nvalue\\r\\n string serializer.\n【中文】第二份 TREE_MAP 序列化实现。",
    0x14CEBC: "[managed-runtime] Initializes the small HTTP managed module: registers CF helper table and exports F0/F1 program handles.\n【中文】初始化 HTTP managed module：注册 CF helper 表，并导出 F0/F1 两个 program 句柄。",
    0x14D130: "[managed-runtime] HTTP F0 wrapper: puts X8/X0/W1 into frame slots 4/5/6, invokes g_managedProg_http_F0_350, then releases the frame.\n【中文】HTTP F0 wrapper：把 X8、X0、W1 分别塞到 slot4/5/6，执行 g_managedProg_http_F0_350，最后释放 frame。",
    0x14D1D8: "[managed-runtime] HTTP F1 wrapper: puts X8/W0 into frame slots 4/5, invokes g_managedProg_http_F1_350. Often reached from error/alternate branches, but it is a real wrapper.\n【中文】HTTP F1 wrapper：把 X8、W0 塞到 slot4/5，执行 g_managedProg_http_F1_350；常从错误/备用分支调用，但不是单纯 marker。",
    0x14D264: "[x-header350] helper: allocate a fresh 0x18 MEM_BLOCK object.\n【中文】小 helper：分配一个新的 0x18 MEM_BLOCK 对象。",
    0x14D284: "[x-header350] helper: load output TREE_MAP from caller stack into X22, then allocate a 0x18 MEM_BLOCK for key/value.\n【中文】小 helper：从调用者栈取输出 TREE_MAP 到 X22，然后分配 0x18 MEM_BLOCK 给 key/value 用。",
    0x14D2B8: "[x-header350] helper: rebuild managed sign pack tail for F7/F13 using preserved regs and caller stack locals.\n【中文】小 helper：根据保存寄存器和调用者栈局部变量，重建 F7/F13 要吃的 managed 参数包尾部。",
    0x14D2E8: "[x-header350] helper: copy output value string from caller local `s` into a MEM_BLOCK and keep it in X28.\n【中文】小 helper：把调用者局部变量 `s` 指向的输出 value 字符串复制进 MEM_BLOCK，并保存到 X28。",
    0x14D2F4: "[x-header350] helper: copy output key string from caller local `ptr` into a MEM_BLOCK and keep it in X27.\n【中文】小 helper：把调用者局部变量 `ptr` 指向的输出 key 字符串复制进 MEM_BLOCK，并保存到 X27。",
    0x14D290: "[x-header350] treeMapPut wrapper: moves X22/X27/X28 into X0/X1/X2 and tail-calls treeMapPut_350. Use LR origin to name the real producer.\n【中文】treeMapPut 小包装：把 X22/X27/X28 当 map/key/value 转到 X0/X1/X2 后尾调用 treeMapPut_350；真实业务含义看 LR 来源。",
    0x14D29C: "[x-header350] wrapper tail-call to treeMapPut_350. In 350.101, origins 0x14A1C0/0x14A210/0x14A3A0/0x14A400 write X-Gorgon/X-Khronos/X-Argus/X-Ladon.\n【中文】wrapper 的尾调用点：350.101 里四个来源分别写 X-Gorgon、X-Khronos、X-Argus、X-Ladon。",
    0x14D300: "[x-header350] treeMapPut wrapper: moves X22/X23/X24 into X0/X1/X2 and tail-calls treeMapPut_350. Use LR origin to name the real producer.\n【中文】treeMapPut 小包装：把 X22/X23/X24 当 map/key/value 转到 X0/X1/X2 后尾调用 treeMapPut_350；真实业务含义看 LR 来源。",
    0x14D30C: "[x-header350] wrapper tail-call to treeMapPut_350. In 350.101, origin 0x14A5A8 writes X-Helios.\n【中文】wrapper 的尾调用点：350.101 里来源 0x14A5A8 写 X-Helios。",
    0x14D310: "[managed-runtime] Shared HTTP wrapper stack-canary check thunk: compares saved canary at [x29-8] with X8, then returns.\n【中文】HTTP wrapper 共用栈保护检查 thunk：比较 [x29-8] 保存值和 X8，然后返回；不是业务逻辑。",
    0x14D370: "[x-header350] helper: fill MetaSecManagedCallArg350 common head (+0/+8/+0x10/+0x18) and prepare aux pointers for caller stores.\n【中文】小 helper：填 MetaSecManagedCallArg350 公共头部字段，并准备后续 +0x20/+0x28 的辅助指针。",
    0x14D394: "[x-header350] helper: save runtime header-key query result in X22 and copy the second runtime key into stack MEM_BLOCK.\n【中文】小 helper：把运行时 header-key 查询结果保存到 X22，并把第二个运行时 key 复制到栈上 MEM_BLOCK。",
    0x14D40C: "[x-header350] helper: query input TREE_MAP using the runtime key stored in stack MEM_BLOCK at -0x48.\n【中文】小 helper：用栈上 -0x48 的运行时 key 查询输入 TREE_MAP。",
    0x14D418: "[x-header350] helper: query input TREE_MAP using the runtime key stored in stack MEM_BLOCK at -0x60.\n【中文】小 helper：用栈上 -0x60 的运行时 key 查询输入 TREE_MAP。",
    0x14D42C: "[x-header350] helper: copy the first pack MEM_BLOCK into the stack MEM_BLOCK at -0x48.\n【中文】小 helper：把参数包首个 MEM_BLOCK 复制到栈上 -0x48 的 MEM_BLOCK。",
    0x14D44C: "[x-header350] helper: copy a C string into X0 MEM_BLOCK and save that MEM_BLOCK pointer in X24.\n【中文】小 helper：把 C 字符串复制进 X0 指向的 MEM_BLOCK，并把该 MEM_BLOCK 保存到 X24。",
    0x14D454: "[x-header350] helper: transform stack MEM_BLOCK -0x60 into pack area -0xC0.\n【中文】小 helper：把栈上 -0x60 的 MEM_BLOCK 转换/写回到 -0xC0 参数包区域。",
    0x14D49C: "[x-header350] helper: copy a C string into the MEM_BLOCK kept in X27.\n【中文】小 helper：把 C 字符串复制进 X27 保存的 MEM_BLOCK。",
    0x14D4B4: "[x-header350] helper: copy the first runtime header key into stack MEM_BLOCK -0x48.\n【中文】小 helper：复制运行时 key 表的第一个 key 到栈上 -0x48 MEM_BLOCK。",
    0x14D4C8: "[x-header350] helper: free stack MEM_BLOCK -0x48 and keep its address in X22 for the next pack step.\n【中文】小 helper：释放栈上 -0x48 MEM_BLOCK，同时把其地址保存到 X22 供下一步复用。",
    0x14D4D4: "[x-header350] helper: copy stack MEM_BLOCK -0x48 into the MEM_BLOCK kept in X28.\n【中文】小 helper：把栈上 -0x48 MEM_BLOCK 复制进 X28 保存的 MEM_BLOCK。",
    0x14D4E0: "[x-header350] helper: base64-encode the pack area at -0xC0 into stack MEM_BLOCK -0x48.\n【中文】小 helper：把 -0xC0 参数包区域 base64 编码到栈上 -0x48 MEM_BLOCK。",
    0x11FBDC: "[struct-recovery] allocates 0x10 TREE_KV and writes key at +0, value at +8.\n【中文】分配 TREE_KV：malloc 0x10，+0 写 key，+8 写 value。",
    0x11FC30: "[struct-recovery] TREE_MAP put/replace. Existing 334 TREE_ITEM::item_value should be treated as TREE_KV* on 350.\n【中文】TREE_MAP 插入/替换：334 导入的 TREE_ITEM::item_value 在 350 这里应修正为 TREE_KV*。",
    0x139AB0: "[struct-recovery] vasprintf-style helper: allocates char* into *out using a format string.\n【中文】vasprintf 风格格式化：按 fmt 分配字符串，并写到 *out。",
    0x14AE74: "[flow350] normalized header pair insert inside j_doHttpX5. Runtime evidence: X-SS-STUB, X-TT-DT, X-SS-REQ-TICKET, etc.\n【中文】规范化 header 插入点：j_doHttpX5 中把小写/原始 header 变成大写工作 key，如 X-SS-STUB、X-TT-DT 等。",
    0x120E00: "[struct-recovery] treeMapPutDoubleValue_350: copies MEM_BLOCK key, allocates an 8-byte double value, then inserts into TREE_MAP.\n【中文】double 值插入 helper：复制 MEM_BLOCK key，分配 8 字节 double value，然后插入 TREE_MAP；可用于耗时/指标 map。",
    0x120E5C: "[flow350] metric/event insert, not an HTTP output header. Current key seen: consume_ML_DoHttpReqSignIT.\n【中文】指标/事件写入点，不是最终 HTTP header；当前看到的 key 是 consume_ML_DoHttpReqSignIT。",
    0x154328: "[managed-runtime] Managed module builder wrapper. X8 is used as the hidden out pointer for managedModuleDecodeBuild_350; returns the built module handle.\n【中文】managed module 构建包装：通过 X8 隐式 out 指针调用解码/构建核心，最终返回 module 句柄。",
    0x154364: "[managed-runtime] Finds a ManagedProgram350* by key such as F0/F1/F8. It builds a small-string key and searches the inline map at module+0x20.\n【中文】按名字查 managed program：例如 F0/F1/F8；会构造小字符串 key，在 module+0x20 的内联索引表里查 program 下标。",
    0x1545A8: "[managed-runtime] Acquire/reuse a 0x8380 TLS frame buffer; clears frame->buf+0x8100 slot area and initializes slot29/value_stack_top to buf+0x8000.\n【中文】托管执行帧申请/复用：从 TLS freelist 取 0x8380 frame buffer；清空 +0x8100 的 slot 表；初始化 slot29 为 value_stack_top。",
    0x154648: "[managed-runtime] Release frame: pushes frame->buf back to TLS freelist or frees it when freelist is full.\n【中文】托管执行帧释放：把 frame->buf 放回 TLS freelist；freelist 满时直接 free。",
    0x1547C0: "[managed-runtime] Slot getter: returns *(frame->buf + 0x8100 + slot*8). Slot2 is commonly used as return value.\n【中文】托管 slot 读取：读 frame->buf + 0x8100 + slot*8；slot2 大多当返回值槽。",
    0x1547D4: "[managed-runtime] Slot setter: writes value to *(frame->buf + 0x8100 + slot*8). Many wrappers use slot4+ for args, slot2 for returns.\n【中文】托管 slot 写入：写 frame->buf + 0x8100 + slot*8；外层 wrapper 常把入参放 slot4/5/6...。",
    0x15485C: "[managed-runtime] Inline string-index-map lookup used by managedModuleFindProgram_350. Input key is the compact SSO string built from names like F8.\n【中文】内联字符串索引表查找：managedModuleFindProgram_350 用它把 F0/F1/F8 这类 key 映射到 program 下标。",
    0x154454: "[managed-runtime] Invoke program/closure with ManagedFrame350. X0=program handle/global qword, X1=frame.\n【中文】托管 program 调用入口：X0 是 program/闭包句柄，X1 是 ManagedFrame350；真正进入 invoke core。",
    0x154468: "[managed-runtime] Program invoke core. kind 1/2/3 selects native entry or bytecode body, then calls managedBytecodeRun_350(body, frame).\n【中文】托管 program 调用核心：根据 program->kind 选择 native entry 或 bytecode body，然后执行 managedBytecodeRun_350。",
    0x1555A4: "[managed-runtime] Large bytecode interpreter for managed program bodies. Uses frame slot table and value stack; not the same as outer MetaSec VMP entry.\n【中文】托管字节码解释器：大 switch/跳表，使用 frame 的 value stack 和 slot 表；注意它不是 0x4CC10 那个 MetaSec 外层 VM。",
    0x158F48: "[managed-runtime] Module decode/build core: XOR-decodes the encoded blob using decode_key+2, parses it, binds CF/native tables, and writes the module to the X8 out pointer.\n【中文】module 解码/构建核心：用 decode_key+2 对 blob 做 XOR，解析后绑定 CF/native 表，并通过 X8 指向的 out 指针返回 module。",
    0x16D204: "[x-header350] native stage1 material builder. Input pack carries seed/url_or_path/x_ss_stub/short_code/mode and writes an allocated string to args->out_str.\n【中文】native stage1 材料生成：参数包里有 seed、url/path、x-ss-stub、short_code、mode；最终分配字符串写到 args->out_str。",
    0x16D35C: "[x-header350] folds short_code into the stage1 byte/string material, then converts it to hex before formatting the output string.\n【中文】把 short_code 混入 stage1 字节/字符串材料，随后转 hex，再进入格式化输出。",
    0x16D3F8: "[x-header350] stage1 final formatAllocString: writes the first native pre-sign string used before X-Argus/X-Ladon insertion.\n【中文】stage1 最终格式化：写出第一段 native 预签名字符串，后续会参与 X-Argus/X-Ladon 的生成。",
    0x16D454: "[x-header350] native stage2 material builder. Input pack seed/out_ptr/out_str; emits two formatted strings used by the early X-Argus/X-Ladon path.\n【中文】native stage2 材料生成：输入 seed/out_ptr/out_str，输出两段格式化字符串，给前面的 X-Argus/X-Ladon 路径使用。",
    0x16D4E0: "[x-header350] stage2 writes args->out_ptr with a decoded format string.\n【中文】stage2 第一段输出：用运行时解密出的 format 写 args->out_ptr。",
    0x16D4FC: "[x-header350] stage2 writes args->out_str using seed; this is the second early-sign material.\n【中文】stage2 第二段输出：按 seed 格式化写 args->out_str，是另一段早期签名材料。",
    0x1702B8: "[managed-runtime] Initializes the large signing managed module: registers CF0..CF101 helpers and exports F0..F54 program handles.\n【中文】初始化签名 managed module 大表：注册 CF0..CF101 helper，并导出 F0..F54 program 句柄。",
    0x17157C: "[flow350] F4 managed wrapper: passes one byte/flag into slot4, invokes sign F4, then reads return slot2.\n【中文】签名 F4 小包装：把一个 byte/flag 放进 slot4，调用 F4 program，然后读取 slot2 作为返回值。",
    0x1715F8: "[struct-recovery] X-Argus uses the shared MetaSecManagedCallArg350 full-call ABI (known 0x60 prefix); this F5 bridge forwards its pointer through managed-frame slot4. MetaSecXArgusProtoWire92_350 is only an observed protobuf-wire payload view, not a native fixed C layout.\n【中文】X-Argus 与 F8 共用 0x60 调用包；此 F5 bridge 放入 frame slot4。ProtoWire92 仅是当前观测到的 wire 视图，不能当作目标内存里的定长 C 对象。",
    0x171648: "[flow350] managed/native signing dispatcher wrapper B; arg_pack fields not promoted yet.\n【中文】签名 managed wrapper B：调用 F7 program；arg_pack 字段暂不强拆。",
    0x171698: "[struct-recovery] X-Medusa shares MetaSecManagedCallArg350 (known 0x60 prefix); this F8 bridge places the pointer in managed-frame slot20, not slot4. MetaSecXMedusaFinalPack2C8_350 describes only the final decoded output buffer, not a call-argument extension.\n【中文】X-Medusa 复用同一 0x60 调用包；F8 bridge 使用 frame slot20，而非 slot4。FinalPack2C8 只描述最终输出字节布局，不能推成调用包的 +0x60 字段。",
    0x1716F4: "[managed-runtime] managedSignPostEmitF13_350 invokes g_managedProg_sign_F13_350 with slot4=arg_pack.\n【中文】managed sign F13 后处理入口：把 arg_pack 放入 slot4，执行 g_managedProg_sign_F13_350。",
    0x1718DC: "[managed-runtime] Shared stack-canary epilogue/check thunk used by signing wrappers. Keep prototype conservative because Hex-Rays loses the tail-call context.\n【中文】签名 wrapper 共用的栈保护检查/尾部 thunk；Hex-Rays 会丢上下文，原型不要强行写死。",
    0x1718E8: "[managed-runtime] Tail thunk: set frame slot4 from preserved X21.\n【中文】尾调用小 thunk：把保存寄存器 X21 写入 frame slot4。",
    0x1718F8: "[managed-runtime] Tail thunk: set frame slot6 from preserved X19, with frame in X22.\n【中文】尾调用小 thunk：把保存寄存器 X19 写入 X22 指向 frame 的 slot6。",
    0x171908: "[managed-runtime] Tail thunk: set frame slot5 from preserved X20, with frame in X22.\n【中文】尾调用小 thunk：把保存寄存器 X20 写入 X22 指向 frame 的 slot5。",
    0x171918: "[managed-runtime] Tail thunk: saves stack canary via X8, then acquires a ManagedFrame350.\n【中文】尾调用小 thunk：先把 X8 的栈保护值保存到当前栈帧，再申请 ManagedFrame350。",
    0x171920: "[managed-runtime] Tail thunk used by sign wrappers: saves frame in X20 and writes preserved X19 into slot4.\n【中文】签名 wrapper 共用尾调用：把 frame 保存到 X20，并把保存寄存器 X19 写入 slot4。",
    0x17196C: "[managed-runtime] Tail thunk: releases the frame kept in X20.\n【中文】尾调用小 thunk：释放保存在 X20 里的 ManagedFrame350。",
    0x1719F0: "[managed-runtime] Fixed return reader: returns managedFrameGetSlot_350(frame, 2).\n【中文】固定返回值读取：读取 frame slot2，作为 managed program 返回值。",
    0x14D424: "[flow350] returnHeaderTreeViaX8_350: thin wrapper around copyRefWithLock_350; passes final output ref back to caller.\n【中文】最终输出引用返回：薄包装 copyRefWithLock_350，把最终 header TREE_MAP 的 shared-ref 返回到调用者/hidden X8。",
    0x2C4D40: "[managed-runtime] HTTP managed module handle built by 0x14CEBC from the encoded blob at 0x27EFF0.\n【中文】HTTP managed module 句柄：由 0x14CEBC 从 0x27EFF0 的编码 blob 解码/构建出来。",
    0x2C4D48: "[managed-runtime] Program handle initialized from key F0 by 0x14CEBC; used by 0x14D130 HTTP wrapper path.\n【中文】HTTP managed program F0：由 0x14CEBC 初始化，0x14D130 调用。",
    0x2C4D50: "[managed-runtime] Program handle initialized from key F1 by 0x14CEBC; used by 0x14D1D8 error/alternate wrapper path.\n【中文】HTTP managed program F1：由 0x14CEBC 初始化，0x14D1D8 错误/备用路径调用。",
    0x2C58C8: "[managed-runtime] Signing managed module handle built by 0x1702B8 from the encoded blob at 0x29FF20.\n【中文】签名 managed module 句柄：由 0x1702B8 从 0x29FF20 的编码 blob 解码/构建出来。",
    0x2C58F0: "[managed-runtime] Program handle initialized from key F4 by 0x1702B8; used by managedSignBuildF4Flag_350.\n【中文】签名 managed program F4：由 0x1702B8 初始化，managedSignBuildF4Flag_350 调用。",
    0x2C58F8: "[managed-runtime] Program handle initialized from key F5 by 0x1702B8; used by managedSignBuildA_350.\n【中文】签名 managed program F5：由 0x1702B8 初始化，managedSignBuildA_350 调用。",
    0x2C5908: "[managed-runtime] Program handle initialized from key F7 by 0x1702B8; used by managedSignBuildB_350.\n【中文】签名 managed program F7：由 0x1702B8 初始化，managedSignBuildB_350 调用。",
    0x2C5910: "[managed-runtime] Program handle initialized from key F8 by 0x1702B8; used by managedSignBuildFinal_350.\n【中文】签名 managed program F8：由 0x1702B8 初始化，managedSignBuildFinal_350 调用，靠近最终 X-* header 生成。",
}

for _managed_prog_idx in range(55):
    _managed_prog_off = 0x2C58D0 + 8 * _managed_prog_idx
    STATIC_COMMENTS.setdefault(
        _managed_prog_off,
        f"[managed-runtime] Signing ManagedProgram350 handle F{_managed_prog_idx}; initialized by 0x1702B8. Runtime use not named yet unless xrefs prove it.\n"
        f"【中文】签名 ManagedProgram350 句柄 F{_managed_prog_idx}：由 0x1702B8 初始化；除非有运行时/静态 xref 证明，暂不猜具体业务语义。",
    )


def _imagebase() -> int:
    return int(ida_nalt.get_imagebase())


def _parse_pc_offset(pc_text: str) -> int | None:
    match = re.search(r"\+0x([0-9a-fA-F]+)", pc_text)
    if not match:
        return None
    return int(match.group(1), 16)


def _set_pseudocode_cmt(ea: int, text: str) -> bool:
    """Mirror an address comment into Hex-Rays pseudocode user comments."""
    func = ida_funcs.get_func(ea)
    if func is None:
        return False
    if not ida_hexrays.init_hexrays_plugin():
        return False

    try:
        cfunc = _CACHED_CFUNCS.get(func.start_ea)
        if cfunc is None:
            cfunc = ida_hexrays.decompile(func.start_ea)
            if not cfunc:
                return False
            _CACHED_CFUNCS[func.start_ea] = cfunc
    except Exception as exc:
        ida_kernwin.msg(f"decompile failed for pseudocode cmt at 0x{ea:x}: {exc}\n")
        return False

    try:
        eamap = cfunc.get_eamap()
        if ea not in eamap:
            return False
        nearest_ea = eamap[ea][0].ea

        if cfunc.has_orphan_cmts():
            cfunc.del_orphan_cmts()
            cfunc.save_user_cmts()

        loc = idaapi.treeloc_t()
        loc.ea = nearest_ea
        for itp in range(idaapi.ITP_SEMI, idaapi.ITP_COLON):
            loc.itp = itp
            cfunc.set_user_cmt(loc, text)
            cfunc.save_user_cmts()
            cfunc.refresh_func_ctext()
            if not cfunc.has_orphan_cmts():
                return True
            cfunc.del_orphan_cmts()
            cfunc.save_user_cmts()
    except Exception as exc:
        ida_kernwin.msg(f"set pseudocode cmt failed at 0x{ea:x}: {exc}\n")
    return False


def _append_cmt(ea: int, new_text: str) -> None:
    old = ida_bytes.get_cmt(ea, True) or ""
    lines = [line for line in old.splitlines() if not line.startswith(COMMENT_TAG_PREFIX)]
    if new_text not in lines:
        lines.append(new_text)
    final_text = "\n".join(lines)
    ida_bytes.set_cmt(ea, final_text, True)
    _set_pseudocode_cmt(ea, final_text)


def _try_import_struct_header() -> None:
    try:
        # IDA 8/9 expose idc_parse_types from ida_typeinf. Keep it best-effort:
        # if a future IDA build changes the API, comments are still applied.
        errors = ida_typeinf.idc_parse_types(IDA_DECLS, ida_typeinf.PT_SIL)
        ida_kernwin.msg(
            f"imported/updated metasec draft local types, parser result={errors}\n"
        )
    except Exception as exc:
        ida_kernwin.msg(f"failed to import built-in metasec local types: {exc}\n")
        if STRUCT_HEADER.exists():
            try:
                decls = STRUCT_HEADER.read_text(encoding="utf-8")
                errors = ida_typeinf.idc_parse_types(decls, ida_typeinf.PT_SIL)
                ida_kernwin.msg(
                    f"fallback imported struct header {STRUCT_HEADER}, parser result={errors}\n"
                )
            except Exception as fallback_exc:
                ida_kernwin.msg(f"fallback struct import failed: {fallback_exc}\n")


def _try_name_function(ea: int, name: str) -> None:
    old = ida_name.get_name(ea) or ""
    if old and not old.startswith("sub_"):
        return
    ida_name.set_name(ea, name, ida_name.SN_NOCHECK | ida_name.SN_NOWARN)


def _ensure_important_functions(base: int) -> None:
    for start_off, end_off, name in IMPORTANT_FUNCTIONS:
        start = base + start_off
        end = base + end_off
        func = ida_funcs.get_func(start)
        if (
            start_off in FORCE_SPLIT_FUNCTION_STARTS
            and func is not None
            and func.start_ea == start
            and func.end_ea != end
        ):
            ida_kernwin.msg(
                f"deleting coarse function before split {ida_funcs.get_func_name(func.start_ea)} "
                f"at 0x{func.start_ea:x}-0x{func.end_ea:x}; target {name} ends 0x{end:x}\n"
            )
            ida_funcs.del_func(func.start_ea)
            func = None
        if func is None or func.start_ea != start:
            ok = ida_funcs.add_func(start, end)
            ida_kernwin.msg(
                f"{'added' if ok else 'failed to add'} function {name} "
                f"at 0x{start:x}-0x{end:x}\n"
            )
            if ok:
                ida_auto.plan_and_wait(start, end)
        _try_name_function(start, name)


def _apply_important_names(base: int) -> None:
    for off, name in IMPORTANT_NAMES:
        _try_name_function(base + off, name)
    ida_kernwin.msg(f"applied {len(IMPORTANT_NAMES)} extra metasec names\n")


def _try_apply_func_type(ea: int, decl: str) -> bool:
    tif = ida_typeinf.tinfo_t()
    try:
        ok = ida_typeinf.parse_decl(tif, None, decl, ida_typeinf.PT_SIL)
    except TypeError:
        ok = ida_typeinf.parse_decl(tif, None, decl + ";", ida_typeinf.PT_SIL)
    except Exception as exc:
        ida_kernwin.msg(f"parse function type failed at 0x{ea:x}: {exc}: {decl}\n")
        return False

    if not ok:
        ida_kernwin.msg(f"parse function type returned false at 0x{ea:x}: {decl}\n")
        return False
    try:
        return bool(ida_typeinf.apply_tinfo(ea, tif, ida_typeinf.TINFO_DEFINITE))
    except Exception as exc:
        ida_kernwin.msg(f"apply function type failed at 0x{ea:x}: {exc}: {decl}\n")
        return False


def _apply_known_function_types(base: int) -> None:
    ok_count = 0
    for off, decl in FUNCTION_TYPES:
        if _try_apply_func_type(base + off, decl):
            ok_count += 1
    ida_kernwin.msg(f"applied {ok_count}/{len(FUNCTION_TYPES)} metasec function prototypes\n")


def _apply_static_comments(base: int) -> None:
    for off, text in STATIC_COMMENTS.items():
        _append_cmt(base + off, text)
    ida_kernwin.msg(f"applied {len(STATIC_COMMENTS)} static metasec flow comments\n")


def _apply_global_types(base: int) -> None:
    ok_count = 0
    for off, name, ty in GLOBAL_TYPES:
        ea = base + off
        ida_name.set_name(ea, name, ida_name.SN_NOCHECK | ida_name.SN_NOWARN)
        if idc.SetType(ea, ty):
            ok_count += 1
    ida_kernwin.msg(f"applied {ok_count}/{len(GLOBAL_TYPES)} metasec global types\n")


def main() -> None:
    if not SUMMARY_JSON.exists():
        ida_kernwin.msg(f"summary not found: {SUMMARY_JSON}\n")
        return

    _try_import_struct_header()

    data = json.loads(SUMMARY_JSON.read_text(encoding="utf-8"))
    base = _imagebase()
    _ensure_important_functions(base)
    _apply_important_names(base)
    _apply_known_function_types(base)
    _apply_global_types(base)
    _apply_static_comments(base)
    applied = 0

    for reg, summary in data.items():
        for row in summary.get("rows", []):
            if not row.get("pcs"):
                continue
            off = int(row["offset"])
            text = (
                f"[metasec:{reg}] +0x{off:x} {row['name']} "
                f"access={row['access'] or '-'} sizes={row['sizes'] or '-'} "
                f"count={row['count']}"
            )
            hint = row.get("nested_ascii") or ""
            if hint:
                text += f" hint={hint[:80]}"
            for pc in row["pcs"]:
                pc_off = _parse_pc_offset(pc)
                if pc_off is None:
                    continue
                ea = base + pc_off
                if ea == ida_idaapi.BADADDR:
                    continue
                _append_cmt(ea, text)
                applied += 1

    ida_kernwin.msg(f"applied {applied} metasec struct evidence comments from {SUMMARY_JSON}\n")


if __name__ == "__main__":
    main()

/*
 * 350.101 libmetasec_ml.so HTTP signing reconstruction.
 *
 * Status:
 *   Evidence-backed pseudo-C, not intended to compile as-is.
 *
 * Purpose:
 *   This file is the "human form" of the currently recovered request ->
 *   signature-success path.  It does not try to keep IDA's ugly control flow.
 *   Instead it names the business stages that were proven by GumTrace/unidbg
 *   traces and by static IDA inspection.
 *
 * Main anchors:
 *   0x14DBF4 buildSignedHttpHeadersCallback_350
 *   0x149CA8 buildSignedHttpHeadersInner_350
 *   0x14A1AC signStage1_makeStubPieces_350
 *   0x14A1FC signStage2_makeKeyPieces_350
 *   0x1715F8 managedSignBuildA_350      -> F5  -> X-Argus
 *   0x171648 managedSignBuildB_350      -> F7  -> X-Ladon
 *   0x171698 managedSignBuildFinal_350  -> F8  -> X-Medusa
 *   0x1716F4 managedSignPostEmitF13_350 -> F13 -> X-Helios side
 *   0x124DD4 nativeVmpBuildMssdkMaterial_350 -> vmCode 0x1F7860
 *   0x12564C selectValueFromNativeVmpMaterial_350
 *
 * Important model:
 *
 *   There are two different "VM-looking" layers:
 *
 *   1. native VMP @ 0x4CC10/exeVMInner_350
 *      - wrapper selects a vmCode such as 0x1F7860
 *      - dispatch is BR X8 / handler table style
 *      - current restored program builds mssdk material, not directly X-Argus
 *
 *   2. managed bytecode VM @ 0x1555A4/managedBytecodeRun_350
 *      - runs programs F5/F7/F8/F13
 *      - calls native CF helpers CF0..CF101
 *      - this layer builds X-Argus/X-Ladon/X-Medusa/X-Helios material
 */

#include "metasec_structs_350_all.h"

typedef struct HeaderStringPair350 {
    char *key;
    char *value;
} HeaderStringPair350;

typedef struct NativeStage1Output350 {
    char *key;      /* observed: X-Gorgon */
    char *value;    /* observed len: 0x34 */
} NativeStage1Output350;

typedef struct NativeStage2Output350 {
    char *key;      /* observed: X-Khronos */
    char *value;    /* observed len: 0x0a */
} NativeStage2Output350;

typedef struct ManagedStageOutput350 {
    char *key;
    char *value;
} ManagedStageOutput350;

static void insert_header(TREE_MAP *out, const char *key, const char *value)
{
    /*
     * Pseudo-equivalent of:
     *
     *   copy C string -> MEM_BLOCK
     *   treeMapPut_350(out, key_block, value_block)
     *
     * Important callsite anchors:
     *   0x14D29C tail wrapper: X22/X27/X28 -> X0/X1/X2
     *   0x14D30C tail wrapper: X22/X23/X24 -> X0/X1/X2
     *   0x14A53C direct treeMapPut_350 for X-Medusa
     *   0x14A65C direct treeMapPut_350 for X-Soter
     */
    MEM_BLOCK key_block = pseudo_memblock_from_cstr(key);
    MEM_BLOCK val_block = pseudo_memblock_from_cstr(value);
    treeMapPut_350(out, &key_block, &val_block);
}

static int parse_metasec_mode(TREE_MAP *input_headers)
{
    /*
     * Anchor: 0x14A128.
     *
     * Reads "x-metasec-mode" from the request tree.  The current baseline run
     * uses mode=0.
     */
    const char *mode_text = pseudo_tree_get_cstr(input_headers, "x-metasec-mode");
    return mode_text ? pseudo_atoi(mode_text) : 0;
}

static MEM_BLOCK *derive_url_or_query_material(MEM_BLOCK *url)
{
    /*
     * Anchors:
     *   0x149F78 finds '?' and '#'
     *   0x14A164 builds the derived MEM_BLOCK
     *
     * The current 350.101 run used query-string-only material:
     *   url_or_path.len = 0x2c0
     */
    return pseudo_extract_query_or_path(url);
}

static NativeStage1Output350 run_native_stage1(MetaSecSignStage1Args350 *args)
{
    /*
     * Anchor: 0x14A1AC -> 0x16D204 signStage1_makeStubPieces_350.
     *
     * Confirmed inputs:
     *   args->seed_or_handle
     *   args->x_ss_stub
     *   args->url_or_path
     *   args->short_code
     *   args->mode
     *
     * Confirmed output insertion:
     *   origin 0x14A1C0 -> X-Gorgon, value len 0x34.
     */
    signStage1_makeStubPieces_350(args);
    return (NativeStage1Output350){
        .key = *args->out_ptr,
        .value = *args->out_str,
    };
}

static NativeStage2Output350 run_native_stage2(MetaSecSignStage2Args350 *args)
{
    /*
     * Anchor: 0x14A1FC -> 0x16D454 signStage2_makeKeyPieces_350.
     *
     * Confirmed output insertion:
     *   origin 0x14A210 -> X-Khronos, value len 0x0a.
     */
    signStage2_makeKeyPieces_350(args);
    return (NativeStage2Output350){
        .key = *args->out_ptr,
        .value = *args->out_str,
    };
}

static ManagedStageOutput350 run_managed_f5_argus(MetaSecManagedCallArg350 *pack)
{
    /*
     * Anchor:
     *   0x14A38C -> 0x1715F8 managedSignBuildA_350 -> program F5.
     *
     * Phase-level material sequence from focused CF probe.
     * Note: CF61 events in that phase can be nested/helper-program activity;
     * bytecode-record-accurate F5 marks are in managed_vm_decode/F5_*.stats.md.
     *
     * Clean F5 bytecode marks in the 2026-08-31 decoder pass:
     *   CF10*5 -> CF38*5 -> CF44 -> CF98*2
     *
     * Phase-level trace still shows lower/nested digest activity before:
     *   CF44(base64) -> CF98*2(out key/value)
     *
     * Stable shape:
     *   - digest/query material through CF61
     *   - x-ss-stub is mixed
     *   - CF44 base64 input length around 0xc2
     *   - CF98 returns key/value strings
     *
     * Confirmed insertion:
     *   origin 0x14A3A0 -> X-Argus, value len 0x104 class.
     */
    managedSignBuildA_350(pack);
    return (ManagedStageOutput350){
        .key = *pack->out_key,
        .value = *pack->out_value,
    };
}

static ManagedStageOutput350 run_managed_f7_ladon(MetaSecManagedShortCallArg350 *pack)
{
    /*
     * Anchor:
     *   0x14A3EC -> 0x171648 managedSignBuildB_350 -> program F7.
     *
     * Confirmed focused run:
     *   CF100("%u-%s-%s") builds:
     *     "1788108717-1588093228-1128"
     *   CF48 transforms plaintext + 32-byte ASCII material -> 32-byte binary
     *   CF49 prepends/cats 4-byte prefix -> 0x24-byte pack
     *   CF44 base64(0x24 bytes) -> 48-char X-Ladon
     *   CF98 returns key/value strings
     *
     * Confirmed insertion:
     *   origin 0x14A400 -> X-Ladon, value len 0x30.
     */
    managedSignBuildB_350(pack);
    return (ManagedStageOutput350){
        .key = *pack->out_key,
        .value = *pack->out_value,
    };
}

static ManagedStageOutput350 run_managed_f8_medusa(MetaSecManagedCallArg350 *pack)
{
    /*
     * Anchor:
     *   0x14A4E0 -> 0x171698 managedSignBuildFinal_350 -> program F8.
     *
     * This is the large final signer.
     *
     * Phase-level material sequence from focused CF probe.
     * Note: CF61/CF79 events in that phase can be nested/helper-program
     * activity; bytecode-record-accurate F8 marks are in
     * managed_vm_decode/F8_*.stats.md.
     *
     * Clean F8 bytecode marks in the 2026-08-31 decoder pass:
     *   CF38*4 -> CF10 -> CF44 -> CF98*2
     *
     * Phase-level helper activity still shows JSON/digest side work around
     * this stage, but do not assign those records to F8 without descriptor
     * meta matching.
     *
     * Stable shape:
     *   - full pack same as F5
     *   - final_flag=1
     *   - CF44 base64 input length around 0x2c4
     *   - output value length around 0x3b0/0x3b4 class
     *
     * Confirmed insertion:
     *   0x14A53C direct treeMapPut_350 -> X-Medusa.
     */
    managedSignBuildFinal_350(pack);
    return (ManagedStageOutput350){
        .key = *pack->out_key,
        .value = *pack->out_value,
    };
}

static ManagedStageOutput350 run_managed_f13_helios(MetaSecManagedShortCallArg350 *pack)
{
    /*
     * Anchor:
     *   0x14A588 -> 0x1716F4 managedSignPostEmitF13_350 -> program F13.
     *
     * Shape-compatible with F7:
     *   CF100("%u-%s-%s") -> CF48 -> CF49 -> CF44 -> CF98*2.
     *
     * Confirmed insertion:
     *   origin 0x14A5A8 -> X-Helios, value len 0x30.
     */
    managedSignPostEmitF13_350(pack);
    return (ManagedStageOutput350){
        .key = *pack->out_key,
        .value = *pack->out_value,
    };
}

static char *build_optional_x_soter(MetaSecManagedShortCallArg350 *pack)
{
    /*
     * Anchor: 0x14A65C.
     *
     * Current trace:
     *   key = "X-Soter"
     *   value is copied from pack/seed_or_handle-related MEM_BLOCK-like output
     *   length around 0x78
     *
     * Treat separately from F13: F13 is the nearby post-emission helper, while
     * the actual Soter insertion is this direct treeMapPut callsite.
     */
    return pseudo_optional_soter_from_short_pack(pack);
}

static void update_pskid_metric_and_state(TREE_MAP *input_or_working_tree)
{
    /*
     * Anchor: 0x14A468.
     *
     * Performs CRC/update-setting checkpoint around kPskID.  This is state /
     * cache/report side effect, not the main X-* value writer.
     */
    pseudo_update_kpskid_crc_state(input_or_working_tree);
}

static void emit_timing_metric(void)
{
    /*
     * Anchors:
     *   0x14A704 marker string fd8d1a41d3c56026d47f1f8ba146eb99
     *   0x120E5C consume_ML_DoHttpReqSignIT
     *
     * This is metric/report output, not an HTTP request header.
     */
    pseudo_emit_metric("consume_ML_DoHttpReqSignIT");
}

__int64 buildSignedHttpHeadersInner_350_recovered(
    MetaSecCtx350 *ctx,
    REF_JSON_LIST *json_list_ref,
    REF_MEM_BLOCK *url_ref,
    REF_MEM_BLOCK *x_ss_stub_ref,
    int request_type,
    REF_TREE_MAP *input_tree_ref,
    REF_TREE_MAP *hidden_x8_out)
{
    /*
     * Logical equivalent of 0x149CA8.
     *
     * IDA prototype omits hidden_x8_out because AArch64 ABI puts it in X8 in
     * this call shape.  The native code finally copies the output TREE_MAP to
     * this hidden out-ref at 0x14A730 -> 0x14D424 -> 0x149C20.
     */
    TREE_MAP *out_headers = newTreeMap_350();
    TREE_MAP *work_headers = newTreeMap_350();

    if (json_list_ref == NULL || json_list_ref->obj == NULL) {
        return managedHttpF1Wrapper_350(-1, hidden_x8_out);
    }
    if (url_ref == NULL || url_ref->obj == NULL || url_ref->obj->body.mem == NULL) {
        return managedHttpF1Wrapper_350(-5, hidden_x8_out);
    }
    if (x_ss_stub_ref == NULL || x_ss_stub_ref->obj == NULL) {
        return managedHttpF1Wrapper_350(-6, hidden_x8_out);
    }
    if (!pseudo_url_allowed(url_ref->obj)) {
        return managedHttpF1Wrapper_350(-7, hidden_x8_out);
    }

    int metasec_mode = parse_metasec_mode(input_tree_ref->obj);
    COOKIE_RISK2 *op2 = metasec350_registry_find_type(ctx->registry, 2);
    MEM_BLOCK *url_or_query = derive_url_or_query_material(url_ref->obj);
    if (url_or_query == NULL || url_or_query->body.mem == NULL) {
        return managedHttpF1Wrapper_350(-8, hidden_x8_out);
    }

    /*
     * Native pre-sign: X-Gorgon / X-Khronos.
     */
    char *key = NULL;
    char *value = NULL;
    MetaSecSignStage1Args350 stage1 = {
        .seed_or_handle = pseudo_get_seed_or_handle(ctx, op2),
        .x_ss_stub = x_ss_stub_ref->obj,
        .url_or_path = url_or_query,
        .short_code = pseudo_get_short_code(ctx),
        .out_ptr = &key,
        .out_str = &value,
        .mode = metasec_mode,
    };
    NativeStage1Output350 gorgon = run_native_stage1(&stage1);
    insert_header(out_headers, gorgon.key, gorgon.value);

    key = NULL;
    value = NULL;
    MetaSecSignStage2Args350 stage2 = {
        .seed = pseudo_get_stage2_seed(ctx),
        .out_ptr = &key,
        .out_str = &value,
    };
    NativeStage2Output350 khronos = run_native_stage2(&stage2);
    insert_header(out_headers, khronos.key, khronos.value);

    /*
     * Managed full pack F5: X-Argus.
     */
    key = NULL;
    value = NULL;
    MetaSecManagedCallArg350 f5_pack = {
        .seed_or_handle = pseudo_get_seed_or_handle(ctx, op2),
        .json_list = json_list_ref->obj,
        .x_ss_stub = x_ss_stub_ref->obj,
        .url_or_path = url_or_query,
        .aux_ref_mem = pseudo_get_aux_ref_mem(ctx),
        .token_or_env_block = pseudo_get_token_or_env_block(op2),
        .bd_client_key_item = pseudo_query_runtime_header_key1(input_tree_ref->obj),
        .bd_client_key_value = pseudo_query_runtime_header_key2(input_tree_ref->obj),
        .request_type = request_type,
        .out_key = &key,
        .out_value = &value,
        .metasec_mode = metasec_mode,
        .final_flag = 0,
    };
    ManagedStageOutput350 argus = run_managed_f5_argus(&f5_pack);
    insert_header(out_headers, argus.key, argus.value);

    /*
     * Managed short pack F7: X-Ladon.
     */
    key = NULL;
    value = NULL;
    MetaSecManagedShortCallArg350 f7_pack = {
        .seed_or_handle = pseudo_get_short_seed(ctx),
        .derived_block = pseudo_memblock_from_cstr_ptr("1128"),
        .json_list = json_list_ref->obj,
        .stack_memblock = pseudo_memblock_from_cstr_ptr("1588093228"),
        .out_key = &key,
        .out_value = &value,
    };
    ManagedStageOutput350 ladon = run_managed_f7_ladon(&f7_pack);
    insert_header(out_headers, ladon.key, ladon.value);

    update_pskid_metric_and_state(work_headers);

    /*
     * Managed full pack F8: X-Medusa.
     */
    key = NULL;
    value = NULL;
    MetaSecManagedCallArg350 f8_pack = f5_pack;
    f8_pack.out_key = &key;
    f8_pack.out_value = &value;
    f8_pack.final_flag = 1;

    ManagedStageOutput350 medusa = run_managed_f8_medusa(&f8_pack);
    insert_header(out_headers, medusa.key, medusa.value);

    /*
     * Managed post stage F13: X-Helios, followed by optional X-Soter.
     */
    key = NULL;
    value = NULL;
    MetaSecManagedShortCallArg350 f13_pack = f7_pack;
    f13_pack.out_key = &key;
    f13_pack.out_value = &value;

    ManagedStageOutput350 helios = run_managed_f13_helios(&f13_pack);
    insert_header(out_headers, helios.key, helios.value);

    char *soter = build_optional_x_soter(&f13_pack);
    if (soter != NULL) {
        insert_header(out_headers, "X-Soter", soter);
    }

    emit_timing_metric();

    if (pseudo_tree_empty(out_headers)) {
        return managedHttpF1Wrapper_350(-4, hidden_x8_out);
    }

    /*
     * Anchor:
     *   0x14A730 -> 0x14D424 -> 0x149C20
     *
     * Return final TREE_MAP by shared-ref copy through hidden X8/out.
     */
    returnHeaderTreeViaX8_350(hidden_x8_out, out_headers);
    return 0;
}

char *buildSignedHttpHeadersCallback_350_recovered(const char *url,
                                                   const char *headers_crlf)
{
    /*
     * Logical equivalent of 0x14DBF4.
     *
     * The public wrapper accepts external strings, normalizes them into the
     * internal CRLF key/value stream, parses that stream to TREE_MAP, invokes
     * the inner signer, then serializes output TREE_MAP back to CRLF text.
     */
    char *request_text = NULL;

    if (pseudo_input_already_internal_shape(url, headers_crlf)) {
        request_text = pseudo_strdup(headers_crlf);
    } else {
        /*
         * Anchors:
         *   0x14DD20 length calculation
         *   0x14DD48 URL marker insertion
         *   0x14DD5C alternate dispatcher
         */
        request_text = pseudo_join_headers_url_as_crlf(headers_crlf, url);
    }

    TREE_MAP *input_tree = NULL;
    parseCrlfPairsToTree_350(&input_tree, request_text);

    REF_TREE_MAP out_ref = {0};
    MetaSecHttpInnerArgPack350 args = {
        .tree_map = pseudo_ref_tree(input_tree),
        .x_ss_stub = pseudo_ref_mem(pseudo_tree_get(input_tree, "x-ss-stub")),
        .url = pseudo_ref_mem(pseudo_memblock_from_cstr_ptr(url)),
        .json_list = pseudo_ref_json(pseudo_extract_json_list(input_tree)),
    };

    buildSignedHttpHeadersInner_350_recovered(
        pseudo_get_global_metasec_ctx_350(),
        &args.json_list,
        &args.url,
        &args.x_ss_stub,
        369,
        &args.tree_map,
        &out_ref);

    return treeMapToCrlfString_350(NULL, &out_ref.obj);
}

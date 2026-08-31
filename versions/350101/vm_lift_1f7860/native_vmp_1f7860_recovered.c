/*
 * 350.101 libmetasec_ml.so native VMP reconstruction, vmCode = 0x1F7860.
 *
 * Status:
 *   Evidence-backed pseudo-C, not intended to compile as-is.
 *
 * Native anchors:
 *   0x4CC10  exeVMInner_350
 *   0x124DD4 nativeVmpBuildMssdkMaterial_350 wrapper
 *   0x12564C selectValueFromNativeVmpMaterial_350 caller/consumer
 *
 * Main evidence:
 *   gumtrace_1f7860_slice.log
 *   gumtrace_1f7860_3pages.vmtrace.asm
 *
 * Key point:
 *   0x1F7860 is not directly "the X-Argus generator".  It builds a protected
 *   mssdk material object containing app info plus two key/value entries:
 *
 *     common_key -> y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY=
 *     sign_key   -> jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU=
 *
 *   The caller then selects one value by key and copies it into its output ref.
 */

#include "../metasec_structs_350_all.h"

typedef struct VmParam64_350 {
    void *funBridge;        /* +0x00, runtime: base+0x129B24 */
    void *stack_end;        /* +0x08 */
    void *save_LR;          /* +0x10, runtime: base+0x1256AC */
} VmParam64_350;

typedef struct NativeVmp124DD4ParamWindow350 {
    /*
     * Built by 0x124DD4 on its own stack before BL 0x4CC10.
     *
     * Runtime fourth hit:
     *   [SP+0x00] = incoming X8 = caller out-ref
     *   [SP+0x08] = incoming X0 = first MEM_BLOCK-ish input
     *   [SP+0x10] = incoming X1 = second MEM_BLOCK-ish input
     *   [SP+0x18] = incoming X2 = extra ref/object
     */
    REF_OBJ *out_ref;       /* +0x00 */
    REF_MEM_BLOCK *block_a; /* +0x08 */
    REF_MEM_BLOCK *block_b; /* +0x10 */
    void *extra_ref;        /* +0x18 */
} NativeVmp124DD4ParamWindow350;

static uint32_t meta_zigzag_u32(uint32_t value)
{
    /*
     * Object fields +0x18/+0x40 are stored as raw uint32 and serialized as
     * value << 1 in the 0xdb-byte protobuf-like buffer.
     *
     * Trace proof:
     *   material.seed_id = 0x20200924 -> serialized field1 = 0x40401248
     *   material.salt_id = 0x5fa25885 -> serialized field6 = 0xbf44b10a
     */
    return value << 1;
}

static MetaSecMssdkKeyValue350 *new_material_kv(const char *key,
                                                 const char *value)
{
    /*
     * Runtime object size: 0x28.
     *
     * The constructor first copies a static 0x28-byte template.  Then the VM
     * fills:
     *   +0x18 key C string
     *   +0x20 value C string
     */
    MetaSecMssdkKeyValue350 *item = pseudo_malloc(sizeof(*item));
    pseudo_copy_static_template(item, "MetaSecMssdkKeyValue350");

    item->key = pseudo_strdup(key);
    item->value = pseudo_strdup(value);
    return item;
}

static MetaSecMssdkAppInfo350 *new_app_info(void)
{
    /*
     * Serialized nested field7:
     *
     *   0a 18 "com.ss.android.ugc.aweme"
     *   12 20 "AEA615AB910015038F73C47E45D21466"
     */
    MetaSecMssdkAppInfo350 *app = pseudo_malloc(sizeof(*app));
    pseudo_copy_static_template(app, "MetaSecMssdkAppInfo350");

    app->package_name = pseudo_strdup("com.ss.android.ugc.aweme");
    app->material_count = 1;
    app->material_values = pseudo_malloc(sizeof(char *));
    app->material_values[0] =
        pseudo_strdup("AEA615AB910015038F73C47E45D21466");
    return app;
}

static MetaSecMssdkMaterial350 *vm_1f7860_build_mssdk_material(
    const NativeVmp124DD4ParamWindow350 *params)
{
    /*
     * This is the useful devirtualized body of vmCode 0x1F7860.
     *
     * The real bytecode does this through thousands of native dispatches:
     *   - allocate MEM_BLOCK/protobuf builder objects;
     *   - copy/decode binary blobs of length 0xf4, 0xf0, 0xe3, 0xdb;
     *   - fill a protobuf-like structure byte-by-byte;
     *   - parse/build object arrays;
     *   - finally write result object through params->out_ref.
     *
     * params->block_a/block_b/extra_ref are still kept in the signature because
     * the VM reads them through pParamList.  In the current captured request,
     * the recovered output material below is what survives to the caller.
     */
    (void)params;

    MetaSecMssdkMaterial350 *m = pseudo_malloc(sizeof(*m)); /* 0x70 */
    pseudo_copy_static_template(m, "MetaSecMssdkMaterial350");

    m->seed_id = 0x20200924;       /* serialized field1: 1077940808 */
    m->module_name = pseudo_strdup("mssdk");
    m->app_id = pseudo_strdup("1588093228");
    m->enabled = 1;
    m->sdk_version = pseudo_strdup("1128");
    m->salt_id = 0x5fa25885;       /* serialized field6: 3208950026 */

    m->app_info_count = 1;
    m->app_infos = pseudo_malloc(sizeof(MetaSecMssdkAppInfo350 *));
    m->app_infos[0] = new_app_info();

    m->kv_count = 2;
    m->kv_items = pseudo_malloc(2 * sizeof(MetaSecMssdkKeyValue350 *));
    m->kv_items[0] = new_material_kv(
        "common_key",
        "y9b0xCYrB++Slss+AeCCmqg/7xiNzqCCzZ2pYLjGgVY=");
    m->kv_items[1] = new_material_kv(
        "sign_key",
        "jr36OAbsxc7nlCPmAp7YJUC8Ihi7fq73HLaR96qKovU=");

    return m;
}

void nativeVmpBuildMssdkMaterial_350(REF_OBJ *out_ref,
                                     REF_MEM_BLOCK *block_a,
                                     REF_MEM_BLOCK *block_b,
                                     void *extra_ref)
{
    /*
     * Native function shape:
     *
     *   0x124DD4:
     *     save X8/X0/X1/X2 into stack pParamList
     *     X0 = base + 0x1F7860
     *     X1 = SP
     *     X2 = base + 0x26F2E0
     *     X3 = base + 0x26F300
     *     X4 = &VmParam64 { base+0x129B24, stack_end, base+0x1256AC }
     *     BL 0x4CC10
     *
     * Pseudo-equivalent:
     *   run vmCode 0x1F7860 and write a ref-counted object pair to out_ref.
     */
    NativeVmp124DD4ParamWindow350 params = {
        .out_ref = out_ref,
        .block_a = block_a,
        .block_b = block_b,
        .extra_ref = extra_ref,
    };

    NativeVmpResultObject350 *result = pseudo_malloc(sizeof(*result));
    result->vtable_26f2c8 = (void *)0x26f2c8;
    result->material = vm_1f7860_build_mssdk_material(&params);

    out_ref->obj = result;
    out_ref->ref_count_ptr = pseudo_new_ref_count(1);
}

int selectValueFromNativeVmpMaterial_350(REF_MEM_BLOCK *dst,
                                         void *source_struct,
                                         MEM_BLOCK *selector_key,
                                         void *extra_ref)
{
    /*
     * Native anchor: 0x12564C.
     *
     * Observed caller-side layout:
     *   source_struct+0x08 -> copied into first MEM_BLOCK-ish input
     *   source_struct+0x48 -> copied into second MEM_BLOCK-ish input
     *   source_struct+0x28 -> passed as extra_ref
     *
     * Then it calls 0x124DD4 and scans:
     *   result        = out_ref.obj
     *   material      = result->material
     *   count         = material->kv_count
     *   item array    = material->kv_items
     *   item->key     at +0x18
     *   item->value   at +0x20
     */
    REF_OBJ out = {0};
    REF_MEM_BLOCK block_a = pseudo_ref_mem_from(source_struct, 0x08);
    REF_MEM_BLOCK block_b = pseudo_ref_mem_from(source_struct, 0x48);

    nativeVmpBuildMssdkMaterial_350(&out, &block_a, &block_b, extra_ref);

    NativeVmpResultObject350 *result = out.obj;
    if (result == NULL || result->material == NULL) {
        return 0;
    }

    MetaSecMssdkMaterial350 *m = result->material;
    for (uint64_t i = 0; i < m->kv_count; i++) {
        MetaSecMssdkKeyValue350 *item = m->kv_items[i];
        if (item == NULL) {
            continue;
        }

        if (pseudo_memblock_equals_cstr(selector_key, item->key)) {
            /*
             * Native code allocates a new MEM_BLOCK from item->value and calls
             * the generic setObjectAddRef helper on the destination ref.
             */
            dst->mem = pseudo_new_mem_block_from_cstr(item->value);
            dst->ref_count_ptr = pseudo_new_ref_count(1);
            return 1;
        }
    }

    return 0;
}

/*
 * Concrete serialization observed before free(0x72f7348d90):
 *
 * message MetaSecMssdkMaterialProto350 {
 *   sint32 seed_id      = 1;  // 0x20200924 << 1 => 1077940808
 *   string module_name  = 2;  // "mssdk"
 *   string app_id       = 3;  // "1588093228"
 *   int32  enabled      = 4;  // 1
 *   string sdk_version  = 5;  // "1128"
 *   sint32 salt_id      = 6;  // 0x5fa25885 << 1 => 3208950026
 *   AppInfo app_info    = 7;  // package + 32-byte material
 *   KeyValue kv         = 8;  // repeated twice: common_key/sign_key
 * }
 */

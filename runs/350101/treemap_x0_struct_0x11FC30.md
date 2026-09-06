# rev-struct 报告：treeMapPut_350 (0x11FC30) 的 X0 参数结构

- 目标：`libmetasec_ml.so` 35.1.0（study 副本 md5 与原库一致：d71025b0…）
- IDB：`douyin_35_0_0/libmetasec_ml.so.i64`（IDA MCP :13338）
- 日期：2026-09-06
- 范围：**只报告，未修改 IDA**

## 结论

X0 是一个 40 字节（0x28）的红黑树 map 对象 `TREE_MAP`，托管 key/value 对的生命周期（free_key/free_value/cmp 三个策略函数指针 + 一个惰性分配的 TREE_HEAD）。C++ std::map 风格的手写实现，vtable 提供析构/克隆多态。

## 最小结构体定义

```c
typedef void (*tree_free_fn)(void *p);
typedef int  (*tree_cmp_fn)(const void *a, const void *b);

struct TREE_MAP_VT {                    // size 0x30, 实例在 off_26F1B8 / off_2700B0 / off_26F150
    void (*freeTreeMap1)(TREE_MAP *);   // +0x00  0x120704  析构变体1
    void (*freeTreeMap2)(TREE_MAP *);   // +0x08  0x120734 (mono_gc_free_fixed_57)
    void (*freeTreeMap3)(TREE_MAP *);   // +0x10  0x1207B8
    void (*f_BAA84)();                  // +0x18  0x120834
    void (*f_BAB34)();                  // +0x20  0x1208E4
    void (*freeTreeMap0)(TREE_MAP *);   // +0x28  0x120980
};

struct TREE_MAP {                       // size 0x28, newMem(0x28)
    TREE_MAP_VT *vt;                    // +0x00  vtable
    tree_free_fn free_key;              // +0x08  覆盖写时释放旧 key
    tree_free_fn free_value;            // +0x10  覆盖写时释放旧 value
    tree_cmp_fn  cmp;                   // +0x18  key 比较函数（构造时传给 RB 树）
    TREE_HEAD   *tree_head_ptr;         // +0x20  惰性分配的 RB 树头（_c_map_0 写入）
};

struct TREE_KV {                        // size 0x10, newTreeKV_350
    void *key;                          // +0x00
    void *value;                        // +0x08
};

struct REF_TREE_MAP {                   // size 0x10, 调用侧持有的引用包装
    TREE_MAP *tree;                     // +0x00
    long     *ref_count_ptr;            // +0x08
};
```

## 字段证据与置信度

| 偏移 | 字段 | 证据地址 | 证据内容 | 置信度 |
|------|------|----------|----------|--------|
| +0x00 | vt | 0x1206e4 | `initTreeMapFuns`: `tree_map->vt = off_26F1B8` | 高 |
| +0x00 | vt（子类覆盖） | 0x127b44 | `initTreeMap_0`: 构造后改写为 `off_2700B0` | 高 |
| +0x08 | free_key | 0x1206f4（写）/ treeMapPut_350 内 `map->free_key(key)`（调用） | 覆盖插入时释放旧 key | 高 |
| +0x10 | free_value | 0x1206f4（写，同 16B 拷贝）/ treeMapPut_350 内 `map->free_value(kv->value)`（调用） | 覆盖插入时释放旧 value | 高 |
| +0x18 | cmp | 0x1206f8（写 funs[2]）→ `_c_map_0(&tree_head_ptr, cmp)` → `rb_tree_ctor` → `rbTreeFindExact_350` 0x10f344 `head->compare(...)` | 比较函数最终落到 TREE_HEAD，被查找/插入使用 | 高（TREE_MAP 本体仅在构造期读出转发） |
| +0x20 | tree_head_ptr | 0x10e964 `_c_map_0`: `*a1 = v4`（a1=&tree_map->tree_head_ptr）；treeMapPut_350 内传给 rbTreeFindExactFromHeadPtr_350 / rbTreeEndFromHeadPtr_350 / rbTreeFindOrPrepareUniqueInsertFromHeadPtr_350 | RB 树头指针，TREE_HEAD 0x28 字节 | 高 |

vtable 6 槽（0x26F1B8 实测）：0x120704 / 0x120734 / 0x1207B8 / 0x120834 / 0x1208E4 / 0x120980，与类型库 TREE_MAP_VT 定义一致——置信度：高。

## 构造链（map 来源）

```
newTreeMapObj 0x120000            initTreeMap_0 0x127af4
  └ newMem(0x28)                    └ initTreeMapFuns 0x1206dc
  └ initCookieBodyListInner 0x11fc08      ├ +0x00 vt = off_26F1B8（后被覆盖 off_2700B0）
      ├ +0x00 vt = off_26F150             ├ +0x08/+0x10 = funs[0..1]（free_key/free_value）
      ├ +0x08..+0x18 = funs               ├ +0x18 = funs[2]（cmp）
      └ initTreeHead(+0x20)               └ _c_map_0 0x10e930 → malloc TREE_HEAD(0x28) + rb_tree_ctor(cmp)
```

注：`newTreeMapObj`（vtable off_26F150）与 `initTreeMapFuns`（off_26F1B8）是同布局的两个多态变体；`buildSignedHttpHeadersInner_350` 里的输出 map（X22/v58）由 `newTreeMapObj` 经 REF_TREE_MAP 包装产生。

## 调用者（xrefs_to 0x11FC30，共 40 处，节选）

- `buildSignedHttpHeadersInner_350`：0x14a2b0 / 0x14a320 / 0x14a53c / 0x14a65c —— 写入 X-Gorgon、X-Khronos、X-Argus、X-Ladon、X-Medusa（0x14a53c 即 unidbg proto dump 证实的 X-Medusa 写入点）
- 包装层：`treeMapPut_X22_X27_X28_350` 0x14d29c、`treeMapPut_X22_X23_X24_350` 0x14d30c、`treeMapPutDoubleValue_350` 0x120e5c
- 解析层：`parseCrlfPairsToTree_350` 0x14f058、`parseCrlfPairsToTree2_350` 0x14f354
- 其余 ~30 处为各业务模块的 map 写入（commitReportNet_0、setUpdateSettingItemValue_int 等）

## 直接 callee 字段使用验证

| callee | 地址 | 对 X0 派生物的使用 |
|--------|------|--------------------|
| rbTreeFindExactFromHeadPtr_350 | 0x10e914 | 解引用 tree_head_ptr → rbTreeFindExact_350，内部用 head->compare（即构造期传入的 cmp）做 lower_bound + 等值判定 |
| rbTreeEndFromHeadPtr_350 | 0x10e824 | 解引用 tree_head_ptr 取 end 迭代器 |
| newTreeKV_350 | 0x11fbdc | newMem(0x10) 造 TREE_KV{key,value}，不触 TREE_MAP 字段 |
| rbTreeFindOrPrepareUniqueInsertFromHeadPtr_350 | 0x10e8fc | 解引用 tree_head_ptr 做唯一插入定位 |

## 与 unidbg trace 的互证

- X-Medusa 的 treeMapPut（LR=0x14a530 附近）value 已是 base64 终值；key/value 均为 MEM_BLOCK 字符串，free_key/free_value 即 MEM_BLOCK 的释放函数——与 0x1206f4 处 funs 注入模式一致。
- 字符串解密入口 decryptStringDispatch350=0x12d018 产出的明文经 copyStringMemBlock2 包装后作为 key 传入本函数。

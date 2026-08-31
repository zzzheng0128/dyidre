#!/usr/bin/env bash
set -euo pipefail

# 更新 MetaSec 分析材料 manifest。
#
# 为什么需要这个脚本：
# - 每次 IDA 改名、补结构体、补中文注释后，`.i64` 会变化；
# - 每次换 APK/SO 后，`libmetasec_ml.so` 或 APK 会变化；
# - 提交前必须把这些材料的 hash/大小/来源记录下来，否则后面升级版本时
#   很难判断“当前结论到底对应哪个 APK、哪个 SO、哪个 IDA 库”。
#
# 常用：
#   scripts/update_materials_manifest.sh --apk douyin_35_0_0/dy351_vivo.apk 350101 \
#     douyin_35_0_0/libmetasec_ml.so \
#     douyin_35_0_0/libmetasec_ml.so.i64
#
# 检查 manifest 是否过期，不写文件：
#   scripts/update_materials_manifest.sh --check --apk douyin_35_0_0/dy351_vivo.apk 350101 \
#     douyin_35_0_0/libmetasec_ml.so \
#     douyin_35_0_0/libmetasec_ml.so.i64
#
# 只打印到 stdout，不写文件：
#   scripts/update_materials_manifest.sh --stdout --apk douyin_35_0_0/dy351_vivo.apk 350101 \
#     douyin_35_0_0/libmetasec_ml.so \
#     douyin_35_0_0/libmetasec_ml.so.i64

usage() {
  cat <<'EOF'
usage:
  update_materials_manifest.sh [--check|--stdout] [--apk <apk_path>] <version> <so_path> <ida_i64_path> [out_md]

default out_md:
  materials/<version>/materials_manifest.md

examples:
  scripts/update_materials_manifest.sh --apk douyin_35_0_0/dy351_vivo.apk 350101 \
    douyin_35_0_0/libmetasec_ml.so \
    douyin_35_0_0/libmetasec_ml.so.i64

  scripts/update_materials_manifest.sh --check --apk douyin_35_0_0/dy351_vivo.apk 350101 \
    douyin_35_0_0/libmetasec_ml.so \
    douyin_35_0_0/libmetasec_ml.so.i64
EOF
}

mode="write"
apk_path=""
while [[ $# -gt 0 ]]; do
  case "${1:-}" in
    --check)
      mode="check"
      shift
      ;;
    --stdout)
      mode="stdout"
      shift
      ;;
    --apk)
      [[ $# -ge 2 ]] || {
        usage >&2
        exit 2
      }
      apk_path="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -lt 3 || $# -gt 4 ]]; then
  usage >&2
  exit 2
fi

version="$1"
so_path="$2"
i64_path="$3"

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
dyidre_root="$(CDPATH= cd -- "${script_dir}/.." && pwd -P)"
out_md="${4:-${dyidre_root}/materials/${version}/materials_manifest.md}"
display_so_path="$so_path"
display_i64_path="$i64_path"
display_apk_path="$apk_path"

die() {
  echo "[materials] $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "$path" ]] || die "missing file: $path"
}

abs_path() {
  local path="$1"
  local dir
  local base
  dir="$(CDPATH= cd -- "$(dirname -- "$path")" && pwd -P)"
  base="$(basename -- "$path")"
  printf '%s/%s\n' "$dir" "$base"
}

sha256_file() {
  local path="$1"
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$path" | awk '{print $1}'
  elif command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$path" | awk '{print $1}'
  else
    die "need shasum or sha256sum"
  fi
}

file_size() {
  local path="$1"
  if stat -f '%z' "$path" >/dev/null 2>&1; then
    stat -f '%z' "$path"
  else
    stat -c '%s' "$path"
  fi
}

file_mtime() {
  local path="$1"
  if stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S %z' "$path" >/dev/null 2>&1; then
    stat -f '%Sm' -t '%Y-%m-%d %H:%M:%S %z' "$path"
  else
    stat -c '%y' "$path"
  fi
}

file_desc() {
  local path="$1"
  if command -v file >/dev/null 2>&1; then
    file -b "$path"
  else
    printf 'n/a'
  fi
}

apk_embedded_so_paths() {
  local path="$1"
  if command -v unzip >/dev/null 2>&1; then
    unzip -Z1 "$path" 2>/dev/null | grep -E '(^|/)libmetasec_ml\.so$' | paste -sd ', ' -
  fi
}

apk_first_embedded_so_path() {
  local path="$1"
  if command -v unzip >/dev/null 2>&1; then
    unzip -Z1 "$path" 2>/dev/null | grep -E '(^|/)libmetasec_ml\.so$' | sed -n '1p'
  fi
}

apk_embedded_so_sha256() {
  local path="$1"
  local inner="$2"
  [[ -n "$inner" ]] || return 0
  if command -v unzip >/dev/null 2>&1; then
    if command -v shasum >/dev/null 2>&1; then
      unzip -p "$path" "$inner" 2>/dev/null | shasum -a 256 | awk '{print $1}'
    elif command -v sha256sum >/dev/null 2>&1; then
      unzip -p "$path" "$inner" 2>/dev/null | sha256sum | awk '{print $1}'
    fi
  fi
}

build_id() {
  local path="$1"
  if command -v readelf >/dev/null 2>&1; then
    local id
    id="$(readelf -n "$path" 2>/dev/null | awk '/Build ID:/ {print $3; exit}')"
    if [[ -n "$id" ]]; then
      printf '%s\n' "$id"
      return 0
    fi
  fi
  if command -v file >/dev/null 2>&1; then
    file -b "$path" | sed -n 's/.*BuildID\[sha1\]=\([0-9a-fA-F]*\).*/\1/p'
  fi
}

emit_manifest() {
  local so_abs="$1"
  local i64_abs="$2"
  local apk_abs="$3"
  local so_build_id="$4"
  local apk_cmd_update=""
  local apk_cmd_check=""
  local apk_row=""
  local apk_section=""
  local embedded_paths=""
  local embedded_first=""
  local embedded_sha=""
  local embedded_match="n/a"

  if [[ -n "$apk_abs" ]]; then
    apk_cmd_update=" --apk ${display_apk_path}"
    apk_cmd_check=" --apk ${display_apk_path}"
    apk_row="| APK | \`${display_apk_path}\` | $(file_size "$apk_abs") | $(file_mtime "$apk_abs") | \`$(sha256_file "$apk_abs")\` |"
    embedded_paths="$(apk_embedded_so_paths "$apk_abs")"
    embedded_first="$(apk_first_embedded_so_path "$apk_abs")"
    embedded_sha="$(apk_embedded_so_sha256 "$apk_abs" "$embedded_first")"
    if [[ -n "$embedded_sha" ]]; then
      if [[ "$embedded_sha" == "$(sha256_file "$so_abs")" ]]; then
        embedded_match="yes"
      else
        embedded_match="no"
      fi
    fi
    apk_section="$(cat <<APKEOF

## APK 信息

| key | value |
|---|---|
| file | \`$(file_desc "$apk_abs")\` |
| embedded libmetasec_ml.so paths | \`${embedded_paths:-n/a}\` |
| first embedded libmetasec_ml.so sha256 | \`${embedded_sha:-n/a}\` |
| embedded SO matches raw SO | \`${embedded_match}\` |
APKEOF
)"
  fi

  cat <<EOF
# ${version} analysis materials manifest

这个文件记录当前分析结论对应的原始材料。提交前如果换了 APK/SO、更新了 IDA 注释/结构体/重命名，都要重新生成它。

更新命令：

\`\`\`bash
scripts/update_materials_manifest.sh${apk_cmd_update} ${version} \\
  ${display_so_path} \\
  ${display_i64_path}
\`\`\`

检查是否过期：

\`\`\`bash
scripts/update_materials_manifest.sh --check${apk_cmd_check} ${version} \\
  ${display_so_path} \\
  ${display_i64_path}
\`\`\`

## 材料状态

| role | path | size | mtime | sha256 |
|---|---|---:|---|---|
| raw SO | \`${display_so_path}\` | $(file_size "$so_abs") | $(file_mtime "$so_abs") | \`$(sha256_file "$so_abs")\` |
| IDA i64 | \`${display_i64_path}\` | $(file_size "$i64_abs") | $(file_mtime "$i64_abs") | \`$(sha256_file "$i64_abs")\` |
${apk_row}

## SO 信息

| key | value |
|---|---|
| file | \`$(file_desc "$so_abs")\` |
| build-id | \`${so_build_id:-n/a}\` |
${apk_section}

## 提交前约束

- 改过 IDA 函数名、结构体、原型、中文注释后，必须保存 \`.i64\` 并重新跑本脚本。
- 换过 APK 或 \`libmetasec_ml.so\` 后，必须重新跑本脚本，并同步更新 \`metasec_so_identity.md\`。
- 默认把 \`.apk/.so/.i64\` 本体放在 \`materials/${version}/\` 并纳入提交历史；这样 APK 来源、SO、IDA 数据库每次改动都有 git 记录。
- 如果后续改用 Git LFS，也要确保 LFS pointer 和本 manifest 的 hash 对应同一份二进制。
- 不要让 \`versions/${version}/\` 的结论对应一个旧 APK/SO/\`.i64\`，这是后续版本升级最容易埋雷的地方。
EOF
}

require_file "$so_path"
require_file "$i64_path"
if [[ -n "$apk_path" ]]; then
  require_file "$apk_path"
fi

so_abs="$(abs_path "$so_path")"
i64_abs="$(abs_path "$i64_path")"
apk_abs=""
if [[ -n "$apk_path" ]]; then
  apk_abs="$(abs_path "$apk_path")"
fi
so_build_id="$(build_id "$so_abs")"

expected_so_abs="${dyidre_root}/materials/${version}/libmetasec_ml.so"
expected_i64_abs="${dyidre_root}/materials/${version}/libmetasec_ml.so.i64"
expected_apk_abs="${dyidre_root}/materials/${version}/source.apk"
if [[ "$so_abs" == "$expected_so_abs" ]]; then
  display_so_path="materials/${version}/libmetasec_ml.so"
fi
if [[ "$i64_abs" == "$expected_i64_abs" ]]; then
  display_i64_path="materials/${version}/libmetasec_ml.so.i64"
fi
if [[ -n "$apk_abs" && "$apk_abs" == "$expected_apk_abs" ]]; then
  display_apk_path="materials/${version}/source.apk"
fi

tmp_file="$(mktemp "${TMPDIR:-/tmp}/metasec-materials.XXXXXX")"
emit_manifest "$so_abs" "$i64_abs" "$apk_abs" "$so_build_id" > "$tmp_file"

if [[ "$mode" == "stdout" ]]; then
  cat "$tmp_file"
  rm -f "$tmp_file"
  exit 0
fi

if [[ "$mode" == "check" ]]; then
  if [[ ! -f "$out_md" ]]; then
    rm -f "$tmp_file"
    die "manifest missing: $out_md"
  fi
  if ! diff -u "$out_md" "$tmp_file"; then
    rm -f "$tmp_file"
    die "manifest is stale, rerun without --check: $out_md"
  fi
  rm -f "$tmp_file"
  echo "[materials] manifest is up to date: $out_md"
  exit 0
fi

mkdir -p "$(dirname -- "$out_md")"
mv "$tmp_file" "$out_md"
chmod 0644 "$out_md"
echo "[materials] updated: $out_md"

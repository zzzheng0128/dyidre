#!/usr/bin/env bash
set -euo pipefail

# 同步 MetaSec 分析材料本体。
#
# 提交前推荐只跑这个脚本：
#   scripts/sync_metasec_materials.sh 350101 \
#     douyin_35_0_0/libmetasec_ml.so \
#     douyin_35_0_0/libmetasec_ml.so.i64 \
#     douyin_35_0_0/dy351_vivo.apk
#
# 它会做四件事：
# 1. 把当前分析用的 SO 复制到 materials/<version>/libmetasec_ml.so
# 2. 把当前 IDA 数据库复制到 materials/<version>/libmetasec_ml.so.i64
# 3. 把当前对应 APK 复制到 materials/<version>/source.apk
# 4. 重新生成 materials/<version>/materials_manifest.md
#
# 可以从上级工作区执行，也可以从 dyidre 仓库根目录执行。
# 如果源路径在当前目录不存在，脚本会尝试到 dyidre 的上级目录查找。
# 注意：这里用 cp -p，保留原始文件 mtime，manifest 更稳定。

usage() {
  cat <<'EOF'
usage:
  sync_metasec_materials.sh <version> <so_path> <ida_i64_path> [apk_path]

example:
  scripts/sync_metasec_materials.sh 350101 \
    douyin_35_0_0/libmetasec_ml.so \
    douyin_35_0_0/libmetasec_ml.so.i64 \
    douyin_35_0_0/dy351_vivo.apk
EOF
}

if [[ $# -lt 3 || $# -gt 4 ]]; then
  usage >&2
  exit 2
fi

version="$1"
so_src="$2"
i64_src="$3"
apk_src="${4:-}"

script_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
dyidre_root="$(CDPATH= cd -- "${script_dir}/.." && pwd -P)"
dst_dir="${dyidre_root}/materials/${version}"
so_dst="${dst_dir}/libmetasec_ml.so"
i64_dst="${dst_dir}/libmetasec_ml.so.i64"
apk_dst="${dst_dir}/source.apk"

die() {
  echo "[materials-sync] $*" >&2
  exit 1
}

resolve_input_file() {
  local path="$1"
  if [[ -f "$path" ]]; then
    printf '%s\n' "$path"
    return 0
  fi
  if [[ "$path" != /* && -f "${dyidre_root}/../${path}" ]]; then
    printf '%s\n' "${dyidre_root}/../${path}"
    return 0
  fi
  printf '%s\n' "$path"
}

so_real="$(resolve_input_file "$so_src")"
i64_real="$(resolve_input_file "$i64_src")"
apk_real=""
if [[ -n "$apk_src" ]]; then
  apk_real="$(resolve_input_file "$apk_src")"
fi

[[ -f "$so_real" ]] || die "missing SO: $so_src"
[[ -f "$i64_real" ]] || die "missing IDA i64: $i64_src"
if [[ -n "$apk_src" ]]; then
  [[ -f "$apk_real" ]] || die "missing APK: $apk_src"
fi

mkdir -p "$dst_dir"
cp -p "$so_real" "$so_dst"
cp -p "$i64_real" "$i64_dst"
chmod 0644 "$so_dst" "$i64_dst"

if [[ -n "$apk_src" ]]; then
  cp -p "$apk_real" "$apk_dst"
  chmod 0644 "$apk_dst"
  "${script_dir}/update_materials_manifest.sh" --apk "$apk_dst" "$version" "$so_dst" "$i64_dst"
else
  "${script_dir}/update_materials_manifest.sh" "$version" "$so_dst" "$i64_dst"
fi

echo "[materials-sync] synced SO : $so_dst"
echo "[materials-sync] synced i64: $i64_dst"
if [[ -n "$apk_src" ]]; then
  echo "[materials-sync] synced APK: $apk_dst"
fi

#!/usr/bin/env bash
set -euo pipefail

# 安装 dyidre 的 git pre-commit hook。
#
# 用法：
#   cd /path/to/dyidre
#   git init                         # 如果这里还不是 git 仓库
#   scripts/install_pre_commit_hook.sh
#
# 安装后每次 git commit 都会自动执行：
#   githooks/pre-commit

usage() {
  cat <<'EOF'
usage:
  install_pre_commit_hook.sh [repo_root]

examples:
  cd /path/to/dyidre
  git init
  scripts/install_pre_commit_hook.sh

  scripts/install_pre_commit_hook.sh /path/to/dyidre
EOF
}

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 2
fi

if [[ $# -eq 1 ]]; then
  cd "$1"
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [[ -z "$repo_root" ]]; then
  echo "[dyidre hook] 当前目录还不是 git 仓库。先在要提交 dyidre 的目录执行 git init。" >&2
  exit 1
fi

cd "$repo_root"

if [[ -f "githooks/pre-commit" && -d "materials" && -d "versions" ]]; then
  project_prefix=""
  hooks_path="githooks"
elif [[ -f "dyidre/githooks/pre-commit" && -d "dyidre/materials" && -d "dyidre/versions" ]]; then
  project_prefix="dyidre/"
  hooks_path="dyidre/githooks"
else
  echo "[dyidre hook] 找不到 dyidre 仓库布局。请在 dyidre 仓库根目录，或包含 dyidre/ 的上级仓库执行。" >&2
  exit 1
fi

hook_path="${project_prefix}githooks/pre-commit"
[[ -f "$hook_path" ]] || {
  echo "[dyidre hook] missing $hook_path" >&2
  exit 1
}

chmod +x \
  "$hook_path" \
  "${project_prefix}scripts/sync_metasec_materials.sh" \
  "${project_prefix}scripts/update_materials_manifest.sh" \
  "${project_prefix}scripts/generate_version_file_catalog.py"

current_hooks_path="$(git config --get core.hooksPath || true)"
if [[ -n "$current_hooks_path" && "$current_hooks_path" != "$hooks_path" ]]; then
  echo "[dyidre hook] 当前 core.hooksPath=$current_hooks_path，将改成 $hooks_path" >&2
fi

git config core.hooksPath "$hooks_path"

echo "[dyidre hook] installed: core.hooksPath=$hooks_path"
echo "[dyidre hook] pre-commit will sync materials listed in ${project_prefix}materials/materials_sources.tsv"

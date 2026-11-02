#!/bin/sh
# 拉取上游最新源码并合入本仓库的本地改动，推送后由 GitHub Actions 产出 APK 与 Windows ZIP。
# 用法：scripts/sync_upstream.sh [上游远端名] [分支]
set -e
remote=${1:-upstream}
branch=${2:-main}
here=$(cd "$(dirname "$0")/.." && pwd)
cd "$here"
git fetch "$remote"
if ! git merge --no-edit "$remote/$branch"; then
  echo "上游有冲突，已中止合并，请手动解决后重新推送：git merge --abort 已执行" >&2
  git merge --abort || true
  exit 1
fi
git push build "$branch"

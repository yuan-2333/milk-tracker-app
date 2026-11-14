#!/bin/sh
# 把最新的网页版应用同步到安卓工程 assets 中
# 用法：在仓库根目录执行 sh sync-web.sh
set -e
cd "$(dirname "$0")"
SRC="../milk-tracker.html"
DST="app/src/main/assets/index.html"
if [ ! -f "$SRC" ]; then
  echo "找不到 $SRC（应放在本工程上一级目录，与 apk-project 同级）"
  exit 1
fi
cp "$SRC" "$DST"
echo "已同步：$SRC -> $DST"
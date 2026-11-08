#!/usr/bin/env sh
# Packs the skill for upload to Claude: skill/coros-nutrition-log/ plus the page (index.html),
# with the skill folder as the ZIP root. Output: coros-nutrition-log.zip (not tracked in git).
set -eu
cd "$(dirname "$0")/.."
name=coros-nutrition-log
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/$name"
cp -R "skill/$name/." "$tmp/$name/"
cp index.html "$tmp/$name/index.html"
rm -f "$name.zip"
(cd "$tmp" && zip -qr - "$name") > "$name.zip"
echo "Built $name.zip"

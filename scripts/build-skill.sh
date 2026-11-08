#!/usr/bin/env sh
# Packs the skill for upload to Claude: skill/coros-nutrition-log/ plus the page (index.html),
# with the skill folder as the ZIP root. Output: claude-coros-nutrition-log.zip (not tracked in git).
# The skill itself is named coros-nutrition-log: Claude doesn't allow "claude" in skill names.
set -eu
cd "$(dirname "$0")/.."
name=coros-nutrition-log
zip_name=claude-coros-nutrition-log.zip
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir "$tmp/$name"
cp -R "skill/$name/." "$tmp/$name/"
cp index.html "$tmp/$name/index.html"
rm -f "$zip_name"
(cd "$tmp" && zip -qr - "$name") > "$zip_name"
echo "Built $zip_name"

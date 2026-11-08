#!/usr/bin/env sh
# Copies the page into the skill folder and packs the skill as a ZIP for upload to Claude.
set -eu
cd "$(dirname "$0")/.."
cp index.html skill/coros-nutrition-log/index.html
rm -f coros-nutrition-log.zip
(cd skill && zip -qr ../coros-nutrition-log.zip coros-nutrition-log)
echo "Built coros-nutrition-log.zip"

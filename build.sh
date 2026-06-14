#!/usr/bin/env bash
# Regenerate the per-theme install zips in dist/.
#
# NetNewsWire installs the FIRST .nnwtheme it finds inside a downloaded
# zip, so each theme needs its own single-theme archive for the
# netnewswire://theme/add?url=... install links in the README to work.
# Run this after changing any theme, then commit the updated zips.

set -euo pipefail
cd "$(dirname "$0")"
mkdir -p dist

for theme in *.nnwtheme; do
	name="${theme%.nnwtheme}"
	rm -f "dist/${name}.zip"
	zip -r -X -q "dist/${name}.zip" "$theme" -x '*.DS_Store'
	echo "built dist/${name}.zip"
done

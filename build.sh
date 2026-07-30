#!/usr/bin/env bash
# Regenerate the per-theme install zips in dist/.
#
# NetNewsWire installs the FIRST .nnwtheme it finds inside a downloaded
# zip, so each theme needs its own single-theme archive for the
# netnewswire://theme/add?url=... install links in the README to work.
# Run this after changing any theme, then commit the updated zips.
#
# Builds are byte-reproducible: each theme is zipped from a temp copy
# with a fixed timestamp and a sorted file list (in UTC, since zip
# stores local-time DOS timestamps), so rebuilding unchanged sources
# yields byte-identical zips and `git status` after a build is a true
# drift check.

set -euo pipefail
cd "$(dirname "$0")"
mkdir -p dist

export TZ=UTC
stamp=202601010000

for theme in *.nnwtheme; do
	name="${theme%.nnwtheme}"
	dest="$PWD/dist/${name}.zip"
	tmp=$(mktemp -d)
	cp -R "$theme" "$tmp/"
	find "$tmp/$theme" -name .DS_Store -delete
	find "$tmp/$theme" -exec touch -t "$stamp" {} +
	rm -f "$dest"
	(cd "$tmp" && find "$theme" -type f | LC_ALL=C sort | zip -X -q "$dest" -@)
	rm -rf "$tmp"
	echo "built dist/${name}.zip"
done

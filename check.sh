#!/usr/bin/env bash
# Render and test each theme in WebKit with NetNewsWire's real renderer, via
# the community nnw-theme tool (https://github.com/dave-atx/nnw-theme).
#
#   ./check.sh            # every theme
#   ./check.sh Folio      # just one
#
# Unlike preview.sh, this runs the app's own core.css, main.js, and
# newsfoot.js (pinned to a NetNewsWire release and verified by hash) and
# renders on Mac, iPhone, and iPad in light and dark, plus large text and
# Article JavaScript off. It fails on things like footnote markers that
# don't resolve, blocked network requests, or an invalid Info.plist.
#
# It can't judge how a page looks, and the large-text cases only produce
# screenshots, so open the galleries it writes to preview/check/<Theme>/.
#
# nnw-theme expects a repository with exactly one .nnwtheme folder, so each
# theme is checked from a temp copy alongside this repo's fixtures/. Needs
# Node 24+; run `npx nnw-theme@1 setup` once per machine to install WebKit.

set -euo pipefail
cd "$(dirname "$0")"

tmp=
trap 'rm -rf "$tmp"' EXIT

check() {
	local theme="$1"
	local dir="$theme.nnwtheme"
	local out="$PWD/preview/check/$theme"
	[ -d "$dir" ] || { echo "no such theme: $theme" >&2; return 1; }

	rm -rf "$tmp"
	tmp=$(mktemp -d)
	cp -R "$dir" fixtures "$tmp/"

	echo "== $theme"
	# The warnings about missing template-repository stubs (AGENTS.md, the
	# GitHub workflows) don't apply to this repo, so drop them, along with
	# the tool's own gallery path, which is in the temp copy. Only the
	# tool's exit status counts; grep's depends on what was left to print.
	set +e
	(cd "$tmp" && npx --yes nnw-theme@1 check --no-open 2>&1) \
		| grep -v -e '^warning: .* is missing; add the current stub' -e '^Preview: '
	local status=${PIPESTATUS[0]}
	set -e

	rm -rf "$out"
	mkdir -p "$(dirname "$out")"
	if [ -d "$tmp/build/preview" ]; then
		cp -R "$tmp/build/preview" "$out"
		echo "gallery: preview/check/$theme/index.html"
	fi
	return "$status"
}

failed=()
if [ "$#" -gt 0 ]; then
	themes=("${@%.nnwtheme}")
else
	themes=()
	for dir in *.nnwtheme; do
		themes+=("${dir%.nnwtheme}")
	done
fi
for theme in "${themes[@]}"; do
	check "$theme" || failed+=("$theme")
done

if [ "${#failed[@]}" -gt 0 ]; then
	echo "FAILED: ${failed[*]}" >&2
	exit 1
fi

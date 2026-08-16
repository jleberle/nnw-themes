#!/usr/bin/env bash
# Render a sample article with a theme, for looking at a change without
# reinstalling into NetNewsWire.
#
#   ./preview.sh            # every theme
#   ./preview.sh Folio      # just one
#
# Output goes to preview/<Theme>.html (gitignored). The page is built from
# the theme's real template.html and stylesheet.css with the same [[…]]
# substitutions NetNewsWire makes, so what you see is what the theme does —
# with two caveats. The app also injects core.css and main.js, which do a
# fair amount of work on feed markup (wrapping tables in .nnw-overflow and
# height-less iframes in .iframeWrap, absoluting image URLs, stripping the
# feed's own inline styles). core.css is pulled from an installed
# NetNewsWire.app when one is present; main.js is not run. And a browser is
# not WKWebView. Check anything subtle in the app itself.

set -euo pipefail
cd "$(dirname "$0")"

app_core_css="/Applications/NetNewsWire.app/Contents/Resources/core.css"
outdir="preview"
mkdir -p "$outdir"

core_css=""
if [ -r "$app_core_css" ]; then
	core_css=$(cat "$app_core_css")
else
	echo "note: $app_core_css not found — previewing without the app's core.css" >&2
fi

# A deliberately awkward article: a wide table, a height-less embed, a long
# unbroken URL, code, a blockquote, a figure, and a broken image — the cases
# the themes have specific handling for.
read -r -d '' body <<'BODY' || true
<p>The opening paragraph, long enough to show the measure and the line height
the theme settles on, and to give <a href="https://example.com/some/path">an
inline link</a> somewhere to sit inside running prose.</p>

<h2>A section heading</h2>

<p>A second paragraph with <code>inline_code()</code> and an
em&nbsp;dash&thinsp;—&thinsp;plus a deliberately overlong URL to test wrapping:
https://example.com/an/unreasonably/long/path/that/will/not/fit/on/one/line/at/any/measure</p>

<blockquote><p>A single-paragraph pull quote, which Eustace italicizes and the
others leave upright.</p></blockquote>

<pre><code>def render(theme):
    return theme.stylesheet + theme.template
</code></pre>

<figure>
  <img src="https://example.invalid/broken.png" alt="A deliberately broken image">
  <figcaption>This figure should collapse entirely — the image cannot load.</figcaption>
</figure>

<table>
  <thead><tr><th>Theme</th><th>Typeface</th><th>Screen</th><th>Accent at rest</th><th>Accent on hover</th></tr></thead>
  <tbody>
    <tr><td>Folio</td><td>Georgia</td><td>Phone-first</td><td>Warm red</td><td>Deeper red</td></tr>
    <tr><td>Quiet</td><td>System sans</td><td>Phone-first</td><td>None</td><td>Blue</td></tr>
    <tr><td>Eustace</td><td>Hoefler Text</td><td>Desktop</td><td>Scarlet</td><td>Deeper scarlet</td></tr>
    <tr><td>Atrium</td><td>System sans</td><td>Desktop</td><td>None</td><td>Blue</td></tr>
  </tbody>
</table>

<hr>

<p>A closing paragraph after the section break.</p>
BODY

render() {
	local theme="$1"
	local dir="$theme.nnwtheme"
	local out="$outdir/$theme.html"
	[ -d "$dir" ] || { echo "no such theme: $theme" >&2; return 1; }

	# Same substitutions ArticleRenderer makes. external_link is deliberately
	# empty, which is the common case and the one that used to leave a stray
	# focusable <a href=""> behind.
	BODY="$body" THEME="$theme" CORE="$core_css" \
		python3 - "$dir/template.html" "$dir/stylesheet.css" <<-'PY' > "$out"
		import os, sys
		template = open(sys.argv[1]).read()
		stylesheet = open(sys.argv[2]).read()
		theme = os.environ["THEME"]
		subs = {
		    "title": f"A Sample Article, Set in {theme}",
		    "preferred_link": "https://example.com/sample-article",
		    "external_link_label": "",
		    "external_link_stripped": "",
		    "external_link": "",
		    "feed_link_title": "The Sample Feed",
		    "feed_link": "https://example.com",
		    "byline": "Ada Lovelace",
		    "avatar_src": "",
		    "dateline_style": "articleDateline",
		    "datetime_medium": "16 Aug 2026 at 09:41",
		    "text_size_class": "mediumText",
		    "body": os.environ["BODY"],
		}
		for key, value in subs.items():
		    template = template.replace(f"[[{key}]]", value)
		print("<!DOCTYPE html>")
		print('<html lang="en"><head><meta charset="utf-8">')
		print('<meta name="viewport" content="width=device-width, initial-scale=1">')
		print(f"<title>{theme} preview</title>")
		print("<style>", os.environ["CORE"], "</style>")
		print("<style>", stylesheet, "</style>")
		print("</head><body>")
		print(template)
		print("</body></html>")
	PY
	echo "wrote $out"
}

if [ "$#" -gt 0 ]; then
	for theme in "$@"; do
		render "${theme%.nnwtheme}"
	done
else
	for dir in *.nnwtheme; do
		render "${dir%.nnwtheme}"
	done
fi

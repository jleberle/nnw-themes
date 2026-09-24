# NetNewsWire themes

[![License: MIT-0](https://img.shields.io/badge/License-MIT--0-blue.svg)](LICENSE)

Four reading themes for [NetNewsWire](https://netnewswire.com), all built for comfortable, distraction-free reading. They pair off by typeface and screen:

|         | Phone-first | Desktop-first |
| ------- | ----------- | ------------- |
| Serif   | **Folio**   | **Eustace**   |
| Sans    | **Quiet**   | **Atrium**    |

## Folio

A phone-first serif theme modeled after my [website](https://jaredeberle.org) — Georgia type, a tightened measure, and a warm paper-light / charcoal-dark reading surface. Built for the small screen first with a fluid headline that scales to the viewport, safe-area-aware margins, tap feedback on links, and soft hyphenation in the narrow column, while staying comfortable at tablet and desktop widths. The serif counterpart to Quiet.

```
netnewswire://theme/add?url=https://raw.githubusercontent.com/jleberle/nnw-themes/main/dist/Folio.zip
```

## Quiet

A minimal, near-monochrome sans-serif theme built phone-first for comfortable reading on a small screen — a fluid headline that scales to the viewport, safe-area-aware margins, and tap feedback on links — while staying clean at tablet and desktop widths. Links take the text color with a hairline underline (the accent appears on hover or tap), and hierarchy is built from weight and whitespace rather than boxes or color.

```
netnewswire://theme/add?url=https://raw.githubusercontent.com/jleberle/nnw-themes/main/dist/Quiet.zip
```

## Eustace

A desktop-oriented serif theme in The New Yorker's house style — a Caslon-like face (Hoefler Text) and a centered masthead with the feed name as a scarlet department rubric, the headline in a standard weight, and a small-caps byline. The red accent gives way to a cool cyan in dark mode. The magazine layout is happiest at a roomy reading-pane width. Named for Eustace Tilley, the magazine's mascot.

```
netnewswire://theme/add?url=https://raw.githubusercontent.com/jleberle/nnw-themes/main/dist/Eustace.zip
```

## Atrium

The desktop-first sans theme — Quiet's minimal, near-monochrome sans styling scaled up for a roomy reading pane, with larger type, a confident headline, and generous whitespace. Links stay text-colored with a clearly visible underline (the accent appears on hover or tap), and hierarchy is built from weight and whitespace rather than boxes or color. The sans counterpart to Eustace, and the wide-screen counterpart to Quiet.

```
netnewswire://theme/add?url=https://raw.githubusercontent.com/jleberle/nnw-themes/main/dist/Atrium.zip
```

## Installing

Copy an install link above in a browser, or paste it into NetNewsWire. Each link points at a single-theme zip in [`dist/`](dist) — NetNewsWire installs the first `.nnwtheme` it finds in a download, so every theme ships in its own archive.

## Developing

The source of each theme lives in its `*.nnwtheme` folder. After editing one, regenerate the install zips and commit them:

```
./build.sh
```

To see a change without reinstalling the theme, render a sample article to a
file and open it in a browser:

```
./preview.sh Folio && open preview/Folio.html
```

The preview reuses the theme's real `template.html` and `stylesheet.css`, and
layers in NetNewsWire's own `core.css` from the installed app when it can find
it — so it is close to, but not a substitute for, checking the result in
NetNewsWire itself.

For the real renderer, check the themes with
[`nnw-theme`](https://github.com/dave-atx/nnw-theme), a community tool that
renders with NetNewsWire's own `core.css` and scripts in WebKit on Mac, iPhone,
and iPad, light and dark, at large text sizes and with Article JavaScript off:

```
npx nnw-theme@1 setup   # once per machine: installs WebKit
./check.sh              # or ./check.sh Folio
```

It needs Node 24 or newer. Each theme's gallery lands in
`preview/check/<Theme>/index.html`. Besides the tool's built-in articles it
renders [`fixtures/edge-cases.toml`](fixtures/edge-cases.toml), which covers
footnote markers and an empty external link.

CI ([GitHub Actions](.github/workflows/ci.yml)) checks that the committed
zips in `dist/` match the theme sources, so a forgotten rebuild fails the
pipeline. It also lints the shell scripts, validates each `Info.plist`, and asserts
that Folio, Quiet, and Atrium keep byte-identical `template.html` files, since
the shared image/link-repair script is copied across all four themes.

### Notes for theme authors

A few things about NetNewsWire's renderer are easy to get wrong, and all four
themes here depend on them:

- A theme's `stylesheet.css` **replaces** the app's default stylesheet rather
  than adding to it (`ArticleRenderer.styleString()` is
  `articleTheme.css ?? defaultStyleSheet`). Only `core.css` is always present.
  So a theme has to style the wrappers the app's `main.js` injects itself —
  `.nnw-overflow` around every article table, `.iframeWrap` around any iframe
  with no height attribute, and `iframe.nnw-constrained` — or wide tables scroll
  the whole pane sideways and some embeds collapse to 150px tall.
- Every `[[…]]` link substitution can be an empty string (an article whose
  external link matches its preferred link, a feed with no home page), which
  leaves `<a href="">`: an unlabeled, focusable link that reloads the article.
  The script in `template.html` unwraps those. If the reader has turned off
  Article JavaScript, that script never runs, so the stylesheet also disables
  empty links and hides the external-link row they leave empty.
- Text size works differently on each platform. On macOS the app puts a size
  class on the article body, and for the two largest settings it writes
  `xLargeText` and `xxLargeText` with a capital L, while the app's bundled
  themes select the lowercase spellings. Define both, or those settings fall
  back to a smaller size. On iOS and iPadOS the app sets no size class at all.
  It fills in the reader's Dynamic Type size wherever `[[font-size]]` appears in
  the stylesheet (17 at the default setting). These themes scale from that with
  `calc()`. On macOS the placeholder is left unfilled, so the declaration is
  invalid and the fixed size before it wins.
- NetNewsWire's `core.css` makes footnote markers `inline-block`, so a marker
  can wrap onto a line by itself. The template script puts each marker and the
  end of its word in a no-wrap span.

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

CI ([GitHub Actions](.github/workflows/ci.yml), mirrored in
[`.woodpecker.yml`](.woodpecker.yml) for Codeberg) checks that the committed
zips in `dist/` match the theme sources, so a forgotten rebuild fails the
pipeline. It also lints `build.sh`, validates each `Info.plist`, and asserts
that Folio, Quiet, and Atrium keep byte-identical `template.html` files, since
the shared image/link-repair script is copied across all four themes.

### Notes for theme authors

Two things about NetNewsWire's renderer are easy to get wrong, and all four
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
  The script in `template.html` unwraps those.

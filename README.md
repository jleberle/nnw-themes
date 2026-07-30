# NetNewsWire themes

Four reading themes for [NetNewsWire](https://netnewswire.com), all built for comfortable, distraction-free reading. They pair off by typeface and screen:

|         | Phone-first | Desktop-first |
| ------- | ----------- | ------------- |
| Serif   | **Folio**   | **Eustace**   |
| Sans    | **Quiet**   | **Atrium**    |

## Folio

A phone-first serif theme modeled after my [website](https://jaredeberle.org) — Georgia type, a tightened measure, and a warm paper-light / charcoal-dark reading surface. Built for the small screen first with a fluid headline that scales to the viewport, safe-area-aware margins, tap feedback on links, and soft hyphenation in the narrow column, while staying comfortable at tablet and desktop widths. The serif counterpart to Quiet.

```
netnewswire://theme/add?url=https://codeberg.org/jle/nnw-themes/raw/branch/main/dist/Folio.zip
```

## Quiet

A minimal, near-monochrome sans-serif theme built phone-first for comfortable reading on a small screen — a fluid headline that scales to the viewport, safe-area-aware margins, and tap feedback on links — while staying clean at tablet and desktop widths. Links take the text color with a hairline underline (the accent appears on hover or tap), and hierarchy is built from weight and whitespace rather than boxes or color.

```
netnewswire://theme/add?url=https://codeberg.org/jle/nnw-themes/raw/branch/main/dist/Quiet.zip
```

## Eustace

A desktop-oriented serif theme in The New Yorker's house style — a Caslon-like face (Hoefler Text) and a centered masthead with the feed name as a scarlet department rubric, the headline in a standard weight, and a small-caps byline. The red accent gives way to a cool cyan in dark mode. The magazine layout is happiest at a roomy reading-pane width. Named for Eustace Tilley, the magazine's mascot.

```
netnewswire://theme/add?url=https://codeberg.org/jle/nnw-themes/raw/branch/main/dist/Eustace.zip
```

## Atrium

The desktop-first sans theme — Quiet's minimal, near-monochrome sans styling scaled up for a roomy reading pane, with larger type, a confident headline, and generous whitespace. Links stay text-colored with a clearly visible underline (the accent appears on hover or tap), and hierarchy is built from weight and whitespace rather than boxes or color. The sans counterpart to Eustace, and the wide-screen counterpart to Quiet.

```
netnewswire://theme/add?url=https://codeberg.org/jle/nnw-themes/raw/branch/main/dist/Atrium.zip
```

## Installing

Copy an install link above in a browser, or paste it into NetNewsWire. Each link points at a single-theme zip in [`dist/`](dist) — NetNewsWire installs the first `.nnwtheme` it finds in a download, so every theme ships in its own archive.

## Developing

The source of each theme lives in its `*.nnwtheme` folder. After editing one, regenerate the install zips and commit them:

```
./build.sh
```

CI ([`.woodpecker.yml`](.woodpecker.yml)) checks that the committed zips in `dist/` match the theme sources, so a forgotten rebuild fails the pipeline.

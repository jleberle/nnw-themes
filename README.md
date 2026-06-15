# NetNewsWire themes

Three reading themes for [NetNewsWire](https://netnewswire.com), all built for comfortable, distraction-free reading.

## Folio

A serif theme modeled after my [website](https://jaredeberle.org) — Georgia type, a tightened measure, and a warm paper-light / charcoal-dark reading surface.

```
netnewswire://theme/add?url=https://codeberg.org/jleberle/nnw-theme/raw/branch/main/dist/Folio.zip
```

## Quiet

A minimal, near-monochrome sans-serif theme focused on readability. Links take the text color with a hairline underline (the accent only appears on hover), and hierarchy is built from weight and whitespace rather than boxes or color.

```
netnewswire://theme/add?url=https://codeberg.org/jleberle/nnw-theme/raw/branch/main/dist/Quiet.zip
```

## Eustace

A serif theme in The New Yorker's house style — a Caslon-like face (Hoefler Text), a centered masthead with the feed name as a scarlet department rubric, a small-caps byline, and a drop cap to open each article. Named for Eustace Tilley, the magazine's mascot.

```
netnewswire://theme/add?url=https://codeberg.org/jleberle/nnw-theme/raw/branch/main/dist/Eustace.zip
```

## Installing

Click an install link above in a browser, or paste it into NetNewsWire. Each link points at a single-theme zip in [`dist/`](dist) — NetNewsWire installs the first `.nnwtheme` it finds in a download, so every theme ships in its own archive.

## Developing

The source of each theme lives in its `*.nnwtheme` folder. After editing one, regenerate the install zips and commit them:

```
./build.sh
```

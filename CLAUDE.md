# nnw-themes — session notes

README.md describes the four themes and how to install them. This file is the
build contract.

## One theme per zip, because NetNewsWire installs the first one it finds

A downloaded archive containing several `.nnwtheme` folders installs only the
first. That is why `build.sh` emits a separate single-theme zip per theme, and
why the `netnewswire://theme/add?url=…` links in README.md point at individual
archives in `dist/`. Don't consolidate them.

## The zips are byte-reproducible, and `git status` is the drift check

`build.sh` zips each theme from a temp copy with `TZ=UTC`, a fixed timestamp,
and a sorted file list (zip stores local-time DOS timestamps, hence the TZ
pin). Rebuilding unchanged sources yields byte-identical archives.

The payoff: **after `./build.sh`, a dirty `git status` means a theme actually
changed.** Anything that reintroduces nondeterminism — an unsorted listing, a
real mtime, a zip implementation that stores extra attributes — breaks that
silently. The build keeps succeeding; it just starts producing a new blob every
run, and the drift signal is gone.

## `dist/` is committed and the install URLs are live

The README's install links resolve to
`raw.githubusercontent.com/jleberle/nnw-themes/main/dist/<Theme>.zip`. So a
push to `main` publishes immediately — there is no release step, and a broken
zip in `dist/` is broken for everyone the moment it lands. Edit the
`*.nnwtheme` source, run `./build.sh`, and commit source and zips together.

## Source of truth is the `*.nnwtheme` folder

Each theme's real source is its folder at the repo root; `dist/` is output.
Editing inside a zip is lost on the next build.

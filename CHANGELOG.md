# Changelog

Versions here are the `Version` integer in each theme's `Info.plist`; all four
themes are versioned together.

## 3 — 2026-08-16

Correctness and accessibility pass across all four themes.

### Fixed

- **Wide tables no longer scroll the whole reading pane sideways.** The app's
  `main.js` wraps every article table in `<div class="nnw-overflow">`, but the
  `overflow-x: auto` for it lives in NetNewsWire's default stylesheet — which a
  custom theme replaces rather than extends. Each theme now supplies it.
- **Embeds with no height attribute no longer collapse to 150px.** Same cause:
  `.iframeWrap` (and `iframe.nnw-constrained`) are now styled by the themes
  instead of being inherited from a stylesheet that isn't loaded. Podcast and
  music players were the visible casualties; the video-host allowlist had
  already covered YouTube and Vimeo.
- **No more empty, focusable links.** NetNewsWire substitutes an empty string
  for a link it doesn't have — an article whose external link matches its
  preferred link (the common case), or a feed with no home page — leaving
  `<a href="">`, an unlabeled tab stop that reloads the article. The template
  script now unwraps those and drops the external-link row when it is empty.
- **Quiet and Atrium: the dateline failed WCAG AA.** `--faint` measured 2.83:1
  in light mode and 3.30:1 in dark; it is now 4.64:1 and 4.63:1, still clearly
  quieter than `--secondary`. Every other color in all four themes already
  passed.
- **A broken image inside a multi-image figure no longer hides the figure.**
  Only the failed image is collapsed unless it was the figure's sole picture.
- Silenced the `TypeError` from the app's `reloadArticleImage()`, which
  dereferences `#nnwImageIcon` unguarded. These themes show the feed as type
  rather than an icon, so the element is present but hidden.
- Feed markup can no longer push the column sideways with an explicit `width`;
  the app strips inline `max-width` but not `width`, so `div`, `svg`, and
  `figure` are capped alongside the media elements.
- All four README install links pointed at a Codeberg repository that returns
  404. They now point at the GitHub raw URLs, which resolve.

### Added

- **Print styles.** Printing an article (File › Print) now drops to black on
  white, uses the page's own margins, keeps figures, quotes, code, and tables
  off page breaks, and spells out link targets.
- **`prefers-contrast: more` support.** The muted tones collapse onto the full
  ink color and link underlines thicken.
- Safe-area insets in Atrium and Eustace, so the desktop-oriented pair survive
  an iPad in landscape.

### Changed

- Captions scale with the reader's text-size preference (`em` rather than a
  `rem` pinned to the 16px root).
- `-webkit-text-size-adjust: none` → `100%`, plus the unprefixed property.
  `none` can block user-initiated text scaling.
- Dropped the deprecated `word-break: break-word`; the `overflow-wrap:
  break-word` beside it already did the work. The external-link row uses
  `overflow-wrap: anywhere` instead of `word-break: break-all`, which was also
  breaking the label.
- Section-break ornaments carry empty alt text so VoiceOver doesn't read them.

### Repository

- `preview.sh` renders a sample article with a theme for checking a change in a
  browser.
- CI runs on GitHub Actions as well as Woodpecker, and now also lints the
  shell scripts, validates each `Info.plist`, and asserts that the three
  themes sharing a `template.html` haven't drifted apart.
- `build.sh` cleans up its temp directory on failure and normalizes file modes,
  so the zips stay byte-reproducible.
- Added `.editorconfig`.

## 2

Readability pass, macOS integration, collapsing broken images, deterministic
builds, and Woodpecker CI. See the git history.

## 1

Initial release of Folio, Quiet, Eustace, and Atrium.

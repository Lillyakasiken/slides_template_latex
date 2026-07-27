# UZH Beamer Theme — with THU-style navigation

A LaTeX Beamer theme that combines the **visual style** of the official
[UZH Corporate Design (CD)](https://www.cd.uzh.ch/) with the **navigation
features** of the [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme).

The corporate colours, fonts, logo and helper commands come from the UZH
template; the section navigation bar, automatic outline slides and code styling
are adapted from the THU theme. All strings and the demo are in English.

## Usage

```latex
\documentclass[aspectratio=169,onlytextwidth]{beamer}
\usetheme[english]{uzh}   % institution label: english or german
```

See `template.tex` for a full example, and build it with:

```bash
latexmk -pdf template.tex        # runs pdflatex + bibtex automatically
```

The theme is based on the `beamer` class, so all the usual commands and
environments (`\section`, `\frametitle`, `columns`, blocks, …) work as normal.

## Features adapted from the THU theme

- **Section navigation bar** at the top of every slide, showing the section
  names, mini-frame progress dots, and the current subsection — recoloured to
  the UZH blue palette.
- **Automatic outline slides**: a table of contents is shown at the start of
  every section, with the current section highlighted and the others shaded.
  Rename the title with `\renewcommand{\outlinename}{Agenda}`.
  Subsection outline slides are off by default; the snippet to enable them is in
  `uzhnavigation.sty`.
- **Slide counter** in the footer: `current / total`.
- **Coloured blocks** (`block`, `exampleblock`, `alertblock`) in UZH blue,
  apple and berry.
- **Source-code listings** styled in the UZH palette — load `\usepackage{uzhcode}`
  (see below) and mark code frames `[fragile]`.

## Helper commands (from the UZH template)

- **`\fillimage[<options>]{<width>}{<height>}{<image-path>}`** — insert an image
  that fills the given width and height, centred and cropped as needed. Options
  are passed to `\includegraphics`.
  Example: `\fillimage{\textwidth}{5cm}{my-image.jpg}`
- **`\imagecard[<height>]{<image-path>}{<title>}{<subtitle>}`** — an image card
  with a title and subtitle below it.
  Example: `\imagecard[5cm]{my-image.jpg}{Title}{Subtitle}`
- **`\numberoverlay{<content>}`** — display a huge number (or any content) on a
  blue background. Other content on the slide is hidden.
  Example: `\numberoverlay{42}`

### Code helpers (from `uzhcode`)

Load `\usepackage{uzhcode}` after the theme. It configures `listings` in the UZH
palette and provides:

- **`\cmd{section}`** → typesets `\section` as an inline LaTeX command (blue)
- **`\env{itemize}`** → typesets `itemize` as an inline environment name (apple)

## Colours

The theme makes the CD colour palette available. Each colour has an accent plus
five shades (e.g. `uzh@blue`, `uzh@blue1` … `uzh@blue5`).

| Color name | Accent                 | Shade 1                    | Shade 2                    | Shade 3                    | Shade 4                    | Shade 5                    |
| ---------- | ---------------------- | -------------------------- | -------------------------- | -------------------------- | -------------------------- | -------------------------- |
| Blue       | `uzh@blue` `#0028a5`   | `uzh@blue1` `#bdc9e8`      | `uzh@blue2` `#7596ff`      | `uzh@blue3` `#3062ff`      | `uzh@blue4` `#001e7c`      | `uzh@blue5` `#001452`      |
| Cyan       | `uzh@cyan` `#4ac9e3`   | `uzh@cyan1` `#dbf4f9`      | `uzh@cyan2` `#b7e9f4`      | `uzh@cyan3` `#92dfee`      | `uzh@cyan4` `#1ea7c4`      | `uzh@cyan5` `#147082`      |
| Apple      | `uzh@apple` `#a4d233`  | `uzh@apple1` `#ecf6d6`     | `uzh@apple2` `#dbedad`     | `uzh@apple3` `#c8e485`     | `uzh@apple4` `#7ca023`     | `uzh@apple5` `#536b18`     |
| Gold       | `uzh@gold` `#ffc845`   | `uzh@gold1` `#fff4da`      | `uzh@gold2` `#ffe9b5`      | `uzh@gold3` `#ffde8f`      | `uzh@gold4` `#f3ab00`      | `uzh@gold5` `#a27200`      |
| Orange     | `uzh@orange` `#fc4c02` | `uzh@orange1` `#ffdbcc`    | `uzh@orange2` `#feb799`    | `uzh@orange3` `#fe9367`    | `uzh@orange4` `#bd3902`    | `uzh@orange5` `#7e2601`    |
| Berry      | `uzh@berry` `#bf0d3e`  | `uzh@berry1` `#fbc6d4`     | `uzh@berry2` `#f78caa`     | `uzh@berry3` `#f3537f`     | `uzh@berry4` `#8f0a2e`     | `uzh@berry5` `#60061f`     |
| Grey       |                        | `uzh@grey1` `#666666`      | `uzh@grey2` `#c2c2c2`      | `uzh@grey3` `#a3a3a3`      | `uzh@grey4` `#4d4d4d`      | `uzh@grey5` `#333333`      |
| Light Grey |                        | `uzh@lightgrey1` `#fafafa` | `uzh@lightgrey2` `#efefef` | `uzh@lightgrey3` `#e7e7e7` | `uzh@lightgrey4` `#e0e0e0` | `uzh@lightgrey5` `#d7d7d7` |

Convenience wrappers: `\uzhblue{…}`, `\uzhcyan{…}`, `\uzhapple{…}`,
`\uzhgold{…}`, `\uzhorange{…}`, `\uzhberry{…}`. Or use the named colours
directly, e.g. `\textcolor{uzh@blue}{Blue text}`.

## Files

| File | Purpose |
| ---- | ------- |
| `beamerthemeuzh.sty` | Main theme: loads the sub-themes, installs the THU-style navigation bar and recolours it |
| `beamercolorthemeuzh.sty` | Colour palette, block, alert and table-of-contents colours |
| `beamerfontthemeuzh.sty` | Fonts (Source Sans Pro) |
| `beamerinnerthemeuzh.sty` | Itemize dashes, title/section pages |
| `beamerouterthemeuzh.sty` | Logo header, frame title, footer (with slide counter) |
| `uzhnavigation.sty` | Automatic section outline slides + TOC styling |
| `uzhcode.sty` | Optional: UZH-styled `listings` and the `\cmd` / `\env` helpers |
| `uzhsetup.sty` | Shared setup and the `\fillimage` / `\imagecard` / `\numberoverlay` helpers |
| `template.tex` | Demo presentation showcasing every feature |
| `ref.bib` | Example bibliography for the demo |

## Requirements

A TeX Live / MacTeX installation with, among the standard packages:
`beamer`, `sourcesans` (Source Sans Pro), `ly1`, `listings`, `booktabs`,
`babel-english`. Compile with `pdflatex` (via `latexmk`).

## Accessibility

PDFs produced by LaTeX are not accessible to screen readers. Use the
`latex2html.sh` script (requires [Pandoc](https://pandoc.org/)) to convert a
presentation into a self-contained HTML file:

```bash
./latex2html.sh my-presentation.tex
```

Provide alternative texts for images via the `alt` option, e.g.
`\includegraphics[width=5cm,alt={Alternative text}]{img.jpg}` or
`\fillimage[alt={}]{5cm}{3cm}{decorative.jpg}` for decorative images.

## Credits

- UZH corporate-design Beamer theme — the style layer of this template.
- [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme) by TUNA — the
  navigation-bar and outline features this template adapts.

# slides_template_latex

A Beamer theme and an A0 poster layer in the
[UZH Corporate Design](https://www.cd.uzh.ch/) (colours, fonts, logo), with the
navigation of the [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme):
section bar, outline slides, slide counter, step reveals, and styles for
blocks, code, tables and DAGs.

```
slides_template_latex/
├── Makefile        build engine for talks and posters
├── uzhsetup.sty    shared helpers (\uzhsup, \fillimage, \occasion, ...)
├── img/            UZH logo, DM3L wordmark, demo photos
├── slides/         beamer theme, optional packages, demo deck
└── poster/         A0 poster layer (uzhposter.sty), demo poster
```

## Quick start

```bash
cd slides && make    # template.pdf and template_short.pdf
cd poster && make    # template.pdf
```

```latex
\documentclass[aspectratio=169,onlytextwidth]{beamer}
\usetheme[english]{uzh}   % institution label: english or german
```

`slides/template.tex` shows every feature. Standard Beamer commands work as
usual.

## Two PDFs from one source

| | `<doc>.pdf` | `<doc>_short.pdf` |
| --- | --- | --- |
| Use | presenting | printing, reading |
| Pages per frame | one per overlay | one |
| Step reveals | current point black, earlier points grey | final all-black state |
| Outline slides | before each section and subsection | omitted (`\uzhoutlineson` keeps them) |
| Demo | 62 pages | 22 pages |

The short PDF is built in Beamer's handout mode from a generated
`<doc>_short.tex`. The step helpers render in full colour in handout mode, so
frames need no extra markup.

## Building

Run `make` in the directory of the `.tex` file. It builds every top-level
`.tex` file there with `latexmk`.

| Target | Output |
| ------ | ------ |
| `make` | `<doc>.pdf` and `<doc>_short.pdf` |
| `make pdf` | `<doc>.pdf` |
| `make short` | `<doc>_short.pdf` (alias `make shorter`) |
| `make draft` | `<doc>-draft.pdf`, without the navigation bar (~1.5 s instead of ~3.7 s per change) |
| `make frames FRAMES=a,b` | `<doc>-frames.pdf`, only the frames with these labels (~0.75 s) |
| `make watch` / `make watch-draft` | rebuild on save |
| `make html` | HTML export via Pandoc (see [Accessibility](#accessibility)) |
| `make clean` | remove build files, keep PDFs |
| `make cleanall` | remove build files and PDFs |

`make frames` needs labelled frames, e.g.
`\begin{frame}[label=math]{Mathematics}`. Its output has no navigation bar and
wrong slide numbers.

Each build mode has its own driver file (`*_short.tex`, `*-draft.tex`,
`*-frames.tex`) and `.aux` files. Do not edit or commit the driver files.

In a poster directory, `draft`, `short`, `frames`, `watch-draft` and `html`
are not available.

## Navigation (from the THU theme)

- **Section bar** at the top of each slide: sections, mini-frame dots, current
  subsection.
- **Outline slides** before each section and subsection. Only the current
  section shows its subsections.
  - `\renewcommand{\outlinename}{Agenda}` renames the title.
  - `\uzhoutlinesoff` / `\uzhoutlineson` turns all outline slides off / on.
  - `\uzhautooutlinesoff` keeps only the opening overview.
  - `\makeatletter\let\uzh@outline@subsection\@empty\makeatother` drops the
    per-subsection slides.
  - `\renewcommand{\uzhtocparskip}{0pt}` tightens a long outline.
- **Opening overview**: `\uzhoutlineframe` after `\maketitle`. Lists sections
  only. Use a frame with `\tableofcontents` to include subsections.
- **Numbered references** `[1]`, `[2]`, …. For the default icon:
  `\setbeamertemplate{bibliography item}[triangle]`.
- **Slide counter** `current / total`. With `appendixnumberbeamer`, the total
  stops at the last main frame and the appendix restarts at 1.
- **Contents button** at the right end of the bar on appendix frames. It links
  to the opening overview. Rename with
  `\renewcommand{\uzhtocbuttonname}{Overview}`. Not shown without an opening
  overview (e.g. in the short PDF).
- **Blocks**: `block` has a pale blue title bar (`uzh@blue1`) on a near-white
  body; `exampleblock` and `alertblock` use apple and berry. A strong blue
  variant is in `beamercolorthemeuzh.sty`.

## Helpers (`uzhsetup`)

- `\fillimage[<opts>]{<w>}{<h>}{<file>}` — image cropped to fill `w` × `h`.
  Options go to `\includegraphics`.
- `\imagecard[<h>]{<file>}{<title>}{<subtitle>}` — image with title and
  subtitle below.
- `\numberoverlay{<content>}` — large content on a blue background over the
  slide.
- `\uzhsup{<content>}` — superscript at 75 % size, raised 0.375 em, as in
  `DM\uzhsup{3}L`.
- `\uzhtinycites` — in the preamble: small, raised, grey `\cite` marks.
- `\uzhtightmath{<above>}{<below>}` — less space around displayed math. Short
  skips are two thirds of the values. `\dagtightmath` is a preset.

### Frames (`uzhframes`)

- `\uzhbibframe[<columns>]{<bib file>}` — references on one slide, two columns
  by default, `\scriptsize`. Redefine `\uzhbibname`, `\uzhbibstyle` (default
  `abbrv`) or `\uzhbibfont` to change it. For long lists, use a frame with
  `[allowframebreaks]`.
- `\uzhthanksframe` — closing slide. Redefine `\uzhthanksname` and
  `\uzhquestionsname` to change the text.

### Step reveal (`uzhnavigation`, loaded by the theme)

One point per overlay: the current point is black, earlier points are grey. A
final overlay shows the whole slide in black.

- `\setsteps{<n>}` — first command in the frame body. The frame has `n+3`
  overlays; the last is all black. `\setsteps{0}` is valid.
- `\steptitle{<title>}` — frame title that fades. Use it only when the title
  should turn grey.
- `\stepnote{<prose>}` — intro text above the list; fades.
- `steplist` with `\stepitem[<overlay>]{<text>}` — item `k` appears on overlay
  `k+1` by default. If you set overlays, set them on all items, and choose
  `\setsteps` so that `n+3` is the final overlay:

  ```latex
  \setsteps{1}                 % 4 overlays
  \stepnote{Intro …}
  \begin{steplist}
    \stepitem[1]{… with the intro}
    \stepitem[2]{… then this}
    \stepitem[3]{… then this}
  \end{steplist}
  ```

- `\steprangeitem{<first>}{<last>}{<text>}` — item black from `first` to
  `last`.
- `\stepsummary{<prose>}` — closing line, hidden until the list is grey.

For blocks, prose and figures, reveal the part yourself and set its colour:

- `\stepblockfade{<k>}` — a block: `\uncover<k->{{\stepblockfade{k} … }}`.
- `\stepblockrangefade{<first>}{<last>}` — a block that stays in colour from
  `first` to `last`, e.g. while its items appear.
- `\steptextfade{<k>}` — prose. Reveal it with `\onslide<k->`, not `\uncover`,
  which breaks `\[ \]` and `align*`. The same applies to blocks with display
  math.
- `\steprangefade{<first>}{<last>}` — black from `first` to `last`.
- `\stepsetfade{<list>}` — black on a list of overlays, e.g. `{4,6}`. Works in
  math mode.
- `\stepifpast{<first>}{<last>}{<past>}{<current>}` — branch version of
  `\steprangefade`, e.g. for TikZ styles:

  ```latex
  {\steprangefade{1}{2}%
   \stepifpast{1}{2}{\tikzset{dagabsent/.append style={draw=uzh@steppast}}}{}%
   \begin{dagfig} … \end{dagfig}}
  ```

- `\stepifinset{<list>}{<past>}{<current>}` — branch version of
  `\stepsetfade`.
- `\stepcell{<first>}{<last>}{<cell>}` — table cell that appears on `first`,
  is black to `last`, then grey:
  `\stepcell{2}{2}{ABETA} & \stepcell{2}{2}{continuous} \\`.
- `\stepnofade` — keeps a part black, e.g. a figure that later steps refer to:
  `\onslide<2->{\stepnofade \begin{tikzpicture} … \end{tikzpicture}}`.

All fade helpers except `\stepnofade` need `\setsteps` earlier in the frame.

### Code (`uzhcode`)

`\usepackage{uzhcode}` after the theme: `listings` in UZH colours (code frames
need `[fragile]`), plus `\cmd{section}` (blue) and `\env{itemize}` (apple).

### DAGs (`uzhdag`)

`\usepackage{uzhdag}` after the theme. Loads TikZ with `arrows.meta`,
`backgrounds` and `shapes.geometric`.

- `dagnode` — node: `\node[dagnode] (a) at (0,0) {$a_t$};`
- `dagedge` — edge: `\draw[dagedge] (a) -- (b);`
- `dagabsent` — absent edge, dashed muted berry.
- `dagsmall` — 0.7 cm nodes; set it on the picture:
  `\begin{tikzpicture}[x=1.4cm, y=0.9cm, dagsmall]`.
- `dagmatharray` — equations flush left at a fixed indent (`\dagmathindent`,
  default 1.5 em). The body is an `alignedat` with three column pairs: left
  side, relation and right side, note. Start each row with `&`:

  ```latex
  \begin{dagmatharray}
    & a_t &&{}= C_{11} a_{t-1} & \quad & C_{11} = 1 \\
    & b_t &&{}= C_{21} a_{t-1} &       & C_{21} = 0
  \end{dagmatharray}
  ```

#### abn data and results

See the subsection "abn data and results" in `slides/template.tex`.

- Node shapes (as `plot(mp)`): `abngauss` (circle), `abnbin` (rectangle),
  `abnpois` (ellipse), `abnmult` (diamond); base style `abnnode`.
- `\varrow{<step>}{<name>}{<symbol>}{<type>}` — row of a `lccl` variable
  table; type is `continuous`, `binary`, `count` or `category`. Appears on
  `step`, then grey.
- `\nodeicon{<step>}{<type>}` — the node shape alone.
- Arrows: `hyplit` (literature, solid), `hypass` (assumption, dashed),
  `abnkey=<width>` (hypothesis arrow in a learned DAG; width = strength),
  `abnminor` (added by abn, grey), `abnmiss` (missed or reversed, berry).
- Coefficient labels: `coef`, `coefkey` (bold), `coefminor`, `coefmiss`:
  `\draw[abnkey=2pt] (a) -- (b) node[coef, above right] {$-0.81$};`
- `\cf[<overlay>]{<sign>}{<number>}` — sign first, number from `overlay`
  (default 4).
- `\gtype{<GLM type>}` — GLM type at the right of an arrow cell.
  `\readas{<text>}` — grey line under a row.
- `alt=<spec>{<keys a>}{<keys b>}` — keys by overlay:
  `\draw[abnkey, alt=<2>{draw=uzh@berry}{}] …`
- `visible on=<spec>` — draw only on these overlays; layout does not move.

Step fade in a DAG (needs `\setsteps`):

- `step on=<k>` — scope of arrows: appears on `k`, then grey.
- `step node={<k>}{<list>}` — node: appears on `k`, black on `list`.
- `step fade=<k>`, `step keep=<list>` — the fade rules without the reveal.
- `steppast` — all `uzhdag` styles in grey. Extend it with
  `steppast/.append style={mystyle/.append style={draw=uzh@steppast}}`.

Time slices (columns x = 0, 1, 2 for t−1, t, t+1):

- `\tsslice{<last column>}{<lowest y>}{<depth>}{<half width>}` — background
  band per slice and a time axis.
- `lag=<width>` — arrow to the next slice (grey).
- `same=<width>` — arrow within a slice (blue, with halo). Draw after `lag`.
- `ts snapshot` — on the picture: overlay 1 shows slice t, overlay 2 all.
  Mark slice parts with `ts col=c` and other lag arrows with `ts lag`. Put
  `ts col` on a scope around `same` arrows.

## Patterns for long talks

### A frame that comes back

Put the body in a macro and use it in two frames with the same label:

```latex
\newcommand{\structurelearningbody}{ … the steps … }

\begin{frame}<beamer:1-2|handout:1>[label=abn]{\steptitle{How are arrows found}}
  \structurelearningbody
\end{frame}

\begin{frame}[label=abn]{Score --- a toy example}
  …
\end{frame}

\mode<beamer>{%
\begin{frame}<3-4>[label=abn]{\steptitle{How are arrows found}}
  \structurelearningbody
\end{frame}}
```

The deck shows overlays 1–2, then the example, then overlays 3–4. The short PDF
shows the frame once.

### Appendix

```latex
\appendix
\section*{Appendix}
```

Appendix frames are not in the overview, have their own slide count, and show
the Contents button.

## Colours

Each colour has an accent and five shades, e.g. `uzh@blue`, `uzh@blue1` …
`uzh@blue5`.

| Colour name | Accent                 | Shade 1                    | Shade 2                    | Shade 3                    | Shade 4                    | Shade 5                    |
| ----------- | ---------------------- | -------------------------- | -------------------------- | -------------------------- | -------------------------- | -------------------------- |
| Blue        | `uzh@blue` `#0028a5`   | `uzh@blue1` `#bdc9e8`      | `uzh@blue2` `#7596ff`      | `uzh@blue3` `#3062ff`      | `uzh@blue4` `#001e7c`      | `uzh@blue5` `#001452`      |
| Cyan        | `uzh@cyan` `#4ac9e3`   | `uzh@cyan1` `#dbf4f9`      | `uzh@cyan2` `#b7e9f4`      | `uzh@cyan3` `#92dfee`      | `uzh@cyan4` `#1ea7c4`      | `uzh@cyan5` `#147082`      |
| Apple       | `uzh@apple` `#a4d233`  | `uzh@apple1` `#ecf6d6`     | `uzh@apple2` `#dbedad`     | `uzh@apple3` `#c8e485`     | `uzh@apple4` `#7ca023`     | `uzh@apple5` `#536b18`     |
| Gold        | `uzh@gold` `#ffc845`   | `uzh@gold1` `#fff4da`      | `uzh@gold2` `#ffe9b5`      | `uzh@gold3` `#ffde8f`      | `uzh@gold4` `#f3ab00`      | `uzh@gold5` `#a27200`      |
| Orange      | `uzh@orange` `#fc4c02` | `uzh@orange1` `#ffdbcc`    | `uzh@orange2` `#feb799`    | `uzh@orange3` `#fe9367`    | `uzh@orange4` `#bd3902`    | `uzh@orange5` `#7e2601`    |
| Berry       | `uzh@berry` `#bf0d3e`  | `uzh@berry1` `#fbc6d4`     | `uzh@berry2` `#f78caa`     | `uzh@berry3` `#f3537f`     | `uzh@berry4` `#8f0a2e`     | `uzh@berry5` `#60061f`     |
| Grey        |                        | `uzh@grey1` `#666666`      | `uzh@grey2` `#c2c2c2`      | `uzh@grey3` `#a3a3a3`      | `uzh@grey4` `#4d4d4d`      | `uzh@grey5` `#333333`      |
| Light Grey  |                        | `uzh@lightgrey1` `#fafafa` | `uzh@lightgrey2` `#efefef` | `uzh@lightgrey3` `#e7e7e7` | `uzh@lightgrey4` `#e0e0e0` | `uzh@lightgrey5` `#d7d7d7` |

Text wrappers: `\uzhblue{…}`, `\uzhcyan{…}`, `\uzhapple{…}`, `\uzhgold{…}`,
`\uzhorange{…}`, `\uzhberry{…}`.

## Files

| File | Purpose |
| ---- | ------- |
| `Makefile` | Build engine, included by `slides/Makefile` and `poster/Makefile` |
| `uzhsetup.sty` | Shared setup and helpers |
| `img/` | UZH logo, DM3L wordmark (`UZH_dm3l.tex/.pdf`), demo photos |
| `slides/Makefile` | Includes `../Makefile` in beamer mode |
| `slides/beamerthemeuzh.sty` | Main theme, navigation bar |
| `slides/beamercolorthemeuzh.sty` | Colours for palette, blocks, alerts, TOC |
| `slides/beamerfontthemeuzh.sty` | Fonts (Source Sans Pro) |
| `slides/beamerinnerthemeuzh.sty` | Itemize, bibliography marker, title and section pages |
| `slides/beamerouterthemeuzh.sty` | Header, frame title, footer |
| `slides/uzhnavigation.sty` | Outline slides, TOC style, step reveal |
| `slides/uzhframes.sty` | `\uzhbibframe`, `\uzhthanksframe` |
| `slides/uzhcode.sty` | Optional: `listings` style, `\cmd`, `\env` |
| `slides/uzhdag.sty` | Optional: DAG styles, abn shapes, DAG step fade, time slices |
| `slides/template.tex` | Demo deck |
| `slides/ref.bib` | Demo bibliography, fallback for talks |
| `slides/latex2html.sh` | HTML export |
| `poster/Makefile` | Includes `../Makefile` in article mode (`BEAMER=0`) |
| `poster/uzhposter.sty` | A0 poster layer for `article` |
| `poster/template.tex` | Demo poster |

## Using the theme from another directory

Put your `.tex` file (and optionally a `ref.bib`) in a directory with this
`Makefile`:

```make
TEMPLATE := path/to/slides_template_latex/slides
include $(TEMPLATE)/Makefile
```

The `Makefile` adds `slides/` (or `poster/`) and the repository root to
`TEXINPUTS` and `BIBINPUTS`. A local `img/` or `ref.bib` takes precedence. All
targets work. If the directory is in another repository, add a `.gitignore`
for `*.pdf`, `*.html` and LaTeX build files (see this repository's
`.gitignore`).

## Poster (`uzhposter`)

A0 portrait layer for `article` documents: UZH colours, poster fonts, grey
`posterblock` boxes (I-Math style), an `Rcode` verbatim environment, header and
footer. It includes the `uzhdag` styles at poster scale under the same names.
No overlays or transparency.

Use the same two-line `Makefile` with `TEMPLATE := path/to/slides_template_latex/poster`.

```latex
\documentclass[10pt]{article}
\usepackage{uzhposter}
\usepackage{amsmath,amssymb}
\begin{document}
\posterheader{Department …}{My title}{Author\textsuperscript{1}}
  {\textsuperscript{1}Affiliation, University of Zurich}
\begin{posterbody}
  \postersection{First panel}
  …
  \begin{posterblock}{A block title} … \end{posterblock}
\end{posterbody}
\posterfooter{Reference one \ |\ Reference two}
\end{document}
```

`posterblock` takes `tcolorbox` options, e.g.
`[colbacktitle=uzhgreyD, coltitle=white, colframe=uzhgreyD]` for a dark block.
Poster colours use plain names (`uzhblue`, `uzhberry`, `uzhimathgrey`, …).

## Requirements

TeX Live, MacTeX or TinyTeX with `latexmk`, `pdflatex` and the packages
`beamer`, `sourcesans`, `ly1`, `lmodern`, `babel-english`,
`appendixnumberbeamer`, `booktabs`, `listings`, `multicol`, `varwidth`,
`fancyvrb`, `tikz`. Posters also need `tcolorbox` and `geometry`.
[Pandoc](https://pandoc.org/) is needed for `make html`.

TinyTeX: `tlmgr install sourcesans ly1 appendixnumberbeamer`.

## Accessibility

PDFs from LaTeX are not screen-reader friendly. `make html` (or
`slides/latex2html.sh my-presentation.tex`) converts a talk to a single HTML
file with Pandoc.

Set alt text with `alt`, e.g.
`\includegraphics[width=5cm,alt={Alternative text}]{img.jpg}`. Use `alt={}`
for decorative images.

## Credits

- Style layer: the UZH corporate-design Beamer theme.
- Navigation and outlines: adapted from the
  [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme) by TUNA.

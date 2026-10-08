# slides_template_latex

This repository provides a LaTeX **Beamer** theme and an **A0 poster** layer in
the official [UZH Corporate Design](https://www.cd.uzh.ch/) style (colours,
fonts, logo). The theme adds the navigation features of the
[THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme): a section
navigation bar, automatic outline slides, a slide counter, step-by-step
reveals, and UZH-styled blocks, code, tables and DAG diagrams. All strings and
demos are in English.

## Repository layout

```
slides_template_latex/
├── Makefile        shared build engine (talks and posters)
├── uzhsetup.sty    shared helpers (\uzhsup, \fillimage, \occasion, ...)
├── img/            shared images (UZH logo, DM3L wordmark, demo photos)
├── slides/         the beamer theme, its optional packages, the demo deck
└── poster/         the A0 poster layer (uzhposter.sty) and a demo poster
```

## Quick start

```bash
cd slides
make            # builds template.pdf and template_short.pdf
```

```bash
cd poster
make            # builds template.pdf
```

To use the theme in your own talk, load it after the document class:

```latex
\documentclass[aspectratio=169,onlytextwidth]{beamer}
\usetheme[english]{uzh}   % institution label: english or german
```

`slides/template.tex` demonstrates every feature and documents itself. Because
the theme builds on the `beamer` class, all the usual commands and environments
(`\section`, `\frametitle`, `columns`, blocks, …) work as normal. To use the
theme from another directory without copying it, see
[Using the theme from another directory](#using-the-theme-from-another-directory).

## Two PDFs from one source

Every talk produces two PDFs from the same `.tex` file. They share content,
layout and page order and differ only in how they treat the step reveals:

| | Stepped deck `<doc>.pdf` | Short PDF `<doc>_short.pdf` |
| --- | --- | --- |
| Purpose | presenting the talk | printing, mailing or reading after the talk |
| Pages per frame | one per overlay | exactly one |
| Step reveals | point by point: current point black, earlier points grey | collapsed to the frame's closing, all-black state |
| Outline slides | at the start of every section and subsection | dropped (keep them with `\uzhoutlineson`) |
| Demo (`slides/template.tex`) | 38 pages | 17 pages |

`make short` builds the short PDF in beamer's *handout* mode through a
generated `<doc>_short.tex` driver, so the main deck and its overlays stay
untouched. The step-reveal helpers recognise handout mode and render
everything in full colour there, so a frame needs no extra markup for the
short PDF.

The short PDF drops the outline slides because readers do not need them: the
navigation bar of every page already shows the sections and the current
position in the talk, so an outline page before each section only costs the
reader a page turn. To keep the outline slides in the short PDF as well, put
`\uzhoutlineson` in your preamble.

## Building with `make`

Run `make` in the directory that holds your `.tex` file: `slides/` for the demo
deck, `poster/` for the demo poster, or your own talk directory (see
[Using the theme from another directory](#using-the-theme-from-another-directory)).
`make` builds every top-level `.tex` file in that directory and writes the PDFs
next to it. It calls `latexmk`, which runs `pdflatex` and `bibtex` as often as
needed.

| Target | What it builds |
| ------ | -------------- |
| `make` | the stepped deck `<doc>.pdf` **and** the short `<doc>_short.pdf` |
| `make pdf` | the stepped deck only |
| `make short` | the short PDF only (alias: `make shorter`) |
| `make draft` | a fast build without the navigation bar, as `<doc>-draft.pdf` |
| `make frames FRAMES=a,b` | only the frames with these labels, as `<doc>-frames.pdf` — a layout preview |
| `make watch` / `make watch-draft` | a rebuild on every save (Ctrl-C to stop) |
| `make html` | an accessible Pandoc export (see [Accessibility](#accessibility)) |
| `make clean` | removes the build artifacts and keeps the PDFs |
| `make cleanall` | removes the build artifacts **and** the PDFs |

A typical editing session uses the faster targets while you work on the
content and the full build before you present:

```bash
make watch-draft              # live preview while you write; Ctrl-C to stop
make frames FRAMES=math       # check the layout of one or a few frames
make                          # final stepped deck + short PDF
make clean                    # tidy up; the PDFs stay
```

- **`make draft`** skips the section navigation bar, which accounts for about
  two thirds of each `pdflatex` pass. A one-line change then rebuilds in about
  1.5 s instead of 3.7 s. Everything below the header stays the same, so use
  the draft for content and run `make` before presenting.
- **`make frames`** typesets only the frames you name, in about 0.75 s however
  long the deck is. To use it, give the frames a label,
  e.g. `\begin{frame}[label=math]{Mathematics}`, and pass one or more labels:
  `make frames FRAMES=math,tables`. The preview has no navigation bar, and its
  slide numbers are meaningless; it shows the layout of single slides, not
  the deck. (The demo deck has no labels, so add one to try it.)
- **`make watch`** keeps `latexmk` running and rebuilds the PDF on every save.
  `make watch-draft` does the same with the draft build.

The draft, short and frames builds each use their own generated driver file
and `.aux` files, so they never invalidate the main build. Make rebuilds a PDF
whenever its `.tex`, a theme `.sty`, the bibliography or an image changes;
when nothing has changed, it reports that the PDF is up to date. The generated
driver files (`*_short.tex`, `*-draft.tex`, `*-frames.tex`) should not be
edited or committed.

In a poster directory, `make` builds only the plain PDF; the beamer-only
targets stop with a short message (see
[Poster template](#poster-template-uzhposter)).

## Features adapted from the THU theme

- **Section navigation bar.** The top of every slide shows the section names,
  mini-frame progress dots and the current subsection, recoloured to the UZH
  blue palette.
- **Automatic outline slides.** The theme shows a table of contents at the
  start of every section and every subsection. This table highlights the
  current entry and shades the other sections. It also expands only the
  **current section**: its subsections are listed, while those of all other
  sections stay hidden. The slide thus shows the shape of the whole talk
  together with the detail of the part that starts now:

  ```
  1  What ABN is
       Bayesian networks
       Structure learning
  2  From ABN to TSABN
  3  Next steps
  ```

  To rename the title, use `\renewcommand{\outlinename}{Agenda}`. To switch
  every outline slide off, put `\uzhoutlinesoff` in the preamble
  (`\uzhoutlineson` switches them back on). `\uzhautooutlinesoff` drops only
  the automatic slides and keeps the opening overview; use it when the
  navigation bar already tells the audience where the talk is. To drop only
  the per-subsection slides, use
  `\makeatletter\let\uzh@outline@subsection\@empty\makeatother`. If a long
  outline runs past the bottom of the slide, tighten it with
  `\renewcommand{\uzhtocparskip}{0pt}` in the preamble.
- **Opening overview slide.** Put `\uzhoutlineframe` after `\maketitle`. This
  slide lists the **sections only**; the subsections of a section appear later,
  on the outline slide that opens that section. The overview therefore stays
  short and fits on one slide. If you want the subsections on the overview as
  well, use a frame with a plain `\tableofcontents` instead (see the comment on
  `\uzhoutlineframe`).
- **Numbered reference list.** The bibliography marks its entries `[1]`, `[2]`,
  … instead of the default article icon, so each marker matches what `\cite`
  prints. To get the icon back, put
  `\setbeamertemplate{bibliography item}[triangle]` in your preamble.
  `\uzhbibframe{ref}` builds the whole frame (see
  [Ready-made frames](#ready-made-frames-from-uzhframes) below).
- **Slide counter.** The footer shows `current / total`. Frames after
  `\appendix` serve only to answer questions and are not presented in the
  talk, so they should not make the talk look longer than it is. For this
  reason, the theme loads `appendixnumberbeamer`, which freezes the total at
  the last main frame and restarts the count at 1 for the appendix. A main
  frame reads `12 / 45`, and an appendix frame reads `3 / 18`.
- **A button back to the contents.** After you show an appendix frame to answer
  a question, you need to return to the talk. For this purpose, the navigation
  bar of every appendix frame carries a *Contents* button at its right end.
  This button jumps to the opening overview, where every entry is itself a
  link, so any part of the talk is two clicks away. To rename the button, use
  `\renewcommand{\uzhtocbuttonname}{Overview}`. The theme draws the button only
  when the talk has an opening overview; the button is therefore absent from
  the short PDF, which drops that slide.
- **Coloured blocks** (`block`, `exampleblock`, `alertblock`). The plain block
  is deliberately quiet: a pale blue title bar (`uzh@blue1`) with dark blue
  text sits over an almost white body (`uzh@lightgrey1`). Several blocks on one
  slide therefore do not compete with their own content. `exampleblock` and
  `alertblock` keep their strong apple and berry title bars. The snippet for a
  strong blue title bar is in `beamercolorthemeuzh.sty`.
- **Source-code listings** in the UZH palette. Load `\usepackage{uzhcode}`
  (see [Code helpers](#code-helpers-from-uzhcode)) and mark code frames
  `[fragile]`.

## Helper commands (from the UZH template)

- **`\fillimage[<options>]{<width>}{<height>}{<image-path>}`** inserts an image
  that fills the given width and height; the image is centred and cropped as
  needed. The options are passed to `\includegraphics`.
  Example: `\fillimage{\textwidth}{5cm}{my-image.jpg}`
- **`\imagecard[<height>]{<image-path>}{<title>}{<subtitle>}`** shows an image
  with a title and a subtitle below it.
  Example: `\imagecard[5cm]{my-image.jpg}{Title}{Subtitle}`
- **`\numberoverlay{<content>}`** displays a huge number (or any other content)
  on a blue background and hides the rest of the slide.
  Example: `\numberoverlay{42}`
- **`\uzhsup{<content>}`** sets a superscript with the geometry that the DM3L
  website gives to `DM<sup>3</sup>L`: 75 % of the surrounding size, raised by
  0.375 em. Use it instead of `\textsuperscript`, which uses the fixed
  math-script size and therefore sets the digit both larger and higher.
  Example: `DM\uzhsup{3}L`
- **`\uzhtinycites`** is opt-in; call it once in the preamble. In-text `\cite`
  marks then print small, raised and grey. These marks are pointers, not
  content, so they should not compete with the text. The reference list keeps
  its normal size.
- **`\uzhtightmath{<above>}{<below>}`** reduces the space around displayed
  formulas. Use it in a column or on a slide that holds several displays and
  would otherwise run past the bottom. The short skips are set to two thirds
  of the two values. `\dagtightmath` (from `uzhdag`) is a preset for DAG
  slides.
  Example: `\uzhtightmath{3pt}{6pt}`

### Ready-made frames (from `uzhframes`)

The theme loads these frames, so a talk only needs to call them.

- **`\uzhbibframe[<columns>]{<bib file>}`** puts the reference list on one
  slide: in two columns by default, in `\scriptsize`, with the columns ragged
  at the bottom. The audience reads this list on its own; the speaker does not
  walk through it.
  Example: `\uzhbibframe{ref}`, or `\uzhbibframe[1]{ref}` for one column.
  To change the title, the style (default `abbrv`) or the font, redefine
  `\uzhbibname`, `\uzhbibstyle` or `\uzhbibfont` with `\renewcommand` in the
  preamble. If the list is too long for one slide, write a plain frame with
  `[allowframebreaks]` instead.
- **`\uzhthanksframe`** builds the closing page: two centred lines in the title
  colour. To rename either line, use `\renewcommand{\uzhthanksname}{Danke!}` or
  `\renewcommand{\uzhquestionsname}{…}`.

### Step reveal (from `uzhnavigation`)

The step-reveal helpers reveal a slide one point at a time. The current point
is black, and the earlier points are grey. A closing overlay then turns the
whole slide black again, so that you can talk over the complete slide. The
theme loads `uzhnavigation`, so no extra `\usepackage` is needed.

- **`\setsteps{<n>}`** sets the number of steps `n`. Call it once, at the top of
  the frame body and before any other step command. The closing all-black
  overlay falls on overlay `n+3`, so the frame has `n+3` overlays.
- **`\steptitle{<title>}`** produces a frame title that follows the fade. Use it
  as the frame title: `\begin{frame}{\steptitle{My title}}`
- **`\stepnote{<prose>}`** places introductory prose above the list; this prose
  also follows the fade.
- **`steplist` + `\stepitem[<overlay>]{<text>}`** form the list itself. Item `k`
  appears on overlay `k+1`, because overlay 1 shows the introduction. The
  optional argument overrides this default for a list that starts elsewhere,
  for example a first item that appears together with the `\stepnote`:

  ```latex
  \setsteps{1}                 % 1+3 = 4 overlays
  \stepnote{Intro …}
  \begin{steplist}
    \stepitem[1]{… with the intro}
    \stepitem[2]{… then this}
    \stepitem[3]{… then this}
  \end{steplist}
  ```

  Once you override the default, `\setsteps` no longer equals the number of
  items. Instead, give it the value that places the closing all-black overlay
  where you want it (`n+3`). Number either every item in the list or none.
- **`\steprangeitem{<first>}{<last>}{<text>}`** adds a list entry that appears
  on overlay `first` and stays black through overlay `last`. Use it for a
  point that the next point builds on. This command is the `\stepitem`
  counterpart of `\steprangefade`, and it mixes freely with `\stepitem` in one
  `steplist`.
- **`\stepsummary{<prose>}`** adds a closing line that stays hidden until the
  whole list is grey. This line takes no space on the earlier overlays.

To step through **blocks, columns of prose or a figure** instead of list items,
reveal each part yourself and colour it with one of the following commands:

- **`\stepblockfade{<overlay>}`** colours a beamer block. Because a block is a
  box, reveal it with `\uncover<k->{{\stepblockfade{k} … }}`.
- **`\steptextfade{<overlay>}`** colours plain prose. Reveal the prose with
  `\onslide<k->` rather than `\uncover`: `\uncover` reads its content as an
  argument, which breaks `\[ \]` and `align*`. For the same reason, a block
  that holds display math also needs `\onslide`.
- **`\steprangefade{<first>}{<last>}`** colours a part that stays current over
  a **range** of overlays. The part is black from `first` to `last`, grey after
  that, and black again on the closing overlay. Use it when several overlays
  build one object and no part of that object should recede yet.
  `\steptextfade{k}` is the special case `\steprangefade{k}{k}`.
- **`\stepsetfade{<list>}`** colours a part that is current on a **set** of
  overlays rather than a range, given as a comma-separated list. For example,
  `\stepsetfade{4,6}` suits a matrix that a later step uses again. This command
  also works in math mode, so a single cell of an equation block can step on
  its own; reveal that cell with `\uncover<k->` inside the block.
- **`\stepifpast{<first>}{<last>}{<past>}{<current>}`** applies the rule behind
  `\steprangefade` as a branch instead of a colour. Use it for a part that
  `\color` does not reach, such as a TikZ style that carries its own colour:

  ```latex
  {\steprangefade{1}{2}%
   \stepifpast{1}{2}{\tikzset{dagabsent/.append style={draw=uzh@steppast}}}{}%
   \begin{dagfig} … \end{dagfig}}
  ```

- **`\stepnofade`** keeps a part from receding. Use it for an object that the
  later steps refer back to, such as a figure, a map or a table. This command
  takes no overlay number: reveal the part as usual, and `\stepnofade` only
  fixes its colour.

  ```latex
  \onslide<2->%
  {\stepnofade \begin{tikzpicture} … \end{tikzpicture}}
  ```

These helpers only set the colour; you choose the overlay. The two fade
helpers need an earlier `\setsteps` in the frame, whereas `\stepnofade` does
not. The frame "Stepping through blocks and prose" in `slides/template.tex`
shows the two fade helpers side by side.

Three points help when you lay out a frame:

- **`\setsteps{0}` is allowed** and gives three overlays. The last content step
  then falls on the closing all-black overlay, so the whole slide turns black
  at the moment that step appears. Use it when you do not want a separate
  all-black overlay at the end.
- **Use `\steptitle` only when the title should recede.** `\steptitle` turns
  the title grey from the second overlay on. On a frame where nothing turns
  grey, such as a plain progressive reveal, keep the ordinary frame title.
- **`make short` needs no extra markup.** In beamer's handout mode, every step
  helper resolves to full colour, and each frame collapses to one page that
  shows its closing all-black state. Write the frame for the stepped deck, and
  the short PDF follows automatically.

### Code helpers (from `uzhcode`)

Load `\usepackage{uzhcode}` after the theme. This package configures
`listings` in the UZH palette and provides two inline helpers:

- **`\cmd{section}`** typesets `\section` as an inline LaTeX command (blue).
- **`\env{itemize}`** typesets `itemize` as an inline environment name (apple).

### DAG helpers (from `uzhdag`)

Load `\usepackage{uzhdag}` after the theme. This package loads TikZ (with
`arrows.meta`) and provides styles for Bayesian-network diagrams, including the
time-slice DAGs of dynamic and time-series ABNs:

- **`dagnode`** draws a variable node: `\node[dagnode] (a) at (0,0) {$a_t$};`
- **`dagedge`** draws a present edge: `\draw[dagedge] (a) -- (b);`
- **`dagabsent`** draws an absent edge (dashed, in muted berry). It shows that
  a dependency is *not* there, because the missing arrows carry the
  information.
- **`dagsmall`** draws smaller nodes (0.7 cm) for a DAG that shares the slide
  with a text column. Apply it to the whole picture so that all its nodes
  change together: `\begin{tikzpicture}[x=1.4cm, y=0.9cm, dagsmall]`

Additional TikZ options combine with these styles; for example,
`\draw[dagedge, line width=2pt] …` marks a strong coefficient.

For the algebra beside such a diagram, the package also provides an equation
environment:

- **`dagmatharray`** sets displayed equations flush left at a constant indent.
  Two consecutive blocks therefore start at the same horizontal position,
  which `align*` cannot guarantee because it centres each block on its own
  width. The body is an `alignedat` with three column pairs; start every row
  with `&`.

  ```latex
  \begin{dagmatharray}
    & a_t &&{}= C_{11} a_{t-1} & \quad & C_{11} = 1 \\
    & b_t &&{}= C_{21} a_{t-1} &       & C_{21} = 0
  \end{dagmatharray}
  ```

  Pair 1 holds the left-hand side, pair 2 the relation and the right-hand
  side, and pair 3 an optional note. Write `{}=` to keep the space around the
  relation sign, and put the gap before the note in the fifth column, as
  `&\quad&`. The indent is `\dagmathindent` (1.5 em by default).

## Two patterns for long talks

The following patterns are not commands but ways of using the theme that long
talks often need.

### A frame that comes back

A frame can open a topic, give way to an example, and then return to finish
the topic. To build such a frame, write its body once in a macro and use that
macro in two frames:

```latex
\newcommand{\structurelearningbody}{ … the steps … }

\begin{frame}<beamer:1-2|handout:1>[label=abn]{\steptitle{How are arrows found}}
  \structurelearningbody
\end{frame}

\begin{frame}[label=abn]{Score --- a toy example}   % the example between
  …
\end{frame}

\mode<beamer>{%
\begin{frame}<3-4>[label=abn]{\steptitle{How are arrows found}}
  \structurelearningbody
\end{frame}}
```

The stepped deck shows overlays 1–2 on the first visit and overlays 3–4 on the
second. The short PDF (handout mode) keeps only the first visit, which
collapses to one complete page. The reader thus sees the frame once, while the
audience of the talk sees it twice.

### The appendix

Frames that you keep only to answer questions, and do not present, go after
`\appendix`:

```latex
\appendix
\section*{Appendix}
```

`\appendix` opens a new part, so these frames stay out of the table of contents
on the opening overview. `\section*` names the part in the navigation bar
without adding a contents entry. The footer counts the appendix frames
separately, and their navigation bar carries the *Contents* button (see
*Slide counter* and *A button back to the contents* above).
`slides/template.tex` ends with such an appendix.

## Colours

The theme provides the full UZH Corporate Design colour palette. Each colour
has an accent and five shades (e.g. `uzh@blue`, `uzh@blue1` … `uzh@blue5`).

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

For coloured text, use the convenience wrappers `\uzhblue{…}`, `\uzhcyan{…}`,
`\uzhapple{…}`, `\uzhgold{…}`, `\uzhorange{…}` and `\uzhberry{…}`, or use the
named colours directly, e.g. `\textcolor{uzh@blue}{Blue text}`.

## Files

| File | Purpose |
| ---- | ------- |
| `Makefile` | Shared build engine for talks and posters (included via `slides/Makefile` or `poster/Makefile`) |
| `uzhsetup.sty` | Shared setup and the `\uzhsup` / `\uzhtinycites` / `\uzhtightmath` / `\fillimage` / `\imagecard` / `\numberoverlay` helpers |
| `img/` | Shared images: UZH logo, the DM3L wordmark (`UZH_dm3l.tex/.pdf`), demo photos |
| `slides/Makefile` | Thin wrapper that includes `../Makefile` in beamer mode |
| `slides/beamerthemeuzh.sty` | Main theme: loads the sub-themes, installs the THU-style navigation bar and recolours it |
| `slides/beamercolorthemeuzh.sty` | Colour palette; block, alert and table-of-contents colours |
| `slides/beamerfontthemeuzh.sty` | Fonts (Source Sans Pro) |
| `slides/beamerinnerthemeuzh.sty` | Itemize dashes, bibliography marker, title and section pages |
| `slides/beamerouterthemeuzh.sty` | Logo header, frame title, footer (wordmark and slide counter) |
| `slides/uzhnavigation.sty` | Outline slides (`\uzhoutlineframe` and the automatic ones), TOC styling and step reveal |
| `slides/uzhframes.sty` | Ready-made reference and closing frames (`\uzhbibframe`, `\uzhthanksframe`) |
| `slides/uzhcode.sty` | Optional: UZH-styled `listings` and the `\cmd` / `\env` helpers |
| `slides/uzhdag.sty` | Optional: TikZ styles for Bayesian-network (DAG) diagrams |
| `slides/template.tex` | Demo presentation that shows every feature |
| `slides/ref.bib` | Example bibliography for the demo, and the fallback for talks |
| `slides/latex2html.sh` | Accessible HTML export (`make html`) |
| `poster/Makefile` | Thin wrapper that includes `../Makefile` in article mode (`BEAMER=0`) |
| `poster/uzhposter.sty` | A0 poster layer for `article` documents (`\posterheader`, `posterblock`, …) |
| `poster/template.tex` | Demo poster that shows every poster building block |

## Using the theme from another directory

A talk does not need its own copy of the theme. Instead, create a directory
that holds only your `.tex` file (and, optionally, your own `ref.bib`) and a
two-line `Makefile` that points to `slides/` in this repository:

```make
TEMPLATE := path/to/slides_template_latex/slides
include $(TEMPLATE)/Makefile
```

Running `make` in that directory writes the PDF next to your `.tex` file. The
`.sty` files, `img/` and the fallback `ref.bib` stay in this repository;
nothing is copied or symlinked. All the usual targets (`short`, `draft`,
`watch`, `frames`, `html`, `clean`) work unchanged.

This setup works because the `Makefile` adds both `slides/` (or `poster/`) and
the repository root to `TEXINPUTS` and `BIBINPUTS`. `kpathsea` can therefore
resolve `\usepackage{uzhcode}`, `uzhsetup.sty`, the theme's internal
`img/uzh-logo.pdf` and `\bibliography{ref}` from this repository. Because
`kpathsea` still searches the current directory first, a local `img/` or
`ref.bib` overrides the shared one.

If your talk directory lives in another repository, add a `.gitignore` there
that covers the build output: at least `*.pdf`, `*.html` (from `make html`) and
the usual LaTeX artifacts. The root `.gitignore` of this repository is a good
starting point.

## Poster template (`uzhposter`)

`uzhposter.sty` is an A0 portrait poster layer for plain `article` documents.
It provides UZH colours, poster-size fonts, the grey `posterblock` boxes of the
Institute of Mathematics (I-Math), an `Rcode` verbatim environment, and the
header and footer skeleton. It also provides the DAG styles at poster scale;
because these styles keep the names from `uzhdag`, TikZ code from slides can
be pasted unchanged. The layer is print-safe by design: it uses no overlays and
no transparency.

A poster directory uses the same two-line `Makefile` as a talk, but points to
`poster/` instead of `slides/`. The wrapper in `poster/` selects the
article-class mode (`BEAMER=0`). In this mode, `make` builds only the plain
PDF, and the beamer-only targets (`draft`, `short`, `frames`, `watch-draft`,
`html`) stop with a clear message.

```make
TEMPLATE := path/to/slides_template_latex/poster
include $(TEMPLATE)/Makefile
```

A poster document has the following skeleton:

```latex
\documentclass[10pt]{article}
\usepackage{uzhposter}          % resolved via TEXINPUTS
\usepackage{amsmath,amssymb}    % content-level packages stay yours
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

`posterblock` accepts `tcolorbox` options in its optional argument; for
example, `[colbacktitle=uzhgreyD, coltitle=white, colframe=uzhgreyD]` produces
a dark emphasis block. The poster colours use plain names (`uzhblue`,
`uzhberry`, `uzhimathgrey`, …), because `article` documents cannot easily use
the `uzh@…` names of the beamer colour theme.

`poster/template.tex` is a demo poster that shows every building block. To
build it, run `make` inside `poster/`.

## Requirements

The template needs a TeX Live, MacTeX or TinyTeX installation with `latexmk`
and `pdflatex`, and the following packages: `beamer`, `sourcesans` (which
provides `sourcesanspro.sty`) and `ly1`, `lmodern`, `babel-english`,
`appendixnumberbeamer`, `booktabs`, `listings`, `multicol`, `varwidth`,
`fancyvrb` and `tikz` (`pgf`). Posters additionally need `tcolorbox` and
`geometry`. [Pandoc](https://pandoc.org/) is needed only for `make html`.

A minimal TinyTeX lacks some of these packages; install them with `tlmgr`,
e.g. `tlmgr install sourcesans ly1 appendixnumberbeamer`.

## Accessibility

Screen readers cannot read the PDFs that LaTeX produces. To make a
presentation accessible, convert it into a self-contained HTML file with the
`slides/latex2html.sh` script, which requires [Pandoc](https://pandoc.org/).
In a talk directory, `make html` runs this script for you:

```bash
slides/latex2html.sh my-presentation.tex
```

Give each image an alternative text through the `alt` option, e.g.
`\includegraphics[width=5cm,alt={Alternative text}]{img.jpg}`. For decorative
images, leave the text empty, e.g.
`\fillimage[alt={}]{5cm}{3cm}{decorative.jpg}`.

## Credits

- The UZH corporate-design Beamer theme provides the style layer of this
  template.
- The [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme) by TUNA
  provides the navigation bar and the outline features that this template
  adapts.

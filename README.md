# slides_template_latex

A LaTeX **Beamer** presentation template that pairs the official
[UZH Corporate Design](https://www.cd.uzh.ch/) look (colours, fonts, logo) with
the navigation features of the [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme)
— a top section-navigation bar, automatic outline slides, a slide counter, and
UZH-styled blocks, code and tables. All content is in English.

## Repository layout

```
slides_template_latex/
├── README.md                 # this file
└── uzh-presentation-LaTeX/   # the theme package + demo (build here)
    ├── template.tex          # demo presentation — start from this
    ├── ref.bib               # example bibliography
    ├── Makefile              # build / watch / clean targets
    ├── beamerthemeuzh.sty    # main theme (loads the sub-themes)
    ├── beamercolorthemeuzh.sty
    ├── beamerfontthemeuzh.sty
    ├── beamerinnerthemeuzh.sty
    ├── beamerouterthemeuzh.sty
    ├── uzhnavigation.sty     # section outline slides + TOC styling
    ├── uzhcode.sty           # optional UZH-styled `listings`
    ├── uzhsetup.sty          # \fillimage / \imagecard / \numberoverlay helpers
    ├── latex2html.sh         # accessible-HTML export (needs Pandoc)
    └── img/                  # demo images and the UZH logo
```

All theme files and the demo live in **`uzh-presentation-LaTeX/`**. See
[`uzh-presentation-LaTeX/README.md`](uzh-presentation-LaTeX/README.md) for the
full feature reference (colour palette, helper commands, accessibility notes).

## Quick start

Build the demo (from the theme folder):

```bash
cd uzh-presentation-LaTeX
make            # builds every *.tex to PDF (latexmk + pdflatex + bibtex)
```

Or invoke `latexmk` directly:

```bash
latexmk -pdf template.tex
```

Other `make` targets:

| Target              | Effect                                                     |
| ------------------- | ---------------------------------------------------------- |
| `make` / `make pdf` | Build all top-level `*.tex` documents to PDF               |
| `make watch`        | Continuous preview — rebuild on every save (Ctrl-C to stop)|
| `make clean`        | Remove build artifacts, keep the PDFs                      |
| `make cleanall`     | Remove build artifacts **and** the generated PDFs          |

## Using the theme in your own slides

```latex
\documentclass[aspectratio=169,onlytextwidth]{beamer}
\usetheme[english]{uzh}   % institution label: english or german
```

Copy the `.sty` files, `img/`, and (optionally) the `Makefile` alongside your
own `.tex`, then build the same way. `template.tex` is a full, self-documenting
example of every feature.

## Requirements

A TeX Live / MacTeX (or TinyTeX) installation with `latexmk`, `pdflatex`, and,
among the standard packages: `beamer`, `sourcesans` (Source Sans Pro), `ly1`,
`listings`, `booktabs`, `appendixnumberbeamer`, `babel-english`.

## Credits

- UZH corporate-design Beamer theme — the visual style layer.
- [THU Beamer Theme](https://github.com/tuna/THU-Beamer-Theme) by TUNA — the
  navigation-bar and outline features this template adapts.

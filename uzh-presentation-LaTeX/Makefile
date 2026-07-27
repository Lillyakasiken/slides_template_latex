# Makefile for the UZH beamer presentation template
# Builds every top-level *.tex document to PDF with latexmk + pdflatex.
# latexmk resolves reruns and calls bibtex for ref.bib automatically.

TEX = $(wildcard *.tex)
PDF = $(patsubst %.tex,%.pdf,$(TEX))

LATEXMK      = latexmk
PDFLATEX     = pdflatex -interaction=nonstopmode -synctex=1
LATEXMKFLAGS = -pdf -pdflatex="$(PDFLATEX)" -halt-on-error

.PHONY: all pdf watch clean cleanall
.SUFFIXES: .tex .pdf

all: pdf

pdf: $(PDF)

# Pattern rule: each PDF depends on its source.
%.pdf: %.tex
	$(LATEXMK) $(LATEXMKFLAGS) $<

# Continuous preview: rebuild on save (Ctrl-C to stop).
watch:
	$(LATEXMK) $(LATEXMKFLAGS) -pvc $(TEX)

# Remove build artifacts but keep the PDFs.
clean:
	$(LATEXMK) -c
	rm -f *~ *.nav *.snm *.vrb *.bbl *.blg *.backup Rplots.pdf

# Remove build artifacts and the generated PDFs.
cleanall:
	$(LATEXMK) -C
	rm -f *~ *.nav *.snm *.vrb *.bbl *.blg *.backup Rplots.pdf $(PDF)

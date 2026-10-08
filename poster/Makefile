# Article-class posters on uzhposter.sty. Include this file from your poster
# directory with a two-line Makefile:
#
#     TEMPLATE := ../../template/latex/poster
#     include $(TEMPLATE)/Makefile
#
# BEAMER=0 marks the document as article-class: `make` builds only the plain
# PDF, and the beamer-only targets (draft, short, frames, watch-draft, html)
# answer with a clear message. The build engine and the shared assets (img/,
# uzhsetup.sty) live one level up, in ../Makefile.
TEMPLATE ?= .
BEAMER := 0
include $(TEMPLATE)/../Makefile

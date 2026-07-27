#!/bin/bash
set -e

# Check arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file.tex>"
    exit 1
fi

# Check if Pandoc is installed
if ! command -v pandoc > /dev/null; then
    echo "Error: Pandoc is not installed"
    exit 1
fi

# Temporary file
tmpfile="$(mktemp -p . -t tmp.XXXXXXXXXX.tex)"
trap 'rm -f "$tmpfile"' EXIT

# Convert Beamer features not supported by Pandoc
sed -e 's/\\begin\s*{frame}\s*{\([^}]*\)}\s*{\([^}]*\)}/\\begin{frame}\n\\frametitle{\1}\n\\framesubtitle{\2}/g' \
    -e 's/\\begin\s*{frame}\s*{\([^}]*\)}/\\begin{frame}\n\\frametitle{\1}/g' \
    -e 's/\\begin\s*{column}\s*\(\[[^]]*\]\s*\)\?{[^}]*}/\\begin{column}/g' \
    -e 's/\\fillimage\(\s*\[\([^]]*\)\]\)\?\s*{[^}]*}\s*{[^}]*}\s*{\([^}]*\)}/\\includegraphics[\2]{\3}/g' \
    -e 's/\\imagecard\s*{\([^}]*\)}\s*{\([^}]*\)}\s*{\([^}]*\)}/\\includegraphics[alt={\2}]{\1} \\\\ \\textbf{\2} \\\\ \3/g' \
    "$1" > "$tmpfile"

# Convert to HTML
pandoc "$tmpfile" -f latex -t html --standalone --embed-resources --mathjax > "${1%.tex}.html"

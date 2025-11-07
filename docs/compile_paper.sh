#!/bin/bash
# Compile LaTeX paper to PDF
# Usage: ./compile_paper.sh

set -e

echo "========================================="
echo "Compiling: The Law of Flickering Scenery"
echo "========================================="

# Check if pdflatex is installed
if ! command -v pdflatex &> /dev/null; then
    echo "Error: pdflatex not found. Please install LaTeX distribution (e.g., MacTeX, TeX Live)"
    exit 1
fi

# Check if bibtex is installed
if ! command -v bibtex &> /dev/null; then
    echo "Error: bibtex not found. Please install LaTeX distribution"
    exit 1
fi

# Navigate to docs directory
cd "$(dirname "$0")"

PAPER="paper_law_of_flickering_scenery"

echo ""
echo "Step 1/4: First pdflatex pass..."
pdflatex -interaction=nonstopmode "$PAPER.tex" > /dev/null 2>&1 || {
    echo "Error in first pdflatex pass. Check $PAPER.log for details."
    exit 1
}

echo "Step 2/4: Running bibtex..."
bibtex "$PAPER" > /dev/null 2>&1 || {
    echo "Warning: bibtex warnings (usually okay)"
}

echo "Step 3/4: Second pdflatex pass..."
pdflatex -interaction=nonstopmode "$PAPER.tex" > /dev/null 2>&1 || {
    echo "Error in second pdflatex pass."
    exit 1
}

echo "Step 4/4: Final pdflatex pass..."
pdflatex -interaction=nonstopmode "$PAPER.tex" > /dev/null 2>&1 || {
    echo "Error in final pdflatex pass."
    exit 1
}

# Clean up auxiliary files
echo ""
echo "Cleaning up auxiliary files..."
rm -f *.aux *.bbl *.blg *.log *.out *.toc *.lof *.lot

echo ""
echo "========================================="
echo "✓ Compilation successful!"
echo "========================================="
echo ""
echo "Output: $PAPER.pdf"
echo "Size: $(du -h "$PAPER.pdf" | cut -f1)"
echo "Pages: $(pdfinfo "$PAPER.pdf" 2>/dev/null | grep Pages | awk '{print $2}' || echo 'N/A')"
echo ""
echo "To view the PDF:"
echo "  open $PAPER.pdf  (macOS)"
echo "  xdg-open $PAPER.pdf  (Linux)"
echo ""

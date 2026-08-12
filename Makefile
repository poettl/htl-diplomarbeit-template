DOC = diplomarbeit

.PHONY: help pdf watch clean distclean

help:
	@echo "make pdf        build the PDF (result: build/$(DOC).pdf)"
	@echo "make watch      rebuild automatically on every change"
	@echo "make clean      delete auxiliary files, keep the PDF"
	@echo "make distclean  delete build/ entirely"

pdf:
	latexmk -pdf $(DOC).tex

watch:
	latexmk -pdf -pvc $(DOC).tex

clean:
	latexmk -c $(DOC).tex

distclean:
	latexmk -C $(DOC).tex
	rm -rf build

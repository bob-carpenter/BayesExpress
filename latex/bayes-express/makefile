BIB=../bib
DOC=../../doc
IMG=../../img
STAN=../../stan

bayes-express.pdf : bayes-express.tex  ${STAN}/*.stan ${IMG}/*.pdf ${BIB}/references.bib
	mkdir -p ${DOC}
	latexmk -pdf bayes-express.tex
	cp bayes-express.pdf ${DOC}

clean :
	latexmk -c
	rm -f bayes-express.bbl

clean-all : clean
	latexmk -C

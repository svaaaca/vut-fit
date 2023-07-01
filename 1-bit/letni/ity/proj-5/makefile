#
# Typography and Publishing - 5th Project
# Ac.Year 2021/2022, Summer Semester
#
# Login xkvace00, Kvacek David
# 1st year BITP, full-time, FIT
# xkvace00@stud.fit.vutbr.cz
#
# Date: 2022-05-05
#

#
# Makefile usage info [current directory]:
# make		- create .pdf version of .tex file
# make clean	- clean all files except .tex
#

TEXNAME=xkvace00

make:
	-make clean
	pdflatex $(TEXNAME).tex

clean:
	-rm *.dvi *.aux *.bbl *.blg *.log *.toc *.lof *.lot *.glo *.gls *.ist *.nav *.snm
	-rm *.ilg *~ $(TEXNAME).pdf $(TEXNAME).dvi $(TEXNAME).ps $(TEXNAME).out


#
# Typography and Publishing - 3rd Project
# Ac.Year 2021/2022, Summer Semester
#
# Login xkvace00, Kvacek David
# 1st year BITP, full-time, FIT
# xkvace00@stud.fit.vutbr.cz
#
# Date: 2022-04-04
#

#
# Makefile usage info [current directory]:
# make		- create .pdf version of .tex file
# make clean	- clean all files except .tex
#

TEXNAME=xkvace00

make:
	-make clean
	latex $(TEXNAME).tex
	latex $(TEXNAME).tex
	dvips -t a4 $(TEXNAME).dvi -o $(TEXNAME).ps
	ps2pdf -sPAPERSIZE=a4 $(TEXNAME).ps

clean:
	-rm *.dvi *.aux *.bbl *.blg *.log *.toc *.lof *.lot *.glo *.gls *.ist
	-rm *.ilg *~ $(TEXNAME).pdf $(TEXNAME).dvi $(TEXNAME).ps $(TEXNAME).out


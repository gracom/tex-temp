LATEX  = platex
BIBTEX = pbibtex
DVIPDF = dvipdfmx

LATEXFLAG = -shell-escape -kanji=utf8
LATEXFLAG+= -halt-on-error -interaction=nonstopmode -file-line-error
LATEXLINKFLAG = -synctex=1 -jobname="$(MAIN)" 
BIBTEXFLAG = -kanji=utf8
DVIPDFFLAG = -synctex=1 -jobname="$(MAIN)" 

SRC := src
OBJ := .obj

SOURCE  = $(wildcard $(SRC)/*.tex) $(wildcard $(SRC)/*/*.tex) 
SOURCE += $(wildcard $(SRC)/*.bib)
SOURCE += $(wildcard $(SRC)/*.sty)
SOURCE += $(wildcard $(SRC)/fig/*)
SOURCE += makefile

MAIN = hogehoge
TARGET  = $(MAIN).pdf

########################################

.SUFFIXES: .pdf

.PHONY: all clean cleantemporalfiles

all: 
	make clean && make $(TARGET); make cleantemporalfiles

$(TARGET): $(SRC)/$(MAIN).dvi 
	cd $(SRC) && $(DVIPDF) $(DVIPDFFLAGS) $(MAIN).dvi -o ../$(TARGET)
	open $(TARGET)

$(SRC)/$(MAIN).dvi: $(SRC)/$(MAIN).bbl
	printf "\e[34m" && cd $(SRC) && $(LATEX) $(LATEXFLAG) $(MAIN).tex
	printf "\e[35m" && cd $(SRC) && $(LATEX) $(LATEXFLAG) $(LATEXLINKFLAG) $(MAIN).tex
	printf "\e[m"; 

$(SRC)/$(MAIN).bbl: $(SRC)/$(MAIN).aux
	printf "\e[33m" && cd $(SRC) && $(BIBTEX) $(BIBTEXFLAG) $(MAIN)
	printf "\e[m"; 

$(SRC)/$(MAIN).aux: $(SOURCE)
	printf "\e[32m" && cd $(SRC) && $(LATEX) $(LATEXFLAG) $(MAIN).tex
	printf "\e[m"; 

clean:
	@rm -f $(TARGET) $(FIG)/*.xbb

cleantemporalfiles:
	@-mv \
		$(SRC)/$(MAIN).aux \
		$(SRC)/$(MAIN).bbl \
		$(SRC)/$(MAIN).dvi \
		$(SRC)/$(MAIN).log \
		$(SRC)/$(MAIN).blg \
		$(SRC)/$(MAIN).out \
		$(SRC)/$(MAIN).synctex.gz \
		$(OBJ)


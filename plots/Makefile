HOST=$(shell hostname)
UNAME := $(shell uname)

all: profile.pdf profile1.pdf profile2.pdf

profile.tex: profile.gnuplot ../build/avgsimu
	gnuplot -c $< $@

profile1.tex: profile1.gnuplot ../build/avgsimu
	gnuplot -c $< $@

profile2.tex: profile2.gnuplot ../build/avgsimu Makefile
	gnuplot -c $< $@

clean:
	rm -f *.eps *.out *.aux *.log *.pdf *.tex

.SUFFIXES: .tex .pdf

%.pdf: %.tex
	pdflatex $<

HOST=$(shell hostname)
UNAME := $(shell uname)

all: phd.pdf waveform.pdf
#all: profile.pdf profile1.pdf profile2.pdf profile3.pdf

phd.tex: phd.gnuplot ../build/avgsimu
	gnuplot -c $< $@

waveform.tex: waveform.gnuplot ../build/avgsimu
	gnuplot -c $< $@

profile.tex: profile.gnuplot ../build/avgsimu
	gnuplot -c $< $@

profile1.tex: profile1.gnuplot ../build/avgsimu
	gnuplot -c $< $@

profile2.tex: profile2.gnuplot ../build/avgsimu Makefile
	gnuplot -c $< $@

profile3.tex: profile3.gnuplot ../build/avgsimu Makefile
	gnuplot -c $< $@

clean:
	rm -f *.eps *.out *.aux *.log *.pdf *.tex

.SUFFIXES: .tex .pdf

%.pdf: %.tex
	pdflatex $<

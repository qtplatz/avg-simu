HOST=$(shell hostname)
UNAME := $(shell uname)

all: profile.pdf profile-width.pdf profile-noise.pdf profile-random.pdf

profile.tex: profile.gnuplot ../build/pksimu
	gnuplot -c $< $@

profile-width.tex: profile-width.gnuplot ../build/pksimu
	gnuplot -c $< $@

profile-noise.tex: profile-noise.gnuplot ../build/pksimu
	gnuplot -c $< $@

profile-random.tex: profile-random.gnuplot ../build/pksimu
	gnuplot -c $< $@

clean:
	rm -f *.eps *.out *.aux *.log *.pdf *.tex

.SUFFIXES: .tex .pdf

%.pdf: %.tex
	pdflatex $<

HOST=$(shell hostname)
UNAME := $(shell uname)

all: single_waveform.pdf averaged_waveform.pdf counting_waveform.pdf digital_averaging.pdf \
	signal-to-noise.pdf saturation.pdf adc_linearity.pdf

saturation.tex: saturation.gnuplot
	gnuplot -c $< $@

adc_linearity.tex: adc_linearity.gnuplot
	gnuplot -c $< $@

single_waveform.tex: single_waveform.gnuplot
	gnuplot -c $< $@

averaged_waveform.tex: averaged_waveform.gnuplot
	gnuplot -c $< $@

counting_waveform.tex: counting_waveform.gnuplot
	gnuplot -c $< $@

digital_averaging.tex: digital_averaging.gnuplot
	gnuplot -c $< $@

signal-to-noise.tex: signal-to-noise.gnuplot
	gnuplot -c $< $@

clean:
	rm -f *.eps *.out *.aux *.log *.pdf *.tex *~

.SUFFIXES: .tex .pdf

%.pdf: %.tex
	pdflatex $<

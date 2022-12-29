HOST=$(shell hostname)
UNAME := $(shell uname)

TARGETS = single_waveform.pdf single_waveform_40.pdf single_waveform_mz.pdf \
	averaged_waveform.pdf counting_waveform.pdf digital_averaging.pdf \
	signal-to-noise.pdf signal-to-noise_linear.pdf \
	saturation.pdf adc_linearity.pdf saturation_waveform.pdf \
	pkd+avg.pdf pkd+avg2.pdf \
	aperture-jitter.pdf

all: ${TARGETS}

aperture-jitter.tex: aperture-jitter.gnuplot
	gnuplot -c $< $@

pkd+avg.tex: pkd+avg.gnuplot functions.gnuplot
	gnuplot -c $< $@

pkd+avg2.tex: pkd+avg2.gnuplot functions.gnuplot
	gnuplot -c $< $@

saturation.tex: saturation.gnuplot functions.gnuplot
	gnuplot -c $< $@

saturation_waveform.tex: saturation_waveform.gnuplot
	gnuplot -c $< $@

adc_linearity.tex: adc_linearity.gnuplot
	gnuplot -c $< $@

single_waveform.tex: single_waveform.gnuplot functions.gnuplot
	gnuplot -c $< $@

single_waveform_40.tex: single_waveform_40.gnuplot functions.gnuplot
	gnuplot -c $< $@

single_waveform_mz.tex: single_waveform_mz.gnuplot functions.gnuplot
	gnuplot -c $< $@

averaged_waveform.tex: averaged_waveform.gnuplot functions.gnuplot
	gnuplot -c $< $@

counting_waveform.tex: counting_waveform.gnuplot functions.gnuplot
	gnuplot -c $< $@

digital_averaging.tex: digital_averaging.gnuplot functions.gnuplot
	gnuplot -c $< $@

signal-to-noise.tex: signal-to-noise.gnuplot
	gnuplot -c $< $@

signal-to-noise_linear.tex: signal-to-noise_linear.gnuplot
	gnuplot -c $< $@

install:
	cp ${TARGETS} ~/Documents/osaka-u.git/2023-01-26/figures/

clean:
	rm -f *.eps *.out *.aux *.log *.pdf *.tex *~

.SUFFIXES: .tex .pdf

%.pdf: %.tex
	pdflatex $<

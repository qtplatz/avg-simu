reset

set terminal epslatex size 12in,9.5in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 5,2 columnsfirst
set datafile separator ","

set format y "%.4f"

set xlabel "$$Time(\\mu s)$$"
set ylabel "Intensity"
#set xrange[ 9.995: 10.005 ]

plot '< ../build/pksimu --width=2 --noise=0.0' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns"

plot '< ../build/pksimu --width=2 --noise=0.011' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns, S/N=30"

plot '< ../build/pksimu --width=2 --noise=0.033' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns, S/N=10"

plot '< ../build/pksimu --width=2 --noise=0.067' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns, S/N=5"

plot '< ../build/pksimu --width=2 --noise=0.111' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns, S/N=3"

unset xrange
set xlabel "Phase~shift $$(ns)$$"
set ylabel "Centroid~error $$(ps)$$"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --noise=0.0 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --noise=0.011 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns, S/N=30"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --noise=0.033 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns, S/N=10"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --noise=0.057 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns, S/N=5"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --noise=0.111 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns, S/N=3"

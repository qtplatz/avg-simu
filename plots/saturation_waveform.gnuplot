set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'functions.gnuplot'
#
set multiplot layout 2,2 #title "PKD+AVG Simulation (N=1000), Gain=50mV,$\\sigma_{gain}$=50mV"
#set datafile separator ","

set xlabel "time (\\si{\\micro\\second})"
set ylabel "intensity (mV)"

#set yrange [-5:50]
xw = 0.01
set xrange [10-xw:10+xw]

set ytics nomirror
set ylabel "intensity(mV)"

aW = 0.25
N = 1
rate = 2.0

array Nlist[4]

Nlist[1] = 1
Nlist[2] = 10
Nlist[3] = 100
Nlist[4] = 1000

ARGS = "-N %d --noise=2 --nions=%d --pulsewidth=1.0 --gain=50.0 --gain-sigma=0.0 --width=%g --rate=%g"

do for [i=1:2] {
    set yrange[-10:1100]
    plot for [k=1:2] '< ../build/avgsimu '.sprintf(ARGS, Nlist[k], 15, aW, rate) using ($1*1e6):(1000*$2/(4096*Nlist[k])) with linespoints pt 4 ps 1 lw 5 \
	 title sprintf("N=%d", Nlist[k])
}

ARGS = "-N %d --noise=2 --nions=%d --pulsewidth=1.0 --gain=50.0 --gain-sigma=200.0 --width=%g --rate=%g"

do for [i=1:2] {
    set yrange[-10:1100]
    plot for [k=1:2] '< ../build/avgsimu '.sprintf(ARGS, Nlist[k], 15, aW, rate) using ($1*1e6):(1000*$2/(4096*Nlist[k])) with linespoints pt 4 ps 1 lw 5 \
	 title sprintf("N=%d", Nlist[k])
}

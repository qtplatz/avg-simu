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
set xrange [9.98:10.02]

set ytics nomirror
set ylabel "intensity(mV)"
set y2tics
set y2label "Counts"

ARGS = "-N %d -Z %d --noise=2 --nions=1 --pulsewidth=1.0 --gain=50.0 --gain-sigma=100.0 --width=%g --rate=%g"
aW = 0.4
N = 1000
rate = 4
array RATE[4]
RATE[1] = 8
RATE[2] = 4
RATE[3] = 2
RATE[4] = 1

#set y2range [-70:700]
#set yrange [-5:50]
array cr[4]
cr[1] = 0.1
cr[2] = 0.1
cr[3] = 0.1
cr[4] = 0.1

do for [i=1:4] {
    aW = 1.0
    CR = cr[i]
    rate = RATE[i]
    system( "../build/avgsimu " . sprintf(ARGS, N*CR, N*(1-CR), aW, rate) . " > tmp.txt" )

    set title sprintf("%g GSPS, R.P.=\\num{%d}, C.R.=\\SI{%g}{\\percent}", rate, RP(10,aW), (CR*100))
    plot 'tmp.txt' using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt 4 ps 1 lw 5 title "AVG" \
	 , 'tmp.txt' using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"
}

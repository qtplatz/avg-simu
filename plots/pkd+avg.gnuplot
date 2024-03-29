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
N = 1000
rate = 2.0

#set y2range [-70:700]
#set yrange [-5:50]
CR = 1.0
array cr[4]
cr[1] = 0.1
cr[2] = 0.1
cr[3] = 0.1
cr[4] = 0.1

array y2FS[4]
y2FS[1] = 250
y2FS[2] = 250
y2FS[3] = 250
y2FS[4] = 250

do for [i=1:4] {
    aW = 2.0/i
    CR = cr[i]
    system( "../build/avgsimu " . sprintf(ARGS, N*CR, N*(1-CR), aW, rate) . " > tmp.txt" )

    # set y2range [-y2FS[i]/10:y2FS[i]]

    set title sprintf("%d GSPS, R.P.=\\num{%d}, C.R.=\\SI{%g}{\\percent}", rate, RP(10,aW), (CR*100))
    plot 'tmp.txt' using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt 4 ps 1 lw 5 title "AVG" \
	 , 'tmp.txt' using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"
}

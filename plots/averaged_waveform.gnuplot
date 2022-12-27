set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'functions.gnuplot'
#
set multiplot layout 2,2 title "Averaged waveform (N=1000, CR=100, 30\\%) (50 mV)"
#set datafile separator ","

set xlabel "Time (\\si{\\micro\\second})"
set ylabel "Intensity (mV)"

set yrange [-5:50]
set xrange [9.98:10.02]

# RP = 2t/dt
# 10e-6 1.0e-9

ARGS = "-N %d -Z %d --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=50.0 --gain-sigma=1e-6 --width=%g --rate=%d"
aY = -2
aW = 4.0
N = 1000
i = 1

set label 1 at 10,aY "$3\\sigma$" offset -1,0.5
set arrow 1 from (10-(aW/2000)*3),aY to (10+(aW/2000)*3),aY heads linecolor rgb "red" lw 5
set title sprintf("2 GSPS, R.P.=\\num{%g}", RP(10, aW) )
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 4.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 2.0
set arrow 1 from (10-(aW/2000)*3),aY to (10+(aW/2000)*3),aY heads linecolor rgb "red" lw 5
set title sprintf("2 GSPS, R.P.=\\num{%g}", RP(10, aW) )
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 2.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 1.0
set arrow 1 from (10-(aW/2000)*3),aY to (10+(aW/2000)*3),aY heads linecolor rgb "red" lw 5
set title sprintf("2 GSPS, R.P.=\\num{%g}", RP(10, aW) )
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 1.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 0.5
set arrow 1 from (10-(aW/2000)*3),aY to (10+(aW/2000)*3),aY heads linecolor rgb "red" lw 5
set title sprintf("2 GSPS, R.P.=\\num{%g}", RP(10, aW) )
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 0.5, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

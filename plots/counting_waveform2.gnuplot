set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,2 title "PKD+AVG Simulation (N=1000), Gain=50mV,$\\sigma_{gain}$=50mV"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

#set yrange [-5:50]
set xrange [9.98:10.02]

set ytics nomirror
set ylabel "intensity(mV)"
set y2tics
set y2label "Counts"

ARGS = "-N %d -Z %d --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=50.0 --gain-sigma=100.0 --width=%g --rate=1.0"
aY = 0
aW = 4.0
N = 1000
rate = 1.0
set y2range [-70:700]
set yrange [-4:40]

CR = 1.0
aW = 0.2

set title sprintf("%d GSPS, R.P.=\\num{%d}", rate, (2*10E-6/(aW*1.0e-9))+0.5)
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW) using ($1*1e6):(1000*$2/(4096*(N+N/CR))) with linespoints pt 4 ps 1 lw 5 title "C.R.=\\SI{100}{\\percent}" \
     , '< ../build/avgsimu '.sprintf(ARGS, N, 0, aW) using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"

CR = 0.3
set yrange [-4*CR:40*CR]
set y2range [-70*CR:700*CR]

set title sprintf("%d GSPS, R.P.=\\num{%d}", rate, 2*10E-6/(aW*1e-9))
plot '< ../build/avgsimu ' . sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):(1000*$2/(4096*(N+N/CR))) with linespoints pt 4 ps 1 lw 5 \
     title sprintf("C.R.=\\SI{%d}{\\percent}", CR*100) \
     , '< ../build/avgsimu '.sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"


CR = 0.1
set yrange [-4*CR:40*CR]
set y2range [-70*CR:700*CR]

plot '< ../build/avgsimu ' . sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):(1000*$2/(4096*(N+N/CR))) with linespoints pt 4 ps 1 lw 5 \
     title sprintf("C.R.=\\SI{%d}{\\percent}", CR*100) \
     , '< ../build/avgsimu '.sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"


CR = 0.03
set yrange [-4*CR:40*CR]
set y2range [-70*CR:700*CR]

plot '< ../build/avgsimu ' . sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):(1000*$2/(4096*(N+N/CR))) with linespoints pt 4 ps 1 lw 5 \
     title sprintf("C.R.=\\SI{%d}{\\percent}", CR*100) \
     , '< ../build/avgsimu '.sprintf(ARGS, N*CR, N*(1-CR), aW) using ($1*1e6):($4) with linespoints lw 5 axes x1y2 title "Counts"

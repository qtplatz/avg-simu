set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,2 title "Simulated waveform averaging (50 mV, gain $\\sigma=$\\SI{1e-6}{\\milli\\volt})"
#set datafile separator ","

set xlabel "Time (\\si{\\micro\\second})"
set ylabel "Intensity (mV)"

set yrange [-5:50]
set xrange [9.98:10.02]

# RP = 2t/dt
# 10e-6 1.0e-9

ARGS = "--noise=1.2 --nions=1 --pulsewidth=1.0 --gain=50.0 --gain-sigma=1e-6 --width=%g --rate=2"
aY = 45
aW = 2.0E-3

set label 1 at 10,aY "$3\\sigma$" offset -1,0.5
set arrow 1 from (10-aW*3),aY to (10+aW*3),aY heads linecolor rgb "red" lw 5
set title "2 GSPS, R.P.=\\num{5000}"
plot for [i=1:3] '< ../build/avgsimu ' . sprintf(ARGS, aW*2000) using ($1*1e6):(1000*$2/4096) with linespoints pt i+4 ps 1 lw 2 notitle

aW = 1.0E-3
set arrow 1 from (10-aW*3),aY to (10+aW*3),aY heads linecolor rgb "red" lw 5
set title "2 GSPS, R.P.=\\num{10000}"
plot for [i=1:3] '< ../build/avgsimu ' . sprintf(ARGS, aW*2000) using ($1*1e6):(1000*$2/4096) with linespoints pt i+4 ps 1 lw 2 notitle

aW = 0.50E-3
set arrow 1 from (10-aW*3),aY to (10+aW*3),aY heads linecolor rgb "red" lw 5
set title "2 GSPS, R.P.=\\num{20000}"
plot for [i=1:3] '< ../build/avgsimu ' . sprintf(ARGS, aW*2000) using ($1*1e6):(1000*$2/4096) with linespoints pt i+4 ps 1 lw 2 notitle

aW = 0.25E-3
set arrow 1 from (10-aW*3),aY to (10+aW*3),aY heads linecolor rgb "red" lw 5
set title "2 GSPS, R.P.=\\num{40000}"
plot for [i=1:3] '< ../build/avgsimu ' . sprintf(ARGS, aW*2000) using ($1*1e6):(1000*$2/4096) with linespoints pt i+4 ps 1 lw 2 notitle

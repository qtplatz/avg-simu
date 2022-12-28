set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'pdf.gnuplot'
#
#set multiplot layout 1 #title "PKD+AVG Simulation (N=1000), Gain=50mV,$\\sigma_{gain}$=50mV"
#set datafile separator ","

set xlabel "time (\\si{\\micro\\second})"
set ylabel "intensity (mV)"

#set yrange [-5:50]

set ytics nomirror
set ylabel "intensity(mV)"

set xlabel "$t$"

clock(x) = int(abs(x))%2

#set arrow 1 from 1000,0.0 to 1000,nd(1000,gain*n,gain*sqrt(n))*yfs nohead lw 5 lc rgb "red"
#set arrow 2 from m,0.0 to m,nd(gain*n,gain*n,gain*sqrt(n))*yfs nohead lw 3 # mean (center)
set y2range [ -2: 32 ]
set yrange [-0.1:0.5]

plot [0:20] nd(x,10,1.0) lw 5 notitle \
     , clock(x*2.5) with steps lw 2 lc "black" axes x1y2 notitle

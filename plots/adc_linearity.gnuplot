set terminal epslatex size 4.5in,4in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,1 #title "PKD+AVG Simulation (N=1000), Gain=50mV,$\\sigma_{gain}$=50mV"

set xrange [-10:1140]
set xlabel "Intensity (mV)"
set ylabel "Averager out (mV)"

f(x) = x;

#system( "../build/pdf --adc > tmp.txt" )
#plot '< ../build/pdf --adc' using ($1*1000):($2*1000) with linespoints pt 4 ps 2 lw 5 notitle \

plot '< ../build/pdf --adc --gain=0.05' using ($1*1000):($2*1000) with linespoints pt 6 ps 2 lw 5 notitle \
     , f(x) lw 5 lc "black" notitle "true (mV)"

set ylabel "Error \\%"

plot -1.5 with filledcurves y=1.5 fc "cyan" fs solid 0.2 notitle \
     , '< ../build/pdf --adc' using ($1*1000):(100*($2-$1)/$1) with linespoints pt 6 ps 2 lw 5 title "Error distribution" \
     , '< ../build/pdf --adc' using ($1*1000):(100*($2-$1)/$1) with impulses lw 5 lc "red" notitle

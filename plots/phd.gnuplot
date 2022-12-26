set terminal epslatex size 4in,4in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
#set multiplot layout 4,2 title "Single Trigger Simulation"
#set datafile separator ","

set ylabel "Frequency"
set xlabel "Intensity(mV)"
set xrange [0:300]

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=100.0 --gain-sigma=50 --width=1.0 --output=PHD' using 1:2 with linespoints pt 4 ps 1 title "PHD"

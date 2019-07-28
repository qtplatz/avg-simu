set terminal epslatex size 12.5in,12in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 4,2 title "Single Trigger Simulation"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

set xrange [9.98:10.02]

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=1.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "Single-ion,G:20mV"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=1.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "Single-ion,G:20mV"

plot '< ../build/avgsimu --noise=1.2 --nions=5 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "5-ions,G:20mV,$\\sigma$:10mV,W:2ns"

plot '< ../build/avgsimu --noise=1.2 --nions=5 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "5-ions,G:20mV,$\\sigma$:10mV,W:2ns"

plot '< ../build/avgsimu --noise=1.2 --nions=10 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "10-ions,G:20mV,$\\sigma$:10mV,W:2ns"

plot '< ../build/avgsimu --noise=1.2 --nions=10 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "10-ions,G:20mV,$\\sigma$:10mV,W:2ns"

plot '< ../build/avgsimu --noise=1.2 --nions=100 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "100-ions,G:20mV,$\\sigma$:10mV,W:2ns"

plot '< ../build/avgsimu --noise=1.2 --nions=100 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=2.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "100-ions,G:20mV,$\\sigma$:10mV,W:2ns"

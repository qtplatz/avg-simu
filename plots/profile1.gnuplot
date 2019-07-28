set terminal epslatex size 12.5in,12in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 5,2 title "Average Simulation (N=1000), Gain=20mV,Gein$\\sigma$=10mV,$W_{peak}$=2ns"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

#set xrange [9.98:10.02]

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "100\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "100\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=750 --ztrig=250' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "75\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=750 --ztrig=250' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "75\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "50\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "50\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "25\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "25\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "5\\%"

plot '< ../build/avgsimu --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "5\\%"

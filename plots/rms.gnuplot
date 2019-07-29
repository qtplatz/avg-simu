set terminal epslatex size 12.5in,12in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 5,2 title "RMS"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

set yrange [-2:2]
#set xrange [9.98:10.02]

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=512' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=512"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=256' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=256"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=128' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=128"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=64' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=64"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=32' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=32"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=16' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=16"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=8' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=8"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=4' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=4"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=2' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=2"

plot '< ../build/avgsimu --noise=1.2 --nions=0 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=0 --ztrig=1' \
     using ($1*1e6):2 with linespoints pt 4 ps 1 title "N=1"

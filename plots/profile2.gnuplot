set terminal epslatex size 12.5in,12in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 5,2 title "PKD+AVG Simulation (N=1000, 2-ions/trigger), Gain=20mV,$\\sigma_{gain}$=10mV"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

set ytics nomirror
set y2tics

#set xrange [9.98:10.02]

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=1.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "Single-ion,G:20mV"

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.01 --width=1.0' using ($1*1e6):2 with linespoints pt 4 ps 1 title "Single-ion,G:20mV"

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):2 with linespoints pt 6 ps 1 title "100\\%,$W_{peak}$=2ns" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):4 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):3 with impulses title "100\\%,$W_{peak}$=2ns,Counting" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=1000 --ztrig=0' \
     using ($1*1e6):5 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):2 with linespoints pt 6 ps 1 title "50\\%,$W_{peak}$=2ns" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):4 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):3 with impulses title "50\\%,$W_{peak}$=2ns,Counting" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=500 --ztrig=500' \
     using ($1*1e6):5 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):2 with linespoints pt 6 ps 1 title "25\\%,$W_{peak}$=2ns" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):4 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):3 with impulses title "25\\%,$W_{peak}$=2ns,Counting" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=250 --ztrig=750' \
     using ($1*1e6):5 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):2 with linespoints pt 6 ps 1 title "5\\%,$W_{peak}$=2ns" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):4 with impulses lw 5 lc 3 axes x1y2 notitle

plot '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):3 with impulses title "5\\%,$W_{peak}$=2ns,Counting" \
     , '< ../build/avgsimu --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10 --width=2.0 --ntrig=50 --ztrig=950' \
     using ($1*1e6):5 with impulses lw 5 lc 3 axes x1y2 notitle

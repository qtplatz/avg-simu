set terminal epslatex size 12in,16in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 3,2 title "Single Trigger Simulation"
#set datafile separator ","

set xlabel "time(microseconds)"
set ylabel "intensity(mV)"

set yrange [-2:20]
set xrange [9.98:10.02]

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.001 --width=2.0 --ntrig=1 --ztrig=0 --nbits=12 --adfs=1.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "Single-ion,PH:20mV, ADC: 12bit,1VFS"

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=1 --pulsewidth=1.0 --gain=20.0 --gain-sigma=0.001 --width=2.0 --ntrig=1 --ztrig=0 --nbits=12 --adfs=10.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "Single-ion,PH:20mV, ADC: 12bit,10VFS"

set yrange [-1:20]

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10.0 --width=2.0 --ntrig=256 --ztrig=0 --nbits=12 --adfs=1.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "20mV,$\\sigma$:10mV,W:4ns, ADC: 12bit,1VFS, n=256, 2-ions/trig"

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10.0 --width=2.0 --ntrig=256 --ztrig=0 --nbits=12 --adfs=10.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "20mV,$\\sigma$:10mV,W:4ns, ADC: 12bit,10VFS, n=256, 2-ions/trig"

set yrange [-2:50]

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10.0 --width=0.1 --ntrig=256 --ztrig=0 --nbits=12 --adfs=1.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "20mV,$\\sigma$:10mV,W:0.1ns, ADC: 12bit,1VFS, n=256, 2-ions/trig"

plot '< ../build/avgsimu --rate=2.0 --noise=1.2 --nions=2 --pulsewidth=1.0 --gain=20.0 --gain-sigma=10.0 --width=0.1 --ntrig=256 --ztrig=0 --nbits=12 --adfs=10.0' using ($1*1e6):($2*1000) with linespoints pt 4 ps 1 title "20mV,$\\sigma$:10mV,W:0.1ns, ADC: 12bit,10VFS, n=256, 2-ions/trig"

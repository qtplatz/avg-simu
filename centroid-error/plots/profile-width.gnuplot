reset

#set terminal postscript eps enhanced color size 11.5in,8.0in font 'Helvetica,24' linewidth 3
set terminal epslatex size 6in,9.5in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 5,1
set datafile separator ","

set format y "%.4f"

set xlabel "$$Time(\\mu s)$$"
set ylabel "Intensity"
set xrange[ 9.990: 10.010 ]
plot '< ../build/pksimu --width=0.5' using ($$1*1e6):2 with linespoints pt 4 ps 1 title "\\SI{0}{\\degree}, 1ns" \
     , '< ../build/pksimu --width=0.5' using ($$3*1e6):4 with linespoints pt 5 ps 1 title "\\SI{45}{\\degree}, 1ns" \
     , '< ../build/pksimu --width=2' using ($$1*1e6):2 with linespoints pt 6 ps 1 title "\\SI{0}{\\degree}, 4ns" \
     , '< ../build/pksimu --width=2' using ($$3*1e6):4 with points pt 7 ps 1 title "\\SI{45}{\\degree}, 4ns" \
     , '< ../build/pksimu --width=4' using ($$1*1e6):2 with linespoints pt 8 ps 1 title "\\SI{0}{\\degree}, 8ns" \
     , '< ../build/pksimu --width=4' using ($$3*1e6):4 with points pt 9 ps 1 title "\\SI{45}{\\degree}, 8ns"

unset xrange
set xlabel "Phase~shift $$(ns)$$"
set ylabel "Centroid~error $$(ps)$$"

plot '< ../build/pksimu --rate=1.0 --width=0.5 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,1.0ns"

plot '< ../build/pksimu --rate=1.0 --width=1.0 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,2.0ns"

plot '< ../build/pksimu --rate=1.0 --width=2.0 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,4.0ns"

plot '< ../build/pksimu --rate=1.0 --width=4.0 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz,8.0ns"

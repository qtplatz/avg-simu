reset

#set terminal postscript eps enhanced color size 11.5in,8.0in font 'Helvetica,24' linewidth 3
set terminal epslatex size 9.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,2
set datafile separator ","

set format y "%.4f"

set xlabel "$Time(\\mu s)$"
set ylabel "Intensity"

set xrange[ 9.996: 10.004 ]
set title "3.2GS/s"
plot '< ../build/pksimu --rate=3.2' using ($$1*1e6):2 with linespoints pt 4 ps 1 title "\\SI{0}{\\degree}" \
     , '< ../build/pksimu --rate=3.2' using ($$3*1e6):4 with linespoints pt 5 ps 1 title "\\SI{45}{\\degree}" \
     , '< ../build/pksimu --rate=3.2' using ($$5*1e6):6 with linespoints pt 6 ps 1 title "\\SI{90}{\\degree}"

set title "1.0GS/s"
plot '< ../build/pksimu --rate=1.0' using ($$1*1e6):2 with linespoints pt 4 ps 1 title "\\SI{0}{\\degree}" \
     , '< ../build/pksimu --rate=1.0' using ($$3*1e6):4 with linespoints pt 5 ps 1 title "\\SI{45}{\\degree}" \
     , '< ../build/pksimu --rate=1.0' using ($$5*1e6):6 with linespoints pt 6 ps 1 title "\\SI{90}{\\degree}"

unset title
unset xrange
set xlabel "Phase~shift $$(ns)$$"
set ylabel "Centroid~error $$(ps)$$"

plot '< ../build/pksimu --rate=3.2 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "3.2GHz"

unset xrange
set xlabel "Phase~shift $$(ns)$$"
set ylabel "Centroid~error $$(ps)$$"

plot '< ../build/pksimu --rate=1.0 --centroid' using ($$1*1e9):($$3*1e12) with linespoints pt 1 ps 1 title "1.0GHz"

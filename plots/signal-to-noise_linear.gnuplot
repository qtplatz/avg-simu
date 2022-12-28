set terminal epslatex size 5in,4in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'border.gnuplot'
#
#set multiplot layout 2,1 #title "Digital Signal Averaging (RMS noise = 1.2 mV, signal = 1.2 mV)"
#set datafile separator ","

set xlabel "Number of average ($N_{avg}$)"
set ylabel "Amplitude (a.u.)"

noise(x) = sqrt(x)
signal(x) = x
sn_r(x,r) = (x*r)/sqrt(x)
dB(x) = 20*log10(x)
set key left top

plot [0:200] (sqrt(x)) lw 10 title "noise" \
             , (x*0.1) lw 10 title "10\\% count rate signal"

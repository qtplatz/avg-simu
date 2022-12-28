set terminal epslatex size 5in,5in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#load 'border.gnuplot'
#
set multiplot layout 2,1 #title "Digital Signal Averaging (RMS noise = 1.2 mV, signal = 1.2 mV)"
#set datafile separator ","

set xlabel "Number of average ($N_{avg}$)"
set ylabel "SNR (dB)"

noise(x) = sqrt(x)
signal(x) = x
sn_r(x,r) = (x*r)/sqrt(x)
dB(x) = 20*log10(x)
set key left top

if ( 0 ) {
plot [1:200] sqrt(x) lw 10 title "noise" \
             , x*0.1 lw 10 title "10\\% count rate signal"
}

set grid

set logscale x
plot [1:10000] dB(x/sqrt(x)) lw 10 title "SNR" \
               , dB(x*0.1/sqrt(x)) lw 10 title "SNR for $R_c=$10\\%" \
               , dB(1) lw 2 lc "red" notitle "SNR=1"

unset yrange

set xlabel "Count rate ($R_c$)\\%"
set ylabel "$N_{avg}$ (where S/N=1)"

set key right top
set logscale xy
set yrange [0.5:*]

plot [0.1:100] (1/((x/100)**2)) lw 5 title "\\Large $\\frac{1}{R_c^2}$" \
               , 1 lw 1 lc "red" notitle "$N=1$"

if ( 0 ) {
set ylabel "dB"
plot [100.0:0] dB(sn_r(20000,x/100)) lw 5 title "N=20000" \
     , dB(sn_r(10000,x/100)) lw 5 title "N=10000" \
     , dB(sn_r(5000,x/100)) lw 5 title "N=5000"
}

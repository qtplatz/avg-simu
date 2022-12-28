set terminal epslatex size 6.5in,5in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'border.gnuplot'
#
set multiplot layout 2,1 #title "Digital Signal Averaging (RMS noise = 1.2 mV, signal = 1.2 mV)"
#set datafile separator ","

set xlabel "N average"
set ylabel "Amplitude (a.u.)"

noise(x) = sqrt(x)
signal(x) = x
sn_r(x,r) = (x*r)/sqrt(x)
dB(x) = 20*log10(x)
set key left top

plot [0:200] sqrt(x) lw 10 title "noise" \
     , x*0.1 lw 10 title "10\\% count rate signal"

#, sn_r(x,1.0) lw 5 title "100\\%" \
#     , sn_r(x,0.5) lw 5 title "10\\%" \
#     , sn_r(x,0.3) lw 5 title "1\\%"


if ( 0 ) {
set ylabel "dB"
#set logscale y 10
plot [0:20000] dB( sn_r(x,1.0)  ) lw 5 title "100\\%" \
     , dB( sn_r(x,0.5) ) lw 5 title "10\\%" \
     , dB( sn_r(x,0.3) ) lw 5 title "1\\%"
}

unset yrange
#unset logscale y
set xlabel "Count rate \\%"
set ylabel "S/N"

plot [0:100.0] sqrt(x/100)/(x/100) lw 10 title "\\Large $\\frac{\\sqrt{x}}{x}$"

if ( 0 ) {
#set logscale y 10
set ylabel "dB"
plot [100.0:0] dB(sn_r(20000,x/100)) lw 5 title "N=20000" \
     , dB(sn_r(10000,x/100)) lw 5 title "N=10000" \
     , dB(sn_r(5000,x/100)) lw 5 title "N=5000"
}

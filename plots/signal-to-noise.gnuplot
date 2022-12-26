set terminal epslatex size 5.0in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,1 #title "Digital Signal Averaging (RMS noise = 1.2 mV, signal = 1.2 mV)"
#set datafile separator ","

set xlabel "N average"
set ylabel "S/N"

noise(x) = sqrt(x)
signal(x) = x
sn_r(x,r) = x*r/sqrt(x)

plot [0:2000] sn_r(x,1.0) lw 5 title "100\\%" \
     , sn_r(x,0.5) lw 5 title "50\\%" \
     , sn_r(x,0.3) lw 5 title "30\\%"


set xlabel "C.R. \\%"
set ylabel "S/N"

plot [100.0:0] sn_r(2000,x/100) lw 5 title "N=2000" \
     , sn_r(1000,x/100) lw 5 title "N=1000" \
     , sn_r(500,x/100) lw 5 title "N=500"

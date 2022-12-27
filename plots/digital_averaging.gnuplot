set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,2 #title "Digital Signal Averaging (RMS noise = 1.2 mV, signal = 1.2 mV)"
#set datafile separator ","

set xlabel "Time (\\si{\\micro\\second})"
set ylabel "Intensity (mV)"

set xrange [9.98:10.02]

# RP = 2t/dt
# 10e-6 1.0e-9

ARGS = "-N %d -Z %d --noise=%g --nions=1 --pulsewidth=1.0 --gain=%g --gain-sigma=1e-9 --width=%g --rate=%d"
aY = -2
aW = 0.1
N = 1
rate = 2
noise = 1.2
gain = 1.2
array NN[4]
NN[1] = 1
NN[2] = 128
NN[3] = 1024
NN[4] = 8192

do for [i=1:4] {
    N = NN[i]
    set title sprintf("%g GSPS, R.P.=\\num{%d}, N$_{avg}$=%d, S/N=%5.0f", rate, (2*10E-6/(aW*1.0e-9))+0.5, N, (gain*N)/sqrt(noise*N) )
    if ( i == 1 ) {
	set yrange [-5:5]
	plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, noise, gain, aW, rate) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 5 title "waveform" \
	     , '< ../build/avgsimu ' . sprintf(ARGS, N, 0, 0, gain, aW, rate) using ($1*1e6):(-3+1000*$2/(4096*N)) with lines lw 3 title sprintf("Hidden peak (%g mV)", gain )
	unset yrange
    } else {
	plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, noise, gain, aW, rate) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 5 title "waveform"
    }
}



if (0) {

set label 1 at 10,aY "$3\\sigma$" offset -1,0.5

set title "2 GSPS, R.P.=\\num{5000}"
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 4.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 2.0

set title "2 GSPS, R.P.=\\num{10000}"
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 2.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 1.0

set title "2 GSPS, R.P.=\\num{20000}"
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 1.0, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"

aW = 0.5
set arrow 1 from (10-(aW/2000)*3),aY to (10+(aW/2000)*3),aY heads linecolor rgb "red" lw 5
set title "2 GSPS, R.P.=\\num{40000}"
plot '< ../build/avgsimu ' . sprintf(ARGS, N, 0, aW, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+4 ps 1 lw 2 title "C.R. \\SI{100}{\percent}" \
     , '< ../build/avgsimu ' . sprintf(ARGS, N*0.3, N*0.7, 0.5, 2) using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt i+5 ps 1 lw 2 title "C.R. \\SI{30}{\percent}"
}
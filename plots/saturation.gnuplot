set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
#
set multiplot layout 2,2 #title "PKD+AVG Simulation (N=1000), Gain=50mV,$\\sigma_{gain}$=50mV"
#set datafile separator ","

set xlabel "time (\\si{\\micro\\second})"
set ylabel "intensity (mV)"

#set yrange [-5:50]
set xrange [9.98:10.02]

set ytics nomirror
set ylabel "intensity(mV)"

ARGS = "-N %d --noise=2 --nions=%d --pulsewidth=1.0 --gain=50.0 --gain-sigma=300.0 --width=%g --rate=%g"
aW = 0.4
N = 1
rate = 2.0

#set y2range [-70:700]
#set yrange [-5:50]
CR = 1.0

do for [i=1:2] {
    system( "../build/avgsimu " . sprintf(ARGS, N, 12, aW, rate) . " > tmp.txt" )
    set yrange[-10:1000]
    #set arrow from 9.98,1000.0 to 10.02,1000.0 nohead lw 5 lc rgb "red"
    #set title sprintf("%d GSPS, R.P.=\\num{%d}", rate, ((2*10E-6)/(aW*1.0e-9))+0.5)
    plot 'tmp.txt' using ($1*1e6):(1000*$2/(4096*N)) with linespoints pt 4 ps 1 lw 5 title "AVG"

}

set ylabel "Frequency"
set xlabel "Intensity (mV)"
set xrange [0:1500]
gauss(x,t) = exp(-(x/t)**2)
nd(x, mu, sd) = (1/(sd*sqrt(2*pi)))*exp(-(x-mu)**2/(2*sd**2))

gain = 50
do for [i=1:2] {
    n = 10 + i*2
    s = gain*sqrt(n)
    m = gain*n
    yfs = 1/nd(gain*n,gain*n,gain*sqrt(n))
    set yrange [-0.1:1.1]
    # set yrange [0:nd(gain*n,gain*n,gain*sqrt(n))*1.1]
    set arrow 1 from 1000,0.0 to 1000,nd(1000,gain*n,gain*sqrt(n))*yfs nohead lw 5 lc rgb "red"
    set arrow 2 from m,0.0 to m,nd(gain*n,gain*n,gain*sqrt(n))*yfs nohead lw 3 # mean (center)
    plot nd(x,gain*n,gain*sqrt(n))*yfs lw 5 title sprintf("n-ions=%d, %g mV/ion, $m$=%g, $\\sigma$=%g", n, gain, gain*n, gain*sqrt(n)) \
	 , [1000:*] nd(x,gain*n,gain*sqrt(n))*yfs w filledcurves above x1=1000 lw 1 fc "red" fs solid 0.2 notitle
}

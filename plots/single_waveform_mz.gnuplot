set terminal epslatex size 10.5in,6in color colortext standalone header \
"\\usepackage{graphicx}\n\\usepackage{amsmath}\n\\usepackage[version=3]{mhchem}\n\\usepackage{siunitx}"

set output ARG1
load 'functions.gnuplot'
load 'constants.gnuplot'
load 'pdf.gnuplot'
#
set multiplot layout 2,2 columnsfirst #title "Simulated waveform averaging (50 mV, gain $\\sigma=$\\SI{1e-6}{\\milli\\volt})"
#set datafile separator ","

set xlabel "\\textit{m/z}"
set ylabel "Intensity (mV)"

set yrange [-5:50]
#set xrange [9.98:10.02]

ARGS = "--noise=1.2 --nions=1 --pulsewidth=1.0 --gain=50.0 --gain-sigma=1e-6 --width=%g --rate=%g --time=%g"
aY   = 45
rate = 2

array RPlist[ 4 ]
RPlist[ 1 ] = 10000
RPlist[ 2 ] = 10000
RPlist[ 3 ] = 10000
RPlist[ 4 ] = 10000

array TOFlist[ 4 ]
TOFlist[ 1 ] = 10
TOFlist[ 2 ] = 20
TOFlist[ 3 ] = 40
TOFlist[ 4 ] = 60

do for [i=1:4] {
    tof = TOFlist[ i ]
    aW  = RP2W( tof, RPlist[ i ] )
    m = accutof_mass( tof*1e-6, 0 )
    w = m / RPlist[ i ]

    set xrange [accutof_mass(tof*1e-6,0)-0.5:accutof_mass(tof*1e-6, 0)+0.5]
    y2fs = nd(m,m,w)
    set y2range [-y2fs*0.1:y2fs*1.1]

    system( "../build/avgsimu " . sprintf(ARGS, aW, rate, tof) . " > tmp.txt" )

    set label 1 at m,aY sprintf("%.2f mDa", w*1000) offset -1,0.5 front
    set arrow 1 from (m - w),aY to (m + w),aY heads linecolor rgb "red" lw 5 front
    set title sprintf("R.P.=\\num{%g}, \\textit{m/z} %g", RP(tof, aW), floor( accutof_mass( tof*1E-6, 0 ) ) )
    n = i + 2

    plot nd(x,m,w) with filledcurves fc "gray" fs solid 0.2 axes x1y2 notitle \
	 , for [i=1:n] '< ../build/avgsimu ' . sprintf(ARGS, aW, rate, tof) using (accutof_mass($1,0)):(1000*$2/4096) with linespoints pt i+4 lc i ps 1 lw 2 notitle \
}

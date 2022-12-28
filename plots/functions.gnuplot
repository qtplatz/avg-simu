
RP( tof, w ) = floor( ((tof*1E-6) / ((w * 1E-9) * 2)) + 0.5 )

RP2W( tof, rp ) = ( (tof*1E-6) / (2 * rp) ) / 1E-9  # return by ns

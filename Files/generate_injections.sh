#!/bin/bash
# write mdc.xml.gz
util_WriteInjectionFile.py --parameter m1 --parameter-value 50 --parameter m2 --parameter-value 50 --parameter s1x --parameter-value 0.0 --parameter s1y --parameter-value 0.0 --parameter s1z --parameter-value 0.6 --parameter s2x --parameter-value 0.0 --parameter s2y --parameter-value 0.0 --parameter s2z --parameter-value 0.6 --parameter eccentricity --parameter-value 0 --parameter meanPerAno --parameter-value 0 --approx SEOBNRv4 --parameter dist --parameter-value 3505.078588428868 --parameter fmin --parameter-value 10 --parameter incl --parameter-value 0.75 --parameter tref --parameter-value 1000000000 --parameter phiref --parameter-value 1.1 --parameter theta --parameter-value 0.53 --parameter phi --parameter-value 4.96 --parameter psi --parameter-value 1.6

# generate injections, will create plots with verbose flag
util_LALWriteFrame.py --inj mdc.xml.gz --event 0 --instrument H1 --start 999999850 --stop 1000000150 --approx "NRHybSur3dq8"   --verbose --srate 16384 --seglen 8 --fref 10  #--use-hlms-as-injections
util_LALWriteFrame.py --inj mdc.xml.gz --event 0 --instrument L1 --start 999999850 --stop 1000000150 --approx "NRHybSur3dq8"   --verbose --srate 16384 --seglen 8 --fref 10  #--use-hlms-as-injections 
util_LALWriteFrame.py --inj mdc.xml.gz --event 0 --instrument V1 --start 999999850 --stop 1000000150 --approx "NRHybSur3dq8"   --verbose --srate 16384 --seglen 8 --fref 10  #--use-hlms-as-injections

# calculate SNR, expects the psds to be outside one directory
ls *.gwf |lal_path2cache >local.cache; util_FrameZeroNoiseSNR.py --cache local.cache  --psd-file H1=../H1-psd.xml.gz --fmin-snr 20 --psd-file L1=../L1-psd.xml.gz --psd-file V1=../V1-psd.xml.gz --fmax-snr 2048

# generate coinc.xml
util_SimInspiralToCoinc.py --sim-xml mdc.xml.gz --event 0

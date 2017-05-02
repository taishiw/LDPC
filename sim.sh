#!/bin/sh
erb test_test.erb.v > test_test.v
erb Ctrl.erb.v > Ctrl.v
erb add.erb.v > add.v
erb row.erb.v >row.v
vlog +acc -lint test_test.v Ctrl.v row.v  add.v

roop=1
snrmax=1
snr=0
a=0
echo $roop >roop.txt
touch BERsoftref.txt
touch BERhardref.txt
:>BERsoftref.txt
:>BERhardref.txt
while [ $snr -ne $snrmax ]
do
    a=0
    echo $snr > snr.txt
    python3 file.py
while [ $a -ne $roop ]
do
    python3 minsum.py <snr.txt
    python3 format10to2.py
    #vlog +acc -lint test_test.v exor.v min.v add.v com.v
    vsim -c -do  'run -all ; exit ' test_test
    python3 minsumref.py <snr.txt
    python3 BER.py
    mv BERsofttest.txt BERsoft.txt
    mv BERhardtest.txt BERhard.txt
    a=`expr $a + 1`
done
paste snr.txt roop.txt>output
python3 BERref.py<output
snr=`expr $snr + 1`
done

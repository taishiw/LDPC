#!/bin/sh
export ROW_NUMBER=400
export COL_NUMBER=200
export ROW_WEIGHT=4
export COL_WEIGHT=2
export WIDTH=16
export INTEGER_WIDTH=8
export DECIMAL_WIDTH=8
export LOOP_MAX=100
snr=0
echo $snr > snr.txt
python3 minsumsim.py <snr.txt
python3 format10to2.py
python3 format10to16.py
erb test_test_m.erb.v > test_test.v
erb sram.erb.v > sram.v
erb sram_lambda.erb.v > sram_lambda.v
erb Ctrl_m.erb.v > Ctrl.v
erb add.erb.v > add.v
erb row.erb.v >row.v
vlog +acc -lint test_test.v Ctrl.v row.v  add.v sram.v sram_lambda.v
vsim -c -do  'run -all ; exit ' test_test
python3 format2to10.py


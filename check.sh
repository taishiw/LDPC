#!/bin/sh
export ROW_NUMBER=6
export COL_NUMBER=4
export ROW_WEIGHT=3
export COL_WEIGHT=2
export WIDTH=12
export INTEGER_WIDTH=4
export DECIMAL_WIDTH=8
export LOOP_MAX=5
snr=0
echo $snr > snr.txt

erb test_test_check.erb.v > test_test.v
erb Ctrl_check.erb.v > Ctrl.v
erb add.erb.v > add.v
erb row.erb.v >row.v
vlog +acc -lint test_test.v Ctrl.v row.v  add.v
vsim -c -do  'run -all ; exit ' test_test
python3 format2to10.py


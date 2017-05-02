#!/bin/sh
erb test_test.erb.v > test_test.v
erb Ctrl.erb.v > Ctrl.v
erb add.erb.v > add.v
erb row.erb.v >row.v
vlog +acc -lint test_test.v Ctrl.v row.v  add.v
vsim test_test

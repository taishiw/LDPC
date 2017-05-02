onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_test/ctrl/sramalpha/clk
add wave -noupdate /test_test/ctrl/sramalpha/i_wen
add wave -noupdate /test_test/ctrl/sramalpha/i_waddr
add wave -noupdate /test_test/ctrl/sramalpha/i_raddr
add wave -noupdate /test_test/ctrl/sramalpha/i_wdata
add wave -noupdate /test_test/ctrl/sramalpha/o_rdata
add wave -noupdate /test_test/ctrl/sramalpha/mem
add wave -noupdate /test_test/ctrl/sramlambda/clk
add wave -noupdate /test_test/ctrl/sramlambda/i_wen
add wave -noupdate /test_test/ctrl/sramlambda/i_waddr
add wave -noupdate /test_test/ctrl/sramlambda/i_raddr
add wave -noupdate /test_test/ctrl/sramlambda/i_wdata
add wave -noupdate /test_test/ctrl/sramlambda/o_rdata
add wave -noupdate /test_test/ctrl/sramlambda/mem
add wave -noupdate -expand /test_test/ctrl/estimate
add wave -noupdate /test_test/ctrl/add/i_data
add wave -noupdate /test_test/ctrl/add/i_val
add wave -noupdate /test_test/ctrl/add/o_data
add wave -noupdate /test_test/ctrl/add/o_val
add wave -noupdate /test_test/ctrl/add/clk
add wave -noupdate /test_test/ctrl/add/xrst
add wave -noupdate /test_test/ctrl/add/i_init
add wave -noupdate /test_test/ctrl/a
add wave -noupdate /test_test/ctrl/b
add wave -noupdate /test_test/ctrl/c
add wave -noupdate /test_test/ctrl/d
add wave -noupdate /test_test/ctrl/e
add wave -noupdate /test_test/ctrl/f
add wave -noupdate /test_test/ctrl/g
add wave -noupdate /test_test/ctrl/h
add wave -noupdate /test_test/ctrl/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5006 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 282
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {4739 ns} {5541 ns}

set_property SRC_FILE_INFO {cfile:/home/taishi/analysis/clk.xdc rfile:../../../../clk.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:1 export:INPUT save:INPUT read:READ} [current_design]
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

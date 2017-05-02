# 変数定義
set top Ctrl
set work work

create_project -in_memory -part xc7v2000tflg1925-1

# ソースの読み込み
read_verilog {
Ctrl.v
row.v
add.v
sram.v
sram_lambda.v
}
# 複数のファイルを読み込む場合は
# read_verilog {
# A.v
# B.v
# C.v
# }
# みたいに書いても OK

# クロック
read_xdc clk.xdc

# 論理合成を実行
synth_design -top ${top} -directive runtimeoptimized -part xc7v2000tflg1925-1

# 合成結果の書き出し
report_utilization -file ${work}/${top}_utilization_synth.rpt
report_timing_summary -file ${work}/${top}_timing_summary_synth.rpt
report_timing -nworst 50 -file ${work}/${top}_timing_synth.rpt

# 最適化，配置，配線
opt_design
place_design
route_design

# 配置配線結果の書き出し
report_utilization  -file ${work}/${top}_utilization_route.rpt
report_timing -file ${work}/${top}_timing_summary_route.rpt
report_timing -nworst 50 -file ${work}/${top}_timing_route.rpt

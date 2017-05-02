#!/bin/sh
#
#title, 横軸の最小値、最大値を引数に入れると、
#gnuplotによるsin(x)のプロットを行ない、ポストスクリプトで保存する

#--- 引数チェック、格納。使用方法表示。
### $#はコマンドラインに続く文字列の数。

### 引数は、図のタイトル、xの最小値、xの最大値の３つ。
TITLE="SNR"
XMIN="0"
XMAX="5"

#---シェル内でのgnuplot起動
#### EOF行までの間に空行を挟んではいけない。
gnuplot<<EOF
set out "SNR.ps"
set term post land
set xr [$XMIN:$XMAX]
set title "$TITLE"
set logscale y
set xlabel 'SNR'font "century gothic,15"
set key font "century gothic,15"
set ylabel 'BER'font "century gothic,15"
plot 'BERhardref0120.txt' title "hard" lc rgb "blue" w l,'BERsoftref0120.txt' title "soft" lc rgb "red" w l
EOF

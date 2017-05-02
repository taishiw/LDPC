# -*- coding: utf-8 -*-
import math
import numpy as np
import os

#書き込み用ファイル
f=open('input.txt','w')

#読み込みファイル
g=open("inputtest.txt").readlines()

#0行列の生成
y=np.zeros(len(g))
z=np.zeros(len(g))

#環境変数から整数部と小数部の幅と全体の幅を決定
INTEGER_WIDTH = int(os.getenv('INTEGER_WIDTH'))
DECIMAL_WIDTH = int(os.getenv('DECIMAL_WIDTH'))
WIDTH = int(os.getenv('WIDTH'))

#整数部と小数部を生成
for j in range (len(g)):
    y[j]=float(g[j])
    
for i in range(len(g)):
    if y[i]>=0.0:
        f.write(format(int(y[i]*(2**DECIMAL_WIDTH)),'0%sb' %(WIDTH)).rstrip('\r\n')+'\n')
    else :
        f.write(format(int(2**WIDTH+y[i]*(2**DECIMAL_WIDTH)),'0%sb' %(WIDTH)).rstrip('\r\n')+'\n')
    



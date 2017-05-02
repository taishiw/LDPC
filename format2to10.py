# -*- coding: utf-8 -*-
"""固定小数点で2bitを10bitに変換する"""
import math
import numpy as np
import os

#書き込み用ファイル
f=open('outputalpha10.txt','w')#10bitのαファイル
g=open('outputbeta10.txt','w')#10bitのβファイル

#読み込みファイル
h=open("outputalpha.txt").readlines()#2bitのαファイル
l=open("outputbeta.txt").readlines()#2bitのβファイル

#0行列の生成
y=np.zeros(len(h))
z=np.zeros(len(l))
k=np.zeros(len(h))
m=np.zeros(len(l))

#環境変数から整数部と小数部の幅と全体の幅を決定
INTEGER_WIDTH = int(os.getenv('INTEGER_WIDTH'))
DECIMAL_WIDTH = int(os.getenv('DECIMAL_WIDTH'))
WIDTH = int(os.getenv('WIDTH'))

#hを2bitに変換
for j in range (len(h)):
    y[j]=int(h[j],2)

#整数部と小数部を生成
for i in range(len(h)):
    if y[i]<=2**(WIDTH-1):
        f.write(str(y[i]*(2**(-DECIMAL_WIDTH))).rstrip('\r\n')+'\n')
    else :
        k[i]=int(format(int(2**WIDTH-y[i]),'0%sb' %(WIDTH)),2)
        f.write(str((-1)*((k[i]*(2**(-DECIMAL_WIDTH))))).rstrip('\r\n')+'\n')

#jを2bitに変換
for j in range (len(l)):
    z[j]=int(l[j],2)

#整数部と小数部の生成
for i in range(len(l)):
    if z[i]<=2**(WIDTH-1):
        g.write(str(z[i]*(2**(-DECIMAL_WIDTH))).rstrip('\r\n')+'\n')
    else :
        m[i]=int(format(int(2**WIDTH-z[i]),'0%sb' %(WIDTH)),2)
        g.write(str((-1)*((m[i]*(2**(-DECIMAL_WIDTH))))).rstrip('\r\n')+'\n')


    



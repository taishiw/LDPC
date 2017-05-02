# -*- coding: utf-8 -*-
import math
import numpy as np
import os
f=open('input16.txt','w')
g=open("inputtest.txt").readlines()
h=open('outputalpha16.txt','w')
k=open('outputsoftalpha.txt').readlines()
l=open('outputbeta16.txt','w')
m=open('outputsoftbeta.txt').readlines()
x=np.zeros(len(g))
y=np.zeros(len(k))
z=np.zeros(len(m))

#環境変数から整数部と小数部の幅と全体の幅を決定
INTEGER_WIDTH = int(os.getenv('INTEGER_WIDTH'))
DECIMAL_WIDTH = int(os.getenv('DECIMAL_WIDTH'))
WIDTH = int(os.getenv('WIDTH'))

for j in range (len(g)):
    x[j]=float(g[j])
for i in range(len(g)):
    if x[i]>=0.0:
        f.write('hex{0:#x}'.format(int(x[i]*(16**DECIMAL_WIDTH)))+'\n')
    else :
        f.write('hex{0:#x}'.format(int(16**WIDTH+x[i]*(16**DECIMAL_WIDTH)))+'\n')
for j in range (len(k)):
    y[j]=float(k[j])
#print (y)
for i in range(len(k)):
    if y[i]>=0.0:
        h.write('hex{0:#x}'.format(int(y[i]*(16**DECIMAL_WIDTH)))+'\n')
    else :
        h.write('hex{0:#x}'.format(int(16**WIDTH+y[i]*(16**DECIMAL_WIDTH)))+'\n')

for j in range (len(m)):
    z[j]=float(m[j])
#print (y)
for i in range(len(m)):
    if z[i]>=0.0:
        l.write('hex{0:#x}'.format(int(z[i]*(16**DECIMAL_WIDTH)))+'\n')
    else :
        l.write('hex{0:#x}'.format(int(16**WIDTH+z[i]*(16**DECIMAL_WIDTH)))+'\n')


    



# -*- coding: utf-8 -*-
import math
import numpy as np
w=open("array.txt",'w')
H=np.array([[1,1,1,0,0,0],
          [0,0,0,1,1,1],
          [1,1,0,0,1,0],
          [0,0,1,1,0,1]])
#for i in range(len(H[0])):
 #   for j in range(len(H[:,[0])):
  #      if H[i][j]==1:
   #         A.append(i)
    #        A.append(j)
i,j=H.nonzero()
for k in range(12):
    w.write (str(i[k])+' ')
    w.write (str(j[k])+'\n')
    

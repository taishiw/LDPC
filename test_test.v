/* */

module test_test();
   reg signed[15:0] mem[0:399];      //lambda data 
   wire 		 o_val;         //control signal
   reg 			 i_val;
   reg 			 clk;           //System clock 
   reg 			 xrst;          //reset signal 	
   reg [9:0] 		 r_counter; 	    
   wire [399:0] estimate;
   wire [15:0] 	 i_data; 
   wire [6:0] 		 w_loop;
   parameter zClk = 20;            //clock time
   integer 		 mcd3;
   integer 		 i;	 
   //clock reversal
   always #(zClk/2) clk <= ~clk;
   
   assign i_data[15:0]=
		    /**/
		    (r_counter == 1)? mem[0]:
		    /**/
		    (r_counter == 2)? mem[1]:
		    /**/
		    (r_counter == 3)? mem[2]:
		    /**/
		    (r_counter == 4)? mem[3]:
		    /**/
		    (r_counter == 5)? mem[4]:
		    /**/
		    (r_counter == 6)? mem[5]:
		    /**/
		    (r_counter == 7)? mem[6]:
		    /**/
		    (r_counter == 8)? mem[7]:
		    /**/
		    (r_counter == 9)? mem[8]:
		    /**/
		    (r_counter == 10)? mem[9]:
		    /**/
		    (r_counter == 11)? mem[10]:
		    /**/
		    (r_counter == 12)? mem[11]:
		    /**/
		    (r_counter == 13)? mem[12]:
		    /**/
		    (r_counter == 14)? mem[13]:
		    /**/
		    (r_counter == 15)? mem[14]:
		    /**/
		    (r_counter == 16)? mem[15]:
		    /**/
		    (r_counter == 17)? mem[16]:
		    /**/
		    (r_counter == 18)? mem[17]:
		    /**/
		    (r_counter == 19)? mem[18]:
		    /**/
		    (r_counter == 20)? mem[19]:
		    /**/
		    (r_counter == 21)? mem[20]:
		    /**/
		    (r_counter == 22)? mem[21]:
		    /**/
		    (r_counter == 23)? mem[22]:
		    /**/
		    (r_counter == 24)? mem[23]:
		    /**/
		    (r_counter == 25)? mem[24]:
		    /**/
		    (r_counter == 26)? mem[25]:
		    /**/
		    (r_counter == 27)? mem[26]:
		    /**/
		    (r_counter == 28)? mem[27]:
		    /**/
		    (r_counter == 29)? mem[28]:
		    /**/
		    (r_counter == 30)? mem[29]:
		    /**/
		    (r_counter == 31)? mem[30]:
		    /**/
		    (r_counter == 32)? mem[31]:
		    /**/
		    (r_counter == 33)? mem[32]:
		    /**/
		    (r_counter == 34)? mem[33]:
		    /**/
		    (r_counter == 35)? mem[34]:
		    /**/
		    (r_counter == 36)? mem[35]:
		    /**/
		    (r_counter == 37)? mem[36]:
		    /**/
		    (r_counter == 38)? mem[37]:
		    /**/
		    (r_counter == 39)? mem[38]:
		    /**/
		    (r_counter == 40)? mem[39]:
		    /**/
		    (r_counter == 41)? mem[40]:
		    /**/
		    (r_counter == 42)? mem[41]:
		    /**/
		    (r_counter == 43)? mem[42]:
		    /**/
		    (r_counter == 44)? mem[43]:
		    /**/
		    (r_counter == 45)? mem[44]:
		    /**/
		    (r_counter == 46)? mem[45]:
		    /**/
		    (r_counter == 47)? mem[46]:
		    /**/
		    (r_counter == 48)? mem[47]:
		    /**/
		    (r_counter == 49)? mem[48]:
		    /**/
		    (r_counter == 50)? mem[49]:
		    /**/
		    (r_counter == 51)? mem[50]:
		    /**/
		    (r_counter == 52)? mem[51]:
		    /**/
		    (r_counter == 53)? mem[52]:
		    /**/
		    (r_counter == 54)? mem[53]:
		    /**/
		    (r_counter == 55)? mem[54]:
		    /**/
		    (r_counter == 56)? mem[55]:
		    /**/
		    (r_counter == 57)? mem[56]:
		    /**/
		    (r_counter == 58)? mem[57]:
		    /**/
		    (r_counter == 59)? mem[58]:
		    /**/
		    (r_counter == 60)? mem[59]:
		    /**/
		    (r_counter == 61)? mem[60]:
		    /**/
		    (r_counter == 62)? mem[61]:
		    /**/
		    (r_counter == 63)? mem[62]:
		    /**/
		    (r_counter == 64)? mem[63]:
		    /**/
		    (r_counter == 65)? mem[64]:
		    /**/
		    (r_counter == 66)? mem[65]:
		    /**/
		    (r_counter == 67)? mem[66]:
		    /**/
		    (r_counter == 68)? mem[67]:
		    /**/
		    (r_counter == 69)? mem[68]:
		    /**/
		    (r_counter == 70)? mem[69]:
		    /**/
		    (r_counter == 71)? mem[70]:
		    /**/
		    (r_counter == 72)? mem[71]:
		    /**/
		    (r_counter == 73)? mem[72]:
		    /**/
		    (r_counter == 74)? mem[73]:
		    /**/
		    (r_counter == 75)? mem[74]:
		    /**/
		    (r_counter == 76)? mem[75]:
		    /**/
		    (r_counter == 77)? mem[76]:
		    /**/
		    (r_counter == 78)? mem[77]:
		    /**/
		    (r_counter == 79)? mem[78]:
		    /**/
		    (r_counter == 80)? mem[79]:
		    /**/
		    (r_counter == 81)? mem[80]:
		    /**/
		    (r_counter == 82)? mem[81]:
		    /**/
		    (r_counter == 83)? mem[82]:
		    /**/
		    (r_counter == 84)? mem[83]:
		    /**/
		    (r_counter == 85)? mem[84]:
		    /**/
		    (r_counter == 86)? mem[85]:
		    /**/
		    (r_counter == 87)? mem[86]:
		    /**/
		    (r_counter == 88)? mem[87]:
		    /**/
		    (r_counter == 89)? mem[88]:
		    /**/
		    (r_counter == 90)? mem[89]:
		    /**/
		    (r_counter == 91)? mem[90]:
		    /**/
		    (r_counter == 92)? mem[91]:
		    /**/
		    (r_counter == 93)? mem[92]:
		    /**/
		    (r_counter == 94)? mem[93]:
		    /**/
		    (r_counter == 95)? mem[94]:
		    /**/
		    (r_counter == 96)? mem[95]:
		    /**/
		    (r_counter == 97)? mem[96]:
		    /**/
		    (r_counter == 98)? mem[97]:
		    /**/
		    (r_counter == 99)? mem[98]:
		    /**/
		    (r_counter == 100)? mem[99]:
		    /**/
		    (r_counter == 101)? mem[100]:
		    /**/
		    (r_counter == 102)? mem[101]:
		    /**/
		    (r_counter == 103)? mem[102]:
		    /**/
		    (r_counter == 104)? mem[103]:
		    /**/
		    (r_counter == 105)? mem[104]:
		    /**/
		    (r_counter == 106)? mem[105]:
		    /**/
		    (r_counter == 107)? mem[106]:
		    /**/
		    (r_counter == 108)? mem[107]:
		    /**/
		    (r_counter == 109)? mem[108]:
		    /**/
		    (r_counter == 110)? mem[109]:
		    /**/
		    (r_counter == 111)? mem[110]:
		    /**/
		    (r_counter == 112)? mem[111]:
		    /**/
		    (r_counter == 113)? mem[112]:
		    /**/
		    (r_counter == 114)? mem[113]:
		    /**/
		    (r_counter == 115)? mem[114]:
		    /**/
		    (r_counter == 116)? mem[115]:
		    /**/
		    (r_counter == 117)? mem[116]:
		    /**/
		    (r_counter == 118)? mem[117]:
		    /**/
		    (r_counter == 119)? mem[118]:
		    /**/
		    (r_counter == 120)? mem[119]:
		    /**/
		    (r_counter == 121)? mem[120]:
		    /**/
		    (r_counter == 122)? mem[121]:
		    /**/
		    (r_counter == 123)? mem[122]:
		    /**/
		    (r_counter == 124)? mem[123]:
		    /**/
		    (r_counter == 125)? mem[124]:
		    /**/
		    (r_counter == 126)? mem[125]:
		    /**/
		    (r_counter == 127)? mem[126]:
		    /**/
		    (r_counter == 128)? mem[127]:
		    /**/
		    (r_counter == 129)? mem[128]:
		    /**/
		    (r_counter == 130)? mem[129]:
		    /**/
		    (r_counter == 131)? mem[130]:
		    /**/
		    (r_counter == 132)? mem[131]:
		    /**/
		    (r_counter == 133)? mem[132]:
		    /**/
		    (r_counter == 134)? mem[133]:
		    /**/
		    (r_counter == 135)? mem[134]:
		    /**/
		    (r_counter == 136)? mem[135]:
		    /**/
		    (r_counter == 137)? mem[136]:
		    /**/
		    (r_counter == 138)? mem[137]:
		    /**/
		    (r_counter == 139)? mem[138]:
		    /**/
		    (r_counter == 140)? mem[139]:
		    /**/
		    (r_counter == 141)? mem[140]:
		    /**/
		    (r_counter == 142)? mem[141]:
		    /**/
		    (r_counter == 143)? mem[142]:
		    /**/
		    (r_counter == 144)? mem[143]:
		    /**/
		    (r_counter == 145)? mem[144]:
		    /**/
		    (r_counter == 146)? mem[145]:
		    /**/
		    (r_counter == 147)? mem[146]:
		    /**/
		    (r_counter == 148)? mem[147]:
		    /**/
		    (r_counter == 149)? mem[148]:
		    /**/
		    (r_counter == 150)? mem[149]:
		    /**/
		    (r_counter == 151)? mem[150]:
		    /**/
		    (r_counter == 152)? mem[151]:
		    /**/
		    (r_counter == 153)? mem[152]:
		    /**/
		    (r_counter == 154)? mem[153]:
		    /**/
		    (r_counter == 155)? mem[154]:
		    /**/
		    (r_counter == 156)? mem[155]:
		    /**/
		    (r_counter == 157)? mem[156]:
		    /**/
		    (r_counter == 158)? mem[157]:
		    /**/
		    (r_counter == 159)? mem[158]:
		    /**/
		    (r_counter == 160)? mem[159]:
		    /**/
		    (r_counter == 161)? mem[160]:
		    /**/
		    (r_counter == 162)? mem[161]:
		    /**/
		    (r_counter == 163)? mem[162]:
		    /**/
		    (r_counter == 164)? mem[163]:
		    /**/
		    (r_counter == 165)? mem[164]:
		    /**/
		    (r_counter == 166)? mem[165]:
		    /**/
		    (r_counter == 167)? mem[166]:
		    /**/
		    (r_counter == 168)? mem[167]:
		    /**/
		    (r_counter == 169)? mem[168]:
		    /**/
		    (r_counter == 170)? mem[169]:
		    /**/
		    (r_counter == 171)? mem[170]:
		    /**/
		    (r_counter == 172)? mem[171]:
		    /**/
		    (r_counter == 173)? mem[172]:
		    /**/
		    (r_counter == 174)? mem[173]:
		    /**/
		    (r_counter == 175)? mem[174]:
		    /**/
		    (r_counter == 176)? mem[175]:
		    /**/
		    (r_counter == 177)? mem[176]:
		    /**/
		    (r_counter == 178)? mem[177]:
		    /**/
		    (r_counter == 179)? mem[178]:
		    /**/
		    (r_counter == 180)? mem[179]:
		    /**/
		    (r_counter == 181)? mem[180]:
		    /**/
		    (r_counter == 182)? mem[181]:
		    /**/
		    (r_counter == 183)? mem[182]:
		    /**/
		    (r_counter == 184)? mem[183]:
		    /**/
		    (r_counter == 185)? mem[184]:
		    /**/
		    (r_counter == 186)? mem[185]:
		    /**/
		    (r_counter == 187)? mem[186]:
		    /**/
		    (r_counter == 188)? mem[187]:
		    /**/
		    (r_counter == 189)? mem[188]:
		    /**/
		    (r_counter == 190)? mem[189]:
		    /**/
		    (r_counter == 191)? mem[190]:
		    /**/
		    (r_counter == 192)? mem[191]:
		    /**/
		    (r_counter == 193)? mem[192]:
		    /**/
		    (r_counter == 194)? mem[193]:
		    /**/
		    (r_counter == 195)? mem[194]:
		    /**/
		    (r_counter == 196)? mem[195]:
		    /**/
		    (r_counter == 197)? mem[196]:
		    /**/
		    (r_counter == 198)? mem[197]:
		    /**/
		    (r_counter == 199)? mem[198]:
		    /**/
		    (r_counter == 200)? mem[199]:
		    /**/
		    (r_counter == 201)? mem[200]:
		    /**/
		    (r_counter == 202)? mem[201]:
		    /**/
		    (r_counter == 203)? mem[202]:
		    /**/
		    (r_counter == 204)? mem[203]:
		    /**/
		    (r_counter == 205)? mem[204]:
		    /**/
		    (r_counter == 206)? mem[205]:
		    /**/
		    (r_counter == 207)? mem[206]:
		    /**/
		    (r_counter == 208)? mem[207]:
		    /**/
		    (r_counter == 209)? mem[208]:
		    /**/
		    (r_counter == 210)? mem[209]:
		    /**/
		    (r_counter == 211)? mem[210]:
		    /**/
		    (r_counter == 212)? mem[211]:
		    /**/
		    (r_counter == 213)? mem[212]:
		    /**/
		    (r_counter == 214)? mem[213]:
		    /**/
		    (r_counter == 215)? mem[214]:
		    /**/
		    (r_counter == 216)? mem[215]:
		    /**/
		    (r_counter == 217)? mem[216]:
		    /**/
		    (r_counter == 218)? mem[217]:
		    /**/
		    (r_counter == 219)? mem[218]:
		    /**/
		    (r_counter == 220)? mem[219]:
		    /**/
		    (r_counter == 221)? mem[220]:
		    /**/
		    (r_counter == 222)? mem[221]:
		    /**/
		    (r_counter == 223)? mem[222]:
		    /**/
		    (r_counter == 224)? mem[223]:
		    /**/
		    (r_counter == 225)? mem[224]:
		    /**/
		    (r_counter == 226)? mem[225]:
		    /**/
		    (r_counter == 227)? mem[226]:
		    /**/
		    (r_counter == 228)? mem[227]:
		    /**/
		    (r_counter == 229)? mem[228]:
		    /**/
		    (r_counter == 230)? mem[229]:
		    /**/
		    (r_counter == 231)? mem[230]:
		    /**/
		    (r_counter == 232)? mem[231]:
		    /**/
		    (r_counter == 233)? mem[232]:
		    /**/
		    (r_counter == 234)? mem[233]:
		    /**/
		    (r_counter == 235)? mem[234]:
		    /**/
		    (r_counter == 236)? mem[235]:
		    /**/
		    (r_counter == 237)? mem[236]:
		    /**/
		    (r_counter == 238)? mem[237]:
		    /**/
		    (r_counter == 239)? mem[238]:
		    /**/
		    (r_counter == 240)? mem[239]:
		    /**/
		    (r_counter == 241)? mem[240]:
		    /**/
		    (r_counter == 242)? mem[241]:
		    /**/
		    (r_counter == 243)? mem[242]:
		    /**/
		    (r_counter == 244)? mem[243]:
		    /**/
		    (r_counter == 245)? mem[244]:
		    /**/
		    (r_counter == 246)? mem[245]:
		    /**/
		    (r_counter == 247)? mem[246]:
		    /**/
		    (r_counter == 248)? mem[247]:
		    /**/
		    (r_counter == 249)? mem[248]:
		    /**/
		    (r_counter == 250)? mem[249]:
		    /**/
		    (r_counter == 251)? mem[250]:
		    /**/
		    (r_counter == 252)? mem[251]:
		    /**/
		    (r_counter == 253)? mem[252]:
		    /**/
		    (r_counter == 254)? mem[253]:
		    /**/
		    (r_counter == 255)? mem[254]:
		    /**/
		    (r_counter == 256)? mem[255]:
		    /**/
		    (r_counter == 257)? mem[256]:
		    /**/
		    (r_counter == 258)? mem[257]:
		    /**/
		    (r_counter == 259)? mem[258]:
		    /**/
		    (r_counter == 260)? mem[259]:
		    /**/
		    (r_counter == 261)? mem[260]:
		    /**/
		    (r_counter == 262)? mem[261]:
		    /**/
		    (r_counter == 263)? mem[262]:
		    /**/
		    (r_counter == 264)? mem[263]:
		    /**/
		    (r_counter == 265)? mem[264]:
		    /**/
		    (r_counter == 266)? mem[265]:
		    /**/
		    (r_counter == 267)? mem[266]:
		    /**/
		    (r_counter == 268)? mem[267]:
		    /**/
		    (r_counter == 269)? mem[268]:
		    /**/
		    (r_counter == 270)? mem[269]:
		    /**/
		    (r_counter == 271)? mem[270]:
		    /**/
		    (r_counter == 272)? mem[271]:
		    /**/
		    (r_counter == 273)? mem[272]:
		    /**/
		    (r_counter == 274)? mem[273]:
		    /**/
		    (r_counter == 275)? mem[274]:
		    /**/
		    (r_counter == 276)? mem[275]:
		    /**/
		    (r_counter == 277)? mem[276]:
		    /**/
		    (r_counter == 278)? mem[277]:
		    /**/
		    (r_counter == 279)? mem[278]:
		    /**/
		    (r_counter == 280)? mem[279]:
		    /**/
		    (r_counter == 281)? mem[280]:
		    /**/
		    (r_counter == 282)? mem[281]:
		    /**/
		    (r_counter == 283)? mem[282]:
		    /**/
		    (r_counter == 284)? mem[283]:
		    /**/
		    (r_counter == 285)? mem[284]:
		    /**/
		    (r_counter == 286)? mem[285]:
		    /**/
		    (r_counter == 287)? mem[286]:
		    /**/
		    (r_counter == 288)? mem[287]:
		    /**/
		    (r_counter == 289)? mem[288]:
		    /**/
		    (r_counter == 290)? mem[289]:
		    /**/
		    (r_counter == 291)? mem[290]:
		    /**/
		    (r_counter == 292)? mem[291]:
		    /**/
		    (r_counter == 293)? mem[292]:
		    /**/
		    (r_counter == 294)? mem[293]:
		    /**/
		    (r_counter == 295)? mem[294]:
		    /**/
		    (r_counter == 296)? mem[295]:
		    /**/
		    (r_counter == 297)? mem[296]:
		    /**/
		    (r_counter == 298)? mem[297]:
		    /**/
		    (r_counter == 299)? mem[298]:
		    /**/
		    (r_counter == 300)? mem[299]:
		    /**/
		    (r_counter == 301)? mem[300]:
		    /**/
		    (r_counter == 302)? mem[301]:
		    /**/
		    (r_counter == 303)? mem[302]:
		    /**/
		    (r_counter == 304)? mem[303]:
		    /**/
		    (r_counter == 305)? mem[304]:
		    /**/
		    (r_counter == 306)? mem[305]:
		    /**/
		    (r_counter == 307)? mem[306]:
		    /**/
		    (r_counter == 308)? mem[307]:
		    /**/
		    (r_counter == 309)? mem[308]:
		    /**/
		    (r_counter == 310)? mem[309]:
		    /**/
		    (r_counter == 311)? mem[310]:
		    /**/
		    (r_counter == 312)? mem[311]:
		    /**/
		    (r_counter == 313)? mem[312]:
		    /**/
		    (r_counter == 314)? mem[313]:
		    /**/
		    (r_counter == 315)? mem[314]:
		    /**/
		    (r_counter == 316)? mem[315]:
		    /**/
		    (r_counter == 317)? mem[316]:
		    /**/
		    (r_counter == 318)? mem[317]:
		    /**/
		    (r_counter == 319)? mem[318]:
		    /**/
		    (r_counter == 320)? mem[319]:
		    /**/
		    (r_counter == 321)? mem[320]:
		    /**/
		    (r_counter == 322)? mem[321]:
		    /**/
		    (r_counter == 323)? mem[322]:
		    /**/
		    (r_counter == 324)? mem[323]:
		    /**/
		    (r_counter == 325)? mem[324]:
		    /**/
		    (r_counter == 326)? mem[325]:
		    /**/
		    (r_counter == 327)? mem[326]:
		    /**/
		    (r_counter == 328)? mem[327]:
		    /**/
		    (r_counter == 329)? mem[328]:
		    /**/
		    (r_counter == 330)? mem[329]:
		    /**/
		    (r_counter == 331)? mem[330]:
		    /**/
		    (r_counter == 332)? mem[331]:
		    /**/
		    (r_counter == 333)? mem[332]:
		    /**/
		    (r_counter == 334)? mem[333]:
		    /**/
		    (r_counter == 335)? mem[334]:
		    /**/
		    (r_counter == 336)? mem[335]:
		    /**/
		    (r_counter == 337)? mem[336]:
		    /**/
		    (r_counter == 338)? mem[337]:
		    /**/
		    (r_counter == 339)? mem[338]:
		    /**/
		    (r_counter == 340)? mem[339]:
		    /**/
		    (r_counter == 341)? mem[340]:
		    /**/
		    (r_counter == 342)? mem[341]:
		    /**/
		    (r_counter == 343)? mem[342]:
		    /**/
		    (r_counter == 344)? mem[343]:
		    /**/
		    (r_counter == 345)? mem[344]:
		    /**/
		    (r_counter == 346)? mem[345]:
		    /**/
		    (r_counter == 347)? mem[346]:
		    /**/
		    (r_counter == 348)? mem[347]:
		    /**/
		    (r_counter == 349)? mem[348]:
		    /**/
		    (r_counter == 350)? mem[349]:
		    /**/
		    (r_counter == 351)? mem[350]:
		    /**/
		    (r_counter == 352)? mem[351]:
		    /**/
		    (r_counter == 353)? mem[352]:
		    /**/
		    (r_counter == 354)? mem[353]:
		    /**/
		    (r_counter == 355)? mem[354]:
		    /**/
		    (r_counter == 356)? mem[355]:
		    /**/
		    (r_counter == 357)? mem[356]:
		    /**/
		    (r_counter == 358)? mem[357]:
		    /**/
		    (r_counter == 359)? mem[358]:
		    /**/
		    (r_counter == 360)? mem[359]:
		    /**/
		    (r_counter == 361)? mem[360]:
		    /**/
		    (r_counter == 362)? mem[361]:
		    /**/
		    (r_counter == 363)? mem[362]:
		    /**/
		    (r_counter == 364)? mem[363]:
		    /**/
		    (r_counter == 365)? mem[364]:
		    /**/
		    (r_counter == 366)? mem[365]:
		    /**/
		    (r_counter == 367)? mem[366]:
		    /**/
		    (r_counter == 368)? mem[367]:
		    /**/
		    (r_counter == 369)? mem[368]:
		    /**/
		    (r_counter == 370)? mem[369]:
		    /**/
		    (r_counter == 371)? mem[370]:
		    /**/
		    (r_counter == 372)? mem[371]:
		    /**/
		    (r_counter == 373)? mem[372]:
		    /**/
		    (r_counter == 374)? mem[373]:
		    /**/
		    (r_counter == 375)? mem[374]:
		    /**/
		    (r_counter == 376)? mem[375]:
		    /**/
		    (r_counter == 377)? mem[376]:
		    /**/
		    (r_counter == 378)? mem[377]:
		    /**/
		    (r_counter == 379)? mem[378]:
		    /**/
		    (r_counter == 380)? mem[379]:
		    /**/
		    (r_counter == 381)? mem[380]:
		    /**/
		    (r_counter == 382)? mem[381]:
		    /**/
		    (r_counter == 383)? mem[382]:
		    /**/
		    (r_counter == 384)? mem[383]:
		    /**/
		    (r_counter == 385)? mem[384]:
		    /**/
		    (r_counter == 386)? mem[385]:
		    /**/
		    (r_counter == 387)? mem[386]:
		    /**/
		    (r_counter == 388)? mem[387]:
		    /**/
		    (r_counter == 389)? mem[388]:
		    /**/
		    (r_counter == 390)? mem[389]:
		    /**/
		    (r_counter == 391)? mem[390]:
		    /**/
		    (r_counter == 392)? mem[391]:
		    /**/
		    (r_counter == 393)? mem[392]:
		    /**/
		    (r_counter == 394)? mem[393]:
		    /**/
		    (r_counter == 395)? mem[394]:
		    /**/
		    (r_counter == 396)? mem[395]:
		    /**/
		    (r_counter == 397)? mem[396]:
		    /**/
		    (r_counter == 398)? mem[397]:
		    /**/
		    (r_counter == 399)? mem[398]:
		    /**/
		    (r_counter == 400)? mem[399]:
		    /**/
		    0;
   
   initial begin
      $readmemb("input.txt",mem,0,399);//input file data
      //$readmemb("array.txt",mem2,0,5);//input file data           
      initialize();
      t_reset();
   end
   ctrl  ctrl(
	      .i_data(i_data[15:0]),
	      .i_val(i_val),
	      .estimate(estimate[399:0]),
	      .o_val(o_val),
	      .clk(clk),
	      .xrst(xrst),
	      .r_loop(w_loop[6:0])
	      );

     always@(posedge clk) begin 
	if(o_val==1 || w_loop==100)
	  begin
	     mcd3=$fopen("estimate.txt","w");
	     @(posedge clk);
	     $fdisplay(mcd3,"%b",estimate);
	     @(posedge clk);
	     $stop;
	  end		 
     end // always@ (posedge clk)
   
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_counter<=0;
	else if (r_counter == 400)
	  r_counter<=0;
	else
	  r_counter<=r_counter+1;
     end

    task t_reset();
      begin
	 @(posedge clk);
	 xrst <= 'd0;
	 @(posedge clk);
	 xrst <= 'd1;
      end
   endtask // t_reset

   task initialize();
      begin
	 clk<=1;
	 i_val <= 1;
      end
   endtask // initialize
   
endmodule // test_test


  
   

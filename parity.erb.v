/* <%
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 text1=File.read('arrayestimate.txt')
 strs1=text1.split("\n")
 lines1 = strs1.map { |str| str.to_i}
 text2=File.read('arraylambda.txt')
 strs2=text2.split("\n")
 lines2 = strs2.map { |str| str.to_i}
 %>*/

module parity(/*AUTOARG*/
	    //Inputs
	    i_data,i_val,
	    //Outputs
	    o_data,o_val,clk,xrst,w_alpha,w_beta,roop
	    );

   assign parity=  /*<%for i in 0...COL_NUMBER-1%>*/
		   (
		    /*<%for j in 0...ROW_WEIGHT-1%>*/
		    estimate[<%=lines2[j+ROW_WEIGHT*i]%>]+
	            /*<%end%>*/
       		    estimate[<%=lines2[ROW_WEIGHT-1+ROW_WEIGHT*i]%>]) ==0) &&
		   /*<%end%>*
		    /*<%for j in 0...ROW_WEIGHT-1%>*/
		   estimate[<%=lines2[j+ROW_WEIGHT*(COL_NUMBER-1)]%>]+
		   /*<%end%>*/
		   estimate[<%=lines2[ROW_WEIGHT-1+ROW_WEIGHT*(COL_NUMBER-1)]%>]);
   /*<%for i in 0...ROW_NUMBER%>*/
   assign estimate[<%=ROW_NUMBER-1-i%>] = (
		      /*<%for j in 0...COL_WEIGHT%>*/	       
		      alpha[<%=lines1[j+(COL_WEIGHT+1)*i]%>]+
		      /*<%end%>*/
		      lambda[<%=lines1[i*(COL_WEIGHT+1)+2]%>])>0) ? 0:1;
   /*<%end%>*/
   
endmodule
				    
  
   

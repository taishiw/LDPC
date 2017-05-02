/* */

module parity(/*AUTOARG*/
	    //Inputs
	    i_data,i_val,
	    //Outputs
	    o_data,o_val,clk,xrst,w_alpha,w_beta,roop
	    );

   assign parity=(func_parity(estimate[5],estimate[4],estimate[3]) ==0) && (func_parity(estimate[0],estimate[1],estimate[2]) ==0) && (func_parity(estimate[5],estimate[4],estimate[1]) ==0) && (func_parity(estimate[3],estimate[2],estimate[0]) ==0);

   assign parity=  /**/
		   (
		    /**/
		    estimate[0]+
		    /**/
		    estimate[3]+
		    /**/
		    estimate[4])
		    ==0) &&
		   /**/
		   (
		    /**/
		    estimate[1]+
		    /**/
		    estimate[2]+
		    /**/
		    estimate[5])
		    ==0) &&
		   /**/
		   (
		    /**/
		    estimate[1]+
		    /**/
		    estimate[4]+
		    /**/
		    estimate[5])
		    ==0) &&
		   /**/
		   /**/
		   estimate[0]+
		   /**/
		   estimate[2]+
		   /**/
		   estimate[3]);
   /**/
   assign estimate[5] = (
			      /**/	       
			      alpha[0]+
			      /**/	       
			      alpha[9]+
			      /**/
			      lambda[0])>0) ? 0:1;
   /**/
   assign estimate[4] = (
			      /**/	       
			      alpha[3]+
			      /**/	       
			      alpha[6]+
			      /**/
			      lambda[1])>0) ? 0:1;
   /**/
   assign estimate[3] = (
			      /**/	       
			      alpha[4]+
			      /**/	       
			      alpha[10]+
			      /**/
			      lambda[2])>0) ? 0:1;
   /**/
   assign estimate[2] = (
			      /**/	       
			      alpha[1]+
			      /**/	       
			      alpha[11]+
			      /**/
			      lambda[3])>0) ? 0:1;
   /**/
   assign estimate[1] = (
			      /**/	       
			      alpha[2]+
			      /**/	       
			      alpha[7]+
			      /**/
			      lambda[4])>0) ? 0:1;
   /**/
   assign estimate[0] = (
			      /**/	       
			      alpha[5]+
			      /**/	       
			      alpha[8]+
			      /**/
			      lambda[5])>0) ? 0:1;
   /**/
			      
			      endmodule
				    
  
   

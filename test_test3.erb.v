/* <%
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 %>*/

module test_test();
   reg signed[<%=WIDTH-1%>:0] mem[0:<%=ROW_NUMBER-1%>];      //lambda data 
   wire 		 o_val;         //control signal
   reg 			 i_val;
   reg 			 clk;           //System clock 
   reg 			 xrst;          //reset signal 		    
   wire [<%=ROW_NUMBER-1%>:0] estimate;
   wire [<%=WIDTH*ROW_NUMBER-1%>:0] 	 i_data; 
   wire [6:0] 		 roop;
   wire [<%=WIDTH*ROW_WEIGHT*COL_NUMBER-1%>:0] w_alpha,w_beta;
   wire [<%=WIDTH-1%>:0] w_alpha_write [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0];
   wire [<%=WIDTH-1%>:0] w_beta_write [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0]; 
   parameter zClk = 20;            //clock time
   integer 		 mcd1,mcd2,mcd3;
   integer 		 i;	 
   parameter roop_max=100;
   //clock reversal
   always #(zClk/2) clk <= ~clk;
   /*<%0.upto(ROW_NUMBER-1) do |i| %>*/
   assign i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=mem[<%=i%>];
   /*<%end%>*/
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_alpha_write[<%=i%>]=w_alpha[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/
    /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_beta_write[<%=i%>]=w_beta[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/
   
   
   
   initial begin
      $readmemb("input.txt",mem,0,<%=ROW_NUMBER-1%>);//input file data
      //$readmemb("array.txt",mem2,0,5);//input file data           
      initialize();
      t_reset();
   end
   ctrl  ctrl(
	      .i_data(i_data[<%=WIDTH*ROW_NUMBER-1%>:0]),
	      .i_val(i_val),
	      .estimate(estimate[<%=ROW_NUMBER-1%>:0]),
	      .o_val(o_val),
	      .clk(clk),
	      .xrst(xrst),
	      .o_alpha(w_alpha),
	      .o_beta(w_beta),
	      .roop(roop)
	      );

     always@(posedge clk) begin 
	if(o_val==1 || roop==roop_max)
	  begin
	     mcd1=$fopen("outputalpha.txt","w");
	     mcd2=$fopen("outputbeta.txt","w");
	     mcd3=$fopen("estimate.txt","w");
	     @(posedge clk);
	     for (i=0;i<<%=ROW_WEIGHT*COL_NUMBER%>;i=i+1)begin
		$fdisplay(mcd1,"%b",w_alpha_write[i]);
		$fdisplay(mcd2,"%b",w_beta_write[i]);
	     end
	     $fdisplay(mcd3,"%b",estimate);
	     @(posedge clk);
	     $stop;
	  end		 
     end // always@ (posedge clk)*/

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


  
   

/* <%
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 LOOP_MAX=ENV['LOOP_MAX'].to_i;
 %>*/

module test_test();
   reg signed[<%=WIDTH-1%>:0] mem[0:<%=ROW_NUMBER-1%>];      //lambda data 
   wire 		 o_val;         //control signal
   reg 			 i_val;
   reg 			 clk;           //System clock 
   reg 			 xrst;          //reset signal 	
   reg [9:0] 		 r_counter; 	    
   wire [<%=ROW_NUMBER-1%>:0] estimate;
   wire [<%=WIDTH-1%>:0] 	 i_data; 
   wire [6:0] 		 w_loop;
   parameter zClk = 20;            //clock time
   integer 		 mcd3;
   integer 		 i;	 
   //clock reversal
   always #(zClk/2) clk <= ~clk;
   
   assign i_data[<%=WIDTH-1%>:0]=
		    /*<%0.upto(ROW_NUMBER-1) do |i| %>*/
		    (r_counter == <%=i+1%>)? mem[<%=i%>]:
		    /*<%end%>*/
		    0;
   
   initial begin
      $readmemb("input.txt",mem,0,<%=ROW_NUMBER-1%>);//input file data
      //$readmemb("array.txt",mem2,0,5);//input file data           
      initialize();
      t_reset();
   end
   ctrl  ctrl(
	      .i_data(i_data[<%=WIDTH-1%>:0]),
	      .i_val(i_val),
	      .estimate(estimate[<%=ROW_NUMBER-1%>:0]),
	      .o_val(o_val),
	      .clk(clk),
	      .xrst(xrst),
	      .r_loop(w_loop[6:0])
	      );

     always@(posedge clk) begin 
	if(o_val==1 || w_loop==<%=LOOP_MAX%>)
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
	else if (r_counter == <%=ROW_NUMBER%>)
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


  
   

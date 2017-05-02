/* <%
 require 'csv'
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 text1=File.read('arrayrow.txt')
 strs=text1.split("\n")
 lines = strs.map { |str| str.to_i}
 text2=File.read('arraycolumn.txt')
 strs2=text2.split("\n")
 lines2=strs2.map { |str| str.to_i}
 text3=File.read('arraylambda.txt')
 strs3=text3.split("\n")
 lines3=strs3.map { |str| str.to_i}
  %>*/

module ctrl(/*AUTOARG*/
	    //Inputs
	    i_data,i_val,
	    //Outputs
	    o_data,o_val,clk,xrst,w_alpha,w_beta,roop
	    );
   input [<%=WIDTH*ROW_NUMBER-1 %>:0] i_data;
   input 	     i_val;
   output [<%=ROW_NUMBER-1 %>:0] o_data;
   output 		   o_val;
   input 		   clk;
   input 		   xrst;
   output [<%=WIDTH*ROW_WEIGHT*COL_NUMBER-1%>:0]    w_alpha,w_beta;
   output reg [6:0] 	      roop;
   parameter zStateInit=0;
   parameter zStateData=1;
   parameter zStateRow=2;
   parameter zStateColumn=3;
   reg [2:0] r_state;
   reg [<%=WIDTH-1%>:0] r_alpha [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0];
   reg [<%=WIDTH-1%>:0] r_beta [<%=ROW_NUMBER*COL_WEIGHT-1 %>:0];
   wire [<%=WIDTH-1%>:0] w_lambda [<%=ROW_NUMBER-1%>:0];
   reg [100:0]		   r_counter;
   reg [2:0] 		   i_init_row;
   reg [2:0] 		   i_init_column;

   wire 		   parity;
   wire [<%=ROW_NUMBER-1%>:0] estimate;
   wire [<%=WIDTH-1%>:0] 	   w_i_data_row,w_i_data_column;
   reg 			   r_i_val_row,r_i_val_column;
   wire 		   w_o_val_row,w_o_val_column;
   wire [<%=WIDTH-1%>:0] 	   w_o_data_column,w_o_data_row;
   wire 		   w_trans_data,w_trans_row,w_trans_column;
   wire [<%=WIDTH-1%>:0] 	   w_lambda_beta[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];

   //sram関係
   wire 			   i_wen;
   wire [7:0] 			   i_waddr,i_raddr;
   wire [<%=WIDTH-1%>:0] 	   i_wdata;
   wire [<%=WIDTH-1%>:0] 	   o_rdata;
   
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_alpha[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_alpha[<%=i%>];
   /*<%end%>*/
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_beta[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_beta[<%=i%>];
   /*<%end%>*/
   assign w_trans_data = (r_state==zStateInit & i_val);
   assign w_trans_row = (r_state==zStateData & r_counter == <%=ROW_NUMBER-1%>);
   assign w_trans_column = (r_state == zStateRow) & (r_counter == <%=(ROW_WEIGHT-1)*ROW_WEIGHT*COL_NUMBER+2%>) & w_o_val_row;

   assign w_i_data_row =	
			/*<%for i in 0...(ROW_WEIGHT-1)*ROW_WEIGHT*COL_NUMBER%>*/
			(r_counter == <%=i%>) ? r_beta[<%=lines[i] %>]:
			/*<%end%>*/
			0;
   assign w_i_data_column =
			   /*<%for i in 0...COL_WEIGHT*COL_WEIGHT*ROW_NUMBER%>*/
			   /*<% if (i+1) % COL_WEIGHT == 0 then %>*/ 
			   (r_counter == <%=i%> ) ? w_lambda[<%=lines3[i/COL_WEIGHT]%>]:
			   /*<%else%>*/
			   (r_counter == <%=i%> ) ? r_alpha[<%=lines2[i]%>]:
				       /*<%end%>*/
				       /*<%end%>*/
			   0;
			    
   /*<%0.upto(ROW_NUMBER-1) do |i| %>*/
   assign w_lambda[<%=i%>]=i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER%>*/
   assign w_lambda_beta[<%=i%>]=w_lambda[<%=lines3[i]%>];
   /*<%end%>*/

   //sram関係
   assign i_wen=(!xrst) ? 1:0;
   assign i_waddr=r_counter;
   assign i_wdata=/*<%for i in 0...ROW_NUMBER%>*/
		  (r_counter==<%=i%>) ? i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]:
		  /*<%end%>*/
		  0;
  
//状態遷移
   always @(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_state <= zStateInit;
	else if (w_trans_data)
	  r_state <= zStateData;
	else if(w_trans_row | ((r_state==zStateColumn) & (r_counter == <%=COL_WEIGHT*COL_WEIGHT*ROW_NUMBER+2%>) & w_o_val_column))
	  r_state <= zStateRow;
	else if(w_trans_column)
	  r_state <= zStateColumn;
	else
	  r_state <= r_state;
     end // always (posedge clk or negedge xrst)
   //ベータの更新式
   /*<%0.upto(ROW_WEIGHT*COL_NUMBER-1) do |i| %>*/
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_beta[<%=i%>] <= 0;
	else if (w_trans_row) 
	  r_beta[<%=i%>] <= w_lambda_beta[<%=i%>];
	else if ((r_state == zStateColumn) & (w_o_val_column) & (r_counter == (<%=COL_WEIGHT*i + COL_WEIGHT%>)))  
	  r_beta[<%=i%>] <= w_o_data_column;
	else
	  r_beta[<%=i%>] <= r_beta[<%=i%>];
     end // always (posedge clk or negedge xrst)
   /*<%end%>*/
    

   //アルファの更新式 
   /*<%0.upto(COL_WEIGHT*ROW_NUMBER-1) do |i| %>*/
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_alpha[<%=i%>] <= 0;
	else if ((r_state == zStateRow) & (w_o_val_row) & (r_counter == (<%=(ROW_WEIGHT-1) * i + ROW_WEIGHT - 1%>)))
	  r_alpha[<%=i%>] <= w_o_data_row;
	else
	  r_alpha[<%=i%>] <= r_alpha[<%=i%>];
     end
   /*<%end%>*/
  
   
   //行処理の動作フラグ
   always@(posedge clk or negedge xrst)
     begin
	if (!xrst)
	  r_i_val_row <= 0;
	else if (r_i_val_row)
	  r_i_val_row <= 0;
	else if (w_trans_row)
	  r_i_val_row <= 1;
	else if (r_state == zStateRow & w_o_val_row)
	  r_i_val_row <= 1;
	else
	  r_i_val_row <= r_i_val_row;
     end // always (posedge clk or negedge xrst)
   //カウンタ
   always@(posedge clk or negedge xrst)
     begin
	if (!xrst)
	  r_counter <= 0;
	else if (r_state == zStateData)
	  r_counter <= r_counter+1;
	else if (r_state == zStateRow & w_o_val_row)
	  begin
	     if (r_counter == <%=(ROW_WEIGHT-1)*ROW_WEIGHT*COL_NUMBER+2%>)
	       r_counter <= 0;
	     else
	       r_counter <= r_counter + 1;
	  end
	else if (r_state == zStateColumn & w_o_val_column)
	  begin
	     if (r_counter == <%=COL_WEIGHT*COL_WEIGHT*ROW_NUMBER+2%>)
	       r_counter <=0;
	     else
	       r_counter <= r_counter + 1;
	  end
	else
	  r_counter <= r_counter;
     end // always@ (posedge clk or negedge xrst)

   //行処理の値の初期化
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  i_init_row <= 0;
	else if (i_init_row == <%=ROW_WEIGHT-2%>)
	  i_init_row <=0;
	else
	  i_init_row <= i_init_row+1;
     end

   //列処理の値の初期化
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  i_init_column <= 0;
	else if (i_init_column == <%=COL_WEIGHT-1%>)
	  i_init_column <=0;
	else
	  i_init_column <= i_init_column+1;
     end
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  roop <= 0;
	else if (w_trans_column)
	  roop <=roop+1;
	else
	  roop <= roop;
     end

   row row(
	   .i_data (w_i_data_row[<%=WIDTH-1%>:0]),
	   .i_val (i_val),
	   .o_data (w_o_data_row[<%=WIDTH-1%>:0]),
	   .o_val (w_o_val_row),
	   .clk (clk),
	   .xrst (xrst),
	   .i_init (i_init_row [2:0])
	   );
   
   add add(
	   .i_data (w_i_data_column[<%=WIDTH-1%>:0]),
	   .i_val (i_val),
	   .o_data (w_o_data_column[<%=WIDTH-1%>:0]),
	   .o_val (w_o_val_column),
	   .clk (clk),
	   .xrst (xrst),
	   .i_init (i_init_column[2:0])
	   );
   
   sram sram(
	     .clk(clk),
	     .i_wen(i_wen),
	     .i_waddr(i_waddr[7:0]),
	     .i_raddr(i_raddr[7:0]),
	     .o_rdata(o_rdata[<%=WIDTH-1%>:0])
	     );
   
	     
endmodule
   
	   
   
   
   

   

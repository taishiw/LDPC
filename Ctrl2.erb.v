/* <%
 #環境変数として取り込む
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 
 #処理順番情報をテキストから取得
 text1=File.read('arrayrow.txt')
 strs=text1.split("\n")
 lines = strs.map { |str| str.to_i}
 text2=File.read('arraycolumn.txt')
 strs2=text2.split("\n")
 lines2=strs2.map { |str| str.to_i}
 text3=File.read('arraylambda.txt')
 strs3=text3.split("\n")
 lines3=strs3.map { |str| str.to_i}
 text4=File.read('arrayestimate.txt')
 strs4=text4.split("\n")
 lines4 = strs4.map { |str| str.to_i}
  %>*/

module ctrl(/*AUTOARG*/
	    i_data,
	    i_val,
	    estimate,
	    o_val,
	    clk,
	    xrst,
	    o_alpha,
	    o_beta,
	    r_loop,
	    i_wen_alpha,
	    i_raddr_alpha,
	    i_waddr_alpha,
	    o_rdata_alpha,
	    i_wen_beta,
	    i_raddr_beta,
	    i_waddr_beta,
	    o_rdata_beta
	    );
   input [<%=WIDTH*ROW_NUMBER-1 %>:0] i_data;//雑音の付加されたデータ
   input 	     i_val;//入力のvalid信号
   output [<%=ROW_NUMBER-1%>:0] estimate;//推定結果
   output 		   o_val;//出力のvalid信号
   input 		   clk;//クロック信号
   input 		   xrst;//リセット信号
   output [<%=WIDTH*ROW_WEIGHT*COL_NUMBER-1%>:0]    o_alpha,o_beta;//出力用のα，β
   output reg [6:0] 				    r_loop;//繰り返し回数レジスタ
   //RAMへの入力信号
   input 					    i_wen_alpha,i_wen_beta;
   input [7:0] 					    i_raddr_alpha,i_raddr_beta;
   input [7:0] 					    i_waddr_alpha,i_waddr_beta;
   input [<%=WIDTH-1%>:0] 			    i_wdata_alpha,i_wdata_beta;
   input [<%=WIDTH-1%>:0] 			    i_rdata_alpha,i_rdata_beta;
   output [<%=WIDTH-1%>:0] 			    o_rdata_alpha,o_rdata_beta;
   //ステート情報
   parameter zStateInit=0;
   parameter zStateRow=1;
   parameter zStateColumn=2;
   
   reg [2:0] r_state;//ステートレジスタ

   reg [5:0] alpha_counter,beta_counter;
   reg signed [<%=WIDTH-1%>:0]  r_alpha [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0];//αレジスタ
   reg signed [<%=WIDTH-1%>:0] 	r_beta [<%=ROW_NUMBER*COL_WEIGHT-1 %>:0];//βレジスタ
   wire signed [<%=WIDTH-1%>:0] w_lambda [<%=ROW_NUMBER-1%>:0];//λワイア
   
   reg [100:0] 			 r_counter;// カウンタ
   
   reg [2:0] 			 i_init_row;//行処理の初期化信号
   reg [2:0] 			 i_init_column;//列処理の初期化信号
   
   wire 			 parity;//パリティビット
 			 
   wire [<%=WIDTH-1%>:0]   w_i_data_row,w_i_data_column;//行処理，列処理それぞれの入力信号
   wire [<%=WIDTH-1%>:0]   w_o_data_column,w_o_data_row;//行処理，列処理の出力信号
   reg 			   r_i_val_row,r_i_val_column;//行処理，列処理の入力のvalid信号
   wire 		   w_o_val_row,w_o_val_column;//行処理，列処理の出力のvalid信号
   wire 		   w_trans_row,w_trans_column;//行処理，列処理の状態遷移
   wire [<%=WIDTH-1%>:0] 	   w_lambda_beta[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];//βの初期値設定用信号
  

   //αを出力用に1列にする
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign o_alpha[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_alpha[<%=i%>];
   /*<%end%>*/

   //βを出力用に1列にする
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign o_beta[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_beta[<%=i%>];
   /*<%end%>*/

   //ステートが初期値のときvalid信号をうけたら，行処理にステートを移す
   assign w_trans_row = (r_state==zStateInit & i_val);

   //ステートが行処理かつカウンタが行処理の最後の処理かつ行処理の出力valid信号が１のときステートを列処理に移す
   assign w_trans_column = (r_state == zStateRow) & (r_counter == <%=(ROW_WEIGHT-1)*ROW_WEIGHT*COL_NUMBER+2%>) & w_o_val_row;

   //カウンタにあわせてβを行処理モジュールに入れる
   assign w_i_data_row =	
			/*<%for i in 0...(ROW_WEIGHT-1)*ROW_WEIGHT*COL_NUMBER%>*/
			(r_counter == <%=i%>) ? r_beta[<%=lines[i]%>]:
			/*<%end%>*/
			0;

   //カウンタにあわせてαまたはλを列処理に入れる
   assign w_i_data_column =
			   /*<%for i in 0...COL_WEIGHT*COL_WEIGHT*ROW_NUMBER%>*/
			   /*<% if (i+1) % COL_WEIGHT == 0 then %>*/ 
			   (r_counter == <%=i%> ) ? w_lambda[<%=lines3[i/COL_WEIGHT]%>]:
			   /*<%else%>*/
			   (r_counter == <%=i%> ) ? r_alpha[<%=lines2[i]%>]:
				       /*<%end%>*/
				       /*<%end%>*/
			   0;

   //入力データからλをつくる
   /*<%0.upto(ROW_NUMBER-1) do |i| %>*/
   assign w_lambda[<%=i%>]=i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/

   //βの初期化
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER%>*/
   assign w_lambda_beta[<%=i%>]=w_lambda[<%=lines3[i]%>];
   /*<%end%>*/

   /*パリティビットを計算
    行を取り出し，検査行列を1が立っている列の推定結果の和を
    だして，すべての列の積をとる
    */ 
   assign parity=  /*<%for i in 0...COL_NUMBER-1%>*/
		   ((
		     /*<%for j in 0...ROW_WEIGHT-1%>*/
		     estimate[<%=lines3[j+ROW_WEIGHT*i]%>]+
	             /*<%end%>*/
       		     estimate[<%=lines3[ROW_WEIGHT-1+ROW_WEIGHT*i]%>]) ==0) &&
		   /*<%end%>*/
		   ((
		     /*<%for j in 0...ROW_WEIGHT-1%>*/
		     estimate[<%=lines3[j+ROW_WEIGHT*(COL_NUMBER-1)]%>]+
		     /*<%end%>*/
		     estimate[<%=lines3[ROW_WEIGHT-1+ROW_WEIGHT*(COL_NUMBER-1)]%>]) ==0);

   /*    推定結果を計算
    列を取り出し，検査行列で1が立っている行のαとその列のλの和をとり，
    0より大きければ0，小さければ1とする
        */
   /*<%for i in 0...ROW_NUMBER%>*/
   assign estimate[<%=ROW_NUMBER-1-i%>] = ((
		      /*<%for j in 0...COL_WEIGHT%>*/	       
		      r_alpha[<%=lines4[j+(COL_WEIGHT+1)*i]%>]+
		      /*<%end%>*/
		      w_lambda[<%=lines4[i*(COL_WEIGHT+1)+2]%>])>0) ? 0:1;
   /*<%end%>*/

   //行処理が終わった時にパリティビットが1であれば出力valid信号を1とする
   assign o_val = ( (r_state==zStateColumn) & (r_counter == 2) & (parity==1) ) ? 1:0;
 
//状態遷移
   always @(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_state <= zStateInit;
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

   //ベータのカウンタ
   /*<%0.upto(ROW_WEIGHT*COL_NUMBER-1) do |i| %>*/
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  beta_counter <= 0;
	else if ((r_state == zStateColumn) & (w_o_val_column) & (r_counter == (<%=COL_WEIGHT*i + COL_WEIGHT%>)))  
	  beta_counter <= beta_counter+1;
	else
	  beta_counter <= beta_counter;
     end // always (posedge clk or negedge xrst)
   /*<%end%>*/
    

   //アルファのカウンタ
   /*<%0.upto(COL_WEIGHT*ROW_NUMBER-1) do |i| %>*/
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  alpha_counter <= 0;
	else if ((r_state == zStateRow) & (w_o_val_row) & (r_counter == (<%=(ROW_WEIGHT-1) * i + ROW_WEIGHT - 1%>)))
	  alpha_counter <= alpha_counter+1;
	else
	  alpha_counter <= alpha_counter;
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

   //繰り返し回数の更新
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_loop <= 0;
	else if (w_trans_column)
	  r_loop <=r_loop+1;
	else
	  r_loop <= r_loop;
     end

   //アドレス関係
   //SRAM_α
   assign i_wen_alpha = /*<%for i in 0...COL_WEIGHT*ROW_NUMBER%>*/
			((r_state == zStateColumn) & (w_o_val_column) & (r_counter == (<%=COL_WEIGHT*i + COL_WEIGHT%>)))  ? 1:
		  /*<%end%>*/
		  0;
   assign i_raddr_alpha =r_counter;
   assign i_waddr_alpha =beta_counter;
   assign i_wdata_alpha = w_o_data_column;
   
   //SRAM-β
   assign i_wen_beta = /*<%for i in 0...COL_WEIGHT*ROW_NUMBER%>*/
		  ((r_state == zStateRow) & (w_o_val_row) & (r_counter == (<%=(ROW_WEIGHT-1) * i + ROW_WEIGHT - 1%>))) ? 1:
		  /*<%end%>*/
		  0;
   assign i_raddr_beta =r_counter;
   assign i_waddr_beta =alpha_counter;
   assign i_wdata_beta = w_o_data_row;


   
   
		   
		  

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
endmodule // ctrl

// Local Variables:
// mode: verilog
// coding: utf-8
// indent-tabs-mode: nil
// verilog-indent-level-module: 2
// verilog-indent-level: 2
// verilog-indent-level-behavioral: 2
// verilog-indent-level-declaration: 2
// End:
   
	   
   
   
   

   

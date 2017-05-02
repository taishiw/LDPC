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
	    //Inputs
	    i_data,i_val,
	    //Outputs
	    estimate,o_val,clk,xrst,o_alpha,o_beta,r_loop
	    );
   input [<%=WIDTH*ROW_NUMBER-1 %>:0] i_data;//雑音の付加されたデータ
   input 	     i_val;//入力のvalid信号
   output [<%=ROW_NUMBER-1%>:0] estimate;//推定結果
   output 		   o_val;//出力のvalid信号
   input 		   clk;//クロック信号
   input 		   xrst;//リセット信号
   output [<%=WIDTH*ROW_WEIGHT*COL_NUMBER-1%>:0]    o_alpha,o_beta;//出力用のα，β
   output reg [6:0] 	      r_loop;//繰り返し回数レジスタ
   //ステート情報
   parameter zStateInit=0;
   parameter zStateLambdaInit=1;
   parameter zStateBetaInit=2;
   parameter zStateRow=3;
   parameter zStateColumn=4;
   
   reg [2:0] r_state;//ステートレジスタ
   
   reg signed [<%=WIDTH-1%>:0]  r_alpha [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0];//αレジスタ
   reg signed [<%=WIDTH-1%>:0] 	r_beta [<%=ROW_NUMBER*COL_WEIGHT-1 %>:0];//βレジスタ
   wire signed [<%=WIDTH-1%>:0] w_lambda [<%=ROW_NUMBER-1%>:0];//λワイア
   
   reg [30:0] 			 r_counter;// カウンタ
   reg [10:0] 			 alpha_counter,beta_counter;
   
   reg [2:0] 			 i_init_row;//行処理の初期化信号
   reg [2:0] 			 i_init_column;//列処理の初期化信号
   
   wire 			 parity;//パリティビット
   
   wire [<%=WIDTH-1%>:0]   w_i_data_row,w_i_data_column;//行処理，列処理それぞれの入力信号
   wire [<%=WIDTH-1%>:0]   w_o_data_column,w_o_data_row;//行処理，列処理の出力信号
   reg 			   r_i_val_row,r_i_val_column;//行処理，列処理の入力のvalid信号
   wire 		   w_o_val_row,w_o_val_column;//行処理，列処理の出力のvalid信号
   wire 		   w_trans_row,w_trans_column,w_trans_lambdainit,w_trans_betainit;//行処理，列処理の状態遷移
   wire [<%=WIDTH-1%>:0] 	   w_lambda_beta[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];//βの初期値設定用信号
   wire [<%=WIDTH-1%>:0] 	   o_data_test_alpha,o_data_test_beta;
   wire [<%=WIDTH-1%>:0] 	   o_column_data;
   
   
   //sram関係
   
   //lambda
   wire 			   i_wen_lambda;
   wire [7:0] 			   i_waddr_lambda,i_raddr_lambda;
   wire [<%=WIDTH-1%>:0] 	   i_wdata_lambda;
   wire [<%=WIDTH-1%>:0] 	   o_rdata_lambda;

   //alpha
   wire 			   i_wen_alpha;
   wire [7:0] 			   i_waddr_alpha,i_raddr_alpha;
   wire [<%=WIDTH-1%>:0] 	   i_wdata_alpha;
   wire [<%=WIDTH-1%>:0] 	   o_rdata_alpha;

   //beta
   wire 			   i_wen_beta;
   wire [7:0] 			   i_waddr_beta,i_raddr_beta;
   wire [<%=WIDTH-1%>:0] 	   i_wdata_beta;
   wire [<%=WIDTH-1%>:0] 	   o_rdata_beta;
   
   
   //αを出力用に1列にする
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign o_alpha[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_alpha[<%=i%>];
   /*<%end%>*/

   //βを出力用に1列にする
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign o_beta[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=r_beta[<%=i%>];
   /*<%end%>*/

   assign w_trans_lambdainit = (r_state==zStateInit & i_val);

   assign w_trans_betainit = (r_state == zStateLambdaInit) & (r_counter == <%=ROW_NUMBER-1%>);
   //ステートが初期値のときvalid信号をうけたら，行処理にステートを移す
   assign w_trans_row = (r_state==zStateBetaInit & r_counter==<%=ROW_WEIGHT*COL_NUMBER%>);

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
   
   //sram関係

   //lambda
   assign i_wen_lambda=(r_state==zStateLambdaInit) ? 1:0;
   assign i_waddr_lambda=r_counter;
   assign i_raddr_lambda=/*<%for i in 0...ROW_WEIGHT*COL_NUMBER%>*/
			 (r_state == zStateBetaInit) & (r_counter == <%=i%>) ? <%=lines3[i]%>:
			 /*<%end%>*/
			 /*<%for i in 0...COL_WEIGHT*COL_WEIGHT*ROW_NUMBER%>*/
			 /*<% if (i+1) % COL_WEIGHT == 0 then %>*/ 
			 (r_state == zStateColumn) & (r_counter == <%=i%>) ? <%=lines3[i/COL_WEIGHT]%>:
			 /*<%end%>*/
			 /*<%end%>*/
			 0;
   assign i_wdata_lambda=/*<%for i in 0...ROW_NUMBER%>*/
		  (r_counter==<%=i%>) ? i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]:
		  /*<%end%>*/
		  0;
   //alpha
   assign i_wen_alpha=(r_state==zStateRow) & (
					      /*<%for i in 0...ROW_WEIGHT*COL_NUMBER-1%>*/
					      (r_counter == (<%=(ROW_WEIGHT-1) * i + ROW_WEIGHT%>)) |
					      /*<%end%>*/
					      (r_counter == (<%=(ROW_WEIGHT-1) * (ROW_WEIGHT*COL_NUMBER-1) + ROW_WEIGHT%>)));
   assign i_waddr_alpha=
			/*<%for i in 0...ROW_WEIGHT*COL_NUMBER+1%>*/
			(r_counter == (<%=(ROW_WEIGHT-1) * i + ROW_WEIGHT%>)) ? <%=i%>:
			/*<%end%>*/
			0;
   
   assign i_raddr_alpha=/*<%for i in 0...(COL_WEIGHT)*COL_WEIGHT*ROW_NUMBER%>*/
			(r_counter == <%=i%>) ? <%=lines2[i]%>:
			/*<%end%>*/
			0;
   assign i_wdata_alpha=o_data_test_alpha;
   
   
   //beta
   assign i_wen_beta=(r_state==zStateBetaInit) | ((r_state==zStateColumn) & (
									     /*<%for i in 0...ROW_WEIGHT*COL_NUMBER-1%>*/
									     (r_counter==<%=COL_WEIGHT*i +COL_WEIGHT+1%>) |
									     /*<%end%>*/
									     (r_counter==<%=COL_WEIGHT*(ROW_WEIGHT*COL_NUMBER-1)+COL_WEIGHT+1%>)));
   
   assign i_waddr_beta=(r_state == zStateBetaInit) ? r_counter-1:
		       /*<%for i in 0...ROW_WEIGHT*COL_NUMBER%>*/
		       (r_state == zStateColumn) & (r_counter == <%=COL_WEIGHT*i+COL_WEIGHT+1%>) ? <%=i%>:
		       /*<%end%>*/
		       0;
   assign i_raddr_beta=/*<%for i in 0...ROW_WEIGHT*(ROW_WEIGHT-1)*COL_NUMBER%>*/
		       (r_counter == <%=i%>) ? <%=lines[i]%>:
		       /*<%end%>*/
		       0;
   assign i_wdata_beta=(r_state == zStateBetaInit) ? o_rdata_lambda:
		       (r_state == zStateColumn) ? o_data_test_beta:
		       0;

   assign o_column_data = 
			  /*<%for i in 0...COL_WEIGHT*COL_WEIGHT*ROW_NUMBER%>*/
			  /*<% if (i+1) % COL_WEIGHT == 0 then %>*/ 
			  (r_state == zStateColumn) & (r_counter == <%=i+1%>) ? o_rdata_lambda:
			  /*<%else%>*/
			  (r_state == zStateColumn) &(r_counter == <%=i+1%> ) ? o_rdata_alpha:
				    /*<%end%>*/
				    /*<%end%>*/
				    0;
   
   
   
   //状態遷移
   always @(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  r_state <= zStateInit;
	else if (w_trans_lambdainit)
	  r_state <= zStateLambdaInit;
	else if (w_trans_betainit)
	  r_state <= zStateBetaInit;
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
	else if (r_state == zStateLambdaInit)
	  begin
	     if(r_counter == <%=ROW_NUMBER-1%>)
	       r_counter <= 0;
	     else
	       r_counter <= r_counter+1;
	  end
	else if (r_state == zStateBetaInit)
	  begin
	     if(r_counter == <%=ROW_WEIGHT*COL_NUMBER%>)
	       r_counter <= 0;
	     else
	       r_counter <= r_counter + 1;
	  end
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
	else if (i_init_row == <%=ROW_WEIGHT-2%> | w_trans_row==1)
	  i_init_row <=0;
	else
	  i_init_row <= i_init_row+1;
     end

   //列処理の値の初期化
   always@(posedge clk or negedge xrst)
     begin
	if(!xrst)
	  i_init_column <= 0;
	else if (i_init_column == <%=COL_WEIGHT-1%> | w_trans_column==1)
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

  row row2(
	   .i_data (o_rdata_beta[<%=WIDTH-1%>:0]),
	   .i_val (i_val),
	   .o_data (o_data_test_alpha[<%=WIDTH-1%>:0]),
	   .o_val (w_o_val_row),
	   .clk (clk),
	   .xrst (xrst),
	   .i_init (i_init_row [2:0])
	   );
   add add2(
	   .i_data (o_column_data[<%=WIDTH-1%>:0]),
	   .i_val (i_val),
	   .o_data (o_data_test_beta[<%=WIDTH-1%>:0]),
	   .o_val (w_o_val_column),
	   .clk (clk),
	   .xrst (xrst),
	   .i_init (i_init_column[2:0])
	   );

   

   sram sramlambda(
	     .clk(clk),
	     .i_wen(i_wen_lambda),
	     .i_waddr(i_waddr_lambda[7:0]),
	     .i_raddr(i_raddr_lambda[7:0]),
	     .i_wdata(i_wdata_lambda[<%=WIDTH-1%>:0]),
	     .o_rdata(o_rdata_lambda[<%=WIDTH-1%>:0])
	     );
   sram sramalpha(
	     .clk(clk),
	     .i_wen(i_wen_alpha),
	     .i_waddr(i_waddr_alpha[7:0]),
	     .i_raddr(i_raddr_alpha[7:0]),
	     .i_wdata(i_wdata_alpha[<%=WIDTH-1%>:0]),
	     .o_rdata(o_rdata_alpha[<%=WIDTH-1%>:0])
	     );
   sram srambeta(
	     .clk(clk),
	     .i_wen(i_wen_beta),
	     .i_waddr(i_waddr_beta[7:0]),
	     .i_raddr(i_raddr_beta[7:0]),
	     .i_wdata(i_wdata_beta[<%=WIDTH-1%>:0]),
	     .o_rdata(o_rdata_beta[<%=WIDTH-1%>:0])
	     );
   
   
   
endmodule
   
	   
   
   
   

   

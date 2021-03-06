/* <%
 #環境変数として取り込む
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 LOOP_MAX=ENV['LOOP_MAX'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 %>*/

module test_test();
   reg signed[<%=WIDTH-1%>:0] mem[0:<%=ROW_NUMBER-1%>];//メモリー 
   wire 		      o_val;//出力制御信号
   reg 			      i_val;//入力制御信号
   reg 			 clk;           //クロック 
   reg 			 xrst;          //リセット信号 		    
   wire [<%=ROW_NUMBER-1%>:0] estimate;//推定結果
   wire [<%=WIDTH*ROW_NUMBER-1%>:0] 	 i_data;//入力信号 
   wire [6:0] 		 w_loop;//繰り返し回数
   wire [<%=WIDTH*ROW_WEIGHT*COL_NUMBER-1%>:0] w_alpha,w_beta;//ワイアα,β
   wire [<%=WIDTH-1%>:0] w_alpha_write [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0];//書き込み用α
   wire [<%=WIDTH-1%>:0] w_beta_write [<%=ROW_WEIGHT*COL_NUMBER-1 %>:0]; //書き込み用β
   
   //メモリ関係
   wire 		 i_wen_alpha,i_wen_beta;//write_enable信号
   wire [7:0] 		 i_waddr_alpha, i_raddr_alpha;//書き込みアドレス，読み込みアドレス
   wire [7:0] 		 i_waddr_beta, i_raddr_beta;//書き込みアドレス，読み込みアドレス 
   wire [<%=WIDTH-1%>:0] i_wdata_alpha,i_wdata_beta;//書き込みデータ
   reg [<%=WIDTH-1%>:0]  o_rdata_alpha,o_rdata_beta;//読み込みデータ
   reg [<%=WIDTH-1%>:0]           mem_alpha[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];//メモリ
   reg [<%=WIDTH-1%>:0] 	  mem_beta[<%=COL_WEIGHT*ROW_NUMBER-1%>:0]; 	  
   parameter zClk = 20;            //クロックタイム
   integer 		 mcd1,mcd2,mcd3;//ファイル書き込み用
   integer 		 i;	 
   //clock reversal
   always #(zClk/2) clk <= ~clk;

   //入力データ書き込み
   /*<%0.upto(ROW_NUMBER-1) do |i| %>*/
   assign i_data[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>]=mem[<%=i%>];
   /*<%end%>*/

   //書き込み用データ生成
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_alpha_write[<%=i%>]=w_alpha[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/

   //書き込み用データ生成
   /*<%for i in 0...ROW_WEIGHT*COL_NUMBER %>*/
   assign w_beta_write[<%=i%>]=w_beta[<%=WIDTH*i+WIDTH-1%>:<%=WIDTH*i%>];
   /*<%end%>*/
   
   always@(posedge clk)
     if (i_wen_alpha) mem[i_waddr_alpha] <= i_wdata_alpha;
   
   always@(posedge clk)
     if (!i_wen_alpha) o_rdata_alpha <= mem_alpha[i_raddr_alpha];

    always@(posedge clk)
     if (i_wen_beta) mem[i_waddr_beta] <= i_wdata_beta;
   
   always@(posedge clk)
     if (!i_wen_beta) o_rdata_beta <= mem_beta[i_raddr_beta];
   
   
   
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
	      .r_loop(w_loop),
	      .i_wen_alpha(i_wen_alpha),
	      .i_raddr_alpha(i_raddr_alpha[7:0]),
	      .i_waddr_alpha(i_waddr_alpha[7:0]),
	      .i_rdata_alpha(i_wdata_alpha[<%=WIDTH-1%>:0]),
	      .o_rdata_alpha(o_rdata_alpha[<%=WIDTH-1%>:0]),
	      .i_wen_beta(i_wen_beta),
	      .i_raddr_beta(i_raddr_beta[7:0]),
	      .i_waddr_beta(i_waddr_beta[7:0]),
	      .i_rdata_beta(i_wdata_beta[<%=WIDTH-1%>:0]),
	      .o_rdata_beta(o_rdata_beta[<%=WIDTH-1%>:0])
	      );

   //データ書き込み（パリティビットが0か最大繰り返し回数に達する
   always@(posedge clk) begin 
      if(o_val==1 || w_loop==<%=LOOP_MAX%>)
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

   //リセット信号生成
   task t_reset();
      begin
	 @(posedge clk);
	 xrst <= 'd0;
	 @(posedge clk);
	 xrst <= 'd1;
      end
   endtask // t_reset

   //クロック,valid初期化
   task initialize();
      begin
	 clk<=1;
	 i_val <= 1;
      end
   endtask // initialize

   module sram
  (
   input             clk,
   input             i_wen,//write_enable信号
   input [7:0]       i_waddr, i_raddr,//書き込みアドレス，読み込みアドレス
   input [<%=WIDTH-1%>:0]      i_wdata,//書き込みデータ
   output reg [<%=WIDTH-1%>:0] o_rdata//読み込みデータ
   /*AUTOARG*/);

  reg [<%=WIDTH-1%>:0]           mem[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];

  always@(posedge clk)
    if (i_wen) mem[i_waddr] <= i_wdata;
  
  always@(posedge clk)
    if (!i_wen) o_rdata <= mem[i_raddr];

  
endmodule // sram
   
endmodule // test_test


  
   

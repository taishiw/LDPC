/* <%
 #環境変数として取り込む
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 %> */
module row(i_data,i_val,o_data,o_val,clk,xrst,i_init);
   input  [<%=WIDTH-1%>:0] i_data;//入力信号
   input  i_val;//入力valid信号
   output [<%=WIDTH-1%>:0] o_data;//出力信号
   output reg o_val;//出力valid信号
   input  clk;//クロック
   input  xrst;//リセット信号
   input [2:0] i_init;//初期化信号
   reg signed [<%=WIDTH-1%>:0] r_min;//最小値レジスタ
   reg 			  r_exor;//符号レジスタ

   //最小値と符号をかけ合わせる
   assign o_data=(!r_exor)?r_min:(-r_min+1);

   //出力valid信号の設定
   always@(posedge clk or negedge xrst)begin
      if(!xrst)
	o_val <= 0;
      else if (i_val)
	o_val <= 1;
      else
	o_val <= o_val;
   end
	
   //排他的論理和
   always@(posedge clk or negedge xrst)begin
      if(!xrst)
	r_exor <= 0;
      else if(i_val)
	begin
	   if(i_init == <%=1%>)
	     r_exor<=i_data[<%=WIDTH-1%>];
	   else 
	     r_exor<=r_exor^i_data[<%=WIDTH-1%>];
	end
      else
	r_exor <= r_exor;
   end // always@ (posedge clk or negedge xrst)
   
   //最小値
   always@(posedge clk)begin
      if(!xrst)
	r_min <= <%=WIDTH%>'b<%0.upto(WIDTH-1) do |i| %>1<%end%>;
      else if (i_val)
	begin
	   if(i_init == 1)
	     r_min <= funcabs(i_data);
	   else
	     r_min <= (funcabs(i_data)< r_min)?funcabs(i_data):r_min;
	end
      else
	r_min <= r_min;
   end

//絶対値
   function [<%=WIDTH-1%>:0] funcabs;
      input [<%=WIDTH-1%>:0] i_data;
      funcabs=(!i_data[<%=WIDTH-1%>])? i_data:(-i_data+1);
   endfunction   
   
endmodule // row

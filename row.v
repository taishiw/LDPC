/*  */
module row(i_data,i_val,o_data,o_val,clk,xrst,i_init);
   input  [15:0] i_data;//入力信号
   input  i_val;//入力valid信号
   output [15:0] o_data;//出力信号
   output reg o_val;//出力valid信号
   input  clk;//クロック
   input  xrst;//リセット信号
   input [2:0] i_init;//初期化信号
   reg signed [15:0] r_min;//最小値レジスタ
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
	   if(i_init == 1)
	     r_exor<=i_data[15];
	   else 
	     r_exor<=r_exor^i_data[15];
	end
      else
	r_exor <= r_exor;
   end // always@ (posedge clk or negedge xrst)
   
   //最小値
   always@(posedge clk)begin
      if(!xrst)
	r_min <= 16'b1111111111111111;
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
   function [15:0] funcabs;
      input [15:0] i_data;
      funcabs=(!i_data[15])? i_data:(-i_data+1);
   endfunction   
   
endmodule // row

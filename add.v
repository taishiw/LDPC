/* */

module add(i_data,i_val,o_data,o_val,clk,xrst,i_init);  
   input signed [15:0] i_data;//入力データ
   input 		    i_val;//入力valid信号
   output reg signed [15:0] o_data;//出力信号
   output reg	       o_val;//出力valid信号
   input 	       clk;//クロック
   input 	       xrst;//リセット信号
   input [2:0] 	       i_init;//初期化信号

   //和をとる
   always@(posedge clk) begin
	 if(!xrst)
	   o_data<=0;
	 else if (i_val)
	   begin
	      if(i_init == 1)
		o_data <= i_data;
	      else
		o_data <= o_data + i_data;
	   end
	 else
	   o_data <= o_data;
   end

   //出力valid信号設定
   always@(posedge clk) begin
      if(!xrst)
	o_val <= 0;
      else if (i_val)
	o_val <= 1;
      else
	o_val <= o_val;
   end
	   
  
  
endmodule

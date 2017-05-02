/* <%
 #環境変数として取り込む
 ROW_NUMBER= ENV['ROW_NUMBER'].to_i;
 COL_NUMBER= ENV['COL_NUMBER'].to_i;
 ROW_WEIGHT= ENV['ROW_WEIGHT'].to_i;
 COL_WEIGHT= ENV['COL_WEIGHT'].to_i;
 LOOP_MAX=ENV['LOOP_MAX'].to_i;
 WIDTH = ENV['WIDTH'].to_i; 
 %>*/

module sram
  (
   input             clk,
   input             i_wen,//write_enable信号
   input [19:0]       i_waddr, i_raddr,//書き込みアドレス，読み込みアドレス
   input [<%=WIDTH-1%>:0]      i_wdata,//書き込みデータ
   output reg [<%=WIDTH-1%>:0] o_rdata//読み込みデータ
   /*AUTOARG*/);

  reg [<%=WIDTH-1%>:0]           mem[<%=ROW_WEIGHT*COL_NUMBER-1%>:0];

  always@(posedge clk)
    if (i_wen) mem[i_waddr] <= i_wdata;
  
  always@(posedge clk)
    if (!i_wen) o_rdata <= mem[i_raddr];

  
endmodule // sram


// Local Variables:
// mode: verilog
// coding: utf-8
// indent-tabs-mode: nil
// verilog-indent-level-module: 2
// verilog-indent-level: 2
// verilog-indent-level-behavioral: 2
// verilog-indent-level-declaration: 2
// End:

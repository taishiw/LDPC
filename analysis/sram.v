/* */

module sram
  (
   input             clk,
   input             i_wen,//write_enable信号
   input [19:0]       i_waddr, i_raddr,//書き込みアドレス，読み込みアドレス
   input [15:0]      i_wdata,//書き込みデータ
   output reg [15:0] o_rdata//読み込みデータ
   /*AUTOARG*/);

  reg [15:0]           mem[799:0];

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

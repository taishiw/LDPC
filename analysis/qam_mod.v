/**/

module qam_mod
(
 input [7:0]         i_data,
 input                                 i_val,
 input                                 i_ready,

 input [2:0]         i_conf_qam_num,
 input                                 i_conf_qam_gray,

 output reg signed [15:0] o_data_re,
 output reg signed [15:0] o_data_im,

 output reg                            o_val,
 output reg                            o_ready,

 input                                 clk, xrst
 );

  wire [15:0]             w_o_data_re, w_o_data_im;
  /**/
  wire [1:0]                           w_bpsk_re, w_bpsk_im;
  parameter zBPSK   = 0;
  /**/
  /**/
  wire [1:0]                           w_qpsk_re, w_qpsk_im;
  parameter zQPSK   = 1;
  /**/
  /**/
  wire [2:0]                           w_qam16_re, w_qam16_im;
  parameter zQAM16  = 2;
  /**/
  /**/
  wire [3:0]                           w_qam64_re, w_qam64_im;
  parameter zQAM64  = 3;
  /**/
  /**/
  wire [4:0]                           w_qam256_re, w_qam256_im;
  parameter zQAM256 = 4;
  /**/

  /**/
  assign w_bpsk_re = {!i_data[0], 1'b1};
  assign w_bpsk_im = 0;
  /**/

  /**/
  assign w_qpsk_re = {!i_data[1], 1'b1};
  assign w_qpsk_im = {i_data[0], 1'b1};
  /**/

  /**/
  assign w_qam16_re = (i_conf_qam_gray) ?
                      {!i_data[3],
                       i_data[3] ^ i_data[2],
                       1'b1}:
                      {!i_data[3], i_data[2], 1'b1};

  assign w_qam16_im = (i_conf_qam_gray) ?
                      {i_data[1],
                       i_data[1] ^ !i_data[0],
                       1'b1}:
                      {i_data[1], !i_data[0], 1'b1};
  /**/

  /**/
  assign w_qam64_re = (i_conf_qam_gray) ?
                      {!i_data[5],
                       i_data[5] ^ i_data[4],
                       i_data[5] ^ i_data[4] ^ i_data[3],
                       1'b1}:
                      {!i_data[5], i_data[4:3], 1'b1};

  assign w_qam64_im = (i_conf_qam_gray) ?
                      {i_data[2],
                       i_data[2] ^ !i_data[1],
                       i_data[2] ^ !i_data[1] ^ i_data[0],
                       1'b1}:
                      {i_data[2], !i_data[1], !i_data[0], 1'b1};
  /**/

  /**/
  assign w_qam256_re = (i_conf_qam_gray) ?
                       {!i_data[7],
                        i_data[7] ^ i_data[6],
                        i_data[7] ^ i_data[6] ^ i_data[5],
                        i_data[7] ^ i_data[6] ^ i_data[5] ^ i_data[4],
                        1'b1}:
                       {!i_data[7], i_data[6:4], 1'b1};
  assign w_qam256_im = (i_conf_qam_gray) ?
                       {i_data[3],
                        i_data[3] ^ !i_data[2],
                        i_data[3] ^ !i_data[2] ^ i_data[1],
                        i_data[3] ^ !i_data[2] ^ i_data[1] ^ i_data[0],
                        1'b1}:
                       {i_data[3], !i_data[2], !i_data[1], !i_data[0], 1'b1};
  /**/

  /**/
  assign w_o_data_re =
                     /**/(i_conf_qam_num == zBPSK)   ? {w_bpsk_re,   14'b0}: /**/
                     /**/(i_conf_qam_num == zQPSK)   ? {w_qpsk_re,   14'b0}: /**/
                     /**/(i_conf_qam_num == zQAM16)  ? {w_qam16_re,  13'b0}: /**/
                     /**/(i_conf_qam_num == zQAM64)  ? {w_qam64_re,  12'b0}: /**/
                     /**/(i_conf_qam_num == zQAM256) ? {w_qam256_re, 11'b0}: /**/
                     'd0;
  /**/
  assign w_o_data_im =
                     /**/(i_conf_qam_num == zBPSK)   ? {w_bpsk_im,   14'b0}: /**/
                     /**/(i_conf_qam_num == zQPSK)   ? {w_qpsk_im,   14'b0}: /**/
                     /**/(i_conf_qam_num == zQAM16)  ? {w_qam16_im,  13'b0}: /**/
                     /**/(i_conf_qam_num == zQAM64)  ? {w_qam64_im,  12'b0}: /**/
                     /**/(i_conf_qam_num == zQAM256) ? {w_qam256_im, 11'b0}: /**/
                     'd0;
  /**/

  always@(posedge clk or negedge xrst)
    if (!xrst)
      o_ready <= 0;
    else
      o_ready <= i_ready;

  always@(posedge clk or negedge xrst)
    if (!xrst)
      o_val <= 0;
    else
      o_val <= i_val;

  always@(posedge clk or negedge xrst)
    if (!xrst)
      o_data_re <= 0;
    else if (i_val)
      o_data_re <= w_o_data_re;
    else
      o_data_re <= 0;

  always@(posedge clk or negedge xrst)
    if (!xrst)
      o_data_im <= 0;
    else if (i_val)
      o_data_im <= w_o_data_im;
    else
      o_data_im <= 0;

endmodule

// Local Variables:
// mode: verilog
// coding: utf-8
// indent-tabs-mode: nil
// verilog-indent-level-module: 2
// verilog-indent-level: 2
// verilog-indent-level-behavioral: 2
// verilog-indent-level-declaration: 2
// End:

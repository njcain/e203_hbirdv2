`include "e203_defines.v"
module e203_exu_fpu_fmis_mv(
    input fmis_mv_i_valid, // Handshake valid
    output fmis_mv_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    output fmis_mv_o_valid, // Handshake valid
    input  fmis_mv_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmis_mv_o_wbck_wdat
);
  assign fmis_mv_o_valid = fmis_mv_i_valid;
  assign fmis_mv_i_ready = fmis_mv_o_ready;
  assign fmis_mv_o_wbck_wdat = fmis_i_rs1;
endmodule
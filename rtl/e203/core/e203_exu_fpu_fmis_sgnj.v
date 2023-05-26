`include "e203_defines.v"
module e203_exu_fpu_fmis_sgnj(
    input fmis_sgnj_i_valid, // Handshake valid
    output fmis_sgnj_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    input [31:0] fmis_i_rs2,
    input [1:0] flag,
    output fmis_sgnj_o_valid, // Handshake valid
    input  fmis_sgnj_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmis_sgnj_o_wbck_wdat
);

  reg [31:0] fmis_sgnj_o_wbck_wdat_r;
  assign fmis_sgnj_o_valid = fmis_sgnj_i_valid;
  assign fmis_sgnj_i_ready = fmis_sgnj_o_ready;
  always @(*) begin
    case (flag)
      0: fmis_sgnj_o_wbck_wdat_r = {fmis_i_rs2[31],fmis_i_rs1[30:0]};
      1: fmis_sgnj_o_wbck_wdat_r = {!fmis_i_rs2[31],fmis_i_rs1[30:0]};
      2: fmis_sgnj_o_wbck_wdat_r = {fmis_i_rs2[31]^fmis_i_rs1[31],fmis_i_rs1[30:0]};
      default: fmis_sgnj_o_wbck_wdat_r = 0;
    endcase
  end
  assign fmis_sgnj_o_wbck_wdat = fmis_sgnj_o_wbck_wdat_r;
endmodule
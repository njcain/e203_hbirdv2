module e203_exu_fpu_fmis_cvtws(
    input fmis_cvtws_i_valid, // Handshake valid
    output fmis_cvtws_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    output fmis_cvtws_o_valid, // Handshake valid
    input  fmis_cvtws_o_ready, // Handshake ready
    input flag,
    input clk,
    input rst_n,
    output [31:0] fmis_cvtws_o_wbck_wdat
    );

    assign fmis_cvtws_o_valid = fmis_cvtws_i_valid;
    assign fmis_cvtws_i_ready = fmis_cvtws_o_ready;
    wire [31:0] a = fmis_i_rs1;
    wire s = a[31];
    wire [8-1:0] e = a[30:23];
    wire [23-1:0] m = a[22:0];
    wire [23:0] mi = {1'b1, m};
    wire [7:0] shift = e > 8'd149 ? e - 8'd150 : 8'd149 - e;
    wire [31:0] n0 = mi << shift;
    wire [32:0] n1 = mi >> shift;
    wire guard = n1[0];
    wire [31:0] n2 = (n1 >> 1) + guard;
    wire [31:0] b_pos = e < 8'd126 ? 32'b0 : e > 8'd157 ? 32'h7fffffff : e > 8'd149 ? n0 : n2;
    wire [31:0] b_neg = ~b_pos + 1;
    assign fmis_cvtws_o_wbck_wdat = flag ? b_pos : (s ? b_neg : b_pos);
endmodule
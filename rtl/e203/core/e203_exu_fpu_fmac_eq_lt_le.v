module e203_exu_fpu_fmac_lt(
    input fmac_lt_i_valid, // Handshake valid
    output fmac_lt_i_ready, // Handshake ready
    input [31:0] fmac_i_rs1,
    input [31:0] fmac_i_rs2,
    output fmac_lt_o_valid, // Handshake valid
    input  fmac_lt_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmac_lt_o_wbck_wdat
);
    assign fmac_lt_o_valid = fmac_lt_i_valid;
    assign fmac_lt_i_ready = fmac_lt_o_ready;
    wire[31:0] a = fmac_i_rs2;
    wire[31:0] b = fmac_i_rs1;
    wire s_a = a[31];
    wire s_b = b[31];
    wire [7:0] e_a = a[30:23];
    wire [7:0] e_b = b[30:23];
    wire [22:0] m_a = a[22:0];
    wire [22:0] m_b = b[22:0];
    
    wire [1:0] sel_s = 
    (~s_a & s_b) ? 0 : 
    (s_a & ~s_b) ? 1 :
    (s_a & s_b) ? 2: 3;
    
    assign fmac_lt_o_wbck_wdat = 
    (a == 32'h80000000 && b == 32'h00000000) ? 0 :
    (sel_s == 1) ? 1 : 
    (sel_s == 2 && e_a > e_b) ? 1 :
    (sel_s == 3 && e_a < e_b) ? 1 :
    (sel_s == 2 && e_a == e_b && m_a > m_b) ? 1 :
    (sel_s == 3 && e_a == e_b && m_a < m_b) ? 1 : 0;
endmodule


module e203_exu_fpu_fmac_eq(
    input fmac_eq_i_valid, // Handshake valid
    output fmac_eq_i_ready, // Handshake ready
    input [31:0] fmac_i_rs1,
    input [31:0] fmac_i_rs2,
    output fmac_eq_o_valid, // Handshake valid
    input  fmac_eq_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmac_eq_o_wbck_wdat
);
    assign fmac_eq_o_valid = fmac_eq_i_valid;
    assign fmac_eq_i_ready = fmac_eq_o_ready;
    wire[31:0] a = fmac_i_rs1;
    wire[31:0] b = fmac_i_rs2;
    assign fmac_eq_o_wbck_wdat = 
    (a == 32'h80000000 && b == 32'h00000000) ? 1 :
    (a == 32'h00000000 && b == 32'h80000000) ? 1 :
    a == b ? 1 : 0;
endmodule


module e203_exu_fpu_fmac_le(
    input fmac_le_i_valid, // Handshake valid
    output fmac_le_i_ready, // Handshake ready
    input [31:0] fmac_i_rs1,
    input [31:0] fmac_i_rs2,
    output fmac_le_o_valid, // Handshake valid
    input  fmac_le_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmac_le_o_wbck_wdat
);
    assign fmac_le_o_valid = fmac_le_i_valid;
    assign fmac_le_i_ready = fmac_le_o_ready;
    wire[31:0] fmac_le_o_wbck_wdat_eq;
    wire[31:0] fmac_le_o_wbck_wdat_lt;

    e203_exu_fpu_fmac_eq u_e203_exu_fpu_fmac_eq(
    .fmac_eq_i_valid(),
    .fmac_eq_i_ready(),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_eq_o_valid(),
    .fmac_eq_o_ready(),
    .clk(),
    .rst_n(),
    .fmac_eq_o_wbck_wdat(fmac_le_o_wbck_wdat_eq)
    );

    e203_exu_fpu_fmac_lt u_e203_exu_fpu_fmac_lt(
    .fmac_lt_i_valid(),
    .fmac_lt_i_ready(),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_lt_o_valid(),
    .fmac_lt_o_ready(),
    .clk(),
    .rst_n(),
    .fmac_lt_o_wbck_wdat(fmac_le_o_wbck_wdat_lt)
    );
    assign fmac_le_o_wbck_wdat = (fmac_le_o_wbck_wdat_eq || fmac_le_o_wbck_wdat_lt) ? 1:0;
endmodule
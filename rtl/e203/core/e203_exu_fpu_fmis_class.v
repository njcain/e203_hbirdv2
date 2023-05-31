module e203_exu_fpu_fmis_class(
    input fmis_class_i_valid, // Handshake valid
    output fmis_class_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    output fmis_class_o_valid, // Handshake valid
    input  fmis_class_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmis_class_o_wbck_wdat
);
  wire [31:0] a = fmis_i_rs1; 
  wire [22:0] a_m = a[22:0];
  wire  [7:0] a_e = a[30:23];
  wire a_s = a[31];
  assign fmis_class_o_valid = fmis_class_i_valid;
  assign fmis_class_i_ready = fmis_class_o_ready;
  assign fmis_class_o_wbck_wdat = {22'b0,
  (a_e==8'b11111111)&(a_m!=23'b0),
  (a_e==8'b11111111)&(a_m!=23'b0),
  (a_s==0)&(a_e==8'b11111111)&(a_m==23'b0), //正无穷
  (a_s==0)& (a_e!=8'b0) & (a_e!=8'b11111111), //正规约数
  (a_s==0)& (a_e==8'b0) & (a_m!=8'b0), //正非规约数
  (a==32'h00000000), //正0
  (a==32'h80000000), //负0
  (a_s==1)& (a_e==8'b0) & (a_m!=8'b0), //负非规约数
  (a_s==1)& (a_e!=8'b0) & (a_e!=8'b11111111), //负规约数
  (a_s==1)&(a_e==8'b11111111)&(a_m==23'b0) //负无穷
  };

endmodule
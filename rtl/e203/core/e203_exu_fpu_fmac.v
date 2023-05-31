`include "e203_defines.v"

module e203_exu_fpu_fmac(
    // The Issue Handshake Interface to FMAC
    //
    input fmac_i_valid, // Handshake valid
    output fmac_i_ready, // Handshake ready
    input [`E203_XLEN-1:0] fmac_i_rs1,
    input [`E203_XLEN-1:0] fmac_i_rs2,
    input [`E203_XLEN-1:0] fmac_i_rs3,
    input [`E203_XLEN-1:0] fmac_i_imm,
    input  [`E203_DECINFO_FMAC_WIDTH-1:0] fmac_i_info,
    input  [`E203_ITAG_WIDTH-1:0] fmac_i_itag,
    input  flush_pulse,

    // The FMAC Write-Back/Commit Interface
    output fmac_o_valid, // Handshake valid
    input  fmac_o_ready, // Handshake ready

    output [`E203_XLEN-1:0] fmac_o_wbck_wdat,
    output fmac_o_wbck_err,
    output wire [1:0] overflow,

    input clk,
    input rst_n
);
	assign fmac_o_wbck_err = 0;
    wire i_fadd=fmac_i_info[`E203_DECINFO_FMAC_FADD];
	wire i_fsub=fmac_i_info[`E203_DECINFO_FMAC_FSUB];
	wire i_fmul=fmac_i_info[`E203_DECINFO_FMAC_FMUL];
    wire i_fdiv=fmac_i_info[`E203_DECINFO_FMAC_FDIV];
	wire i_fmadd=fmac_i_info[`E203_DECINFO_FMAC_FMADD];
	wire i_fmsub=fmac_i_info[`E203_DECINFO_FMAC_FMSUB];
	wire i_fnmsub=fmac_i_info[`E203_DECINFO_FMAC_FNMSUB];
	wire i_fnmadd=fmac_i_info[`E203_DECINFO_FMAC_FNMADD];
	wire i_fmin=fmac_i_info[`E203_DECINFO_FMAC_FMIN];
	wire i_fmax=fmac_i_info[`E203_DECINFO_FMAC_FMAX];
	wire i_feq=fmac_i_info[`E203_DECINFO_FMAC_FEQ];
	wire i_flt=fmac_i_info[`E203_DECINFO_FMAC_FLT];
	wire i_fle=fmac_i_info[`E203_DECINFO_FMAC_FLE];

	wire fmac_as_i_valid = fmac_i_valid & (i_fadd | i_fsub);
	wire fmac_mul_i_valid = fmac_i_valid & i_fmul;
	wire fmac_div_i_valid = fmac_i_valid & i_fdiv;
    wire fmac_eq_i_valid = fmac_i_valid & i_feq;
    wire fmac_lt_i_valid = fmac_i_valid & i_flt;
    wire fmac_le_i_valid = fmac_i_valid & i_fle;
    wire fmac_mmnn_i_valid = fmac_i_valid & (i_fnmadd|i_fnmsub|i_fmadd|i_fmsub);

    wire fmac_as_i_ready,fmac_mul_i_ready,fmac_div_i_ready,fmac_eq_i_ready,fmac_lt_i_ready,fmac_le_i_ready,fmac_mmnn_i_ready;
	assign fmac_i_ready =   (fmac_as_i_ready & (i_fadd | i_fsub))
                 		  | (fmac_mul_i_ready & i_fmul)
						  | (fmac_div_i_ready & i_fdiv)
                          | (fmac_eq_i_ready & i_feq)
                          | (fmac_lt_i_ready & i_flt)
                          | (fmac_le_i_ready & i_fle)
                          | (fmac_mmnn_i_ready & (i_fnmadd|i_fnmsub|i_fmadd|i_fmsub));

	wire fmac_as_o_valid;
	wire fmac_mul_o_valid;
	wire fmac_div_o_valid;
    wire fmac_eq_o_valid;
    wire fmac_lt_o_valid;
    wire fmac_le_o_valid;
    wire fmac_mmnn_o_valid;
	assign fmac_o_valid = (fmac_as_o_valid & (i_fadd | i_fsub)) 
                        | (fmac_mul_o_valid & i_fmul) 
                        | (fmac_div_o_valid & i_fdiv)
                        | (fmac_eq_o_valid & i_feq)
                        | (fmac_le_o_valid & i_fle)
                        | (fmac_lt_o_valid & i_flt)
                        | (fmac_mmnn_o_valid & (i_fnmadd|i_fnmsub|i_fmadd|i_fmsub));

	wire fmac_as_o_ready = fmac_o_ready & (i_fadd | i_fsub);
	wire fmac_mul_o_ready = fmac_o_ready & i_fmul;
	wire fmac_div_o_ready = fmac_o_ready & i_fdiv;
    wire fmac_eq_o_ready = fmac_o_ready & i_feq;
    wire fmac_lt_o_ready = fmac_o_ready & i_flt;
    wire fmac_le_o_ready = fmac_o_ready & i_fle;
    wire fmac_mmnn_o_ready = fmac_o_ready & (i_fnmadd|i_fnmsub|i_fmadd|i_fmsub);

	wire [31:0] fmac_as_o_wbck_wdat;
	wire [31:0] fmac_mul_o_wbck_wdat;
	wire [31:0] fmac_div_o_wbck_wdat;
    wire [31:0] fmac_eq_o_wbck_wdat;
    wire [31:0] fmac_lt_o_wbck_wdat;
    wire [31:0] fmac_le_o_wbck_wdat;
    wire [31:0] fmac_mmnn_o_wbck_wdat;

	assign fmac_o_wbck_wdat = ({`E203_XLEN{(i_fadd|i_fsub)}} & fmac_as_o_wbck_wdat)
					|  ({`E203_XLEN{i_fmul}} & fmac_mul_o_wbck_wdat)
					|  ({`E203_XLEN{i_fdiv}} & fmac_div_o_wbck_wdat)
                    |  ({`E203_XLEN{i_feq}} & fmac_eq_o_wbck_wdat)
                    |  ({`E203_XLEN{i_flt}} & fmac_lt_o_wbck_wdat)
                    |  ({`E203_XLEN{i_fle}} & fmac_le_o_wbck_wdat)
                    |  ({`E203_XLEN{(i_fnmadd|i_fnmsub|i_fmadd|i_fmsub)}} & fmac_mmnn_o_wbck_wdat);
	// assign fmac_o_wbck_err = ({`E203_XLEN{(i_fadd|i_fsub)}} & fmac_as_o_wbck_err)
	// 				|  ({`E203_XLEN{i_fmul}} & fmac_mul_o_wbck_err);

	e203_exu_fpu_fmac_add_sub u_e203_exu_fpu_fmac_add_sub(
	.fmac_as_i_valid(fmac_as_i_valid),
    .fmac_as_i_ready(fmac_as_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(i_fadd ? fmac_i_rs2 : {~fmac_i_rs2[31],fmac_i_rs2[30:0]}),
    .fmac_as_o_valid(fmac_as_o_valid),
    .fmac_as_o_ready(fmac_as_o_ready),
    .fmac_as_o_wbck_wdat(fmac_as_o_wbck_wdat),
    .overflow(overflow),
    .clk(clk),
    .rst_n(rst_n)
	);

	e203_exu_fpu_fmac_mul u_e203_exu_fpu_fmac_mul(
	.fmac_mul_i_valid(fmac_mul_i_valid),
    .fmac_mul_i_ready(fmac_mul_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_mul_o_valid(fmac_mul_o_valid),
    .fmac_mul_o_ready(fmac_mul_o_ready),
    .fmac_mul_o_wbck_wdat(fmac_mul_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);

	e203_exu_fpu_fmac_div u_e203_exu_fpu_fmac_div(
	.fmac_div_i_valid(fmac_div_i_valid),
    .fmac_div_i_ready(fmac_div_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_div_o_valid(fmac_div_o_valid),
    .fmac_div_o_ready(fmac_div_o_ready),
    .fmac_div_o_wbck_wdat(fmac_div_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);


	e203_exu_fpu_fmac_eq u_e203_exu_fpu_fmac_eq(
	.fmac_eq_i_valid(fmac_eq_i_valid),
    .fmac_eq_i_ready(fmac_eq_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_eq_o_valid(fmac_eq_o_valid),
    .fmac_eq_o_ready(fmac_eq_o_ready),
    .fmac_eq_o_wbck_wdat(fmac_eq_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);
	e203_exu_fpu_fmac_lt u_e203_exu_fpu_fmac_lt(
	.fmac_lt_i_valid(fmac_lt_i_valid),
    .fmac_lt_i_ready(fmac_lt_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_lt_o_valid(fmac_lt_o_valid),
    .fmac_lt_o_ready(fmac_lt_o_ready),
    .fmac_lt_o_wbck_wdat(fmac_lt_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);
	e203_exu_fpu_fmac_le u_e203_exu_fpu_fmac_le(
	.fmac_le_i_valid(fmac_le_i_valid),
    .fmac_le_i_ready(fmac_le_i_ready),
    .fmac_i_rs1(fmac_i_rs1),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_le_o_valid(fmac_le_o_valid),
    .fmac_le_o_ready(fmac_le_o_ready),
    .fmac_le_o_wbck_wdat(fmac_le_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);

    e203_exu_fpu_fmac_madd_msub_nmadd_nmsub u_e203_exu_fpu_fmac_madd_msub_nmadd_nmsub(
    .fmac_mmnn_i_valid(fmac_mmnn_i_valid),
    .fmac_mmnn_i_ready(fmac_mmnn_i_ready),
    .fmac_i_rs1((i_fmadd|i_fmsub) ? fmac_i_rs1 : {~fmac_i_rs1[31],fmac_i_rs1[30:0]}),
    .fmac_i_rs2(fmac_i_rs2),
    .fmac_i_rs3((i_fmadd | i_fnmadd) ? fmac_i_rs3 : {~fmac_i_rs3[31],fmac_i_rs3[30:0]}),
    .fmac_mmnn_o_valid(fmac_mmnn_o_valid),
    .fmac_mmnn_o_ready(fmac_mmnn_o_ready),
    .fmac_mmnn_o_wbck_wdat(fmac_mmnn_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
);
endmodule
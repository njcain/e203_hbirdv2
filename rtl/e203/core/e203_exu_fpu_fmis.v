`include "e203_defines.v"

module e203_exu_fpu_fmis(
    // The Issue Handshake Interface to FMIS
    //
    input fmis_i_valid, // Handshake valid
    output fmis_i_ready, // Handshake ready
    input [`E203_XLEN-1:0] fmis_i_rs1,
    input [`E203_XLEN-1:0] fmis_i_rs2,
    input [`E203_XLEN-1:0] fmis_i_imm,
    input  [`E203_DECINFO_FMIS_WIDTH-1:0] fmis_i_info,
    input  [`E203_ITAG_WIDTH-1:0] fmis_i_itag,
    input  flush_pulse,

    // The FMIS Write-Back/Commit Interface
    output fmis_o_valid, // Handshake valid
    input  fmis_o_ready, // Handshake ready

    output [`E203_XLEN-1:0] fmis_o_wbck_wdat,
    output fmis_o_wbck_err,
    output wire [1:0] overflow,

    input clk,
    input rst_n
);
	assign fmis_o_wbck_err = 0;
    wire i_fsgnj=fmis_i_info[`E203_DECINFO_FMIS_FSGNJ];
	wire i_fsgnjn=fmis_i_info[`E203_DECINFO_FMIS_FSGNJN];
	wire i_fsgnjx=fmis_i_info[`E203_DECINFO_FMIS_FSGNJX];
	wire i_fmvxw=fmis_i_info[`E203_DECINFO_FMIS_FMVXW];
	wire i_fclass=fmis_i_info[`E203_DECINFO_FMIS_FCLASS];
	wire i_fmvwx=fmis_i_info[`E203_DECINFO_FMIS_FMVWX];
	wire i_fcvtws=fmis_i_info[`E203_DECINFO_FMIS_CVTWS];
	wire i_fcvtwus=fmis_i_info[`E203_DECINFO_FMIS_CVTWUS];
	wire i_fcvtsw=fmis_i_info[`E203_DECINFO_FMIS_CVTSW];
	wire i_fcvtswu=fmis_i_info[`E203_DECINFO_FMIS_CVTSWU];
    wire i_fsqrt=fmis_i_info[`E203_DECINFO_FMIS_FSQRT];



	wire fmis_sgnj_i_valid = fmis_i_valid & (i_fsgnj|i_fsgnjn|i_fsgnjx);
    wire fmis_mv_i_valid = fmis_i_valid & (i_fmvxw|i_fmvwx);
    wire fmis_cvtws_i_valid = fmis_i_valid & (i_fcvtws|i_fcvtwus);
    wire fmis_cvtsw_i_valid = fmis_i_valid & (i_fcvtsw|i_fcvtswu);
    wire fmis_sqrt_i_valid = fmis_i_valid & i_fsqrt;
    wire fmis_class_i_valid = fmis_i_valid & i_fclass;

    wire fmis_sgnj_i_ready ;
    wire fmis_mv_i_ready;
    wire fmis_cvtws_i_ready;
    wire fmis_cvtsw_i_ready;
    wire fmis_sqrt_i_ready ;
    wire fmis_class_i_ready;
	assign fmis_i_ready = (fmis_sgnj_i_ready & (i_fsgnj|i_fsgnjn|i_fsgnjx))
                         |(fmis_mv_i_ready & (i_fmvxw|i_fmvwx))
                         |(fmis_cvtws_i_ready & (i_fcvtws|i_fcvtwus))
                         |(fmis_cvtsw_i_ready & (i_fcvtsw|i_fcvtswu))
                         |(fmis_sqrt_i_ready & i_fsqrt)
                         |(fmis_class_i_ready & i_fclass);
    
	wire fmis_sgnj_o_valid;
	wire fmis_mv_o_valid;
    wire fmis_cvtws_o_valid;
    wire fmis_cvtsw_o_valid;
    wire fmis_sqrt_o_valid;
    wire fmis_class_o_valid;

	assign fmis_o_valid = (fmis_sgnj_o_valid & (i_fsgnj|i_fsgnjn|i_fsgnjx)) 
                        | (fmis_mv_o_valid & (i_fmvxw|i_fmvwx))
                        | (fmis_cvtws_o_valid & (i_fcvtws|i_fcvtwus))
                        | (fmis_cvtsw_o_valid & (i_fcvtsw|i_fcvtswu)) 
                        | (fmis_sqrt_o_valid & i_fsqrt)
                        | (fmis_class_o_valid & i_fclass);

	wire fmis_sgnj_o_ready = fmis_o_ready & (i_fsgnj|i_fsgnjn|i_fsgnjx);
    wire fmis_mv_o_ready = fmis_o_ready & (i_fmvxw|i_fmvwx);
    wire fmis_cvtws_o_ready = fmis_o_ready & (i_fcvtws|i_fcvtwus);
    wire fmis_cvtsw_o_ready = fmis_o_ready & (i_fcvtsw|i_fcvtswu);
    wire fmis_sqrt_o_ready = fmis_o_ready & i_fsqrt;
    wire fmis_class_o_ready = fmis_o_ready & i_fclass;

	wire [31:0] fmis_sgnj_o_wbck_wdat;
    wire [31:0] fmis_mv_o_wbck_wdat;
    wire [31:0] fmis_cvtws_o_wbck_wdat;
    wire [31:0] fmis_cvtsw_o_wbck_wdat;
    wire [31:0] fmis_sqrt_o_wbck_wdat;
    wire [31:0] fmis_class_o_wbck_wdat;
	assign fmis_o_wbck_wdat = ({`E203_XLEN{(i_fsgnj|i_fsgnjn|i_fsgnjx)}} & fmis_sgnj_o_wbck_wdat)
                            | ({`E203_XLEN{(i_fmvxw|i_fmvwx)}} & fmis_mv_o_wbck_wdat)
                            | ({`E203_XLEN{(i_fcvtws|i_fcvtwus)}} & fmis_cvtws_o_wbck_wdat)
                            | ({`E203_XLEN{(i_fcvtsw|i_fcvtswu)}} & fmis_cvtsw_o_wbck_wdat)
                            | ({`E203_XLEN{i_fsqrt}} & fmis_sqrt_o_wbck_wdat)
                            | ({`E203_XLEN{i_fclass}} & fmis_class_o_wbck_wdat);

	e203_exu_fpu_fmis_sgnj u_e203_exu_fpu_fmis_sgnj(
	.fmis_sgnj_i_valid(fmis_sgnj_i_valid),
    .fmis_sgnj_i_ready(fmis_sgnj_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_i_rs2(fmis_i_rs2),
    .flag (i_fsgnj ? 2'b00 : (i_fsgnjn ? 2'b01 : (i_fsgnjx ? 2'b10 : 0))),
    .fmis_sgnj_o_valid(fmis_sgnj_o_valid),
    .fmis_sgnj_o_ready(fmis_sgnj_o_ready),
    .fmis_sgnj_o_wbck_wdat(fmis_sgnj_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);

    e203_exu_fpu_fmis_mv u_e203_exu_fpu_fmis_mv(
	.fmis_mv_i_valid(fmis_mv_i_valid),
    .fmis_mv_i_ready(fmis_mv_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_mv_o_valid(fmis_mv_o_valid),
    .fmis_mv_o_ready(fmis_mv_o_ready),
    .fmis_mv_o_wbck_wdat(fmis_mv_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);

    e203_exu_fpu_fmis_cvtws u_e203_exu_fpu_fmis_cvtws(
	.fmis_cvtws_i_valid(fmis_cvtws_i_valid),
    .fmis_cvtws_i_ready(fmis_cvtws_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_cvtws_o_valid(fmis_cvtws_o_valid),
    .fmis_cvtws_o_ready(fmis_cvtws_o_ready),
    .fmis_cvtws_o_wbck_wdat(fmis_cvtws_o_wbck_wdat),
    .flag(i_fcvtwus),
    .clk(clk),
    .rst_n(rst_n)
	);

    e203_exu_fpu_fmis_cvtsw u_e203_exu_fpu_fmis_cvtsw(
	.fmis_cvtsw_i_valid(fmis_cvtsw_i_valid),
    .fmis_cvtsw_i_ready(fmis_cvtsw_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_cvtsw_o_valid(fmis_cvtsw_o_valid),
    .fmis_cvtsw_o_ready(fmis_cvtsw_o_ready),
    .fmis_cvtsw_o_wbck_wdat(fmis_cvtsw_o_wbck_wdat),
    .flag(i_fcvtswu),
    .clk(clk),
    .rst_n(rst_n)
	);

    e203_exu_fpu_fmis_sqrt u_e203_exu_fpu_fmis_sqrt(
	.fmis_sqrt_i_valid(fmis_sqrt_i_valid),
    .fmis_sqrt_i_ready(fmis_sqrt_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_sqrt_o_valid(fmis_sqrt_o_valid),
    .fmis_sqrt_o_ready(fmis_sqrt_o_ready),
    .fmis_sqrt_o_wbck_wdat(fmis_sqrt_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);	

    e203_exu_fpu_fmis_class u_e203_exu_fpu_fmis_class(
	.fmis_class_i_valid(fmis_class_i_valid),
    .fmis_class_i_ready(fmis_class_i_ready),
    .fmis_i_rs1(fmis_i_rs1),
    .fmis_class_o_valid(fmis_class_o_valid),
    .fmis_class_o_ready(fmis_class_o_ready),
    .fmis_class_o_wbck_wdat(fmis_class_o_wbck_wdat),
    .clk(clk),
    .rst_n(rst_n)
	);	
endmodule

`include "e203_defines.v"

module tb_top();

  reg  clk;
  reg  lfextclk;
  reg  rst_n;

  wire hfclk = clk;

  `define CPU_TOP u_e203_soc_top.u_e203_subsys_top.u_e203_subsys_main.u_e203_cpu_top
  `define EXU `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_exu
  `define IFU `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu
  `define ITCM `CPU_TOP.u_e203_srams.u_e203_itcm_ram.u_e203_itcm_gnrl_ram.u_sirv_sim_ram

  `define PC_WRITE_TOHOST       `E203_PC_SIZE'h80000086
  `define PC_EXT_IRQ_BEFOR_MRET `E203_PC_SIZE'h800000a6
  `define PC_SFT_IRQ_BEFOR_MRET `E203_PC_SIZE'h800000be
  `define PC_TMR_IRQ_BEFOR_MRET `E203_PC_SIZE'h800000d6
  `define PC_AFTER_SETMTVEC     `E203_PC_SIZE'h8000015C

  
//  wire [`E203_XLEN-1:0] x1 = `EXU.u_e203_exu_regfile.rf_r[1];
//  wire [`E203_XLEN-1:0] x2 = `EXU.u_e203_exu_regfile.rf_r[2];
 // wire [`E203_XLEN-1:0] x3 = `EXU.u_e203_exu_regfile.rf_r[3];
//  wire [`E203_XLEN-1:0] x4 = `EXU.u_e203_exu_regfile.rf_r[4];
//  wire [`E203_XLEN-1:0] x5 = `EXU.u_e203_exu_regfile.rf_r[5];
//  wire [`E203_XLEN-1:0] x6 = `EXU.u_e203_exu_regfile.rf_r[6];
//  wire [`E203_XLEN-1:0] x7 = `EXU.u_e203_exu_regfile.rf_r[7];
//  wire [`E203_XLEN-1:0] x8 = `EXU.u_e203_exu_regfile.rf_r[8];
//  wire [`E203_XLEN-1:0] x9 = `EXU.u_e203_exu_regfile.rf_r[9];
//  wire [`E203_XLEN-1:0] x0 = `EXU.u_e203_exu_regfile.rf_r[0];
//  wire [`E203_XLEN-1:0] x10 = `EXU.u_e203_exu_regfile.rf_r[10];
  wire [`E203_XLEN-1:0] x3 = `EXU.u_e203_exu_regfile.rf_r[3];
   wire [`E203_XLEN-1:0] f0 = `EXU.u_e203_exu_fpu_regfile.rf_r[0];
  wire [`E203_XLEN-1:0] f1 = `EXU.u_e203_exu_fpu_regfile.rf_r[1];
  wire [`E203_XLEN-1:0] f2 = `EXU.u_e203_exu_fpu_regfile.rf_r[2];
  wire [`E203_XLEN-1:0] f3 = `EXU.u_e203_exu_fpu_regfile.rf_r[3];
  wire [`E203_XLEN-1:0] f4 = `EXU.u_e203_exu_fpu_regfile.rf_r[4];
  wire [`E203_XLEN-1:0] f5 = `EXU.u_e203_exu_fpu_regfile.rf_r[5];
  wire [`E203_XLEN-1:0] f6 = `EXU.u_e203_exu_fpu_regfile.rf_r[6];
  wire [`E203_XLEN-1:0] f7 = `EXU.u_e203_exu_fpu_regfile.rf_r[7];
  wire [`E203_XLEN-1:0] f8 = `EXU.u_e203_exu_fpu_regfile.rf_r[8];
  wire [`E203_XLEN-1:0] f9 = `EXU.u_e203_exu_fpu_regfile.rf_r[9];
  wire [`E203_XLEN-1:0] f0 = `EXU.u_e203_exu_fpu_regfile.rf_r[0];
  wire [`E203_XLEN-1:0] f10 = `EXU.u_e203_exu_fpu_regfile.rf_r[10];
  wire [`E203_XLEN-1:0] f11 = `EXU.u_e203_exu_fpu_regfile.rf_r[11];
  wire [`E203_XLEN-1:0] f12 = `EXU.u_e203_exu_fpu_regfile.rf_r[12];
  wire [`E203_XLEN-1:0] f13 = `EXU.u_e203_exu_fpu_regfile.rf_r[13];
    wire [`E203_XLEN-1:0] f14 = `EXU.u_e203_exu_fpu_regfile.rf_r[14];
      wire [`E203_XLEN-1:0] f15 = `EXU.u_e203_exu_fpu_regfile.rf_r[15];
//    wire [`E203_XLEN-1:0] x1_wen = `EXU.u_e203_exu_regfile.rf_wen[1];
//  wire [`E203_XLEN-1:0] x2_wen = `EXU.u_e203_exu_regfile.rf_wen[2];
//  wire [`E203_XLEN-1:0] x3_wen = `EXU.u_e203_exu_regfile.rf_wen[3];
//  wire [`E203_XLEN-1:0] x4_wen = `EXU.u_e203_exu_regfile.rf_wen[4];
//  wire [`E203_XLEN-1:0] x5_wen = `EXU.u_e203_exu_regfile.rf_wen[5];
//  wire [`E203_XLEN-1:0] x6_wen = `EXU.u_e203_exu_regfile.rf_wen[6];
//  wire [`E203_XLEN-1:0] x7_wen = `EXU.u_e203_exu_regfile.rf_wen[7];
//  wire [`E203_XLEN-1:0] x8_wen = `EXU.u_e203_exu_regfile.rf_wen[8];
//  wire [`E203_XLEN-1:0] x9_wen = `EXU.u_e203_exu_regfile.rf_wen[9];
//  wire [`E203_XLEN-1:0] x0_wen = `EXU.u_e203_exu_regfile.rf_wen[0];
//  wire [`E203_XLEN-1:0] x10_wen = `EXU.u_e203_exu_regfile.rf_wen[10];
wire [`E203_XLEN-1:0] f0_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[0];
  wire [`E203_XLEN-1:0] f1_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[1];
  wire [`E203_XLEN-1:0] f2_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[2];
  wire [`E203_XLEN-1:0] f3_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[3];
  wire [`E203_XLEN-1:0] f4_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[4];
  wire [`E203_XLEN-1:0] f5_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[5];
  wire [`E203_XLEN-1:0] f6_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[6];
  wire [`E203_XLEN-1:0] f7_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[7];
  wire [`E203_XLEN-1:0] f8_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[8];
  wire [`E203_XLEN-1:0] f9_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[9];
  wire [`E203_XLEN-1:0] f0_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[0];
  wire [`E203_XLEN-1:0] f10_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[10];
  wire [`E203_XLEN-1:0] f11_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[11];
  wire [`E203_XLEN-1:0] f12_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[12];
  wire [`E203_XLEN-1:0] f13_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[13];
wire [`E203_XLEN-1:0] f14_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[14];
wire [`E203_XLEN-1:0] f15_wen = `EXU.u_e203_exu_fpu_regfile.rf_wen[15];
//wire rv32_load_fp = `EXU.u_e203_exu_decode.rv32_load_fp;
//wire rv32_fr4 =      `EXU.u_e203_exu_decode.rv32_fr4;
wire rv32_fadds =   `EXU.u_e203_exu_decode.rv32_fadds;
wire rv32_fdivs =   `EXU.u_e203_exu_decode.rv32_fdivs;
wire rv32_fsqrts =   `EXU.u_e203_exu_decode.rv32_fsqrts;
wire longp_wbck_o_rdfpu  = `EXU.longp_wbck_o_rdfpu;
//wire rv32_fsubs =    `EXU.u_e203_exu_decode.rv32_fsubs  ;
//wire rv32_fmuls =   `EXU.u_e203_exu_decode.rv32_fmuls  ;
//wire rv32_fdivs =  `EXU.u_e203_exu_decode.rv32_fdivs  ;
//wire rv32_fsqrts =  `EXU.u_e203_exu_decode.rv32_fsqrts ;
//wire rv32_fsgnjs  = `EXU.u_e203_exu_decode.rv32_fsgnjs ;
//wire rv32_fsgnjns = `EXU.u_e203_exu_decode.rv32_fsgnjns;
//wire rv32_fsgnjxs = `EXU.u_e203_exu_decode.rv32_fsgnjxs;
//wire rv32_fmins   = `EXU.u_e203_exu_decode.rv32_fmins  ;
//wire rv32_fmaxs   = `EXU.u_e203_exu_decode.rv32_fmaxs  ;
//wire rv32_fmvxw = `EXU.u_e203_exu_decode.rv32_fmvxw;
//wire rv32_fcvtsw  = `EXU.u_e203_exu_decode.rv32_fcvtsw ;
//wire rv32_fcvtswu = `EXU.u_e203_exu_decode.rv32_fcvtswu;
//wire rv32_fmvwx   = `EXU.u_e203_exu_decode.rv32_fmvwx  ;
wire alu_op = `EXU.u_e203_exu_decode.alu_op;
wire amoldst_op = `EXU.u_e203_exu_decode.amoldst_op;
wire bjp_op = `EXU.u_e203_exu_decode.bjp_op;
wire csr_op = `EXU.u_e203_exu_decode.csr_op;
wire muldiv_op = `EXU.u_e203_exu_decode.muldiv_op;
wire fmac_op = `EXU.u_e203_exu_decode.fmac_op;
wire fmis_op = `EXU.u_e203_exu_decode.fmis_op;

wire rv_all0s1s_ilgl =`EXU.u_e203_exu_decode.rv_all0s1s_ilgl;
wire rv_index_ilgl=`EXU.u_e203_exu_decode.rv_index_ilgl;
wire rv16_addi16sp_ilgl=`EXU.u_e203_exu_decode.rv16_addi16sp_ilgl;
wire rv16_addi4spn_ilgl=`EXU.u_e203_exu_decode.rv16_addi4spn_ilgl;
wire rv16_li_lui_ilgl=`EXU.u_e203_exu_decode.rv16_li_lui_ilgl;
wire rv16_sxxi_shamt_ilgl=`EXU.u_e203_exu_decode.rv16_sxxi_shamt_ilgl;
wire rv32_sxxi_shamt_ilgl=`EXU.u_e203_exu_decode.rv32_sxxi_shamt_ilgl;
wire rv32_dret_ilgl=`EXU.u_e203_exu_decode.rv32_dret_ilgl;
wire rv16_lwsp_ilgl=`EXU.u_e203_exu_decode.rv16_lwsp_ilgl;
wire legl_ops=`EXU.u_e203_exu_decode.legl_ops;

  wire [4:0] rf_wbck_rdidx = `EXU.u_e203_exu_wbck.rf_wbck_o_rdidx;
  wire [31:0] rf_wbck_wdat = `EXU.u_e203_exu_wbck.rf_wbck_o_wdat;
  wire [31:0] wbck_sel_alu = `EXU.u_e203_exu_wbck.wbck_sel_alu;
  wire [31:0] longp_wbck_i_valid = `EXU.u_e203_exu_wbck.longp_wbck_i_valid;
  wire [4:0] dec_fpu_rdfpu = `EXU.u_e203_exu_decode.dec_fpu_rdfpu;
  
  wire [`E203_PC_SIZE-1:0] pc = `EXU.u_e203_exu_commit.alu_cmt_i_pc;
  wire [`E203_PC_SIZE-1:0] pc_vld = `EXU.u_e203_exu_commit.alu_cmt_i_valid;

  reg [31:0] pc_write_to_host_cnt;
  reg [31:0] pc_write_to_host_cycle;
  reg [31:0] valid_ir_cycle;
  reg [31:0] cycle_count;
  reg pc_write_to_host_flag;

  always @(posedge hfclk or negedge rst_n)
  begin 
    if(rst_n == 1'b0) begin
        pc_write_to_host_cnt <= 32'b0;
        pc_write_to_host_flag <= 1'b0;
        pc_write_to_host_cycle <= 32'b0;
    end
    else if (pc_vld & (pc == `PC_WRITE_TOHOST)) begin
        pc_write_to_host_cnt <= pc_write_to_host_cnt + 1'b1;
        pc_write_to_host_flag <= 1'b1;
        if (pc_write_to_host_flag == 1'b0) begin
            pc_write_to_host_cycle <= cycle_count;
        end
    end
  end

  always @(posedge hfclk or negedge rst_n)
  begin 
    if(rst_n == 1'b0) begin
        cycle_count <= 32'b0;
    end
    else begin
        cycle_count <= cycle_count + 1'b1;
    end
  end

  wire i_valid = `EXU.i_valid;
  wire ifu_o_buserr = `IFU.u_e203_ifu_ifetch.ifu_o_buserr;
   wire ifu_o_misalgn = `IFU.u_e203_ifu_ifetch.ifu_o_misalgn;
    wire ir_valid_set = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.ir_valid_set;
    wire ifu_rsp_hsked = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.ifu_rsp_hsked;
    wire pipe_flush_req_real = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.pipe_flush_req_real;
    wire ifu_rsp_need_replay = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.ifu_rsp_need_replay;
    wire ifu_rsp_valid = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.ifu_rsp_valid;
    wire ifu_rsp_ready = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.ifu_rsp_ready;
     wire bpu_wait = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_litebpu.bpu_wait;
      wire dec_i_valid = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_litebpu.dec_i_valid;
       wire dec_jalr = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_litebpu.dec_jalr;
        wire dec_jalr_rs1x1 = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_litebpu.dec_jalr_rs1x1;
         wire jalr_rs1idx_cam_irrdidx = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_litebpu.jalr_rs1idx_cam_irrdidx;
          wire dec_jalr_rs1idx = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_minidec.dec_jalr_rs1idx;
          wire [31:0] instr = `CPU_TOP.u_e203_cpu.u_e203_core.u_e203_ifu.u_e203_ifu_ifetch.u_e203_ifu_minidec.instr;
          wire [31:0] fmac_i_rs1=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_i_rs1;
          wire [31:0] fmac_i_rs2=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_i_rs2;
           wire [31:0] fmac_i_rs3=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_i_rs3;
          wire [31:0] fmis_i_rs1=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmis.fmis_i_rs1;
          wire [31:0] fmis_i_rs2=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmis.fmis_i_rs2;
          wire [31:0] fmac_lt_o_wbck_wdat=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_lt_o_wbck_wdat;
          wire [31:0] fmac_o_wbck_wdat=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_o_wbck_wdat;
            wire [31:0] wbck_o_wdat=`EXU.u_e203_exu_alu.wbck_o_wdat;
          wire i_fadd = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fadd;
           wire i_fdiv = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fdiv;
           wire i_fsub = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fsub;
           wire i_fmul = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fmul;
           wire i_fmadd = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fmadd;
           wire i_feq = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_feq;
           wire i_flt = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_flt;
           wire i_fle = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fle;
           
          wire fmac_o_valid = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_o_valid;
          wire fmac_as_o_valid = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_as_o_valid;
          wire fmac_div_o_valid = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_div_o_valid;
          wire s_output_z = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.u_e203_exu_fpu_fmac_div.s_output_z;
wire i_fsub = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fsub;
wire i_fmul = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fmul;
wire i_fmadd = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fmadd;
wire fmac_mmnn_i_valid = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_mmnn_i_valid;
wire fmac_mmnn_i_ready = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_mmnn_i_ready;
wire fmac_mmnn_o_valid = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_mmnn_o_valid;
wire fmac_mmnn_o_ready = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_mmnn_o_ready;

wire i_fnmadd = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.i_fnmadd;
wire fmac_mmnn_o_wbck_wdat = `EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.fmac_mmnn_o_wbck_wdat;
wire o_valid = `EXU.u_e203_exu_alu.o_valid;
wire wbck_o_valid=`EXU.u_e203_exu_alu.wbck_o_valid;
          wire [3:0] state=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.u_e203_exu_fpu_fmac_div.state;
           wire [3:0] state_fmmnn=`EXU.u_e203_exu_alu.u_e203_exu_fpu_fmac.u_e203_exu_fpu_fmac_madd_msub_nmadd_nmsub.state;
         wire [2:0] E203_DECINFO_GRP=`EXU.u_e203_exu_alu.i_info[`E203_DECINFO_GRP];
   wire [2:0] E203_DECINFO_FPU_GRP=`EXU.u_e203_exu_alu.i_info[`E203_DECINFO_FPU_GRP];
   wire ifu_excp_op=`EXU.u_e203_exu_alu.ifu_excp_op;
   wire i_ilegl=`EXU.u_e203_exu_alu.i_ilegl;
   wire i_buserr=`EXU.u_e203_exu_alu.i_buserr;
    wire i_misalgn=`EXU.u_e203_exu_alu.i_misalgn;
  
  wire i_ready = `EXU.i_ready;
  wire [31:0] zhiling = `EXU.i_ir;
  wire [31:0] rd_f = `EXU.u_e203_exu_fpu_regfile.rf_r[zhiling[11:7]];
  always @(posedge hfclk or negedge rst_n)
  begin 
    if(rst_n == 1'b0) begin
        valid_ir_cycle <= 32'b0;
    end
    else if(i_valid & i_ready & (pc_write_to_host_flag == 1'b0)) begin
        valid_ir_cycle <= valid_ir_cycle + 1'b1;
    end
  end


  // Randomly force the external interrupt
  `define EXT_IRQ u_e203_soc_top.u_e203_subsys_top.u_e203_subsys_main.plic_ext_irq
  `define SFT_IRQ u_e203_soc_top.u_e203_subsys_top.u_e203_subsys_main.clint_sft_irq
  `define TMR_IRQ u_e203_soc_top.u_e203_subsys_top.u_e203_subsys_main.clint_tmr_irq

  `define U_CPU u_e203_soc_top.u_e203_subsys_top.u_e203_subsys_main.u_e203_cpu_top.u_e203_cpu
  `define ITCM_BUS_ERR `U_CPU.u_e203_itcm_ctrl.sram_icb_rsp_err
  `define ITCM_BUS_READ `U_CPU.u_e203_itcm_ctrl.sram_icb_rsp_read
  `define STATUS_MIE   `U_CPU.u_e203_core.u_e203_exu.u_e203_exu_commit.u_e203_exu_excp.status_mie_r

  wire stop_assert_irq = (pc_write_to_host_cnt > 32);

  reg tb_itcm_bus_err;

  reg tb_ext_irq;
  reg tb_tmr_irq;
  reg tb_sft_irq;
  initial begin
    tb_ext_irq = 1'b0;
    tb_tmr_irq = 1'b0;
    tb_sft_irq = 1'b0;
  end

`ifdef ENABLE_TB_FORCE
  initial begin
    tb_itcm_bus_err = 1'b0;
    #100
    @(pc == `PC_AFTER_SETMTVEC ) // Wait the program goes out the reset_vector program
    forever begin
      repeat ($urandom_range(1, 20)) @(posedge clk) tb_itcm_bus_err = 1'b0; // Wait random times
      repeat ($urandom_range(1, 200)) @(posedge clk) tb_itcm_bus_err = 1'b1; // Wait random times
      if(stop_assert_irq) begin
          break;
      end
    end
  end


  initial begin
    force `EXT_IRQ = tb_ext_irq;
    force `SFT_IRQ = tb_sft_irq;
    force `TMR_IRQ = tb_tmr_irq;
       // We force the bus-error only when:
       //   It is in common code, not in exception code, by checking MIE bit
       //   It is in read operation, not write, otherwise the test cannot recover
    force `ITCM_BUS_ERR = tb_itcm_bus_err
                        & `STATUS_MIE 
                        & `ITCM_BUS_READ
                        ;
  end


  initial begin
    #100
    @(pc == `PC_AFTER_SETMTVEC ) // Wait the program goes out the reset_vector program
    forever begin
      repeat ($urandom_range(1, 1000)) @(posedge clk) tb_ext_irq = 1'b0; // Wait random times
      tb_ext_irq = 1'b1; // assert the irq
      @((pc == `PC_EXT_IRQ_BEFOR_MRET)) // Wait the program run into the IRQ handler by check PC values
      tb_ext_irq = 1'b0;
      if(stop_assert_irq) begin
          break;
      end
    end
  end

  initial begin
    #100
    @(pc == `PC_AFTER_SETMTVEC ) // Wait the program goes out the reset_vector program
    forever begin
      repeat ($urandom_range(1, 1000)) @(posedge clk) tb_sft_irq = 1'b0; // Wait random times
      tb_sft_irq = 1'b1; // assert the irq
      @((pc == `PC_SFT_IRQ_BEFOR_MRET)) // Wait the program run into the IRQ handler by check PC values
      tb_sft_irq = 1'b0;
      if(stop_assert_irq) begin
          break;
      end
    end
  end

  initial begin
    #100
    @(pc == `PC_AFTER_SETMTVEC ) // Wait the program goes out the reset_vector program
    forever begin
      repeat ($urandom_range(1, 1000)) @(posedge clk) tb_tmr_irq = 1'b0; // Wait random times
      tb_tmr_irq = 1'b1; // assert the irq
      @((pc == `PC_TMR_IRQ_BEFOR_MRET)) // Wait the program run into the IRQ handler by check PC values
      tb_tmr_irq = 1'b0;
      if(stop_assert_irq) begin
          break;
      end
    end
  end
`endif

  reg[8*300:1] testcase;
  integer dumpwave;

  initial begin
    $display("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");  
    if($value$plusargs("TESTCASE=%s",testcase))begin
      $display("TESTCASE=%s",testcase);
    end

    pc_write_to_host_flag <=0;
    clk   <=0;
    lfextclk   <=0;
    rst_n <=0;
    #120 rst_n <=1;

    @(pc_write_to_host_cnt == 32'd8) #10 rst_n <=1;
`ifdef ENABLE_TB_FORCE
    @((~tb_tmr_irq) & (~tb_sft_irq) & (~tb_ext_irq)) #10 rst_n <=1;// Wait the interrupt to complete
`endif

        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~ Test Result Summary ~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~TESTCASE: %s ~~~~~~~~~~~~~", testcase);
        $display("~~~~~~~~~~~~~~Total cycle_count value: %d ~~~~~~~~~~~~~", cycle_count);
        $display("~~~~~~~~~~The valid Instruction Count: %d ~~~~~~~~~~~~~", valid_ir_cycle);
        $display("~~~~~The test ending reached at cycle: %d ~~~~~~~~~~~~~", pc_write_to_host_cycle);
        $display("~~~~~~~~~~~~~~~The final x3 Reg value: %d ~~~~~~~~~~~~~", x3);
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    if (x3 == 1) begin
        $display("~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    end
    else begin
        $display("~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~~~~~~~");
        $display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    end
    #10
     $finish;
  end

  initial begin
    #400000000
        $display("Time Out !!!");
     $finish;
  end

  always
  begin 
     #6 clk <= ~clk;
  end

  always
  begin 
     #33 lfextclk <= ~lfextclk;
  end



  
  
  initial begin
    if($value$plusargs("DUMPWAVE=%d",dumpwave)) begin
      if(dumpwave != 0) begin

	 `ifdef vcs
            $display("VCS used");
            $fsdbDumpfile("tb_top.fsdb");
            $fsdbDumpvars(0, tb_top, "+mda");
         `endif

	 `ifdef iverilog
            $display("iverlog used");
	    $dumpfile("tb_top.vcd");
            $dumpvars(0, tb_top);
         `endif
      end
    end
  end




  integer i;

    reg [7:0] itcm_mem [0:(`E203_ITCM_RAM_DP*8)-1];
    initial begin
      $readmemh({"D:\\Desktop\\test\\Hello_world.verilog"}, itcm_mem);

      for (i=0;i<(`E203_ITCM_RAM_DP);i=i+1) begin
          `ITCM.mem_r[i][00+7:00] = itcm_mem[i*8+0];
          `ITCM.mem_r[i][08+7:08] = itcm_mem[i*8+1];
          `ITCM.mem_r[i][16+7:16] = itcm_mem[i*8+2];
          `ITCM.mem_r[i][24+7:24] = itcm_mem[i*8+3];
          `ITCM.mem_r[i][32+7:32] = itcm_mem[i*8+4];
          `ITCM.mem_r[i][40+7:40] = itcm_mem[i*8+5];
          `ITCM.mem_r[i][48+7:48] = itcm_mem[i*8+6];
          `ITCM.mem_r[i][56+7:56] = itcm_mem[i*8+7];
      end

        $display("ITCM 0x00: %h", `ITCM.mem_r[8'h00]);
        $display("ITCM 0x01: %h", `ITCM.mem_r[8'h01]);
        $display("ITCM 0x02: %h", `ITCM.mem_r[8'h02]);
        $display("ITCM 0x03: %h", `ITCM.mem_r[8'h03]);
        $display("ITCM 0x04: %h", `ITCM.mem_r[8'h04]);
        $display("ITCM 0x05: %h", `ITCM.mem_r[8'h05]);
        $display("ITCM 0x06: %h", `ITCM.mem_r[8'h06]);
        $display("ITCM 0x07: %h", `ITCM.mem_r[8'h07]);
        $display("ITCM 0x16: %h", `ITCM.mem_r[8'h16]);
        $display("ITCM 0x20: %h", `ITCM.mem_r[8'h20]);

    end 



  wire jtag_TDI = 1'b0;
  wire jtag_TDO;
  wire jtag_TCK = 1'b0;
  wire jtag_TMS = 1'b0;
  wire jtag_TRST = 1'b0;

  wire jtag_DRV_TDO = 1'b0;


e203_soc_top u_e203_soc_top(
   
   .hfextclk(hfclk),
   .hfxoscen(),

   .lfextclk(lfextclk),
   .lfxoscen(),

   .io_pads_jtag_TCK_i_ival (jtag_TCK),
   .io_pads_jtag_TMS_i_ival (jtag_TMS),
   .io_pads_jtag_TDI_i_ival (jtag_TDI),
   .io_pads_jtag_TDO_o_oval (jtag_TDO),
   .io_pads_jtag_TDO_o_oe (),

   .io_pads_gpioA_i_ival(32'b0),
   .io_pads_gpioA_o_oval(),
   .io_pads_gpioA_o_oe  (),

   .io_pads_gpioB_i_ival(32'b0),
   .io_pads_gpioB_o_oval(),
   .io_pads_gpioB_o_oe  (),

   .io_pads_qspi0_sck_o_oval (),
   .io_pads_qspi0_cs_0_o_oval(),
   .io_pads_qspi0_dq_0_i_ival(1'b1),
   .io_pads_qspi0_dq_0_o_oval(),
   .io_pads_qspi0_dq_0_o_oe  (),
   .io_pads_qspi0_dq_1_i_ival(1'b1),
   .io_pads_qspi0_dq_1_o_oval(),
   .io_pads_qspi0_dq_1_o_oe  (),
   .io_pads_qspi0_dq_2_i_ival(1'b1),
   .io_pads_qspi0_dq_2_o_oval(),
   .io_pads_qspi0_dq_2_o_oe  (),
   .io_pads_qspi0_dq_3_i_ival(1'b1),
   .io_pads_qspi0_dq_3_o_oval(),
   .io_pads_qspi0_dq_3_o_oe  (),

   .io_pads_aon_erst_n_i_ival (rst_n),//This is the real reset, active low
   .io_pads_aon_pmu_dwakeup_n_i_ival (1'b1),

   .io_pads_aon_pmu_vddpaden_o_oval (),
    .io_pads_aon_pmu_padrst_o_oval    (),

    .io_pads_bootrom_n_i_ival       (1'b0),// In Simulation we boot from ROM
    .io_pads_dbgmode0_n_i_ival       (1'b1),
    .io_pads_dbgmode1_n_i_ival       (1'b1),
    .io_pads_dbgmode2_n_i_ival       (1'b1) 
);


endmodule



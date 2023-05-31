module e203_exu_fpu_fmis_sqrt(
    input fmis_sqrt_i_valid, // Handshake valid
    output fmis_sqrt_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    output fmis_sqrt_o_valid, // Handshake valid
    input  fmis_sqrt_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmis_sqrt_o_wbck_wdat
    );
    wire[31:0] a = fmis_i_rs1;
    reg output_stb=0;
    wire s = a[31];
    wire [7:0] e = a[30:23];
    wire [9:0] key = a[23:14];
    wire [13:0] ml = a[13:0];
    wire [22:0] c1;
    wire [12:0] g1;
    reg [13:0] ml1;
    wire odd = (e[0] == 1) ? 1 : 0;
    reg odd1;
    wire [8:0] bei = e + 8'd127;
    wire [7:0] be = odd ? bei>>1 : (bei - 1)>>1;
    reg [7:0] be1;
    fsqrt_const_table u1 (clk, key, c1);
    fsqrt_grad_table u2 (clk, key, g1);
    
    wire [36:0] gm = g1 * ml1;
    wire [22:0] bm = odd1 ? c1 + (gm >> 14) : c1 + (gm >> 13);
    reg state=0;
    always @(posedge clk) begin
        case (state)
            0:  
                begin
                    output_stb <=0;
                    if (fmis_sqrt_i_valid) begin
                        state <= 1;
                    end
                end
            1: 
                begin
                    ml1 <= ml;
                    be1 <= be;
                    odd1 <= odd;   
                    output_stb <=1;
                    state <= 0;  
                end
            default : state <=0;
        endcase
    end
    wire wbck_condi = fmis_sqrt_i_valid & output_stb; 
    assign fmis_sqrt_o_valid = wbck_condi & fmis_sqrt_i_valid;
    assign fmis_sqrt_i_ready = wbck_condi & fmis_sqrt_o_ready;
    assign fmis_sqrt_o_wbck_wdat = (s == 1) ? 0 : {1'b0, be1, bm};
endmodule

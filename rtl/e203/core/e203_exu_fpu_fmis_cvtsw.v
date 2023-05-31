//Integer to IEEE Floating Point Converter (Single Precision)
//Copyright (C) Jonathan P Dawson 2013
//2013-12-12
module e203_exu_fpu_fmis_cvtsw(
    input fmis_cvtsw_i_valid, // Handshake valid
    output fmis_cvtsw_i_ready, // Handshake ready
    input [31:0] fmis_i_rs1,
    output fmis_cvtsw_o_valid, // Handshake valid
    input  fmis_cvtsw_o_ready, // Handshake ready
    input flag,
    input clk,
    input rst_n,
    output [31:0] fmis_cvtsw_o_wbck_wdat);

  reg       input_a_stb=0;
  reg       s_output_z_stb=0;
  reg       [31:0] s_output_z;

  reg       [2:0] state;
  parameter get_a         = 3'd0,
            convert_0     = 3'd1,
            convert_1     = 3'd2,
            convert_2     = 3'd3,
            round         = 3'd4,
            pack          = 3'd5,
            put_z         = 3'd6;

  reg [31:0] a, z, value;
  reg [23:0] z_m;
  reg [7:0] z_r;
  reg [7:0] z_e;
  reg z_s;
  reg guard, round_bit, sticky;

  wire wbck_condi = s_output_z_stb;
  assign fmis_cvtsw_o_valid = wbck_condi & fmis_cvtsw_i_valid;
  assign fmis_cvtsw_i_ready = wbck_condi & fmis_cvtsw_o_ready;
  always @(posedge clk)
  begin
    case(state)

      get_a:
      begin
          s_output_z_stb <=0;
          if (fmis_cvtsw_i_valid) begin
              input_a_stb <= 1;
          end

          if (input_a_stb & fmis_cvtsw_i_valid) begin
            a <= fmis_i_rs1;
            state <= convert_0;
            input_a_stb <=0;
          end
      end

      convert_0:
      begin
        if ( a == 0 ) begin
          z_s <= 0;
          z_m <= 0;
          z_e <= -127;
          state <= pack;
        end else begin
          value <= flag ? a : (a[31] ? -a : a);
          z_s <=flag ? 1'b0 : a[31];
          state <= convert_1;
        end
      end

      convert_1:
      begin
        z_e <= 31;
        z_m <= value[31:8];
        z_r <= value[7:0];
        state <= convert_2;
      end

      convert_2:
      begin
        if (!z_m[23]) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= z_r[7];
          z_r <= z_r << 1;
        end else begin
          guard <= z_r[7];
          round_bit <= z_r[6];
          sticky <= z_r[5:0] != 0;
          state <= round;
        end
      end

      round:
      begin
        if (guard && (round_bit || sticky || z_m[0])) begin
          z_m <= z_m + 1;
          if (z_m == 24'hffffff) begin
            z_e <=z_e + 1;
          end
        end
        state <= pack;
      end

      pack:
      begin
        z[22 : 0] <= z_m[22:0];
        z[30 : 23] <= z_e + 127;
        z[31] <= z_s;
        state <= put_z;
      end

      put_z:
      begin
        s_output_z_stb <=1;
        s_output_z <= z;
        state <= get_a;
      end
      default:
      begin
        state <= get_a;
      end

    endcase


  end
  assign fmis_cvtsw_o_wbck_wdat = s_output_z;

endmodule


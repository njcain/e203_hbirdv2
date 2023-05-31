//IEEE Floating Point Multiplier (Single Precision)
//Copyright (C) Jonathan P Dawson 2013
//2013-12-12

module e203_exu_fpu_fmac_madd_msub_nmadd_nmsub(
    input fmac_mmnn_i_valid, // Handshake valid
    output fmac_mmnn_i_ready, // Handshake ready
    input [31:0] fmac_i_rs1,
    input [31:0] fmac_i_rs2,
    input [31:0] fmac_i_rs3,
    output fmac_mmnn_o_valid, // Handshake valid
    input  fmac_mmnn_o_ready, // Handshake ready
    input clk,
    input rst_n,
    output [31:0] fmac_mmnn_o_wbck_wdat
);

  reg       [4:0] state = 0 ;

  parameter get_aby         = 5'd0,
            unpack        = 5'd1,
            special_cases = 5'd2,
            normalise_a   = 5'd3,
            normalise_b   = 5'd4,
            multiply_0    = 5'd5,
            multiply_1    = 5'd6,
            normalise_1   = 5'd7,
            normalise_2   = 5'd8,
            round         = 5'd9,
            pack          = 5'd10,
            put_z         = 5'd11,
            start         = 5'd12,
            zerock        = 5'd13,
            exequal       = 5'd14,
            addm          = 5'd15,
            infifl        = 5'd16,
            over          = 5'd17;

  reg       [31:0] a, b, x, y, z;
  reg       [23:0] a_m, b_m, z_m;
  reg       [9:0] a_e, b_e, z_e;
  reg       a_s, b_s, z_s;
  reg       guard, round_bit, sticky;
  reg       [47:0] product;
  reg[24:0] xm, ym, zm; //尾数部分, 0+ 1+[22:0]，
  reg[7:0] xe, ye, ze;  //阶码部分
  reg zsign; //z的符号位

  reg input_aby_stb=0;
  reg final_cycle=0;
  wire wbck_condi = final_cycle;
  assign fmac_mmnn_o_valid = wbck_condi & fmac_mmnn_i_valid;
  assign fmac_mmnn_i_ready = wbck_condi & fmac_mmnn_o_ready;

  always @(posedge clk)
  begin
    case(state)
      get_aby:
      begin
          final_cycle <=0;
          if (fmac_mmnn_i_valid) begin
              input_aby_stb <= 1;
          end

          if (input_aby_stb & fmac_mmnn_i_valid) begin
            a <= fmac_i_rs1;
            b <= fmac_i_rs2;
            y <= fmac_i_rs3;
            state <= unpack;
            input_aby_stb <=0;
          end
      end

      unpack:
      begin
        a_m <= a[22 : 0];
        b_m <= b[22 : 0];
        a_e <= a[30 : 23] - 127;
        b_e <= b[30 : 23] - 127;
        a_s <= a[31];
        b_s <= b[31];
        state <= special_cases;
      end

      special_cases:
      begin
        //if a is NaN or b is NaN return NaN 
        if ((a_e == 128 && a_m != 0) || (b_e == 128 && b_m != 0)) begin
          z[31] <= 1;
          z[30:23] <= 255;
          z[22] <= 1;
          z[21:0] <= 0;
          state <= put_z;
        //if a is inf return inf
        end else if (a_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          //if b is zero return NaN
          if (($signed(b_e) == -127) && (b_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
          end
          state <= put_z;
        //if b is inf return inf
        end else if (b_e == 128) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 255;
          z[22:0] <= 0;
          //if a is zero return NaN
          if (($signed(a_e) == -127) && (a_m == 0)) begin
            z[31] <= 1;
            z[30:23] <= 255;
            z[22] <= 1;
            z[21:0] <= 0;
          end
          state <= put_z;
        //if a is zero return zero
        end else if (($signed(a_e) == -127) && (a_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
        //if b is zero return zero
        end else if (($signed(b_e) == -127) && (b_m == 0)) begin
          z[31] <= a_s ^ b_s;
          z[30:23] <= 0;
          z[22:0] <= 0;
          state <= put_z;
        end else begin
          //Denormalised Number
          if ($signed(a_e) == -127) begin
            a_e <= -126;
          end else begin
            a_m[23] <= 1;
          end
          //Denormalised Number
          if ($signed(b_e) == -127) begin
            b_e <= -126;
          end else begin
            b_m[23] <= 1;
          end
          state <= normalise_a;
        end
      end

      normalise_a:
      begin
        if (a_m[23]) begin
          state <= normalise_b;
        end else begin
          a_m <= a_m << 1;
          a_e <= a_e - 1;
        end
      end

      normalise_b:
      begin
        if (b_m[23]) begin
          state <= multiply_0;
        end else begin
          b_m <= b_m << 1;
          b_e <= b_e - 1;
        end
      end

      multiply_0:
      begin
        z_s <= a_s ^ b_s;
        z_e <= a_e + b_e + 1;
        product <= a_m * b_m;
        state <= multiply_1;
      end

      multiply_1:
      begin
        z_m <= product[47:24];
        guard <= product[23];
        round_bit <= product[22];
        sticky <= (product[21:0] != 0);
        state <= normalise_1;
      end

      normalise_1:
      begin
        if (z_m[23] == 0) begin
          z_e <= z_e - 1;
          z_m <= z_m << 1;
          z_m[0] <= guard;
          guard <= round_bit;
          round_bit <= 0;
        end else begin
          state <= normalise_2;
        end
      end

      normalise_2:
      begin
        if ($signed(z_e) < -126) begin
          z_e <= z_e + 1;
          z_m <= z_m >> 1;
          guard <= z_m[0];
          round_bit <= guard;
          sticky <= sticky | round_bit;
        end else begin
          state <= round;
        end
      end

      round:
      begin
        if (guard && (round_bit | sticky | z_m[0])) begin
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
        z[30 : 23] <= z_e[7:0] + 127;
        z[31] <= z_s;
        if ($signed(z_e) == -126 && z_m[23] == 0) begin
          z[30 : 23] <= 0;
        end
        //if overflow occurs, return inf
        if ($signed(z_e) > 127) begin
          z[22 : 0] <= 0;
          z[30 : 23] <= 255;
          z[31] <= z_s;
        end
        state <= put_z;
      end

      put_z:
      begin
        x <= z;
        state <= start;
        
      end

        start: //初始化，分离尾数和指数，调整符号位
		  begin
            xe <= x[30:23];
            xm <= {1'b0,1'b1,x[22:0]};
            ye <= y[30:23];
			ym <= {1'b0,1'b1,y[22:0]};
            state <= zerock;
		  end
		  zerock://检测x，y如果有一个为0，则跳转到over state
		  begin
		    if((x[22:0]==23'b0)&&(xe==8'b0))
			 begin
			   {zsign, ze,zm} <= {y[31],ye, ym};
				state <= over;
			 end
			 else
			 begin
				 if((y[22:0]==23'b0)&&(ye==8'b0))
				 begin
			      {zsign,ze,zm} <= {x[31],xe, xm};
				   state <= over;
				 end
				 else
				   state <= exequal;
			 end
		  end
		  exequal:
		  begin
		    if(xe == ye)
			   state <= addm;
			 else
			 begin
			   if(xe > ye)
				begin
				  ye <= ye + 1'b1;//阶码加1
				  ym[23:0] <= {1'b0, ym[23:1]};
				  if(ym==8'b0)
				  begin
				    zm <= xm;
					 ze <= xe;
					 zsign<=x[31];
					 state <= over;
				  end
				  else
				    state <= exequal;

				end
				else
				begin
				  xe <= xe + 1'b1;//阶码加1
				  xm[23:0] <= {1'b0, xm[23:1]};
				  if(xm==8'b0)
				  begin
				    zm <= ym;
					 ze <= ye;
					 zsign <= y[31];
					 state <= over;
				  end
				  else
				    state <= exequal;
				end
			 end

		  end
		  addm://尾数相加
		  begin
		    ze <= xe;

			 if((x[31]^y[31])==1'b0) //同符号
			 begin
			   zsign = x[31];
			   zm <= xm + ym;
			 end
			 else
			 begin
			   if(xm>ym)
				begin
			     zsign = x[31];
			     zm <= xm - ym;
				end
				else
				begin
			     zsign = y[31];
			     zm <= ym - xm;
				end

			 end

			 if(zm[23:0]==24'b0)
			   state <= over;
			 else
			   state <=infifl;
		  end
		  infifl://规格化处理
		  begin
		    if(zm[24]==1'b1)//有进位,或借位
			 begin
			   zm <= {1'b0,zm[24:1]};
            ze <= ze + 1'b1;
            state <= over;
			 end
			 else
			 begin
			   if(zm[23]==1'b0)
				begin
				  zm <= {zm[23:0],1'b0};
              ze <= ze - 1'b1;
              state <= infifl;
				end
				else
				begin
				  state <= over;
				end
			 end
		  end
          over:
		  begin
		    z <= {zsign, ze[7:0], zm[22:0]};
		    state <= get_aby;
            final_cycle <= 1;
	      end         
      default:
      begin
        state <= get_aby;
      end

    endcase
    
  end
  assign fmac_mmnn_o_wbck_wdat = z;

endmodule


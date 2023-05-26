`include "e203_defines.v"

module e203_exu_fpu_fmac_add_sub(
    // The Issue Handshake Interface to FMAC
    //
    input fmac_as_i_valid, // Handshake valid
    output fmac_as_i_ready, // Handshake ready
    input [`E203_XLEN-1:0] fmac_i_rs1,
    input [`E203_XLEN-1:0] fmac_i_rs2,

    // The FMAC Write-Back/Commit Interface
    output fmac_as_o_valid, // Handshake valid
    input  fmac_as_o_ready, // Handshake ready

    output [`E203_XLEN-1:0] fmac_as_o_wbck_wdat,

    output reg [1:0] overflow,

    input clk,
    input rst_n
);

    reg [31:0] z; // z=x+y 
    wire [31:0] x = fmac_i_rs1;
    wire [31:0] y = fmac_i_rs2;
    assign fmac_as_o_wbck_wdat = z;
	reg[24:0] xm, ym, zm; //尾数部分, 0+ 1+[22:0]，
	reg[7:0] xe, ye, ze;  //阶码部分
	
	reg zsign; //z的符号位
    assign fmac_o_wbck_err = 1'b0;
    reg       input_xy_stb=0;
	
    parameter start=3'b000,zerock=3'b001,exequal=3'b010,addm=3'b011,infifl=3'b100,over =3'b110;
    reg[2:0]	state = 0;       //状态机

    reg final_cycle=0;
    wire wbck_condi = final_cycle;
    assign fmac_as_o_valid = wbck_condi & fmac_as_i_valid;
    assign fmac_as_i_ready = wbck_condi & fmac_as_o_ready;


    // always@(state,nextstate,xe,ye,xm,ym,ze,zm) begin
	always@(posedge clk) begin
		  case(state)
		  start: //初始化，分离尾数和指数，调整符号位
		  begin
            final_cycle <=0;
            if (fmac_as_i_valid) begin
              input_xy_stb <= 1;
            end 

            if (input_xy_stb & fmac_as_i_valid) begin
                input_xy_stb <= 0;
                xe <= x[30:23];
                xm <= {1'b0,1'b1,x[22:0]};
                ye <= y[30:23];
			    ym <= {1'b0,1'b1,y[22:0]};
                
                //判断是否溢出，大于最大浮点数，小于最小浮点数
			    if((xe==8'd255)||(ye==8'd255)||((xe==8'd0)&&(xm[22:0]!=23'b0))||((ye==8'd0)&&(ym[22:0]!=23'b0)) )
			    begin
			       overflow <= 2'b11;
			    	state <= start; //直接到初始化
			    	 z <= 32'b1; //直接赋值最小非规约数，
			    end
			    else 
                   state <= zerock;
            end
		    

			    
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
			 //判断是否溢出，大于最大浮点数，小于最小浮点数
			 if(ze==8'd255 )
			 begin
			    overflow <= 2'b01;
			 end
			 else if((ze==8'd0)&&(zm[22:0]!=23'b0)) //不处理非规约数
			 begin
			    overflow <= 2'b10;
			 end
			 else
			    overflow <= 2'b00;
            
		    state <= start;
            final_cycle <= 1;
	     end
		  default:
		  begin
		    state <= start;
		  end
		endcase
	end

endmodule
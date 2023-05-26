
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/21 21:04:41
// Design Name: 
// Module Name: clk
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk(
input wire clk,
output reg ce=0
    );
reg[10:0] count=11'b0;
always @(negedge clk)
   begin
      if(count>=11'd1525)
			count<='d0;
      else
			count <= count + 1;          
    end
always @ (negedge clk )
    begin
        if(count >= 11'd763)
			ce <= 1'b1;
		else
			ce <= 1'b0;
	end
    
endmodule

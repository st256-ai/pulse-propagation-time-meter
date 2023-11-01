`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:42:06 10/31/2023 
// Design Name: 
// Module Name:    level_to_pulse_meely 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Level_to_pulse_meely(
	input i_Clk, 
	input i_In,
	
   output o_Out
	);
   reg r1, r2, r3;
	reg out = 0;
	
	reg [1:0] counter = 0;
	
	assign o_Out = !r2 && i_In;

	always @(posedge i_Clk) begin
		r1 <= i_In;
		r2 <= r1;
	end
	
	 
endmodule

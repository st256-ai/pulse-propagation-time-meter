`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:03:38 11/01/2023 
// Design Name: 
// Module Name:    Level_to_pulse_inverted 
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
module Level_to_pulse_inverted(
	input i_Clk, 
	input i_In,
	
   output o_Out
	);
   reg r1, r2, r3;

	assign o_Out = r2 && !i_In;

	always @(posedge i_Clk) begin
		r1 <= i_In;
		r2 <= r1;
	end


endmodule

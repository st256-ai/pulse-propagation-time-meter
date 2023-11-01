`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:59 11/01/2023 
// Design Name: 
// Module Name:    NEW_HOPE_TOP_MODULE 
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
module NEW_HOPE_TOP_MODULE(
	input i_Clk,
	input i_Rst_L,
	input i_Signal,
	
	output o_Impulse,
	output o_ready
    );

	 Generate_impulse_by_trigger generator1(
		.i_Clk(i_Clk),
		.i_Signal(i_Signal),
		.o_Impulse(o_Impulse),
		.o_ready(o_ready)
	 );

endmodule

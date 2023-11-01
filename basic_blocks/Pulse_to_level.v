`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:52:07 11/01/2023 
// Design Name: 
// Module Name:    Pulse_to_level 
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
module Pulse_to_level
#( parameter LEVEL = 0
)
(
	input i_Pulse,
	
	output o_Level
    );

	reg out = LEVEL;
	assign o_Level = out;

	always @(posedge i_Pulse) begin
		out <= !LEVEL;
	end

endmodule

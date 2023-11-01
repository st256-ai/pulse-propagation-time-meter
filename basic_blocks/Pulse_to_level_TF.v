`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:17:39 11/02/2023
// Design Name:   Pulse_to_level
// Module Name:   C:/Users/Bob/Documents/ISE labs/first/secondTryToRemember/Pulse_to_level_TF.v
// Project Name:  secondTryToRemember
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Pulse_to_level
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Pulse_to_level_TF;

	// Inputs
	reg i_level;
	reg i_Pulse;

	// Outputs
	wire o_Level;

	// Instantiate the Unit Under Test (UUT)
	Pulse_to_level uut (
		.i_Pulse(i_Pulse), 
		.o_Level(o_Level)
	);

	initial begin
		// Initialize Inputs
		i_level = 0;
		i_Pulse = 0;

		// Wait 100 ns for global reset to finish
		#100;
		i_Pulse = 1;
		#10;
		i_Pulse = 0;
		
		// Add stimulus here

	end
      
endmodule


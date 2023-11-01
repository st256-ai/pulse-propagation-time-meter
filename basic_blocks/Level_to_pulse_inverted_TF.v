`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:04:52 11/01/2023
// Design Name:   Level_to_pulse_inverted
// Module Name:   C:/Users/Bob/Documents/ISE labs/first/tryToRememberVerilog/Level_to_pulse_inverted_TF.v
// Project Name:  tryToRememberVerilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Level_to_pulse_inverted
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Level_to_pulse_inverted_TF;

	// Inputs
	reg i_Clk;
	reg i_In;

	// Outputs
	wire o_Out;

	// Instantiate the Unit Under Test (UUT)
	Level_to_pulse_inverted uut (
		.i_Clk(i_Clk), 
		.i_In(i_In), 
		.o_Out(o_Out)
	);
	
	parameter Tclk=20; // 50MHz
	always begin i_Clk=0; #(Tclk/2); i_Clk=1; #(Tclk/2); end

	initial begin
		// Initialize Inputs
		i_In = 0;
		#100;
		i_In = 1;
		#140;
		i_In = 0;
		
		
        
		// Add stimulus here

	end
      
endmodule


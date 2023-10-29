`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:58:17 10/13/2023
// Design Name:   Single_Impulse
// Module Name:   C:/Users/Bob/Documents/ISE labs/first/tryToRememberVerilog/Single_Impulse_TF.v
// Project Name:  tryToRememberVerilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Single_Impulse
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Single_Impulse_TF;

	// Inputs
	reg i_Clk;
	reg i_Rst_L;

	// Outputs
	wire o_impulse;
	wire o_ready;

	// Instantiate the Unit Under Test (UUT)
	Single_Impulse #(.DURATION_NS(150)) uut (
		.i_Clk(i_Clk), 
		.i_Rst_L(i_Rst_L), 
		.i_Enable(1),
		.o_impulse(o_impulse), 
		.o_ready(o_ready)
	);
	
	parameter Tclk=20; // 50MHz
	always begin i_Clk=0; #(Tclk/2); i_Clk=1; #(Tclk/2); end

	initial begin
		// Initialize Inputs
		i_Rst_L = 1;
		#100;
		i_Rst_L = 0;
		#190;
		i_Rst_L = 1;
		
		#190;
		i_Rst_L = 0;
		
		#190;
		i_Rst_L = 1;

	end
      
endmodule


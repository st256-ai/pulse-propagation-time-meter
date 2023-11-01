`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:46:48 11/01/2023
// Design Name:   NEW_HOPE_TOP_MODULE
// Module Name:   C:/Users/Bob/Documents/ISE labs/first/secondTryToRemember/top_TF.v
// Project Name:  secondTryToRemember
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: NEW_HOPE_TOP_MODULE
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Generator_impulse_TF;

	// Inputs
	reg i_Clk;
	reg i_Signal;

	// Outputs
	wire o_Impulse;
	wire o_ready;
	wire meel;

	// Instantiate the Unit Under Test (UUT)
	Generate_impulse_by_trigger uut (
		.i_Clk(i_Clk), 
		.i_Signal(i_Signal), 
		.o_Impulse(o_Impulse), 
		.o_ready(o_ready)
	);
	
	parameter Tclk=20; // 50MHz
	always begin i_Clk=0; #(Tclk/2); i_Clk=1; #(Tclk/2); end
	
	parameter Tclk2=800;
	always begin i_Signal=0; #(Tclk2/2); i_Signal=1; #(Tclk2/2); end

	initial begin

	end
      
endmodule


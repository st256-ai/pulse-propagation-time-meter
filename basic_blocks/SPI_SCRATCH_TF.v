`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:21:26 10/12/2023
// Design Name:   SPI_Transmit_SCRATCH
// Module Name:   C:/Users/Bob/Documents/ISE labs/first/tryToRememberVerilog/SPI_SCRATCH_TF.v
// Project Name:  tryToRememberVerilog
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SPI_Transmit_SCRATCH
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SPI_SCRATCH_TF;

	// Inputs
	reg i_Clk;
	reg i_Rst_L;
	reg i_Enable;
	reg [15:0] i_Data;
	reg i_EdgeShape;

	// Outputs
	wire o_Ready;
	wire o_SCLK;
	wire o_MOSI;
	wire o_CS;

	// Instantiate the Unit Under Test (UUT)
	SPI_Transmit_SCRATCH uut (
		.i_Clk(i_Clk), 
		.i_Rst_L(i_Rst_L), 
		.i_Enable(1), 
		.i_Data(16'd800), 
		.i_EdgeShape(0), 
		
		.o_Ready(o_Ready), 
		.o_SCLK(o_SCLK), 
		.o_MOSI(o_MOSI), 
		.o_CS(o_CS)
	);

	parameter Tclk=20; 
	always begin i_Clk=0; #(Tclk/2); i_Clk=1; #(Tclk/2); end

	initial begin
		// Initialize Inputs
		i_Rst_L = 1;
		#100;
		i_Rst_L = 0;
		
		#200;

		i_Rst_L = 1;
		#100;
		i_Rst_L = 0;
        
		// Add stimulus here

	end
      
endmodule


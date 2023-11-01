`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:32:10 11/02/2023 
// Design Name: 
// Module Name:    Generate_impulse_by_trigger 
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
module Generate_impulse_by_trigger(
		input i_Clk,
		input i_Signal,
		
		output o_Impulse,
		output o_ready
    );
	 
	wire start_ready;
	wire enable;
	
	Monostable_Multivibrator #(.OFFSET_TICKS(1), .DELAY_TICKS(20)) single_impulse(
		.i_Clk(i_Clk),
		.i_Rst(start_ready),
		.i_Enable(enable),
		.o_Signal(o_Impulse)
	);
	
	Level_to_pulse_inverted end_impulse_parser (
		.i_Clk(i_Clk), 
		.i_In(o_Impulse), 
		.o_Out(o_ready)
	);
	
	Level_to_pulse_meely start_impulse_parser (
		.i_Clk(i_Clk),
		.i_In(i_Signal),
		.o_Out(start_ready)
	);
	
	Pulse_to_level #(.LEVEL(0)) enable_multivibrator (
		.i_Pulse(start_ready),
		.o_Level(enable)
	);

endmodule

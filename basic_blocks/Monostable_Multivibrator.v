`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:31:36 08/08/2023 
// Design Name: 
// Module Name:    Monostable_Multivibrator 
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
module Monostable_Multivibrator
#(
parameter DELAY_TICKS = 20,
parameter OFFSET_TICKS = 1
)
(
	input i_Clk,
	input i_Rst,
	input i_Enable,
	
	output o_Signal
);
   // no any overflow detection!
	
	reg emitted = 0;
	reg offset_done = 0;
	reg[37:0] counter_signal = 0; // counter for delay - 2^38 max 5500 seconds
	
	assign o_Signal = emitted;
	
	always @(posedge i_Clk) begin
		if (i_Rst || !i_Enable) begin
			counter_signal <= 0;
			offset_done <= 0;
			emitted <= 0;
		end
		else if (i_Enable) begin
			if(!offset_done && counter_signal <= OFFSET_TICKS) //ready is LOW for this period
			begin
				counter_signal <= counter_signal + 1;
			end
			else begin
				if (!offset_done)
					counter_signal <= 0;
				offset_done <= 1;
			end
		
			if(offset_done && counter_signal <= DELAY_TICKS) // 1000/20
			begin
				emitted <= 1;
				counter_signal <= counter_signal + 1;
			end
			else if (offset_done && counter_signal > DELAY_TICKS) begin
				emitted <= 0;
			end
		end
	end
	 
endmodule


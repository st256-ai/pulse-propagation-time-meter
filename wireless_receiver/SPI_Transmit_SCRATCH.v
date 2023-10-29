`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:27:18 08/15/2023 
// Design Name: 
// Module Name:    SPI_Transmit_SCRATCH 
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
module SPI_Transmit_SCRATCH
#(parameter DATASIZE = 16)
(
	input i_Clk,
	input i_Rst_L,
	input i_Enable,
	input [DATASIZE - 1: 0] i_Data, // MSB
	input i_EdgeShape, // 1 - risingEdge, 0 - fallingEdge

	output o_Ready, // 1 if SPI is ready to transmit data
	output o_SCLK,
	output o_MOSI,
	output o_CS
);

reg [2 : 0] counter;
reg [$clog2(DATASIZE) + 1 : 0] counter2 = 0; // big endian
reg out_bitbang = 0;

reg done = 0; // holder for ready signal
reg flag; // param to detect when rst become high (was clk 1 or 0 ?)
reg q; // holder for clk signal
reg d = 0; // holder for data signal
reg cs_holder = 1; // waits until last 16 bit, then goes HIGH that triggers _CS also to HIGH

assign o_Ready = done;
assign o_SCLK = out_bitbang;
assign o_MOSI = d;
assign o_CS = cs_holder;

localparam IDLE        = 2'b00;
localparam TRANSFER    = 2'b01;

reg [1:0] r_SM_CS;

always @(posedge i_Clk) begin
	if (!i_Rst_L || !i_Enable) begin
		counter <= 0;
		counter2 <= 0;
		cs_holder <= 1;
		done <= 0;
		out_bitbang <= 0;
		r_SM_CS <= TRANSFER;
	end 
	else begin 
		case (r_SM_CS)      
			IDLE:
				begin
					counter <= 0;
					counter2 <= 0;
					cs_holder <= 1;
					done <= 0;
					out_bitbang <= 0;
				end
			TRANSFER:
				begin
					if (i_Enable) begin
						if (counter2 == 0) begin
							cs_holder <= 0;
						end
						if (counter2 < 2 * DATASIZE - !i_EdgeShape) begin // when falling edge one extra impulse - remove it
							counter <= counter + 1;
							counter2 <= counter2 + 1;
						end 
						else begin
							out_bitbang <= 0;
							cs_holder <= 1;
							done <= 1;
							d <= 0;
							out_bitbang <= i_EdgeShape;
							r_SM_CS <= IDLE;
						end
						if (!done) begin
							// wave generation (bitbang)
							if (counter == 1) begin
								counter <= 0;
								out_bitbang <= i_EdgeShape;
							end 
							else begin
								out_bitbang <= !i_EdgeShape;
								d <= (counter2 < 2 * DATASIZE) ? i_Data[DATASIZE - 1 - (counter2 / 2)] : 0;
							end
						end
					end
					else begin
						r_SM_CS <= IDLE;
					end
				end 
		endcase
	end
end

endmodule

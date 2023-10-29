`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:11 10/13/2023 
// Design Name: 
// Module Name:    Single_Impulse 
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
module Single_Impulse
#(
parameter DURATION_NS = 80
)
(
	input i_Clk,
	input i_Rst_L,
	input i_Enable,

	output o_impulse,
	output o_ready
    );
	 
reg [10:0] counter = 0; // 4096 * 10 = 40960 ns = 41 us max

localparam IDLE       = 2'b00;
localparam READY      = 2'b01;
localparam COUNTING   = 2'b10;

assign o_impulse = _impulse;
assign o_ready = _rdy;

reg _impulse = 0;
reg _rdy = 0;

reg [1:0] r_SM_CS = IDLE;
	 
	// 50 MHz = 20ns
	always @(i_Clk or i_Rst_L) begin
		if (i_Rst_L) begin
			_impulse <= 0;
			_rdy <= 0;
			r_SM_CS <= COUNTING;
		end else if (i_Enable) begin
			case (r_SM_CS)   
				IDLE:
					begin
						counter <= 0;
						_impulse <= 0;
						_rdy <= 0;
					end		
				COUNTING:
					begin
						if (counter < DURATION_NS / 10) begin
							counter <= counter + 1;
							_impulse <= 1;
						end else begin
							counter <= 0;
							_rdy <= 1;
							_impulse <= 0;
							r_SM_CS <= READY;
						end
					end
				READY:
					begin
						_rdy <= 0;
						r_SM_CS <= IDLE;
					end
			endcase
		end else begin 
			_impulse <= 0;
			_rdy <= 0;
		end
	end

endmodule

module delay_element #(parameter PERIODS_DIM = 16)(
	input wire sent_signal,
	input wire recieved_signal,
	input wire clk,
	output wire[PERIODS_DIM-1:0] delay_in_clk_periods
);

parameter MSB = 1000; //1264

wire /* synthesis keep */ en_shift;          	// Declare a variable to drive enable to the design
reg dir;                   			 		      // Declare a variable to drive direction of shift register
wire[PERIODS_DIM-1:0] /* synthesis keep */ counter_out;
wire[PERIODS_DIM-1:0] /* synthesis keep */ converter_result;

//wire [MSB-1:0] sft_reg_out;        			 	// Declare a wire to capture output from the design
	
initial begin
	dir <= 0;
end

blocker block(
			.sent_signal(sent_signal),
			.recieved_signal(recieved_signal),
			.enable_delaying(en_shift)
			);
			
counter_15 counter_15(
			.clock(clk), 
			.cnt_en(en_shift),
			.sclr(!en_shift),
			.q(counter_out));

//shift_reg_upd #(MSB) sr0(
			//.d (sent_signal),
         //.clk (clk),
         //.en (en_shift),
         //.dir (dir),
         //.rstn (en_shift),
         //.out(sft_reg_out),
			//.counter(counter_out)
			//);
			
buffer #(PERIODS_DIM) buffer(
			.counter_out(counter_out),
			.enable(en_shift),
			.converter_result(converter_result)
			);

assign delay_in_clk_periods = converter_result;

endmodule


`timescale 1ps/ 1ps
//testbench

module delay_elem_testbench;
	reg sent_signal;
	reg recieved_signal;
	reg clk;
	wire [15:0] delay_in_clk_periods;

	delay_element delay (sent_signal, recieved_signal, clk, delay_in_clk_periods);

	initial 
	begin 
		sent_signal = 0; 
		recieved_signal = 0;
		clk = 0;
		forever begin
			#12000000 sent_signal = 1;
			#100000 sent_signal = 0;
			
			#200000 recieved_signal = 1;
			#100000 recieved_signal = 0;
		end
	end
	
	always #385 clk = !clk;
	
endmodule
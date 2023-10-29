module delay_element(
	input wire input_signal,
	input wire clk,
	output wire delayed_signal,
	output wire delayed_signal_copy
);

parameter MSB = 800; //300 //1000 
reg data;                  // Declare a variable to drive d-input of design
reg /* synthesis keep */ en;                    // Declare a variable to drive enable to the design
reg dir;                   // Declare a variable to drive direction of shift registe
reg /* synthesis keep */ rstn;                  // Declare a variable to drive reset to the design
wire [MSB-1:0] out;        // Declare a wire to capture output from the design
	
	
initial begin 
data<=0;
dir<=0;
en<=0;
rstn<=0;
end

shift_reg #(MSB)
     sr0(.d (input_signal),
         .clk (clk),
         .en (!en),
         .dir (dir),
         .rstn (!rstn),
         .out (out)
			);

assign delayed_signal = out[MSB-1];

assign delayed_signal_copy = delayed_signal;

endmodule


`timescale 1ps/ 1ps
//testbench

module delay_elem_testbench;
	reg initial_signal, CLK;
	
	wire delayed_signal;

	delay_element delay (initial_signal, CLK, delayed_signal);

	initial 
	begin 
		initial_signal = 0;
		CLK = 0;
		forever begin
			#12000000 initial_signal = 1;
			#100000 initial_signal = 0;
		end
	end
	
	always #385 CLK = !CLK;
	//always begin 
	//	#120000000 initial_signal = 1;
	//	#100000 initial_signal = 0;
	//end
	
endmodule
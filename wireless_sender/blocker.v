module blocker(
	input wire sent_signal,
	input wire recieved_signal,
	output reg enable_delaying
);

initial begin
	enable_delaying = 0;
end

always @(posedge sent_signal or posedge recieved_signal) begin

	if (recieved_signal)
		enable_delaying <= 0;
	else begin
		if (sent_signal)
			enable_delaying <= 1;
	end
	
end

endmodule


`timescale 1ps/ 1ps
//testbench

module blocker_testbench;
	reg sent_signal;
	reg recieved_signal;
	wire enable_delaying;

	blocker block (sent_signal, recieved_signal, enable_delaying);

	initial 
	begin 
		sent_signal = 0; 
		recieved_signal = 0;
		forever begin
			#12000000 sent_signal = 1;
			#100000 sent_signal = 0;
			
			#200000 recieved_signal = 1;
			#100000 recieved_signal = 0;
		end
	end
	
endmodule
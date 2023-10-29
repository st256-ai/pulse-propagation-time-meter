module buffer #(parameter PERIODS_DIM = 16) (
	input wire[PERIODS_DIM-1:0] counter_out,
	input wire enable,
	output reg[PERIODS_DIM-1:0] converter_result
);

initial converter_result <= 0;

always @(counter_out) begin
		if(enable)
			converter_result <= counter_out;
		else
			converter_result <= converter_result;
end 

endmodule



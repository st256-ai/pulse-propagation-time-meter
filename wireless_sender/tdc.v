module tdc #(parameter PERIODS_DIM = 24)(
	input wire sent_signal,
	input wire recieved_signal,
	input wire clk,
	output wire[41:0] seg
);

wire new_clk;
wire locked;

wire[PERIODS_DIM-1:0] delay_in_clk_periods;
wire[PERIODS_DIM-1:0] bcd_cnt;

pll_1300 clk_pll(
	.inclk0(clk),
	.locked(locked),
	.c0(new_clk)
);

delay_element #(PERIODS_DIM) delay(
	.sent_signal(sent_signal),
	.recieved_signal(recieved_signal),
	.clk(new_clk),
	.delay_in_clk_periods(delay_in_clk_periods)
);

bin2bcd #(PERIODS_DIM) converter(
	.bin(delay_in_clk_periods),
	.bcd(bcd_cnt)
);
  
indicator_16 indic_0(
  .code(bcd_cnt[3:0]),
  .segments( {seg[6],seg[5],seg[4],seg[3],seg[2],seg[1],seg[0]} )
);

indicator_16 indic_1(
  .code(bcd_cnt[7:4]),
  .segments( {seg[13],seg[12],seg[11],seg[10],seg[9],seg[8],seg[7]} )
);

indicator_16 indic_2(
  .code(bcd_cnt[11:8]),
  .segments( {seg[20],seg[19],seg[18],seg[17],seg[16],seg[15],seg[14]} )
);

indicator_16 indic_3(
 .code(bcd_cnt[15:12]),
  .segments( {seg[27],seg[26],seg[25],seg[24],seg[23],seg[22],seg[21]} )
);

indicator_16 indic_4(
  .code(bcd_cnt[19:16]),
  .segments( {seg[34],seg[33],seg[32],seg[31],seg[30],seg[29],seg[28]} )
);

indicator_16 indic_5(
  .code(bcd_cnt[23:20]),
  .segments( {seg[41],seg[40],seg[39],seg[38],seg[37],seg[36],seg[35]} )
);

// New values 
	
endmodule

`timescale 1ps / 1ps
//testbench

module delay_testbench;
	
	reg initial_signal, CLK;
	
	wire delayed_signal;

	tdc tdc_0(initial_signal, CLK, delayed_signal);

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
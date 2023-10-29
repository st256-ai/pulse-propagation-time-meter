`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:50:26 10/12/2023 
// Design Name: 
// Module Name:    FINAL_TOP_MODULE 
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
module top(
	input i_Clk,
	input i_Rst_L,
	input i_Signal, // input signal from stm32 to start impulse
	input i_MODE, // input button to resolve transmit/receive option
	
	output o_START, // to START on TDC    // 17
	output o_STOP, // to STOP on TDC      // 18
	output reg o_data_ready, // FPGA generates impulse to show transmit-receive procedure done
	
	output o_DataIn,                      // 11 - data to transmit
	output reg o_EnableAmplifier,         // 12
	output reg o_AntennaReceiver,         // 15 
	output reg o_AntennaTransmitter,      // 16 
	
	// Receiver outputs
	output reg o_EnableReceiverPower,     // 9
	output reg o_EnableLowNoiseAmplifier, // 10
	input i_ReceivedData,                 // 14 - received data
	
	// DAC outputs
	output o_SCLK,     // 5
	output o_CS,       // 8
	output o_MOSI      // 7
);

	assign o_START = _o_Impulse;
	assign o_STOP = i_MODE? i_ReceivedData : 0; 
	assign o_DataIn = i_MODE? (_en_signal ? !_o_Impulse : 1) : (_en_signal ? !_o_delayed_signal : 1); // (active LOW), thats why 1 by default

	parameter DAC_VOLTAGE_MV = 950;
	parameter INPUT_VOLTAGE_MV = 4500;
	parameter DAC_CONVERTED_VOLTAGE = 4096 * INPUT_VOLTAGE_MV / DAC_VOLTAGE_MV;

	reg _receiver_ready = 0; // means that receiver part has successfully init via DAC configuration
	reg _en_signal = 0; // defines 11 pin
	reg _switch_transmit_regime = 0;
	reg _switch_receive_regime = 0;
	reg _generate_signal_L = 1; // active LOW. Triggers _o_Impulse
	reg _switched = 0; 
	reg _dac_enabled = 0; // goes 1 forever after DAC started but before FPGA restart. No any usage for now

	wire _o_Impulse;
	wire _o_ready; // single impulse was fully emitted -> change regime from transmitter to receiver
	wire _ready_spi;
	wire _o_delayed_signal; // delayed signal from delay block
	
	
	

/////////////////////////////////////////// FSM block TRANSMITTER
	localparam IDLE_RDY    = 2'b00;
	localparam RESET_RDY   = 2'b01;
	reg [1:0] r_SM_READY = RESET_RDY; // state machine for resolving end process for transmitter
	
	// if i_ReceivedData got in transmitter, then transmission cycle ended up successfully
	always @(posedge i_Clk or negedge i_ReceivedData) begin
		case (r_SM_READY)
			IDLE_RDY: // waiting here till response from receiver: i_ReceivedData	
				begin				
					if (!i_ReceivedData) begin
						o_data_ready <= i_MODE;
						r_SM_READY <= RESET_RDY;
					end
				end
			RESET_RDY:
				begin
					o_data_ready <= 0;
					if (i_ReceivedData) begin
						r_SM_READY <= IDLE_RDY;
					end
				end
		endcase
	end
/////////////////////////////////////////// end of FSM block TRANSMITTER

/////////////////////////////////////////// FSM block for RECEIVER
	localparam IDLE_RC_RDY    = 2'b00;
	localparam RESET_RC_RDY   = 2'b01;
	reg [1:0] r_SM_RC_DONE = RESET_RC_RDY; // state machine for resolving end process for receiver
	reg _delay_generated = 0;
	
	// if _o_delayed_signal got in receiver, then transmission cycle ended up successfully
	always @(posedge i_Clk or negedge _o_delayed_signal) begin
		case (r_SM_RC_DONE)
			IDLE_RC_RDY: // waiting here till response from receiver: i_ReceivedData	
				begin				
					if (!_o_delayed_signal) begin
						_delay_generated <= 1;
						r_SM_RC_DONE <= RESET_RC_RDY;
					end
				end
			RESET_RC_RDY:
				begin
					_delay_generated <= 0;
					if (_o_delayed_signal) begin
						r_SM_RC_DONE <= IDLE_RC_RDY;
					end
				end
		endcase
	end
/////////////////////////////////////////// end of FSM block for RECEIVER	


/////////////////////////////////////////// FSM block resolving switch regimes for TRANSMITTER
	localparam IDLE_TR    = 2'b00;
	localparam RDY_TR     = 2'b01; 
	localparam SWITCH_TR  = 2'b10; 
	reg [1:0] r_SM_TRANSMITTER_SW = IDLE_TR; // state machine defines how to switch transmitter to receiver
	
	always @(negedge i_Rst_L or posedge i_Signal or posedge _o_ready or posedge _switched) begin
		if (!i_Rst_L) begin
			r_SM_TRANSMITTER_SW <= IDLE_TR;
		end else begin
			case (r_SM_TRANSMITTER_SW)
				IDLE_TR: // waiting here forever untill i_Signal comes in	
					begin	
						_generate_signal_L <= 1;
						if (i_Signal) begin // generate single impulse
							_generate_signal_L <= 0;
							r_SM_TRANSMITTER_SW <= RDY_TR;
						end
					end
				RDY_TR: // single impulse was generated and fully went through transmitter antenna -> lets switch
					begin	
						_generate_signal_L <= 1;					
						if (_o_ready) begin 
							_switch_transmit_regime <= 1;
							r_SM_TRANSMITTER_SW <= SWITCH_TR;
						end
					end
				SWITCH_TR: // switch back to transmitter
					begin	
						if (_switched) begin
							_switch_transmit_regime <= 0;
							r_SM_TRANSMITTER_SW <= IDLE_TR;
						end
					end
			endcase
		end
	end
/////////////////////////////////////////// end of FSM block resolving switch regimes for TRANSMITTER 


	
/////////////////////////////////////////// FSM block resolving switch regimes for RECEIVER
	localparam IDLE_RECV    = 2'b00; 
	localparam RDY_RECV     = 2'b01; 
	localparam SWITCH_RECV  = 2'b10;
	reg [1:0] r_SM_RECEIVER_SW = IDLE_RECV; // state machine defines how to switch receiver to transmitter
	reg _posedge_done = 0;
	
	always @(i_Clk or _switched or i_ReceivedData) begin
		if (!i_Rst_L) begin
			r_SM_RECEIVER_SW <= IDLE_TR;
		end else begin
			case (r_SM_RECEIVER_SW)
				IDLE_RECV: // waiting here forever untill posedge i_ReceivedData
					begin				
						if (i_ReceivedData) begin
							_posedge_done <= 1;
							r_SM_RECEIVER_SW <= RDY_RECV;
						end
					end
				RDY_RECV: // waiting till negedge of i_ReceivedData, then switch to transmitter (delayed signal is ready to be emitted)
					begin				
						if (_posedge_done && !i_ReceivedData) begin
							_switch_receive_regime <= 1;
							r_SM_RECEIVER_SW <= SWITCH_RECV;
						end
					end
				SWITCH_RECV: // switch back to receiver
					begin	
						if (_switched) begin
							_posedge_done <= 0;
							_switch_receive_regime <= 0;
							r_SM_RECEIVER_SW <= IDLE_RECV;
						end
					end
			endcase
		end
	end
/////////////////////////////////////////// end of FSM block resolving switch regimes for RECEIVER	
	

/////////////////////////////////////////// main FSM block
	localparam RESET     = 3'b000;
	localparam IDLE      = 3'b001;
	localparam TRANSMIT  = 3'b010;
	localparam RECEIVE   = 3'b011;	
	localparam DAC_UP    = 3'b100;
	reg [2:0] r_SM_MAIN = RESET; // main state machine
	
	always @(posedge i_Clk or negedge i_Rst_L or posedge o_data_ready or posedge _delay_generated) begin
		if (!i_Rst_L) begin
			_receiver_ready <= 0;
			_en_signal <= 0;
			r_SM_MAIN <= RESET;
		end 
		else begin 
			case (r_SM_MAIN)  
				RESET:
					begin
						o_EnableAmplifier <= 0;
						o_AntennaReceiver <= 0;
						o_AntennaTransmitter <= 0;
						o_EnableReceiverPower <= 0;
						o_EnableLowNoiseAmplifier <= 0;
						// use _dac_enabled if you want to run DAC only once after powering up FPGA (even ignore i_Rst_L)			
						_receiver_ready <= 1; // enables DAC
						r_SM_MAIN <= DAC_UP;
					end
				DAC_UP: // enabling DAC once
					begin
						if (_ready_spi) begin
							_receiver_ready <= 0;
							_dac_enabled <= 1;
							r_SM_MAIN <= IDLE;
						end else 
							r_SM_MAIN <= DAC_UP;
					end
				IDLE:
					begin
						if (i_MODE) begin // 1 - transmit
							r_SM_MAIN <= TRANSMIT;
						end
						else begin // 0 - receive (by default)
							r_SM_MAIN <= RECEIVE;
						end
					end		
				TRANSMIT:
					begin
						_switched <= 0;
						o_AntennaTransmitter <= 1;
						o_AntennaReceiver <= 0;
						o_EnableAmplifier <= 1;
						o_EnableReceiverPower <= 0;
						o_EnableLowNoiseAmplifier <= 0; 
						_en_signal <= 1;
						r_SM_MAIN <= TRANSMIT;
						
						if (_switch_transmit_regime) begin
							r_SM_MAIN <= RECEIVE;
						end 
						if (_switch_receive_regime && _delay_generated) begin
							_switched <= 1;
							r_SM_MAIN <= RECEIVE;
						end 
					end 
				RECEIVE:
					begin
						_switched <= 0;				
						o_AntennaTransmitter <= 0;
						o_AntennaReceiver <= 1; 
						o_EnableAmplifier <= 0;
						o_EnableReceiverPower <= 1;
						o_EnableLowNoiseAmplifier <= 1; 
						_en_signal <= 0;
						r_SM_MAIN <= RECEIVE;
						
						if (_switch_receive_regime) begin
							r_SM_MAIN <= TRANSMIT;
						end 
						if (_switch_transmit_regime && o_data_ready) begin
							_switched <= 1;
							r_SM_MAIN <= TRANSMIT;
						end			

					end 
			endcase
		end
	end
/////////////////////////////////////////// end of main FSM block
	
	// To be replaced by real delay
	// Delay 150ns
	// @Contract(enabled = !i_MODE) - works for receiver only
	//delay #(.DELAY_TIME(15)) Delay (
	//	.i_Clk(i_Clk),
	//	.i_Enable(!i_MODE),
	//	.i_original_signal(i_ReceivedData), 
	//	.o_delayed_signal(_o_delayed_signal) 
	//);
	
	// Duration 80ns
	// @Contract(enabled = i_MODE) - works for transmitter only
	Single_Impulse #(.DURATION_NS(80)) Single_Impulse (
		.i_Clk(i_Clk), 
		.i_Rst_L(_generate_signal_L), // generates impulse when i_Signal from STM32 received
		.i_Enable(i_MODE),
		.o_impulse(_o_Impulse), 
		.o_ready(_o_ready)
	);

	// 25MHz -> 40ns -> ~700ns to transmit data
	SPI_Transmit_SCRATCH #(.DATASIZE(16)) SPI_DAC (
		.i_Clk(i_Clk), // SPI will be twice slower, basic i_Clk = 50MHz
		.i_Rst_L(_receiver_ready), // 0 -> 1 will cause reset
		.i_Enable(1), // always enable
		.i_Data(DAC_CONVERTED_VOLTAGE),
		.i_EdgeShape(0), // falling edge
		
		.o_Ready(_ready_spi), 
		.o_SCLK(o_SCLK), 
		.o_MOSI(o_MOSI), 
		.o_CS(o_CS)
	);

//always @(*) begin
//					begin
//						_switched <= 0;
//						if (_switch_receive_regime) begin
//							_switched <= 1;
//							r_SM_MAIN <= TRANSMIT;
//						end else begin
//							o_AntennaTransmitter <= 0;
//							o_AntennaReceiver <= 1; 
//							o_EnableAmplifier <= 0;
//							o_EnableReceiverPower <= 1;
//							o_EnableLowNoiseAmplifier <= 1; 
//							_en_signal <= 0;
//							r_SM_MAIN <= RECEIVE;
//						end
//					end 
//end

pll_1300 clk_pll(
	.inclk0(i_Clk),
	.locked(locked),
	.c0(new_clk)
);

delay_element veriner_delay(
	.input_signal(i_ReceivedData),
	.clk(new_clk),
	.delayed_signal(_o_delayed_signal)
);

endmodule
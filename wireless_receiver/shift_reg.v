module shift_reg  #(parameter MSB=12) (input d,                      // Declare input for data to the first flop in the shift register
                                      input clk,                    // Declare input for clock to all flops in the shift register
                                      input en,                     // Declare input for enable to switch the shift register on/off
                                      input dir,                    // Declare input to shift in either left or right direction
                                      input rstn,                   // Declare input to reset the register to a default value
                                      output reg [MSB-1:0] out);    // Declare output to read out the current value of all flops in this register


   // This always block will "always" be triggered on the rising edge of clock
   // Once it enters the block, it will first check to see if reset is 0 and if yes then reset register
   // If no, then check to see if the shift register is enabled
   // If no => maintain previous output. If yes, then shift based on the requested direction
   always @ (clk)
      if (!rstn)
         out <= 0;
      else begin
         if (en)
            case (dir)
               0 :  out <= {out[MSB-2:0], d};
               1 :  out <= {d, out[MSB-1:1]};
            endcase
         else
            out <= out;
      end
endmodule

module tb_sr;
   parameter MSB = 16;        // [Optional] Declare a parameter to represent number of bits in shift register

   reg data;                  // Declare a variable to drive d-input of design
   reg clk;                   // Declare a variable to drive clock to the design
   reg en;                    // Declare a variable to drive enable to the design
   reg dir;                   // Declare a variable to drive direction of shift registe
   reg rstn;                  // Declare a variable to drive reset to the design
   wire [MSB-1:0] out;        // Declare a wire to capture output from the design

   // Instantiate design (16-bit shift register) by passing MSB and connect with TB signals
   shift_reg  #(MSB) sr0  (  .d (data),
                             .clk (clk),
                             .en (en),
                             .dir (dir),
                             .rstn (rstn),
                             .out (out));

   // Generate clock time period = 20ns, freq => 50MHz
   always #10 clk = ~clk;

   // Initialize variables to default values at time 0
   initial begin
      clk <= 0;
      en <= 0;
      dir <= 0;
      rstn <= 0;
      data <= 'h1;
   end

   // Drive main stimulus to the design to verify if this works
   initial begin

      // 1. Apply reset and deassert reset after some time
      rstn <= 0;
      #20 rstn <= 1;
          en <= 1;

	  // 2. For 7 clocks, drive alternate values to data pin
      repeat (7) @ (posedge clk)
         data <= ~data;

     // 4. Shift direction and drive alternate value to data pin for another 7 clocks
      #10 dir <= 1;
      repeat (7) @ (posedge clk)
         data <= ~data;

      // 5. Drive nothing for next 7 clocks, allow shift register to simply shift based on dir
      repeat (7) @ (posedge clk);

      // 6. Finish the simulation
      $finish;
   end

   // Monitor values of these variables and print them into the logfile for debug
   initial
      $monitor ("rstn=%0b data=%b, en=%0b, dir=%0b, out=%b", rstn, data, en, dir, out);
endmodule

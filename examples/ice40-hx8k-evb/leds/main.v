//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module main (
    output wire [1:0] led,  // Active high.
    input  wire [1:0] but   // Push buttons, active low.
);

  assign led[0] = but[0];
  assign led[1] = but[1];

endmodule

//------------------------------------------------------------------
//-- Hello world example for the iCE40-HX8K board
//-- Turn on all the leds
//------------------------------------------------------------------

module main (
    output wire D2,  // Active high.
    output wire D3,  // Active high.
    output wire D4,  // Active high.
    output wire D5,  // Active high.
    output wire D6,  // Active high.
    output wire D7,  // Active high.
    output wire D8,  // Active high.
    output wire D9   // Active high.
);

  assign D2 = 1'b1;
  assign D3 = 1'b1;
  assign D4 = 1'b1;
  assign D5 = 1'b1;
  assign D6 = 1'b1;
  assign D7 = 1'b1;
  assign D8 = 1'b1;
  assign D9 = 1'b1;

endmodule

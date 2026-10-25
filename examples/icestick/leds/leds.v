//------------------------------------------------------------------
//-- Hello world example for the iCEstick board
//-- Turn on all the leds
//------------------------------------------------------------------

module leds (
    output wire D1,  // Active high.
    output wire D2,  // Active high.
    output wire D3,  // Active high.
    output wire D4,  // Active high.
    output wire D5   // Active high.
);

  assign D1 = 1'b1;
  assign D2 = 1'b1;
  assign D3 = 1'b1;
  assign D4 = 1'b1;
  assign D5 = 1'b1;

endmodule

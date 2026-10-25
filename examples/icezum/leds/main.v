//------------------------------------------------------------------
//-- Hello world example for the iCEstick board
//-- Turn on all the leds
//------------------------------------------------------------------

module main (
    output wire LED0,  // Active high.
    output wire LED1,  // Active high.
    output wire LED2,  // Active high.
    output wire LED3,  // Active high.
    output wire LED4,  // Active high.
    output wire LED5,  // Active high.
    output wire LED6,  // Active high.
    output wire LED7   // Active high.
);

  assign LED0 = 1'b1;
  assign LED1 = 1'b1;
  assign LED2 = 1'b1;
  assign LED3 = 1'b1;
  assign LED4 = 1'b1;
  assign LED5 = 1'b1;
  assign LED6 = 1'b1;
  assign LED7 = 1'b1;

endmodule

//------------------------------------------------------------------
//-- Hello world example for the nandland go-board
//-- Turn on all the leds
//------------------------------------------------------------------

module main (
    output wire LED1,  // Active high.
    output wire LED2,  // Active high.
    output wire LED3,  // Active high.
    output wire LED4   // Active high.
);

  assign LED1 = 1'b1;
  assign LED2 = 1'b1;
  assign LED3 = 1'b1;
  assign LED4 = 1'b1;

endmodule

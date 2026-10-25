//-- Turn on the Green on board LED
//-- Board: iCE40-UP5K
module main (
    output LEDG_N,  // Active low.
    output LEDR_N,  // Active low.
    output LED1,  // Active high.
    output LED2,  // Active high.
    output LED3,  // Active high.
    output LED4,  // Active high.
    output LED5  // Active high.
);

  //-- Turn on the green signal (inverse logic)
  //-- Turn off the red and blue signals (inverse logic)
  //-- On board leds are inverse logic, PMOD LEDs are positive logic.

  assign LEDR_N = 1;  //-- RED off
  assign LEDG_N = 0;  //-- GREEN ON
  assign LED1   = 0;  //-- LED1 off
  assign LED2   = 0;  //-- LED1 off
  assign LED3   = 0;  //-- LED1 off
  assign LED4   = 0;  //-- LED1 off
  assign LED5   = 0;  //-- LED1 off

endmodule

//-- Turning the RGB LED into Green
//-- Board: iCE40-UP5K
module main (
    output led_blue,  // Active low.
    output led_green,  // Active low.
    output led_red  // Active low.
);

  //-- Turn on the green signal (inverse logic)
  //-- Turn off the red and blue signals (inverse logic)

  assign led_red   = 1;  //-- RED off
  assign led_green = 0;  //-- Green ON
  assign led_blue  = 1;  //-- Blue off

endmodule

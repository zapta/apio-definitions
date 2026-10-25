//------------------------------------------------------------------
//-- Hello world example for the iceWerx board
//-- Turn on the Red LED
//------------------------------------------------------------------
module main (
    output wire LEDR  // Active low.
);

  //-- Red LED on
  //-- Inverse logic: 0: ON, 1: OFF
  assign LEDR = 1'b0;

endmodule


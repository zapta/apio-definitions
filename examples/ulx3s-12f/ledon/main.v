//------------------------------------------------------------------
//-- Turn on one LED
//------------------------------------------------------------------
module main (
    output [7:0] led  //-- LEDs, active high.
);

  //-- LED0 on
  assign led[0]   = 1'b1;

  //-- The other LEDs are off
  assign led[7:1] = 7'b0;

endmodule


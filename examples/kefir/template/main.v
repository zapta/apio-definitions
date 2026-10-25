//------------------------------------------------------------------
//-- Verilog template
//-- Top entity
//-- Board: Kéfir I
//------------------------------------------------------------------
`default_nettype none

//-- Template for the top entity
module top (
    output wire LED1  // Active high.
);

  //-- Turn on the LED1 on the board
  assign LED1 = 1'b1;

endmodule

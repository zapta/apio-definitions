//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module Test (
    input  CLK,  // 12MHz clock
    output LEDG  // LED to blink, active low.
);

  reg [23:0] counter = 0;

  always @(posedge CLK) counter <= counter + 1;

  assign LEDG = counter[23];

endmodule



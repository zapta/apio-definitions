//------------------------------------------------------------------
//-- Blinking LED
//------------------------------------------------------------------

module main (
    input sys_clk,  // 25MHz clock
    output led  // LED to blink, active low.
);

  reg [22:0] counter = 0;

  always @(posedge sys_clk) counter <= counter + 1;

  assign led = counter[22];

endmodule

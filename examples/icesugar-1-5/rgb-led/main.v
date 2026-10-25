
module main (
    input sys_clk,  // 12MHz clock
    output LED_G,  // Active low.
    output LED_R,  // Active low.
    output LED_B  // Active low.
);

  //-- Modify this value for changing the blink frequency
  localparam N = 24;  //-- N<=21 Fast, N>=23 Slow

  reg [N:0] counter;
  always @(posedge sys_clk) counter <= counter + 1;

  assign LED_G = counter[N];
  assign LED_R = counter[N-1];
  assign LED_B = counter[N-2];

endmodule

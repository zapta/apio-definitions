
module main (
    input sys_clk,  // 12MHz clock
    output led_blue,  // Active low.
    output led_green,  // Active low.
    output led_red  // Active low.
);


  //-- Modify this value for changing the blink frequency
  localparam N = 24;  //-- N<=21 Fast, N>=23 Slow

  reg [N:0] counter;
  always @(posedge sys_clk) counter <= counter + 1;

  assign led_green = counter[N];
  assign led_blue  = counter[N-1];
  assign led_red   = counter[N-2];

endmodule

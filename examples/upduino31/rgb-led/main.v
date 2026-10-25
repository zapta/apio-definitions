// Generates a RGB blinking pattern. Uses the internal oscilator.
module main (
    // [0]=red, [1]=green, [2]=blue. See pin definitions in pinout.pcf
    output [2:0] leds_out  // Active low.
);

  // The 48MHz clock from the internal oscillator.
  wire sys_clk;

  oscilator oscilator (.sys_clk(sys_clk));

  // Frequency divider to generate the RGB patterns.
  reg  [25:0] divider;
  wire        red_en = divider[25] & divider[24];
  wire        green_en = divider[25] & ~divider[24];
  wire        blue_en = ~divider[25] & divider[24];

  leds leds (
      .sys_clk (sys_clk),
      .red_en  (red_en),
      .green_en(green_en),
      .blue_en (blue_en),
      .leds_out(leds_out)
  );

  // Behavior.
  always @(posedge sys_clk) begin
    divider <= divider + 1'b1;
  end

endmodule

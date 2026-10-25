`default_nettype none

//-- Blinking led
module main (
    input sys_clk,  // 100MHz clock
    output wire [15:0] leds  // Active high.
);

  //-- Contador de 25 bits
  reg [24:0] counter;
  always @(posedge sys_clk) begin
    counter <= counter + 1;
  end

  //-- Mostrar en el LED0 el bit de mayor peso del contador
  assign leds[0] = counter[24];

  assign leds[15:1] = 0;

  //-- This is for simulation
  //-- the counter should start in 0
  initial begin
    counter = 0;
  end

endmodule

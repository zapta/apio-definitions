//------------------------------------------------------------------
//-- Blinking LED
//-- The Green LED is blinking. The other LEDs are turned off
//------------------------------------------------------------------
module blink_test (
    input  CLK,     //-- 12 Mhz
    output LEDG_N,  //-- Green led to blink, active low.
    output LEDR_N,  // Active low.
    output LED1,  // Active high.
    output LED2,  // Active high.
    output LED3,  // Active high.
    output LED4,  // Active high.
    output LED5  // Active high.
);

  reg [23:0] counter = 0;

  always @(posedge CLK) counter <= counter + 1;

  //-- Toggle the green LED
  assign LEDG_N = counter[23];

  //-- Turn off the other LEDs
  assign LEDR_N = 1'b1;
  assign {LED5, LED4, LED3, LED2, LED1} = 5'b0;

endmodule

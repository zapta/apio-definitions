// look in pins.pcf for all the pin names on the TinyFPGA BX board
module main (
    input sys_clk,  // 16MHz clock
    output led,  // User/boot LED next to the power LED, active high.
    output usb_pu  // USB pull-up resistor, active high.
);
  // drive USB pull-up resistor to '0' to disable USB
  assign usb_pu = 0;

  ////////
  // make a simple blink circuit
  ////////

  // keep track of time and location in blink_pattern
  reg  [25:0] blink_counter;

  // pattern that will be flashed over the LED over time
  wire [31:0] blink_pattern = 32'b101010001110111011100010101;

  // increment the blink_counter every clock
  always @(posedge sys_clk) begin
    blink_counter <= blink_counter + 1;
  end

  // light up the LED according to the pattern
  assign led = blink_pattern[blink_counter[25:21]];
endmodule

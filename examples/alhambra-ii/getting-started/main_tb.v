// Testbench for main.v.
// Run it in batch mode with 'apio test', or view the signals
// in GTKWave with 'apio sim'.

// Checks that 'actual_val' equals 'expected_val'. On a mismatch, prints
// the values and location, sets assertion_err, and stops the simulation.
// Under 'apio sim' the simulation continues so the signals can be viewed.
`define EXPECT_EQ(actual_val, expected_val) \
  if ((actual_val) !== (expected_val)) begin \
    $display("*** ASSERTION FAILED at %s:%0d: expected 'h%h, actual 'h%h", \
             `__FILE__, `__LINE__, (expected_val), (actual_val)); \
    assertion_err = 1; \
    if (!`APIO_SIM) $fatal; \
  end

`timescale 1ns / 1ps

module main_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // Clocks between LED toggles, reduced to run quickly.
  localparam integer N = 3;

  // The LEDs driven by the design.
  wire [1:0] leds;

  // The design under test.
  main #(
      .N(N)
  ) dut (
      .sys_clk(sys_clk),
      .leds(leds)
  );

  // Loop index for the checks.
  integer i;

  // The test sequence.
  initial begin
    $dumpvars(0, main_tb);

    // Before the first clock, the counter is 0 and leds[1] is on.
    #1;
    `EXPECT_EQ(dut.counter, 32'd0)
    `EXPECT_EQ(leds, 2'b10)

    // After i clocks the counter is i mod N, and the LEDs swapped
    // every N clocks.
    for (i = 1; i <= 24; i = i + 1) begin
      @(posedge sys_clk);
      #1;
      `EXPECT_EQ(dut.counter, i % N)
      `EXPECT_EQ(leds, ((i/N) % 2 == 0) ? 2'b10 : 2'b01)
    end

    $display("End of simulation");
    $finish;
  end

endmodule

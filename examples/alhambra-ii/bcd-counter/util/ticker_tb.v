// Testbench for ticker.v.
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

module ticker_tb;

  // Set to 1 when an assertion fails.
  reg assertion_err = 0;

  // Clock.
  reg sys_clk = 0;
  always #5 sys_clk = ~sys_clk;

  // Number of sys_clk rising edges so far.
  integer clk_num = 0;
  always @(posedge sys_clk) clk_num <= clk_num + 1;

  // Reset, driven by the test sequence.
  reg  sys_rst = 1;

  // The ticker output.
  wire tick;

  // A ticker that ticks every 5 clocks.
  ticker #(
      .DIV(5)
  ) dut (
      .sys_clk(sys_clk),
      .sys_rst(sys_rst),
      .tick(tick)
  );

  // The test sequence.
  initial begin
    $dumpvars(0, ticker_tb);

    // Reset for 2 clocks.
    repeat (2) @(posedge sys_clk);
    #1;
    sys_rst = 0;
    `EXPECT_EQ(tick, 1'b0)

    // The counter counts 0 to 4 on clocks 3 to 7, and tick is high
    // after clock 7. So tick is high after clocks 7, 12, 17, ...
    repeat (30) begin
      @(posedge sys_clk);
      #1;
      `EXPECT_EQ(tick, (clk_num - 2) % 5 == 0)
    end

    $display("End of simulation");
    $finish;
  end

endmodule

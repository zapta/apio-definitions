// A testbench for testing the main module.

`include "apio_testing.vh"

`timescale 10 ns / 1 ns

module main_tb ();

  // This defines a managed signal called 'clk'.
  `DEF_CLK

  // Inputs.
  reg rst_n = 0;

  // Outputs.
  wire [2:0] led;

  // Instantiate the design so that it changes the led color every 5 clocks.
  main #(
      .DIV(5)
  ) rotator (
      .sys_clk(clk),
      .sys_rst_n(rst_n),
      .led(led)
  );

  initial begin
    `TEST_BEGIN(main_tb)

    // Simulate a press of the reset button.
    `CLKS(3)
    rst_n = 1;

    // Free run for 30 clocks, two full color rotations.
    `CLKS(30)

    `TEST_END
  end

endmodule

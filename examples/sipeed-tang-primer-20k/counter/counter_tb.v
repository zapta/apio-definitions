//------------------------------------------------------------------
// Testbench for counter.v
//
// Copyright (c) 2026 Carlos Venegas <carlos@magnitude.es>
// X: @cavearr  github: @cavearr
//
// SPDX-License-Identifier: GPL-3.0-or-later
//------------------------------------------------------------------

`include "apio_testing.vh"

`timescale 10 ns / 1 ns

module counter_tb ();

  `DEF_CLK

  wire [6:0] segs_n;
  wire digit_sel;

  main #(
      .CLK_HZ(20)
  ) dut (
      .sys_clk(clk),
      .segs_n(segs_n),
      .digit_sel(digit_sel)
  );

  initial begin
    `TEST_BEGIN(counter_tb)
    `CLKS(80)
    `TEST_END
  end

endmodule

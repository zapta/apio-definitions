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

  wire [7:0] seven_seg;

  counter #(
      .CLK_HZ(20)
  ) dut (
      .sys_clk  (clk),
      .seven_seg(seven_seg)
  );

  initial begin
    `TEST_BEGIN(counter_tb)
    `CLKS(80)
    `TEST_END
  end

endmodule

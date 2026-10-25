

`default_nettype none
`timescale 1ns / 1ps

module main_tb;

  reg sys_clk = 0;
  wire [7:0] rows;
  wire [3:0] cols;

  // Instantiate the DUT (Device Under Test)
  main #(
      .N1       (3),   // Small value for fast sim
      .N2       (40),  // Small value for fast sim
      .INTENSITY(15)   // Max intensity, no pwm
  ) main (
      .sys_clk(sys_clk),
      .ROWS(rows),
      .COLS(cols)
  );

  // Clock generation: 12MHz → ~83ns period
  always #42 sys_clk = ~sys_clk;

  initial begin
    // Enable waveform capture
    $dumpvars(0, main_tb);

    $display("Starting simulation...");

    // Run for a limited time
    repeat (150) begin
      @(posedge sys_clk);
      // $display("ROWS = %b, COLS = %b", rows, cols);
    end

    $display("End of simulation");
    $finish;
  end

endmodule


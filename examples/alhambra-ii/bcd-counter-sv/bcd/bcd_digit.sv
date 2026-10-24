// A single decimal digit counter, 0-9. Digits can be chained
// by connecting tick_out of one to tick_in of the next.

module bcd_digit (
    input  logic       sys_clk,   // System clock.
    input  logic       sys_rst,   // Synchronous reset, active high.
    input  logic       tick_in,   // When high, count one step.
    output logic       tick_out,  // When high, the next digit should count.
    output logic [3:0] count      // The digit value, 0-9.
);

  // Tell the next digit to count when this one wraps from 9 to 0.
  assign tick_out = (count == 9) && tick_in;

  // Count 0 to 9 and wrap around.
  always_ff @(posedge sys_clk) begin
    if (sys_rst) begin
      count <= 0;
    end else if (tick_in) begin
      count <= (count == 9) ? 0 : count + 1;
    end
  end

endmodule

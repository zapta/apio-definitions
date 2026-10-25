// Generates a tick that is high for one clock every DIV clocks.

module ticker #(
    // Clocks per tick. main.v overrides this value.
    parameter integer DIV = 12_000_000
) (
    input  wire sys_clk,  // System clock.
    input  wire sys_rst,  // Synchronous reset, active high.
    output reg  tick      // High for one clock every DIV clocks.
);

  // Clock counter, 0 to DIV-1.
  reg [31:0] counter;

  // Count clocks and pulse tick when the counter wraps around.
  always @(posedge sys_clk) begin
    if (sys_rst) begin
      counter <= 0;
      tick <= 0;
    end else if (counter == DIV - 1) begin
      counter <= 0;
      tick <= 1;
    end else begin
      counter <= counter + 1;
      tick <= 0;
    end
  end

endmodule

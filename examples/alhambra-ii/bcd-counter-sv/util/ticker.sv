// Generates a tick that is high for one clock every DIV clocks.

module ticker #(
    // Clocks per tick. main.sv overrides this value.
    parameter int DIV = 12_000_000
) (
    input  logic sys_clk,  // System clock.
    input  logic sys_rst,  // Synchronous reset, active high.
    output logic tick      // High for one clock every DIV clocks.
);

  // Clock counter, 0 to DIV-1.
  logic [31:0] counter;

  // Count clocks and pulse tick when the counter wraps around.
  always_ff @(posedge sys_clk) begin
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

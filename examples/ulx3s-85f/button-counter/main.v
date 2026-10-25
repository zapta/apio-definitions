
module main (
    input sys_clk,  // 25MHz clock
    input [6:0] btn,  // Push buttons. btn[0] is active low, the rest active high.
    output [7:0] led,  // Active high.
    output wifi_gpio0
);

  localparam ctr_width = 32;

  wire i_clk;

  // Tie GPIO0, keep board from rebooting
  assign wifi_gpio0 = 1'b1;
  assign i_clk = sys_clk;
  reg [7:0] o_led;
  assign led = o_led;

  reg [ctr_width-1:0] ctr = 0;

  always @(posedge i_clk) begin
    ctr <= ctr + 1;
    o_led[7] <= 1;
    o_led[6] <= btn[1];
    o_led[5:0] <= ctr[23:18];
  end

endmodule

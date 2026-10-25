
module main #(
    parameter integer N1        = 5_000,      // clks per col scan
    parameter integer N2        = 6_000_000,  // clks per rnd update
    parameter integer INTENSITY = 0           // Leds intensity, 0-15
) (
    input        sys_clk,  // 12MHz clock
    output [7:0] ROWS,     // LED rows, active low.
    output [3:0] COLS      // LED columns, active low.
);

  // Running rand value.
  wire [31:0] rnd;

  // Sampled rand to display
  reg  [31:0] sampled_rnd = 0;

  // wire frame_tick;

  rand_gen rand_gen (
      .sys_clk(sys_clk),
      .rnd(rnd)
  );

  led_matrix #(
      .N(N1)
  ) led_matrix (
      .sys_clk(sys_clk),
      .data(sampled_rnd),
      .intensity(INTENSITY[3:0]),
      .frame_tick(),
      .rows(ROWS),
      .cols(COLS)
  );

  reg [31:0] timer = 0;


  always @(posedge sys_clk) begin
    // Increment timer mod N2.
    timer = (timer >= N2 - 1) ? 0 : timer + 1;
    if (timer == 0) begin
      // Get a new rand.
      sampled_rnd <= rnd;
    end
  end

endmodule



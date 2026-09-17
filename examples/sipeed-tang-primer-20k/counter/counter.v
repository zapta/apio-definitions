//------------------------------------------------------------------
// Two-digit decimal counter 00..99 on both 7-seg digits.
//
// Board : Sipeed Tang Primer 20K Lite (GW2A-LV18PG256C8/I7)
// PMOD  : icebreaker 7-seg display v1.1a, top-right connector
// Clock : 27 MHz on H11
//
// Copyright (c) 2026 Carlos Venegas <carlos@magnitude.es>
// X: @cavearr  github: @cavearr
//
// SPDX-License-Identifier: GPL-3.0-or-later
//
// Mapping and polarity follow the iCEBreaker workshop stopwatch.
//
// PMOD map (Digilent 2x6, looking into the Lite header):
//
//   1 AA T6   2 AB T7   3 AC T8   4 AD T9   5 GND   6 3V3
//   7 AE P6   8 AF R8   9 AG P8  10 CAT P9 11 GND  12 3V3
//
//     tens (CAT=0)      units (CAT=1)
//          AAA               AAA          seven_seg[0] = AA
//         F   B             F   B         seven_seg[1] = AB
//         F   B             F   B         seven_seg[2] = AC
//          GGG               GGG          seven_seg[3] = AD
//         E   C             E   C         seven_seg[4] = AE
//         E   C             E   C         seven_seg[5] = AF
//          DDD               DDD          seven_seg[6] = AG
//                                         seven_seg[7] = CAT
//
// Segments are active-low. CAT multiplexes the two digits.
//------------------------------------------------------------------

module counter #(
    parameter integer CLK_HZ = 27000000
) (
    input        sys_clk,
    output [7:0] seven_seg  // {CAT, AG, AF, AE, AD, AC, AB, AA}
);

  reg [7:0] value = 0;  // BCD: tens in [7:4], units in [3:0]
  reg [31:0] tick_div = 0;
  reg tick = 0;

  always @(posedge sys_clk) begin
    if (tick_div == (CLK_HZ - 1)) begin
      tick_div <= 0;
      tick <= 1;
    end else begin
      tick_div <= tick_div + 1;
      tick <= 0;
    end

    if (tick) begin
      if (value == 8'h99) value <= 0;
      else if (value[3:0] == 4'h9) value <= {value[7:4] + 4'd1, 4'h0};
      else value <= {value[7:4], value[3:0] + 4'd1};
    end
  end

  seven_seg_ctrl display (
      .clk (sys_clk),
      .din (value),
      .dout(seven_seg)
  );

endmodule

// Multiplex the two digits. Patterns are active-high internally, then
// inverted for the PMOD (active-low segments). CAT=1 shows units.
module seven_seg_ctrl (
    input            clk,
    input      [7:0] din,
    output reg [7:0] dout
);
  wire [6:0] tens_digit;
  wire [6:0] units_digit;

  seven_seg_hex tens_nibble (
      .din (din[7:4]),
      .dout(tens_digit)
  );
  seven_seg_hex ones_nibble (
      .din (din[3:0]),
      .dout(units_digit)
  );

  reg [9:0] mux_div = 0;
  reg mux_tick = 0;
  reg show_tens = 0;

  always @(posedge clk) begin
    mux_div   <= mux_div + 1;
    mux_tick  <= &mux_div;
    show_tens <= show_tens ^ mux_tick;

    if (mux_tick) begin
      if (show_tens) begin
        dout[6:0] <= ~tens_digit;
        dout[7]   <= 1'b0;
      end else begin
        dout[6:0] <= ~units_digit;
        dout[7]   <= 1'b1;
      end
    end
  end
endmodule

// Active-high 7-seg patterns, bit0=A .. bit6=G.
module seven_seg_hex (
    input      [3:0] din,
    output reg [6:0] dout
);
  always @* begin
    case (din)
      4'h0: dout = 7'b0111111;
      4'h1: dout = 7'b0000110;
      4'h2: dout = 7'b1011011;
      4'h3: dout = 7'b1001111;
      4'h4: dout = 7'b1100110;
      4'h5: dout = 7'b1101101;
      4'h6: dout = 7'b1111101;
      4'h7: dout = 7'b0000111;
      4'h8: dout = 7'b1111111;
      4'h9: dout = 7'b1101111;
      default: dout = 7'b1000000;
    endcase
  end
endmodule

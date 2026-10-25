//------------------------------------------------------------------
//-- Hello world example for the EDU-CIAA-FPGA
//-- Turn on the green LED
//------------------------------------------------------------------
module main (
    output wire LEDG  // Active high.
);

  assign LEDG = 1'b1;

endmodule


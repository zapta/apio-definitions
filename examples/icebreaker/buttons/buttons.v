// Example of using 3 buttons for toggeling the LED
// Board: iCE40-UP5K
module rgb_test (
    input BTN_N,  // Active low.
    input BTN1,  // Active high.
    input BTN2,  // Active high.
    input BTN3,  // Active high.
    output LEDR_N,  // Active low.
    output LEDG_N,  // Active low.
    output LED4,  // Active high.
    output LED1,  // Active high.
    output LED5  // Active high.
);

  assign {LEDR_N, LEDG_N}   = {BTN_N, ~BTN_N};
  assign {LED4, LED1, LED5} = {BTN1, BTN2, BTN3};

endmodule

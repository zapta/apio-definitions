//-- Plays Frere Jacques in two voices, one on each buzzer.

//-- Incluir las constantes del modulo del divisor
`include "divider.vh"

//--Parametros

module main (
    input  wire       sys_clk,  // 12MHz clock
    output reg  [1:0] buzzers   // The two voices.
);

  //--Notas a tocar
  //--Definidas como parametros para las pruebas del testbench

  parameter N0  = `DO_4;
  parameter N1  = `RE_4;
  parameter N2  = `MI_4;
  parameter N3  = `FA_4;
  parameter N4  = `SOL_4;
  parameter N5  = `LA_4;
  parameter N6  = `SI_4;
  parameter N7  = `DO_5;


  parameter DUR = `T_500ms;

  //--Cables de salida de los canales

  wire ch0, ch1, ch2, ch3, ch4, ch5, ch6, ch7;

  //--Seleccion del canal del multiplexor
  reg [5:0] sel = 0;
  reg [5:0] sel2 = 60;  //Un compas retrasado

  //-Reloj de duracion de la nota
  wire clk_dur;

  //--Canal 0
  divider #(N0) CH0 (
      .clk_in (sys_clk),
      .clk_out(ch0)
  );

  //-- Canal 1
  divider #(N1) CH1 (
      .clk_in (sys_clk),
      .clk_out(ch1)
  );

  //-- canal 2
  divider #(N2) CH2 (
      .clk_in (sys_clk),
      .clk_out(ch2)
  );

  //-- canal 3
  divider #(N3) CH3 (
      .clk_in (sys_clk),
      .clk_out(ch3)
  );

  //-- canal 4
  divider #(N4) CH4 (
      .clk_in (sys_clk),
      .clk_out(ch4)
  );

  //-- canal 5
  divider #(N5) CH5 (
      .clk_in (sys_clk),
      .clk_out(ch5)
  );

  //-- canal 6
  divider #(N6) CH6 (
      .clk_in (sys_clk),
      .clk_out(ch6)
  );

  //-- canal 7
  divider #(N7) CH7 (
      .clk_in (sys_clk),
      .clk_out(ch7)
  );

  //multiplexor de seleccion del canal de Salida

  always @*
    case (sel)
      //Frere Jacques
      0: buzzers[0] = ch0;
      1: buzzers[0] = ch1;
      2: buzzers[0] = ch2;
      3: buzzers[0] = ch0;

      4: buzzers[0] = 0;

      //Frere Jacques
      5: buzzers[0] = ch0;
      6: buzzers[0] = ch1;
      7: buzzers[0] = ch2;
      8: buzzers[0] = ch0;

      9: buzzers[0] = 0;

      //Dormez-vous?
      10: buzzers[0] = ch2;
      11: buzzers[0] = ch3;
      12: buzzers[0] = ch4;

      13: buzzers[0] = 0;

      //Dormez-vous?
      14: buzzers[0] = ch2;
      15: buzzers[0] = ch3;
      16: buzzers[0] = ch4;

      17: buzzers[0] = 0;

      //Sonnez les matines
      18: buzzers[0] = ch4;
      19: buzzers[0] = ch5;
      20: buzzers[0] = ch4;
      21: buzzers[0] = ch3;
      22: buzzers[0] = ch2;
      23: buzzers[0] = ch0;

      24: buzzers[0] = 0;

      //Sonnez les matines
      25: buzzers[0] = ch4;
      26: buzzers[0] = ch5;
      27: buzzers[0] = ch4;
      28: buzzers[0] = ch3;
      29: buzzers[0] = ch2;
      30: buzzers[0] = ch0;

      31: buzzers[0] = 0;

      //Din dan don
      32: buzzers[0] = ch0;
      33: buzzers[0] = ch4;
      34: buzzers[0] = ch0;

      35: buzzers[0] = 0;

      //Din dan don
      36: buzzers[0] = ch0;
      37: buzzers[0] = ch4;
      38: buzzers[0] = ch0;

      39: buzzers[0] = 0;


      default: buzzers[0] = 0;
    endcase

  always @*
    case (sel2)
      //Frere Jacques
      0: buzzers[1] = ch0;
      1: buzzers[1] = ch1;
      2: buzzers[1] = ch2;
      3: buzzers[1] = ch0;

      4: buzzers[1] = 0;

      //Frere Jacques
      5: buzzers[1] = ch0;
      6: buzzers[1] = ch1;
      7: buzzers[1] = ch2;
      8: buzzers[1] = ch0;

      9: buzzers[1] = 0;

      //Dormez-vous?
      10: buzzers[1] = ch2;
      11: buzzers[1] = ch3;
      12: buzzers[1] = ch4;

      13: buzzers[1] = 0;

      //Dormez-vous?
      14: buzzers[1] = ch2;
      15: buzzers[1] = ch3;
      16: buzzers[1] = ch4;

      17: buzzers[1] = 0;

      //Sonnez les matines
      18: buzzers[1] = ch4;
      19: buzzers[1] = ch5;
      20: buzzers[1] = ch4;
      21: buzzers[1] = ch3;
      22: buzzers[1] = ch2;
      23: buzzers[1] = ch0;

      24: buzzers[1] = 0;

      //Sonnez les matines
      25: buzzers[1] = ch4;
      26: buzzers[1] = ch5;
      27: buzzers[1] = ch4;
      28: buzzers[1] = ch3;
      29: buzzers[1] = ch2;
      30: buzzers[1] = ch0;

      31: buzzers[1] = 0;

      //Din dan don
      32: buzzers[1] = ch0;
      33: buzzers[1] = ch4;
      34: buzzers[1] = ch0;

      35: buzzers[1] = 0;

      //Din dan don
      36: buzzers[1] = ch0;
      37: buzzers[1] = ch4;
      38: buzzers[1] = ch0;

      39: buzzers[1] = 0;


      default: buzzers[1] = 0;
    endcase

  always @(posedge sys_clk)  //-- Fix-me! Before: clk_dur
  begin
    sel  <= sel + 1;
    sel2 <= sel2 + 1;
  end

  divider #(DUR) TIMER0 (
      .clk_in (sys_clk),
      .clk_out(clk_dur)
  );

endmodule

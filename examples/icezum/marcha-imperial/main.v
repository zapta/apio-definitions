//-----------------------------------------------------------------------------
//-- Reproductor de melodias almacenadas en memoria rom
//-- Los 8 bits menos significativos de la nota se sacan por los leds
//-----------------------------------------------------------------------------
//-- (C) BQ. October 2015. Written by Juan Gonzalez
//-----------------------------------------------------------------------------
//-- GPL license
//-----------------------------------------------------------------------------

//-- Incluir las constantes del modulo del divisor
`include "divider.vh"

//-- Parameteros:
//-- sys_clk: Reloj de entrada de la placa iCEstick
//-- buzzer: Canal de salida
module main (
    input wire sys_clk,  // 12MHz clock
    output wire [7:0] leds,  // Active high.
    output wire buzzer
);

  //-- Parametros
  //-- Duracion de las notas
  parameter DUR = `T_150ms;

  //-- Fichero con las notas para cargar en la rom
  parameter ROMFILE = "imperial.list";

  //-- Tamaño del bus de direcciones de la rom
  parameter AW = 8;

  //-- Tamaño de las notas
  parameter DW = 16;

  //-- Cables de salida de los canales
  wire ch0, ch1, ch2;

  //-- Selección del canal del multiplexor
  reg [AW-1:0] addr = 0;

  //-- Reloj con la duracion de la nota
  wire clk_dur;
  reg rstn = 0;

  wire [DW-1:0] note;

  //-- Instanciar la memoria rom
  genrom #(
      .ROMFILE(ROMFILE),
      .AW(AW),
      .DW(DW)
  ) ROM (
      .sys_clk (sys_clk),
      .addr(addr),
      .data(note)
  );


  //-- Generador de notas
  notegen CH0 (
      .sys_clk(sys_clk),
      .rstn(rstn),
      .note(note),
      .clk_out(buzzer)
  );

  //-- Sacar los 8 bits de la nota por los leds
  assign leds = note[7:0];

  //-- Inicializador
  always @(posedge sys_clk) rstn <= 1;


  //-- Contador para seleccion de nota
  always @(posedge sys_clk) if (clk_dur) addr <= addr + 1;

  //-- Divisor para marcar la duración de cada nota
  dividerp1 #(DUR) TIMER0 (
      .sys_clk(sys_clk),
      .clk_out(clk_dur)
  );


endmodule




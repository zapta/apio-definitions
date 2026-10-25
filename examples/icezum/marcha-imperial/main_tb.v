//-------------------------------------------------------------------
//-- main_tb.v
//-- Banco de pruebas para el reproductor de melodias
//-------------------------------------------------------------------
//-- BQ October 2015. Written by Juan Gonzalez (Obijuan)
//-------------------------------------------------------------------
//-- GPL License
//-------------------------------------------------------------------

`define DUMP_FILE_NAME(x) `"x.vcd`"

module main_tb ();

  //-- Registro para generar la señal de reloj
  reg  sys_clk = 0;

  //-- Salidas de los canales
  wire buzzer;


  //-- Instanciar el componente y establecer el valor del divisor
  //-- Se pone un valor bajo para simular (de lo contrario tardaria mucho)
  main #(
      .DUR(2)
  ) dut (
      .sys_clk(sys_clk),
      .buzzer(buzzer)
  );

  //-- Generador de reloj. Periodo 2 unidades
  always #1 sys_clk <= ~sys_clk;


  //-- Proceso al inicio
  initial begin

    //-- Dump vars to the .vcd output file
    $dumpvars(0, main_tb);

    #200 $display("FIN de la simulacion");
    $finish;
  end

endmodule


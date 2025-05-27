`timescale 1ns/1ps

module tb_and_circular_structural;

  // Entradas
  logic [1:0] A;
  logic [3:0] B;

  // Salidas
  logic [3:0] Y;
  logic zero, negativo, carry, overflow;

  // Instancia del módulo
  and_circular_structural uut (
    .A(A),
    .B(B),
    .Y(Y),
    .zero(zero),
    .negativo(negativo),
    .carry(carry),
    .overflow(overflow)
  );

  // Procedimiento de prueba
  initial begin
    $display("Tiempo | A  B    | Y    | Z N C O");
    $display("------------------------------------");

    for (int i = 0; i < 4; i++) begin      // 2-bit A: 00 a 11
      for (int j = 0; j < 16; j++) begin   // 4-bit B: 0000 a 1111
        A = i[1:0];
        B = j[3:0];
        #10;
        $display("%4t   | %b  %b | %b | %b %b %b %b",
                 $time, A, B, Y, zero, negativo, carry, overflow);
      end
    end

    $finish;
  end

endmodule

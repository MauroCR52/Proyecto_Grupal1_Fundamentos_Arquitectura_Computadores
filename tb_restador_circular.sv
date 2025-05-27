`timescale 1ns/1ps

module tb_restador_circular;

  // Entradas
  logic [3:0] A;
  logic [3:0] B;

  // Salidas
  logic [3:0] Y;
  logic Z, N, C, V;

  // Instancia del módulo
  restador_circular uut (
    .A(A),
    .B(B),
    .Y(Y),
    .Z(Z),
    .N(N),
    .C(C),
    .V(V)
  );

  // Procedimiento de prueba
  initial begin
    $display("A     B     | Y     Z N C V");
    $display("----------------------------");

    // Prueba 1: 5 - 3 = 2
    A = 4'd5; B = 4'd3; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Prueba 2: 3 - 5 = -2 (esperado: 14 porque es 2's complement de -2 en 4 bits)
    A = 4'd3; B = 4'd5; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Prueba 3: 7 - 7 = 0
    A = 4'd7; B = 4'd7; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Prueba 4: 0 - 1 = -1 (esperado: 1111)
    A = 4'd0; B = 4'd1; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Prueba 5: 8 - 1 = 7
    A = 4'd8; B = 4'd1; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Prueba 6: 7 - 15 = -8 (esperado: 1000, verificar overflow)
    A = 4'd7; B = 4'd15; #10;
    $display("%b %b | %b  %b %b %b %b", A, B, Y, Z, N, C, V);

    // Fin de simulación
    $finish;
  end

endmodule

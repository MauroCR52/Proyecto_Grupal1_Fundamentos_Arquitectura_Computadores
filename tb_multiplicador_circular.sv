`timescale 1ns / 1ps

module tb_multiplicador_circular();

    logic [1:0] A;
    logic [3:0] B;
    logic [3:0] Y;
    logic Z, N, C, V;

    // Instancia del DUT (Device Under Test)
    multiplicador_circular dut (
        .A(A),
        .B(B),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    initial begin
        $display("Tiempo | A  B   | Y   | Z N C V");
        $display("------------------------------");

        for (int a = 0; a < 4; a++) begin
            A = a[1:0];
            for (int b = 0; b < 16; b++) begin
                B = b[3:0];
                #1; // Esperar a que se actualice la lógica
                $display("%0t     | %b  %b | %b | %b %b %b %b", $time, A, B, Y, Z, N, C, V);
            end
        end

        $finish;
    end

endmodule

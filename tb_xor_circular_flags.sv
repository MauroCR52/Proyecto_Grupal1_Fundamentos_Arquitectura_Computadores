module tb_xor_circular_flags();

    // Entradas
    logic [1:0] A;
    logic [3:0] B;

    // Salidas
    logic [3:0] Y;
    logic N, Z, C, V;

    // Instancia del DUT (Device Under Test)
    xor_circular_flags uut (
        .A(A),
        .B(B),
        .Y(Y),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );

    initial begin
        // Encabezado
        $display("Tiempo  |  A  |   B   |   Y   | N | Z | C | V");
        $display("--------|-----|-------|-------|---|---|---|---");

        // Prueba 1
        A = 2'b00; B = 4'b0000; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        // Prueba 2
        A = 2'b01; B = 4'b1010; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        // Prueba 3
        A = 2'b10; B = 4'b0101; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        // Prueba 4
        A = 2'b11; B = 4'b1111; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        // Prueba 5
        A = 2'b01; B = 4'b1110; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        // Prueba 6
        A = 2'b10; B = 4'b0001; #10;
        $display("%0t     |  %b  | %b | %b |  %b | %b | %b | %b", 
                 $time, A, B, Y, N, Z, C, V);

        $finish;
    end

endmodule

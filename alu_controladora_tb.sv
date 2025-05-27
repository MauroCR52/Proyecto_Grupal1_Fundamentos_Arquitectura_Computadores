module alu_controladora_tb();

    logic [1:0] A;
    logic [3:0] B;
    logic [1:0] op;
    logic [3:0] Y;
    logic       Z, N, C, V;

    // Instancia de la ALU
    alu_controladora dut (
        .A(A),
        .B(B),
        .op(op),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    // Tarea para mostrar resultados
    task mostrar_resultado;
        input string nombre_operacion;
        begin
            $display("Operacion: %s | A=%b B=%b op=%b => Y=%b | Z=%b N=%b C=%b V=%b",
                     nombre_operacion, A, B, op, Y, Z, N, C, V);
        end
    endtask

    initial begin
        // ---------- Operación AND (op = 00) ----------
        A = 2'b10;
        B = 4'b1101;
        op = 2'b00;
        #10;
        mostrar_resultado("AND");

        // ---------- Operación XOR (op = 01) ----------
        A = 2'b01;
        B = 4'b1010;
        op = 2'b01;
        #10;
        mostrar_resultado("XOR");

        // ---------- Operación MULTIPLICACION (op = 10) ----------
        A = 2'b11;
        B = 4'b0011;
        op = 2'b10;
        #10;
        mostrar_resultado("MULT");

        // ---------- Operación RESTA (op = 11) ----------
        A = 2'b10;
        B = 4'b0011;
        op = 2'b11;
        #10;
        mostrar_resultado("RESTA");

        // ---------- Otro ejemplo RESTA con resultado negativo ----------
        A = 2'b01;
        B = 4'b1000;
        op = 2'b11;
        #10;
        mostrar_resultado("RESTA NEG");

        // Fin de la simulación
        $finish;
    end

endmodule

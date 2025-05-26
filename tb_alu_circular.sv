`timescale 1ps / 1ps

module tb_alu_circular;

    // Señales para multiplicador
    logic [1:0] A_mul;
    logic [3:0] B_mul;
    logic [3:0] Y_mul;
    logic Z_mul, N_mul, C_mul, V_mul;

    // Señales para restador
    logic [3:0] A_res, B_res;
    logic [3:0] Y_res;
    logic Z_res, N_res, C_res, V_res;

    // Instancia del multiplicador
    multiplicador_circular uut_mul (
        .A(A_mul),
        .B(B_mul),
        .Y(Y_mul),
        .Z(Z_mul),
        .N(N_mul),
        .C(C_mul),
        .V(V_mul)
    );

    // Instancia del restador
    restador_circular uut_res (
        .A(A_res),
        .B(B_res),
        .Y(Y_res),
        .Z(Z_res),
        .N(N_res),
        .C(C_res),
        .V(V_res)
    );

    // Proceso de testeo
    initial begin
        $display("========== TEST: MULTIPLICADOR CIRCULAR ==========");
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 16; j++) begin
                A_mul = i[1:0];
                B_mul = j[3:0];
                #10;
                $display("A=%0d B=%0d -> Y=%0d Z=%b N=%b C=%b V=%b", A_mul, B_mul, Y_mul, Z_mul, N_mul, C_mul, V_mul);
            end
        end

        $display("\n========== TEST: RESTADOR CIRCULAR ==========");
        for (int a = 0; a < 16; a++) begin
            for (int b = 0; b < 16; b++) begin
                A_res = a[3:0];
                B_res = b[3:0];
                #10;
                $display("A=%0d B=%0d -> Y=%0d Z=%b N=%b C=%b V=%b", A_res, B_res, Y_res, Z_res, N_res, C_res, V_res);
            end
        end

        $stop;
    end

endmodule

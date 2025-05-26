module multiplicador_circular (
    input  logic [1:0] A,
    input  logic [3:0] B,
    output logic [3:0] Y,
    output logic Z,   // Zero flag
    output logic N,   // Negative flag
    output logic C,   // Carry flag
    output logic V    // Overflow flag
);
    // Productos pre-calculados
    logic [3:0] prod0, prod1, prod2, prod3;
    logic [4:0] temp3;  // Para capturar carry en 3×B

    assign prod0 = 4'b0000;
    assign prod1 = B;
    assign prod2 = {B[2:0], 1'b0};              // 2×B = B << 1
    assign temp3 = B + {B[2:0], 1'b0};          // 3×B = B + 2×B
    assign prod3 = temp3[3:0];                  // modulo 16

    // Selector estructural para Y
    assign Y[0] = (~A[1] & ~A[0] & prod0[0]) |
                  (~A[1] &  A[0] & prod1[0]) |
                  ( A[1] & ~A[0] & prod2[0]) |
                  ( A[1] &  A[0] & prod3[0]);

    assign Y[1] = (~A[1] & ~A[0] & prod0[1]) |
                  (~A[1] &  A[0] & prod1[1]) |
                  ( A[1] & ~A[0] & prod2[1]) |
                  ( A[1] &  A[0] & prod3[1]);

    assign Y[2] = (~A[1] & ~A[0] & prod0[2]) |
                  (~A[1] &  A[0] & prod1[2]) |
                  ( A[1] & ~A[0] & prod2[2]) |
                  ( A[1] &  A[0] & prod3[2]);

    assign Y[3] = (~A[1] & ~A[0] & prod0[3]) |
                  (~A[1] &  A[0] & prod1[3]) |
                  ( A[1] & ~A[0] & prod2[3]) |
                  ( A[1] &  A[0] & prod3[3]);

    // FLAG: Zero (Z)
    assign Z = ~(Y[0] | Y[1] | Y[2] | Y[3]);

    // FLAG: Negative (N)
    assign N = Y[3];  // MSB

    // FLAG: Carry (C)
    // Solo hay riesgo de acarreo en 3×B (temp3[4])
    assign C = ( A[1] &  A[0] & temp3[4]); // solo si A == 3

    // FLAG: Overflow (V)
    // Overflow en complemento a 2 solo posible cuando el signo se invierte inesperadamente
    logic signed [3:0] sB, sY;
    assign sB = B;
    assign sY = Y;
    assign V = ((A != 2'b00) & ((sB[3] == 0 && sY[3] == 1) || (sB[3] == 1 && sY[3] == 0)));

endmodule

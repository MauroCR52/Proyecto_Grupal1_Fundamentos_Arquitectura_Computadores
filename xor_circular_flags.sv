module xor_circular_flags (
    input  logic [1:0] A,      // Entrada de 2 bits
    input  logic [3:0] B,      // Entrada de 4 bits
    output logic [3:0] Y,      // Resultado XOR circular
    output logic       N,      // Flag Negativo
    output logic       Z,      // Flag Zero
    output logic       C,      // Flag Carry (usaremos el bit más significativo de A)
    output logic       V       // Flag Overflow (basado en MSBs de A y B)
);

    // XOR circular (estructural)
    assign Y[0] = A[0] ^ B[0];
    assign Y[1] = A[1] ^ B[1];
    assign Y[2] = A[0] ^ B[2];
    assign Y[3] = A[1] ^ B[3];

    // Flags
    assign N = Y[3];                     // Negativo: bit más significativo del resultado
    assign Z = ~(Y[0] | Y[1] | Y[2] | Y[3]); // Zero: si todos los bits son cero
    assign C = A[1];                     // Carry: último bit desplazado (definido como MSB de A)
    assign V = (A[1] & ~B[3]) | (~A[1] & B[3]); // Overflow: XOR lógico entre MSBs de A y B

endmodule

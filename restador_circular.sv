module restador_circular (
    input  logic [3:0] A,
    input  logic [3:0] B,
    output logic [3:0] Y,
    output logic Z,     // Zero
    output logic N,     // Negative
    output logic C,     // Carry/Borrow
    output logic V      // Overflow
);

    // Señales internas para carry intermedio
    logic c0, c1, c2, c3, c4;
    logic b0n, b1n, b2n, b3n; // B negado (para complemento a 2)

    // Invertimos B
    assign b0n = ~B[0];
    assign b1n = ~B[1];
    assign b2n = ~B[2];
    assign b3n = ~B[3];

    // Suma de A + (~B + 1) usando sumadores completos

    // Bit 0
    assign c0 = 1'b1; // sumamos +1 para complemento a 2
    assign Y[0] = A[0] ^ b0n ^ c0;
    assign c1 = (A[0] & b0n) | (A[0] & c0) | (b0n & c0);

    // Bit 1
    assign Y[1] = A[1] ^ b1n ^ c1;
    assign c2 = (A[1] & b1n) | (A[1] & c1) | (b1n & c1);

    // Bit 2
    assign Y[2] = A[2] ^ b2n ^ c2;
    assign c3 = (A[2] & b2n) | (A[2] & c2) | (b2n & c2);

    // Bit 3
    assign Y[3] = A[3] ^ b3n ^ c3;
    assign c4 = (A[3] & b3n) | (A[3] & c3) | (b3n & c3);

    // Flags
    assign Z = ~(Y[0] | Y[1] | Y[2] | Y[3]);
    assign N = Y[3];
    assign C = ~c4; // CARRY significa borrow en resta: se presta si no hay carry final
    assign V = (A[3] & ~B[3] & ~Y[3]) | (~A[3] & B[3] & Y[3]);

endmodule

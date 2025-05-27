module encoder42 (
    input  logic [3:0] S,      // Entradas de fotoresistencias: S[3:0]
    output logic [1:0] Y       // Salida codificada: A de la ALU
);
    assign Y[0] = S[3] | S[1]; // Y0 = S3 + S1
    assign Y[1] = S[3] | S[2]; // Y1 = S3 + S2
endmodule
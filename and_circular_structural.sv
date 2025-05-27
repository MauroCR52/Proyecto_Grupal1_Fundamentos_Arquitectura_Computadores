module and_circular_structural (
    input  logic [1:0] A,         // Entrada de 2 bits
    input  logic [3:0] B,         // Entrada de 4 bits
    output logic [3:0] Y,         // Resultado del AND circular
    output logic       zero,      // Flag Zero
    output logic       negativo,  // Flag Negativo
    output logic       carry,     // Flag Carry
    output logic       overflow   // Flag Overflow
);

// Variables internas
logic [3:0] A_ext; // A extendido circularmente a 4 bits
logic [3:0] and_result;

// Rotación circular de A para igualar a 4 bits
// A_ext = {A[1], A[0], A[1], A[0]}
assign A_ext[3] = A[1];
assign A_ext[2] = A[0];
assign A_ext[1] = A[1];
assign A_ext[0] = A[0];

// Operación AND bit a bit
assign and_result[3] = A_ext[3] & B[3];
assign and_result[2] = A_ext[2] & B[2];
assign and_result[1] = A_ext[1] & B[1];
assign and_result[0] = A_ext[0] & B[0];

// Salida
assign Y = and_result;

// Flags
assign zero     = ~(and_result[3] | and_result[2] | and_result[1] | and_result[0]); // todos ceros
assign negativo = and_result[3];   // MSB = 1
assign carry    = A[1] & A[0];     // Si ambos bits de A son 1, al rotar "sobresalen"
assign overflow = (A_ext[3] ^ and_result[3]); // cambio en MSB tras la operación

endmodule

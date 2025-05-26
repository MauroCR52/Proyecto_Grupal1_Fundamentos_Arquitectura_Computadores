module alu_controladora (
    input  logic [1:0] A,
    input  logic [3:0] B,
    input  logic [1:0] op,
    output logic [3:0] Y,
    output logic       Z,
    output logic       N,
    output logic       C,
    output logic       V
);

    // Salidas individuales de cada módulo
    logic [3:0] y_and, y_xor, y_mult, y_sub;
    logic z_and, n_and, c_and, v_and;
    logic z_xor, n_xor, c_xor, v_xor;
    logic z_mult, n_mult, c_mult, v_mult;
    logic z_sub, n_sub, c_sub, v_sub;

    // Instancias
    and_circular_structural and_mod (
        .A(A),
        .B(B),
        .Y(y_and),
        .zero(z_and),
        .negativo(n_and),
        .carry(c_and),
        .overflow(v_and)
    );

    xor_circular_flags xor_mod (
        .A(A),
        .B(B),
        .Y(y_xor),
        .Z(z_xor),
        .N(n_xor),
        .C(c_xor),
        .V(v_xor)
    );

    multiplicador_circular mult_mod (
        .A(A),
        .B(B),
        .Y(y_mult),
        .Z(z_mult),
        .N(n_mult),
        .C(c_mult),
        .V(v_mult)
    );

    restador_circular sub_mod (
        .A({2'b00, A}),
        .B(B),
        .Y(y_sub),
        .Z(z_sub),
        .N(n_sub),
        .C(c_sub),
        .V(v_sub)
    );

    // Selector de cada bit basado en op[1:0]
    logic sel_and, sel_xor, sel_mult, sel_sub;

    assign sel_and  = ~op[1] & ~op[0];  // 00
    assign sel_xor  = ~op[1] &  op[0];  // 01
    assign sel_mult =  op[1] & ~op[0];  // 10
    assign sel_sub  =  op[1] &  op[0];  // 11

    // Combinación estructural usando puertas lógicas
    assign Y[0] = (y_and[0] & sel_and) |
                  (y_xor[0] & sel_xor) |
                  (y_mult[0] & sel_mult) |
                  (y_sub[0] & sel_sub);

    assign Y[1] = (y_and[1] & sel_and) |
                  (y_xor[1] & sel_xor) |
                  (y_mult[1] & sel_mult) |
                  (y_sub[1] & sel_sub);

    assign Y[2] = (y_and[2] & sel_and) |
                  (y_xor[2] & sel_xor) |
                  (y_mult[2] & sel_mult) |
                  (y_sub[2] & sel_sub);

    assign Y[3] = (y_and[3] & sel_and) |
                  (y_xor[3] & sel_xor) |
                  (y_mult[3] & sel_mult) |
                  (y_sub[3] & sel_sub);

    assign Z = (z_and & sel_and) |
               (z_xor & sel_xor) |
               (z_mult & sel_mult) |
               (z_sub & sel_sub);

    assign N = (n_and & sel_and) |
               (n_xor & sel_xor) |
               (n_mult & sel_mult) |
               (n_sub & sel_sub);

    assign C = (c_and & sel_and) |
               (c_xor & sel_xor) |
               (c_mult & sel_mult) |
               (c_sub & sel_sub);

    assign V = (v_and & sel_and) |
               (v_xor & sel_xor) |
               (v_mult & sel_mult) |
               (v_sub & sel_sub);

endmodule

module pwm (
    input  logic clk,
    input  logic rst,
    input  logic [3:0] duty_in,
    output logic pwm_out
);

    parameter MAX_COUNT = 4'd15;

    logic [3:0] counter;
    logic [3:0] counter_next;

    // Detecta si counter es 15 (1111)
    logic is_max;
	 
	 assign is_max = &counter; // AND de todos los bits (1 si todos son 1)

    // Generación del siguiente contador sin if ni ternarios
    // Si is_max=1 -> siguiente es 0; si no, siguiente es counter+1
    assign counter_next = (counter + 1) & {4{~is_max}};

    // Flip-flop del contador con reset asincrono
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 4'b0000;
        else
            counter <= counter_next;
    end
	 
    // Instanciamos un comparador de magnitud de 4 bits
    // pwm_out = (counter < duty_in)

    logic [3:0] a, b;
    assign a = counter;
    assign b = duty_in;

    // Comparador menor que (a < b) sin if ni ternarios:
    // Fórmula simplificada:
    // a < b = (a3 < b3) o (a3 == b3 y a2 < b2) o ...
    // Se implementa con lógica combinacional

    logic lt;

    assign lt = (~a[3] & b[3]) | 
                ((a[3] ~^ b[3]) & (~a[2] & b[2])) |
                ((a[3] ~^ b[3]) & (a[2] ~^ b[2]) & (~a[1] & b[1])) |
                ((a[3] ~^ b[3]) & (a[2] ~^ b[2]) & (a[1] ~^ b[1]) & (~a[0] & b[0]));

    assign pwm_out = lt;

endmodule
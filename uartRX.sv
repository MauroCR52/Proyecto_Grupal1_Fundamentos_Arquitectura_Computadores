module uartRX (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire rx,           // Señal de entrada RX (UART)
    output reg [7:0] data,   // Datos recibidos (8 bits completos)
    output reg valid         // Señal de validez
);

    // Parámetros para UART
    parameter CLK_FREQ = 50000000;  // Frecuencia de reloj (50 MHz)
    parameter BAUD_RATE = 9600;     // Velocidad de UART
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;  // 5208 ticks por cada bit a 9600 baudios

    reg [15:0] baud_count;   // Contador para los ticks del baudrate
    reg [3:0] bit_count;     // Contador de los bits recibidos
    reg [7:0] shift_reg;     // Registro de desplazamiento para recibir los bits
    reg [1:0] state, next_state;  // Estado y siguiente estado de la FSM

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    // Bloque secuencial
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;  // El estado siguiente viene de la lógica combinacional
        end
    end  

    // Bloque secuencial para registros
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            baud_count <= 0;
            bit_count <= 0;
            shift_reg <= 0;
            valid <= 0;
            data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    valid <= 0;
                    baud_count <= 0;
                    bit_count <= 0;
                    shift_reg <= 0;
                    data <= 0;
                end
                START: begin
                    if (baud_count == BAUD_TICK / 2) begin
                        baud_count <= 0;
                        bit_count <= 0;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                DATA: begin
                    if (baud_count == BAUD_TICK) begin
                        baud_count <= 0;
                        shift_reg <= {rx, shift_reg[7:1]};
                        bit_count <= bit_count + 1;
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
                STOP: begin
                    if (baud_count == BAUD_TICK) begin
                        baud_count <= 0;
                        if (rx) begin
                            data <= shift_reg;
                            valid <= 1;
                        end
                    end else begin
                        baud_count <= baud_count + 1;
                    end
                end
            endcase
        end
    end

    // Lógica combinacional para transición de estados
    always_comb begin
        next_state = state;  // Por defecto, el próximo estado es el estado actual
        case (state)
            IDLE: begin
                if (!rx) begin
                    next_state = START;
                end
            end
            START: begin
                if (baud_count == BAUD_TICK / 2) begin
                    next_state = DATA;
                end
            end
            DATA: begin
                if (bit_count == 7 && baud_count == BAUD_TICK) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                if (baud_count == BAUD_TICK) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule

`timescale 1ns / 1ps

module uartTOP (
    input wire clk,
    input wire rst_n,
    input wire rx,
    output wire tx,
    input wire rts,
    output reg cts,
    output logic [6:0] seg,        // salida 7 segmentos
    output logic pwm_out,          // salida PWM
    output reg [7:0] leds,         // LEDs para debug
    input wire [3:0] fotoresistencias, // entradas A (codificadas)
    input wire [1:0] switches          // operación ALU
);

    // UART
    wire [7:0] rx_data;
    wire rx_valid;
    wire uart_busy;
    reg [7:0] tx_data;
    reg tx_start;
    reg prev_rx_valid;
    reg trigger_tx;

    // ALU
    wire [3:0] Y;
    wire Z, N, C, V;
    wire [1:0] A;
    reg  [3:0] B_reg;              // registro para almacenar B
    wire [3:0] B;

    assign B = B_reg;              // conectar a la ALU

    // Codificador 4:2
    encoder42 codif (
        .S(fotoresistencias),
        .Y(A)
    );

    // UART Receiver
    uartRX receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );

    // UART Transmitter
    uartTX transmitter (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tx_data),
        .send(tx_start),
        .tx(tx),
        .busy(uart_busy)
    );

    // ALU
    alu_controladora alu (
        .A(A),
        .B(B),
        .op(switches),
        .Y(Y),
        .Z(Z),
        .N(N),
        .C(C),
        .V(V)
    );

    // PWM: usa resultado de la ALU
    pwm pwm_inst (
        .clk(clk),
        .rst(~rst_n),     // reset activo alto
        .duty_in(Y),
        .pwm_out(pwm_out)
    );

    // Display 7 segmentos: muestra resultado ALU
    seg7_display display (
        .Y(Y),
        .seg(seg)
    );

    // Lógica de control principal
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            leds <= 8'b0;
            tx_data <= 8'b0;
            tx_start <= 1'b0;
            trigger_tx <= 1'b0;
            prev_rx_valid <= 1'b0;
            cts <= 1'b0;
            B_reg <= 4'b0000;
        end else begin
            // Handshake UART
            cts <= rts;

            // Detección de nuevo byte UART recibido
            prev_rx_valid <= rx_valid;
				if (rx_valid && !prev_rx_valid) begin
					 leds <= {Z, N, C, V, rx_data[3:0]}; // ← Flags de la ALU + rx_data
					 tx_data <= rx_data;
					 B_reg <= rx_data[3:0];   // Captura entrada B para ALU
					 trigger_tx <= 1'b1;
				end

            // Inicio de transmisión UART
            if (trigger_tx && !uart_busy) begin
                tx_start <= 1'b1;
                trigger_tx <= 1'b0;
            end else begin
                tx_start <= 1'b0;
            end
        end
    end

endmodule
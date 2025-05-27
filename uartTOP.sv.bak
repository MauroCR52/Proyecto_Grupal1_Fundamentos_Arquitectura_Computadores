`timescale 1ns / 1ps

module uartTOP (
    input wire clk,
    input wire rst_n,
    input wire rx,
    output wire tx,
    input wire rts,
    output reg cts,
    output reg [7:0] leds
);

    wire [7:0] rx_data;
    wire rx_valid;
    wire uart_busy;

    reg [7:0] tx_data;
    reg tx_start;
    reg prev_rx_valid;
    reg trigger_tx;

  
    uartRX receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(rx_data),
        .valid(rx_valid)
    );

    
    uartTX transmitter (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(tx_data),
        .send(tx_start),
        .tx(tx),
        .busy(uart_busy)
    );

  
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            leds <= 8'b0;
            tx_data <= 8'b0;
            tx_start <= 1'b0;
            trigger_tx <= 1'b0;
            prev_rx_valid <= 1'b0;
            cts <= 1'b0;
        end else begin
            // Handshake
            cts <= rts;

            // byte recibido
            prev_rx_valid <= rx_valid;
            if (rx_valid && !prev_rx_valid) begin
                leds <= rx_data;
                tx_data <= rx_data;
                trigger_tx <= 1'b1;
            end

            // enviar data
            if (trigger_tx && !uart_busy) begin
                tx_start <= 1'b1;
                trigger_tx <= 1'b0;
            end else begin
                tx_start <= 1'b0;
            end
        end
    end

endmodule

`timescale 1ns / 1ps

module uartTOP (
    input wire clk,          // Reloj del sistema
    input wire rst_n,        // Reset activo en bajo
    input wire rx,           // Señal RX de UART (desde Arduino)
    output reg [7:0] leds,   // LEDs de la FPGA
    output wire tx,           // Señal TX de UART (hacia Arduino)
	 input wire rts,   // Señal de "Request to Send" desde el Arduino
    output reg cts    // Señal de "Clear to Send" hacia el Arduino
);

    wire [7:0] uart_data_full_rx;  // Datos recibidos por UART (desde Arduino)
    wire [3:0] uart_data_rx;       // Solo los 4 bits menos significativos de los datos recibidos
    wire valid_rx;                 // Señal que indica que los datos recibidos son válidos
    reg [7:0] data_to_send;        // Datos que la FPGA enviará a través de UART
    reg send;                      // Señal para iniciar la transmisión
    reg valid_rx_d;                // Registro para almacenar valid anterior
wire busy_uart;

    // Instancia del receptor UART (RX)
    uartRX uart_receiver (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .data(uart_data_full_rx),  // Dato completo de 8 bits recibido
        .valid(valid_rx)           // Señal de datos válidos
    );

	uartTX uart_transmitter (
		 .clk(clk),
		 .rst_n(rst_n),
		 .data_in(data_to_send),
		 .send(send),
		 .tx(tx),
		 .busy(busy_uart)  // ← conéctalo aquí
	);


	reg send_pending;

	always @(posedge clk or negedge rst_n) begin
		 if (!rst_n) begin
			  leds <= 8'b0;
			  data_to_send <= 8'b0;
			  send <= 0;
			  send_pending <= 0;
			  valid_rx_d <= 0;
		 end else begin
			  valid_rx_d <= valid_rx;

			  // Handshake
			  cts <= rts;

			  // Activar envío si llega un nuevo dato
			  if (valid_rx && !valid_rx_d) begin
					leds <= uart_data_full_rx;
					data_to_send <= uart_data_full_rx;
					send_pending <= 1;
			  end

			  // Manejo de señal 'send'
			  if (send_pending && !busy_uart) begin
					send <= 1;
					send_pending <= 0;
			  end else begin
					send <= 0;
			  end
		 end
	end

endmodule
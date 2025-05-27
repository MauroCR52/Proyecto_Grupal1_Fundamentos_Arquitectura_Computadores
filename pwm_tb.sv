`timescale 1ns/1ps

module pwm_tb;

    // Señales de prueba
    logic clk;
    logic rst;
    logic [3:0] duty_in;
    logic pwm_out;

    // Instancia del DUT (Device Under Test)
    pwm dut (
        .clk(clk),
        .rst(rst),
        .duty_in(duty_in),
        .pwm_out(pwm_out)
    );

    // Reloj de 100 MHz (periodo 10 ns)
    always #5 clk = ~clk;

    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        duty_in = 4'd0;

        // Reset inicial
        #20;
        rst = 0;

        // Probar duty_in de 0 a 15
        for (int i = 0; i < 16; i++) begin
            duty_in = i[3:0];
            $display("\n--- Probando duty_in = %0d ---", i);
            repeat (60) @(posedge clk);  // Esperar 20 ciclos de reloj por valor
        end

        $finish;
    end

    // Monitor para mostrar valores en consola
    initial begin
        $display("Tiempo\tclk\trst\tduty_in\tpwm_out");
        $monitor("%t\t%b\t%b\t%2d\t%b", $time, clk, rst, duty_in, pwm_out);
    end

endmodule
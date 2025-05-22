module uartRX (
    input wire clk,         
    input wire rst_n,        
    input wire rx,           
    output reg [7:0] data,   
    output reg valid         
);

    
    parameter CLK_FREQ = 50000000;  
    parameter BAUD_RATE = 9600;     
    localparam BAUD_TICK = CLK_FREQ / BAUD_RATE;  // 5208 ticks por cada bit a 9600 baudios

    reg [15:0] baud_count;   
    reg [3:0] bit_count;    
    reg [7:0] shift_reg;     
    reg [1:0] state, next_state;  

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;  
        end
    end  

    // registros
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

    always_comb begin
        next_state = state;  
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

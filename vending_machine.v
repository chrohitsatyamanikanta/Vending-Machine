module vending_machine (
    input clk,
    input rst,
    input [1:0] in,       // 01 = 5 Rs, 10 = 10 Rs
    output reg out,
    output reg [1:0] change
);

    parameter s0 = 2'b00;
    parameter s1 = 2'b01;
    parameter s2 = 2'b10;

    reg [1:0] c_state, n_state;

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            c_state  <= 2'b00;
            n_state  <= 2'b00;
            out      <= 1'b0;
            change   <= 2'b00;
        end
        else begin
            c_state <= n_state;
            
            case (c_state)
                s0: begin // State 0: 0 Rs
                    if (in == 2'b00) begin
                        n_state = s0;
                        out     = 1'b0;
                        change  = 2'b00;
                    end
                    else if (in == 2'b01) begin
                        n_state = s1;
                        out     = 1'b0;
                        change  = 2'b00;
                    end
                    else if (in == 2'b10) begin
                        n_state = s2;
                        out     = 1'b0;
                        change  = 2'b00;
                    end
                end

                s1: begin // State 1: 5 Rs
                    if (in == 2'b00) begin
                        n_state = s0;
                        out     = 1'b0;
                        change  = 2'b01; // Change returned: 5 Rs
                    end
                    else if (in == 2'b01) begin
                        n_state = s2;
                        out     = 1'b0;
                        change  = 2'b00;
                    end
                    else if (in == 2'b10) begin
                        n_state = s0;
                        out     = 1'b1;
                        change  = 2'b00;
                    end
                end

                s2: begin // State 2: 10 Rs
                    if (in == 2'b00) begin
                        n_state = s0;
                        out     = 1'b0;
                        change  = 2'b10; // Change returned: 10 Rs
                    end
                    else if (in == 2'b01) begin
                        n_state = s0;
                        out     = 1'b1;
                        change  = 2'b00;
                    end
                    else if (in == 2'b10) begin
                        n_state = s0;
                        out     = 1'b1;
                        change  = 2'b01; // Change returned: 5 Rs + 1 bottle
                    end
                end

                default: begin
                    n_state = s0;
                    out     = 1'b0;
                    change  = 2'b00;
                end
            endcase
        end
    end

endmodule

// 8-bit Serial-In Serial-Out (SISO) Shift Register
// Positive-edge triggered, synchronous active-high reset

module shift_register (
    input  wire clk,      // Clock signal
    input  wire reset,    // Synchronous active-high reset
    input  wire data_in,  // Serial data input
    output wire data_out  // Serial data output (MSB)
);

    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'b0;
        else
            shift_reg <= {shift_reg[6:0], data_in};
    end

    assign data_out = shift_reg[7];

endmodule

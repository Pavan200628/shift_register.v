// 4-bit Universal Shift Register
// mode: 00 = Hold, 01 = Shift Right, 10 = Shift Left, 11 = Parallel Load
module shift_register (
    input        clk,
    input        reset,
    input  [1:0] mode,
    input        serial_in,
    input  [3:0] parallel_in,
    output reg [3:0] data_out,
    output       serial_out
);

    // serial_out carries the bit shifted out (MSB for left-shift, LSB for right-shift)
    assign serial_out = data_out[3];

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 4'b0000;
        else begin
            case (mode)
                2'b00: data_out <= data_out;                        // Hold
                2'b01: data_out <= {serial_in, data_out[3:1]};     // Shift Right
                2'b10: data_out <= {data_out[2:0], serial_in};     // Shift Left
                2'b11: data_out <= parallel_in;                     // Parallel Load
            endcase
        end
    end

endmodule

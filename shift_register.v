module shift_register #(
    parameter N = 4   // Change to 8 for 8-bit
)(
    input clk,
    input reset,
    input [1:0] mode,   // 00 = Hold, 01 = Shift Right, 10 = Shift Left, 11 = Parallel Load
    input serial_in,
    input [N-1:0] parallel_in,
    output reg [N-1:0] data_out,
    output serial_out
);

assign serial_out = (mode == 2'b01) ? data_out[0] : data_out[N-1];

always @(posedge clk or posedge reset) begin
    if (reset)
        data_out <= 0;
    else begin
        case (mode)
            2'b00: data_out <= data_out; // Hold

            2'b01: // Shift Right
                data_out <= {serial_in, data_out[N-1:1]};

            2'b10: // Shift Left
                data_out <= {data_out[N-2:0], serial_in};

            2'b11: // Parallel Load
                data_out <= parallel_in;

            default: data_out <= data_out;
        endcase
    end
end

endmodule

`timescale 1ns/1ps

module shift_register_tb;

reg clk;
reg reset;
reg [1:0] mode;
reg serial_in;
reg [3:0] parallel_in;
wire [3:0] data_out;
wire serial_out;

// Instantiate DUT
shift_register #(4) uut (
    .clk(clk),
    .reset(reset),
    .mode(mode),
    .serial_in(serial_in),
    .parallel_in(parallel_in),
    .data_out(data_out),
    .serial_out(serial_out)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    mode = 2'b00;
    serial_in = 0;
    parallel_in = 4'b0000;

    #10 reset = 0;

    // Parallel Load
    #10 mode = 2'b11; parallel_in = 4'b1011;

    // Hold
    #10 mode = 2'b00;

    // Shift Right
    #10 mode = 2'b01; serial_in = 1;
    #10 serial_in = 0;

    // Shift Left
    #10 mode = 2'b10; serial_in = 1;
    #10 serial_in = 0;

    #50 $finish;
end

endmodule

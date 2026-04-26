`timescale 1ns/1ps

module shift_register_tb;

    // ---------- DUT signals ----------
    reg        clk;
    reg        reset;
    reg  [1:0] mode;
    reg        serial_in;
    reg  [3:0] parallel_in;
    wire [3:0] data_out;
    wire       serial_out;

    // ---------- Instantiate DUT ----------
    shift_register uut (
        .clk         (clk),
        .reset       (reset),
        .mode        (mode),
        .serial_in   (serial_in),
        .parallel_in (parallel_in),
        .data_out    (data_out),
        .serial_out  (serial_out)
    );

    // ---------- Clock: period = 1000 ps (1 ns) ----------
    initial clk = 0;
    always #500 clk = ~clk;

    // ---------- Stimulus ----------
    initial begin
        // Default values
        reset       = 1;
        mode        = 2'b00;
        serial_in   = 0;
        parallel_in = 4'b1011;

        // Hold reset for 2 clock cycles
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // --- Parallel Load ---
        mode = 2'b11;
        @(posedge clk); #1;

        // --- Shift Left (mode=10), serial_in=0 ---
        mode      = 2'b10;
        serial_in = 0;
        repeat (8) @(posedge clk);

        // --- Shift Right (mode=01), serial_in=1 ---
        mode      = 2'b01;
        serial_in = 1;
        repeat (8) @(posedge clk);

        // --- Hold (mode=00) ---
        mode = 2'b00;
        repeat (4) @(posedge clk);

        // --- Parallel Load again ---
        mode        = 2'b11;
        parallel_in = 4'b1011;
        @(posedge clk); #1;

        // --- Shift Left (mode=10), serial_in=0 (matches screenshot state) ---
        mode      = 2'b10;
        serial_in = 0;
        repeat (100) @(posedge clk);

        $stop;
    end

    // ---------- Monitor ----------
    initial begin
        $monitor("Time=%0t | clk=%b reset=%b mode=%b serial_in=%b parallel_in=%b | data_out=%b serial_out=%b",
                 $time, clk, reset, mode, serial_in, parallel_in, data_out, serial_out);
    end

endmodule

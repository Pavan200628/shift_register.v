// Testbench for shift_register module
// Compatible with ModelSim and iverilog; generates VCD waveform output

`timescale 1ns/1ps

module shift_register_tb;

    // Inputs
    reg clk;
    reg reset;
    reg data_in;

    // Output
    wire data_out;

    // Instantiate the Unit Under Test (UUT)
    shift_register uut (
        .clk      (clk),
        .reset    (reset),
        .data_in  (data_in),
        .data_out (data_out)
    );

    // Clock generation: 10 ns period (100 MHz)
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump for ModelSim / GTKWave
    initial begin
        $dumpfile("shift_register.vcd");
        $dumpvars(0, shift_register_tb);
    end

    // Stimulus
    initial begin
        // Initialise
        reset   = 1;
        data_in = 0;

        // Hold reset for two clock cycles
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;

        // Shift in the pattern 1011_0010 (MSB first)
        data_in = 1; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;
        data_in = 1; @(posedge clk); #1;
        data_in = 1; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;
        data_in = 1; @(posedge clk); #1;
        data_in = 0; @(posedge clk); #1;

        // The first input bit (1) should now appear on data_out
        $display("data_out = %b (expected 1)", data_out);
        if (data_out !== 1'b1)
            $display("FAIL: data_out mismatch");
        else
            $display("PASS");

        // Apply synchronous reset and verify output goes low
        reset = 1;
        @(posedge clk); #1;
        reset = 0;
        $display("After reset, data_out = %b (expected 0)", data_out);
        if (data_out !== 1'b0)
            $display("FAIL: reset did not clear shift register");
        else
            $display("PASS");

        // Run a few more cycles then finish
        repeat (4) @(posedge clk);
        $finish;
    end

endmodule

`timescale 1ns/1ps

// Test bench for FIFO Module
module FIFO_tb;

    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 4;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the FIFO module
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock Generation
    initial begin
        clk = 0;
        // indicates a delay of 5 time units, clock signal inverted after 5 time units
        // This creates a 10ns period clock signal
        forever #5 clk = ~clk; 
    end

    // Test case 1: Write to FIFO, then read from FIFO
    initial begin
        // Reset FIFO and prepare to write
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Release reset, wait 10ns 
        #10;
        rst = 0;

        // Write to FIFO
        #10;
        wr_en = 1;
        data_in = 8'hA5;
        #10;
        wr_en = 0;

        // Read from FIFO
        #10;
        rd_en = 1;
        #10;
        rd_en = 0;

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor outputs 
    initial begin
        $monitor("Time: %0d, rst: %b, wr_en: %b, rd_en: %b, data_in: %h, data_out: %h, full: %b, empty: %b", 
                 $time, rst, wr_en, rd_en, data_in, data_out, full, empty);
    end

    // VCD Dump file 
    initial begin
        $dumpfile("FIFO_tb.vcd");
        $dumpvars(0, FIFO_tb); // Dump all variables in the testbench 
    end 

endmodule




    
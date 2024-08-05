`timescale 1ns/1ps

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
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Reset FIFO and prepare to write
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        #10;
        rst = 0;

        // Write 16 values to FIFO
        for (integer i = 1; i <= 16; i = i + 1) begin
            write_fifo(i);
        end

        // Attempt to write 17th value
        write_fifo(8'hFF);

        // Read all 16 values back from FIFO
        for (integer i = 1; i <= 16; i = i + 1) begin
            read_fifo();
        end

        // Reset the FIFO
        rst = 1;
        #10;
        rst = 0;

        // Finish simulation
        #20;
        $finish;
    end

    // Tasks for writing to and reading from the FIFO
    task write_fifo(input [DATA_WIDTH-1:0] data);
    begin
        wr_en = 1;
        data_in = data;
        #10;
        wr_en = 0;
        #10;
    end
    endtask

    task read_fifo();
    begin
        rd_en = 1;
        #10;
        rd_en = 0;
        #10;
    end
    endtask

    // Monitor outputs
    initial begin
        $monitor("Time: %0d, rst: %b, wr_en: %b, rd_en: %b, data_in: %h, data_out: %h, full: %b, empty: %b", 
                 $time, rst, wr_en, rd_en, data_in, data_out, full, empty);
    end 

    // VCD Dump
    initial begin
        $dumpfile("../test_output/FIFO_tb_2/FIFO_tb_2.vcd");
        $dumpvars(0, FIFO_tb);
    end

endmodule


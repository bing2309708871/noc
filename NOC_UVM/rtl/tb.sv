`timescale 1 ns / 1 ps

module tb;
    import noc_pkg::*;

    reg clk;
    reg rst_n;

    NOC_if noc_if(clk,rst_n);


    noc dut
    (
        .clk    (clk),
        .rst_n  (rst_n),
        .router_i   (noc_if.router_i),
        .router_o   (noc_if.router_o)
    );

    // An example to create a clock
    initial clk = 1'b0;
    always #2 clk <= ~clk;

    initial begin
        rst_n <= 1'bx;
        #10;
        rst_n <= 1'b0;
        #10;
        rst_n <= 1'b1;
    end


endmodule


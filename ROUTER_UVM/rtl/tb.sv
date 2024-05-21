`timescale 1 ns / 1 ps

module tb;
    import noc_pkg::*;


    reg clk;
    reg rst_n;

    router_if vif(clk,rst_n);

    //router_i_t [PORT_N-1:0]  cb_i;
    


    router dut
    (
        .clk    (clk),
        .rst_n  (rst_n),
        .router_i   (router_if.router_i),
        .router_o   (router_if.router_o),
        .wire_i     (router_if.wire_i),
        .wire_o     (router_if.wire_o),
        .my_xpos    (router_if.my_xpos),
        .my_ypos    (router_if.my_ypos)
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


`timescale 1 ns / 1 ps

module tb;
    import noc_pkg::*;


    reg clk;
    reg rst_n;

    cb_if vif(clk,rst_n);

    //router_i_t [PORT_N-1:0]  cb_i;
    


    cb dut
    (
        .cb_i   (vif.router_i),
        .cb_o   (vif.router_o),
        .port_i (vif.port),
        .req_i  (vif.req),
        .grt_o  (vif.grt)
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


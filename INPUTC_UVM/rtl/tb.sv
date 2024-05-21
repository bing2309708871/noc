`timescale 1 ns / 1 ps

module tb;
    import noc_pkg::*;


    reg clk;
    reg rst_n;

    inputc_if vif(clk,rst_n);

    //router_i_t [PORT_N-1:0]  cb_i;
    


    inputc dut
    (
        .clk    (clk),
        .rst_n  (rst_n),
        .inputc_i   (vif.inputc_i),
        .inputc_o   (vif.inputc_o),
        .wire_i     (vif.wire_i),
        .wire_o     (vif.wire_o),
        .port_o (vif.port),
        .req_o  (vif.req),
        .my_xpos(vif.my_xpos),
        .my_ypos(vif.my_ypos)
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


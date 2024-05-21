interface inputc_if(input logic clk,input logic rst_n);
    import noc_pkg::*;

    logic   [PORT_W-1:0]    port;

    logic                   req;
    router_i_t            inputc_i;
    router_i_t            inputc_o;
    inputc_wire_i_t [PORT_N-1:0]    wire_i;
    inputc_wire_o_t                 wire_o;
    logic   [1:0]           my_xpos;
    logic   [1:0]           my_ypos;

    assert property (
        @(posedge clk)
        (rst_n==1'b0) |=> (req==0 | port==0)
        );
endinterface

interface router_if(input logic clk,input logic rst_n);
    import noc_pkg::*;

    router_i_t  [PORT_N-1:0]          router_i;
    router_i_t   [PORT_N-1:0]         router_o;
    inner_wire_t [PORT_N-1:0]    wire_i;
    inputc_wire_o_t [PORT_N-1:0]    wire_o;
    logic   [1:0]           my_xpos;
    logic   [1:0]           my_ypos;
endinterface

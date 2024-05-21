interface cb_if(input logic clk,input logic rst_n);
    import noc_pkg::*;

    logic   [PORT_N-1:0][PORT_W-1:0]    port;
    logic   [PORT_N-1:0]                req;
    logic   [PORT_N-1:0][PORT_N-1:0]    grt;  
    router_i_t [PORT_N-1:0]  router_i;
    router_i_t [PORT_N-1:0]  router_o;
endinterface

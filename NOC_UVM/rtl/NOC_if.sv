interface NOC_if(input logic clk,input logic rst_n);
    import noc_pkg::*;


    router_i_t  [15:0]          router_i;
    router_i_t   [15:0]         router_o;

endinterface

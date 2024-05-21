module vcmux import noc_pkg::*;
( 
    input   router_i_t  [VCH_N-1:0]            vcmux_i ,

    input   logic      [VCH_N-1:0]             req_i   ,
    input   logic   [VCH_N-1:0][PORT_W-1:0]   port_i  , 

    output  router_i_t              vcmux_o,
    output  logic                   req_o, 
    output  logic   [PORT_W-1:0]    port_o,  
    output  logic   [VCH_N-1:0]         vcsel_o  
);


    logic   [VCH_N-1:0] grt;   
    logic   [VCH_N-1:0] hold;   
    logic           anyhold;
    logic   [VCH_N-1:0][DATA_W-1:0]   data_wire  ;
    logic   [VCH_N-1:0][VCH_W-1:0]    vch_wire   ;
    logic   [VCH_N-1:0][PORT_W-1:0]    port_wire;

    logic   [VCH_N-1:0]   valid_wire; 
    logic   [VCH_N-1:0]   req_wire;

    assign  hold    = {req_i[0], req_i[1]};
    assign  anyhold = |hold; 
    assign  vcsel_o = grt;  

    assign  grt[0]  = req_i[0];
    assign  grt[1]  = !req_i[0] &  req_i[1];


    for(genvar i=VCH_N-1; i>=0; i--) begin
        if (i==VCH_N-1) begin
            assign data_wire[i] = grt[i] == ENABLE ? vcmux_i[i].data : '0;
            assign vch_wire[i]  = grt[i] == ENABLE ? vcmux_i[i].vch  : '0;
            assign port_wire[i] = grt[i] == ENABLE ? port_i[i]  : '0;
        end else begin
            assign data_wire[i] = grt[i] == ENABLE ? vcmux_i[i].data : data_wire[i+1];
            assign vch_wire[i]  = grt[i] == ENABLE ? vcmux_i[i].vch  : vch_wire[i+1];
            assign port_wire[i] = grt[i] == ENABLE ? port_i[i]  : port_wire[i+1];
        end
        assign valid_wire[i] = vcmux_i[i].valid;
        assign req_wire[i] = req_i[i];
    end

    assign  vcmux_o.data = data_wire[0];
    assign  vcmux_o.vch  = vch_wire[0];
    assign  vcmux_o.valid  = |valid_wire;
    assign  req_o     = |req_wire;
    assign  port_o       = port_wire[0];


endmodule

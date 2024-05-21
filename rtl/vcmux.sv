module vcmux import noc_pkg::*;
( 
    input   logic                   clk,
    input   logic                   rst_n,
    input   router_i_t  [1:0]            vcmux_i ,

    input   logic      [1:0]             req_i   ,
    input   logic   [1:0][PORT_W-1:0]   port_i  , 

    output  router_i_t              vcmux_o,
    output  logic                   req_o, 
    output  logic   [PORT_W-1:0]    port_o,  
    output  logic   [VCH:0]         vcsel_o  
);


    logic   [VCH:0] grt_q,grt_d;   
    logic   [VCH:0] hold;   
    logic           anyhold;
    logic   [1:0][DATAW:0]   data_wire  ;
    logic   [1:0][VCHW:0]    vch_wire   ;
    logic   [1:0][PORT_W-1:0]    port_wire;

    logic   [1:0]   valid_wire; 
    logic   [1:0]   req_wire;

    assign  hold    = grt_q & {req_i[0], req_i[1]};
    assign  anyhold = |hold; 
    assign  vcsel_o   = grt_q;  

    assign  grt_d[0]  = anyhold ? hold[0] : ( req_i[0]);
    assign  grt_d[1]  = anyhold ? hold[1] : (!req_i[0] &  req_i[1]);

    assign  vcmux_o.valid  = |valid_wire;
    assign  req_o     = |req_wire;

    for(genvar i=0; i<2; i++) begin
        assign data_wire[i] = grt_q[i] == ENABLE ? vcmux_i[i].data : '0;
        assign vch_wire[i]  = grt_q[i] == ENABLE ? vcmux_i[i].vch  : '0;
        assign port_wire[i] = grt_q[i] == ENABLE ? port_i[i]  : '0;
        assign valid_wire[i] = vcmux_i[i].valid;
        assign req_wire[i] = req_i[i];
    end

    assign  vcmux_o.data = |data_wire;
                  
    always_ff @ (posedge clk or negedge rst_n) begin          
        if (~rst_n) begin         
                grt_q    <= 'b0;
        end else begin      
                grt_q    <= grt_d;  
        end
    end   

endmodule

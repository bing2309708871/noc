module router import noc_pkg::*;
#( 
    parameter   ROUTERID = 0
)(
    input   logic                           clk,
    input   logic                           rst_n,

    input   router_i_t      [PORT_N-1:0]    router_i,
    output  router_i_t      [PORT_N-1:0]    router_o,

    input   inner_wire_t    [PORT_N-1:0]    wire_i,
    output  inputc_wire_o_t [PORT_N-1:0]    wire_o,

    input   logic           [ARRAY_W-1:0]   my_xpos,
    input   logic           [ARRAY_W-1:0]   my_ypos 
);

    // Wires from input channels (ic_) 
    router_i_t  [PORT_N-1:0]                ic_router;
    logic       [PORT_N-1:0][PORT_W-1:0]    ic_port;
    logic       [PORT_N-1:0]                ic_req;

    // Wires from crossbar (cb_) 
    router_i_t  [PORT_N-1:0]                cb_router;
    logic       [PORT_N-1:0][PORT_N-1:0]    cb_grt;

    // Wires from output channels (oc_) 
    inputc_wire_i_t [PORT_N-1:0][PORT_N-1:0]    oc_wire;
    logic       [PORT_N-1:0][VCH_N-1:0]         rdy_wire;
    logic       [PORT_N-1:0][VCH_N-1:0]         lck_wire;

    
    for(genvar i=0; i<PORT_N; i++) begin : i_router_in

        for(genvar j=0; j<PORT_N; j++) begin
            assign  oc_wire[i][j].rdy = rdy_wire[j];
            assign  oc_wire[i][j].lck = lck_wire[j];
            assign  oc_wire[i][j].grt = cb_grt[i][j];
        end
    end

        // Input physical channels 
        inputc #( ROUTERID, 0 ) i_inputc0 ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[0]),
            .wire_i     (oc_wire[0]),
            .inputc_o   (ic_router[0]),
            .wire_o     (wire_o[0]),
            .port_o       (ic_port[0]), 
            .req_o        (ic_req[0]), 
            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

        // Output channels 
        outputc #( ROUTERID, 0 ) oc_0 ( 
            .clk        (clk),          
            .rst_n      (rst_n),  
            .outputc_i   (cb_router[0]),
            .outputc_o   (router_o[0]),
            .wire_i     (wire_i[0]),
            .rdy_o       (rdy_wire[0]), 
            .lck_o       (lck_wire[0])
        );  

                // Input physical channels 
        inputc #( ROUTERID, 1 ) i_inputc1 ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[1]),
            .wire_i     (oc_wire[1]),
            .inputc_o   (ic_router[1]),
            .wire_o     (wire_o[1]),
            .port_o       (ic_port[1]), 
            .req_o        (ic_req[1]), 
            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

        // Output channels 
        outputc #( ROUTERID, 1 ) oc_1 ( 
            .clk        (clk),          
            .rst_n      (rst_n),  
            .outputc_i   (cb_router[1]),
            .outputc_o   (router_o[1]),
            .wire_i     (wire_i[1]),
            .rdy_o       (rdy_wire[1]), 
            .lck_o       (lck_wire[1])
        );    

        // Input physical channels 
        inputc #( ROUTERID, 2 ) i_inputc2 ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[2]),
            .wire_i     (oc_wire[2]),
            .inputc_o   (ic_router[2]),
            .wire_o     (wire_o[2]),
            .port_o       (ic_port[2]), 
            .req_o        (ic_req[2]), 
            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

        // Output channels 
        outputc #( ROUTERID, 2 ) oc_2 ( 
            .clk        (clk),          
            .rst_n      (rst_n),  
            .outputc_i   (cb_router[2]),
            .outputc_o   (router_o[2]),
            .wire_i     (wire_i[2]),
            .rdy_o       (rdy_wire[2]), 
            .lck_o       (lck_wire[2])
        );    
        // Input physical channels 
        inputc #( ROUTERID, 3 ) i_inputc3 ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[3]),
            .wire_i     (oc_wire[3]),
            .inputc_o   (ic_router[3]),
            .wire_o     (wire_o[3]),
            .port_o       (ic_port[3]), 
            .req_o        (ic_req[3]), 
            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

        // Output channels 
        outputc #( ROUTERID, 3 ) oc_3 ( 
            .clk        (clk),          
            .rst_n      (rst_n),  
            .outputc_i   (cb_router[3]),
            .outputc_o   (router_o[3]),
            .wire_i     (wire_i[3]),
            .rdy_o       (rdy_wire[3]), 
            .lck_o       (lck_wire[3])
        );    
        // Input physical channels 
        inputc #( ROUTERID, 4 ) i_inputc4 ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[4]),
            .wire_i     (oc_wire[4]),
            .inputc_o   (ic_router[4]),
            .wire_o     (wire_o[4]),
            .port_o       (ic_port[4]), 
            .req_o        (ic_req[4]), 
            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

        // Output channels 
        outputc #( ROUTERID, 4 ) oc_4 ( 
            .clk        (clk),          
            .rst_n      (rst_n),  
            .outputc_i   (cb_router[4]),
            .outputc_o   (router_o[4]),
            .wire_i     (wire_i[4]),
            .rdy_o       (rdy_wire[4]), 
            .lck_o       (lck_wire[4])
        );    


    // Crossbar switch 
    cb i_cb ( 
        .cb_i   (ic_router),
        .cb_o   (cb_router),
        .port_i     (ic_port), 
        .req_i      (ic_req), 
        .grt_o      (cb_grt)
    );                    

endmodule

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

        // Input physical channels 
        //inputc #( ROUTERID, 0 ) i_inputc ( 
        //    .clk        (clk),          
        //    .rst_n      (rst_n),    
        //    .inputc_i   (router_i[0]),
        //    .wire_i     (oc_wire[0]),
        //    .inputc_o   (router_o[0]),
        //    .wire_o     (wire_o[0]),

        //    .port_o       (ic_port[0]), 
        //    .req_o        (ic_req[0]), 

        //    .my_xpos    (my_xpos),  
        //    .my_ypos    (my_ypos)
        //);      
    genvar i;
    generate
    for(i=0; i<PORT_N; i++) begin : i_router_in

        for(genvar j=0; j<PORT_N; j++) begin : a
            //assign  oc_wire[i][j].rdy = wire_i[i].rdy;
            //assign  oc_wire[i][j].lck = wire_i[i].lck;
            assign  oc_wire[i][j].grt = cb_grt[i][j];
        end

        // Input physical channels 
        inputc #( ROUTERID, i ) i_inputc ( 
            .clk        (clk),          
            .rst_n      (rst_n),    
            .inputc_i   (router_i[i]),
            .wire_i     (oc_wire[i]),
            .inputc_o   (ic_router[i]),
            .wire_o     (wire_o[i]),

            .port_o       (ic_port[i]), 
            .req_o        (ic_req[i]), 

            .my_xpos    (my_xpos),  
            .my_ypos    (my_ypos)
        );           

    //    // Output channels 
    //    outputc #( ROUTERID, 0 ) oc_0 ( 
    //        .clk        (clk),          
    //        .rst_n      (rst_n),  
    //        .outputc_i   (cb_router[i]),
    //        .outputc_o   (router_o[i]),
    //        .wire_i     (wire_i[i]),
    //        .rdy_o       (oc_wire[i].rdy), 
    //        .lck_o       (oc_wire[i].lck)
    //    );    
    end
    endgenerate

    // Crossbar switch 
    cb i_cb ( 
        .clk        (clk),          
        .rst_n      (rst_n),  
        .cb_i   (ic_router),
        .cb_o   (cb_router),
        .port_i     (ic_port), 
        .req_i      (ic_req), 
        .grt_o      (cb_grt)
    );                    

endmodule

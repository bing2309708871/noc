module muxcont import noc_pkg::*;
#( 
    parameter       PORTID = 0
)(
    input   logic   [PORT_N-1:0][PORT_W-1:0]    port_i  ,  
    input   logic   [PORT_N-1:0]    req_i,     
  
    output logic    [PORT_N-1:0]    sel_o,
    output logic    [PORT_N-1:0]    grt_o
);

    logic   [PORT_N:0]  req;  
    logic   [PORT_N:0]  grt; 

    for(genvar i=0; i<PORT_N; i++) begin
        assign req[i] = req_i[i] & (port_i[i] == PORTID);
        assign grt_o[i] = grt[i];
    end

    assign  sel_o   = grt;    
                     
    // Arbiter                              
    arb i_arb (               
        .req ( req  ), 
        .grt ( grt  ) 
    );                     

endmodule

module muxcont import noc_pkg::*;
#( 
    parameter       PORTID = 0
)(
    input   logic               clk,
    input   logic               rst_n,
    input   logic   [PORT_N-1:0][PORT_W-1:0]  port_i  ,  
    input   logic   [PORT_N-1:0]            req_i,     
  
    output logic    [PORT_N-1:0]  sel_o,
    output logic    [PORT_N-1:0]  grt_o
);

    logic   [PORT_N:0]  req;  
    logic   [PORT_N:0]  grt_q,grt_d; 
    logic   [PORT_N:0]  hold; 
    logic               anyhold;


    for(genvar i=0; i<PORT_N; i++) begin
        assign req[i] = req_i[i] & (port_i[i] == PORTID);
        assign grt_o[i] = anyhold ? hold[i] : grt_q[i];
    end

    assign  hold    = grt_q & req; 
    assign  anyhold = |hold;      
    assign  sel_o     = grt_q;    
    assign  grt_d = grt_q;

    always @ (posedge clk or negedge rst_n) begin 
        if (~rst_n) begin
            grt_q    <= 'b0; 
        end else begin           
            grt_q    <= grt_d;   
        end
    end 

                     
    // Arbiter                              
    arb i_arb (               
        .req ( req  ), 
        .grt ( grt  ) 
        //.clk ( clk  ), 
        //.rst_( rst_n )  
    );                     

endmodule

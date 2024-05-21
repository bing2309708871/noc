module arb import noc_pkg::*;
( 
    input  [PORT_N:0]  req,      
    output [PORT_N:0]  grt  
);


    assign  grt[0]  =                   req[0]; 
    assign  grt[1]  = (req[0]   == 0) & req[1]; 
    assign  grt[2]  = (req[1:0] == 0) & req[2]; 
    assign  grt[3]  = (req[2:0] == 0) & req[3]; 
    assign  grt[4]  = (req[3:0] == 0) & req[4]; 

endmodule

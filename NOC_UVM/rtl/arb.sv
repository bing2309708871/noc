module arb import noc_pkg::*;
( 
    input  [PORT_N:0]  req,      
    output [PORT_N:0]  grt  
);

    for(genvar i=0; i<PORT_N; i++) begin
        if (i==0) begin
            assign grt[i] = req[i];
        end else begin
            assign grt[i] = (req[i-1:0] == '0) & req[i];
        end
    end

endmodule

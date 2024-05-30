module cb import noc_pkg::*;
(
    input   logic   clk,
    input   logic   rst_n,
    input   router_i_t   [PORT_N-1:0]           cb_i,
    output  router_i_t   [PORT_N-1:0]           cb_o,

    input   logic   [PORT_N-1:0][PORT_W-1:0]    port_i,
    input   logic   [PORT_N-1:0]                req_i,
    output  logic   [PORT_N-1:0][PORT_N-1:0]    grt_o     
);

    logic    [PORT_N-1:0][PORT_N-1:0]           cb_sel; 
    logic    [PORT_N-1:0][PORT_N-1:0]           cb_grt; 


    for(genvar i=0; i<PORT_N; i++) begin
        muxcont #( i ) i_muxcont ( 
            .port_i (port_i), 
            .req_i  (req_i), 
            .sel_o  (cb_sel[i]), 
            .grt_o  (cb_grt[i])
        ); 

        mux mux_0 ( 
            .mux_i  (cb_i),
            .mux_o  (cb_o[i]),
            .sel    (cb_sel[i])
        ); 
    end

    for(genvar i=0; i<PORT_N; i++) begin
        for(genvar j=0; j<PORT_N; j++) begin
            assign grt_o[i][j] = cb_grt[j][i];
        end
    end

endmodule

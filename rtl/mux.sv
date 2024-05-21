module mux import noc_pkg::*;( 
    input   router_i_t [4:0] mux_i    ,
    output  router_i_t  mux_o,

    input   [PORT_N:0]  sel 
);

    logic   [4:0][DATAW:0]  data;
    router_i_t              mux_wire;

    assign mux_o.data = | mux_wire.data;
    assign mux_o.valid= | mux_wire.valid;
    assign mux_o.vch  = | mux_wire.vch;

    for(genvar i=0; i<=4; i++) begin
        assign mux_wire[i] = (sel == 'b00001 << i) ? mux_i[i] : '0;
    end

endmodule

module mux import noc_pkg::*;( 
    input   router_i_t [PORT_N-1:0] mux_i    ,
    output  router_i_t  mux_o,

    input   [PORT_N-1:0]  sel 
);

    logic   [PORT_N-1:0][DATAW:0]   data_wire;
    router_i_t  [PORT_N-1:0]        mux_wire;


    assign mux_o.data = mux_wire[PORT_N-1].data;
    assign mux_o.valid= mux_wire[PORT_N-1].valid;
    assign mux_o.vch  = mux_wire[PORT_N-1].vch;

    for(genvar i=0; i<PORT_N; i++) begin
        if(i == 0) begin
            assign mux_wire[i] = (sel == 'b00001 << i) ? mux_i[i] : '0;
        end else begin
            assign mux_wire[i] = (sel == 'b00001 << i) ? mux_i[i] : mux_wire[i-1];
        end
    end

endmodule

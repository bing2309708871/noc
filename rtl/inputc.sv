
module inputc import noc_pkg::*;
#(
    parameter       ROUTERID= 0,
    parameter       PCHID   = 0
)(
    input   logic                   clk,
    input   logic                   rst_n,

    input   router_i_t              inputc_i,
    output  router_i_t              inputc_o,

    input   inputc_wire_i_t	[PORT_N-1:0]    wire_i,
    output  inputc_wire_o_t         wire_o,

    output  logic   [PORT_W-1:0]    port_o,
    output  logic                   req_o,

    input   logic   [ARRAY_W-1:0]   my_xpos,
    input   logic   [ARRAY_W-1:0]   my_ypos
);

    
    logic   [1:0][DATAW:0]      bdata;
    logic   [1:0][TYPE_W-1:0]   btype;
    logic   [1:0]				send;
    logic   [1:0][PORT_W-1:0]   port;
    logic   [VCH:0]				vcsel;
	logic	[1:0]				req_wire;
    router_i_t [1:0]  vcmux_i;

    inputc_wire_i_t [1:0][PORT_N-1:0] vc_wire;

    // Data transmission 
    for(genvar i=0; i<2; i++) begin 

        assign  vcmux_i[i].data   = send[i] && btype[i] != TYPE_NONE ? bdata[i] : 'b0;
        assign  vcmux_i[i].valid  = send[i] && btype[i] != TYPE_NONE; 
        assign  btype[i]  = bdata[i][TYPE_MSB:TYPE_LSB];
        assign  wire_o.ack[i] = send[i];

        for(genvar j=0; j<PORT_N; j++) begin
            assign vc_wire[i][j].rdy = wire_i[j].rdy;
            assign vc_wire[i][j].lck = wire_i[j].lck;
            assign vc_wire[i][j].grt = vcsel[i] ? wire_i[j].grt : DISABLE;
        end

    end

    vcmux i_vcmux(
        .clk    (clk),
        .rst_n  (rst_n),
        .vcmux_i    (vcmux_i),
        .vcmux_o    (inputc_o),
        .req_i      (req_wire),
        .req_o      (req_o),
        .port_i     (port),
        .port_o     (port_o),
        .vcsel_o    (vcsel)
        );
     

    for(genvar i=0; i<2; i++) begin : gen_vc
        vc #(ROUTERID,PCHID,i) i_vc(
            .clk    (clk),
            .rst_n  (rst_n),
            .data_i  (bdata[i]),
            .send_o   (send[i]),
            .lck_o   (wire_o.lck[i]),
            .wire_i (vc_wire[i]),
            .req_o    (req_wire[i]),
            .port_i   (port[i]),
            .vch_i   (vcmux_i[i].vch)
        );

        rtcomp  i_rtcomp(
            .clk    (clk),
            .rst_n  (rst_n),
            .addr_i   ( bdata[i][DST_MSB:DST_LSB] ),
            .vch_i   ( bdata[i][VCH_MSB:VCH_LSB] ),
            .en_i     ( btype[i] == TYPE_HEAD || btype[i] == TYPE_HEADTAIL ),
            .port_o   ( port[i]  ),
            .vch_o   ( vcmux_i[i].vch  ),

            .xpos_i( my_xpos ),
            .ypos_i( my_ypos )
        );

        fifo i_fifo(
            .clk    (clk),
            .rst_n  (rst_n),
            .idata  ( inputc_i.vch == i ? inputc_i.data  : 1'b0 ), 
            .odata  ( bdata[i] ), 
            .wr_en  ( inputc_i.vch == i ? inputc_i.valid : 1'b0 ), 
            .rd_en  ( send[i] ), 
            .empty  ( /* not used */ ), 
            .full   ( /* not used */ ), 
            .ordy   (wire_o.rdy[i]  )
            );
    end

endmodule

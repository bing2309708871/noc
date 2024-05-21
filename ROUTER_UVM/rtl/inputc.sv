
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

    
    logic   [VCH_N-1:0][DATA_W-1:0] bdata;
    logic   [VCH_N-1:0][TYPE_W-1:0] btype;
    logic   [VCH_N-1:0]				send;
    logic   [VCH_N-1:0][PORT_W-1:0] port;
    logic   [VCH_N-1:0]				vcsel;
	logic	[VCH_N-1:0]				req_wire;
    router_i_t [VCH_N-1:0]          vcmux_i;

    inputc_wire_i_t [VCH_N-1:0][PORT_N-1:0] vc_wire;

    // Data transmission 
    for(genvar i=0; i<2; i++) begin 

        assign  vcmux_i[i].data   = send[i] && btype[i] != TYPE_NONE ? bdata[i] : 'b0;
        assign  vcmux_i[i].valid  = send[i] && btype[i] != TYPE_NONE; 
        assign  btype[i]          = bdata[i][TYPE_MSB:TYPE_LSB];
        assign  wire_o.ack[i]     = send[i];

        for(genvar j=0; j<PORT_N; j++) begin
            assign vc_wire[i][j].rdy = wire_i[j].rdy;
            assign vc_wire[i][j].lck = wire_i[j].lck;
            assign vc_wire[i][j].grt = vcsel[i] ? wire_i[j].grt : DISABLE;
        end

    end

    vcmux i_vcmux(
        .vcmux_i    (vcmux_i),
        .vcmux_o    (inputc_o),
        .req_i      (req_wire),
        .req_o      (req_o),
        .port_i     (port),
        .port_o     (port_o),
        .vcsel_o    (vcsel)
        );
     

   // for(genvar i=0; i<2; i++) begin : gen_vc
        vc #(ROUTERID,PCHID,0) i_vc0(
            .clk    (clk),
            .rst_n  (rst_n),
            .data_i (bdata[0]),
            .send_o (send[0]),
            .lck_o  (wire_o.lck[0]),
            .wire_i (vc_wire[0]),
            .req_o  (req_wire[0]),
            .port_i (port[0]),
            .vch_i  (vcmux_i[0].vch)
        );

        rtcomp  i_rtcomp0(
            .clk    (clk),
            .rst_n  (rst_n),
            .addr_i (bdata[0][DST_MSB:DST_LSB]),
            .vch_i  (bdata[0][VCH_MSB:VCH_LSB]),
            .en_i   (btype[0] == TYPE_HEAD || btype[0] == TYPE_HEADTAIL),
            .port_o (port[0]),
            .vch_o  (vcmux_i[0].vch),
            .xpos_i (my_xpos),
            .ypos_i (my_ypos)
        );

        fifo i_fifo0(
            .clk    (clk),
            .rst_n  (rst_n),
            .idata  (inputc_i.vch == 0 ? inputc_i.data  : 1'b0 ), 
            .odata  (bdata[0]), 
            .wr_en  (inputc_i.vch == 0 ? inputc_i.valid : 1'b0 ), 
            .rd_en  (send[0]), 
            .empty  ( /* not used */ ), 
            .full   ( /* not used */ ), 
            .ordy   (wire_o.rdy[0])
            );

                vc #(ROUTERID,PCHID,1) i_vc1(
            .clk    (clk),
            .rst_n  (rst_n),
            .data_i (bdata[1]),
            .send_o (send[1]),
            .lck_o  (wire_o.lck[1]),
            .wire_i (vc_wire[1]),
            .req_o  (req_wire[1]),
            .port_i (port[1]),
            .vch_i  (vcmux_i[1].vch)
        );

        rtcomp  i_rtcomp1(
            .clk    (clk),
            .rst_n  (rst_n),
            .addr_i (bdata[1][DST_MSB:DST_LSB]),
            .vch_i  (bdata[1][VCH_MSB:VCH_LSB]),
            .en_i   (btype[1] == TYPE_HEAD || btype[1] == TYPE_HEADTAIL),
            .port_o (port[1]),
            .vch_o  (vcmux_i[1].vch),
            .xpos_i (my_xpos),
            .ypos_i (my_ypos)
        );

        fifo i_fifo1(
            .clk    (clk),
            .rst_n  (rst_n),
            .idata  (inputc_i.vch == 1 ? inputc_i.data  : 1'b0 ), 
            .odata  (bdata[1]), 
            .wr_en  (inputc_i.vch == 1 ? inputc_i.valid : 1'b0 ), 
            .rd_en  (send[1]), 
            .empty  ( /* not used */ ), 
            .full   ( /* not used */ ), 
            .ordy   (wire_o.rdy[1])
            );

    //end

endmodule

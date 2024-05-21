

module rtcomp import noc_pkg::*;
(
    input	logic                   clk,
    input	logic                   rst_n,
    
    input	logic   [ENTRY_W-1:0]	addr_i,
    input	logic   [ENTRY_W-1:0]	vch_i,
    input   logic			        en_i,
    output	logic   [PORT_W-1:0]	port_o,
    output	logic   [VCH_W-1:0]	    vch_o,
    
    input	logic   [ARRAY_W-1:0]	xpos_i,
    input	logic   [ARRAY_W-1:0]	ypos_i
);


    logic	[PORT_W-1:0]	port_q,port_d;
    logic	[VCH_W-1:0]	    vch_q,vch_d;
    
    logic	[ARRAY_W-1:0]	dst_xpos;
    logic	[ARRAY_W-1:0]	dst_ypos;
    
    assign	dst_xpos= addr_i[DSTX_MSB:DSTX_LSB];
    assign	dst_ypos= addr_i[DSTY_MSB:DSTY_LSB];
    
    
    // XY router
    assign	port_d	= ( dst_xpos == xpos_i && dst_ypos == ypos_i ) ? 4 :
                      ( dst_xpos > xpos_i ) ? 1 :
                      ( dst_xpos < xpos_i ) ? 3 :
                      ( dst_ypos > ypos_i ) ? 2 : 0;
                      
    // The same virtual channel is used.
    assign  vch_d	= vch_i;

    assign  port_o = en_i ? port_d : port_q;
    assign  vch_o  = en_i ? vch_d  : vch_q;
    
    always_ff @ (posedge clk or negedge rst_n) begin
    	if (~rst_n) begin
    		port_q	<= 0;
    		vch_q	<= 0;
    	end else begin
    		port_q	<= port_d;
    		vch_q	<= vch_d;
    	end
    end

endmodule

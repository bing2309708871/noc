

module rtcomp import noc_pkg::*;
(
    input	logic                   clk,
    input	logic                   rst_n,
    
    input	logic   [ENTRY_W-1:0]	addr_i,
    input	logic   [ENTRY_W-1:0]	vch_i,
    input   logic			        en_i,
    output	logic   [PORT_W-1:0]	port_o,
    output	logic   [VCHW:0]	    vch_o,
    
    input	logic   [ARRAY_W-1:0]	xpos_i,
    input	logic   [ARRAY_W-1:0]	ypos_i
);


    logic	[PORT_W-1:0]	port0;
    logic	[PORT_W-1:0]	port1_q,port_d;
    logic	[VCHW:0]	ovch0;
    logic	[VCHW:0]	ovch1_q,ovch1_d;
    
    logic	[ARRAY_W-1:0]	dst_xpos;
    logic	[ARRAY_W-1:0]	dst_ypos;
    
    assign	dst_xpos= addr_i[DSTX_MSB:DSTX_LSB];
    assign	dst_ypos= addr_i[DSTY_MSB:DSTY_LSB];
    
    assign	port_o	= en_i ? port0 : port1_q;
    assign	vch_o	= en_i ? ovch0 : ovch1_q;
    
    assign  port1_d = en_i ? port0 : port1_q;
    assign  ovch1_d = en_i ? ovch0 : ovch1_q;
    
    
    assign	port0	= ( dst_xpos == xpos_i && dst_ypos == ypos_i ) ? 4 :
                      ( dst_xpos > xpos_i ) ? 1 :
                      ( dst_xpos < xpos_i ) ? 3 :
                      ( dst_ypos > ypos_i ) ? 2 : 0;
    // The same virtual channel is used.
    assign  ovch0	= vch_i;
    
    always_ff @ (posedge clk or negedge rst_n) begin
    	if (~rst_n) begin
    		port1_q	<= 0;
    		ovch1_q	<= 0;
    	end else begin
    		port1_q	<= port1_d;
    		ovch1_q	<= ovch1_d;
    	end
    end

endmodule

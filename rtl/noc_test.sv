/* test module for noc.v */ 
`include "define.h"     
`timescale 1ns/10ps 

module noc_test; 

parameter STEP  = 5.0; 
parameter ARRAY = 4; 

integer counter, stop, total_sent, total_recv; 
reg clk, rst_, ready; 

    logic   router_i_t  router_i    [MESH_NUM-1:0];
    logic   router_o_t  router_o    [MESH_NUM-1:0];
    logic   [MESH_NUM-1:0]  sent;
    logic   [MESH_NUM-1:0]  recv;

    
noc i_noc ( 
        .router_i   (router_i),
        .router_o   (router_o),

        .clk ( clk  ), 
        .rst_( rst_ )  
); 

always #( STEP / 2) begin      
        clk <= ~clk;           
end                            
always #(STEP) begin           
        counter = counter + 1; 
end                            

initial begin                   
        /* Initialization */    
        #0                      
        counter = 0;            
        stop    = 200;          
        clk     <= `High;       
        ready   <= `Disable;    
        /* Send/recv counters */
        send = '0;
        recv = '0;
        #(STEP / 2)             
        noc_reset;              
        /* Now we can start simulation! */
        ready   <= `Enable;     

        /* Waiting for the end of the simulation */ 
        while (counter < stop) begin
                #(STEP);        
        end                     

        /* Statistics */ 
        //total_sent = n0_sent + n1_sent + n2_sent + n3_sent + n4_sent + n5_sent + n6_sent + n7_sent + n8_sent + n9_sent + n10_sent + n11_sent + n12_sent + n13_sent + n14_sent + n15_sent;
        //total_recv = n0_recv + n1_recv + n2_recv + n3_recv + n4_recv + n5_recv + n6_recv + n7_recv + n8_recv + n9_recv + n10_recv + n11_recv + n12_recv + n13_recv + n14_recv + n15_recv;
        $write("\n\n");    
        $write("*** statistics (%d) *** \n", counter); 
        $write("n0_sent %d \t n0_recv %d \n", n0_sent, n0_recv);
        $write("n1_sent %d \t n1_recv %d \n", n1_sent, n1_recv);
        $write("n2_sent %d \t n2_recv %d \n", n2_sent, n2_recv);
        $write("n3_sent %d \t n3_recv %d \n", n3_sent, n3_recv);
        $write("n4_sent %d \t n4_recv %d \n", n4_sent, n4_recv);
        $write("n5_sent %d \t n5_recv %d \n", n5_sent, n5_recv);
        $write("n6_sent %d \t n6_recv %d \n", n6_sent, n6_recv);
        $write("n7_sent %d \t n7_recv %d \n", n7_sent, n7_recv);
        $write("n8_sent %d \t n8_recv %d \n", n8_sent, n8_recv);
        $write("n9_sent %d \t n9_recv %d \n", n9_sent, n9_recv);
        $write("n10_sent %d \t n10_recv %d \n", n10_sent, n10_recv);
        $write("n11_sent %d \t n11_recv %d \n", n11_sent, n11_recv);
        $write("n12_sent %d \t n12_recv %d \n", n12_sent, n12_recv);
        $write("n13_sent %d \t n13_recv %d \n", n13_sent, n13_recv);
        $write("n14_sent %d \t n14_recv %d \n", n14_sent, n14_recv);
        $write("n15_sent %d \t n15_recv %d \n", n15_sent, n15_recv);
        //$write("total_sent %d \t total_recv %d \n", total_sent, total_recv);
        $write("\n\n");    
        $finish;               
end                             

/* packet generator for n0 */ 
initial begin 
        #(STEP / 2); 
        #(STEP * 10); 
        while (~ready) begin 
                #(STEP); 
        end 

        $write("*** send (src: 0 dst: 4 vch: 0 len: 5) *** \n");
        send_packet_0(4, 0, 5);
        $write("*** send (src: 0 dst: 2 vch: 1 len: 5) *** \n");
        send_packet_0(2, 1, 5);
        $write("*** send (src: 0 dst: 7 vch: 1 len: 3) *** \n");
end 

/* Send/recv event monitor */ 
always @ (posedge clk) begin 
        if ( n0_ivalid_p0 == `Enable ) begin 
                $write("%d n0 send %x \n", counter, n0_idata_p0); 
                n0_sent = n0_sent + 1;
        end 
end 

always @ (posedge clk) begin 
        if ( n0_ovalid_p0 == `Enable ) begin 
                $write("        %d n0 recv %x \n", counter, n0_odata_p0); 
                n0_recv = n0_recv + 1; 
                stop     = counter + 200;
        end 
end 

/* Port 0 */ 
always @ (posedge clk) begin    
	if ( noc.n0.ovalid_0 == `Enable ) $write("                %d n0(0 %d) go thru %x \n", counter, noc.n0.ovch_0, noc.n0.odata_0); 
end 
/* Port 1 */ 
always @ (posedge clk) begin    
	if ( noc.n0.ovalid_1 == `Enable ) $write("                %d n0(1 %d) go thru %x \n", counter, noc.n0.ovch_1, noc.n0.odata_1); 
end 
/* Port 2 */ 
always @ (posedge clk) begin    
	if ( noc.n0.ovalid_2 == `Enable ) $write("                %d n0(2 %d) go thru %x \n", counter, noc.n0.ovch_2, noc.n0.odata_2); 
end 
/* Port 3 */ 
always @ (posedge clk) begin    
	if ( noc.n0.ovalid_3 == `Enable ) $write("                %d n0(3 %d) go thru %x \n", counter, noc.n0.ovch_3, noc.n0.odata_3); 
end 

initial begin                     
        $dumpfile("dump.vcd"); 
        $dumpvars(0,noc_test);   
        `ifdef __POST_PR__        
        $sdf_annotate("router.sdf", noc_test.noc.n0, , "sdf.log", "MAXIMUM");
        `endif                    
end                               

/* send_packet_0(dst, vch, len): send a packet from n0 to destination. */ 
task send_packet_0; 
input [31:0] dst; 
input [31:0] vch; 
input [31:0] len; 
reg [`DATAW:0]  packet [0:63]; 
integer id; 
begin      
        n0_ivalid_p0 <= `Disable;
        for ( id = 0; id < len; id = id + 1 ) 
                packet[id] <= 0; 
        #(STEP) 
        if (len == 1) 
                packet[0][`TYPE_MSB:`TYPE_LSB] <= `TYPE_HEADTAIL; 
        else 
                packet[0][`TYPE_MSB:`TYPE_LSB] <= `TYPE_HEAD; 
        packet[0][`DST_MSB:`DST_LSB] <= dst;    /* Dest ID (4-bit)   */ 
        packet[0][`SRC_MSB:`SRC_LSB] <= 0;     /* Source ID (4-bit) */ 
        packet[0][`VCH_MSB:`VCH_LSB] <= vch;    /* Vch ID (4-bit)    */ 
        for ( id = 1; id < len; id = id + 1 ) begin 
                if ( id == len - 1 )
                        packet[id][`TYPE_MSB:`TYPE_LSB] <= `TYPE_TAIL; 
                else 
                        packet[id][`TYPE_MSB:`TYPE_LSB] <= `TYPE_DATA; 
                packet[id][15:12] <= id;	/* Flit ID   (4-bit) */ 
                packet[id][31:16] <= counter;	/* Enqueue time (16-bit) */ 
        end 
        id = 0;                                 
        while ( id < len ) begin                
                #(STEP)                         
                /* Packet level flow control */ 
                if ( (id == 0 && n0_ordy_p0[vch]) || id > 0 ) begin 
                        n0_idata_p0 <= packet[id]; n0_ivalid_p0 <= `Enable; n0_ivch_p0 <= vch; id = id + 1; 
                end else begin    
                        n0_idata_p0 <= `DATAW_P1'b0; n0_ivalid_p0 <= `Disable;  
                end 
        end 
        #(STEP) 
        n0_ivalid_p0 <= `Disable;   
end             
endtask         

/* noc_reset(): Reset all routers. */ 
task noc_reset; 
begin           
        rst_    <= `Enable_;   
        #(STEP)                
        n0_idata_p0 <= `DATAW_P1'h0; n0_ivalid_p0 <= `Disable; n0_ivch_p0 <= `VCHW_P1'h0;
        n1_idata_p0 <= `DATAW_P1'h0; n1_ivalid_p0 <= `Disable; n1_ivch_p0 <= `VCHW_P1'h0;
        n2_idata_p0 <= `DATAW_P1'h0; n2_ivalid_p0 <= `Disable; n2_ivch_p0 <= `VCHW_P1'h0;
        n3_idata_p0 <= `DATAW_P1'h0; n3_ivalid_p0 <= `Disable; n3_ivch_p0 <= `VCHW_P1'h0;
        n4_idata_p0 <= `DATAW_P1'h0; n4_ivalid_p0 <= `Disable; n4_ivch_p0 <= `VCHW_P1'h0;
        n5_idata_p0 <= `DATAW_P1'h0; n5_ivalid_p0 <= `Disable; n5_ivch_p0 <= `VCHW_P1'h0;
        n6_idata_p0 <= `DATAW_P1'h0; n6_ivalid_p0 <= `Disable; n6_ivch_p0 <= `VCHW_P1'h0;
        n7_idata_p0 <= `DATAW_P1'h0; n7_ivalid_p0 <= `Disable; n7_ivch_p0 <= `VCHW_P1'h0;
        n8_idata_p0 <= `DATAW_P1'h0; n8_ivalid_p0 <= `Disable; n8_ivch_p0 <= `VCHW_P1'h0;
        n9_idata_p0 <= `DATAW_P1'h0; n9_ivalid_p0 <= `Disable; n9_ivch_p0 <= `VCHW_P1'h0;
        n10_idata_p0 <= `DATAW_P1'h0; n10_ivalid_p0 <= `Disable; n10_ivch_p0 <= `VCHW_P1'h0;
        n11_idata_p0 <= `DATAW_P1'h0; n11_ivalid_p0 <= `Disable; n11_ivch_p0 <= `VCHW_P1'h0;
        n12_idata_p0 <= `DATAW_P1'h0; n12_ivalid_p0 <= `Disable; n12_ivch_p0 <= `VCHW_P1'h0;
        n13_idata_p0 <= `DATAW_P1'h0; n13_ivalid_p0 <= `Disable; n13_ivch_p0 <= `VCHW_P1'h0;
        n14_idata_p0 <= `DATAW_P1'h0; n14_ivalid_p0 <= `Disable; n14_ivch_p0 <= `VCHW_P1'h0;
        n15_idata_p0 <= `DATAW_P1'h0; n15_ivalid_p0 <= `Disable; n15_ivch_p0 <= `VCHW_P1'h0;
        #(STEP)                
        rst_    <= `Disable_;  

end             
endtask         

endmodule 

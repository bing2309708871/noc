
module vc import noc_pkg::*;
#(
	parameter   ROUTERID= 0,
	parameter   PCHID   = 0,
	parameter   VCHID   = 0
)(
    input                   clk,
    input                   rst_n,
    
    input   [DATA_W-1:0]    data_i,
    output                  send_o,  
    output                  lck_o,   

    //input   [VCH:0]     rdy_i    [PORT_N-1:0],
    //input   [VCH:0]     lck_i    [PORT_N-1:0],
    //input               grt_i     [PORT_N-1:0],
    input   inputc_wire_i_t [PORT_N-1:0] wire_i,

    output                  req_o,
    input   [PORT_W-1:0]    port_i, 
    input   [VCH_W-1:0]        vch_i
);

    logic   [TYPE_W-1:0]    btype;
    logic                   req_d,req_q;    /* Request signal */
    logic   [PORT_N-1:0]    lck;            /* 1: Next VC is locked by others */
    logic   [PORT_N-1:0]    grt;	        /* 1: Output channel is allocated */
    logic   [PORT_N-1:0]    rdy;	        /* 1: Next VC can receive a flit  */ 
    logic                   send_d,send_q;

     // Input flit type 
    assign  btype   = data_i[TYPE_MSB:TYPE_LSB]; 

    // FSM
    typedef enum logic [1:0] {
        RC_STAGE,
        VSA_STAGE,
        ST_STAGE
    } state_e;
    state_e state_d, state_q;


    // Packet-level arbitration 
    for (genvar i=0; i<PORT_N; i++) begin
        assign  lck[i] = (port_i == i && wire_i[i].lck[vch_i]);
        assign  grt[i] = (port_i == i && wire_i[i].grt);
        assign  rdy[i] = (port_i == i && wire_i[i].rdy[vch_i]);
    end

    assign  lck_o   = (state_q != RC_STAGE); 
    assign  send_o  = send_q;
    assign  req_o   = req_q;



    always_comb begin

		state_d = state_q;
		send_d	= send_q;
		req_d	= req_q;

        case (state_q)
	        // State 1 : Routing computation
	    	RC_STAGE: begin
	    		if (btype == TYPE_HEAD || btype == TYPE_HEADTAIL) begin
	    			state_d	= VSA_STAGE;
	    			send_d	= DISABLE;
	    			req_d	= ENABLE;
	    		end
	    	end
            
            // State 2 : Virtual channel / switch allocation
            VSA_STAGE: begin
	    		if (|lck == ENABLE) begin
                // Switch is locked (unable to start the arbitration)
	    			req_d     = DISABLE;
	    		end if (|grt == DISABLE) begin
                // Switch is not locked but it is not allocated
	    			req_d     <= ENABLE;
	    		end if (|rdy == ENABLE && |grt == ENABLE) begin
                // Switch is allocated and it is free!
                    //if (btype == TYPE_HEADTAIL) begin
                    //    state_d <= RC_STAGE;
                    //end else if(btype == TYPE_HEAD) begin
                        state_d   <= ST_STAGE;
                    //end

	    			send_d	<= ENABLE;
	    			req_d     <= ENABLE;
	    		end
            end

            // State 3 : Switch Traversal 
	    	ST_STAGE: begin
	    		if (btype == TYPE_HEADTAIL ||  btype == TYPE_TAIL) begin
	    			state_d	= RC_STAGE;
	    			send_d	= DISABLE;
	    			req_d	= DISABLE;
	    		end
	    	end
	    endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            req_q   <= '0;
            send_q  <= '0;
            state_q <= RC_STAGE;
        end else begin
            req_q   <= req_d;
            send_q  <= send_d;
            state_q <= state_d;
        end
    end

endmodule


module outputc import noc_pkg::*;
#(
    parameter       ROUTERID= 0,
    parameter       PCHID   = 0
)(
    input   logic           clk,
    input   logic           rst_n,

    input   router_i_t      outputc_i,
    output  router_i_t      outputc_o,

    input   inner_wire_t    wire_i,

    output  logic   [VCH_N-1:0] rdy_o,
    output  logic   [VCH_N-1:0] lck_o
);

    router_i_t  trans_q,trans_d;

    //logic   [TYPE_W-1:0]       itype;
    //logic   [TYPE_W-1:0]       otype;

    logic   [VCH_N-1:0]         lck_q,lck_d;
    logic   [VCH_N-1:0][FIFOD_P1:0]    cnt_q  ;
    logic   [VCH_N-1:0][FIFOD_P1:0]    cnt_d  ; 

    // Input/Output flit type
    //assign  itype   = (outputc_i.valid == ENABLE) ? outputc_i.data[TYPE_MSB:TYPE_LSB] : TYPE_NONE;
    //assign  otype   = (outputc_o.valid == ENABLE) ? outputc_i.data[TYPE_MSB:TYPE_LSB] : TYPE_NONE;

    assign  trans_d = outputc_i.valid ? outputc_i : (~outputc_i.valid & trans_q.valid) ? '0 : trans_q; // Output data
    assign  outputc_o = trans_q;


    for(genvar i=0; i<VCH_N; i++) begin 
        // Virtual-channel status (lock)
        always_comb begin 
            if ((outputc_i.valid && outputc_i.vch == i) || (outputc_o.valid && outputc_o.vch == i)) begin
                lck_d[i] = ENABLE;
            end else if (lck_q[i] && ~wire_i.lck[i]) begin
                lck_d[i] = DISABLE;
            end else begin
                lck_d[i] = lck_q[i];
            end
        end

        assign lck_o[i] = lck_q[i];

        // Virtual-channel status (ready)
        assign rdy_o[i]  = ((FIFO_P1 - cnt_q[i]) >= PKTLEN_P1) ? ENABLE : DISABLE;
        always_comb begin
            if (wire_i.ack[0] && ~(outputc_i.valid && outputc_i.vch == i) && cnt_q != 0) begin
                cnt_d[i] = cnt_q[i] - 1;
            end else if (~wire_i.ack[0] && (outputc_i.valid && outputc_i.vch == i)) begin
                cnt_d[i] = cnt_q[i] + 1;
            end else begin
                cnt_d[i] = cnt_q[i];
            end
        end
    end

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            trans_q <= '0;
            lck_q   <= '0;
            cnt_q   <= '0;
        end else begin
            trans_q <= trans_d;             
            lck_q   <= lck_d;  
            cnt_q   <= cnt_d;
        end
    end
         
endmodule 

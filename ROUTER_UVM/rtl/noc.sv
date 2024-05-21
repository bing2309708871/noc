module noc import noc_pkg::*;
#(
    parameter MESH_X_NUM = 4,
    parameter MESH_Y_NUM = 4,
    parameter MESH_NUM = MESH_X_NUM*MESH_Y_NUM
)( 
    input   logic   clk,
    input   logic   rst_n,
    
    input   router_i_t  [MESH_X_NUM*MESH_Y_NUM-1:0] router_i,
    output  router_o_t  [MESH_X_NUM*MESH_Y_NUM-1:0] router_o    
);


     router_i_t      [MESH_NUM-1:0][PORT_N-1:0]router_wire_i ;
     router_i_t      [MESH_NUM-1:0][PORT_N-1:0]router_wire_o ;
     inner_wire_t    [MESH_NUM-1:0][PORT_N-1:0]router_inner_i;
     inputc_wire_o_t [MESH_NUM-1:0][PORT_N-1:0]router_inner_o;


/*
    i=      0   1   2   3   4 ....   MESH_NUM

    j=0     #---#---#---#---#
            |   |   |   |   |
      1     #---#---#---#---#
            |   |   |   |   |
      2     #---#---#---#---#
            |   |   |   |   |
      3     #---#---#---#---#
            |   |   |   |   |
      4     #---#---#---#---#
      .


            0
          3 # 1   PORT_N
            2
*/
    for(genvar i=0; i<MESH_X_NUM; i++) begin
        for(genvar j=0; j<MESH_Y_NUM; j++) begin
            for(genvar k=0; k<PORT_N; k++) begin
                
                if (k == P) begin
                   assign router_wire_i[(i+(j*MESH_X_NUM))][k] = router_i[(i+(j*MESH_X_NUM))];
                   assign router_o[i+j*MESH_X_NUM] = router_wire_o[i+j*MESH_X_NUM][k];
                   assign router_inner_i[i+j*MESH_X_NUM][k].ack = '1;
                   assign router_inner_i[i+j*MESH_X_NUM][k].lck = '0;
                end else if (k==N) begin
                    if(j == 0) begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = '0;
                        assign router_inner_i[i+j*MESH_X_NUM][k] = '0;
                    end else begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = router_wire_o[i+(j-1)*MESH_X_NUM][S];
                        assign router_inner_i[i+j*MESH_X_NUM][k].ack = router_inner_o[i+(j-1)*MESH_X_NUM][S].ack;
                        assign router_inner_i[i+j*MESH_X_NUM][k].lck = router_inner_o[i+(j-1)*MESH_X_NUM][S].lck;
                    end
                end else if (k==E) begin
                    if( i == MESH_X_NUM-1) begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = '0;
                        assign router_inner_i[i+j*MESH_X_NUM][k] = '0;
                    end else begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = router_wire_o[(i+1)+j*MESH_X_NUM][W];
                        assign router_inner_i[i+j*MESH_X_NUM][k].ack = router_inner_o[(i+1)+j*MESH_X_NUM][W].ack;
                        assign router_inner_i[i+j*MESH_X_NUM][k].lck = router_inner_o[(i+1)+j*MESH_X_NUM][W].lck;
                    end
                end else if (k==S) begin
                    if( j == MESH_Y_NUM-1) begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = '0;
                        assign router_inner_i[k][i+j*MESH_X_NUM][k] = '0;
                    end else begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = router_wire_o[i+(j+1)*MESH_X_NUM][N];
                        assign router_inner_i[i+j*MESH_X_NUM][k].ack = router_inner_o[i+(j+1)*MESH_X_NUM][N].ack;
                        assign router_inner_i[i+j*MESH_X_NUM][k].lck = router_inner_o[i+(j+1)*MESH_X_NUM][N].lck;
                    end
                end else if (k==W) begin
                    if( i == 0) begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = '0;
                        assign router_inner_i[i+j*MESH_X_NUM][k] = '0;
                    end else begin
                        assign router_wire_i[i+j*MESH_X_NUM][k] = router_wire_o[(i-1)+j*MESH_X_NUM][E];
                        assign router_inner_i[i+j*MESH_X_NUM][k].ack = router_inner_o[(i-1)+j*MESH_X_NUM][E].ack;
                        assign router_inner_i[i+j*MESH_X_NUM][k].lck = router_inner_o[(i-1)+j*MESH_X_NUM][E].lck;
                    end
                end 
            end
            
            router #(i+j*MESH_X_NUM) i_router(
                .clk        (clk),
                .rst_n      (rst_n),
                .router_i   (router_wire_i[i+j*MESH_X_NUM]),
                .router_o   (router_wire_o[i+j*MESH_X_NUM]),
                .wire_o(router_inner_o[i+j*MESH_X_NUM]),
                .wire_i(router_inner_i[i+j*MESH_X_NUM]),
                .my_xpos        (i),
                .my_ypos        (j)
            );
        end
    end
endmodule 

module noc import noc_pkg::*;
#(
    parameter MESH_X_NUM = 4,
    parameter MESH_Y_NUM = 4,
    parameter MESH_NUM = MESH_X_NUM*MESH_Y_NUM
( 
    input   logic   clk,
    input   logic   rst_n,
    
    input   logic   router_i_t  router_i    [MESH_X_NUM*MESH_Y_NUM-1:0],
    output  logic   router_o_t  router_o    [MESH_X_NUM*MESH_Y_NUM-1:0].
);


     logic   [4:0] router_i_t  router_wire_i [MESH_NUM-1:0];
     logic   [4:0] router_i_t  router_wire_o [MESH_NUM-1:0];
     logic  [4:0]   router_inner_t  router_inner_i    [MESH_NUM-1:0];
     logic  [4:0]   router_inner_t  router_inner_o  [MESH_NUM-1:0];

    for(genvar i=0; i<MESH_X_NUM; i++) begin
        for(genvar j=0; j<MESH_Y_NUM; j++) begin

            if (i  == 0) begin
                router_wire_i[i*MESH_X_NUM+j][3] = '0;
                router_inner_i[i*MESH_X_NUM+j][3] = '0;
            end
            if (i  == MESH_X_NUM-1) begin
                router_wire_i[i*MESH_X_NUM+j][2] = '0;
                router_inner_i[i*MESH_X_NUM+j][2] = '0;
            end
            if (j == 0) begin
                router_wire_i[i*MESH_X_NUM+j][0] = '0;
                router_inner_i[i*MESH_X_NUM+j][0] = '0;
            end
            if (j == MESH_Y_NUM-1) begin
                router_wire_i[i*MESH_X_NUM+j][2] = '0;
                router_inner_i[i*MESH_X_NUM+j][2] = '0;
            end
            if (i >= 1) begin
                router_wire_i[i*MESH_X_NUM+j][0] = router_wire_o[(i-1)*MESH_X_NUM+j][2];
                router_inner_i[i*MESH_X_NUM+j][0] = router_inner_o[(i-1)*MESH_X_NUM+j][2];
            end
            if (i < MESH_Y_NUM-1) begin
                router_wire_i[i*MESH_X_NUM+j][2] = router_wire_o[(i+1)*MESH_X_NUM+j][0];
                router_inner_i[i*MESH_X_NUM+j][2] = router_inner_o[(i-1)*MESH_X_NUM+j][2];
            end
            if (j >= 1) begin
                router_wire_i[i*MESH_X_NUM+j][3] = router_wire_o[i*MESH_X_NUM+(j-1)][1];
                router_inner_i[i*MESH_X_NUM+j][3] = router_inner_o[(i-1)*MESH_X_NUM+j][3];
            end
            if (j < MESH_X_NUM-1) begin
                router_wire_i[i*MESH_X_NUM+j][1] = router_wire_o[i*MESH_X_NUM+(j+1)][3];
                router_inner_i[i*MESH_X_NUM+j][1] = router_inner_o[(i-1)*MESH_X_NUM+j][3];
            end

            router #(i+j) i_router(
                .clk        (clk),
                .rst_n      (rst_n),
                .router_i   (router_i[i+j]),
                .router_o   (router_o[i+j]),
                .router_inner_o(router_inner_o[i+j]),
                .router_inner_i(router_inner_i[i+j]),
                .my_xpos        (i),
                .my_ypos        (j)
            );
endmodule 

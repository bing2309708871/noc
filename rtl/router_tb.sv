/* energy estimation module for a router */ 


module router_tb import noc_pkg::*; ();

    timeunit 1ps;
    timeprecision 1ps;

    parameter ENABLE = 1;   
    parameter STEP   = 6; 
    parameter STREAM = 1; 

    integer i, j; 
    integer  seed; 
    logic clk, rst_n; 

    router_i_t      [PORT_N-1:0]    router_i;
    router_o_t      [PORT_N-1:0]    router_o;
    inner_wire_t    [PORT_N-1:0]    wire_i;
    inputc_wire_o_t [PORT_N-1:0]    wire_o;

    always #( STEP / 2 ) begin 
        clk <= ~clk;       
    end                        
    always #( STEP ) begin     
        seed  = seed  + 1; 
    end       

    initial begin
        $fsdbDumpfile("tb.fsdb");
        $fsdbDumpvars("+all");
        //$fsdbDumpMDA();
    end

    initial begin
        #1000;
        $finish();
    end

    router i_router ( 
        .router_i   (router_i),
        .router_o   (router_o),
        .wire_i     (wire_i),
        .wire_o     (wire_o),
        
        .my_xpos( 2'b1 ),
        .my_ypos( 2'b1 ),
        .clk  ( clk  ), 
        .rst_n ( rst_n )  
    ); 

    initial begin                                     

        /* Initialization */            
        #0;                             
        clk     <= 1'b1;               
        rst_n    <= 1'b0;            

        router_i <= '0;


        for(i=0; i<PORT_N; i++) begin
            //router_i[i].data <= '0;
            //router_i[i].vch <= '0;
            //router_i[i].valid <= '0;
            wire_i[i].ack <= 'hf;
            wire_i[i].lck <= 'h0;
        end
        

        #(STEP);
        #(STEP / 2);
        rst_n    <= 1'b1;
        #(STEP);


        for (i = 0; i < 1; i = i + 1) begin
                forward_packet( STREAM, 4, ENABLE );
                #(STEP*7);         // Link utilization 4/13=0.30
        end

        #(STEP);
    end

    task forward_packet; 
        input [31:0] n;      
        input [31:0] len;    
        input [31:0] enable; 
        reg   [31:0] ran0;   
 
        begin                

        for(i=0; i<PORT_N; i++) begin
            /* Initialization */ 
            if (n > i && enable == 1) begin
                router_i[i].data <= {TYPE_HEAD, 32'h09};
                router_i[i].valid<= 1'b1;
            end

            /* Packet transfer */ 
            for (j = 0; j < len; j = j + 1) begin 
                ran0 <= $random(seed);           
                #(STEP);                       
                if ( n > i && enable == 1 ) 
                        router_i[i].data <= {TYPE_DATA, ran0}; 
            end  

            ran0 <= $random(seed);       
            #(STEP);                       
            if ( n > i && enable == 1 ) 
                router_i[i].data <= {TYPE_TAIL, ran0}; 

            #(STEP);                               
            router_i[i].data    <= {TYPE_NONE, 32'h0}; 
            router_i[i].valid   <= DISABLE; 

        end
        end                          
    endtask                      

endmodule 


package noc_pkg;

    localparam int DATA_W   = 35; // 3 bit TYPE + 32 bit DATA
    localparam int VCH_N    = 2;  // virtual channel number
    localparam int VCH_W    = 1;  // virtual channer number width


    // Data width (32-bit data + 3-bit type)
    localparam int DST_LSB  = 0;
    localparam int DST_MSB  = 3;
    localparam int SRC_LSB  = 4;
    localparam int SRC_MSB  = 7;
    localparam int VCH_LSB  = 8;
    localparam int VCH_MSB  = 11;
    localparam int TYPE_LSB = 32;
    localparam int TYPE_MSB = 34;

    localparam int TYPE_W    = 3; // type number width


    localparam int PORT_N   = 5;    // Port number (5-port)
    localparam int PORT_W   = 3;    // Port number width
    localparam int N        = 0;    // North
    localparam int E        = 1;    // East
    localparam int S        = 2;    // South
    localparam int W        = 3;    // West
    localparam int P        = 4;    // Center

    localparam int ENTRY_W  = 4;
    localparam int ARRAY_W  = 2;
    localparam int DSTX_LSB = 0;
    localparam int DSTX_MSB = 1;
    localparam int DSTY_LSB = 2;
    localparam int DSTY_MSB = 3;

    //localparam int FIFO_D   = 4;
    //localparam int FIFO_DW  = 2;
    
    /* Input FIFO (4-element) */ 
    localparam int FIFO           = 16; 
    localparam int FIFO_P1        = FIFO+1; 
    localparam int FIFOD          = $clog2(FIFO); 
    localparam int FIFOD_P1       = FIFOD+1; 
    localparam int PKTLEN         = FIFO; 
    localparam int PKTLEN_P1      = PKTLEN+1; 

    parameter  DISABLE     = 1'b0;
    parameter  ENABLE      = 1'b1;

    // message type
    typedef enum logic [TYPE_W-1:0] {
        TYPE_NONE,
        TYPE_HEAD,
        TYPE_TAIL,
        TYPE_HEADTAIL,
        TYPE_DATA
    } type_e;

    typedef struct packed {
        logic   [DATA_W-1:0]   data;
        logic               valid;
        logic   [VCH_W-1:0]    vch;
    }   router_i_t;

    typedef struct packed {
        logic   [DATA_W-1:0]   data;
        logic               valid;
        logic   [VCH_W-1:0]    rdy;
    }   router_o_t;

    typedef struct packed {
        logic   [VCH_N-1:0]     ack;
        //logic   [VCH_N-1:0]     rdy,
        logic   [VCH_N-1:0]     lck;
    }   inner_wire_t;

    typedef struct packed {
        logic   [VCH_N-1:0]     rdy;
        logic   [VCH_N-1:0]     lck;
        logic               grt;
    }   inputc_wire_i_t;

    typedef struct packed {
        logic   [VCH_N-1:0]     ack;
        logic   [VCH_N-1:0]     rdy;
        logic   [VCH_N-1:0]     lck;
    }   inputc_wire_o_t;


endpackage

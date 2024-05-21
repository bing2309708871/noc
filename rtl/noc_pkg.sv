
package noc_pkg;

    localparam int DATAW    = 34;
    localparam int VCHW     = 0;
    localparam int VCH      = 1;

    // Data width (32-bit data + 3-bit type)
    localparam int DST_LSB  = 0;
    localparam int DST_MSB  = 3;
    localparam int SRC_LSB  = 4;
    localparam int SRC_MSB  = 7;
    localparam int VCH_LSB  = 8;
    localparam int VCH_MSB  = 11;
    localparam int TYPE_LSB = 32;
    localparam int TYPE_MSB = 34;

    localparam int TYPE_W    = 3;


    localparam int PORT_N   = 5;    // Port number (5-port)
    localparam int PORT_W   = 3;    // Port number width

    localparam int ENTRY_W  = 4;
    localparam int ARRAY_W  = 2;
    localparam int DSTX_LSB = 0;
    localparam int DSTX_MSB = 1;
    localparam int DSTY_LSB = 2;
    localparam int DSTY_MSB = 3;

    //localparam int FIFO_D   = 4;
    //localparam int FIFO_DW  = 2;
    
/* Input FIFO (4-element) */ 
localparam int FIFO           = 4; 
localparam int FIFO_P1        = 5; 
localparam int FIFOD          = 2; 
localparam int FIFOD_P1       = 3; 
localparam int PKTLEN         = 4; 
localparam int PKTLEN_P1      = 5; 

    

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
        logic   [DATAW:0]   data;
        logic               valid;
        logic   [VCHW:0]    vch;
    }   router_i_t;

    typedef struct packed {
        logic   [DATAW:0]   data;
        logic               valid;
        logic   [VCHW:0]    rdy;
    }   router_o_t;

    typedef struct packed {
        logic   [VCH:0]     ack;
        //logic   [VCH:0]     rdy,
        logic   [VCH:0]     lck;
    }   inner_wire_t;

    typedef struct packed {
        logic   [VCH:0]     rdy;
        logic   [VCH:0]     lck;
        logic               grt;
    }   inputc_wire_i_t;

    typedef struct packed {
        logic   [VCH:0]     ack;
        logic   [VCH:0]     rdy;
        logic   [VCH:0]     lck;
    }   inputc_wire_o_t;







endpackage

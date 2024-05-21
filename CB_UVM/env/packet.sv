// All transaction classes must be extended from the uvm_sequence_item base class.

class packet extends uvm_sequence_item;

    import noc_pkg::*;


  rand bit [PORT_N-1:0][PORT_W-1:0]    port;
  rand bit [PORT_N-1:0]                req;
  rand bit [PORT_N-1:0][PORT_N-1:0]    grt;
  rand router_i_t  [PORT_N-1:0]    trans; 
  //rand router_i_t                   trans_o;

  `uvm_object_utils_begin(packet)
        //`uvm_field_int(trans_o.data,UVM_ALL_ON);
        //`uvm_field_int(trans_o.valid,UVM_ALL_ON);
        //`uvm_field_int(trans_o.vch,UVM_ALL_ON);

    foreach(trans[i]) begin
        `uvm_field_int(trans[i].data,UVM_ALL_ON);
        `uvm_field_int(trans[i].valid,UVM_ALL_ON);
        `uvm_field_int(trans[i].vch,UVM_ALL_ON);
    end

    `uvm_field_int(port, UVM_ALL_ON);
    `uvm_field_int(req, UVM_ALL_ON);
    `uvm_field_int(grt, UVM_ALL_ON);
  `uvm_object_utils_end

  constraint valid {
    foreach(port[i]) {
        port[i] inside {[0:PORT_N-1]};
    }
  }
    
    function new(string name = "packet");
      super.new(name);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

endclass: packet

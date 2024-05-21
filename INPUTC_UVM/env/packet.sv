// All transaction classes must be extended from the uvm_sequence_item base class.

import noc_pkg::*;
class packet extends uvm_sequence_item;
    

    //rand router_i_t   inputc_i;
    rand inputc_wire_i_t [PORT_N-1:0]    wire_i;
    rand logic  [3:0]          packet_n;
    rand logic  [DATA_W-1:0]    data_queue[$];
    rand logic  [1:0]           my_xpos;
    rand logic  [1:0]           my_ypos;
    rand logic                  vch;
    rand logic  [3:0]           dest;

  `uvm_object_utils_begin(packet)
        `uvm_field_int(my_xpos,UVM_ALL_ON);
        `uvm_field_int(my_ypos,UVM_ALL_ON);
        `uvm_field_int(vch,UVM_ALL_ON);
        `uvm_field_int(dest,UVM_ALL_ON);

        foreach(wire_i[i])begin
        `uvm_field_int(wire_i[i].rdy,UVM_ALL_ON);
        `uvm_field_int(wire_i[i].lck,UVM_ALL_ON);
        `uvm_field_int(wire_i[i].grt,UVM_ALL_ON);
        end
        `uvm_field_int(packet_n,UVM_ALL_ON);
        `uvm_field_queue_int(data_queue,UVM_ALL_ON);

  `uvm_object_utils_end

    constraint valid {
        packet_n inside {1,[3:5]};
        data_queue.size inside {packet_n};
    }
    
    function new(string name = "packet");
      super.new(name);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new

endclass: packet

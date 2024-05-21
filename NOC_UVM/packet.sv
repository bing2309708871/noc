// All transaction classes must be extended from the uvm_sequence_item base class.
import noc_pkg::*;
class packet extends uvm_sequence_item;


    rand router_i_t   [15:0]  router_i;

  `uvm_object_utils_begin(packet)
        foreach(router_i[i]) begin
        `uvm_field_int(router_i[i].data,UVM_ALL_ON);
        `uvm_field_int(router_i[i].valid,UVM_ALL_ON);
        `uvm_field_int(router_i[i].vch,UVM_ALL_ON);
        end
  `uvm_object_utils_end


  function new(string name = "packet");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

endclass: packet

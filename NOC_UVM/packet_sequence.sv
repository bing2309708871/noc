// The packet_sequence class has been modified to extend from packet_sequence_base class.
// The reason for this change is to simplify development of the body() method of the sequence
// by moving the raising and dropping of objections to the base class's pre_start() and
// post_start() methods.
//
// With this modification, the packet_sequence class's body() method no longer needs to
// raise and drop objections. 

import noc_pkg::*;
class packet_sequence extends uvm_sequence #(packet);
  `uvm_object_utils(packet_sequence)

  function new(string name = "packet_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `ifndef UVM_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction: new


  virtual task pre_start();
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_start

  virtual task post_start();
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start

  virtual task body();
    router_i_t [15:0] router_data;
    int i,j;
    reg [3:0] router_num;
    reg [31:0] data_i;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    begin
    router_data = '0;

    for(j=0;j<1;j++) begin
    for(i=0;i<16;i++) begin
    data_i = $random();
    data_i[7:4] = i;
    data_i[3:0] = 5;
    data_i[11:8] = '0;

    router_data[i].data = {TYPE_HEADTAIL,data_i};
    router_data[i].valid = 1'b1;
    router_data[i].vch = '0;
    end
    `uvm_do_with(req,{router_i==router_data;});
    end

    //for(i=0;i<150;i++) begin
    //router_num = $random();
    //data_i = $random();

    //router_data[router_num].data = {TYPE_HEADTAIL,data_i};
    //router_data[router_num].valid = 1'b1;
    //`uvm_do_with(req,{router_i==router_data;});
    //router_data[router_num] = '0;
    //end

    //router_data[0].data = {TYPE_TAIL,32'h1};
    //router_data[0].valid = 1'b1;
    //`uvm_do_with(req,{router_i==router_data;});

    //router_data[0].data = {TYPE_HEADTAIL,32'h5};
    //router_data[0].valid = 1'b1;
    //`uvm_do_with(req,{router_i==router_data;});

    //router_data[0].data = {TYPE_TAIL,32'h5};
    //router_data[0].valid = 1'b1;
    //`uvm_do_with(req,{router_i==router_data;});

    end


  endtask: body


endclass: packet_sequence

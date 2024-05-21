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
    
    `ifndef UVM_VERSION_1_1
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
    `endif

    virtual task body();
    //reg [PORT_N-1:0][PORT_W-1:0] port;
    //reg [PORT_N-1:0]  req_i;
    int i;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);


     //port <= '0;
     //req_i <= '0;
    for(i=0;i<100;i++) begin
    `uvm_do(req);
    `uvm_do(req);
    `uvm_do(req);
    `uvm_do(req);
    `uvm_do(req);
    `uvm_do(req);
    `uvm_do(req);
    end

    //`uvm_do_with(req,{port[4:1]=='0;req==5'b00001;port[0]==3'b11;});
    endtask: body

endclass: packet_sequence

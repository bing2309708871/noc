
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
        reg [DATA_W-1:0] data_i;
        inner_wire_t  wire_input;
        int i;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        wire_input.lck = 2'b0;
        //wire_input.grt = 1'b0;
        wire_input.ack = 2'b11;

        for(i=0;i<1;i++) begin
            `uvm_do_with(req,{wire_i==wire_input;my_xpos==2'b0;my_ypos==2'b0;});
        end
    endtask: body

endclass: packet_sequence

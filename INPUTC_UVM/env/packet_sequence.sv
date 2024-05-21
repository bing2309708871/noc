
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
  inputc_wire_i_t [4:0] wire_input;
  int i;
  `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  for(i=0;i<5;i++)begin
      wire_input[i].lck = 2'b0;
      wire_input[i].grt = 1'b1;
      wire_input[i].rdy = 2'b11;
    end

        for(i=0;i<10;i++) begin
            //`uvm_do(req);
//end
    //    data_i= {TYPE_HEADTAIL, i};

    `uvm_do_with(req,{wire_i==wire_input;});
    end
    endtask: body

endclass: packet_sequence

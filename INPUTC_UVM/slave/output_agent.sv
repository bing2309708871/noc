class output_agent extends uvm_agent;
    `uvm_component_utils(output_agent)

    typedef uvm_sequencer #(packet) packet_sequencer;
    
    virtual inputc_if vif;           // DUT virtual interface
    packet_sequencer  sqr;
    oDriver            drv;
    oMonitor          mon;
    uvm_analysis_port #(packet) analysis_port;
    //is_active = UVM_PASSIVE;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if(is_active == UVM_ACTIVE) begin
            sqr = packet_sequencer::type_id::create("sqr", this);
            drv = oDriver::type_id::create("drv", this);
        end
    
        mon  = oMonitor::type_id::create("mon", this);
        analysis_port = new("analysis_port", this);
    
        uvm_config_db#(virtual inputc_if)::get(this, "", "vif", vif);
        uvm_config_db#(virtual inputc_if)::set(this, "*", "vif", vif);
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        mon.analysis_port.connect(this.analysis_port);
    endfunction: connect_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Interface for output agent not set");
        end
    endfunction: end_of_elaboration_phase

endclass: output_agent

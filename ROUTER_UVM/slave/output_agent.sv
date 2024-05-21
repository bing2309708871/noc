import noc_pkg::*;
class output_agent extends uvm_agent;
    `uvm_component_utils(output_agent)

    typedef uvm_sequencer #(packet) packet_sequencer;
    
    virtual router_if vif;           // DUT virtual interface
    packet_sequencer  sqr;
    oDriver            drv;
    oMonitor          mon;
    uvm_analysis_port #(packet) analysis_port;
    int         port_id = -1;
    
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
        
    
        uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
        uvm_config_db#(virtual router_if)::set(this, "*", "vif", vif);

        uvm_config_db#(int)::get(this, "", "port_id", port_id);
        uvm_config_db#(int)::set(this, "*", "port_id", port_id);
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
        if (!(port_id inside {-1, [0:4]})) begin
            `uvm_fatal("CFGERR", $sformatf("port_id must be {-1, [0:4]}, not %0d!", port_id));
        end 
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Interface for output agent not set");
        end
    endfunction: end_of_elaboration_phase

endclass: output_agent

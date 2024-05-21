import noc_pkg::*;
class input_agent extends uvm_agent;

    
    typedef uvm_sequencer #(packet) packet_sequencer;
    
    virtual router_if vif;
    packet_sequencer  sqr;
    iDriver            drv;
    iMonitor          mon;
    uvm_analysis_port #(packet) analysis_port[PORT_N];
    int             port_id = -1;

    `uvm_component_utils_begin(input_agent)
        `uvm_field_int(port_id, UVM_ALL_ON | UVM_DEC)
    `uvm_component_utils_end

    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if(is_active == UVM_ACTIVE) begin
            sqr = packet_sequencer::type_id::create("sqr", this);
            drv = iDriver::type_id::create("drv", this);
        end
        mon = iMonitor::type_id::create("mon", this);
        foreach(analysis_port[i]) begin
            analysis_port[i] = new($sformatf("analysis_port[%0d]",i), this);
        end
    
        uvm_config_db#(virtual router_if)::get(this,"","vif",vif);
        uvm_config_db#(virtual router_if)::set(this,"*","vif",vif);  

        uvm_config_db#(int)::get(this, "", "port_id", port_id);
        uvm_config_db#(int)::set(this, "*", "port_id", port_id);
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
        foreach(analysis_port[i]) begin
            mon.analysis_port[i].connect(this.analysis_port[i]);
        end
    endfunction: connect_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (!(port_id inside {[0:4]})) begin
            `uvm_fatal("CFGERR", $sformatf("port_id must be {[0:4]}, not %0d!", port_id));
        end
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Interface for input agent not set");
        end
    endfunction: end_of_elaboration_phase
    
endclass: input_agent

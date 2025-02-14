import noc_pkg::*;
class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor)

    virtual cb_if vif;
    uvm_analysis_port #(packet) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(virtual cb_if)::get(this, "", "vif", vif);
        analysis_port = new("analysis_port", this);
    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Interface for input monitor not set");
        end
    endfunction: end_of_elaboration_phase
    
    virtual task run_phase(uvm_phase phase);
        packet tr;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        //wait(vif.rst_n == 1'b1);
        forever begin
            tr = packet::type_id::create("tr", this);
            get_packet(tr);
        end
    endtask: run_phase
    
    
    virtual task get_packet(packet tr);
        router_i_t [PORT_N-1:0] router_wire = '0;
        integer i;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
        @(negedge vif.clk);
        if (|(vif.req)) begin
            for(i=PORT_N; i>=0; i--) begin
                if (vif.req[i]) begin
                    router_wire[vif.port[i]] = vif.router_i[i];
                end
            end
            tr.trans = router_wire; // we only save data to tran[PORT_N-1];
            `uvm_info("Got_Input_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
            analysis_port.write(tr);
        end
    endtask: get_packet

endclass: iMonitor

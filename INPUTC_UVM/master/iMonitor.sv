import noc_pkg::*;
class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor)

    virtual inputc_if vif;
    uvm_analysis_port #(packet) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(virtual inputc_if)::get(this, "", "vif", vif);
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
            get_packet(tr);
        end
    endtask: run_phase
    
    
    virtual task get_packet(packet tr);
        int i=0;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        @(negedge vif.clk);
         if (vif.inputc_i.valid == 1'b1) begin
             tr = packet::type_id::create("tr", this);
             if(vif.inputc_i.data[34:32] == TYPE_HEAD)begin
                 while(vif.inputc_i.data[34:32] != TYPE_TAIL) begin
                     tr.data_queue[i] = vif.inputc_i.data;
                     @(negedge vif.clk);
                     i++;
                end
            end else if (vif.inputc_i.data[34:32] == TYPE_HEADTAIL)begin
                tr.data_queue[i] = vif.inputc_i.data;
            end          
             //add connction
             `uvm_info("Got_Input_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
             analysis_port.write(tr);
         end
    endtask: get_packet

endclass: iMonitor

import noc_pkg::*;
class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor)

    virtual router_if vif;
    uvm_analysis_port #(packet) analysis_port;
    int port_id = -1;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
            `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(int)::get(this, "", "port_id", port_id);
        uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
        analysis_port = new("analysis_port", this);
    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (!(port_id inside {-1, [0:4]})) begin
            `uvm_fatal("CFGERR", $sformatf("port_id must be {-1, [0:4]}, not %0d!", port_id));
        end
        if (vif == null) begin
            `uvm_fatal("CFGERR", "Interface for output monitor not set");
        end
    endfunction: end_of_elaboration_phase 

    virtual task run_phase(uvm_phase phase);
        packet tr;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        //wait(vif.rst_n == 1'b1); 
        forever begin
            tr = packet::type_id::create("tr", this);
            this.get_packet(tr);
        end
    endtask: run_phase
    
    virtual task get_packet(packet tr);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        @(negedge vif.clk);
        if (vif.router_o[port_id].valid == 1'b1) begin
            // first transaction
            if (vif.router_o[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_HEAD) begin
                tr.data_queue.push_back(vif.router_o[port_id].data);
                do begin
                     @(negedge vif.clk);
                     tr.data_queue.push_back(vif.router_o[port_id].data);
                     //i++;
                end while(vif.router_o[port_id].data[34:32] != TYPE_TAIL);
            end else if(vif.router_o[port_id].data[TYPE_MSB:TYPE_LSB] == TYPE_HEADTAIL) begin
            tr.data_queue.push_back(vif.router_o[port_id].data);
            end


             `uvm_info("Got_Output_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
             analysis_port.write(tr);
         end
    endtask: get_packet

endclass: oMonitor

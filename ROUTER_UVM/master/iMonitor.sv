import noc_pkg::*;
class iMonitor extends uvm_monitor;
    `uvm_component_utils(iMonitor)

    virtual router_if vif;
    int             port_id = -1;
    uvm_analysis_port #(packet) analysis_port[PORT_N];
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(int)::get(this, "", "port_id", port_id);
        uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
        foreach(analysis_port[i]) begin
            analysis_port[i] = new($sformatf("analysis_port[%0d]",i), this);
        end
    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (!(port_id inside {-1, [0:4]})) begin
            `uvm_fatal("CFGERR", $sformatf("port_id must be {-1, [0:4]}, not %0d!", port_id));
        end
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
        int port_out;
        reg [1:0] xpos_i,ypos_i,dst_xpos,dst_ypos;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        @(negedge vif.clk);
        if (vif.router_i[port_id].valid == 1'b1) begin
            xpos_i = vif.my_xpos;
            ypos_i = vif.my_ypos;
            // first transaction
            if (vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_HEAD) begin
                dst_xpos = vif.router_i[port_id].data[1:0];
                dst_ypos = vif.router_i[port_id].data[3:2];
                tr.data_queue.push_back(vif.router_i[port_id].data);
                do begin
                     @(negedge vif.clk);
                     tr.data_queue.push_back(vif.router_i[port_id].data);
                     //i++;
                end while(vif.router_i[port_id].data[34:32] != TYPE_TAIL);
            end else if(vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] == TYPE_HEADTAIL) begin
                dst_xpos = vif.router_i[port_id].data[1:0];
                dst_ypos = vif.router_i[port_id].data[3:2];
                tr.data_queue.push_back(vif.router_i[port_id].data);
            end
             `uvm_info("Got_Input_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
            port_out   = ( dst_xpos == xpos_i && dst_ypos == ypos_i ) ? 4 :
                      ( dst_xpos > xpos_i ) ? 1 :
                      ( dst_xpos < xpos_i ) ? 3 :
                      ( dst_ypos > ypos_i ) ? 2 : 0;
             analysis_port[port_out].write(tr);
         end
    endtask: get_packet

endclass: iMonitor

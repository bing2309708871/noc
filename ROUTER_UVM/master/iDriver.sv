import noc_pkg::*;
class iDriver extends uvm_driver #(packet);
    
     virtual router_if vif;           // DUT virtual interface
     int        port_id = -1;

    `uvm_component_utils_begin(iDriver)
        `uvm_field_int(port_id, UVM_ALL_ON | UVM_DEC)
    `uvm_component_utils_end

    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(int)::get(this, "", "port_id", port_id);
        uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
    endfunction: build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        if (!(port_id inside {[0:4]})) begin
            `uvm_fatal("CFGERR", $sformatf("port_id must be {[0:4]}, not %0d!", port_id));
        end
        if (vif == null) begin
        `uvm_fatal("CFGERR", "Interface for input driver agent not set");
        end
  endfunction: end_of_elaboration_phase
    
    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: start_of_simulation_phase
    
    virtual task run_phase(uvm_phase phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        reset();
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
            write(req);
            seq_item_port.item_done();
        end
    endtask: run_phase
    
    virtual task reset();
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        vif.router_i <= '0;
        vif.wire_i <= '0;
        vif.my_xpos <= '0;
        vif.my_ypos <= '0;
        wait(vif.rst_n == 1'b1);
    endtask:reset
    
    virtual task write(packet tr);
        int i;
        reg [3:0] ran;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        ran = $random();
        repeat (ran) @(posedge vif.clk);
        @ (posedge vif.clk);
        // wire data is unchange
        vif.wire_i[port_id] <= tr.wire_i;
        vif.my_xpos <= tr.my_xpos;
        vif.my_ypos <= tr.my_ypos;
        vif.router_i[port_id].vch <= tr.vch;
        vif.router_i[port_id].valid <= 1'b1;

        // first transaction
        if (tr.packet_n == 1) begin
            vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_HEADTAIL;
        end else begin
            vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_HEAD;
        end
        vif.router_i[port_id].data[DST_MSB:DST_LSB] <= tr.dest;
        vif.router_i[port_id].data[VCH_MSB:VCH_LSB] <= tr.vch;

        // other transactions
        for(i=1;i<tr.packet_n;i++)begin
            @(posedge vif.clk);
            if(i == tr.packet_n-1)begin
                vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_TAIL;
                vif.router_i[port_id].data[DST_MSB:DST_LSB] <= tr.dest;
                vif.router_i[port_id].data[VCH_MSB:VCH_LSB] <= tr.vch;

            end else begin
                vif.router_i[port_id].data[TYPE_MSB:TYPE_LSB] <= TYPE_DATA;
                vif.router_i[port_id].data[31:0] <= tr.data_queue[i-1];

            end
        end

        @ (posedge vif.clk);
        vif.router_i[port_id] <= 'b0;
    endtask: write

endclass: iDriver

import noc_pkg::*;
class iDriver extends uvm_driver #(packet);
    `uvm_component_utils(iDriver)
    
     virtual inputc_if vif;           // DUT virtual interface
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        uvm_config_db#(virtual inputc_if)::get(this, "", "vif", vif);
    endfunction: build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
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
        vif.inputc_i = '0;
        vif.wire_i = '0;
        vif.my_xpos = '0;
        vif.my_ypos = '0;
        wait (vif.rst_n == 1);
    endtask:reset
    
    virtual task write(packet tr);
        int i;
        reg [31:0] ran;
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        begin
        @ (posedge vif.clk);
        if (tr.packet_n == 1) begin
            vif.inputc_i.data[TYPE_MSB:TYPE_LSB] = TYPE_HEADTAIL;
        end else begin
            vif.inputc_i.data[TYPE_MSB:TYPE_LSB] = TYPE_HEAD;
        end
        vif.inputc_i.data[DST_MSB:DST_LSB] = tr.dest;
        vif.inputc_i.data[VCH_MSB:VCH_LSB] = tr.vch;
        vif.inputc_i.vch = tr.vch;
        vif.inputc_i.valid = 1'b1;
        //vif.inputc_i = tr.inputc_i;
        vif.wire_i = tr.wire_i;
        vif.my_xpos = tr.my_xpos;
        vif.my_ypos = tr.my_ypos;
        for(i=2;i<tr.packet_n;i++)begin
            @(posedge vif.clk);
            if(i == tr.packet_n-1)begin
                vif.inputc_i.data[TYPE_MSB:TYPE_LSB] = TYPE_TAIL;
            end else begin
                vif.inputc_i.data[TYPE_MSB:TYPE_LSB] = TYPE_DATA;
            end
            vif.inputc_i.data[31:0] = tr.data_queue[i-1];
        end
        @ (posedge vif.clk);
        vif.inputc_i = 'b0;
        //vif.wire_i = '0;
        //#100;
        end    
    endtask: write

endclass: iDriver

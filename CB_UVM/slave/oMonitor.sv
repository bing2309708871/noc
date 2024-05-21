class oMonitor extends uvm_monitor;
    `uvm_component_utils(oMonitor)

    virtual cb_if vif;
    uvm_analysis_port #(packet) analysis_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
            `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(virtual cb_if)::get(this, "", "vif", vif);
        analysis_port = new("analysis_port", this);
    endfunction: build_phase
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
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
    int out_port=-1;
    int i;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //$display("req %h,%h",vif.req,|vif.req);
    

   @(negedge vif.clk);
   //$display("omonitor out port %h",out_port);

   if (|(vif.req)) begin
        for(i=PORT_N; i>=0; i--) begin
            if(vif.req[i]) begin
                out_port = vif.port[i];
            end
        end
        tr.trans = vif.router_o;
        `uvm_info("Got_Output_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
        analysis_port.write(tr);
   end
    endtask: get_packet

endclass: oMonitor

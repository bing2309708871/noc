class oMonitor extends uvm_monitor;
  virtual NOC_if vif;
  uvm_analysis_port #(packet) analysis_port;

  `uvm_component_utils(oMonitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual NOC_if)::get(this, "", "vif", vif);
    analysis_port = new("analysis_port", this);
  endfunction: build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for oMonitor not set");
    end
  endfunction: end_of_elaboration_phase

  virtual task run_phase(uvm_phase phase);
    packet tr;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever begin
      tr = packet::type_id::create("tr", this);
      this.get_packet(tr);
    end
  endtask: run_phase

  virtual task get_packet(packet tr);
    int i;
    reg [15:0] router_o_valid;
    //reg [3:0] dest;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //forever  begin
        @(negedge vif.clk);
        for(i=0;i<16;i++) begin
            router_o_valid[i] = vif.router_o[i].valid;
        end
        if(|router_o_valid)begin
            for(i=0;i<16;i++) begin
                //tr.router_i[i] = '0;
                if(vif.router_o[i].valid == 1'b1) begin
                    tr.router_i[i].data = vif.router_o[i].data;
                    $display("output port:%h; src :%h",i,vif.router_o[i].data[7:4]);
                    //`uvm_info("Got_Output_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
                    analysis_port.write(tr);
                end
            end

        end 
    //end
  endtask: get_packet
endclass: oMonitor

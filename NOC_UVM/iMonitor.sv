class iMonitor extends uvm_monitor;

  virtual NOC_if vif;

  uvm_analysis_port #(packet) analysis_port;

  `uvm_component_utils(iMonitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    uvm_config_db#(virtual NOC_if)::get(this, "", "vif", vif);
    analysis_port = new("analysis_port", this);
  endfunction: build_phase


  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if (vif == null) begin
      `uvm_fatal("CFGERR", "Interface for iMonitor not set");
    end
  endfunction: end_of_elaboration_phase

  virtual task run_phase(uvm_phase phase);
    packet tr;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    forever begin
      tr = packet::type_id::create("tr", this);
      get_packet(tr);
    end
  endtask: run_phase


  virtual task get_packet(packet tr);
    int i;
    reg [15:0] router_i_valid;
    reg [3:0] dest;
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    //forever  begin
        @(negedge vif.clk);
        for(i=0;i<16;i++) begin
            router_i_valid[i] = vif.router_i[i].valid;

        end
        if(|router_i_valid)begin
            for(i=0;i<16;i++) begin
                //tr.router_i[i] = '0;
                if(vif.router_i[i].valid == 1'b1) begin
                    dest = vif.router_i[i].data[3:0];
                    tr.router_i[dest].data = vif.router_i[i].data;
                    $display("src:%h; dest:%h;",i,dest);
                    //`uvm_info("Got_Input_Packet", {"\n", tr.sprint()}, UVM_MEDIUM);
                    analysis_port.write(tr);
                end
            end

         end
    //end
  endtask: get_packet

endclass: iMonitor

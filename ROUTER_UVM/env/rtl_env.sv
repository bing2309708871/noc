import noc_pkg::*;
class rtl_env extends uvm_env;
    `uvm_component_utils(rtl_env)

    input_agent     i_agt[PORT_N];
    output_agent    o_agt[PORT_N];
    scoreboard      sb[PORT_N];
    Coverage        cov;
    virtual router_if vif;
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction: new
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        foreach(i_agt[i]) begin
            i_agt[i] = input_agent::type_id::create($sformatf("i_agt[%0d]",i), this);
            uvm_config_db #(int)::set(this, i_agt[i].get_name(), "port_id", i);
            uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(),".sqr.main_phase"}, "default_sequence", packet_sequence::get_type());
        end
        foreach(o_agt[i]) begin
            o_agt[i] = output_agent::type_id::create($sformatf("o_agt[%0d]",i), this);
            uvm_config_db #(int)::set(this, o_agt[i].get_name(), "port_id", i);
            //uvm_config_db #(uvm_object_wrapper)::set(this, {o_agt[i].get_name(),".sqr.main_phase"}, "default_sequence", packet_sequence::get_type());
        end
        foreach(sb[i]) begin
            sb[i] = scoreboard::type_id::create($sformatf("sb[%0d]",i), this);
        end
        
        cov = Coverage::type_id::create("cov",this);
        
        uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
        uvm_config_db#(virtual router_if)::set(this, "*", "vif", vif); 
    endfunction: build_phase
    
    virtual function void connect_phase(uvm_phase phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        foreach(i_agt[i]) begin
            foreach(sb[j]) begin
                i_agt[i].analysis_port[j].connect(sb[i].before_export);
            end
        end
        foreach(o_agt[i]) begin
            o_agt[i].analysis_port.connect(sb[i].after_export);
        end
    endfunction: connect_phase
  
endclass: rtl_env

class Coverage extends uvm_component;
    `uvm_component_utils(Coverage)
    virtual cb_if vif;

    covergroup cov_write;
        // add coverpoint
        PORT0:coverpoint vif.port[0] {option.auto_bin_max = 5;}
        PORT1:coverpoint vif.port[1] {option.auto_bin_max = 5;}
        PORT2:coverpoint vif.port[2] {option.auto_bin_max = 5;}
        PORT3:coverpoint vif.port[3] {option.auto_bin_max = 5;}
        PORT4:coverpoint vif.port[4] {option.auto_bin_max = 5;}
        REQ:coverpoint vif.req {option.auto_bin_max = 5;}
    endgroup

    
    function new(string name="Coverage", uvm_component parent);
		super.new(name, parent);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        // add cov new
		this.cov_write = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        // add covorage virtual interface
        uvm_config_db#(virtual cb_if)::get(this, "", "vif", vif);
	endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        fork 
            // add sample
            this.do_write_sample();
        join
    endtask

    virtual task do_write_sample();
        forever begin
            @(posedge vif.clk iff vif.rst_n);
            // add sample
            this.cov_write.sample();
        end
    endtask

    function void report_phase(uvm_phase phase);
        string s;
        super.report_phase(phase);
        s = "\n---------------------------------------------------------------\n";
        s = {s, "COVERAGE SUMMARY \n"}; 
        s = {s, $sformatf("total coverage: %.1f \n", $get_coverage())}; 
        // print coverage
        s = {s, $sformatf("write coverage: %.1f \n", this.cov_write.get_coverage())}; 
        s = {s, "---------------------------------------------------------------\n"};
        `uvm_info(get_type_name(), s, UVM_LOW)
    endfunction

endclass

program automatic test;
import uvm_pkg::*;
import router_test_pkg::*;

initial begin
  $fsdbDumpfile("tb.fsdb");
  $fsdbDumpvars("+all");
  $timeformat(-9, 1, "ns", 10);
  uvm_resource_db#(virtual NOC_if)::set("vif","",tb.noc_if);
  run_test("test_base");
end

endprogram


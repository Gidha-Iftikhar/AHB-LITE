
`include "test.sv"
`include "interference.sv"
`include "wrapper.sv"
module top;
bit clk = 0;
logic reset = 0;


always #5 clk = ~clk;

initial begin
     #1 reset = 0;
     #10 reset = 1;
  end
covergroup cg@(posedge clk);
option.per_instance = 1;
 type_option.strobe = 1;
coverpoint int_f.HADDR{ 
			bins low = {[0:128]}; bins high = {[128:256]};
			bins range[] = {[0:256]};
			bins other = default;
			}
endgroup

cg cg_inst;
initial
begin
cg_inst=new();	

$display("Coverage of HADDR = %f",cg_inst.get_inst_coverage());
end
ahb_if int_f(clk,reset);
wrapper wrap(int_f.dut);
test t1(int_f.driver);
assertions ass(int_f);
bind wrapper assertions wp_ass(int_f.dut); 


endmodule
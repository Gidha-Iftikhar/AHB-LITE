
`ifdef 
`define include_n
`include "burst.sv"
`endif
`include "driver.sv"
`include "generator.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  
//handles of all components
generator  gen;
driver     drv;
monitor    mon;
scoreboard scb;
  
//mailbox handles
mailbox#(burst) gen_2_drv;
mailbox#(burst) mon_2_scb;

virtual interface ahb_if intf;
//constructor
function new(virtual interface ahb_if intf);
$display("\n\n---------- Environment constructor---------\n\n");
	this.intf = intf;
      	gen_2_drv=new(0);
      	mon_2_scb=new(0);
      	gen=new(gen_2_drv);
      	drv=new(intf, gen_2_drv);
      	mon=new(intf, mon_2_scb);
      	scb=new(mon_2_scb);
endfunction

task pre_test();
drv.reset();
endtask

task run();
  fork 
      	//gen.run();
      	drv.run();
        mon.run();
        scb.run();
  join_any 
   
endtask


task post_test();
	wait(gen.burst_count == 100);
      	wait(scb.burst_count == 100);
	$finish;


endtask

/*task run1();
	pre_test();
	test();
	post_test();
	
endtask*/

endclass

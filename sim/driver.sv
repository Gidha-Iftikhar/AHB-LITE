`include "burst.sv"
class driver;

virtual ahb_if.driver driver_if;
mailbox gen2driv;
 
function new(virtual ahb_if.driver driver_if, mailbox gen2driv);
	this.driver_if 	<= driver_if;
	this.gen2driv 	<= gen2driv;
endfunction

task reset();
 	wait(driver_if.HRESETn);
	driver_if.HSEL 		<= '0;
	driver_if.HADDR		<= '0;
	driver_if.HWDATA	<= '0;
	driver_if.HWRITE	<= '0;
	driver_if.HSIZE		<= '0;
	driver_if.HBURST 	<= '0;
	driver_if.HPROT		<= '0;
	driver_if.HTRANS	<= '0;
	driver_if.HREADY	<= '0;
endtask

task write_burst();

	burst pkt;
	gen2drive.get(pkt);
	if(driver_if.HREADYOUT && !driver_if.HRESP)
	begin
	driver_if.HSEL 		<= 1;
	driver_if.HREADY	<= 1;
	driver_if.HWRITE	<= 1;
	driver_if.HADDR 	<= pkt.HADDR;
	driver_if.HSIZE		<= pkt.HSIZE;
	driver_if.HBURST	<= pkt.HBURST;
	driver_if.HPROT		<= pkt.HPROT;
	driver_if.HTRANS	<= pkt.HTRANS;
	@(posedge driver_if.clk)
	driver_if.HWDATA	<= pkt.HWDATA;
	end
endtask

task read_burst();

	burst pkt;
	gen2drive.get(pkt);
	if(driver_if.HREADYOUT && !driver_if.HRESP)
	begin
	driver_if.HSEL 		<= 1;
	driver_if.HREADY	<= 1;
	driver_if.HWRITE	<= 0;
	driver_if.HADDR 	<= pkt.HADDR;
	driver_if.HSIZE		<= pkt.HSIZE;
	driver_if.HBURST	<= pkt.HBURST;
	driver_if.HPROT		<= pkt.HPROT;
	driver_if.HTRANS	<= pkt.HTRANS;
	end
endtask

task run();
	reset();
	write_burst();
	read_burst();
endtask

endclass

`include "burst.sv"

class driver;

virtual interface ahb_if.driver driver_if;
mailbox#(burst) gen2driv;
event all_done;
 
function new(virtual ahb_if.driver driver_if, mailbox#(burst) gen2driv);
$display("\n\n---------- driver constructor---------\n\n");
	this.driver_if 	= driver_if;
	this.gen2driv 	= gen2driv;
endfunction

task reset();					// Reset the DUT
	driver_if.driver.master.HSEL 	<= 0;
	driver_if.driver.master.HADDR	<= 0;
	driver_if.driver.master.HWDATA	<= 0;
	driver_if.driver.master.HWRITE	<= 0;
	driver_if.driver.master.HSIZE	<= 0;
	driver_if.driver.master.HBURST 	<= 0;
	driver_if.driver.master.HPROT	<= 0;
	driver_if.driver.master.HTRANS	<= 0;
	driver_if.driver.master.HREADY	<= 0;
endtask

task drive();					//Send signals to DUT according to received burst

	burst pkt;
	gen2driv.get(pkt);
	if(driver_if.master.HREADYOUT && !driver_if.master.HRESP)
	begin
	driver_if.master.HSEL 		<= pkt.HSEL;
	driver_if.master.HREADY		<= 1;
	driver_if.master.HWRITE		<= pkt.HWRITE;
	driver_if.master.HADDR 		<= pkt.HADDR;
	driver_if.master.HSIZE		<= pkt.HSIZE;
	driver_if.master.HBURST		<= pkt.HBURST;
	driver_if.master.HPROT		<= pkt.HPROT;
	driver_if.master.HTRANS		<= pkt.HTRANS;
	@(posedge driver_if.HCLK)
	driver_if.master.HWDATA		<= pkt.HWDATA;
	-> all_done;
	end
	$display("\n\n---------- packet send to the memory ---------\n\n");
endtask

task run();
forever begin
	drive();
end
endtask

endclass

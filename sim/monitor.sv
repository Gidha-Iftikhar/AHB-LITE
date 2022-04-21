`ifndef include_n
`include "burst.sv"
`endif
class monitor;
virtual interface ahb_if.monitor monitor_if;
mailbox#(burst) mon2score;

event all_received;
function new(virtual ahb_if.monitor monitor_if, mailbox#(burst) mon2score);
	this.monitor_if = monitor_if;
	this.mon2score 	= mon2score;
endfunction




task run();
burst pkt;
for(int i = 0; i<100;i++)
begin
if(monitor_if.HREADYOUT && !monitor_if.HRESP)
	begin

	pkt = new;
	pkt.HADDR	= monitor_if.HADDR ;
	pkt.HSIZE	= monitor_if.HSIZE;
	pkt.HBURST	= monitor_if.HBURST;
	pkt.HPROT	= monitor_if.HPROT;
	pkt.HTRANS	= monitor_if.HTRANS;
	pkt.HWDATA	= monitor_if.HWDATA;
	if(monitor_if.HWRITE)
		begin
		@(posedge monitor_if.HCLK)
		pkt.HWDATA	= monitor_if.HWDATA;
		end
	mon2score.put(pkt);
$display("\n\n----------packet receive from memory---------\n\n");
  
	-> all_received;
end
end
endtask


endclass


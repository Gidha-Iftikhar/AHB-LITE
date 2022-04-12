class burst;
	logic	[1:0]	HTRANS;
 	logic	[2:0]  	HSIZE;
 	logic	[2:0] 	HBURST;
rand 	logic 	[7:0] 	HADDR;
	logic 		HWRITE; //flag of read and write for monitir
	logic 	[3:0] 	HPROT;
rand	logic 	[31:0] 	HWDATA;
	logic 		HREADYOUT;
	logic 		HRESP;
	logic 	[31:0] 	HRDATA;

task create(input [2:0] burst_type, input [2:0] burst_size, int wrap_or_incr_size);
int wrap = 0;
int addr;
addr = HADDR;
if(burst_type == 3'b010 || 3'b100 || 3'b110)
begin
	for(int i = 0;i < 40;i++)
		begin
		if( wrap <wrap_or_incr_size) 
		begin
		HADDR 	<= HADDR + 1;
		wrap++;
		end
		else 
		begin
		HADDR 	<= addr;
		wrap 	 = 0;
		end
		HSIZE 	<= burst_size;			//byte size
		HBURST 	<= burst_type;
		if(i==0)
			HTRANS <= 2'b10;
		else 	HTRANS <= 2'b11;
		HPROT 	<= 4'b0011;
	end
end
else
begin
	for(int i = 0;i <  wrap_or_incr_size;i++)
	begin
		if(i> 0) 
			HADDR 	<= HADDR + 1;
		if(i==0)
			HTRANS 	<= 2'b10;
		else 	
			HTRANS 	<= 2'b11;
		HPROT	<= 4'b0011;
		HSIZE 	<= burst_size;			//byte size
		HBURST 	<= burst_type;
	end
end
	

endtask 


endclass

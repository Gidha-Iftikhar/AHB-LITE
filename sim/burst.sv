class burst;
	logic	[1:0]	HTRANS;
 	logic	[2:0]  	HSIZE;
 	logic	[2:0] 	HBURST;
rand 	logic 	[7:0] 	HADDR;
	logic 		HWRITE; //flag of read and write for monitor
	logic 	[3:0] 	HPROT;
rand	logic 	[31:0] 	HWDATA;
	logic 	[7:0]	cus_addr;
	logic 	[31:0] 	HRDATA;
	logic 		HSEL;
constraint random { 
		HADDR % 4 == 0 && HADDR < 8'd256;
		}
constraint HSEL_select{
			HSEL == 1;
			}

constraint customized 	{
			HADDR == cus_addr;
			}
	

endclass
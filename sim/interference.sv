interface ahb_if(input logic HCLK, input logic HRESETn);
 
  logic                       	HSEL;
  logic      			HADDR;
  logic       			HWDATA;
  logic       			HRDATA;
  logic                       	HWRITE;
  logic      			HSIZE;
  logic       			HBURST;
  logic       			HPROT;
  logic       			HTRANS;
  logic                       	HREADYOUT;
  logic                       	HREADY;
  logic                       	HRESP;

clocking master@(posedge HCLK);
default input #1 output #1;
output 	HSEL,HADDR,HWDATA,HWRITE,HSIZE,HBURST,HPROT,HTRANS,HREADY;
input 	HREADYOUT,HRESP;
endclocking

 modport dut(
      	input  		HRESETn,
      	input  		HCLK,
      	input   	HSEL,
  	input   	HADDR,
 	input   	HWDATA,
  	output 		HRDATA,
  	input           HWRITE,
  	input       	HSIZE,
  	input       	HBURST,
  	input       	HPROT,
  	input       	HTRANS,
  	output 		HREADYOUT,
  	input           HREADY,
  	output          HRESP
  );
 modport driver(
	input 		HCLK,
      	input  		HRESETn,
      	clocking	master
  );

 modport monitor(//HSEL,HADDR,HWDATA,HWRITE,HSIZE,HBURST,HPROT,HTRANS,HREADY,HREADYOUT,HRESP
	input  		HRESETn,
      	input  		HCLK,
      	input 		HSEL,
	input		HWRITE,
	input		HADDR,
	input		HWDATA,
	input		HSIZE,
	input		HBURST,
	input		HPROT,
	input		HTRANS,
	input		HREADY,

	input		HRDATA,
	input		HREADYOUT,
	input		HRESP

);
endinterface

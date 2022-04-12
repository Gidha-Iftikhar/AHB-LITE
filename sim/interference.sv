interface ahb_if(input HCLK);
  logic				HRESETn;
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
      	output  	HRESETn,
      	output  	HCLK,
      	output   	HSEL,
  	output   	HADDR,
 	output   	HWDATA,
  	output          HWRITE,
  	output       	HSIZE,
  	output       	HBURST,
  	output       	HPROT,
  	output       	HTRANS,
  	output          HREADY,
	input 		HREADYOUT,
	input          HRESP
  );

 modport monitor(
	input  		HRESETn,
      	input  		HCLK,
      	input   	HSEL,
  	input   	HADDR,
 	input   	HWDATA,
  	input           HWRITE,
  	input       	HSIZE,
  	input       	HBURST,
  	input       	HPROT,
  	input       	HTRANS,
  	input           HREADY,	
	input 		HRDATA,
	input 		HREADYOUT,
	input          HRESP);
endinterface

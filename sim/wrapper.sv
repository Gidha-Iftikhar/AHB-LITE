module wrapper (ahb_if.dut dut_if);

  

ahb3lite_sram1rw #(
  		.MEM_SIZE	(4),
		.MEM_DEPTH	(256),
		.HADDR_SIZE	(8),
		.HDATA_SIZE	(32),
		.TECHNOLOGY	("GENERIC"),
		.REGISTERED_OUTPUT("NO"),
		.INIT_FILE	("")
		) ahb_master(	.HRESETn (dut_if.HRESETn),
				.HCLK	(dut_if.HCLK),
				.HSEL	(dut_if.HSEL),
				.HADDR	(dut_if.HADDR),
				.HWDATA	(dut_if.HWDATA),
				.HRDATA	(dut_if.HRDATA),
				.HWRITE	(dut_if.HWRITE),
				.HSIZE	(dut_if.HSIZE),
				.HBURST	(dut_if.HBURST),
				.HPROT	(dut_if.HPROT),
				.HTRANS	(dut_if.HTRANS),
				.HREADYOUT(dut_if.HREADYOUT),
				.HREADY	(dut_if.HREADY),
				.HRESP	(dut_if.HRESP)	);



endmodule
	
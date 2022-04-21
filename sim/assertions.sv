module assertions(ahb_if ass_if);
//virtual interface ahb_if ass_if;
//------------------- ASSERTION # 1 ---------------------

assert property(@(posedge ass_if.HCLK)(!ass_if.HRESETn)|->ass_if.HREADYOUT);

//------------------- ASSERTION # 2 ---------------------

assert property(@(posedge ass_if.HCLK)(!ass_if.HSEL)|->ass_if.HREADYOUT);

//------------------- ASSERTION # 3 ---------------------

sequence low_hready;
!ass_if.HREADY ##1 ass_if.HREADY;
endsequence

 
sequence write_one;
!ass_if.HWRITE ##1 !ass_if.HWRITE ;
endsequence
sequence wait_one_cycle;
!ass_if.HADDR ##1 ass_if.HADDR;
endsequence 

property one;
@(posedge ass_if.HCLK)(low_hready) |-> (wait_one_cycle);
endproperty
assert property (one);

//------------------- ASSERTION # 4 ---------------------

sequence write_two;
!ass_if.HWRITE ##1 !ass_if.HWRITE ##1 !ass_if.HWRITE;
endsequence
sequence wait_two_cycle;
!ass_if.HADDR ##1 !ass_if.HADDR ##1 ass_if.HADDR;
endsequence 

property two;
@(posedge ass_if.HCLK)(low_hready) |-> (wait_two_cycle);
endproperty
assert property (two);

//------------------- ASSERTION #5 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HTRANS == 2'b00 |-> ##[1:2] !ass_if.HRESP);

//------------------- ASSERTION # 6 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HTRANS == 2'b01 |-> ##[1:2] !ass_if.HRESP);

//------------------- ASSERTION # 7 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HTRANS == 2'b01 |-> ##1 ass_if.HWDATA == 32'b0 & ass_if.HRDATA == 32'b0 ##[1:2] !ass_if.HRESP);

//------------------- ASSERTION # 8 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HTRANS == 2'b01 ##1 ass_if.HTRANS == 2'b00 ##1 ass_if.HTRANS == 2'b01 |-> ##[1:2] !ass_if.HRESP);

//------------------- ASSERTION # 9 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HADDR > 8'd256 |->##[1:2] ass_if.HRESP );

//------------------- ASSERTION # 10 ---------------------

assert property(@(posedge ass_if.HCLK)ass_if.HBURST == 3'b000 |-> ##2 !ass_if.HRESP & ass_if.HREADYOUT);


endmodule

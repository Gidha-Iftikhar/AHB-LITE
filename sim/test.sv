//`ifdef include_n
`include "environment.sv"
`include "rand_burst_generate.sv"
program test(ahb_if intf);
  
  //declare environment handle
  environment env;
  localparam burst_no = 1000;		// In order to write or read random many bursts
  localparam read_write = 0;
 
  logic [2:0] burst_type;
  logic [2:0] burst_size;
  int wrap_or_incr_size;

  initial begin
    //create environment
 	$display("\n\n-----Test initial block------------\n\n");
     	env = new(intf);
     	test_1();
	test_2and3();
	test_8to15();
	test_16();
	
	$stop;
  end

task randomize();
forever begin
	burst_type = $random;
        burst_size = $random;
        wrap_or_incr_size = $random;

	env.gen.generate_burst(burst_type,burst_size,wrap_or_incr_size,read_write,0,0);
	wait(env.gen.burst_count == burst_no);
	$stop;
end
endtask

//////////////  TESTS FROM VERIFICATION PLAN ///////////////////

task test_1();
env.gen.write_incr4_burst_hw(0,0);
env.gen.pkt.HSEL_select.constraint_mode(0);
env.gen.pkt.HSEL= 0;
env.gen.run();
/*if(env.mon.pkt.HWDATA == 32'b0)
$display("TEST# 1 HAS PASSED");
else
$display("TEST# 1 HAS FAILED");*/
endtask

task test_2and3();
static int addr = 25;
int data1,data2;
env.gen.write_single_burst_word(1,addr);
env.gen.run();
data1 = env.gen.pkt.HWDATA;
env.gen.read_single_burst_word(1,addr);
env.gen.run();
data2 = env.gen.pkt.HRDATA;
if(data1 == data2)
$display("TEST# 2 HAS PASSED");
else
$display("TEST# 2 HAS FAILED");
endtask

task test_8to15();
env.gen.write_single_burst_byte(0,0);
env.gen.write_incr_burst_byte(0,0);
env.gen.write_wrap4_burst_byte(0,0);
env.gen.write_incr4_burst_byte(0,0);
env.gen.write_wrap8_burst_byte(0,0);
env.gen.write_incr8_burst_byte(0,0);
env.gen.write_wrap16_burst_byte(0,0);
env.gen.write_incr16_burst_byte(0,0);
env.gen.run();

endtask

task test_16();
env.gen.run();
env.run();
endtask


task test();			//example test

env.pre_test();
env.gen.write_single_burst_byte(1,8'b00011001);
env.gen.read_single_burst_byte(1,8'b00011001);
env.mon.run();
env.scb.run(); 
endtask
endprogram

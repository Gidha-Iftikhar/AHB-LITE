`include "burst.sv"
class generator;
mailbox gen2drive;
int burst_count;
rand burst pkt;
function new(mailbox gen2drive, int burst_count);
	this.gen2drive	 <= gen2drive;
	this.burst_count <= burst_count;
endfunction


////////////////HSIZE length//////////////////// 
localparam BYTE		= 000;
localparam HALF_WORD	= 001;
localparam WORD		= 010;

/////////////// TASKS ////////////////////////
task single_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b000,BYTE,1);  
gen2drive.put(pkt);
burst_count++;
endtask

task incr_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b001,BYTE,100);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap4_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b010,BYTE,4);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr4_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b011,BYTE,4);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap8_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b100,BYTE,8);
gen2drive.put(pkt);
burst_count++;	
endtask

task incr8_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b101,BYTE,8);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap16_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b110,BYTE,16);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr16_burst_byte();
pkt = new;
pkt.randomize();
pkt.create(3'b111,BYTE,16);
gen2drive.put(pkt);
burst_count++;
endtask

////////////////////half word bursts//////////////
task single_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b000,HALF_WORD,1);  
gen2drive.put(pkt);
burst_count++;
endtask

task incr_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b001,HALF_WORD,100);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap4_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b010,HALF_WORD,4);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr4_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b011,HALF_WORD,4);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap8_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b100,HALF_WORD,8);
gen2drive.put(pkt);
burst_count++;	
endtask

task incr8_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b101,HALF_WORD,8);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap16_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b110,HALF_WORD,16);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr16_burst_hw();
pkt = new;
pkt.randomize();
pkt.create(3'b111,HALF_WORD,16);
gen2drive.put(pkt);
burst_count++;
endtask

//////////////////////Word length bursts/////////////
task single_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b000,WORD,1);  
gen2drive.put(pkt);
burst_count++;
endtask

task incr_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b001,WORD,100);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap4_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b010,WORD,4);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr4_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b011,WORD,4);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap8_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b100,WORD,8);
gen2drive.put(pkt);
burst_count++;	
endtask

task incr8_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b101,WORD,8);
gen2drive.put(pkt);
burst_count++;
endtask

task wrap16_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b110,WORD,16);
gen2drive.put(pkt);
burst_count++;
	
endtask

task incr16_burst_word();
pkt = new;
pkt.randomize();
pkt.create(3'b111,WORD,16);
gen2drive.put(pkt);
burst_count++;
endtask

////////////////main tasks//////////////////////
task run;
single_burst_byte();
incr_burst_byte();
incr4_burst_byte();
wrap4_burst_byte();
incr8_burst_byte();
wrap8_burst_byte();
incr16_burst_byte();
wrap16_burst_byte();

single_burst_hw();
incr_burst_hw();
incr4_burst_hw();
wrap4_burst_hw();
incr8_burst_hw();
wrap8_burst_hw();
incr16_burst_hw();
wrap16_burst_hw();

single_burst_word();
incr_burst_word();
incr4_burst_word();
wrap4_burst_word();
incr8_burst_word();
wrap8_burst_word();
incr16_burst_word();
wrap16_burst_word();
endtask

endclass

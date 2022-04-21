`ifndef include_n
`include "burst.sv"
`endif
class generator;
mailbox#(burst) gen2drive;
int burst_count;
rand burst pkt;
event all_sent;
function new(mailbox#(burst) gen2drive);
$display("\n\n---------- Generator constructor---------\n\n");
	this.gen2drive	 = gen2drive;

endfunction


////////////////HSIZE length//////////////////// 
localparam BYTE		= 000;
localparam HALF_WORD	= 001;
localparam WORD		= 010;

///////////////HBURST TYPE/////////////////////

localparam SINGLE	= 000;
localparam INCR		= 001;
localparam WRAP4	= 010;
localparam INCR4	= 011;
localparam WRAP8	= 100;
localparam INCR8	= 101;
localparam WRAP16	= 110;
localparam INCR16	= 111;

task generate_burst(input [2:0] burst_type, input [2:0] burst_size, int wrap_or_incr_size, bit read_write,bit custom,logic [7:0] cus_addr);

//$display("generating new burst");
int addr;
if(burst_type == 3'b010 || 3'b100 || 3'b110)
begin 
for(int i=0;i<wrap_or_incr_size;i++)			// for WRAP bursts
	begin
	pkt = new;
	//pkt.randomize();
	if(custom)
	begin
	pkt.cus_addr = cus_addr;
	pkt.random.constraint_mode(0);
	pkt.customized.constraint_mode(1);
	end
	else
	begin
	pkt.random.constraint_mode(1);
	pkt.customized.constraint_mode(0);
	end
	if(i == 0)
	begin
		if(custom)
		begin
		pkt.cus_addr = cus_addr;
		pkt.random.constraint_mode(0);
		pkt.customized.constraint_mode(1);
		end
		else
		begin
		pkt.random.constraint_mode(1);
		pkt.customized.constraint_mode(0);
		end
	addr 		= pkt.HADDR;
	pkt.HTRANS 	= 2'b10;
	end
	else
	begin
		pkt.HADDR	<= addr+4;
		pkt.HTRANS 	<= 2'b11;
	end
	pkt.HWRITE	<= read_write;
	pkt.HBURST 	<= burst_type;
	pkt.HSIZE	<= burst_size;
	pkt.HPROT 	<= 4'b0011;
	gen2drive.put(pkt);
	burst_count++;
	end
//$display("burst generated for address s");
end
else							// for INCR bursts
begin
int wrap = 0;
int start_addr;
for(int i = 0;i < 40 ;i++)
begin
	pkt = new;
	//pkt.randomize();
	if(wrap<wrap_or_incr_size)
	begin
		if(i == 0)
		begin
			if(custom)
			begin
			pkt.cus_addr = cus_addr;
			pkt.random.constraint_mode(0);
			pkt.customized.constraint_mode(1);
			end
			else
			begin
			pkt.random.constraint_mode(1);
			pkt.customized.constraint_mode(0);
			end
		addr 		<= pkt.HADDR;
		start_addr 	<= pkt.HADDR;
		pkt.HTRANS 	<= 2'b10;
		wrap ++;
		end
		else
		begin
		pkt.HADDR	<= addr+4;
		pkt.HTRANS 	<= 2'b11;
		wrap++;
		end
	end
	else
	begin
		addr		<= start_addr;
		wrap		= 0;
	end
	pkt.HPROT		<= 4'b0011;
	pkt.HSIZE 		<= burst_size;			//byte size
	pkt.HBURST 		<= burst_type;
	pkt.HWRITE		<= read_write;
	pkt.HPROT 		<= 4'b0011;
	gen2drive.put(pkt);
	burst_count++;
//$display("burst generated for address ");
end

end
/*pkt.create_burst(burst_type,burst_size,wrap_or_incr_size,read_write);
gen2drive.put(pkt);
burst_count++;
pkt.display();
$display("\n\n---------- write single burst byte at HADDR = %d ---------\n\n",pkt.HADDR);	*/
pkt.display();
endtask

/////////////// MAIN TASKS ////////////////////////
task write_single_burst_byte(bit custom,logic [7:0] cus_addr);

generate_burst(SINGLE,BYTE,0,1,custom,cus_addr);
//$display("\n\n---------- write single burst byte at HADDR = %d ---------\n\n",pkt.HWDATA);	
endtask

task write_incr_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR burst byte---------\n\n");
generate_burst(INCR,BYTE,100,1,custom,cus_addr);
endtask

task write_wrap4_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP4 burst byte---------\n\n");
generate_burst(WRAP4,BYTE,4,1,custom,cus_addr);	
endtask

task write_incr4_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR4 burst byte---------\n\n");
generate_burst(INCR4,BYTE,4,1,custom,cus_addr);
endtask

task write_wrap8_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP8 burst byte---------\n\n");
generate_burst(WRAP8,BYTE,8,1,custom,cus_addr);
endtask

task write_incr8_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR8 burst byte---------\n\n");
generate_burst(INCR8,BYTE,8,1,custom,cus_addr);
endtask

task write_wrap16_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP16 burst byte---------\n\n");
generate_burst(WRAP16,BYTE,16,1,custom,cus_addr);	
endtask

task write_incr16_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR16 burst byte---------\n\n");
generate_burst(INCR16,BYTE,16,1,custom,cus_addr);
endtask

////////////////////half word bursts//////////////
task write_single_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write single burst half word---------\n\n");
generate_burst(SINGLE,HALF_WORD,0,1,custom,cus_addr);  
endtask

task write_incr_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR burst half word---------\n\n");
generate_burst(INCR,HALF_WORD,100,1,custom,cus_addr);
endtask

task write_wrap4_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP4 burst half word---------\n\n");
generate_burst(WRAP4,HALF_WORD,4,1,custom,cus_addr);
endtask

task write_incr4_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR4 burst half word---------\n\n");
generate_burst(INCR,HALF_WORD,4,1,custom,cus_addr);
endtask

task write_wrap8_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP8 burst half word---------\n\n");
generate_burst(WRAP8,HALF_WORD,8,1,custom,cus_addr);	
endtask

task write_incr8_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR8 burst half word---------\n\n");
generate_burst(INCR8,HALF_WORD,8,1,custom,cus_addr);
endtask

task write_wrap16_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP16 burst half word---------\n\n");
generate_burst(WRAP16,HALF_WORD,16,1,custom,cus_addr);
endtask

task write_incr16_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR16 burst half word---------\n\n");
generate_burst(INCR16,HALF_WORD,16,1,custom,cus_addr);
endtask

//////////////////////Word length bursts/////////////
task write_single_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write SINGLE burst word---------\n\n");
generate_burst(SINGLE,WORD,0,1,custom,cus_addr);
endtask

task write_incr_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR burst word---------\n\n");
generate_burst(INCR,WORD,100,1,custom,cus_addr);
endtask

task write_wrap4_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP4 burst word---------\n\n");
generate_burst(WRAP4,WORD,4,1,custom,cus_addr);
endtask

task write_incr4_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR4 burst word---------\n\n");
generate_burst(INCR4,WORD,4,1,custom,cus_addr);
endtask

task write_wrap8_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP8 burst word---------\n\n");
generate_burst(WRAP8,WORD,8,1,custom,cus_addr);
endtask

task write_incr8_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR8 burst word---------\n\n");
generate_burst(INCR8,WORD,8,1,custom,cus_addr);
endtask

task write_wrap16_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write WRAP16 burst word---------\n\n");
generate_burst(WRAP16,WORD,16,1,custom,cus_addr);
endtask

task write_incr16_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- write INCR16 burst word---------\n\n");
generate_burst(INCR16,WORD,16,1,custom,cus_addr);
endtask


////////////////////////read Tasks///////////////////

task read_single_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read SINGLE burst byte---------\n\n");
generate_burst(SINGLE,BYTE,0,0,custom,cus_addr);
endtask

task read_incr_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR burst byte---------\n\n");
generate_burst(INCR,BYTE,100,0,custom,cus_addr);
endtask

task read_wrap4_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP4 burst byte---------\n\n");
generate_burst(WRAP4,BYTE,4,0,custom,cus_addr);	
endtask

task read_incr4_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR4 burst byte---------\n\n");
generate_burst(INCR4,BYTE,4,0,custom,cus_addr);
endtask

task read_wrap8_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP8 burst byte---------\n\n");
generate_burst(WRAP8,BYTE,8,0,custom,cus_addr);
endtask

task read_incr8_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR8 burst byte---------\n\n");
generate_burst(INCR8,BYTE,8,0,custom,cus_addr);
endtask

task read_wrap16_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP16 burst byte---------\n\n");
generate_burst(WRAP16,BYTE,16,0,custom,cus_addr);	
endtask

task read_incr16_burst_byte(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR16 burst byte---------\n\n");
generate_burst(INCR16,BYTE,16,0,custom,cus_addr);
endtask

////////////////////half word bursts//////////////
task read_single_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read SINGLE burst half word---------\n\n");
generate_burst(SINGLE,HALF_WORD,0,0,custom,cus_addr);  
endtask

task read_incr_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR burst half word---------\n\n");
generate_burst(INCR,HALF_WORD,100,0,custom,cus_addr);
endtask

task read_wrap4_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP4 burst half word---------\n\n");
generate_burst(WRAP4,HALF_WORD,4,0,custom,cus_addr);
endtask

task read_incr4_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR4 burst half word---------\n\n");
generate_burst(INCR,HALF_WORD,4,0,custom,cus_addr);
endtask

task read_wrap8_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP 8 burst half word---------\n\n");
generate_burst(WRAP8,HALF_WORD,8,0,custom,cus_addr);	
endtask

task read_incr8_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR8 burst half word---------\n\n");
generate_burst(INCR8,HALF_WORD,8,0,custom,cus_addr);
endtask

task read_wrap16_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP 16 burst half word---------\n\n");
generate_burst(WRAP16,HALF_WORD,16,0,custom,cus_addr);
endtask

task read_incr16_burst_hw(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR16 burst half word---------\n\n");
generate_burst(INCR16,HALF_WORD,16,0,custom,cus_addr);
endtask

//////////////////////Word length bursts/////////////
task read_single_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read SINGLE burst word---------\n\n");
generate_burst(SINGLE,WORD,0,0,custom,cus_addr);
endtask

task read_incr_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR burst word---------\n\n");
generate_burst(INCR,WORD,100,0,custom,cus_addr);
endtask

task read_wrap4_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP4 burst word---------\n\n");
generate_burst(WRAP4,WORD,4,0,custom,cus_addr);
endtask

task read_incr4_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR4 burst word---------\n\n");
generate_burst(INCR4,WORD,4,0,custom,cus_addr);
endtask

task read_wrap8_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP8 burst word---------\n\n");
generate_burst(WRAP8,WORD,8,0,custom,cus_addr);
endtask

task read_incr8_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR8 burst word---------\n\n");
generate_burst(INCR8,WORD,8,0,custom,cus_addr);
endtask

task read_wrap16_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read WRAP16 burst word---------\n\n");
generate_burst(WRAP16,WORD,16,0,custom,cus_addr);
endtask

task read_incr16_burst_word(bit custom,logic [7:0] cus_addr);
$display("\n\n---------- read INCR16 burst word---------\n\n");
generate_burst(INCR16,WORD,16,0,custom,cus_addr);
endtask

////////////////RUN task//////////////////////
task run;

write_single_burst_byte(0,0);
write_incr_burst_byte(0,0);
write_incr4_burst_byte(0,0);
write_wrap4_burst_byte(0,0);
write_incr8_burst_byte(0,0);
write_wrap8_burst_byte(0,0);
write_incr16_burst_byte(0,0);
write_wrap16_burst_byte(0,0);

write_single_burst_hw(0,0);
write_incr_burst_hw(0,0);
write_incr4_burst_hw(0,0);
write_wrap4_burst_hw(0,0);
write_incr8_burst_hw(0,0);
write_wrap8_burst_hw(0,0);
write_incr16_burst_hw(0,0);
write_wrap16_burst_hw(0,0);

write_single_burst_word(0,0);
write_incr_burst_word(0,0);
write_incr4_burst_word(0,0);
write_wrap4_burst_word(0,0);
write_incr8_burst_word(0,0);
write_wrap8_burst_word(0,0);
write_incr16_burst_word(0,0);
write_wrap16_burst_word(0,0);

read_single_burst_byte(0,0);
read_incr_burst_byte(0,0);
read_incr4_burst_byte(0,0);
read_wrap4_burst_byte(0,0);
read_incr8_burst_byte(0,0);
read_wrap8_burst_byte(0,0);
read_incr16_burst_byte(0,0);
read_wrap16_burst_byte(0,0);

read_single_burst_hw(0,0);
read_incr_burst_hw(0,0);
read_incr4_burst_hw(0,0);
read_wrap4_burst_hw(0,0);
read_incr8_burst_hw(0,0);
read_wrap8_burst_hw(0,0);
read_incr16_burst_hw(0,0);
read_wrap16_burst_hw(0,0);

read_single_burst_word(0,0);
read_incr_burst_word(0,0);
read_incr4_burst_word(0,0);
read_wrap4_burst_word(0,0);
read_incr8_burst_word(0,0);
read_wrap8_burst_word(0,0);
read_incr16_burst_word(0,0);
read_wrap16_burst_word(0,0);

endtask

endclass

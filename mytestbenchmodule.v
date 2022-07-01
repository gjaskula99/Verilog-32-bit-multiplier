module mytestbenchmodule();

reg CLK;
initial CLK  <= 0;
always #50  CLK <= ~CLK;
	
reg RST;
initial 
begin
	RST <= 0;
	RST <= #100 1;
	RST <= #500 0;
end	  
	
reg [15:0] i_dat_a;	  
reg [15:0] i_dat_b;
reg i_stb;	 
reg o_ack;
wire i_ack;
wire o_stb;


initial 
begin		  
	o_ack <= 0;
	i_stb <= 0;
	#1051;	
	i_dat_a <= 511;	 
	i_dat_b <= 63;
	i_stb <= 1;
	#100;	  
	i_stb <= 0;
	#500;
	o_ack <= 1;
end	  

always @(posedge CLK)
if (i_ack) begin
	o_ack <= 0;
	i_stb <= 0;
	#800;
	i_dat_a <= i_dat_a+1;	 
	i_dat_b <= i_dat_b+1;
	i_stb <= 1;
	//i_stb <= 0;
	#50;
	o_ack <= 1;
	//#300;	
	//o_ack <= 0;
end

multiplier
#(
.A_WIDTH(16), 
.B_WIDTH(16)
)  
multiplier1 
( 
.CLK(CLK),
.RST(RST),

.I_DAT_A(i_dat_a), 
.I_DAT_B(i_dat_b),
.I_STB(i_stb),
.I_ACK(i_ack),

.O_DAT(), 
.O_STB(o_stb),
.O_ACK(o_ack)
);		

endmodule	

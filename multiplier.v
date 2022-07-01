module multiplier 
#(								  
parameter A_WIDTH = 32,
parameter B_WIDTH = 32
)	
(
	input wire RST,
	input wire CLK,
	
	input  wire I_STB,		
	output wire I_ACK,
	input  wire [A_WIDTH-1:0] I_DAT_A,
	input  wire [B_WIDTH-1:0] I_DAT_B,	
	
	output reg  O_STB,
	output reg  [A_WIDTH+B_WIDTH-1 : 0] O_DAT,
	input  wire O_ACK
);	

assign I_ACK = I_STB & ~O_STB;

always @(posedge CLK or posedge RST)
	if (RST) O_DAT <= 0;
	else if (I_ACK) O_DAT <= I_DAT_A*I_DAT_B;

always @(posedge CLK or posedge RST)
	if (RST) O_STB <= 0;
	else if (O_ACK) O_STB <= 0;
	else if (I_ACK) O_STB <= 1;

endmodule

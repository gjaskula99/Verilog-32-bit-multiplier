module multiplier_32bit
(
	input wire RST,
	input wire CLK,
	
	input  wire I_STB,
	output wire I_ACK,
	input  wire [31:0] I_DAT_A,
	input  wire [31:0] I_DAT_B,

	output wire O_STB,
	output wire [63:0] O_DAT,
	input  wire O_ACK
);
wire 		ACK_AB;

wire [31:0] DAT_BL_AL;
wire 		STB_BL_AL;
wire 		ACK_BL_AL;
wire 		ACK_BLAL_BHAH;


wire [31:0] DAT_BL_AH;
wire 		STB_BL_AH;
wire 		ACK_BL_AH;
wire 		ACK_BLAH_BHAL;

wire [31:0] DAT_BH_AL;
wire 		STB_BH_AL;
wire 		ACK_BH_AL;

wire [31:0] DAT_BH_AH;
wire 		STB_BH_AH;
wire 		ACK_BH_AH;

wire [32:0]	DAT_BLAH_BHAL;
wire 		STB_BLAH_BHAL;

wire [63:0] DAT_BLAL_BHAH;
wire 		STB_BLAL_BHAH;

multiplier #(
.A_WIDTH(16), 
.B_WIDTH(16)
) BL_AL (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(I_DAT_A[15:0]), 
	.I_DAT_B(I_DAT_B[15:0]),
	.I_STB(I_STB),
	.I_ACK(ACK_BL_AL),
	
	.O_DAT(DAT_BL_AL),
	.O_STB(STB_BL_AL),
	.O_ACK(ACK_BLAL_BHAH)
);

multiplier #(
.A_WIDTH(16), 
.B_WIDTH(16)
) BL_AH (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(I_DAT_A[31:16]), 
	.I_DAT_B(I_DAT_B[15:0]),
	.I_STB(I_STB),
	.I_ACK(ACK_BL_AH),
	
	.O_DAT(DAT_BL_AH), 
	.O_STB(STB_BL_AH),
	.O_ACK(ACK_BLAH_BHAL)
);


multiplier #(
.A_WIDTH(16), 
.B_WIDTH(16)
) BH_AL (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(I_DAT_A[15:0]), 
	.I_DAT_B(I_DAT_B[31:16]),
	.I_STB(I_STB),
	.I_ACK(ACK_BH_AL),
	
	.O_DAT(DAT_BH_AL), 
	.O_STB(STB_BH_AL),
	.O_ACK(ACK_BLAH_BHAL)
);

multiplier #(
.A_WIDTH(16), 
.B_WIDTH(16)
) BH_AH (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(I_DAT_A[31:16]), 
	.I_DAT_B(I_DAT_B[31:16]),
	.I_STB(I_STB),
	.I_ACK(ACK_BH_AH),
	
	.O_DAT(DAT_BH_AH), 
	.O_STB(STB_BH_AH),
	.O_ACK(ACK_BLAL_BHAH)
);

adder #(
.A_WIDTH(32), 
.B_WIDTH(32)
) BLAH_BHAL (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(DAT_BL_AH), 
	.I_DAT_B(DAT_BH_AL),
	.I_STB(STB_BH_AL & STB_BL_AH),
	.I_ACK(ACK_BLAH_BHAL),
	
	.O_DAT(DAT_BLAH_BHAL), 
	.O_STB(STB_BLAH_BHAL),
	.O_ACK(ACK_AB)
);

adder #(
.A_WIDTH(64), 
.B_WIDTH(64)
) BLAL_BHAH (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A({ DAT_BH_AH, 32'd0}), 
	.I_DAT_B({ 32'd0, DAT_BL_AL}),
	.I_STB(STB_BH_AH & STB_BL_AL),
	.I_ACK(ACK_BLAL_BHAH),
	
	.O_DAT(DAT_BLAL_BHAH), 
	.O_STB(STB_BLAL_BHAH),
	.O_ACK(ACK_AB)
);


adder #(
.A_WIDTH(64),
.B_WIDTH(33+16)	
) AB (
	.CLK(CLK),
	.RST(RST),
	
	.I_DAT_A(DAT_BLAL_BHAH), 
	.I_DAT_B({DAT_BLAH_BHAL, 16'd0}),
	.I_STB(STB_BLAL_BHAH & STB_BLAH_BHAL),
	.I_ACK(ACK_AB),
	
	.O_DAT(O_DAT), 
	.O_STB(O_STB),
	.O_ACK(O_ACK)
);

endmodule
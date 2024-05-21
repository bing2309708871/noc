module fifo import noc_pkg::*;
(

    input   logic               clk,
    input   logic               rst_n,
    input	logic   [DATA_W-1:0]	idata,
    output	logic   [DATA_W-1:0]	odata,

    input   logic			    wr_en,
    input   logic			    rd_en, 

    output  logic			    empty,
    output  logic			    full,

    output  logic			    ordy

);

    reg	[DATA_W-1:0]	ram	[0:FIFO];

    reg	[FIFOD:0]	rd_addr, wr_addr;
    reg	[FIFOD_P1:0]	d_cnt;
    wire			set;
    integer	i;

/* Write address */
always @ (posedge clk) begin
	if (~rst_n) 
		wr_addr	<= 0;
	else if (set) 
		if (wr_addr == FIFO)
			wr_addr	<= 0;
		else
			wr_addr	<= wr_addr + 1;
end

//always @(posedge clk) begin
//	$display("wr_addr %h,odata %h.d_cnt %h",wr_addr,odata,d_cnt);
//end

/* Read address */
always @ (posedge clk) begin
	if (~rst_n) 
		rd_addr	<= 0;
	else if (~empty & rd_en) 
		if (rd_addr == FIFO)
			rd_addr	<= 0;
		else
			rd_addr	<= rd_addr + 1;
end

/* Data counter */
always @ (posedge clk) begin
	if (~rst_n) 
		d_cnt	<= 0;
	else if (~full  & wr_en & ~(rd_en & ~empty)) 
		d_cnt	<= d_cnt + 1;
	else if (~empty & rd_en & ~wr_en) 
		d_cnt	<= d_cnt - 1;
end

/* Full, Empty, Set */
assign	full	= (d_cnt == FIFO_P1);
assign	empty	= (d_cnt == 0);
assign	set	= (~full | rd_en) & wr_en;

/* Empty space for a single packet */
assign	ordy	= ((FIFO_P1 - d_cnt) >= PKTLEN_P1) ? ENABLE : DISABLE;

/* Memory I/O */
assign	odata	= ~empty ? ram[rd_addr] : 0;
always @ (posedge clk) begin
	if (~rst_n) 
		for (i = 0; i < FIFO_P1; i = i + 1)
			ram[i]	<= 0;
	else if (set) 
		ram[wr_addr]	<= idata;
end

endmodule


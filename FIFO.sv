////////////////////////////////////////////////////////////////////////////////
// Author: Ahmed Ashour 
// 
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////

module FIFO(FIFO_if.DUT F_if);
	
// Define local parameters
localparam max_fifo_addr = $clog2(F_if.FIFO_DEPTH);

// Declare memory for FIFO storage
reg [F_if.FIFO_WIDTH-1:0] mem [F_if.FIFO_DEPTH-1:0];

// Declare write and read pointers along with count
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

// Define an up-counting property for verification
property upC ;
    logic [max_fifo_addr:0] count_next;
    @(posedge F_if.clk) disable iff(!F_if.rst_n) (((F_if.wr_en&&!F_if.rd_en)&&(!F_if.full)), count_next=count+1) |=> (count==count_next);
endproperty

// Define a down-counting property for verification
property dwC ;
    logic [max_fifo_addr:0] count_next;
    @(posedge F_if.clk) disable iff(!F_if.rst_n) (((!F_if.wr_en&&F_if.rd_en)&&(!F_if.empty)), count_next=count-1) |=> (count==count_next);
endproperty

// Define assertions for FIFO properties
Full        : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == F_if.FIFO_DEPTH) |-> (F_if.full));
empty       : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == 0) |-> (F_if.empty));
almostfull  : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == F_if.FIFO_DEPTH-1) |-> (F_if.almostfull));
almostempty : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (count == 1) |-> (F_if.almostempty));
wr_ack      : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (!F_if.full && F_if.wr_en) |=> (F_if.wr_ack));
overflow    : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.full && F_if.wr_en) |=> (F_if.overflow));
underflow   : assert property (@(posedge F_if.clk) disable iff(!F_if.rst_n) (F_if.empty && F_if.rd_en) |=> (F_if.underflow));
countup     : assert property (upC);
countdw     : assert property (dwC);

// Always block for write operation
always @(posedge F_if.clk or negedge F_if.rst_n) begin
    if (!F_if.rst_n) begin
        wr_ptr <= 0;
        F_if.wr_ack <= 0; 
        F_if.overflow <= 0;
    end
    else if (F_if.wr_en && count < F_if.FIFO_DEPTH) begin
        mem[wr_ptr] <= F_if.data_in;
        F_if.wr_ack <= 1;
        F_if.overflow <= 0;
        wr_ptr <= wr_ptr + 1;
    end
    else begin 
        F_if.wr_ack <= 0; 
        if (F_if.full & F_if.wr_en)
            F_if.overflow <= 1;
        else
            F_if.overflow <= 0;
    end
end

// Always block for read operation
always @(posedge F_if.clk or negedge F_if.rst_n) begin
    if (!F_if.rst_n) begin
        rd_ptr <= 0;
        F_if.underflow <= 0;
    end
    else if (F_if.rd_en && count != 0) begin
        F_if.data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        F_if.underflow <= 0;
    end
    else begin
        if (F_if.empty && F_if.rd_en)
            F_if.underflow <= 1;
        else
            F_if.underflow <= 0;
    end
end

// Always block for count update
always @(posedge F_if.clk or negedge F_if.rst_n) begin
    if (!F_if.rst_n) begin
        count <= 0;
    end
    else begin
        if	( ({F_if.wr_en, F_if.rd_en} == 2'b10) && !F_if.full) 
            count <= count + 1;
        else if ( ({F_if.wr_en, F_if.rd_en} == 2'b01) && !F_if.empty)
            count <= count - 1;
        else if ( ({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.full) begin
            count <= count - 1;
        end
        else if ( ({F_if.wr_en, F_if.rd_en} == 2'b11) && F_if.empty) begin
            count <= count + 1;
        end
    end
end

// Assign full, empty, almostfull, and almostempty based on count
assign F_if.full = (count == F_if.FIFO_DEPTH)? 1 : 0;
assign F_if.empty = (count == 0)? 1 : 0;
assign F_if.almostfull = (count == F_if.FIFO_DEPTH-1)? 1 : 0; 
assign F_if.almostempty = (count == 1)? 1 : 0;

endmodule

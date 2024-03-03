// Define an interface named FIFO_if with parameters for FIFO width and depth
interface FIFO_if (clk);
    parameter FIFO_WIDTH = 16;   // Set the width of the FIFO to 16 bits
    parameter FIFO_DEPTH = 8;    // Set the depth of the FIFO to 8 elements

    // Declare input and output signals within the interface
    input bit clk;                            // Clock signal
    logic [FIFO_WIDTH-1:0] data_in;           // Input data to the FIFO
    logic rst_n, wr_en, rd_en;                // Reset, write enable, and read enable signals
    logic [FIFO_WIDTH-1:0] data_out;          // Output data from the FIFO
    logic wr_ack, overflow;                   // Write acknowledge and overflow signals
    logic full, empty, almostfull, almostempty, underflow; // Status signals

    // Define modports for different roles in the interface
    modport DUT  (input  clk, data_in, rst_n, wr_en, rd_en,     // DUT modport for DUT (Design Under Test)
                  output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

    modport TEST (output      data_in, rst_n, wr_en, rd_en,     // TEST modport for testbench
                  input clk, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

    modport Monitor  (input  clk, data_in, rst_n, wr_en, rd_en,  // Monitor modport for monitoring purposes
                     data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
endinterface

// Define a SystemVerilog package named pkg_transaction
package pkg_transaction;
    parameter FIFO_WIDTH = 16;  // Set the width of the FIFO to 16 bits
    parameter FIFO_DEPTH = 8;   // Set the depth of the FIFO to 8 elements

    // Define a class named FIFO_transaction within the package
    class FIFO_transaction;
        rand logic [FIFO_WIDTH-1:0] data_in;        // Randomized input data
        rand logic rst_n, wr_en, rd_en;             // Randomized reset and control signals
        rand logic [FIFO_WIDTH-1:0] data_out;       // Randomized output data
        rand logic wr_ack, overflow;                // Randomized write acknowledge and overflow signals
        rand logic full, empty, almostfull, almostempty, underflow; // Randomized status signals

        int WR_EN_ON_DIST = 70;   // Probability distribution for write enable being '1'
        int RD_EN_ON_DIST = 30;   // Probability distribution for read enable being '1'

        // Constraint for the reset signal
        constraint cstr_Reset {rst_n  dist {1'b1:=98, 1'b0:=2};}

        // Constraint for the write enable signal
        constraint cstr_WrEn  {wr_en  dist {1'b1:=WR_EN_ON_DIST, 1'b0:=(100-WR_EN_ON_DIST)};}

        // Constraint for the read enable signal
        constraint cstr_RdEn  {rd_en  dist {1'b1:=RD_EN_ON_DIST, 1'b0:=(100-RD_EN_ON_DIST)};}
    endclass

endpackage

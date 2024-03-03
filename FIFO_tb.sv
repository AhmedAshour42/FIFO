// Import necessary packages for transactions, coverage, and scoreboard
import pkg_transaction::*;
import pkg_cvr::*;
import pkg_FIFO_scoreboard::*;

// Define a SystemVerilog module named FIFO_tb using the TEST modport of the FIFO interface
module FIFO_tb (FIFO_if.TEST F_if);

    // Declare a random transaction object named rand_inputs of type FIFO_transaction
    FIFO_transaction rand_inputs = new;

    // Initial block for testbench setup
    initial begin
        F_if.rst_n = 0; // Assert reset initially
        @(negedge F_if.clk); // Wait for a negative edge of the clock
        F_if.rst_n = 1; // Deassert reset

        // Generate transactions for 10,000 cycles
        for (int i = 0; i < 10000; i++) begin
            assert(rand_inputs.randomize()); // Randomize transaction data
            F_if.rst_n   = rand_inputs.rst_n; // Assign values to interface signals
            F_if.data_in = rand_inputs.data_in;
            F_if.wr_en   = rand_inputs.wr_en;
            F_if.rd_en   = rand_inputs.rd_en;
            @(negedge F_if.clk); // Wait for a negative edge of the clock
        end

        test_finished = 1; // Set test_finished flag after completing transactions
        @(negedge F_if.clk); // Wait for a negative edge of the clock
    end

endmodule : FIFO_tb

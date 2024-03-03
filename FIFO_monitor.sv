// Import necessary packages for transactions, coverage, and scoreboard
import pkg_transaction::*;
import pkg_cvr::*;
import pkg_FIFO_scoreboard::*;

// Define a SystemVerilog module named FIFO_monitor using the Monitor modport of the FIFO interface
module FIFO_monitor (FIFO_if.Monitor F_if);
    // Declare a random transaction object named fifo_trx of type FIFO_transaction
    FIFO_transaction fifo_trx = new;

    // Declare a coverage object named fifo_cvr of type FIFO_coverage
    FIFO_coverage fifo_cvr = new;

    // Initial block for monitor setup
    initial begin
        // Forever loop for continuous monitoring
        forever begin
            @(negedge F_if.clk); // Wait for a negative edge of the clock
            #1; // Wait for one time unit

            // Sampling all data for coverage
            fifo_trx.data_in     = F_if.data_in;
            fifo_trx.rst_n       = F_if.rst_n;
            fifo_trx.wr_en       = F_if.wr_en;
            fifo_trx.rd_en       = F_if.rd_en;
            fifo_trx.data_out    = F_if.data_out;
            fifo_trx.wr_ack      = F_if.wr_ack;
            fifo_trx.overflow    = F_if.overflow;
            fifo_trx.full        = F_if.full;
            fifo_trx.empty       = F_if.empty;
            fifo_trx.almostfull  = F_if.almostfull;
            fifo_trx.almostempty = F_if.almostempty;
            fifo_trx.underflow   = F_if.underflow;

            // Forking for parallel processes
            fork
                // Coverage sample process
                begin
                    fifo_cvr.sample_data(fifo_trx);
                end

                // Checking process
                begin
                    @(posedge F_if.clk); // Wait for a positive edge of the clock
                    #1; // Wait for one time unit
                    // Sampling outputs after posedge for checking against golden model
                    fifo_trx.data_out    = F_if.data_out;
                    fifo_trx.wr_ack      = F_if.wr_ack;
                    fifo_trx.overflow    = F_if.overflow;
                    fifo_trx.full        = F_if.full;
                    fifo_trx.empty       = F_if.empty;
                    fifo_trx.almostfull  = F_if.almostfull;
                    fifo_trx.almostempty = F_if.almostempty;
                    fifo_trx.underflow   = F_if.underflow;
                    check_data(fifo_trx); // Perform data checking
                end
            join

            // Check if the test has finished
            if (test_finished) begin
                $display("After test, Correct cases = %d ; Wrong cases = %d", correct_count, error_count);
                #1; // Wait for one time unit
                $stop; // Stop the simulation
            end
        end
    end
endmodule

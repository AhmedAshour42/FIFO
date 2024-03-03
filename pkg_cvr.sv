// Define a SystemVerilog package named pkg_cvr
package pkg_cvr;
    import pkg_transaction::*; // Import the transaction package

    // Define a SystemVerilog class named FIFO_coverage
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn; // Declare an instance of the FIFO_transaction class

        // Define a covergroup named cvr_gp
        covergroup cvr_gp ();
            // Define coverage crosses for various FIFO properties
            full_CVR         : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.full;
            almostfull_CVR   : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostfull;
            empty_CVR        : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.empty;
            almostempty_CVR  : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostempty;
            overflow_CVR     : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.overflow;
            underflow_CVR    : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.underflow;
            wr_ack_CVR       : cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.wr_ack;
        endgroup

        // Define the constructor function for the FIFO_coverage class
        function new();
            cvr_gp = new(); // Initialize the covergroup instance
        endfunction

        // Define a function to sample data for coverage
        function sample_data (FIFO_transaction F_txn);
            F_cvg_txn = F_txn; // Assign the input transaction to the class instance
            cvr_gp.sample();   // Sample coverage based on the assigned transaction
        endfunction

    endclass

endpackage

// Define a SystemVerilog package named pkg_FIFO_scoreboard
package pkg_FIFO_scoreboard;
    import pkg_transaction::*; // Import the transaction package

    // Declare variables to store reference values and count statistics
    bit full_ref, almostfull_ref, empty_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref;
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] ref_FIFO [$]; 
    int correct_count = 0;
    int error_count   = 0;
    bit test_finished;
    int count_ref=0;

    // Define a function to check data consistency between DUT and reference model
    function check_data (FIFO_transaction F_din);
        reference_model (F_din); // Call the reference model function to update reference values

        // Compare each signal of the DUT with the corresponding reference value
        if (F_din.data_out != data_out_ref) begin
            $display("%t : Error - data_out incorrect", $time());
            $display("expected : %h", data_out_ref);
            $display("output   : %h", F_din.data_out);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        // Repeat the comparison for other signals
        if (F_din.full != full_ref) begin
            $display("%t : Error - full incorrect", $time());
            $display("expected : %b", full_ref);
            $display("output   : %b", F_din.full);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.almostfull != almostfull_ref) begin
            $display("%t : Error - almostfull incorrect", $time());
            $display("expected : %b", almostfull_ref);
            $display("output   : %b", F_din.almostfull);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.empty != empty_ref) begin
            $display("%t : Error - empty incorrect", $time());
            $display("expected : %b", empty_ref);
            $display("output   : %b", F_din.empty);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.almostempty != almostempty_ref) begin
            $display("%t : Error - almostempty incorrect", $time());
            $display("expected : %b", almostempty_ref);
            $display("output   : %b", F_din.almostempty);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.overflow != overflow_ref) begin
            $display("%t : Error - overflow incorrect", $time());
            $display("expected : %b", overflow_ref);
            $display("output   : %b", F_din.overflow);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.underflow != underflow_ref) begin
            $display("%t : Error - underflow incorrect", $time());
            $display("expected : %b", underflow_ref);
            $display("output   : %b", F_din.underflow);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end

        if (F_din.wr_ack != wr_ack_ref) begin
            $display("%t : Error - wr_ack incorrect", $time());
            $display("expected : %b", wr_ack_ref);
            $display("output   : %b", F_din.wr_ack);
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
        
    endfunction

    // Define a function for the reference model
    function reference_model (FIFO_transaction F_inputs);
        if (!F_inputs.rst_n) begin
            ref_FIFO.delete();
            full_ref=0;
            almostfull_ref=0;
            empty_ref=1;
            almostempty_ref=0;
            overflow_ref=0;
            underflow_ref=0;
            wr_ack_ref=0;
        end
        else begin
            // Implement the reference model logic based on DUT input signals
            if (F_inputs.wr_en && F_inputs.rd_en) begin
                if (full_ref) begin
                    data_out_ref = ref_FIFO.pop_front();
                    overflow_ref = 1;
                    wr_ack_ref = 0;
                end
                else if (empty_ref) begin
                    ref_FIFO.push_back(F_inputs.data_in);
                    wr_ack_ref = 1;
                    underflow_ref = 1;
                end
                else begin
                    ref_FIFO.push_back(F_inputs.data_in);
                    wr_ack_ref = 1;
                    data_out_ref = ref_FIFO.pop_front();
                    underflow_ref = 0;
                    overflow_ref = 0;
                end
            end
            else begin
                if (F_inputs.wr_en) begin
                    if (!full_ref) begin
                        ref_FIFO.push_back(F_inputs.data_in);
                        wr_ack_ref = 1;
                        overflow_ref = 0;
                    end
                    else begin
                        wr_ack_ref = 0;
                        overflow_ref = 1;
                    end
                end
                else begin
                    wr_ack_ref = 0;
                    overflow_ref = 0;
                end
    
                if (F_inputs.rd_en) begin
                    if (!empty_ref) begin
                        data_out_ref = ref_FIFO.pop_front();
                        underflow_ref = 0;
                    end
                    else begin
                        underflow_ref = 1;
                    end
                end
                else begin
                    underflow_ref = 0;
                end
            end

            // Update the state based on the size of the reference FIFO
            if (ref_FIFO.size() == FIFO_DEPTH) begin
                full_ref = 1;
                almostfull_ref = 0;
                empty_ref = 0;
                almostempty_ref = 0;
            end
            else if (ref_FIFO.size() == (FIFO_DEPTH-1)) begin
                full_ref = 0;
                almostfull_ref = 1;
                empty_ref = 0;
                almostempty_ref = 0;
            end
            else if (ref_FIFO.size() == 1) begin
                full_ref = 0;
                almostfull_ref = 0;
                empty_ref = 0;
                almostempty_ref = 1;
            end
            else if (ref_FIFO.size() == 0) begin
                full_ref = 0;
                almostfull_ref = 0;
                empty_ref = 1;
                almostempty_ref = 0;
            end
            else begin
                full_ref = 0;
                almostfull_ref = 0;
                empty_ref = 0;
                almostempty_ref = 0;
            end
        end

        // Update the count_ref based on the size of the reference FIFO
        count_ref = ref_FIFO.size();
    endfunction

endpackage

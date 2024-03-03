// Define a SystemVerilog module named FIFO_top
module FIFO_top ();
    bit clk; // Declare a bit signal named 'clk'

    // Initialize the clock signal 'clk' with an initial value of 0
    initial begin
        clk = 0;

        // Create an infinite loop to toggle the clock signal every 2 time units
        forever
            #2 clk = ~clk; // Toggle the clock signal
    end

    // Instantiate an interface named F_if with the clock signal 'clk'
    FIFO_if F_if (clk);

    // Instantiate a FIFO module named DUT (Device Under Test) using the interface F_if
    FIFO DUT (F_if);

    // Instantiate a FIFO_tb (testbench) module using the interface F_if
    FIFO_tb TB (F_if);

    // Instantiate a FIFO_monitor module to monitor the interface signals
    FIFO_monitor Monitor (F_if);

endmodule

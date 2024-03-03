vlib work
vlog pkg_transaction.sv pkg_cvr.sv pkg_FIFO_scoreboard.sv FIFO_if.sv FIFO.sv FIFO_monitor.sv FIFO_tb.sv FIFO_top.sv  +cover
vsim -voptargs=+acc work.FIFO_top -cover
add wave -position insertpoint sim:/FIFO_top/F_if/*
add wave -position insertpoint  \
sim:/FIFO_top/DUT/count
add wave -position insertpoint  \
sim:/pkg_FIFO_scoreboard::wr_ack_ref \
sim:/pkg_FIFO_scoreboard::underflow_ref \
sim:/pkg_FIFO_scoreboard::overflow_ref \
sim:/pkg_FIFO_scoreboard::full_ref \
sim:/pkg_FIFO_scoreboard::error_count \
sim:/pkg_FIFO_scoreboard::empty_ref \
sim:/pkg_FIFO_scoreboard::data_out_ref \
sim:/pkg_FIFO_scoreboard::count_ref \
sim:/pkg_FIFO_scoreboard::correct_count \
sim:/pkg_FIFO_scoreboard::almostfull_ref \
sim:/pkg_FIFO_scoreboard::almostempty_ref
add wave /FIFO_top/DUT/Full /FIFO_top/DUT/empty /FIFO_top/DUT/almostfull /FIFO_top/DUT/almostempty /FIFO_top/DUT/wr_ack /FIFO_top/DUT/overflow /FIFO_top/DUT/underflow /FIFO_top/DUT/countup /FIFO_top/DUT/countdw
coverage save FIFO.ucdb -onexit
run -all
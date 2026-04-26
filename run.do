# Create working library
vlib work
vmap work work
# Compile design and testbench
vlog shift_register.v
vlog shift_register_tb.v
# Start simulation
vsim shift_register_tb
# Add all signals to waveform
add wave *
# Run simulation
run -all

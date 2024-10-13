onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/ena
add wave -noupdate -radix unsigned /tb/Y
add wave -noupdate -radix unsigned /tb/X
add wave -noupdate -radix unsigned /tb/ALUFN
add wave -noupdate -radix unsigned /tb/ALUout_o
add wave -noupdate /tb/flag_o
add wave -noupdate /tb/PWMout
add wave -noupdate /tb/L0/PWMM/PWM_mode
add wave -noupdate -radix unsigned /tb/L0/PWMM/counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {847898610 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {643424576 ps}

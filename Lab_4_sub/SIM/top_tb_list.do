onerror {resume}
add list -width 9 /tb/clk
add list /tb/rst
add list /tb/ena
add list /tb/Y
add list /tb/X
add list /tb/ALUFN
add list /tb/ALUout_o
add list /tb/flag_o
add list /tb/PWMout
add list /tb/L0/PWMM/PWM_mode
add list /tb/L0/PWMM/counter
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5

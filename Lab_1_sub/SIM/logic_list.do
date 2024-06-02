onerror {resume}
add list -width 15 /tb_logic/sel
add list /tb_logic/Y
add list /tb_logic/X
add list /tb_logic/RES
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5

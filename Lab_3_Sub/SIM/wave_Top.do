onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/ena
add wave -noupdate /top_tb/FSM_done
add wave -noupdate /top_tb/TBactive
add wave -noupdate -radix hexadecimal /top_tb/Unit_Top/DataPath_unit/Opcode
add wave -noupdate /top_tb/Unit_Top/DataPath_unit/Zflag
add wave -noupdate /top_tb/Unit_Top/DataPath_unit/Cflag
add wave -noupdate /top_tb/Unit_Top/DataPath_unit/Nflag
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(0)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(1)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(2)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(3)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(4)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(5)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(6)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(7)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(8)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(9)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(10)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(11)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(12)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(13)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(14)
add wave -noupdate -radix decimal /top_tb/Unit_Top/DataPath_unit/RF_Module/sysRF(15)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {8580702 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 306
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
WaveRestoreZoom {0 ps} {5519984 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/Unit_Datapath/clk
add wave -noupdate /datapath_tb/Unit_Datapath/mov
add wave -noupdate -radix hexadecimal /datapath_tb/Unit_Datapath/Opcode
add wave -noupdate -radix decimal /datapath_tb/Unit_Datapath/WR_RegAddr
add wave -noupdate -radix decimal /datapath_tb/Unit_Datapath/IR_imm
add wave -noupdate -radix decimal /datapath_tb/Unit_Datapath/W_RegData
add wave -noupdate -radix decimal /datapath_tb/Unit_Datapath/Immidiate
add wave -noupdate -radix decimal /datapath_tb/Unit_Datapath/BusData
add wave -noupdate /datapath_tb/Unit_Datapath/Mem_wr
add wave -noupdate /datapath_tb/Unit_Datapath/Mem_out
add wave -noupdate /datapath_tb/Unit_Datapath/Mem_in
add wave -noupdate /datapath_tb/Unit_Datapath/Cout
add wave -noupdate /datapath_tb/Unit_Datapath/Cin
add wave -noupdate /datapath_tb/Unit_Datapath/Ain
add wave -noupdate /datapath_tb/Unit_Datapath/RFin
add wave -noupdate /datapath_tb/Unit_Datapath/RFout
add wave -noupdate /datapath_tb/Unit_Datapath/IRin
add wave -noupdate /datapath_tb/Unit_Datapath/PCin
add wave -noupdate /datapath_tb/Unit_Datapath/Imm1_in
add wave -noupdate /datapath_tb/Unit_Datapath/Imm2_in
add wave -noupdate /datapath_tb/Unit_Datapath/OPC
add wave -noupdate /datapath_tb/Unit_Datapath/PCsel
add wave -noupdate /datapath_tb/Unit_Datapath/RFaddr
add wave -noupdate /datapath_tb/Unit_Datapath/rst
add wave -noupdate /datapath_tb/Unit_Datapath/add
add wave -noupdate /datapath_tb/Unit_Datapath/sub
add wave -noupdate /datapath_tb/Unit_Datapath/andd
add wave -noupdate /datapath_tb/Unit_Datapath/orr
add wave -noupdate /datapath_tb/Unit_Datapath/xorr
add wave -noupdate /datapath_tb/Unit_Datapath/jmp
add wave -noupdate /datapath_tb/Unit_Datapath/jc
add wave -noupdate /datapath_tb/Unit_Datapath/jnc
add wave -noupdate /datapath_tb/Unit_Datapath/ld
add wave -noupdate /datapath_tb/Unit_Datapath/st
add wave -noupdate /datapath_tb/Unit_Datapath/done
add wave -noupdate /datapath_tb/Unit_Datapath/Zflag
add wave -noupdate /datapath_tb/Unit_Datapath/Cflag
add wave -noupdate /datapath_tb/Unit_Datapath/Nflag
add wave -noupdate /datapath_tb/Unit_Datapath/A
add wave -noupdate /datapath_tb/Unit_Datapath/B
add wave -noupdate /datapath_tb/Unit_Datapath/CRegin
add wave -noupdate /datapath_tb/Unit_Datapath/CRegout
add wave -noupdate /datapath_tb/Unit_Datapath/RFData
add wave -noupdate /datapath_tb/Unit_Datapath/offset
add wave -noupdate /datapath_tb/Unit_Datapath/Pogram_Raddr
add wave -noupdate /datapath_tb/Unit_Datapath/Pogram_DataOut
add wave -noupdate /datapath_tb/Unit_Datapath/Datamem_readaddr
add wave -noupdate /datapath_tb/Unit_Datapath/Datamem_writeaddr
add wave -noupdate /datapath_tb/Unit_Datapath/BDatamem_readaddr
add wave -noupdate /datapath_tb/Unit_Datapath/BDatamem_writeaddr
add wave -noupdate /datapath_tb/Unit_Datapath/Datamem_datain
add wave -noupdate /datapath_tb/Unit_Datapath/Datamem_dataout
add wave -noupdate /datapath_tb/Unit_Datapath/Datamem_wren
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2050000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 296
configure wave -valuecolwidth 56
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
WaveRestoreZoom {1952831 ps} {3679820 ps}

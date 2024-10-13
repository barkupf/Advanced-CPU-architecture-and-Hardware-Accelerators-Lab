onerror {resume}
add list -width 35 /datapath_tb/Unit_Datapath/Mem_wr
add list /datapath_tb/Unit_Datapath/Mem_out
add list /datapath_tb/Unit_Datapath/Mem_in
add list /datapath_tb/Unit_Datapath/Cout
add list /datapath_tb/Unit_Datapath/Cin
add list /datapath_tb/Unit_Datapath/Ain
add list /datapath_tb/Unit_Datapath/RFin
add list /datapath_tb/Unit_Datapath/RFout
add list /datapath_tb/Unit_Datapath/IRin
add list /datapath_tb/Unit_Datapath/PCin
add list /datapath_tb/Unit_Datapath/Imm1_in
add list /datapath_tb/Unit_Datapath/Imm2_in
add list /datapath_tb/Unit_Datapath/OPC
add list /datapath_tb/Unit_Datapath/PCsel
add list /datapath_tb/Unit_Datapath/RFaddr
add list /datapath_tb/Unit_Datapath/clk
add list /datapath_tb/Unit_Datapath/rst
add list /datapath_tb/Unit_Datapath/sub
add list /datapath_tb/Unit_Datapath/andd
add list /datapath_tb/Unit_Datapath/orr
add list /datapath_tb/Unit_Datapath/xorr
add list /datapath_tb/Unit_Datapath/jmp
add list /datapath_tb/Unit_Datapath/jc
add list /datapath_tb/Unit_Datapath/jnc
add list /datapath_tb/Unit_Datapath/mov
add list /datapath_tb/Unit_Datapath/ld
add list /datapath_tb/Unit_Datapath/st
add list /datapath_tb/Unit_Datapath/done
add list /datapath_tb/Unit_Datapath/Zflag
add list /datapath_tb/Unit_Datapath/Cflag
add list /datapath_tb/Unit_Datapath/Nflag
add list /datapath_tb/Unit_Datapath/A
add list /datapath_tb/Unit_Datapath/B
add list /datapath_tb/Unit_Datapath/CRegin
add list /datapath_tb/Unit_Datapath/CRegout
add list /datapath_tb/Unit_Datapath/WR_RegAddr
add list /datapath_tb/Unit_Datapath/W_RegData
add list /datapath_tb/Unit_Datapath/RFData
add list /datapath_tb/Unit_Datapath/Opcode
add list /datapath_tb/Unit_Datapath/offset
add list /datapath_tb/Unit_Datapath/IR_imm
add list /datapath_tb/Unit_Datapath/Pogram_Raddr
add list /datapath_tb/Unit_Datapath/Pogram_DataOut
add list /datapath_tb/Unit_Datapath/Datamem_readaddr
add list /datapath_tb/Unit_Datapath/Datamem_writeaddr
add list /datapath_tb/Unit_Datapath/BDatamem_readaddr
add list /datapath_tb/Unit_Datapath/BDatamem_writeaddr
add list /datapath_tb/Unit_Datapath/Datamem_datain
add list /datapath_tb/Unit_Datapath/Datamem_dataout
add list /datapath_tb/Unit_Datapath/Datamem_wren
add list /datapath_tb/Unit_Datapath/BusData
add list /datapath_tb/Unit_Datapath/Immidiate
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5

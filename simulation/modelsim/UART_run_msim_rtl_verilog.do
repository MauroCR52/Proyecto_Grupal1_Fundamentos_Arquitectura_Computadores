transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/multiplicador_circular.sv}
vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/restador_circular.sv}
vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/and_circular_structural.sv}
vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/xor_circular_flags.sv}
vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/alu_controladora.sv}

vlog -sv -work work +incdir+C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores {C:/Users/XPC/Desktop/Funda/Proyecto_Grupal1_Fundamentos_Arquitectura_Computadores/alu_controladora_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  alu_controladora_tb

add wave *
view structure
view signals
run -all

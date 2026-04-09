v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -190 80 -190 100 {lab=GND}
N -190 0 -190 20 {lab=IN}
N -190 0 -60 -0 {lab=IN}
N 20 60 20 80 {lab=GND}
N 20 -120 20 -60 {lab=Vdd}
N 160 0 260 -0 {lab=OUT}
N -180 -180 -180 -160 {lab=GND}
N -180 -300 -180 -240 {lab=Vdd}
C {inverter.sym} 80 0 0 0 {name=x1}
C {vsource.sym} -190 50 0 0 {name=V1 value=0.9 savecurrent=false}
C {gnd.sym} -190 100 0 0 {name=l1 lab=GND}
C {gnd.sym} 20 80 0 0 {name=l2 lab=GND}
C {vsource.sym} -180 -210 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} -180 -160 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -180 -290 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 20 -120 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} -130 0 0 0 {name=p3 sig_type=std_logic lab=IN}
C {lab_wire.sym} 260 0 0 0 {name=p4 sig_type=std_logic lab=OUT}
C {devices/code.sym} -370 -270 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -580 20 0 0 {name=commands 
only_toplevel=false 
value="
.include tb_op.save
.options savecurrents

.control
  save all
  op
  remzerovec
  write tb_op.raw
.endc
"}
C {devices/launcher.sym} -130 230 0 0 {name=h5
descr="Generate .save lines" 
tclcommand="write_data [save_fet_params] $netlist_dir/[file rootname [file tail [xschem get current_name]]].save
textwindow $netlist_dir/[file rootname [file tail [xschem get current_name]]].save
"
}
C {devices/launcher.sym} -130 280 0 0 {name=h1
descr="Annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}

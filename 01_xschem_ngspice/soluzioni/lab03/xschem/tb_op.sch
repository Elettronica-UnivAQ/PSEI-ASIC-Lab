v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -260 -200 -260 -180 {lab=GND}
N -260 -310 -260 -260 {lab=vdd}
N -130 -200 -130 -180 {lab=GND}
N -130 -310 -130 -260 {lab=clk}
N 10 -200 10 -180 {lab=GND}
N 100 -200 100 -180 {lab=GND}
N 10 -310 10 -260 {lab=vin_p}
N 100 -310 100 -260 {lab=vin_n}
N 220 100 220 120 {lab=GND}
N 280 100 280 120 {lab=GND}
N 170 -20 360 -20 {lab=#net1}
N 170 20 360 20 {lab=#net2}
N 220 20 220 40 {lab=#net2}
N 280 -20 280 40 {lab=#net1}
N 30 70 30 90 {lab=GND}
N 30 -110 30 -70 {lab=vdd}
N -120 -20 -50 -20 {lab=vin_p}
N -120 20 -50 20 {lab=vin_n}
N -120 50 -50 50 {lab=clk}
C {vsource.sym} -260 -230 0 0 {name=VVDD value=1.8 savecurrent=false}
C {gnd.sym} -260 -180 0 0 {name=l1 lab=GND}
C {gnd.sym} 30 90 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -260 -310 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {vsource.sym} -130 -230 0 0 {name=VCLK value=0 savecurrent=false}
C {gnd.sym} -130 -180 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -130 -310 0 0 {name=p3 sig_type=std_logic lab=clk}
C {vsource.sym} 10 -230 0 0 {name=VVIN_P value=0.9 savecurrent=false}
C {gnd.sym} 10 -180 0 0 {name=l5 lab=GND}
C {vsource.sym} 100 -230 0 0 {name=VVIN_N value=0.9 savecurrent=false}
C {gnd.sym} 100 -180 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 10 -310 0 0 {name=p7 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 100 -310 0 0 {name=p9 sig_type=std_logic lab=vin_n}
C {capa.sym} 220 70 0 0 {name=C1
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 280 70 0 0 {name=C2
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 220 120 0 0 {name=l7 lab=GND}
C {gnd.sym} 280 120 0 0 {name=l8 lab=GND}
C {devices/launcher.sym} -250 230 0 0 {name=h5
descr="Generate .save lines" 
tclcommand="write_data [save_fet_params] $netlist_dir/[file rootname [file tail [xschem get current_name]]].save
textwindow $netlist_dir/[file rootname [file tail [xschem get current_name]]].save
"
}
C {devices/code.sym} -530 -280 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -700 -50 0 0 {name=commands 
only_toplevel=false 
value=".include tb_op.save
.options savecurrents

.control
  save all
  op
  remzerovec
  write tb_op.raw
.endc"}
C {strongarm.sym} 100 0 0 0 {name=x1}
C {lab_wire.sym} -120 20 0 0 {name=p2 sig_type=std_logic lab=vin_n}
C {lab_wire.sym} -120 -20 0 0 {name=p4 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} -120 50 0 0 {name=p5 sig_type=std_logic lab=clk}
C {lab_wire.sym} 30 -110 0 0 {name=p6 sig_type=std_logic lab=vdd}

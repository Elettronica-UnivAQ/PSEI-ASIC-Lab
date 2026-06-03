v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 140 -850 940 -420 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="out
vctrl"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
}
N -90 30 -90 70 {lab=GND}
N -90 30 -70 30 {lab=GND}
N -290 -190 -290 -170 {lab=GND}
N -210 -190 -210 -170 {lab=GND}
N -210 -300 -210 -250 {lab=Vref}
N -290 -300 -290 -250 {lab=vdd}
N -150 -40 -70 -40 {lab=Vref}
N 50 -120 50 -60 {lab=vdd}
N 30 -120 30 -60 {lab=Vctrl}
N -130 -190 -130 -170 {lab=GND}
N -130 -300 -130 -250 {lab=Vctrl}
N 90 0 160 0 {lab=out}
N 120 0 120 10 {lab=out}
N 120 70 120 80 {lab=GND}
N 160 -0 230 0 {lab=out}
N 190 0 190 20 {lab=out}
C {T_gate.sym} 30 0 0 0 {name=x1}
C {gnd.sym} -90 70 0 0 {name=l1 lab=GND}
C {vsource.sym} -290 -220 0 0 {name=Vvdd value=1.8 savecurrent=false}
C {vsource.sym} -210 -220 0 0 {name=Vvref value=0.256 savecurrent=false}
C {gnd.sym} -290 -170 0 0 {name=l2 lab=GND}
C {gnd.sym} -210 -170 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -290 -300 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 50 -120 0 1 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -210 -300 0 0 {name=p3 sig_type=std_logic lab=Vref}
C {lab_wire.sym} -150 -40 0 0 {name=p4 sig_type=std_logic lab=Vref}
C {devices/code.sym} -460 -30 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {vsource.sym} -130 -220 0 0 {name=Vctrl value="PULSE(0 1.8 100n 1n 1n 50n 100n)" savecurrent=false}
C {gnd.sym} -130 -170 0 0 {name=l4 lab=GND}
C {lab_wire.sym} -130 -300 0 0 {name=p5 sig_type=std_logic lab=Vctrl}
C {lab_wire.sym} 30 -120 0 0 {name=p6 sig_type=std_logic lab=Vctrl}
C {lab_wire.sym} 230 0 0 0 {name=p7 sig_type=std_logic lab=out}
C {capa.sym} 120 40 0 0 {name=C1
m=1
value=6.4p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 120 80 0 0 {name=l5 lab=GND}
C {res.sym} 190 50 0 0 {name=R1
value=1G
footprint=1206
device=resistor
m=1}
C {gnd.sym} 190 80 0 0 {name=l6 lab=GND}
C {code_shown.sym} -740 -210 0 0 {name=commands
only_toplevel=false 
value=
"
.option savecurrents
.control
  save all
  tran 10p 200n
  write tb_T_gate.raw v(out) v(Vctrl)
  plot v(out) v(Vctrl)
.endc
"}
C {launcher.sym} 200 -370 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_T_gate.raw tran"
}

v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 170 -810 970 -410 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vin
vout
ctrl"
color="4 7 12"
dataset=-1
unitx=1
logx=0
logy=0
}
N -300 -120 -300 -100 {lab=GND}
N -50 40 -50 60 {lab=GND}
N -300 -220 -300 -180 {lab=vdd}
N -50 -70 -50 -40 {lab=vdd}
N -190 140 -190 170 {lab=GND}
N -190 0 -190 80 {lab=Vin}
N -190 0 -50 0 {lab=Vin}
N 10 230 10 260 {lab=GND}
N 10 40 10 170 {lab=ctrl}
N 10 -140 10 -60 {lab=ctrl_not}
N 10 -230 10 -200 {lab=GND}
N 70 0 200 0 {lab=Vout}
N 200 80 200 100 {lab=GND}
N 200 0 200 20 {lab=Vout}
N 300 0 300 30 {lab=Vout}
N 200 0 300 -0 {lab=Vout}
N 300 90 300 100 {lab=GND}
C {vsource.sym} -300 -150 0 0 {name=Vvdd value=1.8 savecurrent=false}
C {gnd.sym} -300 -100 0 0 {name=l1 lab=GND}
C {passgate.sym} 10 0 0 0 {name=x1}
C {gnd.sym} -50 60 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -300 -220 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -50 -70 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -190 110 0 0 {name=Vvin value="PWL(0 0.9 500n 1.8 500n 0.9 1000n 0)" savecurrent=false}
C {gnd.sym} -190 170 0 0 {name=l3 lab=GND}
C {vsource.sym} 10 200 0 0 {name=Vctrl value="PULSE(0 1.8 100n 1n 1n 200n 400n)" savecurrent=false}
C {gnd.sym} 10 260 0 0 {name=l4 lab=GND}
C {vsource.sym} 10 -170 2 0 {name=Vctrl_not value="PULSE(1.8 0 100n 1n 1n 200n 400n)" savecurrent=false}
C {gnd.sym} 10 -230 2 0 {name=l5 lab=GND}
C {lab_wire.sym} -160 0 0 0 {name=p3 sig_type=std_logic lab=Vin}
C {lab_wire.sym} 10 110 0 0 {name=p4 sig_type=std_logic lab=ctrl}
C {lab_wire.sym} 10 -100 0 0 {name=p5 sig_type=std_logic lab=ctrl_not}
C {capa.sym} 200 50 0 0 {name=C1
m=1
value=12.8p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 200 100 0 0 {name=l6 lab=GND}
C {res.sym} 300 60 0 0 {name=R1
value=1G
footprint=1206
device=resistor
m=1}
C {gnd.sym} 300 100 0 0 {name=l7 lab=GND}
C {lab_wire.sym} 270 0 0 1 {name=p6 sig_type=std_logic lab=Vout}
C {code_shown.sym} -680 -40 0 0 {name=commands 
only_toplevel=false 
value="
.control
  save all
  tran 100p 1000n
  write tb_passgate.raw
  plot v(Vin) v(Vout) v(CTRL)
.endc
"}
C {devices/code.sym} -590 160 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/launcher.sym} 230 -330 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}

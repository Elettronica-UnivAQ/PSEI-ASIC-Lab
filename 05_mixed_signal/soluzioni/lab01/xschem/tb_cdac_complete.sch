v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 470 -550 1270 -150 {flags=graph
y1=0.96
y2=1.2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-3e-08
x2=2.7e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vin
vout"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 470 -980 1270 -580 {flags=graph
y1=0
y2=1.8
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=-3e-08
x2=2.7e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color="4 4"
node="ctrl7
phi"
digital=1}
N -40 60 -40 80 {lab=GND}
N -180 -260 -180 -240 {lab=GND}
N -180 -360 -180 -320 {lab=vdd}
N -40 -150 -40 -100 {lab=vdd}
N -190 80 -190 100 {lab=GND}
N -190 -20 -190 20 {lab=vin}
N -190 -20 -110 -20 {lab=vin}
N 190 -20 330 -20 {lab=vout}
N -90 -260 -90 -240 {lab=GND}
N -90 -360 -90 -320 {lab=phi}
N 130 -260 130 -240 {lab=GND}
N 130 -360 130 -320 {lab=phi_not}
N 40 -150 40 -100 {lab=phi}
N 60 -150 60 -100 {lab=phi_not}
N -270 -260 -270 -240 {lab=GND}
N -270 -360 -270 -320 {lab=vref}
N -20 -150 -20 -100 {lab=vref}
N 10 200 10 230 {lab=GND}
N 10 60 10 140 {lab=ctrl7}
N 30 60 30 100 {lab=#net1}
N 50 60 50 100 {lab=#net1}
N 70 60 70 100 {lab=#net1}
N 90 60 90 100 {lab=#net1}
N 110 60 110 100 {lab=#net1}
N 130 60 130 100 {lab=#net1}
N 150 60 150 100 {lab=#net1}
N 290 60 290 80 {lab=GND}
N 290 -20 290 -0 {lab=vout}
N 30 100 30 120 {lab=#net1}
N 30 120 310 120 {lab=#net1}
N 310 120 310 160 {lab=#net1}
N 50 100 50 120 {lab=#net1}
N 70 100 70 120 {lab=#net1}
N 90 100 90 120 {lab=#net1}
N 110 100 110 120 {lab=#net1}
N 130 100 130 120 {lab=#net1}
N 150 100 150 120 {lab=#net1}
N 310 220 310 230 {lab=GND}
C {gnd.sym} -40 80 0 0 {name=l1 lab=GND}
C {vsource.sym} -180 -290 0 0 {name=Vvdd value=1.8 savecurrent=false}
C {lab_wire.sym} -180 -360 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -40 -150 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -190 50 0 0 {name=Vvdd1 value=0.972 savecurrent=false}
C {gnd.sym} -180 -240 0 0 {name=l3 lab=GND}
C {gnd.sym} -190 100 0 0 {name=l4 lab=GND}
C {lab_wire.sym} -160 -20 0 0 {name=p3 sig_type=std_logic lab=vin}
C {lab_wire.sym} 310 -20 0 0 {name=p4 sig_type=std_logic lab=vout}
C {vsource.sym} -90 -290 0 0 {name=Vphi value="PULSE(1.8 0 0 1n 1n 49n 100n)" savecurrent=false}
C {gnd.sym} -90 -240 0 0 {name=l5 lab=GND}
C {vsource.sym} 130 -290 0 0 {name=Vphi_not value="PULSE(0 1.8 0 1n 1n 49n 100n)" savecurrent=false}
C {gnd.sym} 130 -240 0 0 {name=l6 lab=GND}
C {lab_wire.sym} -90 -360 0 0 {name=p5 sig_type=std_logic lab=phi}
C {lab_wire.sym} 40 -150 0 0 {name=p6 sig_type=std_logic lab=phi}
C {lab_wire.sym} 130 -360 0 1 {name=p7 sig_type=std_logic lab=phi_not}
C {lab_wire.sym} 60 -150 0 1 {name=p8 sig_type=std_logic lab=phi_not}
C {devices/code.sym} -500 -200 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {vsource.sym} -270 -290 0 0 {name=Vvref value=\{vref\} savecurrent=false}
C {gnd.sym} -270 -240 0 0 {name=l7 lab=GND}
C {lab_wire.sym} -270 -360 0 0 {name=p9 sig_type=std_logic lab=vref}
C {lab_wire.sym} -20 -150 0 1 {name=p10 sig_type=std_logic lab=vref}
C {vsource.sym} 10 170 0 0 {name=VBP7 value="pwl 0 0 100n 0 101n 1.8 148n 1.8 149n 0 300n 0" savecurrent=false}
C {gnd.sym} 10 230 0 0 {name=l10 lab=GND}
C {code_shown.sym} -610 80 0 0 {name=s1 
only_toplevel=false 
value="
.param vref = 0.256
.ic v(vin) = 0

.control
  save all
  tran 10p 300n
  write tb_cdac_complete.raw
  plot v(VOUT) v(VIN) v(phi) v(ctrl7)
.endc
"}
C {cdac_complete.sym} 40 -10 0 0 {name=x1}
C {vsource.sym} 310 190 0 0 {name=VBP60 value=0 savecurrent=false}
C {gnd.sym} 310 230 0 0 {name=l2 lab=GND}
C {res.sym} 290 30 0 0 {name=R1
value=1G
footprint=1206
device=resistor
m=1}
C {gnd.sym} 290 80 0 0 {name=l8 lab=GND}
C {lab_wire.sym} 10 120 0 0 {name=p11 sig_type=std_logic lab=ctrl7}
C {launcher.sym} 540 -80 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_cdac_complete.raw tran"
}

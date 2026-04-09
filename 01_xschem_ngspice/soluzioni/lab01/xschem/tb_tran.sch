v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 270 -460 1070 -60 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="in
out"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
}
N -270 80 -270 100 {lab=GND}
N -270 0 -270 20 {lab=IN}
N -270 0 -50 0 {lab=IN}
N 170 -0 240 -0 {lab=OUT}
N 30 -120 30 -60 {lab=Vdd}
N 30 60 30 80 {lab=GND}
N -130 -170 -130 -150 {lab=GND}
N -130 -300 -130 -230 {lab=Vdd}
C {inverter.sym} 90 0 0 0 {name=x1}
C {vsource.sym} -270 50 0 0 {name=Vin value="PULSE(0 1.8 0 100p 100p 4n 8n)" savecurrent=false}
C {vsource.sym} -130 -200 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} -270 100 0 0 {name=l1 lab=GND}
C {gnd.sym} 30 80 0 0 {name=l2 lab=GND}
C {gnd.sym} -130 -150 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -130 -290 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 30 -120 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} -160 0 0 0 {name=p3 sig_type=std_logic lab=IN}
C {lab_wire.sym} 240 0 0 0 {name=p4 sig_type=std_logic lab=OUT}
C {devices/launcher.sym} 470 -10 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}
C {devices/code.sym} -320 -260 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -1000 -90 0 0 {name=commands 
only_toplevel=false 
value="
.save all

.control
  tran 10p 20n

  * tpHL: ritardo da IN che sale (50%) a OUT che scende (50%)
  meas tran tpHL TRIG v(IN) VAL=0.9 RISE=1 TARG v(OUT) VAL=0.9 FALL=1

  * tpLH: ritardo da IN che scende (50%) a OUT che sale (50%)
  meas tran tpLH TRIG v(IN) VAL=0.9 FALL=1 TARG v(OUT) VAL=0.9 RISE=1

  write tb_tran.raw
.endc
"}

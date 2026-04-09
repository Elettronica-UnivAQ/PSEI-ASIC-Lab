v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 290 -560 1090 -160 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1.8
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
rawfile=$netlist_dir/tb_dc.raw}
N -180 80 -180 100 {lab=GND}
N -180 0 -180 20 {lab=IN}
N -180 0 -70 0 {lab=IN}
N -200 -300 -200 -250 {lab=Vdd}
N 10 -120 10 -60 {lab=Vdd}
N 10 60 10 120 {lab=GND}
N 150 -0 220 -0 {lab=OUT}
C {inverter.sym} 70 0 0 0 {name=x1}
C {vsource.sym} -180 50 0 0 {name=Vin value=1.8 savecurrent=false}
C {gnd.sym} -180 100 0 0 {name=l1 lab=GND}
C {vsource.sym} -200 -220 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} -200 -190 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -200 -300 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 10 -120 0 0 {name=p2 sig_type=std_logic lab=Vdd}
C {gnd.sym} 10 120 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -120 0 0 0 {name=p3 sig_type=std_logic lab=IN}
C {lab_wire.sym} 220 0 0 0 {name=p4 sig_type=std_logic lab=OUT}
C {devices/code.sym} -390 -290 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -450 -90 0 0 {name=commands
simulator=ngspice 
only_toplevel=false 
value="
.save all

.control
  dc Vin 0 1.8 0.005
  write tb_dc.raw
.endc
"}
C {devices/launcher.sym} 350 -110 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw dc
"
}

v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 70 -670 870 -270 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=9.9549978e-09
x2=1.0403747e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="in
out
out_post"
color="4 5 12"
dataset=-1
unitx=1
logx=0
logy=0
}
N -40 70 -40 100 {lab=GND}
N -280 -170 -280 -150 {lab=GND}
N -280 -280 -280 -230 {lab=vdd}
N -40 -130 -40 -70 {lab=vdd}
N -300 100 -300 130 {lab=GND}
N -300 0 -300 40 {lab=in}
N -300 0 -90 0 {lab=in}
N 130 0 240 0 {lab=out}
N 180 0 180 40 {lab=out}
N 180 100 180 130 {lab=GND}
N -180 360 -90 360 {lab=in}
N -180 0 -180 360 {lab=in}
N 130 360 240 360 {lab=out_post}
N 180 460 180 490 {lab=GND}
N 180 360 180 400 {lab=out_post}
N 180 100 180 130 {lab=GND}
N -40 430 -40 470 {lab=GND}
N -40 210 -40 290 {lab=vdd}
C {gnd.sym} -40 100 0 0 {name=l1 lab=GND}
C {vsource.sym} -280 -200 0 0 {name=V1 value=1.8 savecurrent=false}
C {gnd.sym} -280 -150 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -280 -280 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -40 -130 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -300 70 0 0 {name=V2 value="PULSE(0 1.8 0 100p 100p 4.9n 10n)" savecurrent=false}
C {gnd.sym} -300 130 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -230 0 0 0 {name=p3 sig_type=std_logic lab=in}
C {lab_wire.sym} 240 0 0 0 {name=p4 sig_type=std_logic lab=out}
C {sky130_fd_pr/corner.sym} -540 -230 0 0 {name=CORNER only_toplevel=true corner=tt}
C {code_shown.sym} -1200 20 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents

.control
  save all
  tran 10p 40n

  meas tran tpLH_pre  TRIG v(IN) VAL=0.9 RISE=1 TARG v(out)      VAL=0.9 RISE=1
  meas tran tpHL_pre  TRIG v(IN) VAL=0.9 FALL=1 TARG v(out)      VAL=0.9 FALL=1
  meas tran tpLH_post TRIG v(IN) VAL=0.9 RISE=1 TARG v(out_post) VAL=0.9 RISE=1
  meas tran tpHL_post TRIG v(IN) VAL=0.9 FALL=1 TARG v(out_post) VAL=0.9 FALL=1
  
  write tb_postlayout.raw


.endc"}
C {devices/launcher.sym} 130 -210 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}
C {modulo3/lab02/xschem/buffer.sym} 30 360 0 0 {name=x2
schematic=buffer_parax
spice_sym_def="tcleval(.include [file normalize ../mag/buffer.sim.spice])"}
C {capa.sym} 180 430 0 0 {name=C2
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 180 490 0 0 {name=l5 lab=GND}
C {lab_wire.sym} 240 360 0 0 {name=p5 sig_type=std_logic lab=out_post}
C {capa.sym} 180 70 0 0 {name=C3
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 180 130 0 0 {name=l6 lab=GND}
C {gnd.sym} -40 470 0 0 {name=l7 lab=GND}
C {lab_wire.sym} -40 220 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {modulo3/lab03/xschem/buffer.sym} 30 0 0 0 {name=x3}

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
x1=9.4654309e-09
x2=1.1527015e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="in
out
x1.out1"
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
C {modulo3/lab02/xschem/buffer.sym} 30 0 0 0 {name=x1}
C {gnd.sym} -40 100 0 0 {name=l1 lab=GND}
C {vsource.sym} -280 -200 0 0 {name=V1 value=1.8 savecurrent=false}
C {gnd.sym} -280 -150 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -280 -280 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -40 -130 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -300 70 0 0 {name=V2 value="PULSE(0 1.8 0 100p 100p 4.9n 10n)" savecurrent=false}
C {gnd.sym} -300 130 0 0 {name=l3 lab=GND}
C {capa.sym} 180 70 0 0 {name=C1
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 180 130 0 0 {name=l4 lab=GND}
C {lab_wire.sym} -230 0 0 0 {name=p3 sig_type=std_logic lab=in}
C {lab_wire.sym} 240 0 0 0 {name=p4 sig_type=std_logic lab=out}
C {sky130_fd_pr/corner.sym} -540 -230 0 0 {name=CORNER only_toplevel=true corner=tt}
C {code_shown.sym} -1040 20 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents

.control
  save all
  tran 10p 30n

  * trise: ritardo da IN che sale (50%) a OUT che sale (50%)
  meas tran trise TRIG v(IN) VAL=0.9 RISE=1 TARG v(OUT) VAL=0.9 RISE=1

  * tfall: ritardo da IN che scende (50%) a OUT che scende (50%)
  meas tran tfall TRIG v(IN) VAL=0.9 FALL=1 TARG v(OUT) VAL=0.9 FALL=1
  
  write tb_buffer.raw


.endc"}
C {devices/launcher.sym} 130 -210 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}

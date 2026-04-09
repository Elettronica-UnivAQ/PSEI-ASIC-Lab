v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 530 -530 1330 -130 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.4720692e-08
x2=2.7816916e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="out_p
out_n
clk"
color="4 7 12"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 530 -970 1330 -570 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.4720692e-08
x2=2.7816916e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="x1.sp
x1.sn"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 530 -1390 1330 -990 {flags=graph
y1=2.7e-17
y2=0.00074
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.4720692e-08
x2=2.7816916e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="\\"i(M2); i(@m.x1.xm2.msky130_fd_pr__nfet_01v8[id])\\"
\\"i(M1); i(@m.x1.xm1.msky130_fd_pr__nfet_01v8[id])\\"
\\"i(M5)_tail; i(@m.x1.xm5.msky130_fd_pr__nfet_01v8[id])\\""
color="4 5 12"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1470 -960 2390 -130 {flags=graph,unlocked
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=8.2718061e-25
x2=1.1e-07
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clk
out_p
out_n"
color="12 4 4"
dataset=-1
unitx=1
logx=0
logy=0
digital=1
linewidth_mult=2}
N -140 -210 -140 -190 {lab=GND}
N -140 -320 -140 -270 {lab=vdd}
N -0 80 0 100 {lab=GND}
N 0 -120 0 -60 {lab=vdd}
N -20 -210 -20 -190 {lab=GND}
N -20 -320 -20 -270 {lab=clk}
N 240 -210 240 -190 {lab=GND}
N 330 -210 330 -190 {lab=GND}
N 240 -320 240 -270 {lab=vin_p}
N 330 -320 330 -270 {lab=vin_n}
N 140 -10 320 -10 {lab=out_p}
N 140 30 320 30 {lab=out_n}
N 210 30 210 70 {lab=out_n}
N 280 -10 280 70 {lab=out_p}
N 210 130 210 160 {lab=GND}
N 280 130 280 160 {lab=GND}
N -150 60 -80 60 {lab=clk}
N -150 30 -80 30 {lab=vin_n}
N -150 -10 -80 -10 {lab=vin_p}
C {strongarm.sym} 70 10 0 0 {name=x1}
C {devices/code.sym} -360 -230 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {vsource.sym} -140 -240 0 0 {name=VVDD value=1.8 savecurrent=false}
C {gnd.sym} -140 -190 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -140 -320 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {gnd.sym} 0 100 0 0 {name=l2 lab=GND}
C {lab_wire.sym} 0 -120 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -20 -240 0 0 {name=VCLK value="PULSE(0 1.8 25n 100p 100p 25n 50n)" savecurrent=false}
C {gnd.sym} -20 -190 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -20 -320 0 0 {name=p3 sig_type=std_logic lab=clk}
C {lab_wire.sym} -150 60 0 0 {name=p4 sig_type=std_logic lab=clk}
C {vsource.sym} 240 -240 0 0 {name=VVIN_P value=0.905 savecurrent=false}
C {gnd.sym} 240 -190 0 0 {name=l5 lab=GND}
C {vsource.sym} 330 -240 0 0 {name=VVIN_N value=0.895 savecurrent=false}
C {gnd.sym} 330 -190 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 240 -320 0 0 {name=p7 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 330 -320 0 0 {name=p9 sig_type=std_logic lab=vin_n}
C {lab_wire.sym} -150 -10 0 0 {name=p5 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} -150 30 0 0 {name=p6 sig_type=std_logic lab=vin_n}
C {capa.sym} 210 100 0 0 {name=C1
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 280 100 0 0 {name=C2
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 210 160 0 0 {name=l4 lab=GND}
C {gnd.sym} 280 160 0 0 {name=l7 lab=GND}
C {lab_wire.sym} 320 -10 0 0 {name=p8 sig_type=std_logic lab=out_p}
C {lab_wire.sym} 320 30 0 0 {name=p10 sig_type=std_logic lab=out_n}
C {code_shown.sym} -700 110 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents

.control
  save all
  tran 10p 110n

  meas tran t_clk_rise  WHEN v(clk)=0.9    RISE=1
  meas tran t_out_fall  WHEN v(out_p)=0.9  FALL=1
  let t_decision = t_out_fall - t_clk_rise
  let t_dec_ns = t_decision * 1e9
  echo Tempo di decisione (nominale TT 27C 1.8V) = $&t_dec_ns ns

  write tb_tran.raw

  plot v(clk)+2 v(out_p) v(out_n)
  plot v(x1.sp) v(x1.sn)
.endc"}
C {devices/launcher.sym} 590 -50 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}

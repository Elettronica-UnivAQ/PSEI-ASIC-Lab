v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 180 -780 980 -380 {flags=graph
y1=-0.00029
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
hcursor1_y=0.8995
hilight_wave=-1
rainbow=1}
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
C {vsource.sym} -300 -150 0 0 {name=Vvdd value=\{vdd_param\} savecurrent=false}
C {gnd.sym} -300 -100 0 0 {name=l1 lab=GND}
C {passgate.sym} 10 0 0 0 {name=x1}
C {gnd.sym} -50 60 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -300 -220 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_wire.sym} -50 -70 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {vsource.sym} -190 110 0 0 {name=Vvin value="PULSE(0 0.9 100n 1n 1n 800n 1000n)" savecurrent=false}
C {gnd.sym} -190 170 0 0 {name=l3 lab=GND}
C {vsource.sym} 10 200 0 0 {name=Vctrl value="PULSE(0 \{vdd_param\} 50n 1n 1n 900n 1000n)" savecurrent=false}
C {gnd.sym} 10 260 0 0 {name=l4 lab=GND}
C {vsource.sym} 10 -170 2 0 {name=Vctrl_not value="PULSE(\{vdd_param\} 0 50n 1n 1n 900n 1000n)" savecurrent=false}
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
C {code_shown.sym} -1030 -140 0 0 {name=commands 
only_toplevel=false 
value="
.param vdd_param=1.8
.options savecurrents

.control
  save all
  set appendwrite
  shell rm -f tb_passgate_pvt.raw
  set outfile = pvt_passgate_tt.txt
  echo T_C,VDD_V,t_settle_ns > $outfile

  foreach T_val -40 27 125
    foreach VDD_val 1.62 1.8 1.98
      set t_save   = $T_val
      set vdd_save = $VDD_val
      alterparam vdd_param = $vdd_save
      reset
      set temp = $t_save

      tran 100p 1000n
      meas tran t_settle WHEN v(Vout) = 0.8995 RISE=1 TD=110n
      let t_settle_ns = (t_settle - 100e-9) * 1e9
      echo $t_save,$vdd_save,$&t_settle_ns >> $outfile
      echo T=$t_save VDD=$vdd_save t_settle=$&t_settle_ns ns
      write tb_passgate_pvt.raw v(Vout) v(Vin) v(ctrl) v(ctrl_not)
    end
  end
.endc
"
}
C {sky130_fd_pr/corner.sym} -520 10 0 0 {name=CORNER only_toplevel=true corner=tt}
C {launcher.sym} 260 -340 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/tb_passgate_pvt.raw tran"
}

v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 630 -520 1430 -120 {flags=graph
y1=-0.056
y2=2.1
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.4533818e-08
x2=2.7010798e-08
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
rawfile=$netlist_dir/tb_pvt.raw
sim_type=tran
autoload=1}
B 2 630 0 1430 400 {flags=graph
y1=-1.8e-08
y2=2.1
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.4533818e-08
x2=2.7010798e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="\\"out_p @1.62V - -40°C; v(out_p)%0\\"
\\"out_p @1.8V - -40°C; v(out_p)%1\\"
\\"out_p @1.98V - -40°C; v(out_p)%2\\"
\\"out_p @1.62V - 27°C; v(out_p)%3\\"
\\"out_p @1.8V - 27°C; v(out_p)%4\\"
\\"out_p @1.98V - 27°C; v(out_p)%5\\"
\\"out_p @1.62V - 125°C; v(out_p)%6\\"
\\"out_p @1.8V - 125°C; v(out_p)%7\\"
\\"out_p @1.98V - 125°C; v(out_p)%8\\"
clk"
color="4 5 6 11 7 12 16 15 17 8"
dataset=-1
unitx=1
logx=0
logy=0
legend=1
rainbow=0
rawfile=$netlist_dir/tb_pvt.raw
sim_type=tran
autoload=1}
T {Change corner (tt, ss, ff, fs, sf) -->} -1180 -100 0 0 0.4 0.4 {}
T {rename outfile name with current corner -->} -1250 130 0 0 0.4 0.4 {}
N -400 -340 -400 -320 {lab=GND}
N -400 -450 -400 -400 {lab=vdd}
N -280 -340 -280 -320 {lab=GND}
N -280 -450 -280 -400 {lab=clk}
N 20 -340 20 -320 {lab=GND}
N 110 -340 110 -320 {lab=GND}
N 20 -450 20 -400 {lab=vin_p}
N 110 -450 110 -400 {lab=vin_n}
N -20 -110 -20 -70 {lab=vdd}
N -20 70 -20 90 {lab=GND}
N 200 120 200 150 {lab=GND}
N 270 120 270 150 {lab=GND}
N 120 -20 310 -20 {lab=out_p}
N 120 20 310 20 {lab=out_n}
N 200 20 200 60 {lab=out_n}
N 270 -20 270 60 {lab=out_p}
N -180 50 -100 50 {lab=clk}
N -180 20 -100 20 {lab=vin_n}
N -180 -20 -100 -20 {lab=vin_p}
C {strongarm.sym} 50 0 0 0 {name=x1}
C {vsource.sym} -400 -370 0 0 {name=VVDD value=\{vdd_param\} savecurrent=false}
C {gnd.sym} -400 -320 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -400 -450 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {vsource.sym} -280 -370 0 0 {name=VCLK value="PULSE(0 \{vdd_param\} 25n 100p 100p 25n 50n)" savecurrent=false}
C {gnd.sym} -280 -320 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -280 -450 0 0 {name=p3 sig_type=std_logic lab=clk}
C {vsource.sym} 20 -370 0 0 {name=VVIN_P value=0.905 savecurrent=false}
C {gnd.sym} 20 -320 0 0 {name=l5 lab=GND}
C {vsource.sym} 110 -370 0 0 {name=VVIN_N value=0.895 savecurrent=false}
C {gnd.sym} 110 -320 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 20 -450 0 0 {name=p7 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 110 -450 0 0 {name=p9 sig_type=std_logic lab=vin_n}
C {gnd.sym} -20 90 0 0 {name=l2 lab=GND}
C {lab_wire.sym} -20 -110 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {capa.sym} 200 90 0 0 {name=C1
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 270 90 0 0 {name=C2
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 200 150 0 0 {name=l4 lab=GND}
C {gnd.sym} 270 150 0 0 {name=l7 lab=GND}
C {lab_wire.sym} -180 50 0 0 {name=p4 sig_type=std_logic lab=clk}
C {lab_wire.sym} -180 -20 0 0 {name=p5 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} -180 20 0 0 {name=p6 sig_type=std_logic lab=vin_n}
C {lab_wire.sym} 310 -20 0 0 {name=p8 sig_type=std_logic lab=out_p}
C {lab_wire.sym} 310 20 0 0 {name=p10 sig_type=std_logic lab=out_n}
C {code_shown.sym} -800 -90 0 0 {name=corner 
only_toplevel=false 
value=".lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt"}
C {code_shown.sym} -800 10 0 0 {name=commands 
only_toplevel=false 
value=".param vdd_param=1.8
.options savecurrents

.control
  save all
  set appendwrite
  shell rm -f tb_pvt.raw
  set outfile = pvt_tt.txt
  echo T_C,VDD_V,t_decision_ns > $outfile

  foreach T_val -40 27 125
    foreach VDD_val 1.62 1.8 1.98
      set t_save   = $T_val
      set vdd_save = $VDD_val
      alterparam vdd_param = $vdd_save
      reset
      set temp = $t_save

      tran 10p 110n
      let thresh = $vdd_save / 2
      meas tran t_clk_rise  WHEN v(clk)=thresh    RISE=2
      meas tran t_out_fall  WHEN v(out_p)=thresh  FALL=2
      let t_decision = t_out_fall - t_clk_rise
      let t_dec_ns = t_decision * 1e9
      echo $t_save,$vdd_save,$&t_dec_ns >> $outfile
      echo T=$t_save VDD=$vdd_save t_decision=$&t_dec_ns ns
      write tb_pvt.raw
    end
  end
.endc"}
C {devices/launcher.sym} 470 -60 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}

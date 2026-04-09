v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1400 -580 2200 -180 {flags=graph
y1=0.87
y2=0.93
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5.5e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vin_p
vin_n"
color="4 7"
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_mc_tran.raw
sim_type=tran
autoload=1
sweep=run}
B 2 1400 -170 2200 230 {flags=graph
y1=-1.3
y2=1.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5.5e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="vout; out_n out_p -"
color=21
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_mc_tran.raw
sim_type=tran}
B 2 1400 250 2200 650 {flags=graph
y1=0
y2=1.8
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=5.5e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=clk
color=12
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/tb_mc_tran.raw
sim_type=tran}
B 2 420 -10 1240 670 {flags=graph
y1=-0.03
y2=0.03
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=16
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
rawfile=distrib
sim_type=distrib
sweep=freq
mode=HistoH
linewidth_mult=6
color=4
node=offset_run}
T {tcleval(MC tt_mm
N = $samples runs
mean  = [format %.2f [expr \{$mean*1000\}]] mV
sigma = [format %.2f [expr \{$sigma*1000\}]] mV
Pelgrom: ~4.95 mV)} 420 720 0 0 0.6 0.6 {layer=4 floater=yes}
N -400 -340 -400 -320 {lab=GND}
N -400 -450 -400 -400 {lab=vdd}
N -280 -340 -280 -320 {lab=GND}
N -280 -450 -280 -400 {lab=clk}
N 140 -340 140 -320 {lab=GND}
N 40 -340 40 -320 {lab=GND}
N 140 -450 140 -400 {lab=vin_p}
N 40 -450 40 -400 {lab=vin_n}
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
C {vsource.sym} -400 -370 0 0 {name=VVDD value=1.8 savecurrent=false}
C {gnd.sym} -400 -320 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -400 -450 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {vsource.sym} -280 -370 0 0 {name=VCLK value="PULSE(0 1.8 25n 100p 100p 25n 50n)" savecurrent=false}
C {gnd.sym} -280 -320 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -280 -450 0 0 {name=p3 sig_type=std_logic lab=clk}
C {vsource.sym} 140 -370 0 0 {name=VVIN_P value="PULSE(0.875 0.925 0 5u 1 1)" savecurrent=false}
C {gnd.sym} 140 -320 0 0 {name=l5 lab=GND}
C {vsource.sym} 40 -370 0 0 {name=VVIN_N value=0.9 savecurrent=false}
C {gnd.sym} 40 -320 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 140 -450 0 0 {name=p7 sig_type=std_logic lab=vin_p}
C {lab_wire.sym} 40 -450 0 0 {name=p9 sig_type=std_logic lab=vin_n}
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
C {code_shown.sym} -1060 10 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents

.control
  let mc_runs = 300
  let mc_run = 1
  let results = unitvec(mc_runs)

  dowhile mc_run <= mc_runs
    reset
    tran 100p 5.5u

    * Primo FALL di out_p a VDD/2: il comparatore inverte la decisione
    meas tran cross_time WHEN v(out_p) = 0.9 FALL=1

    * L'offset e' la differenza d'ingresso in quell'istante
    meas tran vin_at_cross FIND v(vin_p) AT=cross_time
    let offset_run = vin_at_cross - 0.9
    set offset_save = $&offset_run
    set run_save = $&mc_run

    echo Run $&mc_run: offset = $&offset_run V

    op
    let offset_run = $offset_save
    let mc_run = $run_save
    let results[mc_run - 1] = offset_run
    remzerovec
    write tb_mc.raw
    set appendwrite
    let mc_run = mc_run + 1
  end

  * Calcolo statistico finale
  let mean_off = mean(results)
  let var_off = mean(results * results) - mean_off * mean_off
  let sigma_off = sqrt(var_off * mc_runs / (mc_runs - 1))

  echo ======================================
  echo Monte Carlo completato ($&mc_runs run)
  echo Media offset:  $&mean_off V
  echo Sigma offset:  $&sigma_off V
  echo Pelgrom atteso: ~4.95e-3 V
  echo ======================================

  print results > tb_mc.txt

  * Simulazione transitoria finale: mostra la rampa di Vin+ e come il
  * comparatore inverte la decisione al raggiungimento della soglia di offset
  unset appendwrite
  tran 100p 5.5u
  write tb_mc_tran.raw
.endc"}
C {devices/launcher.sym} 470 -70 0 0 {name=h17 
descr="Load MC statistics" 
tclcommand="
xschem raw_read $netlist_dir/tb_mc.raw op

proc mean_off \{\} \{
  set sum 0
  set points [xschem raw points]
  foreach v [xschem raw values offset_run -1] \{
    set sum [expr \{$sum + $v\}]
  \}
  return [expr \{$sum / $points\}]
\}

proc variance_off \{mean\} \{
  set sum 0
  set points [xschem raw points]
  foreach v [xschem raw values offset_run -1] \{
    set sum [expr \{$sum + pow($v - $mean, 2)\}]
  \}
  return [expr \{$sum / $points\}]
\}

proc get_histo \{var mean min max step\} \{
  xschem raw switch 0
  proc xround \{a size\} \{ return [expr \{round($a/$size) * $size\}] \}
  catch \{unset freq\}
  foreach v [xschem raw values $var -1] \{
    set v [xround [expr \{$v - $mean\}] $step]
    if \{![info exists freq($v)]\} \{ set freq($v) 1 \} else \{ incr freq($v) \}
  \}
  xschem raw new distrib distrib $var $min $max $step
  xschem raw add freq
  set j 0
  for \{set i $min\} \{$i <= $max\} \{set i [expr \{$i + $step\}]\} \{
    set ii [xround $i $step]
    set v 0
    if \{[info exists freq($ii)]\} \{ set v $freq($ii) \}
    xschem raw set freq $j $v
    incr j
  \}
\}

set mean [mean_off]
set variance [variance_off $mean]
set sigma [expr \{sqrt($variance)\}]
set samples [xschem raw points]

# Istogramma: ±30mV in step da 2mV (adatta al sigma misurato)
get_histo offset_run 0 -30e-3 30e-3 2e-3
set categories [xschem raw points]

xschem reset_caches
xschem redraw
"
}
C {sky130_fd_pr/corner.sym} -800 -180 0 0 {name=CORNER only_toplevel=true corner=tt_mm}
C {launcher.sym} 470 -170 0 0 {name=h1
descr="Load last MC transient run"
tclcommand="xschem raw_read $netlist_dir/tb_mc_tran.raw tran"}

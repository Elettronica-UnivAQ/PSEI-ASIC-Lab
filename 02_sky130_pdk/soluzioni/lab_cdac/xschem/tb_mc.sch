v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 -680 -680 120 -280 {flags=graph
y1=0.898
y2=0.902
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e-6
x2=2e-6
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color=4
node=voutp
rainbow=1}
N -600 270 -600 300 {lab=GND}
N -280 270 -280 300 {lab=GND}
N -90 270 -90 290 {lab=GND}
N -310 -80 -230 -80 {lab=VOUTP}
N -310 -80 -310 -30 {lab=VOUTP}
N -280 110 -280 210 {lab=BP6_0}
N -400 110 -400 140 {lab=BP6_0}
N -400 140 -280 140 {lab=BP6_0}
N -380 110 -380 140 {lab=BP6_0}
N -360 110 -360 140 {lab=BP6_0}
N -340 110 -340 140 {lab=BP6_0}
N -320 110 -320 140 {lab=BP6_0}
N -300 110 -300 140 {lab=BP6_0}
N -600 140 -600 210 {lab=BP7}
N -600 140 -420 140 {lab=BP7}
N -420 110 -420 140 {lab=BP7}
N -260 110 -260 140 {lab=Vdd}
N -260 140 -90 140 {lab=Vdd}
N -90 140 -90 210 {lab=Vdd}
N -230 -80 -100 -80 {lab=VOUTP}
N -130 -80 -130 -60 {lab=VOUTP}
N -130 0 -130 30 {lab=GND}
C {vsource.sym} -600 240 0 0 {name=VBP7 value="pwl 0 0 0.999u 0 1u 1.8 2u 1.8" savecurrent=false}
C {vsource.sym} -280 240 0 0 {name=VBP1 value=0 savecurrent=false}
C {devices/code_shown.sym} -1740 -630 0 0 {name=NGSPICE
only_toplevel=true
value=".option savecurrents
.ic v(VOUTP) = 0

.control
    save v(VOUTP)
    let mc_runs = 1000
    let run = 0
    let vout_sum  = 0
    let vout_sum2 = 0

    * Crea il file CSV e scrive l'intestazione (sovrascrive eventuali file precedenti)
    set outfile = vout_mc.txt
    echo run vout_V > $outfile

    dowhile run < mc_runs
        reset
        * Stessa sequenza di tb_convert per D=128:
        * da t=0 a t=1us: tutte le BP a 0V (carica nulla, VOUTP=0)
        * da t=1us in poi: BP7 a 1.8V, BP6..0 restano a 0V
        * La ridistribuzione porta VOUTP a ~0.9V con variazione da mismatch
        tran 10n 2u
        meas tran vout_val AVG v(VOUTP) from=1.5u to=1.9u
        let vout_sum  = vout_sum  + $&vout_val
        let vout_sum2 = vout_sum2 + $&vout_val * $&vout_val
        echo Run $&run : Vout = $&vout_val V
        * Salva riga CSV: numero di run e tensione misurata
        echo $&run $&vout_val >> $outfile
        remzerovec
        write tb_mc.raw
        set appendwrite
        let run = run + 1
    end

    let vout_mean  = vout_sum  / mc_runs
    let vout_var   = vout_sum2 / mc_runs - vout_mean * vout_mean
    let vout_sigma = sqrt(vout_var)
    let vout_3s    = 3 * vout_sigma
    let lsb        = 1.8 / 256
    let vout_3s_lsb = vout_3s / lsb

    echo
    echo ============================================
    echo  Monte Carlo CDAC — codice 10000000 (D=128)
    echo  Run: $&mc_runs  |  VOUT nominale atteso: 0.900 V
    echo  ----------------------------------------
    echo  Media VOUT   = $&vout_mean V
    echo  sigma VOUT   = $&vout_sigma V
    echo  3sigma VOUT  = $&vout_3s V
    echo  3sigma [LSB] = $&vout_3s_lsb LSB
    echo ============================================
.endc"}
C {sky130_fd_pr/corner.sym} -870 190 0 0 {name=CORNER only_toplevel=true corner=tt_mm}
C {res.sym} -130 -30 0 0 {name=R1
value=1e12
footprint=1206
device=resistor
m=1}
C {gnd.sym} -130 30 0 0 {name=l4 lab=GND}
C {devices/launcher.sym} -610 -230 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}
C {gnd.sym} -600 300 0 0 {name=l5 lab=GND}
C {gnd.sym} -280 300 0 0 {name=l6 lab=GND}
C {cdac.sym} -360 0 0 0 {name=x2}
C {vsource.sym} -90 240 0 0 {name=V2 value=1.8 savecurrent=false}
C {gnd.sym} -90 290 0 0 {name=l7 lab=GND}
C {lab_wire.sym} -100 -80 0 0 {name=p5 sig_type=std_logic lab=VOUTP}
C {lab_wire.sym} -570 140 0 0 {name=p6 sig_type=std_logic lab=BP7}
C {lab_wire.sym} -280 180 0 0 {name=p7 sig_type=std_logic lab=BP6_0}
C {lab_wire.sym} -90 140 0 0 {name=p8 sig_type=std_logic lab=Vdd}

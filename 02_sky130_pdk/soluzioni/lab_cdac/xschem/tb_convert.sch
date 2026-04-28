v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 -690 -790 110 -390 {flags=graph
y1=-0.13888889
y2=1.8611111
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1.2484587e-06
x2=4.2484587e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=voutp
color=4
dataset=-1
unitx=1
logx=0
logy=0
digital=0}
B 2 -690 -1220 110 -820 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1.2484587e-06
x2=4.2484587e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="bp7

bp6_0"
color="7 4"
dataset=-1
unitx=1
logx=0
logy=0
digital=1}
N -660 130 -660 160 {lab=GND}
N -340 130 -340 160 {lab=GND}
N -150 130 -150 150 {lab=GND}
N -370 -220 -290 -220 {lab=VOUTP}
N -370 -220 -370 -170 {lab=VOUTP}
N -340 -30 -340 70 {lab=BP6_0}
N -460 -30 -460 0 {lab=BP6_0}
N -460 0 -340 0 {lab=BP6_0}
N -440 -30 -440 0 {lab=BP6_0}
N -420 -30 -420 0 {lab=BP6_0}
N -400 -30 -400 0 {lab=BP6_0}
N -380 -30 -380 0 {lab=BP6_0}
N -360 -30 -360 0 {lab=BP6_0}
N -660 0 -660 70 {lab=BP7}
N -660 0 -480 0 {lab=BP7}
N -480 -30 -480 0 {lab=BP7}
N -320 -30 -320 0 {lab=Vdd}
N -320 0 -150 0 {lab=Vdd}
N -150 0 -150 70 {lab=Vdd}
C {vsource.sym} -660 100 0 0 {name=VBP7 value="pwl 0 0 1u 0 1.001u 1.8 2u 1.8 2.001u 1.8" savecurrent=false}
C {gnd.sym} -660 160 0 0 {name=l1 lab=GND}
C {vsource.sym} -340 100 0 0 {name=VBP1 value="pwl 0 0 2u 0 2.001u 1.8" savecurrent=false}
C {gnd.sym} -340 160 0 0 {name=l2 lab=GND}
C {cdac.sym} -420 -140 0 0 {name=x1}
C {vsource.sym} -150 100 0 0 {name=V1 value=1.8 savecurrent=false}
C {gnd.sym} -150 150 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -300 -220 0 0 {name=p1 sig_type=std_logic lab=VOUTP}
C {devices/code.sym} -870 130 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {devices/code_shown.sym} -1450 -480 0 0 {name=NGSPICE
only_toplevel=true
value=".option savecurrents
.ic v(VOUTP)=0

.control
    save all
    tran 10n 3u
    remzerovec
    write tb_convert.raw

    * Misura VOUTP nel mezzo di ogni fase (evita transitori iniziali)
    meas tran VOUT_code0   avg v(VOUTP) from=0.4u  to=0.9u
    meas tran VOUT_code128 avg v(VOUTP) from=1.4u  to=1.9u
    meas tran VOUT_code255 avg v(VOUTP) from=2.4u  to=2.9u

    echo
    echo ============================================
    echo  CDAC 8 bit — verifica scala DAC
    echo  VIN = VCM (condizione iniziale VOUTP = 0V)
    echo ============================================
    echo  Codice 00000000 (D=0):
    echo    VOUT misurata  = $&VOUT_code0 V
    echo    VOUT attesa    = 0.000 V
    echo  Codice 10000000 (D=128):
    echo    VOUT misurata  = $&VOUT_code128 V
    echo    VOUT attesa    = 0.900 V
    echo  Codice 11111111 (D=255):
    echo    VOUT misurata  = $&VOUT_code255 V
    echo    VOUT attesa    = 1.793 V
    echo ============================================
.endc"}
C {devices/launcher.sym} -630 -340 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw tran
"
}
C {lab_wire.sym} -630 0 0 0 {name=p3 sig_type=std_logic lab=BP7}
C {lab_wire.sym} -340 40 0 0 {name=p4 sig_type=std_logic lab=BP6_0}
C {lab_wire.sym} -150 0 0 0 {name=p2 sig_type=std_logic lab=Vdd}

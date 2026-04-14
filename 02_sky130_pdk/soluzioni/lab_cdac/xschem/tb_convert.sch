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
N -590 160 -590 190 {lab=GND}
N -490 230 -490 260 {lab=GND}
N -590 -40 -590 100 {lab=BP7}
N -590 -40 -220 -40 {lab=BP7}
N -490 -20 -490 170 {lab=BP6_0}
N -490 -20 -220 -20 {lab=BP6_0}
N -260 100 -220 100 {lab=BP6_0}
N -260 -20 -260 100 {lab=BP6_0}
N -260 80 -220 80 {lab=BP6_0}
N -260 60 -220 60 {lab=BP6_0}
N -260 40 -220 40 {lab=BP6_0}
N -260 20 -220 20 {lab=BP6_0}
N -260 0 -220 0 {lab=BP6_0}
N -670 -60 -670 50 {lab=VCM}
N -670 -60 -220 -60 {lab=VCM}
N -670 110 -670 130 {lab=GND}
N -30 -60 50 -60 {lab=VOUTP}
C {vsource.sym} -590 130 0 0 {name=VBP7 value="pwl 0 0 1u 0 1.001u 1.8 2u 1.8 2.001u 1.8" savecurrent=false}
C {gnd.sym} -590 190 0 0 {name=l1 lab=GND}
C {vsource.sym} -490 200 0 0 {name=VBP1 value="pwl 0 0 2u 0 2.001u 1.8" savecurrent=false}
C {gnd.sym} -490 260 0 0 {name=l2 lab=GND}
C {cdac.sym} -70 20 0 0 {name=x1}
C {vsource.sym} -670 80 0 0 {name=V1 value=0.9 savecurrent=false}
C {gnd.sym} -670 130 0 0 {name=l3 lab=GND}
C {lab_wire.sym} 50 -60 0 0 {name=p1 sig_type=std_logic lab=VOUTP}
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
C {lab_wire.sym} -410 -60 0 0 {name=p2 sig_type=std_logic lab=VCM}
C {lab_wire.sym} -480 -40 0 0 {name=p3 sig_type=std_logic lab=BP7}
C {lab_wire.sym} -410 -20 0 0 {name=p4 sig_type=std_logic lab=BP6_0}

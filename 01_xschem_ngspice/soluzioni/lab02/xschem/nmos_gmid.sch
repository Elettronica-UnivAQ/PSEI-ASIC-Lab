v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -90 70 -90 80 {lab=GND}
N -90 0 -90 10 {lab=#net1}
N -90 0 -20 0 {lab=#net1}
N 20 30 20 50 {lab=GND}
N 20 0 40 0 {lab=GND}
N 40 0 40 40 {lab=GND}
N 20 40 40 40 {lab=GND}
N 120 -20 120 -10 {lab=GND}
N 20 -110 120 -110 {lab=#net2}
N 120 -110 120 -80 {lab=#net2}
N 20 -50 20 -30 {lab=#net3}
C {sky130_fd_pr/nfet_01v8.sym} 0 0 0 0 {name=M1
W=W_val
L=L_val
nf=1 
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {vsource.sym} -90 40 0 0 {name=VGS1 value=0 savecurrent=false}
C {gnd.sym} -90 80 0 0 {name=l1 lab=GND}
C {gnd.sym} 20 50 0 0 {name=l2 lab=GND}
C {vsource.sym} 120 -50 0 0 {name=VDS1 value=0.9 savecurrent=false}
C {gnd.sym} 120 -10 0 0 {name=l3 lab=GND}
C {devices/code.sym} -300 -270 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} 280 -160 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents
.param W_val=10 L_val=0.15
.save all

.control
  foreach L_iter 0.15 0.18 0.25 0.5 1.0
    alterparam L_val=$L_iter
    reset

    echo =========================================
    echo Simulating L = $L_iter um
    echo =========================================

    save @m.xm1.msky130_fd_pr__nfet_01v8[gm]
    save @m.xm1.msky130_fd_pr__nfet_01v8[gds]
    save @m.xm1.msky130_fd_pr__nfet_01v8[cgg]
    save @m.xm1.msky130_fd_pr__nfet_01v8[vdsat]

    dc VGS1 0 1.8 0.005
    remzerovec

    let Id = -i(VDS1)
    let gm = @m.xm1.msky130_fd_pr__nfet_01v8[gm]
    let IdW = Id / 10e-6
    let gmid = gm / Id
    let gds = @m.xm1.msky130_fd_pr__nfet_01v8[gds]
    let gds_norm = gds / Id
    let fT_GHz = @m.xm1.msky130_fd_pr__nfet_01v8[gm] / (2 * 3.14159265 * @m.xm1.msky130_fd_pr__nfet_01v8[cgg]) / 1e9
    let Vdsat = @m.xm1.msky130_fd_pr__nfet_01v8[vdsat]

    let L_nm = $L_iter * 1000
    set fname = "nmos_gmid_L\{$&L_nm\}nm.txt"
    wrdata $fname IdW gmid gds_norm fT_GHz Vdsat

  end
.endc"}
C {devices/launcher.sym} 340 -790 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw dc
"
}
C {ammeter.sym} 20 -80 0 0 {name=Vmeas1 savecurrent=true spice_ignore=0}

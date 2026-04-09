v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 30 540 40 {lab=GND}
N 540 -60 540 -30 {lab=#net1}
N 430 -60 540 -60 {lab=#net1}
N 430 -60 430 50 {lab=#net1}
N 430 80 440 80 {lab=#net1}
N 440 30 440 80 {lab=#net1}
N 430 30 440 30 {lab=#net1}
N 330 80 390 80 {lab=#net2}
N 330 80 330 110 {lab=#net2}
N 430 110 430 140 {lab=#net3}
N 330 170 330 190 {lab=#net1}
N 290 190 330 190 {lab=#net1}
N 290 0 290 190 {lab=#net1}
N 290 0 430 -0 {lab=#net1}
N 430 200 430 260 {lab=GND}
C {devices/code.sym} 0 -70 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {sky130_fd_pr/pfet_01v8.sym} 410 80 0 0 {name=M1
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
model=pfet_01v8
spiceprefix=X
}
C {vsource.sym} 540 0 0 0 {name=VDD value=0.9 savecurrent=false}
C {gnd.sym} 540 40 0 0 {name=l1 lab=GND}
C {vsource.sym} 330 140 0 0 {name=VGS value=0 savecurrent=false}
C {ammeter.sym} 430 170 0 0 {name=Vmeas savecurrent=true spice_ignore=0}
C {gnd.sym} 430 260 0 0 {name=l3 lab=GND}
C {code_shown.sym} 690 80 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents
.param W_val=10 L_val=0.15
.save all

.control
  foreach L_iter 0.15 0.18 0.25 0.5 1.0
    alterparam L_val=$L_iter
    reset

    echo =========================================
    echo Simulating PMOS L = $L_iter um
    echo =========================================

    save @m.xm1.msky130_fd_pr__pfet_01v8[gm]
    save @m.xm1.msky130_fd_pr__pfet_01v8[gds]
    save @m.xm1.msky130_fd_pr__pfet_01v8[cgg]
    save @m.xm1.msky130_fd_pr__pfet_01v8[vdsat]

    dc VGS 0 -1.8 -0.005
    remzerovec

    let Id = -i(vmeas)
    let gm = @m.xm1.msky130_fd_pr__pfet_01v8[gm]
    let IdW = Id / 10e-6
    let gmid = gm / Id
    let gds = @m.xm1.msky130_fd_pr__pfet_01v8[gds]
    let gds_norm = gds / Id
    let fT_GHz = @m.xm1.msky130_fd_pr__pfet_01v8[gm] / (2 * 3.14159265 * @m.xm1.msky130_fd_pr__pfet_01v8[cgg]) / 1e9
    let Vdsat = @m.xm1.msky130_fd_pr__pfet_01v8[vdsat]

    let L_nm = $L_iter * 1000
    set fname = "pmos_gmid_L\{$&L_nm\}nm.txt"
    wrdata $fname IdW gmid gds_norm fT_GHz Vdsat

  end
.endc"}

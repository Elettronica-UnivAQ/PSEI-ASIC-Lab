v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N 10 -30 10 -0 {lab=Vin}
N 10 -30 160 -30 {lab=Vin}
N 10 60 10 90 {lab=Vout}
N 10 90 160 90 {lab=Vout}
N -90 30 -30 30 {lab=CTRL}
N 200 30 260 30 {lab=!CTRL}
N 80 -90 80 -30 {lab=Vin}
N 80 90 80 150 {lab=Vout}
N 10 30 30 30 {lab=gnd}
N 30 -60 30 30 {lab=gnd}
N 140 30 160 30 {lab=Vdd}
N 140 30 140 130 {lab=Vdd}
N 160 -30 160 0 {lab=Vin}
N 160 60 160 90 {lab=Vout}
C {ipin.sym} -90 30 0 0 {name=p1 lab=CTRL}
C {ipin.sym} 260 30 2 0 {name=p2 lab=!CTRL}
C {iopin.sym} 80 -90 3 0 {name=p3 lab=Vin}
C {iopin.sym} 80 150 1 0 {name=p4 lab=Vout}
C {ipin.sym} 140 130 3 0 {name=p5 lab=Vdd}
C {ipin.sym} 30 -60 1 0 {name=p6 lab=gnd}
C {sky130_fd_pr/annotate_fet_params.sym} -100 -110 0 0 {name=annot1 ref=M1}
C {sky130_fd_pr/annotate_fet_params.sym} 200 -110 0 0 {name=annot2 ref=M2}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -10 30 0 0 {name=M3
W=6
L=0.15
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 180 30 2 0 {name=M1
W=12
L=0.35
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}

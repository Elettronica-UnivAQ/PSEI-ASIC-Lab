v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N 10 -80 10 -10 {lab=OUT}
N 10 -200 10 -140 {lab=VDD}
N 10 50 10 120 {lab=GND}
N 10 20 30 20 {lab=GND}
N 30 20 30 70 {lab=GND}
N 10 70 30 70 {lab=GND}
N 10 -110 30 -110 {lab=VDD}
N 30 -160 30 -110 {lab=VDD}
N 10 -160 30 -160 {lab=VDD}
N -60 -110 -30 -110 {lab=IN}
N -60 -110 -60 20 {lab=IN}
N -60 20 -30 20 {lab=IN}
N -120 -50 -60 -50 {lab=IN}
N 10 -50 90 -50 {lab=OUT}
C {sky130_fd_pr/nfet_01v8.sym} -10 20 0 0 {name=M1
W=4
L=0.15
nf=2 
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
C {sky130_fd_pr/pfet_01v8.sym} -10 -110 0 0 {name=M2
W=8
L=0.15
nf=4
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
C {ipin.sym} -120 -50 0 0 {name=p1 lab=IN}
C {opin.sym} 90 -50 0 0 {name=p2 lab=OUT}
C {iopin.sym} 10 -200 3 0 {name=p3 lab=VDD}
C {iopin.sym} 10 120 1 0 {name=p4 lab=GND}
C {sky130_fd_pr/annotate_fet_params.sym} 80 -210 0 0 {name=annot1 ref=M1}
C {sky130_fd_pr/annotate_fet_params.sym} 80 60 0 0 {name=annot2 ref=M2}

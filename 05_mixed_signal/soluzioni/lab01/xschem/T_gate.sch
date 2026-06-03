v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N 20 -330 80 -330 {lab=GND}
N 20 -330 20 -170 {lab=GND}
N 20 -170 80 -170 {lab=GND}
N 140 -330 200 -330 {lab=Vout}
N 200 -330 200 -170 {lab=Vout}
N 140 -170 200 -170 {lab=Vout}
N 20 160 80 160 {lab=Vref}
N 20 160 20 320 {lab=Vref}
N 20 320 80 320 {lab=Vref}
N 140 160 200 160 {lab=Vout}
N 200 160 200 320 {lab=Vout}
N 140 320 200 320 {lab=Vout}
N 200 240 310 240 {lab=Vout}
N 310 -250 310 240 {lab=Vout}
N 200 -250 310 -250 {lab=Vout}
N -320 0 -270 -0 {lab=Ctrl}
N -30 -0 110 -0 {lab=#net1}
N 110 -130 110 -0 {lab=#net1}
N 110 0 110 120 {lab=#net1}
N -300 -400 -300 -0 {lab=Ctrl}
N -300 -400 110 -400 {lab=Ctrl}
N 110 -400 110 -370 {lab=Ctrl}
N -300 -0 -300 390 {lab=Ctrl}
N -300 390 110 390 {lab=Ctrl}
N 110 360 110 390 {lab=Ctrl}
N -40 -240 20 -240 {lab=GND}
N -40 260 20 260 {lab=Vref}
N 110 300 110 320 {lab=GND}
N 110 300 230 300 {lab=GND}
N 110 -190 110 -170 {lab=GND}
N 110 -190 220 -190 {lab=GND}
N 110 -330 110 -310 {lab=VDD}
N -30 -310 110 -310 {lab=VDD}
N 110 160 110 180 {lab=VDD}
N -20 180 110 180 {lab=VDD}
N 310 -0 360 0 {lab=Vout}
N -190 -120 -190 -60 {lab=VDD}
N -190 60 -190 110 {lab=GND}
C {inverter.sym} -130 0 0 0 {name=x1}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 110 -150 3 0 {name=M1
W=2
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} 110 -350 1 0 {name=M2
W=4
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
C {sky130_fd_pr/nfet_01v8_lvt.sym} 110 340 3 0 {name=M3
W=2
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} 110 140 1 0 {name=M4
W=4
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
C {ipin.sym} -320 0 0 0 {name=p1 lab=Ctrl}
C {iopin.sym} 360 0 0 0 {name=p2 lab=Vout}
C {iopin.sym} 460 -400 2 0 {name=p3 lab=VDD}
C {iopin.sym} 460 -360 2 0 {name=p4 lab=GND}
C {lab_wire.sym} -30 -310 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -20 180 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 220 -190 2 0 {name=p7 sig_type=std_logic lab=GND}
C {lab_wire.sym} 230 300 2 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_wire.sym} -40 -240 0 0 {name=p9 sig_type=std_logic lab=GND}
C {iopin.sym} -40 260 2 0 {name=p10 lab=Vref}
C {lab_wire.sym} -190 -120 0 0 {name=p11 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -190 110 0 0 {name=p12 sig_type=std_logic lab=GND}

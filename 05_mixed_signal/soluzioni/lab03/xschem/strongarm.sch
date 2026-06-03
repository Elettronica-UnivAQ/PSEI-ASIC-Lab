v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
T {<- insert isource here for op analysis} 220 150 0 0 0.4 0.4 {layer=4}
N -70 -250 -70 -160 {lab=out_p}
N 160 -250 160 -160 {lab=out_n}
N -70 -100 -70 -0 {lab=sp}
N 160 -100 160 -0 {lab=sn}
N -70 60 -70 100 {lab=tail}
N -70 100 160 100 {lab=tail}
N 160 60 160 100 {lab=tail}
N 40 100 40 140 {lab=tail}
N 200 30 260 30 {lab=vin_n}
N -170 30 -110 30 {lab=vin_p}
N 40 200 40 260 {lab=GND}
N -90 170 -0 170 {lab=clk}
N 40 170 70 170 {lab=GND}
N 70 170 70 220 {lab=GND}
N 40 220 70 220 {lab=GND}
N -70 30 160 30 {lab=GND}
N -150 -130 -70 -130 {lab=GND}
N 160 -130 240 -130 {lab=GND}
N 160 -200 270 -200 {lab=out_n}
N -180 -200 -70 -200 {lab=out_p}
N -70 -360 160 -360 {lab=VDD}
N 50 -400 50 -360 {lab=VDD}
N -340 -290 -270 -290 {lab=clk}
N 370 -290 430 -290 {lab=clk}
N 160 100 160 130 {lab=tail}
N 160 190 160 220 {lab=GND}
N 70 220 160 220 {lab=GND}
N -70 -260 -70 -250 {lab=out_p}
N -70 -360 -70 -320 {lab=VDD}
N 160 -360 160 -320 {lab=VDD}
N 160 -260 160 -250 {lab=out_n}
N -30 -290 -0 -290 {lab=out_n}
N -0 -290 0 -130 {lab=out_n}
N -30 -130 0 -130 {lab=out_n}
N 90 -130 120 -130 {lab=out_p}
N 90 -290 90 -130 {lab=out_p}
N 90 -290 120 -290 {lab=out_p}
N -90 -290 -70 -290 {lab=VDD}
N -90 -340 -90 -290 {lab=VDD}
N -90 -340 -70 -340 {lab=VDD}
N 160 -290 180 -290 {lab=VDD}
N 180 -340 180 -290 {lab=VDD}
N 160 -340 180 -340 {lab=VDD}
N -70 -200 90 -200 {lab=out_p}
N -0 -230 160 -230 {lab=out_n}
N -230 -360 -70 -360 {lab=VDD}
N -230 -360 -230 -320 {lab=VDD}
N 160 -360 330 -360 {lab=VDD}
N 330 -360 330 -320 {lab=VDD}
N -230 -260 -230 -250 {lab=out_p}
N -230 -250 -70 -250 {lab=out_p}
N 330 -260 330 -250 {lab=out_n}
N 160 -250 330 -250 {lab=out_n}
N 310 -290 330 -290 {lab=VDD}
N 310 -360 310 -290 {lab=VDD}
N -230 -290 -200 -290 {lab=VDD}
N -200 -360 -200 -290 {lab=VDD}
N 510 -360 510 -320 {lab=VDD}
N 330 -360 510 -360 {lab=VDD}
N 490 -290 510 -290 {lab=VDD}
N 490 -360 490 -290 {lab=VDD}
N 510 -260 510 -40 {lab=sn}
N 160 -40 510 -40 {lab=sn}
N 550 -290 630 -290 {lab=clk}
N -440 -360 -440 -320 {lab=VDD}
N -440 -360 -230 -360 {lab=VDD}
N -440 -290 -420 -290 {lab=VDD}
N -420 -360 -420 -290 {lab=VDD}
N -440 -260 -440 -40 {lab=sp}
N -440 -40 -70 -40 {lab=sp}
N -560 -290 -480 -290 {lab=clk}
C {sky130_fd_pr/nfet_01v8.sym} -90 30 0 0 {name=M1
W=4
L=0.25
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
C {sky130_fd_pr/nfet_01v8.sym} 180 30 0 1 {name=M2
W=4
L=0.25
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
C {sky130_fd_pr/nfet_01v8.sym} -50 -130 0 1 {name=M3
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 140 -130 0 0 {name=M4
W=1
L=0.15
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
C {sky130_fd_pr/nfet_01v8.sym} 20 170 0 0 {name=M5
W=8
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} -250 -290 0 0 {name=M6
W=3
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} 350 -290 0 1 {name=M7
W=3
L=0.15
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
C {lab_wire.sym} 40 30 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} -150 -130 0 0 {name=p3 sig_type=std_logic lab=GND}
C {lab_wire.sym} 240 -130 0 1 {name=p4 sig_type=std_logic lab=GND}
C {lab_wire.sym} -70 -40 0 0 {name=p5 sig_type=std_logic lab=sp}
C {lab_wire.sym} 160 -40 0 0 {name=p6 sig_type=std_logic lab=sn}
C {lab_wire.sym} 90 100 0 0 {name=p7 sig_type=std_logic lab=tail}
C {ipin.sym} -170 30 0 0 {name=p1 lab=vin_p}
C {ipin.sym} 260 30 2 0 {name=p8 lab=vin_n}
C {ipin.sym} -90 170 0 0 {name=p9 lab=clk}
C {opin.sym} 270 -200 0 0 {name=p11 lab=out_n}
C {opin.sym} -180 -200 2 0 {name=p12 lab=out_p}
C {iopin.sym} 50 -400 3 0 {name=p13 lab=VDD}
C {iopin.sym} 40 260 1 0 {name=p14 lab=GND}
C {sky130_fd_pr/annotate_fet_params.sym} -350 10 0 0 {name=annot1 ref=M1}
C {sky130_fd_pr/annotate_fet_params.sym} 340 20 0 0 {name=annot2 ref=M2}
C {sky130_fd_pr/annotate_fet_params.sym} -320 -150 0 0 {name=annot3 ref=M3}
C {sky130_fd_pr/annotate_fet_params.sym} 330 -150 0 0 {name=annot4 ref=M4}
C {sky130_fd_pr/annotate_fet_params.sym} 70 250 0 0 {name=annot5 ref=M5}
C {sky130_fd_pr/annotate_fet_params.sym} -240 -540 0 0 {name=annot6 ref=M6}
C {sky130_fd_pr/annotate_fet_params.sym} 360 -530 0 0 {name=annot7 ref=M7}
C {lab_wire.sym} -340 -290 0 0 {name=p10 sig_type=std_logic lab=clk}
C {lab_wire.sym} 430 -290 0 0 {name=p15 sig_type=std_logic lab=clk}
C {sky130_fd_pr/pfet_01v8.sym} 140 -290 0 0 {name=M8
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} -50 -290 0 1 {name=M9
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 530 -290 0 1 {name=M10
W=3
L=0.15
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
C {sky130_fd_pr/pfet_01v8.sym} -460 -290 0 0 {name=M11
W=3
L=0.15
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
C {lab_wire.sym} -560 -290 0 0 {name=p16 sig_type=std_logic lab=clk}
C {lab_wire.sym} 630 -290 0 0 {name=p17 sig_type=std_logic lab=clk}
C {sky130_fd_pr/annotate_fet_params.sym} -440 -530 0 0 {name=annot8 ref=M11}
C {sky130_fd_pr/annotate_fet_params.sym} -80 -540 0 0 {name=annot9 ref=M9}
C {sky130_fd_pr/annotate_fet_params.sym} 150 -540 0 0 {name=annot10 ref=M8}
C {sky130_fd_pr/annotate_fet_params.sym} 500 -530 0 0 {name=annot11 ref=M10}

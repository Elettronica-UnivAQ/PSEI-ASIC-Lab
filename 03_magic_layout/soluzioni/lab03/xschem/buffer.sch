v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 -0 110 0 {lab=out1}
N -190 0 -140 0 {lab=IN}
N 330 0 360 0 {lab=OUT}
N -90 -120 -90 -70 {lab=VDD}
N 160 -120 160 -70 {lab=VDD}
N -90 70 -90 120 {lab=GND}
N 160 70 160 120 {lab=GND}
C {modulo3/lab02/xschem/inverter.sym} -20 0 0 0 {name=x1}
C {modulo3/lab02/xschem/inverterx4.sym} 250 0 0 0 {name=x2}
C {ipin.sym} -190 0 0 0 {name=p1 lab=IN}
C {opin.sym} 360 0 0 0 {name=p2 lab=OUT}
C {lab_wire.sym} 100 0 0 0 {name=p3 sig_type=std_logic lab=out1}
C {iopin.sym} -140 -220 2 0 {name=p4 lab=VDD}
C {iopin.sym} -140 -190 2 0 {name=p5 lab=GND}
C {lab_wire.sym} -90 -120 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 160 -120 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -90 120 0 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_wire.sym} 160 120 0 0 {name=p9 sig_type=std_logic lab=GND}

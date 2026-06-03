v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -90 30 -90 50 {lab=#net1}
N -90 20 -90 30 {lab=#net1}
N -70 20 -70 50 {lab=#net2}
N -50 20 -50 50 {lab=#net3}
N -30 20 -30 50 {lab=#net4}
N -10 20 -10 50 {lab=#net5}
N 10 20 10 50 {lab=#net6}
N 30 20 30 50 {lab=#net7}
N 50 20 50 50 {lab=#net8}
N -210 -170 20 -170 {lab=Vout}
N 20 -170 20 -120 {lab=Vout}
N 20 -170 200 -170 {lab=Vout}
N -380 -210 -330 -210 {lab=VDD}
N -380 -130 -330 -130 {lab=GND}
N 80 200 80 250 {lab=GND}
N 120 200 120 250 {lab=VDD}
N 100 200 100 230 {lab=Vref}
N 100 230 170 230 {lab=Vref}
N 170 40 170 230 {lab=Vref}
N 70 40 170 40 {lab=Vref}
N 70 20 70 40 {lab=Vref}
N -400 -170 -330 -170 {lab=Vin}
N -300 -270 -270 -270 {lab=SMPL_not}
N -270 -270 -270 -230 {lab=SMPL_not}
N -300 -80 -270 -80 {lab=SMPL}
N -270 -130 -270 -80 {lab=SMPL}
N -90 200 -90 230 {lab=ctrl7}
N -70 200 -70 230 {lab=ctrl6}
N -50 200 -50 230 {lab=ctrl5}
N -30 200 -30 230 {lab=ctrl4}
N -10 200 -10 230 {lab=ctrl3}
N 10 200 10 230 {lab=ctrl2}
N 30 200 30 230 {lab=ctrl1}
N 50 200 50 230 {lab=ctrl0}
C {cdac.sym} -30 -90 0 0 {name=x1}
C {switch_bank.sym} 10 180 0 0 {name=x2}
C {passgate.sym} -270 -170 0 0 {name=x3}
C {ipin.sym} -240 -370 0 0 {name=p1 lab=VDD}
C {ipin.sym} -240 -330 0 0 {name=p2 lab=GND}
C {lab_wire.sym} -350 -210 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 120 250 1 1 {name=p4 sig_type=std_logic lab=VDD}
C {lab_wire.sym} -350 -130 0 0 {name=p5 sig_type=std_logic lab=GND}
C {lab_wire.sym} 80 250 1 1 {name=p6 sig_type=std_logic lab=GND}
C {ipin.sym} 170 130 2 0 {name=p7 lab=Vref}
C {ipin.sym} -400 -170 0 0 {name=p8 lab=Vin}
C {opin.sym} 200 -170 0 0 {name=p9 lab=Vout}
C {ipin.sym} -300 -80 0 0 {name=p10 lab=SMPL}
C {ipin.sym} -300 -270 0 0 {name=p11 lab=SMPL_not}
C {ipin.sym} -90 230 3 0 {name=p12 lab=ctrl7}
C {ipin.sym} -70 230 3 0 {name=p13 lab=ctrl6}
C {ipin.sym} -50 230 3 0 {name=p14 lab=ctrl5}
C {ipin.sym} -30 230 3 0 {name=p15 lab=ctrl4}
C {ipin.sym} -10 230 3 0 {name=p16 lab=ctrl3}
C {ipin.sym} 10 230 3 0 {name=p17 lab=ctrl2}
C {ipin.sym} 30 230 3 0 {name=p18 lab=ctrl1}
C {ipin.sym} 50 230 3 0 {name=p19 lab=ctrl0}

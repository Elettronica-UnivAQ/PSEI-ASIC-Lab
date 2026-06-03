v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
N -180 -80 -180 -40 {lab=clk_ana}
N -180 20 -180 50 {lab=GND}
N 70 20 70 50 {lab=GND}
N 70 -80 70 -40 {lab=rst_ana}
N 120 -160 180 -160 {lab=clk_ana}
N 240 -160 300 -160 {lab=clk_d}
N 120 -120 180 -120 {lab=rst_ana}
N 240 -120 300 -120 {lab=rst_d}
N 300 -160 350 -160 {lab=clk_d}
N 320 -140 350 -140 {lab=rst_d}
N 320 -140 320 -120 {lab=rst_d}
N 300 -120 320 -120 {lab=rst_d}
N 630 -180 700 -180 {lab=q0_d}
N 630 -160 700 -160 {lab=q1_d}
N 630 -140 700 -140 {lab=q2_d}
N 630 -120 700 -120 {lab=q3_d}
N 760 -120 890 -120 {lab=v_q3}
N 890 -120 890 -80 {lab=v_q3}
N 760 -140 950 -140 {lab=v_q2}
N 950 -140 950 -80 {lab=v_q2}
N 760 -160 1010 -160 {lab=v_q1}
N 1010 -160 1010 -80 {lab=v_q1}
N 760 -180 1070 -180 {lab=v_q0}
N 1070 -180 1070 -80 {lab=v_q0}
N 890 -20 890 20 {lab=GND}
N 950 -20 950 20 {lab=GND}
N 1010 -20 1010 20 {lab=GND}
N 1070 -20 1070 20 {lab=GND}
N 70 -120 70 -80 {lab=rst_ana}
N 70 -120 120 -120 {lab=rst_ana}
N -180 -160 -180 -80 {lab=clk_ana}
N -180 -160 120 -160 {lab=clk_ana}
C {gnd.sym} -180 50 0 0 {name=l1 lab=GND}
C {vsource.sym} -180 -10 0 0 {name=Vclk value="PULSE(0 1.8 0 1n 1n 49n 100n)" savecurrent=false}
C {lab_wire.sym} -120 -160 0 0 {name=p1 sig_type=std_logic lab=clk_ana}
C {vsource.sym} 70 -10 0 0 {name=Vrst value="PULSE(0 1.8 200n 1n 1n 10u 20u)" savecurrent=false}
C {gnd.sym} 70 50 0 0 {name=l2 lab=GND}
C {lab_wire.sym} 130 -120 0 0 {name=p2 sig_type=std_logic lab=rst_ana}
C {adc_bridge1.sym} 210 -160 0 0 {name=Abr_clk
adc=adc1
adc_bridge_model=adc_bridge
in_low=0.7
in_high=1.1
}
C {lab_wire.sym} 300 -160 0 0 {name=p4 sig_type=std_logic lab=clk_d}
C {adc_bridge1.sym} 210 -120 0 0 {name=Abr_rst
adc=adc1
adc_bridge_model=adc_bridge
in_low=0.7
in_high=1.1
}
C {lab_wire.sym} 300 -120 0 0 {name=p6 sig_type=std_logic lab=rst_d}
C {counter4.sym} 490 -150 0 0 {name=adut
model=dut}
C {dac_bridge1.sym} 730 -180 0 0 {name=A1
dac=dac1
dac_bridge_model=dac_bridge
out_low=0
out_high=1.8
}
C {dac_bridge1.sym} 730 -160 0 0 {name=A2
dac=dac1
dac_bridge_model=dac_bridge
out_low=0
out_high=1.8
}
C {dac_bridge1.sym} 730 -140 0 0 {name=A3
dac=dac1
dac_bridge_model=dac_bridge
out_low=0
out_high=1.8
}
C {dac_bridge1.sym} 730 -120 0 0 {name=A4
dac=dac1
dac_bridge_model=dac_bridge
out_low=0
out_high=1.8
}
C {lab_wire.sym} 670 -180 0 0 {name=p7 sig_type=std_logic lab=q0_d}
C {lab_wire.sym} 670 -160 0 0 {name=p8 sig_type=std_logic lab=q1_d}
C {lab_wire.sym} 670 -140 0 0 {name=p9 sig_type=std_logic lab=q2_d}
C {lab_wire.sym} 670 -120 0 0 {name=p10 sig_type=std_logic lab=q3_d}
C {res.sym} 890 -50 0 0 {name=R1
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 950 -50 0 0 {name=R2
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -50 0 0 {name=R3
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 1070 -50 0 0 {name=R4
value=100k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 890 20 0 0 {name=l3 lab=GND}
C {gnd.sym} 950 20 0 0 {name=l4 lab=GND}
C {gnd.sym} 1010 20 0 0 {name=l5 lab=GND}
C {gnd.sym} 1070 20 0 0 {name=l6 lab=GND}
C {lab_wire.sym} 1070 -180 0 0 {name=p11 sig_type=std_logic lab=v_q0}
C {lab_wire.sym} 1010 -160 0 0 {name=p12 sig_type=std_logic lab=v_q1}
C {lab_wire.sym} 950 -140 0 0 {name=p13 sig_type=std_logic lab=v_q2}
C {lab_wire.sym} 890 -120 0 0 {name=p14 sig_type=std_logic lab=v_q3}
C {code_shown.sym} -540 -510 0 0 {name=command 
only_toplevel=false 
value="
.control
tran 1n 2000n
plot v_q3+6 v_q2+4 v_q1+2 v_q0
.endc
"}

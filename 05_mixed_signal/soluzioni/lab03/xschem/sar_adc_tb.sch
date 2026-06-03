v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1280 -490 2080 -90 {flags=graph
y1=0.75
y2=1.2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1.16e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="voutp
voutn"
color="4 5"
dataset=-1
unitx=1
logx=0
logy=0
linewidth_mult=2}
B 2 1280 -70 2080 460 {flags=graph
y1=0
y2=2
ypos1=-0.019517383
ypos2=3.2382718
divy=5
subdivy=1
unity=1
x1=0
x2=1.16e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="dout7
dout6
dout5
dout4
dout3
dout2
dout1
dout0
Dout; dout7, dout6, dout5, dout4, dout3, dout2, dout1, dout0
clk
eoc
rst_n
x1.phi_smp_inv_a
x1.phi_a"
color="4 4 4 4 4 4 4 4 4 7 8 6 6 4"
dataset=-1
unitx=1
logx=0
logy=0
digital=1
legend=1}
B 2 1280 -910 2080 -510 {flags=graph
y1=-1.9
y2=1.9
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1.16e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="\\"comp_diff; x1.out_comp_p_a x1.out_comp_n_a -\\""
color=4
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1280 480 2080 880 {flags=graph
y1=0
y2=2
ypos1=-0.26344561
ypos2=2.2891176
divy=5
subdivy=1
unity=1
x1=0
x2=1.16e-06
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="x1.dac_p_a7
x1.dac_p_a6
x1.dac_p_a5
x1.dac_p_a4
x1.dac_p_a3
x1.dac_p_a2
x1.dac_p_a1
x1.dac_p_a0"
color="4 4 4 4 4 4 4 4"
dataset=-1
unitx=1
logx=0
logy=0
digital=1}
N -350 -350 -350 -330 {lab=GND}
N -350 -460 -350 -410 {lab=VDD}
N 40 -220 40 -180 {lab=VDD}
N 40 120 40 150 {lab=GND}
N -260 -350 -260 -330 {lab=GND}
N -260 -460 -260 -410 {lab=Vref}
N -120 -70 -90 -70 {lab=Vref}
N -120 -130 -120 -70 {lab=Vref}
N -160 -350 -160 -330 {lab=GND}
N -160 -460 -160 -410 {lab=clk}
N -170 -50 -90 -50 {lab=clk}
N 30 -350 30 -330 {lab=GND}
N 30 -460 30 -410 {lab=rst_n}
N -170 -30 -90 -30 {lab=rst_n}
N 370 180 370 210 {lab=GND}
N 430 180 430 210 {lab=GND}
N 490 180 490 210 {lab=GND}
N 550 180 550 210 {lab=GND}
N 610 180 610 210 {lab=GND}
N 670 180 670 210 {lab=GND}
N 730 180 730 210 {lab=GND}
N 790 180 790 210 {lab=GND}
N 210 70 370 70 {lab=eoc}
N 370 70 370 120 {lab=eoc}
N 210 50 430 50 {lab=dout0}
N 430 50 430 120 {lab=dout0}
N 210 30 490 30 {lab=dout1}
N 490 30 490 120 {lab=dout1}
N 210 10 550 10 {lab=dout2}
N 550 10 550 120 {lab=dout2}
N 210 -10 610 -10 {lab=dout3}
N 610 -10 610 120 {lab=dout3}
N 210 -30 670 -30 {lab=dout4}
N 670 -30 670 120 {lab=dout4}
N 210 -50 730 -50 {lab=dout5}
N 730 -50 730 120 {lab=dout5}
N 210 -70 790 -70 {lab=dout6}
N 790 -70 790 120 {lab=dout6}
N 850 180 850 210 {lab=GND}
N 210 -90 850 -90 {lab=dout7}
N 850 -90 850 120 {lab=dout7}
N 210 -130 340 -130 {lab=VOUTP}
N 210 -110 340 -110 {lab=VOUTN}
N -410 150 -410 180 {lab=GND}
N -300 150 -300 180 {lab=GND}
N -300 10 -300 90 {lab=VIN_N}
N -410 -10 -410 90 {lab=VIN_P}
N -300 10 -220 10 {lab=VIN_N}
N -220 -10 -220 10 {lab=VIN_N}
N -220 -10 -90 -10 {lab=VIN_N}
N -410 -10 -240 -10 {lab=VIN_P}
N -240 -10 -240 30 {lab=VIN_P}
N -240 30 -190 30 {lab=VIN_P}
N -190 10 -190 30 {lab=VIN_P}
N -190 10 -90 10 {lab=VIN_P}
C {sar_adc_top.sym} 60 -30 0 0 {name=x1}
C {vsource.sym} -350 -380 0 0 {name=Vvdd value=1.8 savecurrent=false}
C {gnd.sym} -350 -330 0 0 {name=l1 lab=GND}
C {lab_wire.sym} -350 -460 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 40 -220 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {gnd.sym} 40 150 0 0 {name=l2 lab=GND}
C {vsource.sym} -260 -380 0 0 {name=Vvref value=\{Vref_par\} savecurrent=false}
C {gnd.sym} -260 -330 0 0 {name=l3 lab=GND}
C {lab_wire.sym} -260 -460 0 0 {name=p3 sig_type=std_logic lab=Vref}
C {lab_wire.sym} -120 -130 0 0 {name=p4 sig_type=std_logic lab=Vref}
C {vsource.sym} -160 -380 0 0 {name=Vclk value="PULSE(0 1.8 0 1n 1n 24n 50n)" savecurrent=false}
C {gnd.sym} -160 -330 0 0 {name=l4 lab=GND}
C {lab_wire.sym} -160 -460 0 0 {name=p5 sig_type=std_logic lab=clk}
C {lab_wire.sym} -170 -50 0 0 {name=p6 sig_type=std_logic lab=clk}
C {vsource.sym} 30 -380 0 0 {name=Vrst value="PULSE(0 1.8 100n 1n 1n 100u 200u)" savecurrent=false}
C {gnd.sym} 30 -330 0 0 {name=l5 lab=GND}
C {lab_wire.sym} 30 -460 0 0 {name=p7 sig_type=std_logic lab=rst_n}
C {lab_wire.sym} -170 -30 0 0 {name=p8 sig_type=std_logic lab=rst_n}
C {res.sym} 370 150 0 0 {name=R1
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 430 150 0 0 {name=R2
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 490 150 0 0 {name=R3
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 550 150 0 0 {name=R4
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 610 150 0 0 {name=R5
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 670 150 0 0 {name=R6
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 730 150 0 0 {name=R7
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 790 150 0 0 {name=R8
value=100k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 370 210 0 0 {name=l6 lab=GND}
C {gnd.sym} 430 210 0 0 {name=l7 lab=GND}
C {gnd.sym} 490 210 0 0 {name=l8 lab=GND}
C {gnd.sym} 550 210 0 0 {name=l9 lab=GND}
C {gnd.sym} 610 210 0 0 {name=l10 lab=GND}
C {gnd.sym} 670 210 0 0 {name=l11 lab=GND}
C {gnd.sym} 730 210 0 0 {name=l12 lab=GND}
C {gnd.sym} 790 210 0 0 {name=l13 lab=GND}
C {res.sym} 850 150 0 0 {name=R9
value=100k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 850 210 0 0 {name=l14 lab=GND}
C {vsource.sym} -410 120 0 0 {name=Vinp value=0.93 savecurrent=false}
C {vsource.sym} -300 120 0 0 {name=Vinn value=0.87 savecurrent=false}
C {gnd.sym} -410 180 0 0 {name=l15 lab=GND}
C {gnd.sym} -300 180 0 0 {name=l16 lab=GND}
C {lab_wire.sym} -380 -10 0 0 {name=p9 sig_type=std_logic lab=VIN_P}
C {lab_wire.sym} -270 10 0 0 {name=p10 sig_type=std_logic lab=VIN_N}
C {lab_wire.sym} 310 -130 0 1 {name=p11 sig_type=std_logic lab=VOUTP}
C {lab_wire.sym} 310 -110 0 1 {name=p12 sig_type=std_logic lab=VOUTN}
C {devices/code.sym} -430 -210 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} -740 100 0 0 {name=commands 
only_toplevel=false 
value="
.param vref_par=0.256

.options savecurrents
.ic v(VOUTP)=0.9
.ic v(VOUTN)=0.9

.control
  save all
  tran 1n 1160n
  write sar_adc_tb.raw
  plot v(VOUTP) v(VOUTN)
  plot v(dout7)+16 v(dout6)+14 v(dout5)+12 v(dout4)+10 v(dout3)+8 v(dout2)+6 v(dout1)+4 v(dout0)+2 v(eoc)
.endc
"}
C {lab_wire.sym} 840 -90 0 0 {name=p13 sig_type=std_logic lab=dout7}
C {lab_wire.sym} 780 -70 0 0 {name=p14 sig_type=std_logic lab=dout6}
C {lab_wire.sym} 720 -50 0 0 {name=p15 sig_type=std_logic lab=dout5}
C {lab_wire.sym} 660 -30 0 0 {name=p16 sig_type=std_logic lab=dout4}
C {lab_wire.sym} 600 -10 0 0 {name=p17 sig_type=std_logic lab=dout3}
C {lab_wire.sym} 540 10 0 0 {name=p18 sig_type=std_logic lab=dout2}
C {lab_wire.sym} 480 30 0 0 {name=p19 sig_type=std_logic lab=dout1}
C {lab_wire.sym} 420 50 0 0 {name=p20 sig_type=std_logic lab=dout0}
C {lab_wire.sym} 360 70 0 0 {name=p21 sig_type=std_logic lab=eoc}
C {launcher.sym} 530 -510 0 0 {name=h5
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/sar_adc_tb.raw tran"
}

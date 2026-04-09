v {xschem version=3.4.8RC file_version=1.2}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 270 -720 1070 -320 {flags=graph
y1=2.6e-12
y2=0.0049
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1.8
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color=4
node=i(vmeas1)
rawfile=$netlist_dir/nmos_vgs.raw
sim_type=dc
autoload=1}
B 2 1110 -720 1910 -320 {flags=graph
y1=-7.5e-20
y2=0.0049
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=1.8
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
rawfile=$netlist_dir/nmos_vds.raw
sim_type=dc
autoload=1
color=4
node=i(vmeas2)}
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
N 190 70 190 80 {lab=GND}
N 190 0 190 10 {lab=#net4}
N 190 0 260 0 {lab=#net4}
N 300 30 300 50 {lab=GND}
N 300 0 320 0 {lab=GND}
N 320 0 320 40 {lab=GND}
N 300 40 320 40 {lab=GND}
N 400 -20 400 -10 {lab=GND}
N 300 -110 400 -110 {lab=#net5}
N 400 -110 400 -80 {lab=#net5}
N 300 -50 300 -30 {lab=#net6}
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
C {vsource.sym} 120 -50 0 0 {name=VDS1 value=1.8 savecurrent=false}
C {gnd.sym} 120 -10 0 0 {name=l3 lab=GND}
C {devices/code.sym} -300 -270 0 0 {name=TT_MODELS
only_toplevel=true
format="tcleval( @value )"
value="
** opencircuitdesign pdks install
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
"
spice_ignore=false}
C {code_shown.sym} 760 -140 0 0 {name=commands 
only_toplevel=false 
value=".options savecurrents
.param W_val=10 L_val=0.15
.save all

.control
  * curva Id-VGS su MN1
  dc VGS1 0 1.8 0.005
  remzerovec
  plot i(vmeas1)
  write nmos_vgs.raw

  * famiglia Id-VDS su MN2
  dc VDS2 0 1.8 0.005 VGS2 0 1.8 0.2
  remzerovec
  plot all.vmeas2#branch
  write nmos_vds.raw

.endc"}
C {sky130_fd_pr/nfet_01v8.sym} 280 0 0 0 {name=M2
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
C {vsource.sym} 190 40 0 0 {name=VGS2 value=0 savecurrent=false}
C {gnd.sym} 190 80 0 0 {name=l4 lab=GND}
C {gnd.sym} 300 50 0 0 {name=l5 lab=GND}
C {vsource.sym} 400 -50 0 0 {name=VDS2 value=1.8 savecurrent=false}
C {gnd.sym} 400 -10 0 0 {name=l6 lab=GND}
C {ammeter.sym} 300 -80 0 0 {name=Vmeas2 savecurrent=true spice_ignore=0}
C {devices/launcher.sym} 340 -790 0 0 {name=h17 
descr="Load waves" 
tclcommand="
xschem raw_read $netlist_dir/[file tail [file rootname [xschem get current_name]]].raw dc
"
}
C {ammeter.sym} 20 -80 0 0 {name=Vmeas1 savecurrent=true spice_ignore=0}

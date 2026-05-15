module sar_controller (clk,
    clk_comp,
    eoc,
    out_comp_n,
    out_comp_p,
    phi_sample,
    phi_sample_n,
    rst_n,
    dac_n,
    dac_p,
    dout);
 input clk;
 output clk_comp;
 output eoc;
 input out_comp_n;
 input out_comp_p;
 output phi_sample;
 output phi_sample_n;
 input rst_n;
 output [7:0] dac_n;
 output [7:0] dac_p;
 output [7:0] dout;

 wire \:61.Y[0] ;
 wire \:61.Y[1] ;
 wire \:61.Y[2] ;
 wire \:61.Y[3] ;
 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net18;
 wire net19;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net25;
 wire net26;
 wire net27;
 wire net28;
 wire net29;
 wire net30;
 wire net31;
 wire net32;
 wire net38;
 wire net39;
 wire \state[0] ;
 wire \state[1] ;
 wire \state[2] ;
 wire \state[3] ;
 wire net1;
 wire net33;
 wire net34;
 wire net35;
 wire net36;
 wire net2;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire net37;
 wire net40;
 wire net41;
 wire net42;
 wire clk_regs;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_0_clk_regs;
 wire clknet_2_0__leaf_clk_regs;
 wire clknet_2_1__leaf_clk_regs;
 wire clknet_2_2__leaf_clk_regs;
 wire clknet_2_3__leaf_clk_regs;

 sky130_fd_sc_hd__inv_1 _072_ (.A(net37),
    .Y(_046_));
 sky130_fd_sc_hd__inv_1 _073_ (.A(\state[1] ),
    .Y(_047_));
 sky130_fd_sc_hd__inv_2 _074_ (.A(net1),
    .Y(_048_));
 sky130_fd_sc_hd__inv_1 _075_ (.A(net38),
    .Y(net39));
 sky130_fd_sc_hd__and2b_4 _076_ (.A_N(\state[2] ),
    .B(\state[3] ),
    .X(_049_));
 sky130_fd_sc_hd__nand2b_2 _077_ (.A_N(\state[2] ),
    .B(\state[3] ),
    .Y(_050_));
 sky130_fd_sc_hd__and4bb_4 _078_ (.A_N(\state[0] ),
    .B_N(net35),
    .C(net34),
    .D(net36),
    .X(_000_));
 sky130_fd_sc_hd__a21oi_1 _079_ (.A1(net35),
    .A2(net34),
    .B1(\state[0] ),
    .Y(\:61.Y[0] ));
 sky130_fd_sc_hd__nand2_1 _080_ (.A(\state[0] ),
    .B(net36),
    .Y(_051_));
 sky130_fd_sc_hd__o21ai_1 _081_ (.A1(net36),
    .A2(net35),
    .B1(net34),
    .Y(_052_));
 sky130_fd_sc_hd__nor2_1 _082_ (.A(net37),
    .B(\state[1] ),
    .Y(_053_));
 sky130_fd_sc_hd__or2_4 _083_ (.A(\state[0] ),
    .B(net36),
    .X(_054_));
 sky130_fd_sc_hd__and3_1 _084_ (.A(_051_),
    .B(_052_),
    .C(_054_),
    .X(\:61.Y[1] ));
 sky130_fd_sc_hd__or2_4 _085_ (.A(net35),
    .B(net34),
    .X(_055_));
 sky130_fd_sc_hd__and4bb_1 _086_ (.A_N(net35),
    .B_N(net34),
    .C(\state[0] ),
    .D(net36),
    .X(_056_));
 sky130_fd_sc_hd__or2_1 _087_ (.A(_051_),
    .B(_055_),
    .X(_057_));
 sky130_fd_sc_hd__and2b_1 _088_ (.A_N(net34),
    .B(net35),
    .X(_058_));
 sky130_fd_sc_hd__a21o_1 _089_ (.A1(_051_),
    .A2(_058_),
    .B1(_056_),
    .X(\:61.Y[2] ));
 sky130_fd_sc_hd__and4b_4 _090_ (.A_N(net34),
    .B(net35),
    .C(net36),
    .D(\state[0] ),
    .X(_059_));
 sky130_fd_sc_hd__a21o_1 _091_ (.A1(_047_),
    .A2(_049_),
    .B1(_059_),
    .X(\:61.Y[3] ));
 sky130_fd_sc_hd__nor2_2 _092_ (.A(net38),
    .B(clknet_1_0__leaf_clk),
    .Y(net3));
 sky130_fd_sc_hd__nor2_2 _093_ (.A(net36),
    .B(_055_),
    .Y(_060_));
 sky130_fd_sc_hd__or3_4 _094_ (.A(\state[1] ),
    .B(\state[2] ),
    .C(\state[3] ),
    .X(_061_));
 sky130_fd_sc_hd__or2_4 _095_ (.A(net37),
    .B(_061_),
    .X(_062_));
 sky130_fd_sc_hd__and2_4 _096_ (.A(net42),
    .B(_000_),
    .X(_063_));
 sky130_fd_sc_hd__and2b_1 _097_ (.A_N(_000_),
    .B(net24),
    .X(_064_));
 sky130_fd_sc_hd__o21a_1 _098_ (.A1(_063_),
    .A2(_064_),
    .B1(_062_),
    .X(_001_));
 sky130_fd_sc_hd__o21a_1 _099_ (.A1(\state[2] ),
    .A2(_054_),
    .B1(net26),
    .X(_065_));
 sky130_fd_sc_hd__and3_4 _100_ (.A(net42),
    .B(_049_),
    .C(_053_),
    .X(_066_));
 sky130_fd_sc_hd__or2_1 _101_ (.A(_065_),
    .B(_066_),
    .X(_002_));
 sky130_fd_sc_hd__and4_4 _102_ (.A(net37),
    .B(_047_),
    .C(net42),
    .D(_049_),
    .X(_067_));
 sky130_fd_sc_hd__o31a_1 _103_ (.A1(_046_),
    .A2(\state[1] ),
    .A3(_050_),
    .B1(net25),
    .X(_068_));
 sky130_fd_sc_hd__o21a_1 _104_ (.A1(_067_),
    .A2(_068_),
    .B1(_062_),
    .X(_003_));
 sky130_fd_sc_hd__or4bb_4 _105_ (.A(net37),
    .B(net34),
    .C_N(\state[2] ),
    .D_N(\state[1] ),
    .X(_069_));
 sky130_fd_sc_hd__nor2_1 _106_ (.A(_048_),
    .B(_069_),
    .Y(_070_));
 sky130_fd_sc_hd__mux2_1 _107_ (.A0(net42),
    .A1(net28),
    .S(_069_),
    .X(_071_));
 sky130_fd_sc_hd__and2_1 _108_ (.A(_062_),
    .B(_071_),
    .X(_004_));
 sky130_fd_sc_hd__or4bb_4 _109_ (.A(\state[1] ),
    .B(net34),
    .C_N(\state[2] ),
    .D_N(net37),
    .X(_026_));
 sky130_fd_sc_hd__nor2_1 _110_ (.A(_048_),
    .B(_026_),
    .Y(_027_));
 sky130_fd_sc_hd__mux2_1 _111_ (.A0(_048_),
    .A1(net13),
    .S(_026_),
    .X(_028_));
 sky130_fd_sc_hd__or2_1 _112_ (.A(_060_),
    .B(_028_),
    .X(_005_));
 sky130_fd_sc_hd__mux2_1 _113_ (.A0(net27),
    .A1(net42),
    .S(_059_),
    .X(_029_));
 sky130_fd_sc_hd__and2_1 _114_ (.A(_062_),
    .B(_029_),
    .X(_006_));
 sky130_fd_sc_hd__or4b_4 _115_ (.A(net37),
    .B(\state[1] ),
    .C(\state[3] ),
    .D_N(\state[2] ),
    .X(_030_));
 sky130_fd_sc_hd__nor2_1 _116_ (.A(_048_),
    .B(_030_),
    .Y(_031_));
 sky130_fd_sc_hd__mux2_1 _117_ (.A0(_048_),
    .A1(net14),
    .S(_030_),
    .X(_032_));
 sky130_fd_sc_hd__or2_1 _118_ (.A(_060_),
    .B(_032_),
    .X(_007_));
 sky130_fd_sc_hd__o22a_1 _119_ (.A1(\state[0] ),
    .A2(_055_),
    .B1(_060_),
    .B2(net38),
    .X(_008_));
 sky130_fd_sc_hd__a21oi_1 _120_ (.A1(_046_),
    .A2(net36),
    .B1(_055_),
    .Y(_033_));
 sky130_fd_sc_hd__o22a_1 _121_ (.A1(net42),
    .A2(_057_),
    .B1(_033_),
    .B2(net23),
    .X(_009_));
 sky130_fd_sc_hd__and2_4 _122_ (.A(net42),
    .B(_056_),
    .X(_034_));
 sky130_fd_sc_hd__o21ba_1 _123_ (.A1(net15),
    .A2(_033_),
    .B1_N(_034_),
    .X(_010_));
 sky130_fd_sc_hd__mux2_1 _124_ (.A0(_048_),
    .A1(net8),
    .S(_069_),
    .X(_035_));
 sky130_fd_sc_hd__or2_1 _125_ (.A(_060_),
    .B(_035_),
    .X(_011_));
 sky130_fd_sc_hd__mux2_1 _126_ (.A0(net42),
    .A1(net29),
    .S(_026_),
    .X(_036_));
 sky130_fd_sc_hd__and2_1 _127_ (.A(_062_),
    .B(_036_),
    .X(_012_));
 sky130_fd_sc_hd__mux2_1 _128_ (.A0(net7),
    .A1(_048_),
    .S(_059_),
    .X(_037_));
 sky130_fd_sc_hd__or2_1 _129_ (.A(_060_),
    .B(_037_),
    .X(_013_));
 sky130_fd_sc_hd__o21a_1 _130_ (.A1(net34),
    .A2(_054_),
    .B1(net30),
    .X(_038_));
 sky130_fd_sc_hd__or2_1 _131_ (.A(_031_),
    .B(_038_),
    .X(_014_));
 sky130_fd_sc_hd__a31o_1 _132_ (.A1(net31),
    .A2(_057_),
    .A3(_062_),
    .B1(_034_),
    .X(_015_));
 sky130_fd_sc_hd__a21oi_1 _133_ (.A1(_049_),
    .A2(_053_),
    .B1(net6),
    .Y(_039_));
 sky130_fd_sc_hd__o21ai_1 _134_ (.A1(_066_),
    .A2(_039_),
    .B1(_061_),
    .Y(_016_));
 sky130_fd_sc_hd__a31oi_1 _135_ (.A1(net37),
    .A2(_047_),
    .A3(_049_),
    .B1(net5),
    .Y(_040_));
 sky130_fd_sc_hd__o21ai_1 _136_ (.A1(_067_),
    .A2(_040_),
    .B1(_061_),
    .Y(_017_));
 sky130_fd_sc_hd__nor2_1 _137_ (.A(net4),
    .B(_000_),
    .Y(_041_));
 sky130_fd_sc_hd__o21ai_1 _138_ (.A1(_063_),
    .A2(_041_),
    .B1(_061_),
    .Y(_018_));
 sky130_fd_sc_hd__a211o_1 _139_ (.A1(net22),
    .A2(_030_),
    .B1(_031_),
    .C1(net33),
    .X(_019_));
 sky130_fd_sc_hd__a211o_1 _140_ (.A1(net21),
    .A2(_026_),
    .B1(_027_),
    .C1(net33),
    .X(_020_));
 sky130_fd_sc_hd__a211o_1 _141_ (.A1(net20),
    .A2(_069_),
    .B1(_070_),
    .C1(net33),
    .X(_021_));
 sky130_fd_sc_hd__mux2_1 _142_ (.A0(net19),
    .A1(net42),
    .S(_059_),
    .X(_042_));
 sky130_fd_sc_hd__or2_1 _143_ (.A(net33),
    .B(_042_),
    .X(_022_));
 sky130_fd_sc_hd__o21a_1 _144_ (.A1(_050_),
    .A2(_054_),
    .B1(net18),
    .X(_043_));
 sky130_fd_sc_hd__or3_1 _145_ (.A(net33),
    .B(_066_),
    .C(_043_),
    .X(_023_));
 sky130_fd_sc_hd__o31a_1 _146_ (.A1(_046_),
    .A2(\state[1] ),
    .A3(_050_),
    .B1(net17),
    .X(_044_));
 sky130_fd_sc_hd__or3_1 _147_ (.A(net33),
    .B(_067_),
    .C(_044_),
    .X(_024_));
 sky130_fd_sc_hd__and2b_1 _148_ (.A_N(_000_),
    .B(net16),
    .X(_045_));
 sky130_fd_sc_hd__or3_1 _149_ (.A(net33),
    .B(_063_),
    .C(_045_),
    .X(_025_));
 sky130_fd_sc_hd__dfrtp_1 _150_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_001_),
    .RESET_B(net41),
    .Q(net24));
 sky130_fd_sc_hd__dfrtp_1 _151_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_002_),
    .RESET_B(net9),
    .Q(net26));
 sky130_fd_sc_hd__dfrtp_1 _152_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_003_),
    .RESET_B(net9),
    .Q(net25));
 sky130_fd_sc_hd__dfrtp_1 _153_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_004_),
    .RESET_B(net41),
    .Q(net28));
 sky130_fd_sc_hd__dfstp_1 _154_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_005_),
    .SET_B(net11),
    .Q(net13));
 sky130_fd_sc_hd__dfrtp_1 _155_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_006_),
    .RESET_B(net41),
    .Q(net27));
 sky130_fd_sc_hd__dfstp_1 _156_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_007_),
    .SET_B(net11),
    .Q(net14));
 sky130_fd_sc_hd__dfrtp_4 _157_ (.CLK(clknet_2_3__leaf_clk_regs),
    .D(\:61.Y[0] ),
    .RESET_B(net10),
    .Q(\state[0] ));
 sky130_fd_sc_hd__dfrtp_4 _158_ (.CLK(clknet_2_3__leaf_clk_regs),
    .D(\:61.Y[1] ),
    .RESET_B(net10),
    .Q(\state[1] ));
 sky130_fd_sc_hd__dfrtp_4 _159_ (.CLK(clknet_2_3__leaf_clk_regs),
    .D(\:61.Y[2] ),
    .RESET_B(net10),
    .Q(\state[2] ));
 sky130_fd_sc_hd__dfrtp_4 _160_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(\:61.Y[3] ),
    .RESET_B(net40),
    .Q(\state[3] ));
 sky130_fd_sc_hd__dfrtp_4 _161_ (.CLK(clknet_2_3__leaf_clk_regs),
    .D(_008_),
    .RESET_B(net11),
    .Q(net38));
 sky130_fd_sc_hd__dfstp_1 _162_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_009_),
    .SET_B(net10),
    .Q(net23));
 sky130_fd_sc_hd__dfstp_1 _163_ (.CLK(clknet_2_3__leaf_clk_regs),
    .D(_010_),
    .SET_B(net11),
    .Q(net15));
 sky130_fd_sc_hd__dfrtp_1 _164_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_000_),
    .RESET_B(net2),
    .Q(net32));
 sky130_fd_sc_hd__dfstp_1 _165_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_011_),
    .SET_B(net11),
    .Q(net8));
 sky130_fd_sc_hd__dfrtp_1 _166_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_012_),
    .RESET_B(net12),
    .Q(net29));
 sky130_fd_sc_hd__dfstp_1 _167_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_013_),
    .SET_B(net40),
    .Q(net7));
 sky130_fd_sc_hd__dfrtp_1 _168_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_014_),
    .RESET_B(net12),
    .Q(net30));
 sky130_fd_sc_hd__dfrtp_1 _169_ (.CLK(clknet_2_1__leaf_clk_regs),
    .D(_015_),
    .RESET_B(net2),
    .Q(net31));
 sky130_fd_sc_hd__dfstp_1 _170_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_016_),
    .SET_B(net40),
    .Q(net6));
 sky130_fd_sc_hd__dfstp_1 _171_ (.CLK(clknet_2_2__leaf_clk_regs),
    .D(_017_),
    .SET_B(net40),
    .Q(net5));
 sky130_fd_sc_hd__dfstp_1 _172_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_018_),
    .SET_B(net40),
    .Q(net4));
 sky130_fd_sc_hd__dfstp_1 _173_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_019_),
    .SET_B(net40),
    .Q(net22));
 sky130_fd_sc_hd__dfstp_1 _174_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_020_),
    .SET_B(net41),
    .Q(net21));
 sky130_fd_sc_hd__dfstp_1 _175_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_021_),
    .SET_B(net41),
    .Q(net20));
 sky130_fd_sc_hd__dfstp_1 _176_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_022_),
    .SET_B(net41),
    .Q(net19));
 sky130_fd_sc_hd__dfstp_1 _177_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_023_),
    .SET_B(net9),
    .Q(net18));
 sky130_fd_sc_hd__dfstp_1 _178_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_024_),
    .SET_B(net9),
    .Q(net17));
 sky130_fd_sc_hd__dfstp_1 _179_ (.CLK(clknet_2_0__leaf_clk_regs),
    .D(_025_),
    .SET_B(net12),
    .Q(net16));
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Right_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Right_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Right_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Right_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Right_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Right_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Right_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_21_Right_21 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_22_Right_22 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_23_Right_23 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_24_Right_24 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_25 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_26 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_27 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_28 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_29 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_30 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_31 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_32 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_33 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_34 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_35 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Left_36 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Left_37 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Left_38 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Left_39 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Left_40 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Left_41 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Left_42 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Left_43 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Left_44 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Left_45 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_21_Left_46 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_22_Left_47 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_23_Left_48 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_24_Left_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_88 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_89 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_90 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_91 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_92 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_93 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_94 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_95 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_96 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_97 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_98 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_99 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_100 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_101 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_102 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_103 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_104 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_105 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_21_106 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_107 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_108 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_22_109 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_110 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_23_111 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_112 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_113 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_114 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_115 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_24_116 ();
 sky130_fd_sc_hd__clkbuf_1 input1 (.A(out_comp_p),
    .X(net1));
 sky130_fd_sc_hd__buf_1 place33 (.A(_060_),
    .X(net33));
 sky130_fd_sc_hd__clkbuf_1 output4 (.A(net4),
    .X(dac_n[0]));
 sky130_fd_sc_hd__buf_1 place34 (.A(\state[3] ),
    .X(net34));
 sky130_fd_sc_hd__buf_1 place35 (.A(\state[2] ),
    .X(net35));
 sky130_fd_sc_hd__buf_1 output3 (.A(net3),
    .X(clk_comp));
 sky130_fd_sc_hd__buf_1 place36 (.A(\state[1] ),
    .X(net36));
 sky130_fd_sc_hd__buf_1 input2 (.A(rst_n),
    .X(net2));
 sky130_fd_sc_hd__clkbuf_1 fanout9 (.A(net12),
    .X(net9));
 sky130_fd_sc_hd__clkbuf_1 fanout10 (.A(net11),
    .X(net10));
 sky130_fd_sc_hd__buf_1 fanout11 (.A(net12),
    .X(net11));
 sky130_fd_sc_hd__buf_1 fanout12 (.A(net2),
    .X(net12));
 sky130_fd_sc_hd__buf_1 place37 (.A(\state[0] ),
    .X(net37));
 sky130_fd_sc_hd__clkbuf_1 output5 (.A(net5),
    .X(dac_n[1]));
 sky130_fd_sc_hd__clkbuf_1 output6 (.A(net6),
    .X(dac_n[2]));
 sky130_fd_sc_hd__clkbuf_1 output7 (.A(net7),
    .X(dac_n[3]));
 sky130_fd_sc_hd__clkbuf_1 output8 (.A(net8),
    .X(dac_n[4]));
 sky130_fd_sc_hd__clkbuf_1 output9 (.A(net13),
    .X(dac_n[5]));
 sky130_fd_sc_hd__clkbuf_1 output10 (.A(net14),
    .X(dac_n[6]));
 sky130_fd_sc_hd__clkbuf_1 output11 (.A(net15),
    .X(dac_n[7]));
 sky130_fd_sc_hd__clkbuf_1 output12 (.A(net16),
    .X(dac_p[0]));
 sky130_fd_sc_hd__clkbuf_1 output13 (.A(net17),
    .X(dac_p[1]));
 sky130_fd_sc_hd__clkbuf_1 output14 (.A(net18),
    .X(dac_p[2]));
 sky130_fd_sc_hd__clkbuf_1 output15 (.A(net19),
    .X(dac_p[3]));
 sky130_fd_sc_hd__clkbuf_1 output16 (.A(net20),
    .X(dac_p[4]));
 sky130_fd_sc_hd__clkbuf_1 output17 (.A(net21),
    .X(dac_p[5]));
 sky130_fd_sc_hd__clkbuf_1 output18 (.A(net22),
    .X(dac_p[6]));
 sky130_fd_sc_hd__clkbuf_1 output19 (.A(net23),
    .X(dac_p[7]));
 sky130_fd_sc_hd__clkbuf_1 output20 (.A(net24),
    .X(dout[0]));
 sky130_fd_sc_hd__clkbuf_1 output21 (.A(net25),
    .X(dout[1]));
 sky130_fd_sc_hd__clkbuf_1 output22 (.A(net26),
    .X(dout[2]));
 sky130_fd_sc_hd__clkbuf_1 output23 (.A(net27),
    .X(dout[3]));
 sky130_fd_sc_hd__clkbuf_1 output24 (.A(net28),
    .X(dout[4]));
 sky130_fd_sc_hd__clkbuf_1 output25 (.A(net29),
    .X(dout[5]));
 sky130_fd_sc_hd__clkbuf_1 output26 (.A(net30),
    .X(dout[6]));
 sky130_fd_sc_hd__clkbuf_1 output27 (.A(net31),
    .X(dout[7]));
 sky130_fd_sc_hd__clkbuf_1 output28 (.A(net32),
    .X(eoc));
 sky130_fd_sc_hd__clkbuf_1 output29 (.A(net38),
    .X(phi_sample));
 sky130_fd_sc_hd__clkbuf_1 output30 (.A(net39),
    .X(phi_sample_n));
 sky130_fd_sc_hd__clkbuf_2 max_cap31 (.A(net10),
    .X(net40));
 sky130_fd_sc_hd__clkbuf_2 max_cap32 (.A(net9),
    .X(net41));
 sky130_fd_sc_hd__buf_2 max_cap33 (.A(net1),
    .X(net42));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_regs_0_clk (.A(clk),
    .X(clk_regs));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk_regs (.A(clk_regs),
    .X(clknet_0_clk_regs));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_0__f_clk_regs (.A(clknet_0_clk_regs),
    .X(clknet_2_0__leaf_clk_regs));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_1__f_clk_regs (.A(clknet_0_clk_regs),
    .X(clknet_2_1__leaf_clk_regs));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_2__f_clk_regs (.A(clknet_0_clk_regs),
    .X(clknet_2_2__leaf_clk_regs));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_2_3__f_clk_regs (.A(clknet_0_clk_regs),
    .X(clknet_2_3__leaf_clk_regs));
 sky130_fd_sc_hd__clkinv_1 clkload0 (.A(clknet_2_1__leaf_clk_regs));
 sky130_fd_sc_hd__clkinv_2 clkload1 (.A(clknet_2_2__leaf_clk_regs));
 sky130_fd_sc_hd__inv_4 clkload2 (.A(clknet_2_3__leaf_clk_regs));
endmodule

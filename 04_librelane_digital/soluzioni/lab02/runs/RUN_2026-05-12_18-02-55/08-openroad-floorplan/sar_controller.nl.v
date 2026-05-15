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
 wire \state[0] ;
 wire \state[1] ;
 wire \state[2] ;
 wire \state[3] ;

 sky130_fd_sc_hd__inv_2 _072_ (.A(\state[0] ),
    .Y(_046_));
 sky130_fd_sc_hd__inv_2 _073_ (.A(\state[1] ),
    .Y(_047_));
 sky130_fd_sc_hd__inv_2 _074_ (.A(out_comp_p),
    .Y(_048_));
 sky130_fd_sc_hd__inv_2 _075_ (.A(phi_sample),
    .Y(phi_sample_n));
 sky130_fd_sc_hd__and2b_2 _076_ (.A_N(\state[2] ),
    .B(\state[3] ),
    .X(_049_));
 sky130_fd_sc_hd__nand2b_2 _077_ (.A_N(\state[2] ),
    .B(\state[3] ),
    .Y(_050_));
 sky130_fd_sc_hd__and4bb_2 _078_ (.A_N(\state[0] ),
    .B_N(\state[2] ),
    .C(\state[3] ),
    .D(\state[1] ),
    .X(_000_));
 sky130_fd_sc_hd__a21oi_2 _079_ (.A1(\state[2] ),
    .A2(\state[3] ),
    .B1(\state[0] ),
    .Y(\:61.Y[0] ));
 sky130_fd_sc_hd__nand2_2 _080_ (.A(\state[0] ),
    .B(\state[1] ),
    .Y(_051_));
 sky130_fd_sc_hd__o21ai_2 _081_ (.A1(\state[1] ),
    .A2(\state[2] ),
    .B1(\state[3] ),
    .Y(_052_));
 sky130_fd_sc_hd__nor2_2 _082_ (.A(\state[0] ),
    .B(\state[1] ),
    .Y(_053_));
 sky130_fd_sc_hd__or2_2 _083_ (.A(\state[0] ),
    .B(\state[1] ),
    .X(_054_));
 sky130_fd_sc_hd__and3_2 _084_ (.A(_051_),
    .B(_052_),
    .C(_054_),
    .X(\:61.Y[1] ));
 sky130_fd_sc_hd__or2_2 _085_ (.A(\state[2] ),
    .B(\state[3] ),
    .X(_055_));
 sky130_fd_sc_hd__and4bb_2 _086_ (.A_N(\state[2] ),
    .B_N(\state[3] ),
    .C(\state[0] ),
    .D(\state[1] ),
    .X(_056_));
 sky130_fd_sc_hd__or2_2 _087_ (.A(_051_),
    .B(_055_),
    .X(_057_));
 sky130_fd_sc_hd__and2b_2 _088_ (.A_N(\state[3] ),
    .B(\state[2] ),
    .X(_058_));
 sky130_fd_sc_hd__a21o_2 _089_ (.A1(_051_),
    .A2(_058_),
    .B1(_056_),
    .X(\:61.Y[2] ));
 sky130_fd_sc_hd__and4b_2 _090_ (.A_N(\state[3] ),
    .B(\state[2] ),
    .C(\state[1] ),
    .D(\state[0] ),
    .X(_059_));
 sky130_fd_sc_hd__a21o_2 _091_ (.A1(_047_),
    .A2(_049_),
    .B1(_059_),
    .X(\:61.Y[3] ));
 sky130_fd_sc_hd__nor2_2 _092_ (.A(phi_sample),
    .B(clk),
    .Y(clk_comp));
 sky130_fd_sc_hd__nor2_2 _093_ (.A(\state[1] ),
    .B(_055_),
    .Y(_060_));
 sky130_fd_sc_hd__or3_2 _094_ (.A(\state[1] ),
    .B(\state[2] ),
    .C(\state[3] ),
    .X(_061_));
 sky130_fd_sc_hd__or2_2 _095_ (.A(\state[0] ),
    .B(_061_),
    .X(_062_));
 sky130_fd_sc_hd__and2_2 _096_ (.A(out_comp_p),
    .B(_000_),
    .X(_063_));
 sky130_fd_sc_hd__and2b_2 _097_ (.A_N(_000_),
    .B(dout[0]),
    .X(_064_));
 sky130_fd_sc_hd__o21a_2 _098_ (.A1(_063_),
    .A2(_064_),
    .B1(_062_),
    .X(_001_));
 sky130_fd_sc_hd__o21a_2 _099_ (.A1(\state[2] ),
    .A2(_054_),
    .B1(dout[2]),
    .X(_065_));
 sky130_fd_sc_hd__and3_2 _100_ (.A(out_comp_p),
    .B(_049_),
    .C(_053_),
    .X(_066_));
 sky130_fd_sc_hd__or2_2 _101_ (.A(_065_),
    .B(_066_),
    .X(_002_));
 sky130_fd_sc_hd__and4_2 _102_ (.A(\state[0] ),
    .B(_047_),
    .C(out_comp_p),
    .D(_049_),
    .X(_067_));
 sky130_fd_sc_hd__o31a_2 _103_ (.A1(_046_),
    .A2(\state[1] ),
    .A3(_050_),
    .B1(dout[1]),
    .X(_068_));
 sky130_fd_sc_hd__o21a_2 _104_ (.A1(_067_),
    .A2(_068_),
    .B1(_062_),
    .X(_003_));
 sky130_fd_sc_hd__or4bb_2 _105_ (.A(\state[0] ),
    .B(\state[3] ),
    .C_N(\state[2] ),
    .D_N(\state[1] ),
    .X(_069_));
 sky130_fd_sc_hd__nor2_2 _106_ (.A(_048_),
    .B(_069_),
    .Y(_070_));
 sky130_fd_sc_hd__mux2_1 _107_ (.A0(out_comp_p),
    .A1(dout[4]),
    .S(_069_),
    .X(_071_));
 sky130_fd_sc_hd__and2_2 _108_ (.A(_062_),
    .B(_071_),
    .X(_004_));
 sky130_fd_sc_hd__or4bb_2 _109_ (.A(\state[1] ),
    .B(\state[3] ),
    .C_N(\state[2] ),
    .D_N(\state[0] ),
    .X(_026_));
 sky130_fd_sc_hd__nor2_2 _110_ (.A(_048_),
    .B(_026_),
    .Y(_027_));
 sky130_fd_sc_hd__mux2_1 _111_ (.A0(_048_),
    .A1(dac_n[5]),
    .S(_026_),
    .X(_028_));
 sky130_fd_sc_hd__or2_2 _112_ (.A(_060_),
    .B(_028_),
    .X(_005_));
 sky130_fd_sc_hd__mux2_1 _113_ (.A0(dout[3]),
    .A1(out_comp_p),
    .S(_059_),
    .X(_029_));
 sky130_fd_sc_hd__and2_2 _114_ (.A(_062_),
    .B(_029_),
    .X(_006_));
 sky130_fd_sc_hd__or4b_2 _115_ (.A(\state[0] ),
    .B(\state[1] ),
    .C(\state[3] ),
    .D_N(\state[2] ),
    .X(_030_));
 sky130_fd_sc_hd__nor2_2 _116_ (.A(_048_),
    .B(_030_),
    .Y(_031_));
 sky130_fd_sc_hd__mux2_1 _117_ (.A0(_048_),
    .A1(dac_n[6]),
    .S(_030_),
    .X(_032_));
 sky130_fd_sc_hd__or2_2 _118_ (.A(_060_),
    .B(_032_),
    .X(_007_));
 sky130_fd_sc_hd__o22a_2 _119_ (.A1(\state[0] ),
    .A2(_055_),
    .B1(_060_),
    .B2(phi_sample),
    .X(_008_));
 sky130_fd_sc_hd__a21oi_2 _120_ (.A1(_046_),
    .A2(\state[1] ),
    .B1(_055_),
    .Y(_033_));
 sky130_fd_sc_hd__o22a_2 _121_ (.A1(out_comp_p),
    .A2(_057_),
    .B1(_033_),
    .B2(dac_p[7]),
    .X(_009_));
 sky130_fd_sc_hd__and2_2 _122_ (.A(out_comp_p),
    .B(_056_),
    .X(_034_));
 sky130_fd_sc_hd__o21ba_2 _123_ (.A1(dac_n[7]),
    .A2(_033_),
    .B1_N(_034_),
    .X(_010_));
 sky130_fd_sc_hd__mux2_1 _124_ (.A0(_048_),
    .A1(dac_n[4]),
    .S(_069_),
    .X(_035_));
 sky130_fd_sc_hd__or2_2 _125_ (.A(_060_),
    .B(_035_),
    .X(_011_));
 sky130_fd_sc_hd__mux2_1 _126_ (.A0(out_comp_p),
    .A1(dout[5]),
    .S(_026_),
    .X(_036_));
 sky130_fd_sc_hd__and2_2 _127_ (.A(_062_),
    .B(_036_),
    .X(_012_));
 sky130_fd_sc_hd__mux2_1 _128_ (.A0(dac_n[3]),
    .A1(_048_),
    .S(_059_),
    .X(_037_));
 sky130_fd_sc_hd__or2_2 _129_ (.A(_060_),
    .B(_037_),
    .X(_013_));
 sky130_fd_sc_hd__o21a_2 _130_ (.A1(\state[3] ),
    .A2(_054_),
    .B1(dout[6]),
    .X(_038_));
 sky130_fd_sc_hd__or2_2 _131_ (.A(_031_),
    .B(_038_),
    .X(_014_));
 sky130_fd_sc_hd__a31o_2 _132_ (.A1(dout[7]),
    .A2(_057_),
    .A3(_062_),
    .B1(_034_),
    .X(_015_));
 sky130_fd_sc_hd__a21oi_2 _133_ (.A1(_049_),
    .A2(_053_),
    .B1(dac_n[2]),
    .Y(_039_));
 sky130_fd_sc_hd__o21ai_2 _134_ (.A1(_066_),
    .A2(_039_),
    .B1(_061_),
    .Y(_016_));
 sky130_fd_sc_hd__a31oi_2 _135_ (.A1(\state[0] ),
    .A2(_047_),
    .A3(_049_),
    .B1(dac_n[1]),
    .Y(_040_));
 sky130_fd_sc_hd__o21ai_2 _136_ (.A1(_067_),
    .A2(_040_),
    .B1(_061_),
    .Y(_017_));
 sky130_fd_sc_hd__nor2_2 _137_ (.A(dac_n[0]),
    .B(_000_),
    .Y(_041_));
 sky130_fd_sc_hd__o21ai_2 _138_ (.A1(_063_),
    .A2(_041_),
    .B1(_061_),
    .Y(_018_));
 sky130_fd_sc_hd__a211o_2 _139_ (.A1(dac_p[6]),
    .A2(_030_),
    .B1(_031_),
    .C1(_060_),
    .X(_019_));
 sky130_fd_sc_hd__a211o_2 _140_ (.A1(dac_p[5]),
    .A2(_026_),
    .B1(_027_),
    .C1(_060_),
    .X(_020_));
 sky130_fd_sc_hd__a211o_2 _141_ (.A1(dac_p[4]),
    .A2(_069_),
    .B1(_070_),
    .C1(_060_),
    .X(_021_));
 sky130_fd_sc_hd__mux2_1 _142_ (.A0(dac_p[3]),
    .A1(out_comp_p),
    .S(_059_),
    .X(_042_));
 sky130_fd_sc_hd__or2_2 _143_ (.A(_060_),
    .B(_042_),
    .X(_022_));
 sky130_fd_sc_hd__o21a_2 _144_ (.A1(_050_),
    .A2(_054_),
    .B1(dac_p[2]),
    .X(_043_));
 sky130_fd_sc_hd__or3_2 _145_ (.A(_060_),
    .B(_066_),
    .C(_043_),
    .X(_023_));
 sky130_fd_sc_hd__o31a_2 _146_ (.A1(_046_),
    .A2(\state[1] ),
    .A3(_050_),
    .B1(dac_p[1]),
    .X(_044_));
 sky130_fd_sc_hd__or3_2 _147_ (.A(_060_),
    .B(_067_),
    .C(_044_),
    .X(_024_));
 sky130_fd_sc_hd__and2b_2 _148_ (.A_N(_000_),
    .B(dac_p[0]),
    .X(_045_));
 sky130_fd_sc_hd__or3_2 _149_ (.A(_060_),
    .B(_063_),
    .C(_045_),
    .X(_025_));
 sky130_fd_sc_hd__dfrtp_2 _150_ (.CLK(clk),
    .D(_001_),
    .RESET_B(rst_n),
    .Q(dout[0]));
 sky130_fd_sc_hd__dfrtp_2 _151_ (.CLK(clk),
    .D(_002_),
    .RESET_B(rst_n),
    .Q(dout[2]));
 sky130_fd_sc_hd__dfrtp_2 _152_ (.CLK(clk),
    .D(_003_),
    .RESET_B(rst_n),
    .Q(dout[1]));
 sky130_fd_sc_hd__dfrtp_2 _153_ (.CLK(clk),
    .D(_004_),
    .RESET_B(rst_n),
    .Q(dout[4]));
 sky130_fd_sc_hd__dfstp_2 _154_ (.CLK(clk),
    .D(_005_),
    .SET_B(rst_n),
    .Q(dac_n[5]));
 sky130_fd_sc_hd__dfrtp_2 _155_ (.CLK(clk),
    .D(_006_),
    .RESET_B(rst_n),
    .Q(dout[3]));
 sky130_fd_sc_hd__dfstp_2 _156_ (.CLK(clk),
    .D(_007_),
    .SET_B(rst_n),
    .Q(dac_n[6]));
 sky130_fd_sc_hd__dfrtp_2 _157_ (.CLK(clk),
    .D(\:61.Y[0] ),
    .RESET_B(rst_n),
    .Q(\state[0] ));
 sky130_fd_sc_hd__dfrtp_2 _158_ (.CLK(clk),
    .D(\:61.Y[1] ),
    .RESET_B(rst_n),
    .Q(\state[1] ));
 sky130_fd_sc_hd__dfrtp_2 _159_ (.CLK(clk),
    .D(\:61.Y[2] ),
    .RESET_B(rst_n),
    .Q(\state[2] ));
 sky130_fd_sc_hd__dfrtp_2 _160_ (.CLK(clk),
    .D(\:61.Y[3] ),
    .RESET_B(rst_n),
    .Q(\state[3] ));
 sky130_fd_sc_hd__dfrtp_2 _161_ (.CLK(clk),
    .D(_008_),
    .RESET_B(rst_n),
    .Q(phi_sample));
 sky130_fd_sc_hd__dfstp_2 _162_ (.CLK(clk),
    .D(_009_),
    .SET_B(rst_n),
    .Q(dac_p[7]));
 sky130_fd_sc_hd__dfstp_2 _163_ (.CLK(clk),
    .D(_010_),
    .SET_B(rst_n),
    .Q(dac_n[7]));
 sky130_fd_sc_hd__dfrtp_2 _164_ (.CLK(clk),
    .D(_000_),
    .RESET_B(rst_n),
    .Q(eoc));
 sky130_fd_sc_hd__dfstp_2 _165_ (.CLK(clk),
    .D(_011_),
    .SET_B(rst_n),
    .Q(dac_n[4]));
 sky130_fd_sc_hd__dfrtp_2 _166_ (.CLK(clk),
    .D(_012_),
    .RESET_B(rst_n),
    .Q(dout[5]));
 sky130_fd_sc_hd__dfstp_2 _167_ (.CLK(clk),
    .D(_013_),
    .SET_B(rst_n),
    .Q(dac_n[3]));
 sky130_fd_sc_hd__dfrtp_2 _168_ (.CLK(clk),
    .D(_014_),
    .RESET_B(rst_n),
    .Q(dout[6]));
 sky130_fd_sc_hd__dfrtp_2 _169_ (.CLK(clk),
    .D(_015_),
    .RESET_B(rst_n),
    .Q(dout[7]));
 sky130_fd_sc_hd__dfstp_2 _170_ (.CLK(clk),
    .D(_016_),
    .SET_B(rst_n),
    .Q(dac_n[2]));
 sky130_fd_sc_hd__dfstp_2 _171_ (.CLK(clk),
    .D(_017_),
    .SET_B(rst_n),
    .Q(dac_n[1]));
 sky130_fd_sc_hd__dfstp_2 _172_ (.CLK(clk),
    .D(_018_),
    .SET_B(rst_n),
    .Q(dac_n[0]));
 sky130_fd_sc_hd__dfstp_2 _173_ (.CLK(clk),
    .D(_019_),
    .SET_B(rst_n),
    .Q(dac_p[6]));
 sky130_fd_sc_hd__dfstp_2 _174_ (.CLK(clk),
    .D(_020_),
    .SET_B(rst_n),
    .Q(dac_p[5]));
 sky130_fd_sc_hd__dfstp_2 _175_ (.CLK(clk),
    .D(_021_),
    .SET_B(rst_n),
    .Q(dac_p[4]));
 sky130_fd_sc_hd__dfstp_2 _176_ (.CLK(clk),
    .D(_022_),
    .SET_B(rst_n),
    .Q(dac_p[3]));
 sky130_fd_sc_hd__dfstp_2 _177_ (.CLK(clk),
    .D(_023_),
    .SET_B(rst_n),
    .Q(dac_p[2]));
 sky130_fd_sc_hd__dfstp_2 _178_ (.CLK(clk),
    .D(_024_),
    .SET_B(rst_n),
    .Q(dac_p[1]));
 sky130_fd_sc_hd__dfstp_2 _179_ (.CLK(clk),
    .D(_025_),
    .SET_B(rst_n),
    .Q(dac_p[0]));
endmodule

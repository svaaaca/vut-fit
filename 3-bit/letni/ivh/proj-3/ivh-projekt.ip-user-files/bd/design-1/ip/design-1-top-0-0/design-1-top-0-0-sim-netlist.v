// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Fri May  3 18:49:37 2024
// Host        : DESKTOP-MHH9EC6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/lubos/ivh_projekt/ivh_projekt.gen/sources_1/bd/design_1/ip/design_1_top_0_0/design_1_top_0_0_sim_netlist.v
// Design      : design_1_top_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_1_top_0_0,top,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* ip_definition_source = "module_ref" *) 
(* x_core_info = "top,Vivado 2023.2" *) 
(* NotValidForBitStream *)
module design_1_top_0_0
   (clk,
    row,
    col);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input clk;
  output [7:0]row;
  output [7:0]col;

  wire \<const0> ;
  wire \<const1> ;
  wire clk;
  wire [7:0]col;

  assign row[7] = \<const1> ;
  assign row[6] = \<const1> ;
  assign row[5] = \<const1> ;
  assign row[4] = \<const1> ;
  assign row[3] = \<const1> ;
  assign row[2] = \<const1> ;
  assign row[1] = \<const1> ;
  assign row[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  design_1_top_0_0_top U0
       (.clk(clk),
        .col(col));
  VCC VCC
       (.P(\<const1> ));
endmodule

(* ORIG_REF_NAME = "top" *) 
module design_1_top_0_0_top
   (col,
    clk);
  output [7:0]col;
  input clk;

  wire clk;
  wire [24:0]cnt;
  wire cnt0_carry__0_n_0;
  wire cnt0_carry__0_n_1;
  wire cnt0_carry__0_n_2;
  wire cnt0_carry__0_n_3;
  wire cnt0_carry__1_n_0;
  wire cnt0_carry__1_n_1;
  wire cnt0_carry__1_n_2;
  wire cnt0_carry__1_n_3;
  wire cnt0_carry__2_n_0;
  wire cnt0_carry__2_n_1;
  wire cnt0_carry__2_n_2;
  wire cnt0_carry__2_n_3;
  wire cnt0_carry__3_n_0;
  wire cnt0_carry__3_n_1;
  wire cnt0_carry__3_n_2;
  wire cnt0_carry__3_n_3;
  wire cnt0_carry__4_n_1;
  wire cnt0_carry__4_n_2;
  wire cnt0_carry__4_n_3;
  wire cnt0_carry_n_0;
  wire cnt0_carry_n_1;
  wire cnt0_carry_n_2;
  wire cnt0_carry_n_3;
  wire [0:0]cnt_0;
  wire [7:0]col;
  wire \col_select[7]_i_1_n_0 ;
  wire \col_select[7]_i_3_n_0 ;
  wire \col_select[7]_i_4_n_0 ;
  wire \col_select[7]_i_5_n_0 ;
  wire \col_select[7]_i_6_n_0 ;
  wire \col_select[7]_i_7_n_0 ;
  wire \col_select[7]_i_8_n_0 ;
  wire [24:1]data0;
  wire [7:0]p_0_in;
  wire [3:3]NLW_cnt0_carry__4_CO_UNCONNECTED;

  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry
       (.CI(1'b0),
        .CO({cnt0_carry_n_0,cnt0_carry_n_1,cnt0_carry_n_2,cnt0_carry_n_3}),
        .CYINIT(cnt[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[4:1]),
        .S(cnt[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__0
       (.CI(cnt0_carry_n_0),
        .CO({cnt0_carry__0_n_0,cnt0_carry__0_n_1,cnt0_carry__0_n_2,cnt0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[8:5]),
        .S(cnt[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__1
       (.CI(cnt0_carry__0_n_0),
        .CO({cnt0_carry__1_n_0,cnt0_carry__1_n_1,cnt0_carry__1_n_2,cnt0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[12:9]),
        .S(cnt[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__2
       (.CI(cnt0_carry__1_n_0),
        .CO({cnt0_carry__2_n_0,cnt0_carry__2_n_1,cnt0_carry__2_n_2,cnt0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[16:13]),
        .S(cnt[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__3
       (.CI(cnt0_carry__2_n_0),
        .CO({cnt0_carry__3_n_0,cnt0_carry__3_n_1,cnt0_carry__3_n_2,cnt0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[20:17]),
        .S(cnt[20:17]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__4
       (.CI(cnt0_carry__3_n_0),
        .CO({NLW_cnt0_carry__4_CO_UNCONNECTED[3],cnt0_carry__4_n_1,cnt0_carry__4_n_2,cnt0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(data0[24:21]),
        .S(cnt[24:21]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \cnt[0]_i_1 
       (.I0(cnt[0]),
        .O(cnt_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_0),
        .Q(cnt[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[10]),
        .Q(cnt[10]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[11]),
        .Q(cnt[11]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[12]),
        .Q(cnt[12]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[13]),
        .Q(cnt[13]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[14]),
        .Q(cnt[14]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[15]),
        .Q(cnt[15]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[16]),
        .Q(cnt[16]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[17]),
        .Q(cnt[17]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[18]),
        .Q(cnt[18]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[19]),
        .Q(cnt[19]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[1]),
        .Q(cnt[1]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[20]),
        .Q(cnt[20]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[21]),
        .Q(cnt[21]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[22]),
        .Q(cnt[22]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[23]),
        .Q(cnt[23]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[24]),
        .Q(cnt[24]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[2]),
        .Q(cnt[2]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[3]),
        .Q(cnt[3]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[4]),
        .Q(cnt[4]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[5]),
        .Q(cnt[5]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[6]),
        .Q(cnt[6]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[7]),
        .Q(cnt[7]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[8]),
        .Q(cnt[8]),
        .R(\col_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(data0[9]),
        .Q(cnt[9]),
        .R(\col_select[7]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[0]_i_1 
       (.I0(col[0]),
        .O(p_0_in[0]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[1]_i_1 
       (.I0(col[1]),
        .O(p_0_in[1]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[2]_i_1 
       (.I0(col[2]),
        .O(p_0_in[2]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[3]_i_1 
       (.I0(col[3]),
        .O(p_0_in[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[4]_i_1 
       (.I0(col[4]),
        .O(p_0_in[4]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[5]_i_1 
       (.I0(col[5]),
        .O(p_0_in[5]));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[6]_i_1 
       (.I0(col[6]),
        .O(p_0_in[6]));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \col_select[7]_i_1 
       (.I0(\col_select[7]_i_3_n_0 ),
        .I1(\col_select[7]_i_4_n_0 ),
        .I2(\col_select[7]_i_5_n_0 ),
        .I3(\col_select[7]_i_6_n_0 ),
        .I4(\col_select[7]_i_7_n_0 ),
        .I5(\col_select[7]_i_8_n_0 ),
        .O(\col_select[7]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \col_select[7]_i_2 
       (.I0(col[7]),
        .O(p_0_in[7]));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \col_select[7]_i_3 
       (.I0(cnt[16]),
        .I1(cnt[15]),
        .I2(cnt[18]),
        .I3(cnt[17]),
        .O(\col_select[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \col_select[7]_i_4 
       (.I0(cnt[20]),
        .I1(cnt[19]),
        .I2(cnt[22]),
        .I3(cnt[21]),
        .O(\col_select[7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \col_select[7]_i_5 
       (.I0(cnt[8]),
        .I1(cnt[7]),
        .I2(cnt[10]),
        .I3(cnt[9]),
        .O(\col_select[7]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \col_select[7]_i_6 
       (.I0(cnt[12]),
        .I1(cnt[11]),
        .I2(cnt[14]),
        .I3(cnt[13]),
        .O(\col_select[7]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \col_select[7]_i_7 
       (.I0(cnt[4]),
        .I1(cnt[3]),
        .I2(cnt[5]),
        .I3(cnt[6]),
        .O(\col_select[7]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hDFFFFFFF)) 
    \col_select[7]_i_8 
       (.I0(cnt[0]),
        .I1(cnt[23]),
        .I2(cnt[24]),
        .I3(cnt[2]),
        .I4(cnt[1]),
        .O(\col_select[7]_i_8_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \col_select_reg[0] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[0]),
        .Q(col[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \col_select_reg[1] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[1]),
        .Q(col[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \col_select_reg[2] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[2]),
        .Q(col[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \col_select_reg[3] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[3]),
        .Q(col[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \col_select_reg[4] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[4]),
        .Q(col[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \col_select_reg[5] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[5]),
        .Q(col[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \col_select_reg[6] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[6]),
        .Q(col[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \col_select_reg[7] 
       (.C(clk),
        .CE(\col_select[7]_i_1_n_0 ),
        .D(p_0_in[7]),
        .Q(col[7]),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif

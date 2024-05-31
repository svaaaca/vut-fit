// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Tue May 14 17:36:01 2024
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
    col,
    led,
    row);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *) input clk;
  output [7:0]col;
  output [3:0]led;
  output [7:0]row;

  wire \<const0> ;
  wire clk;
  wire [7:0]col;
  wire [7:0]row;

  assign led[3] = \<const0> ;
  assign led[2] = \<const0> ;
  assign led[1] = \<const0> ;
  assign led[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  design_1_top_0_0_top U0
       (.Q(row),
        .clk(clk),
        .col(col));
endmodule

(* ORIG_REF_NAME = "top" *) 
module design_1_top_0_0_top
   (col,
    Q,
    clk);
  output [7:0]col;
  output [7:0]Q;
  input clk;

  wire \FSM_sequential_fsm_current_state[0]_i_10_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_11_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_12_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_13_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_14_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_15_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_16_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_17_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_2_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_3_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_4_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_5_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_6_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_7_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_8_n_0 ;
  wire \FSM_sequential_fsm_current_state[0]_i_9_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_10_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_11_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_12_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_13_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_14_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_2_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_3_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_4_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_5_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_6_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_7_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_8_n_0 ;
  wire \FSM_sequential_fsm_current_state[1]_i_9_n_0 ;
  wire [7:0]Q;
  wire cell_animation0;
  wire \cell_animation[0]_i_2_n_0 ;
  wire \cell_animation[0]_i_3_n_0 ;
  wire \cell_animation[0]_i_4_n_0 ;
  wire \cell_animation[0]_i_5_n_0 ;
  wire \cell_animation[0]_i_6_n_0 ;
  wire \cell_animation[0]_i_7_n_0 ;
  wire \cell_animation[0]_i_8_n_0 ;
  wire \cell_animation_reg[1016]_srl32_n_1 ;
  wire \cell_animation_reg[103]_srl32_n_1 ;
  wire \cell_animation_reg[1048]_srl32_n_1 ;
  wire \cell_animation_reg[143]_srl31_n_0 ;
  wire \cell_animation_reg[174]_srl32_n_1 ;
  wire \cell_animation_reg[206]_srl32_n_1 ;
  wire \cell_animation_reg[238]_srl32_n_1 ;
  wire \cell_animation_reg[278]_srl31_n_0 ;
  wire \cell_animation_reg[309]_srl32_n_1 ;
  wire \cell_animation_reg[341]_srl32_n_1 ;
  wire \cell_animation_reg[373]_srl32_n_1 ;
  wire \cell_animation_reg[39]_srl32_n_1 ;
  wire \cell_animation_reg[413]_srl31_n_0 ;
  wire \cell_animation_reg[444]_srl32_n_1 ;
  wire \cell_animation_reg[476]_srl32_n_1 ;
  wire \cell_animation_reg[508]_srl32_n_1 ;
  wire \cell_animation_reg[548]_srl31_n_0 ;
  wire \cell_animation_reg[579]_srl32_n_1 ;
  wire \cell_animation_reg[611]_srl32_n_1 ;
  wire \cell_animation_reg[643]_srl32_n_1 ;
  wire \cell_animation_reg[683]_srl31_n_0 ;
  wire \cell_animation_reg[714]_srl32_n_1 ;
  wire \cell_animation_reg[71]_srl32_n_1 ;
  wire \cell_animation_reg[746]_srl32_n_1 ;
  wire \cell_animation_reg[778]_srl32_n_1 ;
  wire \cell_animation_reg[818]_srl31_n_0 ;
  wire \cell_animation_reg[849]_srl32_n_1 ;
  wire \cell_animation_reg[881]_srl32_n_1 ;
  wire \cell_animation_reg[8]_srl31_n_0 ;
  wire \cell_animation_reg[913]_srl32_n_1 ;
  wire \cell_animation_reg[953]_srl31_n_0 ;
  wire \cell_animation_reg[984]_srl32_n_1 ;
  wire \cell_animation_reg_n_0_[0] ;
  wire \cell_animation_reg_n_0_[135] ;
  wire \cell_animation_reg_n_0_[136] ;
  wire \cell_animation_reg_n_0_[137] ;
  wire \cell_animation_reg_n_0_[138] ;
  wire \cell_animation_reg_n_0_[139] ;
  wire \cell_animation_reg_n_0_[140] ;
  wire \cell_animation_reg_n_0_[141] ;
  wire \cell_animation_reg_n_0_[142] ;
  wire \cell_animation_reg_n_0_[1] ;
  wire \cell_animation_reg_n_0_[270] ;
  wire \cell_animation_reg_n_0_[271] ;
  wire \cell_animation_reg_n_0_[272] ;
  wire \cell_animation_reg_n_0_[273] ;
  wire \cell_animation_reg_n_0_[274] ;
  wire \cell_animation_reg_n_0_[275] ;
  wire \cell_animation_reg_n_0_[276] ;
  wire \cell_animation_reg_n_0_[277] ;
  wire \cell_animation_reg_n_0_[2] ;
  wire \cell_animation_reg_n_0_[3] ;
  wire \cell_animation_reg_n_0_[405] ;
  wire \cell_animation_reg_n_0_[406] ;
  wire \cell_animation_reg_n_0_[407] ;
  wire \cell_animation_reg_n_0_[408] ;
  wire \cell_animation_reg_n_0_[409] ;
  wire \cell_animation_reg_n_0_[410] ;
  wire \cell_animation_reg_n_0_[411] ;
  wire \cell_animation_reg_n_0_[412] ;
  wire \cell_animation_reg_n_0_[4] ;
  wire \cell_animation_reg_n_0_[540] ;
  wire \cell_animation_reg_n_0_[541] ;
  wire \cell_animation_reg_n_0_[542] ;
  wire \cell_animation_reg_n_0_[543] ;
  wire \cell_animation_reg_n_0_[544] ;
  wire \cell_animation_reg_n_0_[545] ;
  wire \cell_animation_reg_n_0_[546] ;
  wire \cell_animation_reg_n_0_[547] ;
  wire \cell_animation_reg_n_0_[5] ;
  wire \cell_animation_reg_n_0_[675] ;
  wire \cell_animation_reg_n_0_[676] ;
  wire \cell_animation_reg_n_0_[677] ;
  wire \cell_animation_reg_n_0_[678] ;
  wire \cell_animation_reg_n_0_[679] ;
  wire \cell_animation_reg_n_0_[680] ;
  wire \cell_animation_reg_n_0_[681] ;
  wire \cell_animation_reg_n_0_[682] ;
  wire \cell_animation_reg_n_0_[6] ;
  wire \cell_animation_reg_n_0_[7] ;
  wire \cell_animation_reg_n_0_[810] ;
  wire \cell_animation_reg_n_0_[811] ;
  wire \cell_animation_reg_n_0_[812] ;
  wire \cell_animation_reg_n_0_[813] ;
  wire \cell_animation_reg_n_0_[814] ;
  wire \cell_animation_reg_n_0_[815] ;
  wire \cell_animation_reg_n_0_[816] ;
  wire \cell_animation_reg_n_0_[817] ;
  wire \cell_animation_reg_n_0_[946] ;
  wire \cell_animation_reg_n_0_[947] ;
  wire \cell_animation_reg_n_0_[948] ;
  wire \cell_animation_reg_n_0_[949] ;
  wire \cell_animation_reg_n_0_[950] ;
  wire \cell_animation_reg_n_0_[951] ;
  wire \cell_animation_reg_n_0_[952] ;
  wire \cell_generator[22].cell_reg[22]_i_1_n_0 ;
  wire \cell_generator[22].cell_reg_n_0_[22] ;
  wire \cell_generator[23].cell_reg[23]_i_1_n_0 ;
  wire \cell_generator[23].cell_reg_n_0_[23] ;
  wire \cell_generator[24].cell_reg[24]_i_1_n_0 ;
  wire \cell_generator[24].cell_reg_n_0_[24] ;
  wire \cell_generator[26].cell_reg[26]_i_1_n_0 ;
  wire \cell_generator[26].cell_reg_n_0_[26] ;
  wire \cell_generator[29].cell_reg[29]_i_1_n_0 ;
  wire \cell_generator[29].cell_reg_n_0_[29] ;
  wire \cell_generator[31].cell_reg[31]_i_1_n_0 ;
  wire \cell_generator[31].cell_reg_n_0_[31] ;
  wire \cell_generator[32].cell_reg[32]_i_1_n_0 ;
  wire \cell_generator[32].cell_reg_n_0_[32] ;
  wire \cell_generator[33].cell_reg[33]_i_1_n_0 ;
  wire \cell_generator[33].cell_reg_n_0_[33] ;
  wire \cell_generator[37].cell_reg[37]_i_1_n_0 ;
  wire \cell_generator[37].cell_reg_n_0_[37] ;
  wire \cell_generator[38].cell_reg[38]_i_1_n_0 ;
  wire \cell_generator[38].cell_reg_n_0_[38] ;
  wire \cell_generator[39].cell_reg[39]_i_1_n_0 ;
  wire \cell_generator[39].cell_reg_n_0_[39] ;
  wire \cell_generator[40].cell_reg[40]_i_1_n_0 ;
  wire \cell_generator[40].cell_reg_n_0_[40] ;
  wire \cell_generator[41].cell_reg[41]_i_1_n_0 ;
  wire \cell_generator[41].cell_reg_n_0_[41] ;
  wire \cell_generator[42].cell_reg[42]_i_1_n_0 ;
  wire \cell_generator[42].cell_reg_n_0_[42] ;
  wire \cell_generator[45].cell_reg[45]_i_1_n_0 ;
  wire \cell_generator[45].cell_reg_n_0_[45] ;
  wire \cell_generator[46].cell_reg[46]_i_1_n_0 ;
  wire \cell_generator[46].cell_reg_n_0_[46] ;
  wire \cell_generator[47].cell_reg[47]_i_1_n_0 ;
  wire \cell_generator[47].cell_reg_n_0_[47] ;
  wire \cell_generator[48].cell_reg[48]_i_1_n_0 ;
  wire \cell_generator[48].cell_reg_n_0_[48] ;
  wire \cell_generator[49].cell_reg[49]_i_1_n_0 ;
  wire \cell_generator[49].cell_reg_n_0_[49] ;
  wire \cell_generator[53].cell_reg[53]_i_1_n_0 ;
  wire \cell_generator[53].cell_reg_n_0_[53] ;
  wire \cell_generator[54].cell_reg[54]_i_1_n_0 ;
  wire \cell_generator[54].cell_reg_n_0_[54] ;
  wire \cell_generator[56].cell_reg[56]_i_1_n_0 ;
  wire \cell_generator[56].cell_reg_n_0_[56] ;
  wire \cell_generator[58].cell_reg[58]_i_1_n_0 ;
  wire \cell_generator[58].cell_reg[58]_i_2_n_0 ;
  wire \cell_generator[58].cell_reg_n_0_[58] ;
  wire clk;
  wire [24:0]cnt;
  wire cnt0_carry__0_n_0;
  wire cnt0_carry__0_n_1;
  wire cnt0_carry__0_n_2;
  wire cnt0_carry__0_n_3;
  wire cnt0_carry__0_n_4;
  wire cnt0_carry__0_n_5;
  wire cnt0_carry__0_n_6;
  wire cnt0_carry__0_n_7;
  wire cnt0_carry__1_n_0;
  wire cnt0_carry__1_n_1;
  wire cnt0_carry__1_n_2;
  wire cnt0_carry__1_n_3;
  wire cnt0_carry__1_n_4;
  wire cnt0_carry__1_n_5;
  wire cnt0_carry__1_n_6;
  wire cnt0_carry__1_n_7;
  wire cnt0_carry__2_n_0;
  wire cnt0_carry__2_n_1;
  wire cnt0_carry__2_n_2;
  wire cnt0_carry__2_n_3;
  wire cnt0_carry__2_n_4;
  wire cnt0_carry__2_n_5;
  wire cnt0_carry__2_n_6;
  wire cnt0_carry__2_n_7;
  wire cnt0_carry__3_n_0;
  wire cnt0_carry__3_n_1;
  wire cnt0_carry__3_n_2;
  wire cnt0_carry__3_n_3;
  wire cnt0_carry__3_n_4;
  wire cnt0_carry__3_n_5;
  wire cnt0_carry__3_n_6;
  wire cnt0_carry__3_n_7;
  wire cnt0_carry__4_n_1;
  wire cnt0_carry__4_n_2;
  wire cnt0_carry__4_n_3;
  wire cnt0_carry__4_n_4;
  wire cnt0_carry__4_n_5;
  wire cnt0_carry__4_n_6;
  wire cnt0_carry__4_n_7;
  wire cnt0_carry_n_0;
  wire cnt0_carry_n_1;
  wire cnt0_carry_n_2;
  wire cnt0_carry_n_3;
  wire cnt0_carry_n_4;
  wire cnt0_carry_n_5;
  wire cnt0_carry_n_6;
  wire cnt0_carry_n_7;
  wire \cnt[24]_i_2_n_0 ;
  wire \cnt[24]_i_3_n_0 ;
  wire \cnt[24]_i_4_n_0 ;
  wire \cnt[24]_i_5_n_0 ;
  wire \cnt[24]_i_6_n_0 ;
  wire \cnt[24]_i_7_n_0 ;
  wire \cnt[24]_i_8_n_0 ;
  wire [0:0]cnt_1;
  wire cnt_fsm0_carry__0_n_0;
  wire cnt_fsm0_carry__0_n_1;
  wire cnt_fsm0_carry__0_n_2;
  wire cnt_fsm0_carry__0_n_3;
  wire cnt_fsm0_carry__0_n_4;
  wire cnt_fsm0_carry__0_n_5;
  wire cnt_fsm0_carry__0_n_6;
  wire cnt_fsm0_carry__0_n_7;
  wire cnt_fsm0_carry__1_n_0;
  wire cnt_fsm0_carry__1_n_1;
  wire cnt_fsm0_carry__1_n_2;
  wire cnt_fsm0_carry__1_n_3;
  wire cnt_fsm0_carry__1_n_4;
  wire cnt_fsm0_carry__1_n_5;
  wire cnt_fsm0_carry__1_n_6;
  wire cnt_fsm0_carry__1_n_7;
  wire cnt_fsm0_carry__2_n_0;
  wire cnt_fsm0_carry__2_n_1;
  wire cnt_fsm0_carry__2_n_2;
  wire cnt_fsm0_carry__2_n_3;
  wire cnt_fsm0_carry__2_n_4;
  wire cnt_fsm0_carry__2_n_5;
  wire cnt_fsm0_carry__2_n_6;
  wire cnt_fsm0_carry__2_n_7;
  wire cnt_fsm0_carry__3_n_0;
  wire cnt_fsm0_carry__3_n_1;
  wire cnt_fsm0_carry__3_n_2;
  wire cnt_fsm0_carry__3_n_3;
  wire cnt_fsm0_carry__3_n_4;
  wire cnt_fsm0_carry__3_n_5;
  wire cnt_fsm0_carry__3_n_6;
  wire cnt_fsm0_carry__3_n_7;
  wire cnt_fsm0_carry__4_n_0;
  wire cnt_fsm0_carry__4_n_1;
  wire cnt_fsm0_carry__4_n_2;
  wire cnt_fsm0_carry__4_n_3;
  wire cnt_fsm0_carry__4_n_4;
  wire cnt_fsm0_carry__4_n_5;
  wire cnt_fsm0_carry__4_n_6;
  wire cnt_fsm0_carry__4_n_7;
  wire cnt_fsm0_carry__5_n_0;
  wire cnt_fsm0_carry__5_n_1;
  wire cnt_fsm0_carry__5_n_2;
  wire cnt_fsm0_carry__5_n_3;
  wire cnt_fsm0_carry__5_n_4;
  wire cnt_fsm0_carry__5_n_5;
  wire cnt_fsm0_carry__5_n_6;
  wire cnt_fsm0_carry__5_n_7;
  wire cnt_fsm0_carry__6_n_3;
  wire cnt_fsm0_carry__6_n_6;
  wire cnt_fsm0_carry__6_n_7;
  wire cnt_fsm0_carry_n_0;
  wire cnt_fsm0_carry_n_1;
  wire cnt_fsm0_carry_n_2;
  wire cnt_fsm0_carry_n_3;
  wire cnt_fsm0_carry_n_4;
  wire cnt_fsm0_carry_n_5;
  wire cnt_fsm0_carry_n_6;
  wire cnt_fsm0_carry_n_7;
  wire \cnt_fsm[0]_i_1_n_0 ;
  wire \cnt_fsm[30]_i_1_n_0 ;
  wire \cnt_fsm_reg_n_0_[0] ;
  wire \cnt_fsm_reg_n_0_[10] ;
  wire \cnt_fsm_reg_n_0_[11] ;
  wire \cnt_fsm_reg_n_0_[12] ;
  wire \cnt_fsm_reg_n_0_[13] ;
  wire \cnt_fsm_reg_n_0_[14] ;
  wire \cnt_fsm_reg_n_0_[15] ;
  wire \cnt_fsm_reg_n_0_[16] ;
  wire \cnt_fsm_reg_n_0_[17] ;
  wire \cnt_fsm_reg_n_0_[18] ;
  wire \cnt_fsm_reg_n_0_[19] ;
  wire \cnt_fsm_reg_n_0_[1] ;
  wire \cnt_fsm_reg_n_0_[20] ;
  wire \cnt_fsm_reg_n_0_[21] ;
  wire \cnt_fsm_reg_n_0_[22] ;
  wire \cnt_fsm_reg_n_0_[23] ;
  wire \cnt_fsm_reg_n_0_[24] ;
  wire \cnt_fsm_reg_n_0_[25] ;
  wire \cnt_fsm_reg_n_0_[26] ;
  wire \cnt_fsm_reg_n_0_[27] ;
  wire \cnt_fsm_reg_n_0_[28] ;
  wire \cnt_fsm_reg_n_0_[29] ;
  wire \cnt_fsm_reg_n_0_[2] ;
  wire \cnt_fsm_reg_n_0_[30] ;
  wire \cnt_fsm_reg_n_0_[3] ;
  wire \cnt_fsm_reg_n_0_[4] ;
  wire \cnt_fsm_reg_n_0_[5] ;
  wire \cnt_fsm_reg_n_0_[6] ;
  wire \cnt_fsm_reg_n_0_[7] ;
  wire \cnt_fsm_reg_n_0_[8] ;
  wire \cnt_fsm_reg_n_0_[9] ;
  wire [15:0]cnt_row_swap;
  wire cnt_row_swap0_carry__0_n_0;
  wire cnt_row_swap0_carry__0_n_1;
  wire cnt_row_swap0_carry__0_n_2;
  wire cnt_row_swap0_carry__0_n_3;
  wire cnt_row_swap0_carry__0_n_4;
  wire cnt_row_swap0_carry__0_n_5;
  wire cnt_row_swap0_carry__0_n_6;
  wire cnt_row_swap0_carry__0_n_7;
  wire cnt_row_swap0_carry__1_n_0;
  wire cnt_row_swap0_carry__1_n_1;
  wire cnt_row_swap0_carry__1_n_2;
  wire cnt_row_swap0_carry__1_n_3;
  wire cnt_row_swap0_carry__1_n_4;
  wire cnt_row_swap0_carry__1_n_5;
  wire cnt_row_swap0_carry__1_n_6;
  wire cnt_row_swap0_carry__1_n_7;
  wire cnt_row_swap0_carry__2_n_2;
  wire cnt_row_swap0_carry__2_n_3;
  wire cnt_row_swap0_carry__2_n_5;
  wire cnt_row_swap0_carry__2_n_6;
  wire cnt_row_swap0_carry__2_n_7;
  wire cnt_row_swap0_carry_n_0;
  wire cnt_row_swap0_carry_n_1;
  wire cnt_row_swap0_carry_n_2;
  wire cnt_row_swap0_carry_n_3;
  wire cnt_row_swap0_carry_n_4;
  wire cnt_row_swap0_carry_n_5;
  wire cnt_row_swap0_carry_n_6;
  wire cnt_row_swap0_carry_n_7;
  wire [0:0]cnt_row_swap_2;
  wire [3:0]cnt_seconds;
  wire cnt_seconds_0;
  wire cnt_tens;
  wire \cnt_tens[0]_i_1_n_0 ;
  wire \cnt_tens[1]_i_1_n_0 ;
  wire \cnt_tens[2]_i_1_n_0 ;
  wire \cnt_tens_reg_n_0_[0] ;
  wire \cnt_tens_reg_n_0_[1] ;
  wire \cnt_tens_reg_n_0_[2] ;
  wire [7:0]col;
  wire [7:0]col_select;
  wire \col_select_reg[0]_i_2_n_0 ;
  wire \col_select_reg[0]_i_3_n_0 ;
  wire \col_select_reg[1]_i_2_n_0 ;
  wire \col_select_reg[1]_i_3_n_0 ;
  wire \col_select_reg[1]_i_4_n_0 ;
  wire \col_select_reg[1]_i_5_n_0 ;
  wire \col_select_reg[2]_i_2_n_0 ;
  wire \col_select_reg[2]_i_3_n_0 ;
  wire \col_select_reg[2]_i_4_n_0 ;
  wire \col_select_reg[2]_i_5_n_0 ;
  wire \col_select_reg[3]_i_2_n_0 ;
  wire \col_select_reg[3]_i_3_n_0 ;
  wire \col_select_reg[3]_i_4_n_0 ;
  wire \col_select_reg[3]_i_5_n_0 ;
  wire \col_select_reg[4]_i_2_n_0 ;
  wire \col_select_reg[4]_i_3_n_0 ;
  wire \col_select_reg[4]_i_4_n_0 ;
  wire \col_select_reg[4]_i_5_n_0 ;
  wire \col_select_reg[5]_i_2_n_0 ;
  wire \col_select_reg[5]_i_3_n_0 ;
  wire \col_select_reg[5]_i_4_n_0 ;
  wire \col_select_reg[5]_i_5_n_0 ;
  wire \col_select_reg[6]_i_2_n_0 ;
  wire \col_select_reg[6]_i_3_n_0 ;
  wire \col_select_reg[6]_i_4_n_0 ;
  wire \col_select_reg[6]_i_5_n_0 ;
  wire \col_select_reg[6]_i_6_n_0 ;
  wire \col_select_reg[6]_i_7_n_0 ;
  wire \col_select_reg[7]_i_2_n_0 ;
  wire \col_select_reg[7]_i_3_n_0 ;
  wire \col_select_reg[7]_i_4_n_0 ;
  wire \col_select_reg[7]_i_5_n_0 ;
  wire \col_select_reg[7]_i_6_n_0 ;
  wire \col_select_reg[7]_i_7_n_0 ;
  wire \col_select_reg[7]_i_8_n_0 ;
  wire \col_select_reg[7]_i_9_n_0 ;
  wire data00;
  wire [1:0]fsm_current_state;
  wire [1:0]fsm_next_state;
  wire [21:0]i;
  wire i0_carry__0_n_0;
  wire i0_carry__0_n_1;
  wire i0_carry__0_n_2;
  wire i0_carry__0_n_3;
  wire i0_carry__0_n_4;
  wire i0_carry__0_n_5;
  wire i0_carry__0_n_6;
  wire i0_carry__0_n_7;
  wire i0_carry__1_n_0;
  wire i0_carry__1_n_1;
  wire i0_carry__1_n_2;
  wire i0_carry__1_n_3;
  wire i0_carry__1_n_4;
  wire i0_carry__1_n_5;
  wire i0_carry__1_n_6;
  wire i0_carry__1_n_7;
  wire i0_carry__2_n_0;
  wire i0_carry__2_n_1;
  wire i0_carry__2_n_2;
  wire i0_carry__2_n_3;
  wire i0_carry__2_n_4;
  wire i0_carry__2_n_5;
  wire i0_carry__2_n_6;
  wire i0_carry__2_n_7;
  wire i0_carry__3_n_0;
  wire i0_carry__3_n_1;
  wire i0_carry__3_n_2;
  wire i0_carry__3_n_3;
  wire i0_carry__3_n_4;
  wire i0_carry__3_n_5;
  wire i0_carry__3_n_6;
  wire i0_carry__3_n_7;
  wire i0_carry__4_n_7;
  wire i0_carry_n_0;
  wire i0_carry_n_1;
  wire i0_carry_n_2;
  wire i0_carry_n_3;
  wire i0_carry_n_4;
  wire i0_carry_n_5;
  wire i0_carry_n_6;
  wire i0_carry_n_7;
  wire \i[0]_i_1_n_0 ;
  wire \i[21]_i_1_n_0 ;
  wire \i[21]_i_2_n_0 ;
  wire \i[21]_i_3_n_0 ;
  wire \i[21]_i_4_n_0 ;
  wire \i[21]_i_5_n_0 ;
  wire \i[21]_i_6_n_0 ;
  wire \i[21]_i_7_n_0 ;
  wire [3:0]p_0_in;
  wire \rom_memory_reg[22]_i_1_n_0 ;
  wire \rom_memory_reg[22]_i_2_n_0 ;
  wire \rom_memory_reg[22]_i_3_n_0 ;
  wire \rom_memory_reg[23]_i_1_n_0 ;
  wire \rom_memory_reg[24]_i_1_n_0 ;
  wire \rom_memory_reg[29]_i_1_n_0 ;
  wire \rom_memory_reg[31]_i_1_n_0 ;
  wire \rom_memory_reg[32]_i_1_n_0 ;
  wire \rom_memory_reg[33]_i_1_n_0 ;
  wire \rom_memory_reg[37]_i_1_n_0 ;
  wire \rom_memory_reg[38]_i_1_n_0 ;
  wire \rom_memory_reg[39]_i_1_n_0 ;
  wire \rom_memory_reg[40]_i_1_n_0 ;
  wire \rom_memory_reg[41]_i_1_n_0 ;
  wire \rom_memory_reg[42]_i_1_n_0 ;
  wire \rom_memory_reg[45]_i_1_n_0 ;
  wire \rom_memory_reg[46]_i_1_n_0 ;
  wire \rom_memory_reg[47]_i_1_n_0 ;
  wire \rom_memory_reg[53]_i_1_n_0 ;
  wire \rom_memory_reg_n_0_[22] ;
  wire \rom_memory_reg_n_0_[23] ;
  wire \rom_memory_reg_n_0_[24] ;
  wire \rom_memory_reg_n_0_[29] ;
  wire \rom_memory_reg_n_0_[31] ;
  wire \rom_memory_reg_n_0_[32] ;
  wire \rom_memory_reg_n_0_[33] ;
  wire \rom_memory_reg_n_0_[37] ;
  wire \rom_memory_reg_n_0_[38] ;
  wire \rom_memory_reg_n_0_[39] ;
  wire \rom_memory_reg_n_0_[40] ;
  wire \rom_memory_reg_n_0_[41] ;
  wire \rom_memory_reg_n_0_[42] ;
  wire \rom_memory_reg_n_0_[45] ;
  wire \rom_memory_reg_n_0_[46] ;
  wire \rom_memory_reg_n_0_[47] ;
  wire \rom_memory_reg_n_0_[48] ;
  wire \rom_memory_reg_n_0_[53] ;
  wire \row_select[7]_i_1_n_0 ;
  wire \row_select[7]_i_2_n_0 ;
  wire \row_select[7]_i_3_n_0 ;
  wire \row_select[7]_i_4_n_0 ;
  wire \NLW_cell_animation_reg[1016]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[103]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[1048]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[143]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[174]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[206]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[238]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[278]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[309]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[341]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[373]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[39]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[413]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[444]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[476]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[508]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[548]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[579]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[611]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[643]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[683]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[714]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[71]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[746]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[778]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[818]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[849]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[881]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[8]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[913]_srl32_Q_UNCONNECTED ;
  wire \NLW_cell_animation_reg[953]_srl31_Q31_UNCONNECTED ;
  wire \NLW_cell_animation_reg[984]_srl32_Q_UNCONNECTED ;
  wire [3:3]NLW_cnt0_carry__4_CO_UNCONNECTED;
  wire [3:1]NLW_cnt_fsm0_carry__6_CO_UNCONNECTED;
  wire [3:2]NLW_cnt_fsm0_carry__6_O_UNCONNECTED;
  wire [3:2]NLW_cnt_row_swap0_carry__2_CO_UNCONNECTED;
  wire [3:3]NLW_cnt_row_swap0_carry__2_O_UNCONNECTED;
  wire [3:0]NLW_i0_carry__4_CO_UNCONNECTED;
  wire [3:1]NLW_i0_carry__4_O_UNCONNECTED;

  LUT6 #(
    .INIT(64'hFCFFFAF0FCF0FAF0)) 
    \FSM_sequential_fsm_current_state[0]_i_1 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_2_n_0 ),
        .I1(\FSM_sequential_fsm_current_state[1]_i_3_n_0 ),
        .I2(\FSM_sequential_fsm_current_state[0]_i_3_n_0 ),
        .I3(fsm_current_state[1]),
        .I4(fsm_current_state[0]),
        .I5(\FSM_sequential_fsm_current_state[0]_i_4_n_0 ),
        .O(fsm_next_state[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \FSM_sequential_fsm_current_state[0]_i_10 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_16_n_0 ),
        .I1(\cnt_fsm_reg_n_0_[9] ),
        .I2(\cnt_fsm_reg_n_0_[20] ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_13_n_0 ),
        .I4(\FSM_sequential_fsm_current_state[0]_i_17_n_0 ),
        .I5(\cnt_fsm_reg_n_0_[19] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hFFDFFFFFFFFFFFFF)) 
    \FSM_sequential_fsm_current_state[0]_i_11 
       (.I0(\cnt_fsm_reg_n_0_[20] ),
        .I1(\cnt_fsm_reg_n_0_[28] ),
        .I2(\cnt_fsm_reg_n_0_[29] ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ),
        .I4(\cnt_fsm_reg_n_0_[5] ),
        .I5(\cnt_fsm_reg_n_0_[4] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \FSM_sequential_fsm_current_state[0]_i_12 
       (.I0(\cnt_fsm_reg_n_0_[21] ),
        .I1(\cnt_fsm_reg_n_0_[25] ),
        .I2(\cnt_fsm_reg_n_0_[27] ),
        .I3(\cnt_fsm_reg_n_0_[7] ),
        .I4(\cnt_fsm_reg_n_0_[26] ),
        .I5(\cnt_fsm_reg_n_0_[11] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFFFFFF7F)) 
    \FSM_sequential_fsm_current_state[0]_i_13 
       (.I0(\cnt_fsm_reg_n_0_[10] ),
        .I1(\cnt_fsm_reg_n_0_[15] ),
        .I2(\cnt_fsm_reg_n_0_[8] ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_13_n_0 ),
        .I4(\FSM_sequential_fsm_current_state[1]_i_7_n_0 ),
        .O(\FSM_sequential_fsm_current_state[0]_i_13_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \FSM_sequential_fsm_current_state[0]_i_14 
       (.I0(\cnt_fsm_reg_n_0_[28] ),
        .I1(\cnt_fsm_reg_n_0_[24] ),
        .I2(\cnt_fsm_reg_n_0_[23] ),
        .I3(\cnt_fsm_reg_n_0_[15] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_14_n_0 ));
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_fsm_current_state[0]_i_15 
       (.I0(\cnt_fsm_reg_n_0_[25] ),
        .I1(\cnt_fsm_reg_n_0_[27] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_15_n_0 ));
  LUT5 #(
    .INIT(32'hFDFFFFFF)) 
    \FSM_sequential_fsm_current_state[0]_i_16 
       (.I0(\cnt_fsm_reg_n_0_[17] ),
        .I1(\cnt_fsm_reg_n_0_[16] ),
        .I2(\cnt_fsm_reg_n_0_[18] ),
        .I3(\cnt_fsm_reg_n_0_[28] ),
        .I4(\cnt_fsm_reg_n_0_[22] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_16_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \FSM_sequential_fsm_current_state[0]_i_17 
       (.I0(\cnt_fsm_reg_n_0_[29] ),
        .I1(\cnt_fsm_reg_n_0_[7] ),
        .I2(\cnt_fsm_reg_n_0_[21] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000200)) 
    \FSM_sequential_fsm_current_state[0]_i_2 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_5_n_0 ),
        .I1(\FSM_sequential_fsm_current_state[0]_i_6_n_0 ),
        .I2(\FSM_sequential_fsm_current_state[0]_i_7_n_0 ),
        .I3(\cnt_fsm_reg_n_0_[29] ),
        .I4(\cnt_fsm_reg_n_0_[10] ),
        .I5(\cnt_fsm_reg_n_0_[27] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000040000)) 
    \FSM_sequential_fsm_current_state[0]_i_3 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_8_n_0 ),
        .I1(\cnt_fsm_reg_n_0_[24] ),
        .I2(\cell_generator[58].cell_reg[58]_i_1_n_0 ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_5_n_0 ),
        .I4(\FSM_sequential_fsm_current_state[0]_i_9_n_0 ),
        .I5(\FSM_sequential_fsm_current_state[0]_i_10_n_0 ),
        .O(\FSM_sequential_fsm_current_state[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFEF)) 
    \FSM_sequential_fsm_current_state[0]_i_4 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_11_n_0 ),
        .I1(\FSM_sequential_fsm_current_state[0]_i_12_n_0 ),
        .I2(\cnt_fsm_reg_n_0_[9] ),
        .I3(\cnt_fsm_reg_n_0_[12] ),
        .I4(\cnt_fsm_reg_n_0_[14] ),
        .I5(\FSM_sequential_fsm_current_state[0]_i_13_n_0 ),
        .O(\FSM_sequential_fsm_current_state[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \FSM_sequential_fsm_current_state[0]_i_5 
       (.I0(\FSM_sequential_fsm_current_state[0]_i_14_n_0 ),
        .I1(\cnt_fsm_reg_n_0_[6] ),
        .I2(\cnt_fsm_reg_n_0_[13] ),
        .I3(\cnt_fsm_reg_n_0_[14] ),
        .I4(\FSM_sequential_fsm_current_state[1]_i_4_n_0 ),
        .I5(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ),
        .O(\FSM_sequential_fsm_current_state[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFF7)) 
    \FSM_sequential_fsm_current_state[0]_i_6 
       (.I0(\cnt_fsm_reg_n_0_[21] ),
        .I1(\cnt_fsm_reg_n_0_[18] ),
        .I2(\cnt_fsm_reg_n_0_[17] ),
        .I3(\cnt_fsm_reg_n_0_[19] ),
        .I4(\cnt_fsm_reg_n_0_[22] ),
        .I5(\cnt_fsm_reg_n_0_[16] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_sequential_fsm_current_state[0]_i_7 
       (.I0(\cnt_fsm_reg_n_0_[25] ),
        .I1(\cnt_fsm_reg_n_0_[12] ),
        .I2(\cnt_fsm_reg_n_0_[9] ),
        .I3(\cnt_fsm_reg_n_0_[20] ),
        .I4(\cnt_fsm_reg_n_0_[8] ),
        .I5(\cnt_fsm_reg_n_0_[30] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_fsm_current_state[0]_i_8 
       (.I0(\cnt_fsm_reg_n_0_[5] ),
        .I1(\cnt_fsm_reg_n_0_[4] ),
        .O(\FSM_sequential_fsm_current_state[0]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    \FSM_sequential_fsm_current_state[0]_i_9 
       (.I0(\cnt_fsm_reg_n_0_[26] ),
        .I1(\cnt_fsm_reg_n_0_[11] ),
        .I2(\cnt_fsm_reg_n_0_[12] ),
        .I3(\cnt_fsm_reg_n_0_[14] ),
        .I4(\FSM_sequential_fsm_current_state[0]_i_15_n_0 ),
        .I5(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ),
        .O(\FSM_sequential_fsm_current_state[0]_i_9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hFABA)) 
    \FSM_sequential_fsm_current_state[1]_i_1 
       (.I0(\FSM_sequential_fsm_current_state[1]_i_2_n_0 ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .I3(\FSM_sequential_fsm_current_state[1]_i_3_n_0 ),
        .O(fsm_next_state[1]));
  LUT6 #(
    .INIT(64'hFFFFFFFFF7FFFFFF)) 
    \FSM_sequential_fsm_current_state[1]_i_10 
       (.I0(\cnt_fsm_reg_n_0_[13] ),
        .I1(\cnt_fsm_reg_n_0_[30] ),
        .I2(\cnt_fsm_reg_n_0_[28] ),
        .I3(\cnt_fsm_reg_n_0_[23] ),
        .I4(\cnt_fsm_reg_n_0_[6] ),
        .I5(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ),
        .O(\FSM_sequential_fsm_current_state[1]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'h7FFFFFFFFFFFFFFF)) 
    \FSM_sequential_fsm_current_state[1]_i_11 
       (.I0(\cnt_fsm_reg_n_0_[11] ),
        .I1(\cnt_fsm_reg_n_0_[10] ),
        .I2(\cnt_fsm_reg_n_0_[25] ),
        .I3(\cnt_fsm_reg_n_0_[27] ),
        .I4(\cnt_fsm_reg_n_0_[5] ),
        .I5(\cnt_fsm_reg_n_0_[4] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'h7FFF)) 
    \FSM_sequential_fsm_current_state[1]_i_12 
       (.I0(\cnt_fsm_reg_n_0_[2] ),
        .I1(\cnt_fsm_reg_n_0_[3] ),
        .I2(\cnt_fsm_reg_n_0_[0] ),
        .I3(\cnt_fsm_reg_n_0_[1] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_fsm_current_state[1]_i_13 
       (.I0(\cnt_fsm_reg_n_0_[23] ),
        .I1(\cnt_fsm_reg_n_0_[6] ),
        .I2(\cnt_fsm_reg_n_0_[30] ),
        .I3(\cnt_fsm_reg_n_0_[13] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_13_n_0 ));
  LUT3 #(
    .INIT(8'hFE)) 
    \FSM_sequential_fsm_current_state[1]_i_14 
       (.I0(\cnt_fsm_reg_n_0_[9] ),
        .I1(\cnt_fsm_reg_n_0_[20] ),
        .I2(\cnt_fsm_reg_n_0_[8] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000200000)) 
    \FSM_sequential_fsm_current_state[1]_i_2 
       (.I0(\FSM_sequential_fsm_current_state[1]_i_4_n_0 ),
        .I1(\FSM_sequential_fsm_current_state[1]_i_5_n_0 ),
        .I2(\FSM_sequential_fsm_current_state[1]_i_6_n_0 ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_7_n_0 ),
        .I4(\cnt_fsm_reg_n_0_[29] ),
        .I5(\FSM_sequential_fsm_current_state[1]_i_8_n_0 ),
        .O(\FSM_sequential_fsm_current_state[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFEFFFFFFFFFFFF)) 
    \FSM_sequential_fsm_current_state[1]_i_3 
       (.I0(\FSM_sequential_fsm_current_state[1]_i_9_n_0 ),
        .I1(\FSM_sequential_fsm_current_state[1]_i_10_n_0 ),
        .I2(\FSM_sequential_fsm_current_state[1]_i_11_n_0 ),
        .I3(\cnt_fsm_reg_n_0_[15] ),
        .I4(\cnt_fsm_reg_n_0_[12] ),
        .I5(\cnt_fsm_reg_n_0_[14] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \FSM_sequential_fsm_current_state[1]_i_4 
       (.I0(\cnt_fsm_reg_n_0_[7] ),
        .I1(\cnt_fsm_reg_n_0_[26] ),
        .I2(\cnt_fsm_reg_n_0_[11] ),
        .I3(\cnt_fsm_reg_n_0_[4] ),
        .I4(\cnt_fsm_reg_n_0_[5] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \FSM_sequential_fsm_current_state[1]_i_5 
       (.I0(\cnt_fsm_reg_n_0_[10] ),
        .I1(\cnt_fsm_reg_n_0_[15] ),
        .I2(\cnt_fsm_reg_n_0_[8] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h0000000080000000)) 
    \FSM_sequential_fsm_current_state[1]_i_6 
       (.I0(\cnt_fsm_reg_n_0_[25] ),
        .I1(\cnt_fsm_reg_n_0_[27] ),
        .I2(\cnt_fsm_reg_n_0_[21] ),
        .I3(\cnt_fsm_reg_n_0_[9] ),
        .I4(\cell_generator[56].cell_reg[56]_i_1_n_0 ),
        .I5(\FSM_sequential_fsm_current_state[1]_i_12_n_0 ),
        .O(\FSM_sequential_fsm_current_state[1]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFEF)) 
    \FSM_sequential_fsm_current_state[1]_i_7 
       (.I0(\cnt_fsm_reg_n_0_[24] ),
        .I1(\cnt_fsm_reg_n_0_[18] ),
        .I2(\cnt_fsm_reg_n_0_[16] ),
        .I3(\cnt_fsm_reg_n_0_[22] ),
        .I4(\cnt_fsm_reg_n_0_[19] ),
        .I5(\cnt_fsm_reg_n_0_[17] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFD)) 
    \FSM_sequential_fsm_current_state[1]_i_8 
       (.I0(\cnt_fsm_reg_n_0_[20] ),
        .I1(\cnt_fsm_reg_n_0_[12] ),
        .I2(\cnt_fsm_reg_n_0_[28] ),
        .I3(\FSM_sequential_fsm_current_state[1]_i_13_n_0 ),
        .I4(\cnt_fsm_reg_n_0_[14] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \FSM_sequential_fsm_current_state[1]_i_9 
       (.I0(\FSM_sequential_fsm_current_state[1]_i_7_n_0 ),
        .I1(\cnt_fsm_reg_n_0_[26] ),
        .I2(\FSM_sequential_fsm_current_state[1]_i_14_n_0 ),
        .I3(\cnt_fsm_reg_n_0_[29] ),
        .I4(\cnt_fsm_reg_n_0_[7] ),
        .I5(\cnt_fsm_reg_n_0_[21] ),
        .O(\FSM_sequential_fsm_current_state[1]_i_9_n_0 ));
  (* FSM_ENCODED_STATES = "state_inverse:01,state_image:10,state_animation:11,state_normal:00" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_fsm_current_state_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(fsm_next_state[0]),
        .Q(fsm_current_state[0]),
        .R(1'b0));
  (* FSM_ENCODED_STATES = "state_inverse:01,state_image:10,state_animation:11,state_normal:00" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_sequential_fsm_current_state_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(fsm_next_state[1]),
        .Q(fsm_current_state[1]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0020000000000000)) 
    \cell_animation[0]_i_1 
       (.I0(\i[21]_i_2_n_0 ),
        .I1(i[20]),
        .I2(i[21]),
        .I3(i[19]),
        .I4(\cell_animation[0]_i_2_n_0 ),
        .I5(\cell_animation[0]_i_3_n_0 ),
        .O(cell_animation0));
  LUT6 #(
    .INIT(64'hBBBB0B0000000000)) 
    \cell_animation[0]_i_2 
       (.I0(\cell_animation[0]_i_4_n_0 ),
        .I1(i[17]),
        .I2(i[19]),
        .I3(i[18]),
        .I4(i[20]),
        .I5(\cell_animation[0]_i_5_n_0 ),
        .O(\cell_animation[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \cell_animation[0]_i_3 
       (.I0(\cell_animation[0]_i_6_n_0 ),
        .I1(i[0]),
        .I2(i[1]),
        .I3(i[2]),
        .I4(\cell_animation[0]_i_7_n_0 ),
        .I5(\cell_animation[0]_i_8_n_0 ),
        .O(\cell_animation[0]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \cell_animation[0]_i_4 
       (.I0(i[15]),
        .I1(i[16]),
        .O(\cell_animation[0]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h0000150015001500)) 
    \cell_animation[0]_i_5 
       (.I0(i[14]),
        .I1(i[13]),
        .I2(i[12]),
        .I3(i[11]),
        .I4(i[10]),
        .I5(i[9]),
        .O(\cell_animation[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h2323002300230023)) 
    \cell_animation[0]_i_6 
       (.I0(i[7]),
        .I1(i[8]),
        .I2(i[6]),
        .I3(i[5]),
        .I4(i[3]),
        .I5(i[4]),
        .O(\cell_animation[0]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    \cell_animation[0]_i_7 
       (.I0(i[8]),
        .I1(i[7]),
        .I2(i[5]),
        .I3(i[4]),
        .O(\cell_animation[0]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h0080000000000000)) 
    \cell_animation[0]_i_8 
       (.I0(i[10]),
        .I1(i[11]),
        .I2(i[13]),
        .I3(i[14]),
        .I4(i[17]),
        .I5(i[16]),
        .O(\cell_animation[0]_i_8_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[0] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[1] ),
        .Q(\cell_animation_reg_n_0_[0] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[1016]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[1016]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[1048]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[1016]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[1016]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[103]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[103]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[0] ),
        .Q(\NLW_cell_animation_reg[103]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[103]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[1048]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[1048]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(data00),
        .Q(\NLW_cell_animation_reg[1048]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[1048]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[135] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[136] ),
        .Q(\cell_animation_reg_n_0_[135] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[136] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[137] ),
        .Q(\cell_animation_reg_n_0_[136] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[137] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[138] ),
        .Q(\cell_animation_reg_n_0_[137] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[138] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[139] ),
        .Q(\cell_animation_reg_n_0_[138] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[139] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[140] ),
        .Q(\cell_animation_reg_n_0_[139] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[140] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[141] ),
        .Q(\cell_animation_reg_n_0_[140] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[141] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[142] ),
        .Q(\cell_animation_reg_n_0_[141] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[142] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[143]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[142] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[143]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[143]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[174]_srl32_n_1 ),
        .Q(\cell_animation_reg[143]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[143]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[174]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[174]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[206]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[174]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[174]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[1] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[2] ),
        .Q(\cell_animation_reg_n_0_[1] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[206]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[206]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[238]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[206]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[206]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[238]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[238]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[135] ),
        .Q(\NLW_cell_animation_reg[238]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[238]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[270] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[271] ),
        .Q(\cell_animation_reg_n_0_[270] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[271] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[272] ),
        .Q(\cell_animation_reg_n_0_[271] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[272] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[273] ),
        .Q(\cell_animation_reg_n_0_[272] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[273] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[274] ),
        .Q(\cell_animation_reg_n_0_[273] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[274] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[275] ),
        .Q(\cell_animation_reg_n_0_[274] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[275] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[276] ),
        .Q(\cell_animation_reg_n_0_[275] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[276] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[277] ),
        .Q(\cell_animation_reg_n_0_[276] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[277] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[278]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[277] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[278]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h7CF9F078)) 
    \cell_animation_reg[278]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[309]_srl32_n_1 ),
        .Q(\cell_animation_reg[278]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[278]_srl31_Q31_UNCONNECTED ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[2] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[3] ),
        .Q(\cell_animation_reg_n_0_[2] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[309]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h89F00000)) 
    \cell_animation_reg[309]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[341]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[309]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[309]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[341]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h3E4489E1)) 
    \cell_animation_reg[341]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[373]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[341]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[341]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[373]_srl32 " *) 
  SRLC32E #(
    .INIT(32'hC7831000)) 
    \cell_animation_reg[373]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[270] ),
        .Q(\NLW_cell_animation_reg[373]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[373]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[39]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[39]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[71]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[39]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[39]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[3] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[4] ),
        .Q(\cell_animation_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[405] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[406] ),
        .Q(\cell_animation_reg_n_0_[405] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[406] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[407] ),
        .Q(\cell_animation_reg_n_0_[406] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[407] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[408] ),
        .Q(\cell_animation_reg_n_0_[407] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[408] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[409] ),
        .Q(\cell_animation_reg_n_0_[408] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[409] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[410] ),
        .Q(\cell_animation_reg_n_0_[409] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[410] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[411] ),
        .Q(\cell_animation_reg_n_0_[410] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[411] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[412] ),
        .Q(\cell_animation_reg_n_0_[411] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[412] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[413]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[412] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[413]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h40204044)) 
    \cell_animation_reg[413]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[444]_srl32_n_1 ),
        .Q(\cell_animation_reg[413]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[413]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[444]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h88400040)) 
    \cell_animation_reg[444]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[476]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[444]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[444]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[476]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h08448812)) 
    \cell_animation_reg[476]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[508]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[476]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[476]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[4] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[5] ),
        .Q(\cell_animation_reg_n_0_[4] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[508]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h60451000)) 
    \cell_animation_reg[508]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[405] ),
        .Q(\NLW_cell_animation_reg[508]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[508]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[540] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[541] ),
        .Q(\cell_animation_reg_n_0_[540] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[541] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[542] ),
        .Q(\cell_animation_reg_n_0_[541] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[542] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[543] ),
        .Q(\cell_animation_reg_n_0_[542] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[543] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[544] ),
        .Q(\cell_animation_reg_n_0_[543] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[544] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[545] ),
        .Q(\cell_animation_reg_n_0_[544] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[545] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[546] ),
        .Q(\cell_animation_reg_n_0_[545] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[546] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[547] ),
        .Q(\cell_animation_reg_n_0_[546] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[547] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[548]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[547] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[548]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h78204078)) 
    \cell_animation_reg[548]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[579]_srl32_n_1 ),
        .Q(\cell_animation_reg[548]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[548]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[579]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h88407C20)) 
    \cell_animation_reg[579]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[611]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[579]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[579]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[5] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[6] ),
        .Q(\cell_animation_reg_n_0_[5] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[611]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h0844F8E2)) 
    \cell_animation_reg[611]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[643]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[611]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[611]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[643]_srl32 " *) 
  SRLC32E #(
    .INIT(32'hA3891000)) 
    \cell_animation_reg[643]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[540] ),
        .Q(\NLW_cell_animation_reg[643]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[643]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[675] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[676] ),
        .Q(\cell_animation_reg_n_0_[675] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[676] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[677] ),
        .Q(\cell_animation_reg_n_0_[676] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[677] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[678] ),
        .Q(\cell_animation_reg_n_0_[677] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[678] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[679] ),
        .Q(\cell_animation_reg_n_0_[678] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[679] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[680] ),
        .Q(\cell_animation_reg_n_0_[679] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[680] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[681] ),
        .Q(\cell_animation_reg_n_0_[680] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[681] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[682] ),
        .Q(\cell_animation_reg_n_0_[681] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[682] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[683]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[682] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[683]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h40204044)) 
    \cell_animation_reg[683]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[714]_srl32_n_1 ),
        .Q(\cell_animation_reg[683]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[683]_srl31_Q31_UNCONNECTED ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[6] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[7] ),
        .Q(\cell_animation_reg_n_0_[6] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[714]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h88400040)) 
    \cell_animation_reg[714]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[746]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[714]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[714]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[71]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[71]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[103]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[71]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[71]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[746]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h08288903)) 
    \cell_animation_reg[746]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[778]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[746]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[746]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[778]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h240F9000)) 
    \cell_animation_reg[778]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[675] ),
        .Q(\NLW_cell_animation_reg[778]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[778]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[7] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[8]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[810] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[811] ),
        .Q(\cell_animation_reg_n_0_[810] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[811] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[812] ),
        .Q(\cell_animation_reg_n_0_[811] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[812] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[813] ),
        .Q(\cell_animation_reg_n_0_[812] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[813] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[814] ),
        .Q(\cell_animation_reg_n_0_[813] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[814] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[815] ),
        .Q(\cell_animation_reg_n_0_[814] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[815] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[816] ),
        .Q(\cell_animation_reg_n_0_[815] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[816] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[817] ),
        .Q(\cell_animation_reg_n_0_[816] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[817] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[818]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[817] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[818]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h40F84078)) 
    \cell_animation_reg[818]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[849]_srl32_n_1 ),
        .Q(\cell_animation_reg[818]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[818]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[849]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h70400000)) 
    \cell_animation_reg[849]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[881]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[849]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[849]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[881]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h3E1089F1)) 
    \cell_animation_reg[881]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[913]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[881]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[881]_srl32_n_1 ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[8]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[8]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[39]_srl32_n_1 ),
        .Q(\cell_animation_reg[8]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[8]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[913]_srl32 " *) 
  SRLC32E #(
    .INIT(32'hC7C11F00)) 
    \cell_animation_reg[913]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg_n_0_[810] ),
        .Q(\NLW_cell_animation_reg[913]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[913]_srl32_n_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[945] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[946] ),
        .Q(data00),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[946] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[947] ),
        .Q(\cell_animation_reg_n_0_[946] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[947] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[948] ),
        .Q(\cell_animation_reg_n_0_[947] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[948] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[949] ),
        .Q(\cell_animation_reg_n_0_[948] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[949] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[950] ),
        .Q(\cell_animation_reg_n_0_[949] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[950] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[951] ),
        .Q(\cell_animation_reg_n_0_[950] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[951] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg_n_0_[952] ),
        .Q(\cell_animation_reg_n_0_[951] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cell_animation_reg[952] 
       (.C(clk),
        .CE(cell_animation0),
        .D(\cell_animation_reg[953]_srl31_n_0 ),
        .Q(\cell_animation_reg_n_0_[952] ),
        .R(1'b0));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[953]_srl31 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[953]_srl31 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b0}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[984]_srl32_n_1 ),
        .Q(\cell_animation_reg[953]_srl31_n_0 ),
        .Q31(\NLW_cell_animation_reg[953]_srl31_Q31_UNCONNECTED ));
  (* srl_bus_name = "\\U0/cell_animation_reg " *) 
  (* srl_name = "\\U0/cell_animation_reg[984]_srl32 " *) 
  SRLC32E #(
    .INIT(32'h00000000)) 
    \cell_animation_reg[984]_srl32 
       (.A({1'b1,1'b1,1'b1,1'b1,1'b1}),
        .CE(cell_animation0),
        .CLK(clk),
        .D(\cell_animation_reg[1016]_srl32_n_1 ),
        .Q(\NLW_cell_animation_reg[984]_srl32_Q_UNCONNECTED ),
        .Q31(\cell_animation_reg[984]_srl32_n_1 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[22].cell_reg[22] 
       (.CLR(1'b0),
        .D(\cell_generator[22].cell_reg[22]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[22].cell_reg_n_0_[22] ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[22].cell_reg[22]_i_1 
       (.I0(\rom_memory_reg_n_0_[22] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[22].cell_reg[22]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[23].cell_reg[23] 
       (.CLR(1'b0),
        .D(\cell_generator[23].cell_reg[23]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[23].cell_reg_n_0_[23] ));
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[23].cell_reg[23]_i_1 
       (.I0(\rom_memory_reg_n_0_[23] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[23].cell_reg[23]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[24].cell_reg[24] 
       (.CLR(1'b0),
        .D(\cell_generator[24].cell_reg[24]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[24].cell_reg_n_0_[24] ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[24].cell_reg[24]_i_1 
       (.I0(\rom_memory_reg_n_0_[24] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[24].cell_reg[24]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[26].cell_reg[26] 
       (.CLR(1'b0),
        .D(\cell_generator[26].cell_reg[26]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[26].cell_reg_n_0_[26] ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[26].cell_reg[26]_i_1 
       (.I0(\rom_memory_reg_n_0_[32] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[26].cell_reg[26]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[29].cell_reg[29] 
       (.CLR(1'b0),
        .D(\cell_generator[29].cell_reg[29]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[29].cell_reg_n_0_[29] ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[29].cell_reg[29]_i_1 
       (.I0(\rom_memory_reg_n_0_[29] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[29].cell_reg[29]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[31].cell_reg[31] 
       (.CLR(1'b0),
        .D(\cell_generator[31].cell_reg[31]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[31].cell_reg_n_0_[31] ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[31].cell_reg[31]_i_1 
       (.I0(\rom_memory_reg_n_0_[31] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[31].cell_reg[31]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[32].cell_reg[32] 
       (.CLR(1'b0),
        .D(\cell_generator[32].cell_reg[32]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[32].cell_reg_n_0_[32] ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hBE)) 
    \cell_generator[32].cell_reg[32]_i_1 
       (.I0(fsm_current_state[1]),
        .I1(\rom_memory_reg_n_0_[32] ),
        .I2(fsm_current_state[0]),
        .O(\cell_generator[32].cell_reg[32]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[33].cell_reg[33] 
       (.CLR(1'b0),
        .D(\cell_generator[33].cell_reg[33]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[33].cell_reg_n_0_[33] ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[33].cell_reg[33]_i_1 
       (.I0(\rom_memory_reg_n_0_[33] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[33].cell_reg[33]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[37].cell_reg[37] 
       (.CLR(1'b0),
        .D(\cell_generator[37].cell_reg[37]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[37].cell_reg_n_0_[37] ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[37].cell_reg[37]_i_1 
       (.I0(\rom_memory_reg_n_0_[37] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[37].cell_reg[37]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[38].cell_reg[38] 
       (.CLR(1'b0),
        .D(\cell_generator[38].cell_reg[38]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[38].cell_reg_n_0_[38] ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[38].cell_reg[38]_i_1 
       (.I0(\rom_memory_reg_n_0_[38] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[38].cell_reg[38]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[39].cell_reg[39] 
       (.CLR(1'b0),
        .D(\cell_generator[39].cell_reg[39]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[39].cell_reg_n_0_[39] ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[39].cell_reg[39]_i_1 
       (.I0(\rom_memory_reg_n_0_[39] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[39].cell_reg[39]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[40].cell_reg[40] 
       (.CLR(1'b0),
        .D(\cell_generator[40].cell_reg[40]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[40].cell_reg_n_0_[40] ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[40].cell_reg[40]_i_1 
       (.I0(\rom_memory_reg_n_0_[40] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[40].cell_reg[40]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[41].cell_reg[41] 
       (.CLR(1'b0),
        .D(\cell_generator[41].cell_reg[41]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[41].cell_reg_n_0_[41] ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[41].cell_reg[41]_i_1 
       (.I0(\rom_memory_reg_n_0_[41] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[41].cell_reg[41]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[42].cell_reg[42] 
       (.CLR(1'b0),
        .D(\cell_generator[42].cell_reg[42]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[42].cell_reg_n_0_[42] ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[42].cell_reg[42]_i_1 
       (.I0(\rom_memory_reg_n_0_[42] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[42].cell_reg[42]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[45].cell_reg[45] 
       (.CLR(1'b0),
        .D(\cell_generator[45].cell_reg[45]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[45].cell_reg_n_0_[45] ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[45].cell_reg[45]_i_1 
       (.I0(\rom_memory_reg_n_0_[45] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[45].cell_reg[45]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[46].cell_reg[46] 
       (.CLR(1'b0),
        .D(\cell_generator[46].cell_reg[46]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[46].cell_reg_n_0_[46] ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[46].cell_reg[46]_i_1 
       (.I0(\rom_memory_reg_n_0_[46] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[46].cell_reg[46]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[47].cell_reg[47] 
       (.CLR(1'b0),
        .D(\cell_generator[47].cell_reg[47]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[47].cell_reg_n_0_[47] ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hF6)) 
    \cell_generator[47].cell_reg[47]_i_1 
       (.I0(\rom_memory_reg_n_0_[47] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[47].cell_reg[47]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[48].cell_reg[48] 
       (.CLR(1'b0),
        .D(\cell_generator[48].cell_reg[48]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[48].cell_reg_n_0_[48] ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[48].cell_reg[48]_i_1 
       (.I0(\rom_memory_reg_n_0_[48] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[48].cell_reg[48]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[49].cell_reg[49] 
       (.CLR(1'b0),
        .D(\cell_generator[49].cell_reg[49]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[49].cell_reg_n_0_[49] ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hBE)) 
    \cell_generator[49].cell_reg[49]_i_1 
       (.I0(fsm_current_state[1]),
        .I1(\rom_memory_reg_n_0_[48] ),
        .I2(fsm_current_state[0]),
        .O(\cell_generator[49].cell_reg[49]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[53].cell_reg[53] 
       (.CLR(1'b0),
        .D(\cell_generator[53].cell_reg[53]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[53].cell_reg_n_0_[53] ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cell_generator[53].cell_reg[53]_i_1 
       (.I0(\rom_memory_reg_n_0_[53] ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .O(\cell_generator[53].cell_reg[53]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[54].cell_reg[54] 
       (.CLR(1'b0),
        .D(\cell_generator[54].cell_reg[54]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[54].cell_reg_n_0_[54] ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hBE)) 
    \cell_generator[54].cell_reg[54]_i_1 
       (.I0(fsm_current_state[1]),
        .I1(\rom_memory_reg_n_0_[53] ),
        .I2(fsm_current_state[0]),
        .O(\cell_generator[54].cell_reg[54]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[56].cell_reg[56] 
       (.CLR(1'b0),
        .D(\cell_generator[56].cell_reg[56]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[56].cell_reg_n_0_[56] ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \cell_generator[56].cell_reg[56]_i_1 
       (.I0(fsm_current_state[0]),
        .I1(fsm_current_state[1]),
        .O(\cell_generator[56].cell_reg[56]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \cell_generator[58].cell_reg[58] 
       (.CLR(1'b0),
        .D(\cell_generator[58].cell_reg[58]_i_1_n_0 ),
        .G(\cell_generator[58].cell_reg[58]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\cell_generator[58].cell_reg_n_0_[58] ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \cell_generator[58].cell_reg[58]_i_1 
       (.I0(fsm_current_state[0]),
        .I1(fsm_current_state[1]),
        .O(\cell_generator[58].cell_reg[58]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \cell_generator[58].cell_reg[58]_i_2 
       (.I0(fsm_current_state[1]),
        .I1(fsm_current_state[0]),
        .O(\cell_generator[58].cell_reg[58]_i_2_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry
       (.CI(1'b0),
        .CO({cnt0_carry_n_0,cnt0_carry_n_1,cnt0_carry_n_2,cnt0_carry_n_3}),
        .CYINIT(cnt[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry_n_4,cnt0_carry_n_5,cnt0_carry_n_6,cnt0_carry_n_7}),
        .S(cnt[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__0
       (.CI(cnt0_carry_n_0),
        .CO({cnt0_carry__0_n_0,cnt0_carry__0_n_1,cnt0_carry__0_n_2,cnt0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry__0_n_4,cnt0_carry__0_n_5,cnt0_carry__0_n_6,cnt0_carry__0_n_7}),
        .S(cnt[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__1
       (.CI(cnt0_carry__0_n_0),
        .CO({cnt0_carry__1_n_0,cnt0_carry__1_n_1,cnt0_carry__1_n_2,cnt0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry__1_n_4,cnt0_carry__1_n_5,cnt0_carry__1_n_6,cnt0_carry__1_n_7}),
        .S(cnt[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__2
       (.CI(cnt0_carry__1_n_0),
        .CO({cnt0_carry__2_n_0,cnt0_carry__2_n_1,cnt0_carry__2_n_2,cnt0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry__2_n_4,cnt0_carry__2_n_5,cnt0_carry__2_n_6,cnt0_carry__2_n_7}),
        .S(cnt[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__3
       (.CI(cnt0_carry__2_n_0),
        .CO({cnt0_carry__3_n_0,cnt0_carry__3_n_1,cnt0_carry__3_n_2,cnt0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry__3_n_4,cnt0_carry__3_n_5,cnt0_carry__3_n_6,cnt0_carry__3_n_7}),
        .S(cnt[20:17]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt0_carry__4
       (.CI(cnt0_carry__3_n_0),
        .CO({NLW_cnt0_carry__4_CO_UNCONNECTED[3],cnt0_carry__4_n_1,cnt0_carry__4_n_2,cnt0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt0_carry__4_n_4,cnt0_carry__4_n_5,cnt0_carry__4_n_6,cnt0_carry__4_n_7}),
        .S(cnt[24:21]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \cnt[0]_i_1 
       (.I0(cnt[0]),
        .O(cnt_1));
  LUT1 #(
    .INIT(2'h1)) 
    \cnt[24]_i_1 
       (.I0(\cnt[24]_i_2_n_0 ),
        .O(cnt_seconds_0));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \cnt[24]_i_2 
       (.I0(\cnt[24]_i_3_n_0 ),
        .I1(\cnt[24]_i_4_n_0 ),
        .I2(\cnt[24]_i_5_n_0 ),
        .I3(\cnt[24]_i_6_n_0 ),
        .I4(\cnt[24]_i_7_n_0 ),
        .I5(\cnt[24]_i_8_n_0 ),
        .O(\cnt[24]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFDF)) 
    \cnt[24]_i_3 
       (.I0(cnt[16]),
        .I1(cnt[15]),
        .I2(cnt[18]),
        .I3(cnt[17]),
        .O(\cnt[24]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \cnt[24]_i_4 
       (.I0(cnt[20]),
        .I1(cnt[19]),
        .I2(cnt[22]),
        .I3(cnt[21]),
        .O(\cnt[24]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \cnt[24]_i_5 
       (.I0(cnt[8]),
        .I1(cnt[7]),
        .I2(cnt[10]),
        .I3(cnt[9]),
        .O(\cnt[24]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \cnt[24]_i_6 
       (.I0(cnt[12]),
        .I1(cnt[11]),
        .I2(cnt[14]),
        .I3(cnt[13]),
        .O(\cnt[24]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \cnt[24]_i_7 
       (.I0(cnt[4]),
        .I1(cnt[3]),
        .I2(cnt[5]),
        .I3(cnt[6]),
        .O(\cnt[24]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hDFFFFFFF)) 
    \cnt[24]_i_8 
       (.I0(cnt[0]),
        .I1(cnt[23]),
        .I2(cnt[24]),
        .I3(cnt[2]),
        .I4(cnt[1]),
        .O(\cnt[24]_i_8_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry
       (.CI(1'b0),
        .CO({cnt_fsm0_carry_n_0,cnt_fsm0_carry_n_1,cnt_fsm0_carry_n_2,cnt_fsm0_carry_n_3}),
        .CYINIT(\cnt_fsm_reg_n_0_[0] ),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry_n_4,cnt_fsm0_carry_n_5,cnt_fsm0_carry_n_6,cnt_fsm0_carry_n_7}),
        .S({\cnt_fsm_reg_n_0_[4] ,\cnt_fsm_reg_n_0_[3] ,\cnt_fsm_reg_n_0_[2] ,\cnt_fsm_reg_n_0_[1] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__0
       (.CI(cnt_fsm0_carry_n_0),
        .CO({cnt_fsm0_carry__0_n_0,cnt_fsm0_carry__0_n_1,cnt_fsm0_carry__0_n_2,cnt_fsm0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__0_n_4,cnt_fsm0_carry__0_n_5,cnt_fsm0_carry__0_n_6,cnt_fsm0_carry__0_n_7}),
        .S({\cnt_fsm_reg_n_0_[8] ,\cnt_fsm_reg_n_0_[7] ,\cnt_fsm_reg_n_0_[6] ,\cnt_fsm_reg_n_0_[5] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__1
       (.CI(cnt_fsm0_carry__0_n_0),
        .CO({cnt_fsm0_carry__1_n_0,cnt_fsm0_carry__1_n_1,cnt_fsm0_carry__1_n_2,cnt_fsm0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__1_n_4,cnt_fsm0_carry__1_n_5,cnt_fsm0_carry__1_n_6,cnt_fsm0_carry__1_n_7}),
        .S({\cnt_fsm_reg_n_0_[12] ,\cnt_fsm_reg_n_0_[11] ,\cnt_fsm_reg_n_0_[10] ,\cnt_fsm_reg_n_0_[9] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__2
       (.CI(cnt_fsm0_carry__1_n_0),
        .CO({cnt_fsm0_carry__2_n_0,cnt_fsm0_carry__2_n_1,cnt_fsm0_carry__2_n_2,cnt_fsm0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__2_n_4,cnt_fsm0_carry__2_n_5,cnt_fsm0_carry__2_n_6,cnt_fsm0_carry__2_n_7}),
        .S({\cnt_fsm_reg_n_0_[16] ,\cnt_fsm_reg_n_0_[15] ,\cnt_fsm_reg_n_0_[14] ,\cnt_fsm_reg_n_0_[13] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__3
       (.CI(cnt_fsm0_carry__2_n_0),
        .CO({cnt_fsm0_carry__3_n_0,cnt_fsm0_carry__3_n_1,cnt_fsm0_carry__3_n_2,cnt_fsm0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__3_n_4,cnt_fsm0_carry__3_n_5,cnt_fsm0_carry__3_n_6,cnt_fsm0_carry__3_n_7}),
        .S({\cnt_fsm_reg_n_0_[20] ,\cnt_fsm_reg_n_0_[19] ,\cnt_fsm_reg_n_0_[18] ,\cnt_fsm_reg_n_0_[17] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__4
       (.CI(cnt_fsm0_carry__3_n_0),
        .CO({cnt_fsm0_carry__4_n_0,cnt_fsm0_carry__4_n_1,cnt_fsm0_carry__4_n_2,cnt_fsm0_carry__4_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__4_n_4,cnt_fsm0_carry__4_n_5,cnt_fsm0_carry__4_n_6,cnt_fsm0_carry__4_n_7}),
        .S({\cnt_fsm_reg_n_0_[24] ,\cnt_fsm_reg_n_0_[23] ,\cnt_fsm_reg_n_0_[22] ,\cnt_fsm_reg_n_0_[21] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__5
       (.CI(cnt_fsm0_carry__4_n_0),
        .CO({cnt_fsm0_carry__5_n_0,cnt_fsm0_carry__5_n_1,cnt_fsm0_carry__5_n_2,cnt_fsm0_carry__5_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_fsm0_carry__5_n_4,cnt_fsm0_carry__5_n_5,cnt_fsm0_carry__5_n_6,cnt_fsm0_carry__5_n_7}),
        .S({\cnt_fsm_reg_n_0_[28] ,\cnt_fsm_reg_n_0_[27] ,\cnt_fsm_reg_n_0_[26] ,\cnt_fsm_reg_n_0_[25] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_fsm0_carry__6
       (.CI(cnt_fsm0_carry__5_n_0),
        .CO({NLW_cnt_fsm0_carry__6_CO_UNCONNECTED[3:1],cnt_fsm0_carry__6_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_cnt_fsm0_carry__6_O_UNCONNECTED[3:2],cnt_fsm0_carry__6_n_6,cnt_fsm0_carry__6_n_7}),
        .S({1'b0,1'b0,\cnt_fsm_reg_n_0_[30] ,\cnt_fsm_reg_n_0_[29] }));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \cnt_fsm[0]_i_1 
       (.I0(\cnt_fsm_reg_n_0_[0] ),
        .O(\cnt_fsm[0]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \cnt_fsm[30]_i_1 
       (.I0(\FSM_sequential_fsm_current_state[1]_i_3_n_0 ),
        .O(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\cnt_fsm[0]_i_1_n_0 ),
        .Q(\cnt_fsm_reg_n_0_[0] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__1_n_6),
        .Q(\cnt_fsm_reg_n_0_[10] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__1_n_5),
        .Q(\cnt_fsm_reg_n_0_[11] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__1_n_4),
        .Q(\cnt_fsm_reg_n_0_[12] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__2_n_7),
        .Q(\cnt_fsm_reg_n_0_[13] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__2_n_6),
        .Q(\cnt_fsm_reg_n_0_[14] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__2_n_5),
        .Q(\cnt_fsm_reg_n_0_[15] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__2_n_4),
        .Q(\cnt_fsm_reg_n_0_[16] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__3_n_7),
        .Q(\cnt_fsm_reg_n_0_[17] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__3_n_6),
        .Q(\cnt_fsm_reg_n_0_[18] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__3_n_5),
        .Q(\cnt_fsm_reg_n_0_[19] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry_n_7),
        .Q(\cnt_fsm_reg_n_0_[1] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__3_n_4),
        .Q(\cnt_fsm_reg_n_0_[20] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__4_n_7),
        .Q(\cnt_fsm_reg_n_0_[21] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__4_n_6),
        .Q(\cnt_fsm_reg_n_0_[22] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__4_n_5),
        .Q(\cnt_fsm_reg_n_0_[23] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__4_n_4),
        .Q(\cnt_fsm_reg_n_0_[24] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[25] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__5_n_7),
        .Q(\cnt_fsm_reg_n_0_[25] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[26] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__5_n_6),
        .Q(\cnt_fsm_reg_n_0_[26] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[27] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__5_n_5),
        .Q(\cnt_fsm_reg_n_0_[27] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[28] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__5_n_4),
        .Q(\cnt_fsm_reg_n_0_[28] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[29] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__6_n_7),
        .Q(\cnt_fsm_reg_n_0_[29] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry_n_6),
        .Q(\cnt_fsm_reg_n_0_[2] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[30] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__6_n_6),
        .Q(\cnt_fsm_reg_n_0_[30] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry_n_5),
        .Q(\cnt_fsm_reg_n_0_[3] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry_n_4),
        .Q(\cnt_fsm_reg_n_0_[4] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__0_n_7),
        .Q(\cnt_fsm_reg_n_0_[5] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__0_n_6),
        .Q(\cnt_fsm_reg_n_0_[6] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__0_n_5),
        .Q(\cnt_fsm_reg_n_0_[7] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__0_n_4),
        .Q(\cnt_fsm_reg_n_0_[8] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_fsm_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_fsm0_carry__1_n_7),
        .Q(\cnt_fsm_reg_n_0_[9] ),
        .R(\cnt_fsm[30]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_1),
        .Q(cnt[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__1_n_6),
        .Q(cnt[10]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__1_n_5),
        .Q(cnt[11]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__1_n_4),
        .Q(cnt[12]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__2_n_7),
        .Q(cnt[13]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__2_n_6),
        .Q(cnt[14]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__2_n_5),
        .Q(cnt[15]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[16] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__2_n_4),
        .Q(cnt[16]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[17] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__3_n_7),
        .Q(cnt[17]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[18] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__3_n_6),
        .Q(cnt[18]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[19] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__3_n_5),
        .Q(cnt[19]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry_n_7),
        .Q(cnt[1]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[20] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__3_n_4),
        .Q(cnt[20]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[21] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__4_n_7),
        .Q(cnt[21]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[22] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__4_n_6),
        .Q(cnt[22]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[23] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__4_n_5),
        .Q(cnt[23]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[24] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__4_n_4),
        .Q(cnt[24]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry_n_6),
        .Q(cnt[2]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry_n_5),
        .Q(cnt[3]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry_n_4),
        .Q(cnt[4]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__0_n_7),
        .Q(cnt[5]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__0_n_6),
        .Q(cnt[6]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__0_n_5),
        .Q(cnt[7]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__0_n_4),
        .Q(cnt[8]),
        .R(cnt_seconds_0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt0_carry__1_n_7),
        .Q(cnt[9]),
        .R(cnt_seconds_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_row_swap0_carry
       (.CI(1'b0),
        .CO({cnt_row_swap0_carry_n_0,cnt_row_swap0_carry_n_1,cnt_row_swap0_carry_n_2,cnt_row_swap0_carry_n_3}),
        .CYINIT(cnt_row_swap[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_row_swap0_carry_n_4,cnt_row_swap0_carry_n_5,cnt_row_swap0_carry_n_6,cnt_row_swap0_carry_n_7}),
        .S(cnt_row_swap[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_row_swap0_carry__0
       (.CI(cnt_row_swap0_carry_n_0),
        .CO({cnt_row_swap0_carry__0_n_0,cnt_row_swap0_carry__0_n_1,cnt_row_swap0_carry__0_n_2,cnt_row_swap0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_row_swap0_carry__0_n_4,cnt_row_swap0_carry__0_n_5,cnt_row_swap0_carry__0_n_6,cnt_row_swap0_carry__0_n_7}),
        .S(cnt_row_swap[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_row_swap0_carry__1
       (.CI(cnt_row_swap0_carry__0_n_0),
        .CO({cnt_row_swap0_carry__1_n_0,cnt_row_swap0_carry__1_n_1,cnt_row_swap0_carry__1_n_2,cnt_row_swap0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({cnt_row_swap0_carry__1_n_4,cnt_row_swap0_carry__1_n_5,cnt_row_swap0_carry__1_n_6,cnt_row_swap0_carry__1_n_7}),
        .S(cnt_row_swap[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 cnt_row_swap0_carry__2
       (.CI(cnt_row_swap0_carry__1_n_0),
        .CO({NLW_cnt_row_swap0_carry__2_CO_UNCONNECTED[3:2],cnt_row_swap0_carry__2_n_2,cnt_row_swap0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_cnt_row_swap0_carry__2_O_UNCONNECTED[3],cnt_row_swap0_carry__2_n_5,cnt_row_swap0_carry__2_n_6,cnt_row_swap0_carry__2_n_7}),
        .S({1'b0,cnt_row_swap[15:13]}));
  LUT1 #(
    .INIT(2'h1)) 
    \cnt_row_swap[0]_i_1 
       (.I0(cnt_row_swap[0]),
        .O(cnt_row_swap_2));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap_2),
        .Q(cnt_row_swap[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[10] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__1_n_6),
        .Q(cnt_row_swap[10]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[11] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__1_n_5),
        .Q(cnt_row_swap[11]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[12] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__1_n_4),
        .Q(cnt_row_swap[12]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[13] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__2_n_7),
        .Q(cnt_row_swap[13]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[14] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__2_n_6),
        .Q(cnt_row_swap[14]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[15] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__2_n_5),
        .Q(cnt_row_swap[15]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry_n_7),
        .Q(cnt_row_swap[1]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry_n_6),
        .Q(cnt_row_swap[2]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry_n_5),
        .Q(cnt_row_swap[3]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry_n_4),
        .Q(cnt_row_swap[4]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__0_n_7),
        .Q(cnt_row_swap[5]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__0_n_6),
        .Q(cnt_row_swap[6]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__0_n_5),
        .Q(cnt_row_swap[7]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[8] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__0_n_4),
        .Q(cnt_row_swap[8]),
        .R(\row_select[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_row_swap_reg[9] 
       (.C(clk),
        .CE(1'b1),
        .D(cnt_row_swap0_carry__1_n_7),
        .Q(cnt_row_swap[9]),
        .R(\row_select[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \cnt_seconds[0]_i_1 
       (.I0(cnt_seconds[0]),
        .O(p_0_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'h0FD0)) 
    \cnt_seconds[1]_i_1 
       (.I0(cnt_seconds[3]),
        .I1(cnt_seconds[2]),
        .I2(cnt_seconds[0]),
        .I3(cnt_seconds[1]),
        .O(p_0_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h6C)) 
    \cnt_seconds[2]_i_1 
       (.I0(cnt_seconds[1]),
        .I1(cnt_seconds[2]),
        .I2(cnt_seconds[0]),
        .O(p_0_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h6CC4)) 
    \cnt_seconds[3]_i_1 
       (.I0(cnt_seconds[0]),
        .I1(cnt_seconds[3]),
        .I2(cnt_seconds[2]),
        .I3(cnt_seconds[1]),
        .O(p_0_in[3]));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_seconds_reg[0] 
       (.C(clk),
        .CE(cnt_seconds_0),
        .D(p_0_in[0]),
        .Q(cnt_seconds[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_seconds_reg[1] 
       (.C(clk),
        .CE(cnt_seconds_0),
        .D(p_0_in[1]),
        .Q(cnt_seconds[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_seconds_reg[2] 
       (.C(clk),
        .CE(cnt_seconds_0),
        .D(p_0_in[2]),
        .Q(cnt_seconds[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_seconds_reg[3] 
       (.C(clk),
        .CE(cnt_seconds_0),
        .D(p_0_in[3]),
        .Q(cnt_seconds[3]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h0FB0)) 
    \cnt_tens[0]_i_1 
       (.I0(\cnt_tens_reg_n_0_[1] ),
        .I1(\cnt_tens_reg_n_0_[2] ),
        .I2(cnt_tens),
        .I3(\cnt_tens_reg_n_0_[0] ),
        .O(\cnt_tens[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \cnt_tens[1]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(cnt_tens),
        .I2(\cnt_tens_reg_n_0_[1] ),
        .O(\cnt_tens[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'h6F80)) 
    \cnt_tens[2]_i_1 
       (.I0(\cnt_tens_reg_n_0_[1] ),
        .I1(\cnt_tens_reg_n_0_[0] ),
        .I2(cnt_tens),
        .I3(\cnt_tens_reg_n_0_[2] ),
        .O(\cnt_tens[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'h00001000)) 
    \cnt_tens[2]_i_2 
       (.I0(cnt_seconds[1]),
        .I1(cnt_seconds[2]),
        .I2(cnt_seconds[0]),
        .I3(cnt_seconds[3]),
        .I4(\cnt[24]_i_2_n_0 ),
        .O(cnt_tens));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_tens_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .D(\cnt_tens[0]_i_1_n_0 ),
        .Q(\cnt_tens_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_tens_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .D(\cnt_tens[1]_i_1_n_0 ),
        .Q(\cnt_tens_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_tens_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .D(\cnt_tens[2]_i_1_n_0 ),
        .Q(\cnt_tens_reg_n_0_[2] ),
        .R(1'b0));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[0] 
       (.CLR(1'b0),
        .D(col_select[0]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[0]));
  LUT6 #(
    .INIT(64'hFAEEAAAAAAAAAAAA)) 
    \col_select_reg[0]_i_1 
       (.I0(\col_select_reg[7]_i_3_n_0 ),
        .I1(\col_select_reg[0]_i_2_n_0 ),
        .I2(\col_select_reg[0]_i_3_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(fsm_current_state[1]),
        .I5(fsm_current_state[0]),
        .O(col_select[0]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[0]_i_2 
       (.I0(\cell_animation_reg_n_0_[1] ),
        .I1(\cell_animation_reg_n_0_[3] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[0] ),
        .I5(\cell_animation_reg_n_0_[2] ),
        .O(\col_select_reg[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[0]_i_3 
       (.I0(\cell_animation_reg_n_0_[5] ),
        .I1(\cell_animation_reg_n_0_[7] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[4] ),
        .I5(\cell_animation_reg_n_0_[6] ),
        .O(\col_select_reg[0]_i_3_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[1] 
       (.CLR(1'b0),
        .D(col_select[1]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[1]));
  LUT6 #(
    .INIT(64'hFFFFFFFFC0804000)) 
    \col_select_reg[1]_i_1 
       (.I0(\col_select_reg[7]_i_6_n_0 ),
        .I1(fsm_current_state[0]),
        .I2(fsm_current_state[1]),
        .I3(\col_select_reg[1]_i_2_n_0 ),
        .I4(\col_select_reg[1]_i_3_n_0 ),
        .I5(\col_select_reg[1]_i_4_n_0 ),
        .O(col_select[1]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[1]_i_2 
       (.I0(\cell_animation_reg_n_0_[136] ),
        .I1(\cell_animation_reg_n_0_[138] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[135] ),
        .I5(\cell_animation_reg_n_0_[137] ),
        .O(\col_select_reg[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[1]_i_3 
       (.I0(\cell_animation_reg_n_0_[140] ),
        .I1(\cell_animation_reg_n_0_[142] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[139] ),
        .I5(\cell_animation_reg_n_0_[141] ),
        .O(\col_select_reg[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00000000DD88CFC0)) 
    \col_select_reg[1]_i_4 
       (.I0(\col_select_reg[1]_i_5_n_0 ),
        .I1(\cell_generator[56].cell_reg_n_0_[56] ),
        .I2(\col_select_reg[6]_i_6_n_0 ),
        .I3(\cell_generator[58].cell_reg_n_0_[58] ),
        .I4(\col_select_reg[7]_i_6_n_0 ),
        .I5(\i[21]_i_2_n_0 ),
        .O(\col_select_reg[1]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF7FFFFFF77FFFFFF)) 
    \col_select_reg[1]_i_5 
       (.I0(Q[5]),
        .I1(Q[1]),
        .I2(Q[6]),
        .I3(Q[7]),
        .I4(Q[3]),
        .I5(Q[2]),
        .O(\col_select_reg[1]_i_5_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[2] 
       (.CLR(1'b0),
        .D(col_select[2]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[2]));
  LUT6 #(
    .INIT(64'hCAFFCAF0CA0FCA00)) 
    \col_select_reg[2]_i_1 
       (.I0(\col_select_reg[2]_i_2_n_0 ),
        .I1(\col_select_reg[2]_i_3_n_0 ),
        .I2(\i[21]_i_2_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(\col_select_reg[2]_i_4_n_0 ),
        .I5(\col_select_reg[2]_i_5_n_0 ),
        .O(col_select[2]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[2]_i_2 
       (.I0(\cell_generator[49].cell_reg_n_0_[49] ),
        .I1(\cell_generator[23].cell_reg_n_0_[23] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[56].cell_reg_n_0_[56] ),
        .I5(\cell_generator[22].cell_reg_n_0_[22] ),
        .O(\col_select_reg[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[2]_i_3 
       (.I0(\cell_animation_reg_n_0_[275] ),
        .I1(\cell_animation_reg_n_0_[277] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[274] ),
        .I5(\cell_animation_reg_n_0_[276] ),
        .O(\col_select_reg[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFC0CFAFAFC0C0A0A)) 
    \col_select_reg[2]_i_4 
       (.I0(\cell_generator[49].cell_reg_n_0_[49] ),
        .I1(\cell_generator[48].cell_reg_n_0_[48] ),
        .I2(\col_select_reg[7]_i_8_n_0 ),
        .I3(\cell_generator[56].cell_reg_n_0_[56] ),
        .I4(\col_select_reg[7]_i_9_n_0 ),
        .I5(\cell_generator[32].cell_reg_n_0_[32] ),
        .O(\col_select_reg[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[2]_i_5 
       (.I0(\cell_animation_reg_n_0_[271] ),
        .I1(\cell_animation_reg_n_0_[273] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[270] ),
        .I5(\cell_animation_reg_n_0_[272] ),
        .O(\col_select_reg[2]_i_5_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[3] 
       (.CLR(1'b0),
        .D(col_select[3]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[3]));
  LUT6 #(
    .INIT(64'hCAFFCAF0CA0FCA00)) 
    \col_select_reg[3]_i_1 
       (.I0(\col_select_reg[3]_i_2_n_0 ),
        .I1(\col_select_reg[3]_i_3_n_0 ),
        .I2(\i[21]_i_2_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(\col_select_reg[3]_i_4_n_0 ),
        .I5(\col_select_reg[3]_i_5_n_0 ),
        .O(col_select[3]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[3]_i_2 
       (.I0(\cell_generator[29].cell_reg_n_0_[29] ),
        .I1(\cell_generator[31].cell_reg_n_0_[31] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[56].cell_reg_n_0_[56] ),
        .I5(\cell_generator[46].cell_reg_n_0_[46] ),
        .O(\col_select_reg[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[3]_i_3 
       (.I0(\cell_animation_reg_n_0_[410] ),
        .I1(\cell_animation_reg_n_0_[412] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[409] ),
        .I5(\cell_animation_reg_n_0_[411] ),
        .O(\col_select_reg[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[3]_i_4 
       (.I0(\cell_generator[41].cell_reg_n_0_[41] ),
        .I1(\cell_generator[56].cell_reg_n_0_[56] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[24].cell_reg_n_0_[24] ),
        .I5(\cell_generator[26].cell_reg_n_0_[26] ),
        .O(\col_select_reg[3]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[3]_i_5 
       (.I0(\cell_animation_reg_n_0_[406] ),
        .I1(\cell_animation_reg_n_0_[408] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[405] ),
        .I5(\cell_animation_reg_n_0_[407] ),
        .O(\col_select_reg[3]_i_5_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[4] 
       (.CLR(1'b0),
        .D(col_select[4]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[4]));
  LUT6 #(
    .INIT(64'hCAFFCAF0CA0FCA00)) 
    \col_select_reg[4]_i_1 
       (.I0(\col_select_reg[4]_i_2_n_0 ),
        .I1(\col_select_reg[4]_i_3_n_0 ),
        .I2(\i[21]_i_2_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(\col_select_reg[4]_i_4_n_0 ),
        .I5(\col_select_reg[4]_i_5_n_0 ),
        .O(col_select[4]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[4]_i_2 
       (.I0(\cell_generator[37].cell_reg_n_0_[37] ),
        .I1(\cell_generator[39].cell_reg_n_0_[39] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[56].cell_reg_n_0_[56] ),
        .I5(\cell_generator[38].cell_reg_n_0_[38] ),
        .O(\col_select_reg[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[4]_i_3 
       (.I0(\cell_animation_reg_n_0_[545] ),
        .I1(\cell_animation_reg_n_0_[547] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[544] ),
        .I5(\cell_animation_reg_n_0_[546] ),
        .O(\col_select_reg[4]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'hE2FFE200)) 
    \col_select_reg[4]_i_4 
       (.I0(\cell_generator[33].cell_reg_n_0_[33] ),
        .I1(\col_select_reg[7]_i_8_n_0 ),
        .I2(\cell_generator[56].cell_reg_n_0_[56] ),
        .I3(\col_select_reg[7]_i_9_n_0 ),
        .I4(\cell_generator[32].cell_reg_n_0_[32] ),
        .O(\col_select_reg[4]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[4]_i_5 
       (.I0(\cell_animation_reg_n_0_[541] ),
        .I1(\cell_animation_reg_n_0_[543] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[540] ),
        .I5(\cell_animation_reg_n_0_[542] ),
        .O(\col_select_reg[4]_i_5_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[5] 
       (.CLR(1'b0),
        .D(col_select[5]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[5]));
  LUT6 #(
    .INIT(64'hCAFFCAF0CA0FCA00)) 
    \col_select_reg[5]_i_1 
       (.I0(\col_select_reg[5]_i_2_n_0 ),
        .I1(\col_select_reg[5]_i_3_n_0 ),
        .I2(\i[21]_i_2_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(\col_select_reg[5]_i_4_n_0 ),
        .I5(\col_select_reg[5]_i_5_n_0 ),
        .O(col_select[5]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[5]_i_2 
       (.I0(\cell_generator[45].cell_reg_n_0_[45] ),
        .I1(\cell_generator[47].cell_reg_n_0_[47] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[58].cell_reg_n_0_[58] ),
        .I5(\cell_generator[46].cell_reg_n_0_[46] ),
        .O(\col_select_reg[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[5]_i_3 
       (.I0(\cell_animation_reg_n_0_[680] ),
        .I1(\cell_animation_reg_n_0_[682] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[679] ),
        .I5(\cell_animation_reg_n_0_[681] ),
        .O(\col_select_reg[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[5]_i_4 
       (.I0(\cell_generator[41].cell_reg_n_0_[41] ),
        .I1(\cell_generator[58].cell_reg_n_0_[58] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[40].cell_reg_n_0_[40] ),
        .I5(\cell_generator[42].cell_reg_n_0_[42] ),
        .O(\col_select_reg[5]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[5]_i_5 
       (.I0(\cell_animation_reg_n_0_[676] ),
        .I1(\cell_animation_reg_n_0_[678] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[675] ),
        .I5(\cell_animation_reg_n_0_[677] ),
        .O(\col_select_reg[5]_i_5_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[6] 
       (.CLR(1'b0),
        .D(col_select[6]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[6]));
  LUT6 #(
    .INIT(64'hCAFFCAF0CA0FCA00)) 
    \col_select_reg[6]_i_1 
       (.I0(\col_select_reg[6]_i_2_n_0 ),
        .I1(\col_select_reg[6]_i_3_n_0 ),
        .I2(\i[21]_i_2_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(\col_select_reg[6]_i_4_n_0 ),
        .I5(\col_select_reg[6]_i_5_n_0 ),
        .O(col_select[6]));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[6]_i_2 
       (.I0(\cell_generator[53].cell_reg_n_0_[53] ),
        .I1(\cell_generator[48].cell_reg_n_0_[48] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_generator[56].cell_reg_n_0_[56] ),
        .I5(\cell_generator[54].cell_reg_n_0_[54] ),
        .O(\col_select_reg[6]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[6]_i_3 
       (.I0(\cell_animation_reg_n_0_[815] ),
        .I1(\cell_animation_reg_n_0_[817] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[814] ),
        .I5(\cell_animation_reg_n_0_[816] ),
        .O(\col_select_reg[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF22F222F222F2)) 
    \col_select_reg[6]_i_4 
       (.I0(\cell_generator[48].cell_reg_n_0_[48] ),
        .I1(\col_select_reg[7]_i_9_n_0 ),
        .I2(\cell_generator[49].cell_reg_n_0_[49] ),
        .I3(\col_select_reg[6]_i_6_n_0 ),
        .I4(\cell_generator[56].cell_reg_n_0_[56] ),
        .I5(\col_select_reg[6]_i_7_n_0 ),
        .O(\col_select_reg[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[6]_i_5 
       (.I0(\cell_animation_reg_n_0_[811] ),
        .I1(\cell_animation_reg_n_0_[813] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[810] ),
        .I5(\cell_animation_reg_n_0_[812] ),
        .O(\col_select_reg[6]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hF7FFFFFF77FFFFFF)) 
    \col_select_reg[6]_i_6 
       (.I0(Q[6]),
        .I1(Q[2]),
        .I2(Q[5]),
        .I3(Q[7]),
        .I4(Q[3]),
        .I5(Q[1]),
        .O(\col_select_reg[6]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h07FFFFFF77FFFFFF)) 
    \col_select_reg[6]_i_7 
       (.I0(Q[6]),
        .I1(Q[2]),
        .I2(Q[5]),
        .I3(Q[7]),
        .I4(Q[3]),
        .I5(Q[1]),
        .O(\col_select_reg[6]_i_7_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \col_select_reg[7] 
       (.CLR(1'b0),
        .D(col_select[7]),
        .G(\col_select_reg[7]_i_2_n_0 ),
        .GE(1'b1),
        .Q(col[7]));
  LUT6 #(
    .INIT(64'hFAEEAAAAAAAAAAAA)) 
    \col_select_reg[7]_i_1 
       (.I0(\col_select_reg[7]_i_3_n_0 ),
        .I1(\col_select_reg[7]_i_4_n_0 ),
        .I2(\col_select_reg[7]_i_5_n_0 ),
        .I3(\col_select_reg[7]_i_6_n_0 ),
        .I4(fsm_current_state[1]),
        .I5(fsm_current_state[0]),
        .O(col_select[7]));
  LUT6 #(
    .INIT(64'hFF00404040400000)) 
    \col_select_reg[7]_i_2 
       (.I0(\col_select_reg[7]_i_6_n_0 ),
        .I1(Q[3]),
        .I2(Q[2]),
        .I3(\col_select_reg[7]_i_7_n_0 ),
        .I4(Q[0]),
        .I5(Q[1]),
        .O(\col_select_reg[7]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000EB28EB28EB28)) 
    \col_select_reg[7]_i_3 
       (.I0(\cell_generator[58].cell_reg_n_0_[58] ),
        .I1(\col_select_reg[7]_i_8_n_0 ),
        .I2(\col_select_reg[7]_i_6_n_0 ),
        .I3(\cell_generator[56].cell_reg_n_0_[56] ),
        .I4(fsm_current_state[1]),
        .I5(fsm_current_state[0]),
        .O(\col_select_reg[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[7]_i_4 
       (.I0(\cell_animation_reg_n_0_[946] ),
        .I1(\cell_animation_reg_n_0_[948] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(data00),
        .I5(\cell_animation_reg_n_0_[947] ),
        .O(\col_select_reg[7]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hCFAFCFA0C0AFC0A0)) 
    \col_select_reg[7]_i_5 
       (.I0(\cell_animation_reg_n_0_[950] ),
        .I1(\cell_animation_reg_n_0_[952] ),
        .I2(\col_select_reg[7]_i_9_n_0 ),
        .I3(\col_select_reg[7]_i_8_n_0 ),
        .I4(\cell_animation_reg_n_0_[949] ),
        .I5(\cell_animation_reg_n_0_[951] ),
        .O(\col_select_reg[7]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \col_select_reg[7]_i_6 
       (.I0(Q[5]),
        .I1(Q[6]),
        .I2(Q[7]),
        .I3(Q[4]),
        .O(\col_select_reg[7]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h6880800080000000)) 
    \col_select_reg[7]_i_7 
       (.I0(Q[2]),
        .I1(Q[5]),
        .I2(Q[7]),
        .I3(Q[6]),
        .I4(Q[3]),
        .I5(Q[4]),
        .O(\col_select_reg[7]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \col_select_reg[7]_i_8 
       (.I0(Q[2]),
        .I1(Q[3]),
        .I2(Q[7]),
        .I3(Q[6]),
        .O(\col_select_reg[7]_i_8_n_0 ));
  LUT4 #(
    .INIT(16'h7FFF)) 
    \col_select_reg[7]_i_9 
       (.I0(Q[1]),
        .I1(Q[3]),
        .I2(Q[7]),
        .I3(Q[5]),
        .O(\col_select_reg[7]_i_9_n_0 ));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry
       (.CI(1'b0),
        .CO({i0_carry_n_0,i0_carry_n_1,i0_carry_n_2,i0_carry_n_3}),
        .CYINIT(i[0]),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({i0_carry_n_4,i0_carry_n_5,i0_carry_n_6,i0_carry_n_7}),
        .S(i[4:1]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry__0
       (.CI(i0_carry_n_0),
        .CO({i0_carry__0_n_0,i0_carry__0_n_1,i0_carry__0_n_2,i0_carry__0_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({i0_carry__0_n_4,i0_carry__0_n_5,i0_carry__0_n_6,i0_carry__0_n_7}),
        .S(i[8:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry__1
       (.CI(i0_carry__0_n_0),
        .CO({i0_carry__1_n_0,i0_carry__1_n_1,i0_carry__1_n_2,i0_carry__1_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({i0_carry__1_n_4,i0_carry__1_n_5,i0_carry__1_n_6,i0_carry__1_n_7}),
        .S(i[12:9]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry__2
       (.CI(i0_carry__1_n_0),
        .CO({i0_carry__2_n_0,i0_carry__2_n_1,i0_carry__2_n_2,i0_carry__2_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({i0_carry__2_n_4,i0_carry__2_n_5,i0_carry__2_n_6,i0_carry__2_n_7}),
        .S(i[16:13]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry__3
       (.CI(i0_carry__2_n_0),
        .CO({i0_carry__3_n_0,i0_carry__3_n_1,i0_carry__3_n_2,i0_carry__3_n_3}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({i0_carry__3_n_4,i0_carry__3_n_5,i0_carry__3_n_6,i0_carry__3_n_7}),
        .S(i[20:17]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 i0_carry__4
       (.CI(i0_carry__3_n_0),
        .CO(NLW_i0_carry__4_CO_UNCONNECTED[3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_i0_carry__4_O_UNCONNECTED[3:1],i0_carry__4_n_7}),
        .S({1'b0,1'b0,1'b0,i[21]}));
  LUT6 #(
    .INIT(64'h00000000FFFFFFEF)) 
    \i[0]_i_1 
       (.I0(\i[21]_i_3_n_0 ),
        .I1(\i[21]_i_4_n_0 ),
        .I2(\i[21]_i_5_n_0 ),
        .I3(i[9]),
        .I4(i[7]),
        .I5(i[0]),
        .O(\i[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000200)) 
    \i[21]_i_1 
       (.I0(\i[21]_i_2_n_0 ),
        .I1(\i[21]_i_3_n_0 ),
        .I2(\i[21]_i_4_n_0 ),
        .I3(\i[21]_i_5_n_0 ),
        .I4(i[9]),
        .I5(i[7]),
        .O(\i[21]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \i[21]_i_2 
       (.I0(fsm_current_state[0]),
        .I1(fsm_current_state[1]),
        .O(\i[21]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFF7FFF)) 
    \i[21]_i_3 
       (.I0(i[3]),
        .I1(i[11]),
        .I2(i[10]),
        .I3(i[4]),
        .I4(\i[21]_i_6_n_0 ),
        .O(\i[21]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFFFFFFF7)) 
    \i[21]_i_4 
       (.I0(i[15]),
        .I1(i[16]),
        .I2(i[19]),
        .I3(i[12]),
        .I4(i[14]),
        .O(\i[21]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \i[21]_i_5 
       (.I0(i[8]),
        .I1(i[6]),
        .O(\i[21]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFF7FFFFFFF)) 
    \i[21]_i_6 
       (.I0(i[13]),
        .I1(i[2]),
        .I2(i[5]),
        .I3(i[21]),
        .I4(i[0]),
        .I5(\i[21]_i_7_n_0 ),
        .O(\i[21]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFF7F)) 
    \i[21]_i_7 
       (.I0(i[18]),
        .I1(i[1]),
        .I2(i[17]),
        .I3(i[20]),
        .O(\i[21]_i_7_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[0] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(\i[0]_i_1_n_0 ),
        .Q(i[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[10] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__1_n_6),
        .Q(i[10]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[11] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__1_n_5),
        .Q(i[11]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[12] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__1_n_4),
        .Q(i[12]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[13] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__2_n_7),
        .Q(i[13]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[14] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__2_n_6),
        .Q(i[14]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[15] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__2_n_5),
        .Q(i[15]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[16] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__2_n_4),
        .Q(i[16]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[17] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__3_n_7),
        .Q(i[17]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[18] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__3_n_6),
        .Q(i[18]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[19] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__3_n_5),
        .Q(i[19]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[1] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry_n_7),
        .Q(i[1]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[20] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__3_n_4),
        .Q(i[20]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[21] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__4_n_7),
        .Q(i[21]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[2] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry_n_6),
        .Q(i[2]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[3] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry_n_5),
        .Q(i[3]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[4] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry_n_4),
        .Q(i[4]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[5] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__0_n_7),
        .Q(i[5]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[6] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__0_n_6),
        .Q(i[6]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[7] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__0_n_5),
        .Q(i[7]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[8] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__0_n_4),
        .Q(i[8]),
        .R(\i[21]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \i_reg[9] 
       (.C(clk),
        .CE(\i[21]_i_2_n_0 ),
        .D(i0_carry__1_n_7),
        .Q(i[9]),
        .R(\i[21]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[22] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[22]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[22] ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFBFBFB)) 
    \rom_memory_reg[22]_i_1 
       (.I0(cnt_seconds[1]),
        .I1(cnt_seconds[2]),
        .I2(cnt_seconds[0]),
        .I3(\cnt_tens_reg_n_0_[1] ),
        .I4(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000AAAAAAAB)) 
    \rom_memory_reg[22]_i_2 
       (.I0(\rom_memory_reg[22]_i_3_n_0 ),
        .I1(cnt_seconds[1]),
        .I2(cnt_seconds[2]),
        .I3(cnt_seconds[3]),
        .I4(cnt_seconds[0]),
        .I5(\cnt_tens_reg_n_0_[2] ),
        .O(\rom_memory_reg[22]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT2 #(
    .INIT(4'h7)) 
    \rom_memory_reg[22]_i_3 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .O(\rom_memory_reg[22]_i_3_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[23] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[23]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[23] ));
  LUT6 #(
    .INIT(64'hFFFFFEEFFEEFFEEF)) 
    \rom_memory_reg[23]_i_1 
       (.I0(cnt_seconds[3]),
        .I1(cnt_seconds[1]),
        .I2(cnt_seconds[0]),
        .I3(cnt_seconds[2]),
        .I4(\cnt_tens_reg_n_0_[0] ),
        .I5(\cnt_tens_reg_n_0_[1] ),
        .O(\rom_memory_reg[23]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[24] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[24]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[24] ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \rom_memory_reg[24]_i_1 
       (.I0(\cnt_tens_reg_n_0_[1] ),
        .I1(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[24]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[29] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[29]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[29] ));
  LUT6 #(
    .INIT(64'h88FF88F8F8FFF8FF)) 
    \rom_memory_reg[29]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .I2(cnt_seconds[2]),
        .I3(cnt_seconds[1]),
        .I4(cnt_seconds[3]),
        .I5(cnt_seconds[0]),
        .O(\rom_memory_reg[29]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[31] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[31]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[31] ));
  LUT6 #(
    .INIT(64'hF8FFF8F88FFF8FFF)) 
    \rom_memory_reg[31]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .I2(cnt_seconds[1]),
        .I3(cnt_seconds[2]),
        .I4(cnt_seconds[3]),
        .I5(cnt_seconds[0]),
        .O(\rom_memory_reg[31]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[32] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[32]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[32] ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \rom_memory_reg[32]_i_1 
       (.I0(\cnt_tens_reg_n_0_[1] ),
        .I1(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[32]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[33] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[33]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[33] ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \rom_memory_reg[33]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .O(\rom_memory_reg[33]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[37] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[37]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[37] ));
  LUT6 #(
    .INIT(64'hF8FFFFFFFFFFF8FF)) 
    \rom_memory_reg[37]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .I2(cnt_seconds[3]),
        .I3(cnt_seconds[0]),
        .I4(cnt_seconds[1]),
        .I5(cnt_seconds[2]),
        .O(\rom_memory_reg[37]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[38] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[38]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[38] ));
  LUT6 #(
    .INIT(64'h0BBB0FFF0FFF0EEE)) 
    \rom_memory_reg[38]_i_1 
       (.I0(cnt_seconds[3]),
        .I1(cnt_seconds[2]),
        .I2(\cnt_tens_reg_n_0_[0] ),
        .I3(\cnt_tens_reg_n_0_[1] ),
        .I4(cnt_seconds[0]),
        .I5(cnt_seconds[1]),
        .O(\rom_memory_reg[38]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[39] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[39]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[39] ));
  LUT6 #(
    .INIT(64'hFFFFFFEFFFEFFFEF)) 
    \rom_memory_reg[39]_i_1 
       (.I0(cnt_seconds[1]),
        .I1(cnt_seconds[2]),
        .I2(cnt_seconds[0]),
        .I3(cnt_seconds[3]),
        .I4(\cnt_tens_reg_n_0_[1] ),
        .I5(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[39]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[40] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[40]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[40] ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \rom_memory_reg[40]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[40]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[41] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[41]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[41] ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \rom_memory_reg[41]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .O(\rom_memory_reg[41]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[42] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[42]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[42] ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \rom_memory_reg[42]_i_1 
       (.I0(\cnt_tens_reg_n_0_[1] ),
        .I1(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[42]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[45] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[45]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[45] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFF454545)) 
    \rom_memory_reg[45]_i_1 
       (.I0(cnt_seconds[0]),
        .I1(cnt_seconds[1]),
        .I2(cnt_seconds[2]),
        .I3(\cnt_tens_reg_n_0_[1] ),
        .I4(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[45]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[46] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[46]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[46] ));
  LUT6 #(
    .INIT(64'h0000000000000700)) 
    \rom_memory_reg[46]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .I2(cnt_seconds[3]),
        .I3(cnt_seconds[0]),
        .I4(cnt_seconds[2]),
        .I5(cnt_seconds[1]),
        .O(\rom_memory_reg[46]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[47] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[47]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[47] ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFF88F)) 
    \rom_memory_reg[47]_i_1 
       (.I0(\cnt_tens_reg_n_0_[0] ),
        .I1(\cnt_tens_reg_n_0_[1] ),
        .I2(cnt_seconds[0]),
        .I3(cnt_seconds[1]),
        .I4(cnt_seconds[3]),
        .I5(cnt_seconds[2]),
        .O(\rom_memory_reg[47]_i_1_n_0 ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[48] 
       (.CLR(1'b0),
        .D(1'b1),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[48] ));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \rom_memory_reg[53] 
       (.CLR(1'b0),
        .D(\rom_memory_reg[53]_i_1_n_0 ),
        .G(\rom_memory_reg[22]_i_2_n_0 ),
        .GE(1'b1),
        .Q(\rom_memory_reg_n_0_[53] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFF7D7D7D)) 
    \rom_memory_reg[53]_i_1 
       (.I0(cnt_seconds[2]),
        .I1(cnt_seconds[0]),
        .I2(cnt_seconds[1]),
        .I3(\cnt_tens_reg_n_0_[1] ),
        .I4(\cnt_tens_reg_n_0_[0] ),
        .O(\rom_memory_reg[53]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000040000000)) 
    \row_select[7]_i_1 
       (.I0(\row_select[7]_i_2_n_0 ),
        .I1(cnt_row_swap[1]),
        .I2(cnt_row_swap[0]),
        .I3(cnt_row_swap[3]),
        .I4(cnt_row_swap[2]),
        .I5(\row_select[7]_i_3_n_0 ),
        .O(\row_select[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFFEF)) 
    \row_select[7]_i_2 
       (.I0(cnt_row_swap[5]),
        .I1(cnt_row_swap[4]),
        .I2(cnt_row_swap[6]),
        .I3(cnt_row_swap[7]),
        .O(\row_select[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFEFFF)) 
    \row_select[7]_i_3 
       (.I0(cnt_row_swap[10]),
        .I1(cnt_row_swap[11]),
        .I2(cnt_row_swap[8]),
        .I3(cnt_row_swap[9]),
        .I4(\row_select[7]_i_4_n_0 ),
        .O(\row_select[7]_i_3_n_0 ));
  LUT4 #(
    .INIT(16'hEFFF)) 
    \row_select[7]_i_4 
       (.I0(cnt_row_swap[13]),
        .I1(cnt_row_swap[12]),
        .I2(cnt_row_swap[15]),
        .I3(cnt_row_swap[14]),
        .O(\row_select[7]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \row_select_reg[0] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[7]),
        .Q(Q[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[1] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[0]),
        .Q(Q[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[2] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[1]),
        .Q(Q[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[3] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[2]),
        .Q(Q[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[4] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[3]),
        .Q(Q[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[5] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[4]),
        .Q(Q[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[6] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[5]),
        .Q(Q[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b1)) 
    \row_select_reg[7] 
       (.C(clk),
        .CE(\row_select[7]_i_1_n_0 ),
        .D(Q[6]),
        .Q(Q[7]),
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

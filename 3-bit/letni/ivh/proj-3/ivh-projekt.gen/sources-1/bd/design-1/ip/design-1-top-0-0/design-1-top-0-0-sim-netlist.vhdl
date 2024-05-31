-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
-- Date        : Tue May 14 17:36:01 2024
-- Host        : DESKTOP-MHH9EC6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/lubos/ivh_projekt/ivh_projekt.gen/sources_1/bd/design_1/ip/design_1_top_0_0/design_1_top_0_0_sim_netlist.vhdl
-- Design      : design_1_top_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_top_0_0_top is
  port (
    col : out STD_LOGIC_VECTOR ( 7 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_top_0_0_top : entity is "top";
end design_1_top_0_0_top;

architecture STRUCTURE of design_1_top_0_0_top is
  signal \FSM_sequential_fsm_current_state[0]_i_10_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_11_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_12_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_13_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_14_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_15_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_16_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_17_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_5_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_6_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_7_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_8_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[0]_i_9_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_10_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_11_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_12_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_13_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_14_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_5_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_6_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_7_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_8_n_0\ : STD_LOGIC;
  signal \FSM_sequential_fsm_current_state[1]_i_9_n_0\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal cell_animation0 : STD_LOGIC;
  signal \cell_animation[0]_i_2_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_3_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_4_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_5_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_6_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_7_n_0\ : STD_LOGIC;
  signal \cell_animation[0]_i_8_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[1016]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[103]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[1048]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[143]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[174]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[206]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[238]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[278]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[309]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[341]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[373]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[39]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[413]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[444]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[476]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[508]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[548]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[579]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[611]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[643]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[683]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[714]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[71]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[746]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[778]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[818]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[849]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[881]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[8]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[913]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg[953]_srl31_n_0\ : STD_LOGIC;
  signal \cell_animation_reg[984]_srl32_n_1\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[0]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[135]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[136]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[137]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[138]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[139]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[140]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[141]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[142]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[1]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[270]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[271]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[272]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[273]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[274]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[275]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[276]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[277]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[2]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[3]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[405]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[406]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[407]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[408]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[409]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[410]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[411]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[412]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[4]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[540]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[541]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[542]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[543]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[544]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[545]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[546]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[547]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[5]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[675]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[676]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[677]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[678]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[679]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[680]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[681]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[682]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[6]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[7]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[810]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[811]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[812]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[813]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[814]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[815]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[816]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[817]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[946]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[947]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[948]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[949]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[950]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[951]\ : STD_LOGIC;
  signal \cell_animation_reg_n_0_[952]\ : STD_LOGIC;
  signal \cell_generator[22].cell_reg[22]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[22].cell_reg_n_0_[22]\ : STD_LOGIC;
  signal \cell_generator[23].cell_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[23].cell_reg_n_0_[23]\ : STD_LOGIC;
  signal \cell_generator[24].cell_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[24].cell_reg_n_0_[24]\ : STD_LOGIC;
  signal \cell_generator[26].cell_reg[26]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[26].cell_reg_n_0_[26]\ : STD_LOGIC;
  signal \cell_generator[29].cell_reg[29]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[29].cell_reg_n_0_[29]\ : STD_LOGIC;
  signal \cell_generator[31].cell_reg[31]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[31].cell_reg_n_0_[31]\ : STD_LOGIC;
  signal \cell_generator[32].cell_reg[32]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[32].cell_reg_n_0_[32]\ : STD_LOGIC;
  signal \cell_generator[33].cell_reg[33]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[33].cell_reg_n_0_[33]\ : STD_LOGIC;
  signal \cell_generator[37].cell_reg[37]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[37].cell_reg_n_0_[37]\ : STD_LOGIC;
  signal \cell_generator[38].cell_reg[38]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[38].cell_reg_n_0_[38]\ : STD_LOGIC;
  signal \cell_generator[39].cell_reg[39]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[39].cell_reg_n_0_[39]\ : STD_LOGIC;
  signal \cell_generator[40].cell_reg[40]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[40].cell_reg_n_0_[40]\ : STD_LOGIC;
  signal \cell_generator[41].cell_reg[41]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[41].cell_reg_n_0_[41]\ : STD_LOGIC;
  signal \cell_generator[42].cell_reg[42]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[42].cell_reg_n_0_[42]\ : STD_LOGIC;
  signal \cell_generator[45].cell_reg[45]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[45].cell_reg_n_0_[45]\ : STD_LOGIC;
  signal \cell_generator[46].cell_reg[46]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[46].cell_reg_n_0_[46]\ : STD_LOGIC;
  signal \cell_generator[47].cell_reg[47]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[47].cell_reg_n_0_[47]\ : STD_LOGIC;
  signal \cell_generator[48].cell_reg[48]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[48].cell_reg_n_0_[48]\ : STD_LOGIC;
  signal \cell_generator[49].cell_reg[49]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[49].cell_reg_n_0_[49]\ : STD_LOGIC;
  signal \cell_generator[53].cell_reg[53]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[53].cell_reg_n_0_[53]\ : STD_LOGIC;
  signal \cell_generator[54].cell_reg[54]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[54].cell_reg_n_0_[54]\ : STD_LOGIC;
  signal \cell_generator[56].cell_reg[56]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[56].cell_reg_n_0_[56]\ : STD_LOGIC;
  signal \cell_generator[58].cell_reg[58]_i_1_n_0\ : STD_LOGIC;
  signal \cell_generator[58].cell_reg[58]_i_2_n_0\ : STD_LOGIC;
  signal \cell_generator[58].cell_reg_n_0_[58]\ : STD_LOGIC;
  signal cnt : STD_LOGIC_VECTOR ( 24 downto 0 );
  signal \cnt0_carry__0_n_0\ : STD_LOGIC;
  signal \cnt0_carry__0_n_1\ : STD_LOGIC;
  signal \cnt0_carry__0_n_2\ : STD_LOGIC;
  signal \cnt0_carry__0_n_3\ : STD_LOGIC;
  signal \cnt0_carry__0_n_4\ : STD_LOGIC;
  signal \cnt0_carry__0_n_5\ : STD_LOGIC;
  signal \cnt0_carry__0_n_6\ : STD_LOGIC;
  signal \cnt0_carry__0_n_7\ : STD_LOGIC;
  signal \cnt0_carry__1_n_0\ : STD_LOGIC;
  signal \cnt0_carry__1_n_1\ : STD_LOGIC;
  signal \cnt0_carry__1_n_2\ : STD_LOGIC;
  signal \cnt0_carry__1_n_3\ : STD_LOGIC;
  signal \cnt0_carry__1_n_4\ : STD_LOGIC;
  signal \cnt0_carry__1_n_5\ : STD_LOGIC;
  signal \cnt0_carry__1_n_6\ : STD_LOGIC;
  signal \cnt0_carry__1_n_7\ : STD_LOGIC;
  signal \cnt0_carry__2_n_0\ : STD_LOGIC;
  signal \cnt0_carry__2_n_1\ : STD_LOGIC;
  signal \cnt0_carry__2_n_2\ : STD_LOGIC;
  signal \cnt0_carry__2_n_3\ : STD_LOGIC;
  signal \cnt0_carry__2_n_4\ : STD_LOGIC;
  signal \cnt0_carry__2_n_5\ : STD_LOGIC;
  signal \cnt0_carry__2_n_6\ : STD_LOGIC;
  signal \cnt0_carry__2_n_7\ : STD_LOGIC;
  signal \cnt0_carry__3_n_0\ : STD_LOGIC;
  signal \cnt0_carry__3_n_1\ : STD_LOGIC;
  signal \cnt0_carry__3_n_2\ : STD_LOGIC;
  signal \cnt0_carry__3_n_3\ : STD_LOGIC;
  signal \cnt0_carry__3_n_4\ : STD_LOGIC;
  signal \cnt0_carry__3_n_5\ : STD_LOGIC;
  signal \cnt0_carry__3_n_6\ : STD_LOGIC;
  signal \cnt0_carry__3_n_7\ : STD_LOGIC;
  signal \cnt0_carry__4_n_1\ : STD_LOGIC;
  signal \cnt0_carry__4_n_2\ : STD_LOGIC;
  signal \cnt0_carry__4_n_3\ : STD_LOGIC;
  signal \cnt0_carry__4_n_4\ : STD_LOGIC;
  signal \cnt0_carry__4_n_5\ : STD_LOGIC;
  signal \cnt0_carry__4_n_6\ : STD_LOGIC;
  signal \cnt0_carry__4_n_7\ : STD_LOGIC;
  signal cnt0_carry_n_0 : STD_LOGIC;
  signal cnt0_carry_n_1 : STD_LOGIC;
  signal cnt0_carry_n_2 : STD_LOGIC;
  signal cnt0_carry_n_3 : STD_LOGIC;
  signal cnt0_carry_n_4 : STD_LOGIC;
  signal cnt0_carry_n_5 : STD_LOGIC;
  signal cnt0_carry_n_6 : STD_LOGIC;
  signal cnt0_carry_n_7 : STD_LOGIC;
  signal \cnt[24]_i_2_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_3_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_4_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_5_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_6_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_7_n_0\ : STD_LOGIC;
  signal \cnt[24]_i_8_n_0\ : STD_LOGIC;
  signal cnt_1 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \cnt_fsm0_carry__0_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__0_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__1_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__2_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__3_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__4_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_0\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_1\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_2\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_4\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_5\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__5_n_7\ : STD_LOGIC;
  signal \cnt_fsm0_carry__6_n_3\ : STD_LOGIC;
  signal \cnt_fsm0_carry__6_n_6\ : STD_LOGIC;
  signal \cnt_fsm0_carry__6_n_7\ : STD_LOGIC;
  signal cnt_fsm0_carry_n_0 : STD_LOGIC;
  signal cnt_fsm0_carry_n_1 : STD_LOGIC;
  signal cnt_fsm0_carry_n_2 : STD_LOGIC;
  signal cnt_fsm0_carry_n_3 : STD_LOGIC;
  signal cnt_fsm0_carry_n_4 : STD_LOGIC;
  signal cnt_fsm0_carry_n_5 : STD_LOGIC;
  signal cnt_fsm0_carry_n_6 : STD_LOGIC;
  signal cnt_fsm0_carry_n_7 : STD_LOGIC;
  signal \cnt_fsm[0]_i_1_n_0\ : STD_LOGIC;
  signal \cnt_fsm[30]_i_1_n_0\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[10]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[11]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[12]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[13]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[14]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[15]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[16]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[17]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[18]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[19]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[1]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[20]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[21]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[22]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[23]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[24]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[25]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[26]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[27]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[28]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[29]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[2]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[30]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[3]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[4]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[5]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[6]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[7]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[8]\ : STD_LOGIC;
  signal \cnt_fsm_reg_n_0_[9]\ : STD_LOGIC;
  signal cnt_row_swap : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \cnt_row_swap0_carry__0_n_0\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_1\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_2\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_3\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_4\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_5\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_6\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__0_n_7\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_0\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_1\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_2\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_3\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_4\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_5\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_6\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__1_n_7\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__2_n_2\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__2_n_3\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__2_n_5\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__2_n_6\ : STD_LOGIC;
  signal \cnt_row_swap0_carry__2_n_7\ : STD_LOGIC;
  signal cnt_row_swap0_carry_n_0 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_1 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_2 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_3 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_4 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_5 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_6 : STD_LOGIC;
  signal cnt_row_swap0_carry_n_7 : STD_LOGIC;
  signal cnt_row_swap_2 : STD_LOGIC_VECTOR ( 0 to 0 );
  signal cnt_seconds : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal cnt_seconds_0 : STD_LOGIC;
  signal cnt_tens : STD_LOGIC;
  signal \cnt_tens[0]_i_1_n_0\ : STD_LOGIC;
  signal \cnt_tens[1]_i_1_n_0\ : STD_LOGIC;
  signal \cnt_tens[2]_i_1_n_0\ : STD_LOGIC;
  signal \cnt_tens_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_tens_reg_n_0_[1]\ : STD_LOGIC;
  signal \cnt_tens_reg_n_0_[2]\ : STD_LOGIC;
  signal col_select : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \col_select_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[0]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[1]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[1]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[1]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[1]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[2]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[2]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[2]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[2]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[3]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[3]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[3]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[3]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[4]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[4]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[4]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[4]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[5]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[5]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[5]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[5]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_6_n_0\ : STD_LOGIC;
  signal \col_select_reg[6]_i_7_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_2_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_3_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_4_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_5_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_6_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_7_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_8_n_0\ : STD_LOGIC;
  signal \col_select_reg[7]_i_9_n_0\ : STD_LOGIC;
  signal data00 : STD_LOGIC;
  signal fsm_current_state : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal fsm_next_state : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal i : STD_LOGIC_VECTOR ( 21 downto 0 );
  signal \i0_carry__0_n_0\ : STD_LOGIC;
  signal \i0_carry__0_n_1\ : STD_LOGIC;
  signal \i0_carry__0_n_2\ : STD_LOGIC;
  signal \i0_carry__0_n_3\ : STD_LOGIC;
  signal \i0_carry__0_n_4\ : STD_LOGIC;
  signal \i0_carry__0_n_5\ : STD_LOGIC;
  signal \i0_carry__0_n_6\ : STD_LOGIC;
  signal \i0_carry__0_n_7\ : STD_LOGIC;
  signal \i0_carry__1_n_0\ : STD_LOGIC;
  signal \i0_carry__1_n_1\ : STD_LOGIC;
  signal \i0_carry__1_n_2\ : STD_LOGIC;
  signal \i0_carry__1_n_3\ : STD_LOGIC;
  signal \i0_carry__1_n_4\ : STD_LOGIC;
  signal \i0_carry__1_n_5\ : STD_LOGIC;
  signal \i0_carry__1_n_6\ : STD_LOGIC;
  signal \i0_carry__1_n_7\ : STD_LOGIC;
  signal \i0_carry__2_n_0\ : STD_LOGIC;
  signal \i0_carry__2_n_1\ : STD_LOGIC;
  signal \i0_carry__2_n_2\ : STD_LOGIC;
  signal \i0_carry__2_n_3\ : STD_LOGIC;
  signal \i0_carry__2_n_4\ : STD_LOGIC;
  signal \i0_carry__2_n_5\ : STD_LOGIC;
  signal \i0_carry__2_n_6\ : STD_LOGIC;
  signal \i0_carry__2_n_7\ : STD_LOGIC;
  signal \i0_carry__3_n_0\ : STD_LOGIC;
  signal \i0_carry__3_n_1\ : STD_LOGIC;
  signal \i0_carry__3_n_2\ : STD_LOGIC;
  signal \i0_carry__3_n_3\ : STD_LOGIC;
  signal \i0_carry__3_n_4\ : STD_LOGIC;
  signal \i0_carry__3_n_5\ : STD_LOGIC;
  signal \i0_carry__3_n_6\ : STD_LOGIC;
  signal \i0_carry__3_n_7\ : STD_LOGIC;
  signal \i0_carry__4_n_7\ : STD_LOGIC;
  signal i0_carry_n_0 : STD_LOGIC;
  signal i0_carry_n_1 : STD_LOGIC;
  signal i0_carry_n_2 : STD_LOGIC;
  signal i0_carry_n_3 : STD_LOGIC;
  signal i0_carry_n_4 : STD_LOGIC;
  signal i0_carry_n_5 : STD_LOGIC;
  signal i0_carry_n_6 : STD_LOGIC;
  signal i0_carry_n_7 : STD_LOGIC;
  signal \i[0]_i_1_n_0\ : STD_LOGIC;
  signal \i[21]_i_1_n_0\ : STD_LOGIC;
  signal \i[21]_i_2_n_0\ : STD_LOGIC;
  signal \i[21]_i_3_n_0\ : STD_LOGIC;
  signal \i[21]_i_4_n_0\ : STD_LOGIC;
  signal \i[21]_i_5_n_0\ : STD_LOGIC;
  signal \i[21]_i_6_n_0\ : STD_LOGIC;
  signal \i[21]_i_7_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \rom_memory_reg[22]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[22]_i_2_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[22]_i_3_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[23]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[24]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[29]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[31]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[32]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[33]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[37]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[38]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[39]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[40]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[41]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[42]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[45]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[46]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[47]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg[53]_i_1_n_0\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[22]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[23]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[24]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[29]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[31]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[32]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[33]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[37]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[38]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[39]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[40]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[41]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[42]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[45]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[46]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[47]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[48]\ : STD_LOGIC;
  signal \rom_memory_reg_n_0_[53]\ : STD_LOGIC;
  signal \row_select[7]_i_1_n_0\ : STD_LOGIC;
  signal \row_select[7]_i_2_n_0\ : STD_LOGIC;
  signal \row_select[7]_i_3_n_0\ : STD_LOGIC;
  signal \row_select[7]_i_4_n_0\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[1016]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[103]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[1048]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[143]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[174]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[206]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[238]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[278]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[309]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[341]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[373]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[39]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[413]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[444]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[476]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[508]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[548]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[579]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[611]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[643]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[683]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[714]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[71]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[746]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[778]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[818]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[849]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[881]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[8]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[913]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[953]_srl31_Q31_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cell_animation_reg[984]_srl32_Q_UNCONNECTED\ : STD_LOGIC;
  signal \NLW_cnt0_carry__4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_cnt_fsm0_carry__6_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \NLW_cnt_fsm0_carry__6_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_cnt_row_swap0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \NLW_cnt_row_swap0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_i0_carry__4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i0_carry__4_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 1 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[0]_i_13\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[0]_i_8\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[1]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[1]_i_12\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[1]_i_4\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \FSM_sequential_fsm_current_state[1]_i_5\ : label is "soft_lutpair2";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_fsm_current_state_reg[0]\ : label is "state_inverse:01,state_image:10,state_animation:11,state_normal:00";
  attribute FSM_ENCODED_STATES of \FSM_sequential_fsm_current_state_reg[1]\ : label is "state_inverse:01,state_image:10,state_animation:11,state_normal:00";
  attribute SOFT_HLUTNM of \cell_animation[0]_i_4\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cell_animation[0]_i_7\ : label is "soft_lutpair8";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \cell_animation_reg[1016]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name : string;
  attribute srl_name of \cell_animation_reg[1016]_srl32\ : label is "\U0/cell_animation_reg[1016]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[103]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[103]_srl32\ : label is "\U0/cell_animation_reg[103]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[1048]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[1048]_srl32\ : label is "\U0/cell_animation_reg[1048]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[143]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[143]_srl31\ : label is "\U0/cell_animation_reg[143]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[174]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[174]_srl32\ : label is "\U0/cell_animation_reg[174]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[206]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[206]_srl32\ : label is "\U0/cell_animation_reg[206]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[238]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[238]_srl32\ : label is "\U0/cell_animation_reg[238]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[278]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[278]_srl31\ : label is "\U0/cell_animation_reg[278]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[309]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[309]_srl32\ : label is "\U0/cell_animation_reg[309]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[341]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[341]_srl32\ : label is "\U0/cell_animation_reg[341]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[373]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[373]_srl32\ : label is "\U0/cell_animation_reg[373]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[39]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[39]_srl32\ : label is "\U0/cell_animation_reg[39]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[413]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[413]_srl31\ : label is "\U0/cell_animation_reg[413]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[444]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[444]_srl32\ : label is "\U0/cell_animation_reg[444]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[476]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[476]_srl32\ : label is "\U0/cell_animation_reg[476]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[508]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[508]_srl32\ : label is "\U0/cell_animation_reg[508]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[548]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[548]_srl31\ : label is "\U0/cell_animation_reg[548]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[579]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[579]_srl32\ : label is "\U0/cell_animation_reg[579]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[611]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[611]_srl32\ : label is "\U0/cell_animation_reg[611]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[643]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[643]_srl32\ : label is "\U0/cell_animation_reg[643]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[683]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[683]_srl31\ : label is "\U0/cell_animation_reg[683]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[714]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[714]_srl32\ : label is "\U0/cell_animation_reg[714]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[71]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[71]_srl32\ : label is "\U0/cell_animation_reg[71]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[746]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[746]_srl32\ : label is "\U0/cell_animation_reg[746]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[778]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[778]_srl32\ : label is "\U0/cell_animation_reg[778]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[818]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[818]_srl31\ : label is "\U0/cell_animation_reg[818]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[849]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[849]_srl32\ : label is "\U0/cell_animation_reg[849]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[881]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[881]_srl32\ : label is "\U0/cell_animation_reg[881]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[8]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[8]_srl31\ : label is "\U0/cell_animation_reg[8]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[913]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[913]_srl32\ : label is "\U0/cell_animation_reg[913]_srl32 ";
  attribute srl_bus_name of \cell_animation_reg[953]_srl31\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[953]_srl31\ : label is "\U0/cell_animation_reg[953]_srl31 ";
  attribute srl_bus_name of \cell_animation_reg[984]_srl32\ : label is "\U0/cell_animation_reg ";
  attribute srl_name of \cell_animation_reg[984]_srl32\ : label is "\U0/cell_animation_reg[984]_srl32 ";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \cell_generator[22].cell_reg[22]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[22].cell_reg[22]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[22].cell_reg[22]_i_1\ : label is "soft_lutpair16";
  attribute XILINX_LEGACY_PRIM of \cell_generator[23].cell_reg[23]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[23].cell_reg[23]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \cell_generator[24].cell_reg[24]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[24].cell_reg[24]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[24].cell_reg[24]_i_1\ : label is "soft_lutpair23";
  attribute XILINX_LEGACY_PRIM of \cell_generator[26].cell_reg[26]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[26].cell_reg[26]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[26].cell_reg[26]_i_1\ : label is "soft_lutpair18";
  attribute XILINX_LEGACY_PRIM of \cell_generator[29].cell_reg[29]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[29].cell_reg[29]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[29].cell_reg[29]_i_1\ : label is "soft_lutpair16";
  attribute XILINX_LEGACY_PRIM of \cell_generator[31].cell_reg[31]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[31].cell_reg[31]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[31].cell_reg[31]_i_1\ : label is "soft_lutpair23";
  attribute XILINX_LEGACY_PRIM of \cell_generator[32].cell_reg[32]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[32].cell_reg[32]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[32].cell_reg[32]_i_1\ : label is "soft_lutpair18";
  attribute XILINX_LEGACY_PRIM of \cell_generator[33].cell_reg[33]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[33].cell_reg[33]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[33].cell_reg[33]_i_1\ : label is "soft_lutpair15";
  attribute XILINX_LEGACY_PRIM of \cell_generator[37].cell_reg[37]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[37].cell_reg[37]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[37].cell_reg[37]_i_1\ : label is "soft_lutpair22";
  attribute XILINX_LEGACY_PRIM of \cell_generator[38].cell_reg[38]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[38].cell_reg[38]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[38].cell_reg[38]_i_1\ : label is "soft_lutpair15";
  attribute XILINX_LEGACY_PRIM of \cell_generator[39].cell_reg[39]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[39].cell_reg[39]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[39].cell_reg[39]_i_1\ : label is "soft_lutpair22";
  attribute XILINX_LEGACY_PRIM of \cell_generator[40].cell_reg[40]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[40].cell_reg[40]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[40].cell_reg[40]_i_1\ : label is "soft_lutpair21";
  attribute XILINX_LEGACY_PRIM of \cell_generator[41].cell_reg[41]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[41].cell_reg[41]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[41].cell_reg[41]_i_1\ : label is "soft_lutpair13";
  attribute XILINX_LEGACY_PRIM of \cell_generator[42].cell_reg[42]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[42].cell_reg[42]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[42].cell_reg[42]_i_1\ : label is "soft_lutpair14";
  attribute XILINX_LEGACY_PRIM of \cell_generator[45].cell_reg[45]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[45].cell_reg[45]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[45].cell_reg[45]_i_1\ : label is "soft_lutpair14";
  attribute XILINX_LEGACY_PRIM of \cell_generator[46].cell_reg[46]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[46].cell_reg[46]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[46].cell_reg[46]_i_1\ : label is "soft_lutpair13";
  attribute XILINX_LEGACY_PRIM of \cell_generator[47].cell_reg[47]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[47].cell_reg[47]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[47].cell_reg[47]_i_1\ : label is "soft_lutpair20";
  attribute XILINX_LEGACY_PRIM of \cell_generator[48].cell_reg[48]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[48].cell_reg[48]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[48].cell_reg[48]_i_1\ : label is "soft_lutpair17";
  attribute XILINX_LEGACY_PRIM of \cell_generator[49].cell_reg[49]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[49].cell_reg[49]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[49].cell_reg[49]_i_1\ : label is "soft_lutpair17";
  attribute XILINX_LEGACY_PRIM of \cell_generator[53].cell_reg[53]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[53].cell_reg[53]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[53].cell_reg[53]_i_1\ : label is "soft_lutpair19";
  attribute XILINX_LEGACY_PRIM of \cell_generator[54].cell_reg[54]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[54].cell_reg[54]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[54].cell_reg[54]_i_1\ : label is "soft_lutpair19";
  attribute XILINX_LEGACY_PRIM of \cell_generator[56].cell_reg[56]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[56].cell_reg[56]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[56].cell_reg[56]_i_1\ : label is "soft_lutpair21";
  attribute XILINX_LEGACY_PRIM of \cell_generator[58].cell_reg[58]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \cell_generator[58].cell_reg[58]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \cell_generator[58].cell_reg[58]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \cell_generator[58].cell_reg[58]_i_2\ : label is "soft_lutpair9";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of cnt0_carry : label is 35;
  attribute ADDER_THRESHOLD of \cnt0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt0_carry__4\ : label is 35;
  attribute SOFT_HLUTNM of \cnt[0]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \cnt[24]_i_8\ : label is "soft_lutpair6";
  attribute ADDER_THRESHOLD of cnt_fsm0_carry : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__4\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__5\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_fsm0_carry__6\ : label is 35;
  attribute SOFT_HLUTNM of \cnt_fsm[0]_i_1\ : label is "soft_lutpair10";
  attribute ADDER_THRESHOLD of cnt_row_swap0_carry : label is 35;
  attribute ADDER_THRESHOLD of \cnt_row_swap0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_row_swap0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \cnt_row_swap0_carry__2\ : label is 35;
  attribute SOFT_HLUTNM of \cnt_seconds[0]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cnt_seconds[1]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \cnt_seconds[2]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cnt_seconds[3]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cnt_tens[0]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cnt_tens[1]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \cnt_tens[2]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \cnt_tens[2]_i_2\ : label is "soft_lutpair5";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[0]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[0]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[1]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[1]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[2]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[2]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[3]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[3]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[4]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[4]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[5]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[5]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[6]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[6]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \col_select_reg[7]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \col_select_reg[7]\ : label is "VCC:GE GND:CLR";
  attribute ADDER_THRESHOLD of i0_carry : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__3\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__4\ : label is 35;
  attribute SOFT_HLUTNM of \i[21]_i_4\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \i[21]_i_5\ : label is "soft_lutpair8";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[22]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[22]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[22]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \rom_memory_reg[22]_i_3\ : label is "soft_lutpair24";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[23]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[23]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[24]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[24]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[24]_i_1\ : label is "soft_lutpair24";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[29]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[29]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[31]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[31]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[32]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[32]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[32]_i_1\ : label is "soft_lutpair25";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[33]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[33]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[33]_i_1\ : label is "soft_lutpair25";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[37]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[37]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[38]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[38]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[39]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[39]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[40]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[40]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[40]_i_1\ : label is "soft_lutpair26";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[41]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[41]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[41]_i_1\ : label is "soft_lutpair26";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[42]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[42]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[42]_i_1\ : label is "soft_lutpair12";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[45]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[45]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[45]_i_1\ : label is "soft_lutpair3";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[46]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[46]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[47]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[47]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[48]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[48]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \rom_memory_reg[53]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \rom_memory_reg[53]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM of \rom_memory_reg[53]_i_1\ : label is "soft_lutpair3";
begin
  Q(7 downto 0) <= \^q\(7 downto 0);
\FSM_sequential_fsm_current_state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FCFFFAF0FCF0FAF0"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_2_n_0\,
      I1 => \FSM_sequential_fsm_current_state[1]_i_3_n_0\,
      I2 => \FSM_sequential_fsm_current_state[0]_i_3_n_0\,
      I3 => fsm_current_state(1),
      I4 => fsm_current_state(0),
      I5 => \FSM_sequential_fsm_current_state[0]_i_4_n_0\,
      O => fsm_next_state(0)
    );
\FSM_sequential_fsm_current_state[0]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFEFFFFFFFF"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_16_n_0\,
      I1 => \cnt_fsm_reg_n_0_[9]\,
      I2 => \cnt_fsm_reg_n_0_[20]\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_13_n_0\,
      I4 => \FSM_sequential_fsm_current_state[0]_i_17_n_0\,
      I5 => \cnt_fsm_reg_n_0_[19]\,
      O => \FSM_sequential_fsm_current_state[0]_i_10_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFDFFFFFFFFFFFFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[20]\,
      I1 => \cnt_fsm_reg_n_0_[28]\,
      I2 => \cnt_fsm_reg_n_0_[29]\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_12_n_0\,
      I4 => \cnt_fsm_reg_n_0_[5]\,
      I5 => \cnt_fsm_reg_n_0_[4]\,
      O => \FSM_sequential_fsm_current_state[0]_i_11_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_12\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[21]\,
      I1 => \cnt_fsm_reg_n_0_[25]\,
      I2 => \cnt_fsm_reg_n_0_[27]\,
      I3 => \cnt_fsm_reg_n_0_[7]\,
      I4 => \cnt_fsm_reg_n_0_[26]\,
      I5 => \cnt_fsm_reg_n_0_[11]\,
      O => \FSM_sequential_fsm_current_state[0]_i_12_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_13\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFF7F"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[10]\,
      I1 => \cnt_fsm_reg_n_0_[15]\,
      I2 => \cnt_fsm_reg_n_0_[8]\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_13_n_0\,
      I4 => \FSM_sequential_fsm_current_state[1]_i_7_n_0\,
      O => \FSM_sequential_fsm_current_state[0]_i_13_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[28]\,
      I1 => \cnt_fsm_reg_n_0_[24]\,
      I2 => \cnt_fsm_reg_n_0_[23]\,
      I3 => \cnt_fsm_reg_n_0_[15]\,
      O => \FSM_sequential_fsm_current_state[0]_i_14_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_15\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[25]\,
      I1 => \cnt_fsm_reg_n_0_[27]\,
      O => \FSM_sequential_fsm_current_state[0]_i_15_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_16\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FDFFFFFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[17]\,
      I1 => \cnt_fsm_reg_n_0_[16]\,
      I2 => \cnt_fsm_reg_n_0_[18]\,
      I3 => \cnt_fsm_reg_n_0_[28]\,
      I4 => \cnt_fsm_reg_n_0_[22]\,
      O => \FSM_sequential_fsm_current_state[0]_i_16_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_17\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[29]\,
      I1 => \cnt_fsm_reg_n_0_[7]\,
      I2 => \cnt_fsm_reg_n_0_[21]\,
      O => \FSM_sequential_fsm_current_state[0]_i_17_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000200"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_5_n_0\,
      I1 => \FSM_sequential_fsm_current_state[0]_i_6_n_0\,
      I2 => \FSM_sequential_fsm_current_state[0]_i_7_n_0\,
      I3 => \cnt_fsm_reg_n_0_[29]\,
      I4 => \cnt_fsm_reg_n_0_[10]\,
      I5 => \cnt_fsm_reg_n_0_[27]\,
      O => \FSM_sequential_fsm_current_state[0]_i_2_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000040000"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_8_n_0\,
      I1 => \cnt_fsm_reg_n_0_[24]\,
      I2 => \cell_generator[58].cell_reg[58]_i_1_n_0\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_5_n_0\,
      I4 => \FSM_sequential_fsm_current_state[0]_i_9_n_0\,
      I5 => \FSM_sequential_fsm_current_state[0]_i_10_n_0\,
      O => \FSM_sequential_fsm_current_state[0]_i_3_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFEF"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_11_n_0\,
      I1 => \FSM_sequential_fsm_current_state[0]_i_12_n_0\,
      I2 => \cnt_fsm_reg_n_0_[9]\,
      I3 => \cnt_fsm_reg_n_0_[12]\,
      I4 => \cnt_fsm_reg_n_0_[14]\,
      I5 => \FSM_sequential_fsm_current_state[0]_i_13_n_0\,
      O => \FSM_sequential_fsm_current_state[0]_i_4_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000080000000"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[0]_i_14_n_0\,
      I1 => \cnt_fsm_reg_n_0_[6]\,
      I2 => \cnt_fsm_reg_n_0_[13]\,
      I3 => \cnt_fsm_reg_n_0_[14]\,
      I4 => \FSM_sequential_fsm_current_state[1]_i_4_n_0\,
      I5 => \FSM_sequential_fsm_current_state[1]_i_12_n_0\,
      O => \FSM_sequential_fsm_current_state[0]_i_5_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFF7"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[21]\,
      I1 => \cnt_fsm_reg_n_0_[18]\,
      I2 => \cnt_fsm_reg_n_0_[17]\,
      I3 => \cnt_fsm_reg_n_0_[19]\,
      I4 => \cnt_fsm_reg_n_0_[22]\,
      I5 => \cnt_fsm_reg_n_0_[16]\,
      O => \FSM_sequential_fsm_current_state[0]_i_6_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[25]\,
      I1 => \cnt_fsm_reg_n_0_[12]\,
      I2 => \cnt_fsm_reg_n_0_[9]\,
      I3 => \cnt_fsm_reg_n_0_[20]\,
      I4 => \cnt_fsm_reg_n_0_[8]\,
      I5 => \cnt_fsm_reg_n_0_[30]\,
      O => \FSM_sequential_fsm_current_state[0]_i_7_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[5]\,
      I1 => \cnt_fsm_reg_n_0_[4]\,
      O => \FSM_sequential_fsm_current_state[0]_i_8_n_0\
    );
\FSM_sequential_fsm_current_state[0]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000008000"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[26]\,
      I1 => \cnt_fsm_reg_n_0_[11]\,
      I2 => \cnt_fsm_reg_n_0_[12]\,
      I3 => \cnt_fsm_reg_n_0_[14]\,
      I4 => \FSM_sequential_fsm_current_state[0]_i_15_n_0\,
      I5 => \FSM_sequential_fsm_current_state[1]_i_12_n_0\,
      O => \FSM_sequential_fsm_current_state[0]_i_9_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FABA"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[1]_i_2_n_0\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      I3 => \FSM_sequential_fsm_current_state[1]_i_3_n_0\,
      O => fsm_next_state(1)
    );
\FSM_sequential_fsm_current_state[1]_i_10\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFF7FFFFFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[13]\,
      I1 => \cnt_fsm_reg_n_0_[30]\,
      I2 => \cnt_fsm_reg_n_0_[28]\,
      I3 => \cnt_fsm_reg_n_0_[23]\,
      I4 => \cnt_fsm_reg_n_0_[6]\,
      I5 => \FSM_sequential_fsm_current_state[1]_i_12_n_0\,
      O => \FSM_sequential_fsm_current_state[1]_i_10_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_11\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFFFFFFFFFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[11]\,
      I1 => \cnt_fsm_reg_n_0_[10]\,
      I2 => \cnt_fsm_reg_n_0_[25]\,
      I3 => \cnt_fsm_reg_n_0_[27]\,
      I4 => \cnt_fsm_reg_n_0_[5]\,
      I5 => \cnt_fsm_reg_n_0_[4]\,
      O => \FSM_sequential_fsm_current_state[1]_i_11_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[2]\,
      I1 => \cnt_fsm_reg_n_0_[3]\,
      I2 => \cnt_fsm_reg_n_0_[0]\,
      I3 => \cnt_fsm_reg_n_0_[1]\,
      O => \FSM_sequential_fsm_current_state[1]_i_12_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[23]\,
      I1 => \cnt_fsm_reg_n_0_[6]\,
      I2 => \cnt_fsm_reg_n_0_[30]\,
      I3 => \cnt_fsm_reg_n_0_[13]\,
      O => \FSM_sequential_fsm_current_state[1]_i_13_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_14\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FE"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[9]\,
      I1 => \cnt_fsm_reg_n_0_[20]\,
      I2 => \cnt_fsm_reg_n_0_[8]\,
      O => \FSM_sequential_fsm_current_state[1]_i_14_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000200000"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[1]_i_4_n_0\,
      I1 => \FSM_sequential_fsm_current_state[1]_i_5_n_0\,
      I2 => \FSM_sequential_fsm_current_state[1]_i_6_n_0\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_7_n_0\,
      I4 => \cnt_fsm_reg_n_0_[29]\,
      I5 => \FSM_sequential_fsm_current_state[1]_i_8_n_0\,
      O => \FSM_sequential_fsm_current_state[1]_i_2_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFEFFFFFFFFFFFF"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[1]_i_9_n_0\,
      I1 => \FSM_sequential_fsm_current_state[1]_i_10_n_0\,
      I2 => \FSM_sequential_fsm_current_state[1]_i_11_n_0\,
      I3 => \cnt_fsm_reg_n_0_[15]\,
      I4 => \cnt_fsm_reg_n_0_[12]\,
      I5 => \cnt_fsm_reg_n_0_[14]\,
      O => \FSM_sequential_fsm_current_state[1]_i_3_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"80000000"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[7]\,
      I1 => \cnt_fsm_reg_n_0_[26]\,
      I2 => \cnt_fsm_reg_n_0_[11]\,
      I3 => \cnt_fsm_reg_n_0_[4]\,
      I4 => \cnt_fsm_reg_n_0_[5]\,
      O => \FSM_sequential_fsm_current_state[1]_i_4_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[10]\,
      I1 => \cnt_fsm_reg_n_0_[15]\,
      I2 => \cnt_fsm_reg_n_0_[8]\,
      O => \FSM_sequential_fsm_current_state[1]_i_5_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000080000000"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[25]\,
      I1 => \cnt_fsm_reg_n_0_[27]\,
      I2 => \cnt_fsm_reg_n_0_[21]\,
      I3 => \cnt_fsm_reg_n_0_[9]\,
      I4 => \cell_generator[56].cell_reg[56]_i_1_n_0\,
      I5 => \FSM_sequential_fsm_current_state[1]_i_12_n_0\,
      O => \FSM_sequential_fsm_current_state[1]_i_6_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFEF"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[24]\,
      I1 => \cnt_fsm_reg_n_0_[18]\,
      I2 => \cnt_fsm_reg_n_0_[16]\,
      I3 => \cnt_fsm_reg_n_0_[22]\,
      I4 => \cnt_fsm_reg_n_0_[19]\,
      I5 => \cnt_fsm_reg_n_0_[17]\,
      O => \FSM_sequential_fsm_current_state[1]_i_7_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFD"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[20]\,
      I1 => \cnt_fsm_reg_n_0_[12]\,
      I2 => \cnt_fsm_reg_n_0_[28]\,
      I3 => \FSM_sequential_fsm_current_state[1]_i_13_n_0\,
      I4 => \cnt_fsm_reg_n_0_[14]\,
      O => \FSM_sequential_fsm_current_state[1]_i_8_n_0\
    );
\FSM_sequential_fsm_current_state[1]_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[1]_i_7_n_0\,
      I1 => \cnt_fsm_reg_n_0_[26]\,
      I2 => \FSM_sequential_fsm_current_state[1]_i_14_n_0\,
      I3 => \cnt_fsm_reg_n_0_[29]\,
      I4 => \cnt_fsm_reg_n_0_[7]\,
      I5 => \cnt_fsm_reg_n_0_[21]\,
      O => \FSM_sequential_fsm_current_state[1]_i_9_n_0\
    );
\FSM_sequential_fsm_current_state_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => fsm_next_state(0),
      Q => fsm_current_state(0),
      R => '0'
    );
\FSM_sequential_fsm_current_state_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => fsm_next_state(1),
      Q => fsm_current_state(1),
      R => '0'
    );
\cell_animation[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0020000000000000"
    )
        port map (
      I0 => \i[21]_i_2_n_0\,
      I1 => i(20),
      I2 => i(21),
      I3 => i(19),
      I4 => \cell_animation[0]_i_2_n_0\,
      I5 => \cell_animation[0]_i_3_n_0\,
      O => cell_animation0
    );
\cell_animation[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BBBB0B0000000000"
    )
        port map (
      I0 => \cell_animation[0]_i_4_n_0\,
      I1 => i(17),
      I2 => i(19),
      I3 => i(18),
      I4 => i(20),
      I5 => \cell_animation[0]_i_5_n_0\,
      O => \cell_animation[0]_i_2_n_0\
    );
\cell_animation[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \cell_animation[0]_i_6_n_0\,
      I1 => i(0),
      I2 => i(1),
      I3 => i(2),
      I4 => \cell_animation[0]_i_7_n_0\,
      I5 => \cell_animation[0]_i_8_n_0\,
      O => \cell_animation[0]_i_3_n_0\
    );
\cell_animation[0]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => i(15),
      I1 => i(16),
      O => \cell_animation[0]_i_4_n_0\
    );
\cell_animation[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000150015001500"
    )
        port map (
      I0 => i(14),
      I1 => i(13),
      I2 => i(12),
      I3 => i(11),
      I4 => i(10),
      I5 => i(9),
      O => \cell_animation[0]_i_5_n_0\
    );
\cell_animation[0]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2323002300230023"
    )
        port map (
      I0 => i(7),
      I1 => i(8),
      I2 => i(6),
      I3 => i(5),
      I4 => i(3),
      I5 => i(4),
      O => \cell_animation[0]_i_6_n_0\
    );
\cell_animation[0]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1000"
    )
        port map (
      I0 => i(8),
      I1 => i(7),
      I2 => i(5),
      I3 => i(4),
      O => \cell_animation[0]_i_7_n_0\
    );
\cell_animation[0]_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0080000000000000"
    )
        port map (
      I0 => i(10),
      I1 => i(11),
      I2 => i(13),
      I3 => i(14),
      I4 => i(17),
      I5 => i(16),
      O => \cell_animation[0]_i_8_n_0\
    );
\cell_animation_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[1]\,
      Q => \cell_animation_reg_n_0_[0]\,
      R => '0'
    );
\cell_animation_reg[1016]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[1048]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[1016]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[1016]_srl32_n_1\
    );
\cell_animation_reg[103]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[0]\,
      Q => \NLW_cell_animation_reg[103]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[103]_srl32_n_1\
    );
\cell_animation_reg[1048]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => data00,
      Q => \NLW_cell_animation_reg[1048]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[1048]_srl32_n_1\
    );
\cell_animation_reg[135]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[136]\,
      Q => \cell_animation_reg_n_0_[135]\,
      R => '0'
    );
\cell_animation_reg[136]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[137]\,
      Q => \cell_animation_reg_n_0_[136]\,
      R => '0'
    );
\cell_animation_reg[137]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[138]\,
      Q => \cell_animation_reg_n_0_[137]\,
      R => '0'
    );
\cell_animation_reg[138]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[139]\,
      Q => \cell_animation_reg_n_0_[138]\,
      R => '0'
    );
\cell_animation_reg[139]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[140]\,
      Q => \cell_animation_reg_n_0_[139]\,
      R => '0'
    );
\cell_animation_reg[140]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[141]\,
      Q => \cell_animation_reg_n_0_[140]\,
      R => '0'
    );
\cell_animation_reg[141]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[142]\,
      Q => \cell_animation_reg_n_0_[141]\,
      R => '0'
    );
\cell_animation_reg[142]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[143]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[142]\,
      R => '0'
    );
\cell_animation_reg[143]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[174]_srl32_n_1\,
      Q => \cell_animation_reg[143]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[143]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[174]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[206]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[174]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[174]_srl32_n_1\
    );
\cell_animation_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[2]\,
      Q => \cell_animation_reg_n_0_[1]\,
      R => '0'
    );
\cell_animation_reg[206]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[238]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[206]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[206]_srl32_n_1\
    );
\cell_animation_reg[238]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[135]\,
      Q => \NLW_cell_animation_reg[238]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[238]_srl32_n_1\
    );
\cell_animation_reg[270]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[271]\,
      Q => \cell_animation_reg_n_0_[270]\,
      R => '0'
    );
\cell_animation_reg[271]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[272]\,
      Q => \cell_animation_reg_n_0_[271]\,
      R => '0'
    );
\cell_animation_reg[272]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[273]\,
      Q => \cell_animation_reg_n_0_[272]\,
      R => '0'
    );
\cell_animation_reg[273]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[274]\,
      Q => \cell_animation_reg_n_0_[273]\,
      R => '0'
    );
\cell_animation_reg[274]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[275]\,
      Q => \cell_animation_reg_n_0_[274]\,
      R => '0'
    );
\cell_animation_reg[275]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[276]\,
      Q => \cell_animation_reg_n_0_[275]\,
      R => '0'
    );
\cell_animation_reg[276]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[277]\,
      Q => \cell_animation_reg_n_0_[276]\,
      R => '0'
    );
\cell_animation_reg[277]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[278]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[277]\,
      R => '0'
    );
\cell_animation_reg[278]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"7CF9F078"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[309]_srl32_n_1\,
      Q => \cell_animation_reg[278]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[278]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[3]\,
      Q => \cell_animation_reg_n_0_[2]\,
      R => '0'
    );
\cell_animation_reg[309]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"89F00000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[341]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[309]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[309]_srl32_n_1\
    );
\cell_animation_reg[341]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"3E4489E1"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[373]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[341]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[341]_srl32_n_1\
    );
\cell_animation_reg[373]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"C7831000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[270]\,
      Q => \NLW_cell_animation_reg[373]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[373]_srl32_n_1\
    );
\cell_animation_reg[39]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[71]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[39]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[39]_srl32_n_1\
    );
\cell_animation_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[4]\,
      Q => \cell_animation_reg_n_0_[3]\,
      R => '0'
    );
\cell_animation_reg[405]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[406]\,
      Q => \cell_animation_reg_n_0_[405]\,
      R => '0'
    );
\cell_animation_reg[406]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[407]\,
      Q => \cell_animation_reg_n_0_[406]\,
      R => '0'
    );
\cell_animation_reg[407]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[408]\,
      Q => \cell_animation_reg_n_0_[407]\,
      R => '0'
    );
\cell_animation_reg[408]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[409]\,
      Q => \cell_animation_reg_n_0_[408]\,
      R => '0'
    );
\cell_animation_reg[409]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[410]\,
      Q => \cell_animation_reg_n_0_[409]\,
      R => '0'
    );
\cell_animation_reg[410]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[411]\,
      Q => \cell_animation_reg_n_0_[410]\,
      R => '0'
    );
\cell_animation_reg[411]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[412]\,
      Q => \cell_animation_reg_n_0_[411]\,
      R => '0'
    );
\cell_animation_reg[412]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[413]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[412]\,
      R => '0'
    );
\cell_animation_reg[413]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"40204044"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[444]_srl32_n_1\,
      Q => \cell_animation_reg[413]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[413]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[444]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"88400040"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[476]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[444]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[444]_srl32_n_1\
    );
\cell_animation_reg[476]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"08448812"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[508]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[476]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[476]_srl32_n_1\
    );
\cell_animation_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[5]\,
      Q => \cell_animation_reg_n_0_[4]\,
      R => '0'
    );
\cell_animation_reg[508]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"60451000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[405]\,
      Q => \NLW_cell_animation_reg[508]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[508]_srl32_n_1\
    );
\cell_animation_reg[540]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[541]\,
      Q => \cell_animation_reg_n_0_[540]\,
      R => '0'
    );
\cell_animation_reg[541]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[542]\,
      Q => \cell_animation_reg_n_0_[541]\,
      R => '0'
    );
\cell_animation_reg[542]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[543]\,
      Q => \cell_animation_reg_n_0_[542]\,
      R => '0'
    );
\cell_animation_reg[543]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[544]\,
      Q => \cell_animation_reg_n_0_[543]\,
      R => '0'
    );
\cell_animation_reg[544]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[545]\,
      Q => \cell_animation_reg_n_0_[544]\,
      R => '0'
    );
\cell_animation_reg[545]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[546]\,
      Q => \cell_animation_reg_n_0_[545]\,
      R => '0'
    );
\cell_animation_reg[546]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[547]\,
      Q => \cell_animation_reg_n_0_[546]\,
      R => '0'
    );
\cell_animation_reg[547]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[548]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[547]\,
      R => '0'
    );
\cell_animation_reg[548]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"78204078"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[579]_srl32_n_1\,
      Q => \cell_animation_reg[548]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[548]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[579]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"88407C20"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[611]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[579]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[579]_srl32_n_1\
    );
\cell_animation_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[6]\,
      Q => \cell_animation_reg_n_0_[5]\,
      R => '0'
    );
\cell_animation_reg[611]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"0844F8E2"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[643]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[611]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[611]_srl32_n_1\
    );
\cell_animation_reg[643]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"A3891000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[540]\,
      Q => \NLW_cell_animation_reg[643]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[643]_srl32_n_1\
    );
\cell_animation_reg[675]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[676]\,
      Q => \cell_animation_reg_n_0_[675]\,
      R => '0'
    );
\cell_animation_reg[676]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[677]\,
      Q => \cell_animation_reg_n_0_[676]\,
      R => '0'
    );
\cell_animation_reg[677]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[678]\,
      Q => \cell_animation_reg_n_0_[677]\,
      R => '0'
    );
\cell_animation_reg[678]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[679]\,
      Q => \cell_animation_reg_n_0_[678]\,
      R => '0'
    );
\cell_animation_reg[679]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[680]\,
      Q => \cell_animation_reg_n_0_[679]\,
      R => '0'
    );
\cell_animation_reg[680]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[681]\,
      Q => \cell_animation_reg_n_0_[680]\,
      R => '0'
    );
\cell_animation_reg[681]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[682]\,
      Q => \cell_animation_reg_n_0_[681]\,
      R => '0'
    );
\cell_animation_reg[682]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[683]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[682]\,
      R => '0'
    );
\cell_animation_reg[683]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"40204044"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[714]_srl32_n_1\,
      Q => \cell_animation_reg[683]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[683]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[7]\,
      Q => \cell_animation_reg_n_0_[6]\,
      R => '0'
    );
\cell_animation_reg[714]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"88400040"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[746]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[714]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[714]_srl32_n_1\
    );
\cell_animation_reg[71]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[103]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[71]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[71]_srl32_n_1\
    );
\cell_animation_reg[746]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"08288903"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[778]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[746]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[746]_srl32_n_1\
    );
\cell_animation_reg[778]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"240F9000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[675]\,
      Q => \NLW_cell_animation_reg[778]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[778]_srl32_n_1\
    );
\cell_animation_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[8]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[7]\,
      R => '0'
    );
\cell_animation_reg[810]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[811]\,
      Q => \cell_animation_reg_n_0_[810]\,
      R => '0'
    );
\cell_animation_reg[811]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[812]\,
      Q => \cell_animation_reg_n_0_[811]\,
      R => '0'
    );
\cell_animation_reg[812]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[813]\,
      Q => \cell_animation_reg_n_0_[812]\,
      R => '0'
    );
\cell_animation_reg[813]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[814]\,
      Q => \cell_animation_reg_n_0_[813]\,
      R => '0'
    );
\cell_animation_reg[814]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[815]\,
      Q => \cell_animation_reg_n_0_[814]\,
      R => '0'
    );
\cell_animation_reg[815]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[816]\,
      Q => \cell_animation_reg_n_0_[815]\,
      R => '0'
    );
\cell_animation_reg[816]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[817]\,
      Q => \cell_animation_reg_n_0_[816]\,
      R => '0'
    );
\cell_animation_reg[817]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[818]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[817]\,
      R => '0'
    );
\cell_animation_reg[818]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"40F84078"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[849]_srl32_n_1\,
      Q => \cell_animation_reg[818]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[818]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[849]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"70400000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[881]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[849]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[849]_srl32_n_1\
    );
\cell_animation_reg[881]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"3E1089F1"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[913]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[881]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[881]_srl32_n_1\
    );
\cell_animation_reg[8]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[39]_srl32_n_1\,
      Q => \cell_animation_reg[8]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[8]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[913]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"C7C11F00"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg_n_0_[810]\,
      Q => \NLW_cell_animation_reg[913]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[913]_srl32_n_1\
    );
\cell_animation_reg[945]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[946]\,
      Q => data00,
      R => '0'
    );
\cell_animation_reg[946]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[947]\,
      Q => \cell_animation_reg_n_0_[946]\,
      R => '0'
    );
\cell_animation_reg[947]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[948]\,
      Q => \cell_animation_reg_n_0_[947]\,
      R => '0'
    );
\cell_animation_reg[948]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[949]\,
      Q => \cell_animation_reg_n_0_[948]\,
      R => '0'
    );
\cell_animation_reg[949]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[950]\,
      Q => \cell_animation_reg_n_0_[949]\,
      R => '0'
    );
\cell_animation_reg[950]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[951]\,
      Q => \cell_animation_reg_n_0_[950]\,
      R => '0'
    );
\cell_animation_reg[951]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg_n_0_[952]\,
      Q => \cell_animation_reg_n_0_[951]\,
      R => '0'
    );
\cell_animation_reg[952]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cell_animation0,
      D => \cell_animation_reg[953]_srl31_n_0\,
      Q => \cell_animation_reg_n_0_[952]\,
      R => '0'
    );
\cell_animation_reg[953]_srl31\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11110",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[984]_srl32_n_1\,
      Q => \cell_animation_reg[953]_srl31_n_0\,
      Q31 => \NLW_cell_animation_reg[953]_srl31_Q31_UNCONNECTED\
    );
\cell_animation_reg[984]_srl32\: unisim.vcomponents.SRLC32E
    generic map(
      INIT => X"00000000"
    )
        port map (
      A(4 downto 0) => B"11111",
      CE => cell_animation0,
      CLK => clk,
      D => \cell_animation_reg[1016]_srl32_n_1\,
      Q => \NLW_cell_animation_reg[984]_srl32_Q_UNCONNECTED\,
      Q31 => \cell_animation_reg[984]_srl32_n_1\
    );
\cell_generator[22].cell_reg[22]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[22].cell_reg[22]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[22].cell_reg_n_0_[22]\
    );
\cell_generator[22].cell_reg[22]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[22]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[22].cell_reg[22]_i_1_n_0\
    );
\cell_generator[23].cell_reg[23]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[23].cell_reg[23]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[23].cell_reg_n_0_[23]\
    );
\cell_generator[23].cell_reg[23]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[23]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[23].cell_reg[23]_i_1_n_0\
    );
\cell_generator[24].cell_reg[24]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[24].cell_reg[24]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[24].cell_reg_n_0_[24]\
    );
\cell_generator[24].cell_reg[24]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[24]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[24].cell_reg[24]_i_1_n_0\
    );
\cell_generator[26].cell_reg[26]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[26].cell_reg[26]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[26].cell_reg_n_0_[26]\
    );
\cell_generator[26].cell_reg[26]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[32]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[26].cell_reg[26]_i_1_n_0\
    );
\cell_generator[29].cell_reg[29]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[29].cell_reg[29]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[29].cell_reg_n_0_[29]\
    );
\cell_generator[29].cell_reg[29]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[29]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[29].cell_reg[29]_i_1_n_0\
    );
\cell_generator[31].cell_reg[31]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[31].cell_reg[31]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[31].cell_reg_n_0_[31]\
    );
\cell_generator[31].cell_reg[31]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[31]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[31].cell_reg[31]_i_1_n_0\
    );
\cell_generator[32].cell_reg[32]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[32].cell_reg[32]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[32].cell_reg_n_0_[32]\
    );
\cell_generator[32].cell_reg[32]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BE"
    )
        port map (
      I0 => fsm_current_state(1),
      I1 => \rom_memory_reg_n_0_[32]\,
      I2 => fsm_current_state(0),
      O => \cell_generator[32].cell_reg[32]_i_1_n_0\
    );
\cell_generator[33].cell_reg[33]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[33].cell_reg[33]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[33].cell_reg_n_0_[33]\
    );
\cell_generator[33].cell_reg[33]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[33]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[33].cell_reg[33]_i_1_n_0\
    );
\cell_generator[37].cell_reg[37]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[37].cell_reg[37]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[37].cell_reg_n_0_[37]\
    );
\cell_generator[37].cell_reg[37]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[37]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[37].cell_reg[37]_i_1_n_0\
    );
\cell_generator[38].cell_reg[38]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[38].cell_reg[38]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[38].cell_reg_n_0_[38]\
    );
\cell_generator[38].cell_reg[38]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[38]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[38].cell_reg[38]_i_1_n_0\
    );
\cell_generator[39].cell_reg[39]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[39].cell_reg[39]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[39].cell_reg_n_0_[39]\
    );
\cell_generator[39].cell_reg[39]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[39]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[39].cell_reg[39]_i_1_n_0\
    );
\cell_generator[40].cell_reg[40]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[40].cell_reg[40]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[40].cell_reg_n_0_[40]\
    );
\cell_generator[40].cell_reg[40]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[40]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[40].cell_reg[40]_i_1_n_0\
    );
\cell_generator[41].cell_reg[41]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[41].cell_reg[41]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[41].cell_reg_n_0_[41]\
    );
\cell_generator[41].cell_reg[41]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[41]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[41].cell_reg[41]_i_1_n_0\
    );
\cell_generator[42].cell_reg[42]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[42].cell_reg[42]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[42].cell_reg_n_0_[42]\
    );
\cell_generator[42].cell_reg[42]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[42]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[42].cell_reg[42]_i_1_n_0\
    );
\cell_generator[45].cell_reg[45]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[45].cell_reg[45]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[45].cell_reg_n_0_[45]\
    );
\cell_generator[45].cell_reg[45]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[45]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[45].cell_reg[45]_i_1_n_0\
    );
\cell_generator[46].cell_reg[46]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[46].cell_reg[46]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[46].cell_reg_n_0_[46]\
    );
\cell_generator[46].cell_reg[46]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[46]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[46].cell_reg[46]_i_1_n_0\
    );
\cell_generator[47].cell_reg[47]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[47].cell_reg[47]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[47].cell_reg_n_0_[47]\
    );
\cell_generator[47].cell_reg[47]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F6"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[47]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[47].cell_reg[47]_i_1_n_0\
    );
\cell_generator[48].cell_reg[48]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[48].cell_reg[48]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[48].cell_reg_n_0_[48]\
    );
\cell_generator[48].cell_reg[48]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[48]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[48].cell_reg[48]_i_1_n_0\
    );
\cell_generator[49].cell_reg[49]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[49].cell_reg[49]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[49].cell_reg_n_0_[49]\
    );
\cell_generator[49].cell_reg[49]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BE"
    )
        port map (
      I0 => fsm_current_state(1),
      I1 => \rom_memory_reg_n_0_[48]\,
      I2 => fsm_current_state(0),
      O => \cell_generator[49].cell_reg[49]_i_1_n_0\
    );
\cell_generator[53].cell_reg[53]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[53].cell_reg[53]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[53].cell_reg_n_0_[53]\
    );
\cell_generator[53].cell_reg[53]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \rom_memory_reg_n_0_[53]\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      O => \cell_generator[53].cell_reg[53]_i_1_n_0\
    );
\cell_generator[54].cell_reg[54]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[54].cell_reg[54]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[54].cell_reg_n_0_[54]\
    );
\cell_generator[54].cell_reg[54]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BE"
    )
        port map (
      I0 => fsm_current_state(1),
      I1 => \rom_memory_reg_n_0_[53]\,
      I2 => fsm_current_state(0),
      O => \cell_generator[54].cell_reg[54]_i_1_n_0\
    );
\cell_generator[56].cell_reg[56]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[56].cell_reg[56]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[56].cell_reg_n_0_[56]\
    );
\cell_generator[56].cell_reg[56]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => fsm_current_state(0),
      I1 => fsm_current_state(1),
      O => \cell_generator[56].cell_reg[56]_i_1_n_0\
    );
\cell_generator[58].cell_reg[58]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \cell_generator[58].cell_reg[58]_i_1_n_0\,
      G => \cell_generator[58].cell_reg[58]_i_2_n_0\,
      GE => '1',
      Q => \cell_generator[58].cell_reg_n_0_[58]\
    );
\cell_generator[58].cell_reg[58]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => fsm_current_state(0),
      I1 => fsm_current_state(1),
      O => \cell_generator[58].cell_reg[58]_i_1_n_0\
    );
\cell_generator[58].cell_reg[58]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => fsm_current_state(1),
      I1 => fsm_current_state(0),
      O => \cell_generator[58].cell_reg[58]_i_2_n_0\
    );
cnt0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cnt0_carry_n_0,
      CO(2) => cnt0_carry_n_1,
      CO(1) => cnt0_carry_n_2,
      CO(0) => cnt0_carry_n_3,
      CYINIT => cnt(0),
      DI(3 downto 0) => B"0000",
      O(3) => cnt0_carry_n_4,
      O(2) => cnt0_carry_n_5,
      O(1) => cnt0_carry_n_6,
      O(0) => cnt0_carry_n_7,
      S(3 downto 0) => cnt(4 downto 1)
    );
\cnt0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cnt0_carry_n_0,
      CO(3) => \cnt0_carry__0_n_0\,
      CO(2) => \cnt0_carry__0_n_1\,
      CO(1) => \cnt0_carry__0_n_2\,
      CO(0) => \cnt0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt0_carry__0_n_4\,
      O(2) => \cnt0_carry__0_n_5\,
      O(1) => \cnt0_carry__0_n_6\,
      O(0) => \cnt0_carry__0_n_7\,
      S(3 downto 0) => cnt(8 downto 5)
    );
\cnt0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt0_carry__0_n_0\,
      CO(3) => \cnt0_carry__1_n_0\,
      CO(2) => \cnt0_carry__1_n_1\,
      CO(1) => \cnt0_carry__1_n_2\,
      CO(0) => \cnt0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt0_carry__1_n_4\,
      O(2) => \cnt0_carry__1_n_5\,
      O(1) => \cnt0_carry__1_n_6\,
      O(0) => \cnt0_carry__1_n_7\,
      S(3 downto 0) => cnt(12 downto 9)
    );
\cnt0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt0_carry__1_n_0\,
      CO(3) => \cnt0_carry__2_n_0\,
      CO(2) => \cnt0_carry__2_n_1\,
      CO(1) => \cnt0_carry__2_n_2\,
      CO(0) => \cnt0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt0_carry__2_n_4\,
      O(2) => \cnt0_carry__2_n_5\,
      O(1) => \cnt0_carry__2_n_6\,
      O(0) => \cnt0_carry__2_n_7\,
      S(3 downto 0) => cnt(16 downto 13)
    );
\cnt0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt0_carry__2_n_0\,
      CO(3) => \cnt0_carry__3_n_0\,
      CO(2) => \cnt0_carry__3_n_1\,
      CO(1) => \cnt0_carry__3_n_2\,
      CO(0) => \cnt0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt0_carry__3_n_4\,
      O(2) => \cnt0_carry__3_n_5\,
      O(1) => \cnt0_carry__3_n_6\,
      O(0) => \cnt0_carry__3_n_7\,
      S(3 downto 0) => cnt(20 downto 17)
    );
\cnt0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt0_carry__3_n_0\,
      CO(3) => \NLW_cnt0_carry__4_CO_UNCONNECTED\(3),
      CO(2) => \cnt0_carry__4_n_1\,
      CO(1) => \cnt0_carry__4_n_2\,
      CO(0) => \cnt0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt0_carry__4_n_4\,
      O(2) => \cnt0_carry__4_n_5\,
      O(1) => \cnt0_carry__4_n_6\,
      O(0) => \cnt0_carry__4_n_7\,
      S(3 downto 0) => cnt(24 downto 21)
    );
\cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cnt(0),
      O => cnt_1(0)
    );
\cnt[24]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \cnt[24]_i_2_n_0\,
      O => cnt_seconds_0
    );
\cnt[24]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFFFFE"
    )
        port map (
      I0 => \cnt[24]_i_3_n_0\,
      I1 => \cnt[24]_i_4_n_0\,
      I2 => \cnt[24]_i_5_n_0\,
      I3 => \cnt[24]_i_6_n_0\,
      I4 => \cnt[24]_i_7_n_0\,
      I5 => \cnt[24]_i_8_n_0\,
      O => \cnt[24]_i_2_n_0\
    );
\cnt[24]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFDF"
    )
        port map (
      I0 => cnt(16),
      I1 => cnt(15),
      I2 => cnt(18),
      I3 => cnt(17),
      O => \cnt[24]_i_3_n_0\
    );
\cnt[24]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => cnt(20),
      I1 => cnt(19),
      I2 => cnt(22),
      I3 => cnt(21),
      O => \cnt[24]_i_4_n_0\
    );
\cnt[24]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => cnt(8),
      I1 => cnt(7),
      I2 => cnt(10),
      I3 => cnt(9),
      O => \cnt[24]_i_5_n_0\
    );
\cnt[24]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => cnt(12),
      I1 => cnt(11),
      I2 => cnt(14),
      I3 => cnt(13),
      O => \cnt[24]_i_6_n_0\
    );
\cnt[24]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => cnt(4),
      I1 => cnt(3),
      I2 => cnt(5),
      I3 => cnt(6),
      O => \cnt[24]_i_7_n_0\
    );
\cnt[24]_i_8\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DFFFFFFF"
    )
        port map (
      I0 => cnt(0),
      I1 => cnt(23),
      I2 => cnt(24),
      I3 => cnt(2),
      I4 => cnt(1),
      O => \cnt[24]_i_8_n_0\
    );
cnt_fsm0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cnt_fsm0_carry_n_0,
      CO(2) => cnt_fsm0_carry_n_1,
      CO(1) => cnt_fsm0_carry_n_2,
      CO(0) => cnt_fsm0_carry_n_3,
      CYINIT => \cnt_fsm_reg_n_0_[0]\,
      DI(3 downto 0) => B"0000",
      O(3) => cnt_fsm0_carry_n_4,
      O(2) => cnt_fsm0_carry_n_5,
      O(1) => cnt_fsm0_carry_n_6,
      O(0) => cnt_fsm0_carry_n_7,
      S(3) => \cnt_fsm_reg_n_0_[4]\,
      S(2) => \cnt_fsm_reg_n_0_[3]\,
      S(1) => \cnt_fsm_reg_n_0_[2]\,
      S(0) => \cnt_fsm_reg_n_0_[1]\
    );
\cnt_fsm0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cnt_fsm0_carry_n_0,
      CO(3) => \cnt_fsm0_carry__0_n_0\,
      CO(2) => \cnt_fsm0_carry__0_n_1\,
      CO(1) => \cnt_fsm0_carry__0_n_2\,
      CO(0) => \cnt_fsm0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__0_n_4\,
      O(2) => \cnt_fsm0_carry__0_n_5\,
      O(1) => \cnt_fsm0_carry__0_n_6\,
      O(0) => \cnt_fsm0_carry__0_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[8]\,
      S(2) => \cnt_fsm_reg_n_0_[7]\,
      S(1) => \cnt_fsm_reg_n_0_[6]\,
      S(0) => \cnt_fsm_reg_n_0_[5]\
    );
\cnt_fsm0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__0_n_0\,
      CO(3) => \cnt_fsm0_carry__1_n_0\,
      CO(2) => \cnt_fsm0_carry__1_n_1\,
      CO(1) => \cnt_fsm0_carry__1_n_2\,
      CO(0) => \cnt_fsm0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__1_n_4\,
      O(2) => \cnt_fsm0_carry__1_n_5\,
      O(1) => \cnt_fsm0_carry__1_n_6\,
      O(0) => \cnt_fsm0_carry__1_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[12]\,
      S(2) => \cnt_fsm_reg_n_0_[11]\,
      S(1) => \cnt_fsm_reg_n_0_[10]\,
      S(0) => \cnt_fsm_reg_n_0_[9]\
    );
\cnt_fsm0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__1_n_0\,
      CO(3) => \cnt_fsm0_carry__2_n_0\,
      CO(2) => \cnt_fsm0_carry__2_n_1\,
      CO(1) => \cnt_fsm0_carry__2_n_2\,
      CO(0) => \cnt_fsm0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__2_n_4\,
      O(2) => \cnt_fsm0_carry__2_n_5\,
      O(1) => \cnt_fsm0_carry__2_n_6\,
      O(0) => \cnt_fsm0_carry__2_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[16]\,
      S(2) => \cnt_fsm_reg_n_0_[15]\,
      S(1) => \cnt_fsm_reg_n_0_[14]\,
      S(0) => \cnt_fsm_reg_n_0_[13]\
    );
\cnt_fsm0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__2_n_0\,
      CO(3) => \cnt_fsm0_carry__3_n_0\,
      CO(2) => \cnt_fsm0_carry__3_n_1\,
      CO(1) => \cnt_fsm0_carry__3_n_2\,
      CO(0) => \cnt_fsm0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__3_n_4\,
      O(2) => \cnt_fsm0_carry__3_n_5\,
      O(1) => \cnt_fsm0_carry__3_n_6\,
      O(0) => \cnt_fsm0_carry__3_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[20]\,
      S(2) => \cnt_fsm_reg_n_0_[19]\,
      S(1) => \cnt_fsm_reg_n_0_[18]\,
      S(0) => \cnt_fsm_reg_n_0_[17]\
    );
\cnt_fsm0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__3_n_0\,
      CO(3) => \cnt_fsm0_carry__4_n_0\,
      CO(2) => \cnt_fsm0_carry__4_n_1\,
      CO(1) => \cnt_fsm0_carry__4_n_2\,
      CO(0) => \cnt_fsm0_carry__4_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__4_n_4\,
      O(2) => \cnt_fsm0_carry__4_n_5\,
      O(1) => \cnt_fsm0_carry__4_n_6\,
      O(0) => \cnt_fsm0_carry__4_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[24]\,
      S(2) => \cnt_fsm_reg_n_0_[23]\,
      S(1) => \cnt_fsm_reg_n_0_[22]\,
      S(0) => \cnt_fsm_reg_n_0_[21]\
    );
\cnt_fsm0_carry__5\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__4_n_0\,
      CO(3) => \cnt_fsm0_carry__5_n_0\,
      CO(2) => \cnt_fsm0_carry__5_n_1\,
      CO(1) => \cnt_fsm0_carry__5_n_2\,
      CO(0) => \cnt_fsm0_carry__5_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_fsm0_carry__5_n_4\,
      O(2) => \cnt_fsm0_carry__5_n_5\,
      O(1) => \cnt_fsm0_carry__5_n_6\,
      O(0) => \cnt_fsm0_carry__5_n_7\,
      S(3) => \cnt_fsm_reg_n_0_[28]\,
      S(2) => \cnt_fsm_reg_n_0_[27]\,
      S(1) => \cnt_fsm_reg_n_0_[26]\,
      S(0) => \cnt_fsm_reg_n_0_[25]\
    );
\cnt_fsm0_carry__6\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_fsm0_carry__5_n_0\,
      CO(3 downto 1) => \NLW_cnt_fsm0_carry__6_CO_UNCONNECTED\(3 downto 1),
      CO(0) => \cnt_fsm0_carry__6_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 2) => \NLW_cnt_fsm0_carry__6_O_UNCONNECTED\(3 downto 2),
      O(1) => \cnt_fsm0_carry__6_n_6\,
      O(0) => \cnt_fsm0_carry__6_n_7\,
      S(3 downto 2) => B"00",
      S(1) => \cnt_fsm_reg_n_0_[30]\,
      S(0) => \cnt_fsm_reg_n_0_[29]\
    );
\cnt_fsm[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \cnt_fsm_reg_n_0_[0]\,
      O => \cnt_fsm[0]_i_1_n_0\
    );
\cnt_fsm[30]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \FSM_sequential_fsm_current_state[1]_i_3_n_0\,
      O => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm[0]_i_1_n_0\,
      Q => \cnt_fsm_reg_n_0_[0]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__1_n_6\,
      Q => \cnt_fsm_reg_n_0_[10]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__1_n_5\,
      Q => \cnt_fsm_reg_n_0_[11]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__1_n_4\,
      Q => \cnt_fsm_reg_n_0_[12]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__2_n_7\,
      Q => \cnt_fsm_reg_n_0_[13]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__2_n_6\,
      Q => \cnt_fsm_reg_n_0_[14]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__2_n_5\,
      Q => \cnt_fsm_reg_n_0_[15]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__2_n_4\,
      Q => \cnt_fsm_reg_n_0_[16]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__3_n_7\,
      Q => \cnt_fsm_reg_n_0_[17]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__3_n_6\,
      Q => \cnt_fsm_reg_n_0_[18]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__3_n_5\,
      Q => \cnt_fsm_reg_n_0_[19]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_fsm0_carry_n_7,
      Q => \cnt_fsm_reg_n_0_[1]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__3_n_4\,
      Q => \cnt_fsm_reg_n_0_[20]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__4_n_7\,
      Q => \cnt_fsm_reg_n_0_[21]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__4_n_6\,
      Q => \cnt_fsm_reg_n_0_[22]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__4_n_5\,
      Q => \cnt_fsm_reg_n_0_[23]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__4_n_4\,
      Q => \cnt_fsm_reg_n_0_[24]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__5_n_7\,
      Q => \cnt_fsm_reg_n_0_[25]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__5_n_6\,
      Q => \cnt_fsm_reg_n_0_[26]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__5_n_5\,
      Q => \cnt_fsm_reg_n_0_[27]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__5_n_4\,
      Q => \cnt_fsm_reg_n_0_[28]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__6_n_7\,
      Q => \cnt_fsm_reg_n_0_[29]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_fsm0_carry_n_6,
      Q => \cnt_fsm_reg_n_0_[2]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__6_n_6\,
      Q => \cnt_fsm_reg_n_0_[30]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_fsm0_carry_n_5,
      Q => \cnt_fsm_reg_n_0_[3]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_fsm0_carry_n_4,
      Q => \cnt_fsm_reg_n_0_[4]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__0_n_7\,
      Q => \cnt_fsm_reg_n_0_[5]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__0_n_6\,
      Q => \cnt_fsm_reg_n_0_[6]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__0_n_5\,
      Q => \cnt_fsm_reg_n_0_[7]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__0_n_4\,
      Q => \cnt_fsm_reg_n_0_[8]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_fsm_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_fsm0_carry__1_n_7\,
      Q => \cnt_fsm_reg_n_0_[9]\,
      R => \cnt_fsm[30]_i_1_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_1(0),
      Q => cnt(0),
      R => '0'
    );
\cnt_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__1_n_6\,
      Q => cnt(10),
      R => cnt_seconds_0
    );
\cnt_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__1_n_5\,
      Q => cnt(11),
      R => cnt_seconds_0
    );
\cnt_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__1_n_4\,
      Q => cnt(12),
      R => cnt_seconds_0
    );
\cnt_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__2_n_7\,
      Q => cnt(13),
      R => cnt_seconds_0
    );
\cnt_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__2_n_6\,
      Q => cnt(14),
      R => cnt_seconds_0
    );
\cnt_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__2_n_5\,
      Q => cnt(15),
      R => cnt_seconds_0
    );
\cnt_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__2_n_4\,
      Q => cnt(16),
      R => cnt_seconds_0
    );
\cnt_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__3_n_7\,
      Q => cnt(17),
      R => cnt_seconds_0
    );
\cnt_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__3_n_6\,
      Q => cnt(18),
      R => cnt_seconds_0
    );
\cnt_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__3_n_5\,
      Q => cnt(19),
      R => cnt_seconds_0
    );
\cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt0_carry_n_7,
      Q => cnt(1),
      R => cnt_seconds_0
    );
\cnt_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__3_n_4\,
      Q => cnt(20),
      R => cnt_seconds_0
    );
\cnt_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__4_n_7\,
      Q => cnt(21),
      R => cnt_seconds_0
    );
\cnt_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__4_n_6\,
      Q => cnt(22),
      R => cnt_seconds_0
    );
\cnt_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__4_n_5\,
      Q => cnt(23),
      R => cnt_seconds_0
    );
\cnt_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__4_n_4\,
      Q => cnt(24),
      R => cnt_seconds_0
    );
\cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt0_carry_n_6,
      Q => cnt(2),
      R => cnt_seconds_0
    );
\cnt_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt0_carry_n_5,
      Q => cnt(3),
      R => cnt_seconds_0
    );
\cnt_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt0_carry_n_4,
      Q => cnt(4),
      R => cnt_seconds_0
    );
\cnt_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__0_n_7\,
      Q => cnt(5),
      R => cnt_seconds_0
    );
\cnt_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__0_n_6\,
      Q => cnt(6),
      R => cnt_seconds_0
    );
\cnt_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__0_n_5\,
      Q => cnt(7),
      R => cnt_seconds_0
    );
\cnt_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__0_n_4\,
      Q => cnt(8),
      R => cnt_seconds_0
    );
\cnt_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt0_carry__1_n_7\,
      Q => cnt(9),
      R => cnt_seconds_0
    );
cnt_row_swap0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => cnt_row_swap0_carry_n_0,
      CO(2) => cnt_row_swap0_carry_n_1,
      CO(1) => cnt_row_swap0_carry_n_2,
      CO(0) => cnt_row_swap0_carry_n_3,
      CYINIT => cnt_row_swap(0),
      DI(3 downto 0) => B"0000",
      O(3) => cnt_row_swap0_carry_n_4,
      O(2) => cnt_row_swap0_carry_n_5,
      O(1) => cnt_row_swap0_carry_n_6,
      O(0) => cnt_row_swap0_carry_n_7,
      S(3 downto 0) => cnt_row_swap(4 downto 1)
    );
\cnt_row_swap0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => cnt_row_swap0_carry_n_0,
      CO(3) => \cnt_row_swap0_carry__0_n_0\,
      CO(2) => \cnt_row_swap0_carry__0_n_1\,
      CO(1) => \cnt_row_swap0_carry__0_n_2\,
      CO(0) => \cnt_row_swap0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_row_swap0_carry__0_n_4\,
      O(2) => \cnt_row_swap0_carry__0_n_5\,
      O(1) => \cnt_row_swap0_carry__0_n_6\,
      O(0) => \cnt_row_swap0_carry__0_n_7\,
      S(3 downto 0) => cnt_row_swap(8 downto 5)
    );
\cnt_row_swap0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_row_swap0_carry__0_n_0\,
      CO(3) => \cnt_row_swap0_carry__1_n_0\,
      CO(2) => \cnt_row_swap0_carry__1_n_1\,
      CO(1) => \cnt_row_swap0_carry__1_n_2\,
      CO(0) => \cnt_row_swap0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \cnt_row_swap0_carry__1_n_4\,
      O(2) => \cnt_row_swap0_carry__1_n_5\,
      O(1) => \cnt_row_swap0_carry__1_n_6\,
      O(0) => \cnt_row_swap0_carry__1_n_7\,
      S(3 downto 0) => cnt_row_swap(12 downto 9)
    );
\cnt_row_swap0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \cnt_row_swap0_carry__1_n_0\,
      CO(3 downto 2) => \NLW_cnt_row_swap0_carry__2_CO_UNCONNECTED\(3 downto 2),
      CO(1) => \cnt_row_swap0_carry__2_n_2\,
      CO(0) => \cnt_row_swap0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \NLW_cnt_row_swap0_carry__2_O_UNCONNECTED\(3),
      O(2) => \cnt_row_swap0_carry__2_n_5\,
      O(1) => \cnt_row_swap0_carry__2_n_6\,
      O(0) => \cnt_row_swap0_carry__2_n_7\,
      S(3) => '0',
      S(2 downto 0) => cnt_row_swap(15 downto 13)
    );
\cnt_row_swap[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cnt_row_swap(0),
      O => cnt_row_swap_2(0)
    );
\cnt_row_swap_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_row_swap_2(0),
      Q => cnt_row_swap(0),
      R => '0'
    );
\cnt_row_swap_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__1_n_6\,
      Q => cnt_row_swap(10),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__1_n_5\,
      Q => cnt_row_swap(11),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__1_n_4\,
      Q => cnt_row_swap(12),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__2_n_7\,
      Q => cnt_row_swap(13),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__2_n_6\,
      Q => cnt_row_swap(14),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__2_n_5\,
      Q => cnt_row_swap(15),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_row_swap0_carry_n_7,
      Q => cnt_row_swap(1),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_row_swap0_carry_n_6,
      Q => cnt_row_swap(2),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_row_swap0_carry_n_5,
      Q => cnt_row_swap(3),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => cnt_row_swap0_carry_n_4,
      Q => cnt_row_swap(4),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__0_n_7\,
      Q => cnt_row_swap(5),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__0_n_6\,
      Q => cnt_row_swap(6),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__0_n_5\,
      Q => cnt_row_swap(7),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__0_n_4\,
      Q => cnt_row_swap(8),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_row_swap_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_row_swap0_carry__1_n_7\,
      Q => cnt_row_swap(9),
      R => \row_select[7]_i_1_n_0\
    );
\cnt_seconds[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => cnt_seconds(0),
      O => p_0_in(0)
    );
\cnt_seconds[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0FD0"
    )
        port map (
      I0 => cnt_seconds(3),
      I1 => cnt_seconds(2),
      I2 => cnt_seconds(0),
      I3 => cnt_seconds(1),
      O => p_0_in(1)
    );
\cnt_seconds[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6C"
    )
        port map (
      I0 => cnt_seconds(1),
      I1 => cnt_seconds(2),
      I2 => cnt_seconds(0),
      O => p_0_in(2)
    );
\cnt_seconds[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6CC4"
    )
        port map (
      I0 => cnt_seconds(0),
      I1 => cnt_seconds(3),
      I2 => cnt_seconds(2),
      I3 => cnt_seconds(1),
      O => p_0_in(3)
    );
\cnt_seconds_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cnt_seconds_0,
      D => p_0_in(0),
      Q => cnt_seconds(0),
      R => '0'
    );
\cnt_seconds_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cnt_seconds_0,
      D => p_0_in(1),
      Q => cnt_seconds(1),
      R => '0'
    );
\cnt_seconds_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cnt_seconds_0,
      D => p_0_in(2),
      Q => cnt_seconds(2),
      R => '0'
    );
\cnt_seconds_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => cnt_seconds_0,
      D => p_0_in(3),
      Q => cnt_seconds(3),
      R => '0'
    );
\cnt_tens[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0FB0"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[1]\,
      I1 => \cnt_tens_reg_n_0_[2]\,
      I2 => cnt_tens,
      I3 => \cnt_tens_reg_n_0_[0]\,
      O => \cnt_tens[0]_i_1_n_0\
    );
\cnt_tens[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => cnt_tens,
      I2 => \cnt_tens_reg_n_0_[1]\,
      O => \cnt_tens[1]_i_1_n_0\
    );
\cnt_tens[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6F80"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[1]\,
      I1 => \cnt_tens_reg_n_0_[0]\,
      I2 => cnt_tens,
      I3 => \cnt_tens_reg_n_0_[2]\,
      O => \cnt_tens[2]_i_1_n_0\
    );
\cnt_tens[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00001000"
    )
        port map (
      I0 => cnt_seconds(1),
      I1 => cnt_seconds(2),
      I2 => cnt_seconds(0),
      I3 => cnt_seconds(3),
      I4 => \cnt[24]_i_2_n_0\,
      O => cnt_tens
    );
\cnt_tens_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_tens[0]_i_1_n_0\,
      Q => \cnt_tens_reg_n_0_[0]\,
      R => '0'
    );
\cnt_tens_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_tens[1]_i_1_n_0\,
      Q => \cnt_tens_reg_n_0_[1]\,
      R => '0'
    );
\cnt_tens_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => '1',
      D => \cnt_tens[2]_i_1_n_0\,
      Q => \cnt_tens_reg_n_0_[2]\,
      R => '0'
    );
\col_select_reg[0]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(0),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(0)
    );
\col_select_reg[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FAEEAAAAAAAAAAAA"
    )
        port map (
      I0 => \col_select_reg[7]_i_3_n_0\,
      I1 => \col_select_reg[0]_i_2_n_0\,
      I2 => \col_select_reg[0]_i_3_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => fsm_current_state(1),
      I5 => fsm_current_state(0),
      O => col_select(0)
    );
\col_select_reg[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[1]\,
      I1 => \cell_animation_reg_n_0_[3]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[0]\,
      I5 => \cell_animation_reg_n_0_[2]\,
      O => \col_select_reg[0]_i_2_n_0\
    );
\col_select_reg[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[5]\,
      I1 => \cell_animation_reg_n_0_[7]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[4]\,
      I5 => \cell_animation_reg_n_0_[6]\,
      O => \col_select_reg[0]_i_3_n_0\
    );
\col_select_reg[1]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(1),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(1)
    );
\col_select_reg[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFC0804000"
    )
        port map (
      I0 => \col_select_reg[7]_i_6_n_0\,
      I1 => fsm_current_state(0),
      I2 => fsm_current_state(1),
      I3 => \col_select_reg[1]_i_2_n_0\,
      I4 => \col_select_reg[1]_i_3_n_0\,
      I5 => \col_select_reg[1]_i_4_n_0\,
      O => col_select(1)
    );
\col_select_reg[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[136]\,
      I1 => \cell_animation_reg_n_0_[138]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[135]\,
      I5 => \cell_animation_reg_n_0_[137]\,
      O => \col_select_reg[1]_i_2_n_0\
    );
\col_select_reg[1]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[140]\,
      I1 => \cell_animation_reg_n_0_[142]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[139]\,
      I5 => \cell_animation_reg_n_0_[141]\,
      O => \col_select_reg[1]_i_3_n_0\
    );
\col_select_reg[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000DD88CFC0"
    )
        port map (
      I0 => \col_select_reg[1]_i_5_n_0\,
      I1 => \cell_generator[56].cell_reg_n_0_[56]\,
      I2 => \col_select_reg[6]_i_6_n_0\,
      I3 => \cell_generator[58].cell_reg_n_0_[58]\,
      I4 => \col_select_reg[7]_i_6_n_0\,
      I5 => \i[21]_i_2_n_0\,
      O => \col_select_reg[1]_i_4_n_0\
    );
\col_select_reg[1]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFFF77FFFFFF"
    )
        port map (
      I0 => \^q\(5),
      I1 => \^q\(1),
      I2 => \^q\(6),
      I3 => \^q\(7),
      I4 => \^q\(3),
      I5 => \^q\(2),
      O => \col_select_reg[1]_i_5_n_0\
    );
\col_select_reg[2]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(2),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(2)
    );
\col_select_reg[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFFCAF0CA0FCA00"
    )
        port map (
      I0 => \col_select_reg[2]_i_2_n_0\,
      I1 => \col_select_reg[2]_i_3_n_0\,
      I2 => \i[21]_i_2_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => \col_select_reg[2]_i_4_n_0\,
      I5 => \col_select_reg[2]_i_5_n_0\,
      O => col_select(2)
    );
\col_select_reg[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[49].cell_reg_n_0_[49]\,
      I1 => \cell_generator[23].cell_reg_n_0_[23]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[56].cell_reg_n_0_[56]\,
      I5 => \cell_generator[22].cell_reg_n_0_[22]\,
      O => \col_select_reg[2]_i_2_n_0\
    );
\col_select_reg[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[275]\,
      I1 => \cell_animation_reg_n_0_[277]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[274]\,
      I5 => \cell_animation_reg_n_0_[276]\,
      O => \col_select_reg[2]_i_3_n_0\
    );
\col_select_reg[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FC0CFAFAFC0C0A0A"
    )
        port map (
      I0 => \cell_generator[49].cell_reg_n_0_[49]\,
      I1 => \cell_generator[48].cell_reg_n_0_[48]\,
      I2 => \col_select_reg[7]_i_8_n_0\,
      I3 => \cell_generator[56].cell_reg_n_0_[56]\,
      I4 => \col_select_reg[7]_i_9_n_0\,
      I5 => \cell_generator[32].cell_reg_n_0_[32]\,
      O => \col_select_reg[2]_i_4_n_0\
    );
\col_select_reg[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[271]\,
      I1 => \cell_animation_reg_n_0_[273]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[270]\,
      I5 => \cell_animation_reg_n_0_[272]\,
      O => \col_select_reg[2]_i_5_n_0\
    );
\col_select_reg[3]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(3),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(3)
    );
\col_select_reg[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFFCAF0CA0FCA00"
    )
        port map (
      I0 => \col_select_reg[3]_i_2_n_0\,
      I1 => \col_select_reg[3]_i_3_n_0\,
      I2 => \i[21]_i_2_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => \col_select_reg[3]_i_4_n_0\,
      I5 => \col_select_reg[3]_i_5_n_0\,
      O => col_select(3)
    );
\col_select_reg[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[29].cell_reg_n_0_[29]\,
      I1 => \cell_generator[31].cell_reg_n_0_[31]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[56].cell_reg_n_0_[56]\,
      I5 => \cell_generator[46].cell_reg_n_0_[46]\,
      O => \col_select_reg[3]_i_2_n_0\
    );
\col_select_reg[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[410]\,
      I1 => \cell_animation_reg_n_0_[412]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[409]\,
      I5 => \cell_animation_reg_n_0_[411]\,
      O => \col_select_reg[3]_i_3_n_0\
    );
\col_select_reg[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[41].cell_reg_n_0_[41]\,
      I1 => \cell_generator[56].cell_reg_n_0_[56]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[24].cell_reg_n_0_[24]\,
      I5 => \cell_generator[26].cell_reg_n_0_[26]\,
      O => \col_select_reg[3]_i_4_n_0\
    );
\col_select_reg[3]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[406]\,
      I1 => \cell_animation_reg_n_0_[408]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[405]\,
      I5 => \cell_animation_reg_n_0_[407]\,
      O => \col_select_reg[3]_i_5_n_0\
    );
\col_select_reg[4]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(4),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(4)
    );
\col_select_reg[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFFCAF0CA0FCA00"
    )
        port map (
      I0 => \col_select_reg[4]_i_2_n_0\,
      I1 => \col_select_reg[4]_i_3_n_0\,
      I2 => \i[21]_i_2_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => \col_select_reg[4]_i_4_n_0\,
      I5 => \col_select_reg[4]_i_5_n_0\,
      O => col_select(4)
    );
\col_select_reg[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[37].cell_reg_n_0_[37]\,
      I1 => \cell_generator[39].cell_reg_n_0_[39]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[56].cell_reg_n_0_[56]\,
      I5 => \cell_generator[38].cell_reg_n_0_[38]\,
      O => \col_select_reg[4]_i_2_n_0\
    );
\col_select_reg[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[545]\,
      I1 => \cell_animation_reg_n_0_[547]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[544]\,
      I5 => \cell_animation_reg_n_0_[546]\,
      O => \col_select_reg[4]_i_3_n_0\
    );
\col_select_reg[4]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E2FFE200"
    )
        port map (
      I0 => \cell_generator[33].cell_reg_n_0_[33]\,
      I1 => \col_select_reg[7]_i_8_n_0\,
      I2 => \cell_generator[56].cell_reg_n_0_[56]\,
      I3 => \col_select_reg[7]_i_9_n_0\,
      I4 => \cell_generator[32].cell_reg_n_0_[32]\,
      O => \col_select_reg[4]_i_4_n_0\
    );
\col_select_reg[4]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[541]\,
      I1 => \cell_animation_reg_n_0_[543]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[540]\,
      I5 => \cell_animation_reg_n_0_[542]\,
      O => \col_select_reg[4]_i_5_n_0\
    );
\col_select_reg[5]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(5),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(5)
    );
\col_select_reg[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFFCAF0CA0FCA00"
    )
        port map (
      I0 => \col_select_reg[5]_i_2_n_0\,
      I1 => \col_select_reg[5]_i_3_n_0\,
      I2 => \i[21]_i_2_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => \col_select_reg[5]_i_4_n_0\,
      I5 => \col_select_reg[5]_i_5_n_0\,
      O => col_select(5)
    );
\col_select_reg[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[45].cell_reg_n_0_[45]\,
      I1 => \cell_generator[47].cell_reg_n_0_[47]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[58].cell_reg_n_0_[58]\,
      I5 => \cell_generator[46].cell_reg_n_0_[46]\,
      O => \col_select_reg[5]_i_2_n_0\
    );
\col_select_reg[5]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[680]\,
      I1 => \cell_animation_reg_n_0_[682]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[679]\,
      I5 => \cell_animation_reg_n_0_[681]\,
      O => \col_select_reg[5]_i_3_n_0\
    );
\col_select_reg[5]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[41].cell_reg_n_0_[41]\,
      I1 => \cell_generator[58].cell_reg_n_0_[58]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[40].cell_reg_n_0_[40]\,
      I5 => \cell_generator[42].cell_reg_n_0_[42]\,
      O => \col_select_reg[5]_i_4_n_0\
    );
\col_select_reg[5]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[676]\,
      I1 => \cell_animation_reg_n_0_[678]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[675]\,
      I5 => \cell_animation_reg_n_0_[677]\,
      O => \col_select_reg[5]_i_5_n_0\
    );
\col_select_reg[6]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(6),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(6)
    );
\col_select_reg[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CAFFCAF0CA0FCA00"
    )
        port map (
      I0 => \col_select_reg[6]_i_2_n_0\,
      I1 => \col_select_reg[6]_i_3_n_0\,
      I2 => \i[21]_i_2_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => \col_select_reg[6]_i_4_n_0\,
      I5 => \col_select_reg[6]_i_5_n_0\,
      O => col_select(6)
    );
\col_select_reg[6]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_generator[53].cell_reg_n_0_[53]\,
      I1 => \cell_generator[48].cell_reg_n_0_[48]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_generator[56].cell_reg_n_0_[56]\,
      I5 => \cell_generator[54].cell_reg_n_0_[54]\,
      O => \col_select_reg[6]_i_2_n_0\
    );
\col_select_reg[6]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[815]\,
      I1 => \cell_animation_reg_n_0_[817]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[814]\,
      I5 => \cell_animation_reg_n_0_[816]\,
      O => \col_select_reg[6]_i_3_n_0\
    );
\col_select_reg[6]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF22F222F222F2"
    )
        port map (
      I0 => \cell_generator[48].cell_reg_n_0_[48]\,
      I1 => \col_select_reg[7]_i_9_n_0\,
      I2 => \cell_generator[49].cell_reg_n_0_[49]\,
      I3 => \col_select_reg[6]_i_6_n_0\,
      I4 => \cell_generator[56].cell_reg_n_0_[56]\,
      I5 => \col_select_reg[6]_i_7_n_0\,
      O => \col_select_reg[6]_i_4_n_0\
    );
\col_select_reg[6]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[811]\,
      I1 => \cell_animation_reg_n_0_[813]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[810]\,
      I5 => \cell_animation_reg_n_0_[812]\,
      O => \col_select_reg[6]_i_5_n_0\
    );
\col_select_reg[6]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFFFFF77FFFFFF"
    )
        port map (
      I0 => \^q\(6),
      I1 => \^q\(2),
      I2 => \^q\(5),
      I3 => \^q\(7),
      I4 => \^q\(3),
      I5 => \^q\(1),
      O => \col_select_reg[6]_i_6_n_0\
    );
\col_select_reg[6]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"07FFFFFF77FFFFFF"
    )
        port map (
      I0 => \^q\(6),
      I1 => \^q\(2),
      I2 => \^q\(5),
      I3 => \^q\(7),
      I4 => \^q\(3),
      I5 => \^q\(1),
      O => \col_select_reg[6]_i_7_n_0\
    );
\col_select_reg[7]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => col_select(7),
      G => \col_select_reg[7]_i_2_n_0\,
      GE => '1',
      Q => col(7)
    );
\col_select_reg[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FAEEAAAAAAAAAAAA"
    )
        port map (
      I0 => \col_select_reg[7]_i_3_n_0\,
      I1 => \col_select_reg[7]_i_4_n_0\,
      I2 => \col_select_reg[7]_i_5_n_0\,
      I3 => \col_select_reg[7]_i_6_n_0\,
      I4 => fsm_current_state(1),
      I5 => fsm_current_state(0),
      O => col_select(7)
    );
\col_select_reg[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00404040400000"
    )
        port map (
      I0 => \col_select_reg[7]_i_6_n_0\,
      I1 => \^q\(3),
      I2 => \^q\(2),
      I3 => \col_select_reg[7]_i_7_n_0\,
      I4 => \^q\(0),
      I5 => \^q\(1),
      O => \col_select_reg[7]_i_2_n_0\
    );
\col_select_reg[7]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000EB28EB28EB28"
    )
        port map (
      I0 => \cell_generator[58].cell_reg_n_0_[58]\,
      I1 => \col_select_reg[7]_i_8_n_0\,
      I2 => \col_select_reg[7]_i_6_n_0\,
      I3 => \cell_generator[56].cell_reg_n_0_[56]\,
      I4 => fsm_current_state(1),
      I5 => fsm_current_state(0),
      O => \col_select_reg[7]_i_3_n_0\
    );
\col_select_reg[7]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[946]\,
      I1 => \cell_animation_reg_n_0_[948]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => data00,
      I5 => \cell_animation_reg_n_0_[947]\,
      O => \col_select_reg[7]_i_4_n_0\
    );
\col_select_reg[7]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFAFCFA0C0AFC0A0"
    )
        port map (
      I0 => \cell_animation_reg_n_0_[950]\,
      I1 => \cell_animation_reg_n_0_[952]\,
      I2 => \col_select_reg[7]_i_9_n_0\,
      I3 => \col_select_reg[7]_i_8_n_0\,
      I4 => \cell_animation_reg_n_0_[949]\,
      I5 => \cell_animation_reg_n_0_[951]\,
      O => \col_select_reg[7]_i_5_n_0\
    );
\col_select_reg[7]_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(5),
      I1 => \^q\(6),
      I2 => \^q\(7),
      I3 => \^q\(4),
      O => \col_select_reg[7]_i_6_n_0\
    );
\col_select_reg[7]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6880800080000000"
    )
        port map (
      I0 => \^q\(2),
      I1 => \^q\(5),
      I2 => \^q\(7),
      I3 => \^q\(6),
      I4 => \^q\(3),
      I5 => \^q\(4),
      O => \col_select_reg[7]_i_7_n_0\
    );
\col_select_reg[7]_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(2),
      I1 => \^q\(3),
      I2 => \^q\(7),
      I3 => \^q\(6),
      O => \col_select_reg[7]_i_8_n_0\
    );
\col_select_reg[7]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7FFF"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(3),
      I2 => \^q\(7),
      I3 => \^q\(5),
      O => \col_select_reg[7]_i_9_n_0\
    );
i0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => i0_carry_n_0,
      CO(2) => i0_carry_n_1,
      CO(1) => i0_carry_n_2,
      CO(0) => i0_carry_n_3,
      CYINIT => i(0),
      DI(3 downto 0) => B"0000",
      O(3) => i0_carry_n_4,
      O(2) => i0_carry_n_5,
      O(1) => i0_carry_n_6,
      O(0) => i0_carry_n_7,
      S(3 downto 0) => i(4 downto 1)
    );
\i0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => i0_carry_n_0,
      CO(3) => \i0_carry__0_n_0\,
      CO(2) => \i0_carry__0_n_1\,
      CO(1) => \i0_carry__0_n_2\,
      CO(0) => \i0_carry__0_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i0_carry__0_n_4\,
      O(2) => \i0_carry__0_n_5\,
      O(1) => \i0_carry__0_n_6\,
      O(0) => \i0_carry__0_n_7\,
      S(3 downto 0) => i(8 downto 5)
    );
\i0_carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \i0_carry__0_n_0\,
      CO(3) => \i0_carry__1_n_0\,
      CO(2) => \i0_carry__1_n_1\,
      CO(1) => \i0_carry__1_n_2\,
      CO(0) => \i0_carry__1_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i0_carry__1_n_4\,
      O(2) => \i0_carry__1_n_5\,
      O(1) => \i0_carry__1_n_6\,
      O(0) => \i0_carry__1_n_7\,
      S(3 downto 0) => i(12 downto 9)
    );
\i0_carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \i0_carry__1_n_0\,
      CO(3) => \i0_carry__2_n_0\,
      CO(2) => \i0_carry__2_n_1\,
      CO(1) => \i0_carry__2_n_2\,
      CO(0) => \i0_carry__2_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i0_carry__2_n_4\,
      O(2) => \i0_carry__2_n_5\,
      O(1) => \i0_carry__2_n_6\,
      O(0) => \i0_carry__2_n_7\,
      S(3 downto 0) => i(16 downto 13)
    );
\i0_carry__3\: unisim.vcomponents.CARRY4
     port map (
      CI => \i0_carry__2_n_0\,
      CO(3) => \i0_carry__3_n_0\,
      CO(2) => \i0_carry__3_n_1\,
      CO(1) => \i0_carry__3_n_2\,
      CO(0) => \i0_carry__3_n_3\,
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3) => \i0_carry__3_n_4\,
      O(2) => \i0_carry__3_n_5\,
      O(1) => \i0_carry__3_n_6\,
      O(0) => \i0_carry__3_n_7\,
      S(3 downto 0) => i(20 downto 17)
    );
\i0_carry__4\: unisim.vcomponents.CARRY4
     port map (
      CI => \i0_carry__3_n_0\,
      CO(3 downto 0) => \NLW_i0_carry__4_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 1) => \NLW_i0_carry__4_O_UNCONNECTED\(3 downto 1),
      O(0) => \i0_carry__4_n_7\,
      S(3 downto 1) => B"000",
      S(0) => i(21)
    );
\i[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFFFFEF"
    )
        port map (
      I0 => \i[21]_i_3_n_0\,
      I1 => \i[21]_i_4_n_0\,
      I2 => \i[21]_i_5_n_0\,
      I3 => i(9),
      I4 => i(7),
      I5 => i(0),
      O => \i[0]_i_1_n_0\
    );
\i[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000200"
    )
        port map (
      I0 => \i[21]_i_2_n_0\,
      I1 => \i[21]_i_3_n_0\,
      I2 => \i[21]_i_4_n_0\,
      I3 => \i[21]_i_5_n_0\,
      I4 => i(9),
      I5 => i(7),
      O => \i[21]_i_1_n_0\
    );
\i[21]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => fsm_current_state(0),
      I1 => fsm_current_state(1),
      O => \i[21]_i_2_n_0\
    );
\i[21]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF7FFF"
    )
        port map (
      I0 => i(3),
      I1 => i(11),
      I2 => i(10),
      I3 => i(4),
      I4 => \i[21]_i_6_n_0\,
      O => \i[21]_i_3_n_0\
    );
\i[21]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFF7"
    )
        port map (
      I0 => i(15),
      I1 => i(16),
      I2 => i(19),
      I3 => i(12),
      I4 => i(14),
      O => \i[21]_i_4_n_0\
    );
\i[21]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => i(8),
      I1 => i(6),
      O => \i[21]_i_5_n_0\
    );
\i[21]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF7FFFFFFF"
    )
        port map (
      I0 => i(13),
      I1 => i(2),
      I2 => i(5),
      I3 => i(21),
      I4 => i(0),
      I5 => \i[21]_i_7_n_0\,
      O => \i[21]_i_6_n_0\
    );
\i[21]_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FF7F"
    )
        port map (
      I0 => i(18),
      I1 => i(1),
      I2 => i(17),
      I3 => i(20),
      O => \i[21]_i_7_n_0\
    );
\i_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i[0]_i_1_n_0\,
      Q => i(0),
      R => '0'
    );
\i_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__1_n_6\,
      Q => i(10),
      R => \i[21]_i_1_n_0\
    );
\i_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__1_n_5\,
      Q => i(11),
      R => \i[21]_i_1_n_0\
    );
\i_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__1_n_4\,
      Q => i(12),
      R => \i[21]_i_1_n_0\
    );
\i_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__2_n_7\,
      Q => i(13),
      R => \i[21]_i_1_n_0\
    );
\i_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__2_n_6\,
      Q => i(14),
      R => \i[21]_i_1_n_0\
    );
\i_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__2_n_5\,
      Q => i(15),
      R => \i[21]_i_1_n_0\
    );
\i_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__2_n_4\,
      Q => i(16),
      R => \i[21]_i_1_n_0\
    );
\i_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__3_n_7\,
      Q => i(17),
      R => \i[21]_i_1_n_0\
    );
\i_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__3_n_6\,
      Q => i(18),
      R => \i[21]_i_1_n_0\
    );
\i_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__3_n_5\,
      Q => i(19),
      R => \i[21]_i_1_n_0\
    );
\i_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => i0_carry_n_7,
      Q => i(1),
      R => \i[21]_i_1_n_0\
    );
\i_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__3_n_4\,
      Q => i(20),
      R => \i[21]_i_1_n_0\
    );
\i_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__4_n_7\,
      Q => i(21),
      R => \i[21]_i_1_n_0\
    );
\i_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => i0_carry_n_6,
      Q => i(2),
      R => \i[21]_i_1_n_0\
    );
\i_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => i0_carry_n_5,
      Q => i(3),
      R => \i[21]_i_1_n_0\
    );
\i_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => i0_carry_n_4,
      Q => i(4),
      R => \i[21]_i_1_n_0\
    );
\i_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__0_n_7\,
      Q => i(5),
      R => \i[21]_i_1_n_0\
    );
\i_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__0_n_6\,
      Q => i(6),
      R => \i[21]_i_1_n_0\
    );
\i_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__0_n_5\,
      Q => i(7),
      R => \i[21]_i_1_n_0\
    );
\i_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__0_n_4\,
      Q => i(8),
      R => \i[21]_i_1_n_0\
    );
\i_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \i[21]_i_2_n_0\,
      D => \i0_carry__1_n_7\,
      Q => i(9),
      R => \i[21]_i_1_n_0\
    );
\rom_memory_reg[22]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[22]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[22]\
    );
\rom_memory_reg[22]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFBFBFB"
    )
        port map (
      I0 => cnt_seconds(1),
      I1 => cnt_seconds(2),
      I2 => cnt_seconds(0),
      I3 => \cnt_tens_reg_n_0_[1]\,
      I4 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[22]_i_1_n_0\
    );
\rom_memory_reg[22]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000AAAAAAAB"
    )
        port map (
      I0 => \rom_memory_reg[22]_i_3_n_0\,
      I1 => cnt_seconds(1),
      I2 => cnt_seconds(2),
      I3 => cnt_seconds(3),
      I4 => cnt_seconds(0),
      I5 => \cnt_tens_reg_n_0_[2]\,
      O => \rom_memory_reg[22]_i_2_n_0\
    );
\rom_memory_reg[22]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      O => \rom_memory_reg[22]_i_3_n_0\
    );
\rom_memory_reg[23]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[23]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[23]\
    );
\rom_memory_reg[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFEEFFEEFFEEF"
    )
        port map (
      I0 => cnt_seconds(3),
      I1 => cnt_seconds(1),
      I2 => cnt_seconds(0),
      I3 => cnt_seconds(2),
      I4 => \cnt_tens_reg_n_0_[0]\,
      I5 => \cnt_tens_reg_n_0_[1]\,
      O => \rom_memory_reg[23]_i_1_n_0\
    );
\rom_memory_reg[24]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[24]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[24]\
    );
\rom_memory_reg[24]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[1]\,
      I1 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[24]_i_1_n_0\
    );
\rom_memory_reg[29]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[29]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[29]\
    );
\rom_memory_reg[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"88FF88F8F8FFF8FF"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      I2 => cnt_seconds(2),
      I3 => cnt_seconds(1),
      I4 => cnt_seconds(3),
      I5 => cnt_seconds(0),
      O => \rom_memory_reg[29]_i_1_n_0\
    );
\rom_memory_reg[31]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[31]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[31]\
    );
\rom_memory_reg[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F8FFF8F88FFF8FFF"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      I2 => cnt_seconds(1),
      I3 => cnt_seconds(2),
      I4 => cnt_seconds(3),
      I5 => cnt_seconds(0),
      O => \rom_memory_reg[31]_i_1_n_0\
    );
\rom_memory_reg[32]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[32]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[32]\
    );
\rom_memory_reg[32]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[1]\,
      I1 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[32]_i_1_n_0\
    );
\rom_memory_reg[33]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[33]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[33]\
    );
\rom_memory_reg[33]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      O => \rom_memory_reg[33]_i_1_n_0\
    );
\rom_memory_reg[37]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[37]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[37]\
    );
\rom_memory_reg[37]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F8FFFFFFFFFFF8FF"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      I2 => cnt_seconds(3),
      I3 => cnt_seconds(0),
      I4 => cnt_seconds(1),
      I5 => cnt_seconds(2),
      O => \rom_memory_reg[37]_i_1_n_0\
    );
\rom_memory_reg[38]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[38]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[38]\
    );
\rom_memory_reg[38]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0BBB0FFF0FFF0EEE"
    )
        port map (
      I0 => cnt_seconds(3),
      I1 => cnt_seconds(2),
      I2 => \cnt_tens_reg_n_0_[0]\,
      I3 => \cnt_tens_reg_n_0_[1]\,
      I4 => cnt_seconds(0),
      I5 => cnt_seconds(1),
      O => \rom_memory_reg[38]_i_1_n_0\
    );
\rom_memory_reg[39]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[39]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[39]\
    );
\rom_memory_reg[39]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEFFFEFFFEF"
    )
        port map (
      I0 => cnt_seconds(1),
      I1 => cnt_seconds(2),
      I2 => cnt_seconds(0),
      I3 => cnt_seconds(3),
      I4 => \cnt_tens_reg_n_0_[1]\,
      I5 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[39]_i_1_n_0\
    );
\rom_memory_reg[40]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[40]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[40]\
    );
\rom_memory_reg[40]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[40]_i_1_n_0\
    );
\rom_memory_reg[41]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[41]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[41]\
    );
\rom_memory_reg[41]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      O => \rom_memory_reg[41]_i_1_n_0\
    );
\rom_memory_reg[42]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[42]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[42]\
    );
\rom_memory_reg[42]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[1]\,
      I1 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[42]_i_1_n_0\
    );
\rom_memory_reg[45]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[45]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[45]\
    );
\rom_memory_reg[45]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF454545"
    )
        port map (
      I0 => cnt_seconds(0),
      I1 => cnt_seconds(1),
      I2 => cnt_seconds(2),
      I3 => \cnt_tens_reg_n_0_[1]\,
      I4 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[45]_i_1_n_0\
    );
\rom_memory_reg[46]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[46]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[46]\
    );
\rom_memory_reg[46]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000700"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      I2 => cnt_seconds(3),
      I3 => cnt_seconds(0),
      I4 => cnt_seconds(2),
      I5 => cnt_seconds(1),
      O => \rom_memory_reg[46]_i_1_n_0\
    );
\rom_memory_reg[47]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[47]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[47]\
    );
\rom_memory_reg[47]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFFF88F"
    )
        port map (
      I0 => \cnt_tens_reg_n_0_[0]\,
      I1 => \cnt_tens_reg_n_0_[1]\,
      I2 => cnt_seconds(0),
      I3 => cnt_seconds(1),
      I4 => cnt_seconds(3),
      I5 => cnt_seconds(2),
      O => \rom_memory_reg[47]_i_1_n_0\
    );
\rom_memory_reg[48]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => '1',
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[48]\
    );
\rom_memory_reg[53]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \rom_memory_reg[53]_i_1_n_0\,
      G => \rom_memory_reg[22]_i_2_n_0\,
      GE => '1',
      Q => \rom_memory_reg_n_0_[53]\
    );
\rom_memory_reg[53]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF7D7D7D"
    )
        port map (
      I0 => cnt_seconds(2),
      I1 => cnt_seconds(0),
      I2 => cnt_seconds(1),
      I3 => \cnt_tens_reg_n_0_[1]\,
      I4 => \cnt_tens_reg_n_0_[0]\,
      O => \rom_memory_reg[53]_i_1_n_0\
    );
\row_select[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000040000000"
    )
        port map (
      I0 => \row_select[7]_i_2_n_0\,
      I1 => cnt_row_swap(1),
      I2 => cnt_row_swap(0),
      I3 => cnt_row_swap(3),
      I4 => cnt_row_swap(2),
      I5 => \row_select[7]_i_3_n_0\,
      O => \row_select[7]_i_1_n_0\
    );
\row_select[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => cnt_row_swap(5),
      I1 => cnt_row_swap(4),
      I2 => cnt_row_swap(6),
      I3 => cnt_row_swap(7),
      O => \row_select[7]_i_2_n_0\
    );
\row_select[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFEFFF"
    )
        port map (
      I0 => cnt_row_swap(10),
      I1 => cnt_row_swap(11),
      I2 => cnt_row_swap(8),
      I3 => cnt_row_swap(9),
      I4 => \row_select[7]_i_4_n_0\,
      O => \row_select[7]_i_3_n_0\
    );
\row_select[7]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFFF"
    )
        port map (
      I0 => cnt_row_swap(13),
      I1 => cnt_row_swap(12),
      I2 => cnt_row_swap(15),
      I3 => cnt_row_swap(14),
      O => \row_select[7]_i_4_n_0\
    );
\row_select_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(7),
      Q => \^q\(0),
      R => '0'
    );
\row_select_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(0),
      Q => \^q\(1),
      R => '0'
    );
\row_select_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(1),
      Q => \^q\(2),
      R => '0'
    );
\row_select_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(2),
      Q => \^q\(3),
      R => '0'
    );
\row_select_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(3),
      Q => \^q\(4),
      R => '0'
    );
\row_select_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(4),
      Q => \^q\(5),
      R => '0'
    );
\row_select_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(5),
      Q => \^q\(6),
      R => '0'
    );
\row_select_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => clk,
      CE => \row_select[7]_i_1_n_0\,
      D => \^q\(6),
      Q => \^q\(7),
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_top_0_0 is
  port (
    clk : in STD_LOGIC;
    col : out STD_LOGIC_VECTOR ( 7 downto 0 );
    led : out STD_LOGIC_VECTOR ( 3 downto 0 );
    row : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_top_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_top_0_0 : entity is "design_1_top_0_0,top,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_top_0_0 : entity is "yes";
  attribute ip_definition_source : string;
  attribute ip_definition_source of design_1_top_0_0 : entity is "module_ref";
  attribute x_core_info : string;
  attribute x_core_info of design_1_top_0_0 : entity is "top,Vivado 2023.2";
end design_1_top_0_0;

architecture STRUCTURE of design_1_top_0_0 is
  signal \<const0>\ : STD_LOGIC;
  attribute x_interface_info : string;
  attribute x_interface_info of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 25000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0";
begin
  led(3) <= \<const0>\;
  led(2) <= \<const0>\;
  led(1) <= \<const0>\;
  led(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
U0: entity work.design_1_top_0_0_top
     port map (
      Q(7 downto 0) => row(7 downto 0),
      clk => clk,
      col(7 downto 0) => col(7 downto 0)
    );
end STRUCTURE;

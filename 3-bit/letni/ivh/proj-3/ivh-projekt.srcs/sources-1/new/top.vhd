--
-- @file top.vhd
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Top level module of the project.
-- @date 2024-05-14
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Top level entity with associated ports.
entity top is
    Port ( clk  : in    STD_LOGIC;
           col  : out   STD_LOGIC_VECTOR (7 downto 0);
           led  : out   STD_LOGIC_VECTOR (3 downto 0);
           row  : out   STD_LOGIC_VECTOR (7 downto 0)
         );
end top;

-- Architecture of the top level entity.
architecture Behavioral of top is
    -- User defined type for finite state machine (FSM) states.
    type FSM_STATE              is (STATE_NORMAL, STATE_INVERSE, STATE_IMAGE, STATE_ANIMATION);

    -- Constants for each cell number to be displayed.
    constant CELL_00            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100101101001011010010111100111";
    constant CELL_01            : STD_LOGIC_VECTOR (16 to 55) := "1110011010100010101000101010001011100111";
    constant CELL_02            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100001101001111010010011100111";
    constant CELL_03            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100001101001111010000111100111";
    constant CELL_04            : STD_LOGIC_VECTOR (16 to 55) := "1110010010100101101001111010000111100001";
    constant CELL_05            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100100101001111010000111100111";
    constant CELL_06            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100100101001111010010111100111";
    constant CELL_07            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100001101000011010000111100001";
    constant CELL_08            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100101101001111010010111100111";
    constant CELL_09            : STD_LOGIC_VECTOR (16 to 55) := "1110011110100101101001111010000111100111";
    constant CELL_10            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000101010001010100010111100111";
    constant CELL_11            : STD_LOGIC_VECTOR (16 to 55) := "1100011001000010010000100100001011100111";
    constant CELL_12            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000001010001110100010011100111";
    constant CELL_13            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000001010001110100000111100111";
    constant CELL_14            : STD_LOGIC_VECTOR (16 to 55) := "1100010001000101010001110100000111100001";
    constant CELL_15            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000100010001110100000111100111";
    constant CELL_16            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000100010001110100010111100111";
    constant CELL_17            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000001010000010100000111100001";
    constant CELL_18            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000101010001110100010111100111";
    constant CELL_19            : STD_LOGIC_VECTOR (16 to 55) := "1100011101000101010001110100000111100111";
    constant CELL_20            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100101111001011000010111100111";
    constant CELL_21            : STD_LOGIC_VECTOR (16 to 55) := "1110011000100010111000101000001011100111";
    constant CELL_22            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100001111001111000010011100111";
    constant CELL_23            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100001111001111000000111100111";
    constant CELL_24            : STD_LOGIC_VECTOR (16 to 55) := "1110010000100101111001111000000111100001";
    constant CELL_25            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100100111001111000000111100111";
    constant CELL_26            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100100111001111000010111100111";
    constant CELL_27            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100001111000011000000111100001";
    constant CELL_28            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100101111001111000010111100111";
    constant CELL_29            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100101111001111000000111100111";
    constant CELL_30            : STD_LOGIC_VECTOR (16 to 55) := "1110011100100101111001010010010111100111";

    -- Constant for each cell image to be displayed.
    constant CELL_IMAGE         : STD_LOGIC_VECTOR (0 to 63) := "0011110001000010101001011000000110100101100110010100001000111100";

    -- Constant for the maximum value of the animation counter (shift set to each 0.104 s for smooth animation).
    constant CNT_ANIMATION_MAX  : INTEGER := 2600000 - 1;       -- implementation
    -- constant CNT_ANIMATION_MAX  : INTEGER := 2600 - 1;       -- simulation

    -- Constant for the maximum value of the FSM switch to the animation state (set to 36 s from the beginning by default).
    constant CNT_FSM_ANIMATION  : INTEGER := 900000000 - 1;     -- implementation
    -- constant CNT_FSM_ANIMATION  : INTEGER := 900000 - 1;     -- simulation

    -- Constant for the maximum value of the FSM switch to the image state (set to 31 s from the beginning by default).
    constant CNT_FSM_IMAGE      : INTEGER := 775000000 - 1;     -- implementation
    -- constant CNT_FSM_IMAGE      : INTEGER := 775000 - 1;     -- simulation

    -- Constant for the maximum value of the FSM counter of the entire display (set to 50 s from the beginning by default).
    constant CNT_FSM_MAX        : INTEGER := 1250000000 - 1;    -- implementation
    -- constant CNT_FSM_MAX        : INTEGER := 1250000 - 1;    -- simulation

    -- Constant for the maximum value of the FSM switch to the inverse state (set to 21 s from the beginning by default).
    constant CNT_FSM_INVERSE    : INTEGER := 525000000 - 1;     -- implementation
    -- constant CNT_FSM_INVERSE    : INTEGER := 525000 - 1;     -- simulation

    -- Constant for the maximum value of the 25 MHz ticks counter (set to 1 s by default).
    constant CNT_MAX            : INTEGER := 25000000 - 1;      -- implementation
    -- constant CNT_MAX            : INTEGER := 25000 - 1;      -- simulation

    -- Constant for the maximum value of the counter for row swapping (set to 0.002 s s by default).
    constant CNT_ROW_SWAP_MAX   : INTEGER := 50000 - 1;         -- implementation
    -- constant CNT_ROW_SWAP_MAX   : INTEGER := 50 - 1;         -- simulation

    -- Constants for the maximum value of the tens and seconds counters (set to 9 and 4 by default).
    constant CNT_SECONDS_MAX    : INTEGER := 9;
    constant CNT_TENS_MAX       : INTEGER := 4;

    -- Signal vector for the cell to be displayed.
    signal cell                 : STD_LOGIC_VECTOR (0 to 63) := (others => '0');

    -- Signal vector for the cell animation to be displayed.
    signal cell_animation       : STD_LOGIC_VECTOR (0 to 1079) := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111100111110011111000001111000100010011111000000000000000000000011111001000100100010011110000111000111100000110001000000000000000000001000000001000000100000001000100100010000100000000000000010000000000100001000100100010000001001001100000010001010001000000000000000000001111000001000000100000001111000100010000100000001111100001000000000100001000100111110001110001010100011100010010001000000000000000000001000000001000000100000001000100100010000100000000000000010000000000100000101000100010010000001100100100000011111001000000000000000000001000000111110000100000001111000011100000100000000000000000000000011111000010000100010011111000111000111110000010001111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

    -- Signal for the counter of the number of 25 MHz ticks.
    signal cnt                  : INTEGER range 0 to CNT_MAX := 0;

    -- Signal for the counter of the FSM current and next state switching logic.
    signal cnt_fsm              : INTEGER range 0 to CNT_FSM_MAX := 0;

    -- Signal for the counter of the row swapping logic.
    signal cnt_row_swap         : INTEGER range 0 to CNT_ROW_SWAP_MAX := 0;

    -- Signals for the counters of the tens and seconds.
    signal cnt_seconds          : INTEGER range 0 to CNT_SECONDS_MAX := 0;
    signal cnt_tens             : INTEGER range 0 to CNT_TENS_MAX := 0;

    -- Signal vector for the selection of the column to be displayed.
    signal col_select           : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

    -- Signals for the FSM current and next state.
    signal fsm_current_state    : FSM_STATE := STATE_NORMAL;
    signal fsm_next_state       : FSM_STATE := STATE_NORMAL;

    -- Signal vector for storing the actual ROM memory content.
    signal rom_memory           : STD_LOGIC_VECTOR (0 to 63) := (others => '0');

    -- Signal vector for the selection of the row to be displayed.
    signal row_select           : STD_LOGIC_VECTOR (7 downto 0) := "11111110";

-- Main processes of the top level entity.
begin
    -- Process for counting one iteration of the entire display (50 s).
    process (clk)
    begin
        if rising_edge (clk) then
            if cnt_fsm = CNT_FSM_MAX then
                cnt_fsm <= 0;
            else
                cnt_fsm <= cnt_fsm + 1;
            end if;
        end if;
    end process;

    -- Process for counting the tens and seconds (up to 49 s).
    process (clk)
    begin
        if rising_edge (clk) then
            if cnt = CNT_MAX then
                if cnt_seconds = CNT_SECONDS_MAX then
                    cnt_seconds <= 0;
                    if cnt_tens = CNT_TENS_MAX then
                        cnt_tens <= 0;
                    else
                        cnt_tens <= cnt_tens + 1;   -- increment tens
                    end if;
                else
                    cnt_seconds <= cnt_seconds + 1; -- increment seconds
                end if;
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    -- Process for counting the row swapping (0.002 s).
    process (clk)
    begin
        if rising_edge (clk) then
            if cnt_row_swap = CNT_ROW_SWAP_MAX then
                row_select <= row_select (6 downto 0) & row_select (7); -- shift row select to the left
                cnt_row_swap <= 0;
            else
                cnt_row_swap <= cnt_row_swap + 1;
            end if;
        end if;
    end process;

    -- Process for the FSM next state switching logic.
    process (clk)
    begin
        if rising_edge (clk) then
            fsm_current_state <= fsm_next_state;    -- update current state
        end if;
    end process;

    -- Process for the FSM current state logic.
    process (cnt_fsm, fsm_current_state)
    begin
        case fsm_current_state is
            when STATE_NORMAL =>
                if cnt_fsm = CNT_FSM_INVERSE then
                    fsm_next_state <= STATE_INVERSE;    -- switch to inverse state
                else
                    fsm_next_state <= STATE_NORMAL;     -- stay in normal state
                end if;
            when STATE_INVERSE =>
                if cnt_fsm = CNT_FSM_IMAGE then
                    fsm_next_state <= STATE_IMAGE;      -- switch to image state
                else
                    fsm_next_state <= STATE_INVERSE;    -- stay in inverse state
                end if;
            when STATE_IMAGE =>
                if cnt_fsm = CNT_FSM_ANIMATION then
                    fsm_next_state <= STATE_ANIMATION;  -- switch to animation state
                else
                    fsm_next_state <= STATE_IMAGE;      -- stay in image state
                end if;
            when STATE_ANIMATION =>
                if cnt_fsm = CNT_FSM_MAX then
                    fsm_next_state <= STATE_NORMAL;     -- switch to normal state
                else
                    fsm_next_state <= STATE_ANIMATION;  -- stay in animation state
                end if;
        end case;
    end process;

    -- Process for the ROM memory content.
    process (cnt_seconds, cnt_tens)
    begin
        -- Select the ROM memory content based on the tens and seconds.
        case cnt_tens is
            when 0 =>
                case cnt_seconds is
                    when 0 => rom_memory (16 to 55) <= CELL_00;
                    when 1 => rom_memory (16 to 55) <= CELL_01;
                    when 2 => rom_memory (16 to 55) <= CELL_02;
                    when 3 => rom_memory (16 to 55) <= CELL_03;
                    when 4 => rom_memory (16 to 55) <= CELL_04;
                    when 5 => rom_memory (16 to 55) <= CELL_05;
                    when 6 => rom_memory (16 to 55) <= CELL_06;
                    when 7 => rom_memory (16 to 55) <= CELL_07;
                    when 8 => rom_memory (16 to 55) <= CELL_08;
                    when 9 => rom_memory (16 to 55) <= CELL_09;
                end case;
            when 1 =>
                case cnt_seconds is
                    when 0 => rom_memory (16 to 55) <= CELL_10;
                    when 1 => rom_memory (16 to 55) <= CELL_11;
                    when 2 => rom_memory (16 to 55) <= CELL_12;
                    when 3 => rom_memory (16 to 55) <= CELL_13;
                    when 4 => rom_memory (16 to 55) <= CELL_14;
                    when 5 => rom_memory (16 to 55) <= CELL_15;
                    when 6 => rom_memory (16 to 55) <= CELL_16;
                    when 7 => rom_memory (16 to 55) <= CELL_17;
                    when 8 => rom_memory (16 to 55) <= CELL_18;
                    when 9 => rom_memory (16 to 55) <= CELL_19;
                end case;
            when 2 =>
                case cnt_seconds is
                    when 0 => rom_memory (16 to 55) <= CELL_20;
                    when 1 => rom_memory (16 to 55) <= CELL_21;
                    when 2 => rom_memory (16 to 55) <= CELL_22;
                    when 3 => rom_memory (16 to 55) <= CELL_23;
                    when 4 => rom_memory (16 to 55) <= CELL_24;
                    when 5 => rom_memory (16 to 55) <= CELL_25;
                    when 6 => rom_memory (16 to 55) <= CELL_26;
                    when 7 => rom_memory (16 to 55) <= CELL_27;
                    when 8 => rom_memory (16 to 55) <= CELL_28;
                    when 9 => rom_memory (16 to 55) <= CELL_29;
                end case;
            when 3 =>
                case cnt_seconds is
                    when 0      => rom_memory (16 to 55) <= CELL_30;
                    when others => null;
                end case;
            when others => null;
        end case;
    end process;

    -- Process for the cell animation logic.
    process (clk, fsm_current_state)
        variable i : INTEGER range 0 to CNT_ANIMATION_MAX := 0; -- local variable for the animation counter
    begin
        if fsm_current_state = STATE_ANIMATION then
            if rising_edge (clk) then
                if i = CNT_ANIMATION_MAX then
                    cell_animation <=
                        cell_animation (1 to 134)       &   cell_animation (0)      &   -- shift the first row of the animation to the left
                        cell_animation (136 to 269)     &   cell_animation (135)    &   -- shift the second row of the animation to the left
                        cell_animation (271 to 404)     &   cell_animation (270)    &   -- shift the third row of the animation to the left
                        cell_animation (406 to 539)     &   cell_animation (405)    &   -- shift the fourth row of the animation to the left
                        cell_animation (541 to 674)     &   cell_animation (540)    &   -- shift the fifth row of the animation to the left
                        cell_animation (676 to 809)     &   cell_animation (675)    &   -- shift the sixth row of the animation to the left
                        cell_animation (811 to 944)     &   cell_animation (810)    &   -- shift the seventh row of the animation to the left
                        cell_animation (946 to 1079)    &   cell_animation (945);       -- shift the eighth row of the animation to the left
                    i := 0;
                else
                    i := i + 1;
                end if;
            end if;
        end if;
    end process;

    -- Generate the cell logic for the entire display.
    cell_generator : for i in 0 to 63 generate
        constant index : INTEGER := i;  -- local constant for the cell index
    begin
        -- Select the cell content to be displayed based on the FSM state.
        cell (index) <=
            rom_memory (index)      when (fsm_current_state = STATE_NORMAL)     -- ROM memory content
        else
            not rom_memory (index)  when (fsm_current_state = STATE_INVERSE)    -- inverse ROM memory content
        else
            CELL_IMAGE (index)      when (fsm_current_state = STATE_IMAGE);     -- image content
    end generate cell_generator;

    -- Process for the column selection logic.
    process (cell, fsm_current_state, row_select)
    begin
        -- Select the column to be displayed based on the FSM state and the row select.
        if fsm_current_state = STATE_ANIMATION then
            -- Select the column for the animation state (from the animation cell vector).
            case row_select is
                when "11111110" => col_select <= cell_animation (945) & cell_animation (810) & cell_animation (675) & cell_animation (540) & cell_animation (405) & cell_animation (270) & cell_animation (135) & cell_animation (0);   -- the eighth row of the animation
                when "11111101" => col_select <= cell_animation (946) & cell_animation (811) & cell_animation (676) & cell_animation (541) & cell_animation (406) & cell_animation (271) & cell_animation (136) & cell_animation (1);   -- the seventh row of the animation
                when "11111011" => col_select <= cell_animation (947) & cell_animation (812) & cell_animation (677) & cell_animation (542) & cell_animation (407) & cell_animation (272) & cell_animation (137) & cell_animation (2);   -- the sixth row of the animation
                when "11110111" => col_select <= cell_animation (948) & cell_animation (813) & cell_animation (678) & cell_animation (543) & cell_animation (408) & cell_animation (273) & cell_animation (138) & cell_animation (3);   -- the fifth row of the animation
                when "11101111" => col_select <= cell_animation (949) & cell_animation (814) & cell_animation (679) & cell_animation (544) & cell_animation (409) & cell_animation (274) & cell_animation (139) & cell_animation (4);   -- the fourth row of the animation
                when "11011111" => col_select <= cell_animation (950) & cell_animation (815) & cell_animation (680) & cell_animation (545) & cell_animation (410) & cell_animation (275) & cell_animation (140) & cell_animation (5);   -- the third row of the animation
                when "10111111" => col_select <= cell_animation (951) & cell_animation (816) & cell_animation (681) & cell_animation (546) & cell_animation (411) & cell_animation (276) & cell_animation (141) & cell_animation (6);   -- the second row of the animation
                when "01111111" => col_select <= cell_animation (952) & cell_animation (817) & cell_animation (682) & cell_animation (547) & cell_animation (412) & cell_animation (277) & cell_animation (142) & cell_animation (7);   -- the first row of the animation
                when others     => null;
            end case;
        else
            -- Select the column for the normal, inverse and image states (from the cell vector).
            case row_select is
                when "11111110" => col_select <= cell (56) & cell (48) & cell (40) & cell (32) & cell (24) & cell (16) & cell (8) & cell (0);   -- the eighth row of the normal, inverse and image
                when "11111101" => col_select <= cell (57) & cell (49) & cell (41) & cell (33) & cell (25) & cell (17) & cell (9) & cell (1);   -- the seventh row of the normal, inverse and image
                when "11111011" => col_select <= cell (58) & cell (50) & cell (42) & cell (34) & cell (26) & cell (18) & cell (10) & cell (2);  -- the sixth row of the normal, inverse and image
                when "11110111" => col_select <= cell (59) & cell (51) & cell (43) & cell (35) & cell (27) & cell (19) & cell (11) & cell (3);  -- the fifth row of the normal, inverse and image
                when "11101111" => col_select <= cell (60) & cell (52) & cell (44) & cell (36) & cell (28) & cell (20) & cell (12) & cell (4);  -- the fourth row of the normal, inverse and image
                when "11011111" => col_select <= cell (61) & cell (53) & cell (45) & cell (37) & cell (29) & cell (21) & cell (13) & cell (5);  -- the third row of the normal, inverse and image
                when "10111111" => col_select <= cell (62) & cell (54) & cell (46) & cell (38) & cell (30) & cell (22) & cell (14) & cell (6);  -- the second row of the normal, inverse and image
                when "01111111" => col_select <= cell (63) & cell (55) & cell (47) & cell (39) & cell (31) & cell (23) & cell (15) & cell (7);  -- the first row of the normal, inverse and image
                when others     => null;
            end case;
        end if;
    end process;

    -- Assign the signals to the output ports.
    col <= col_select;
    led <= (others => '0');
    row <= row_select;

end Behavioral;

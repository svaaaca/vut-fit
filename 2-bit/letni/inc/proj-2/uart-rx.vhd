-- uart-rx.vhd: UART controller - receiving (RX) side
-- Author(s): David Kvacek (xkvace00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    signal CEN : std_logic := '0';
    signal CNT : std_logic_vector(7 downto 0) := (others => '0');
    signal VLD : std_logic := '0';
begin

    -- Instance of RX FSM
    FSM: entity work.UART_RX_FSM
    port map(
        CLK => CLK,
        RST => RST,
        DIN => DIN,
        CNT => CNT,
        CEN => CEN,
        VLD => VLD
    );

    -- Instance of RX AND gate register
    AND_GATE: process(DIN, VLD)
    begin
        DOUT_VLD <= DIN and VLD;
    end process;

    -- Instance of RX COUNTER register
    COUNTER: process(CLK, RST, CEN)
    begin
        if(RST = '1' or rising_edge(CEN)) then
            CNT <= (others => '0');
        elsif(rising_edge(CLK)) then
            if(CEN = '1') then
                CNT <= CNT + 1;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(0) register
    DOUT_0: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(0) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 23) then
                DOUT(0) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(1) register
    DOUT_1: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(1) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 39) then
                DOUT(1) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(2) register
    DOUT_2: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(2) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 55) then
                DOUT(2) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(3) register
    DOUT_3: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(3) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 71) then
                DOUT(3) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(4) register
    DOUT_4: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(4) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 87) then
                DOUT(4) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(5) register
    DOUT_5: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(5) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 103) then
                DOUT(5) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(6) register
    DOUT_6: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(6) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 119) then
                DOUT(6) <= DIN;
            end if;
        end if;
    end process;

    -- Instance of RX DOUT(7) register
    DOUT_7: process(CLK, RST, CNT)
    begin
        if(RST = '1' or CNT = 0) then
            DOUT(7) <= '0';
        elsif(rising_edge(CLK)) then
            if(CNT = 135) then
                DOUT(7) <= DIN;
            end if;
        end if;
    end process;

end architecture;

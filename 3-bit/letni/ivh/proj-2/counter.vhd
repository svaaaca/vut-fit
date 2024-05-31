--
-- @file counter.vhd
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Implementation of the BCD counter.
-- @date 2024-04-07
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- counter entity
entity counter is
    port ( CLK    : in  std_logic;
           RESET  : in  std_logic;
           EN     : in  std_logic;
		   Q      : out std_logic_vector(3 downto 0);
		   EN_OUT : out std_logic
		 );
end counter;

-- counter architecture
architecture behavioral of counter is
    -- signals for counting and setting the overflow flag
    signal COUNT    : std_logic_vector(3 downto 0) := "0000";
    signal OVERFLOW : std_logic := '0';
begin
    -- own process based on CLK and RESET signals
    process (CLK, RESET)
    begin
        if RESET = '1' then
            COUNT <= "0000";
            OVERFLOW <= '0';
        elsif rising_edge(CLK) then
            if EN = '1' then
                if COUNT = "1001" then
                    COUNT <= "0000";
                    OVERFLOW <= '1';
                else
                    COUNT <= COUNT + 1;
                    OVERFLOW <= '0';
                end if;
            else
                OVERFLOW <= '0';
            end if;
        end if;
    end process;
    -- connection of internal signals to the global ones
    Q <= COUNT;
    EN_OUT <= OVERFLOW;
end behavioral;

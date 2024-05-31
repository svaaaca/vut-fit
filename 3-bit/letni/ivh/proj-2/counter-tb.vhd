--
-- @file counter-tb.vhd
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Testbench implementation using the assert construct.
-- @date 2024-04-07
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_tb is
end counter_tb;

-- counter_tb architecture
architecture behavior of counter_tb is
    -- counter component
    component counter is
        port ( CLK      : in  std_logic;
               RESET    : in  std_logic;
               EN       : in  std_logic;
               Q        : out std_logic_vector(3 downto 0);
               EN_OUT   : out std_logic
             );
    end component;

    -- clock period constant
    constant CLK_PERIOD : time := 2 ns;

    -- component signals
    signal CLK          : std_logic := '0';
    signal EN1          : std_logic := '0';
    signal Q1           : std_logic_vector(3 downto 0);
    signal Q2           : std_logic_vector(3 downto 0);
    signal OVERFLOW1    : std_logic;
    signal OVERFLOW2    : std_logic;
begin
	-- Unit Under Test (UUT) instantiation
    UUT1: counter port map (CLK, '0', EN1, Q1, OVERFLOW1);
    UUT2: counter port map (CLK, '0', OVERFLOW1, Q2, OVERFLOW2);

    -- CLK stimulation
    CLK <= not CLK after CLK_PERIOD / 2;
    
    -- EN1 stimulation
    process
    begin
        EN1 <= '1';
        wait for CLK_PERIOD;
        EN1 <= '0';
        wait for CLK_PERIOD * 4;
    end process;

    -- testing the counter functionality
    process
    begin
        -- first test
        wait for CLK_PERIOD / 2;
        assert EN1 = '1' report "FAIL: first test (EN1)" severity error;
        assert Q2 = "0000" report "FAIL: first test (Q2)" severity error;
        assert OVERFLOW1 = '0' report "FAIL: first test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '0' report "FAIL: first test (OVERFLOW2)" severity error;

        -- second test
        wait for CLK_PERIOD / 2;
        assert Q1 = "0001" report "FAIL: second test (Q1)" severity error;
        assert Q2 = "0000" report "FAIL: second test (Q2)" severity error;
        assert OVERFLOW1 = '0' report "FAIL: second test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '0' report "FAIL: second test (OVERFLOW2)" severity error;

        -- third test
        wait for CLK_PERIOD * 45;
        assert Q1 = "0000" report "FAIL: third test (Q1)" severity error;
        assert Q2 = "0000" report "FAIL: third test (Q2)" severity error;
        assert OVERFLOW1 = '1' report "FAIL: third test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '0' report "FAIL: third test (OVERFLOW2)" severity error;

        -- fourth test
        wait for CLK_PERIOD;
        assert EN1 = '0' report "FAIL: fourth test (EN1)" severity error;
        assert Q1 = "0000" report "FAIL: fourth test (Q1)" severity error;
        assert Q2 = "0001" report "FAIL: fourth test (Q2)" severity error;
        assert OVERFLOW1 = '0' report "FAIL: fourth test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '0' report "FAIL: fourth test (OVERFLOW2)" severity error;

        -- fifth test
        wait for CLK_PERIOD * 448;
        assert Q1 = "1001" report "FAIL: fifth test (Q1)" severity error;
        assert Q2 = "1001" report "FAIL: fifth test (Q2)" severity error;
        assert OVERFLOW1 = '0' report "FAIL: fifth test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '0' report "FAIL: fifth test (OVERFLOW2)" severity error;

        -- sixth test
        wait for CLK_PERIOD * 2;
        assert EN1 = '0' report "FAIL: sixth test (EN1)" severity error;
        assert Q1 = "0000" report "FAIL: sixth test (Q1)" severity error;
        assert Q2 = "0000" report "FAIL: sixth test (Q2)" severity error;
        assert OVERFLOW1 = '0' report "FAIL: sixth test (OVERFLOW1)" severity error;
        assert OVERFLOW2 = '1' report "FAIL: sixth test (OVERFLOW2)" severity error;

        wait;
    end process;
end;

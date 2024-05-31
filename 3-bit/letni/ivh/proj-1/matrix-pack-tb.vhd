--
-- @file matrix-pack-tb.vhd
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Testbench implementation using the assert construct.
-- @date 2024-03-11
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_pack.all;

entity matrix_pack_tb is
end matrix_pack_tb;

architecture behavior of matrix_pack_tb is
    -- constants
    constant N : integer := 3;

    -- signals for testing
    signal DATA : std_logic_vector(0 to N * N - 1) := "101000110";
    signal RESULT : std_logic_vector(0 to N - 1) := "000";
    signal NEAREST : natural := 0;
begin
    -- testing the GETROW function
    process
    begin
        -- first test
        wait for 10 ns;
        assert GETROW(DATA, 0, N) = "101" report "FAIL: first test" severity error;
        RESULT <= GETROW(DATA, 0, N);

        -- second test
        wait for 10 ns;
        assert GETROW(DATA, 1, N) = "001" report "FAIL: second test" severity error;
        RESULT <= GETROW(DATA, 1, N);
        
        -- third test
        wait for 10 ns;
        assert GETROW(DATA, 2, N) = "100" report "FAIL: third test" severity error;
        RESULT <= GETROW(DATA, 2, N);

        -- cleanup
        wait for 10 ns;
        RESULT <= "000";
        wait;
    end process;

    -- testing the NEAREST2N function
    process
    begin
        -- fourth test
        wait for 10 ns;
        assert NEAREST2N(6) = 8 report "FAIL: fourth test" severity error;
        NEAREST <= NEAREST2N(6);

        -- fifth test
        wait for 10 ns;
        assert NEAREST2N(42) = 64 report "FAIL: fifth test" severity error;
        NEAREST <= NEAREST2N(42);
 
        -- sixth test
        wait for 10 ns;
        assert NEAREST2N(64) = 64 report "FAIL: sixth test" severity error;
        NEAREST <= NEAREST2N(64);
        
        -- cleanup
        wait for 10 ns;
        NEAREST <= 0;
        wait;
    end process;
end behavior;

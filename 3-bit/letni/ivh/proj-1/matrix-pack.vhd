--
-- @file matrix-pack.vhd
-- @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
-- @brief Implementation of matrix pack with supporting functions.
-- @date 2024-03-11
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package matrix_pack is
    -- column selection function
    function GETROW(DATA : in std_logic_vector; COL : in integer; N : in integer) return std_logic_vector;

    -- type for display states
    type STATE_T is (S_BCD_NORM, S_BCD_INV, S_ALT);

    -- function to find the nearest higher power of two
    function NEAREST2N(DATA : in natural) return natural;
end package matrix_pack;

package body matrix_pack is
    -- implementation of the GETROW function
    function GETROW(DATA: in std_logic_vector; COL: in integer; N: in integer) return std_logic_vector is
        variable RESULT: std_logic_vector(0 to N - 1);
        variable INDEX: integer := COL;
    begin
        for i in 0 to N - 1 loop
            RESULT(i) := DATA(INDEX);
            INDEX := INDEX + N;
        end loop;
        return RESULT;
    end function GETROW;

    -- implementation of the NEAREST2N function
    function NEAREST2N(DATA: in natural) return natural is
        variable POW: natural := 1;
    begin
        while POW < DATA loop
            POW := POW * 2;
        end loop;
        return POW;
    end function NEAREST2N;
end package body matrix_pack;

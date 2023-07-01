-- uart.vhd: UART controller - receiving part
-- Author: xkvace00 [David Kvacek]
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK     : in std_logic;
    RST     : in std_logic;
    DIN     : in std_logic;

    DOUT    : out std_logic_vector(7 downto 0);
    DOUT_VLD: out std_logic := '0'
    );
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal cnt_out : std_logic;
signal data_out: std_logic;
signal vld_out : std_logic;

signal clk_cnt : std_logic_vector(4 downto 0);
signal bit_cnt : std_logic_vector(3 downto 0);

begin
    FSM: entity work.UART_FSM(behavioral)
    port map(
    	CLK_IN   => CLK,
    	RST_IN   => RST,
    	CNT_IN   => clk_cnt,
    	DIN_IN   => DIN,
    	BIT_IN   => bit_cnt,

	CNT_OUT  => cnt_out,
	DATA_OUT => data_out,
	VLD_OUT  => vld_out
    	);

    DOUT_VLD <= vld_out;
    RX_PROCESS: process (CLK)
    begin
    if (CLK'event and CLK'last_value = '0' and CLK = '1') then

	if (RST = '0') then
	    if (cnt_out = '0') then
		clk_cnt <= "00000";
	    else
		clk_cnt <= clk_cnt + 1;
	    end if;

	    if (((data_out = '1') nand (clk_cnt = "11000")) nand ((data_out = '1') nand (clk_cnt = "11000"))) then
		DOUT(conv_integer(bit_cnt)) <= DIN;
		bit_cnt <= bit_cnt + 1;
		clk_cnt <= "00001";
	    end if;

	    if (data_out = '0') then
		bit_cnt <= "0000";
	    end if;

	else
	    clk_cnt <= "00000";
	    bit_cnt <= "0000";
	end if;

    end if;
    end process RX_PROCESS;
end behavioral;

-- uart-fsm.vhd: UART controller - finite state machine
-- Author: xkvace00 [David Kvacek]
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
    CNT_IN  : in std_logic_vector(4 downto 0);
    RST_IN  : in std_logic;
    CLK_IN  : in std_logic;
    DIN_IN  : in std_logic;
    BIT_IN  : in std_logic_vector(3 downto 0);

    CNT_OUT : out std_logic;
    DATA_OUT: out std_logic;
    VLD_OUT : out std_logic
    );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is

type status is (IDLE, FIRST, DATA, STOP, VALID);
signal FSM_STATUS : status := IDLE;

begin
    CNT_OUT  <= '0' when (FSM_STATUS = IDLE or FSM_STATUS = VALID) else '1';
    DATA_OUT <= '1' when (FSM_STATUS = DATA) else '0';
    VLD_OUT  <= '1' when (FSM_STATUS = VALID) else '0';

    FSM_PROCESS: process (CLK_IN)
    begin
    if (CLK_IN'event and CLK_IN'last_value = '0' and CLK_IN = '1') then

	if RST_IN = '0' then
	    if (FSM_STATUS = IDLE) then
		if (DIN_IN = '0') then
		    FSM_STATUS <= FIRST;
		end if;
	    end if;

	    if (FSM_STATUS = FIRST) then
		if (CNT_IN = "11000") then
		    FSM_STATUS <= DATA;
		end if;
	    end if;

	    if (FSM_STATUS = DATA) then
		if (BIT_IN = "1000") then
		    FSM_STATUS <= STOP;
		end if;
	    end if;

	    if (FSM_STATUS = STOP) then
		if (CNT_IN = "10000") then
		    FSM_STATUS <= VALID;
		end if;
	    end if;

	    if (FSM_STATUS = VALID) then
		FSM_STATUS <= IDLE;
	    end if;

	else
	    FSM_STATUS <= IDLE;
	end if;

    end if;
    end process FSM_PROCESS;
end behavioral;

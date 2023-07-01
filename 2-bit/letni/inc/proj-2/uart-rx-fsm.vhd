-- uart-rx-fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): David Kvacek (xkvace00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       DIN : in std_logic;
       CNT : in std_logic_vector(7 downto 0);
       CEN : out std_logic;
       VLD : out std_logic
    );
end entity;



architecture behavioral of UART_RX_FSM is
    type FSM_STATE is(IDLE, START, RECEIVE, STOP);
    signal P_STATE : FSM_STATE;
    signal N_STATE : FSM_STATE;
begin

    -- Present state register of RX FSM
    P_STATE_REG: process(CLK, RST)
    begin
        if(RST = '1') then
            P_STATE <= IDLE;
        elsif(rising_edge(CLK)) then
            P_STATE <= N_STATE;
        end if;
    end process;

    -- Next state logic of RX FSM
    N_STATE_LOGIC: process(P_STATE, DIN, CNT)
    begin
        VLD <= '0';
        case P_STATE is
            when IDLE =>
                N_STATE <= IDLE;
                if(DIN = '0') then
                    N_STATE <= START;
                end if;
            when START =>
                N_STATE <= START;
                if(CNT = 7 and DIN = '1') then
                    N_STATE <= IDLE;
                end if;
                if(CNT = 15) then
                    N_STATE <= RECEIVE;
                end if;
            when RECEIVE =>
                N_STATE <= RECEIVE;
                if(CNT = 143) then
                    N_STATE <= STOP;
                end if;
            when STOP =>
                N_STATE <= STOP;
                if(CNT = 151) then
                    N_STATE <= IDLE;
                    VLD <= '1';
                end if;
            when others =>
                N_STATE <= IDLE;
        end case;
    end process;

    -- Output logic of RX FSM
    OUTPUT_LOGIC: process(P_STATE)
    begin
        case P_STATE is
            when IDLE =>
                CEN <= '0';
            when START =>
                CEN <= '1';
            when RECEIVE =>
                CEN <= '1';
            when STOP =>
                CEN <= '1';
            when others =>
                null;
        end case;
    end process;

end architecture;

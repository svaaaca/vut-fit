-- cpu.vhd: Simple 8-bit CPU (BrainFuck interpreter)
-- Copyright (C) 2022 Brno University of Technology,
--                    Faculty of Information Technology
-- Author(s): David Kvacek <xkvace00 AT stud.fit.vutbr.cz>
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity cpu is
 port (
   CLK   : in std_logic;  -- hodinovy signal
   RESET : in std_logic;  -- asynchronni reset procesoru
   EN    : in std_logic;  -- povoleni cinnosti procesoru
 
   -- synchronni pamet RAM
   DATA_ADDR  : out std_logic_vector(12 downto 0);  -- adresa do pameti
   DATA_WDATA : out std_logic_vector(7 downto 0);   -- mem[DATA_ADDR] <- DATA_WDATA pokud DATA_EN='1'
   DATA_RDATA : in std_logic_vector(7 downto 0);    -- DATA_RDATA <- ram[DATA_ADDR] pokud DATA_EN='1'
   DATA_RDWR  : out std_logic;                      -- cteni (0) / zapis (1)
   DATA_EN    : out std_logic;                      -- povoleni cinnosti
   
   -- vstupni port
   IN_DATA   : in std_logic_vector(7 downto 0);     -- IN_DATA <- stav klavesnice pokud IN_VLD='1' a IN_REQ='1'
   IN_VLD    : in std_logic;                        -- data platna
   IN_REQ    : out std_logic;                       -- pozadavek na vstup data
   
   -- vystupni port
   OUT_DATA : out  std_logic_vector(7 downto 0);    -- zapisovana data
   OUT_BUSY : in std_logic;                         -- LCD je zaneprazdnen (1), nelze zapisovat
   OUT_WE   : out std_logic                         -- LCD <- OUT_DATA pokud OUT_WE='1' a OUT_BUSY='0'
 );
end cpu;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of cpu is

  -- CNT SIGNALS
  signal CNT_INC : std_logic := '0';                                  -- inkrementace citace
  signal CNT_DEC : std_logic := '0';                                  -- dekrementace citace
  signal CNT_OUT : std_logic_vector(12 downto 0) := "0000000000000";  -- 13-bitovy vystup citace

  -- PC SIGNALS
  signal PC_INC  : std_logic := '0';                                  -- inkrementace instrukcniho citace
  signal PC_DEC  : std_logic := '0';                                  -- dekrementace instrukcniho citace
  signal PC_OUT  : std_logic_vector(12 downto 0) := "0000000000000";  -- 13-bitovy vystup instrukcniho citace

  -- PTR SIGNALS
  signal PTR_INC : std_logic := '0';                                  -- inkrementace ukazatele na data
  signal PTR_DEC : std_logic := '0';                                  -- dekrementace ukazatele na data
  signal PTR_OUT : std_logic_vector(12 downto 0) := "1000000000000";  -- 13-bitovy vystup ukazatele na data

  -- MX1 SIGNALS
  signal MX1_SEL : std_logic := '0';                                  -- vyberovy signal multiplexoru 1

  -- MX2 SIGNALS
  signal MX2_SEL : std_logic_vector(1 downto 0) := "00";              -- vyberovy signal multiplexoru 2

  -- FSM STATES
  type fsm_state is (
    s_start,               -- pocatecni stav automatu
    s_fetch,               -- stav nacitani instrukci z pameti
    s_decode,              -- stav dekodovani nactenych instrukci

    s_ptr_inc,             -- stav inkrementace ukazatele na data
    s_ptr_dec,             -- stav dekrementace ukazatele na data

    s_val_inc_start,       -- stav inkrementace hodnoty bunky (prvni faze)
    s_val_inc_end,         -- stav inkrementace hodnoty bunky (druha faze)

    s_val_dec_start,       -- stav dekrementace hodnoty bunky (prvni faze)
    s_val_dec_end,         -- stav dekrementace hodnoty bunky (druha faze)

    s_print_start,         -- stav tisknuti hodnoty aktualni bunky (prvni faze)
    s_print_in,            -- stav tisknuti hodnoty aktualni bunky (druha faze)
    s_print_end,           -- stav tisknuti hodnoty aktualni bunky (treti faze)

    s_load_start,          -- stav nacitani hodnoty do aktualni bunky (prvni faze)
    s_load_end,            -- stav nacitani hodnoty do aktualni bunky (druha faze)

    s_while_start,         -- stav provadeni cyklu while (prvni faze)
    s_while_check,         -- stav provadeni cyklu while (druha faze)
    s_while_in,            -- stav provadeni cyklu while (treti faze)
    s_while_end,           -- stav provadeni cyklu while (ctvrta faze)
    s_while_end_check,     -- stav provadeni cyklu while (pata faze)

    s_do_while_start,      -- stav provadeni cyklu do while (prvni faze)
    s_do_while_in,         -- stav provadeni cyklu do while (druha faze)
    s_do_while_end,        -- stav provadeni cyklu do while (treti faze)
    s_do_while_end_check,  -- stav provadeni cyklu do while (ctvrta faze)

    s_null                 -- stav ukonceni vykonavani programu
  );

  signal fsm_current_state : fsm_state := s_start;  -- aktualni stav automatu
  signal fsm_next_state    : fsm_state;             -- nasledujici stav automatu

begin

  -- CNT PROCESS
  CNT : process(CLK, RESET, CNT_INC, CNT_DEC) is
    begin
      if(RESET = '1') then                      -- pokud je signal RESET = '1'
        CNT_OUT <= "0000000000000";             -- vystup citace je vynulovan
      elsif(CLK'event) and (CLK = '1') then     -- pri nabezne hrane hodinoveho signalu
        if(CNT_INC = '1') then                  -- je-li signal CNT_INC = '1'
          CNT_OUT <= CNT_OUT + "0000000000001"; -- inkrementujeme vystup citace
        elsif(CNT_DEC = '1') then               -- je-li signal CNT_DEC = '1'
          CNT_OUT <= CNT_OUT - "0000000000001"; -- dekrementujeme vystup citace
        end if;
      end if;
    end process;

  -- PC PROCESS
  PC : process(CLK, RESET, PC_INC, PC_DEC) is
  begin
    if(RESET = '1') then                    -- pokud je signal RESET = '1'
      PC_OUT <= "0000000000000";            -- vystup instrukcniho citace je vynulovan
    elsif(CLK'event) and (CLK = '1') then   -- pri nabezne hrane hodinoveho signalu
      if(PC_INC = '1') then                 -- je-li signal PC_INC = '1'
        PC_OUT <= PC_OUT + "0000000000001"; -- inkrementujeme vystup instrukcniho citace
      elsif(PC_DEC = '1') then              -- je-li signal PC_DEC = '1'
        PC_OUT <= PC_OUT - "0000000000001"; -- dekrementujeme vystup instrukcniho citace
      end if;
    end if;
  end process;

  -- PTR PROCESS
  PTR : process(CLK, RESET, PTR_INC, PTR_DEC) is
  begin
    if(RESET = '1') then                        -- pokud je signal RESET = '1'
      PTR_OUT <= "1000000000000";               -- vystup ukazatele na data je vynulovan
    elsif(CLK'event) and (CLK = '1') then       -- pri nabezne hrane hodinoveho signalu
      if(PTR_INC = '1') then                    -- je-li signal PTR_INC = '1'
        if(PTR_OUT = "1111111111111") then      -- pokud je PTR_OUT na maximalni hodnote
          PTR_OUT <= "1000000000000";           -- nastavime PTR_OUT na pocatecni hodnotu
        else
          PTR_OUT <= PTR_OUT + "0000000000001"; -- jinak inkrementujeme vystup ukazatele na data
        end if;
      elsif(PTR_DEC = '1') then                 -- je-li signal PTR_DEC = '1'
        if(PTR_OUT = "1000000000000") then      -- pokud je PTR_OUT na pocatecni hodnote
          PTR_OUT <= "1111111111111";           -- nastavime PTR_OUT na maximalni hodnotu
        else
          PTR_OUT <= PTR_OUT - "0000000000001"; -- jinak dekrementujeme vystup ukazatele na data
        end if;
      end if;
    end if;
  end process;

  -- MX1 PROCESS
  MX1 : process(PC_OUT, PTR_OUT, MX1_SEL) is
  begin
    case MX1_SEL is
      when '0'    => DATA_ADDR <= PC_OUT;         -- vystupem multiplexoru je instrukcni citac
      when '1'    => DATA_ADDR <= PTR_OUT;        -- vystupem multiplexoru je ukazatel na data
      when others => DATA_ADDR <= "0000000000000";
    end case;
  end process;

  -- MX2 PROCESS
  MX2 : process(IN_DATA, DATA_RDATA, MX2_SEL) is
  begin
    case MX2_SEL is                                         -- rozhodujeme se podle signalu MX2_SEL
      when "00"   => DATA_WDATA <= IN_DATA;                 -- vystupem multiplexoru je IN_DATA
      when "01"   => DATA_WDATA <= DATA_RDATA - "00000001"; -- vystupem multiplexoru je DATA_RDATA - 1
      when "10"   => DATA_WDATA <= DATA_RDATA + "00000001"; -- vystupem multiplexoru je DATA_RDATA + 1
      when others => DATA_WDATA <= "00000000";              -- v ostatnich pripadech je vystupem '0'
    end case;
  end process;

  -- FSM CURRENT STATE LOGIC
  FSM_CURRENT_STATE_LOGIC : process(CLK, RESET, EN) is
  begin
    if(RESET = '1') then                      -- pokud je signal RESET = '1'
      fsm_current_state <= s_start;           -- stav automatu je s_start
    elsif(CLK'event) and (CLK = '1') then     -- pri nabezne hrane hodinoveho signalu
      if(EN = '1') then                       -- pokud je signal EN = '1'
        fsm_current_state <= fsm_next_state;  -- automat prechazi do dalsiho stavu
      end if;
    end if;
  end process;

  -- FSM NEXT STATE LOGIC
  FSM_NEXT_STATE_LOGIC : process(fsm_current_state, IN_VLD, OUT_BUSY, DATA_RDATA) is
  begin
    IN_REQ    <= '0';             -- inicializace signalu IN_REQ
    OUT_WE    <= '0';             -- inicializace signalu OUT_WE

    PC_INC    <= '0';             -- inicializace signalu PC_INC
    PC_DEC    <= '0';             -- inicializace signalu PC_DEC

    PTR_INC   <= '0';             -- inicializace signalu PTR_INC
    PTR_DEC   <= '0';             -- inicializace signalu PTR_DEC

    MX1_SEL   <= '0';             -- inicializace signalu MX1_SEL

    MX2_SEL   <= "00";            -- inicializace signalu MX2_SEL

    DATA_RDWR <= '0';             -- inicializace signalu DATA_RDWR
    DATA_EN   <= '0';             -- inicializace signalu DATA_EN

    case fsm_current_state is
      when s_start => fsm_next_state <= s_fetch;

      when s_fetch => DATA_EN <= '1';
                      fsm_next_state <= s_decode;

      when s_decode =>
        case DATA_RDATA is
          when "00111110"  =>  fsm_next_state <= s_ptr_inc;
          when "00111100"  =>  fsm_next_state <= s_ptr_dec;
          when "00101011"  =>  fsm_next_state <= s_val_inc_start;
          when "00101101"  =>  fsm_next_state <= s_val_dec_start;
          when "00101110"  =>  fsm_next_state <= s_print_start;
          when "00101100"  =>  fsm_next_state <= s_load_start;
          when "01011011"  =>  fsm_next_state <= s_while_start;
          when "01011101"  =>  fsm_next_state <= s_while_end;
          when "00101000"  =>  fsm_next_state <= s_do_while_start;
          when "00101001"  =>  fsm_next_state <= s_do_while_end;
          when "00000000"  =>  fsm_next_state <= s_null;
          when others =>  fsm_next_state <= s_fetch;
                          PC_INC <= '1';
        end case;

      when s_ptr_inc => PTR_INC <= '1';
                        PC_INC  <= '1';
                        fsm_next_state <= s_fetch;

      when s_ptr_dec => PTR_DEC <= '1';
                        PC_INC  <= '1';
                        fsm_next_state <= s_fetch;

      when s_val_inc_start => MX1_SEL   <= '1';
                              DATA_EN   <= '1';
                              DATA_RDWR <= '0';
                              fsm_next_state <= s_val_inc_end;

      when s_val_inc_end   => MX1_SEL   <= '1';
                              MX2_SEL   <= "10";
                              DATA_EN   <= '1';
                              DATA_RDWR <= '1';
                              PC_INC    <= '1';
                              fsm_next_state <= s_fetch;

      when s_val_dec_start => MX1_SEL   <= '1';
                              DATA_EN   <= '1';
                              DATA_RDWR <= '0';
                              fsm_next_state <= s_val_dec_end;

      when s_val_dec_end   => MX1_SEL   <= '1';
                              MX2_SEL   <= "01";
                              DATA_EN   <= '1';
                              DATA_RDWR <= '1';
                              PC_INC    <= '1';
                              fsm_next_state <= s_fetch;
                              
      when s_print_start   => if(OUT_BUSY = '1') then
                                fsm_next_state <= s_print_start;
                              else
                                MX1_SEL   <= '1';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_print_in;
                              end if;

      when s_print_in      => MX1_SEL   <= '1';
                              DATA_EN   <= '1';
                              DATA_RDWR <= '0';
                              OUT_DATA  <= DATA_RDATA;
                              fsm_next_state <= s_print_end;

      when s_print_end     => OUT_WE <= '1';
                              PC_INC <= '1';
                              fsm_next_state <= s_fetch;

      when s_load_start    => IN_REQ    <= '1';
                              DATA_EN   <= '1';
                              DATA_RDWR <= '1';
                              MX1_SEL   <= '1';
                              MX2_SEL   <= "00";
                              if(IN_VLD = '1') then
                                fsm_next_state <= s_load_end;
                              else
                                fsm_next_state <= s_load_start;
                              end if;
      
      when s_load_end      => PC_INC <= '1';
                              fsm_next_state <= s_fetch;

      when s_while_start   => PC_INC    <= '1';
                              MX1_SEL   <= '1';
                              DATA_EN   <= '1';
                              DATA_RDWR <= '0';
                              fsm_next_state <= s_while_check;

      when s_while_check   => if(DATA_RDATA = "00000000") then
                                MX1_SEL   <= '0';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_while_in;
                              else
                                fsm_next_state <= s_fetch;
                              end if;

      when s_while_in      => if(DATA_RDATA /= "01011101") then
                                PC_INC    <= '1';
                                MX1_SEL   <= '0';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_while_in;
                              else
                                MX1_SEL   <= '1';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_while_end;
                              end if;
      
      when s_while_end     => if(DATA_RDATA = "00000000") then
                                PC_INC  <= '1';
                                fsm_next_state <= s_fetch;
                              else
                                PC_DEC    <= '1';
                                MX1_SEL   <= '0';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_while_end_check;
                              end if;

      when s_while_end_check => if(DATA_RDATA = "01011011") then
                                  PC_INC    <= '1';
                                  MX1_SEL   <= '1';
                                  DATA_EN   <= '1';
                                  DATA_RDWR <= '0';
                                  fsm_next_state <= s_while_start;
                                else
                                  PC_DEC    <= '1';
                                  MX1_SEL   <= '0';
                                  DATA_EN   <= '1';
                                  DATA_RDWR <= '0';
                                  fsm_next_state <= s_while_end_check;
                                end if;

      when s_do_while_start =>  PC_INC    <= '1';
                                MX1_SEL   <= '0';
                                DATA_EN   <= '1';
                                DATA_RDWR <= '0';
                                fsm_next_state <= s_do_while_in;

      when s_do_while_in    =>  if(DATA_RDATA /= "00101001") then
                                  PC_INC    <= '1';
                                  MX1_SEL   <= '0';
                                  DATA_EN   <= '1';
                                  DATA_RDWR <= '0';
                                  fsm_next_state <= s_do_while_in;
                                else
                                  MX1_SEL   <= '1';
                                  DATA_EN   <= '1';
                                  DATA_RDWR <= '0';
                                  fsm_next_state <= s_do_while_end;
                                end if;

      when s_do_while_end    => if(DATA_RDATA = "00000000") then
                                  PC_INC  <= '1';
                                  fsm_next_state <= s_fetch;
                                else
                                  PC_DEC    <= '1';
                                  MX1_SEL   <= '0';
                                  DATA_EN   <= '1';
                                  DATA_RDWR <= '0';
                                  fsm_next_state <= s_do_while_end_check;
                                end if;

      when s_do_while_end_check =>  if(DATA_RDATA = "00101000") then
                                      PC_INC    <= '1';
                                      MX1_SEL   <= '0';
                                      DATA_EN   <= '1';
                                      DATA_RDWR <= '0';
                                      fsm_next_state <= s_do_while_start;
                                    else
                                      PC_DEC    <= '1';
                                      MX1_SEL   <= '0';
                                      DATA_EN   <= '1';
                                      DATA_RDWR <= '0';
                                      fsm_next_state <= s_fetch;
                                    end if;
      
      when s_null => fsm_next_state <= s_null;
      when others => null;
    end case;
  end process;

end behavioral;

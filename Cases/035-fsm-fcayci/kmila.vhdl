library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation: 3-state FSM with mixed Moore/Mealy outputs.
-- Uses a 2-bit std_logic_vector state register instead of the reference's
-- enumerated type. Transition + output table:
--   S0 + a=0           → stay S0, moore=0, mealy=0
--   S0 + a=1, b=0      → S1,      moore=0, mealy=0
--   S0 + a=1, b=1      → S2,      moore=0, mealy=1   (Mealy)
--   S1 + a=0           → stay S1, moore=1, mealy=0
--   S1 + a=1           → S0,      moore=1, mealy=0
--   S2 (any)           → S0,      moore=0, mealy=0
entity fsm is
    port (
        clk   : in  std_logic;
        a, b  : in  std_logic;
        mealy : out std_logic;
        moore : out std_logic
    );
end fsm;

architecture rtl of fsm is
    signal state : std_logic_vector(1 downto 0) := "00";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            moore <= '0';
            mealy <= '0';
            case state is
                when "00" =>  -- S0
                    if a = '1' then
                        if b = '1' then
                            state <= "10";
                            mealy <= '1';
                        else
                            state <= "01";
                        end if;
                    end if;
                when "01" =>  -- S1
                    moore <= '1';
                    if a = '1' then state <= "00"; end if;
                when "10" =>  -- S2
                    state <= "00";
                when others =>
                    state <= "00";
            end case;
        end if;
    end process;
end rtl;

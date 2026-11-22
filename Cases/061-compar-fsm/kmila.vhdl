library ieee;
use ieee.std_logic_1164.all;

entity compar_fsm is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        ab    : in  std_logic_vector(1 downto 0);
        o     : out std_logic_vector(1 downto 0)
    );
end compar_fsm;

architecture rtl of compar_fsm is
    type state_t is (sEq, sB, sA);
    signal state : state_t := sEq;
begin
    process(clk)
    begin
        if reset = '1' then
            state <= sEq;
            o     <= "00";
        elsif rising_edge(clk) then
            case state is
                when sEq =>
                    if ab = "01" then
                        state <= sB;
                        o     <= "01";
                    elsif ab = "10" then
                        state <= sA;
                        o     <= "10";
                    else
                        state <= sEq;
                        o     <= "00";
                    end if;
                when sB =>
                    if ab = "10" then
                        state <= sA;
                        o     <= "10";
                    else
                        state <= sB;
                        o     <= "01";
                    end if;
                when sA =>
                    if ab = "01" then
                        state <= sB;
                        o     <= "01";
                    else
                        state <= sA;
                        o     <= "10";
                    end if;
            end case;
        end if;
    end process;
end rtl;

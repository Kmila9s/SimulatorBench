library ieee;
use ieee.std_logic_1164.all;

entity stable_gate is
    port (
        clk        : in  std_logic;
        data       : in  std_logic;
        stable_out : out std_logic
    );
end stable_gate;

architecture rtl of stable_gate is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if data'stable(20 ns) then
                stable_out <= '1';
            else
                stable_out <= '0';
            end if;
        end if;
    end process;
end rtl;

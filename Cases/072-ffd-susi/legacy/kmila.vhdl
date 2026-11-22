library ieee;
use ieee.std_logic_1164.all;

entity FFD is
    port (
        d_i   : in  std_logic;
        clk_i : in  std_logic;
        q_o   : out std_logic
    );
end FFD;

architecture rtl of FFD is
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            q_o <= d_i;
        end if;
    end process;
end rtl;

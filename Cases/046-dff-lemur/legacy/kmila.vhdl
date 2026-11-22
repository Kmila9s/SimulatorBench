library ieee;
use ieee.std_logic_1164.all;

entity dff is
    port (
        clk : in  std_logic;
        r   : in  std_logic;
        D   : in  std_logic;
        Q   : out std_logic
    );
end dff;

architecture rtl of dff is
begin
    process(clk, r)
    begin
        if r = '1' then
            Q <= '0';
        elsif rising_edge(clk) then
            Q <= D;
        end if;
    end process;
end rtl;

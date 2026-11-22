library ieee;
use ieee.std_logic_1164.all;

entity sipo is
    port (
        clk : in  std_logic;
        se  : in  std_logic_vector(1 downto 0);
        D   : in  std_logic_vector(3 downto 0);
        Dl  : in  std_logic;
        Dr  : in  std_logic;
        Q   : out std_logic_vector(3 downto 0)
    );
end sipo;

architecture rtl of sipo is
    signal r : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if se(0) = '0' then
                r <= Dl & r(3 downto 1);
            elsif se(1) = '1' then
                r <= r(2 downto 0) & Dr;
            else
                r <= D;
            end if;
        end if;
    end process;

    Q <= r;
end rtl;

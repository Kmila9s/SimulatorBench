library ieee;
use ieee.std_logic_1164.all;

entity piso is
    port (
        clk : in  std_logic;
        se  : in  std_logic_vector(1 downto 0);
        D   : in  std_logic_vector(3 downto 0);
        Din : in  std_logic;
        Q   : out std_logic
    );
end piso;

architecture rtl of piso is
    signal r : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if se(0) = '1' then
                r <= D;
            else
                r <= r(2 downto 0) & Din;
            end if;
        end if;
        Q <= r(3);
    end process;
end rtl;

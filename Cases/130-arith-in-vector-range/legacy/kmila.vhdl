library ieee;
use ieee.std_logic_1164.all;

entity arith_range is
    port (
        clk  : in  std_logic;
        data : out std_logic_vector(8-1 downto 0)
    );
end arith_range;

architecture rtl of arith_range is
    signal latched : std_logic_vector(8-1 downto 0) := "10101010";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            latched <= "11001100";
        end if;
    end process;

    data <= latched;
end rtl;

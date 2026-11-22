library ieee;
use ieee.std_logic_1164.all;

entity dec3x8_sel is
    port (
        input  : in  std_logic_vector(2 downto 0);
        output : out std_logic_vector(7 downto 0)
    );
end dec3x8_sel;

architecture rtl of dec3x8_sel is
begin
    with input select
        output <= transport "00000001" after 50 ns when "000",
                  "00000010" after 50 ns when "001",
                  "00000100" when "010",
                  "00001000" when "011",
                  "00010000" when "100",
                  "00100000" when "101",
                  "01000000" when "110",
                  "10000000" when "111",
                  "00000000" when others;
end rtl;

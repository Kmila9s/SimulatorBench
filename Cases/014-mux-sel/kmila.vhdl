library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_sel is
    port (
        sel : in  std_logic_vector(2 downto 0);
        x   : in  std_logic_vector(7 downto 0);
        y   : out std_logic
    );
end mux8x1_sel;

architecture rtl of mux8x1_sel is
begin
    with sel select
        y <= transport x(0) after 50 ns when "000",
             x(1) after 50 ns when "001",
             x(2)             when "010",
             x(3)             when "011",
             x(4)             when "100",
             x(5)             when "101",
             x(6)             when "110",
             x(7)             when "111",
             'X'              when others;
end rtl;

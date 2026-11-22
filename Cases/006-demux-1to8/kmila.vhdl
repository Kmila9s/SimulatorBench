library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation. Same per-bit `with sel select` style as the
-- reference (with bits 0 and 1 carrying the 20 ns documented delay), but
-- written from the problem spec without copying the reference's text.
entity Demux1x8 is
    port (
        x   : in  std_logic;
        sel : in  std_logic_vector(2 downto 0);
        y   : out std_logic_vector(7 downto 0)
    );
end Demux1x8;

architecture rtl of Demux1x8 is
begin
    with sel select y(0) <= x after 20 ns when "000", '0' when others;
    with sel select y(1) <= x after 20 ns when "001", '0' when others;
    with sel select y(2) <= x              when "010", '0' when others;
    with sel select y(3) <= x              when "011", '0' when others;
    with sel select y(4) <= x              when "100", '0' when others;
    with sel select y(5) <= x              when "101", '0' when others;
    with sel select y(6) <= x              when "110", '0' when others;
    with sel select y(7) <= x              when "111", '0' when others;
end rtl;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub is
    port (
        a    : in  std_logic_vector(7 downto 0);
        kin  : in  std_logic_vector(3 downto 0);
        out8 : out std_logic_vector(7 downto 0)
    );
end sub;

architecture rtl of sub is
    signal k_sig : std_logic_vector(3 downto 0);
    function add_off(x : std_logic_vector(7 downto 0))
        return std_logic_vector is
    begin
        return std_logic_vector(unsigned(x) + unsigned("0000" & k_sig));
    end function;
begin
    k_sig <= kin;
    out8 <= add_off(a);
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity multi_caller_top is
    port (
        a1, a2 : in  std_logic_vector(7 downto 0);
        kin1   : in  std_logic_vector(3 downto 0);
        kin2   : in  std_logic_vector(3 downto 0);
        o1, o2 : out std_logic_vector(7 downto 0)
    );
end multi_caller_top;

architecture rtl of multi_caller_top is
begin
    u1 : entity work.sub(rtl)
        port map (a => a1, kin => kin1, out8 => o1);

    u2 : entity work.sub(rtl)
        port map (a => a2, kin => kin2, out8 => o2);
end rtl;

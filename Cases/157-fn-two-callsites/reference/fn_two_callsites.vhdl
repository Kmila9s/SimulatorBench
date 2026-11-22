library ieee;
use ieee.std_logic_1164.all;

entity fn_two_callsites is
    port (
        a  : in  std_logic;
        b  : in  std_logic;
        y1 : out std_logic;
        y2 : out std_logic
    );
end fn_two_callsites;

architecture rtl of fn_two_callsites is
    function invert(x : std_logic) return std_logic is
    begin
        return not x;
    end invert;
begin
    y1 <= invert(a);
    y2 <= invert(b);
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity fn_case_mux is
    port (
        sel : in  std_logic_vector(1 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end fn_case_mux;

architecture rtl of fn_case_mux is
    function decode(s : std_logic_vector(1 downto 0)) return std_logic_vector is
    begin
        case s is
            when "00"   => return "0001";
            when "01"   => return "0010";
            when "10"   => return "0100";
            when others => return "1000";
        end case;
    end decode;
begin
    y <= decode(sel);
end rtl;

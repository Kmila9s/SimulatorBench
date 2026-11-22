library ieee;
use ieee.std_logic_1164.all;

entity fn_case_arm_local_var is
    port (
        sel : in  std_logic_vector(1 downto 0);
        a   : in  std_logic_vector(3 downto 0);
        b   : in  std_logic_vector(3 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end fn_case_arm_local_var;

architecture rtl of fn_case_arm_local_var is
    function pick(s : std_logic_vector(1 downto 0);
                  x : std_logic_vector(3 downto 0);
                  z : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable tmp : std_logic_vector(3 downto 0);
    begin
        case s is
            when "00" =>
                tmp := x;
                return tmp;
            when "01" =>
                tmp := z;
                return tmp;
            when "10" =>
                tmp := x;
                return tmp;
            when others =>
                tmp := z;
                return tmp;
        end case;
    end pick;
begin
    y <= pick(sel, a, b);
end rtl;

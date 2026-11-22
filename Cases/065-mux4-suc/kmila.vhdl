library ieee;
use ieee.std_logic_1164.all;

entity Mux4 is
    port (
        i_i   : in  std_logic_vector(3 downto 0);
        sel_i : in  std_logic_vector(1 downto 0);
        y_o   : out std_logic
    );
end Mux4;

architecture rtl of Mux4 is
begin
    process(i_i, sel_i)
    begin
        case sel_i is
            when "00"   => y_o <= i_i(0);
            when "01"   => y_o <= i_i(1);
            when "10"   => y_o <= i_i(2);
            when others => y_o <= i_i(3);
        end case;
    end process;
end rtl;

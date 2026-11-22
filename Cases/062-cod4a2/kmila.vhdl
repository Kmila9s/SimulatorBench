library ieee;
use ieee.std_logic_1164.all;

entity Cod4a2 is
    port (
        i_i : in  std_logic_vector(3 downto 0);
        y_o : out std_logic_vector(1 downto 0);
        g_o : out std_logic
    );
end Cod4a2;

architecture rtl of Cod4a2 is
begin
    process(i_i)
    begin
        if    i_i(3) = '1' then y_o <= "11";
        elsif i_i(2) = '1' then y_o <= "10";
        elsif i_i(1) = '1' then y_o <= "01";
        else                    y_o <= "00";
        end if;
    end process;

    g_o <= i_i(3) or i_i(2) or i_i(1) or i_i(0);
end rtl;

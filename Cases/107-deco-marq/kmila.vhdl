library ieee;
use ieee.std_logic_1164.all;

entity Exercici_4 is
    port (
        sel     : in  std_logic_vector(1 downto 0);
        out_dec : out std_logic_vector(3 downto 0)
    );
end Exercici_4;

architecture rtl of Exercici_4 is
begin
    process(sel)
    begin
        case sel is
            when "00"   => out_dec <= "0001";
            when "01"   => out_dec <= "0010";
            when "10"   => out_dec <= "0100";
            when "11"   => out_dec <= "1000";
            when others => out_dec <= "0000";
        end case;
    end process;
end rtl;

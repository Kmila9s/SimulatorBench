library ieee;
use ieee.std_logic_1164.all;

entity DecoN is
    port (
        a_i   : in  std_logic_vector(1 downto 0);
        ena_i : in  std_logic;
        y_o   : out std_logic_vector(3 downto 0)
    );
end DecoN;

architecture rtl of DecoN is
    signal y : std_logic_vector(3 downto 0);
begin
    process(a_i)
    begin
        case a_i is
            when "00"   => y <= "0001";
            when "01"   => y <= "0010";
            when "10"   => y <= "0100";
            when "11"   => y <= "1000";
            when others => y <= "0000";
        end case;
    end process;

    y_o <= y when ena_i = '1' else "0000";
end rtl;

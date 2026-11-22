library ieee;
use ieee.std_logic_1164.all;

entity Deco3a8 is
    port (
        a_i   : in  std_logic_vector(2 downto 0);
        ena_i : in  std_logic;
        y_o   : out std_logic_vector(7 downto 0)
    );
end Deco3a8;

architecture rtl of Deco3a8 is
    signal y : std_logic_vector(7 downto 0);
begin
    process(a_i)
    begin
        case a_i is
            when "000"  => y <= "00000001";
            when "001"  => y <= "00000010";
            when "010"  => y <= "00000100";
            when "011"  => y <= "00001000";
            when "100"  => y <= "00010000";
            when "101"  => y <= "00100000";
            when "110"  => y <= "01000000";
            when "111"  => y <= "10000000";
            when others => y <= "00000000";
        end case;
    end process;

    y_o <= y when ena_i = '1' else "00000000";
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity Seven_Segment is
    port (
        inDigit   : in  std_logic_vector(3 downto 0);
        inSelect  : in  std_logic_vector(3 downto 0);
        outSelect : out std_logic_vector(3 downto 0);
        out7Seg   : out std_logic_vector(7 downto 0)
    );
end Seven_Segment;

architecture rtl of Seven_Segment is
begin
    outSelect <= inSelect;

    process(inDigit)
    begin
        case inDigit is
            when "0000" => out7Seg <= "11000000";
            when "0001" => out7Seg <= "11111001";
            when "0010" => out7Seg <= "10100100";
            when "0011" => out7Seg <= "10110000";
            when "0100" => out7Seg <= "10011001";
            when "0101" => out7Seg <= "10010010";
            when "0110" => out7Seg <= "10000010";
            when "0111" => out7Seg <= "11111000";
            when "1000" => out7Seg <= "10000000";
            when "1001" => out7Seg <= "10010000";
            when "1010" => out7Seg <= "10001000";
            when "1011" => out7Seg <= "10000011";
            when "1100" => out7Seg <= "11000110";
            when "1101" => out7Seg <= "10100001";
            when "1110" => out7Seg <= "10000110";
            when "1111" => out7Seg <= "10001110";
            when others => out7Seg <= "11111111";
        end case;
    end process;
end rtl;

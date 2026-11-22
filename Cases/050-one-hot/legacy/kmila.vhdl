library ieee;
use ieee.std_logic_1164.all;

entity one_hot is
    port (
        si : in  std_logic_vector(6 downto 0);
        so : out std_logic_vector(2 downto 0)
    );
end one_hot;

architecture rtl of one_hot is
begin
    process(si)
    begin
        case si is
            when "0000001" => so <= "001";
            when "0000010" => so <= "010";
            when "0000100" => so <= "011";
            when "0001000" => so <= "100";
            when "0010000" => so <= "101";
            when "0100000" => so <= "110";
            when "1000000" => so <= "111";
            when others    => so <= "000";
        end case;
    end process;
end rtl;

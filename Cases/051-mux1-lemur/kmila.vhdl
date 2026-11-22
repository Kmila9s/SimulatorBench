library ieee;
use ieee.std_logic_1164.all;

entity multiplex_1 is
    port (
        smi : in  std_logic_vector(6 downto 0);
        smo : out std_logic;
        se  : in  std_logic_vector(2 downto 0)
    );
end multiplex_1;

architecture rtl of multiplex_1 is
begin
    process(smi, se)
    begin
        case se is
            when "000"  => smo <= smi(0);
            when "001"  => smo <= smi(1);
            when "010"  => smo <= smi(2);
            when "011"  => smo <= smi(3);
            when "100"  => smo <= smi(4);
            when "101"  => smo <= smi(5);
            when "110"  => smo <= smi(6);
            when others => smo <= '0';
        end case;
    end process;
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_conditional is
    port (
        sel : in  std_logic_vector(2 downto 0);
        x   : in  std_logic_vector(7 downto 0);
        y   : out std_logic
    );
end mux8x1_conditional;

architecture rtl of mux8x1_conditional is
begin
    process(sel, x)
    begin
        case sel is
            when "000" => y <= x(0);
            when "001" => y <= x(1);
            when "010" => y <= x(2);
            when "011" => y <= x(3);
            when "100" => y <= x(4);
            when "101" => y <= x(5);
            when "110" => y <= x(6);
            when "111" => y <= x(7);
            when others => y <= '0';
        end case;
    end process;
end rtl;
